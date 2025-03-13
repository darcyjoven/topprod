# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Descriptions...: 委花旗代付票號寫回作業
# Date & Author..: 97/07/28 by lydia
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: NO.FUN-550057 05/05/30 By jackie 單據編號加大
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6C0176 06/12/28 By Smapmin 修改上傳方法
# Modify.........: No.FUN-710024 07/01/18 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0008 09/12/03 By alex 調整環境變量
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD	
	   wc           LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(300)	
           fname        LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
   	   nmd01        LIKE nmd_file.nmd01,          #No.FUN-680107 VARCHAR(1) #No.FUN-550057
   	   nmd06        LIKE nmd_file.nmd06,
   	   nma02        LIKE nma_file.nma02           #No.FUN-680107 VARCHAR(16)
       END RECORD,
       g_dbs_gl         LIKE type_file.chr21,         #No.FUN-680107 VARCHAR(21)
       g_flag           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       g_leng           LIKE type_file.num10,         #No.FUN-680107 INTEGER
       g_nma            RECORD LIKE nma_file.*,
       g_nmd            RECORD LIKE nmd_file.*
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
 
    OPEN WINDOW p901 WITH FORM "anm/42f/anmp901" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
    CALL p901_ask()
 
    CLOSE WINDOW p901

    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION p901_ask()
   DEFINE   l_year   LIKE nmd_file.nmd16
 
     WHILE TRUE
       LET tm.nmd01='104'
       LET tm.nmd06='01'
       DISPLAY BY NAME tm.nmd01,tm.nmd06 
 
       INPUT BY NAME tm.nmd01,tm.nmd06 WITHOUT DEFAULTS 
       
          AFTER FIELD nmd01
             IF NOT cl_null(tm.nmd01) THEN 
                SELECT * INTO g_nma.* FROM nma_file WHERE nma01=tm.nmd01
                IF STATUS=NOTFOUND THEN 
# Prog. Version..: '5.30.06-13.03.12(0,'anm-013',0)   #No.FUN-660148
                   CALL cl_err3("sel","nma_file",tm.nmd01,"","anm-013","","",0) #No.FUN-660148
                   NEXT FIELD nmd01
                ELSE
                   LET tm.nma02=g_nma.nma02
                   DISPLAY BY NAME g_nma.nma02
                END IF
             END IF
           
          AFTER FIELD nmd06 #票別一
             IF NOT cl_null(tm.nmd06) THEN 
                SELECT * FROM nmo_file WHERE nmo01=tm.nmd06
                IF STATUS=NOTFOUND THEN 
# Prog. Version..: '5.30.06-13.03.12(0,'anm-086',0)   #No.FUN-660148
                   CALL cl_err3("sel","nmo_file",tm.nmd06,"","anm-086","","",0) #No.FUN-660148
                   NEXT FIELD nmd06
                ELSE
                   IF tm.nmd06='01' THEN
                      LET tm.fname='dsc-nmr1.txt'
                   ELSE
                      LET tm.fname='dsc-nmr2.txt'
                   END IF
                   DISPLAY BY NAME tm.fname
                END IF
             END IF
       
          ON ACTION locale                    #genero
             LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             EXIT INPUT
         
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         
          ON ACTION exit  #加離開功能genero
             LET INT_FLAG = 1
             EXIT INPUT
       
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
       END INPUT
 
       IF g_action_choice = "locale" THEN  #genero
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE 
       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          EXIT WHILE  
       END IF
 
       IF cl_sure(10,10) THEN
          BEGIN WORK
          LET g_success = 'Y'
          IF ftpfile() THEN   #unload success
             CALL p_check()   #已開票
          ELSE
             LET g_success='N'
          END IF
          CALL s_showmsg()          #No.FUN-710024
          IF g_success='Y' THEN 
             COMMIT WORK
             CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
          ELSE 
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING g_flag           #批次作業失敗
          END IF
          IF g_flag THEN
             CONTINUE WHILE
          ELSE
             EXIT WHILE
          END IF
       END IF
     END WHILE 
END FUNCTION
 
FUNCTION p_check() #已開票 
DEFINE l_date   LIKE type_file.dat,           #No.FUN-680107 DATE
       l_amt    LIKE nmd_file.nmd04,          #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
       l_nmd01  LIKE nmd_file.nmd02,
       p_nmd02  LIKE nmd_file.nmd02,
       l_ckno   LIKE nmd_file.nmd02,
       l_fd     LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(200)
 
   DECLARE q_cur_chk CURSOR FOR  
   SELECT * FROM tmp_p901
   CALL s_showmsg_init()                      #No.FUN-710024
   FOREACH q_cur_chk INTO l_fd
      IF SQLCA.sqlcode!=0 THEN 
