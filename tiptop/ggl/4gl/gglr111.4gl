# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr111.4gl
# Descriptions...: 帳戶式資產負債表
# Date & Author..: 96/09/10 By Melody 
# Modified by Thomas   maj05 跳格未作控制 97/04/09 Line 398,406
# Modified by Thomas   maj07 基準科目處理有錯 Line 456 - 459
# Modified by flora    增加年初數---中國地區
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.FUN-510007 05/02/22 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570087 05/07/28 By Will 新增公式維護 maj26,maj27,maj28 
# Modify.........: NO.FUN-590118 06/01/13 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-640004 06/04/09 By Carier 將帳別擴大至5碼 
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改 
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740032 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740305 07/04/30 By Lynn 制表日期位置在報表名之上
# Modify.........: No.FUN-780057 07/08/22 By mike 報表輸出方式改為Crystal Reports
# Modify.........: No.MOD-820155 08/02/28 By chenl  修正報表遺漏的兩種情況。
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-840670 08/04/30 By Smapmin 報表連續列印二次,結果不同
# Modify.........: No.MOD-860252 09/02/02 By chenl 增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-AC0008 10/12/07 By Summer 計算合計階段需增加maj09的控制
# Modify.........: No:TQC-B30210 11/04/02 By yinhy 增加條件選項“是否包含審計調整”，如果選是並且bm等於12時,則在生成報表時,將憑證來源碼為AD的資料加入到報表中 
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.MOD-D30040 13/03/06 By fengmy 抓取邏輯按gglq811修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
	      a     LIKE mai_file.mai01,  #NO FUN-690009   VARCHAR(6)    #報表結構編號 #TQC-840066
	      b     LIKE aaa_file.aaa01,  #帳別編號  #No.FUN-640004
	      yy    LIKE type_file.num5,  #NO FUN-690009   SMALLINT   #輸入年度
	      bm    LIKE type_file.num5,  #NO FUN-690009   SMALLINT   #Begin 期別
	      c     LIKE type_file.chr1,  #NO FUN-690009   VARCHAR(1)    #異動額及餘額為0者是否列印
	      d     LIKE type_file.chr1,  #NO FUN-690009   VARCHAR(1)    #金額單位
	      e     LIKE type_file.num5,  #NO FUN-690009   SMALLINT   #小數位數
	      f     LIKE type_file.num5,  #NO FUN-690009   SMALLINT   #列印最小階數
              i     LIKE type_file.chr1,  #No.MOD-860252
	      h     LIKE type_file.chr4,    # Prog. Version..: '5.30.06-13.03.12(04)   #額外說明類別
	      o     LIKE type_file.chr1,  # Prog. Version..: '5.30.06-13.03.12(01)   #轉換幣別否
	      p     LIKE azi_file.azi01,  #幣別
	      q     LIKE azj_file.azj03,  #匯率
	      r     LIKE azi_file.azi01,  #幣別
	      g     LIKE type_file.chr1,  #No.TQC-B30210 #是否包含審計調整
	      more  LIKE type_file.chr1   #NO FUN-690009   VARCHAR(1)    #Input more condition(Y/N)
	      END RECORD,
	  i,j,k      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
	  g_unit     LIKE type_file.num10,      #NO FUN-690009   INTEGER     #金額單位基數
	  l_row      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
	  r_row      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
	  g_bookno   LIKE aah_file.aah00, #帳別
	  g_mai02    LIKE mai_file.mai02,
	  g_mai03    LIKE mai_file.mai03,
	  g_tot1     ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
	  g_tot0     ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
	  g_basetot1 LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03   
