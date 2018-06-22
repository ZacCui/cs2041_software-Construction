#!/web/cs2041/bin/python3.6.3

# written by andrewt@cse.unsw.edu.au October 2017
# as a starting point for COMP[29]041 assignment 2
# https://cgi.cse.unsw.edu.au/~cs2041/assignments/UNSWtalk/


import os, re
from flask import Flask, render_template, session, request
from datetime import datetime
from collections import OrderedDict


students_dir = "static/dataset-medium";

app = Flask(__name__)

# Show unformatted details for student "n"
# Increment n and store it in the session cookie

        
@app.route('/', methods=['GET','POST'])

@app.route('/login', methods=['GET'])
def go_login():
    return render_template('login.html')

@app.route('/post', methods=['GET'])
def go_post():
    if 'zid' in session:
        login =  session['zid']
    else:
        return go_login()
    return render_template('post.html', login = login)

@app.route('/post', methods=['POST'])
def post():
    if 'zid' not in session:
        return render_template('login.html')
    zid = session['zid']
    num = int(getPostNum(zid,0)) +1
    time = datetime.now().strftime('time: %Y-%m-%dT%H:%M:%S+0000')
    message = "message: "+ str(request.form.get('post', ''))
    who = "from: "+zid
    file = os.path.join(students_dir, zid, str(num)+".txt")
    fh = open(file, "a") 
    fh.write(time+"\n") 
    fh.write(message+"\n") 
    fh.write(who) 
    fh.close()
    return profile(zid)

@app.route('/comment', methods=['POST'])
def comment():
    if 'zid' in session:
        zid =  session['zid']
    else:
        return go_login()
    x = request.form.get('x', '')
    student_to_show = request.form.get('zid', '')
    num = getPostNum(zid,x)
    if re.search('-',num):
        y = int(re.sub('\d+-','',num))+1
    else:
        y = 0
    x += "-"+str(y)
    time = datetime.now().strftime('time: %Y-%m-%dT%H:%M:%S+0000')
    message = "message: "+ str(request.form.get('comment', ''))
    who = "from: "+zid
    file = os.path.join(students_dir, student_to_show, str(x)+".txt")
    fh = open(file, "w") 
    time += "\n"
    message += "\n"
    fh.write(time+message+who) 
    fh.close()
    return profile(student_to_show)

@app.route('/reply', methods=['POST'])
def reply():
    if 'zid' in session:
        zid =  session['zid']
    else:
        return go_login()
    x = request.form.get('x', '')
    y = request.form.get('y', '')
    student_to_show = request.form.get('zid', '')
    y = x +"-"+ y
    num = getPostNum(zid,y)
    if re.match('\d+-\d+-\d+',num):
        z = int(re.sub('\d+-','',num))+1
    else:
        z = 0
    y += "-"+str(z)
    time = datetime.now().strftime('time: %Y-%m-%dT%H:%M:%S+0000')
    message = "message: "+ str(request.form.get('reply', ''))
    who = "from: "+zid
    file = os.path.join(students_dir, student_to_show, str(y)+".txt")
    fh = open(file, "w") 
    time += "\n"
    message += "\n"
    fh.write(time+message+who) 
    fh.close()
    return profile(student_to_show)


@app.route('/profile/<zid>', methods=['GET','POST'])
def profile(zid=None):
    login = None
    if 'zid' in session:
        login =  session['zid']
    n = session.get('n', 0)
    session['n'] = n + 1
    students = sorted(os.listdir(students_dir))
    student_to_show = students[n % len(students)]
    if zid and re.match('z\d{7}',zid):
        student_to_show = zid
    image_filename = os.path.join(students_dir, student_to_show, "img.jpg")
    image_filename = re.sub('static/','',image_filename);
    comment = getPosts(student_to_show)
    detail = getDetails(student_to_show)
    friend_list = getFriends(student_to_show)
    friends_info = getInfo(friend_list)
    return render_template('profile.html', student_details=detail , image_filename=image_filename
                                        , friend_list=friends_info, comment=comment, login=login
                                        , student_to_show = student_to_show)

@app.route('/search', methods=['GET','POST'])
def search():
    zids = []
    result = {}
    message = str()
    login = None
    if 'zid' in session:
        login = session['zid']
    else:
        return go_login()
    content = request.args.get('search', '')
    sortBy = request.args.get('category', '')
    if content == ' ' or content == '':
        return render_template('search.html', result=result, message="No results!", login=login)
    students = sorted(os.listdir(students_dir))
    if sortBy =='any' or sortBy == "name":
        for zid in students:
            student_file = os.path.join(students_dir, zid, "student.txt")
            with open(student_file) as f:
                details = f.read()
            for line in details.split('\n'):
                if re.match('full_name',line) and re.search(content,line[11:],re.IGNORECASE):
                    zids.append(zid)
        if len(zids):
            result = getInfo(', '.join(zids))
        else:
            message = "No results!"
    else:
        for zid in students:
            comments = sorted(os.listdir(students_dir+'/'+zid))
            if "student.txt" in comments:
                comments.remove("student.txt")
            if "img.jpg" in comments:
                comments.remove("img.jpg")
            for file in sorted(comments, key=lambda a: eval(re.sub(r'(\d+)-?(\d+)?-?(\d+)?.txt',r'\1*10000+1\2*10+1\3',a)),reverse=True):
                if(re.search('^\d+.txt',file)):
                    msg, info = getContent(zid,file,content)
                    if msg:
                        result[zid] = {'msg':msg,'info':info}
        if not result:
            message = "No results!"
    return render_template('search.html', result=result,message=message,login=login)

