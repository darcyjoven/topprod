# Prog. Version..: '5.30.06-13.03.29(00008)'     #
#
# Pattern name...: gglq811.4gl
# Descriptions...: 帳戶式資產負債表查詢化
# Date & Author..: 08/05/06 By Carrier  No.FUN-850030
# Modify.........: No.FUN-850030 08/07/24 By dxfwo 新增程序從21區移植到31區
# Modify.........: NO.MOD-950022 09/05/05 By wujie  增加對合計加減項的使用  
# Modify.........: NO.MOD-950053 09/05/07 By wujie  抓取的邏輯按gglq812修改 
# Modify.........: No.MOD-980059 09/08/10 By Carrier show的資料隨機問題處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0086 09/12/18 By wujie  報表結構開窗只選資產負債表
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
# Modify.........: No:TQC-A70062 10/07/15 By Sam 合计错误
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B30210 11/04/02 By yinhy 增加條件選項“是否包含審計調整”，如果選是並且bm等於12時,則在生成報表時,
#                                                  將憑證來源碼為AD的資料加入到報表中
# Modify.........: No:MOD-CA0146 12/10/22 By wujie 金额正负有错 
# Modify.........: No.FUN-CA0097 12/10/22 By zhangweib 當agli116金額來源選則a、b、c、d時,資產負債表金額取值方式改取npr_file OR aeh_file
# Modify.........: No.FUN-C80102 12/09/13 By zhangweib 報表改善追單
# Modify.........: No.TQC-D10110 13/02/01 By zhangweib 單身金額根據單頭小數位數取位、截位
 
DATABASE ds  #No.FUN-850030
 
GLOBALS "../../config/top.global"
 
   DEFINE tm         RECORD
	             a     LIKE mai_file.mai01,  #報表結構編號
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
	  i,j,k,l_n  LIKE type_file.num5,        #FUN-C80102  add  l_n
	  g_unit     LIKE type_file.num10,       #金額單位基數   
	  l_row      LIKE type_file.num5, 
	  r_row      LIKE type_file.num5, 
	  g_bookno   LIKE aah_file.aah00,        #帳別
	  g_mai02    LIKE mai_file.mai02,
	  g_mai03    LIKE mai_file.mai03,
	  g_tot1     ARRAY[100] OF LIKE type_file.num20_6,
	  g_tot0     ARRAY[100] OF LIKE type_file.num20_6,
	  g_basetot1 LIKE type_file.num20_6
 
DEFINE   g_aaa03     LIKE aaa_file.aaa03   
DEFINE   g_i         LIKE type_file.num5 
DEFINE   g_rec_b     LIKE type_file.num5
DEFINE   l_ac        LIKE type_file.num5
DEFINE   g_aag       DYNAMIC ARRAY OF RECORD 
                     aag01_l    LIKE maj_file.maj20,
                     line_l     LIKE maj_file.maj26,
                    #sum1_l     LIKE aah_file.aah04,    #No.TQC-D10110   Mark
                    #sum2_l     LIKE aah_file.aah05,    #No.TQC-D10110   Mark
                     sum1_l     LIKE type_file.chr20,   #No.TQC-D10110   Add
                     sum2_l     LIKE type_file.chr20,   #No.TQC-D10110   Add
                     aag01_r    LIKE maj_file.maj20,
                     line_r     LIKE maj_file.maj26,
                    #sum1_r     LIKE aah_file.aah04,    #No.TQC-D10110   Mark
                    #sum2_r     LIKE aah_file.aah05     #No.TQC-D10110   Mark
                     sum1_r     LIKE type_file.chr20,   #No.TQC-D10110   Add
                     sum2_r     LIKE type_file.chr20    #No.TQC-D10110   Add
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
 
   OPEN WINDOW q811_w AT 5,10
        WITH FORM "ggl/42f/gglq811" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           

   #FUN-C80102--mark--str--
   #IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
   #   CALL q811_tm()                          # Input print condition
   #ELSE
   #   CALL q811()                             # Read data and create out-file
   #END IF
   #FUN-C80102--mark--end-- 

   CALL q811_tm()   #FUN-C80102
   
   CALL q811_menu()                                                            
   CLOSE WINDOW q811_w 
   CALL cl_used(g_prog,g_time,2)
        RETURNING g_time
 
END MAIN
 
