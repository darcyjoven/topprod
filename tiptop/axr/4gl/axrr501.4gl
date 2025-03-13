# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr501.4gl
# Descriptions...: 客戶應收明細帳(彙總)
# Date & Author..: 95/02/22 by Nick
# Modify.........: 97/08/28 By Sophia 新增帳別(ooo11)
# Modify.........: No.MOD-4B0001 04/11/01 By ching 排除未確認,作廢
# Modify.........: No.FUN-4C0100 04/12/29 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550071 05/05/27 By yoyo單據編號格式放大
# Modify.........: No.TQC-5B0042 05/11/08 By kim 報表日期欄位出現星號
# Modify.........: No.TQC-5B0083 05/11/29 By Smapmin 日期欄位出現*號
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng 修改報表格式      
# Modify.........: No.MOD-720047 07/02/28 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-750226 07/05/30 By rainy CR未列印年度期別
# Modify.........: No.MOD-7C0080 07/12/12 By Smapmin 變數DEFINE 錯誤
#                                                    類別應BY 語言別顯示
# Modify.........: No.FUN-8C0009 08/12/23 By xiaofeizhu 加入多營運中心
# Modify.........: No.MOD-8C0282 09/01/05 By Sarah r501_cur2的SQL增加ORDER BY npp02,npq01
# Modify.........: No.TQC-920048 09/02/20 By liuxqa 列印時，不應列印出未審核的資料
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.TQC-960406 09/07/06 By chenmoyan 改變npp02的定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No.MOD-A40071 10/04/13 By sabrina 將npp02欄位型態為date
# Modify.........: No:TQC-A50082 10/05/24 By Carrier join少了aag00的条件
# Modify.........: No:CHI-A70006 10/07/12 By Summer 增加aza63判斷使用s_azmm 
# Modify.........: No.FUN-B20054 10/02/23 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-C40001 12/04/16 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_bdate,g_edate,d	LIKE type_file.dat            #No.FUN-680123 DATE
   DEFINE tm  RECORD                              # Print condition RECORD
              wc       LIKE type_file.chr1000,                #No.FUN-680123 VARCHAR(1000)  # Where condition
              #p       LIKE type_file.chr1,                   #No.FUN-680123 VARCHAR(1)     # Eject sw   #MOD-8C0282 mark
			        y	       LIKE type_file.num5,          #No.FUN-680123 SMALLINT
			        b1	     LIKE type_file.num5,          #No.FUN-680123 SMALLINT
			        b2	     LIKE type_file.num5,          #No.FUN-680123 SMALLINT
			        n	       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
              choice   LIKE type_file.chr1,                   #No.FUN-680123 VARCHAR(1)     #無異動是否印出
              ooo11    like ooo_file.ooo11,	    #FUN-B20054
  ##NO.FUN-A10098  mark--begin
#              b       LIKE type_file.chr1,      #No.FUN-8C0009 VARCHAR(1)
#              p1      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p2      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p3      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p4      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p5      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p6      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p7      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p8      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
  ##NO.FUN-A10098  mark--end
              s       LIKE type_file.chr4,      #No.FUN-8C0009 VARCHAR(4)
              t       LIKE type_file.chr4,      #No.FUN-8C0009 VARCHAR(4)
              u       LIKE type_file.chr4,      #No.FUN-8C0009 VARCHAR(4)              
              more     LIKE type_file.chr1                    #No.FUN-680123 VARCHAR(1)     # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_chr         LIKE type_file.chr1                    #No.FUN-680123 VARCHAR(1)
DEFINE   g_i           LIKE type_file.num5                    #No.FUN-680123 SMALLINT    #count/index for any purpose
DEFINE i               LIKE type_file.num5                    #FUN-8C0009 ADD     
DEFINE l_table        STRING,                   ### CR11 ###
       g_str          STRING,                   ### CR11 ###
       g_sql          STRING                    ### CR11 ###
DEFINE g_Logistics    STRING                    #FUN-8C0009 ADD
  ##NO.FUN-A10098  mark--begin
#DEFINE tok            Base.StringTokenizer      #FUN-8B0009 ADD
DEFINE g_su           LIKE type_file.chr8       #FUN-8B0009 ADD
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8C0009 ARRAY[10]       
  ##NO.FUN-A10098  mark--end       
