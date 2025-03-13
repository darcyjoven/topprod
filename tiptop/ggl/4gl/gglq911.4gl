# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglq911.4gl
# Descriptions...: 集團資產負債表查詢化
# Date & Author..: 08/08/27 By Carrier  No.FUN-8A0028
# Modify.........: No.FUN-950007 09/05/11 By sabrina 跨主機資料拋轉，shell手工調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/07 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70025 10/07/13 By Summer 將本來不應該是實際ERP table 的都改成 create temp table
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.TQC-B60384 11/10/10 By zm 明細科目串查改為串gglq919
 
DATABASE ds  #No.FUN-8A0028
 
GLOBALS "../../config/top.global"
 
   DEFINE tm         RECORD
	             b     LIKE aaa_file.aaa01,
                     axa02 LIKE axa_file.axa02,
                     axa01 LIKE axa_file.axa01,
	             a     LIKE mai_file.mai01,  #報表結構編號
	             yy    LIKE type_file.num5,  #輸入年度
	             bm    LIKE type_file.num5,  #Begin 期別
	             c     LIKE type_file.chr1,  #異動額及余額為0者是否列印
	             d     LIKE type_file.chr1,  #金額單位
	             e     LIKE type_file.num5,  #小數位數
	             f     LIKE type_file.num5,  #列印最小階數
	             h     LIKE type_file.chr4,  #額外說明類別
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
DEFINE   g_sql       STRING
DEFINE   g_str       STRING
DEFINE   l_table     STRING
DEFINE   g_msg       LIKE type_file.chr1000
DEFINE   g_msg1      LIKE type_file.chr1000
 
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
 
   LET g_bookno   = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.b       = ARG_VAL(9)
   LET tm.axa02   = ARG_VAL(9)
   LET tm.axa01   = ARG_VAL(9)
   LET tm.a       = ARG_VAL(8)
   LET tm.yy      = ARG_VAL(10)
   LET tm.bm      = ARG_VAL(11)
   LET tm.c       = ARG_VAL(12)
   LET tm.d       = ARG_VAL(13)
   LET tm.e       = ARG_VAL(14)
   LET tm.f       = ARG_VAL(15)
   LET tm.h       = ARG_VAL(16)
   LET tm.o       = ARG_VAL(17)
   LET tm.p       = ARG_VAL(18)
   LET tm.q       = ARG_VAL(19)
   LET tm.r       = ARG_VAL(20)
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)
 
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   OPEN WINDOW q911_w AT 5,10
        WITH FORM "ggl/42f/gglq911" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
#   CALL cl_set_comp_visible("cnt",FALSE)    #zm 110704
   DROP TABLE gglq911_tmp1;
   #CHI-A70025 mod CREAT TABLE gglq911_tmp1-> CREAT TEMP TABLE gglq911_tmp1
   CREATE TEMP TABLE gglq911_tmp1(
          cnt     DECIMAL(10),
          maj21   VARCHAR(24),
          maj22   VARCHAR(24),
          maj24   VARCHAR(10),
          maj25   VARCHAR(10));
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL q911_tm()                          # Input print condition
   ELSE
      CALL q911()                             # Read data and create out-file
   END IF
 
   CALL q911_menu()
   DROP TABLE gglq911_tmp1;
   CLOSE WINDOW q911_w
   CALL cl_used(g_prog,g_time,2)
        RETURNING g_time
 
END MAIN
 
FUNCTION q911_menu()
   DEFINE l_maj21   LIKE maj_file.maj21    #No.TQC-B60384
   DEFINE l_maj22   LIKE maj_file.maj22    #No.TQC-B60384
   DEFINE l_maj24   LIKE maj_file.maj24    #No.TQC-B60384
   DEFINE l_maj25   LIKE maj_file.maj25    #No.TQC-B60384

   WHILE TRUE
      CALL q911_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q911_tm()
            END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL q911_out()
#           END IF
         WHEN "drill_detail"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                #No.TQC-B60384 begin
                #  CALL q911_drill_down()
                  SELECT maj21,maj22,maj24,maj25 INTO l_maj21,l_maj22,l_maj24,l_maj25 FROM gglq911_tmp1
                   WHERE cnt=g_aag[l_ac].cnt
                  LET g_msg = "gglq919 '",tm.b,"' '",tm.axa02,"' '",tm.axa01,"' ",tm.yy," ",tm.bm," ",
                              "'",l_maj21,"' '",l_maj22,"' '",l_maj24 CLIPPED,"' '",l_maj25 CLIPPED,"' ",
                              "'Y' '",g_today,"' '' '",g_lang,"' '' '1' '",tm.d,"' '",tm.e,"' '",tm.o,"' '",tm.q,"' "
                  CALL cl_cmdrun_wait(g_msg)
                 #No.TQC-B60384 end
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
 
