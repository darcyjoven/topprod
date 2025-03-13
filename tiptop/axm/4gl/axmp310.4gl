# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axmp310.4gl
# Descriptions...: 材料/人工/製費分攤作業
# Date & Author..: 00/03/06 By Melody
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.MOD-580046 05/08/18 By Rosayu 估價單號放大到char(16),加開窗查詢
# Modify.........: No.FUN-570155 06/03/15 By yiting 批次背景執行
# Modify.........: No.MOD-650024 06/05/08 By Claire 傳入值直接帶入key值
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0090 06/11/16 By day 輸入金額為負時加報錯信息
# Modify.........: No.FUN-710046 07/01/17 By Carrier 錯誤訊息匯整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_argv1	LIKE oea_file.oea01    #MOD-580046  # 所要查詢的key   #No.FUN-680137  
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE tm RECORD
          id    LIKE oea_file.oea01,   #MOD-580046 #No.FUN-680137  VARCHAR(16)
          a     LIKE type_file.chr1,               #No.FUN-680137  VARCHAR(01)
          amta  LIKE oqc_file.oqc13,  #FUN-4C0006
          b     LIKE type_file.chr1,               #No.FUN-680137  VARCHAR(01)
          amtb  LIKE oqc_file.oqc13,  #FUN-4C0006
          d     LIKE type_file.chr1,               #No.FUN-680137  VARCHAR(01)
          c     LIKE type_file.chr1,               #No.FUN-680137  VARCHAR(01)
          amtc  LIKE oqc_file.oqc13,  #FUN-4C0006
          e     LIKE type_file.chr1                #No.FUN-680137  VARCHAR(01)
          END RECORD
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680137 INTEGER
DEFINE g_flag          LIKE type_file.chr1,        #No.FUN-570155 #No.FUN-680137 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1         #是否有做語言切換 No.FUN-570155   #No.FUN-680137 VARCHAR(01)
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT        			# Supress DEL key function
 
   #->No.FUN-570155 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
  #LET tm.id    = ARG_VAL(1)    
   LET g_argv1  = ARG_VAL(1)    
   LET tm.a     = ARG_VAL(2)    
   LET tm.amta  = ARG_VAL(3)    
   LET tm.b     = ARG_VAL(4)    
   LET tm.amtb  = ARG_VAL(5)    
   LET tm.d     = ARG_VAL(6)    
   LET tm.c     = ARG_VAL(7)    
   LET tm.amtc  = ARG_VAL(8)    
   LET tm.e     = ARG_VAL(9)    
   LET g_bgjob  = ARG_VAL(10)    
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570155 ---end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
#NO.FUN-570155 mark---
#   LET g_argv1 = ARG_VAL(1)
 
   SELECT azi04 INTO t_azi04  #估價幣別   #No.CHI-6A0004
     FROM azi_file,oqa_file
    WHERE oqa01 = g_argv1
      AND azi01 = oqa08
 
# Prog. Version..: '5.30.06-13.03.12(0,0)				# 
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start-
   LET g_success = 'Y'
   WHILE TRUE
   IF g_bgjob = "N" THEN
      CALL p310_tm(0,0)
      IF cl_sure(18,20) THEN
         BEGIN WORK
         CALL axmp310()
         #No.FUN-710046  --Begin
         CALL s_showmsg()
         #No.FUN-710046  --End  
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag
         END IF
        IF g_flag THEN 
           CONTINUE WHILE 
        ELSE 
           CLOSE WINDOW p310_w
           EXIT WHILE 
        END IF
    ELSE
        CONTINUE WHILE
    END IF
  ELSE
    BEGIN WORK
    LET g_success = 'Y'
    CALL axmp310()
    #No.FUN-710046  --Begin
    CALL s_showmsg()
    #No.FUN-710046  --End  
    IF g_success = "Y" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    CALL cl_batch_bg_javamail(g_success)
    EXIT WHILE
  END IF
 END WHILE
#->No.FUN-570155 ---end---

 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN
 