#No.FUN-710024--begin
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)    
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
#No.FUN-710024--end
         EXIT FOREACH 
      END IF
      LET l_nmd01=l_fd[1,10] #開票號碼
      LET l_ckno=l_fd[11,17] USING "<<<<<<<" #支票號碼
      MESSAGE "No.:",l_nmd01
      CALL ui.Interface.refresh()
      CALL chang_chdate(l_fd[18,25]) RETURNING l_date #到期日期
      LET l_amt=l_fd[105,122] #開票金額
      SELECT nmd02 INTO p_nmd02 FROM nmd_file 
      WHERE nmd01=l_nmd01 AND nmd30 <> 'X' #開票號碼
      IF STATUS!=NOTFOUND THEN
         IF p_nmd02 IS NULL OR p_nmd02=' ' THEN
            UPDATE nmd_file SET nmd02=l_ckno,   #支票號碼
                                nmd15=nmd07,    #寄領日期=開票日
                                nmd16=g_user    #經辨人員
               WHERE nmd01=l_nmd01              #開票號碼
                 AND nmd04=l_amt                #開票金額
                 AND nmd32='Y'                  #已委花旗開票
            IF SQLCA.sqlcode != 0  or sqlca.sqlerrd[3] = 0 THEN 
#              CALL cl_err('update nmd_file:',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("upd","nmd_file",l_nmd01,l_amt,SQLCA.sqlcode,"","update nmd_file:",1) #No.FUN-660148
               LET g_showmsg=l_nmd01,"/",l_amt,"/",'Y'
               CALL s_errmsg('nmd01,nmd04,nmd32',g_showmsg,'update nmd_file:',SQLCA.sqlcode,1)
               LET g_success='N' 
#               EXIT FOREACH 
               CONTINUE FOREACH
#No.FUN-710024--end
            END IF
         END IF
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION ftpfile()
#-----TQC-6C0176---------
   DEFINE    l_source,l_target,l_status STRING   
 
   IF tm.nmd06='01' THEN
      LET l_target = os.Path.join(FGL_GETENV("TEMPDIR"),"dsc-nmr1.txt" )    #FUN-9C0008
      LET l_source = "c:\\tiptop\\dsc-nmr1.txt"
      LET l_status = cl_upload_file(l_source,l_target)
   ELSE
      LET l_target = os.Path.join(FGL_GETENV("TEMPDIR"),"dsc-nmr2.txt" )    #FUN-9C0008
      LET l_source = "c:\\tiptop\\dsc-nmr2.txt"
      LET l_status = cl_upload_file(l_source,l_target)
   END IF
   IF l_status THEN
      CALL cl_err(l_source,"amd-022",1)
      RETURN 1
   ELSE
      CALL cl_err(l_source,"amd-023",1)
      RETURN 0
   END IF
#DEFINE l_cmd  LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(60)
#       l_sql  LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
#  ###FTP 檔案 
#   IF tm.nmd06='01' THEN
#      LET l_cmd="dtcget $TEMPDIR/dsc-nmr1.txt 'c:\\tiptop\\dsc-nmr1.txt' "
#   ELSE
#      LET l_cmd="dtcget $TEMPDIR/dsc-nmr2.txt 'c:\\tiptop\\dsc-nmr2.txt' "
#   END IF
#   RUN l_cmd    
#  ###上傳檔案
##  LET l_sql=" CREATE TEMP TABLE tmp_p901 (fd VARCHAR(200)) "  #No.FUN-680107
#   LET l_sql=" CREATE TEMP TABLE tmp_p901 (fd LIKE type_file.chr1000) "  #No.FUN-680107 --欄位類型修改
#   PREPARE open_pre FROM l_sql
#   EXECUTE open_pre
#
#   IF tm.nmd06='01' THEN
#      LOAD FROM '/u1/out/dsc-nmr1.txt' INSERT INTO tmp_p901
#   ELSE
#      LOAD FROM '$TEMPDIR/dsc-nmr2.txt' INSERT INTO tmp_p901
#   END IF
#   IF STATUS THEN
#      RETURN 0     
#   ELSE
#      RETURN 1     
#   END IF
#-----END TQC-6C0176-----
END FUNCTION
 
FUNCTION chang_chdate(l_str)
DEFINE l_date LIKE type_file.chr8,          #No.FUN-680107 VARCHAR(10)
       r_date LIKE type_file.dat,           #No.FUN-680107 DATE
       l_str  LIKE type_file.chr8           #No.FUN-680107 VARCHAR(8)
 
   LET l_date[1,3]=l_str[3,4],"/"
   LET l_date[4,6]=l_str[5,6],"/"
   LET l_date[7,8]=l_str[7,8]
   LET r_date=DATE(l_date)
   RETURN r_date
END FUNCTION
