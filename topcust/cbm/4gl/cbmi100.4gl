# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cbmi100.4gl
# Descriptions...: JAVA import测试程序
# Date & Author..: 22/06/09 By darcy

IMPORT os
IMPORT JAVA com.darcy.Hello

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_argv1,g_argv2,g_argv3 STRING
DEFINE   g_n,g_i      INT
DEFINE darcy  record
      object Hello
end record 
define ouput string

type person record
    name string,
    age string
end record

define ob person
define l_ima01,l_ima01_desc varchar(40)
define res int, msg string

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CBM")) THEN
       EXIT PROGRAM
    END IF
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    let l_ima01='AA0001A2-1'

    let darcy.object =  com.darcy.Hello.newHello("我是",123)
    let ob.age = darcy.object.toString()

    let ob.name = com.darcy.Hello.getHello()

    CALL ui.Interface.frontCall("erpdemo", "mysum", [100,250], [res,msg])


    sql
    select SYSDATE into l_ima01 from dual
    end sql
    CALL cws_json()
 

END MAIN


FUNCTION cl_exist_file(p_path,msgshow)   #检查文件/文件夹路径是否存在
DEFINE p_path       STRING       #文件路径 
DEFINE msgshow      BOOLEAN      #是否显示报错信息
DEFINE l_err        INT          #返回 0 成功 1 失败
         
        LET l_err = 0
        IF cl_null(p_path) THEN
           CALL cl_file_msg(cl_getmsg('文件路径不允许为空',g_lang))
           RETURN l_err
        END IF
        LET p_path = cl_replace_str(p_path,'\\','/')
                 
        CALL cl_get_DllVersion('A','A')
                 
                 
        TRY
          CALL ui.Interface.frontCall('FileCom','FileExists',[p_path],[l_err])
        CATCH  
          CALL cl_err3("filecom","exist","","",STATUS,"","",1)
        END TRY  
          
        IF NOT l_err AND msgshow==TRUE THEN
         
           CALL cl_file_msg(p_path||cl_getmsg('执行失败',g_lang))
         
        END IF
                 
        RETURN l_err
                 
END FUNCTION
         
FUNCTION cl_add_dir(p_path,msgshow)  #创建文件夹
#参数1.............: 文件路径目录
DEFINE  p_path      STRING
DEFINE  msgshow     BOOLEAN      #是否显示报错信息
DEFINE  l_err       INT
         
         
        LET l_err = 0
        IF cl_null(p_path)  THEN
           CALL cl_file_msg(cl_getmsg('文件路径不允许为空',g_lang))
           RETURN l_err
        END IF
        LET p_path = cl_replace_str(p_path,'\\','/')
                 
        CALL cl_get_DllVersion('A','A')
                 
        TRY
          CALL ui.Interface.frontCall('FileCom','FileCreateDir',[p_path],[l_err])
        CATCH  
          CALL cl_err3("filecom","exist","","",STATUS,"","",1)
        END TRY  
         
        IF NOT l_err AND msgshow==TRUE THEN
         
           CALL cl_file_msg(p_path||cl_getmsg('创建文件夹失败',g_lang))
                    
        END IF
                 
        RETURN l_err
                 
END FUNCTION
         
FUNCTION cl_del_dir(p_path,msgshow)  #删除文件夹
#参数1.............: 文件路径目录
DEFINE  p_path      STRING
DEFINE  msgshow     BOOLEAN      #是否显示报错信息
DEFINE  l_err       INT
           
         
        LET l_err = 0
        IF cl_null(p_path)  THEN
           CALL cl_file_msg(cl_getmsg('文件路径不允许为空',g_lang))
           RETURN l_err
        END IF
        LET p_path = cl_replace_str(p_path,'\\','/')
        IF NOT cl_exist_file(p_path,msgshow) THEN
           RETURN l_err
        END IF  
         
        TRY
           CALL ui.Interface.frontCall('FileCom','FileRemoveDirectory',[p_path],[l_err])
        CATCH
           CALL cl_err3("filecom","exist","","",STATUS,"","",1)
        END TRY  
         
        IF NOT l_err AND msgshow==TRUE THEN
         
           CALL cl_file_msg(p_path||cl_getmsg('删除文件夹失败',g_lang))
         
        END IF
                 
        RETURN l_err
                 