DEFINE g_bookno1     LIKE aza_file.aza81       #CHI-A70006 add
DEFINE g_bookno2     LIKE aza_file.aza82       #CHI-A70006 add
DEFINE g_flag        LIKE type_file.chr1       #CHI-A70006 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #MOD-720047 - START
   ## *** CR11 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = " ooo01.ooo_file.ooo01, ",             #客戶編號
               " ooo02.ooo_file.ooo02, ",             #客戶簡稱
               " ooo03.ooo_file.ooo03, ",             #科目編號
               " aag02.aag_file.aag02, ",             #科目名稱
               " ooo04.ooo_file.ooo04, ",             #部門
               " gem02.gem_file.gem02, ",             #部門名稱
               " ooo05.ooo_file.ooo05, ",             #幣別
               " azi03.azi_file.azi03, ",
               " azi04.azi_file.azi04, ",
               " azi05.azi_file.azi05, ",
               " amt.ooo_file.ooo08d, ",	      #前期
              #" npp02.npp_file.npp02, ",             #MOD-7C0080
              #" npp02.type_file.chr8, ",             #TQC-960406
               " npp02.npp_file.npp02, ",             #TQC-960406
               " npq01.npq_file.npq01, ",
               " npp00.npp_file.npp00, ",
              #" npp00_desc.npp_file.npp07, ",        #MOD-7C0080         
               " npp00_desc.type_file.chr8, ",        #MOD-7C0080         
               " npq23.npq_file.npq23, ",
               " npq24.npq_file.npq24, ",
               " npq06.npq_file.npq06, ",             #借貸別
               " npq07f.npq_file.npq07f, ",           #原幣
               " npq07.npq_file.npq07, ",             #本幣
               " l_credit.npq_file.npq07f, ",         #借方
               " l_debit.npq_file.npq07f, ",          #貸方
               " l_left.npq_file.npq07f, ",           #餘額 
               " p_tran.type_file.chr1, ",
               " byear.type_file.chr4,",              #年度 #TQC-750226
               " bb.type_file.chr5,",                 #期別 #TQC-750226 00-12
               " plant.azp_file.azp01,",              #FUN-8C0009 加入營運中心
               " ooo11.ooo_file.ooo11,",              #FUN-8C0009 加入帳別               
               " l_npp02.npp_file.npp02,",            #MOD-8C0282 add #排序用
               " l_npq01.npq_file.npq01"              #MOD-8C0282 add #排序用
             
   LET l_table = cl_prt_temptable('axrr501',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"   #TQC-750226 add 2?  #FUN-8C0009 ADD 2?  #MOD-8C0282 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #MOD-720047 - END
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.y = ARG_VAL(8)
   LET tm.b1 = ARG_VAL(9)
   LET tm.b2 = ARG_VAL(10)
   LET tm.n = ARG_VAL(11)
   LET tm.choice = ARG_VAL(12)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.FUN-8C0009 --start--
  ##NO.FUN-A10098  mark--begin
#   LET tm.b     = ARG_VAL(17)
#   LET tok      = base.StringTokenizer.create(ARG_VAL(18),",")
#   LET tm.p1    = tok.nextToken()
#   LET tm.p2    = tok.nextToken()
#   LET tm.p3    = tok.nextToken()
#   LET tm.p4    = tok.nextToken()
#   LET tm.p5    = tok.nextToken()
#   LET tm.p6    = tok.nextToken()
#   LET tm.p7    = tok.nextToken()
#   LET tm.p8    = tok.nextToken()
  ##NO.FUN-A10098  mark--end
   LET tm.s     = ARG_VAL(17)
   #LET tm.t     = ARG_VAL(20)   #FUN-8C0009 MARK
   #LET tm.u     = ARG_VAL(21)   #FUN-8C0009 MARK
   LET g_su     = ARG_VAL(18)
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = g_su[1,1]
   LET tm2.t2   = g_su[2,2]
   LET tm2.t3   = g_su[3,3]
   LET tm2.u1   = g_su[4,4]
   LET tm2.u2   = g_su[5,5]
   LET tm2.u3   = g_su[6,6]
 
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
   LET tm.t = tm2.t1,tm2.t2,tm2.t3
   LET tm.u = tm2.u1,tm2.u2,tm2.u3  #FUN-8C0009 ADD
 
   #No.FUN-8C0009 ---end---   
   IF cl_null(tm.wc)
      THEN CALL axrr501_tm(0,0)             # Input print condition
   ELSE
      CALL axrr501()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr501_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680123 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col =18
   ELSE LET p_row = 5 LET p_col =15
   END IF
   OPEN WINDOW axrr501_w AT p_row,p_col
        WITH FORM "axr/42f/axrr501" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.y=YEAR(TODAY)
   LET tm.b1=1
   LET tm.b2=2
   LET tm.n='1'
  #LET tm.p='2'   #MOD-8C0282 mark
   #FUN-8C0009-Begin--#
   LET tm.s ='12 '
   LET tm.t ='Y  '
   LET tm.u ='Y  '
   LET tm.ooo11 = g_aza.aza81   #FUN-B20054
  ##NO.FUN-A10098  mark--begin
#   LET tm.b ='N'
#   LET tm.p1=g_plant
#   CALL p501_set_entry_1()
#   CALL p501_set_no_entry_1()
#   CALL r501_set_comb()
  ##NO.FUN-A10098  mark--end
   #FUN-8C0009-End--#   
WHILE TRUE
#FUN-B20054--add--str--
   DIALOG ATTRIBUTE(unbuffered)
      INPUT BY NAME tm.ooo11 ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD ooo11 
            IF NOT cl_null(tm.ooo11) THEN
                   CALL s_check_bookno(tm.ooo11,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD ooo11
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.ooo11
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.ooo11,"","agl-043","","",0)
                   NEXT FIELD ooo11
                END IF
            END IF
       END INPUT
#FUN-B20054--add--end--

   CONSTRUCT BY NAME tm.wc ON ooo01,ooo03,ooo04,ooo05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#FUN-B20054--mark--str--
#      ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#  
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#         #No.FUN-580031 ---end---    
#FUN-B20054--mark--end--
 
  END CONSTRUCT
  
  #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030   #FUN-B20054 TO AFTER END DIALOG
  #FUN-B20054--mark--str--
  #     IF g_action_choice = "locale" THEN
  #        LET g_action_choice = ""
  #        CALL cl_dynamic_locale()
  #        CONTINUE WHILE
  #     END IF
  #
	#				 
  # IF INT_FLAG THEN
  #    LET INT_FLAG = 0 CLOSE WINDOW axrr501_w 
  #    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
  #    EXIT PROGRAM
  #       
  # END IF
  #FUN-B20054--mark--end--
  #FUN-B20054--TO AFTER END DIALOG--end--
  #LET tm.choice='N'
  #DISPLAY BY NAME tm.choice
  #IF tm.wc=" 1=1" THEN 
  #   CALL cl_err('','9046',0) CONTINUE WHILE
  #END IF 
  #FUN-B20054--TO AFTER END DIALOG--end--  
  
   INPUT BY NAME tm.y,tm.b1,tm.b2,tm.n,tm.choice,
  ##NO.FUN-A10098  mark--begin
#               tm.b,tm.p1,tm.p2,tm.p3,                          #FUN-8C0009
#               tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,                   #FUN-8C0009
  ##NO.FUN-A10098  mark--end
                tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,       #FUN-8C0009
                tm2.u1,tm2.u2,tm2.u3,                            #FUN-8C0009   
                tm.more 
		#WITHOUT DEFAULTS                                            #FUN-B20054
		ATTRIBUTE(WITHOUT DEFAULTS)                                  #FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD y
         IF cl_null(tm.y) THEN
            NEXT FIELD y
         END IF
      AFTER FIELD b1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.b1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y
            IF g_azm.azm02 = 1 THEN
               IF tm.b1 > 12 OR tm.b1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b1
               END IF
            ELSE
               IF tm.b1 > 13 OR tm.b1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b1
               END IF
            END IF
         END IF
#         IF cl_null(tm.b1) OR tm.b1<1 OR tm.b1>13 THEN
#            NEXT FIELD b1
#         END IF
#No.TQC-720032 -- end --
      AFTER FIELD b2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.b2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y
            IF g_azm.azm02 = 1 THEN
               IF tm.b2 > 12 OR tm.b2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b2
               END IF
            ELSE
               IF tm.b2 > 13 OR tm.b2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b2
               END IF
            END IF
         END IF
#         IF cl_null(tm.b2) OR tm.b2<tm.b1 OR tm.b2 >13 THEN
#            NEXT FIELD b2
#         END IF
#No.TQC-720032 -- end --
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[12]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD choice 
         IF cl_null(tm.choice) OR tm.choice NOT MATCHES '[YN]' THEN 
              NEXT FIELD choice 
         END IF
         
      #FUN-8C0009--Begin--#
  ##NO.FUN-A10098  mark--begin
#      AFTER FIELD b
#         IF NOT cl_null(tm.b)  THEN
#            IF tm.b NOT MATCHES "[YN]" THEN
#               NEXT FIELD b
#            END IF
#         END IF
#      ON CHANGE  b
#         LET tm.p1=g_plant
#         LET tm.p2=NULL
#         LET tm.p3=NULL
#         LET tm.p4=NULL
#         LET tm.p5=NULL
#         LET tm.p6=NULL
#         LET tm.p7=NULL
#         LET tm.p8=NULL
#         DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8
#         CALL p501_set_entry_1()
#         CALL p501_set_no_entry_1()
#         CALL r501_set_comb()
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)
#            NEXT FIELD p1
#         END IF
#         #No.FUN-940102--begin    
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1          
#            END IF  
#         END IF              
#         #No.FUN-940102--end
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)
#               NEXT FIELD p2
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#            #No.FUN-940102--end
#         END IF
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)
#               NEXT FIELD p3
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#            #No.FUN-940102--end 
#         END IF
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)
#               NEXT FIELD p4
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#            #No.FUN-940102--end 
#         END IF
#       AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)
#               NEXT FIELD p5
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#            #No.FUN-940102--end 
#         END IF
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)
#               NEXT FIELD p6
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#            #No.FUN-940102--end 
#         END IF
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1)
#               NEXT FIELD p7
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#            #No.FUN-940102--end 
#         END IF
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)
#               NEXT FIELD p8
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#            #No.FUN-940102--end 
#         END IF
  ##NO.FUN-A10098  mark--end
      #FUN-8C0009--End--#         
          
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT 
         IF tm.choice IS NULL THEN NEXT FIELD choice END IF
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]     #FUN-8C0009 ADD
         LET tm.t = tm2.t1,tm2.t2,tm2.t3                    #FUN-8C0009 ADD
         LET tm.u = tm2.u1,tm2.u2,tm2.u3                    #FUN-8C0009 ADD          
