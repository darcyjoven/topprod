# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: gglq810.4gl
# Descriptions...: 帳戶式資產負債表查詢化
# Date & Author..: No.TQC-B50154 11/06/08 By zm
 
DATABASE ds  #No.FUN-850030
 
GLOBALS "../../config/top.global"
 
   DEFINE tm         RECORD
                     wc        STRING,
	             a     LIKE mbi_file.mbi01,  #報表結構編號
	             b     LIKE aaa_file.aaa01,  
	             yy    LIKE type_file.num5,  #輸入年度
	             bm    LIKE type_file.num5,  #Begin 期別
	             c     LIKE type_file.chr1,  #異動額及餘額為0者是否列印
	             d     LIKE type_file.chr1,  #金額單位
	             e     LIKE type_file.num5,  #小數位數
	             f     LIKE type_file.num5,  #列印最小階數
	             h     LIKE type_file.chr4,  #額外說明類別
	             o     LIKE type_file.chr1,  #轉換幣別否
	             p     LIKE azi_file.azi01,  #幣別
	             q     LIKE azj_file.azj03,  #匯率
	             r     LIKE azi_file.azi01,  #幣別
	             g     LIKE type_file.chr1,  #No.TQC-B30210 #是否包含審計調整
	             more  LIKE type_file.chr1   #Input more condition(Y/N)
	             END RECORD,
	  i,j,k      LIKE type_file.num5, 
	  g_unit     LIKE type_file.num10,       #金額單位基數
	  l_row      LIKE type_file.num5, 
	  r_row      LIKE type_file.num5, 
	  g_bookno   LIKE aah_file.aah00,        #帳別
	  g_mbi02    LIKE mbi_file.mbi02,
	  g_mbi03    LIKE mbi_file.mbi03,
	  g_tot1     ARRAY[100] OF LIKE type_file.num20_6,
	  g_tot0     ARRAY[100] OF LIKE type_file.num20_6,
	  g_basetot1 LIKE type_file.num20_6
 
DEFINE   g_aaa03     LIKE aaa_file.aaa03   
DEFINE   g_i         LIKE type_file.num5 
DEFINE   g_rec_b     LIKE type_file.num5
DEFINE   l_ac        LIKE type_file.num5
DEFINE   g_aag       DYNAMIC ARRAY OF RECORD 
                     aag01_l    LIKE mbj_file.mbj20,
                     line_l     LIKE mbj_file.mbj26,
                     sum1_l     LIKE aah_file.aah04,
                     sum2_l     LIKE aah_file.aah05,
                     aag01_r    LIKE mbj_file.mbj20,
                     line_r     LIKE mbj_file.mbj26,
                     sum1_r     LIKE aah_file.aah04,
                     sum2_r     LIKE aah_file.aah05
                     END RECORD
DEFINE   g_sql           STRING     
DEFINE   g_str           STRING     
DEFINE   l_table         STRING     
 
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
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.yy = ARG_VAL(10)
   LET tm.bm = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)  
   LET tm.f  = ARG_VAL(15)
   LET tm.h  = ARG_VAL(16)
   LET tm.o  = ARG_VAL(17)
   LET tm.p  = ARG_VAL(18)
   LET tm.q  = ARG_VAL(19)
   LET tm.r  = ARG_VAL(20)
   LET tm.g  = ARG_VAL(21)   #No.TQC-B30210
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)
 
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   OPEN WINDOW q810_w AT 5,10
        WITH FORM "ggl/42f/gglq810" ATTRIBUTE(STYLE = g_win_style)               # No.TQC-B50154
                                                                                
   CALL cl_ui_init()                                                           
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL q810_tm()                          # Input print condition
   ELSE
      CALL q810()                             # Read data and create out-file
   END IF
 
   CALL q810_menu()                                                            
   CLOSE WINDOW q810_w 
   CALL cl_used(g_prog,g_time,2)
        RETURNING g_time
 
END MAIN
 
FUNCTION q810_menu()
   WHILE TRUE
      CALL q810_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q810_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q810_out()
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
 
FUNCTION q810_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5    
   DEFINE p_row,p_col    LIKE type_file.num5,   
	  l_sw           LIKE type_file.chr1,   
	  l_cmd          LIKE type_file.chr1000 
   DEFINE li_result      LIKE type_file.num5    
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   
   CALL s_dsmark(tm.b)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW q810_w1 AT p_row,p_col WITH FORM "ggl/42f/gglr110" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL cl_set_comp_visible("i",FALSE)
 
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
   LET tm.g = 'N'       #No.TQC-B30210
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   DISPLAY BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.c,tm.d,tm.e,tm.f,tm.h,tm.o,tm.r,tm.p,tm.q,tm.g,tm.more   #zm

WHILE TRUE
    LET l_row=0
    LET r_row=0
    LET l_sw = 1
  DIALOG ATTRIBUTE(unbuffered)   
    INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.c,tm.g ATTRIBUTE(WITHOUT DEFAULTS)
#       BEFORE INPUT
#          CALL cl_qbe_init()
 
