# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aooi901_fp.4gl
# Descriptions...: 維護連線字串子程式
# Date & Author..: 08/12/11 By alex
# Modify.........: No.FUN-910114 08/12/11 By alex 新增此func
# Modify.........: No.TQC-920013 09/02/06 By alex 調整抓取dbconnect.ini機制
# Modify.........: No.FUN-930071 09/03/12 By kevin 使用 schema::username::password
# Modify.........: No.FUN-960077 09/06/10 By kevin 當帳號與資料庫不一致時,提醒使用者注意
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-BC0080 11/12/08 by jrg542 調整dbconnect.ini至DS4GL 
# Modify.........: No:MOD-C30897 12/03/29 by yuge77 調整dbconnect.ini至$FGLDIR/etc,並更名為dbconnect.prod/test/std

 
IMPORT os
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE ls_fglprofile  STRING    #FUN-910114
DEFINE ls_cbakpath    STRING
DEFINE ls_user        STRING    
DEFINE ls_passwd1     STRING
DEFINE ls_passwd2     STRING
DEFINE lc_encode      LIKE type_file.chr1
DEFINE lc_azp03       LIKE azp_file.azp03
DEFINE la_dbc         DYNAMIC ARRAY OF RECORD 
          azp03       STRING,
          username    STRING,
          encodepass  STRING
                      END RECORD
 
