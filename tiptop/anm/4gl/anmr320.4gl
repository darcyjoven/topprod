# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr320.4gl
# Descriptions...: 銀行收支明細帳列印作業
# Date & Author..: 93/04/13 By Felicity  Tseng
#                : 96/06/14 By Lynn   銀行編號(nma01) 取6碼
# Modify.........: No.FUN-4C0098 05/01/06 By pengu 報表轉XML
# Modify.........: No.MOD-550144 05/06/01 By ching fix l_nme03 DEFINE
# Modify.........: No.MOD-510158 05/07/27 By Smapmin 加印支票號碼(nme17)
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5B0251 05/11/21 By Nicola 幣別、期初金額放在第二行
# Modify.........: No.MOD-630043 06/03/10 By Sarah 在轉出EXCEL時, 最後一頁格式會跑掉, 全部會擠在同一格內
# Modify.........: No.MOD-650004 06/05/03 By Smapmin l_nme03 改為CHAR(43)
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.MOD-670038 06/07/11 By Smapmin 票別需抓取nmo02之值,若查無則為空白
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-770087 07/07/18 By chenl  報表格式修改。
# Modify.........: No.FUN-780011 07/09/18 By Carrier 報表轉Crystal Report格式
# Modify.........: No.CHI-8B0001 08/11/25 By Sarah 若區間在質押日以前仍可顯示,若在質押日範圍內則不可計算定存金額
# Modify.........: No:FUN-8C0018 08/12/22 By jan 加上關係人與營運中心
# Modify.........: No.MOD-930038 09/03/04 By lilingyu 678行sql語句修改
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.TQC-950127 09/06/09 By baofei LET l_sql = "SELECT nmo02 INTO FROM "錯誤多了INTO                               
#                                                   LET l_dbs = s_dbstring(l_dbs CLIPPED)改為s_dbsting                                      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-990067 09/09/22 By hongmei add nme07 
# Modify.........: No:FUN-A10098 10/01/21 By shiwuying GP5.2跨DB報表--財務類
# Modify.........: NO.FUN-A30106 10/03/29 By wujie  增加银行编号开窗挑选功能,"选择"中默认为会计日期
# Modify.........: NO.MOD-AA0010 10/10/05 By Dido 調整外部參數順序 
# Modify.........: No:CHI-B20031 11/03/10 By Sarah 增加「列印無異動者」之選項,若選項打勾,則需列印前期餘額,餘額為0者亦須同時印出
# Modify.........: No.MOD-C20147 12/02/20 By Polly 查詢條件後需再重新給予 INPUT 欄位變數
# Modify.........: No.MOD-C20234 12/03/02 By Polly 調整tm2.u3給予的值
# Modify.........: No:TQC-DA0028 13/10/23 By yangxf “銀行賬號”和“幣種”欄位添加开窗
# Modify.........: No:yinhy131106 13/11/06 By yinhy 增加憑證編號

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,                 #TQC-630166
             #No.FUN-A10098 -BEGIN-----
             #b       LIKE type_file.chr1,    #No.FUN-8C0018 VARCHAR(1)
             #p1      LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
             #p2      LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
             #p3      LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
             #p4      LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10) 
             #p5      LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
             #p6      LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
             #p7      LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
             #p8      LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
             #No.FUN-A10098 -END-------
              bdate   LIKE type_file.dat,     #No.FUN-680107 DATE
              edate   LIKE type_file.dat,     #No.FUN-680107 DATE
              c       LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
              d       LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
              e       LIKE type_file.chr1,    #CHI-B20031 add
              s       LIKE type_file.chr6,    #FUN-8C0018
              t       LIKE type_file.chr3,    #FUN-8C0018
              u       LIKE type_file.chr3,    #FUN-8C0018
              date_sw LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
              more    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_dash_1    LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(132)	
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1      STRING
DEFINE   l_table      STRING  #No.FUN-780011
DEFINE   g_str        STRING  #No.FUN-780011
DEFINE   g_sql        STRING  #No.FUN-780011
#DEFINE   m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8C0018 ARRAY[10] OF VARCHAR(20) #No.FUN-A10098
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-780011  --Begin
   LET g_sql = " nme00.nme_file.nme00,",
               " nma01.nma_file.nma01,",
               " nme02.nme_file.nme02,",
               " nme03.nme_file.nme03,",
               " nme04.nme_file.nme04,",
               " nme05.nme_file.nme05,",
               "nme07.nme_file.nme07,",   #FUN-990067
               " nme08.nme_file.nme08,",
               " nme09.nme_file.nme09,",
               " nme11.nme_file.nme11,",
               " nmg13.nmg_file.nmg13,",    #yinhy131106
               " nme12.nme_file.nme12,",
               " nme13.nme_file.nme13,",
               " nme16.nme_file.nme16,",
               " nme17.nme_file.nme17,",
               " nmc02.nmc_file.nmc02,",
               " nmc03.nmc_file.nmc03,",
               " nma03.nma_file.nma03,",
               " nma10.nma_file.nma10,",
               " nmh10.nmh_file.nmh10,",
               " nmo02.nmo_file.nmo02,",
               " nma04.nma_file.nma04,",    #FUN-8C0018
               " l_restf.nme_file.nme04,",
               " l_rest.nme_file.nme04,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " plant.azp_file.azp01 "     #FUN-8C0018
 
   LET l_table = cl_prt_temptable('anmr264',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?,?,?,?,?, ?,?)"           #FUN-8C0018 #FUN-990067 add ?  #yinhy131106 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780011  --End
 
 
   LET g_pdate  = ARG_VAL(1)     # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
