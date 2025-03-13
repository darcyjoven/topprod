# Prog. Version..: '5.30.06-13.03.29(00003)'     #
#
# Pattern name...: axcr802.4gl
# Descriptions...: 客户发出商品进销存表 
# Date & Author..: No.FUN-C60033 12/06/11 By minpp
# Modify.........: FUN-C60033 12/07/23 By xuxz 判斷料件是否為MISC
# Modify.........: No:MOD-CB0110 12/11/12 By wujie 默认账套带ccz12,默认成本计算类型带ccz28，默认年月带ccz01，ccz02
# Modify.........: No.TQC-D20046 13/02/26 By chenjing 報表打印料件編號帶出品名和規格
# Modify.........: No.TQC-D20046 13/03/04 By xuxz ccc08添加開窗

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm RECORD
          wc     LIKE type_file.chr1000,
          yy     LIKE type_file.num5,
          mm     LIKE type_file.num5,
          ccc07  LIKE ccc_file.ccc07,
          ccc08  LIKE ccc_file.ccc08,
          flag   LIKE type_file.chr1,
          MORE    LIKE type_file.chr1
         END  RECORD
DEFINE  g_str   STRING 
DEFINE  g_sql   STRING 
DEFINE  l_table      STRING
DEFINE  g_change_lang    LIKE type_file.chr1

MAIN 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("axc")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   #判讀oaz93是否為N，為N才運行，不為N則報錯：系統參數做發出商品管理，才可執行本作業！
   SELECT oaz93 INTO g_oaz.oaz93 FROM oaz_file WHERE oaz00='0'
   IF g_oaz.oaz93 = 'Y' THEN
      CALL cl_err('','axc-127',1)
      EXIT PROGRAM
   END IF
   LET g_sql = "cfc07.cfc_file.cfc07,",
               "cfc08.cfc_file.cfc08,",
               "cfc11.cfc_file.cfc11,",
               "cfc13.cfc_file.cfc13,",        #TQC-D20046 cj add
               "cfc15.cfc_file.cfc15,",
               "tot.type_file.num20_6,",
               "sum1.cfc_file.cfc15,",
               "tot1.type_file.num20_6,",
               "sum2.cfc_file.cfc15,",
               "tot2.type_file.num20_6,",
               "sum3.cfc_file.cfc15,",
               "tot3.type_file.num20_6,",
               "sum4.cfc_file.cfc15,",
               "tot4.type_file.num20_6,",
               "sum5.cfc_file.cfc15,",
               "tot5.type_file.num20_6,",
               "ima021.ima_file.ima021"      #TQC-D20046 cj add   
 
   LET l_table = cl_prt_temptable('axcr802',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?,?,?)"      #TQC-D20046 cj add 2?  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   INITIALIZE tm.* TO NULL
   LET tm.wc = ARG_VAL(1) 
   LET tm.yy = ARG_VAL(2)
   LET tm.mm = ARG_VAL(3)
   LET tm.ccc07 = ARG_VAL(4)
   LET tm.ccc08 = ARG_VAL(5)
   LET tm.flag = ARG_VAL(6)
   LET tm.more = ARG_VAL(7)
   LET g_bgjob  = ARG_VAL(8)
   LET g_pdate=ARG_VAL(9)
   LET g_towhom=ARG_VAL(10)
   LET g_rlang=ARG_VAL(11)
   LET g_prtway=ARG_VAL(12)
   LET g_copies=ARG_VAL(13)

      IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
         THEN CALL r802_tm()                      # Input print condition
         ELSE CALL axcr802()                         # Read data and create out-file
      END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   
END MAIN           

FUNCTION r802_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd          LIKE type_file.chr1000     
DEFINE li_chk_bookno  LIKE type_file.num5    
DEFINE l_pja01        LIKE pja_file.pja01
DEFINE l_imd09        LIKE imd_file.imd09
LET p_row = 4 LET p_col = 16
   OPEN WINDOW axcr802_w AT p_row,p_col
     WITH FORM "axc/42f/axcr802"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 

     CALL cl_ui_init()
     CALL cl_set_comp_entry('ccc08',FALSE)#TQC-D20046 add
     CALL cl_opmsg('p')
     LET g_pdate = g_today
     LET g_rlang = g_lang
     LET g_bgjob = 'N'
     LET g_copies = '1' 
   WHILE TRUE
   DIALOG ATTRIBUTE(unbuffered)
   CONSTRUCT BY NAME tm.wc ON cfc07,cfc11
    BEFORE CONSTRUCT
       LET tm.flag = 'N'
       LET tm.more = 'N'
       LET tm.ccc08 = ' '
    END CONSTRUCT
    
    INPUT BY NAME tm.yy,tm.mm,tm.ccc07,tm.ccc08,tm.flag,tm.more