FUNCTION q811_menu()
   WHILE TRUE
      CALL q811_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q811_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q811_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
                   #modified by leizj 130715 改用excel8函数 -begin
  #            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
              CALL cl_export_to_excel8(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','',tm.b,tm.a,tm.d,tm.yy,tm.bm)
                     #modified by leizj 130715 改用excel8函数 -begin
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q811_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5    
   DEFINE p_row,p_col    LIKE type_file.num5,   
	  l_sw           LIKE type_file.chr1,   
	  l_cmd          LIKE type_file.chr1000 
   DEFINE li_result      LIKE type_file.num5  
   DEFINE l_mai01    LIKE mai_file.mai01       #FUN-C80102  add
   DEFINE l_yy       LIKE type_file.num5       #FUN-C80102  add
   DEFINE l_bm       LIKE type_file.num5       #FUN-C80102  add
 
   CALL s_dsmark(tm.b)

   CLEAR FORM #清除畫面  #FUN-C80102  add
   CALL g_aag.clear()  #FUN-C80102  add

   #FUN-C80102--mark--str---
   #LET p_row = 2 LET p_col = 20
 
   #OPEN WINDOW q811_w1 AT p_row,p_col WITH FORM "ggl/42f/gglr111" 
   #     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   #FUN-C80102--mark--end---
    
    CALL cl_ui_init()
 
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
   #FUN-C80102--add--str--
   SELECT aaa04,aaa05 INTO tm.yy,tm.bm FROM aaa_file WHERE aaa01 = tm.b
   IF tm.bm = '1' THEN
      LET tm.yy = tm.yy - 1
      LET tm.bm = '12'
   ELSE
      LET tm.bm = tm.bm - 1
   END IF
   #FUN-C80102--add--end--
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
   #FUN-C80102--add--str--
   SELECT COUNT(*) INTO l_n FROM mai_file WHERE mai00 = tm.b AND mai03 ='2' AND maiacti='Y'
   IF l_n >= '1' THEN 
      LET g_sql = " SELECT mai01 FROM mai_file WHERE  mai03 ='2' AND maiacti='Y' AND mai00 ='",tm.b,"'",
                  " ORDER BY mai01 " 
      PREPARE gglq811_ps FROM g_sql
      DECLARE gglq811_curs SCROLL CURSOR WITH HOLD FOR gglq811_ps
      OPEN gglq811_curs
      FETCH FIRST gglq811_curs INTO l_mai01
      LET tm.a = l_mai01
   END IF
   #FUN-C80102--add--end--
WHILE TRUE
    LET l_row=0
    LET r_row=0
    LET l_sw = 1
    INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,
		  #tm.c,tm.d,tm.e,tm.f,tm.h,tm.o,tm.r,        #FUN-C80102   mark
		  #tm.p,tm.q,tm.g,tm.more WITHOUT DEFAULTS   #No.TQC-B30210 add tm.g   #FUN-C80102 mark
          tm.e,tm.f,tm.d,tm.o,tm.r,tm.q,tm.p,tm.c,    #FUN-C80102  add
          tm.g,tm.h WITHOUT DEFAULTS                  #FUN-C80102  add  
    
       BEFORE INPUT
          CALL cl_qbe_init()
 
       ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
          EXIT INPUT
 
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
             #FUN-C80102--add-str--
             SELECT aaa04,aaa05 INTO l_yy,l_bm FROM aaa_file WHERE aaa01 = tm.b    
             IF l_bm = '1' THEN
                LET l_yy = l_yy - 1
                LET l_bm = '12'
             ELSE
                LET l_bm = l_bm - 1
             END IF
             DISPLAY l_yy,l_bm TO yy,bm       
             SELECT COUNT(*) INTO l_n FROM mai_file WHERE mai00 = tm.b AND mai03 ='2' AND maiacti='Y'
             IF l_n >= '1' THEN
                LET g_sql = " SELECT mai01 FROM mai_file WHERE  mai03 ='2' AND maiacti='Y' AND mai00 ='",tm.b,"'",
                            " ORDER BY mai01 "
                PREPARE gglq811_ps_1 FROM g_sql
                DECLARE gglq811_curs_1 SCROLL CURSOR WITH HOLD FOR gglq811_ps_1
                OPEN gglq811_curs_1
                FETCH FIRST gglq811_curs INTO l_mai01
                DISPLAY l_mai01 TO a
             END IF
             #FUN-C80102--add-end--
          END IF
 
       AFTER FIELD c
          IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
       AFTER FIELD yy
          IF tm.yy IS NULL OR tm.yy = 0 THEN
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
 
       AFTER FIELD o   
          IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
          IF tm.o = 'N' THEN 
             LET tm.p = g_aaa03 
             LET tm.q = 1
             DISPLAY g_aaa03 TO p
             DISPLAY BY NAME tm.q
             CALL cl_set_comp_entry("p,q",FALSE)             
             NEXT FIELD c
          ELSE
             CALL cl_set_comp_entry("p,q",TRUE)     
          END IF
     
       #FUN-C80102--mark--str--
       #BEFORE FIELD p
       #   IF tm.o = 'N' THEN NEXT FIELD d END IF  
       #FUN-C80102--mark--end--
 
       AFTER FIELD p
	  SELECT azi01 FROM azi_file WHERE azi01 = tm.p
	  IF SQLCA.sqlcode THEN 
	     CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)
	     NEXT FIELD p 
	  END IF
       #No.TQC-B30210  --Begin
       AFTER FIELD g
          IF tm.g IS NULL OR tm.g NOT MATCHES "[YN]" THEN NEXT FIELD g END IF
       #No.TQC-B30210  --End
       #FUN-C80102--mark--str--
       #BEFORE FIELD q
       #   IF tm.o = 'N' THEN NEXT FIELD o END IF

       #AFTER FIELD more
       #   IF tm.more = 'Y'
       #      THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
       #  			g_bgjob,g_time,g_prtway,g_copies)
       #  	      RETURNING g_pdate,g_towhom,g_rlang,
       #  			g_bgjob,g_time,g_prtway,g_copies
       #   END IF
       #FUN-C80102--mark--end--  
 
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
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION CONTROLP
	 CASE
            WHEN INFIELD(a) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