DEFINE   g_i             LIKE type_file.num5        #NO FUN-690009   SMALLINT   #count/index for any purpose
#str FUN-780057 add
DEFINE   g_sql           STRING     
DEFINE   g_str           STRING     
DEFINE   l_table         STRING     
#end FUN-780057 add
 
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
 
   #str FUN-780057 add
   ### *** 與 Crystal Reports 串聯段 - <<<<產生Temp Table >>>> CR11 *** ##
   LET g_sql="maj02.maj_file.maj02,",    #項次（排序要用的）
             "maj20_l.type_file.chr1000,",   
             "maj26.type_file.num5,",    #行序
             "bal_l0.type_file.chr20,",  #年初數
             "bal_l.type_file.chr20,",   #期末數
             "per_l.type_file.chr20,",
             "maj03_l.maj_file.maj03,",  #列印碼
             "maj20_r.type_file.chr1000,",
             "maj26_r.type_file.num5,",  #行序
             "bal_r0.type_file.chr20,",  #年初數
             "bal_r.type_file.chr20,",   #期末數
             "per_r.type_file.chr20,",
             "maj03_r.maj_file.maj03"  #列印碼
 
   LET l_table = cl_prt_temptable('gglr111',g_sql)  CLIPPED   #產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1)
       EXIT PROGRAM
   END IF 
   #-------------------------------- CR (1) ------------------------------------#
   #end FUN-780057 add
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)   #TQC-610056
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
   LET tm.r  = ARG_VAL(20)   #TQC-610056
   LET tm.g  = ARG_VAL(21)   #TQC-B30210
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#  IF NOT cl_null(g_bookno) THEN
   IF cl_null(g_bookno) THEN         #No.FUN-570087 
      LET g_bookno = g_aaz.aaz64
   END IF
 
   #No.FUN-740032  --Begin
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF
   #No.FUN-740032  --End  

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL r111_tm()                          # Input print condition
   ELSE
      CALL r111()                             # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION r111_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5        #NO FUN-690009   SMALLINT   #No.FUN-670004
   DEFINE p_row,p_col    LIKE type_file.num5,       #NO FUN-690009   SMALLINT
	  l_sw           LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01)   #重要欄位是否空白
	  l_cmd          LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5        #No.FUN-6C0068
   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW r111_w AT p_row,p_col WITH FORM "ggl/42f/gglr111" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別
   #No.FUN-740032  --Begin
#  SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b
   IF SQLCA.sqlcode THEN
#       CALL cl_err('sel aaa:',SQLCA.sqlcode,0)   #No.FUN-660124
        CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660124       
   END IF
   #No.FUN-740032  --End  
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03   
   IF SQLCA.sqlcode THEN 
#       CALL cl_err('sel azi:',SQLCA.sqlcode,0)
        CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)    #No.FUN-660124 
   END IF
#  LET tm.b = g_bookno     #No.FUN-740032
   LET tm.b = g_aza.aza81  #No.FUN-740032
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.i = 'Y'        #No.MOD-860252
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
WHILE TRUE
    LET l_row=0
    LET r_row=0
    LET l_sw = 1
    INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,  #No.FUN-740032
		 tm.c,tm.d,tm.e,tm.f,tm.i,tm.h,tm.o,tm.r,  #No.MOD-860252 add tm.i
		 tm.p,tm.q,tm.g,tm.more WITHOUT DEFAULTS   #No.TQC-B30210 add tm.g
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD a
	 IF tm.a IS NULL THEN NEXT FIELD a END IF
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
	 SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
		WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                  AND mai00 = tm.b  #No.FUN-740032
	 IF STATUS THEN 
#             CALL cl_err('sel mai:',STATUS,0)  #No.FUN-660124
	      CALL cl_err3("sel","mai_file",tm.a,tm.b,STATUS,"","sel mai:",0)   #No.FUN-660124     #No.FUN-740032
	      NEXT FIELD a
        #No.TQC-C50042   ---start---   Add
         ELSE
            IF g_mai03 = '5' OR g_mai03 = '6' THEN
               CALL cl_err('','agl-268',0)
               NEXT FIELD a
            END IF
        #No.TQC-C50042   ---end---     Add
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b END IF  #No.FUN-740032
         IF NOT cl_null(tm.b) THEN
            #No.FUN-670004--begin
	          CALL s_check_bookno(tm.b,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF
            #No.FUN-670004--end
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0)    #No.FUN-660124
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
 
      AFTER FIELD bm
#No.TQC-720032 -- begin --
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
#No.TQC-720032 -- end --
	 IF tm.bm IS NULL THEN NEXT FIELD bm END IF