#No.MOD-CB0110 --begin
         BEFORE INPUT 
            LET tm.yy = g_ccz.ccz01
            LET tm.mm = g_ccz.ccz02
            LET tm.ccc07 = g_ccz.ccz28
            DISPLAY BY NAME tm.yy,tm.mm,tm.ccc07
#No.MOD-CB0110 --end

       AFTER FIELD yy
         IF NOT cl_null(tm.yy) THEN 
            IF tm.yy > 9999 OR tm.yy < 1000 THEN 
              CALL cl_err('','ask-003',0)
              NEXT FIELD yy
            END IF 
         END IF 
         
        AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN 
           IF tm.mm >13 OR tm.mm < 1 THEN 
              CALL cl_err('','agl-013',0)
              NEXT FIELD mm
            END IF  
          END IF 

         ON CHANGE ccc07
            IF NOT cl_null(tm.ccc07) THEN
                IF tm.ccc07 MATCHES '[345]' THEN
                  CALL cl_set_comp_entry("ccc08",TRUE)
                ELSE
                   CALL cl_set_comp_entry("ccc08",FALSE)
                END IF 
             END IF

         AFTER FIELD ccc08
            IF NOT cl_null(tm.ccc08) OR tm.ccc08 != ' '  THEN
               IF tm.ccc07='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=tm.ccc08
                                             AND pjaclose='N'
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",tm.ccc08,"",STATUS,"","sel pja:",1)
                     NEXT FIELD ccc07
                  END IF
               END IF
               IF tm.ccc07='5'THEN
                  SELECT UNIQUE imd09 INTO l_imd09 FROM imd_file WHERE imd09=tm.ccc08
                  IF STATUS THEN
                     CALL cl_err3("sel","imd_file",tm.ccc08,"",STATUS,"","sel imd:",1)
                     NEXT FIELD ccc07
                  END IF
               END IF
            ELSE
               LET tm.ccc08 = ' '
            END IF
 
         AFTER FIELD flag
            IF tm.flag='Y' THEN 
               CALL cl_set_comp_visible("cfc11,cfc13,cfc15,sum1,sum2,sum3,sum4,sum5,ima021",TRUE)
            ELSE
               CALL cl_set_comp_visible("cfc11,cfc13,cfc15,sum1,sum2,sum3,sum4,sum5,ima021",FALSE)  #TQC-D20046 cj add cfc13 ima021
            END IF  

         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF

            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
         END INPUT
             
       ON ACTION controlp
         CASE
           WHEN INFIELD(cfc07)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_cfc07"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO cfc07
            NEXT FIELD cfc07

           WHEN INFIELD(cfc11)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_cfc11"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO cfc11
            NEXT FIELD cfc11
         #TQC-D20046--xxz--add-str
         #ccc08添加開窗，當ccc007 = 4,5的時候可以開窗
           WHEN INFIELD(ccc08)
              IF tm.ccc07 MATCHES '[45]' THEN
                 CALL cl_init_qry_var()
                 CASE tm.ccc07
                    WHEN '4'
                       LET g_qryparam.form = "q_pja"
                    WHEN '5'
                       LET g_qryparam.form = "q_gem4"
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 = tm.ccc08
                 CALL cl_create_qry() RETURNING tm.ccc08
                 DISPLAY BY NAME  tm.ccc08
                 NEXT FIELD ccc08
              END IF
         #TQC-D20046--xxz--add-end
        END CASE
 
      ON ACTION locale
         LET g_change_lang = TRUE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
    #    EXIT DIALOG            #TQC-D20046 cj mark

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about        
         CALL cl_about()     

      ON ACTION help         
         CALL cl_show_help()  

      ON ACTION controlg      
         CALL cl_cmdask()     

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION accept
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=1
         EXIT DIALOG
    END DIALOG
    IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW axcr802_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr802'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axcr802','9031',1)
      ELSE
         LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,    
                        "'",tm.wc CLIPPED,"'",
                        "'",tm.yy,"'",
                        "'",tm.mm,"'",
                        "'",tm.ccc07,"'",
                        "'",tm.ccc08,"'",
                        "'",tm.flag,"'",
                        "'",tm.more,"'",
                        "'",g_bgjob,"'",
                        "'",g_pdate,"'",
                        "'",g_towhom,"'",
                        "'",g_rlang,"'",
                        "'",g_prtway,"'",
                        "'",g_copies,"'"
                       
            CALL cl_cmdat('axcr802',g_time,l_cmd)
          END IF 
         CLOSE WINDOW axcr802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF    

      CALL cl_wait()
      CALL axcr802()

      ERROR ""
   END WHILE

   CLOSE WINDOW axcr802_w