#              LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740032
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 ='2' "  #No.MOD-9C0086
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
#     LET INT_FLAG = 0 CLOSE WINDOW q811_w1 EXIT PROGRAM
      LET INT_FLAG = 0 CLOSE WINDOW q811_w1 RETURN         #No.FUN-A40009
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
	     WHERE zz01='gglq811'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
   	 CALL cl_err('gglq811','9031',1)   
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
	 CALL cl_cmdat('gglq811',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW q811_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL q811()
   ERROR ""
   EXIT WHILE
END WHILE
   #CLOSE WINDOW q811_w1  #FUN-C80102  mark
END FUNCTION
 
FUNCTION q811()
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
   DEFINE l_i       LIKE maj_file.maj02    
   DEFINE sr  RECORD
	      bal0      LIKE type_file.num20_6,  # 期初數
	      bal1      LIKE type_file.num20_6 
	      END RECORD
   DEFINE prt_l DYNAMIC ARRAY OF RECORD         #--- 陣列 for 資產類 (左)
		maj20    LIKE type_file.chr1000,
                maj26    LIKE type_file.num5,   
		bal0     LIKE type_file.chr20,  
		bal      LIKE type_file.chr20,  
		per      LIKE type_file.chr20,  
		maj03    LIKE maj_file.maj03    
		END RECORD
   DEFINE prt_r DYNAMIC ARRAY OF RECORD         #--- 陣列 for 負債&業主權益類 (右)
		maj20    LIKE type_file.chr1000,
                maj26    LIKE type_file.num5,   
		bal0     LIKE type_file.chr20,  
		bal      LIKE type_file.chr20,  
		per      LIKE type_file.chr20,  
		maj03    LIKE maj_file.maj03    
		END RECORD
   DEFINE tmp RECORD
	      maj20_l    LIKE type_file.chr1000,
              maj26      LIKE type_file.num5,   
	      bal_l0     LIKE type_file.chr20,  
	      bal_l      LIKE type_file.chr20,  
	      per_l      LIKE type_file.chr20,  
	      maj03_l    LIKE maj_file.maj03,   
	      maj20_r    LIKE type_file.chr1000,
              maj26_r    LIKE type_file.num5,   
	      bal_r0     LIKE type_file.chr20,  
	      bal_r      LIKE type_file.chr20,  
	      per_r      LIKE type_file.chr20,  
	      maj03_r    LIKE maj_file.maj03    
	      END RECORD
DEFINE l_sw      LIKE type_file.num5  #No.MOD-950053 add 
DEFINE l_n       LIKE type_file.num5  #No.MOD-980059
DEFINE l_ad1     LIKE abb_file.abb07             #No.TQC-B30210
DEFINE l_ad2     LIKE abb_file.abb07             #No.TQC-B30210 
#No.TQC-D10110 ---start--- Add
DEFINE l_sum1_l  LIKE type_file.num20_6
DEFINE l_sum1_r  LIKE type_file.num20_6
DEFINE l_sum2_l  LIKE type_file.num20_6
DEFINE l_sum2_r  LIKE type_file.num20_6
#No.TQC-D10110 ---end  --- Add

   DROP TABLE tmp_file                                                                                                              
   CREATE TEMP TABLE tmp_file(                                                                                                       
     maj02      LIKE type_file.num5,  #No.MOD-980059
     maj20_l    LIKE type_file.chr1000,                                                
     maj26      LIKE type_file.num5,                                 
     bal_l0     LIKE type_file.chr20,                                           
     bal_l      LIKE type_file.chr20,                                                    
     per_l      LIKE cre_file.cre08,                                                        
     maj03_l    LIKE maj_file.maj03,                                                         
     maj20_r    LIKE type_file.chr1000,                                                  
     maj26_r    LIKE type_file.num5,                                     
     bal_r0     LIKE type_file.chr20,                                                    
     bal_r      LIKE type_file.chr20,                                           
     per_r      LIKE cre_file.cre08,                                                   
     maj03_r    LIKE maj_file.maj03)                                                                                                                  
     
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
	    AND aaf02 = g_rlang
 
     LET l_sql = "SELECT * FROM maj_file ",
		 " WHERE maj01 = '",tm.a,"' ",
		 "   AND maj23[1,1]='1' ",
		 " ORDER BY maj02"
     PREPARE q811_p FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE q811_c CURSOR FOR q811_p
 
     FOR g_i = 1 TO 100 LET g_tot0[g_i]=0  LET g_tot1[g_i] = 0 END FOR
 
     FOREACH q811_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       FOR i = 1 TO maj.maj04
	   IF maj.maj23[2,2]='2' THEN  
              LET r_row=r_row+1
	   ELSE
	      LET l_row=l_row+1
	   END IF
       END FOR
       LET amt0 = 0  #no.A048
       LET amt1 = 0
       IF NOT cl_null(maj.maj21) THEN
      #NO.FUN-CA0097   ---start--- Add
          #IF  maj.maj06 = 'a' OR maj.maj06 = 'b' OR maj.maj06 = 'c' OR maj.maj06 = 'd' THEN  #FUN-C80102 mark
          IF  maj.maj06 = 'a' OR maj.maj06 = 'b' OR maj.maj06 = 'c' OR maj.maj06 = 'd' OR maj.maj06='8' OR maj.maj06='9'THEN  #FUN-C80120 add
              IF maj.maj24 IS NULL THEN
                 IF maj.maj06 = 'a' THEN
#FUN-C80102--mod--str----
                    SELECT SUM(snpr06-snpr07) INTO amt1 
                      FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
                              FROM npr_file,aag_file 
                             WHERE aag01 = npr00 AND aag07 IN ('2','3')
                               AND aag00 = npr09
                               AND npr00 BETWEEN maj.maj21 AND maj.maj22
                               AND npr04 = tm.yy AND npr05 <= tm.bm 
                             GROUP BY npr00,npr01 
                            HAVING SUM(npr06)-SUM(npr07)>0 )
#
#                   SELECT SUM(snpr06-snpr07) INTO amt0 
#                     FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
#                             FROM npr_file,aag_file 
#                            WHERE aag01 = npr00 AND aag07 IN ('2','3')
#                              AND aag00 = npr09
#                              AND npr00 BETWEEN maj.maj21 AND maj.maj22
#                              AND npr04 = tm.yy AND npr05 = 0 
#                            GROUP BY npr00,npr01 
#                           HAVING SUM(npr06)-SUM(npr07)>0 )
#                   SELECT SUM(snpr06-snpr07) INTO amt1 
#                     FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
#                             FROM npr_file,aag_file 
#                            WHERE aag01 = npr00 AND aag07 IN ('2','3')
#                              AND aag00 = npr09
#                              AND npr00 BETWEEN maj.maj21 AND maj.maj22
#                              AND npr04 = tm.yy AND npr05 <= tm.bm 
#                            GROUP BY npr00,npr01 
#                           HAVING SUM(npr06)-SUM(npr07)>0 )
#
#FUN-C80102--mod--end
                 END IF
                 IF maj.maj06 = 'b' THEN
#FUN-C80102--mod--str----
                    SELECT SUM(snpr07-snpr06) INTO amt1 
                      FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
                              FROM npr_file,aag_file 
                             WHERE aag01 = npr00 AND aag07 IN ('2','3')
                               AND aag00 = npr09
                               AND npr00 BETWEEN maj.maj21 AND maj.maj22
                               AND npr04 = tm.yy AND npr05 <= tm.bm 
                             GROUP BY npr00,npr01 
                            HAVING SUM(npr07)-SUM(npr06)>0 )
#
#                   SELECT SUM(snpr07-snpr06) INTO amt0 
#                     FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
#                             FROM npr_file,aag_file 
#                            WHERE aag01 = npr00 AND aag07 IN ('2','3')
#                              AND aag00 = npr09
#                              AND npr00 BETWEEN maj.maj21 AND maj.maj22
#                              AND npr04 = tm.yy AND npr05 = 0 
#                            GROUP BY npr00,npr01 
#                           HAVING SUM(npr07)-SUM(npr06)>0 )
#                   SELECT SUM(snpr07-snpr06) INTO amt1 
#                     FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
#                             FROM npr_file,aag_file 
#                            WHERE aag01 = npr00 AND aag07 IN ('2','3')
#                              AND aag00 = npr09
#                              AND npr00 BETWEEN maj.maj21 AND maj.maj22
#                              AND npr04 = tm.yy AND npr05 <= tm.bm 
#                            GROUP BY npr00,npr01 
#                           HAVING SUM(npr07)-SUM(npr06)>0 )
#
#FUN-C80102--mod--end
                 END IF