#No.TQC-720032 -- begin --
#	 IF tm.bm <1 OR tm.bm > 13 THEN
#	    CALL cl_err('','agl-013',0)
#	    NEXT FIELD bm
#	 END IF
#No.TQC-720032 -- end --
  
      AFTER FIELD d
	 IF tm.d IS NULL OR tm.d NOT MATCHES'[1234]'  THEN
	    NEXT FIELD d
	 END IF
	 IF tm.d = '1' THEN LET g_unit = 1 END IF
	 IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 10000 END IF  #No.FUN-570087 
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
#           CALL cl_err(tm.p,'agl-109',0)   #No.FUN-660124
	    CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)     #No.FUN-660124
	 NEXT FIELD p 
	 END IF
 
      BEFORE FIELD q
	 IF tm.o = 'N' THEN NEXT FIELD o END IF
       #No.TQC-B30210  --Begin
       AFTER FIELD g
          IF tm.g IS NULL OR tm.g NOT MATCHES "[YN]" THEN NEXT FIELD g END IF
       #No.TQC-B30210  --End
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
	 IF tm.d = '1' THEN LET g_unit = 1 END IF
	 IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 10000 END IF  #No.FUN-570087  
	 IF tm.d = '4' THEN LET g_unit = 1000000 END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
 
      ON ACTION CONTROLP
	 CASE
            WHEN INFIELD(a) 
#              CALL q_mai(0,0,tm.a,tm.a) RETURNING tm.a
#              CALL FGL_DIALOG_SETBUFFER( tm.a )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740032   #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a 
#               CALL FGL_DIALOG_SETBUFFER( tm.a )
	       DISPLAY BY NAME tm.a
	       NEXT FIELD a
 
             #No.MOD-4C0156 add
            WHEN INFIELD(b) 
#              CALL q_aaa(0,0,tm.b) RETURNING tm.b
#              CALL FGL_DIALOG_SETBUFFER( tm.b )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
#               CALL FGL_DIALOG_SETBUFFER( tm.b )
               DISPLAY BY NAME tm.b
               NEXT FIELD b
              #No.MOD-4C0156 end
 
            WHEN INFIELD(p)
#              CALL q_azi(6,10,tm.p) RETURNING tm.p
#              CALL FGL_DIALOG_SETBUFFER( tm.p )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
#               CALL FGL_DIALOG_SETBUFFER( tm.p )
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r111_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
	     WHERE zz01='gglr111'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
   	 CALL cl_err('gglr111','9031',1)   
      ELSE
	 LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
			 " '",g_pdate CLIPPED,"'",
			 " '",g_towhom CLIPPED,"'",
			 #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
			 " '",g_bgjob CLIPPED,"'",
			 " '",g_prtway CLIPPED,"'",
			 " '",g_copies CLIPPED,"'",
			 " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #TQC-610056
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
                         " '",tm.r CLIPPED,"'",   #TQC-610056
                         " '",tm.g CLIPPED,"'",   #TQC-B30210
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
	 CALL cl_cmdat('gglr111',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r111()
   ERROR ""
END WHILE
   CLOSE WINDOW r111_w
END FUNCTION
 
FUNCTION r111()
   DEFINE l_name    LIKE type_file.chr20       #NO FUN-690009   VARCHAR(20)  # External(Disk) file name
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0097
   DEFINE l_sql     LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(1000)# RDSQL STATEMENT
   DEFINE l_chr     LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(40)
   DEFINE amt0      LIKE aah_file.aah04        #NO FUN-690009   DEC(20,6) # 期初數
   DEFINE amt1      LIKE aah_file.aah04        #NO FUN-690009   DEC(20,6)
   DEFINE per1      LIKE fid_file.fid03        #NO FUN-690009   DEC(8,3)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_last    LIKE type_file.num5        #NO FUN-690009   SMALLINT
   DEFINE l_diff    LIKE type_file.num5        #NO FUN-690009   SMALLINT
   DEFINE l_i       LIKE maj_file.maj02        #MOD-840670
   DEFINE sr  RECORD
	      bal0      LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)   # 期初數
	      bal1      LIKE type_file.num20_6   #NO FUN-690009   DEC(20,6)
	      END RECORD
   DEFINE prt_l DYNAMIC ARRAY OF RECORD         #--- 陣列 for 資產類 (左)
		maj20    LIKE type_file.chr1000,#NO FUN-690009   VARCHAR(40)
                maj26    LIKE type_file.num5,   #NO FUN-690009   SMALLINT   #No.FUN-570087  
		bal0     LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)
		bal      LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)
		per      LIKE type_file.chr20,    #NO FUN-690009   VARCHAR(10)
		maj03    LIKE maj_file.maj03    #NO FUN-690009   VARCHAR(1) 
		END RECORD
   DEFINE prt_r DYNAMIC ARRAY OF RECORD         #--- 陣列 for 負債&業主權益類 (右)
		maj20    LIKE type_file.chr1000,#NO FUN-690009   VARCHAR(40) 
                maj26    LIKE type_file.num5,   #NO FUN-690009   SMALLINT   #No.FUN-570087
		bal0     LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)
		bal      LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)
		per      LIKE type_file.chr20,    #NO FUN-690009   VARCHAR(10)
		maj03    LIKE maj_file.maj03    #NO FUN-690009   VARCHAR(1)
		END RECORD
   DEFINE tmp RECORD
	      maj20_l    LIKE type_file.chr1000,#NO FUN-690009   VARCHAR(40)
              maj26      LIKE type_file.num5,   #NO FUN-690009   SMALLINT   #No.FUN-570087
	      bal_l0     LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)
	      bal_l      LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)
	      per_l      LIKE type_file.chr20,    #NO FUN-690009   VARCHAR(10)
	      maj03_l    LIKE maj_file.maj03,   #NO FUN-690009   VARCHAR(1)
	      maj20_r    LIKE type_file.chr1000,#NO FUN-690009   VARCHAR(40)
              maj26_r    LIKE type_file.num5,   #NO FUN-690009   SMALLINT   #No.FUN-570087
	      bal_r0     LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)
	      bal_r      LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)
	      per_r      LIKE type_file.chr20,    #NO FUN-690009   VARCHAR(10)
	      maj03_r    LIKE maj_file.maj03    #NO FUN-690009   VARCHAR(1)
	      END RECORD
	  DEFINE l_ad1     LIKE abb_file.abb07             #No.TQC-B30210
    DEFINE l_ad2     LIKE abb_file.abb07             #No.TQC-B30210 