@app.route('/login', methods=['POST'])
def login():
    zid = request.form.get('zid', '')
    password = request.form.get('password', '')
    zid = re.sub(r'\s', '', zid)
    if not zid or not re.match('z\d{7}',zid):
        return render_template('login.html', error="Unknown zid")
    info = getInfo(zid)
    if zid not in info:
        return render_template('login.html', error="Unknown zid")
    elif password != info[zid]['pwd']:
        return render_template('login.html', error="Wrong password")
    session['zid'] = zid
    return profile(zid)

@app.route('/logout', methods=['GET','POST'])
def logout():
    session['zid'] = None
    return render_template('login.html')

def getInfo(zids):
    friend_list = {};
    if type(zids) is str :
        mylist = zids.split(', ')
    else:
        mylist = zids
    for zid in mylist:
        name = str()
        password = str()
        friend_details = os.path.join(students_dir, zid, "student.txt")
        friend_img = os.path.join(students_dir, zid, "img.jpg")
        friend_img = re.sub('static/','',friend_img);
        with open(friend_details) as f:
            details = f.read()
        for line in details.split('\n'):
            if(re.match('full_name',line)):
                name = line[11:]
            if(re.match('password',line)):
                password = re.sub('password: ','',line)   
        friend_list[zid] = {'name': name, 'img' : friend_img, 'pwd' : password,'zid':zid}
    return friend_list

def getPostNum(zid,option):
    num = str()
    comments = sorted(os.listdir(students_dir+'/'+zid))
    if "student.txt" in comments:
        comments.remove("student.txt")
    if "img.jpg" in comments:
        comments.remove("img.jpg")
    if option == 0:
        patten = '^\d+.txt'
    else:
        patten = '^' + option
        patten += '-?\d+?.txt'
    for file in sorted(comments, key=lambda a: eval(re.sub(r'(\d+)-?(\d+)?-?(\d+)?.txt',r'\1*1000000+1\2*100+1\3',a)),reverse=True):
        if(re.match(patten,file)):
            num = re.sub('.txt','',file)
            break
    return num

def getPosts(zid):
    comments = sorted(os.listdir(students_dir+'/'+zid))
    if "student.txt" in comments:
        comments.remove("student.txt")
    if "img.jpg" in comments:
        comments.remove("img.jpg")
    comment = OrderedDict()
    msg = str()
    for file in sorted(comments, key=lambda a: eval(re.sub(r'(\d+)-?(\d+)?-?(\d+)?.txt',r'\1*1000000+1\2*100+1\3',a))):
        msg,info = getContent(zid,file,None)
        if not msg:
            continue
        x = re.sub('.txt','',file)
        x = int(re.sub('-.*','',x))
        if x not in comment:
            comment[x] = {'post': str(),'info':{},'comment': [],'x':x}
        if not re.search('-',file):
            comment[x]['post'] = msg
            comment[x]['info'] = info
        if re.match('\d+-\d+\.',file):
            m = re.match("\d+-(\d+).txt",file)
            dic = OrderedDict({'msg':msg ,'info':info ,'reply':[], 'y':m.group(1)})
            comment[x]['comment'].append(dic)

        if re.search('\d+-\d+-\d+',file):
            dic = {'msg':msg ,'info':info}
            comment[x]['comment'][-1]['reply'].append(dic)
    comment = OrderedDict(sorted(comment.items(),reverse=True))
    return comment
    
def getContent(zid,file,content):
    msg = str()
    message_file = os.path.join(students_dir, zid, file)
    with open(message_file) as f:
        message = f.read()
    #if not re.search("from: "+zid ,message):
     #   return ''
    for line in sorted(message.split('\n'),reverse = True):
        if content and re.match('message',line):
            if not re.search(content,line[9:],re.IGNORECASE):
                return "",{}
        if(re.match('longitude|latitude',line)):
            continue 
        if(re.match('from',line)):
            idn = re.sub('from: ','',line)
            info = getInfo(idn)
            continue
        line = re.sub(r'\\n','\n',line)
        msg += line+'\n'
    msg = re.sub('\n$','',msg);
    return msg,info

def getDetails(zid):
    details_filename = os.path.join(students_dir, zid, "student.txt")
    with open(details_filename) as f:
        details = f.read()
    detail = str()
    for line in sorted(details.split('\n'),reverse=True):
        if(re.match('friend|password|email|home_longitude|home_latitude|courses',line)):
            continue 
        detail += str(line)+"\n" 
    return detail

def getFriends(zid):
    details_filename = os.path.join(students_dir, zid, "student.txt")
    with open(details_filename) as f:
        details = f.read()
    friend_list = str()
    for line in sorted(details.split('\n'),reverse=True):
        if(re.match('friend',line)):
            line = re.sub('.*\(','',line)
            friend_list = re.sub('\)','',line)
            break
    return friend_list

    
if __name__ == '__main__':
    app.secret_key = os.urandom(12)
    app.run(debug=True)