#FUN-C80102--mod--str----
#
#                IF maj.maj06 = 'c' THEN
#                   SELECT SUM(aeh11-aeh12) INTO amt0
#                     FROM (SELECT aeh01,aeh02,aeh11 ,aeh12
#                             FROM aeh_file,aag_file
#                            WHERE aag01 = aeh01 AND aag07 IN ('2','3')
#                              AND aeh00 = aag00 AND aeh00 = tm.b
#                              AND aeh01 BETWEEN maj.maj21 AND maj.maj22
#                              AND aeh09 = tm.yy AND aeh10 = 0
#                              AND aeh11-aeh12>0 )
#                   SELECT SUM(aeh11-aeh12) INTO amt1
#                     FROM (SELECT aeh01,aeh02,aeh11 ,aeh12
#                             FROM aeh_file,aag_file
#                            WHERE aag01 = aeh01 AND aag07 IN ('2','3')
#                              AND aeh00 = aag00 AND aeh00 = tm.b
#                              AND aeh01 BETWEEN maj.maj21 AND maj.maj22
#                              AND aeh09 = tm.yy AND aeh10 <=tm.bm
#                              AND aeh11-aeh12>0 )
#                END IF
#                IF maj.maj06 = 'd' THEN
#                   SELECT SUM(aeh12-aeh11) INTO amt0
#                     FROM (SELECT aeh01,aeh02,aeh11,aeh12
#                             FROM aeh_file,aag_file
#                            WHERE aag01 = aeh01 AND aag07 IN ('2','3')
#                              AND aeh00 = aag00 AND aeh00 = tm.b
#                              AND aeh01 BETWEEN maj.maj21 AND maj.maj22
#                              AND aeh09 = tm.yy AND aeh10 = 0
#                              AND aeh12-aeh11>0 )
#                   SELECT SUM(aeh12-aeh11) INTO amt1 
#                     FROM (SELECT aeh01,aeh02,aeh11,aeh12
#                             FROM aeh_file,aag_file
#                            WHERE aag01 = aeh01 AND aag07 IN ('2','3')
#                              AND aeh00 = aag00 AND aeh00 = tm.b
#                              AND aeh01 BETWEEN maj.maj21 AND maj.maj22
#                              AND aeh09 = tm.yy AND aeh10 <=tm.bm
#                              AND aeh12-aeh11>0 )
#                END IF
#
                 IF maj.maj06 = 'c' THEN
                    SELECT SUM(saeh11-saeh12) INTO amt1
                      FROM (SELECT aeh01,aeh04,aeh05,SUM(aeh11) saeh11 ,SUM(aeh12) saeh12
                              FROM aeh_file,aag_file
                             WHERE aag01 = aeh01 AND aag07 IN ('2','3')
                               AND aeh00 = aag00 AND aeh00 = tm.b
                               AND aeh01 BETWEEN maj.maj21 AND maj.maj22
                               AND aeh09 = tm.yy AND aeh10 <=tm.bm
                             GROUP BY aeh01,aeh04,aeh05
                            HAVING SUM(aeh11)-SUM(aeh12)>0 )
                 END IF
                 IF maj.maj06 = 'd' THEN
                    SELECT SUM(saeh12-saeh11) INTO amt1
                      FROM (SELECT aeh01,aeh04,aeh05,SUM(aeh11) saeh11 ,SUM(aeh12) saeh12
                              FROM aeh_file,aag_file
                             WHERE aag01 = aeh01 AND aag07 IN ('2','3')
                               AND aeh00 = aag00 AND aeh00 = tm.b
                               AND aeh01 BETWEEN maj.maj21 AND maj.maj22
                               AND aeh09 = tm.yy AND aeh10 <=tm.bm
                             GROUP BY aeh01,aeh04,aeh05
                            HAVING SUM(aeh12)-SUM(aeh11)>0 )
                 END IF
#FUN-C80102--mod--end
                 IF maj.maj06 = '8' THEN
#FUN-C80102--mod--str----
                    SELECT SUM(saah04-saah05) INTO amt1 
                      FROM (SELECT aah00,aah01,SUM(aah04) saah04 ,SUM(aah05) saah05 
                              FROM aah_file,aag_file 
                             WHERE aah00 = tm.b AND aag07 IN ('2','3')
                               AND aag00 = aah00
                               AND aag01 = aah01
                               AND aah01 BETWEEN maj.maj21 AND maj.maj22
                               AND aah02 = tm.yy AND aah03 <= tm.bm 
                             GROUP BY aah00,aah01 
                            HAVING SUM(aah04)-SUM(aah05)>0 )   
 #remark by maoyy20210721
                   SELECT SUM(aah04-aah05) INTO amt0 
                     FROM aah_file,aag_file
                    WHERE aah00 = tm.b
                      AND aah00 = aag00 
                      AND aah01 BETWEEN maj.maj21 AND maj.maj22
                      AND aah02 = tm.yy AND aah03 =0
                      AND aah01 = aag01 AND aag07 IN ('2','3')
                      AND aah04-aah05>0
#                   SELECT SUM(aah04-aah05) INTO amt1 
#                     FROM aah_file,aag_file
#                    WHERE aah00 = tm.b
#                      AND aah00 = aag00
#                      AND aah01 BETWEEN maj.maj21 AND maj.maj22
#                      AND aah02 = tm.yy AND aah03 <= tm.bm
#                      AND aah01 = aag01 AND aag07 IN ('2','3')
#                      AND aah04-aah05>0
#
#FUN-C80102--mod--end
                  END IF
                  IF maj.maj06 = '9' THEN
#FUN-C80102--mod--str----
                    SELECT SUM(saah05-saah04) INTO amt1 
                      FROM (SELECT aah00,aah01,SUM(aah05) saah05 ,SUM(aah04) saah04 
                              FROM aah_file,aag_file 
                             WHERE aah00 = tm.b AND aag07 IN ('2','3')
                               AND aag00 = aah00
                               AND aag01 = aah01
                               AND aah01 BETWEEN maj.maj21 AND maj.maj22
                               AND aah02 = tm.yy AND aah03 <= tm.bm 
                             GROUP BY aah00,aah01 
                            HAVING SUM(aah05)-SUM(aah04)>0 )        