END FUNCTION
         
         
FUNCTION cl_del_file(p_path,msgshow)  #删除文件
#参数1.............: 文件路径目录
DEFINE  p_path      STRING
DEFINE  msgshow     BOOLEAN      #是否显示报错信息
DEFINE  l_err       INT
         
         
        LET l_err = 0
        IF cl_null(p_path)  THEN
           CALL cl_file_msg(cl_getmsg('文件路径不允许为空',g_lang))
           RETURN l_err
        END IF
        LET p_path = cl_replace_str(p_path,'\\','/')
        IF NOT cl_exist_file(p_path,msgshow) THEN
           RETURN l_err
        END IF  
         
        TRY
           CALL ui.Interface.frontCall('FileCom','FileDelete',[p_path],[l_err])
        CATCH
           CALL cl_err3("filecom","exist","","",STATUS,"","",1)
        END TRY  
         
        IF NOT l_err AND msgshow==TRUE THEN
         
           CALL cl_file_msg(p_path||cl_getmsg('删除文件失败',g_lang))
         
        END IF
                 
        RETURN l_err
                 
END FUNCTION
         
FUNCTION cl_copy_file(p_pathin,p_pathout,p_state,msgshow)  #复制文件或文件夹
#p_pathin("C:/tiptop" OR "C:/tiptop/test.txt")
#p_pathout("C:/tiptop" OR "C:/tiptop/test.txt")
#NO.1....:cl_copy_file("C:/tiptop","D:/tiptop",FALSE,TRUE)
#NO.2....:cl_copy_file("C:/tiptop/test.txt","D:/tiptop/test.txt",FALSE,TRUE)
DEFINE  p_pathin    STRING     #原路径文件
DEFINE  p_pathout   STRING     #被复制文件路径
DEFINE  p_state     INT        #是否强制覆盖 :TRUE 不强制覆盖(目标文件存在则报错) FALSE 强制覆盖
DEFINE  msgshow     BOOLEAN    #是否显示报错信息
DEFINE  l_err       INT
            
         
        LET l_err = 0
        IF cl_null(p_pathin) OR cl_null(p_pathout) OR cl_null(p_state) THEN
           CALL cl_file_msg(cl_getmsg('文件路径不允许为空',g_lang))
           RETURN l_err
        END IF
        LET p_pathin = cl_replace_str(p_pathin,'\\','/')
        LET p_pathout = cl_replace_str(p_pathout,'\\','/')
                 
        IF NOT cl_exist_file(p_pathin,msgshow) THEN
           RETURN l_err
        END IF 
                 
        LET p_pathout = p_pathout,"/",cl_get_basename(p_pathin)     #拼接为绝对路径
                 
        TRY
           CALL ui.Interface.frontCall('FileCom','FileCopy',[p_pathin,p_pathout,p_state],[l_err])
        CATCH
           CALL cl_err3("filecom","exist","","",STATUS,"","",1)
        END TRY  
         
        IF NOT l_err AND msgshow==TRUE THEN
         
           CALL cl_file_msg('From '||p_pathin||' To '||p_pathout||cl_getmsg('复制文件失败',g_lang))
         
        END IF
                 
        RETURN l_err
                 
END FUNCTION
         