################################################################################
# START genero shell script ADD
   #FUN-B20054--mark--str--
   #ON ACTION CONTROLR
   #   CALL cl_show_req_fields()
   ##FUN-B20054--mark--end--
# END genero shell script ADD
################################################################################
#FUN-B20054--mark--str--
#      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#      
#     #FUN-8C0009  ADD  STR------------------------------------
#      ON ACTION CONTROLP
#FUN-B20054--mark--end--  
##NO.FUN-A10098  mark--begin
#        CASE
#            WHEN INFIELD(p1)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p1
#               CALL cl_create_qry() RETURNING tm.p1
#               DISPLAY BY NAME tm.p1
#               NEXT FIELD p1
#            WHEN INFIELD(p2)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p2
#               CALL cl_create_qry() RETURNING tm.p2
#               DISPLAY BY NAME tm.p2
#               NEXT FIELD p2
#            WHEN INFIELD(p3)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p3
#               CALL cl_create_qry() RETURNING tm.p3
#               DISPLAY BY NAME tm.p3
#               NEXT FIELD p3
#            WHEN INFIELD(p4)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p4
#               CALL cl_create_qry() RETURNING tm.p4
#               DISPLAY BY NAME tm.p4
#               NEXT FIELD p4
#            WHEN INFIELD(p5)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p5
#               CALL cl_create_qry() RETURNING tm.p5
#               DISPLAY BY NAME tm.p5
#               NEXT FIELD p5
#            WHEN INFIELD(p6)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p6
#               CALL cl_create_qry() RETURNING tm.p6
#               DISPLAY BY NAME tm.p6
#               NEXT FIELD p6
#            WHEN INFIELD(p7)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p7
#               CALL cl_create_qry() RETURNING tm.p7
#               DISPLAY BY NAME tm.p7
#               NEXT FIELD p7
#            WHEN INFIELD(p8)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p8
#               CALL cl_create_qry() RETURNING tm.p8
#               DISPLAY BY NAME tm.p8
#               NEXT FIELD p8
#         END CASE
  ##NO.FUN-A10098  mark--end
      #FUN-8C0009  ADD  END------------------------------------      
      
      #FUN-B20054--mark--str--
      #ON IDLE g_idle_seconds
      #   CALL cl_on_idle()
      #   CONTINUE INPUT
      #
      #ON ACTION about         #MOD-4C0121
      #   CALL cl_about()      #MOD-4C0121
      #
      #ON ACTION help          #MOD-4C0121
      #   CALL cl_show_help()  #MOD-4C0121
      #
      #
      #    ON ACTION exit
      #    LET INT_FLAG = 1
      #    EXIT INPUT
      #   #No.FUN-580031 --start--
      #   ON ACTION qbe_save
      #      CALL cl_qbe_save()  
      #FUN-B20054--mark--end--
         #No.FUN-580031 ---end---
 
   END INPUT   
   
   #FUN-B20054--add--str--
      ON ACTION CONTROLP
          CASE  
             WHEN INFIELD(ooo11)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = tm.ooo11
                CALL cl_create_qry() RETURNING tm.ooo11
                DISPLAY tm.ooo11 TO FORMONLY.ooo11
                NEXT FIELD ooo11
             WHEN INFIELD(ooo03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.ooo11 CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ooo03
                NEXT FIELD ooo03
             #No.FUN-C40001  --Begin
              WHEN INFIELD(ooo01) #客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo01
                 NEXT FIELD ooo01
              WHEN INFIELD(ooo04) #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo04
                 NEXT FIELD ooo04
              WHEN INFIELD(ooo05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo05
                 NEXT FIELD ooo05
             #No.FUN-C40001  --End
         END CASE
          
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT DIALOG

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG

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
    #FUN-B20054--add--end
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr501_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null)    #FUN-B20054 
   IF tm.wc=" 1=1" THEN                                       #FUN-B20054
     CALL cl_err('','9046',0) CONTINUE WHILE                  #FUN-B20054
   END IF                                                     #FUN-B20054
   
	#  CALL s_azm(tm.y,tm.b1) RETURNING g_chr,g_bdate,d #CHI-A70006 mark
	#  CALL s_azm(tm.y,tm.b2) RETURNING g_chr,d,g_edate #CHI-A70006 mark
   #CHI-A70006 add --start--
    CALL s_get_bookno(tm.y)
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y,tm.b1,g_plant,g_bookno1) RETURNING g_chr,g_bdate,d
      CALL s_azmm(tm.y,tm.b2,g_plant,g_bookno1) RETURNING g_chr,d,g_edate
   ELSE
      CALL s_azm(tm.y,tm.b1) RETURNING g_chr,g_bdate,d
      CALL s_azm(tm.y,tm.b2) RETURNING g_chr,d,g_edate
   END IF
   #CHI-A70006 add --end--
	#	由 年度,期別CALL s_azm 傳回 1.有效否,2.起始日期,3.截止日期
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr501'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr501','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         #FUN-8C0009 ADD g_Logistics,g_su
#        LET g_Logistics = tm.p1,",",tm.p2,",",tm.p3,",",tm.p4,",",tm.p5,",",     #FUN-8C0009
#                          tm.p6,",",tm.p7,",",tm.p8                              #FUN-8C0009
         LET g_su = tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3                     #FUN-8C0009
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.y CLIPPED,"'" ,
                         " '",tm.b1 CLIPPED,"'" ,
                         " '",tm.b2 CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",tm.choice CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
  ##NO.FUN-A10098  mark--begin