#
#                   SELECT SUM(aah05-aah04) INTO amt1 
#                     FROM aah_file,aag_file
#                    WHERE aah00 = tm.b
#                      AND aah00 = aag00 
#                      AND aah01 BETWEEN maj.maj21 AND maj.maj22
#                      AND aah02 = tm.yy AND aah03 =0
#                      AND aah01 = aag01 AND aag07 IN ('2','3')
#                      AND aah05-aah04>0
#                   SELECT SUM(aah05-aah04) INTO amt1 
#                     FROM aah_file,aag_file
#                    WHERE aah00 = tm.b
#                      AND aah00 = aag00
#                      AND aah01 BETWEEN maj.maj21 AND maj.maj22
#                      AND aah02 = tm.yy AND aah03 <= tm.bm
#                      AND aah01 = aag01 AND aag07 IN ('2','3')
#                      AND aah05-aah04>0
#
                  END IF
#FUN-C80102--mod--end
              ELSE
                 IF maj.maj06 = 'a' THEN
#FUN-C80102--mod--str
                    SELECT SUM(snpr06-snpr07) INTO amt1 
                      FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
                              FROM npr_file,aag_file 
                             WHERE aag01 = npr00 AND aag07 IN ('2','3')
                               AND aag00 = npr09
                               AND npr00 BETWEEN maj.maj21 AND maj.maj22
                               AND npr04 = tm.yy AND npr05 <= tm.bm 
                             GROUP BY npr00,npr01 
                            HAVING SUM(npr06)-SUM(npr07)>0 )
#
#                   SELECT SUM(snpr06-snpr07) INTO amt0 
#                     FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
#                             FROM npr_file,aag_file 
#                            WHERE aag01 = npr00 AND aag07 IN ('2','3')
#                              AND aag00 = npr09
#                              AND npr00 BETWEEN maj.maj21 AND maj.maj22
#                              AND npr03 BETWEEN maj.maj24 AND maj.maj25
#                              AND npr04 = tm.yy AND npr05 = 0 
#                            GROUP BY npr00,npr01 
#                           HAVING SUM(npr06)-SUM(npr07)>0 )
#                   SELECT SUM(snpr06-snpr07) INTO amt1 
#                     FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
#                             FROM npr_file,aag_file 
#                            WHERE aag01 = npr00 AND aag07 IN ('2','3')
#                              AND aag00 = npr09
#                              AND npr00 BETWEEN maj.maj21 AND maj.maj22
#                              AND npr03 BETWEEN maj.maj24 AND maj.maj25
#                              AND npr04 = tm.yy AND npr05 <= tm.bm 
#                            GROUP BY npr00,npr01 
#                           HAVING SUM(npr06)-SUM(npr07)>0 )
#
#FUN-C80102--mod--end
                 END IF
                 IF maj.maj06 = 'b' THEN
#FUN-C80102--mod--str--
                    SELECT SUM(snpr07-snpr06) INTO amt1 
                      FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
                              FROM npr_file,aag_file 
                             WHERE aag01 = npr00 AND aag07 IN ('2','3')
                               AND aag00 = npr09
                               AND npr00 BETWEEN maj.maj21 AND maj.maj22
                               AND npr04 = tm.yy AND npr05 <= tm.bm 
                             GROUP BY npr00,npr01 
                            HAVING SUM(npr07)-SUM(npr06)>0 )
#
#                   SELECT SUM(snpr07-snpr06) INTO amt0 
#                     FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
#                             FROM npr_file,aag_file 
#                            WHERE aag01 = npr00 AND aag07 IN ('2','3')
#                              AND aag00 = npr09
#                              AND npr00 BETWEEN maj.maj21 AND maj.maj22
#                              AND npr03 BETWEEN maj.maj24 AND maj.maj25
#                              AND npr04 = tm.yy AND npr05 = 0 
#                            GROUP BY npr00,npr01 
#                           HAVING SUM(npr07)-SUM(npr06)>0 )
#                   SELECT SUM(snpr07-snpr06) INTO amt1 
#                     FROM (SELECT npr00,npr01,SUM(npr06) snpr06 ,SUM(npr07) snpr07 
#                             FROM npr_file,aag_file 
#                            WHERE aag01 = npr00 AND aag07 IN ('2','3')
#                              AND aag00 = npr09
#                              AND npr00 BETWEEN maj.maj21 AND maj.maj22
#                              AND npr03 BETWEEN maj.maj24 AND maj.maj25
#                              AND npr04 = tm.yy AND npr05 <= tm.bm 
#                            GROUP BY npr00,npr01 
#                           HAVING SUM(npr07)-SUM(npr06)>0 )
#
#FUN-C80102--mod--end
                 END IF
