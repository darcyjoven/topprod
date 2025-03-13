# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Patterr name...: asdp190.4gl
# Descriptions...: 單位成本表計算作業
# Date & Author..: 99/12/03 By Eric
 # Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大                                       
# Modify.........: No.FUN-5100337 05/01/19 By pengu 報表轉XML
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify ........: No.FUN-570150 06/03/13 By yiting 批次背景執行
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-C50140 12/05/21 By ck2yuan 抓取bom資料應串主件於aimi100的主特性代碼
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
          g_tta RECORD LIKE tta_file.*,
          g_ttb RECORD LIKE ttb_file.*,
          g_ttc RECORD LIKE ttc_file.*,
          g_stg RECORD LIKE stg_file.*
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(400),    # Where condition
              bdate   LIKE type_file.dat,          #No.FUN-690010DATE,
              edate   LIKE type_file.dat,          #No.FUN-690010DATE,
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              ryea    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              rm      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              ma      LIKE alb_file.alb06,         #No.FUN-690010dec(20,6),
              la      LIKE alb_file.alb06,         #No.FUN-690010dec(20,6),
              oh      LIKE alb_file.alb06,         #No.FUN-690010dec(20,6),
              ot      LIKE alb_file.alb06,         #No.FUN-690010dec(20,6),
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_effdate     LIKE type_file.dat,          #No.FUN-690010DATE,
          g_err         LIKE type_file.chr1000       #No.FUN-690010CHAR(80)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_flag          LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE   ls_date         STRING,                  #No.FUN-570150
         g_date          LIKE type_file.dat,           #No.FUN-690010DATE,                    #NO.FUN-570150
         g_change_lang   LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)                 #NO.FUN-570150 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
#NO.FUN-570150 start--
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = 'N'
    END IF
#NO.FUN-570150 end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL asdp190_tm(4,15)        # Input print condition
      ELSE CALL asdp190()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION asdp190_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
            l_name        LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20)
            l_za05        LIKE za_file.za05,
            l_cmd         LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
 
   LET p_row = 3 LET p_col = 30


   OPEN WINDOW asdp190_w AT p_row,p_col WITH FORM "asd/42f/asdp190" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea  = YEAR(g_today)
   LET tm.ryea = YEAR(g_today)
   LET tm.rm   = 12
   LET tm.ma   = 0
   LET tm.la   = 0
   LET tm.oh   = 0
   LET tm.ot   = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      #INPUT BY NAME tm.yea,tm.ryea,tm.rm,tm.ma,tm.la,tm.oh,tm.ot WITHOUT DEFAULTS 
      INPUT BY NAME tm.yea,tm.ryea,tm.rm,tm.ma,tm.la,tm.oh,tm.ot,
                    g_bgjob  #NO.FUN-570150 
        WITHOUT DEFAULTS 
 
         AFTER FIELD yea
            IF tm.yea IS NULL OR tm.yea=0 THEN
               NEXT FIELD yea
            END IF
            LET tm.ryea=tm.yea
            DISPLAY BY NAME tm.ryea
         
         AFTER FIELD ryea
            IF tm.ryea IS NULL OR tm.ryea=0 THEN
               NEXT FIELD ryea
            END IF
 
         AFTER FIELD rm
            IF tm.rm IS NULL OR tm.rm=0 OR tm.rm < 1 OR tm.rm >12 THEN
               NEXT FIELD rm
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON ACTION locale                    #genero
#NO.FUN-570150 mark
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570150 mark
            LET g_change_lang = TRUE                 #NO.FUN-570150
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
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
 