#                        " '",tm.b CLIPPED,"'" ,                #FUN-8C0009
#                        " '",g_Logistics clipped,"'" ,         #FUN-8C0009
   ##NO.FUN-A10098  mark--end
                         " '",tm.s CLIPPED,"'" ,                #FUN-8C0009
                         " '",g_su CLIPPED,"'"                  #FUN-8C0009                          
                         
         CALL cl_cmdat('axrr501',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr501_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr501()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr501_w
END FUNCTION
 
FUNCTION axrr501()
   DEFINE l_name       LIKE type_file.chr20,      #No.FUN-680123 VARCHAR(20)      # External(Disk) file name
#         l_time       LIKE type_file.chr8        #No.FUN-6A0095
          l_sql        LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(1000)
         #l_npp00_desc LIKE npp_file.npp07,       #CR11   #MOD-7C0080
          l_npp00_desc LIKE type_file.chr8,       #CR11   #MOD-7C0080
          l_amt_keep   LIKE npq_file.npq07f,      #CR11 Keep amt1
          l_cnt        LIKE type_file.num5,       #No.FUN-680123 SMALLINT
          l_za05       LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(40) 
          l_conf       LIKE oma_file.omaconf,
          l_void       LIKE oma_file.omavoid,
          l_ooaconf    LIKE ooa_file.ooaconf,     #No.TQC-920048 add by liuxqa 
          l_order      ARRAY[5] OF LIKE ooo_file.ooo02,  #No.FUN-680123 VARCHAR(20)
          l_credit     LIKE npq_file.npq07f,
          l_debit      LIKE npq_file.npq07f,
         #l_npp02      LIKE type_file.chr8,              #No.FUN-680123 VARCHAR(8)   #TQC-5B0083   #MOD-A40071 mark
          l_npp02      LIKE npp_file.npp02,              #MOD-A40071 add 
          sr           RECORD        
	                ooo01   LIKE ooo_file.ooo01,     #客戶編號
	                ooo02   LIKE ooo_file.ooo02,     #客戶簡稱
                        ooo03   LIKE ooo_file.ooo03,     #科目編號
                        aag02   LIKE aag_file.aag02,     #科目名稱
	                ooo04	LIKE ooo_file.ooo04,     #部門
	                gem02	LIKE gem_file.gem02,     #部門名稱
                        ooo05	LIKE ooo_file.ooo05,     #幣別
	                azi03	LIKE azi_file.azi03,
	                azi04	LIKE azi_file.azi04,
	                azi05	LIKE azi_file.azi05,
                        amt     LIKE ooo_file.ooo08d,    #前期(原幣)
                        a1      LIKE type_file.num20_6,  #MOD-8C0282 add  #本幣
                        ooo11   LIKE ooo_file.ooo11      #FUN-8C0009 ADD
                       END RECORD,
          sr2          RECORD        
# Prog. Version..: '5.30.06-13.03.12(08),                #TQC-5B0083
                        npp02	LIKE npp_file.npp02,     #TQC-5B0083
	                npq01	LIKE npq_file.npq01,
	                npp00	LIKE npp_file.npp00,
	                npq23	LIKE npq_file.npq23,
	                npq24	LIKE npq_file.npq24,
	                npq06	LIKE npq_file.npq06,
	                npq07f  LIKE npq_file.npq07f,
	                npq07	LIKE npq_file.npq07,
                        l_npp02 LIKE npp_file.npp02,     #MOD-8C0282 add
                        l_npq01 LIKE npq_file.npq01      #MOD-8C0282 add
                       END RECORD 
   DEFINE l_bb         LIKE type_file.chr5               #TQC-750226 起迄期別
   DEFINE l_i          LIKE type_file.num5               #No.FUN-8C0009 SMALL
   DEFINE l_dbs        LIKE azp_file.azp03               #No.FUN-8C0009
   DEFINE l_azp03      LIKE azp_file.azp03               #No.FUN-8C0009  
 
   #MOD-720047 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #MOD-720047 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720014 add
  ##NO.FUN-A10098  mark--begin 
   #FUN-8C0009--Begin--#
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
   #FUN-8C0009--End--#
  ##NO.FUN-A10098  mark--end 
   #CALL s_azm(tm.y,tm.b1) RETURNING g_chr,g_bdate,d                          #FUN-8C0009 ADD #CHI-A70006 mark
   #CALL s_azm(tm.y,tm.b2) RETURNING g_chr,d,g_edate                          #FUN-8C0009 ADD #CHI-A70006 mark
   #CHI-A70006 add --start--
    CALL s_get_bookno(tm.y)
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y,tm.b1,g_plant,g_bookno1) RETURNING g_chr,g_bdate,d
      CALL s_azmm(tm.y,tm.b2,g_plant,g_bookno1) RETURNING g_chr,d,g_edate
   ELSE
      CALL s_azm(tm.y,tm.b1) RETURNING g_chr,g_bdate,d
      CALL s_azm(tm.y,tm.b2) RETURNING g_chr,d,g_edate
   END IF
   #CHI-A70006 add --end--
  ##NO.FUN-A10098  mark--begin 