#NO.FUN-690009------------------begin---------------------
#   DROP TABLE tmp_file
#   CREATE TEMP TABLE tmp_file
#   (
#     maj20_l    VARCHAR(40),
#     maj26      SMALLINT,              #No.FUN-570087
#     bal_l0     VARCHAR(20),
#     bal_l      VARCHAR(20),
#     per_l      VARCHAR(10),
#     maj03_l    VARCHAR(1),
#     maj20_r    VARCHAR(40),
#     maj26_r    SMALLINT,              #No.FUN-570087    
#     bal_r0     VARCHAR(20),
#     bal_r      VARCHAR(20),
#     per_r      VARCHAR(10),
#     maj03_r    VARCHAR(1) 
#   )
#NO.FUN-690009------------------END------------------------
 
#NO.FUN-690009------------------begin---------------------                                                                          
   DROP TABLE tmp_file                                                                                                              
   CREATE TEMP TABLE tmp_file(                                                                                                       
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
#NO.FUN-690009------------------END------------------------   
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     #str FUN-780057 add
     ## *** 與 Crystal Reports  串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table) 
     #-------------------------------CR(2)----------------------------------#
     #end FUN-780057 add
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
	    AND aaf02 = g_rlang
 
     LET l_sql = "SELECT * FROM maj_file ",
		 " WHERE maj01 = '",tm.a,"' ",
		 "   AND maj23[1,1]='1' ",
		 " ORDER BY maj02"
     PREPARE r111_p FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE r111_c CURSOR FOR r111_p
 
     FOR g_i = 1 TO 100 LET g_tot0[g_i]=0  LET g_tot1[g_i] = 0 END FOR
 
    #CALL cl_outnam('gglr111') RETURNING l_name    #FUN-780057 mark
    #START REPORT r111_rep TO l_name               #FUN-780057 mark
     FOREACH r111_c INTO maj.*
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
	  IF maj.maj24 IS NULL THEN
            #No.MOD-860252--begin-- add
             IF tm.i ='Y' THEN
	        SELECT SUM(aah04-aah05) INTO amt0 FROM aah_file,aag_file
	           WHERE aah00 = tm.b
               AND aah00 = aag00  #No.FUN-740032
	             AND aah01 BETWEEN maj.maj21 AND maj.maj22
	             AND aah02 = tm.yy AND aah03 ='0'
	             AND aah01 = aag01 AND aag07 IN ('2','3')
               AND aag09 = 'Y'
	        SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
	           WHERE aah00 = tm.b
               AND aah00 = aag00  #No.FUN-740032
	             AND aah01 BETWEEN maj.maj21 AND maj.maj22
	             AND aah02 = tm.yy AND aah03 <= tm.bm
	             AND aah01 = aag01 AND aag07 IN ('2','3')
               AND aag09 = 'Y'
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
                #No.TQC-B30210 --End #是否包含審計調     
             ELSE
            #No.MOD-860252---end--- add
	        SELECT SUM(aah04-aah05) INTO amt0 FROM aah_file,aag_file
	           WHERE aah00 = tm.b
                     AND aah00 = aag00  #No.FUN-740032
	             AND aah01 BETWEEN maj.maj21 AND maj.maj22
	             AND aah02 = tm.yy AND aah03 ='0'
	             AND aah01 = aag01 AND aag07 IN ('2','3')
	        SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
	           WHERE aah00 = tm.b
                     AND aah00 = aag00  #No.FUN-740032
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
                #No.TQC-B30210 --End #是否包含審計調   
             END IF      #No.MOD-860252
	  ELSE
             #No.MOD-860252--begin-- add
             IF tm.i = 'Y' THEN
	        SELECT SUM(aao05-aao06) INTO amt0 FROM aao_file,aag_file
	           WHERE aao00 = tm.b
                     AND aao00 = aag00  #No.FUN-740032
	             AND aao01 BETWEEN maj.maj21 AND maj.maj22
	             AND aao02 BETWEEN maj.maj24 AND maj.maj25
	             AND aao03 = tm.yy AND aao04 ='0'
	             AND aao01 = aag01 AND aag07 IN ('2','3')
                     AND aag09 = 'Y'
	        SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
	           WHERE aao00 = tm.b
                     AND aao00 = aag00  #No.FUN-740032
	             AND aao01 BETWEEN maj.maj21 AND maj.maj22
	             AND aao02 BETWEEN maj.maj24 AND maj.maj25
	             AND aao03 = tm.yy AND aao04 <= tm.bm
	             AND aao01 = aag01 AND aag07 IN ('2','3')
                     AND aag09 = 'Y'
             ELSE
             #No.MOD-860252---end---
	        SELECT SUM(aao05-aao06) INTO amt0 FROM aao_file,aag_file
	           WHERE aao00 = tm.b
                     AND aao00 = aag00  #No.FUN-740032
	             AND aao01 BETWEEN maj.maj21 AND maj.maj22
	             AND aao02 BETWEEN maj.maj24 AND maj.maj25
	             AND aao03 = tm.yy AND aao04 ='0'
	             AND aao01 = aag01 AND aag07 IN ('2','3')
	        SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
	           WHERE aao00 = tm.b
                     AND aao00 = aag00  #No.FUN-740032
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
                #No.TQC-B30210 --End #是否包含審計調 
             END IF      #No.MOD-860252            
	  END IF
	  IF STATUS THEN
#                 CALL cl_err('sel aah:',STATUS,1)   #No.FUN-6600124
                  CALL cl_err3("sel","azi_file",tm.p,"",STATUS,"","sel aah:",1)   #No.FUN-6600124
          EXIT FOREACH END IF
	  IF amt0 IS NULL THEN LET amt0 = 0 END IF
	  IF amt1 IS NULL THEN LET amt1 = 0 END IF
       END IF
       IF tm.o = 'Y' THEN LET amt0 = amt0 * tm.q END IF      #匯率的轉換
       IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF      #匯率的轉換
       #MOD-D30040 --begin
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
       #MOD-D30040 --end
       IF maj.maj03 MATCHES "[012349]" AND maj.maj08 > 0     #合計階數處理
	  THEN FOR i = 1 TO 100 
              #CHI-AC0008 mod --start--
              #LET g_tot0[i]=g_tot0[i]+amt0 
              #LET g_tot1[i]=g_tot1[i]+amt1
               IF maj.maj09 = '-' THEN
                  LET g_tot0[i] = g_tot0[i] - amt0 
                  LET g_tot1[i] = g_tot1[i] - amt1
               ELSE
                  LET g_tot0[i] = g_tot0[i] + amt0 
                  LET g_tot1[i] = g_tot1[i] + amt1
               END IF
              #CHI-AC0008 mod --end-- 
               END FOR
	       LET k=maj.maj08  
               LET sr.bal0=g_tot0[k]
               LET sr.bal1=g_tot1[k]
               #CHI-AC0008 add --start--
              #IF maj.maj07 = '1' AND maj.maj09 = '-' THEN                         #MOD-D30040 mark
               IF (maj.maj07 = '1' AND maj.maj09 = '-') OR maj.maj07 = '2' THEN    #MOD-D30040 
                  LET sr.bal0 = sr.bal0 *-1
                  LET sr.bal1 = sr.bal1 *-1
               END IF
               #CHI-AC0008 add --end--
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
     
       IF maj.maj07='2' THEN 
             LET sr.bal0=sr.bal0*-1 
             LET sr.bal1=sr.bal1*-1 
       END IF
       IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
       LET per1 = (sr.bal1 / g_basetot1) * 100
       IF tm.d MATCHES '[234]' THEN LET sr.bal1=sr.bal1/g_unit END IF   #No.FUN-570087   
 
       IF maj.maj23[2,2]='2' THEN  
	  LET r_row=r_row+1
#  modified by Thomas 97/04/08 縮格控制
	  LET prt_r[r_row].maj20=maj.maj05 SPACES,maj.maj20 
					#-- 右邊(負債&業主權益)
          LET prt_r[r_row].maj26=maj.maj26      #No.FUN-570087    
	  # LET prt_r[r_row].maj20=maj.maj20      #--- 右邊 (負債&業主權益)
	  LET prt_r[r_row].bal0=cl_numfor(sr.bal0,17,tm.e) 
	  LET prt_r[r_row].bal=cl_numfor(sr.bal1,17,tm.e)  
	  LET prt_r[r_row].per=per1 USING '----&.&& %'
       ELSE
	  LET l_row=l_row+1
#  modified by Thomas 97/04/08 縮格控制
	  LET prt_l[l_row].maj20= maj.maj05 SPACES, maj.maj20   #--- 左邊 (資產)
          LET prt_l[l_row].maj26=maj.maj26      #No.FUN-570087 
	  # LET prt_l[l_row].maj20=maj.maj20      #--- 左邊 (資產)
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
{
	    OTHERWISE 
		 FOR i = 1 TO maj.maj04
		     IF maj.maj23[2,2]='2' THEN  
			LET r_row=r_row+1
		     ELSE
			LET l_row=l_row+1
		     END IF
		 END FOR
}
       END CASE                      
     END FOREACH
##No.0167 modify 1999/05/21
     IF l_row>r_row THEN 
        LET l_last=l_row LET l_diff =r_row  
        FOR i = l_last TO 1 step -1
            IF prt_l[i].maj20 IS NOT NULL AND prt_l[i].maj20 <> ' ' THEN
#No.FUN-570087--begin           
               IF r_row = '0' THEN  
                 CALL cl_err('','ggl-002',1)     
                 RETURN        
               END IF         
#No.FUN-570087--end 
               LET prt_r[i].* = prt_r[r_row].*
               INITIALIZE prt_r[l_diff].* TO NULL
               EXIT FOR
            END IF
        END FOR
     END IF
#No.MOD-820155--begin--
     IF l_row=r_row THEN 
        LET l_last=l_row LET l_diff =r_row  
        FOR i = l_last TO 1 step -1
            IF prt_l[i].maj20 IS NOT NULL AND prt_l[i].maj20 <> ' ' THEN
#No.FUN-570087--begin      
               IF r_row = '0' THEN      
                 CALL cl_err('','ggl-002',1)       
                 RETURN          
               END IF  
#No.FUN-570087--end
               LET prt_r[i].* = prt_r[r_row].*
          #    INITIALIZE prt_r[l_diff].* TO NULL
               EXIT FOR
            END IF
        END FOR
     END IF
     IF r_row>l_row THEN 
        LET l_last=r_row LET l_diff =l_row
        FOR i = l_last TO 1 step -1
            IF prt_r[i].maj20 IS NOT NULL AND prt_r[i].maj20 <> ' ' THEN
#No.FUN-570087--begin  
               IF l_row = '0' THEN      
                 CALL cl_err('','ggl-002',1)      
                 RETURN     
               END IF      
#No.FUN-570087--end 
               LET prt_l[i].* = prt_l[l_row].*
               INITIALIZE prt_l[l_diff].* TO NULL
               EXIT FOR
            END IF
        END FOR
     END IF
#No.MOD-820155---end---
##-------------------------------
     FOR i=1 TO l_last
# Modified by Thomas 97/04/09   重新計算百分比
	 LET per1 = (prt_l[i].bal / g_basetot1) * 100
	 LET prt_l[i].per=per1 USING '----&.&& %'
	 LET per1 = (prt_r[i].bal / g_basetot1) * 100
	 LET prt_r[i].per=per1 USING '----&.&& %'
##############
	 INSERT INTO tmp_file 
		VALUES(prt_l[i].maj20,prt_l[i].maj26,prt_l[i].bal0,prt_l[i].bal,
                       prt_l[i].per,prt_l[i].maj03,
		       prt_r[i].maj20,prt_r[i].maj26,prt_r[i].bal0,prt_r[i].bal,
                       prt_r[i].per,prt_r[i].maj03)   #No.FUN-570087 -add maj26
     END FOR
 
     DECLARE r111_c1 CURSOR FOR SELECT * FROM tmp_file
     LET l_i = 1   #MOD-840670
     FOREACH r111_c1 INTO tmp.*
     
     #str FUN-780057 add
     ## *** 與 Crystal Reports 串聯段 -<<<<寫入暫存檔 >>>> CR11 *** ##
        EXECUTE insert_prep USING 
           #maj.maj02,tmp.maj20_l,tmp.maj26,tmp.bal_l0,tmp.bal_l,tmp.per_l,tmp.maj03_l,   #MOD-840670
           l_i,tmp.maj20_l,tmp.maj26,tmp.bal_l0,tmp.bal_l,tmp.per_l,tmp.maj03_l,   #MOD-840670
           tmp.maj20_r,tmp.maj26_r,tmp.bal_r0,tmp.bal_r,tmp.per_r,tmp.maj03_r
        LET l_i = l_i + 1   #MOD-840670
     #end FUN-780057 add
 
	#OUTPUT TO REPORT r111_rep(tmp.*)  #FUN-780057 mark
     END FOREACH
 
     #str FUN-780057 add
     ## *** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET g_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     #報表名稱是否以報表結構名稱列印
     IF g_aaz.aaz77='N' THEN LET g_mai02= '' END IF
     LET g_str = g_mai02,';',tm.b,';',tm.a,';',tm.yy,';',tm.bm,';',tm.c,';',tm.d,';',tm.e,';',
                 tm.f,';',tm.h,';',tm.o,';',tm.r,';',tm.p,';',tm.q,';',tm.more
     CALL cl_prt_cs3('gglr111','gglr111',g_sql,g_str)
     #----------------------------- CR (4) --------------------------------------------------#
     #end FUN-780057 add     
     
     #str FUN-780057 add
     #FINISH REPORT r111_rep                                                                                                         
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                                                                    
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097                                 
     #end FUN-780057 add
END FUNCTION                                                                                                                        
 
#str FUN-780057 add
#REPORT r111_rep(tmp)                                                                                                                
#   DEFINE l_last_sw    LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)                                                          
#          g_head1      STRING                                                                                                       
#   DEFINE tmp RECORD                                                                                                                
#              maj20_l    LIKE type_file.chr1000,#NO FUN-690009   VARCHAR(40)       
#              maj26      LIKE type_file.num5,   #NO FUN-690009   SMALLINT   #No.FUN-570087                                          
#              bal_l0     LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)                                                           
#              bal_l      LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)                                                           
#              per_l      LIKE type_file.chr20,    #NO FUN-690009   VARCHAR(10)                                                         
#              maj03_l    LIKE maj_file.maj03,   #NO FUN-690009   VARCHAR(1)                                                            
#              maj20_r    LIKE type_file.chr1000,#NO FUN-690009   VARCHAR(40)                                                           
#              maj26_r    LIKE type_file.num5,   #NO FUN-690009   SMALLINT   #No.FUN-570087                                          
#              bal_r0     LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)                                                           
#              bal_r      LIKE type_file.chr20,  #NO FUN-690009   VARCHAR(20)                                                           
#              per_r      LIKE type_file.chr20,    #NO FUN-690009   VARCHAR(10)                                                         
#              maj03_r    LIKE maj_file.maj03    #NO FUN-690009   VARCHAR(1)                                                            
#              END RECORD                                                                                                            
#  
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line                    
#  FORMAT                                                                                                                            
#    PAGE HEADER                                                                               
#	 PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#No.TQC-6A0094 -- begin --
#         LET g_pageno = g_pageno + 1                                            
#         LET pageno_total = PAGENO USING '<<<',"/pageno"                        
#        PRINT g_head CLIPPED, pageno_total CLIPPED    # No.TQC-740305
#         IF g_aaz.aaz77 = 'Y' THEN
#            LET g_x[1] = g_x[1] CLIPPED," (",g_mai02 CLIPPED,")"
#         END IF
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0094
#         PRINT g_head CLIPPED, pageno_total CLIPPED    # No.TQC-740305
#No.TQC-6A0094 -- end --
#	 #金額單位之列印
#	 CASE tm.d
#	      WHEN '1'  LET l_unit = g_x[16] CLIPPED
#	      WHEN '2'  LET l_unit = g_x[17] CLIPPED
#             WHEN '3'  LET l_unit = g_x[20] CLIPPED  #No.FUN-570087       
#	      WHEN '4'  LET l_unit = g_x[18] CLIPPED
#	      OTHERWISE LET l_unit = ' '
#	 END CASE
#No.TQC-6A0094 -- begin --
#         LET g_x[1] = g_mai02
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED, pageno_total
#No.TQC-6A0094 -- end --
#         PRINT g_x[14] CLIPPED,tm.a;
#No.TQC-6A0094 -- begin --
#         LET g_head1 = g_x[13] CLIPPED,                                         
#                       tm.yy USING '<<<<','/',tm.bm USING'&&'                   
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1 CLIPPED))/2)+1,g_head1 CLIPPED
#No.TQC-6A0094 -- end --
#         LET g_head1 = g_x[19] CLIPPED,tm.p,' ',
#                       g_x[15] CLIPPED,l_unit CLIPPED
#         PRINT COLUMN (g_len-FGL_WIDTH(g_head1)-6 CLIPPED),g_head1 CLIPPED
#No.TQC-6A0094 -- begin --
#         LET g_head1 = g_x[13] CLIPPED,
#                       tm.yy USING '<<<<','/',tm.bm USING'&&'
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1
#No.TQC-6A0094 -- end --
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               g_x[38],g_x[39]    #No.FUN-570087    --add
#         PRINT g_dash1 CLIPPED
#	 LET l_last_sw = 'n'
#
#    ON EVERY ROW
#	IF tmp.maj03_r='9' OR tmp.maj03_l='9' THEN SKIP TO TOP OF PAGE END IF
#No.FUN-570087--begin         
#       PRINT COLUMN g_c[31],tmp.maj20_l[1,25],
#             COLUMN g_c[32],tmp.bal_l0,
#	      COLUMN g_c[33],tmp.bal_l,
#             COLUMN g_c[34], '|',
#	      COLUMN g_c[35],tmp.maj20_r[1,25],
#	      COLUMN g_c[36],tmp.bal_r0,
#	      COLUMN g_c[37],tmp.bal_r
#        PRINT COLUMN g_c[31],tmp.maj20_l[1,25],     
#              COLUMN g_c[32],tmp.maj26 USING '###&', #FUN-590118            
#              COLUMN g_c[33],tmp.bal_l0,          
#              COLUMN g_c[34],tmp.bal_l,          
#              COLUMN g_c[35], '|',              
#              COLUMN g_c[36],tmp.maj20_r[1,25],
#              COLUMN g_c[37],tmp.maj26_r USING '###&', #FUN-590118     
#              COLUMN g_c[38],tmp.bal_r0,     
#              COLUMN g_c[39],tmp.bal_r      
#No.FUN-570087--end       
#    ON LAST ROW
#	LET l_last_sw = 'y'
#
#    PAGE TRAILER
#	PRINT g_dash[1,g_len]
#	IF l_last_sw = 'n' THEN
#	   PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#	ELSE
#	   PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#	END IF
#END REPORT
#end FUN-780057 add
