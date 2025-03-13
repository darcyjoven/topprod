# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr111.4gl
# Descriptions...: 帳戶式預算資產負債表
# Date & Author..: 03/03/16 By Kammy
# Modify.........: No.FUN-510025 05/02/14 By Smapmin 報表轉XML格式
# Modify         : No.MOD-530835 05/03/29 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/08 By baogui  表名名稱未置中
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構檢查使用者設限及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740048 07/04/12 By johnray 會計科目加帳套
# Modify.........: NO.FUN-750025 07/07/25 BY TSD.Ken 改為CR
# Modify.........: No.FUN-810069 08/02/28 By ChenMoyan 去掉budget 添加afc041,afc042
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40036 10/04/22 By Summer 相關有使用afb04,afb041,afb042若給予''者,將改為' '
# Modify.........: No:CHI-A40063 10/05/04 By Summer 相關有使用 afc04,afc041,afc042 若給予 '' 者,將改為 ' '
# Modify.........: No:CHI-A20007 10/10/28 By sabrina 欄位抓取錯誤，afc041、afb041才是部門編號
# Modify.........: No:FUN-AB0020 10/11/04 By huangtao 添加預算項目欄位
# Modify.........: No:FUN-B10020 11/01/13 By huangtao 預算項目可以為空 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
	      a       LIKE maj_file.maj01,  #報表結構編號     #No.FUN-680061 VARCHAR(6)                                                                  
              b       LIKE aaa_file.aaa01,  #帳別編號  #No.FUN-670039                                                 
              yy      LIKE abk_file.abk03,  #輸入年度         #No.FUN-680061 SMALLINT                                                                       
              bm      LIKE aah_file.aah03,  #Begin 期別       #No.FUN-680061 SMALLINT                                                                      
#             budget  LIKE afa_file.afa01,  #預算編號         #No.FUN-680061 VARCHAR(4)      #FUN-810069
              afc01   LIKE afc_file.afc01,         #FUN-AB0020   add by huangtao                                                                
              c       LIKE type_file.chr1,  #異動額及餘額為0者是否列印   #No.FUN-680061 VARCHAR(1)                                                            
              d       LIKE type_file.chr1,  #金額單位         #No.FUN-680061  VARCHAR(1)                                                                       
              f       LIKE maj_file.maj08,  #列印最小階數     #No.FUN-680061  SMALLINT                                                                     
              more  LIKE type_file.chr1,                    #No.FUN-680061  VARCHAR(1)
          e     LIKE azi_file.azi05,    #小數位數         #No.FUN-680061  SMALLINT                                                                        
              h     LIKE fan_file.fan02,    #額外說明類別     #No.FUN-680061  VARCHAR(4)                                                                        
              o     LIKE type_file.chr1,    #轉換幣別否       #No.FUN-680061  VARCHAR(1)
	      p     LIKE azi_file.azi01,    #幣別
	      q     LIKE azj_file.azj03,    #匯率
	      r     LIKE azi_file.azi01     #幣別
	      END RECORD,
	  i,j,k      LIKE type_file.num5,    #No.FUN-680061  SMALLINT 
	  g_unit     LIKE type_file.num10,   #No.FUN-680061  INTEGER
	  l_row      LIKE type_file.num5,    #No.FUN-680061  SMALLINT
	  r_row      LIKE type_file.num5,    #No.FUN-680061  SMALLINT
	  g_bookno   LIKE afc_file.afc00,    #帳別
	  g_mai02    LIKE mai_file.mai02,
	  g_mai03    LIKE mai_file.mai03,
	  g_tot1     ARRAY[100] OF LIKE type_file.num20_6, #No.FUN-680061  ARRAY[100] OF DEC(20,6)
	  g_basetot1 LIKE type_file.num20_6    #No.FUN-680061  DEC(20,6)
