# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: Function-Library 
# Descriptions...: Main Function: ftp  upload & gpg encrypt
#                  Entironment :
#                  OS          : Red Hat Linux AS4 
#                  FTP Software: vsFTPd 2.0.1 
#                  GPG Software: gpg (GnuPG) 1.2.6  
# Date & Author..: 08/02/16 By David Lee
# Memo...........: 若在不同的測試環境下應用,需要經過嚴格測試和調試方可實施
# Revise record..:  
# Modify.........: No.FUN-870067 08/07/17 By douzh 匯豐銀行接口協議
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
################################################################################
# TEST&DEMO嚗:    僅作為測試和Demo用,在實際應用里把Main函數刪除
#
#
#
#
################################################################################
 
#MAIN
# DEFINE pubkey DYNAMIC ARRAY OF RECORD  #存放查出來的所有已簽名的公匙和用戶ID和對應的私匙ID摮
#                 UID STRING,
#                 KID STRING 
#                 END RECORD 
# DEFINE seckey DYNAMIC ARRAY OF RECORD  #存放所有查出來的私鑰的用戶ID和對應的私鑰ID
#                 UID STRING,
#                 KID STRING                                                    
#                 END RECORD 
# DEFINE skid               STRING       #TIPTOP私鑰ID
#        ,passphrase        STRING       #TIPTOP私鑰的passphrase
#        ,pkid              STRING       #HSBC公鑰的子ID
#        ,ifile             STRING       #生成ifile文件路徑
#        ,sfile             STRING       #ifile文件加密后存入的路徑
#        ,host              STRING       #HSBC FTP服務器
#        ,name              STRING       #HSBC FTP服務器的賬號
#        ,password          STRING       #HSBC FTP服務器的口令
#        ,remotedir         STRING       #ifile存放路徑
#        ,saveasname        STRING       #ifile存放的名稱
# 
#
# DEFINE li_i   LIKE type_file.num10
#
# LET passphrase ="tiptop"               #用戶輸入
# LET ifile      ="/u1/out/ifile"        #程序生成
# LET sfile      ="/u1/out/ifile.pgp"    #程序生成,若相同則加密后覆蓋原明文
# LET host       ="192.168.100.254"      #配置作業
# LET name       ="tiptop"               #配置作業
# LET password   ="tiptop"               #自定義
# LET remotedir  ="./ifiles/"            #配置作業
# LET saveasname ="tiptop.gpg"           #按需求
#
# CALL getseckey(seckey)                 #得到所有私鑰的用戶ID和密鑰ID
# CALL getpubkey(pubkey)                 #得到所有公鑰的用戶ID和密鑰的子ID
#
# DISPLAY "\nsec--------\n"
# FOR li_i=1 TO seckey.getLength()
#    IF seckey[li_i].UID = "tiptop"      #用戶通過combox選擇
#    THEN 
#      LET skid = seckey[li_i].KID
#    END IF
#    DISPLAY seckey[li_i].UID ," & ",seckey[li_i].KID,"\n"  #顯示
# END FOR
#
# DISPLAY "pub sub----\n"
# FOR li_i=1 TO pubkey.getLength()
#
#    IF pubkey[li_i].UID = "HSBC_TEST"                      #用戶通過combox選擇
#    THEN 
#      LET pkid = pubkey[li_i].KID
#    END IF
#    DISPLAY pubkey[li_i].UID, " & ", pubkey[li_i].KID,"\n" #顯示
# END FOR
#
# DISPLAY "encrypt(",skid,",",passphrase,",",pkid,",",ifile,",",sfile,")"
# IF NOT encrypt(skid,passphrase,pkid,ifile,sfile) THEN
#       DISPLAY "加密失敗"
#       RETURN
# ELSE
#       DISPLAY "加密成功"
# END IF
#
# DISPLAY "\nupload(",host,",",name,",",password,",",remotedir,",",saveasname,",",sfile,")\n"
# CASE upload(host,name,password,remotedir,saveasname,sfile)
#    WHEN 0
#       DISPLAY "\n傳輸成功"                                          
#    WHEN 1
#       DISPLAY "\n連接失敗"                                          
#    WHEN 2
#       DISPLAY "\n登錄失敗"
#    WHEN 3
#       DISPLAY "\n服務器目錄失敗"
#    WHEN 4
#       DISPLAY "\n發送失敗"                                          
#    WHEN 5
#       DISPLAY "\n接受失敗"                                          
#    WHEN 6
#       DISPLAY "\n斷開失敗" 
# END CASE
#
#END MAIN
 