FUNCTION p310_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_flag        LIKE type_file.num5          #No.FUN-680137 SMALLINT 
   DEFINE lc_cmd        LIKE type_file.chr1000       #No.FUN-570155 #No.FUN-680137 VARCHAR(500)
 
   OPEN WINDOW p310_w WITH FORM "axm/42f/axmp310" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition 
      IF g_argv1!=' ' AND g_argv1 IS NOT NULL THEN LET tm.id=g_argv1 END IF 
      LET tm.a='Y' 
      LET tm.amta=0   
      LET tm.b='Y' 
      LET tm.amtb=0   
      LET tm.d='1' 
      LET tm.c='Y' 
      LET tm.amtc=0    
      LET tm.e='1' 
      LET g_bgjob = 'N'   #NO.FUN-570155 
      #DISPLAY BY NAME tm.id,tm.a,tm.amta,tm.b,tm.amtb,tm.d,tm.c,tm.amtc,tm.e
      DISPLAY BY NAME tm.id,tm.a,tm.amta,tm.b,tm.amtb,tm.d,tm.c,tm.amtc,tm.e,g_bgjob  #NO.FUN-570155  
                      
      INPUT BY NAME tm.id,tm.a,tm.amta,tm.b,tm.amtb,tm.d,tm.c,tm.amtc,tm.e,
                    g_bgjob  #NO.FUN-570155 
                     WITHOUT DEFAULTS 
         BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL p310_set_entry()
            CALL p310_set_no_entry()
            LET g_before_input_done = TRUE
 
         AFTER FIELD id
            IF cl_null(tm.id) THEN NEXT FIELD id END IF
            SELECT COUNT(*) INTO g_cnt FROM oqa_file 
               WHERE oqa01=tm.id AND oqaconf='N'
            IF g_cnt=0 THEN
               CALL cl_err(tm.id,'axm-511',0)
               NEXT FIELD id
            END IF 
            SELECT azi04 INTO t_azi04  #估價幣別     #No.CHI-6A0004
              FROM azi_file,oqa_file
             WHERE oqa01 = tm.id
               AND azi01 = oqa08
 
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         BEFORE FIELD a 
            CALL p310_set_entry()
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
               NEXT FIELD a 
            END IF
            CALL p310_set_no_entry()
 
         AFTER FIELD amta
            IF cl_null(tm.amta) OR tm.amta<0 THEN
               CALL cl_err(tm.amta,'aap-201',0)  #No.TQC-6B0090
               NEXT FIELD amta
            END IF
            LET tm.amta = cl_numfor(tm.amta,11,t_azi04)     #No.CHI-6A0004
            DISPLAY BY NAME tm.amta
 
         BEFORE FIELD b
            CALL p310_set_entry()
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b 
            END IF
            CALL p310_set_no_entry()
 
         AFTER FIELD amtb
            IF cl_null(tm.amtb) OR tm.amtb<0 THEN
               CALL cl_err(tm.amtb,'aap-201',0)  #No.TQC-6B0090
               NEXT FIELD amtb
            END IF
            LET tm.amtb = cl_numfor(tm.amtb,11,t_azi04)       #No.CHI-6A0004
            DISPLAY BY NAME tm.amtb
 
         AFTER FIELD d
            IF NOT cl_null(tm.d) THEN
               IF tm.d NOT MATCHES '[12]' THEN NEXT FIELD d END IF
            END IF
 
         BEFORE FIELD c
            CALL p310_set_entry()
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
               NEXT FIELD c 
            END IF
            CALL p310_set_no_entry()
 
         AFTER FIELD amtc
            IF cl_null(tm.amtc) OR tm.amtc < 0 THEN
               CALL cl_err(tm.amtc,'aap-201',0)  #No.TQC-6B0090
               NEXT FIELD amtc
            END IF
            LET tm.amtc = cl_numfor(tm.amtc,11,t_azi04)       #No.CHI-6A0004
            DISPLAY BY NAME tm.amtc
 
         AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES '[12]' THEN NEXT FIELD e END IF
 
         ON ACTION locale