#   FOR l_i = 1 to 8                                                          #FUN-8C0009
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                        #FUN-8C0009
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]           #FUN-8C0009
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)                                          #FUN-8C0009
  ##NO.FUN-A10098  mark--end 
   LET l_sql="SELECT ",
             "       ooo01,ooo02,ooo03,aag02,ooo04,gem02,ooo05,",
             "       azi03,azi04,azi05,",
             "       SUM(ooo08d-ooo08c),ooo11,SUM(ooo09d-ooo09c) ",          #FUN-8C0009 ADD ooo11
            #" FROM ooo_file,gem_file,aag_file,azi_file",  #FUN-8C0009 MARK
  ##NO.FUN-A10098  mark--begin
#             "  FROM ",l_dbs CLIPPED,"ooo_file,",                            #FUN-8C0009 ADD
#             " OUTER ",l_dbs CLIPPED,"gem_file,",                            #FUN-8C0009 ADD
#             " OUTER ",l_dbs CLIPPED,"aag_file,",                            #FUN-8C0009 ADD
#             " OUTER ",l_dbs CLIPPED,"azi_file ",                            #FUN-8C0009 ADD             
              "  FROM ooo_file LEFT OUTER join gem_file ON  ooo_file.ooo04=gem_file.gem01 ",
              "  LEFT OUTER join aag_file ON ooo_file.ooo03=aag_file.aag01 AND ooo_file.ooo11 = aag_file.aag00",   #No.TQC-A50082
              "  LEFT OUTER join azi_file ON azi_file.azi01=ooo_file.ooo05",
  ##NO.FUN-A10098  mark--end 