################################################################################
#
# Descriptions...: 上傳文件到指定的FTP服務器上
# Date & Author..: 2008/08/14 by David Lee
# Input Parameter: p_host           STRING       FTP Server IP Address
#                  p_name           STRING       FTP User
#                  p_password       STRING       FTP Password
#                  p_remotedir      STRING       上傳到服務器的目錄
#                  p_saveasname     STRING       上傳并保存的文件名
#                  p_localfile      STRING       上傳文件的本地路徑
# Return code....: LIKE type_file.num10 
#                           0:成功
#                           1:連接失敗
#                           2:登錄失敗
#                           3:服務器目錄失敗
#                           4:發送失敗
#                           5:接受失敗
#                           6:斷開失敗
################################################################################
FUNCTION upload(p_host,p_name,p_password,p_remotedir,p_saveasname,p_localfile)
DEFINE p_host            STRING,
       p_name            STRING,
       p_password        STRING,
       p_remotedir       STRING,
       p_saveasname      STRING,
       p_localfile       STRING
 
  DEFINE l_ch          base.Channel
  DEFINE ls_buf        STRING 
  DEFINE l_cmd         STRING
  DEFINE lst_line base.StringTokenizer
  DEFINE li_i    LIKE type_file.num10
  DEFINE li_j    LIKE type_file.num10
  DEFINE ls_str  STRING
  DEFINE li_err  LIKE type_file.num10
  DEFINE li_flag LIKE type_file.num10
  DEFINE li_status LIKE type_file.num10
 
  LET l_cmd= "ftp -v -n"
          ," ",p_host.trim()
          ," ","<<EOF"
          ,"\n"
          ,"user"
          ," ",p_name.trim()
          ," ",p_password.trim()
          ,"\n"
          ,"binary"
          ,"\n"
          ,"cd"
          ," ",p_remotedir
          ,"\n"
          ,"prompt"
          ,"\n"
          ,"put"
          ," ",p_localfile
          ," ",p_saveasname
          ,"\n"
          ,"bye"
          ,"\n"
          ,"EOF"
 
  LET l_ch = base.Channel.create()
  CALL l_ch.setDelimiter("\n")
  CALL l_ch.openPipe(l_cmd,"r")
  LET li_i=1
  LET li_flag=FALSE
  LET li_err = 0
  LET li_status =1
  WHILE l_ch.read(ls_buf)
    DISPLAY ls_buf
    IF ( ls_buf.subString(1,4) NOT MATCHES "[0-9]*")
    THEN
          LET li_i = li_i + 1
          CONTINUE WHILE
    END IF
  
    LET lst_line = base.StringTokenizer.create(ls_buf, " ")
    LET li_j = 1
    WHILE lst_line.hasMoreTokens()
       LET ls_str = lst_line.nextToken()
       LET ls_str = ls_str.trim()
       CASE li_j
         WHEN 1
           CASE
             WHEN (li_status= 1 AND ls_str="220")
                LET li_status = 2          #連接成功
             WHEN (li_status =2 AND ls_str="230")
                LET li_status =3           #登陸成功
             WHEN (li_status =3 AND ls_str="250")
                LET li_status =4           #改變目錄成功
             WHEN (li_status =4 AND ls_str="150")
                LET li_status =5           #發送數據成功
             WHEN (li_status =5 AND ls_str="226")
                LET li_status =6           #接收數據成功
             WHEN (li_status =6 AND ls_str="221")
                LET li_status =0           #斷開成功
           END CASE
       END CASE   
 
       LET li_j = li_j + 1
 
    END WHILE 
    
    LET li_i = li_i + 1     
  END WHILE
  CALL l_ch.close()
RETURN li_status
END FUNCTION
 
