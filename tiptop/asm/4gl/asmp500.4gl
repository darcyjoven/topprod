# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asmp500.4gl
# Descriptions...: 族群料件連結產生作業
# Date & Author..: 91/12/02 By Wu  
# Release 4.0....: 92/07/25 By Jones
# Modify.........: No.MOD-470041 04/07/16 By Wiky 修改INSERT INTO...
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          sure    LIKE type_file.chr1,   #No.FUN-690010   VARCHAR(1),
          gdate   LIKE type_file.dat,    #No.FUN-690010  DATE,
          item    LIKE ima_file.ima01 #No.MOD-490217
          END RECORD,
          g_buf   LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(45)
          g_n     LIKE type_file.num5   #No.FUN-690010 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
 
FUNCTION p500_tm(p_row,p_col,p_arg)

   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          p_arg         LIKE ima_file.ima01, #No.MOD-490217
          l_jump        LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
          l_flag        LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_chr         LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   WHENEVER ERROR CONTINUE

   IF s_shut(0) THEN
      CLOSE WINDOW p500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF

   OPEN WINDOW p500_w WITH FORM "asm/42f/asmp500" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_ui_locale("asmp500")
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.sure = 'Y'
   LET tm.gdate = g_today
   LET tm.item  = p_arg
   LET l_jump   = 'N'
   WHILE TRUE
      INPUT tm.sure,tm.gdate,tm.item WITHOUT DEFAULTS FROM sure,gdate,item 
         AFTER FIELD sure   
            IF tm.sure IS NULL OR tm.sure NOT MATCHES'[YyNn]' THEN
               NEXT FIELD sure
            ELSE
               IF tm.sure matches'[nN]' THEN 
                  LET l_jump = 'Y'
                  EXIT INPUT 
               END IF
            END IF
       
         AFTER FIELD item 
            IF tm.item IS NULL OR tm.item = ' ' THEN
               NEXT FIELD item 
            ELSE
               SELECT ima08 FROM ima_file
                WHERE ima01 = tm.item 
                  AND ima08 IN ('A','C')
               IF SQLCA.sqlcode != 0 THEN 
#                 CALL cl_err(tm.item,'mfg0026',0)   #No.FUN-660138
                  CALL cl_err3("sel","ima_file",tm.item,"","mfg0026","","",0) #No.FUN-660138
                  NEXT FIELD item
               END IF
               SELECT count(*) INTO g_cnt FROM bmb_file 
                                WHERE bmb01 = tm.item
               IF g_cnt <= 0 THEN CALL cl_err(tm.item,'mfg2601',0)
                                  NEXT FIELD item
               END IF
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
     
         ON ACTION CONTROLG
             CALL cl_cmdask()
     
         ON ACTION exit    #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION locale  #genero
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
      END INPUT
      
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG  OR l_jump = 'Y' THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p500_w 
         RETURN 
      ELSE
         #---genero
         IF cl_sure(21,21) THEN
            CALL cl_wait()
         
            CALL p500()
            ERROR ""
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               EXIT WHILE
            END IF
         END IF
         #---genero
      END IF
      ERROR ""
 
   END WHILE
   CLOSE WINDOW p500_w
 
END FUNCTION
   
FUNCTION p500()
  DEFINE l_bmb02   LIKE bmb_file.bmb02,
         l_bmb03   LIKE bmb_file.bmb03,
         l_bmb04   LIKE bmb_file.bmb04,
         l_bmb05   LIKE bmb_file.bmb05,
         l_sql     LIKE type_file.chr1000,  #No.FUN-690010 VARCHAR(200)
         l_cnt     LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   LET l_sql = "SELECT bmb02 , bmb03, bmb04, bmb05 ",
               " FROM bmb_file "
   IF tm.gdate IS NULL OR tm.gdate = ' ' THEN 
         LET l_sql = l_sql clipped," WHERE bmb01 ='", tm.item,"'"
    ELSE LET l_sql = l_sql  clipped,
                  " WHERE bmb01 ='", tm.item,"'",
                  " AND (bmb04 <='", tm.gdate,"'"," OR bmb04 IS NULL )",
                  " AND (bmb05 > '", tm.gdate,"'"," OR bmb05 IS NULL )"
   END IF
   PREPARE p500_per FROM l_sql
   DECLARE p500_cur CURSOR FOR p500_per
   LET l_cnt = 1
   LET g_success="Y"
   FOREACH p500_cur INTO l_bmb02,l_bmb03,l_bmb04,l_bmb05
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach error',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      IF l_cnt = 1 THEN 
         DELETE FROM rpe_file WHERE rpe01 = tm.item 
         IF SQLCA.sqlcode THEN 
#           CALL cl_err('delete rpe_file error',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("del","rpe_file",tm.item,"",SQLCA.sqlcode,"","delete rpe_file error",0) #No.FUN-660138
         ELSE
            MESSAGE 'Delete rep_file OK  ..........'
            CALL ui.Interface.refresh()
         END IF
      END IF
      INSERT INTO rpe_file(rpe01,rpe02,rpe03,rpe04,rpe05) 
                  VALUES(tm.item,l_bmb02,l_bmb03,l_bmb04,l_bmb05)
      IF SQLCA.sqlcode THEN 
#        CALL cl_err('insert error rpe_file',SQLCA.sqlcode,0)    #No.FUN-660138
         CALL cl_err3("ins","rpe_file",tm.item,l_bmb02,SQLCA.sqlcode,"","insert error rpe_file",0) #No.FUN-660138
         LET g_success="N"
      ELSE
         MESSAGE  tm.item,' ',l_bmb02,' ',l_bmb03,' ',l_bmb04,' ',l_bmb05
         CALL ui.Interface.refresh()
      END IF
      LET l_cnt = l_cnt +1
   END FOREACH 
 
END FUNCTION