#FUN-C80102--mod--str
#                 
#                IF maj.maj06 = 'c' THEN
#                   SELECT SUM(aeh11-aeh12) INTO amt0
#                     FROM (SELECT aeh01,aeh02,aeh11 ,aeh12
#                             FROM aeh_file,aag_file
#                            WHERE aag01 = aeh01 AND aag07 IN ('2','3')
#                              AND aeh00 = aag00 AND aeh00 = tm.b
#                              AND aeh01 BETWEEN maj.maj21 AND maj.maj22
#                              AND aeh02 BETWEEN maj.maj24 AND maj.maj25
#                              AND aeh09 = tm.yy AND aeh10 = 0
#                              AND aeh11-aeh12>0 )
#                   SELECT SUM(aeh11-aeh12) INTO amt1  
#                     FROM (SELECT aeh01,aeh02,aeh11 ,aeh12
#                             FROM aeh_file,aag_file
#                            WHERE aag01 = aeh01 AND aag07 IN ('2','3')
#                              AND aeh00 = aag00 AND aeh00 = tm.b
#                              AND aeh01 BETWEEN maj.maj21 AND maj.maj22
#                              AND aeh02 BETWEEN maj.maj24 AND maj.maj25
#                              AND aeh09 = tm.yy AND aeh10 <=tm.bm
#                              AND aeh11-aeh12>0 )
#                END IF
#                IF maj.maj06 = 'd' THEN
#                   SELECT SUM(aeh12-aeh11) INTO amt0
#                     FROM (SELECT aeh01,aeh02,aeh11,aeh12
#                             FROM aeh_file,aag_file
#                            WHERE aag01 = aeh01 AND aag07 IN ('2','3')
#                              AND aeh00 = aag00 AND aeh00 = tm.b
#                              AND aeh01 BETWEEN maj.maj21 AND maj.maj22
#                              AND aeh02 BETWEEN maj.maj24 AND maj.maj25
#                              AND aeh09 = tm.yy AND aeh10 = 0
#                              AND aeh12-aeh11>0 )
#                   SELECT SUM(aeh12-aeh11) INTO amt1 
#                     FROM (SELECT aeh01,aeh02,aeh11,aeh12
#                             FROM aeh_file,aag_file
#                            WHERE aag01 = aeh01 AND aag07 IN ('2','3')
#                              AND aeh00 = aag00 AND aeh00 = tm.b
#                              AND aeh01 BETWEEN maj.maj21 AND maj.maj22
#                              AND aeh02 BETWEEN maj.maj24 AND maj.maj25
#                              AND aeh09 = tm.yy AND aeh10 <=tm.bm
#                              AND aeh12-aeh11>0 )
#                END IF
#                }
                 IF maj.maj06 = 'c' THEN
                   SELECT SUM(saeh11-saeh12) INTO amt1
                      FROM (SELECT aeh01,aeh04,aeh05,SUM(aeh11) saeh11 ,SUM(aeh12) saeh12
                              FROM aeh_file,aag_file
                             WHERE aag01 = aeh01 AND aag07 IN ('2','3')
                               AND aeh00 = aag00 AND aeh00 = tm.b
                               AND aeh01 BETWEEN maj.maj21 AND maj.maj22
                               AND aeh02 BETWEEN maj.maj24 AND maj.maj25
                               AND aeh09 = tm.yy AND aeh10 <=tm.bm
                             GROUP BY aeh01,aeh04,aeh05
                            HAVING SUM(aeh11)-SUM(aeh12)>0 )
                 END IF
                 IF maj.maj06 = 'd' THEN
                    SELECT SUM(saeh12-saeh11) INTO amt1
                      FROM (SELECT aeh01,aeh04,aeh05,SUM(aeh11) saeh11 ,SUM(aeh12) saeh12
                              FROM aeh_file,aag_file
                             WHERE aag01 = aeh01 AND aag07 IN ('2','3')
                               AND aeh00 = aag00 AND aeh00 = tm.b
                               AND aeh01 BETWEEN maj.maj21 AND maj.maj22
                               AND aeh02 BETWEEN maj.maj24 AND maj.maj25
                               AND aeh09 = tm.yy AND aeh10 <=tm.bm
                             GROUP BY aeh01,aeh04,aeh05
                            HAVING SUM(aeh12)-SUM(aeh11)>0 )
                 END IF
                 IF maj.maj06='8' THEN
	           SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
		    WHERE aao00 = tm.b
                      AND aao00 = aag00
		      AND aao01 BETWEEN maj.maj21 AND maj.maj22
		      AND aao02 BETWEEN maj.maj24 AND maj.maj25
		      AND aao03 = tm.yy AND aao04 <= tm.bm
		      AND aao01 = aag01 AND aag07 IN ('2','3')
                      AND aao05>aao06
                END IF
                IF maj.maj06 = '9' THEN
	           SELECT SUM(aao06-aao05) INTO amt1 FROM aao_file,aag_file
		    WHERE aao00 = tm.b
                      AND aao00 = aag00
		      AND aao01 BETWEEN maj.maj21 AND maj.maj22
		      AND aao02 BETWEEN maj.maj24 AND maj.maj25
		      AND aao03 = tm.yy AND aao04 <= tm.bm
		      AND aao01 = aag01 AND aag07 IN ('2','3')
                      AND aao06>aao05
                END IF
#                {
#                IF maj.maj06='8' THEN
#                   SELECT SUM(aao05-aao06) INTO amt0 FROM aao_file,aag_file
#                    WHERE aao00 = tm.b
#                      AND aao00 = aag00
#                      AND aao01 BETWEEN maj.maj21 AND maj.maj22
#                      AND aao02 BETWEEN maj.maj24 AND maj.maj25
#                      AND aao03 = tm.yy AND aao04 =0
#                      AND aao01 = aag01 AND aag07 IN ('2','3')
#                      AND aao05>aao06
#                   SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
#                    WHERE aao00 = tm.b
#                      AND aao00 = aag00
#                      AND aao01 BETWEEN maj.maj21 AND maj.maj22
#                      AND aao02 BETWEEN maj.maj24 AND maj.maj25
#                      AND aao03 = tm.yy AND aao04 <= tm.bm
#                      AND aao01 = aag01 AND aag07 IN ('2','3')
#                      AND aao05>aao06
#               END IF
#               IF maj.maj06 = '9' THEN
#                   SELECT SUM(aao06-aao05) INTO amt0 FROM aao_file,aag_file
#                    WHERE aao00 = tm.b
#                      AND aao00 = aag00
#                      AND aao01 BETWEEN maj.maj21 AND maj.maj22
#                      AND aao02 BETWEEN maj.maj24 AND maj.maj25
#                      AND aao03 = tm.yy AND aao04 =0
#                      AND aao01 = aag01 AND aag07 IN ('2','3')
#                      AND aao06>aao05
#                   SELECT SUM(aao06-aao05) INTO amt1 FROM aao_file,aag_file
#                    WHERE aao00 = tm.b
#                      AND aao00 = aag00
#                      AND aao01 BETWEEN maj.maj21 AND maj.maj22
#                      AND aao02 BETWEEN maj.maj24 AND maj.maj25
#                      AND aao03 = tm.yy AND aao04 <= tm.bm
#                      AND aao01 = aag01 AND aag07 IN ('2','3')
#                      AND aao06>aao05
#               END IF
#               }
#FUN-C80102--mod--str
             END IF
          ELSE 
      #NO.FUN-CA0097   ---end  --- Add
	  IF maj.maj24 IS NULL THEN
	     SELECT SUM(aah04-aah05) INTO amt0 FROM aah_file,aag_file
		WHERE aah00 = tm.b
                  AND aah00 = aag00 
		  AND aah01 BETWEEN maj.maj21 AND maj.maj22
		  AND aah02 = tm.yy AND aah03 =0
		  AND aah01 = aag01 AND aag07 IN ('2','3')
	     SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
		WHERE aah00 = tm.b
                  AND aah00 = aag00
		  AND aah01 BETWEEN maj.maj21 AND maj.maj22
		  AND aah02 = tm.yy AND aah03 <= tm.bm
		  AND aah01 = aag01 AND aag07 IN ('2','3')
		  #No.TQC-B30210 --Begin #是否包含審計調整
      IF tm.g = 'Y' THEN
         IF tm.bm = 12 THEN
            LET l_ad1 = 0 
            LET l_ad2 = 0                       
            SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
             WHERE abb00 = tm.b
               AND aba00 = abb00 AND aba01 = abb01
               AND abb03 BETWEEN maj.maj21 AND maj.maj22
               AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy+1
               AND aba04 = 0 AND abapost = 'Y'
            SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
             WHERE abb00 = tm.b
               AND aba00 = abb00 AND aba01 = abb01
               AND abb03 BETWEEN maj.maj21 AND maj.maj22
               AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy+1
               AND aba04 = 0 AND abapost = 'Y'
            IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
            IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF 
            LET amt1 = amt1 + l_ad1 - l_ad2
          END IF
       END IF
       #No.TQC-B30210 --End #是否包含審計調整
	  ELSE
	     SELECT SUM(aao05-aao06) INTO amt0 FROM aao_file,aag_file
		WHERE aao00 = tm.b
                  AND aao00 = aag00
		  AND aao01 BETWEEN maj.maj21 AND maj.maj22
		  AND aao02 BETWEEN maj.maj24 AND maj.maj25
		  AND aao03 = tm.yy AND aao04 =0
		  AND aao01 = aag01 AND aag07 IN ('2','3')
	     SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
		WHERE aao00 = tm.b
                  AND aao00 = aag00
		  AND aao01 BETWEEN maj.maj21 AND maj.maj22
		  AND aao02 BETWEEN maj.maj24 AND maj.maj25
		  AND aao03 = tm.yy AND aao04 <= tm.bm
		  AND aao01 = aag01 AND aag07 IN ('2','3')
		  #No.TQC-B30210 --Begin #是否包含審計調整
      IF tm.g = 'Y' THEN
         IF tm.bm = 12 THEN
            LET l_ad1 = 0 
            LET l_ad2 = 0                       
            SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
             WHERE abb00 = tm.b
               AND aba00 = abb00 AND aba01 = abb01
               AND abb03 BETWEEN maj.maj21 AND maj.maj22
               AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy+1
               AND aba04 = 0 AND abapost = 'Y'
            SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
             WHERE abb00 = tm.b
               AND aba00 = abb00 AND aba01 = abb01
               AND abb03 BETWEEN maj.maj21 AND maj.maj22
               AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy+1
               AND aba04 = 0 AND abapost = 'Y'
            IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
            IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF 
            LET amt1 = amt1 + l_ad1 - l_ad2
          END IF
       END IF
       #No.TQC-B30210 --End #是否包含審計調整
	  END IF
          END IF   #No.FUN-CA0097   Add
	  IF STATUS THEN
             CALL cl_err3("sel","azi_file",tm.p,"",STATUS,"","sel aah:",1)   #No.FUN-6600124
             EXIT FOREACH
          END IF
	  IF amt0 IS NULL THEN LET amt0 = 0 END IF
	  IF amt1 IS NULL THEN LET amt1 = 0 END IF
       END IF
       IF tm.o = 'Y' THEN LET amt0 = amt0 * tm.q END IF      #匯率的轉換
       IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF      #匯率的轉換