FUNCTION cl_move_file(p_pathin,p_pathout,msgshow)  #移动文件或文件夹
#p_pathin("C:/tiptop" OR "C:/tiptop/test.txt")
#p_pathout("C:/tiptop" OR "C:/tiptop/test.txt")
#NO.1....:cl_move_file("C:/tiptop","D:/tiptop",TRUE)
#NO.2....:cl_move_file("C:/tiptop/test.txt","D:/tiptop/test.txt",TRUE)
#参数1.........: 文件路径目录     注：移动文件夹时 只能移动空文件夹 若复制路径有文件不能移动
DEFINE  p_pathin    STRING     #原路径文件
DEFINE  p_pathout   STRING     #被复制文件路径
DEFINE  msgshow     BOOLEAN    #是否显示报错信息 
DEFINE  l_err       INT
         
         
        LET l_err = 0
        IF cl_null(p_pathin) OR cl_null(p_pathout)  THEN
           CALL cl_file_msg(cl_getmsg('文件路径不允许为空',g_lang))
           RETURN l_err
        END IF
        LET p_pathin = cl_replace_str(p_pathin,'\\','/')
        LET p_pathout = cl_replace_str(p_pathout,'\\','/')
                 
        IF NOT cl_exist_file(p_pathin,msgshow) THEN
           RETURN l_err
        END IF  
         
        LET p_pathout = p_pathout,"/",cl_get_basename(p_pathin)     #拼接为绝对路径
                 
                 
        TRY
           CALL ui.Interface.frontCall('FileCom','FileMove',[p_pathin,p_pathout],[l_err])
        CATCH
           CALL cl_err3("filecom","exist","","",STATUS,"","",1)
        END TRY
                 
        IF NOT l_err AND msgshow==TRUE THEN
         
           CALL cl_file_msg('From '||p_pathin||' To '||p_pathout||cl_getmsg('移动文件失败',g_lang))
         
        END IF
                 
        RETURN l_err
                 
END FUNCTION
         
FUNCTION cl_get_desktop()   #取桌面路径
DEFINE  l_path STRING
         
        CALL cl_get_DllVersion('A','A')
        TRY
           CALL ui.Interface.frontCall('FileCom','GetDesktop',["xx"],[l_path])
        CATCH 
           CALL cl_err3("filecom","exist","","",STATUS,"","",1)
        END TRY
         
        RETURN l_path
                 
END FUNCTION
         
         
FUNCTION cl_shell_run(p_path,p_status,msgshow)   #执行程序
DEFINE p_path       STRING       #文件路径 
DEFINE p_status     INT          #状态(输入数字)
#################################################################
#SW_HIDE            = 0; {隐藏}
#SW_SHOWNORMAL      = 1; {用最近的大小和位置显示, 激活}
#SW_NORMAL          = 1; {同 SW_SHOWNORMAL}
#SW_SHOWMINIMIZED   = 2; {最小化, 激活}
#SW_SHOWMAXIMIZED   = 3; {最大化, 激活}
#SW_MAXIMIZE        = 3; {同 SW_SHOWMAXIMIZED}
#SW_SHOWNOACTIVATE  = 4; {用最近的大小和位置显示, 不激活}
#SW_SHOW            = 5; {同 SW_SHOWNORMAL}
#SW_MINIMIZE        = 6; {最小化, 不激活}
#SW_SHOWMINNOACTIVE = 7; {同 SW_MINIMIZE}
#SW_SHOWNA          = 8; {同 SW_SHOWNOACTIVATE}
#SW_RESTORE         = 9; {同 SW_SHOWNORMAL}
#SW_SHOWDEFAULT     = 10; {同 SW_SHOWNORMAL}
#SW_MAX             = 10; {同 SW_SHOWNORMAL}
################################################################
DEFINE msgshow      BOOLEAN      #是否显示报错信息
DEFINE l_err        INT          #返回 0 成功 1 失败
         
        LET l_err = 0
        IF cl_null(p_path) THEN
           CALL cl_file_msg(cl_getmsg('文件路径不允许为空',g_lang))
           RETURN l_err
        END IF
        #LET p_path = cl_replace_str(p_path,'\\','/')
                 
        CALL cl_get_DllVersion('A','A')
                 
                 
        TRY
          CALL ui.Interface.frontCall('FileCom','ShellRun',['open',p_path,NULL,NULL,p_status],[l_err])
          #参数1: PChar; {指定动作, 譬如: open、runas、print、edit、explore、find }
          #参数2: PChar; {指定要打开的文件或程序}
          #参数3: PChar; {给要打开的程序指定参数; 如果打开的是文件这里应该是 nil}
          #参数4: PChar; {缺省目录}
          #参数5: Integer {打开选项}
        CATCH  
          CALL cl_err3("filecom","exist","","",STATUS,"","",1)
        END TRY  
          
        IF NOT l_err AND msgshow==TRUE THEN
         
           CALL cl_file_msg(p_path||cl_getmsg('执行文件失败',g_lang))
         
        END IF
                 
        RETURN l_err
                 