#  LET tm.c     = ARG_VAL(10)    #FUN-8C0018
   LET tm.d     = ARG_VAL(10)                      #MOD-AA0010 11 -> 10
   LET tm.date_sw = ARG_VAL(11)                    #MOD-AA0010 12 -> 11
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)                    #MOD-AA0010 13 -> 12
   LET g_rep_clas = ARG_VAL(13)                    #MOD-AA0010 14 -> 13
   LET g_template = ARG_VAL(14)                    #MOD-AA0010 15 -> 14
   LET g_rpt_name = ARG_VAL(15)  #No:FUN-7C0078    #MOD-AA0010 16 -> 15
   #No.FUN-570264 ---end---
   #No.FUN-8C0018 --start--
  #No.FUN-A10098 -BEGIN-----
  #LET tm.b     = ARG_VAL(17)
  #LET tm.p1    = ARG_VAL(18)
  #LET tm.p2    = ARG_VAL(19)
  #LET tm.p3    = ARG_VAL(20)
  #LET tm.p4    = ARG_VAL(21)
  #LET tm.p5    = ARG_VAL(22)
  #LET tm.p6    = ARG_VAL(23)
  #LET tm.p7    = ARG_VAL(24)
  #LET tm.p8    = ARG_VAL(25)
  #LET tm.s     = ARG_VAL(26)
  #LET tm.t     = ARG_VAL(27)
  #LET tm.u     = ARG_VAL(28)
   LET tm.s     = ARG_VAL(16)                      #MOD-AA0010 17 -> 16
   LET tm.t     = ARG_VAL(17)                      #MOD-AA0010 18 -> 17
   LET tm.u     = ARG_VAL(18)                      #MOD-AA0010 19 -> 18 
   LET tm.e     = ARG_VAL(19)                      #CHI-B20031 add
  #No.FUN-A10098 -END-------
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF   
   #No.FUN-8C0018 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r320_tm(0,0)
      ELSE CALL r320()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r320_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
DEFINE li_result      LIKE type_file.num5    #No.FUN-940102
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW r320_w AT p_row,p_col
        WITH FORM "anm/42f/anmr320"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate = g_today
   LET tm.edate = g_today
#  LET tm.c = 'N'                     #FUN-8C0018
   LET tm.d = 'Y'
   LET tm.e = 'N'                     #CHI-B20031 add
#  LET tm.date_sw = '1'
   LET tm.date_sw = '2'               #No.FUN-A30106
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #FUN-8C0018-Begin--#
 # LET tm.b ='N'     #No.FUN-A10098
   LET tm.s ='123'
   LET tm.t ='Y'
   LET tm.u ='Y'
#No.FUN-A10098 -BEGIN-----
#  LET tm.p1=g_plant
#  CALL r320_set_entry_1()               
#  CALL r320_set_no_entry_1()
   CALL r320_set_comb()   
#No.FUN-A10098 -END-------        
   #FUN-8C0018-End--# 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma01, nma04,nma10
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

#No.FUN-A30106  --begin                                                         
      ON ACTION CONTROLP                                                        
         CASE                                                                   
           WHEN INFIELD(nma01)                                                  
              CALL cl_init_qry_var()                                            
              LET g_qryparam.form = "q_nma"                                     
              LET g_qryparam.state = "c"                                        
              CALL cl_create_qry() RETURNING g_qryparam.multiret                
              DISPLAY g_qryparam.multiret TO nma01                              
