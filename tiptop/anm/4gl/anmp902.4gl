# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmp902.4gl
# Descriptions...: 銀行自動對帳作業
# Date & Author..: 97/01/28 by lydia
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)                                                                                 
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/01/18 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970017 09/09/21 By baofei 修改LET l_cmd="dtcget $TEMPDIR/dsc-bank.txt 'c:\\tiptop\\dsc-bank.txt' "        
# Modify.........: No.FUN-9B0030 09/11/04 By wujie  5.2SQL转标准语法
# Modify.........: No.FUN-9B0068 09/11/10 By lilingyu 臨時表字段改成LIKE的形式
                                                                                                                                    
IMPORT os         #TQC-970017    
DATABASE ds
                                                                               
GLOBALS "../../config/top.global"
                                                                               
DEFINE tm  RECORD	
           wc      LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(300)
       fname       LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
   	   nme01   LIKE nme_file.nme01,          #No.FUN-680107 VARCHAR(6)
   	   nma02   LIKE nme_file.nme02,          #No.FUN-680107 VARCHAR(16)
   	   bdate   LIKE type_file.dat,           #No.FUN-680107 DATE
   	   edate   LIKE type_file.dat            #No.FUN-680107 DATE
           END RECORD,
       g_dbs_gl    LIKE type_file.chr21,         #No.FUN-680107 VARCHAR(21)
       g_ckcode    LIKE nnf_file.nnf07,          #No.FUN-680107 VARCHAR(2)
       g_leng      LIKE type_file.num10,         #No.FUN-680107 INTEGER
       g_delete    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       g_nma  RECORD LIKE nma_file.*,
       g_nme  RECORD LIKE nme_file.*,
       g_npc  RECORD LIKE npc_file.*,
       l_npc  RECORD LIKE npc_file.*,
       m_shift     LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       g_flag      LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
                                                                               
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
 
    OPEN WINDOW p340 WITH FORM "anm/42f/anmp902" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL p340_ask()
 
    CLOSE WINDOW p340

    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
                                                                               
FUNCTION p340_ask()
   DEFINE   l_bdate   LIKE type_file.dat       #No.FUN-680107 DATE
   DEFINE   l_year    LIKE nme_file.nme16
                                                                              
 
     WHILE TRUE 
       LET  m_shift     =  "N"  
       LET tm.nme01='114'
       DISPLAY BY NAME tm.nme01,tm.bdate,tm.edate 
       INPUT BY NAME tm.nme01,tm.bdate,tm.edate WITHOUT DEFAULTS 
      
          AFTER FIELD nme01
             SELECT * INTO g_nma.* FROM nma_file WHERE nma01=tm.nme01
             IF STATUS=NOTFOUND THEN
#               CALL cl_err(tm.nme01,'anm-013',0)   #No.FUN-660148
                CALL cl_err3("sel","nma_file",tm.nme01,"","anm-013","","",0) #No.FUN-660148
                NEXT FIELD nme01
             ELSE
                LET tm.bdate=g_nma.nma21
                LET tm.nma02=g_nma.nma02
                DISPLAY BY NAME g_nma.nma02,tm.bdate
             END IF
             CASE tm.nme01
                WHEN '114' 
                   LET tm.fname='dsc-bank.txt'   #上傳土銀檔案甲存
                   LET g_ckcode='CG'         #支票代碼
                   LET g_leng=200            #檔案長度
                OTHERWISE 
                   LET tm.fname=NULL
                   LET g_ckcode=NULL     
                   CALL cl_err(tm.nme01,'anm-951',0)
                   NEXT FIELD nme01
             END CASE
             DISPLAY BY NAME tm.fname
 
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
          CALL cl_wait()
       ELSE
          RETURN
       END IF
 
       BEGIN WORK
       LET g_success = 'Y'
       IF ftpfile() THEN #unload success
          CALL init_p340() #清除非支票原對帳記錄
          CALL p340()      #依銀行對帳單對帳
          IF g_success='Y' THEN 
             CALL update_nme()
          END IF
       END IF
       IF g_success='Y' THEN 
          UPDATE nma_file SET nma21=tm.edate
          WHERE nma01=tm.nme01
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#            CALL cl_err('upd_nme',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#             CALL cl_err3("upd","nma_file",tm.nme01,"",SQLCA.sqlcode,"","upd_nme",1) #No.FUN-660148
             CALL s_errmsg('nma01',tm.nme01,'upd_nme',SQLCA.sqlcode,1)
             CALL s_showmsg()       