FUNCTION i901_connect_str(lc_azp03g)
 
   DEFINE ls_temp      STRING
   DEFINE li_cnt       LIKE type_file.num5
   DEFINE lc_azp03g    LIKE azp_file.azp03
   DEFINE lc_channel   base.Channel
   DEFINE ls_encodepass STRING
 
   LET lc_azp03 = lc_azp03g CLIPPED
 
   IF NOT i901_auth_dba() THEN CALL cl_err(g_user,"-389",1) RETURN END IF
 
   #現行無門店架構下,azp03+azp04 為 unique pk,因此檢查若azp03>1筆，通知使用者
   #全部會整合為一筆 (因為 follow FGLPROFILE dbi.database.XX 不會重覆
 
   SELECT count(*) INTO li_cnt FROM azp_file
    WHERE azp03 = lc_azp03 AND azp04 IS NULL 
   IF li_cnt > 1 THEN
      CALL cl_err_msg(NULL,"azz-884", li_cnt USING "<<"||" || "||lc_azp03 CLIPPED,10)
   END IF
 
   LET ls_passwd1 = ""
   LET ls_passwd2 = ""
 
   LET lc_encode = "Y"   #當進入此FUNCTION時必定azz06="Y"且有FGLPROFILE設定
   LET ls_fglprofile = FGL_GETENV("FGLPROFILE")
   #LET ls_cbakpath = os.Path.join(FGL_GETENV("TOP"),"bin")   #No:MOD-BC0080 
   #LET ls_cbakpath = os.Path.join(FGL_GETENV("DS4GL"),"bin")  #No:MOD-BC0080
   #LET ls_cbakpath = os.Path.join(os.Path.dirname(FGL_GETENV("FGLPROFILE")),"dbconnect.ini") #MOD-BC0080 #MOD-C30897 mark
   LET ls_cbakpath = FGL_GETENV("CALLBACKFILE") # MOD-C30897
   LET ls_cbakpath = ls_cbakpath.trim()         # MOD-C30897
 
   LET lc_channel = base.Channel.create()
 
   #抓取 db user id
   #1.從 dbconnect.ini file 抓
   IF os.Path.exists(ls_cbakpath) THEN  #TQC-920013
 
      #假設存在,先檢查是否有寫入權限
      IF NOT os.Path.writable(ls_cbakpath) THEN
         CALL cl_err("","azz-881",1)
         RETURN
      END IF
 
      CALL lc_channel.openFile(ls_cbakpath.trim(), "r")
      CALL lc_channel.setDelimiter("")
      IF os.Path.size(ls_cbakpath) > 0 THEN  #TQC-920013
         WHILE TRUE
            LET ls_temp = lc_channel.readLine()
            IF lc_channel.isEof() THEN EXIT WHILE END IF
            IF ls_temp.getIndexOf("::",1) THEN
               LET ls_user = ls_temp.subString(1,ls_temp.getIndexOf("::",1)-1)
               LET ls_encodepass = ls_temp.subString(ls_temp.getIndexOf("::",1)+2,ls_temp.getLength())
            ELSE
               LET ls_user = ls_temp.trim()
               LET ls_encodepass = ""
            END IF
            IF ls_user.equals(lc_azp03 CLIPPED) THEN
               IF ls_temp.getIndexOf("::",1) THEN
                  LET ls_user = ls_encodepass.subString(1,ls_encodepass.getIndexOf("::",1)-1)
                  LET ls_encodepass = ls_encodepass.subString(ls_encodepass.getIndexOf("::",1)+2,ls_encodepass.getLength())
               ELSE
                  LET ls_user = ls_encodepass.trim()
                  LET ls_encodepass = ""
               END IF
               EXIT WHILE
            ELSE
               LET ls_user = ""
               LET ls_encodepass = ""
            END IF    
         END WHILE
      END IF
      CALL lc_channel.close()
   END IF
 
   #2.沒有就從 FGLPROFILE 抓
   IF ls_user.trim() IS NULL THEN
      LET ls_user       = fgl_getResource("dbi.database."||lc_azp03 CLIPPED||".username")
      LET ls_encodepass = fgl_getResource("dbi.database."||lc_azp03 CLIPPED||".password")
   END IF
 
   #3.再沒有以 azp03 做 default
   IF ls_user.trim() IS NULL THEN
      LET ls_user = lc_azp03 CLIPPED
   END IF
 
   OPEN WINDOW i901_fp_w WITH FORM "aoo/42f/aooi901_fp"
      ATTRIBUTES (STYLE="dialog" CLIPPED)
 
   CALL cl_ui_locale("aooi901_fp")
 
   DISPLAY ls_fglprofile,lc_encode,lc_azp03,ls_user
        TO FORMONLY.filename,FORMONLY.encode,azp03,FORMONLY.username
 
   INPUT ls_user,ls_passwd1,ls_passwd2 WITHOUT DEFAULTS
      FROM FORMONLY.username,FORMONLY.passwd1,FORMONLY.passwd2 
 
      AFTER FIELD passwd1
         IF ls_passwd1.getIndexOf(":",1) THEN
            CALL cl_err("","azz-887",1)
            LET ls_passwd1 = ""
            DISPLAY ls_passwd1 TO FORMONLY.passwd1
            NEXT FIELD passwd1
         END IF
 
      AFTER INPUT 
         IF ls_passwd1 <> ls_passwd2 OR cl_null(ls_passwd1) THEN
            LET ls_passwd1 = ""
            LET ls_passwd2 = ""
            DISPLAY ls_passwd1,ls_passwd2 TO FORMONLY.passwd1,FORMONLY.passwd2
            CALL cl_err("","azz-882",1)
            NEXT FIELD passwd1
         END IF
         
         IF cl_db_get_database_type() = "ORA" AND lc_azp03 <> ls_user THEN  #FUN-960077
            CALL cl_err("","azz-888",1)         	
            NEXT FIELD username
         END IF
 
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT INPUT
 
      ON ACTION about     
         CALL cl_about() 
 
      ON ACTION help   
         CALL cl_show_help() 
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   CLOSE WINDOW i901_fp_w
 
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF
 
   #更新密碼shadow檔
   CALL i901_gen_dbconnect()
   #建立fglprofile(暫存)檔
   CALL i901_gen_fglprofile()
 
