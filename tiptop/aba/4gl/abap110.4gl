# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abap110.4gl
# Descriptions...: 條碼重計作業
# Date & Author..: No:DEV-CA0018 2012/11/07 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---

DATABASE ds    #TQC-670013

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"


DEFINE g_wc,g_sql           STRING,
       g_yy,g_mm            LIKE type_file.num5,
       g_stime,g_etime      LIKE type_file.chr8,
       g_item_t             LIKE imgb_file.imgb01,
       g_d1,g_date          LIKE type_file.dat,
       g_argv0              LIKE type_file.chr1,
       show                 LIKE type_file.chr1
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_msg           STRING
DEFINE g_change_lang   LIKE type_file.chr1          #是否有做語言切換

MAIN
   DEFINE l_flag  LIKE type_file.chr1
   DEFINE l_cnt   LIKE type_file.num5

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv0 = ARG_VAL(1)      #预留
   LET g_wc    = ARG_VAL(2)      #条件
   LET g_yy    = ARG_VAL(3)      #年度
   LET g_mm    = ARG_VAL(4)      #期别
   LET g_bgjob = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   WHILE TRUE
      LET g_success = 'Y'
      LET show = 'Y'
      IF g_bgjob = 'N' THEN
         CALL p110_tm()
         IF cl_sure(21,21) THEN
             IF (g_yy*12+g_mm)>=(g_sma.sma51*12+g_sma.sma52) THEN
                 CALL s_errmsg('','','','aim-929',1)
                 CONTINUE WHILE
             END IF
             CALL cl_wait()
             BEGIN WORK
             LET g_success = 'Y'
             CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_d1,g_date
             CALL abap110()
             CALL s_showmsg()
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
                 CLOSE WINDOW p110_w  #NO.FUN-570122
                 EXIT WHILE
             END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_d1,g_date
         CALL abap110()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