#            " WHERE ooo_file.ooo04=gem_file.gem01 AND ooo_file.ooo03=aag_file.aag01 AND ",tm.wc CLIPPED,
#              " AND azi_file.azi01=ooo_file.ooo05 ",
             " WHERE  ",tm.wc CLIPPED,    
             " AND ooo06 =",tm.y," AND ooo07 <= ",tm.b2,
             " GROUP BY ooo01,ooo02,ooo03,aag02,ooo04,gem02,ooo05,azi03,azi04,azi05,ooo11 "   #FUN-8C0009 ADD ooo11
#             " GROUP BY 1,2,3,4,5,6,7,8,9,10"   #CR11
   LET l_sql= l_sql CLIPPED 
   PREPARE axrr501_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   DECLARE axrr501_curs1 CURSOR FOR axrr501_prepare1
 
   LET g_pageno = 0
   FOREACH axrr501_curs1 INTO sr.*     #MOD-8C0282 mod
      IF STATUS THEN CALL cl_err('fore1:',STATUS,1) EXIT FOREACH END IF
               
      #FUN-8C0009 MARK STR--------------------------------------------
      #SELECT SUM(ooo08d-ooo08c),SUM(ooo09d-ooo09c) INTO sr.amt, a1
      #        FROM ooo_file
      #       WHERE ooo01=sr.ooo01 AND ooo02=sr.ooo02
      #         AND ooo03=sr.ooo03 AND ooo04=sr.ooo04
      #         AND ooo05=sr.ooo05
      #         AND ooo06=tm.y AND ooo07<tm.b1
      #FUN-8C0009 MARK END--------------------------------------------
      #FUN-8C0009  ADD  STR----------------------------------------
       LET l_sql=" SELECT SUM(ooo08d-ooo08c),SUM(ooo09d-ooo09c)  ",
  ##NO.FUN-A10098  mark--begin
#                "   FROM ",l_dbs CLIPPED,"ooo_file",
                 "   FROM ooo_file",
  ##NO.FUN-A10098  mark--end 
                 "  WHERE ooo01='",sr.ooo01,"'",
                 "    AND ooo02='",sr.ooo02,"'",
                 "    AND ooo03='",sr.ooo03,"'",
                 "    AND ooo04='",sr.ooo04,"'",
                 "    AND ooo05='",sr.ooo05,"'",
                 "    AND ooo06=",tm.y,
                 "    AND ooo07<",tm.b1
       PREPARE ooo_prepare2 FROM l_sql
       DECLARE ooo_c2  CURSOR FOR ooo_prepare2
       OPEN ooo_c2
       FETCH ooo_c2 INTO sr.amt,sr.a1   #MOD-8C0282 mod
      #FUN-8C0009  ADD  END----------------------------------------               
               
      IF tm.n = '2' THEN LET sr.amt=sr.a1 END IF   #幣別判斷  #MOD-8C0282 mod
      IF sr.amt IS NULL THEN LET sr.amt=0 END IF
      LET l_cnt = 0 
 
      LET l_amt_keep = sr.amt   #MOD-720047 add
            
      #FUN-8C0009 MARK STR------------------------------------------
      #DECLARE r501_cur2 CURSOR FOR
      #   SELECT npp02,npq01,npp00,npq23,npq24,npq06,npq07f,npq07
      #     FROM npq_file,npp_file
      #    WHERE npq03=sr.ooo03 AND npq05=sr.ooo04 AND npp02>=g_bdate
      #      AND npp02<=g_edate AND npq24=sr.ooo05 
      #      AND npq21=sr.ooo01
      #      AND nppsys=npqsys AND npp00=npq00 AND npp01=npq01 
      #      AND npp011=npq011 AND  nppsys='AR' 
      #FUN-8C0009 MARK END-----------------------------------------
      #FUN-8C0009 ADD ---------------------------------------------
  ##NO.FUN-A10098  --begin
      IF sr.ooo04 =' ' OR cl_null(sr.ooo04) THEN
         LET l_sql="SELECT npp02,npq01,npp00,npq23,npq24,npq06,npq07f,npq07",
#                  " FROM ",l_dbs CLIPPED,"npq_file,",l_dbs CLIPPED,"npp_file ",
                   " FROM npq_file,npp_file ",
                   " WHERE npq03='",sr.ooo03,"' AND (npq05=' ' OR npq05 IS NULL) AND npp02>='",g_bdate,"'",
                   "    AND npp02<='",g_edate,"' AND npq24='",sr.ooo05,"'",
                   "    AND npq21='",sr.ooo01,"'",
                   "    AND nppsys=npqsys AND npp00=npq00 AND npp01=npq01",
                   "    AND npp011=npq011 AND nppsys='AR'"
      ELSE
         LET l_sql="SELECT npp02,npq01,npp00,npq23,npq24,npq06,npq07f,npq07",