#No.MOD-950053 --begin                                                          
       IF NOT cl_null(maj.maj21) THEN                                           
          IF maj.maj06 MATCHES '[123]' AND maj.maj07 = '2' THEN                 
             LET amt0 = amt0 * -1                                               
             LET amt1 = amt1 * -1                                               
          END IF                                                                
          IF maj.maj06 = '4' AND maj.maj07 = '2' THEN                           
             LET amt0 = amt0 * -1                                               
             LET amt1 = amt1 * -1                                               
          END IF                                                                
          IF maj.maj06 = '5' AND maj.maj07 = '1' THEN                           
             LET amt0 = amt0 * -1                                               
             LET amt1 = amt1 * -1                                               
          END IF                                                                
       END IF                                                                   
#No.MOD-950053 --end   
       IF maj.maj03 MATCHES "[012349]" AND maj.maj08 > 0     #合計階數處理
	  THEN 
#No.MOD-950053 --begin                                                          
              IF maj.maj09 ='-' THEN                                            
                 LET l_sw =-1                                                   
              ELSE                                                              
                 LET l_sw =1                                                    
              END IF                                                            
#No.MOD-950022 --begin                                                          
#              IF maj.maj09 ='-' THEN                                           
#                 LET amt0 =amt0*(-1)                                           
#                 LET amt1 =amt1*(-1)                                           
#              END IF                                                           
#No.MOD-950022 --end                                                            
#No.MOD-950053 --end  
               FOR i = 1 TO 100 
               #No.TQC-A70062  --Begin
               #LET g_tot0[i]=g_tot0[i]+amt0 
               #LET g_tot1[i]=g_tot1[i]+amt1 
               LET g_tot0[i]=g_tot0[i]+amt0 * l_sw
               LET g_tot1[i]=g_tot1[i]+amt1 * l_sw
               #No.TQC-A70062  --End  
               END FOR
	       LET k=maj.maj08  
#No.MOD-950053 --begin
#              IF k=1 THEN
#                 LET sr.bal0=amt0
#                 LET sr.bal1=amt1
#              ELSE
#No.MOD-950053 --end
#                 LET sr.bal0=g_tot0[k]
#                 LET sr.bal1=g_tot1[k]
#              END IF  #No.MOD-950053
               IF amt0 =0 THEN
                  LET sr.bal0=g_tot0[k]
                  LET sr.bal1=g_tot1[k]
               ELSE
                  LET sr.bal0=amt0
                  LET sr.bal1=amt1
               END IF
#No.MOD-CA0146 --end
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
       IF maj.maj11 = 'Y' THEN                               #百分比基準科目
	  LET g_basetot1=sr.bal1
	  IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
	  IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF         #本行不印出
       IF (tm.c='N' OR maj.maj03='2') AND
	  maj.maj03 MATCHES "[012]" AND sr.bal1=0 THEN
	  CONTINUE FOREACH                                   #餘額為 0 者不列印
       END IF
       IF tm.f>0 AND maj.maj08 < tm.f THEN
	  CONTINUE FOREACH                                   #最小階數起列印
       END IF
     