#No.FUN-710024--begin
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
          ELSE 
             CALL s_showmsg()          #No.FUN-710024
             COMMIT WORK
             CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
          END IF 
       ELSE 
          CALL s_showmsg()          #No.FUN-710024
          ROLLBACK WORK
          CALL cl_end2(2) RETURNING g_flag           #批次作業失敗
       END IF
       IF g_flag THEN
          CONTINUE WHILE
       ELSE
          EXIT WHILE
       END IF
     END WHILE  
 
END FUNCTION
                                                                               
FUNCTION init_p340()
    DELETE FROM npc_file 
    WHERE npc01=tm.nme01 
    AND npc02 BETWEEN tm.bdate AND tm.edate
    UPDATE nme_file SET nme20=null 
    WHERE nme01=tm.nme01
    AND nme16 BETWEEN tm.bdate AND tm.edate
END FUNCTION
                                                                               
FUNCTION p340()
DEFINE l_date LIKE type_file.dat,           #No.FUN-680107 DATE
       l_time LIKE type_file.chr8,          #No.FUN-6A0082
       l_memo LIKE npc_file.npc03,          #No.FUN-680107 VARCHAR(5)
       l_fd   LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(200)
       l_dw   LIKE npc_file.npc04,          #No.FUN-680107 VARCHAR(1)
       l_amt  LIKE npc_file.npc05,          #No.FUN-680107 DECIMAL(20,6)
       l_ck   LIKE npc_file.npc06,          #No.FUN-680107 VARCHAR(10)
       l_damt,l_camt LIKE npc_file.npc05    #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
                                                                               
   DECLARE q_cur1 CURSOR FOR
   SELECT * FROM tmp_p340
   CALL s_showmsg_init()           #No.FUN-710024
   FOREACH q_cur1 INTO l_fd
      IF SQLCA.sqlcode != 0 THEN
#No.FUN-710024--begin
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)  
#No.FUN-710024--end
          LET g_success ='N'        #FUN-8A0086
          EXIT FOREACH
      END IF
#No.FUN-710024--begin
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF             
#No.FUN-710024--end 
 
      INITIALIZE g_npc.* TO NULL
      LET g_delete=NULL
      CASE tm.nme01
      WHEN '114'
         LET l_date=l_fd[13,18]
         LET l_time=l_fd[19,20],':',l_fd[21,22]             #時間
         LET l_memo=l_fd[34,35]                             #摘要
         IF l_fd[39,39]='1' THEN LET g_delete='D' END IF    #更正碼
         LET l_damt=l_fd[40,52]                             #提 
         LET l_camt=l_fd[53,65]                             #存
         IF l_damt<>0 THEN
            LET l_dw='2'  
            LET l_amt=l_damt/100                            #提
         ELSE
            LET l_dw='1'  
            LET l_amt=l_camt/100                            #存
         END IF
         IF l_fd[101,107]='0000000' THEN                    #支票號碼(非支票)
            LET l_ck=NULL
         ELSE
            LET l_ck=g_ckcode,l_fd[101,107] 
         END IF
      END CASE
      LET g_npc.npc01=tm.nme01
      CALL chang_chdate(l_date) RETURNING g_npc.npc02 #日期
      IF g_npc.npc02 > tm.edate OR g_npc.npc02 < tm.bdate THEN
         CONTINUE FOREACH
      END IF
      IF g_npc.npc02 IS NULL THEN CONTINUE FOREACH END IF
      LET g_npc.npc021=l_time                               #時間
      LET g_npc.npc03=l_memo                                #摘要
      LET g_npc.npc04=l_dw                                  #收支碼
      LET g_npc.npc05=l_amt                                 #金額
      LET g_npc.npc06=l_ck                                  #支票號碼
      MESSAGE 'Date:',g_npc.npc02 ,'   Check No.:',g_npc.npc06 
      CALL ui.Interface.refresh()
      SELECT npc_file.* INTO l_npc.* FROM npc_file  
         WHERE npc01=g_npc.npc01
           AND npc03=g_npc.npc03
           AND npc04=g_npc.npc04
           AND npc05=g_npc.npc05
           AND npc06=g_npc.npc06
      IF STATUS!=NOTFOUND AND 
         l_npc.npc07 matches '[12]' AND  #已對帳或錯帳
         g_delete='D'               THEN #此筆已存在,將刪除
         DELETE FROM npc_file WHERE npc01 = l_npc.npc01 AND npc02 = l_npc.npc02 AND npc03 = l_npc.npc03
         IF SQLCA.sqlcode != 0 THEN 