DEFINE   g_i         LIKE type_file.num5       #count/index for any purpose    #No.FUN-680061  SMALLINT
DEFINE   g_aaa03     LIKE  aaa_file.aaa03
DEFINE   g_before_input_done  LIKE type_file.num5       #No.FUN-680061  SMALLINT
DEFINE   p_cmd       LIKE type_file.chr1       #No.FUN-680061    VARCHAR(1)
DEFINE   g_str         STRING          # FUN-750025 
DEFINE   l_table       STRING          # FUN-750025 
DEFINE   g_sql         STRING          # FUN-750025
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
    #str FUN-750025 add
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
 LET g_sql = "maj20_l.maj_file.maj20,", 
	     "bal_l.type_file.chr20,",
	     "per_l.cre_file.cre08,",
	     "maj03_l.maj_file.maj03,",
	     "maj20_r.maj_file.maj20,",
	     "bal_r.type_file.chr20,",
	     "per_r.cre_file.cre08,",
	     "maj03_r.maj_file.maj03"
 
 LET l_table = cl_prt_temptable('abgr111',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?)"
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
 END IF
 #------------------------------ CR (1) ------------------------------#
 #end FUN-750025 add
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
LET tm.a  = ARG_VAL(8)
LET tm.b  = ARG_VAL(9)   #TQC-610054
LET tm.yy = ARG_VAL(10)
LET tm.bm = ARG_VAL(11)
LET tm.afc01 = ARG_VAL(12)           #FUN-AB0020
#LET tm.budget = ARG_VAL(12)   #TQC-610054     #FUN-810069
LET tm.c  = ARG_VAL(13)
LET tm.d  = ARG_VAL(14)
LET tm.e  = ARG_VAL(15)
LET tm.f  = ARG_VAL(16)
LET tm.h  = ARG_VAL(17)
LET tm.o  = ARG_VAL(18)
LET tm.r  = ARG_VAL(19)
LET tm.p  = ARG_VAL(20)
LET tm.q  = ARG_VAL(21)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF   #No.FUN-740048
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r111_tm()                   # Input print condition
      ELSE CALL r111()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r111_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680061  SMALLINT 
	  l_sw           LIKE type_file.chr1,    #No.FUN-680061   VARCHAR(1)
	  l_cmd          LIKE type_file.chr1000, #No.FUN-680061  VARCHAR(400)
	  li_chk_bookno  LIKE type_file.num5     #No.FUN-680061   SMALLINT
   DEFINE li_result      LIKE type_file.num5     #No.FUN-6C0068
 
#   CALL s_dsmark(g_bookno)   #No.FUN-740048
   CALL s_dsmark(tm.b)   #No.FUN-740048
   LET p_row = 4 LET p_col = 11
   OPEN WINDOW r111_w AT p_row,p_col
	WITH FORM "abg/42f/abgr111"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)   #No.FUN-740048
   CALL  s_shwact(0,0,tm.b)   #No.FUN-740048
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   LET tm.b = g_aza.aza81
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.FUN-740048
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b   #No.FUN-740048
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #FUN-660105
#   CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #FUN-660105    #No.FUN-740048
   CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)      #No.FUN-740048
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel azi:',SQLCA.sqlcode,0) #FUN-660105
   CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0) #FUN-660105 
   END IF
#  LET tm.b = g_bookno   #No.FUN-740048
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'Y'
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
 
#INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.budget,tm.e,tm.f,     #FUN-810069
# INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.e,tm.f,               #FUN-810069   #FUN-AB0020  mark
 INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.afc01,tm.e,tm.f,     #FUN-AB0020
		 #tm.d,tm.c,tm.h,tm.h,tm.o,tm.r, #CHI-A40063 mark
		 tm.d,tm.c,tm.h,tm.o,tm.r,       #CHI-A40063
		 tm.p,tm.q,tm.more WITHOUT DEFAULTS HELP 1 
        BEFORE INPUT
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
            LET g_before_input_done = FALSE
            CALL r111_set_entry(p_cmd)
            CALL r111_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
        
        AFTER FIELD a
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
	 SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
		WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                AND mai00 = tm.b              #No.FUN-740048
	 IF STATUS THEN 
#        CALL cl_err('sel mai:',STATUS,0) #FUN-660105
         CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0) #FUN-660105 
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
      #No.FUN-660141--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-660141--end
	 SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
	 IF STATUS THEN 
#	 CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
         CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0) #FUN-660105 
	 NEXT FIELD b END IF
 
 
      AFTER FIELD yy
	 IF tm.yy = 0 THEN
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
#	 IF tm.bm <1 OR tm.bm > 13 THEN
#	    CALL cl_err('','agl-013',0)
#	    NEXT FIELD bm
#	 END IF
#No.TQC-720032 -- end --
 
