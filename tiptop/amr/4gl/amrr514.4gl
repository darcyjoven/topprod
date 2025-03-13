# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: amrr514.4gl
# Descriptions...: MRP交期提前建議表
# Input parameter: 
# Return code....: 
# Date & Author..: 05/08/01 By Hay
# Modify.........: No.FUN-570081 05/08/30 By vivien 6X轉GP版本
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-850143 08/06/06 By lutingting報表轉為使用CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-890230 08/12/22 By Pengu 報表列印時請採單號會被截掉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10162 10/02/03 By Smapmin 轉為CR報表時,變數使用錯誤
# Modify.........: No:MOD-A10180 10/02/03 By Smapmin 一個時距提前到二個以上的時距時,報表列印有誤.
# Modify.........: No:MOD-A40096 10/07/21 By Pengu 交期調整建議應考慮調整百分比
# Modify.........: No:MOD-CA0067 12/10/10 By suncx 修正MOD-A10180改錯的sql
# Modify.........: No:CHI-C50068 12/11/05 By bart 將amrr514與amrr532合併成一個報表

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      STRING,     # Where condition  TQC-630166  
             #n       VARCHAR(1),                   #TQC-610074        
              ver_no  LIKE mss_file.mss_v,       #NO.FUN-680082 VARCHAR(1)
              sdate   LIKE type_file.dat,        #CHI-C50068
              edate   LIKE type_file.dat,        #NO.FUN-680082 DATE 
              type    LIKE type_file.chr1,       #CHI-C50068
              per     LIKE type_file.num5,       #NO.FUN-680082 SMALLINT 
              more    LIKE type_file.chr1        # Input more condition(Y/N)   #NO.FUN-680082 VARCHAR(1)        
              END RECORD
   DEFINE  g_sql      STRING          #No.FUN-850143
   DEFINE  g_str      STRING          #No.FUN-850143
   DEFINE  l_table    STRING          #No.FUN-850143
   
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CONTINUE
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
   
   #No.FUN-850143-----start--
   LET g_sql = "ima43.ima_file.ima43,", 
               "gen02.gen_file.gen02,", 
               "mss041.mss_file.mss041,",
               "mss043.mss_file.mss043,",
               "mss044.mss_file.mss044,",
               "mss051.mss_file.mss051,",
               "mss052.mss_file.mss052,",
               "mss053.mss_file.mss053,",
               "mss063.mss_file.mss063,",
               "mss064.mss_file.mss064,",
               "mss065.mss_file.mss065,",
               "mss09.mss_file.mss09,", 
               "mss01.mss_file.mss01,", 
               "ima02.ima_file.ima02,", 
               "ima25.ima_file.ima25,", 
               "mss00.mss_file.mss00,", 
               "mss03.mss_file.mss03,", 
               "mss072.mss_file.mss072,",
               "mss071.mss_file.mss071,",
               "mst08.mst_file.mst08,", 
               "mst06.mst_file.mst06,", 
               "mst061.mst_file.mst061,",
               "mst04.mst_file.mst04,", 
			   "difference.type_file.chr10,", #CHI-C50068
               "l_vender.pmm_file.pmm09,",
               "pmc03.pmc_file.pmc03,", 
               "mss02.mss_file.mss02" 
   LET l_table = cl_prt_temptable('amrr514',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?)"	  #CHI-C50068
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF
   #No.FUN-850143-----end
   LET g_trace = 'N'                # default trace off
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ver_no = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.per = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   IF cl_null(g_bgjob) OR g_bgjob='N'    # If background job sw is off
      THEN CALL amrr514_tm(0,0)          # Input print condition
      ELSE CALL amrr514()                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr514_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
 
IF p_row = 0 THEN LET p_row = 4 LET p_col = 13 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 12
   ELSE LET p_row = 4 LET p_col = 13
   END IF
 
   OPEN WINDOW amrr514_w AT p_row,p_col WITH FORM "amr/42f/amrr514"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.n   = '2'                  #TQC-610074
   LET tm.type = '1'                  #CHI-C50068
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.per = 20 
 
