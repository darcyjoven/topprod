# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: gglq919.4gl
# Descriptions...: 
# Date & Author..: 11/07/05 By zm No.TQC-B60384 改善gglq911,將明細科目串查的畫面gglq911_2改為可獨立運行的作業
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
 
DATABASE ds  #No.FUN-8A0028
 
GLOBALS "../../config/top.global"
#No.TQC-B60384
 
   DEFINE tm         RECORD
                     wc    STRING,      
	             b     LIKE aaa_file.aaa01,
                     axa02 LIKE axa_file.axa02,
                     axa01 LIKE axa_file.axa01,
	             yy    LIKE type_file.num5,  #輸入年度
	             bm    LIKE type_file.num5,  #Begin 期別
	             d     LIKE type_file.chr1,  #金額單位
	             e     LIKE type_file.num5,  #小數位數
	             o     LIKE type_file.chr1,  #轉換幣別否
	             p     LIKE azi_file.azi01,  #幣別
	             q     LIKE azj_file.azj03,  #匯率
	             r     LIKE azi_file.azi01,  #幣別
	             more  LIKE type_file.chr1   #Input more condition(Y/N)
	             END RECORD,
	  i,j,k      LIKE type_file.num5,
	  g_unit     LIKE type_file.num10,       #金額單位基數
	  l_row      LIKE type_file.num5,
	  r_row      LIKE type_file.num5,
	  g_bookno   LIKE aah_file.aah00,        #帳別
	  g_reportno LIKE maj_file.maj01,      #报表结构
	  g_sn       LIKE maj_file.maj02, 
	  g_mai02    LIKE mai_file.mai02,
	  g_mai03    LIKE mai_file.mai03,
	  g_tot1     ARRAY[100] OF LIKE type_file.num20_6,
	  g_tot0     ARRAY[100] OF LIKE type_file.num20_6,
	  g_basetot1 LIKE type_file.num20_6
 
DEFINE   g_cnt       LIKE type_file.num10
DEFINE   g_aaa03     LIKE aaa_file.aaa03
DEFINE   g_i         LIKE type_file.num5
DEFINE   g_rec_b     LIKE type_file.num5
DEFINE   g_rec_b1    LIKE type_file.num5
DEFINE   l_ac        LIKE type_file.num5
DEFINE   g_aah   DYNAMIC ARRAY OF RECORD
                  axb04     LIKE azp_file.azp02,
                  dbs       LIKE azp_file.azp03,
                  aah01     LIKE aah_file.aah01,
                  aag02     LIKE aag_file.aag02,
                  qc_aah04  LIKE aah_file.aah04,
                  qc_aah05  LIKE aah_file.aah05,
                  qj_aah04  LIKE aah_file.aah04,
                  qj_aah05  LIKE aah_file.aah05,
                  qm_aah04  LIKE aah_file.aah04,
                  qm_aah05  LIKE aah_file.aah05
                  END RECORD
DEFINE   g_aag       DYNAMIC ARRAY OF RECORD
                     aag01      LIKE maj_file.maj20,
                     cnt        LIKE type_file.num10,
                     sum1       LIKE aah_file.aah04,
                     sum2       LIKE aah_file.aah04,
                     sum3       LIKE aah_file.aah04,
                     sum4       LIKE aah_file.aah04,
                     sum5       LIKE aah_file.aah04,
                     sum6       LIKE aah_file.aah04,
                     sum7       LIKE aah_file.aah04,
                     sum8       LIKE aah_file.aah04,
                     sum9       LIKE aah_file.aah04,
                     sum10      LIKE aah_file.aah04
                     END RECORD
DEFINE   g_title     DYNAMIC ARRAY OF RECORD
                     axb04  LIKE axb_file.axb04,
                     axb05  LIKE axb_file.axb05,
                     dbs    LIKE azp_file.azp03,
                     azp02  LIKE azp_file.azp02,
                     azp01  LIKE azp_file.azp01     #FUN-A50102
                     END RECORD
DEFINE   g_axb     DYNAMIC ARRAY OF RECORD
                     check  LIKE type_file.chr1,
                     axb04  LIKE axb_file.axb04,
                     azp02  LIKE azp_file.azp02,
                     axb05  LIKE axb_file.axb05
                     END RECORD