END FUNCTION
 
 
#驗證是否為 DBA 身份
FUNCTION i901_auth_dba() 
 
   DEFINE lc_db_type    LIKE type_file.chr3
   DEFINE lc_dba_priv   LIKE type_file.chr1
 
   LET lc_db_type = cl_db_get_database_type()
 
   CASE 
      WHEN lc_db_type = "IFX" 
         SELECT COUNT(*) INTO lc_dba_priv FROM sysusers
          WHERE usertype='D' and (username=g_user or username='public')
 
      WHEN lc_db_type = "ORA" 
        RUN "groups|grep dba" RETURNING lc_dba_priv
        IF lc_dba_priv = "0 " THEN LET lc_dba_priv = "1" END IF  #TQC-920013
 
      WHEN lc_db_type = "MSV" 
        LET lc_dba_priv = "1"
   END CASE
 
   IF lc_dba_priv = '1' THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
 
END FUNCTION
 
#更新密碼shadow檔
FUNCTION i901_gen_dbconnect()
   
   DEFINE lc_channel    base.Channel
   DEFINE lc_dbconnect  base.Channel
   DEFINE ls_tempfile   STRING
   DEFINE ls_temp       STRING
   DEFINE li_cnt        LIKE type_file.num5
   DEFINE li_flag       LIKE type_file.num5
   DEFINE l_cmd         STRING 
  
   CALL la_dbc.clear()
   
   IF os.Path.exists(ls_cbakpath.trim()) THEN  #TQC-920013  #FUN-930071 	 
      #將dbconnect.ini資料讀入dynamic array (編碼密碼不為空時讀入,只存azp03)
      LET lc_dbconnect = base.Channel.create()
      CALL lc_dbconnect.openFile(ls_cbakpath.trim(), "r")
      CALL lc_dbconnect.setDelimiter("")
 
      LET li_cnt = 1
 
      #讀取
      WHILE TRUE
         LET ls_temp = lc_dbconnect.readLine()
         IF lc_dbconnect.isEof() THEN EXIT WHILE END IF
         IF ls_temp.getIndexOf("::",1) THEN
            LET la_dbc[li_cnt].azp03 = ls_temp.subString(1,ls_temp.getIndexOf("::",1)-1)
            LET la_dbc[li_cnt].username = ls_temp.subString(ls_temp.getIndexOf("::",1)+2,ls_temp.getLength())
         ELSE
            LET la_dbc[li_cnt].azp03 = ls_temp.trim()
            LET la_dbc[li_cnt].username = ""
         END IF
         IF la_dbc[li_cnt].username.getIndexOf("::",1) THEN
            LET ls_temp = la_dbc[li_cnt].username
            LET la_dbc[li_cnt].username = ls_temp.subString(1,ls_temp.getIndexOf("::",1)-1)
            LET la_dbc[li_cnt].encodepass = ls_temp.subString(ls_temp.getIndexOf("::",1)+2,ls_temp.getLength())
         ELSE
            LET la_dbc[li_cnt].encodepass = ""
         END IF
         LET li_cnt = li_cnt + 1
      END WHILE
      CALL lc_dbconnect.close()
   END IF
 
   #FUN-930071 開啟 dbconnect.ini 準備寫入資料 
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ls_cbakpath.trim(), "w")
   CALL lc_channel.setDelimiter("")
   #檢查一下是否已經有現在在改的這個資料庫的資料, 有:改密碼, 沒:新增一條
   LET li_flag = FALSE
   FOR li_cnt = 1 TO la_dbc.getLength()
      IF la_dbc[li_cnt].azp03.trim() = lc_azp03 CLIPPED THEN
         LET la_dbc[li_cnt].username = ls_user CLIPPED  #FUN-930071
         LET la_dbc[li_cnt].encodepass = cl_tiptop_encode(ls_passwd1)
         LET li_flag = TRUE
         EXIT FOR
      END IF
   END FOR
   IF NOT li_flag THEN
      LET li_cnt = la_dbc.getLength() + 1
      LET la_dbc[li_cnt].azp03 = lc_azp03 CLIPPED
      LET la_dbc[li_cnt].username = ls_user CLIPPED  #FUN-930071
      LET la_dbc[li_cnt].encodepass = cl_tiptop_encode(ls_passwd1)
   END IF
 
   #將資料寫入新檔中
   FOR li_cnt = 1 TO la_dbc.getLength()
      LET ls_temp = la_dbc[li_cnt].azp03 CLIPPED,"::",
                    la_dbc[li_cnt].username CLIPPED,"::",
                    la_dbc[li_cnt].encodepass CLIPPED
      CALL lc_channel.write(ls_temp.trim())
   END FOR
   
   CALL lc_channel.close()