#TQC-DA0028 add begin ---
           WHEN INFIELD(nma04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nma04"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nma04
           WHEN INFIELD(nma10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nma10"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nma10
#TQC-DA0028 add end -----
         END CASE                                                               
#No.FUN-A30106  --end  
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
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r320_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#  INPUT BY NAME tm.b,tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,           #FUN-8C0018 #No.FUN-A10098
   INPUT BY NAME                                                                 #No.FUN-A10098
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3, #FUN-8C0018
                 #tm.bdate,tm.edate,tm.c,tm.d,tm.date_sw,tm.more                 #FUN-8C0018
                 tm.bdate,tm.edate,tm.d,tm.date_sw,tm.e,tm.more                  #FUN-8C0018  #CHI-B20031 add tm.e
                 WITHOUT DEFAULTS
     #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
     #No.FUN-580031 ---end---
         #---------------------------MOD-C20147-------------------------start
          LET tm2.s1 = GET_FLDBUF(s1)
          LET tm2.s2 = GET_FLDBUF(s2)
          LET tm2.s3 = GET_FLDBUF(s3)
          LET tm2.t1 = GET_FLDBUF(t1)
          LET tm2.t2 = GET_FLDBUF(t2)
          LET tm2.t3 = GET_FLDBUF(t3)
          LET tm2.u1 = GET_FLDBUF(u1)
          LET tm2.u2 = GET_FLDBUF(u2)
         #LET tm2.u3 = GET_FLDBUF(us)     #MOD-C20234 mark
          LET tm2.u3 = GET_FLDBUF(u3)     #MOD-C20234 add
          LET tm.bdate = GET_FLDBUF(bdate)
          LET tm.edate = GET_FLDBUF(edate)
          LET tm.d = GET_FLDBUF(d)
          LET tm.date_sw = GET_FLDBUF(date_sw)
          LET tm.e = GET_FLDBUF(e)
          LET tm.more = GET_FLDBUF(more)
         #---------------------------MOD-C20147---------------------------end
#No.FUN-A10098 -BEGIN-----
#     #FUN-8C0018--Begin--#
#     AFTER FIELD b
#         IF NOT cl_null(tm.b)  THEN
#            IF tm.b NOT MATCHES "[YN]" THEN
#               NEXT FIELD b       
#            END IF
#         END IF
#                   
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
#         CALL r320_set_entry_1()      
#         CALL r320_set_no_entry_1()
#         CALL r320_set_comb()                               
#      
#     AFTER FIELD p1
#        IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#        SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#        IF STATUS THEN 
#           CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#           NEXT FIELD p1 
#        END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p1) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p1
#               END IF 
#No.FUN-940102 --end-- 
#
#     AFTER FIELD p2
#        IF NOT cl_null(tm.p2) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p2 
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p2) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p2
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p3
#        IF NOT cl_null(tm.p3) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p3 
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p3) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p3
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p4
#        IF NOT cl_null(tm.p4) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#              NEXT FIELD p4 
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p4) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p4
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p5
#        IF NOT cl_null(tm.p5) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#              NEXT FIELD p5 
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p5) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p5
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p6
#        IF NOT cl_null(tm.p6) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#              NEXT FIELD p6 
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p6) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p6
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p7
#        IF NOT cl_null(tm.p7) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#              NEXT FIELD p7 
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p7) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p7
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p8
#        IF NOT cl_null(tm.p8) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p8 
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p8) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p8
#               END IF 
#No.FUN-940102 --end-- 
#        END IF       
#      #FUN-8C0018--End--#
#No.FUN-A10098 -END-------
       
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            CALL cl_err(0,'anm-003',0)
            NEXT FIELD bdate
         END IF
         IF NOT cl_null(tm.edate) THEN
         IF tm.bdate > tm.edate THEN      #截止日期不可小於起始日期
            CALL cl_err(0,'anm-091',0)
            LET tm.bdate = g_today
            LET tm.edate = g_today
            DISPLAY BY NAME tm.bdate, tm.edate
            NEXT FIELD bdate
         END IF
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.bdate) THEN
            CALL cl_err(0,'anm-003',0)
            NEXT FIELD edate
         END IF
         IF tm.bdate > tm.edate THEN      #截止日期不可小於起始日期
            CALL cl_err(0,'anm-091',0)
            LET tm.bdate = g_today
            LET tm.edate = g_today
            DISPLAY BY NAME tm.bdate, tm.edate
            NEXT FIELD bdate
         END IF
 
      #No.FUN-8C0018--BEGIN--MARK
      #AFTER FIELD c
      #   IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
      #      LET tm.c = 'N'
      #      NEXT FIELD c
      #   END IF
      #No.FUN-8C0018--END--MARK--
 
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
            LET tm.d = 'N' NEXT FIELD d
         END IF
      AFTER FIELD date_sw
         IF cl_null(tm.date_sw) OR tm.date_sw NOT MATCHES '[12]' THEN
            LET tm.date_sw = 'N' NEXT FIELD date_sw
         END IF
     #str CHI-B20031 add
      AFTER FIELD e
         IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
            LET tm.e = 'N' NEXT FIELD e
         END IF
     #end CHI-B20031 add
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
   