END FUNCTION
         
         
FUNCTION cl_DriveMap_Add(lpRemoteName,lpUsername,lpPassword)   #建立网络资源链接
DEFINE lpRemoteName STRING   #网络路径ip或主机名
DEFINE lpUsername   STRING   #用户
DEFINE lpPassword   STRING   #密码
DEFINE l_err        INT
           
       CALL cl_get_DllVersion('A','A')
       TRY
          CALL ui.Interface.frontCall('FileCom','WNetAddConnect',[lpRemoteName,lpUsername,lpPassword],[l_err])
       CATCH 
                    
       END TRY
         
END FUNCTION
         
FUNCTION cl_DriveMap_Move(lpRemoteName)   #移除网络资源链接
DEFINE lpRemoteName STRING  #网络路径ip或主机名
DEFINE l_err        INT
         
       CALL cl_get_DllVersion('A','A')
       TRY
          CALL ui.Interface.frontCall('FileCom','WNetCancelConnect',[lpRemoteName],[l_err])
       CATCH 
                    
       END TRY
                 
END FUNCTION
         
FUNCTION cl_get_DllVersion(p_state,p_state1) #判断是否执行成功
DEFINE l_version   STRING
DEFINE l_flag      LIKE type_file.chr1
DEFINE p_state     LIKE type_file.chr1
DEFINE p_state1    LIKE type_file.chr1
         
    LET l_flag = 'Y'
             
    IF g_n > 10 THEN RETURN END IF    #防止死循环
             
    LET g_n = g_n + 1
         
    TRY
       CALL ui.Interface.frontCall('FileCom','GetDllVersion',[""],[l_version])
    CATCH
       CALL cl_load_FileCom(p_state1)
       LET l_flag = 'N'
    END TRY
               
    IF l_flag = 'N' THEN
       IF p_state <> p_state1 THEN
          CALL cl_get_DllVersion(p_state1,'B')
       ELSE
          CALL cl_get_DllVersion(p_state,'B')
       END IF
    END IF  
            
    IF l_version != "1.1.5"  AND l_flag <> 'N' THEN
       CALL cl_load_FileCom(p_state)
       CALL cl_get_DllVersion(p_state,p_state)
    END IF
END FUNCTION
         
         
FUNCTION cl_load_FileCom(p_state)
DEFINE p_state   STRING   #A:取32位dll      B:取64位dll
DEFINE s_path    STRING
DEFINE l_path    STRING
DEFINE l_err     INT
         
         
         
    CALL ui.Interface.frontCall('standard','mdclose',['FileCom'],[l_err])
    IF p_state.equals('A') THEN
       LET s_path = '/u1/genero/fgl/doc/dll/32/FileCom.dll'
    ELSE
       LET s_path = '/u1/genero/fgl/doc/dll/64/FileCom.dll'
    END IF   
    CALL ui.Interface.frontCall('standard','feinfo',['fepath'],[l_path])
    LET l_path = l_path||'/FileCom.dll'
    CALL cl_download_file(s_path, l_path) RETURNING l_err
             
END FUNCTION
         
         
FUNCTION cl_get_basename(p_path) #获取最后子目录或文件名称
#NO.1 cl_get_basename("C:/tiptop")          返回 tiptop
#NO.2 cl_get_basename("C:/tiptop/test.txt") 返回 test.txt
DEFINE  p_path STRING   #路径
         
        RETURN os.Path.basename(p_path)
                 
END FUNCTION
         
         
FUNCTION cl_file_msg(p_msg)
DEFINE p_msg  STRING
         
       MENU 'ERROR' ATTRIBUTES(STYLE="dialog", COMMENT=p_msg.trim() CLIPPED, IMAGE="stop")
         
           ON ACTION ACCEPT
              EXIT MENU
                       
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE MENU
                       
       END MENU
         
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
               
END FUNCTION