#     AFTER FIELD budget                              #FUN-810069
#        SELECT * FROM afa_file WHERE afa01=tm.budget #FUN-810069
#                                 AND afaacti IN ('Y','y')                 #FUN-810069
#                                 AND afa00 = tm.b    #No.FUN-740048
#       IF STATUS THEN                                #FUN-810069
#       CALL cl_err('sel afa:',STATUS,0) #FUN-660105
#       CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105 #FUN-810069
#       NEXT FIELD budget END IF                      #FUN-810069
#FUN-AB0020 -------------start------------------------
         AFTER FIELD afc01
            IF NOT cl_null(tm.afc01) THEN            #FUN-B10020
               SELECT * FROM azf_file WHERE azf01 = tm.afc01
                                     AND azfacti = 'Y'
                                     AND azf02 = '2'
               IF STATUS THEN
                  CALL cl_err3("sel","azf_file",tm.afc01,"",STATUS,"","sel afc:",0)
                  NEXT FIELD afc01
               END IF
            END IF                                   #FUN-B10020
#FUN-AB0020 --------------end-------------------------
  
      AFTER FIELD d
	 IF tm.d = '1' THEN LET g_unit = 1 END IF
	 IF tm.d = '2' THEN LET g_unit = 1000 END IF
	 IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
      AFTER FIELD e
	 IF tm.e < 0 THEN
	    LET tm.e = 0
	    DISPLAY BY NAME tm.e
	 END IF
 
      AFTER FIELD f
	 IF tm.f < 0  THEN
	    LET tm.f = 0
	    DISPLAY BY NAME tm.f
	    NEXT FIELD f
	 END IF
 
 
      AFTER FIELD o
	 IF tm.o = 'N' THEN 
	    LET tm.p = g_aaa03 
	    LET tm.q = 1
	    DISPLAY g_aaa03 TO p
	    DISPLAY BY NAME tm.q
	 END IF
         CALL r111_set_entry(p_cmd)
         CALL r111_set_no_entry(p_cmd)
 
      AFTER FIELD p
	 SELECT azi01 FROM azi_file WHERE azi01 = tm.p
	 IF SQLCA.sqlcode THEN 
#	 CALL cl_err(tm.p,'agl-109',0) #FUN-660105
         CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0) #FUN-660105 
	 NEXT FIELD p END IF
 
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
	    DISPLAY BY NAME tm.yy ATTRIBUTE(REVERSE)
	    CALL cl_err('',9033,0)
	END IF
	 IF tm.bm IS NULL THEN 
	    LET l_sw = 0 
	    DISPLAY BY NAME tm.bm ATTRIBUTE(REVERSE)
	END IF
	IF l_sw = 0 THEN 
	    LET l_sw = 1 
	    NEXT FIELD a
	    CALL cl_err('',9033,0)
	END IF
	 IF tm.d = '1' THEN LET g_unit = 1 END IF
	 IF tm.d = '2' THEN LET g_unit = 1000 END IF
	 IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(a) 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_mai"                                 
                 LET g_qryparam.default1 = tm.a                    
                #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740048  #No.TQC-C50042   Mark
                 LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                 CALL cl_create_qry() RETURNING tm.a             
                 DISPLAY tm.a TO a                           
                 NEXT FIELD a 
           WHEN INFIELD(b) 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aaa"                                 
                 LET g_qryparam.default1 = tm.b                    
                 CALL cl_create_qry() RETURNING tm.b             
                 DISPLAY tm.b TO b                           
            NEXT FIELD b
           WHEN INFIELD(p) 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_azi"                                 
                 LET g_qryparam.default1 = tm.p                    
                 CALL cl_create_qry() RETURNING tm.p             
                 DISPLAY tm.p TO p                           
            NEXT FIELD p