#No.FUN-A10098 -BEGIN-----
#  #FUN-8C0018--Begin--# 
#     ON ACTION CONTROLP
#        CASE                                          
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
##             LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102 
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
##             LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102 
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
##             LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102 
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
##             LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102 
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_azp'
##             LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102 
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
##             LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102 
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
##             LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102 
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
##             LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102 
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#        END CASE                        
#        #FUN-8C0018--End--#
#No.FUN-A10098 -END-------
         
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
        #FUN-8C0018--Begin
          LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
          LET tm.t = tm2.t1,tm2.t2,tm2.t3
          LET tm.u = tm2.u1,tm2.u2,tm2.u3
          #FUN-8C0018--End
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
      LET INT_FLAG = 0 CLOSE WINDOW r320_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr320'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr320','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         #" '",tm.c CLIPPED,"'",     #FUN-8C0018
                         " '",tm.d CLIPPED,"'",
                         " '",tm.date_sw CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                        #No.FUN-A10098 -BEGIN-----
                        #" '",tm.b CLIPPED,"'" ,    #FUN-8C0018
                        #" '",tm.p1 CLIPPED,"'" ,   #FUN-8C0018
                        #" '",tm.p2 CLIPPED,"'" ,   #FUN-8C0018
                        #" '",tm.p3 CLIPPED,"'" ,   #FUN-8C0018
                        #" '",tm.p4 CLIPPED,"'" ,   #FUN-8C0018
                        #" '",tm.p5 CLIPPED,"'" ,   #FUN-8C0018
                        #" '",tm.p6 CLIPPED,"'" ,   #FUN-8C0018
                        #" '",tm.p7 CLIPPED,"'" ,   #FUN-8C0018
                        #" '",tm.p8 CLIPPED,"'",    #FUN-8C0018
                        #No.FUN-A10098 -END-------
                         " '",tm.s CLIPPED,"'" ,    #FUN-8C0018
                         " '",tm.t CLIPPED,"'" ,    #FUN-8C0018
                         " '",tm.u CLIPPED,"'" ,    #FUN-8C0018
                         " '",tm.e CLIPPED,"'"      #CHI-B20031 add
         CALL cl_cmdat('anmr320',g_time,l_cmd)
      END IF
      CLOSE WINDOW r320_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r320()
   ERROR ""
END WHILE
   CLOSE WINDOW r320_w
END FUNCTION

#No.FUN-A10098 -BEGIN----- 
##FUN-8C0018--Begin--#
#FUNCTION r320_set_entry_1()
#   CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r320_set_no_entry_1()
#   IF tm.b = 'N' THEN
#      CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#      IF tm2.s1 = '4' THEN                                                                                                        
#         LET tm2.s1 = ' '                                                                                                          
#      END IF                                                                                                                       
#      IF tm2.s2 = '4' THEN                                                                                                        
#         LET tm2.s2 = ' '                                                                                                          
#      END IF                                                                                                                       
#      IF tm2.s3 = '4' THEN                                                                                                        
#         LET tm2.s2 = ' '                                                                                                          
#      END IF
#   END IF
#END FUNCTION
 FUNCTION r320_set_comb()                                                                                                            
  DEFINE comb_value STRING                                                                                                          
  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                   
#   IF tm.b ='N' THEN                                                                                                         
       LET comb_value = '1,2,3'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axr100' AND ze02=g_lang                                                                                      
#   ELSE                                                                                                                            
#      LET comb_value = '1,2,3,4'                                                                                                   
#      SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#        WHERE ze01='axr101' AND ze02=g_lang                                                                                       
#   END IF                                                                                                                          
    CALL cl_set_combo_items('s1',comb_value,comb_item)
    CALL cl_set_combo_items('s2',comb_value,comb_item)
    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
 END FUNCTION
##FUN-8C0018--End--#
#No.FUN-A10098 -END-------
 
FUNCTION r320()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#         l_time    LIKE type_file.chr8           #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          l_restf   LIKE nme_file.nme04,          #No.FUN-780011
          l_rest    LIKE nme_file.nme04,          #No.FUN-780011
          l_cnt     LIKE type_file.num5,          #CHI-8B0001 add
          sr        RECORD
                     nme00 LIKE nme_file.nme00,
                     nma01 LIKE nma_file.nma01,
                     nme02 LIKE nme_file.nme02,
                     nme03 LIKE nme_file.nme03,
                     nme04 LIKE nme_file.nme04,
                     nme05 LIKE nme_file.nme05,
                     nme07 LIKE nme_file.nme07,  #FUN-990067
                     nme08 LIKE nme_file.nme08,
                     nme09 LIKE nme_file.nme09,
                     nme11 LIKE nme_file.nme11,
                     nmg13 LIKE nmg_file.nmg13,    #yinhy131106
                     nme12 LIKE nme_file.nme12,
                     nme13 LIKE nme_file.nme13,
                     nme16 LIKE nme_file.nme16,
                     nme17 LIKE nme_file.nme17,   #MOD-510158
                     nmc02 LIKE nmc_file.nmc02,
                     nmc03 LIKE nmc_file.nmc03,
                     nma03 LIKE nma_file.nma03,
                     nma10 LIKE nma_file.nma10,
                     nmh10 LIKE nmh_file.nmh10,   #票別
                     nmo02 LIKE nmo_file.nmo02,
                     nma04 LIKE nma_file.nma04    #FUN-8C0018
                    END RECORD