#NO.FUN-570150 start--
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
#NO.FUN-570150 end--
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW asdp190_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='asdp190'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asdp190','9031',1)   
            
         ELSE
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('asdp190',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW asdp190_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF cl_sure(16,20) THEN
         CALL cl_wait()
         LET g_copies= '1'
         SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
         CALL cl_outnam('asdp190') RETURNING l_name
         START REPORT asdp190_rep TO l_name
         LET g_pageno = 0
            CALL asdp190()
 
            FINISH REPORT asdp190_rep
            CALL cl_prt(l_name,g_prtway,g_copies,g_len)
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
         END IF
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            #No.FUN-570150--start------
            IF g_bgjob = 'Y' THEN
               CALL cl_batch_bg_javamail(g_success)    #No.FUN-570150
            END IF
            #No.FUN-570150--end--------
            EXIT WHILE
         END IF
      END IF
      EXIT WHILE
      ERROR ""
   END WHILE
 
   CLOSE WINDOW asdp190_w
  
END FUNCTION
 
FUNCTION asdp190()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0089
          l_tot     LIKE type_file.num10,        #No.FUN-690010INTEGER,
          l_cnt     LIKE type_file.num10,        #No.FUN-690010INTEGER,
          l_tta04   LIKE tta_file.tta04,    #DECIMAL(14,2),
          l_tta05   LIKE tta_file.tta07,    #DECIMAL(14,2),
          l_tta06   LIKE tta_file.tta07,    #DECIMAL(14,2),
          l_tta07   LIKE tta_file.tta07,    #DECIMAL(14,2),
          l_ttb07   LIKE ttb_file.ttb07,    #DECIMAL(14,2),
          l_ma      LIKE alb_file.alb06,         #No.FUN-690010dec(20,6),
          l_la      LIKE alb_file.alb06,         #No.FUN-690010dec(20,6),
          l_oh      LIKE alb_file.alb06,         #No.FUN-690010dec(20,6),
          l_ot      LIKE alb_file.alb06,         #No.FUN-690010dec(20,6),
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(800)
          l_base    LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
          l_diff    LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
           l_ima01   LIKE ima_file.ima01,  #No.MOD-490217
          l_ima131  LIKE cre_file.cre08,         #No.FUN-690010CHAR(10),
          l_ima06   LIKE ima_file.ima06,         #No.FUN-690010CHAR(4), #TQC-840066
          l_ima09   LIKE ima_file.ima09,         #No.FUN-690010CHAR(4), #TQC-840066
          l_err     LIKE type_file.chr1000,      #No.FUN-690010CHAR(80),
          l_n       LIKE type_file.num10   #No.FUN-690010 INTEGER
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
 
     LET g_success='Y'
     BEGIN WORK
     LET g_effdate=MDY(12,31,tm.yea)          
     LET g_tta.tta01=tm.yea
     LET g_tta.ttaplant = g_plant #FUN-980008 add
     LET g_tta.ttalegal = g_legal #FUN-980008 add
     LET g_ttc.ttcplant = g_plant #FUN-980008 add
     LET g_ttc.ttclegal = g_legal #FUN-980008 add
 
#No.MOD-580325-begin                                                           
     CALL cl_err('','asd-001',0)                                                
#    MESSAGE '01.清除相關資料'                                                  
#No.MOD-580325-end          
     CALL ui.Interface.refresh()
     DELETE FROM tta_file WHERE tta01=tm.yea
     DELETE FROM ttb_file WHERE ttb01=tm.yea
     DELETE FROM ttc_file WHERE ttc01=tm.yea
     DECLARE stg_cur CURSOR FOR 
      SELECT ima01,ima131,stg_file.* FROM stg_file, sfb_file, ima_file, imd_file
       WHERE stg02=tm.yea AND stg04=sfb01 AND sfb05=ima01 
         AND stg20=imd01 AND imd09='Y'
         AND stg01 <> '5'
     FOREACH stg_cur INTO l_ima01,l_ima131,g_stg.*
       IF STATUS <> 0 THEN 
          LET g_success='N'
          EXIT FOREACH 
       END IF
       IF g_bgjob = 'N' THEN         #No.FUN-570150
           MESSAGE g_stg.stg04,' ',g_stg.stg05
           CALL ui.Interface.refresh()
       END IF
       LET g_tta.tta02=l_ima131
       SELECT * FROM tta_file WHERE tta01=g_tta.tta01 AND tta02=g_tta.tta02
       IF STATUS <> 0 THEN
          LET g_tta.tta03=g_stg.stg07
          LET g_tta.tta04=g_stg.stg08*g_stg.stg07
          LET g_tta.tta05=g_stg.stg09*g_stg.stg07
          LET g_tta.tta06=g_stg.stg10*g_stg.stg07
          LET g_tta.tta07=g_stg.stg11*g_stg.stg07
          LET g_tta.tta08=0
          LET g_tta.tta09=0
          LET g_tta.tta10=0
          LET g_tta.tta11=0
          INSERT INTO tta_file VALUES(g_tta.*)
       ELSE
          UPDATE tta_file 
             SET tta03=tta03+g_stg.stg07,
                 tta04=tta04+g_stg.stg08*g_stg.stg07,
                 tta05=tta05+g_stg.stg09*g_stg.stg07,
                 tta06=tta06+g_stg.stg10*g_stg.stg07,
                 tta07=tta07+g_stg.stg11*g_stg.stg07
           WHERE tta01=g_tta.tta01 AND tta02=g_tta.tta02
           IF SQLCA.SQLCODE THEN
              LET g_success='N'
#             CALL cl_err('up_tta_file',SQLCA.SQLCODE,0)   #No.FUN-660120
              CALL cl_err3("upd","tta_file",g_tta.tta01,g_tta.tta02,SQLCA.sqlcode,"","up_tta_file",0)   #No.FUN-660120
              EXIT FOREACH
           END IF
       END IF
       LET g_ttc.ttc01=g_tta.tta01
       LET g_ttc.ttc02=g_tta.tta02
       LET g_ttc.ttc03=l_ima01
       LET g_ttc.ttc04=g_stg.stg07
       SELECT * FROM ttc_file 
        WHERE ttc01=g_tta.tta01 AND ttc02=g_tta.tta02 AND ttc03=l_ima01
       IF STATUS <> 0 THEN
          INSERT INTO ttc_file VALUES(g_ttc.*)
       ELSE
          UPDATE ttc_file 
             SET ttc04=ttc04+g_stg.stg07
           WHERE ttc01=g_ttc.ttc01 AND ttc02=g_ttc.ttc02 AND ttc03=g_ttc.ttc03 
           IF SQLCA.SQLCODE THEN
              LET g_success='N'
#             CALL cl_err('up_ttc_file',SQLCA.SQLCODE,0)   #No.FUN-660120
              CALL cl_err3("upd","ttc_file",g_ttc.ttc01,g_ttc.ttc02,SQLCA.sqlcode,"","up_ttc_file",0)   #No.FUN-660120
              EXIT FOREACH
           END IF
       END IF  
     END FOREACH
#No.MOD-580325-begin                                                           
     CALL cl_err('','asd-002',0)                                                
#    MESSAGE '02.分攤成本'                                                      
#No.MOD-580325-end      
     CALL ui.Interface.refresh()
     SELECT COUNT(*),SUM(tta04),SUM(tta05),SUM(tta06),SUM(tta07)
       INTO l_tot,l_tta04,l_tta05,l_tta06,l_tta07
       FROM tta_file WHERE tta01=g_tta.tta01
     LET l_cnt=1
     LET l_ma=tm.ma
     LET l_la=tm.la
     LET l_oh=tm.oh
     LET l_ot=tm.ot
     DECLARE tta_cur CURSOR FOR
       SELECT * FROM tta_file WHERE tta01=g_tta.tta01
     FOREACH tta_cur INTO g_tta.*
       IF STATUS <> 0 THEN LET g_success='N' EXIT FOREACH END IF
       LET l_err=l_cnt USING '&&&&','/', l_tot USING '&&&&',' ',g_tta.tta02
       IF g_bgjob = 'N' THEN         #No.FUN-570150
           MESSAGE l_err
           CALL ui.Interface.refresh()
       END IF
       IF l_cnt < l_tot THEN
          LET g_tta.tta08=tm.ma*g_tta.tta04/l_tta04
          LET g_tta.tta09=tm.la*g_tta.tta05/l_tta05
          LET g_tta.tta10=tm.oh*g_tta.tta06/l_tta06
          LET g_tta.tta11=tm.ot*g_tta.tta07/l_tta07
          LET l_ma=l_ma - g_tta.tta08
          LET l_la=l_la - g_tta.tta09
          LET l_oh=l_oh - g_tta.tta10
          LET l_ot=l_ot - g_tta.tta11
          UPDATE tta_file
             SET tta08=g_tta.tta08, tta09=g_tta.tta09,
                 tta10=g_tta.tta10, tta11=g_tta.tta11
           WHERE tta01=g_tta.tta01 AND tta02=g_tta.tta02
           IF SQLCA.SQLCODE THEN
              LET g_success='N'
#             CALL cl_err('up_tta_file',SQLCA.SQLCODE,0)   #No.FUN-660120
              CALL cl_err3("upd","tta_file",g_tta.tta01,g_tta.tta02,SQLCA.sqlcode,"","up_tta_file",0)   #No.FUN-660120
              EXIT FOREACH
           END IF
       ELSE
          UPDATE tta_file
             SET tta08=l_ma,tta09=l_la,tta10=l_oh,tta11=l_ot
           WHERE tta01=g_tta.tta01 AND tta02=g_tta.tta02
           IF SQLCA.SQLCODE THEN
              LET g_success='N'
#             CALL cl_err('up_tta_file',SQLCA.SQLCODE,0)   #No.FUN-660120
              CALL cl_err3("upd","tta_file",g_tta.tta01,g_tta.tta02,SQLCA.sqlcode,"","up_tta_file",0)   #No.FUN-660120
              EXIT FOREACH
           END IF
          EXIT FOREACH
       END IF
       LET l_cnt=l_cnt+1
     END FOREACH
 
 
# 計算直接原料明細表
     DECLARE tta_cur1 CURSOR FOR
      SELECT * FROM tta_file WHERE tta01=tm.yea
     FOREACH tta_cur1 INTO g_tta.*
       IF STATUS <> 0 THEN LET g_success='N' EXIT FOREACH END IF
       DECLARE ttc_cur CURSOR FOR
        SELECT ttc03,ttc04 FROM ttc_file 
         WHERE ttc01=g_tta.tta01 AND ttc02=g_tta.tta02 ORDER BY ttc04 DESC
       OPEN ttc_cur 
       FETCH ttc_cur INTO l_ima01
       IF STATUS <> 0 THEN
          CLOSE ttc_cur
          CONTINUE FOREACH
       END IF
       CLOSE ttc_cur
       #FUN-550110
       LET l_ima910=''
       SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=l_ima01
       IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
       #--
       CALL p190_bom(0,l_ima01,l_ima910,g_tta.tta03)        
     END FOREACH
     UPDATE ttb_file SET ttb07=ttb05*ttb06 WHERE ttb01=tm.yea
     IF SQLCA.SQLCODE THEN
        LET g_success='N'
#       CALL cl_err('up_ttb_file',SQLCA.SQLCODE,0)   #No.FUN-660120
        CALL cl_err3("upd","ttb_file",tm.yea,"",SQLCA.sqlcode,"","up_ttb_file",0)   #No.FUN-660120
        RETURN 
     END IF
 
     DECLARE tta_cur2 CURSOR FOR
      SELECT * FROM tta_file WHERE tta01=tm.yea
     FOREACH tta_cur2 INTO g_tta.*
       IF STATUS <> 0 THEN LET g_success='N' EXIT FOREACH END IF
       LET l_ma=g_tta.tta08
       SELECT COUNT(*),SUM(ttb07) INTO l_tot,l_ttb07 FROM ttb_file 
        WHERE ttb01=g_tta.tta01 AND ttb02=g_tta.tta02
       LET l_cnt=1
       DECLARE ttb_cur CURSOR FOR
        SELECT * FROM ttb_file 
         WHERE ttb01=g_tta.tta01 AND ttb02=g_tta.tta02
       FOREACH ttb_cur INTO g_ttb.*
         IF STATUS <> 0 THEN EXIT FOREACH END IF
         LET l_err=l_cnt USING '&&&&','/', l_tot USING '&&&&',' ',g_ttb.ttb03
         IF g_bgjob = 'N' THEN         #No.FUN-570150
             MESSAGE l_err
             CALL ui.Interface.refresh()
         END IF
         LET g_ttb.ttb04=g_ttb.ttb05/g_tta.tta03
         IF l_cnt < l_tot THEN
            LET g_ttb.ttb08=g_tta.tta08*g_ttb.ttb07/l_ttb07
            LET l_ma=l_ma - g_ttb.ttb08
            UPDATE ttb_file SET ttb08=g_ttb.ttb08,ttb04=g_ttb.ttb04
             WHERE ttb01=g_ttb.ttb01 AND ttb02=g_ttb.ttb02 
               AND ttb03=g_ttb.ttb03 
            IF SQLCA.SQLCODE THEN
              LET g_success='N'
#             CALL cl_err('up_ttb_file',SQLCA.SQLCODE,0)   #No.FUN-660120
              CALL cl_err3("upd","ttb_file",g_ttb.ttb01,g_ttb.ttb02,SQLCA.sqlcode,"","up_ttb_file",0)   #No.FUN-660120
              EXIT FOREACH
            END IF
         ELSE
            UPDATE ttb_file SET ttb08=l_ma,ttb04=g_ttb.ttb04
             WHERE ttb01=g_ttb.ttb01 AND ttb02=g_ttb.ttb02 
               AND ttb03=g_ttb.ttb03 
            IF SQLCA.SQLCODE THEN
              LET g_success='N'
#             CALL cl_err('up_ttb_file',SQLCA.SQLCODE,0)   #No.FUN-660120
              CALL cl_err3("upd","ttb_file",g_ttb.ttb01,g_ttb.ttb02,SQLCA.sqlcode,"","up_ttb_file",0)   #No.FUN-660120
              EXIT FOREACH
            END IF
            LET l_ma=0
            EXIT FOREACH
         END IF
         LET l_cnt=l_cnt+1
       END FOREACH
       LET g_err=g_x[20] clipped,
                 g_tta.tta02,' ',g_tta.tta08 USING '###,###,##&.&&'
       OUTPUT TO REPORT asdp190_rep(g_err)
     END FOREACH
 
END FUNCTION
 
FUNCTION p190_bom(p_level,p_key,p_key2,p_total)  #FUN-550110
   DEFINE p_level       LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          p_total       LIKE alb_file.alb06,         #No.FUN-690010DECIMAL(20,6),
          l_total       LIKE alb_file.alb06,         #No.FUN-690010DECIMAL(20,6),
          p_key         LIKE bma_file.bma01,  #主件料件編號
          p_key2        LIKE ima_file.ima910,   #FUN-550110
          l_ac,i        LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          arrno         LIKE type_file.num5,         #No.FUN-690010SMALLINT,       #BUFFER SIZE (可存筆數)
          b_seq         LIKE type_file.num10,        #No.FUN-690010INTEGER,        #當BUFFER滿時,重新讀單身之起始序號
          l_chr         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_ima06 LIKE ima_file.ima06,    #分群碼
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb01 LIKE bmb_file.bmb01,    #本階主件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb14 LIKE bmb_file.bmb14,    #
              bmb15 LIKE bmb_file.bmb15,    #
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb17 LIKE bmb_file.bmb17,    #
              ima08 LIKE ima_file.ima08     #來源
          END RECORD,
          l_cmd         LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(602)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1) RETURN
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
       INITIALIZE sr[1].* TO NULL
       LET sr[1].bmb03 = p_key
    END IF
    LET arrno = 400
 
    WHILE TRUE
        LET l_cmd=
            "SELECT bma01, bmb01, bmb02, bmb03, bmb04, bmb05,",
            "       (bmb06/bmb07),  bmb08, bmb10,",
            "       bmb14, bmb15, bmb16, bmb17,ima08",
           #"  FROM bmb_file LEFT OUTER JOIN ima_file ON bmb_file.bmb03=ima_file.ima01 LETF OUTER JOIN bma_file ON bmb_file.bmb03=bma_file.bma01 ",  #MOD-C50140 mark
            "  FROM bmb_file,ima_file,bma_file " ,       #MOD-C50140 add
            " WHERE bmb01='", p_key,"'",
            "   AND bmb29 ='",p_key2,"' ",  #FUN-550110
           #MOD-C50140 str add-----
            "   AND bma06=bmb29 AND bmb29=ima910 ",
            "   AND bmb_file.bmb01=ima_file.ima01 ",
            "   AND bmb_file.bmb01=bma_file.bma01 ",
           #MOD-C50140 end add-----           
            "   AND (bmb04 <='",g_effdate,"' OR bmb04 IS NULL)",
            "   AND (bmb05 >'",g_effdate, "' OR bmb05 IS NULL)"
 
        PREPARE p190_prebmb  FROM l_cmd
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211           
           EXIT PROGRAM
        END IF
        DECLARE p190_curbmb CURSOR FOR p190_prebmb
 
        LET l_ac = 1
        FOREACH p190_curbmb INTO sr[l_ac].*        # 先將BOM單身存入BUFFER
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03 
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END-
            LET l_ac = l_ac + 1                 # 但BUFFER不宜太大
            IF l_ac = arrno THEN EXIT FOREACH END IF
         END FOREACH
         FOR i = 1 TO l_ac-1                    # 讀BUFFER傳給REPORT
           #尾階在展開時, 其展開之
            IF sr[i].bma01 IS NOT NULL THEN         #若為主件(有BOM單頭)
               #CALL p190_bom(p_level,sr[i].bmb03,' ',p_total*sr[i].bmb06)  #FUN-550110#FUN-8B0035
                CALL p190_bom(p_level,sr[i].bmb03,l_ima910[i],p_total*sr[i].bmb06)  #FUN-8B0035
            ELSE
                LET l_total=p_total*sr[i].bmb06
                LET g_ttb.ttb01=tm.yea
                LET g_ttb.ttb02=g_tta.tta02
                LET g_ttb.ttb03=sr[i].bmb03
                IF g_bgjob = 'N' THEN         #No.FUN-570150
                    MESSAGE g_ttb.ttb03
                    CALL ui.Interface.refresh()
                END IF
                SELECT * FROM ttb_file 
                 WHERE ttb01=g_ttb.ttb01 AND ttb02=g_ttb.ttb02
                   AND ttb03=g_ttb.ttb03
                IF STATUS <> 0 THEN
                   LET g_ttb.ttb04=0
                   LET g_ttb.ttb05=l_total
                   IF l_total <> 0 THEN
                      SELECT stb07+stb08+stb09+stb09a INTO g_ttb.ttb06 
                        FROM stb_file
                       WHERE stb01 = g_ttb.ttb03 AND stb02 = tm.ryea 
                         AND stb03 = tm.rm
                      IF g_ttb.ttb06 IS NULL THEN LET g_ttb.ttb06=0 END IF
                      LET g_ttb.ttb07=0
                      LET g_ttb.ttb08=0
                      LET g_ttb.ttbplant = g_plant #FUN-980008 add
                      LET g_ttb.ttblegal = g_legal #FUN-980008 add
                      INSERT INTO ttb_file VALUES(g_ttb.*)
                   END IF
                ELSE
                   UPDATE ttb_file SET ttb05=ttb05+l_total
                    WHERE ttb01=g_ttb.ttb01 AND ttb02=g_ttb.ttb02
                      AND ttb03=g_ttb.ttb03
                END IF
            END IF
        END FOR
        IF l_ac < arrno THEN                        # BOM單身已讀完
            EXIT WHILE
        END IF
    END WHILE
END FUNCTION
 
REPORT asdp190_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
          sr        RECORD 
                    text    LIKE type_file.chr1000       #No.FUN-690010CHAR(80)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
# ORDER BY sr.text
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31] clipped 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.text
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