################################################################################
#
# Descriptions...: 獲取所有已簽名公鑰的用戶ID和密鑰ID,供用戶錄入時選擇(建議用Combox呈現用戶來選擇) 
# Date & Author..: 2008/08/14 by David Lee
# Input Parameter: 為輸出參數,保存處理結果
#                  DEFINE pubkeys DYNAMIC ARRAY OF RECORD
#                                         UID STRING,       #用戶ID
#                                         KID STRING        #公鑰ID(sub)
#                                        END RECORD
#
# Return code....:無
#
################################################################################
FUNCTION getpubkey(pubkeys)
DEFINE pubkeys DYNAMIC ARRAY OF RECORD
                 UID STRING,
                 KID STRING
                 END RECORD
  DEFINE ch      base.Channel
  DEFINE cmd     STRING
  DEFINE ls_buf  STRING
  DEFINE lst_line base.StringTokenizer
  DEFINE lst_sub  base.StringTokenizer
  DEFINE li_i    LIKE type_file.num10
  DEFINE li_j    LIKE type_file.num10
  DEFINE li_k    LIKE type_file.num10
  DEFINE li_flag LIKE type_file.num10
  DEFINE ls_str  STRING
  DEFINE lss_str STRING
  DEFINE pubkey  RECORD
                 UID STRING,
                 KID STRING
                 END RECORD
 
  LET cmd="gpg --list-key"
  LET ch = base.Channel.create()
  CALL ch.setDelimiter("\n")
  CALL ch.openPipe(cmd,"r")
  LET li_i=1
  LET li_flag=FALSE
  WHILE ch.read(ls_buf)  
    IF ( NOT (ls_buf.subString(1,4) = "pub " OR ls_buf.subString(1,4) ="sub "))
    THEN
          LET li_i = li_i + 1
          CONTINUE WHILE
    END IF
    IF ls_buf.subString(1,4) = "pub " THEN
          LET li_flag = TRUE
          LET li_j = 1
          LET lst_line = base.StringTokenizer.create(ls_buf, " ")
          WHILE lst_line.hasMoreTokens()
              LET ls_str = lst_line.nextToken()
              CASE li_j 
                 WHEN 4
                   LET pubkey.UID=ls_str.trim()
              END CASE
              LET li_j = li_j + 1
          END WHILE
          IF li_flag THEN
             LET li_i = li_i + 1
             CONTINUE WHILE
          END IF
          
    END IF
    
    IF li_flag THEN
          LET li_flag = FALSE
          IF ls_buf.subString(1,4) = "sub " THEN
            LET li_j=1  
            LET lst_line = base.StringTokenizer.create(ls_buf, " ")  
            WHILE lst_line.hasMoreTokens()
              LET ls_str = lst_line.nextToken()
              LET ls_str = ls_str.trim()                                        
              CASE li_j                                                         
                 WHEN 2                                                         
                   LET li_k=1
                   LET lst_sub = base.StringTokenizer.create(ls_str,"/")
                   WHILE lst_sub.hasMoreTokens()
                     LET lss_str = lst_sub.nextToken()
                     LET lss_str = lss_str.trim()
                     CASE li_k
                       WHEN 2
                         LET pubkey.KID=lss_str 
                     END CASE
                     LET li_k = li_k+1
                   END WHILE
              END CASE                                                          
              LET li_j = li_j + 1                                               
            END WHILE                       
            
            CALL pubkeys.appendElement()
            LET  pubkeys[pubkeys.getLength()].* = pubkey.*
 
            INITIALIZE pubkey.* TO NULL
            LET li_i = li_i + 1
            CONTINUE WHILE
          END IF
    END IF 
 
    LET li_i = li_i + 1
   
  END WHILE
  CALL ch.close()
 
END FUNCTION
 
################################################################################
#
# Descriptions...: 獲取所有私鑰的用戶ID和密鑰ID,供用戶錄入時選擇(建議用Combox呈現用戶來選擇)
# Date & Author..: 2008/08/14 by David Lee
# Input Parameter: 為輸出參數,保存處理結果
#                  DEFINE seckeys DYNAMIC ARRAY OF RECORD
#                                         UID STRING,       #用戶ID
#                                         KID STRING        #私鑰ID
#                                        END RECORD
#
# Return code....: 無
#
################################################################################
 