#NO.FUN-570155 start--
#           LET g_action_choice='locale'
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE
#NO.FUN-570155 end---
            EXIT INPUT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
          #MOD-580046 add
         ON ACTION CONTROLP
           CASE
               WHEN INFIELD(id)
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form="q_oqa"  #MOD-650024 mark
                   LET g_qryparam.form="q_oqa1"  #MOD-650024 show 未確認 
                   LET g_qryparam.default1 = tm.id
                   CALL cl_create_qry() RETURNING tm.id 
                   CALL FGL_DIALOG_SETBUFFER(tm.id)
                   DISPLAY BY NAME tm.id
                   NEXT FIELD id
               OTHERWISE
                   EXIT CASE
           END CASE
          #MOD-580046(end)
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
#NO.FUN-570155 mark---
#      IF g_action_choice = 'locale' THEN
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#     END IF
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM END IF
#      IF cl_sure(20,20) THEN
#         CALL cl_wait()
#         LET g_success = 'Y'
#         BEGIN WORK
#         CALL axmp310()
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag
#        ELSE
#           ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag
#         END IF
#         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#       END IF
#
#      CALL axmp310()
#   END WHILE
#   ERROR ""
#   CLOSE WINDOW p310_w
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start-
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW p310_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
 
 IF g_change_lang THEN
    LET g_change_lang = FALSE
    CALL cl_dynamic_locale()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    CONTINUE WHILE
 END IF
 
 IF g_bgjob = 'Y' THEN
    SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axmp310'
    IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
       CALL cl_err('axmp310','9031',1)
    ELSE
       LET lc_cmd = lc_cmd CLIPPED,
                    " '",tm.id CLIPPED,"'",
                    " '",tm.a CLIPPED,"'",
                    " '",tm.amta CLIPPED,"'",
                    " '",tm.b CLIPPED,"'",
                    " '",tm.amtb CLIPPED,"'",
                    " '",tm.d CLIPPED,"'",
                    " '",tm.c CLIPPED,"'",
                    " '",tm.amtc CLIPPED,"'",
                    " '",tm.e CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
       CALL cl_cmdat('axmp310',g_time,lc_cmd CLIPPED)
    END IF
    CLOSE WINDOW p310_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
    EXIT PROGRAM
 END IF
 
 EXIT WHILE
END WHILE
#FUN-570155 ---end---
END FUNCTION
 