FUNCTION p110_tm()
   DEFINE lc_cmd  LIKE type_file.chr1000

   OPEN WINDOW abap110_w WITH FORM "aba/42f/abap110"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=g_sma.sma53

   WHILE TRUE
     #CONSTRUCT BY NAME g_wc ON imgb00,imgb01,imgb02,imgb03,imgb04   #No:DEV-CA0018--mark
      CONSTRUCT BY NAME g_wc ON imgb01,imgb02,imgb03,imgb04          #No:DEV-CA0018--add
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION locale
             CALL cl_show_fld_cont()
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
 
          ON ACTION qbe_select
             CALL cl_qbe_select()
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(imgb02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                  #LET g_qryparam.form ="cq_imd"  #No:DEV-CA0018--mark
                   LET g_qryparam.form ="q_imd21" #No:DEV-CA0018--add
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imgb02
                   NEXT FIELD imgb02
                WHEN INFIELD(imgb03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_ime2"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imgb03
                   NEXT FIELD imgb03
                OTHERWISE EXIT CASE
             END CASE
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW abap110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      INPUT BY NAME g_yy,g_mm,show,g_bgjob WITHOUT DEFAULTS
 
         AFTER FIELD g_yy
           #IF g_yy IS NULL THEN NEXT FIELD g_yy END IF #No:DEV-CA0018--mark
            #No:DEV-CA0018--add--begin
            IF NOT cl_null(g_yy) THEN
               CALL p110_azm()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD g_mm
               END IF
            END IF
            #No:DEV-CA0018--add--end
         AFTER FIELD g_mm
            IF NOT cl_null(g_mm) THEN
              #No:DEV-CA0018--mark--begin
              #SELECT azm02 INTO g_azm.azm02 FROM azm_file
              #  WHERE azm01 = g_yy
              #IF g_azm.azm02 = 1 THEN
              #   IF g_mm > 12 OR g_mm < 1 THEN
              #      CALL cl_err('','agl-020',0)
              #      NEXT FIELD g_mm
              #   END IF
              #ELSE
              #   IF g_mm > 13 OR g_mm < 1 THEN
              #      CALL cl_err('','agl-020',0)
              #      NEXT FIELD g_mm
              #   END IF
              #END IF
              #No:DEV-CA0018--mark--end

               #No:DEV-CA0018--add--begin
               CALL p110_azm()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD g_mm
               END IF
               #No:DEV-CA0018--add--end
            END IF
           #IF g_mm IS NULL THEN NEXT FIELD g_mm END IF #No:DEV-CA0018--mark
 
         ON CHANGE g_bgjob
            IF g_bgjob = "Y" THEN
               LET show = "N"
               DISPLAY BY NAME show
               CALL cl_set_comp_entry("show",FALSE)
            ELSE
               CALL cl_set_comp_entry("show",TRUE)
            END IF
 
         AFTER FIELD g_bgjob
            IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
               NEXT FIELD g_bgjob
            END IF
 
      #-------MOD-590100判斷是否大於現行年月
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0 CLOSE WINDOW abap110_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time
               EXIT PROGRAM
 
            END IF
            IF NOT cl_null(g_yy) AND NOT cl_null(g_mm) THEN
               IF (g_yy*12+g_mm)>=(g_sma.sma51*12+g_sma.sma52) THEN
                 #CALL cl_err('','aba-929',1) #No:DEV-CA0018--mark
                  CALL cl_err('','aim-929',1) #No:DEV-CA0018--add
                  NEXT FIELD g_yy
               END IF
            END IF
            #No:DEV-CA0018--add--begin
            CALL p110_azm()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD g_mm
            END IF
            #No:DEV-CA0018--add--end
 
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW abap110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "abap110"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('abap110','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\\")
            LET lc_cmd = lc_cmd CLIPPED,
                    "'",g_argv0 CLIPPED,"'",         #MOD-B20066 add
                    " '",g_wc CLIPPED,"'",
                    " '",g_yy CLIPPED,"'",
                    " '",g_mm CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abap110',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

#No:DEV-CA0018--add--begin
FUNCTION p110_azm()
   DEFINE l_azm02   LIKE azm_file.azm02

   LET g_errno = ''
   IF NOT cl_null(g_yy) AND NOT cl_null(g_mm) THEN
      SELECT azm02 INTO g_azm.azm02
        FROM azm_file
       WHERE azm01 = g_yy
      IF g_azm.azm02 = 1 THEN
         IF g_mm > 12 OR g_mm < 1 THEN
            LET g_errno = 'agl-020'
            RETURN
         END IF
      ELSE
         IF g_mm > 13 OR g_mm < 1 THEN
            LET g_errno = 'agl-020'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION
#No:DEV-CA0018--add--end

FUNCTION abap110()
   DEFINE l_name        LIKE type_file.chr20,
          l_sql         STRING,
         #l_rowid       LIKE type_file.row_id, #No:DEV-CA0018--mark  #不會用到
          l_sw          LIKE type_file.num10,
          l_cnt1        LIKE type_file.num10,
          l_sw_tot      LIKE type_file.num10,
          l_count       LIKE type_file.num10,
          l_bal         LIKE imgb_file.imgb05,
          l_tlfb05      LIKE tlfb_file.tlfb05,
          g_count       LIKE type_file.num5,
          xx            RECORD LIKE tlfb_file.*,
          sr            RECORD
                       #imgb00     LIKE imgb_file.imgb00, #No:DEV-CA0018--mark
                        imgb01     LIKE imgb_file.imgb01,
                        imgb02     LIKE imgb_file.imgb02,
                        imgb03     LIKE imgb_file.imgb03,
                        imgb04     LIKE imgb_file.imgb04,
                        imkb07     LIKE imkb_file.imkb07,
                        imkb08     LIKE imkb_file.imkb08,
                        imkb09     LIKE imkb_file.imkb09,
                        imkb10     LIKE imkb_file.imkb10,
                        imkb11     LIKE imkb_file.imkb11
                       ,imkb12     LIKE imkb_file.imkb12 #No:DEV-CA0018--add
                        END RECORD

     LET g_stime=TIME
     LET g_count=0
    #LET l_sql="SELECT imgb00,imgb01,imgb02,imgb03,imgb04,", #No:DEV-CA0018--mark
     LET l_sql="SELECT imgb01,imgb02,imgb03,imgb04,",        #No:DEV-CA0018--add
               "       imkb07,imkb08,imkb09,imkb10,imkb11 ",
               "      ,imkb12 ",                             #No:DEV-CA0018--add
               "  FROM imgb_file, iba_file, OUTER imkb_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND imgb01 = iba01 ",
              #"   AND imgb00 = iba00 ",                       #No:DEV-CA0018--mark
              #"   AND imgb_file.imgb00=imkb_file.imkb00 ",    #No:DEV-CA0018--mark
               "   AND imgb_file.imgb01=imkb_file.imkb01 ",
               "   AND imgb_file.imgb02=imkb_file.imkb02 ",
               "   AND imgb_file.imgb03=imkb_file.imkb03 ",
               "   AND imgb_file.imgb04=imkb_file.imkb04 ",
               "   AND imkb_file.imkb05=",g_yy,
               "   AND imkb_file.imkb06=",g_mm,
              #" ORDER BY imgb00,imgb01,imgb02,imgb03,imgb04" #No:DEV-CA0018--mark
               " ORDER BY imgb01,imgb02,imgb03,imgb04"        #No:DEV-CA0018--add

     IF show = 'N' THEN
         LET l_count = 1
         LET g_sql="SELECT COUNT(*) ",
                   "  FROM imgb_file,iba_file, OUTER imkb_file ",
                   " WHERE ",g_wc CLIPPED,
                   "   AND imgb01 = iba01 ",
                  #"   AND imgb00 = iba00 ",                    #No:DEV-CA0018--mark
                  #"   AND imgb_file.imgb00=imkb_file.imkb00 ", #No:DEV-CA0018--mark
                   "   AND imgb_file.imgb01=imkb_file.imkb01 ",
                   "   AND imgb_file.imgb02=imkb_file.imkb02 ",
                   "   AND imgb_file.imgb03=imkb_file.imkb03 ",
                   "   AND imgb_file.imgb04=imkb_file.imkb04 ",
                   "   AND imkb_file.imkb05=",g_yy,
                   "   AND imkb_file.imkb06=",g_mm

         PREPARE abap110_show_p FROM g_sql
         IF STATUS THEN
            CALL cl_err('prep:',STATUS,1)
         END IF
         DECLARE abap110_show_c CURSOR FOR abap110_show_p
         IF STATUS THEN
            CALL cl_err('declare p110_show_c:',STATUS,1)
         END IF
         FOREACH abap110_show_c INTO l_sw_tot
         END FOREACH
         IF l_sw_tot>0 THEN
             IF l_sw_tot > 10 THEN
                LET l_sw = l_sw_tot /10
                CALL cl_progress_bar(10)
             ELSE
                CALL cl_progress_bar(l_sw_tot)
             END IF
          END IF
     END IF

     PREPARE abap110_prepare1 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prep:',STATUS,1)
         LET g_success = 'N' #MOD-4C0119
         IF show = 'N' THEN
             CALL cl_close_progress_bar()
         END IF
         RETURN              #MOD-4C0119
     END IF

     DECLARE abap110_curs1 CURSOR FOR abap110_prepare1
     IF STATUS THEN
         CALL cl_err('declare p110_curs1:',STATUS,1)
         LET g_success = 'N' #MOD-4C0119
         IF show = 'N' THEN
             CALL cl_close_progress_bar()
         END IF
         RETURN
     END IF
     CALL s_showmsg_init()
     FOREACH abap110_curs1 INTO sr.*
       IF STATUS THEN
          CALL s_errmsg('','','foreach: ',STATUS,1)
           LET g_success = 'N'
         IF show = 'N' THEN
             CALL cl_close_progress_bar()
         END IF
           RETURN
       END IF
       IF g_success='N' THEN
          LET g_totsuccess='N'
          LET g_success="Y"
       END IF
       LET l_cnt1 = l_cnt1 + 1
       LET g_count=g_count+1
       IF show = 'Y' OR g_bgjob THEN
          #MESSAGE sr.imgb00,sr.imgb01,sr.imgb04,g_count #No:DEV-CA0018--mark
           MESSAGE sr.imgb01,sr.imgb04,g_count           #No:DEV-CA0018--add
           CALL ui.Interface.refresh()
       END IF
       IF cl_null(sr.imkb07) THEN LET sr.imkb07=0 END IF
       IF cl_null(sr.imkb08) THEN LET sr.imkb08=0 END IF
       IF cl_null(sr.imkb09) THEN LET sr.imkb09=0 END IF
       IF cl_null(sr.imkb10) THEN LET sr.imkb10=0 END IF
       IF cl_null(sr.imkb11) THEN LET sr.imkb11=0 END IF
       IF cl_null(sr.imkb12) THEN LET sr.imkb12=0 END IF #No:DEV-CA0018--add
      #No:DEV-CA0018--mark--begin
      #LET l_bal = sr.imkb07 + sr.imkb08+
      #            sr.imkb09 + sr.imkb10+
      #            sr.imkb011
      #No:DEV-CA0018--mark--end
       LET l_bal = sr.imkb12 #No:DEV-CA0018--add

       ####---庫存異動
       DECLARE p110_c2 CURSOR FOR
        #SELECT rowid,tlfb_file.* FROM tlfb_file #No:DEV-CA0018--mark
        # WHERE tlfb00 = sr.imgb00               #No:DEV-CA0018--mark
         SELECT tlfb_file.*                      #No:DEV-CA0018--add
           FROM tlfb_file                        #No:DEV-CA0018--add
          WHERE tlfb14 > g_date                  #No:DEV-CA0018--add
            AND tlfb01 = sr.imgb01
            AND tlfb02 = sr.imgb02
            AND tlfb03 = sr.imgb03
            AND tlfb04 = sr.imgb04
          ORDER BY tlfb11,tlfb12
      #FOREACH p110_c2 INTO l_rowid,xx.* #No:DEV-CA0018--mark
       FOREACH p110_c2 INTO xx.*         #No:DEV-CA0018--add
         IF STATUS THEN
            CALL s_errmsg('','','foreach2:',STATUS,1)
             LET g_success = 'N'
             IF show = 'N' THEN
                  CALL cl_close_progress_bar()
             END IF
              EXIT FOREACH
         END IF

         LET l_tlfb05 = xx.tlfb05 * xx.tlfb06
         LET l_bal = l_bal + l_tlfb05

       END FOREACH
       IF STATUS THEN
           CALL s_errmsg('','','foreach p110_c2:',STATUS,1)
            LET g_success = 'N'
            IF show = 'N' THEN
                 CALL cl_close_progress_bar()
            END IF
            RETURN
       END IF

       UPDATE imgb_file SET imgb05=l_bal
       #WHERE imgb00=sr.imgb00 #No:DEV-CA0018--mark
        WHERE 1=1              #No:DEV-CA0018--add
          AND imgb01=sr.imgb01 AND imgb02=sr.imgb02
          AND imgb03=sr.imgb03 AND imgb04=sr.imgb04
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         #LET g_showmsg = sr.imgb00,"/",sr.imgb01,"/",sr.imgb02,"/",sr.imgb03,"/",sr.imgb04  #No:DEV-CA0018--mark
         #CALL s_errmsg('imgb00,imgb01,imgb02,imgb03,imgb04',g_showmsg,'upd imgb:',STATUS,1) #No:DEV-CA0018--mark
          LET g_showmsg = sr.imgb01,"/",sr.imgb02,"/",sr.imgb03,"/",sr.imgb04                #No:DEV-CA0018--add
          CALL s_errmsg('imgb01,imgb02,imgb03,imgb04',g_showmsg,'upd imgb:',STATUS,1)        #No:DEV-CA0018--add
          LET g_success = 'N' #MOD-4C0119
          IF show = 'N' THEN
             CALL cl_close_progress_bar()
          END IF
          RETURN              #MOD-4C0119
       END IF
     IF show = 'N' THEN
          IF l_sw_tot > 10 THEN  #筆數合計
             IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                 CALL cl_progressing(" ")
             END IF
             IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數時才呼
                  CALL cl_progressing(" ")
                  LET l_count = l_count + 1
             END IF
          ELSE
              CALL cl_progressing(" ")
          END IF
     END IF
     END FOREACH
          IF g_totsuccess="N" THEN
              LET g_success="N"
          END IF

     IF STATUS THEN
         CALL s_errmsg('','','foreach p110_curs1:',STATUS,1)
         LET g_success = 'N'
         RETURN
     END IF
    #更新最後一筆imgb_file
     LET g_msg = cl_getmsg('aim-994',g_lang),g_stime,'  ',cl_getmsg('aim-992',g_lang),g_etime
     IF g_bgjob = 'N' THEN
         MESSAGE g_msg
    END IF
END FUNCTION
#DEV-D30025--add