FUNCTION getseckey(seckeys)
DEFINE seckeys DYNAMIC ARRAY OF RECORD
                 UID STRING,
                 KID STRING
                 END RECORD
  DEFINE ch      base.Channel
  DEFINE cmd     STRING
  DEFINE ls_buf  STRING
  DEFINE lst_line base.StringTokenizer
  DEFINE lst_sub  base.StringTokenizer
  DEFINE li_i    LIKE type_file.num10
  DEFINE li_j    LIKE type_file.num10
  DEFINE li_k    LIKE type_file.num10
  DEFINE li_flag LIKE type_file.num10
  DEFINE ls_str  STRING
  DEFINE lss_str STRING
  DEFINE seckey  RECORD
                 UID STRING,
                 KID STRING
                 END RECORD
 
  LET cmd="gpg --list-secret-key"
  LET ch = base.Channel.create()
  CALL ch.setDelimiter("\n")
  CALL ch.openPipe(cmd,"r")
  LET li_i=1
  LET li_flag=FALSE
  WHILE ch.read(ls_buf)  
    IF ls_buf.subString(1,4) = "sec " THEN
          LET li_flag = TRUE
          LET li_j = 1
          LET lst_line = base.StringTokenizer.create(ls_buf, " ")
          WHILE lst_line.hasMoreTokens()
              LET ls_str = lst_line.nextToken()
              LET ls_str = ls_str.trim()
              CASE li_j 
                 WHEN 2
                   LET li_k=1                                                   
                   LET lst_sub = base.StringTokenizer.create(ls_str,"/")        
                   WHILE lst_sub.hasMoreTokens()                                
                     LET lss_str = lst_sub.nextToken()                          
                     LET lss_str = lss_str.trim()                               
                     CASE li_k                                                  
                       WHEN 2                                                   
                         LET seckey.KID=lss_str                                 
                     END CASE                                                   
                     LET li_k = li_k+1                                          
                   END WHILE           
                 WHEN 4
                   LET seckey.UID=ls_str.trim()
              END CASE
              LET li_j = li_j + 1
          END WHILE
 
    END IF
 
    IF li_flag THEN
          LET li_flag = FALSE
      CALL seckeys.appendElement()
      LET  seckeys[seckeys.getLength()].* = seckey.*
      INITIALIZE seckey.* TO NULL
    END IF
 
    LET li_i = li_i + 1
  END WHILE
  CALL ch.close()
END FUNCTION
 
################################################################################
#
# Descriptions...: 用私鑰和公鑰對ifile所指向的文件進行簽名和加密,輸出加密文件保存到ofile所指向的路徑
# Date & Author..: 2008/08/14 by David Lee
# Input Parameter: sikd       STRING 私鑰ID
#                  passphrase STRING 私鑰的密碼
#                  pkid       STRING 公鑰ID
#                  ifile      STRING 需要簽名并加密的文件路徑
#                  ofile      STRING 需要加密文件路徑
# Return code....: BOOLEAN
#                      TRUE : 成功
#                      FALSE: 失敗
#
################################################################################
 
FUNCTION encrypt(skid,passphrase,pkid,ifile,ofile)
DEFINE skid       STRING
      ,passphrase STRING
      ,pkid       STRING
      ,ifile      STRING
      ,ofile      STRING
 
  DEFINE ls_cmd     STRING 
  DEFINE lc_ch      base.Channel 
  DEFINE li_i       LIKE type_file.num10
  DEFINE ls_err     STRING
  DEFINE ls_buf     STRING
 
  LET ls_cmd ="gpg --batch --yes -e -s"
             ," -r ",pkid.trim() 
             ," -u ",skid.trim() 
             ," -o ",ofile.trim() 
             ," --passphrase"
             ," ",passphrase.trim()
             ," ",IFILE.trim() 
             ," 2>&1"
             ," &"
  LET lc_ch = base.Channel.create()
  CALL lc_ch.setDelimiter("\n")
  CALL lc_ch.openPipe(ls_cmd,"r")  
  LET li_i = 1
  WHILE lc_ch.read(ls_buf)
     DISPLAY ls_buf 
     LET li_i = li_i + 1
  END WHILE
  CALL lc_ch.close()
  IF li_i>1 THEN
     RETURN FALSE
  END IF
RETURN TRUE
END FUNCTION
#No.FUN-870067
