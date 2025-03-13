# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr320.4gl
# Descriptions...: 應收帳款彙總表
# Date & Author..: 95/02/16 by Nick
# Modify.........: No.FUN-4C0100 05/01/04 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530411 05/03/30 By Smapmin 類別代號與說明錯誤
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-510167 06/06/12 By rainy 依幣別總計
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/12 By xufeng  修改報表
# Modify.........: No.MOD-720047 07/02/26 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-750177 07/05/28 By rainy 類別列印異常
# Modify.........: No.FUN-720033 08/01/18 By jamie 增加本幣總計
# Modify.........: No.MOD-840053 08/04/08 by Smapmin 放大變數定義
# Modify.........: No.FUN-8B0024 08/12/26 by jan 新增多營運中心大小
# Modify.........: No.MOD-910134 09/01/13 By sherry 本幣金額未包含匯差調整金額    
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能
# Modify.........: No.MOD-C50103 12/08/15 By jt_chen 移除g_sql的TAB分隔與空白
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
              wc      LIKE type_file.chr1000, # Where condition #No.FUN-680123 VARCHAR(1000)
              #FUN-8B0024 begin
        ###GP5.2  dxfwo mark begin 
#              b       LIKE type_file.chr1,
#              p1      LIKE azp_file.azp01,            
#              p2      LIKE azp_file.azp01,            
#              p3      LIKE azp_file.azp01,            
#              p4      LIKE azp_file.azp01,             
#              p5      LIKE azp_file.azp01,            
#              p6      LIKE azp_file.azp01,            
#              p7      LIKE azp_file.azp01,            
#              p8      LIKE azp_file.azp01,
        ###GP5.2  dxfwo mark end            
            #FUN-8B0024 end 
              s       LIKE type_file.chr3,    # Order by sequence #No.FUN-680123 
              t       LIKE type_file.chr3,    # Eject sw #No.FUN-680123 VARCHAR(3)
              u       LIKE type_file.chr3,    # Group total sw #No.FUN-680123 VARCHAR(3)
              i       LIKE type_file.chr1,    #No.FUN-680123 VARCHAR(01)
              j       LIKE type_file.chr1,    #No.FUN-680123 VARCHAR(01)
              k       LIKE type_file.chr1,    #No.FUN-680123 VARCHAR(01)
              more    LIKE type_file.chr1     # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD,
		  l_oma54t	LIKE oma_file.oma54t,
		  l_balance     LIKE oma_file.oma54t,
                  l_oma56t	LIKE oma_file.oma56t,   #FUN-720033 add
                  l_balance1    LIKE oma_file.oma56t    #FUN-720033 add
 
DEFINE   g_i         LIKE type_file.num5      #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   i           LIKE type_file.num5      #No.FUN-680123 SMALLINT
DEFINE l_table        STRING,                 ### CR11 ###
       g_str          STRING,                 ### CR11 ###
       g_sql          STRING                  ### CR11 ###
# DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8B0024  
 
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
   LET g_sql= " oma15.oma_file.oma15,",	        #MOD-C50103 
              " gem02.gem_file.gem02,",	        #部門
              " gen01.gen_file.gen01,",         #業務員編號
              " gen02.gen_file.gen02,",         #業務員
              " oma03.oma_file.oma03,",         #客戶
              " oma032.oma_file.oma032,",       #簡稱
              " oma08.oma_file.oma08,",         #內銷/外銷
              " oma00.oma_file.oma00,",         #類別
      	      #" oma00_desc.oma_file.oma00,",   #類別說明   #TQC-750177
      	      #" oma00_desc.type_file.chr4,",   #類別說明    #TQC-750177   #MOD-840053
      	      " oma00_desc.type_file.chr1000,", #類別說明    #TQC-750177   #MOD-840053
      	      " oma23.oma_file.oma23,",         #幣別
              " oma54t.oma_file.oma54t,",	#應收金額
              " balance.oma_file.oma54,",	#未沖金額
	      " oma02.oma_file.oma02,",         #帳款日期
	      " azi03.azi_file.azi03,",         #
	      " azi04.azi_file.azi04,",         #
	      " azi05.azi_file.azi05,",	        #
              " oma56t.oma_file.oma56t,",       #本幣應收金額   #FUN-720033 add
              " balance1.oma_file.oma56,",	#本幣未沖金額   #FUN-720033 add
              " plant.azp_file.azp01"           #FUN-8B0024
 
   LET l_table = cl_prt_temptable('axrr320',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,  ?, ? , ?, ? , ?, ",
               "        ?, ?, ?, ?, ?,  ?, ? , ?, ? )"   #FUN-7720033 add 2? #FUN-8C0024 add ?
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
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET tm.u = ARG_VAL(10)
   LET tm.i = ARG_VAL(11)
   LET tm.j = ARG_VAL(12)
   LET tm.k = ARG_VAL(13)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #FUN-8B0024 begin
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin   
#   LET tm.b     = ARG_VAL(18)
#   LET tm.p1    = ARG_VAL(19)
#   LET tm.p2    = ARG_VAL(20)
#   LET tm.p3    = ARG_VAL(21)
#   LET tm.p4    = ARG_VAL(22)
#   LET tm.p5    = ARG_VAL(23)
#   LET tm.p6    = ARG_VAL(24)
#   LET tm.p7    = ARG_VAL(25)
#   LET tm.p8    = ARG_VAL(26)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end   
 #FUN-8B0024 end
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = "1"  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = "2"  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = "5"  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "Y" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "Y" END IF
   #no.5196   #FUN-560011 #No.FUN-680123 
   DROP TABLE curr_tmp
   CREATE TEMP TABLE curr_tmp
    (curr LIKE azi_file.azi01,
     amt1 LIKE type_file.num20_6,
     amt2 LIKE type_file.num20_6,
     amt5 LIKE type_file.num20_6,            #本幣應收金額  #FUN-720033 add
     amt6 LIKE type_file.num20_6,            #本幣未沖金額  #FUN-720033 add
     order1 LIKE gen_file.gen02,
     order2 LIKE gen_file.gen02,
     order3 LIKE gen_file.gen02)
         #No.FUN-680123 end
   #CREATE UNIQUE INDEX curr_01 ON curr_tmp(curr,order1,order2,order3);
   #no.5196(end)
 
   IF cl_null(tm.wc)
      THEN CALL axrr320_tm(0,0)                  # Input print condition
      ELSE
      CALL axrr320()                             # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr320_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 2 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW axrr320_w AT p_row,p_col
        WITH FORM "axr/42f/axrr320"
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
   LET tm.s='125'
   LET tm.t='YNN'
   LET tm.u='NNY'
   LET tm.i='1'
   LET tm.j='1'
   LET tm.k='2'
   #FUN-8B0024 begin
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#  LET tm.b ='N'
#  LET tm.p1=g_plant     
#   CALL r320_set_entry()               
#   CALL r320_set_no_entry()
#   CALL r320_set_comb()           
 #FUN-8B0024 end
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma15,oma14,oma03,oma00,oma23,oma02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
        #No.FUN-C40001  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oma03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma03
              WHEN INFIELD(oma14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma14
                   NEXT FIELD oma14
              WHEN INFIELD(oma15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.plant = g_plant
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma15
                   NEXT FIELD oma15
              WHEN INFIELD(oma23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma23
                   NEXT FIELD oma23
              END CASE
        #No.FUN-C40001  --End
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
							
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr320_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME #FUN-8B0024 begin
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                 tm.b,tm.p1,tm.p2,tm.p3,
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8, 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end                 
                 #FUN-8B0024 end
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,tm.k,tm.j,tm.i,
                 tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin         
      #FUN-8B0024 begin--
#      AFTER FIELD b
#          IF NOT cl_null(tm.b)  THEN
#             IF tm.b NOT MATCHES "[YN]" THEN
#                NEXT FIELD b       
#             END IF
#          END IF
#                    
#      ON CHANGE  b
#          LET tm.p1=g_plant
#          LET tm.p2=NULL
#          LET tm.p3=NULL
#          LET tm.p4=NULL
#          LET tm.p5=NULL
#          LET tm.p6=NULL
#          LET tm.p7=NULL
#          LET tm.p8=NULL
#          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#          CALL r320_set_entry()      
#          CALL r320_set_no_entry()
#          CALL r320_set_comb()       
#       
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
#      AFTER FIELD p5
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
#         #FUN-8C0024--END--
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
      AFTER FIELD i
         IF cl_null(tm.i) OR tm.i NOT MATCHES '[12]' THEN
            NEXT FIELD i
         END IF
      AFTER FIELD j
         IF cl_null(tm.j) OR tm.j NOT MATCHES '[123]' THEN
            NEXT FIELD j
         END IF
      AFTER FIELD k
         IF cl_null(tm.k) OR tm.k NOT MATCHES '[123]' THEN
            NEXT FIELD k
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #FUN-8B0024--BEGIN--
      ON ACTION CONTROLP
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#         CASE 
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
   #FUN-8B0024 end 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr320_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr320'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr320','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'" ,   #TQC-610059
                         " '",tm.t CLIPPED,"'" ,   #TQC-610059
                         " '",tm.u CLIPPED,"'" ,   #TQC-610059
                         " '",tm.i CLIPPED,"'" ,
                         " '",tm.j CLIPPED,"'" ,
                         " '",tm.k CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
                         #FUN-8B0024 begin
#                         " '",tm.b CLIPPED,"'" ,    
#                         " '",tm.p1 CLIPPED,"'" ,   
#                         " '",tm.p2 CLIPPED,"'" ,   
#                         " '",tm.p3 CLIPPED,"'" ,   
#                         " '",tm.p4 CLIPPED,"'" ,   
#                         " '",tm.p5 CLIPPED,"'" ,   
#                         " '",tm.p6 CLIPPED,"'" ,   
#                         " '",tm.p7 CLIPPED,"'" ,   
#                         " '",tm.p8 CLIPPED,"'"   
                        #FUN-8B0024 end
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end                        
         CALL cl_cmdat('axrr320',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr320_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr320()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr320_w
END FUNCTION
 
FUNCTION axrr320()
   DEFINE 
          l_name     LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0095
          l_sql      LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
	  l_omavoid  LIKE oma_file.omavoid,
	  l_omaconf  LIKE oma_file.omaconf,
         #l_order    ARRAY[5] OF VARCHAR(30),         #FUN-560011
          l_order    ARRAY[5] OF LIKE gen_file.gen02,          #No.FUN-680123 ARRAY[5] OF VARCHAR(30)
          sr        RECORD
		order1    LIKE gen_file.gen02,     #No.FUN-680123 VARCHAR(30)
		order2    LIKE gen_file.gen02,     #FUN-560011 #No.FUN-680123 VARCHAR(30)
		order3    LIKE gen_file.gen02,     #FUN-560011 #No.FUN-680123 VARCHAR(30)
		oma15	  LIKE oma_file.oma15,	   #部門編號
                gem02	  LIKE gem_file.gem02,	   #部門
                gen01     LIKE gen_file.gen01,	   #業務員編號
                gen02     LIKE gen_file.gen02,	   #業務員
	        oma03	  LIKE oma_file.oma03,	   #客戶
                oma032    LIKE oma_file.oma032,	   #簡稱
                oma08     LIKE oma_file.oma08,	   #內銷/外銷
                oma00     LIKE oma_file.oma00,	   #類別
		#oma00_desc LIKE oma_file.oma00,    #類別說明    #TQC-750177
		#oma00_desc LIKE type_file.chr4,    #類別說明     #TQC-750177   #MOD-840053
		oma00_desc LIKE type_file.chr1000,    #類別說明     #TQC-750177   #MOD-840053
		oma23	  LIKE oma_file.oma23,     #幣別
                oma54t    LIKE oma_file.oma54t,	   #應收金額
                balance   LIKE oma_file.oma54,	   #未沖金額
                oma56t    LIKE oma_file.oma56t,    #本幣應收金額  #FUN-720033 add
                balance1  LIKE oma_file.oma56, 	   #本幣未沖金額  #FUN-720033 add
		oma02	  LIKE oma_file.oma02,	   #帳款日期
		azi03	  LIKE azi_file.azi03,	   #
		azi04	  LIKE azi_file.azi04,	   #
		azi05	  LIKE azi_file.azi05	   #
                    END RECORD
#FUN-8B0024 begin
DEFINE     l_i        LIKE type_file.num5                 
DEFINE     l_dbs      LIKE azp_file.azp03                 
DEFINE     l_azp03    LIKE azp_file.azp03                 
DEFINE     i          LIKE type_file.num5                 
#FUN-8B0024 end
 
   #MOD-720047 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #MOD-720047 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
   #End:FUN-980030
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin   
   #FUN-8B0024 begin
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
#FUN-8B0024 end
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
 
   #no.5196
   DELETE FROM curr_tmp;
 
  #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2) ",                     #FUN-720033 mark
   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt5),SUM(amt6) ", #FUN-720033 mod
             "   FROM curr_tmp ",
             "  WHERE order1=? ",
             "  GROUP BY curr  "
   PREPARE r320_prepare_1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare_1:',SQLCA.sqlcode,1) RETURN
   END IF
   DECLARE curr_temp1 CURSOR FOR r320_prepare_1
 
  #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2) ",                     #FUN-720033 mark
   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt5),SUM(amt6) ", #FUN-720033 mod
             "   FROM curr_tmp ",
             "  WHERE order1=? ",
             "    AND order2=? ",
             "  GROUP BY curr  "
   PREPARE r320_prepare_2 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare_2:',SQLCA.sqlcode,1) RETURN
   END IF
   DECLARE curr_temp2 CURSOR FOR r320_prepare_2
 
  #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2) ",                     #FUN-720033 mark
   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt5),SUM(amt6) ", #FUN-720033 mod
             "   FROM curr_tmp ",
             "  WHERE order1=? ",
             "    AND order2=? ",
             "    AND order3=? ",
             "  GROUP BY curr  "
   PREPARE r320_prepare_3 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare_3:',SQLCA.sqlcode,1) RETURN
   END IF
   DECLARE curr_temp3 CURSOR FOR r320_prepare_3
   #no.5196(end)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin   
# FOR l_i = 1 to 8                                                          
#     IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       
#     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          
#     LET l_azp03 = l_dbs CLIPPED                                           

#     LET l_dbs = s_dbstring(l_dbs CLIPPED)
 
   IF g_ooz.ooz07 = 'N' THEN    #MOD-910134 add
      LET l_sql="SELECT '','','',oma15,gem02,gen01,gen02,oma03,oma032,oma08, ",
                "                oma00,'',oma23,oma54t,oma54t-oma55,oma56t,oma56t-oma57,oma02, ", #FUN-720033 add oma56t,oma56t-oma57
                "                azi03,azi04,azi05 ",
                #" FROM oma_file,OUTER gem_file,OUTER gen_file,OUTER azi_file ", #FUN-8B0024
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#               " FROM ", l_dbs, "oma_file,OUTER ", l_dbs, "gem_file,",          #FUN-8B0024
#               " OUTER ", l_dbs, "gen_file,OUTER ", l_dbs, " azi_file ",        #FUN-8B0024
#               " FROM  oma_file,OUTER gem_file ",
#               " OUTER gen_file,OUTER azi_file ",
                " FROM oma_file  LEFT OUTER join gem_file ON oma_file.oma15=gem_file.gem01 ",
                " LEFT OUTER join gen_file ON oma_file.oma14=gen_file.gen01 ",
                " LEFT OUTER join azi_file ON oma_file.oma23=azi_file.azi01 ",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#              " WHERE oma_file.oma15=gem_file.gem01 AND oma_file.oma14=gen_file.gen01 ",
              # "   AND omaconf = 'Y' AND omavoid = 'N'",  #97/07/29 modify
#               "   AND oma_file.oma23=azi_file.azi01 AND ",tm.wc CLIPPED
                " WHERE ",tm.wc CLIPPED 
   #MOD-910134---Begin
   ELSE
      LET l_sql="SELECT '','','',oma15,gem02,gen01,gen02,oma03,oma032,oma08, ",                                                     
                "                oma00,'',oma23,oma54t,oma54t-oma55,oma56t,oma61,oma02, ",
                "                azi03,azi04,azi05 ", 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#               " FROM ", l_dbs, "oma_file,OUTER ", l_dbs, "gem_file,",          #FUN-8B0024                                        
#               " OUTER ", l_dbs, "gen_file,OUTER ", l_dbs, " azi_file ",        #FUN-8B0024                                        
                " FROM oma_file  LEFT OUTER join gem_file ON oma_file.oma15=gem_file.gem01 ",
                " LEFT OUTER join gen_file ON oma_file.oma14=gen_file.gen01 ",
                " LEFT OUTER join azi_file ON oma_file.oma23=azi_file.azi01 ",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
#               " WHERE oma_file.oma15=gem_file.gem01 AND oma_file.oma14=gen_file.gen01 ", 
#               "   AND oma_file.oma23=azi_file.azi01 AND ",tm.wc CLIPPED  
                " WHERE ",tm.wc CLIPPED  
   END IF
   #MOD-910134---End
##No.2884 modify 1998/12/2
   CASE tm.j
        WHEN '1' LET l_sql = l_sql clipped," AND omaconf = 'Y' "
        WHEN '2' LET l_sql = l_sql clipped," AND omaconf = 'N' "
   END CASE
   CASE tm.k
        WHEN '1' LET l_sql = l_sql clipped," AND omavoid = 'Y' "
        WHEN '2' LET l_sql = l_sql clipped," AND omavoid = 'N' "
   END CASE
   LET l_sql = l_sql clipped," ORDER BY oma03 "
##-----------------------------
   PREPARE axrr320_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   DECLARE axrr320_curs1 CURSOR FOR axrr320_prepare1
 
   LET g_pageno = 0
   LET l_oma54t=0
   LET l_balance=0
   LET l_oma56t=0     #FUN-720033 add
   LET l_balance1=0   #FUN-720033 add
 
   FOREACH axrr320_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF tm.i = '1' AND sr.balance = 0 THEN CONTINUE FOREACH END IF
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oma15
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.gen02
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oma03
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oma00
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oma23
              WHEN tm.s[g_i,g_i] = '6'
                   LET l_order[g_i] = sr.oma02 USING 'YYYYMMDD'
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
      IF sr.oma00 MATCHES '2*' THEN
         LET sr.oma54t=-sr.oma54t
         LET sr.balance=-sr.balance
         LET sr.oma56t  =-sr.oma56t           #FUN-720033 add 
         LET sr.balance1=-sr.balance1         #FUN-720033 add
      END IF
      LET l_oma54t= l_oma54t+sr.oma54t
      LET l_balance=l_balance+sr.balance
      LET l_oma56t= l_oma56t+sr.oma56t        #FUN-720033 add
      LET l_balance1=l_balance1+sr.balance1   #FUN-720033 add
      CALL axmr320_getdesc(sr.oma00) RETURNING sr.oma00_desc			
      IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
      IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
      IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
      #FUN-8B0024 begin
      LET l_sql = "SELECT azi03,azi04 ",                                                                              
#                 "  FROM ",l_dbs CLIPPED,"azi_file",
                  "  FROM azi_file",
                  " WHERE azi01='",g_aza.aza17,"'"                                                                                                                                                                                  
          PREPARE azi_prepare2 FROM l_sql                                                                                          
          DECLARE azi_c2  CURSOR FOR azi_prepare2                                                                                 
          OPEN azi_c2                                                                                    
          FETCH azi_c2 INTO sr.azi03,sr.azi04
      SELECT azi05 INTO sr.azi05
        FROM azi_file WHERE azi01=g_aza.aza17         
   #FUN-8B0024 end
 
      #MOD-720047 - START
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
              sr.oma15,sr.gem02,sr.gen01,sr.gen02,sr.oma03,
              sr.oma032,sr.oma08,sr.oma00,sr.oma00_desc,sr.oma23,
              sr.oma54t,sr.balance,sr.oma02,sr.azi03,sr.azi04,
              sr.azi05,sr.oma56t,sr.balance1,   #FUN-720033 add oma56t、balance1
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#             m_dbs[l_i]   #FUN-8B0024 add
              ''
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin              
      #------------------------------ CR (3) ------------------------------#
      #MOD-720047 - END
   END FOREACH
#END FOR #FUN-8B0024
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
   #MOD-720047 - START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oma15,oma14,oma03,oma00,oma23,oma02')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   
   #FUN-8B0024 begin
#  IF tm.b = 'Y' THEN                                                  
#    LET l_name = 'axrr320_1'                                          
#  ELSE                                                                
     LET l_name = 'axrr320'                                            
#  END IF	                                                      
#FUN-8B0024 end
 
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                         tm.t,";",tm.u
  #CALL cl_prt_cs3('axrr320','axrr320',l_sql,g_str)   #FUN-710080 modify #FUN-8B0024
   CALL cl_prt_cs3('axrr320',l_name,l_sql,g_str)   #FUN-710080 modify    #FUN-8B0024
   #------------------------------ CR (4) ------------------------------#
   #MOD-720047 - END
 
END FUNCTION
 
FUNCTION axmr320_getdesc(l_oma00)
DEFINE l_oma00	    LIKE oma_file.oma00,
       #l_desc       LIKE type_file.chr4          #No.FUN-680123 VARCHAR(4)   #MOD-840053
       l_desc       LIKE type_file.chr1000          #No.FUN-680123 VARCHAR(4)   #MOD-840053
 #MOD-530411
CASE l_oma00
	WHEN '11' LET l_desc="訂金" #g_x[23]
	WHEN '12' LET l_desc="出貨" #g_x[24]
	WHEN '13' LET l_desc="尾款" #g_x[25]
	WHEN '14' LET l_desc="雜項" #g_x[26]
	WHEN '21' LET l_desc="折讓" #g_x[27]
	WHEN '22' LET l_desc="待低" #g_x[28]
	WHEN '23' LET l_desc="預收" #g_x[29]
	WHEN '24' LET l_desc="暫收" #g_x[30]
END CASE
 #END MOD-530411
RETURN l_desc
END FUNCTION
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin 
#FUN-8B0024 begin
#FUNCTION r320_set_entry()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r320_set_no_entry()
#    IF tm.b = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm2.s1 = '7' THEN                                                                                                         
#          LET tm2.s1 = ' '                                                                                                          
#       END IF                                                                                                                       
#       IF tm2.s2 = '7' THEN                                                                                                         
#          LET tm2.s2 = ' '                                                                                                          
#       END IF                                                                                                                       
#       IF tm2.s3 = '7' THEN                                                                                                         
#          LET tm2.s2 = ' '                                                                                                          
#       END IF
#    END IF
#END FUNCTION
#FUNCTION r320_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.b ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4,5,6'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-967' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5,6,7'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-968' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-8B0024 end
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