END FUNCTION  

FUNCTION axcr802()
DEFINE l_c1,l_c2  LIKE type_file.num5
DEFINE l_s1,l_s2  LIKE type_file.num20_6
DEFINE l_str       LIKE type_file.chr1000
DEFINE temp_cfc11 STRING #FUN-C60033 add by xuxz
DEFINE  sr1          RECORD
                cfc07   LIKE cfc_file.cfc07,
                cfc08   LIKE cfc_file.cfc08,
                cfc11   LIKE cfc_file.cfc11,
                cfc13   LIKE cfc_file.cfc13             #TQC-D20046 cj add
                 END RECORD,
        sr      RECORD  
                cfc15   LIKE cfc_file.cfc15, 
                tot     LIKE type_file.num20_6,
                sum1    LIKE cfc_file.cfc15,
                tot1    LIKE type_file.num20_6,
                sum2    LIKE cfc_file.cfc15,
                tot2    LIKE type_file.num20_6,
                sum3    LIKE cfc_file.cfc15,
                tot3    LIKE type_file.num20_6,
                sum4    LIKE cfc_file.cfc15,
                tot4    LIKE type_file.num20_6,
                sum5    LIKE cfc_file.cfc15,
                tot5    LIKE type_file.num20_6,
                ima021  LIKE ima_file.ima021      #TQC-D20046 cj add
                END RECORD
       
       CALL cl_del_data(l_table)          
       SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
       IF tm.flag='N' THEN
          LET g_sql=" SELECT DISTINCT cfc07,cfc08,'','','','','','','','', ",
                    " '','','','','','','' ",     #TQC-D20046 add 2''
                    " FROM cfc_file,occ_file ",
                    " WHERE occ01= cfc07 AND occacti='Y' ",
                    "   AND ",tm.wc CLIPPED
          PREPARE sel_cfc_pre FROM g_sql
          DECLARE sel_cfc_cs CURSOR FOR sel_cfc_pre
          FOREACH sel_cfc_cs INTO sr1.*  
          IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
          #期初金额
             LET l_s1=0
             LET l_s2=0
             LET sr.tot=0
             SELECT SUM(cfc15*ccc23) INTO l_s1 FROM cfc_file,ccc_file WHERE cfc11=ccc01 AND cfc05=ccc02
                                                                  AND cfc06=ccc03 AND (cfc05<tm.yy OR (cfc05=tm.yy AND cfc06<tm.mm))
                                                                  AND ccc01 NOT LIKE 'MISC%' #FUN-C60033 add bu xuxz
                                                                  AND ccc07=tm.ccc07 AND cfc01=1 AND cfc07=sr1.cfc07
                                                                  GROUP BY cfc07 
            SELECT SUM(cfc15*ccc23) INTO l_s2 FROM cfc_file,ccc_file WHERE cfc11=ccc01 AND cfc05=ccc02
                                                                  AND cfc06=ccc03 AND (cfc05<tm.yy OR (cfc05=tm.yy AND cfc06<tm.mm))
                                                                  AND ccc01 NOT LIKE 'MISC%' #FUN-C60033 add bu xuxz
                                                                  AND ccc07=tm.ccc07  AND cfc01=-1  AND cfc07=sr1.cfc07
                                                                  GROUP BY cfc07
            IF cl_null(l_s1) THEN LET l_s1 = 0 END IF
            IF cl_null(l_s2) THEN LET l_s2 = 0 END IF                                                     
            LET sr.tot=l_s1-l_s2
            IF cl_null(sr.tot) THEN LET sr.tot=0 END IF
            #本月出货转入金额
            LET sr.tot1=0
            SELECT SUM(cfc15*ccc23) INTO sr.tot1 FROM cfc_file,ccc_file
            WHERE cfc11=ccc01 AND cfc05=ccc02 AND cfc06=ccc03 AND cfc00 IN ('1','2')
              AND cfc01=1 AND ccc07=tm.ccc07 AND ccc08 = tm.ccc08 AND ccc02=tm.yy 
              AND ccc01 NOT LIKE 'MISC%' #FUN-C60033 add bu xuxz
              AND ccc03=tm.mm AND cfc07=sr1.cfc07 GROUP BY cfc07
            IF cl_null(sr.tot1) THEN LET sr.tot1=0 END IF
            #本月出货转出金额
            LET sr.tot2=0
            SELECT SUM(cfc15*ccc23) INTO sr.tot2 FROM cfc_file,ccc_file 
             WHERE cfc11=ccc01 AND cfc05=ccc02 AND  cfc06=ccc03  AND cfc00 IN ('1','2') 
               AND ccc01 NOT LIKE 'MISC%' #FUN-C60033 add bu xuxz
               AND cfc01=-1    AND ccc07=tm.ccc07 AND ccc08 = tm.ccc08 AND ccc02=tm.yy AND ccc03=tm.mm
               AND cfc07=sr1.cfc07  GROUP BY cfc07
            IF cl_null(sr.tot2) THEN LET sr.tot2=0 END IF
           #本月销退转入金额
            LET sr.tot3=0
            SELECT SUM(cfc15*ccc23) INTO sr.tot3 FROM cfc_file,ccc_file 
             WHERE cfc11=ccc01 AND cfc05=ccc02 AND cfc06=ccc03 AND  cfc00='3' AND cfc01=1 
               AND ccc01 NOT LIKE 'MISC%' #FUN-C60033 add bu xuxz
               AND  ccc07=tm.ccc07 AND ccc08 = tm.ccc08 AND  ccc02=tm.yy AND ccc03=tm.mm
               AND cfc07=sr1.cfc07  GROUP BY cfc07
            IF cl_null(sr.tot3) THEN LET sr.tot3=0 END IF
          #本月销退转出金额
            LET sr.tot4=0
            SELECT SUM(cfc15*ccc23) INTO sr.tot4 FROM cfc_file,ccc_file 
             WHERE  cfc11=ccc01 AND cfc05=ccc02 AND  cfc06=ccc03  AND  cfc00='3' 
               AND  cfc01=-1 AND ccc07=tm.ccc07 AND  ccc08 = tm.ccc08 AND  ccc02=tm.yy 
               AND ccc01 NOT LIKE 'MISC%' #FUN-C60033 add bu xuxz
               AND  ccc03=tm.mm AND cfc07=sr1.cfc07  GROUP BY cfc07 
           IF cl_null(sr.tot4) THEN LET sr.tot4=0 END IF
         #期末金额 
            LET sr.tot5=0
            LET sr.tot5 =sr.tot +sr.tot1 -sr.tot2 
                                  +sr.tot3 - sr.tot4 
         #TQC-D20046--cj--add--str--
            SELECT ima021 INTO sr.ima021 FROM ima_file WHERE ima01 = sr1.cfc11
         #TQC-D20046--cj--add--end--
            EXECUTE insert_prep USING sr1.*,sr.*
            END FOREACH
        ELSE   
           #期初数量
            LET g_sql=" SELECT DISTINCT cfc07,cfc08,cfc11,cfc13,'','','','','','','', ",
                    " '','','','','','' ",          #TQC-D20046 cj add cfc13 ''
                    " FROM cfc_file,occ_file ",
                    " WHERE occ01= cfc07 AND occacti='Y' ",
                    "   AND ",tm.wc CLIPPED
            PREPARE sel_cfc_pre1 FROM g_sql
            DECLARE sel_cfc_cs1 CURSOR FOR sel_cfc_pre1
            FOREACH sel_cfc_cs1 INTO sr1.*
            LET l_c1=0
            LET l_c2=0
            LET sr.cfc15=0
            SELECT SUM(cfc15) INTO l_c1 FROM cfc_file WHERE cfc01=1 AND (cfc05<tm.yy OR (cfc05=tm.yy AND cfc06<tm.mm)) 
               AND cfc11=sr1.cfc11 AND cfc07=sr1.cfc07 GROUP BY cfc07,cfc11 
            SELECT SUM(cfc15) INTO l_c2 FROM cfc_file WHERE cfc01=-1 AND (cfc05<tm.yy OR (cfc05=tm.yy AND cfc06<tm.mm))
               AND cfc11=sr1.cfc11 AND cfc07=sr1.cfc07 GROUP BY cfc07,cfc11
            IF cl_null(l_c1) THEN  LET l_c1=0 END IF
            IF cl_null(l_c2) THEN  LET l_c1=0 END IF
            LET sr.cfc15=l_c1-l_c2
           #期初金额
           LET l_s1=0
           LET l_s2=0
           LET sr.tot=0
           SELECT SUM(cfc15*ccc23) INTO l_s1 FROM cfc_file,ccc_file WHERE cfc11=ccc01 AND cfc05=ccc02
                                                                     AND cfc06=ccc03 AND (cfc05<tm.yy OR (cfc05=tm.yy AND cfc06<tm.mm))
                                                                     AND ccc07=tm.ccc07 AND cfc01=1 AND cfc11=sr1.cfc11
                                                                     AND cfc07=sr1.cfc07  GROUP BY cfc07,cfc11
           SELECT SUM(cfc15*ccc23) INTO l_s2 FROM cfc_file,ccc_file WHERE cfc11=ccc01 AND cfc05=ccc02
                                                                     AND cfc06=ccc03 AND (cfc05<tm.yy OR (cfc05=tm.yy AND cfc06<tm.mm))
                                                                     AND ccc07=tm.ccc07  AND cfc01=-1  AND cfc11=sr1.cfc11
                                                                     GROUP BY cfc07,cfc11
           IF cl_null(l_s1) THEN LET l_s1 = 0 END IF
           IF cl_null(l_s2) THEN LET l_s2 = 0 END IF
           LET sr.tot=l_s1-l_s2
           #本月出货转入数量
           LET sr.sum1=0
           SELECT SUM(cfc15) INTO sr.sum1 
             FROM cfc_file WHERE cfc00 IN ('1','2') AND cfc01=1
                             AND cfc05=tm.yy AND cfc06=tm.mm AND cfc11=sr1.cfc11
                             AND cfc07=sr1.cfc07  GROUP BY cfc07,cfc11              
           IF cl_null(sr.sum1) THEN  LET sr.sum1 =0 END IF
           #本月出货转入金额
           LET sr.tot1=0
           SELECT SUM(cfc15*ccc23) INTO sr.tot1 FROM cfc_file,ccc_file
            WHERE cfc11=ccc01 AND cfc05=ccc02 AND cfc06=ccc03 AND cfc00 IN ('1','2')
              AND cfc01=1 AND ccc07=tm.ccc07 AND ccc08 = tm.ccc08 AND ccc02=tm.yy 
              AND ccc03=tm.mm AND cfc11=sr1.cfc11 AND cfc07=sr1.cfc07  GROUP BY cfc07,cfc11
           IF cl_null(sr.tot1) THEN  LET sr.tot1 =0 END IF
           #本月出货转出数量
           LET sr.sum2=0
           SELECT SUM(cfc15) INTO sr.sum2 
             FROM  cfc_file WHERE cfc00 IN ('1','2') 
                              AND  cfc01=-1 AND cfc05=tm.yy 
                              AND cfc06=tm.mm AND cfc11=sr1.cfc11
                              AND cfc07=sr1.cfc07  GROUP BY cfc07,cfc11
           IF cl_null(sr.sum2) THEN  LET sr.sum2 =0 END IF
           #本月出货转出金额
           LET sr.tot2=0
           SELECT SUM(cfc15*ccc23) INTO sr.tot2 FROM cfc_file,ccc_file 
            where cfc11=ccc01 AND cfc05=ccc02 AND  cfc06=ccc03  AND cfc00 IN ('1','2') 
              AND  cfc01=-1 AND ccc07=tm.ccc07 AND ccc08 = tm.ccc08 AND ccc02=tm.yy AND ccc03=tm.mm
              AND cfc11=sr1.cfc11  AND cfc07=sr1.cfc07  GROUP BY cfc07,cfc11
           IF cl_null(sr.tot2) THEN  LET sr.tot2 =0 END IF

           #本月销退转入数量
           LET sr.sum3=0
           SELECT SUM(cfc15) INTO sr.sum3 FROM  cfc_file
            where cfc00='3' AND  cfc01=1 AND  cfc05=tm.yy AND  cfc06=tm.mm
              AND cfc11=sr1.cfc11  AND cfc07=sr1.cfc07  GROUP BY cfc07,cfc11
           IF cl_null(sr.sum3) THEN  LET sr.sum3 =0 END IF
           #本月销退转入金额
           LET sr.tot3=0
           SELECT SUM(cfc15*ccc23) INTO sr.tot3 FROM cfc_file,ccc_file
            WHERE cfc11=ccc01 AND cfc05=ccc02 AND cfc06=ccc03 AND  cfc00='3' AND cfc01=1
              AND  ccc07=tm.ccc07 AND ccc08 = tm.ccc08 AND  ccc02=tm.yy AND ccc03=tm.mm
              AND cfc11=sr1.cfc11  AND cfc07=sr1.cfc07  GROUP BY cfc07,cfc11
           IF cl_null(sr.tot3) THEN  LET sr.tot3 =0 END IF
           #本月销退转出数量
           LET sr.sum4=0
           SELECT SUM(cfc15) INTO sr.sum4  FROM  cfc_file
            WHERE cfc00='3' AND  cfc01=-1 AND  cfc05=tm.yy AND  cfc06=tm.mm
              AND cfc11=sr1.cfc11 AND cfc07=sr1.cfc07 GROUP BY cfc07,cfc11
          IF cl_null(sr.sum4) THEN  LET sr.sum4 =0 END IF
          #本月销退转出金额
           LET sr.tot4=0
           SELECT SUM(cfc15*ccc23) INTO sr.tot4 FROM cfc_file,ccc_file
            WHERE  cfc11=ccc01 AND cfc05=ccc02 AND  cfc06=ccc03  AND  cfc00='3'
              AND  cfc01=-1 AND ccc07=tm.ccc07 AND  ccc08 = tm.ccc08 AND  ccc02=tm.yy
              AND  ccc03=tm.mm AND cfc11=sr1.cfc11 AND cfc07=sr1.cfc07  GROUP BY cfc07,cfc11
          IF cl_null(sr.tot4) THEN  LET sr.tot4 =0 END IF
          #期末数量
          LET sr.sum5=0
          LET sr.sum5 = sr.cfc15 + sr.sum1 - sr.sum2 + sr.sum3 - sr.sum4
          #FUN-C60033--add--str
          LET temp_cfc11 = sr1.cfc11
          IF temp_cfc11.substring(1,4) = 'MISC' THEN 
             LET sr.tot = 0
             LET sr.tot1 = 0
             LET sr.tot2 = 0
             LET sr.tot3 = 0
             LET sr.tot4 = 0 
          END IF
          #FUN-C60033--add--end
          #期末金额
          LET sr.tot5=0
          LET sr.tot5 =sr.tot +sr.tot1-sr.tot2+sr.tot3 - sr.tot4
         #TQC-D20046--cj--add--str--
          SELECT ima021 INTO sr.ima021 FROM ima_file WHERE ima01 = sr1.cfc11
         #TQC-D20046--cj--add--end--
          EXECUTE insert_prep USING sr1.*,sr.*
          END FOREACH
        END IF
        LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
        LET l_str=''
        SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
        IF g_zz05='Y' THEN
           CALL cl_wcchp(tm.wc,'cfc07,cfc11')
           RETURNING tm.wc
        END IF
        LET l_str=tm.wc,";",tm.flag

        IF tm.flag='N' THEN 
           CALL cl_prt_cs3('axcr802','axcr802',g_sql,l_str)
        ELSE
           CALL cl_prt_cs3('axcr802','axcr802_1',g_sql,l_str)
        END IF
        
END FUNCTION
#FUN-C60033