WHILE TRUE
CONSTRUCT BY NAME tm.wc ON mss01,ima67,mss02,ima08,ima43
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
        IF INFIELD(mss01) THEN                                                                                                  
           CALL cl_init_qry_var()                                                                                               
           LET g_qryparam.form = "q_ima"                                                                                       
           LET g_qryparam.state = "c"                                                                                           
           CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
           DISPLAY g_qryparam.multiret TO mss01                                                                                 
           NEXT FIELD mss01                                                                                                     
        END IF  
 
     ON ACTION locale
        LET g_action_choice = "locale"
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about         
        CALL cl_about()     
 
     ON ACTION help         
        CALL cl_show_help()
 
     ON ACTION controlg    
        CALL cl_cmdask()  
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW amrr514_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
           
     END IF
 
     DISPLAY BY NAME tm.ver_no,tm.per,tm.sdate,tm.edate,tm.type,tm.more                 #CHI-C50068
     INPUT BY NAME tm.ver_no,tm.per,tm.sdate,tm.edate,tm.type,tm.more WITHOUT DEFAULTS  #CHI-C50068
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 		#CHI-C50068---begin
        AFTER FIELD edate                                                               
           IF ((not cl_null(tm.edate)) AND (tm.edate<tm.sdate)) THEN
              CALL cl_err(tm.edate,'aap-100',0)
              NEXT FIELD edate
           END IF
 
        AFTER FIELD type
           IF cl_null(tm.type) THEN
              CALL cl_err(tm.type,'aec-019',0)
              NEXT FIELD type
           END IF                                                                       
		#CHI-C50068---end
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
     ON ACTION CONTROLG 
        CALL cl_cmdask()    # Command execution
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
   
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     END INPUT
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        CLOSE WINDOW amrr514_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
         WHERE zz01='amrr514'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('amrr514','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           " '",g_lang CLIPPED,"'",
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           " '",tm.ver_no CLIPPED,"'",
                           " '",tm.sdate CLIPPED,"'",       #CHI-C50068
                           " '",tm.edate CLIPPED,"'",
                           " '",tm.type CLIPPED,"'",        #CHI-C50068
                           " '",tm.per CLIPPED,"'",
                           " '",g_rep_user CLIPPED,"'",          
                           " '",g_rep_clas CLIPPED,"'",           
                           " '",g_template CLIPPED,"'"           
           IF g_trace = 'Y' THEN ERROR l_cmd END IF
           CALL cl_cmdat('amrr514',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW amrr514_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL amrr514()
     ERROR ""
END WHILE
     CLOSE WINDOW amrr514_w
END FUNCTION
 
FUNCTION amrr514()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name      #NO.FUN-680082 VARCHAR(20)         
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT               #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,        #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,     #NO.FUN-680082 VARCHAR(40)
          l_order   LIKE type_file.chr1000,     #NO.FUN-680082 VARCHAR(20)
          l_bal,l_qty,l_move  LIKE mss_file.mss061,
          l_begin   LIKE type_file.chr1,        #NO.FUN-680082 VARCHAR(01)
          mss   RECORD LIKE mss_file.*,
          mss_o RECORD LIKE mss_file.*,
          mst   RECORD LIKE mst_file.*,
          ima   RECORD      
                  ima02  LIKE ima_file.ima02,
                  ima08  LIKE ima_file.ima08,
                  ima25  LIKE ima_file.ima25,
                  ima43  LIKE ima_file.ima43
                END RECORD,
          ima_o RECORD      
                  ima02  LIKE ima_file.ima02,
                  ima08  LIKE ima_file.ima08,
                  ima25  LIKE ima_file.ima25,
                  ima43  LIKE ima_file.ima43
                END RECORD
  
  #No.FUN-850143------start--
  DEFINE l_gen02  LIKE gen_file.gen02 
  DEFINE l_pono   LIKE pmm_file.pmm01 
  DEFINE l_prno   LIKE pmm_file.pmm01 
  DEFINE l_vender LIKE pmm_file.pmm09 
  DEFINE l_pmc03  LIKE pmc_file.pmc03 
  #-----MOD-A10180---------
  DEFINE sss      DYNAMIC ARRAY OF RECORD LIKE mss_file.*   
  DEFINE i,j,k    LIKE type_file.num10   
  DEFINE l_mst08  LIKE mst_file.mst08    
  DEFINE l_mst081 LIKE mst_file.mst08    
  DEFINE l_mst05  LIKE mst_file.mst05    
  DEFINE l_mst06  LIKE mst_file.mst06    
  DEFINE l_mst061 LIKE mst_file.mst061   
  DEFINE l_mst04  LIKE mst_file.mst04    
  DEFINE l_datedf LIKE type_file.num5  #CHI-C50068
  DEFINE l_difference LIKE type_file.chr10  #CHI-C50068

  DROP TABLE r514_tmp
  CREATE TEMP TABLE r514_tmp(
          mst_v LIKE mst_file.mst_v,
          mst01 LIKE mst_file.mst01,
          mst02 LIKE mst_file.mst02,
          mst03 LIKE mst_file.mst03,
          mst08 LIKE mst_file.mst08,
          mst06 LIKE mst_file.mst06,
          mst061 LIKE mst_file.mst061)
  #-----END MOD-A10180-----
  
  CALL cl_del_data(l_table)  #MOD-A10180                                                                                                     
  
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amrr514' 
  #No.FUN-850143------end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #-----MOD-A10180---------
     #LET l_sql = "SELECT mss_file.*,ima02,ima08,ima25,ima43",  
     #            "  FROM mss_file, ima_file",
     #            " WHERE ",tm.wc,
     #            "   AND mss01=ima01 ",
     #            "   AND mss_v='",tm.ver_no CLIPPED,"'",
     #            "   AND mss03<='",tm.edate,"'",
     #            "   ORDER BY mss01,mss02,mss03"
     #LET l_sql = "SELECT *",                #MOD-CA0067 mark
     #            "  FROM mss_file",         #MOD-CA0067 mark
     LET l_sql = "SELECT mss_file.*",        #MOD-CA0067 add
                 "  FROM mss_file LEFT JOIN ima_file ON ima01=mss01",  #MOD-CA0067 add
                 " WHERE ",tm.wc,
                 "   AND mss_v='",tm.ver_no CLIPPED,"'",
                 "   AND mss03>='",tm.sdate,"'",            #CHI-C50068
                 "   AND mss03<='",tm.edate,"'",
                 "   ORDER BY mss01,mss02,mss03"
     #-----END MOD-A10180-----
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE amrr514_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrr514_curs1 CURSOR FOR amrr514_prepare1
 
     LET l_sql = "SELECT *  FROM mst_file ",
                 " WHERE (mst05='61' OR mst05='62' OR mst05='63')",
                 "   AND mst_v = '",tm.ver_no CLIPPED,"'",
                 "   AND mst01=? AND mst02=? ",
                 "   AND mst03=? AND mst_v=?  ORDER BY mst06,mst061"
     PREPARE r514_premst  FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE r514_curmst CURSOR FOR r514_premst 
 
     #CALL cl_outnam('amrr514') RETURNING l_name     #No.FUN-850143
  
     #START REPORT amrr514_rep TO l_name    #No.FUN-850143
     LET g_pageno = 0 LET mss_o.mss01 = ' '
     #-----MOD-A10180-----
     #FOREACH amrr514_curs1 INTO mss.*, ima.* 
     #  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #  LET l_qty = mss.mss061+mss.mss062 + mss.mss063
     #  LET l_bal = mss.mss071-mss.mss072
     #  IF mss.mss01!=mss_o.mss01 THEN LET l_move=0 END IF 
     #  IF l_move<=0 THEN LET mss_o.* =mss.* LET ima_o.*=ima.* LET l_move=0 END IF 
     #  IF l_bal<0 THEN LET l_move=l_move-l_bal
     #     IF mss.mss03!= mss_o.mss03 THEN
     #        LET mss_o.mss043=mss_o.mss043+mss.mss043
     #        LET mss_o.mss041=mss_o.mss041+mss.mss041
     #        LET mss_o.mss044=mss_o.mss044+mss.mss044
     #        LET mss_o.mss051=mss_o.mss051+mss.mss051
     #        LET mss_o.mss052=mss_o.mss052+mss.mss052
     #        LET mss_o.mss053=mss_o.mss053+mss.mss053
     #        LET mss_o.mss061=mss_o.mss061+mss.mss061
     #        LET mss_o.mss062=mss_o.mss062+mss.mss062
     #        LET mss_o.mss063=mss_o.mss063+mss.mss063
     #        LET mss_o.mss064=mss_o.mss064+mss.mss064
     #        LET mss_o.mss065=mss_o.mss065+mss.mss065
     #        LET mss_o.mss09=mss_o.mss09+mss.mss09
     #     END IF 
     #  ELSE
     #     IF l_move>0 THEN
     #        IF l_qty<=0 THEN CONTINUE FOREACH END IF
     #        IF l_move<= l_qty THEN
     #           LET l_sql=
     #            " SELECT * INTO mst.* FROM mst_file",
     #            "  where mst01='",mss.mss01,"' AND mst02='",mss.mss02,"'",
     #            "    AND mst03='",mss.mss03,"' AND mst_v='",mss.mss_v,"'",
     #            "    AND mst08 >= ",l_move," AND mst08<= ",l_move*(1+tm.per/100),"",
     #            "    AND (mst05='61' OR mst05='62' OR mst05='63')",
     #            "    ORDER BY mst08,mst06,mst061"  
     #           PREPARE mstsql FROM l_sql
     #           DECLARE r514_mstmin CURSOR FOR mstsql
     #           FOREACH r514_mstmin INTO mst.*
     #           IF STATUS THEN EXIT FOREACH END IF 
     #           IF l_move<=0 THEN CONTINUE FOREACH END IF 
     #           #No.FUN-850143-------start--
     #           SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = ima_o.ima43   #MOD-A10162 ima.ima43-->ima_o.ima43
     #           IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF 
     #                           
     #           IF mst.mst05 = '62' OR mst.mst05 = '63' THEN                               
     #             #---------------No.MOD-890230 modify
     #             #LET l_pono = mst.mst06[1,10]                                            
     #              LET l_pono = mst.mst06                                            
     #             #---------------No.MOD-890230 end
     #              SELECT pmm09,pmc03 INTO l_vender,l_pmc03                                
     #                FROM pmm_file,pmc_file                                                
     #               WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'                 
     #              IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF       
     #           END IF                                                                     
     #           IF mst.mst05 ='61' THEN                                                    
     #             #---------------No.MOD-890230 modify
     #             #LET l_pono = mst.mst06[1,10]                                            
     #              LET l_pono = mst.mst06                                            
     #             #---------------No.MOD-890230 end
     #              SELECT pmk09,pmc03 INTO l_vender,l_pmc03                                
     #                FROM pmk_file,pmc_file                                                
     #               WHERE pmk09 = pmc01 and pmk01 = l_prno                                 
     #              IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF       
     #           END IF                                                                     
     #           
     #           #MOD-A10162 ima-->ima_o/mss-->mss_o
     #           EXECUTE insert_prep USING
     #               ima_o.ima43,l_gen02,mss_o.mss041,mss_o.mss043,mss_o.mss044,
     #               mss_o.mss051,mss_o.mss052,mss_o.mss053,mss_o.mss063,mss_o.mss064,
     #               mss_o.mss065,mss_o.mss09,mss_o.mss01,ima_o.ima02,ima_o.ima25,
     #               mss_o.mss00,mss_o.mss03,mss_o.mss072,mss_o.mss071,mst.mst08,
     #              #----------No:MOD-890230 modify
     #              #mst.mst06[1,10],mst.mst061,mst.mst04,l_vender,l_pmc03,
     #               mst.mst06,mst.mst061,mst.mst04,l_vender,l_pmc03,
     #              #----------No:MOD-890230 end
     #               mss_o.mss02   
     #           #OUTPUT TO REPORT amrr514_rep(mss_o.*,ima_o.*,mst.*)
     #           #No.FUN-850143-------end
     #           LET l_move=l_move-mst.mst08
     #           END FOREACH
     #        END IF 
     #
     #        IF l_move >0 THEN 
     #           FOREACH r514_curmst USING mss.mss01,mss.mss02,mss.mss03,mss.mss_v
     #           INTO mst.*
     #           IF l_move<=0 THEN CONTINUE FOREACH END IF 
     #           #No.FUN-850143-------start--
     #           SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = ima_o.ima43     #MOD-A10162 ima.ima43-->ima_o.ima43
     #           IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF 
     #                           
     #           IF mst.mst05 = '62' OR mst.mst05 = '63' THEN                               
     #             #--------------No.MOD-890230 modify
     #             #LET l_pono = mst.mst06[1,10]                                            
     #              LET l_pono = mst.mst06                                            
     #             #--------------No.MOD-890230 end
     #              SELECT pmm09,pmc03 INTO l_vender,l_pmc03                                
     #                FROM pmm_file,pmc_file                                                
     #               WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'                 
     #              IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF       
     #           END IF                                                                     
     #           IF mst.mst05 ='61' THEN                                                    
     #             #--------------No.MOD-890230 modify
     #             #LET l_pono = mst.mst06[1,10]                                            
     #              LET l_pono = mst.mst06                                            
     #             #--------------No.MOD-890230 end
     #              SELECT pmk09,pmc03 INTO l_vender,l_pmc03                                
     #                FROM pmk_file,pmc_file                                                
     #               WHERE pmk09 = pmc01 and pmk01 = l_prno                                 
     #              IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF       
     #           END IF                                                                     
     #           
     #           #MOD-A10162 ima-->ima_o/mss-->mss_o
     #           EXECUTE insert_prep USING
     #               ima_o.ima43,l_gen02,mss_o.mss041,mss_o.mss043,mss_o.mss044,
     #               mss_o.mss051,mss_o.mss052,mss_o.mss053,mss_o.mss063,mss_o.mss064,
     #               mss_o.mss065,mss_o.mss09,mss_o.mss01,ima_o.ima02,ima_o.ima25,
     #               mss_o.mss00,mss_o.mss03,mss_o.mss072,mss_o.mss071,mst.mst08,
     #              #---------No:MOD-890230 modify
     #              #mst.mst06[1,10],mst.mst061,mst.mst04,l_vender,l_pmc03,
     #               mst.mst06,mst.mst061,mst.mst04,l_vender,l_pmc03,
     #              #---------No:MOD-890230 end
     #               mss_o.mss02                   
     #           #OUTPUT TO REPORT amrr514_rep(mss_o.*,ima_o.*,mst.*) 
     #           #No.FUN-850143-------end
     #           LET l_move=l_move-mst.mst08 
     #           END FOREACH 
     #        END IF  
     #     END IF  
     #  END IF  
     #END FOREACH
     LET i = 1 
     FOREACH amrr514_curs1 INTO sss[i].* 
        LET i = i + 1
     END FOREACH
     CALL sss.deleteElement(i)
     LET i = i - 1
     FOR j = 1 TO i
         LET l_bal = 0 
         LET l_bal = sss[j].mss072 - sss[j].mss071
         IF l_bal > 0 THEN 
            #FOR k = j+1 TO i  #CHI-C50068 
 			#CHI-C50068---begin
            FOR k = 1 TO i         
                IF sss[j].mss01 <> sss[k].mss01 THEN
                   CONTINUE FOR
                END IF
			#CHI-C50068---end
                LET l_qty = 0 
                LET l_qty = sss[k].mss061 + sss[k].mss062 + sss[k].mss063 
                LET l_move = sss[k].mss072 - sss[k].mss071       #No:MOD-A40096 add
                IF cl_null(l_move) THEN LET l_move = 0 END IF    #No:MOD-A40096 add
                #IF l_qty <=0 THEN 	#CHI-C50068
				IF l_move >= 0 THEN	 #CHI-C50068
                   CONTINUE FOR
                ELSE
                   LET l_mst08 = 0 
                   LET l_mst05 = ''
                   LET l_mst06 = '' 
                   LET l_mst061= ''
                   LET l_mst04 = ''
                   DECLARE r514_curs1 CURSOR FOR
                    SELECT mst08,mst05,mst06,mst061,mst04 
                       FROM mst_file
                      WHERE mst_v = sss[k].mss_v
                        AND mst01 = sss[k].mss01
                        AND mst02 = sss[k].mss02
                        AND mst03 = sss[k].mss03
                        AND (mst05='61' OR mst05='62' OR mst05='63')
                        #AND mst08 >= l_bal AND mst08 <= (l_bal * (1 + tm.per/100))    #No:MOD-A40096 add #CHI-C50068
						AND l_bal > 0  #CHI-C50068
                        ORDER BY mst08,mst06,mst061                                   #No:MOD-A40096 add
                   FOREACH r514_curs1 INTO l_mst08,l_mst05,l_mst06,l_mst061,l_mst04                                      
                      #CHI-C50068---begin
                      LET l_difference=''  LET l_datedf=0
                      LET l_datedf = sss[j].mss03 - l_mst04
                      IF  l_datedf = 0 THEN
                          LET l_difference = ''
                      ELSE
                          IF l_datedf > 0 THEN
                             #LET l_difference = '延後'
                             LET l_difference = '2'
                          ELSE
                             #LET l_difference = '提前'
                             LET l_difference = '1'
                          END IF
                      END IF
                      #CHI-C50068---end                                    
                      LET l_mst081= 0 
                      SELECT SUM(mst08) INTO l_mst081 FROM r514_tmp
                        WHERE mst_v = sss[k].mss_v
                          AND mst01 = sss[k].mss01
                          AND mst02 = sss[k].mss02
                          AND mst03 = sss[k].mss03
                          AND mst06 = l_mst06
                          AND mst061 = l_mst061
                      IF cl_null(l_mst081) THEN LET l_mst081 = 0 END IF
                      LET l_mst08 = l_mst08 - l_mst081
                      IF l_mst08 = 0 THEN CONTINUE FOREACH END IF          #No:MOD-A40096 add
                      IF l_mst05 = '62' OR l_mst05 = '63' THEN                               
                         LET l_vender = ''
                         LET l_pmc03 = ''
                         SELECT pmm09,pmc03 INTO l_vender,l_pmc03                                
                           FROM pmm_file,pmc_file                                                
                          WHERE pmm09 = pmc01 and pmm01 = l_mst06 AND pmm18 !='X'                 
                         IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF       
                      END IF                                                                     
                      IF l_mst05 ='61' THEN                                                    
                         LET l_vender = ''
                         LET l_pmc03 = ''
                         SELECT pmk09,pmc03 INTO l_vender,l_pmc03                                
                           FROM pmk_file,pmc_file                                                
                          WHERE pmk09 = pmc01 and pmk01 = l_mst06                                 
                         IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF       
                      END IF                                                                     
                      SELECT ima02,ima08,ima25,ima43 INTO ima.* FROM ima_file
                      WHERE ima01 = sss[j].mss01

                    CASE WHEN tm.type = '1'  #CHI-C50068                                              
                      IF l_bal <= l_mst08 THEN
                         EXECUTE insert_prep USING
                            ima.ima43,l_gen02,sss[j].mss041,sss[j].mss043,sss[j].mss044,
                            sss[j].mss051,sss[j].mss052,sss[j].mss053,sss[j].mss063,sss[j].mss064,
                            sss[j].mss065,sss[j].mss09,sss[j].mss01,ima.ima02,ima.ima25,
                            sss[j].mss00,sss[j].mss03,sss[j].mss072,sss[j].mss071,l_bal,
                            l_mst06,l_mst061,l_mst04,l_difference,l_vender,l_pmc03,	 #CHI-C50068
                            sss[j].mss02                   
                         INSERT INTO r514_tmp VALUES(sss[k].mss_v,sss[k].mss01,sss[k].mss02,
                                               sss[k].mss03,l_bal,l_mst06,l_mst061)
                         LET l_bal = l_bal - l_mst08     #No:MOD-A40096 add
                         EXIT FOREACH
                      ELSE
                         EXECUTE insert_prep USING
                            ima.ima43,l_gen02,sss[j].mss041,sss[j].mss043,sss[j].mss044,
                            sss[j].mss051,sss[j].mss052,sss[j].mss053,sss[j].mss063,sss[j].mss064,
                            sss[j].mss065,sss[j].mss09,sss[j].mss01,ima.ima02,ima.ima25,
                            sss[j].mss00,sss[j].mss03,sss[j].mss072,sss[j].mss071,l_mst08,
                            l_mst06,l_mst061,l_mst04,l_difference,l_vender,l_pmc03,	#CHI-C50068
                            sss[j].mss02                   
                         INSERT INTO r514_tmp VALUES(sss[k].mss_v,sss[k].mss01,sss[k].mss02,
                                               sss[k].mss03,l_mst08,l_mst06,l_mst061)
                         LET l_bal = l_bal - l_mst08     #No:MOD-A40096 add
                      END IF  
                    #CHI-C50068---begin
                    WHEN tm.type = '2'                                                              
                      IF l_bal <= l_mst08 THEN                                                           
                         IF (l_datedf < 0)THEN                                                           #tm.type='2' <=> l_datedf<0(提前)
                         EXECUTE insert_prep USING
                            ima.ima43,l_gen02,sss[j].mss041,sss[j].mss043,sss[j].mss044,
                            sss[j].mss051,sss[j].mss052,sss[j].mss053,sss[j].mss063,sss[j].mss064,
                            sss[j].mss065,sss[j].mss09,sss[j].mss01,ima.ima02,ima.ima25, 
                            sss[j].mss00,sss[j].mss03,sss[j].mss072,sss[j].mss071,l_bal,     
                            l_mst06,l_mst061,l_mst04,l_difference,l_vender,l_pmc03,      
                            sss[j].mss02                   
                         END IF                                                                          #tm.type='2' <=> l_datedf<0(提前)
                         INSERT INTO r514_tmp VALUES(sss[k].mss_v,sss[k].mss01,sss[k].mss02,
                                               sss[k].mss03,l_bal,l_mst06,l_mst061)
                         LET l_bal = l_bal - l_mst08     #No:MOD-A40096 add
                         EXIT FOREACH
                      ELSE
                         IF (l_datedf < 0)THEN                                                           #tm.type='2' <=> l_datedf<0(提前)
                         EXECUTE insert_prep USING
                            ima.ima43,l_gen02,sss[j].mss041,sss[j].mss043,sss[j].mss044,
                            sss[j].mss051,sss[j].mss052,sss[j].mss053,sss[j].mss063,sss[j].mss064,
                            sss[j].mss065,sss[j].mss09,sss[j].mss01,ima.ima02,ima.ima25,      
                            sss[j].mss00,sss[j].mss03,sss[j].mss072,sss[j].mss071,l_mst08,
                            l_mst06,l_mst061,l_mst04,l_difference,l_vender,l_pmc03,     
                            sss[j].mss02
                         END IF                                                                          #tm.type='2' <=> l_datedf<0(提前)
                         INSERT INTO r514_tmp VALUES(sss[k].mss_v,sss[k].mss01,sss[k].mss02,
                                               sss[k].mss03,l_mst08,l_mst06,l_mst061)
                         LET l_bal = l_bal - l_mst08     #No:MOD-A40096 add
                      END IF
                    WHEN tm.type = '3'
                      IF l_bal <= l_mst08 THEN                                                           
                         IF (l_datedf > 0)THEN                                                           #tm.type='3' <=> l_datedf>0(延後)
                         EXECUTE insert_prep USING
                            ima.ima43,l_gen02,sss[j].mss041,sss[j].mss043,sss[j].mss044,
                            sss[j].mss051,sss[j].mss052,sss[j].mss053,sss[j].mss063,sss[j].mss064,
                            sss[j].mss065,sss[j].mss09,sss[j].mss01,ima.ima02,ima.ima25,      
                            sss[j].mss00,sss[j].mss03,sss[j].mss072,sss[j].mss071,l_bal,
                            l_mst06,l_mst061,l_mst04,l_difference,l_vender,l_pmc03,     
                            sss[j].mss02
                         END IF                                                                          #tm.type='3' <=> l_datedf>0(延後)
                         INSERT INTO r514_tmp VALUES(sss[k].mss_v,sss[k].mss01,sss[k].mss02,
                                               sss[k].mss03,l_bal,l_mst06,l_mst061)
                         LET l_bal = l_bal - l_mst08     #No:MOD-A40096 add
                         EXIT FOREACH
                      ELSE
                         IF (l_datedf > 0)THEN                                                           #tm.type='3' <=> l_datedf>0(延後)
                         EXECUTE insert_prep USING
                            ima.ima43,l_gen02,sss[j].mss041,sss[j].mss043,sss[j].mss044,
                            sss[j].mss051,sss[j].mss052,sss[j].mss053,sss[j].mss063,sss[j].mss064,
                            sss[j].mss065,sss[j].mss09,sss[j].mss01,ima.ima02,ima.ima25,      
                            sss[j].mss00,sss[j].mss03,sss[j].mss072,sss[j].mss071,l_mst08,
                            l_mst06,l_mst061,l_mst04,l_difference,l_vender,l_pmc03,      
                            sss[j].mss02
                         END IF                                                                          #tm.type='3' <=> l_datedf>0(延後)
                         INSERT INTO r514_tmp VALUES(sss[k].mss_v,sss[k].mss01,sss[k].mss02,
                                               sss[k].mss03,l_mst08,l_mst06,l_mst061)
                         LET l_bal = l_bal - l_mst08     #No:MOD-A40096 add
                      END IF
                    END CASE                                                                            
				    #CHI-C50068---end
                   END FOREACH
                  #------------------------------No:MOD-A40096 add
                   #若需求未滿足，須再處理供給量未符合需求量範圍的單據
                   IF l_bal > 0 THEN
                      LET l_mst08 = 0 
                      LET l_mst05 = ''
                      LET l_mst06 = '' 
                      LET l_mst061= ''
                      LET l_mst04 = ''
                      DECLARE r514_curs2 CURSOR FOR
                       SELECT mst08,mst05,mst06,mst061,mst04 
                          FROM mst_file
                         WHERE mst_v = sss[k].mss_v
                           AND mst01 = sss[k].mss01
                           AND mst02 = sss[k].mss02
                           AND mst03 = sss[k].mss03
                           AND (mst05='61' OR mst05='62' OR mst05='63')
                           ORDER BY mst06,mst061
                      FOREACH r514_curs2 INTO l_mst08,l_mst05,l_mst06,l_mst061,l_mst04
						 LET l_difference=''  LET l_datedf=0  #CHI-C50068
                         LET l_mst081= 0 
                         SELECT SUM(mst08) INTO l_mst081 FROM r514_tmp
                           WHERE mst_v = sss[k].mss_v
                             AND mst01 = sss[k].mss01
                             AND mst02 = sss[k].mss02
                             AND mst03 = sss[k].mss03
                             AND mst06 = l_mst06
                             AND mst061 = l_mst061
                         IF cl_null(l_mst081) THEN LET l_mst081 = 0 END IF
                         LET l_mst08 = l_mst08 - l_mst081
                         IF l_mst08 = 0 THEN CONTINUE FOREACH END IF          #No:MOD-A40096 add
                         IF l_mst05 = '62' OR l_mst05 = '63' THEN                               
                            LET l_vender = ''
                            LET l_pmc03 = ''
                            SELECT pmm09,pmc03 INTO l_vender,l_pmc03                                
                              FROM pmm_file,pmc_file                                                
                             WHERE pmm09 = pmc01 and pmm01 = l_mst06 AND pmm18 !='X'                 
                            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF       
                         END IF                                                                     
                         IF l_mst05 ='61' THEN                                                    
                            LET l_vender = ''
                            LET l_pmc03 = ''
                            SELECT pmk09,pmc03 INTO l_vender,l_pmc03                                
                              FROM pmk_file,pmc_file                                                
                             WHERE pmk09 = pmc01 and pmk01 = l_mst06                                 
                            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF       
                         END IF                                                                     
                         SELECT ima02,ima08,ima25,ima43 INTO ima.* FROM ima_file
                         WHERE ima01 = sss[j].mss01
                         IF l_bal <= l_mst08 THEN
                            EXECUTE insert_prep USING
                               ima.ima43,l_gen02,sss[j].mss041,sss[j].mss043,sss[j].mss044,
                               sss[j].mss051,sss[j].mss052,sss[j].mss053,sss[j].mss063,sss[j].mss064,
                               sss[j].mss065,sss[j].mss09,sss[j].mss01,ima.ima02,ima.ima25,
                               sss[j].mss00,sss[j].mss03,sss[j].mss072,sss[j].mss071,l_bal,
                               l_mst06,l_mst061,l_mst04,l_difference,l_vender,l_pmc03, #CHI-C50068
                               sss[j].mss02                   
                            INSERT INTO r514_tmp VALUES(sss[k].mss_v,sss[k].mss01,sss[k].mss02,
                                                  sss[k].mss03,l_bal,l_mst06,l_mst061)
                            LET l_bal = l_bal - l_mst08     #No:MOD-A40096 add
                            EXIT FOREACH
                         ELSE
                            EXECUTE insert_prep USING
                               ima.ima43,l_gen02,sss[j].mss041,sss[j].mss043,sss[j].mss044,
                               sss[j].mss051,sss[j].mss052,sss[j].mss053,sss[j].mss063,sss[j].mss064,
                               sss[j].mss065,sss[j].mss09,sss[j].mss01,ima.ima02,ima.ima25,
                               sss[j].mss00,sss[j].mss03,sss[j].mss072,sss[j].mss071,l_mst08,
                               l_mst06,l_mst061,l_mst04,l_difference,l_vender,l_pmc03, #CHI-C50068
                               sss[j].mss02                   
                            INSERT INTO r514_tmp VALUES(sss[k].mss_v,sss[k].mss01,sss[k].mss02,
                                                  sss[k].mss03,l_mst08,l_mst06,l_mst061)
                            LET l_bal = l_bal - l_mst08     #No:MOD-A40096 add
                         END IF
                      END FOREACH
                   END IF
                  #------------------------------No:MOD-A40096 end
                END IF
            END FOR
         END IF
     END FOR
     #-----END MOD-A10180-----
     
     #No.FUN-850143-------start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'mss01,ima67,mss02,ima08,ima43')
        RETURNING tm.wc
     END IF
     
     LET g_str = tm.wc,";",tm.ver_no,";",tm.sdate,";",tm.edate  #CHI-C50068
     
     CALL cl_prt_cs3('amrr514','amrr514',g_sql,g_str)
     #FINISH REPORT amrr514_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-850143-------end
END FUNCTION
 
#No.FUN-850143------start--
#REPORT amrr514_rep(mss,ima,mst)
#   DEFINE l_last_sw     LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
#   DEFINE mss           RECORD LIKE mss_file.*
#   DEFINE mst           RECORD LIKE mst_file.*
#   DEFINE ima   RECORD      
#                  ima02  LIKE ima_file.ima02,
#                  ima08  LIKE ima_file.ima08,
#                  ima25  LIKE ima_file.ima25,
#                  ima43  LIKE ima_file.ima43
#                END RECORD
#   DEFINE l_reqqty,l_othqty LIKE mss_file.mss041 
#   DEFINE l_cnt    LIKE type_file.num5          #NO.FUN-680082 SMALLINT
#   DEFINE l_gen02  LIKE gen_file.gen02 
#   DEFINE l_pono   LIKE pmm_file.pmm01 
#   DEFINE l_prno   LIKE pmm_file.pmm01 
#   DEFINE l_vender LIKE pmm_file.pmm09 
#   DEFINE l_pmc03  LIKE pmc_file.pmc03 
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY ima.ima43,mss.mss01,mss.mss02,mss.mss03
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = ima.ima43
#      IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
#      PRINT g_x[22] clipped,ima.ima43,' ',l_gen02
#      PRINT g_x[16] CLIPPED,tm.ver_no,'  ',g_x[21] CLIPPED,tm.edate
#      PRINT g_dash[1,g_len] 
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF ima.ima43   #採購員
#      SKIP TO TOP OF PAGE
#
#   BEFORE GROUP OF mss.mss03
#      LET l_cnt = 0
#      LET l_reqqty = mss.mss041+mss.mss043+mss.mss044
#      LET l_othqty = mss.mss051+mss.mss052+mss.mss053 +
#                     mss.mss063+mss.mss064+mss.mss065 + mss.mss09
#
#   ON EVERY ROW 
#       #-->取請購/採購供給
#     PRINT COLUMN g_c[31],mss.mss01 CLIPPED,  #FUN-5B0014 [1,20] CLIPPED,
#           COLUMN g_c[32],ima.ima02 CLIPPED,
#           COLUMN g_c[33],ima.ima25 CLIPPED, 
#           COLUMN g_c[34],mss.mss00 USING '###&', #FUN-590118
#           COLUMN g_c[35],mss.mss03 CLIPPED, 
#           COLUMN g_c[36],(mss.mss072-mss.mss071) USING '---,---,--&.&&&',
#           COLUMN g_c[37],l_reqqty  USING '---,---,--&.&&&',
#           COLUMN g_c[38],l_othqty  USING '---,---,--&.&&&';
#     IF mst.mst05 = '62' OR mst.mst05 = '63' THEN
#        LET l_pono = mst.mst06[1,10]
#        SELECT pmm09,pmc03 INTO l_vender,l_pmc03 
#          FROM pmm_file,pmc_file
#         WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'
#        IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
#     END IF
#     IF mst.mst05 ='61' THEN 
#        LET l_prno = mst.mst06[1,10]
#        SELECT pmk09,pmc03 INTO l_vender,l_pmc03 
#          FROM pmk_file,pmc_file
#         WHERE pmk09 = pmc01 and pmk01 = l_prno
#        IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
#     END IF
#     PRINT COLUMN g_c[39],mst.mst08 USING '---,---,---.&&&',
#           COLUMN g_c[40],mst.mst06[1,10],
#           COLUMN g_c[41],mst.mst061 using '###&',
#           COLUMN g_c[42],mst.mst04 CLIPPED,
#           COLUMN g_c[43],l_vender CLIPPED,
#           COLUMN g_c[44],l_pmc03
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'aec01,aec05,aec02,aec051')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#              # TQC-630166 Start
#              # IF tm.wc[001,070] > ' ' THEN			# for 80
#    	      #    PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#              # IF tm.wc[071,140] > ' ' THEN
#	      #	  PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#              # IF tm.wc[141,210] > ' ' THEN
#	      #	  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#              # IF tm.wc[211,280] > ' ' THEN
#	      #	  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#
#              CALL cl_prt_pos_wc(tm.wc)
#
#              # TQC-630166 End
#              
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED 
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED 
#      ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-850143------end
#FUN-870144