#No.MOD-950053 --begin                                                          
#     IF maj.maj07='2' THEN                                                     
#            LET sr.bal0=sr.bal0*-1                                             
#            LET sr.bal1=sr.bal1*-1                                             
#      END IF                                                                   
#No.MOD-950053 --end 
       IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
       LET per1 = (sr.bal1 / g_basetot1) * 100
       IF tm.d MATCHES '[234]' THEN LET sr.bal1=sr.bal1/g_unit END IF   #No.FUN-570087   
 
       IF maj.maj23[2,2]='2' THEN  
	  LET r_row=r_row+1
	  LET prt_r[r_row].maj20=maj.maj05 SPACES,maj.maj20 
					#-- 右邊(負債&業主權益)
          LET prt_r[r_row].maj26=maj.maj26      #No.FUN-570087    
	  LET prt_r[r_row].bal0=cl_numfor(sr.bal0,17,tm.e) 
	  LET prt_r[r_row].bal=cl_numfor(sr.bal1,17,tm.e)  
	  LET prt_r[r_row].per=per1 USING '----&.&& %'
       ELSE
	  LET l_row=l_row+1
	  LET prt_l[l_row].maj20= maj.maj05 SPACES, maj.maj20   #--- 左邊 (資產)
          LET prt_l[l_row].maj26=maj.maj26      #No.FUN-570087 
	  LET prt_l[l_row].bal0=cl_numfor(sr.bal0,17,tm.e) 
	  LET prt_l[l_row].bal=cl_numfor(sr.bal1,17,tm.e)  
	  LET prt_l[l_row].per=per1 USING '----&.&& %'
       END IF
 
       CASE WHEN maj.maj03 = '9' 
		 IF maj.maj23[2,2]='2' THEN    
		    LET prt_r[r_row].maj03='9'         
		 ELSE                          
		    LET prt_l[l_row].maj03='9'         
		 END IF
	    WHEN maj.maj03 = '3' 
		 IF maj.maj23[2,2]='2' THEN  
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
	    WHEN maj.maj03 = '4' 
		 IF maj.maj23[2,2]='2' THEN  
		    LET r_row=r_row+1
		    LET prt_r[r_row].maj20='--------------------',
					   '-----'
		    LET prt_r[r_row].bal0='-----------------'     
		    LET prt_r[r_row].bal='-----------------'     
		    LET prt_r[r_row].per='----------'               
		 ELSE
		    LET l_row=l_row+1
		    LET prt_l[l_row].maj20='--------------------',
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
            IF prt_l[i].maj20 IS NOT NULL AND prt_l[i].maj20 <> ' ' THEN
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
            IF prt_l[i].maj20 IS NOT NULL AND prt_l[i].maj20 <> ' ' THEN
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
            IF prt_r[i].maj20 IS NOT NULL AND prt_r[i].maj20 <> ' ' THEN
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
		VALUES(i,prt_l[i].maj20,prt_l[i].maj26,prt_l[i].bal0,prt_l[i].bal,  #No.MOD-980059
                       prt_l[i].per,prt_l[i].maj03,
		       prt_r[i].maj20,prt_r[i].maj26,prt_r[i].bal0,prt_r[i].bal,
                       prt_r[i].per,prt_r[i].maj03)   #No.FUN-570087 -add maj26
     END FOR
 
     DECLARE q811_c1 CURSOR FOR SELECT * FROM tmp_file ORDER BY maj02   #No.MOD-980059
     CALL g_aag.clear()
     LET l_i = 1   #MOD-840670
     FOREACH q811_c1 INTO l_n,tmp.*  #No.MOD-980059
        LET g_aag[l_i].aag01_l = tmp.maj20_l  
        LET g_aag[l_i].line_l  = tmp.maj26  
        LET g_aag[l_i].sum1_l  = tmp.bal_l0
        LET g_aag[l_i].sum2_l  = tmp.bal_l
        LET g_aag[l_i].aag01_r = tmp.maj20_r  
        LET g_aag[l_i].line_r  = tmp.maj26_r
        LET g_aag[l_i].sum1_r  = tmp.bal_r0
        LET g_aag[l_i].sum2_r  = tmp.bal_r
        LET l_i = l_i + 1   #MOD-840670
     END FOREACH
     LET g_rec_b = l_i - 1
 
END FUNCTION                                                                                                                        
 
FUNCTION q811_bp(p_ud)
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
 
FUNCTION q811_out()
   DEFINE tmp RECORD
	      maj20_l    LIKE type_file.chr1000,
          maj26      LIKE type_file.num5,   
	      bal_l0     LIKE type_file.chr20,  
	      bal_l      LIKE type_file.chr20,  
	      per_l      LIKE type_file.chr20,  
	      maj03_l    LIKE maj_file.maj03,   
	      maj20_r    LIKE type_file.chr1000,
          maj26_r    LIKE type_file.num5,   
	      bal_r0     LIKE type_file.chr20,  
	      bal_r      LIKE type_file.chr20,  
	      per_r      LIKE type_file.chr20,  
	      maj03_r    LIKE maj_file.maj03    
	      END RECORD
   DEFINE l_i       LIKE type_file.num10   
 
   IF g_aag.getLength() = 0  THEN RETURN END IF
   ### *** 與 Crystal Reports 串聯段 - <<<<產生Temp Table >>>> CR11 *** ##
   LET g_sql="maj02.maj_file.maj02,",    #項次（排序要用的）
             "maj20_l.type_file.chr1000,",   
             "maj26.type_file.num5,",    #行序
             "bal_l0.type_file.chr20,",  #年初數     #FUN-C80102  mark   #No.TQC-D10110   UnMark
            #"bal_l0.type_file.num20_6,",  #年初數    #FUN-C80102  add   #No.TQC-D10110   Mark
             "bal_l.type_file.chr20,",   #期末數     #FUN-C80102  mark   #No.TQC-D10110   UnMark
            #"bal_l.type_file.num20_6,",   #期末數    #FUN-C80102  add   #No.TQC-D10110   Mark
             "per_l.type_file.chr20,",
             "maj03_l.maj_file.maj03,",  #列印碼
             "maj20_r.type_file.chr1000,",
             "maj26_r.type_file.num5,",  #行序
             "bal_r0.type_file.chr20,",  #年初數
             "bal_r.type_file.chr20,",   #期末數
             "per_r.type_file.chr20,",
             "maj03_r.maj_file.maj03"  #列印碼
 
   LET l_table = cl_prt_temptable('gglq811',g_sql)  CLIPPED   #產生Temp Table
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
     IF g_aaz.aaz77='N' THEN LET g_mai02= '' END IF
     LET g_str = g_mai02,';',tm.b,';',tm.a,';',tm.yy,';',tm.bm,';',tm.c,';',tm.d,';',tm.e,';',
                 tm.f,';',tm.h,';',tm.o,';',tm.r,';',tm.p,';',tm.q,';',tm.more
     CALL cl_prt_cs3('gglq811','gglq811',g_sql,g_str)
     #----------------------------- CR (4) --------------------------------------------------#
     
END FUNCTION                                                                                                                        
 