#No.FUN-A10098 -BEGIN-----
##No.FUN-8C0018---Begin
#DEFINE     l_azp03    LIKE azp_file.azp03
#DEFINE     l_dbs      LIKE azp_file.azp03
#DEFINE     l_i        LIKE type_file.num5
#DEFINE     i          LIKE type_file.num5
##No.FUN-8C0018---End
#No.FUN-A10098 -END-------
 
     #No.FUN-780011  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780011  --End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
     #End:FUN-980030
     
#No.FUN-A10098 -BEGIN-----
#    #FUN-8C0018--Begin--#
#  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#  LET m_dbs[1]=tm.p1
#  LET m_dbs[2]=tm.p2
#  LET m_dbs[3]=tm.p3
#  LET m_dbs[4]=tm.p4
#  LET m_dbs[5]=tm.p5
#  LET m_dbs[6]=tm.p6
#  LET m_dbs[7]=tm.p7
#  LET m_dbs[8]=tm.p8
#  
#  FOR l_i = 1 to 8
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]
#      LET l_azp03 = l_dbs CLIPPED
##      LET l_dbs = s_dbstring(l_dbs CLIPPED)   #TQC-950127                                                                                 
#      LET l_dbs = s_dbstring(l_dbs)    #TQC-950127
#  #FUN-8C0018--End--# 
#No.FUN-A10098 -END------- 

     LET l_sql = "SELECT ",
                 " nme00, nma01, nme02, nme03, nme04, nme05,nme07, nme08, nme09,",    #FUN-990067 add nme07
                 " nme11, '',nme12, nme13, nme16, nme17,",    #yinhy131106 add ''
                 " nmc02, nmc03, nma03, nma10,'',''",
                #" FROM nma_file LEFT OUTER JOIN ",   #CHI-B20031 mark
                 " FROM nma_file JOIN ",              #CHI-B20031 #後面增加選項處理無異動資料,故這段SQL應該只抓有異動的
                 "   (SELECT nme00,nme02,nme03,nme04,nme05,nme07,nme08,nme09,", #FUN-A10098 Add nme07
                 "           nme11,nme12,nme13,nme16,nme17,nmc02,nmc03,nme01 ",
                 "      FROM nme_file,nmc_file ",
                 "     WHERE nme03 = nmc01 "
     IF tm.date_sw = '1'
        THEN LET l_sql = l_sql CLIPPED,
                 " AND   nme02 BETWEEN '", tm.bdate,"' AND '",tm.edate,"'"
        ELSE LET l_sql = l_sql CLIPPED,
                 " AND   nme16 BETWEEN '", tm.bdate,"' AND '",tm.edate,"'"
     END IF
     IF tm.d = 'N' 				#
        THEN LET l_sql = l_sql CLIPPED," AND (nme09 IS NULL OR nme09 = ' ')"
     END IF
     LET l_sql = l_sql CLIPPED,"  ) tmp ",
                 " ON nma01 = tmp.nme01 ",
                 " WHERE ", tm.wc CLIPPED
     PREPARE r320_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r320_curs1 CURSOR FOR r320_prepare1
 
     #No.FUN-780011  --Begin
     #CALL cl_outnam('anmr320') RETURNING l_name
     #START REPORT r320_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-780011  --End  
 
     FOREACH r320_curs1 INTO sr.*
       IF STATUS != 0 THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF

       IF NOT cl_null(sr.nme12) THEN
         SELECT nmg13 INTO sr.nmg13 FROM nmg_file WHERE nmg00 = sr.nme12     #yinhy131106
         #str CHI-8B0001 add
         #抓取銀行存款異動記錄時,應考慮到質押及質押解除,
         #  質押日介於日期範圍   ->不印
         #  解除日不介於日期範圍 ->不印
          LET l_cnt = 0
          #No.FUN-8C0018--EBGIN--
          #SELECT COUNT(*) INTO l_cnt FROM gxf_file
          # WHERE gxf011= sr.nme12
          #   AND ((gxf21 BETWEEN tm.bdate AND tm.edate) OR
          #        (gxf22 NOT BETWEEN tm.bdate AND tm.edate))
        #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED," gxf_file ", #No.FUN-A10098
         LET l_sql = "SELECT COUNT(*) FROM gxf_file ",                   #No.FUN-A10098
                     " WHERE gxf011= '",sr.nme12,"' ",
                     " AND ((gxf21 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') OR ",
                     " (gxf22 NOT BETWEEN '",tm.bdate,"' AND '",tm.edate,"')) "
         PREPARE r320_prepare2 FROM l_sql
         DECLARE r320_c2  CURSOR FOR r320_prepare2
         OPEN r320_c2
         FETCH r320_c2 INTO l_cnt
         #FUN-8C0018---end
          IF l_cnt > 0 THEN CONTINUE FOREACH END IF
         #end CHI-8B0001 add
         #No.FUN-8C0018--BEGIN--
         # SELECT nmh10 INTO sr.nmh10 FROM nmh_file
         #  WHERE nmh01 = sr.nme12 AND nmh38 <> 'X'
         #LET l_sql = "SELECT nmh10 FROM ",l_dbs CLIPPED," nmh_file ", #No.FUN-A10098
          LET l_sql = "SELECT nmh10 FROM nmh_file ",                   #No.FUN-A10098
                     " WHERE nmh01 = '",sr.nme12,"' AND nmh38 <> 'X' "
         PREPARE r320_prepare3 FROM l_sql
         DECLARE r320_c3  CURSOR FOR r320_prepare3
         OPEN r320_c3
         FETCH r320_c3 INTO sr.nmh10
         #FUN-8C0018---end
          IF SQLCA.sqlcode THEN
             #No.FUN-8C0018--BEGIN--
             #SELECT nmd06 INTO sr.nmh10 FROM nmd_file WHERE nmd01 = sr.nme12
          #  LET l_sql = "SELECT nmd06 FROM ",l_dbs CLIPPED," nmd_file WHERE nmd01 = '",sr.nme12,"' " #No.FUN-A10098
             LET l_sql = "SELECT nmd06 FROM nmd_file WHERE nmd01 = '",sr.nme12,"' " #No.FUN-A10098
             PREPARE r320_prepare4 FROM l_sql
             DECLARE r320_c4  CURSOR FOR r320_prepare4
             OPEN r320_c4
             FETCH r320_c4 INTO sr.nmh10
             #FUN-8C0018---end
             IF SQLCA.sqlcode THEN
                LET sr.nmh10 = ''
                #LET sr.nmo02 =g_x[37]   #MOD-670038
                LET sr.nmo02 = ''  #MOD-670038
             END IF
          END IF
          IF NOT cl_null(sr.nmh10) THEN
             #No.FUN-8C0018--BEGIN--
             #SELECT nmo02 INTO sr.nmo02 FROM nmo_file WHERE nmo01=sr.nmh10