#           CALL cl_err('del npc_file error,',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("del","npc_file",l_npc.npc01,"",SQLCA.sqlcode,"","del npc_file error,",1) #No.FUN-660148
#           CALL s_errmsg('rowid',l_npc.npc01,'del npc_file error,',SQLCA.sqlcode,1)
            CALL s_errmsg('npc01',l_npc.npc01,'del npc_file error,',SQLCA.sqlcode,1)   #No.FUN-9B0030
            LET g_success='N'
#            RETURN
            CONTINUE FOREACH 
#No.FUN-710024--end
         END IF
         IF NOT cls_nme08() AND l_npc.npc07='1' THEN #清除已對帳之對帳碼
            IF g_delete='D' THEN
               LET g_npc.npc07='D' #更正記錄
            ELSE
               LET g_npc.npc07='2' #錯誤
            END IF
 
            #FUN-980005  add legal 
            LET g_npc.npclegal = g_legal
            #FUN-980005  end legal 
 
            INSERT INTO npc_file VALUES (g_npc.*)
            IF SQLCA.sqlcode != 0 THEN 
#              CALL cl_err('insert npc_file error,',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","npc_file",g_npc.npc01,g_npc.npc02,SQLCA.sqlcode,"","insert npc_file error,",1) #No.FUN-660148
               LET g_showmsg=g_npc.npc01,"/",g_npc.npc02,"/",g_npc.npc06
               CALL s_errmsg('npc01,npc02,npc06',g_showmsg,'insert npc_file error,',SQLCA.sqlcode,1)
               LET g_success='N'
#               RETURN
               CONTINUE FOREACH
#No.FUN-710024--end
            END IF
         END IF
      ELSE
         CALL upd_nme() #更新對帳碼
 
         #FUN-980005  add legal 
         LET g_npc.npclegal = g_legal
         #FUN-980005  end legal 
 
         INSERT INTO npc_file VALUES (g_npc.*)
         IF SQLCA.sqlcode != 0 THEN 
#           CALL cl_err('insert npc_file error,',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","npc_file",g_npc.npc01,g_npc.npc02,SQLCA.sqlcode,"","insert npc_file error,",1) #No.FUN-660148
            LET g_showmsg=g_npc.npc01,"/",g_npc.npc02,"/",g_npc.npc06
            CALL s_errmsg('npc01,npc02,npc06',g_showmsg,'insert npc_file error,',SQLCA.sqlcode,1)
            LET g_success='N'
#            RETURN
            CONTINUE FOREACH
#No.FUN-710024--end
         END IF
      END IF
   END FOREACH
#No.FUN-710024--begin
  IF g_totsuccess="N" THEN                                                                                                         
     LET g_success="N"                                                                                                             
  END IF 
#No.FUN-710024--end  
END FUNCTION
                                                                                
FUNCTION ftpfile()
DEFINE l_cmd  LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(60)
       l_sql  LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(100)
DEFINE l_source,l_target,l_status   STRING      #TQC-970017 
 
  ###FTP 檔案 
#TQC-970017---begin                                                                                                                 
#   LET l_cmd="dtcget $TEMPDIR/dsc-bank.txt 'c:\\tiptop\\dsc-bank.txt' "                                                            
#   RUN l_cmd                                                                                                                       
    LET l_source= os.Path.join(FGL_GETENV("TEMPDIR"),"dsc-bank.txt")                                                                
    LET l_target="C:\\tiptop\\dsc-bank.txt"                                                                                         
    LET l_status = cl_download_file(l_source,l_target)                                                                              
#TQC-970017---end   
  ###上傳檔案
#  LET l_sql=" CREATE TEMP TABLE tmp_p340 (fd VARCHAR(200)) "    #FUN-680107
   LET l_sql=" CREATE TEMP TABLE tmp_p340 (fd LIKE type_file.chr1000) "  #FUN-680107 欄位類型修改  #TQC-970017   #FUN-9B0068還原