#        WHEN INFIELD(budget)                  #FUN-810069
#                CALL cl_init_qry_var()        #FUN-810069                                 
#                LET g_qryparam.form ="q_afa"  #FUN-810069                               
#                LET g_qryparam.default1 = tm.budget          #FUN-810069          
#                LET g_qryparam.arg1 = tm.b    #No.FUN-740048 #FUN-810069
#                CALL cl_create_qry() RETURNING tm.budget     #FUN-810069            
#                DISPLAY tm.budget TO budget   #FUN-810069                        
#           NEXT FIELD budget                  #FUN-810069
#FUN-AB0020 --------------start--------------------
          WHEN INFIELD(afc01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_azf'    
             LET g_qryparam.default1 = tm.afc01
             LET g_qryparam.arg1 = '2'        
             CALL cl_create_qry() RETURNING tm.afc01
             DISPLAY BY NAME tm.afc01
             NEXT FIELD afc01
#FUN-AB0020 ---------------end--------------------
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
 
      #-----TQC-740001--------- 
      ON ACTION locale
         CALL cl_dynamic_locale()
      #-----END TQC-740001-----
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r111_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
	     WHERE zz01='abgr111'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
	 CALL cl_err('abgr111','9031',1)
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
			 " '",tm.b CLIPPED,"'",   #TQC-610054
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.bm CLIPPED,"'",
                      " '",tm.afc01 CLIPPED,"'",         #FUN-AB0020
#                     " '",tm.budget CLIPPED,"'",   #TQC-610054 #FUN-810069
                      " '",tm.c CLIPPED,"'",
                      " '",tm.d CLIPPED,"'",
                      " '",tm.e CLIPPED,"'",
                      " '",tm.f CLIPPED,"'",
                      " '",tm.h CLIPPED,"'",
                      " '",tm.o CLIPPED,"'",
                      " '",tm.r CLIPPED,"'",   #TQC-610054
                      " '",tm.p CLIPPED,"'",
                      " '",tm.q CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
	 CALL cl_cmdat('abgr111',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r111()
   ERROR ""
END WHILE
   CLOSE WINDOW r111_w
END FUNCTION
 
FUNCTION r111()
   DEFINE l_name    LIKE type_file.chr20   #No.FUN-680061  VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0056
   DEFINE l_sql     LIKE type_file.chr1000 # RDSQL STATEMENT  #No.FUN-680061  VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1    #No.FUN-680061  VARCHAR(1) 
   DEFINE l_za05    LIKE type_file.chr1000 #No.FUN-680061  VARCHAR(40)
   DEFINE amt1      LIKE type_file.num20_6 #No.FUN-680061  DEC(20,6)
   DEFINE per1      LIKE con_file.con06    #No.FUN-680061  DEC(8,3)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_last    LIKE type_file.num5    #No.FUN-680061  SMALLINT
   DEFINE l_diff    LIKE type_file.num5    #No.FUN-680061  SMALLINT
   DEFINE sr  RECORD
	      bal1      LIKE type_file.num20_6 #No.FUN-680061  DEC(20,6)
	      END RECORD
   DEFINE prt_l ARRAY[1500] OF RECORD          #--- 陣列 for 資產類 (左)
		maj20   LIKE maj_file.maj20,   #No.FUN-680061 VARCHAR(40) 
		bal     LIKE type_file.chr20,  #No.FUN-680061 VARCHAR(20)
		per     LIKE cre_file.cre08,   #No.FUN-680061 VARCHAR(10)
		maj03   LIKE maj_file.maj03    #No.FUN-680061  VARCHAR(1)
		END RECORD
   DEFINE prt_r ARRAY[1500] OF RECORD          #--- 陣列 for 負債&業主權益類 (右)
		maj20   LIKE maj_file.maj20,   #No.FUN-680061 VARCHAR(40)                                                                                     
                bal     LIKE type_file.chr20,  #No.FUN-680061 VARCHAR(20)                                                                                      
                per     LIKE cre_file.cre08,   #No.FUN-680061 VARCHAR(10)                                                                                      
                maj03   LIKE maj_file.maj03    #No.FUN-680061 VARCHAR(1) 
		END RECORD
   DEFINE tmp RECORD
	      maj20_1  LIKE maj_file.maj20,   #No.FUN-680061 VARCHAR(40)                                                                                    
              bal_1    LIKE type_file.chr20,  #No.FUN-680061 VARCHAR(20)                                                                                      
              per_1    LIKE cre_file.cre08,   #No.FUN-680061 VARCHAR(10)                                                                                     
              maj03_1  LIKE maj_file.maj03,   #No.FUN-680061 VARCHAR(1)
	      maj20_r  LIKE maj_file.maj20,   #No.FUN-680061  VARCHAR(40)
	      bal_r    LIKE type_file.chr20,  #No.FUN-680061 VARCHAR(20)
	      per_r    LIKE cre_file.cre08,   #No.FUN-680061 VARCHAR(10)
	      maj03_r  LIKE maj_file.maj03    #No.FUN-680061 VARCHAR(1)
	      END RECORD
 
   DROP TABLE tmp_file
#No.FUN-680061----------------begin---------------------
   CREATE TEMP TABLE tmp_file(
     maj20_l    LIKE maj_file.maj20,
     bal_l      LIKE type_file.chr20, 
     per_l      LIKE cre_file.cre08,
     maj03_l    LIKE maj_file.maj03,
     maj20_r    LIKE maj_file.maj20,
     bal_r      LIKE type_file.chr20, 
     per_r      LIKE cre_file.cre08,
     maj03_r    LIKE maj_file.maj03)
#No.FUN-680061----------------end-----------------------
     #str FUN-750025 add
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
	    AND aaf02 = g_rlang
 
     LET l_sql = "SELECT * FROM maj_file ",
		 " WHERE maj01 = '",tm.a,"' ",
		 "   AND maj23[1,1]='1' ",
		 " ORDER BY maj02"
     PREPARE r111_p FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM 
     END IF
     DECLARE r111_c CURSOR FOR r111_p
 
     FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
 
     #CALL cl_outnam('abgr111') RETURNING l_name
     #START REPORT r111_rep TO l_name
     FOREACH r111_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       FOR i = 1 TO maj.maj04
	   IF maj.maj23[2,2]='2' THEN  
              LET r_row=r_row+1
	   ELSE
	      LET l_row=l_row+1
	   END IF
       END FOR
       LET amt1 = 0
       IF NOT cl_null(maj.maj21) THEN
#FUN-AB0020  ---------------start-------------------------
       IF NOT cl_null(tm.afc01) THEN
         IF maj.maj24 IS NULL THEN
	        SELECT SUM(afc06) INTO amt1 FROM afc_file
            	WHERE afc00 = tm.b
                 AND afc01 = tm.afc01      
            	  AND afc02 BETWEEN maj.maj21 AND maj.maj22
            	  AND afc03 = tm.yy AND afc05 <= tm.bm
                  AND afc04 = ' ' AND afc042 = ' '
	   ELSE
	     SELECT SUM(afc06) INTO amt1 FROM afc_file,afb_file
                WHERE afb00 = afc00  AND afb01 = afc01 
                  AND afb02 = afc02  AND afb03 = afc03
                  AND afb04 = afc04 
		          AND afc00 = tm.b
                 AND afc01 = tm.afc01     
		  AND afc02 BETWEEN maj.maj21 AND maj.maj22
		  AND afc041 BETWEEN maj.maj24 AND maj.maj25       
		  AND afc03 = tm.yy AND afc05 <= tm.bm
                  AND afc041 = afb041 AND afc042 = afb042  
                  AND afb04 = ' ' AND afb042 = ' '   
                  AND afbacti = 'Y'                            #FUN-D70090 add
	    END IF
	    IF STATUS THEN 
           CALL cl_err3("sel","afc_file,afb_file",tm.b,'',STATUS,"","sel afc:",1)          
	       EXIT FOREACH 
        END IF
      ELSE
#FUN-AB0020  --------------------end ----------------------------       
	    IF maj.maj24 IS NULL THEN
	     SELECT SUM(afc06) INTO amt1 FROM afc_file
            	WHERE afc00 = tm.b
#                 AND afc01 = tm.budget      #FUN-810069
            	  AND afc02 BETWEEN maj.maj21 AND maj.maj22
            	  AND afc03 = tm.yy AND afc05 <= tm.bm
                 #AND afc041 = ' ' AND afc042 = ''       #FUN-810069 #CHI-A40063 mod ' '  #CHI-A20007 mark
                  AND afc04 = ' ' AND afc042 = ' '     #CHI-A20007 add  
                 #AND afc04 = '@' #整體                #CHI-A20007 mark
	  ELSE
	     SELECT SUM(afc06) INTO amt1 FROM afc_file,afb_file
                WHERE afb00 = afc00  AND afb01 = afc01 
                  AND afb02 = afc02  AND afb03 = afc03
                  AND afb04 = afc04 
                 #AND afb15 = '2'           #部門預算       #CHI-A20007 mark
		  AND afc00 = tm.b
#                 AND afc01 = tm.budget     #FUN-810069
		  AND afc02 BETWEEN maj.maj21 AND maj.maj22
		 #AND afc04 BETWEEN maj.maj24 AND maj.maj25        #CHI-A20007 mark
		  AND afc041 BETWEEN maj.maj24 AND maj.maj25       #CHI-A20007 add
		  AND afc03 = tm.yy AND afc05 <= tm.bm
                  AND afc041 = afb041 AND afc042 = afb042    #FUN-810069
                 #AND afb041 = ' ' AND afb042 = ' '      #FUN-810069  #CHI-A40036 mod ' '  #CHI-A20007 mark
                  AND afb04 = ' ' AND afb042 = ' '     #CHI-A20007 add  
                  AND afbacti = 'Y'                            #FUN-D70090 add
	  END IF
	  IF STATUS THEN 
#	  CALL cl_err('sel afc:',STATUS,1) #FUN-660105
#         CALL cl_err3("sel","afc_file,afb_file",tm.b,tm.budget,STATUS,"","sel afc:",1) #FUN-660105 #FUN-810069
          CALL cl_err3("sel","afc_file,afb_file",tm.b,'',STATUS,"","sel afc:",1)           #FUN-810069  
	  EXIT FOREACH END IF
      END IF                            #FUN-AB0020   add
	  IF amt1 IS NULL THEN LET amt1 = 0 END IF
       END IF
       IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF      #匯率的轉換
       IF maj.maj03 MATCHES "[012349]" AND maj.maj08 > 0     #合計階數處理
	  THEN FOR i = 1 TO 100 LET g_tot1[i]=g_tot1[i]+amt1 END FOR
	       LET k=maj.maj08  LET sr.bal1=g_tot1[k]
	       FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
	  ELSE  
            IF maj.maj03='5' THEN
               LET sr.bal1=amt1
            ELSE
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
	  maj.maj03 MATCHES "[0125]" AND sr.bal1=0 THEN      #CHI-CC0023 add maj03 match 5
	  CONTINUE FOREACH                                   #餘額為 0 者不列印
       END IF
       IF tm.f>0 AND maj.maj08 < tm.f THEN
	  CONTINUE FOREACH                                   #最小階數起列印
       END IF
     
       IF maj.maj07='2' THEN LET sr.bal1=sr.bal1*-1 END IF
       IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
       #-------TSD.liquor add 070829---------
       IF cl_null(sr.bal1) THEN
          LET sr.bal1 = 0
       END IF
       IF cl_null(g_basetot1) THEN
          LET g_basetot1 = 0
       END IF
       #-------TSD.liquor add end------------
       LET per1 = (sr.bal1 / g_basetot1) * 100
       IF tm.d MATCHES '[23]' THEN LET sr.bal1=sr.bal1/g_unit END IF
 
       IF maj.maj23[2,2]='2' THEN  
	  LET r_row=r_row+1
#  modified by Thomas 97/04/08 縮格控制
	  LET prt_r[r_row].maj20=maj.maj05 SPACES,maj.maj20 
					#-- 右邊(負債&業主權益)
	  # LET prt_r[r_row].maj20=maj.maj20      #--- 右邊 (負債&業主權益)
	  LET prt_r[r_row].bal=cl_numfor(sr.bal1,18,tm.e) 
	  LET prt_r[r_row].per=per1 USING '----&.&& %'
       ELSE
	  LET l_row=l_row+1
#  modified by Thomas 97/04/08 縮格控制
	  LET prt_l[l_row].maj20= maj.maj05 SPACES, maj.maj20   #--- 左邊 (資產)
	  # LET prt_l[l_row].maj20=maj.maj20      #--- 左邊 (資產)
	  LET prt_l[l_row].bal=cl_numfor(sr.bal1,18,tm.e) 
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
		 ####LET r_row=r_row+1                              #FUN-750025  
                    LET r_row = r_row - 1                           #FUN-750025 
		    LET prt_r[r_row].maj03='3'                      #FUN-750025
		    #LET prt_r[r_row].bal='------------------'      #FUN-750025    
		    #LET prt_r[r_row].per='----------'              #FUN-750025  
		 ELSE                                               
		 ####LET l_row=l_row+1                              #FUN-750025 
		    LET l_row=l_row-1                               #FUN-750025
		    LET prt_l[l_row].maj03='3'                      #FUN-750025
		    #LET prt_l[l_row].bal='------------------'      #FUN-750025    
		    #LET prt_l[l_row].per='----------'              #FUN-750025     
		 END IF
	    WHEN maj.maj03 = '4' 
		 IF maj.maj23[2,2]='2' THEN  
		    #LET r_row=r_row+1                              #FUN-750025
		    LET prt_r[r_row].maj03='4'                      #FUN-750025
		    #LET prt_r[r_row].maj20='--------------------', #FUN-750025
		    #			   '--------------------'   #FUN-750025
		    #LET prt_r[r_row].bal='------------------'      #FUN-750025
		    #LET prt_r[r_row].per='----------'              #FUN-750025
		 ELSE
		    #LET l_row=l_row+1                              #FUN-750025
		    LET prt_l[l_row].maj03='4'                      #FUN-750025
		    #LET prt_l[l_row].maj20='--------------------', #FUN-750025
		    #			   '--------------------'   #FUN-750025
		    #LET prt_l[l_row].bal='------------------'      #FUN-750025  
		    #LET prt_l[l_row].per='----------'              #FUN-750025 
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
               IF r_row>0 THEN   #FUN-750025 add
                  LET prt_r[i].* = prt_r[r_row].*
                  INITIALIZE prt_r[l_diff].* TO NULL
                  EXIT FOR
               END IF            #FUN-750025 add
            END IF
        END FOR
     END IF
     IF l_row=r_row THEN 
        LET l_last=l_row LET l_diff =r_row  
        FOR i = l_last TO 1 step -1
            IF prt_l[i].maj20 IS NOT NULL AND prt_l[i].maj20 <> ' ' THEN
               IF r_row>0 THEN   #FUN-750025 add
                  LET prt_r[i].* = prt_r[r_row].*
          #       INITIALIZE prt_r[l_diff].* TO NULL
                  EXIT FOR
               END IF            #FUN-750025 add
            END IF
        END FOR
     END IF
     IF r_row>l_row THEN 
        LET l_last=r_row LET l_diff =l_row
        FOR i = l_last TO 1 step -1
            IF prt_r[i].maj20 IS NOT NULL AND prt_r[i].maj20 <> ' ' THEN
               IF r_row>0 THEN   #FUN-750025 add
                  LET prt_l[i].* = prt_l[l_row].*
                  INITIALIZE prt_l[l_diff].* TO NULL
                  EXIT FOR
               END IF            #FUN-750025 add
            END IF
        END FOR
     END IF
##-------------------------------
     FOR i=1 TO l_last
         IF prt_l[i].maj03 = 'H'  THEN 
            LET prt_l[i].per= ' '
            LET prt_r[i].per= ' '
         ELSE 
            LET per1 = (prt_l[i].bal / g_basetot1) * 100
            LET prt_l[i].per=per1 USING '----&.&& %'
            LET per1 = (prt_r[i].bal / g_basetot1) * 100
            LET prt_r[i].per=per1 USING '----&.&& %'
         END IF 
	 INSERT INTO tmp_file 
		VALUES(prt_l[i].maj20,prt_l[i].bal,prt_l[i].per,prt_l[i].maj03,
		       prt_r[i].maj20,prt_r[i].bal,prt_r[i].per,prt_r[i].maj03)
     END FOR
 
     DECLARE r111_c1 CURSOR FOR SELECT * FROM tmp_file
     FOREACH r111_c1 INTO tmp.*
        EXECUTE insert_prep USING tmp.maj20_1,tmp.bal_1,tmp.per_1,tmp.maj03_1,
                                  tmp.maj20_r,tmp.bal_r,tmp.per_r,tmp.maj03_r
     END FOREACH
 
     #FINISH REPORT r111_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #str FUN-750025 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = tm.a,";",tm.p,";",tm.d,";",tm.yy USING '<<<<','/', tm.bm USING '&&'
     CALL cl_prt_cs3('abgr111','abgr111',g_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     #end FUN-750025 add
END FUNCTION
 
FUNCTION r111_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680061  VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("p,q",TRUE)
#   END IF
 
END FUNCTION
 
FUNCTION r111_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680061  VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       IF tm.o = 'N' THEN
           CALL cl_set_comp_entry("p,q",FALSE)
       END IF
#   END IF
 
END FUNCTION