FUNCTION axmp310()
#     DEFINE  l_time LIKE type_file.chr8	     #No.FUN-6A0094
DEFINE   l_sql	 LIKE type_file.chr1000,        #No.FUN-680137 VARCHAR(500)
         l_oqa01 LIKE oqa_file.oqa01, 
         l_oqa09 LIKE oqa_file.oqa09,
         tot_oqb11,l_oqb11 LIKE oqb_file.oqb11,
         tot_oqb12,l_oqb12 LIKE oqb_file.oqb12,
         tot_oqc13,l_oqc13 LIKE oqc_file.oqc13,
         tot_oqc14,l_oqc14 LIKE oqc_file.oqc14,
         l_oqb11_up LIKE oqb_file.oqb11,
         l_oqb12_up LIKE oqb_file.oqb11,
         l_oqc13_up LIKE oqc_file.oqc13,
         l_oqc14_up LIKE oqc_file.oqc14,
         g_oqa      RECORD LIKE oqa_file.*,
         l_oqb   RECORD LIKE oqb_file.*,
         l_oqc   RECORD LIKE oqc_file.*
 
     LET l_sql = "SELECT oqa01,oqa09 FROM oqa_file WHERE oqa01='",tm.id,"' "
     PREPARE p310_prepare FROM l_sql
     DECLARE p310_cur CURSOR FOR p310_prepare
     CALL s_showmsg_init()   #No.FUN-710046
     FOREACH p310_cur INTO l_oqa01,l_oqa09  
         #No.FUN-710046  --Begin
         IF g_success = "N" THEN
            LET g_totsuccess = "N"
            LET g_success = "Y"
         END IF
         #No.FUN-710046  --End
         #--------------- 材料
         IF tm.a='Y' THEN         
            SELECT SUM(oqb11) INTO l_oqb11 FROM oqb_file 
               WHERE oqb01=l_oqa01 AND oqb06='N'
            IF l_oqb11 IS NOT NULL AND l_oqb11!=0 THEN
               LET tot_oqb11=0
               DECLARE oqb_cur CURSOR FOR
                  SELECT * FROM oqb_file WHERE oqb01=l_oqa01 AND oqb06='N'
               FOREACH oqb_cur INTO l_oqb.*
                  LET l_oqb11_up=tm.amta*l_oqb.oqb11/l_oqb11
                  LET l_oqb.oqb10=l_oqb11_up/l_oqb.oqb05
                  LET tot_oqb11=tot_oqb11+l_oqb11_up 
                  UPDATE oqb_file SET oqb11=l_oqb11_up,
                                      oqb10=l_oqb.oqb10 
                     WHERE oqb01=l_oqa01 AND oqb02=l_oqb.oqb02
                  IF tot_oqb11>tm.amta THEN
                     UPDATE oqb_file SET oqb11=oqb11-(tot_oqb11-tm.amta),
                                         oqb10=(oqb11-(tot_oqb11-tm.amta))/oqb05
                        WHERE oqb01=l_oqa01 AND oqb02=l_oqb.oqb02
                     EXIT FOREACH 
                  END IF 
                  IF tot_oqb11=tm.amta THEN
                     EXIT FOREACH 
                  END IF 
               END FOREACH      
               IF tot_oqb11<tm.amta THEN
                  UPDATE oqb_file SET oqb11=oqb11+(tm.amta-tot_oqb11),
                                      oqb10=(oqb11+(tm.amta-tot_oqb11))/oqb05
                     WHERE oqb01=l_oqa01 AND oqb02=l_oqb.oqb02
               END IF
            END IF
         END IF
 
         #--------------- 人工
         IF tm.b='Y' THEN         
            SELECT SUM(oqc13) INTO l_oqc13 FROM oqc_file WHERE oqc01=l_oqa01 
            IF l_oqc13 IS NOT NULL AND l_oqc13!=0 THEN
               LET tot_oqc13=0
               CASE tm.d
                    WHEN '1' 
                         DECLARE oqc_cur11 CURSOR FOR
                         SELECT * FROM oqc_file WHERE oqc01=l_oqa01 
                         FOREACH oqc_cur11 INTO l_oqc.*
                            LET l_oqc13_up=tm.amtb*l_oqc.oqc13/l_oqc13
                            LET l_oqc.oqc11=l_oqc13_up*l_oqa09
                            LET l_oqc.oqc07=l_oqc.oqc11/l_oqc.oqc09
                            LET tot_oqc13=tot_oqc13+l_oqc13_up 
                            UPDATE oqc_file SET oqc13=l_oqc13_up,
                                                oqc11=l_oqc.oqc11,
                                                oqc07=l_oqc.oqc07
                               WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
 
                            IF tot_oqc13>tm.amtb THEN
                               UPDATE oqc_file SET 
                                      oqc13=oqc13-(tot_oqc13-tm.amtb),
                                      oqc11=(oqc13-(tot_oqc13-tm.amtb))*l_oqa09,
                                      oqc07=(oqc13-(tot_oqc13-tm.amtb))*l_oqa09/oqc09
                                  WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                               EXIT FOREACH 
                            END IF 
                            IF tot_oqc13=tm.amtb THEN
                               EXIT FOREACH 
                            END IF 
                         END FOREACH      
                         IF tot_oqc13<tm.amtb THEN
                            UPDATE oqc_file SET 
                                   oqc13=oqc13+(tm.amtb-tot_oqc13),
                                   oqc11=(oqc13+(tm.amtb-tot_oqc13))*l_oqa09,
                                   oqc07=(oqc13+(tm.amtb-tot_oqc13))*l_oqa09/oqc09
                               WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                         END IF
                    WHEN '2' 
                         DECLARE oqc_cur12 CURSOR FOR
                            SELECT * FROM oqc_file WHERE oqc01=l_oqa01 
                         FOREACH oqc_cur12 INTO l_oqc.*
                            LET l_oqc13_up=tm.amtb*l_oqc.oqc13/l_oqc13
                            LET l_oqc.oqc11=l_oqc13_up*l_oqa09
                            LET l_oqc.oqc09=l_oqc.oqc11/l_oqc.oqc07
                            LET tot_oqc13=tot_oqc13+l_oqc13_up 
                            UPDATE oqc_file SET oqc13=l_oqc13_up,
                                                oqc11=l_oqc.oqc11,
                                                oqc09=l_oqc.oqc09
                               WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                            IF tot_oqc13>tm.amtb THEN
                               UPDATE oqc_file SET 
                                      oqc13=oqc13-(tot_oqc13-tm.amtb),
                                      oqc11=(oqc13-(tot_oqc13-tm.amtb))*l_oqa09,
                                      oqc09=(oqc13-(tot_oqc13-tm.amtb))*l_oqa09/oqc07
                                  WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                               EXIT FOREACH 
                            END IF 
                            IF tot_oqc13=tm.amtb THEN
                               EXIT FOREACH 
                            END IF 
                         END FOREACH      
                         IF tot_oqc13<tm.amtb THEN
                            UPDATE oqc_file SET 
                                   oqc13=oqc13+(tm.amtb-tot_oqc13),
                                   oqc11=(oqc13+(tm.amtb-tot_oqc13))*l_oqa09,
                                   oqc09=(oqc13+(tm.amtb-tot_oqc13))*l_oqa09/oqc07
                               WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                         END IF
               END CASE
            END IF
         END IF
 
         #--------------- 製費
         IF tm.c='Y' THEN         
            SELECT SUM(oqc14) INTO l_oqc14 FROM oqc_file WHERE oqc01=l_oqa01 
            IF l_oqc14 IS NOT NULL AND l_oqc14!=0 THEN
               LET tot_oqc14=0
               CASE tm.e
                    WHEN '1' 
                         DECLARE oqc_cur21 CURSOR FOR
                         SELECT * FROM oqc_file WHERE oqc01=l_oqa01 
                         FOREACH oqc_cur21 INTO l_oqc.*
                            LET l_oqc14_up=tm.amtc*l_oqc.oqc14/l_oqc14
                            LET l_oqc.oqc12=l_oqc14_up*l_oqa09
                            LET l_oqc.oqc08=l_oqc.oqc12/l_oqc.oqc10
                            LET tot_oqc14=tot_oqc14+l_oqc14_up 
                            UPDATE oqc_file SET oqc14=l_oqc14_up,
                                                oqc12=l_oqc.oqc12,
                                                oqc08=l_oqc.oqc08
                               WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
 
                            IF tot_oqc14>tm.amtc THEN
                               UPDATE oqc_file SET 
                                      oqc14=oqc14-(tot_oqc14-tm.amtc),
                                      oqc12=(oqc14-(tot_oqc14-tm.amtc))*l_oqa09,
                                      oqc08=(oqc14-(tot_oqc14-tm.amtc))*l_oqa09/oqc10
                                  WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                               EXIT FOREACH 
                            END IF 
                            IF tot_oqc14=tm.amtc THEN
                               EXIT FOREACH 
                            END IF 
                         END FOREACH      
                         IF tot_oqc14<tm.amtc THEN
                            UPDATE oqc_file SET 
                                   oqc14=oqc14+(tm.amtc-tot_oqc14),
                                   oqc12=(oqc14+(tm.amtc-tot_oqc14))*l_oqa09,
                                   oqc08=(oqc14+(tm.amtc-tot_oqc14))*l_oqa09/oqc10
                               WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                         END IF
                    WHEN '2' 
                         DECLARE oqc_cur22 CURSOR FOR
                            SELECT * FROM oqc_file WHERE oqc01=l_oqa01 
                         FOREACH oqc_cur22 INTO l_oqc.*
                            LET l_oqc14_up=tm.amtc*l_oqc.oqc14/l_oqc14
                            LET l_oqc.oqc12=l_oqc14_up*l_oqa09
                            LET l_oqc.oqc10=l_oqc.oqc12/l_oqc.oqc08
                            LET tot_oqc14=tot_oqc14+l_oqc14_up 
                            UPDATE oqc_file SET oqc14=l_oqc14_up,
                                                oqc12=l_oqc.oqc12,
                                                oqc10=l_oqc.oqc10
                               WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                            IF tot_oqc14>tm.amtc THEN
                               UPDATE oqc_file SET 
                                      oqc14=oqc14-(tot_oqc14-tm.amtc),
                                      oqc12=(oqc14-(tot_oqc14-tm.amtc))*l_oqa09,
                                      oqc10=(oqc14-(tot_oqc14-tm.amtc))*l_oqa09/oqc08
                                  WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                               EXIT FOREACH 
                            END IF 
                            IF tot_oqc14=tm.amtc THEN
                               EXIT FOREACH 
                            END IF 
                         END FOREACH      
                         IF tot_oqc14<tm.amtc THEN
                            UPDATE oqc_file SET 
                                   oqc14=oqc14+(tm.amtc-tot_oqc14),
                                   oqc12=(oqc14+(tm.amtc-tot_oqc14))*l_oqa09,
                                   oqc10=(oqc14+(tm.amtc-tot_oqc14))*l_oqa09/oqc08
                               WHERE oqc01=l_oqa01 AND oqc02=l_oqc.oqc02
                         END IF
               END CASE
            END IF
         END IF
 
         SELECT SUM(oqb11) INTO g_oqa.oqa13 FROM oqb_file WHERE oqb01=tm.id  
         IF g_oqa.oqa13 IS NULL THEN LET g_oqa.oqa13=0 END IF
 
         SELECT SUM(oqc13),SUM(oqc14) INTO g_oqa.oqa14,g_oqa.oqa15 
           FROM oqc_file WHERE oqc01=tm.id       
         IF g_oqa.oqa14 IS NULL THEN LET g_oqa.oqa14=0 END IF
         IF g_oqa.oqa15 IS NULL THEN LET g_oqa.oqa15=0 END IF
 
         SELECT SUM(oqd04) INTO g_oqa.oqa16 FROM oqd_file WHERE oqd01=tm.id
         IF g_oqa.oqa16 IS NULL THEN LET g_oqa.oqa16=0 END IF
 
         LET g_oqa.oqa17=g_oqa.oqa13+g_oqa.oqa14+g_oqa.oqa15+g_oqa.oqa16
         UPDATE oqa_file SET oqa13=g_oqa.oqa13,
                             oqa14=g_oqa.oqa14,
                             oqa15=g_oqa.oqa15,
                             oqa16=g_oqa.oqa16,
                             oqa17=g_oqa.oqa17
            WHERE oqa01=tm.id
     END FOREACH
   #No.FUN-710046  --Begin
   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
   END IF
   #No.FUN-710046  --End