#  LET l_cmd = "chmod 755 ", ls_tempfile CLIPPED, " >/dev/null 2>&1"  #No.FUN-9C0009
#  RUN l_cmd                                               #No.FUN-9C0009
   IF os.Path.chrwx(ls_tempfile CLIPPED,493) THEN END IF   #No.FUN-9C0009
 
END FUNCTION
 
#在臨時路徑下生成 FGLPROFILE (暫存)檔
FUNCTION i901_gen_fglprofile()
   
   DEFINE ls_tempfile   STRING
   DEFINE lc_channel    base.Channel
   DEFINE lc_fglprofile base.Channel
   DEFINE ld_datetime   DATETIME YEAR TO MINUTE
   DEFINE ls_temp       STRING
   DEFINE ls_azp03      STRING
   #DEFINE ls_tmpstr     STRING
   DEFINE li_exist      LIKE type_file.num5
   DEFINE li_i,li_j     LIKE type_file.num5
 
   LET ld_datetime = CURRENT YEAR TO MINUTE
   LET ls_tempfile = ld_datetime
   LET ls_tempfile = ls_tempfile.subString(3,4), ls_tempfile.subString(6,7),
                     ls_tempfile.subString(9,10),
                     ls_tempfile.subString(12,13),
                     ls_tempfile.subString(15,16)
   LET ls_tempfile = "fglprofile.",ls_tempfile.trim()
   LET ls_tempfile = os.Path.join(FGL_GETENV("TEMPDIR"),ls_tempfile.trim())
   
 
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ls_tempfile.trim(), "w")
   CALL lc_channel.setDelimiter("")
 
   LET lc_fglprofile = base.Channel.create()
   CALL lc_fglprofile.openFile(ls_fglprofile.trim(), "r")
 
   LET li_exist = FALSE
   WHILE (lc_fglprofile.read(ls_temp))
      #清除已存在 array 裡的 azp03 db 的 username / password 設定
      IF ls_temp.getIndexOf("dbi.database.",1) AND
       ( ls_temp.getIndexOf("password",1) OR ls_temp.getIndexOf("username",1) ) THEN
         LET li_i = ls_temp.getIndexOf("dbi.database.",1)
         CASE
            WHEN ls_temp.getIndexOf(".username",1)
               LET ls_azp03 = ls_temp.subString(li_i+13,ls_temp.getIndexOf(".username",li_i) -1)
            WHEN ls_temp.getIndexOf(".password",1)
               LET ls_azp03 = ls_temp.subString(li_i+13,ls_temp.getIndexOf(".password",li_i) -1)
         END CASE
         FOR li_j = 1 TO la_dbc.getLength()
            IF la_dbc[li_j].azp03.equals(ls_azp03.trim()) THEN
               LET ls_temp = ""
               EXIT FOR
            END IF
         END FOR
      END IF
      CALL lc_channel.write(ls_temp)
   END WHILE
 
   CALL lc_channel.close()
   CALL lc_fglprofile.close()
 
   CALL cl_err_msg(NULL,"azz-883",ls_tempfile,10)
 
END FUNCTION
#FUN-910114
 