#       ON ACTION locale
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          LET g_action_choice = "locale"
#          EXIT INPUT
 
       AFTER FIELD a
	  IF tm.a IS NULL THEN NEXT FIELD a END IF
          CALL s_chkmai(tm.a,'RGL') RETURNING li_result
          IF NOT li_result THEN
             CALL cl_err(tm.a,g_errno,1)
             NEXT FIELD a
          END IF
	  SELECT mbi02,mbi03 INTO g_mbi02,g_mbi03 FROM mbi_file
	   WHERE mbi01 = tm.a AND mbiacti IN ('Y','y')
             AND mbi00 = tm.b
	  IF STATUS THEN 
	     CALL cl_err3("sel","mbi_file",tm.a,tm.b,STATUS,"","sel mbi:",0)   #No.FUN-660124     #No.FUN-740032
	     NEXT FIELD a
          END IF
 
       AFTER FIELD b
          IF cl_null(tm.b) THEN NEXT FIELD b END IF
          IF NOT cl_null(tm.b) THEN
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF
             SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
             IF STATUS THEN
                CALL cl_err3("sel","aaa.file",tm.b,"",STATUS,"","sel aaa:",0)    #No.FUN-660124   
                NEXT FIELD b 
             END IF
          END IF
 
       AFTER FIELD c
          IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
       AFTER FIELD yy
          IF tm.yy IS NULL OR tm.yy = 0 THEN
             NEXT FIELD yy
          END IF
 
       AFTER FIELD g
          IF tm.g IS NULL OR tm.g NOT MATCHES "[YN]" THEN NEXT FIELD g END IF

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

     END INPUT  

     CONSTRUCT BY NAME tm.wc ON aao02
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
     END CONSTRUCT

     INPUT BY NAME tm.d,tm.e,tm.h,tm.f,tm.o,tm.r,tm.p,tm.q,tm.more ATTRIBUTE(WITHOUT DEFAULTS)
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)

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
 
       AFTER FIELD o
          IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
          IF tm.o = 'N' THEN 
             LET tm.p = g_aaa03 
             LET tm.q = 1
             DISPLAY g_aaa03 TO p
             DISPLAY BY NAME tm.q
          END IF
 
       BEFORE FIELD p
          IF tm.o = 'N' THEN NEXT FIELD more END IF
 
       AFTER FIELD p
	  SELECT azi01 FROM azi_file WHERE azi01 = tm.p
	  IF SQLCA.sqlcode THEN 
	     CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)
	     NEXT FIELD p 
	  END IF

       BEFORE FIELD q
          IF tm.o = 'N' THEN NEXT FIELD o END IF
 
       AFTER FIELD more
          IF tm.more = 'Y'
             THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
         			g_bgjob,g_time,g_prtway,g_copies)
         	      RETURNING g_pdate,g_towhom,g_rlang,
         			g_bgjob,g_time,g_prtway,g_copies
          END IF
 
      AFTER INPUT 
{	 IF tm.yy IS NULL THEN 
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
	 END IF    }

	 IF tm.d = '1' THEN LET g_unit = 1       END IF
	 IF tm.d = '2' THEN LET g_unit = 1000    END IF
         IF tm.d = '3' THEN LET g_unit = 10000   END IF 
	 IF tm.d = '4' THEN LET g_unit = 1000000 END IF
      END INPUT 

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION CONTROLP
	 CASE
            WHEN INFIELD(a) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mbi'
               LET g_qryparam.default1 = tm.a
               LET g_qryparam.where = " mbi00 = '",tm.b,"' AND mbi03 ='2' "  #No.MOD-9C0086
               CALL cl_create_qry() RETURNING tm.a 
	       DISPLAY BY NAME tm.a
	       NEXT FIELD a
 
            WHEN INFIELD(b) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
               DISPLAY BY NAME tm.b
               NEXT FIELD b
 
            WHEN INFIELD(p)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
	       DISPLAY BY NAME tm.p 
	       NEXT FIELD p

            WHEN INFIELD(aao02)
              CALL cl_init_qry_var()
              LET g_qryparam.state    = "c"
              LET g_qryparam.form = "q_gem"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aao02
              NEXT FIELD aao02
       END CASE

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT DIALOG

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
  END DIALOG 

   IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q810_w1 RETURN         #No.FUN-A40009
   END IF
   
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
	     WHERE zz01='gglq810'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
   	 CALL cl_err('gglq810','9031',1)   
      ELSE
	 LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
			 " '",g_pdate CLIPPED,"'",
			 " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
			 " '",g_bgjob CLIPPED,"'",
			 " '",g_prtway CLIPPED,"'",
			 " '",g_copies CLIPPED,"'",
			 " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
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
                         " '",tm.g CLIPPED,"'",       #TQC-B30210
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'" 
	 CALL cl_cmdat('gglq810',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW q810_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL q810()
   ERROR ""
   EXIT WHILE
END WHILE
   CLOSE WINDOW q810_w1
END FUNCTION
 
FUNCTION q810()
   DEFINE l_name    LIKE type_file.chr20    # External(Disk) file name
   DEFINE l_sql     STRING
   DEFINE l_acc03   LIKE type_file.chr10
   DEFINE l_chr     LIKE type_file.chr1   
   DEFINE l_za05    LIKE type_file.chr1000
   DEFINE amt0,l_amt0,l_amt0_1,l_amt0_2      LIKE aah_file.aah04     # 期初數
   DEFINE amt1,l_amt1,l_amt1_1,l_amt1_2      LIKE aah_file.aah04   
   DEFINE l_nouse1,l_nouse2     LIKE aah_file.aah04     #无用途
   DEFINE per1      LIKE fid_file.fid03   
   DEFINE mbj       RECORD LIKE mbj_file.*
   DEFINE l_last    LIKE type_file.num5    
   DEFINE l_diff    LIKE type_file.num5    
   DEFINE l_i       LIKE mbj_file.mbj02    
   DEFINE sr  RECORD
	      bal0      LIKE type_file.num20_6,  # 期初數
	      bal1      LIKE type_file.num20_6 
	      END RECORD
   DEFINE prt_l DYNAMIC ARRAY OF RECORD         #--- 陣列 for 資產類 (左)
		mbj20    LIKE type_file.chr1000,
                mbj26    LIKE type_file.num5,   
		bal0     LIKE type_file.chr20,  
		bal      LIKE type_file.chr20,  
		per      LIKE type_file.chr20,  
		mbj03    LIKE mbj_file.mbj03    
		END RECORD
   DEFINE prt_r DYNAMIC ARRAY OF RECORD         #--- 陣列 for 負債&業主權益類 (右)
		mbj20    LIKE type_file.chr1000,
                mbj26    LIKE type_file.num5,   
		bal0     LIKE type_file.chr20,  
		bal      LIKE type_file.chr20,  
		per      LIKE type_file.chr20,  
		mbj03    LIKE mbj_file.mbj03    
		END RECORD
   DEFINE tmp RECORD
	      mbj20_l    LIKE type_file.chr1000,
              mbj26      LIKE type_file.num5,   
	      bal_l0     LIKE type_file.chr20,  
	      bal_l      LIKE type_file.chr20,  
	      per_l      LIKE type_file.chr20,  
	      mbj03_l    LIKE mbj_file.mbj03,   
	      mbj20_r    LIKE type_file.chr1000,
              mbj26_r    LIKE type_file.num5,   
	      bal_r0     LIKE type_file.chr20,  
	      bal_r      LIKE type_file.chr20,  
	      per_r      LIKE type_file.chr20,  
	      mbj03_r    LIKE mbj_file.mbj03    
	      END RECORD
DEFINE l_sw      LIKE type_file.num5  #No.MOD-950053 add 
DEFINE l_n       LIKE type_file.num5  #No.MOD-980059
DEFINE l_ad1     LIKE abb_file.abb07             #No.TQC-B30210
DEFINE l_ad2     LIKE abb_file.abb07             #No.TQC-B30210 

   DROP TABLE tmp_file                                                                                                              
   CREATE TEMP TABLE tmp_file(                                                                                                       
     mbj02      LIKE type_file.num5,  #No.MOD-980059
     mbj20_l    LIKE type_file.chr1000,                                                
     mbj26      LIKE type_file.num5,                                 
     bal_l0     LIKE type_file.chr20,                                           
     bal_l      LIKE type_file.chr20,                                                    
     per_l      LIKE cre_file.cre08,                                                        
     mbj03_l    LIKE mbj_file.mbj03,                                                         
     mbj20_r    LIKE type_file.chr1000,                                                  
     mbj26_r    LIKE type_file.num5,                                     
     bal_r0     LIKE type_file.chr20,                                                    
     bal_r      LIKE type_file.chr20,                                           
     per_r      LIKE cre_file.cre08,                                                   
     mbj03_r    LIKE mbj_file.mbj03);                                                                                                                  
     
   DROP TABLE acc_file
   CREATE TEMP TABLE acc_file(
     acc01   LIKE type_file.chr30,       #科目编号
     acc02   LIKE type_file.chr1,        #+/-
     acc03   LIKE type_file.chr5)        #金额来源
                                                                                                            
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b AND aaf02 = g_rlang
 
   LET l_sql = "SELECT * FROM mbj_file ",
               " WHERE mbj01 = '",tm.a,"' ",
	       "   AND mbj23[1,1]='1' ",
	       " ORDER BY mbj02"
   PREPARE q810_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE q810_c CURSOR FOR q810_p
 
   FOR g_i = 1 TO 100 LET g_tot0[g_i]=0  LET g_tot1[g_i] = 0 END FOR
 
   FOREACH q810_c INTO mbj.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     FOR i = 1 TO mbj.mbj04
         IF mbj.mbj23[2,2]='2' THEN  
            LET r_row=r_row+1
	  ELSE
	     LET l_row=l_row+1
	  END IF
     END FOR
     LET amt0 = 0
     LET amt1 = 0 
     LET l_amt0_1 = 0   LET l_amt0_2 = 0    LET l_amt1_1 = 0   LET l_amt1_2 = 0  LET l_amt0=0  LET l_amt1=0
     LET l_n = 0

     DELETE FROM acc_file
     INSERT INTO acc_file 
     SELECT mbk03,mbk04,'123' FROM mbk_file WHERE mbk01=tm.a AND mbk02=mbj.mbj02 AND mbk05 IN('1','2','3')
     INSERT INTO acc_file 
     SELECT mbk03,mbk04,mbk05 FROM mbk_file WHERE mbk01=tm.a AND mbk02=mbj.mbj02 AND mbk05 IN('4','5')

     #------------Declare Cursor begin------
     LET l_sql = "SELECT SUM(aah04),SUM(aah05),SUM(aah04-aah05) FROM aah_file,aag_file ",       #无部门期初
	         " WHERE aah00 = '",tm.b,"' ",
                 " AND aah00 = aag00 ",
                 " AND aah01 IN(SELECT acc01 FROM acc_file WHERE acc02=? AND acc03=?) ",
	         " AND aah02 = ",tm.yy," AND aah03 =0 ",
	         " AND aah01 = aag01 AND aag07 IN ('2','3') "
     PREPARE q810_p1 FROM l_sql
     IF STATUS THEN CALL cl_err('pre q810_p1',STATUS,1) END IF

     LET l_sql = "SELECT SUM(aah04),SUM(aah05),SUM(aah04-aah05) FROM aah_file,aag_file ",          #无部门期末
                 " WHERE aah00 = '",tm.b,"' ",
                 " AND aah00 = aag00 ",
                 " AND aah01 IN(SELECT acc01 FROM acc_file WHERE acc02=? AND acc03=?) ",
	         " AND aah02 = ",tm.yy," AND aah03 <= ",tm.bm," ",
	         " AND aah01 = aag01 AND aag07 IN ('2','3') "
     PREPARE q810_p2 FROM l_sql
     IF STATUS THEN CALL cl_err('pre q810_p2',STATUS,1) END IF

     LET l_sql = "SELECT SUM(aao05),SUM(aao06),SUM(aao05-aao06) FROM aao_file,aag_file ",          #有部门期初
         	 " WHERE aao00 = '",tm.b,"' ",
                 "   AND aao00 = aag00 ",
                 "   AND aao01 IN(SELECT acc01 FROM acc_file WHERE acc02=? AND acc03=?) ",
	         "   AND ",tm.wc,
	         "   AND aao03 = ",tm.yy," AND aao04 =0  ",
	         "   AND aao01 = aag01 AND aag07 IN ('2','3') "
     PREPARE q810_p3 FROM l_sql
     IF STATUS THEN CALL cl_err('pre q810_p3',STATUS,1) END IF

     LET l_sql = "SELECT SUM(aao05),SUM(aao06),SUM(aao05-aao06) FROM aao_file,aag_file ",          #有部门期末
	         " WHERE aao00 = '",tm.b,"' ",
                 "   AND aao00 = aag00 ",
	         "   AND aao01 IN(SELECT acc01 FROM acc_file WHERE acc02=? AND acc03=?) ",
	         "   AND ",tm.wc,
	         "   AND aao03 = ",tm.yy," AND aao04 <= ",tm.bm," ",
	         "   AND aao01 = aag01 AND aag07 IN ('2','3') "
     PREPARE q810_p4 FROM l_sql
     IF STATUS THEN CALL cl_err('pre q810_p4',STATUS,1) END IF
     #------------Declare Cursor End------

     LET l_sql = "SELECT DISTINCT acc03 FROM acc_file "
     DECLARE q810_cur01 CURSOR FROM l_sql
     FOREACH q810_cur01 INTO l_acc03 
   #  IF mbj.mbj06<'4' THEN  
       IF l_acc03='123' THEN  
	  IF tm.wc=' 1=1' THEN    #无部门条件 
             #期初加项(+) 
             EXECUTE q810_p1 USING '+',l_acc03 INTO l_nouse1,l_nouse2,l_amt0_1
             IF cl_null(l_amt0_1) THEN LET l_amt0_1=0 END IF

             #期初减项(-) 
             EXECUTE q810_p1 USING '-',l_acc03 INTO l_nouse1,l_nouse2,l_amt0_2
             IF cl_null(l_amt0_2) THEN LET l_amt0_2=0 END IF
             LET l_amt0 = l_amt0_1-l_amt0_2

             #期末加项(+) 
             EXECUTE q810_p2 USING '+',l_acc03 INTO l_nouse1,l_nouse2,l_amt1_1
             IF cl_null(l_amt1_1) THEN LET l_amt1_1=0 END IF

             #期末减项(-) 
             EXECUTE q810_p2 USING '-',l_acc03 INTO l_nouse1,l_nouse2,l_amt1_2
             IF cl_null(l_amt1_2) THEN LET l_amt1_2=0 END IF
             LET l_amt1 = l_amt1_1-l_amt1_2
	  ELSE                             #有部门条件
             #期初加项(+)
             EXECUTE q810_p3 USING '+',l_acc03 INTO l_nouse1,l_nouse2,l_amt0_1
             IF cl_null(l_amt0_1) THEN LET l_amt0_1=0 END IF

             #期初减项(-)
             EXECUTE q810_p3 USING '-',l_acc03 INTO l_nouse1,l_nouse2,l_amt0_2
             IF cl_null(l_amt0_2) THEN LET l_amt0_2=0 END IF
             LET l_amt0 = l_amt0_1-l_amt0_2
		 
             #期末加项(+)
             EXECUTE q810_p4 USING '+',l_acc03 INTO l_nouse1,l_nouse2,l_amt1_1
             IF cl_null(l_amt1_1) THEN LET l_amt1_1=0 END IF

             #期末减项(-)
             EXECUTE q810_p4 USING '-',l_acc03 INTO l_nouse1,l_nouse2,l_amt1_2
             IF cl_null(l_amt1_2) THEN LET l_amt1_2=0 END IF
             LET l_amt1 = l_amt1_1-l_amt1_2
          END IF
          IF tm.g = 'Y' THEN
             IF tm.bm = 12 THEN
                LET l_ad1 = 0 
                LET l_ad2 = 0                       
                SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                 WHERE abb00 = tm.b
                   AND aba00 = abb00 AND aba01 = abb01
                   AND abb03 IN(SELECT acc01 FROM acc_file WHERE acc03=l_acc03)
                   AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy+1
                   AND aba04 = 0 AND abapost = 'Y'
                SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                 WHERE abb00 = tm.b
                   AND aba00 = abb00 AND aba01 = abb01
                   AND abb03 IN(SELECT acc01 FROM acc_file WHERE acc03=l_acc03)
                   AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy+1
                   AND aba04 = 0 AND abapost = 'Y'
                IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF 
                LET l_amt1 = l_amt1 + l_ad1 - l_ad2
             END IF
          END IF
	  IF STATUS THEN
             CALL cl_err3("sel","aah_file",tm.p,"",STATUS,"","sel aah:",1)   #No.FUN-6600124
             EXIT FOREACH
          END IF
	  IF l_amt0 IS NULL THEN LET l_amt0 = 0 END IF
	  IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
     END IF

     IF l_acc03='4' THEN  
#     IF mbj.mbj06='4' THEN  
	  IF tm.wc=' 1=1' THEN    #无部门条件 
             #期初加项(+) 
             EXECUTE q810_p1 USING '+',l_acc03 INTO l_amt0_1,l_nouse1,l_nouse2
             IF cl_null(l_amt0_1) THEN LET l_amt0_1=0 END IF

             #期初减项(-) 
             EXECUTE q810_p1 USING '-',l_acc03 INTO l_amt0_2,l_nouse1,l_nouse2
             IF cl_null(l_amt0_2) THEN LET l_amt0_2=0 END IF
             LET l_amt0 = l_amt0_1-l_amt0_2

             #期末加项(+) 
             EXECUTE q810_p2 USING '+',l_acc03 INTO l_amt1_1,l_nouse1,l_nouse2
             IF cl_null(l_amt1_1) THEN LET l_amt1_1=0 END IF

             #期末减项(-) 
             EXECUTE q810_p2 USING '-',l_acc03 INTO l_amt1_2,l_nouse1,l_nouse2
             IF cl_null(l_amt1_2) THEN LET l_amt1_2=0 END IF
             LET l_amt1 = l_amt1_1-l_amt1_2
	  ELSE                           #有部门条件
             #期初加项(+)
             EXECUTE q810_p3 USING '+',l_acc03 INTO l_amt0_1,l_nouse1,l_nouse2
             IF cl_null(l_amt0_1) THEN LET l_amt0_1=0 END IF

             #期初减项(-)
             EXECUTE q810_p3 USING '-',l_acc03 INTO l_amt0_2,l_nouse1,l_nouse2
             IF cl_null(l_amt0_2) THEN LET l_amt0_2=0 END IF
             LET l_amt0 = l_amt0_1-l_amt0_2
		 
             #期末加项(+)
             EXECUTE q810_p4 USING '+',l_acc03 INTO l_amt1_1,l_nouse1,l_nouse2
             IF cl_null(l_amt1_1) THEN LET l_amt1_1=0 END IF

             #期末减项(-)
             EXECUTE q810_p4 USING '-',l_acc03 INTO l_amt1_2,l_nouse1,l_nouse2
             IF cl_null(l_amt1_2) THEN LET l_amt1_2=0 END IF
             LET l_amt1 = l_amt1_1-l_amt1_2
          END IF
          IF tm.g = 'Y' THEN
             IF tm.bm = 12 THEN
                LET l_ad1 = 0 
                SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                 WHERE abb00 = tm.b
                   AND aba00 = abb00 AND aba01 = abb01
                   AND abb03 IN(SELECT acc01 FROM acc_file WHERE acc03=l_acc03)
                   AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy+1
                   AND aba04 = 0 AND abapost = 'Y'
                IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                LET l_amt1 = l_amt1 + l_ad1 
             END IF
          END IF
	  IF STATUS THEN
             CALL cl_err3("sel","aah_file",tm.p,"",STATUS,"","sel aah:",1)   #No.FUN-6600124
             EXIT FOREACH
          END IF
	  IF l_amt0 IS NULL THEN LET l_amt0 = 0 END IF
	  IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
     END IF

   #  IF mbj.mbj06='5' THEN   #贷方金额
     IF l_acc03='5' THEN   #贷方金额
	  IF tm.wc=' 1=1' THEN    #无部门条件 
             #期初加项(+) 
             EXECUTE q810_p1 USING '+',l_acc03 INTO l_nouse1,l_amt0_1,l_nouse2
             IF cl_null(l_amt0_1) THEN LET l_amt0_1=0 END IF

             #期初减项(-) 
             EXECUTE q810_p1 USING '-',l_acc03 INTO l_nouse1,l_amt0_2,l_nouse2
             IF cl_null(l_amt0_2) THEN LET l_amt0_2=0 END IF
             LET l_amt0 = l_amt0_1-l_amt0_2

             #期末加项(+) 
             EXECUTE q810_p2 USING '+',l_acc03 INTO l_nouse1,l_amt1_1,l_nouse2
             IF cl_null(l_amt1_1) THEN LET l_amt1_1=0 END IF

             #期末减项(-) 
             EXECUTE q810_p2 USING '-',l_acc03 INTO l_nouse1,l_amt1_2,l_nouse2
             IF cl_null(l_amt1_2) THEN LET l_amt1_2=0 END IF
             LET l_amt1 = l_amt1_1-l_amt1_2
	  ELSE                           #有部门条件
             #期初加项(+)
             EXECUTE q810_p3 USING '+',l_acc03 INTO l_nouse1,l_amt0_1,l_nouse2
             IF cl_null(l_amt0_1) THEN LET l_amt0_1=0 END IF

             #期初减项(-)
             EXECUTE q810_p3 USING '-',l_acc03 INTO l_nouse1,l_amt0_2,l_nouse2
             IF cl_null(l_amt0_2) THEN LET l_amt0_2=0 END IF
             LET l_amt0 = l_amt0_1-l_amt0_2
		 
             #期末加项(+)
             EXECUTE q810_p4 USING '+',l_acc03 INTO l_nouse1,l_amt1_1,l_nouse2
             IF cl_null(l_amt1_1) THEN LET l_amt1_1=0 END IF

             #期末减项(-)
             EXECUTE q810_p4 USING '-',l_acc03 INTO l_nouse1,l_amt1_2,l_nouse2
             IF cl_null(l_amt1_2) THEN LET l_amt1_2=0 END IF
             LET l_amt1 = l_amt1_1-l_amt1_2
          END IF
          IF tm.g = 'Y' THEN
             IF tm.bm = 12 THEN
                LET l_ad2 = 0 
                SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                 WHERE abb00 = tm.b
                   AND aba00 = abb00 AND aba01 = abb01
                   AND abb03 IN(SELECT acc01 FROM acc_file WHERE acc03=l_acc03)
                   AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy+1
                   AND aba04 = 0 AND abapost = 'Y'
                IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF 
                LET l_amt1 = l_amt1 + l_ad2 
             END IF
          END IF
	  IF STATUS THEN
             CALL cl_err3("sel","aah_file",tm.p,"",STATUS,"","sel aah:",1)   #No.FUN-6600124
             EXIT FOREACH
          END IF
	  IF l_amt0 IS NULL THEN LET l_amt0 = 0 END IF
	  IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
       END IF
       LET amt0 = amt0+l_amt0  
       LET amt1 = amt1+l_amt1
       LET l_amt0_1 = 0   LET l_amt0_2 = 0    LET l_amt1_1 = 0   LET l_amt1_2 = 0  LET l_amt0=0  LET l_amt1=0
     END FOREACH
     IF tm.o = 'Y' THEN LET amt0 = amt0 * tm.q END IF      #匯率的轉換
     IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF      #匯率的轉換
     #  IF NOT cl_null(mbj.mbj21) THEN                                           
     #IF l_n >0 THEN 
     #     IF mbj.mbj06 MATCHES '[123]' AND mbj.mbj07 = '2' THEN                 
     #        LET amt0 = amt0 * -1                                               
     #        LET amt1 = amt1 * -1                                               
     #     END IF                                                                
     #     IF mbj.mbj06 = '4' AND mbj.mbj07 = '2' THEN                           
     #        LET amt0 = amt0 * -1                                               
     #        LET amt1 = amt1 * -1                                               
     #     END IF                                                                
     #     IF mbj.mbj06 = '5' AND mbj.mbj07 = '1' THEN                           
     #        LET amt0 = amt0 * -1                                               
     #        LET amt1 = amt1 * -1                                               
     #     END IF                                                                
     #END IF                                                                   
     IF mbj.mbj03 MATCHES "[012349]" AND mbj.mbj08 > 0     #合計階數處理
	  THEN 
              IF mbj.mbj09 ='-' THEN                                            
                 LET l_sw =-1                                                   
              ELSE                                                              
                 LET l_sw =1                                                    
              END IF                                                            
               FOR i = 1 TO 100 
                   LET g_tot0[i]=g_tot0[i]+amt0 * l_sw
                   LET g_tot1[i]=g_tot1[i]+amt1 * l_sw
               END FOR
	       LET k=mbj.mbj08  
               IF k=1 THEN                                                      
                  LET sr.bal0=amt0                                              
                  LET sr.bal1=amt1                                              
               ELSE                                                             
                  LET sr.bal0=g_tot0[k]                                         
                  LET sr.bal1=g_tot1[k]                                         
               END IF  #No.MOD-950053  
	       FOR i = 1 TO mbj.mbj08 LET g_tot0[i]=0 LET g_tot1[i]=0 END FOR
     ELSE  
            IF mbj.mbj03='5' THEN
               LET sr.bal0=amt0
               LET sr.bal1=amt1
            ELSE
               LET sr.bal0=NULL
               LET sr.bal1=NULL
            END IF
     END IF
     IF mbj.mbj11 = 'Y' THEN                               #百分比基準科目
	  LET g_basetot1=sr.bal1
	  IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
	  IF mbj.mbj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
     END IF
     IF mbj.mbj03='0' THEN CONTINUE FOREACH END IF         #本行不印出
     IF (tm.c='N' OR mbj.mbj03='2') AND
	  mbj.mbj03 MATCHES "[012]" AND sr.bal1=0 THEN
	  CONTINUE FOREACH                                   #餘額為 0 者不列印
     END IF
     IF tm.f>0 AND mbj.mbj08 < tm.f THEN
	  CONTINUE FOREACH                                   #最小階數起列印
     END IF
    
       IF tm.h='Y' THEN LET mbj.mbj20=mbj.mbj20e END IF
       LET per1 = (sr.bal1 / g_basetot1) * 100
       IF tm.d MATCHES '[234]' THEN LET sr.bal1=sr.bal1/g_unit END IF   #No.FUN-570087   
 
       IF mbj.mbj23[2,2]='2' THEN  
	  LET r_row=r_row+1
	  LET prt_r[r_row].mbj20=mbj.mbj05 SPACES,mbj.mbj20 
					#-- 右邊(負債&業主權益)
          LET prt_r[r_row].mbj26=mbj.mbj26      #No.FUN-570087    
	  LET prt_r[r_row].bal0=cl_numfor(sr.bal0,17,tm.e) 
	  LET prt_r[r_row].bal=cl_numfor(sr.bal1,17,tm.e)  
	  LET prt_r[r_row].per=per1 USING '----&.&& %'
       ELSE
	  LET l_row=l_row+1
	  LET prt_l[l_row].mbj20= mbj.mbj05 SPACES, mbj.mbj20   #--- 左邊 (資產)
          LET prt_l[l_row].mbj26=mbj.mbj26      #No.FUN-570087 
	  LET prt_l[l_row].bal0=cl_numfor(sr.bal0,17,tm.e) 
	  LET prt_l[l_row].bal=cl_numfor(sr.bal1,17,tm.e)  
	  LET prt_l[l_row].per=per1 USING '----&.&& %'
       END IF
 
       CASE WHEN mbj.mbj03 = '9' 
		 IF mbj.mbj23[2,2]='2' THEN    
		    LET prt_r[r_row].mbj03='9'         
		 ELSE                          
		    LET prt_l[l_row].mbj03='9'         
		 END IF
	    WHEN mbj.mbj03 = '3' 
		 IF mbj.mbj23[2,2]='2' THEN  
		    LET r_row=r_row+1
		    LET prt_r[r_row].bal0='-----------------'     
		    LET prt_r[r_row].bal='-----------------'     
		    LET prt_r[r_row].per='----------'              
		 ELSE
		    LET l_row=l_row+1
		    LET prt_l[l_row].bal0='-----------------'     
		    LET prt_l[l_row].bal='-----------------'     
		    LET prt_l[l_row].per='----------'              
		 END IF
	    WHEN mbj.mbj03 = '4' 
		 IF mbj.mbj23[2,2]='2' THEN  
		    LET r_row=r_row+1
		    LET prt_r[r_row].mbj20='--------------------',
					   '-----'
		    LET prt_r[r_row].bal0='-----------------'     
		    LET prt_r[r_row].bal='-----------------'     
		    LET prt_r[r_row].per='----------'               
		 ELSE
		    LET l_row=l_row+1
		    LET prt_l[l_row].mbj20='--------------------',
					   '-----'
		    LET prt_l[l_row].bal0='-----------------'     
		    LET prt_l[l_row].bal='-----------------'     
		    LET prt_l[l_row].per='----------'               
		 END IF
       END CASE                      
     END FOREACH
     IF l_row>r_row THEN 
        LET l_last=l_row LET l_diff =r_row  
        FOR i = l_last TO 1 step -1
            IF prt_l[i].mbj20 IS NOT NULL AND prt_l[i].mbj20 <> ' ' THEN
               IF r_row = '0' THEN  
                 CALL cl_err('','ggl-002',1)     
                 RETURN        
               END IF         
               LET prt_r[i].* = prt_r[r_row].*
               INITIALIZE prt_r[l_diff].* TO NULL
               EXIT FOR
            END IF
        END FOR
     END IF
 
     IF l_row=r_row THEN 
        LET l_last=l_row LET l_diff =r_row  
        FOR i = l_last TO 1 step -1
            IF prt_l[i].mbj20 IS NOT NULL AND prt_l[i].mbj20 <> ' ' THEN
               IF r_row = '0' THEN      
                 CALL cl_err('','ggl-002',1)       
                 RETURN          
               END IF  
               LET prt_r[i].* = prt_r[r_row].*
               EXIT FOR
            END IF
        END FOR
     END IF
     IF r_row>l_row THEN 
        LET l_last=r_row LET l_diff =l_row
        FOR i = l_last TO 1 step -1
            IF prt_r[i].mbj20 IS NOT NULL AND prt_r[i].mbj20 <> ' ' THEN
               IF l_row = '0' THEN      
                 CALL cl_err('','ggl-002',1)      
                 RETURN     
               END IF      
               LET prt_l[i].* = prt_l[l_row].*
               INITIALIZE prt_l[l_diff].* TO NULL
               EXIT FOR
            END IF
        END FOR
     END IF
 
     FOR i=1 TO l_last
	 LET per1 = (prt_l[i].bal / g_basetot1) * 100
	 LET prt_l[i].per=per1 USING '----&.&& %'
	 LET per1 = (prt_r[i].bal / g_basetot1) * 100
	 LET prt_r[i].per=per1 USING '----&.&& %'
	 INSERT INTO tmp_file 
		VALUES(i,prt_l[i].mbj20,prt_l[i].mbj26,prt_l[i].bal0,prt_l[i].bal,  #No.MOD-980059
                       prt_l[i].per,prt_l[i].mbj03,
		       prt_r[i].mbj20,prt_r[i].mbj26,prt_r[i].bal0,prt_r[i].bal,
                       prt_r[i].per,prt_r[i].mbj03)   #No.FUN-570087 -add mbj26
     END FOR
 
     DECLARE q810_c1 CURSOR FOR SELECT * FROM tmp_file ORDER BY mbj02   #No.MOD-980059
     CALL g_aag.clear()
     LET l_i = 1   #MOD-840670
     FOREACH q810_c1 INTO l_n,tmp.*  #No.MOD-980059
        LET g_aag[l_i].aag01_l = tmp.mbj20_l  
        LET g_aag[l_i].line_l  = tmp.mbj26  
        LET g_aag[l_i].sum1_l  = tmp.bal_l0
        LET g_aag[l_i].sum2_l  = tmp.bal_l
        LET g_aag[l_i].aag01_r = tmp.mbj20_r  
        LET g_aag[l_i].line_r  = tmp.mbj26_r
        LET g_aag[l_i].sum1_r  = tmp.bal_r0
        LET g_aag[l_i].sum2_r  = tmp.bal_r
        LET l_i = l_i + 1   #MOD-840670
     END FOREACH
     LET g_rec_b = l_i - 1
 
END FUNCTION                                                                                                                        
 
FUNCTION q810_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY tm.a TO FORMONLY.mbj01
   DISPLAY g_mbi02 TO FORMONLY.mbi02
   DISPLAY tm.p TO FORMONLY.azi01
   DISPLAY tm.yy TO FORMONLY.yy
   DISPLAY tm.bm TO FORMONLY.mm
   DISPLAY tm.d  TO FORMONLY.unit
   
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
 
      ON ACTION output
         LET g_action_choice="output"
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
 
FUNCTION q810_out()
   DEFINE tmp RECORD
	      mbj20_l    LIKE type_file.chr1000,
              mbj26      LIKE type_file.num5,   
	      bal_l0     LIKE type_file.chr20,  
	      bal_l      LIKE type_file.chr20,  
	      per_l      LIKE type_file.chr20,  
	      mbj03_l    LIKE mbj_file.mbj03,   
	      mbj20_r    LIKE type_file.chr1000,
              mbj26_r    LIKE type_file.num5,   
	      bal_r0     LIKE type_file.chr20,  
	      bal_r      LIKE type_file.chr20,  
	      per_r      LIKE type_file.chr20,  
	      mbj03_r    LIKE mbj_file.mbj03    
	      END RECORD
   DEFINE l_i       LIKE type_file.num10   
 
   IF g_aag.getLength() = 0  THEN RETURN END IF
   ### *** 與 Crystal Reports 串聯段 - <<<<產生Temp Table >>>> CR11 *** ##
   LET g_sql="mbj02.mbj_file.mbj02,",    #項次（排序要用的）
             "mbj20_l.type_file.chr1000,",   
             "mbj26.type_file.num5,",    #行序
             "bal_l0.type_file.chr20,",  #年初數
             "bal_l.type_file.chr20,",   #期末數
             "per_l.type_file.chr20,",
             "mbj03_l.mbj_file.mbj03,",  #列印碼
             "mbj20_r.type_file.chr1000,",
             "mbj26_r.type_file.num5,",  #行序
             "bal_r0.type_file.chr20,",  #年初數
             "bal_r.type_file.chr20,",   #期末數
             "per_r.type_file.chr20,",
             "mbj03_r.mbj_file.mbj03"  #列印碼
 
   LET l_table = cl_prt_temptable('gglq810',g_sql)  CLIPPED   #產生Temp Table
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
   END IF 
   #-------------------------------- CR (1) ------------------------------------#
 
   ## *** 與 Crystal Reports  串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table) 
   #-------------------------------CR(2)----------------------------------#
 
   FOR l_i = 1 TO g_rec_b
        EXECUTE insert_prep USING 
           l_i,g_aag[l_i].aag01_l,g_aag[l_i].line_l,g_aag[l_i].sum1_l,
           g_aag[l_i].sum2_l,'','',
           g_aag[l_i].aag01_r,g_aag[l_i].line_r,g_aag[l_i].sum1_r,
           g_aag[l_i].sum2_r,'',''
   END FOR
 
     ## *** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET g_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     #報表名稱是否以報表結構名稱列印
     IF g_aaz.aaz77='N' THEN LET g_mbi02= '' END IF
     LET g_str = g_mbi02,';',tm.b,';',tm.a,';',tm.yy,';',tm.bm,';',tm.c,';',tm.d,';',tm.e,';',
                 tm.f,';',tm.h,';',tm.o,';',tm.r,';',tm.p,';',tm.q,';',tm.more
     CALL cl_prt_cs3('gglq810','gglq810',g_sql,g_str)
     #----------------------------- CR (4) --------------------------------------------------#
     
END FUNCTION                                                                                                                        
 