#                  " FROM ",l_dbs CLIPPED,"npq_file,",l_dbs CLIPPED,"npp_file ",
                   " FROM npq_file,npp_file ",
                   " WHERE npq03='",sr.ooo03,"' AND npq05='",sr.ooo04,"' AND npp02>='",g_bdate,"'",
                   "    AND npp02<='",g_edate,"' AND npq24='",sr.ooo05,"'",
                   "    AND npq21='",sr.ooo01,"'",
                   "    AND nppsys=npqsys AND npp00=npq00 AND npp01=npq01",
                   "    AND npp011=npq011 AND nppsys='AR'"
      END IF
      LET l_sql=l_sql," ORDER BY npp02,npq01"   #MOD-8C0282 add
      PREPARE r501_p FROM l_sql
      DECLARE r501_cur2 CURSOR FOR r501_p
      #FUN-8C0009 ADD--------------------------------------------------------            
             
      FOREACH r501_cur2 INTO sr2.*
         IF STATUS THEN CALL cl_err('fore2:',STATUS,1) EXIT FOREACH END IF
         #---判斷已作廢不印出 modi in 99/12/30--------
#         IF sr2.npp00=2 THEN    #應收立帳  #No.TQC-920048 mark by liuxqa
          IF sr2.npp00 MATCHES '[123]' THEN #No.TQC-920048 mod by liuxqa
            #MOD-4B0001
            LET l_conf=''
            LET l_void=''
            LET l_ooaconf=''     #No.TQC-920048 add by liuxqa 
            #FUN-8C0009 MARK STR------------------------------------
            #SELECT omaconf,omavoid INTO l_conf,l_void FROM oma_file
            # WHERE oma01=sr2.npq01
            #FUN-8C0009 MARK END-----------------------------------
            #FUN-8C0009 ADD STR-------------
             LET l_sql="  SELECT omaconf,omavoid  ",
#                      "  FROM ",l_dbs CLIPPED,"oma_file",
                       "  FROM oma_file",
                       " WHERE oma01 ='", sr2.npq01,"'"
             PREPARE oma_prepare1 FROM l_sql
             DECLARE oma_c1  CURSOR FOR oma_prepare1
             OPEN oma_c1
             FETCH oma_c1 INTO  l_conf,l_void
            #FUN-8C0009 ADD STR-------------                          
            IF STATUS=100 THEN
            #FUN-8C0009 MARK STR------------------------------------
            #   SELECT ooaconf,ooaconf INTO l_conf,l_void FROM ooa_file
            #    WHERE ooa01=sr2.npq01 
            #FUN-8C0009 MARK END-----------------------------------
            #FUN-8C0009 ADD STR-------------
#             LET l_sql="  SELECT ooaconf,ooaconf  ",  #No.TQC-920048 mark by liuxqa
              LET l_sql="  SELECT ooaconf ",           #No.TQC-920048 mod by liuxqa
#                      "    FROM ",l_dbs CLIPPED,"ooa_file",
                       "    FROM ooa_file",
                       "   WHERE ooa01 ='", sr2.npq01,"'"
             PREPARE ooa_prepare1 FROM l_sql
             DECLARE ooa_c1  CURSOR FOR ooa_prepare1
             OPEN ooa_c1
#             FETCH ooa_c1 INTO  l_conf,l_void
             FETCH ooa_c1 INTO l_ooaconf    #No.TQC-920048 mod by liuxqa
            #FUN-8C0009 ADD STR-------------                 
               IF STATUS=100 THEN CONTINUE FOREACH END IF
               IF l_ooaconf='N' OR l_ooaconf='X' THEN CONTINUE FOREACH END IF  #No.TQC-920048 add by liuxqa 
            ELSE                                                               #No.TQC-920048 add by liuxqa 
               IF l_conf='N' THEN CONTINUE FOREACH END IF
               IF l_void='Y' THEN CONTINUE FOREACH END IF
            END IF    #No.TQC-920048 add by liuxqa 
            #--
         END IF
         #--------------------------------------------
         LET l_cnt = l_cnt + 1 
         LET sr2.l_npp02 = sr2.npp02     #MOD-8C0282 add
         LET sr2.l_npq01 = sr2.npq01     #MOD-8C0282 add
         LET l_npp02 = sr2.npp02     #TQC-5B0083
        #IF tm.p='2' THEN   #MOD-8C0282 mark
            IF sr2.npp00 MATCHES "[123]" THEN
              #LET l_npp02[7,8]='99'       #MOD-A40071 mark
               LET sr2.npq01=NULL
               LET sr2.npq23=NULL
            END IF
        #END IF   #MOD-8C0282 mark
	 IF tm.n='2' THEN LET sr2.npq07f=sr2.npq07 END IF #幣別判斷
         IF sr2.npq06 = '1' THEN
            LET sr.amt=sr.amt+sr2.npq07f  #sr.amt存放餘額
            LET l_credit = sr2.npq07f
            LET l_debit  = 0
         ELSE
            LET sr.amt=sr.amt-sr2.npq07f
            LET l_credit = 0
            LET l_debit  = sr2.npq07f
         END IF  # 判斷借貸
 
         CASE sr2.npp00
              WHEN '1'
               #LET l_npp00_desc="出貨立帳"   #MOD-7C0080
               LET l_npp00_desc= cl_getmsg('axr-380',g_lang)  #MOD-7C0080
              WHEN '2'
               #LET l_npp00_desc="應收立帳"   #MOD-7C0080
               LET l_npp00_desc= cl_getmsg('axr-381',g_lang)  #MOD-7C0080
              WHEN '3'
               #LET l_npp00_desc="待抵立帳"   #MOD-7C0080
               LET l_npp00_desc= cl_getmsg('axr-382',g_lang)  #MOD-7C0080
              WHEN '4'
               #LET l_npp00_desc="出納收款"   #MOD-7C0080
               LET l_npp00_desc= cl_getmsg('axr-383',g_lang)  #MOD-7C0080
              OTHERWISE
               LET l_npp00_desc=" "
         END CASE
 
        #IF l_npp02[7,8]='99' THEN LET l_npp02[6,8]=' ' END IF  #MOD-A40071 mark
   
         LET l_bb = tm.b1 USING "&&","-",tm.b2 USING "&&"   #TQC-750226
         #MOD-720047 - START 
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         EXECUTE insert_prep USING 
            sr.ooo01,   sr.ooo02,  sr.ooo03,    sr.aag02,
            sr.ooo04,   sr.gem02,  sr.ooo05,    sr.azi03,
            sr.azi04,   sr.azi05,  l_amt_keep,  l_npp02,
            sr2.npq01,  sr2.npp00, l_npp00_desc,sr2.npq23,
            sr2.npq24,  sr2.npq06, sr2.npq07f,  sr2.npq07,
            l_credit,   l_debit,   sr.amt,      'Y',
            tm.y,       l_bb,        #TQC-750226 add 年度期別