#   LET l_sql=" CREATE TEMP TABLE tmp_p340 (fd VARCHAR(1000)) "          #TQC-970017  #FUN-9B0068 MARK 
   PREPARE open_pre FROM l_sql
   EXECUTE open_pre
 
   CASE tm.nme01 
   WHEN '114'
        LOAD FROM 'dsc-bank.txt' INSERT INTO tmp_p340
   END CASE
   RETURN TRUE  
END FUNCTION
                                                                               
FUNCTION upd_nme()
DEFINE l_nmc03 LIKE nmc_file.nmc03,
       l_nme00 LIKE nme_file.nme00   #No.FUN-680107 INTEGER
   LET l_nme00=null
   IF g_npc.npc06 IS NULL THEN #非支票
     SELECT MAX(nme00) INTO l_nme00 FROM nme_file
     WHERE nme01=g_npc.npc01  #銀行
     AND nme04=g_npc.npc05    #金額
     AND nme16=g_npc.npc02    #日期
     AND (nme20 IS NULL OR nme20=' ')
     IF l_nme00 IS NOT NULL THEN
        SELECT * INTO g_nme.* FROM nme_file WHERE nme00=l_nme00
     ELSE
        LET g_npc.npc07='2' #未入帳
        RETURN
     END IF  
   ELSE
     if m_shift = "N" then
        SELECT * INTO g_nme.* FROM nme_file 
         WHERE nme01=g_npc.npc01
           AND nme04=g_npc.npc05 
           AND nme17=g_npc.npc06
     else
        SELECT * INTO g_nme.* FROM nme_file 
         WHERE nme01=g_npc.npc01
          #AND nme02 between tm.bdate  and  tm.edate
           AND nme04=g_npc.npc05 
           AND nme17[3,10]=g_npc.npc06
     end if
   END IF  
   IF STATUS!=NOTFOUND THEN 
      SELECT nmc03 INTO l_nmc03 FROM nmc_file WHERE nmc01=g_nme.nme03
      IF STATUS!=NOTFOUND AND
         l_nmc03=g_npc.npc04 THEN #收支代碼相同
         UPDATE nme_file SET nme20='Y',nme09=null
         WHERE nme00=g_nme.nme00
         AND (nme20 IS NULL OR nme20=' ')
         LET g_npc.npc07='1' #已對帳
         LET g_npc.npc08=g_nme.nme00  #更新來源
      END IF
   END IF  
   IF g_npc.npc07<>'1' OR g_npc.npc07 IS NULL  THEN
      LET g_npc.npc07='2' #未入帳
      LET g_npc.npc08=null  #更新來源
   END IF
END FUNCTION
                                                                               
FUNCTION cls_nme08()
DEFINE l_nmc03 LIKE nmc_file.nmc03,
       l_nme00 LIKE nme_file.nme00   #No.FUN-680107 INTEGER
   LET l_nme00=null
   SELECT * FROM nme_file
   WHERE nme00=l_npc.npc08 #來源編號
   AND nme20='Y'
   IF STATUS=NOTFOUND THEN 
      MESSAGE 'ERROR!'
      CALL ui.Interface.refresh()
      RETURN FALSE
   END IF
                                                                               
   UPDATE nme_file
   SET nme20=NULL
   WHERE nme00=l_npc.npc08
   AND nme20='Y'
                                                                               
   RETURN TRUE
END FUNCTION
                                                                               
FUNCTION chang_chdate(l_date)
DEFINE l_date LIKE type_file.chr8,        #No.FUN-680107 VARCHAR(6)
       r_date LIKE type_file.dat,         #No.FUN-680107 DATE
       l_str  LIKE type_file.chr8         #No.FUN-680107 VARCHAR(10)
                                                                               
   LET l_str[1,2]=l_date[1,2]+11
   LET l_str[3,3]="/"
   LET l_str[4,6]=l_date[3,4],"/"
   LET l_str[7,8]=l_date[5,6]
   LET r_date=DATE(l_str)
   RETURN r_date
END FUNCTION
                                                                               
FUNCTION update_nme()
    MESSAGE "Update nme_file ..............."
    CALL ui.Interface.refresh()
    UPDATE nme_file SET nme09='PK'    #銀行未入
       WHERE nme16 BETWEEN tm.bdate AND tm.edate
         AND nme01=tm.nme01
         AND nme09 IS NULL            #未作調節
         AND nme20 IS NULL            #未對帳
END FUNCTION