#             LET l_sql = "SELECT nmo02 INTO FROM ",l_dbs CLIPPED," nmo_file WHERE nmo01='",sr.nmh10,"' "    #TQC-950127               
          #  LET l_sql = "SELECT nmo02  FROM ",l_dbs CLIPPED," nmo_file WHERE nmo01='",sr.nmh10,"' "    #TQC-950127  #No.FUN-A10098
             LET l_sql = "SELECT nmo02  FROM nmo_file WHERE nmo01='",sr.nmh10,"' "  #No.FUN-A10098
             PREPARE r320_prepare5 FROM l_sql
             DECLARE r320_c5  CURSOR FOR r320_prepare5
             OPEN r320_c5
             FETCH r320_c5 INTO sr.nmo02
            #FUN-8C0018---end
             IF SQLCA.sqlcode THEN LET sr.nmo02 = '' END IF
          END IF
       END IF
 
       IF tm.date_sw = '2' THEN LET sr.nme02 = sr.nme16 END IF
       #No.FUN-780011  --Begin
       #OUTPUT TO REPORT r320_rep(sr.*)
       CALL s_cntrest(sr.nma01,tm.bdate,tm.date_sw,'1')
                      RETURNING l_restf #計算期初餘額
       CALL s_cntrest(sr.nma01,tm.bdate,tm.date_sw,'2')
                      RETURNING l_rest  #計算期初餘額
       SELECT azi04,azi05
         INTO t_azi04,t_azi05
         FROM azi_file
        WHERE azi01=sr.nma10
     # EXECUTE insert_prep USING sr.*,l_restf,l_rest,t_azi04,t_azi05,m_dbs[l_i] #FUN-8C0018 #No.FUN-A10098
       EXECUTE insert_prep USING sr.*,l_restf,l_rest,t_azi04,t_azi05,''         #No.FUN-A10098
       #No.FUN-780011  --End  
     END FOREACH

    #str CHI-B20031 add
    #列印無異動者(tm.e)勾選時,需列印前期餘額
     IF tm.e='Y' THEN
        LET l_sql = "SELECT '',nma01,'','','','','','','',",
                    "       '','','','','',",
                    "       '','',nma03,nma10,'','' ",
                    "  FROM nma_file ",
                    " WHERE nma01 NOT IN ",
                    " (SELECT nme01 FROM nme_file WHERE 1=1"
        IF tm.date_sw = '1' THEN     #選擇:1.銀行日 2.會計日
           LET l_sql = l_sql CLIPPED,
                    "     AND nme02 BETWEEN '", tm.bdate,"' AND '",tm.edate,"'"
        ELSE
           LET l_sql = l_sql CLIPPED,
                    "     AND nme16 BETWEEN '", tm.bdate,"' AND '",tm.edate,"'"
        END IF
        LET l_sql = l_sql CLIPPED,")   AND ", tm.wc CLIPPED
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        PREPARE r320_prepare1_1 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare1_1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
        END IF
        DECLARE r320_curs1_1 CURSOR FOR r320_prepare1_1
        FOREACH r320_curs1_1 INTO sr.*
           IF STATUS != 0 THEN
              CALL cl_err('foreach:',STATUS,1)
              EXIT FOREACH
           END IF
           LET l_restf = 0   LET l_rest = 0
           CALL s_cntrest(sr.nma01,tm.bdate,tm.date_sw,'1')
                          RETURNING l_restf #計算期初餘額
           CALL s_cntrest(sr.nma01,tm.bdate,tm.date_sw,'2')
                          RETURNING l_rest  #計算期初餘額
           SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01=sr.nma10
           EXECUTE insert_prep USING sr.*,l_restf,l_rest,t_azi04,t_azi05,''
        END FOREACH
     END IF
    #end CHI-B20031 add

  #  END FOR              #FUN-8C0018  #No.FUN-A10098
 
     #No.FUN-780011  --Begin
     #FINISH REPORT r320_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nma01,nma04,nma10')
             RETURNING g_str
     END IF
     #No.FUN-8C0018---begin
     IF cl_null(tm.s[1,1]) THEN LET tm.s[1,1] = '0' END IF
     IF cl_null(tm.s[2,2]) THEN LET tm.s[2,2] = '0' END IF
     IF cl_null(tm.s[3,3]) THEN LET tm.s[3,3] = '0' END IF
     #No.FUN-8C0018---end
     LET g_str = g_str,";",tm.date_sw,";",tm.bdate,";",tm.edate,";",
                 #tm.c,";",g_azi04,";",g_azi05    #FUN-8C0018