#           m_dbs[l_i],sr.ooo11                                                   #FUN-8C0009 ADD
            '',sr.ooo11   
           ,sr2.l_npp02,sr2.l_npq01  #MOD-8C0282 add
         #------------------------------ CR (3) ------------------------------#
         #MOD-720047 - END 
      END FOREACH
      #MOD-720047 - START 
      IF tm.choice='Y' AND l_cnt=0 THEN   #無異動是否印出
         INITIALIZE sr2.* TO NULL
         EXECUTE insert_prep USING
            sr.ooo01,sr.ooo02,sr.ooo03,   sr.aag02,
            sr.ooo04,sr.gem02,sr.ooo05,   sr.azi03,
            sr.azi04,sr.azi05,l_amt_keep, '',
            '', '',  '',  '',
            '', '',  '',  '',
            '0', '0',  '0',  'N',tm.y,l_bb,   #TQC-750226 add 年度期別
#           m_dbs[l_i],sr.ooo11      #FUN-8C0009 ADD
            '',sr.ooo11
           ,sr2.l_npp02,sr2.l_npq01  #MOD-8C0282 add
      END IF
      #MOD-720047 - END
   END FOREACH
#  END FOR  #FUN-8C0009 ADD   
 
   #MOD-720047 - START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ooo01,ooo03,ooo04,ooo05,ooo11')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   
   #FUN-8C0009 ADD------------------------------
   IF cl_null(tm.s[1,1]) THEN LET tm.s[1,1] = '0' END IF                
   IF cl_null(tm.s[2,2]) THEN LET tm.s[2,2] = '0' END IF                
   IF cl_null(tm.s[3,3]) THEN LET tm.s[3,3] = '0' END IF                
#  IF tm.b = 'Y' THEN                                                   
#     LET l_name = 'axrr501_1'                                          
#  ELSE                                                                 
      LET l_name = 'axrr501'                                        
#  END IF
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
#              tm.t,";",tm.u,";",tm.b
               tm.t,";",tm.u,";",'N'
   #FUN-8C0009 END------------------------------                            
   
   #CALL cl_prt_cs3('axrr501','axrr501',l_sql,g_str)   #FUN-710080 modify #FUN-8C0009 MARK
   CALL cl_prt_cs3('axrr501',l_name,l_sql,g_str)                          #FUN-8C0009 ADD
   #------------------------------ CR (4) ------------------------------#
   #MOD-720047 - END 
  ##NO.FUN-A10098  --end 
END FUNCTION
  ##NO.FUN-A10098  mark--begin 
#FUN-8C0009--Begin--#
#FUNCTION p501_set_entry_1()
#  CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION p501_set_no_entry_1()
#  IF tm.b = 'N' THEN
#     CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#     IF tm2.s1 = '5' THEN
#        LET tm2.s1 = ' '
#     END IF
#     IF tm2.s2 = '5' THEN
#        LET tm2.s2 = ' '
#     END IF
#     IF tm2.s3 = '5' THEN
#        LET tm2.s2 = ' '
#     END IF
#  END IF
#END FUNCTION
#FUNCTION r501_set_comb()
#DEFINE comb_value STRING
#DEFINE comb_item  LIKE type_file.chr1000
# 
#  IF tm.b ='N' THEN
#     LET comb_value = '1,2,3,4,5'
#     SELECT ze03 INTO comb_item FROM ze_file
#       WHERE ze01='axr-113' AND ze02=g_lang
#  ELSE
#     LET comb_value = '1,2,3,4,5,6'
#     SELECT ze03 INTO comb_item FROM ze_file
#       WHERE ze01='axr-114' AND ze02=g_lang
#  END IF
#  CALL cl_set_combo_items('s1',comb_value,comb_item)
#  CALL cl_set_combo_items('s2',comb_value,comb_item)
#  CALL cl_set_combo_items('s3',comb_value,comb_item)
#END FUNCTION
#FUN-8C0009--End--#
  ##NO.FUN-A10098  mark--end