END FUNCTION
 
FUNCTION p310_set_entry()
 
  #MOD-650024-begin
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("id",TRUE)   
   END IF 
  #MOD-650024-end
 
    IF INFIELD(a) OR (NOT g_before_input_done) THEN
       IF tm.a = 'Y' THEN
          CALL cl_set_comp_entry("amta",TRUE)
       END IF
    END IF
    IF INFIELD(b) OR (NOT g_before_input_done) THEN
       IF tm.b = 'Y' THEN
          CALL cl_set_comp_entry("amtb,d",TRUE)
       END IF
    END IF
    IF INFIELD(c) OR (NOT g_before_input_done) THEN
       IF tm.b = 'Y' THEN
          CALL cl_set_comp_entry("amtc,e",TRUE)
       END IF
    END IF
   
END FUNCTION
 
FUNCTION p310_set_no_entry()
 
    IF INFIELD(a) OR (NOT g_before_input_done) THEN
       IF tm.a = 'N' THEN
          CALL cl_set_comp_entry("amta",FALSE)
       END IF
    END IF
    IF INFIELD(b) OR (NOT g_before_input_done) THEN
       IF tm.b = 'N' THEN
          CALL cl_set_comp_entry("amtb,d",FALSE)
       END IF
    END IF
    IF INFIELD(c) OR (NOT g_before_input_done) THEN
       IF tm.b = 'N' THEN
          CALL cl_set_comp_entry("amtc,e",FALSE)
       END IF
    END IF
   #MOD-650024-begin
    IF INFIELD(id) OR (NOT g_before_input_done) THEN
       IF NOT cl_null(g_argv1) THEN
          CALL cl_set_comp_entry("id",FALSE)
       END IF
    END IF
   #MOD-650024-end
END FUNCTION
 