DEFINE   g_sql       STRING
DEFINE   g_str       STRING
DEFINE   l_table     STRING
DEFINE   g_msg       LIKE type_file.chr1000
DEFINE   g_msg1      LIKE type_file.chr1000
DEFINE g_maj21   LIKE maj_file.maj21
DEFINE g_maj22   LIKE maj_file.maj22
DEFINE g_maj24   LIKE maj_file.maj24
DEFINE g_maj25   LIKE maj_file.maj25
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   LET tm.b       = ARG_VAL(1)     #帳套
   LET tm.axa02   = ARG_VAL(2)     #上層公司
   LET tm.axa01   = ARG_VAL(3)     #族群
   LET tm.yy      = ARG_VAL(4)     #年
   LET tm.bm      = ARG_VAL(5)     #月
   LET g_maj21    = ARG_VAL(6)     #起始科目
   LET g_maj22    = ARG_VAL(7)     #截止科目
   LET g_maj24    = ARG_VAL(8)     #起始部門
   LET g_maj25    = ARG_VAL(9)     #截止部門
   LET g_bgjob    = ARG_VAL(10)    #
   LET g_pdate    = ARG_VAL(11)    # Get arguments from command line
   LET g_towhom   = ARG_VAL(12)
   LET g_rlang    = ARG_VAL(13)
   LET g_prtway   = ARG_VAL(14)
   LET g_copies   = ARG_VAL(15)
   LET tm.d       = ARG_VAL(16)
   LET tm.e       = ARG_VAL(17)
   LET tm.o       = ARG_VAL(18)
   LET tm.q       = ARG_VAL(19)
 
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   OPEN WINDOW q919_w AT 5,10
        WITH FORM "ggl/42f/gglq919" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("cnt",FALSE) 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL q919_tm()                          # Input print condition
   ELSE
      CALL q919_2()                             # Read data and create out-file
   END IF
 
   CALL q919_menu()
   CLOSE WINDOW q919_w
   CALL cl_used(g_prog,g_time,2)
        RETURNING g_time
 
END MAIN
 