#No.FUN-A10098 -BEGIN-----
#                g_azi04,";",g_azi05,";",            #FUN-8C0018
#                tm.b,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u   #No.FUN-8C0018<img src="">
                 g_azi04,";",g_azi05,";'N';",
                 tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u
#    IF tm.b = 'N' THEN                                                  #No.FUN-8C0018
        CALL cl_prt_cs3('anmr320','anmr320',g_sql,g_str)
#    ELSE                                                                #No.FUN-8C0018
#       CALL cl_prt_cs3('anmr320','anmr320_1',g_sql,g_str)               #No.FUN-8C0018
#    END IF                                                              #No.FUN-8C0018
#No.FUN-A10098 -END-------
   #No.FUN-780011  --End  
     #No.FUN-780011  --End  
END FUNCTION
 
#No.FUN-780011  --Begin
#REPORT r320_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#          l_nme03      LIKE nme_file.nme03,   #No.FUN-680107 VARCHAR(43) #異動說明字串   #MOD-650004
#          sr               RECORD
#                                  nme00 LIKE nme_file.nme00,
#                                  nma01 LIKE nma_file.nma01,
#                                  nme02 LIKE nme_file.nme02,
#                                  nme03 LIKE nme_file.nme03,
#                                  nme04 LIKE nme_file.nme04,
#                                  nme05 LIKE nme_file.nme05,
#                                  nme08 LIKE nme_file.nme08,
#                                  nme09 LIKE nme_file.nme09,
#                                  nme11 LIKE nme_file.nme11,
#                                  nme12 LIKE nme_file.nme12,
#                                  nme13 LIKE nme_file.nme13,
#                                  nme16 LIKE nme_file.nme16,
#                                  nme17 LIKE nme_file.nme17,  #MOD-570158
#                                  nmc02 LIKE nmc_file.nmc02,
#                                  nmc03 LIKE nmc_file.nmc03,
#                                  nma03 LIKE nma_file.nma03,
#                                  nma10 LIKE nma_file.nma10,
#                                  nmh10 LIKE nmh_file.nmh10,  #票別
#                                  nmo02 LIKE nmo_file.nmo02   #票別
#                        END RECORD,
#      l_debitf     LIKE nme_file.nme04,
#      l_creditf    LIKE nme_file.nme04,
#      l_debit      LIKE nme_file.nme04,
#      l_credit     LIKE nme_file.nme04,
#      l_restf      LIKE nme_file.nme04,
#      l_rest       LIKE nme_file.nme04,
#      l_gsum_1     LIKE nme_file.nme04,
#      l_gsum_2     LIKE nme_file.nme04,
#      t_azi03      LIKE azi_file.azi03,  #NO.CHI-6A0004
#      t_azi04      LIKE azi_file.azi05,  #NO.CHI-6A0004
#      t_azi05      LIKE azi_file.azi05,  #NO.CHI-6A0004
#      l_chr        LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY sr.nma01, sr.nme02, sr.nmh10, sr.nme03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#     #PRINT g_head CLIPPED,pageno_total      #No.TQC-770087 mark
#      IF tm.date_sw = '1'  THEN
#            LET g_head1=g_x[13] CLIPPED,tm.bdate,'    ',g_x[14] CLIPPED,tm.edate,'     ',
#                g_x[19] CLIPPED
#      ELSE
#            LET g_head1=g_x[13] CLIPPED,tm.bdate,'    ',g_x[14] CLIPPED,tm.edate,'     ',
#                g_x[20] CLIPPED
#      END IF
#      #PRINT g_head1                                         #FUN-660060 remaark
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1  #FUN-660060
# 
#      PRINT g_head CLIPPED,pageno_total       #No.TQC-770087 
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#             #g_x[39] CLIPPED,g_x[40] CLIPPED   #MOD-510158
#             g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED   #MOD-510158
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.nma01
#      IF tm.c = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#      CALL s_cntrest(sr.nma01,tm.bdate,tm.date_sw,'1')
#                     RETURNING l_restf #計算期初餘額
#      CALL s_cntrest(sr.nma01,tm.bdate,tm.date_sw,'2')
#                     RETURNING l_rest  #計算期初餘額
#      LET l_gsum_1 = 0
#      LET l_gsum_2 = 0
#
#      SELECT azi03,azi04,azi05
#        INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.nma10
#
#      PRINT g_x[10] CLIPPED,
#            COLUMN g_c[32], sr.nma01,    #No.+414 mod
#            COLUMN g_c[33], sr.nma03          #簡稱
#      PRINT COLUMN g_c[36], g_x[11] CLIPPED,      #No.MOD-5B0251
#            COLUMN g_c[37],sr.nma10,        #幣別
#            COLUMN g_c[39], g_x[12] CLIPPED,
#            COLUMN g_c[40], cl_numfor(l_restf,40,t_azi04), #NO.CHI-6A0004
#            COLUMN g_c[41],cl_numfor(l_rest,41,t_azi04)    #NO.CHI-6A0004
#      SKIP 1 LINE
#
#   ON EVERY ROW
#      LET l_nme03=sr.nme03,'-',sr.nmc02
#
#      CASE WHEN sr.nmc03 = '1' LET sr.nme04 = sr.nme04
#                               LET sr.nme08 = sr.nme08
#           WHEN sr.nmc03 = '2' LET sr.nme04 = sr.nme04*-1
#                               LET sr.nme08 = sr.nme08*-1
#           OTHERWISE           LET sr.nme04 = 0
#                               LET sr.nme08 = 0
#      END CASE
#      LET l_restf=l_restf+ sr.nme04
#      LET l_rest =l_rest + sr.nme08
#
#      PRINT COLUMN g_c[31], sr.nme02,
#             COLUMN g_c[32], sr.nme17,   #MOD-510158
#            COLUMN g_c[33], sr.nmo02,
#            COLUMN g_c[34],l_nme03 ,
#            COLUMN g_c[35], sr.nme12,
#            COLUMN g_c[36], sr.nme11,
#            COLUMN g_c[37], sr.nme13 CLIPPED,
#            COLUMN g_c[38],cl_numfor(sr.nme04,38,t_azi04), #NO.CHI-6A0004
#            COLUMN g_c[39],cl_numfor(sr.nme08,39,g_azi04),
#            COLUMN g_c[40],cl_numfor(l_restf,40,t_azi04),  #NO.CHI-6A0004
#            COLUMN g_c[41],cl_numfor(l_rest,41,g_azi04)
#
#   AFTER GROUP OF sr.nma01      #小計
#      LET l_debitf = GROUP SUM(sr.nme04) WHERE sr.nmc03 = '1'
#      LET l_creditf= GROUP SUM(sr.nme04) WHERE sr.nmc03 = '2'
#      LET l_debit  = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '1'
#      LET l_credit = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '2'
#      #PRINT
#      IF l_debitf <> 0 OR l_debit <> 0 THEN
#         PRINT COLUMN g_c[37],g_x[21] CLIPPED,
#               COLUMN g_c[40],cl_numfor(l_debitf,40,t_azi04), #NO.CHI-6A0004
#               COLUMN g_c[41],cl_numfor(l_debit,41,g_azi04)
#      END IF
#      IF l_creditf <> 0 OR l_credit <> 0 THEN
#         PRINT COLUMN g_c[37],g_x[22] CLIPPED,
#               COLUMN g_c[40],cl_numfor(l_creditf,40,t_azi04),  #NO.CHI-6A0004
#               COLUMN g_c[41],cl_numfor(l_credit,41,g_azi04)
#      END IF
#      PRINT g_dash2   #g_dash_1[1,g_len]
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'nma01,nme02,nme03,nme04,nme05')
#              RETURNING tm.wc
#              #TQC-630166 Start
#             # IF tm.wc[001,070] > ' ' THEN            # for 80
#         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#         #     IF tm.wc[071,140] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#         #     IF tm.wc[141,210] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#         #     IF tm.wc[211,280] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#
#         PRINT g_dash[1,g_len]              #No.TQC-770087
#             CALL cl_prt_pos_wc(tm.wc)
#             #TQC-630166 End
#  
#
#        #PRINT g_dash[1,g_len]              #No.TQC-770087 mark
#      END IF
#      PRINT g_dash[1,g_len]   #MOD-630043 add
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780011  --End  