FUNCTION q911_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE p_row,p_col    LIKE type_file.num5,
	  l_sw           LIKE type_file.chr1,
	  l_cmd          LIKE type_file.chr1000
   DEFINE li_result      LIKE type_file.num5
 
   CALL s_dsmark(tm.b)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW q911_w1 AT p_row,p_col WITH FORM "ggl/42f/gglq911_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("gglq911_1")
 
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
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_row=0
    LET r_row=0
    LET l_sw = 1
    INPUT BY NAME tm.b,tm.axa02,tm.axa01,tm.a,tm.yy,tm.bm,
		  tm.c,tm.d,tm.e,tm.f,tm.h,tm.o,tm.r,
		  tm.p,tm.q,tm.more WITHOUT DEFAULTS
       BEFORE INPUT
          CALL cl_qbe_init()
          CALL cl_set_comp_entry("p,q",TRUE)
          IF tm.o = 'N' THEN
             CALL cl_set_comp_entry("p,q",FALSE)
          END IF
 
       ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
          EXIT INPUT
 
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
 
       AFTER FIELD a
	  IF tm.a IS NULL THEN NEXT FIELD a END IF
          CALL s_chkmai(tm.a,'RGL') RETURNING li_result
          IF NOT li_result THEN
             CALL cl_err(tm.a,g_errno,1)
             NEXT FIELD a
          END IF
	  SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
	   WHERE mai01 = tm.a AND maiacti IN ('Y','y')
             AND mai00 = tm.b
	  IF STATUS THEN
	     CALL cl_err3("sel","mai_file",tm.a,tm.b,STATUS,"","sel mai:",0)   #No.FUN-660124     #No.FUN-740032
	     NEXT FIELD a
          END IF
 
       AFTER FIELD c
          IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
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
 
       AFTER FIELD f
          IF tm.f IS NULL OR tm.f < 0  THEN
             LET tm.f = 0
             DISPLAY BY NAME tm.f
             NEXT FIELD f
          END IF
 
       AFTER FIELD h
          IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
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
	 IF INT_FLAG THEN EXIT INPUT END IF
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
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION CONTROLP
	 CASE
            WHEN INFIELD(a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
               LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740032
               CALL cl_create_qry() RETURNING tm.a
	       DISPLAY BY NAME tm.a
	       NEXT FIELD a
 
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
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q911_w1 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
	     WHERE zz01='gglq911'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
   	 CALL cl_err('gglq911','9031',1)
      ELSE
	 LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
			 " '",g_pdate CLIPPED,"'",
			 " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
			 " '",g_bgjob CLIPPED,"'",
			 " '",g_prtway CLIPPED,"'",
			 " '",g_copies CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.axa02 CLIPPED,"'",
                         " '",tm.axa01 CLIPPED,"'",
			 " '",tm.a CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",tm.p CLIPPED,"'",
                         " '",tm.q CLIPPED,"'",
                         " '",tm.r CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"
	 CALL cl_cmdat('gglq911',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW q911_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CLOSE WINDOW q911_w1
   CALL q911()
   ERROR ""
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION q911()
   DEFINE l_name    LIKE type_file.chr20    # External(Disk) file name
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT
   DEFINE l_chr     LIKE type_file.chr1
   DEFINE l_za05    LIKE type_file.chr1000
   DEFINE amt0      LIKE aah_file.aah04     # 期初數
   DEFINE amt1      LIKE aah_file.aah04
   DEFINE per1      LIKE fid_file.fid03
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_last    LIKE type_file.num5
   DEFINE l_diff    LIKE type_file.num5
   DEFINE l_i       LIKE type_file.num5
   DEFINE sr  RECORD
	      bal0      LIKE type_file.num20_6,  # 期初數
	      bal1      LIKE type_file.num20_6
	      END RECORD
   DEFINE prt_r DYNAMIC ARRAY OF RECORD         #--- 陣列 for 負債&業主權益類 (右)
                maj02    LIKE maj_file.maj02,
                maj08    LIKE maj_file.maj08,
		maj20    LIKE type_file.chr1000,
                maj26    LIKE type_file.num5,
		bal0     LIKE type_file.chr20,
		bal      LIKE type_file.chr20,
		per      LIKE type_file.chr20,
		maj03    LIKE maj_file.maj03
		END RECORD
   DEFINE l_maj20   LIKE type_file.chr1000
   DEFINE l_row     LIKE type_file.num10
   DEFINE l_maj03   LIKE maj_file.maj03
   DEFINE l_split   LIKE type_file.chr10
   DEFINE l_axb04   LIKE axb_file.axb04
   DEFINE l_axb05   LIKE axb_file.axb05
   DEFINE l_axz03   LIKE axz_file.axz03
   DEFINE l_dbs_sep LIKE type_file.chr50
   DEFINE l_sum1    LIKE aah_file.aah04
   DEFINE l_sum2    LIKE aah_file.aah04
   DEFINE l_sum3    LIKE aah_file.aah04
   DEFINE l_sum4    LIKE aah_file.aah04
   DEFINE l_sum5    LIKE aah_file.aah04
   DEFINE l_sum6    LIKE aah_file.aah04
   DEFINE l_dbs     LIKE azp_file.azp03
   DEFINE l_j       LIKE type_file.num5
   DEFINE l_k       LIKE type_file.num5
   DEFINE l_p       LIKE type_file.num5
   DEFINE l_azp02   LIKE azp_file.azp02
   DEFINE l_maj02   LIKE maj_file.maj02
   DEFINE l_maj08   LIKE maj_file.maj08
   DEFINE c_maj08   LIKE maj_file.maj08
   DEFINE l_maj21   LIKE maj_file.maj21
   DEFINE l_maj22   LIKE maj_file.maj22
   DEFINE l_maj24   LIKE maj_file.maj24
   DEFINE l_maj25   LIKE maj_file.maj25
   DEFINE l_plant   LIKE azp_file.azp01        #FUN-A50102
 
   DROP TABLE tmp_file
   CREATE TEMP TABLE tmp_file(
     maj02      LIKE maj_file.maj02,
     maj08      LIKE maj_file.maj08,
     maj20      LIKE maj_file.maj20,
     n_row      LIKE type_file.num10,
     maj03      LIKE maj_file.maj03,
     axb04      LIKE axb_file.axb04,
     bal1       LIKE type_file.chr20,
     bal2       LIKE type_file.chr20);
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
	    AND aaf02 = g_rlang
 
     LET l_sql = "SELECT * FROM maj_file ",
		 " WHERE maj01 = '",tm.a,"' ",
		 "   AND maj23[1,1]='1' ",
		 " ORDER BY maj02"
     PREPARE q911_p FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM 
     END IF
     DECLARE q911_c CURSOR FOR q911_p
 
     FOR g_i = 1 TO 100 LET g_tot0[g_i]=0  LET g_tot1[g_i] = 0 END FOR
     CASE cl_db_get_database_type()
        WHEN "IFX"  LET l_split = ':'
        WHEN "ORA"  LET l_split = '.'
     END CASE
 
     DECLARE axb_curs CURSOR FOR
      SELECT UNIQUE axb04,axb05,axz03 FROM axb_file,axz_file
       WHERE axb01 = tm.axa01
         AND axb02 = tm.axa02
         AND axb03 = tm.b
         AND axb04 = axz01
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare axb_curs',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     LET g_title[1].axb04 = tm.axa02
     LET g_title[1].axb05 = tm.b
     #SELECT azp02,azp03 INTO l_azp02,l_dbs
     SELECT azp01,azp02,azp03 INTO l_plant,l_azp02,l_dbs      #FUN-A50102
       FROM azp_file,axz_file
      WHERE axz01 = tm.axa02
        AND axz03 = azp01
     LET l_dbs_sep = l_dbs CLIPPED,l_split
     LET g_title[1].dbs = l_dbs_sep
     LET g_title[1].azp02 = l_azp02
     LET g_title[1].azp01 = l_plant  #FUN-A50102
 
     LET g_i = 2
     FOREACH axb_curs INTO l_axb04,l_axb05,l_axz03
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach axb_curs',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #SELECT azp02,azp03 INTO l_azp02,l_dbs FROM azp_file
        SELECT azp01,azp02,azp03 INTO l_plant,l_azp02,l_dbs FROM azp_file #FUN-A50102
         WHERE azp01 = l_axz03
        IF SQLCA.sqlcode THEN
           CONTINUE FOREACH
        END IF
        LET l_dbs_sep = l_dbs CLIPPED,l_split
        LET g_title[g_i].axb04 = l_axb04
        LET g_title[g_i].axb05 = l_axb05
        LET g_title[g_i].dbs   = l_dbs_sep
        LET g_title[g_i].azp02 = l_azp02
        LET g_title[g_i].azp01 = l_plant  #FUN-A50102
        LET g_i = g_i + 1
    END FOREACH
    LET g_i = g_i - 1
    FOR l_k = 1 TO g_i
        LET l_dbs_sep = g_title[l_k].dbs
        LET l_axb05 = g_title[l_k].axb05
        LET l_plant = g_title[l_k].azp01  #FUN-A50102
 
        #LET g_sql= "SELECT SUM(aah04-aah05) FROM ",l_dbs_sep,"aah_file,",
        #                                           l_dbs_sep,"aag_file ",
        LET g_sql= "SELECT SUM(aah04-aah05) FROM ",cl_get_target_table(l_plant,'aah_file'),",", #FUN-A50102
                                                   cl_get_target_table(l_plant,'aag_file'),     #FUN-A50102
           	   " WHERE aah00 = '",l_axb05,"'",
                   "   AND aah00 = aag00 ",
           	   "   AND aah01 BETWEEN ? AND ? ",
           	   "   AND aah02 = ",tm.yy," AND aah03 <= ? ",
           	   "   AND aah01 = aag01 AND aag07 IN ('2','3')"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE aah_p1 FROM g_sql
 
        #LET g_sql= "SELECT SUM(aao05-aao06) FROM ",l_dbs_sep,"aao_file,",
        #                                           l_dbs_sep,"aag_file ",
        LET g_sql= "SELECT SUM(aao05-aao06) FROM ",cl_get_target_table(l_plant,'aao_file'),",", #FUN-A50102
                                                   cl_get_target_table(l_plant,'aag_file'),     #FUN-A50102
           	   " WHERE aao00 = '",l_axb05,"'",
                   "   AND aao00 = aag00 ",
           	   "   AND aao01 BETWEEN ? AND ? ",
           	   "   AND aao02 BETWEEN ? AND ? ",
           	   "   AND aao03 = ",tm.yy," AND aao04 <= ? ",
           	   "   AND aao01 = aag01 AND aag07 IN ('2','3') "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE aao_p1 FROM g_sql
 
        LET r_row = 0
        CALL prt_r.clear()
        FOREACH q911_c INTO maj.*
          IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          FOR i = 1 TO maj.maj04
              LET r_row=r_row+1
          END FOR
          LET amt0 = 0  #no.A048
          LET amt1 = 0
          IF NOT cl_null(maj.maj21) THEN
             IF maj.maj24 IS NULL THEN
                EXECUTE aah_p1 USING maj.maj21,maj.maj22,'0' INTO amt0
                IF SQLCA.sqlcode THEN
                   CALL cl_err('execute aah_p1',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
                EXECUTE aah_p1 USING maj.maj21,maj.maj22,tm.bm INTO amt1
                IF SQLCA.sqlcode THEN
                   CALL cl_err('execute aah_p1',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
             ELSE
                EXECUTE aao_p1 USING maj.maj21,maj.maj22,maj.maj24,maj.maj25,'0'
                               INTO amt0
                IF SQLCA.sqlcode THEN
                   CALL cl_err('execute aao_p1',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
                EXECUTE aao_p1 USING maj.maj21,maj.maj22,maj.maj24,maj.maj25,tm.bm
                               INTO amt1
                IF SQLCA.sqlcode THEN
                   CALL cl_err('execute aao_p1',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
             END IF
             IF amt0 IS NULL THEN LET amt0 = 0 END IF
             IF amt1 IS NULL THEN LET amt1 = 0 END IF
          END IF
          IF tm.o = 'Y' THEN LET amt0 = amt0 * tm.q END IF      #匯率的轉換
          IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF      #匯率的轉換
          IF maj.maj03 MATCHES "[012349]" AND maj.maj08 > 0     #合計階數處理
             THEN FOR i = 1 TO 100
                  LET g_tot0[i]=g_tot0[i]+amt0
                  LET g_tot1[i]=g_tot1[i]+amt1
                  END FOR
                  LET k=maj.maj08
                  LET sr.bal0=g_tot0[k]
                  LET sr.bal1=g_tot1[k]
                  FOR i = 1 TO maj.maj08 LET g_tot0[i]=0 LET g_tot1[i]=0 END FOR
             ELSE
               IF maj.maj03='5' THEN
                  LET sr.bal0=amt0
                  LET sr.bal1=amt1
               ELSE
                  LET sr.bal0=NULL
                  LET sr.bal1=NULL
               END IF
          END IF
          IF maj.maj11 = 'Y' THEN                               #百分比基准科目
             LET g_basetot1=sr.bal1
             IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
             IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
          END IF
          IF maj.maj03='0' THEN CONTINUE FOREACH END IF         #本行不印出
          IF (tm.c='N' OR maj.maj03='2') AND
             maj.maj03 MATCHES "[012]" AND sr.bal1=0 THEN
             CONTINUE FOREACH                                   #余額為 0 者不列印
          END IF
          IF tm.f>0 AND maj.maj08 < tm.f THEN
             CONTINUE FOREACH                                   #最小階數起列印
          END IF
 
          IF maj.maj07='2' THEN
                LET sr.bal0=sr.bal0*-1
                LET sr.bal1=sr.bal1*-1
          END IF
          IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
          LET per1 = (sr.bal1 / g_basetot1) * 100
          IF tm.d MATCHES '[234]' THEN LET sr.bal1=sr.bal1/g_unit END IF   #No.FUN-570087
 
          LET r_row=r_row+1
          LET prt_r[r_row].maj02=maj.maj02
          LET prt_r[r_row].maj08=maj.maj08
          LET prt_r[r_row].maj20=maj.maj05 SPACES,maj.maj20
                                        #-- 右邊(負債&業主權益)
          LET prt_r[r_row].maj26=maj.maj26      #No.FUN-570087
          LET prt_r[r_row].bal0=cl_numfor(sr.bal0,17,tm.e)
          LET prt_r[r_row].bal=cl_numfor(sr.bal1,17,tm.e)
          LET prt_r[r_row].per=per1 USING '----&.&& %'
 
           CASE WHEN maj.maj03 = '9'
            	    LET prt_r[r_row].maj03='9'
                WHEN maj.maj03 = '3'
            	    LET r_row=r_row+1
                    LET prt_r[r_row].maj02=maj.maj02
                    LET prt_r[r_row].maj08=maj.maj08
            	    LET prt_r[r_row].bal0='-----------------'
            	    LET prt_r[r_row].bal='-----------------'
            	    LET prt_r[r_row].per='----------'
                WHEN maj.maj03 = '4'
            	    LET r_row=r_row+1
                    LET prt_r[r_row].maj02=maj.maj02
                    LET prt_r[r_row].maj08=maj.maj08
            	    LET prt_r[r_row].maj20='--------------------',
            				   '-----'
            	    LET prt_r[r_row].bal0='-----------------'
            	    LET prt_r[r_row].bal='-----------------'
            	    LET prt_r[r_row].per='----------'
           END CASE
        END FOREACH
        FOR l_i = 1 TO r_row
           INSERT INTO tmp_file VALUES(prt_r[l_i].maj02,
                                       prt_r[l_i].maj08,
                                       prt_r[l_i].maj20,l_i,
                                       prt_r[l_i].maj03,g_title[l_k].axb04,
                                       prt_r[l_i].bal0,prt_r[l_i].bal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3('ins','tmp_file',prt_r[l_i].maj20,g_title[l_k].axb04,SQLCA.sqlcode,'','',1)
              EXIT FOR
           END IF
        END FOR
     END FOR
 
     FOR l_i = 1 TO g_i
         LET g_msg = g_title[l_i].azp02 CLIPPED,'本期'
         LET g_msg1= "sum",l_i USING "<<<<<"
         CALL cl_set_comp_visible(g_msg1,TRUE)
         CALL cl_set_comp_att_text(g_msg1,g_msg CLIPPED)
     END FOR
     LET l_i = g_i + 1
     LET g_msg = '合計'
     LET g_msg1= "sum",l_i USING "<<<<<"
     CALL cl_set_comp_visible(g_msg1, TRUE)
     CALL cl_set_comp_att_text(g_msg1,g_msg CLIPPED)
 
     FOR l_j = l_i + 1 TO 10
         LET g_msg1= "sum",l_j USING "<<<<<"
         CALL cl_set_comp_visible(g_msg1,FALSE)
     END FOR
 
     DECLARE gglq911_cur CURSOR FOR
      SELECT UNIQUE maj02,maj08,maj20,n_row,maj03 FROM tmp_file
       ORDER BY n_row
     CALL g_aag.clear()
     LET l_i = 1
     DELETE FROM gglq911_tmp1;
     LET g_cnt = 1
 
     LET g_sql = " SELECT maj08,maj21,maj22,maj24,maj25 ",
                 "   FROM maj_file ",
                 "  WHERE maj01 = '",tm.a,"'",
                 "    AND maj23 LIKE '1%' ",
                 "    AND maj02 <= ? ",
                 "    AND maj03 IN ('0','1','2','3','4','5','9') ",
                 "  ORDER BY maj02 DESC"
     PREPARE gglq911_maj_p1 FROM g_sql
     DECLARE gglq911_maj_cur CURSOR FOR gglq911_maj_p1
 
 
     FOREACH gglq911_cur INTO l_maj02,l_maj08,l_maj20,l_row,l_maj03
         LET g_aag[l_i].aag01 = l_maj20
         LET g_aag[l_i].cnt   = g_cnt
         LET l_sum3 = 0
         LET l_sum4 = 0
 
         #for drill down  begin
         LET l_p = 1
         FOREACH gglq911_maj_cur USING l_maj02
                 INTO c_maj08,l_maj21,l_maj22,l_maj24,l_maj25
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq911_maj_cur',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF c_maj08 >= l_maj08 AND l_p <> 1 THEN
               EXIT FOREACH
            END IF
            INSERT INTO gglq911_tmp1
                   VALUES(g_cnt,l_maj21,l_maj22,l_maj24,l_maj25)
            IF SQLCA.sqlcode THEN
               CALL cl_err3('ins','gglq911_tmp1',l_maj21,l_maj22,SQLCA.sqlcode,'','',1)
            END IF
            LET l_p = l_p + 1
         END FOREACH
         #for drill down  End
 
         FOR l_j = 1 TO g_i
             LET l_sum1 = 0
             LET l_sum2 = 0
             SELECT bal1,bal2 INTO l_sum1,l_sum2 FROM tmp_file
              WHERE n_row = l_row
                AND axb04 = g_title[l_j].axb04
             IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
             IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
             LET l_sum3 = l_sum3 + l_sum1
             LET l_sum4 = l_sum4 + l_sum2
             CASE l_j
                  WHEN 1  LET g_aag[l_i].sum1 = l_sum2
                          LET g_aag[l_i].sum2 = l_sum4
                  WHEN 2  LET g_aag[l_i].sum2 = l_sum2
                          LET g_aag[l_i].sum3 = l_sum4
                  WHEN 3  LET g_aag[l_i].sum3 = l_sum2
                          LET g_aag[l_i].sum4 = l_sum4
                  WHEN 4  LET g_aag[l_i].sum4 = l_sum2
                          LET g_aag[l_i].sum5 = l_sum4
                  WHEN 5  LET g_aag[l_i].sum5 = l_sum2
                          LET g_aag[l_i].sum6 = l_sum4
                  WHEN 6  LET g_aag[l_i].sum6 = l_sum2
                          LET g_aag[l_i].sum7 = l_sum4
                  WHEN 7  LET g_aag[l_i].sum7 = l_sum2
                          LET g_aag[l_i].sum8 = l_sum4
                  WHEN 8  LET g_aag[l_i].sum8 = l_sum2
                          LET g_aag[l_i].sum9 = l_sum4
                  WHEN 9  LET g_aag[l_i].sum9 = l_sum2
                          LET g_aag[l_i].sum10= l_sum4
                  WHEN 10 LET g_aag[l_i].sum10= l_sum2
             END CASE
         END FOR
         LET l_i = l_i + 1
         LET g_cnt = g_cnt + 1
     END FOREACH
     LET g_rec_b = l_i - 1
 
END FUNCTION
 
FUNCTION q911_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY tm.a TO FORMONLY.maj01
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
   DISPLAY ARRAY g_aag TO s_aag.* ATTRIBUTE(COUNT=g_rec_b)
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
 
#FUNCTION q911_out()
#   DEFINE tmp RECORD
#	      maj20_l    LIKE type_file.chr1000,
#              maj26      LIKE type_file.num5,
#	      bal_l0     LIKE type_file.chr20,
#	      bal_l      LIKE type_file.chr20,
#	      per_l      LIKE type_file.chr20,
#	      maj03_l    LIKE maj_file.maj03,
#	      maj20_r    LIKE type_file.chr1000,
#              maj26_r    LIKE type_file.num5,
#	      bal_r0     LIKE type_file.chr20,
#	      bal_r      LIKE type_file.chr20,
#	      per_r      LIKE type_file.chr20,
#	      maj03_r    LIKE maj_file.maj03
#	      END RECORD
#   DEFINE l_i       LIKE type_file.num10
#
#   IF g_aag.getLength() = 0  THEN RETURN END IF
#   ### *** 與 Crystal Reports 串聯段 - <<<<產生Temp Table >>>> CR11 *** ##
#   LET g_sql="maj02.maj_file.maj02,",    #項次（排序要用的）
#             "maj20_l.type_file.chr1000,",
#             "maj26.type_file.num5,",    #行序
#             "bal_l0.type_file.chr20,",  #年初數
#             "bal_l.type_file.chr20,",   #期末數
#             "per_l.type_file.chr20,",
#             "maj03_l.maj_file.maj03,",  #列印碼
#             "maj20_r.type_file.chr1000,",
#             "maj26_r.type_file.num5,",  #行序
#             "bal_r0.type_file.chr20,",  #年初數
#             "bal_r.type_file.chr20,",   #期末數
#             "per_r.type_file.chr20,",
#             "maj03_r.maj_file.maj03"  #列印碼
#
#   LET l_table = cl_prt_temptable('gglq911',g_sql)  CLIPPED   #產生Temp Table
#   IF l_table = -1 THEN EXIT PROGRAM END IF
#   LET g_sql="INSERT INTO ds_report:",l_table CLIPPED,
#             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN
#       CALL cl_err('insert_prep:',status,1)
#       EXIT PROGRAM
#   END IF
#   #-------------------------------- CR (1) ------------------------------------#
#
#   ## *** 與 Crystal Reports  串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
#   CALL cl_del_data(l_table)
#   #-------------------------------CR(2)----------------------------------#
#
#   FOR l_i = 1 TO g_rec_b
#        EXECUTE insert_prep USING
#           l_i,g_aag[l_i].aag01_l,g_aag[l_i].line_l,g_aag[l_i].sum1_l,
#           g_aag[l_i].sum2_l,'','',
#           g_aag[l_i].aag01_r,g_aag[l_i].line_r,g_aag[l_i].sum1_r,
#           g_aag[l_i].sum2_r,'',''
#   END FOR
#
#     ## *** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
#     LET g_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#
#     #報表名稱是否以報表結構名稱列印
#     IF g_aaz.aaz77='N' THEN LET g_mai02= '' END IF
#     LET g_str = g_mai02,';',tm.b,';',tm.a,';',tm.yy,';',tm.bm,';',tm.c,';',tm.d,';',tm.e,';',
#                 tm.f,';',tm.h,';',tm.o,';',tm.r,';',tm.p,';',tm.q,';',tm.more
#     CALL cl_prt_cs3('gglq911','gglq911',g_sql,g_str)
#     #----------------------------- CR (4) --------------------------------------------------#
#
#END FUNCTION
 

#No.TQC-B60384  begin
#FUNCTION q911_drill_down()
#   DEFINE l_aah   DYNAMIC ARRAY OF RECORD
#                  axb04     LIKE azp_file.azp02,
#                  dbs       LIKE azp_file.azp03,
#                  aah01     LIKE aah_file.aah01,
#                  aag02     LIKE aag_file.aag02,
#                  qc_aah04  LIKE aah_file.aah04,
#                  qc_aah05  LIKE aah_file.aah05,
#                  qj_aah04  LIKE aah_file.aah04,
#                  qj_aah05  LIKE aah_file.aah05,
#                  qm_aah04  LIKE aah_file.aah04,
#                  qm_aah05  LIKE aah_file.aah05
#                  END RECORD
#   DEFINE l_date1   LIKE type_file.dat
#   DEFINE l_date2   LIKE type_file.dat
#   DEFINE l_axb04   LIKE axb_file.axb04
#   DEFINE l_axb05   LIKE axb_file.axb05
#   DEFINE l_dbs_sep LIKE type_file.chr50
#   DEFINE l_azp02   LIKE azp_file.azp02
#   DEFINE l_k       LIKE type_file.num5
#   DEFINE l_i       LIKE type_file.num10
#   DEFINE l_j       LIKE type_file.num10
#   DEFINE l_maj21   LIKE maj_file.maj21
#   DEFINE l_maj22   LIKE maj_file.maj22
#   DEFINE l_maj24   LIKE maj_file.maj24
#   DEFINE l_maj25   LIKE maj_file.maj25
#   DEFINE l_dbs     LIKE azp_file.azp03
#   DEFINE l_dbs_old LIKE azp_file.azp03
#   DEFINE lc_tty_no    LIKE zxx_file.zxx02
#   DEFINE ls_tty_no    STRING
#   DEFINE qc_aah04     LIKE aah_file.aah04
#   DEFINE qc_aah05     LIKE aah_file.aah05
#   DEFINE qj_aah04     LIKE aah_file.aah04
#   DEFINE qj_aah05     LIKE aah_file.aah05
#   DEFINE qm_aah04     LIKE aah_file.aah04
#   DEFINE qm_aah05     LIKE aah_file.aah05
#   DEFINE l_aah_str    LIKE type_file.chr1000
#   DEFINE l_aao_str    LIKE type_file.chr1000
#   DEFINE l_aag01      LIKE aag_file.aag01
#   DEFINE l_aag02      LIKE aag_file.aag02
#   DEFINE l_gbq10      LIKE gbq_file.gbq10
#   DEFINE l_plant      LIKE azp_file.azp01   #FUN-A50102
# 
#    IF g_aag[l_ac].cnt <= 0 OR cl_null(g_aag[l_ac].cnt) THEN
#       RETURN
#    END IF
#    #LET ls_tty_no = FGL_GETENV('FGLSERVER')
#    #LET lc_tty_no = ls_tty_no.trim()
#    CALL fgl_getenv('LOGTTY') RETURNING lc_tty_no
#    IF (lc_tty_no IS NULL) THEN
#       LET lc_tty_no = '-'
#    END IF
# 
#    CALL l_aah.clear()
#    LET g_rec_b1 = 0
# 
#    DECLARE gglq911_tmp1_cs CURSOR FOR
#     SELECT aag01,aag02,maj24,maj25 FROM gglq911_tmp1,aag_file
#      WHERE cnt = g_aag[l_ac].cnt
#        AND aag01 BETWEEN maj21 AND maj22
#        AND aag00 = g_title[1].axb05
#        AND aag07 IN ('2','3')
#      ORDER BY aag01,maj24,maj25
#    LET l_i = 1
#    FOR l_k = 1 TO g_i
#        SELECT azp01 INTO l_dbs
#         FROM azp_file,axz_file
#         WHERE axz01 = g_title[l_k].axb04
#           AND axz03 = azp01
# 
#        LET l_dbs_sep = g_title[l_k].dbs
#        LET l_axb05 = g_title[l_k].axb05
#        LET l_plant = g_title[l_k].azp01   #FUN-A50102
# 
#        LET l_aah_str = " SELECT SUM(aah04),SUM(aah05) ",
#                        #"   FROM ",l_dbs_sep CLIPPED,"aah_file ",
#                        "   FROM ",cl_get_target_table(l_plant,'aah_file'), #FUN-A50102
#                        "  WHERE aah00 = '",l_axb05,"'",
#                        "    AND aah01 = ?",
#                        "    AND aah02 = ",tm.yy
#        LET g_sql = l_aah_str CLIPPED,
#                    "    AND aah03 < ",tm.bm
# 	#CALL cl_replace_sqldb(l_aah_str) RETURNING l_aah_str    #FUN-920032  #FUN-950007 mark
# 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-920032  #FUN-950007 add
#     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
#        PREPARE gglq911_aah_qc_p FROM g_sql
# 
#        LET g_sql = l_aah_str CLIPPED,
#                    "    AND aah03 BETWEEN ? AND ? "
#        PREPARE gglq911_aah_qj_p FROM g_sql
# 
#        LET l_aao_str = " SELECT SUM(aao05),SUM(aao06) ",
#                        #"   FROM ",l_dbs_sep CLIPPED,"aao_file ",
#                        "   FROM ",cl_get_target_table(l_plant,'aao_file'), #FUN-A50102
#                        "  WHERE aao00 = '",l_axb05,"'",
#                        "    AND aao01 = ?",
#                        "    AND aao02 BETWEEN ? AND ? ",
#                        "    AND aao03 = ",tm.yy
#        LET g_sql = l_aao_str CLIPPED,
#                    "    AND aao04 < ",tm.bm
# 	#CALL cl_replace_sqldb(l_aao_str) RETURNING l_aao_str    #FUN-920032  #FUN-950007 mark
# 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-920032  #FUN-950007 add
#     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
#        PREPARE gglq911_aao_qc_p FROM g_sql
# 
#        LET g_sql = l_aao_str CLIPPED,
#                    "    AND aao04 BETWEEN ? AND ? "
#        PREPARE gglq911_aao_qj_p FROM g_sql
# 
#        FOREACH gglq911_tmp1_cs INTO l_aag01,l_aag02,l_maj24,l_maj25
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('gglq911_tmp1_cs',SQLCA.sqlcode,1)
#              EXIT FOREACH
#           END IF
#           LET l_aah[l_i].axb04 = g_title[l_k].azp02
#           LET l_aah[l_i].dbs   = l_dbs
#           LET l_aah[l_i].aah01 = l_aag01
#           LET l_aah[l_i].aag02 = l_aag02
# 
#           LET qc_aah04 = 0    LET qc_aah05 = 0
#           LET qj_aah04 = 0    LET qj_aah05 = 0
#           LET qm_aah04 = 0    LET qm_aah05 = 0
#           IF cl_null(l_maj24) THEN
#              EXECUTE gglq911_aah_qc_p USING l_aag01
#                      INTO qc_aah04,qc_aah05
#           ELSE
#              EXECUTE gglq911_aao_qc_p USING l_aag01,l_maj24,l_maj25
#                      INTO qc_aah04,qc_aah05
#           END IF
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('execute qc_p',SQLCA.sqlcode,1)
#              EXIT FOREACH
#           END IF
#           IF cl_null(qc_aah04) THEN LET qc_aah04 = 0 END IF
#           IF cl_null(qc_aah05) THEN LET qc_aah05 = 0 END IF
# 
#           IF cl_null(l_maj24) THEN
#              EXECUTE gglq911_aah_qj_p USING l_aag01,tm.bm,tm.bm
#                      INTO qj_aah04,qj_aah05
#           ELSE
#              EXECUTE gglq911_aao_qj_p USING l_aag01,l_maj24,l_maj25,tm.bm,tm.bm
#                      INTO qj_aah04,qj_aah05
#           END IF
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('execute qj_p',SQLCA.sqlcode,1)
#              EXIT FOREACH
#           END IF
#           IF cl_null(qj_aah04) THEN LET qj_aah04 = 0 END IF
#           IF cl_null(qj_aah05) THEN LET qj_aah05 = 0 END IF
# 
#           IF qc_aah04 > qc_aah05 THEN
#              LET qc_aah04 = qc_aah04 - qc_aah05
#              LET qc_aah05 = 0
#           ELSE
#              LET qc_aah05 = qc_aah05 - qc_aah04
#              LET qc_aah04 = 0
#           END IF
#           LET qm_aah04 = qc_aah04 + qj_aah04
#           LET qm_aah05 = qc_aah05 + qj_aah05
#           IF qm_aah04 > qm_aah05 THEN
#              LET qm_aah04 = qm_aah04 - qm_aah05
#              LET qm_aah05 = 0
#           ELSE
#              LET qm_aah05 = qm_aah05 - qm_aah04
#              LET qm_aah04 = 0
#           END IF
#           LET l_aah[l_i].qc_aah04 = qc_aah04
#           LET l_aah[l_i].qc_aah05 = qc_aah05
#           LET l_aah[l_i].qj_aah04 = qj_aah04
#           LET l_aah[l_i].qj_aah05 = qj_aah05
#           LET l_aah[l_i].qm_aah04 = qm_aah04
#           LET l_aah[l_i].qm_aah05 = qm_aah05
# 
#           LET l_i = l_i + 1
#        END FOREACH
#    END FOR
#    LET g_rec_b1 = l_i - 1
# 
#    OPEN WINDOW q911_w2 AT 5,10
#         WITH FORM "ggl/42f/gglq911_2" ATTRIBUTE(STYLE = g_win_style)
#    CALL cl_ui_locale("gglq911_2")
#    CALL cl_set_comp_visible("dbs",FALSE)
# 
#    DISPLAY g_rec_b1 TO cnt
#    CALL cl_set_act_visible("accept,cancel", FALSE)
# 
#    DISPLAY ARRAY l_aah TO s_aah.* ATTRIBUTE(COUNT=g_rec_b1)
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()
# 
#      ON ACTION drill_detail
#         IF l_ac > 0 AND NOT cl_null(l_aah[l_ac].aah01) THEN
#            UPDATE zx_file SET zx08 = l_aah[l_ac].dbs
#             WHERE zx01=g_user
#            LET l_gbq10 = l_aah[l_ac].dbs CLIPPED,'/',l_aah[l_ac].dbs
#            UPDATE gbq_file SET gbq10=l_gbq10 WHERE gbq03=g_user
#            UPDATE zxx_file SET zxx03 = l_aah[l_ac].dbs
#             WHERE zxx01 = g_user AND zxx02 = lc_tty_no
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#               INSERT INTO zxx_file VALUES(g_user,lc_tty_no,l_aah[l_ac].dbs)
#            END IF
#            LET g_sql = "aag01 = '",l_aah[l_ac].aah01,"'"
#            CALL s_azn01(tm.yy,tm.bm) RETURNING l_date1,l_date2
#            #LET g_msg = "gglq301 '",g_title[1].axb05,"' '' '' '",g_lang,
#            #            "' 'Y' '' '' '",g_sql CLIPPED,
#            #            "' ' 1=1' 'N' 'Y' 'N' 'N' '' '3' '",
#            #            l_date1,"' '",l_date2,"' '' '' '' ''"
#            LET g_msg = 'gglq301 "',g_title[1].axb05,'" "" "" "',g_lang,
#                        '" "Y" "" "" "',g_sql CLIPPED,
#                        '" " 1=1" "N" "Y" "N" "N" "" "3" "',
#                        l_date1,'" "',l_date2,'" "" "" "" ""'
#            CALL cl_cmdrun_wait(g_msg)
#            UPDATE zxx_file SET zxx03 = g_plant
#             WHERE zxx01 = g_user AND zxx02 = lc_tty_no
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#               INSERT INTO zxx_file VALUES(g_user,lc_tty_no,g_plant)
#            END IF
#         END IF
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         CALL cl_cmdask()
#         #EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET INT_FLAG=FALSE
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION close
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION exporttoexcel
#         IF cl_chk_act_auth() THEN
#           CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_aah),'','')
#         END IF
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
# 
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
#   CLOSE WINDOW q911_w2
# 
#END FUNCTION
##No.TQC-B60384 end 