FUNCTION q919_menu()
   WHILE TRUE
      CALL q919_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q919_tm()
            END IF
         WHEN "drill_detail"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  CALL q919_drill_down()
               END IF
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q919_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE p_row,p_col,l_ac1,l_i    LIKE type_file.num5,
	  l_sw           LIKE type_file.chr1,
	  l_cmd          LIKE type_file.chr1000
   DEFINE li_result      LIKE type_file.num5
 
   CALL s_dsmark(tm.b)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW q919_w1 AT p_row,p_col WITH FORM "ggl/42f/gglq919_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("gglq919_1")
 
   CALL s_shwact(0,0,tm.b)
 
   CALL cl_opmsg('p')
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)
   END IF
   INITIALIZE tm.* TO NULL                  #Default condition
 
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)
   END IF
   LET tm.b = g_aza.aza81
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   DISPLAY tm.b,tm.axa02,tm.axa01,tm.yy,tm.bm,tm.d,tm.e,tm.o,tm.r,tm.p,tm.q,tm.more
WHILE TRUE
    LET l_row=0
    LET r_row=0
    LET l_sw = 1
    DIALOG ATTRIBUTE(unbuffered)
    INPUT BY NAME tm.b,tm.axa02,tm.axa01,tm.yy,tm.bm ATTRIBUTE(WITHOUT DEFAULTS)
  #     BEFORE INPUT
  #        CALL cl_qbe_init()
 
  #     ON ACTION locale
  #        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
  #        LET g_action_choice = "locale"
  #        EXIT INPUT
 
       AFTER FIELD b
          IF cl_null(tm.b) THEN NEXT FIELD b END IF
          IF NOT cl_null(tm.b) THEN
             CALL s_check_bookno(tm.b,g_user,g_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF
             SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('y','Y')
             IF STATUS THEN
                CALL cl_err3("sel","aaa.file",tm.b,"",STATUS,"","sel aaa:",0)    #No.FUN-660124
                NEXT FIELD b
             END IF
          END IF
 
       AFTER FIELD axa02
          IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
          IF NOT cl_null(tm.axa02) THEN
             SELECT axz02 FROM axz_file WHERE axz01 = tm.axa02
             IF SQLCA.sqlcode THEN
                CALL cl_err3('sel','axz_file',tm.axa02,'','mfg9142','','',0)
                NEXT FIELD axa02
             END IF
          END IF
 
       AFTER FIELD axa01
          IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
          IF NOT cl_null(tm.axa01) THEN
             SELECT DISTINCT axa01 FROM axa_file WHERE axa01 = tm.axa01
             IF SQLCA.sqlcode THEN
                CALL cl_err3('sel','axa_file',tm.axa01,'',SQLCA.sqlcode,'','',0)
                NEXT FIELD axa01
             END IF
          END IF
 
       AFTER FIELD yy
          IF tm.yy IS NULL OR tm.yy <= 0 THEN
             NEXT FIELD yy
          END IF
 
       AFTER FIELD bm
          IF tm.bm IS NULL THEN NEXT FIELD bm END IF
          IF NOT cl_null(tm.bm) THEN
             SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
             IF g_azm.azm02 = 1 THEN
                IF tm.bm > 12 OR tm.bm < 1 THEN
                   CALL cl_err('','agl-020',0)
                   NEXT FIELD bm
                END IF
             ELSE
                IF tm.bm > 13 OR tm.bm < 1 THEN
                   CALL cl_err('','agl-020',0)
                   NEXT FIELD bm
                END IF
             END IF
          END IF
 
      AFTER INPUT
	 IF tm.yy IS NULL THEN
	    LET l_sw = 0
	    DISPLAY BY NAME tm.yy
	    CALL cl_err('',9033,0)
	 END IF
	 IF tm.bm IS NULL THEN
	    LET l_sw = 0
	    DISPLAY BY NAME tm.bm
	 END IF
	 IF l_sw = 0 THEN
	    LET l_sw = 1
	    NEXT FIELD a
	    CALL cl_err('',9033,0)
	 END IF
         CALL q919_b_fill()

    END INPUT

    CONSTRUCT BY NAME tm.wc ON aag01
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
    #TQC-C30136--mark--str--
    #ON ACTION controlp
    #   CASE
    #     WHEN INFIELD(aag01)
    #         CALL cl_init_qry_var()
    #         LET g_qryparam.state = "c"
    #         LET g_qryparam.form ="q_aag"  
    #         CALL cl_create_qry() RETURNING g_qryparam.multiret
    #         DISPLAY g_qryparam.multiret TO aag01
    #    END CASE
    #TQC-C30136--mark--end--
    END CONSTRUCT 
  
      
    INPUT BY NAME tm.d,tm.e,tm.o,tm.r,tm.p,tm.q,tm.more ATTRIBUTE(WITHOUT DEFAULTS)

       BEFORE INPUT
          CALL cl_qbe_init()
          CALL cl_set_comp_entry("p,q",TRUE)
          IF tm.o = 'N' THEN
             CALL cl_set_comp_entry("p,q",FALSE)
          END IF
 
       AFTER FIELD d
          IF tm.d IS NULL OR tm.d NOT MATCHES'[1234]'  THEN
             NEXT FIELD d
          END IF
          IF tm.d = '1' THEN LET g_unit = 1       END IF
          IF tm.d = '2' THEN LET g_unit = 1000    END IF
          IF tm.d = '3' THEN LET g_unit = 10000   END IF
          IF tm.d = '4' THEN LET g_unit = 1000000 END IF
 
       AFTER FIELD e
          IF tm.e < 0 THEN
             LET tm.e = 0
             DISPLAY BY NAME tm.e
          END IF
 
       BEFORE FIELD o
          CALL cl_set_comp_entry("p,q",TRUE)
 
       AFTER FIELD o
          IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
          IF tm.o = 'N' THEN
             LET tm.p = g_aaa03
             LET tm.q = 1
             DISPLAY g_aaa03 TO p
             DISPLAY BY NAME tm.q
             CALL cl_set_comp_entry("p,q",FALSE)
          END IF
 
       AFTER FIELD p
	  SELECT azi01 FROM azi_file WHERE azi01 = tm.p
	  IF SQLCA.sqlcode THEN
	     CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)
	     NEXT FIELD p
	  END IF
 
       AFTER FIELD more
          IF tm.more = 'Y'
             THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
         			g_bgjob,g_time,g_prtway,g_copies)
         	      RETURNING g_pdate,g_towhom,g_rlang,
         			g_bgjob,g_time,g_prtway,g_copies
          END IF
 
      AFTER INPUT
	 IF tm.yy IS NULL THEN
	    LET l_sw = 0
	    DISPLAY BY NAME tm.yy
	    CALL cl_err('',9033,0)
	 END IF
	 IF tm.bm IS NULL THEN
	    LET l_sw = 0
	    DISPLAY BY NAME tm.bm
	 END IF
	 IF l_sw = 0 THEN
	    LET l_sw = 1
	    NEXT FIELD a
	    CALL cl_err('',9033,0)
	 END IF
	 IF tm.d = '1' THEN LET g_unit = 1       END IF
	 IF tm.d = '2' THEN LET g_unit = 1000    END IF
         IF tm.d = '3' THEN LET g_unit = 10000   END IF
	 IF tm.d = '4' THEN LET g_unit = 1000000 END IF

      END INPUT
 
   INPUT ARRAY g_axb FROM s_axb.* 
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                  INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)

       BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF

       BEFORE ROW
            LET l_ac1=ARR_CURR()

       BEFORE INSERT
            LET g_axb[l_ac1].check='Y'
            DISPLAY BY NAME g_axb[l_ac1].check
            NEXT FIELD check
     
       AFTER FIELD check
           IF g_axb[l_ac1].check IS NULL OR g_axb[l_ac1].check NOT MATCHES'[YN]' THEN NEXT FIELD check END IF

       AFTER ROW
           LET l_ac1= ARR_CURR()

    END INPUT
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION CONTROLP
	 CASE
            #TQC-C30136-add--str--
            WHEN INFIELD(aag01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag"  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aag01
            #TQC-C30136--add--end--
            WHEN INFIELD(b) OR INFIELD(axa01) OR INFIELD(axa02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_axa'
               LET g_qryparam.default1 = tm.axa01
               LET g_qryparam.default2 = tm.axa02
               LET g_qryparam.default3 = tm.b
               CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.b
               DISPLAY BY NAME tm.axa01,tm.axa02,tm.b
 
            WHEN INFIELD(p)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
	       DISPLAY BY NAME tm.p
	       NEXT FIELD p
       END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
 
      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION accept
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=1
         EXIT DIALOG

      ON ACTION select_all
         FOR l_i=1 TO g_cnt-1
            LET g_axb[l_i].check='Y' 
         END FOR

      ON ACTION cancel_all
         FOR l_i=1 TO g_cnt-1
            LET g_axb[l_i].check='N' 
         END FOR
   END DIALOG 

   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q919_w1 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
	     WHERE zz01='gglq919'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
   	 CALL cl_err('gglq919','9031',1)
      ELSE
	 LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.b CLIPPED,"'",
                         " '",tm.axa02 CLIPPED,"'",
                         " '",tm.axa01 CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",g_maj21 CLIPPED,"'",
                         " '",g_maj22 CLIPPED,"'",
                         " '",g_maj24 CLIPPED,"'",
                         " '",g_maj25 CLIPPED,"'",
			 " '",g_bgjob CLIPPED,"'",
			 " '",g_pdate CLIPPED,"'",
			 " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
			 " '",g_prtway CLIPPED,"'",
			 " '",g_copies CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",tm.q CLIPPED,"'"
	 CALL cl_cmdat('gglq919',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW q919_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CLOSE WINDOW q919_w1
   CALL q919()
   ERROR ""
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION q919_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY g_mai02 TO FORMONLY.mai02
   DISPLAY tm.p TO FORMONLY.azi01
   DISPLAY tm.yy TO FORMONLY.yy
   DISPLAY tm.bm TO FORMONLY.mm
   DISPLAY tm.d  TO FORMONLY.unit
   DISPLAY tm.axa02 TO axa02
   DISPLAY tm.axa01 TO axa01
   IF g_aag.getLength() > 0 THEN
      DISPLAY g_title[1].azp02 TO azp02
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aah TO s_aah.* ATTRIBUTE(COUNT=g_rec_b1)
      #BEFORE DISPLAY
      #   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
 
      ON ACTION drill_detail
         LET g_action_choice="drill_detail"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q919()
   DEFINE l_date1   LIKE type_file.dat
   DEFINE l_date2   LIKE type_file.dat
   DEFINE l_axb04   LIKE axb_file.axb04
   DEFINE l_axb05   LIKE axb_file.axb05
   DEFINE l_dbs_sep LIKE type_file.chr50
   DEFINE l_azp02   LIKE azp_file.azp02
   DEFINE l_k       LIKE type_file.num5
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_maj21   LIKE maj_file.maj21
   DEFINE l_maj22   LIKE maj_file.maj22
   DEFINE l_maj24   LIKE maj_file.maj24
   DEFINE l_maj25   LIKE maj_file.maj25
   DEFINE l_dbs     LIKE azp_file.azp03
   DEFINE l_dbs_old LIKE azp_file.azp03
   DEFINE lc_tty_no    LIKE zxx_file.zxx02
   DEFINE ls_tty_no    STRING
   DEFINE l_sql        STRING
   DEFINE qc_aah04     LIKE aah_file.aah04
   DEFINE qc_aah05     LIKE aah_file.aah05
   DEFINE qj_aah04     LIKE aah_file.aah04
   DEFINE qj_aah05     LIKE aah_file.aah05
   DEFINE qm_aah04     LIKE aah_file.aah04
   DEFINE qm_aah05     LIKE aah_file.aah05
   DEFINE g_aah_str    LIKE type_file.chr1000
   DEFINE l_aao_str    LIKE type_file.chr1000
   DEFINE l_aag01      LIKE aag_file.aag01
   DEFINE l_aag02      LIKE aag_file.aag02
   DEFINE l_gbq10      LIKE gbq_file.gbq10
   DEFINE l_plant      LIKE azp_file.azp01   #FUN-A50102
 
     CALL g_aah.clear()
     LET g_rec_b1 = 0
     LET l_i = 1
     FOR l_k=1 TO g_cnt-1
        IF g_axb[l_k].check = 'N' THEN CONTINUE FOR END IF
        SELECT azp01,azp03 INTO l_plant,l_dbs FROM azp_file,axz_file
         WHERE axz01 = g_axb[l_k].axb04
           AND axz03 = azp01
        LET g_aah_str = " SELECT SUM(aah04),SUM(aah05) ",
                        #"   FROM ",l_dbs_sep CLIPPED,"aah_file ",
                        "   FROM ",cl_get_target_table(l_plant,'aah_file'), #FUN-A50102
                        "  WHERE aah00 = '",g_axb[l_k].axb05,"'",
                        "    AND aah01 = ?",
                        "    AND aah02 = ",tm.yy
        LET g_sql = g_aah_str CLIPPED, "    AND aah03 < ",tm.bm
 	CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
        CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql 
        PREPARE gglq919_aah_qc_p FROM g_sql
 
        LET g_sql = g_aah_str CLIPPED, "    AND aah03 BETWEEN ? AND ? "
        PREPARE gglq919_aah_qj_p FROM g_sql
 
        LET l_sql = "SELECT aag01,aag02 FROM ",cl_get_target_table(l_plant,'aag_file'),
                    " WHERE aag00 = '",g_axb[l_k].axb05,"' ",
                    "   AND aag07 IN('2','3')",
                    "   AND ",tm.wc 
        DECLARE q919_aag CURSOR FROM l_sql
        FOREACH q919_aag INTO l_aag01,l_aag02
           LET g_aah[l_i].axb04 = g_axb[l_k].axb04
           LET g_aah[l_i].dbs   = l_dbs
           LET g_aah[l_i].aah01 = l_aag01
           LET g_aah[l_i].aag02 = l_aag02
 
           LET qc_aah04 = 0    LET qc_aah05 = 0
           LET qj_aah04 = 0    LET qj_aah05 = 0
           LET qm_aah04 = 0    LET qm_aah05 = 0
              EXECUTE gglq919_aah_qc_p USING l_aag01
                      INTO qc_aah04,qc_aah05
           IF SQLCA.sqlcode THEN
              CALL cl_err('execute qc_p',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(qc_aah04) THEN LET qc_aah04 = 0 END IF
           IF cl_null(qc_aah05) THEN LET qc_aah05 = 0 END IF
 
           EXECUTE gglq919_aah_qj_p USING l_aag01,tm.bm,tm.bm
                   INTO qj_aah04,qj_aah05
           IF SQLCA.sqlcode THEN
              CALL cl_err('execute qj_p',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(qj_aah04) THEN LET qj_aah04 = 0 END IF
           IF cl_null(qj_aah05) THEN LET qj_aah05 = 0 END IF
 
           IF tm.d MATCHES '[234]' THEN
              LET qc_aah04 = qc_aah04/g_unit
              LET qc_aah05 = qc_aah05/g_unit
              LET qj_aah04 = qj_aah04/g_unit
              LET qj_aah05 = qj_aah05/g_unit
           END IF 
           IF tm.o='Y' THEN 
              LET qc_aah04 = qc_aah04*tm.q 
              LET qc_aah05 = qc_aah05*tm.q 
              LET qj_aah04 = qj_aah04*tm.q 
              LET qj_aah05 = qj_aah05*tm.q 
           END IF
           IF qc_aah04 > qc_aah05 THEN
              LET qc_aah04 = qc_aah04 - qc_aah05
              LET qc_aah05 = 0
           ELSE
              LET qc_aah05 = qc_aah05 - qc_aah04
              LET qc_aah04 = 0
           END IF
           LET qm_aah04 = qc_aah04 + qj_aah04
           LET qm_aah05 = qc_aah05 + qj_aah05
           IF qm_aah04 > qm_aah05 THEN
              LET qm_aah04 = qm_aah04 - qm_aah05
              LET qm_aah05 = 0
           ELSE
              LET qm_aah05 = qm_aah05 - qm_aah04
              LET qm_aah04 = 0
           END IF
           LET g_aah[l_i].qc_aah04 = cl_numfor(qc_aah04,17,tm.e)
           LET g_aah[l_i].qc_aah05 = cl_numfor(qc_aah05,17,tm.e)
           LET g_aah[l_i].qj_aah04 = cl_numfor(qj_aah04,17,tm.e)
           LET g_aah[l_i].qj_aah05 = cl_numfor(qj_aah05,17,tm.e)
           LET g_aah[l_i].qm_aah04 = cl_numfor(qm_aah04,17,tm.e)
           LET g_aah[l_i].qm_aah05 = cl_numfor(qm_aah05,17,tm.e)
 
           LET l_i = l_i + 1
        END FOREACH
    END FOR
    LET g_rec_b1 = l_i - 1
 
END FUNCTION
 

FUNCTION q919_2()
   DEFINE l_date1   LIKE type_file.dat
   DEFINE l_date2   LIKE type_file.dat
   DEFINE l_axb04   LIKE axb_file.axb04
   DEFINE l_axb05   LIKE axb_file.axb05
   DEFINE l_dbs_sep LIKE type_file.chr50
   DEFINE l_azp02   LIKE azp_file.azp02
   DEFINE l_k       LIKE type_file.num5
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_dbs     LIKE azp_file.azp03
   DEFINE l_dbs_old LIKE azp_file.azp03
   DEFINE lc_tty_no    LIKE zxx_file.zxx02
   DEFINE ls_tty_no    STRING
   DEFINE l_sql        STRING
   DEFINE qc_aah04     LIKE aah_file.aah04
   DEFINE qc_aah05     LIKE aah_file.aah05
   DEFINE qj_aah04     LIKE aah_file.aah04
   DEFINE qj_aah05     LIKE aah_file.aah05
   DEFINE qm_aah04     LIKE aah_file.aah04
   DEFINE qm_aah05     LIKE aah_file.aah05
   DEFINE g_aah_str    LIKE type_file.chr1000
   DEFINE l_aao_str    LIKE type_file.chr1000
   DEFINE l_aag01      LIKE aag_file.aag01
   DEFINE l_aag02      LIKE aag_file.aag02
   DEFINE l_gbq10      LIKE gbq_file.gbq10
   DEFINE l_plant      LIKE azp_file.azp01   #FUN-A50102
 
    CALL g_aah.clear()
    LET g_rec_b1 = 0
    LET l_i = 1
 
    LET l_sql="SELECT UNIQUE axb04,axb05 FROM axb_file,axz_file ",
              " WHERE axb01 = '",tm.axa01,"' ",
              "   AND axb02 = '",tm.axa02,"'  ",
              "   AND axb03 = '",tm.b,"'  ",
              "   AND axb04 = axz01  ",
              " UNION  ",
              "SELECT '",tm.axa02,"','",tm.b,"' FROM dual  "
    DECLARE axb_cur01 CURSOR FROM l_sql
    FOREACH axb_cur01 INTO l_axb04,l_axb05
        SELECT azp01,azp03 INTO l_plant,l_dbs FROM azp_file,axz_file
         WHERE axz01 = l_axb04
           AND axz03 = azp01
        LET g_aah_str = " SELECT SUM(aah04),SUM(aah05) ",
                        "   FROM ",cl_get_target_table(l_plant,'aah_file'), #FUN-A50102
                        "  WHERE aah00 = '",l_axb05,"'",
                        "    AND aah01 = ?",
                        "    AND aah02 = ",tm.yy
        LET g_sql = g_aah_str CLIPPED, "    AND aah03 < ",tm.bm
 	CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
        CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql 
        PREPARE gglq919_aah_qc_p1 FROM g_sql
 
        LET g_sql = g_aah_str CLIPPED, "    AND aah03 BETWEEN ? AND ? "
        PREPARE gglq919_aah_qj_p1 FROM g_sql
 
        LET l_aao_str = " SELECT SUM(aao05),SUM(aao06) ",
                        "   FROM ",cl_get_target_table(l_plant,'aao_file'), 
                        "  WHERE aao00 = '",l_axb05,"'",
                        "    AND aao01 = ?",
                        "    AND aao02 BETWEEN ? AND ? ",
                        "    AND aao03 = ",tm.yy
        LET g_sql = l_aao_str CLIPPED, " AND aao04 < ",tm.bm
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
        CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
        PREPARE gglq919_aao_qc_p1 FROM g_sql
 
        LET g_sql = l_aao_str CLIPPED, "    AND aao04 BETWEEN ? AND ? "
        PREPARE gglq919_aao_qj_p1 FROM g_sql
 
        LET l_sql = "SELECT aag01,aag02 FROM aag_file ",
                    " WHERE aag01 BETWEEN '",g_maj21,"' AND '",g_maj22,"' ",
                    "   AND aag00 = '",l_axb05,"' ",
                    "   AND aag07 IN ('2','3') ",
                    "  ORDER BY aag01 "
        DECLARE q919_aag1 CURSOR FROM l_sql
        FOREACH q919_aag1 INTO l_aag01,l_aag02
           LET g_aah[l_i].axb04 = l_axb04
           LET g_aah[l_i].dbs   = l_dbs
           LET g_aah[l_i].aah01 = l_aag01
           LET g_aah[l_i].aag02 = l_aag02
 
           LET qc_aah04 = 0    LET qc_aah05 = 0
           LET qj_aah04 = 0    LET qj_aah05 = 0
           LET qm_aah04 = 0    LET qm_aah05 = 0
           IF cl_null(g_maj24) THEN
              EXECUTE gglq919_aah_qc_p1 USING l_aag01 INTO qc_aah04,qc_aah05
           ELSE
              EXECUTE gglq919_aao_qc_p1 USING l_aag01,g_maj24,g_maj25 INTO qc_aah04,qc_aah05
           END IF
           IF SQLCA.sqlcode THEN
              CALL cl_err('execute qc_p',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(qc_aah04) THEN LET qc_aah04 = 0 END IF
           IF cl_null(qc_aah05) THEN LET qc_aah05 = 0 END IF
 
           IF cl_null(g_maj24) THEN
              EXECUTE gglq919_aah_qj_p1 USING l_aag01,tm.bm,tm.bm
                      INTO qj_aah04,qj_aah05
           ELSE
              EXECUTE gglq919_aao_qj_p1 USING l_aag01,g_maj24,g_maj25,tm.bm,tm.bm
                      INTO qj_aah04,qj_aah05
           END IF
           IF SQLCA.sqlcode THEN
              CALL cl_err('execute qj_p',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(qj_aah04) THEN LET qj_aah04 = 0 END IF
           IF cl_null(qj_aah05) THEN LET qj_aah05 = 0 END IF
 
           IF tm.d = '1' THEN LET g_unit = 1       END IF
           IF tm.d = '2' THEN LET g_unit = 1000    END IF
           IF tm.d = '3' THEN LET g_unit = 10000   END IF
           IF tm.d = '4' THEN LET g_unit = 1000000 END IF
           IF tm.d MATCHES '[234]' THEN
              LET qc_aah04 = qc_aah04/g_unit
              LET qc_aah05 = qc_aah05/g_unit
              LET qj_aah04 = qj_aah04/g_unit
              LET qj_aah05 = qj_aah05/g_unit
           END IF 
           IF tm.o='Y' THEN 
              LET qc_aah04 = qc_aah04*tm.q 
              LET qc_aah05 = qc_aah05*tm.q 
              LET qj_aah04 = qj_aah04*tm.q 
              LET qj_aah05 = qj_aah05*tm.q 
           END IF
           IF qc_aah04 > qc_aah05 THEN
              LET qc_aah04 = qc_aah04 - qc_aah05
              LET qc_aah05 = 0
           ELSE
              LET qc_aah05 = qc_aah05 - qc_aah04
              LET qc_aah04 = 0
           END IF
           LET qm_aah04 = qc_aah04 + qj_aah04
           LET qm_aah05 = qc_aah05 + qj_aah05
           IF qm_aah04 > qm_aah05 THEN
              LET qm_aah04 = qm_aah04 - qm_aah05
              LET qm_aah05 = 0
           ELSE
              LET qm_aah05 = qm_aah05 - qm_aah04
              LET qm_aah04 = 0
           END IF
           LET g_aah[l_i].qc_aah04 = cl_numfor(qc_aah04,17,tm.e)
           LET g_aah[l_i].qc_aah05 = cl_numfor(qc_aah05,17,tm.e)
           LET g_aah[l_i].qj_aah04 = cl_numfor(qj_aah04,17,tm.e)
           LET g_aah[l_i].qj_aah05 = cl_numfor(qj_aah05,17,tm.e)
           LET g_aah[l_i].qm_aah04 = cl_numfor(qm_aah04,17,tm.e)
           LET g_aah[l_i].qm_aah05 = cl_numfor(qm_aah05,17,tm.e)
 
           LET l_i = l_i + 1
        END FOREACH
    END FOREACH
    LET g_rec_b1 = l_i - 1
 
END FUNCTION

FUNCTION q919_b_fill()
  
   DECLARE axb_cs1 CURSOR FOR
   SELECT UNIQUE 'Y',axb04,'',axb05 FROM axb_file,axz_file
    WHERE axb01 = tm.axa01
      AND axb02 = tm.axa02
      AND axb03 = tm.b
      AND axb04 = axz01
   CALL g_axb.clear()
   LET g_axb[1].check = 'Y'
   LET g_axb[1].axb04 = tm.axa02
   LET g_axb[1].axb05 = tm.b
   SELECT azp02 INTO g_axb[1].azp02 FROM azp_file,axz_file
    WHERE axz01=g_axb[1].axb04 AND axz03=azp01
   LET g_cnt = 2 
   FOREACH axb_cs1 INTO g_axb[g_cnt].* 	
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT azp02 INTO g_axb[g_cnt].azp02 FROM azp_file,axz_file
       WHERE axz01=g_axb[g_cnt].axb04 AND axz03=azp01
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_axb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
 
END FUNCTION

FUNCTION q919_drill_down()
   DEFINE l_date1   LIKE type_file.dat
   DEFINE l_date2   LIKE type_file.dat
   DEFINE l_gbq10      LIKE gbq_file.gbq10

         IF l_ac > 0 AND NOT cl_null(g_aah[l_ac].aah01) THEN
            LET l_gbq10 = g_aah[l_ac].dbs CLIPPED,'/',g_aah[l_ac].dbs
            UPDATE gbq_file SET gbq10=l_gbq10 WHERE gbq03=g_user
            UPDATE zxx_file SET zxx03 = g_aah[l_ac].dbs
             WHERE zxx01 = g_user AND zxx02 = lc_tty_no
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               INSERT INTO zxx_file VALUES(g_user,lc_tty_no,g_aah[l_ac].dbs)
            END IF
            LET g_sql = "aag01 = '",g_aah[l_ac].aah01,"'"
            CALL s_azn01(tm.yy,tm.bm) RETURNING l_date1,l_date2
            LET g_msg = 'gglq301 "',g_title[1].axb05,'" "" "" "',g_lang,
                        '" "Y" "" "" "',g_sql CLIPPED,
                        '" " 1=1" "N" "Y" "N" "N" "" "3" "',
                        l_date1,'" "',l_date2,'" "" "" "" ""'
            CALL cl_cmdrun_wait(g_msg)
            UPDATE zxx_file SET zxx03 = g_plant
             WHERE zxx01 = g_user AND zxx02 = lc_tty_no
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               INSERT INTO zxx_file VALUES(g_user,lc_tty_no,g_plant)
            END IF
         END IF
END FUNCTION
