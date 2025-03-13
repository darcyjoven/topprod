# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrp340.4gl
# Descriptions...: 銷項發票彙總開立作業     
# Date & Author..: 97/07/14 By Sophia
# Remark ........: 本程式 Copy from axrp330
# Modify.........: 97/08/01 By Sophia 判斷ooz20是否確認後才可開立發票
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-540057 05/05/09 By Trisy 發票號碼調整
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-560099 05/06/23 By Smapmin 
# Modify.........: No.FUN-570156 06/03/09 By saki 批次背景執行
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680022 06/08/21 By cl   多帳期處理
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/27 By xumin l_time轉g_time  
# Modify.........: No.FUN-710050 07/01/22 By Jackho 增加批處理錯誤統整功能
# MOdify.........: No.CHI-790002 07/09/02 By Nicole 修正Insert Into ome_file Error
# Modify.........: NO.TQC-790100 07/09/17 BY Joe 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.MOD-810020 08/01/07 By Smapmin 未回寫oga54
# Modify.........: No.MOD-950042 09/05/06 By lilingyu 回寫oma_file時,增加回寫oma05 = l_oom.oom03
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/25 By hongmei oma71的值賦給ome60
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying  s_ar_upinv增加一參數
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:MOD-A50161 10/08/03 By sabrina 彙總開發票應以'發票客戶oma04'彙總,不是用'客戶編號oma03' 
# Modify.........: No:CHI-A70028 10/08/26 By Summer 寫入ome_file時需同步增加寫入到發票與帳款對照檔(omee_file) 
# Modify.........: No:MOD-AA0055 10/10/12 By Dido 立帳日與發票日不同期別則不產生彙總 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B60174 11/06/22 By Sarah 抓取應收帳款時,排除掉發票金額為0的資料
# Modify.........: No:FUN-B90097 11/09/22 By yangxf 因為 ome_file 新增了 not null 欄位, 導致部份作業無法成功產生發票資料.
# Modify.........: No.FUN-B90130 11/11/24 By wujie 大陆发票改善
# Modify.........: No:MOD-BB0282 11/11/24 By Sarah 回寫oma_file的地方增加回寫oma71
# Modify.........: No:TQC-C40188 12/04/20 By 發票整批開立也排除外銷單
# Modify.........: No:TQC-C10002 12/04/23 By Elise 發票開立,若碼幾年前已存在(字軌四年輪回一次,可能會重複),導致無法開立今年度的發票
# Modify.........: No:FUN-C40078 12/05/03 By Lori INSERT ome_file 新增ome22預設值'N'
# Modify.........: No:FUN-C70030 12/07/11 By pauline INSERT ome_file 新增omecncl預設值'N'
# Modify.........: No:FUN-C80002 12/08/02 By pauline INSERT ome_file 新增ome81預設值'1'
# Modify.........: No:TQC-BC0118 12/08/30 By wangwei INSERT INTO omee_file時omee03賦值錯誤
# Modify.........: No:MOD-CB0085 13/01/31 By Polly 若收款條件的基準日為發票日時，需再重新計算應收款日和票到期日
# Modify.........: No:TQC-D90021 13/09/23 By yangtt "發票客戶編號""稅別""發票別""部門編號""業務人員""幣別""帳款編號""參考單號"新增開窗

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql       string                   #No.FUN-580092 HCN
DEFINE g_date           LIKE type_file.dat        #No.FUN-680123 DATE         # 發票日期  
DEFINE ar_sum           LIKE type_file.chr4       #No.FUN-680123 VARCHAR(4)      # 彙總項目 
DEFINE ar_no            LIKE ome_file.ome05       #No.FUN-680123 VARCHAR(1)      # 發票別
DEFINE g_no1            LIKE oay_file.oayslip     #No.FUN-680123 VARCHAR(5)      # 單別       #No.FUN-550071            
DEFINE g_date2          LIKE type_file.dat        #No.FUN-680123 DATE         # 開立發票日期
DEFINE g_oma05          LIKE oma_file.oma05       #No.FUN-680123 VARCHAR(1)      # 發票別
DEFINE g_oma            RECORD LIKE oma_file.*
DEFINE g_omb            RECORD LIKE omb_file.*
DEFINE p_row,p_col      LIKE type_file.num5       #No.FUN-680123 SMALLINT
DEFINE g_mm  SMALLINT
DEFINE g_oma59          LIKE oma_file.oma59,
        g_oma59t        LIKE oma_file.oma59t,
       g_oma59x         LIKE oma_file.oma59x,
       g_oma10          LIKE oma_file.oma10
DEFINE
    g_oar   RECORD LIKE oar_file.*,
    g_gec   RECORD LIKE gec_file.*,
    g_unikey   LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1) 
 
DEFINE begin_no         LIKE oma_file.oma01     #No.FUN-680123 VARCHAR(16)    
DEFINE g_start,g_end    LIKE oma_file.oma10     #No.FUN-680123 VARCHAR(16)    #NO.FUN-540057
 
DEFINE   g_i             LIKE type_file.num5       #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE   g_change_lang   LIKE type_file.chr1       # Prog. Version..: '5.30.06-13.03.12(01)   #是否有做語言切換 No.FUN-570156
DEFINE   g_cnt           LIKE type_file.num5   #MOD-810020
DEFINE   g_oma75         LIKE oma_file.oma75   #No.FUN-B90130
 
MAIN
#   DEFINE l_time        LIKE type_file.chr8       #No.FUN-680123 VARCHAR(8)   #No.FUN-6A0095
   DEFINE ls_date       STRING    #No.FUN-570156 
   DEFINE l_flag        LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)   #No.FUN-570156 
 
   OPTIONS
        MESSAGE   LINE  LAST-1,
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570156 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET g_wc     = cl_replace_str(g_wc, "\"", "'")
   LET tm2.s1   = ARG_VAL(2)             #彙總項目1
   LET tm2.s2   = ARG_VAL(3)             #彙總項目2
   LET tm2.s3   = ARG_VAL(4)             #彙總項目3
   LET tm2.s4   = ARG_VAL(5)             #彙總項目4
   LET ar_no    = ARG_VAL(6)             #發票別
   LET ls_date  = ARG_VAL(7)             #發票日期
   LET g_date   = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob = ARG_VAL(8)     #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570156 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570156 --start--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818   #No.FUN-6A0095
#  OPEN WINDOW p340_w AT p_row,p_col WITH FORM "axr/42f/axrp340"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#   CALL cl_ui_init()
 
#  CALL p340()
#  CLOSE WINDOW p340_w
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p340()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p340_process()
            CALL s_showmsg()          #No.FUN-710050
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            DROP TABLE p340_tmp              #MOD-AA0055 
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p340_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p340_process()
         CALL s_showmsg()          #No.FUN-710050
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         DROP TABLE p340_tmp              #MOD-AA0055 
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #No.FUN-570156 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN
 
FUNCTION p340()
   #No.FUN-570156 --start-- 將此段移至 p340_process()
#  DEFINE   l_order    ARRAY[4] of VARCHAR(10),
#           l_oma      RECORD LIKE oma_file.*,
#           l_gec      RECORD LIKE gec_file.*,
#           l_oom      RECORD LIKE oom_file.*,
#           l_name     VARCHAR(10),
#           l_cnt      SMALLINT,
#           l_flag     VARCHAR(1),
#           l_cmd      VARCHAR(30),
#           l_azi03    LIKE azi_file.azi03,
#           l_azi04    LIKE azi_file.azi04,
#           l_azi05    LIKE azi_file.azi05,
#           l_oma03    LIKE oma_file.oma03,
#           l_oma21    LIKE oma_file.oma21,
#           oma10_t    LIKE oma_file.oma10,
#           l_order1   VARCHAR(10),
#           l_order2   VARCHAR(10),
#           l_order3   VARCHAR(10),
#           l_order4   VARCHAR(10),
#           sr         RECORD
#           order1     VARCHAR(10),
#           order2     VARCHAR(10),
#           order3     VARCHAR(10),
#           order4     VARCHAR(10),
#           oma00      LIKE oma_file.oma00,
#           oma01      LIKE oma_file.oma01,
#           omaconf    LIKE oma_file.omaconf,
#           oma03      LIKE oma_file.oma03,
#           oma05      LIKE oma_file.oma05,
#           oma21      LIKE oma_file.oma21,
#           oma15      LIKE oma_file.oma15,
#           oma14      LIKE oma_file.oma14,
#           oma23      LIKE oma_file.oma23,
#           oma02      LIKE oma_file.oma02,
#           oma59      LIKE oma_file.oma59, 
#           oma59t     LIKE oma_file.oma59t,
#           oma59x     LIKE oma_file.oma59x 
#           END RECORD
#    #020130 BUGNO:4424 add
 
#  WHILE TRUE
#     CREATE TEMP TABLE p340_tmp
#      (
#       order1     VARCHAR(10),
#       order2     VARCHAR(10),
#       order3     VARCHAR(10),
#       order4     VARCHAR(10),
#       oma00      VARCHAR(02),
#       oma01      VARCHAR(16),     #No.FUN-550071
#       omaconf    VARCHAR(01),
#       oma03      VARCHAR(10),
#       oma05      VARCHAR(01),
#       oma21      VARCHAR(04),
#       oma15      VARCHAR(06),
#       oma14      VARCHAR(08),
#       oma23      VARCHAR(04),
#       oma02      DATE,
#       oma59      DEC(20,6) not null,  #FUN-4C0013 
#       oma59t     DEC(20,6) not null,  #FUN-4C0013 
#       oma59x     DEC(20,6) not null,  #FUN-4C0013 
#       azi03      smallint,
#       azi04      smallint,
#       azi05      smallint
#      )
 
   DEFINE   lc_cmd      LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(500)     #No.FUN-570156
 
   OPEN WINDOW p340_w AT p_row,p_col WITH FORM "axr/42f/axrp340"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   WHILE TRUE
   #No.FUN-570156 ---end---
      #020130 BUGNO:4424 
      CLEAR FORM
      MESSAGE   ""
      CALL cl_opmsg('w')
      
     #CONSTRUCT BY NAME g_wc ON oma03,oma21,oma05,oma15,oma14,     #MOD-A50161 mark 
      CONSTRUCT BY NAME g_wc ON oma04,oma21,oma05,oma15,oma14,     #MOD-A50161 add 
                                oma23,oma02,oma01,oma16 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

        #TQC-D90021---add---str---
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(oma04)#客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ02"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma04
                   NEXT FIELD oma04
              WHEN INFIELD(oma21)#稅別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gec3"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma21
                   NEXT FIELD oma21
              WHEN INFIELD(oma15)#部門編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem3"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma15
                   NEXT FIELD oma15

              WHEN INFIELD(oma14)#業務人員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen5"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma14
                   NEXT FIELD oma14

              WHEN INFIELD(oma23)#幣種
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi2"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma23
                   NEXT FIELD oma23

              WHEN INFIELD(oma01)#賬款編號 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oma01_1"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma01
                   NEXT FIELD oma01

              WHEN INFIELD(oma16)#參考單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oma16" 
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma16
                   NEXT FIELD oma16

              WHEN INFIELD(oma05)#發票別 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_oom"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma05    
                   NEXT FIELD oma05   

            END CASE
           #TQC-D90021---add---end---
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale          #genero
            #No.FUN-570156 --start--
#           LET g_action_choice = "locale"
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE
            EXIT CONSTRUCT
 
         ON ACTION exit              #加離開功能genero
              LET INT_FLAG = 1
              EXIT CONSTRUCT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup') #FUN-980030
      #No.FUN-570156 --start--
#     IF g_action_choice = "locale" THEN  #genero
      IF g_change_lang THEN
#        LET g_action_choice = ""
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE 
      END IF
      #No.FUN-570156 ---end---
 
      IF INT_FLAG THEN
         #No.FUN-570156 --start--
         LET INT_FLAG = 0 
         CLOSE WINDOW p340_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
#        RETURN
         #No.FUN-570156 ---end---
      END IF
      IF g_wc = ' 1=1' THEN
         CALL cl_err('','9046',0) 
         CONTINUE WHILE
     # ELSE
     #    EXIT WHILE
      END IF
     #END WHILE
     LET g_date=g_today
     LET ar_sum='3   '
     LET g_date2=NULL
     LET tm2.s1='3'
     LET g_bgjob = "N"             #No.FUN-570156
     CALL cl_opmsg('a')
        INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.s4,ar_no,g_date,g_bgjob WITHOUT DEFAULTS    #No.FUN-570156
     
           AFTER FIELD ar_no
              IF ar_no IS NULL THEN
                 NEXT FIELD ar_no 
              END IF
           
           AFTER FIELD g_date
              IF g_date IS NULL THEN 
                 NEXT FIELD g_date 
              END IF
     
          {
#           AFTER FIELD g_no1   
#               IF cl_null(g_no1) THEN NEXT FIELD g_no1 END IF
#                  CALL s_axrslip(g_no1,'12')        #檢查單別
#                  IF NOT cl_null(g_errno)THEN              #抱歉, 有問題
#                     CALL cl_err(g_no1,g_errno,0)
#                     NEXT FIELD g_no1 
#                  END IF
          }

    #TQC-D90021----add---str---
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(ar_no) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oom"
              CALL cl_create_qry() RETURNING ar_no
              DISPLAY BY NAME ar_no
     END CASE
    #TQC-D90021----add---edn---
     
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
           ON ACTION CONTROLG
              call cl_cmdask()
        {
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(g_no1) # Class
                  CALL q_ooy(FALSE,FALSE,g_no1,'12') RETURNING g_no1
#                  CALL FGL_DIALOG_SETBUFFER( g_no1 )
                  DISPLAY BY NAME g_no1 
            END CASE
        }
           AFTER INPUT
              LET ar_sum = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1]
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
           ON ACTION exit      #加離開功能genero
              LET INT_FLAG = 1
              EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        END INPUT
     IF INT_FLAG THEN
        #No.FUN-570156 --start--
        LET INT_FLAG = 0 
        CLOSE WINDOW p340_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
#       RETURN
        #No.FUN-570156 ---end---
     END IF
     #No.FUN-570156 --start--
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "axrp340"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('axrp340','9031',1)
        ELSE
           LET g_wc=cl_replace_str(g_wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_wc    CLIPPED,"'",
                        " '",tm2.s1  CLIPPED,"'",
                        " '",tm2.s2  CLIPPED,"'",
                        " '",tm2.s3  CLIPPED,"'",
                        " '",tm2.s4  CLIPPED,"'",
                        " '",ar_no   CLIPPED,"'",
                        " '",g_date  CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('axrp340',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p340_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     EXIT WHILE
 
     #No.FUN-570156 ----將此段移至 p340_process()
#    IF cl_sure(21,21) THEN
#       LET g_mm= MONTH(g_date)
#       LET g_sql= "SELECT '','','','',oma00,oma01,omaconf,oma03,oma05,oma21, ",
#                  " oma15,",
#                  " oma14,oma23,oma02,oma59,oma59t,oma59x,azi03,azi04,azi05 ",
#                  "  FROM oma_file,azi_file",
#                  " WHERE ",g_wc CLIPPED,
#                  "   AND oma23=azi_file.azi01", 
#                  "   AND omavoid = 'N'",
#                  "   AND oma10 IS NULL",
#                  " ORDER BY oma03,oma21"
#       ##Add by Raymon
#       FOR g_i = 1 TO 4
#          CASE
#             WHEN ar_sum[g_i,g_i] = '3'
#                LET g_sql = g_sql CLIPPED,",oma05"
#             WHEN ar_sum[g_i,g_i] = '4'
#                LET g_sql = g_sql CLIPPED,",oma15"
#             WHEN ar_sum[g_i,g_i] = '5'
#                LET g_sql = g_sql CLIPPED,",oma14"
#             WHEN ar_sum[g_i,g_i] = '6'
#                LET g_sql = g_sql CLIPPED,",oma23"
#             OTHERWISE
#                LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       ##     
#       PREPARE p340_prepare FROM g_sql
#       DECLARE p340_cs CURSOR FOR p340_prepare
#       LET begin_no  = NULL
#       INITIALIZE g_oma.* TO NULL
#       INITIALIZE l_gec.* TO NULL
#       CALL cl_outnam('axrp340') RETURNING l_name
#       START REPORT p340_rep TO l_name
#       BEGIN WORK
#       LET l_cnt=0
#       LET g_success = 'Y'
#       LET g_oma59 = 0 LET g_oma59t = 0 LET g_oma59x = 0
#       LET g_oma10=NULL
#       LET g_start = ''   LET g_end = ''
#       FOREACH p340_cs INTO sr.*,g_azi03,g_azi04,g_azi05
#          IF STATUS THEN 
#             CALL cl_err('p340(foreach):',STATUS,1) 
#             LET g_success='N' EXIT FOREACH 
#          END IF
#          IF sr.oma00[1,1]='2' THEN 
#             CONTINUE FOREACH
#          END IF
#          MESSAGE   '單號:',sr.oma01
#          CALL ui.Interface.refresh() 
#         #-----97/08/01 modify
#          IF g_ooz.ooz20 = 'Y' THEN
#             IF sr.omaconf = 'N' THEN
#                CONTINUE FOREACH
#             END IF
#          END IF
#         #---------------------------------------------------------- 產生應收
#          FOR g_i = 1 TO 4
#             CASE
#                WHEN ar_sum[g_i,g_i] = '3'
#                   LET l_order[g_i] = sr.oma05
#                WHEN ar_sum[g_i,g_i] = '4'
#                   LET l_order[g_i] = sr.oma15
#                WHEN ar_sum[g_i,g_i] = '5'
#                   LET l_order[g_i] = sr.oma14
#                WHEN ar_sum[g_i,g_i] = '6'
#                   LET l_order[g_i] = sr.oma23
#                OTHERWISE
#                   LET l_order[g_i] = '-'
#             END CASE
#          END FOR
#          LET sr.order1 = l_order[1]
#          LET sr.order2 = l_order[2]
#          LET sr.order3 = l_order[3]
#          LET sr.order4 = l_order[4]
#       #020130 BUGNO:4424  
#          INSERT INTO p340_tmp VALUES(sr.*,g_azi03,g_azi04,g_azi05)
#                 IF SQLCA.SQLCODE THEN
#                      CALL cl_err('sr Ins:',STATUS,1)
#                 END IF
#          LET l_cnt=l_cnt+1
#       END FOREACH
#       DECLARE p340_tmpcs CURSOR FOR
#           SELECT * FROM p340_tmp
#            ORDER BY oma03,oma21,order1,
#                     order2,order3,order4
#       FOREACH p340_tmpcs INTO sr.*,g_azi03,g_azi04,g_azi05
#           IF STATUS THEN
#               CALL cl_err('order:',STATUS,1)
#               LET g_success='N'  
#               EXIT FOREACH
#           END IF
#           OUTPUT TO REPORT p340_rep(sr.*)
#       END FOREACH 
#       #020130 BUGNO:4424  
#       FINISH REPORT p340_rep
#       #No.+366 010705 plum
#       LET l_cmd = "chmod 777 ", l_name
#       RUN l_cmd
#       #No.+366..end
#       MESSAGE   'Start No: ',g_start,' End No :',g_end
#       CALL ui.Interface.refresh() 
#       IF l_cnt=0 THEN
#          CALL cl_err('','aap-129',1)
#          CALL cl_end2(2) RETURNING l_flag           #批次作業失敗 
#          ROLLBACK WORK 
#       ELSE
#          IF g_success = 'Y' THEN
#             COMMIT WORK 
#             CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#          ELSE 
#             #ROLLBACK WORK RETURN    #FUN-560099
#             ROLLBACK WORK     #FUN-560099
#             CALL cl_end2(2) RETURNING l_flag        #批次作業失敗 
#          END IF
#       END IF
#       #CALL cl_end(10,10)
#       DROP TABLE p340_tmp
#       IF l_flag THEN
#          CONTINUE WHILE
#       ELSE
#          EXIT WHILE
#       END IF
#    END IF
#No.FUN-570156 ---end---
   END WHILE
END FUNCTION
 
#No.FUN-570156 --start--
FUNCTION p340_process()
  #DEFINE   l_order    ARRAY[4] of LIKE oma_file.oma03,      #No.FUN-680123 VARCHAR(10),   #MOD-A50161 mark
   DEFINE   l_order    ARRAY[4] of LIKE oma_file.oma04,      #MOD-A50161 add
            l_oma      RECORD LIKE oma_file.*,
            l_gec      RECORD LIKE gec_file.*,
            l_oom      RECORD LIKE oom_file.*,
            l_name     LIKE type_file.chr20,                 #No.FUN-680123 VARCHAR(10),
            l_cnt      LIKE type_file.num5,                  #No.FUN-680123 SMALLINT,
            l_flag     LIKE type_file.chr1,                  #No.FUN-680123 VARCHAR(1),
            l_cmd      LIKE type_file.chr1000,               #No.FUN-680123 VARCHAR(30),
            l_azi03    LIKE azi_file.azi03,
            l_azi04    LIKE azi_file.azi04,
            l_azi05    LIKE azi_file.azi05,
           #l_oma03    LIKE oma_file.oma03,    #MOD-A50161 mark 
            l_oma04    LIKE oma_file.oma04,    #MOD-A50161 add 
            l_oma21    LIKE oma_file.oma21,
            oma10_t    LIKE oma_file.oma10,
            l_order1   LIKE oma_file.oma04,                 #No:FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04 
            l_order2   LIKE oma_file.oma04,                 #No:FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04 
            l_order3   LIKE oma_file.oma04,                 #No:FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04 
            l_order4   LIKE oma_file.oma04,                 #No:FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04 
            sr         RECORD
            order1     LIKE oma_file.oma04,                 #No:FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04 
            order2     LIKE oma_file.oma04,                 #No:FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04 
            order3     LIKE oma_file.oma04,                 #No:FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04 
            order4     LIKE oma_file.oma04,                 #No:FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04 
            oma00      LIKE oma_file.oma00,
            oma01      LIKE oma_file.oma01,
            omaconf    LIKE oma_file.omaconf,
           #oma03      LIKE oma_file.oma03,    #MOD-A50161 mark 
            oma04      LIKE oma_file.oma04,    #MOD-A50161 add 
            oma05      LIKE oma_file.oma05,
            oma21      LIKE oma_file.oma21,
            oma15      LIKE oma_file.oma15,
            oma14      LIKE oma_file.oma14,
            oma23      LIKE oma_file.oma23,
            oma02      LIKE oma_file.oma02,
            oma59      LIKE oma_file.oma59, 
            oma59t     LIKE oma_file.oma59t,
            oma59x     LIKE oma_file.oma59x,
            oma75      LIKE oma_file.oma75    #No.FUN-B90130 
            END RECORD
        #No.FUN-680123 
   CREATE TEMP TABLE p340_tmp
    (order1     LIKE oma_file.oma04,   #MOD-A50161 oma03 modify oma04  
     order2     LIKE oma_file.oma04,   #MOD-A50161 oma03 modify oma04  
     order3     LIKE oma_file.oma04,   #MOD-A50161 oma03 modify oma04 
     order4     LIKE oma_file.oma04,   #MOD-A50161 oma03 modify oma04  
     oma00      LIKE oma_file.oma00,
     oma01      LIKE oma_file.oma01,
     omaconf    LIKE oma_file.omaconf,
     oma04      LIKE oma_file.oma04,   #MOD-A50161 oma03 modify oma04
     oma05      LIKE oma_file.oma05,
     oma21      LIKE oma_file.oma21,
     oma15      LIKE oma_file.oma15,
     oma14      LIKE oma_file.oma14,
     oma23      LIKE oma_file.oma23,
     oma02      LIKE oma_file.oma02,
     oma59      LIKE oma_file.oma59,
     oma59t     LIKE oma_file.oma59t NOT NULL,   
     oma59x     LIKE oma_file.oma59x NOT NULL, 
     oma75      LIKE oma_file.oma75,    #No.FUN-B90130
     azi03      LIKE azi_file.azi03,
     azi04      LIKE azi_file.azi04,
     azi05      LIKE azi_file.azi05)
    #FUN-4C0013   #No.FUN-680123 end
 
   LET g_mm= MONTH(g_date)
  #LET g_sql= "SELECT '','','','',oma00,oma01,omaconf,oma03,oma05,oma21, ",   #MOD-A50161 mark  
   LET g_sql= "SELECT '','','','',oma00,oma01,omaconf,oma04,oma05,oma21, ",   #MOD-A50161 add 
              " oma15,",
              " oma14,oma23,oma02,oma59,oma59t,oma59x,oma75,azi03,azi04,azi05 ",   #No.FUN-B90130 add oma75 
              "  FROM oma_file,azi_file",
              " WHERE ",g_wc CLIPPED,
              "   AND oma23=azi_file.azi01", 
              "   AND omavoid = 'N'",
              "   AND oma10 IS NULL",
              "   AND oma59t > 0 ",     #MOD-B60174 add   #發票金額>0時才需要產生發票
              " ORDER BY oma04,oma21"          #MOD-A50161 oma03 modify oma04
   ##Add by Raymon
   FOR g_i = 1 TO 4
      CASE
         WHEN ar_sum[g_i,g_i] = '3'
            LET g_sql = g_sql CLIPPED,",oma05"
         WHEN ar_sum[g_i,g_i] = '4'
            LET g_sql = g_sql CLIPPED,",oma15"
         WHEN ar_sum[g_i,g_i] = '5'
            LET g_sql = g_sql CLIPPED,",oma14"
         WHEN ar_sum[g_i,g_i] = '6'
            LET g_sql = g_sql CLIPPED,",oma23"
         OTHERWISE
            LET l_order[g_i] = '-'
      END CASE
   END FOR
   ##     
   
   PREPARE p340_prepare FROM g_sql
   DECLARE p340_cs CURSOR FOR p340_prepare
   LET begin_no  = NULL
   INITIALIZE g_oma.* TO NULL
   INITIALIZE l_gec.* TO NULL
   CALL cl_outnam('axrp340') RETURNING l_name
   START REPORT p340_rep TO l_name
   BEGIN WORK
   LET l_cnt=0
   LET g_success = 'Y'
   LET g_oma59 = 0 LET g_oma59t = 0 LET g_oma59x = 0
   LET g_oma10=NULL
   LET g_oma75=NULL   #No.FUN-B90130
   LET g_start = ''   LET g_end = ''
   CALL s_showmsg_init()   #No.FUN-710050
   FOREACH p340_cs INTO sr.*,g_azi03,g_azi04,g_azi05
      IF STATUS THEN 
#No.FUN-710050--begin
#         CALL cl_err('p340(foreach):',STATUS,1) 
         CALL s_errmsg('','','p340(foreach):',STATUS,1)
#No.FUN-710050--end
         LET g_success='N' EXIT FOREACH 
      END IF
 
      IF sr.oma00[1,1]='2' THEN 
         CONTINUE FOREACH
      END IF
      IF g_bgjob = "N" THEN           #No.FUN-570156
         MESSAGE   '單號:',sr.oma01
         CALL ui.Interface.refresh() 
      END IF                          #No.FUN-570156
     #-----97/08/01 modify
      IF g_ooz.ooz20 = 'Y' THEN
         IF sr.omaconf = 'N' THEN
            CONTINUE FOREACH
         END IF
      END IF
     #---------------------------------------------------------- 產生應收
      FOR g_i = 1 TO 4
         CASE
            WHEN ar_sum[g_i,g_i] = '3'
               LET l_order[g_i] = sr.oma05
            WHEN ar_sum[g_i,g_i] = '4'
               LET l_order[g_i] = sr.oma15
            WHEN ar_sum[g_i,g_i] = '5'
               LET l_order[g_i] = sr.oma14
            WHEN ar_sum[g_i,g_i] = '6'
               LET l_order[g_i] = sr.oma23
            OTHERWISE
               LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
      LET sr.order4 = l_order[4]
   #020130 BUGNO:4424  
      INSERT INTO p340_tmp VALUES(sr.*,g_azi03,g_azi04,g_azi05)
             IF SQLCA.SQLCODE THEN
#                 CALL cl_err('sr Ins:',STATUS,1)    #No.FUN-660116
#No.FUN-710050--begin
#                  CALL cl_err3("ins","p340_tmp",sr.oma01,"",STATUS,"","sr Ins:",1)    #No.FUN-660116
                  CALL s_errmsg('p340_tmp',sr.oma01,'sr Ins:',STATUS,0)
#No.FUN-710050--end
             END IF
      LET l_cnt=l_cnt+1
   END FOREACH
   DECLARE p340_tmpcs CURSOR FOR
       SELECT * FROM p340_tmp
        ORDER BY oma04,oma21,order1,      #MOD-A50161 oma03 modify oma04
                 order2,order3,order4
   FOREACH p340_tmpcs INTO sr.*,g_azi03,g_azi04,g_azi05
       IF STATUS THEN
#No.FUN-710050--begin
#           CALL cl_err('order:',STATUS,1)
           CALL s_errmsg('','','order:',STATUS,1)
#No.FUN-710050--end
           LET g_success='N'  
           EXIT FOREACH
       END IF
#No.FUN-710050--begin
       IF g_success='N' THEN                                                                                                          
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF             
#No.FUN-710050--end        
       OUTPUT TO REPORT p340_rep(sr.*)
   END FOREACH 
#No.FUN-710050--begin
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
#No.FUN-710050--end  
   #020130 BUGNO:4424  
   FINISH REPORT p340_rep
   #No.+366 010705 plum
#  LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009  
#  RUN l_cmd                                          #No.FUN-9C0009
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
   #No.+366..end
   IF g_bgjob = "N" THEN               #No.FUN-570156
      MESSAGE   'Start No: ',g_start,' End No :',g_end
      CALL ui.Interface.refresh() 
   END IF                              #No.FUN-570156
   IF l_cnt=0 THEN
      LET g_success = "N"           #批次作業失敗 
   END IF
  #DROP TABLE p340_tmp              #MOD-AA0055 mark
END FUNCTION
#No.FUN-570156 ---end---
 
REPORT p340_rep(sr)
DEFINE sr        RECORD
                 order1     LIKE oma_file.oma04,         #No.FUN-680123 VARCHAR(10),  #MOD-A50161 oma03 modify oma04 
                 order2     LIKE oma_file.oma04,         #No.FUN-680123 VARCHAR(10),  #MOD-A50161 oma03 modify oma04 
                 order3     LIKE oma_file.oma04,         #No.FUN-680123 VARCHAR(10),  #MOD-A50161 oma03 modify oma04 
                 order4     LIKE oma_file.oma04,         #No.FUN-680123 VARCHAR(10),  #MOD-A50161 oma03 modify oma04  
                 oma00      LIKE oma_file.oma00,
                 oma01      LIKE oma_file.oma01,
                 omaconf    LIKE oma_file.omaconf,
                 oma04      LIKE oma_file.oma04,          #MOD-A50161 oma03 modify oma04
                 oma05      LIKE oma_file.oma05,
                 oma21      LIKE oma_file.oma21,
                 oma15      LIKE oma_file.oma15,
                 oma14      LIKE oma_file.oma14,
                 oma23      LIKE oma_file.oma23,
                 oma02      LIKE oma_file.oma02,
                 oma59      LIKE oma_file.oma59, 
                 oma59t     LIKE oma_file.oma59t,
                 oma59x     LIKE oma_file.oma59x,
                 oma75      LIKE oma_file.oma75      #No.FUN-B90130 
                 END RECORD,
       l_oma04  LIKE oma_file.oma04,             #MOD-A50161 oma03 modify oma04
       l_oma21  LIKE oma_file.oma21,
       oma10_t  LIKE oma_file.oma10,
       l_flag   LIKE type_file.chr1,                   #No.FUN-680123 VARCHAR(1),
       l_first  LIKE type_file.chr1,                   #No.FUN-680123 VARCHAR(1),
       t_oma10  LIKE oma_file.oma10,
       l_gec    RECORD LIKE gec_file.*,
       l_oom    RECORD LIKE oom_file.*,
       l_order1 LIKE oma_file.oma04,                 #No.FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04  
       l_order2 LIKE oma_file.oma04,                 #No.FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04  
       l_order3 LIKE oma_file.oma04,                 #No.FUN-680123 VARCHAR(10), #MOD-A50161 oma03 modify oma04  
       l_order4 LIKE oma_file.oma04                  #No.FUN-680123 VARCHAR(10)  #MOD-A50161 oma03 modify oma04 
   DEFINE l_oga909   LIKE oga_file.oga909      #三角貿易否
   DEFINE l_oga16    LIKE oga_file.oga16     #訂單單號
   DEFINE l_ogaplant LIKE oga_file.ogaplant  #FUN-A60056
   DEFINE l_oea904   LIKE oea_file.oea904    #流程代碼
   #add 030625 NO.A083
   DEFINE l_oot05    LIKE oot_file.oot05 
   DEFINE l_oot05x   LIKE oot_file.oot05x
   DEFINE l_oot05t   LIKE oot_file.oot05t
   DEFINE l_mm       SMALLINT                #MOD-AA0055
   DEFINE l_oma02    LIKE oma_file.oma02     #MOD-CB0085 add
   DEFINE l_oma03    LIKE oma_file.oma03     #MOD-CB0085 add
   DEFINE l_oma09    LIKE oma_file.oma09     #MOD-CB0085 add
   DEFINE l_oma11    LIKE oma_file.oma11     #MOD-CB0085 add
   DEFINE l_oma12    LIKE oma_file.oma12     #MOD-CB0085 add
   DEFINE l_oma32    LIKE oma_file.oma32     #MOD-CB0085 add
   DEFINE l_oag03    LIKE oag_file.oag03     #MOD-CB0085 add
 
    ORDER EXTERNAL BY sr.oma04,sr.oma21,sr.order1,sr.order2,sr.order3,sr.order4    #MOD-A50161 oma03 modify oma04
    FORMAT
      PAGE HEADER
        
        LET l_flag = 'Y'
        LET l_first = 'Y'
        LET l_oma04 = ' '    #MOD-A50161 oma03 modify oma04
        LET l_oma21 = ' '
        LET l_order1 = ' '
        LET l_order2 = ' '
        LET l_order3 = ' '
        LET l_order4 = ' '
 
     ON EVERY ROW
        SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = sr.oma01
        #TQC-C40188--add--str--
         IF g_ooz.ooz64 = 'N' AND g_oma.oma08 = '2' AND g_aza.aza26 = '0' THEN
            CALL s_errmsg('oma01','',g_oma.oma01,'axr-702',1) 
            LET g_success='N'
            RETURN 
         END IF
         #TQC-C40188--add--str--
        IF l_oma04 != sr.oma04 OR l_oma21 != sr.oma21 OR       #MOD-A50161 oma03 modify oma04 
           l_order1 != sr.order1 OR l_order2 != sr.order2 OR 
           l_order3 != sr.order3 OR l_order4 != sr.order4 THEN
                                      #依項目不同分別開立發票
         IF t_oma10 IS NOT NULL AND l_flag = 'N' THEN   #不是第一次

         
#No.FUN-B90130 --begin 
         IF g_aza.aza26 ='2' THEN 
            UPDATE ome_file SET ome59 = g_oma59,
                                ome59t= g_oma59t,
                                ome59x= g_oma59x 
             WHERE ome01 = t_oma10 
               AND ome03 = g_oma75 
         ELSE  
            UPDATE ome_file SET ome59 = g_oma59,
                                ome59t= g_oma59t,
                                ome59x= g_oma59x 
             WHERE ome01 = t_oma10  
         END IF 
#No.FUN-B90130 --end
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#              CALL cl_err('upd ome',SQLCA.SQLCODE,0)    #No.FUN-660116
#No.FUN-710050--begin
#               CALL cl_err3("upd","ome_file",t_oma10,"",SQLCA.SQLCODE,"","upd ome",0)    #No.FUN-660116
               CALL s_errmsg('ome01',t_oma10,'upd ome',SQLCA.SQLCODE,1) 
#No.FUN-710050--end
               LET g_success = 'N'
            END IF
            LET g_oma59 = 0
            LET g_oma59t= 0
            LET g_oma59x= 0
         END IF
             #99.01.25 add for 三角貿易
               LET l_oga909='N'
               IF g_oma.oma00='12' THEN
                 #FUN-A60056--mod--str--
                 #SELECT oga16,oga909 INTO l_oga16,l_oga909
                 #  FROM oga_file
                 # WHERE oga01=g_oma.oma16
                  LET g_sql = "SELECT oga16,oga909,ogaplant FROM ",cl_get_target_table(g_oma.oma66,'oga_file'),   #FUN-A60056 add ogaplant
                              " WHERE oga01='",g_oma.oma16,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
                  PREPARE sel_oga16 FROM g_sql
                  EXECUTE sel_oga16 INTO l_oga16,l_oga909,l_ogaplant    #FUN-A60056 add ogaplant
                 #FUN-A60056--mod--end 
                  IF SQLCA.SQLCODE <>0 OR l_oga909 IS NULL THEN
                     LET l_oga909='N'
                  END IF
               END IF
               IF cl_null(l_oga909) THEN LET l_oga909='N' END IF
               IF l_oga909='Y' THEN
                  #讀取流程代碼
                 #FUN-A60056--mod--str--
                 #SELECT oea904 INTO l_oea904
                 #  FROM oea_file
                 # WHERE oea01=l_oga16
                  LET g_sql = "SELECT oea904 FROM ",cl_get_target_table(l_ogaplant,'oea_file'),
                              " WHERE oea01='",l_oga16,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,l_ogaplant) RETURNING g_sql
                  PREPARE sel_oea904 FROM g_sql
                  EXECUTE sel_oea904 INTO l_oea904
                 #FUN-A60056--mod--end
                  SELECT * INTO g_oar.*
                    FROM oar_file
                   WHERE oar01=l_oea904
                     AND oar02=g_plant
                  IF SQLCA.SQLCODE <>0 THEN
                     LET g_unikey='N'
                  ELSE
                     LET g_unikey='Y'
                     IF cl_null(g_oar.oar04) THEN
                        LET g_unikey='N'
                     ELSE
                        SELECT * INTO g_gec.*
                          FROM gec_file
                         WHERE gec01=g_oar.oar04
                          AND gec011='2'
                     END IF   
                  END IF
               ELSE
                  LET g_unikey='N'
               END IF 
      #------------------------------------------ (1) Default GUI NO
         SELECT * INTO l_gec.* FROM gec_file WHERE gec01 = sr.oma21   #稅別
                                               AND gec011='2'  #銷項
         #-----取得發票號碼
       # CALL s_guiauno(g_oma.oma10,g_date,ar_no,l_gec.gec05)
       #      RETURNING g_i,oma10_t
       #99.01.25 for 三角貿易
       IF g_unikey='N' THEN
          CALL s_guiauno(g_oma.oma10,g_oma.oma75,g_date,ar_no,l_gec.gec05)  #No.FUN-B90130 add oma75
	      RETURNING g_i,oma10_t,sr.oma75  #No.FUN-B90130      
	     ELSE
         LET l_gec.gec05 = g_gec.gec05
         CALL s_guiauno(g_oma.oma10,g_oma.oma75,g_date,ar_no,g_gec.gec05)   #No.FUN-B90130 add oma75
	      RETURNING g_i,oma10_t,sr.oma75  #No.FUN-B90130
       END IF
         IF NOT g_i THEN LET g_oma.oma10=oma10_t LET g_oma.oma75 = sr.oma75 END IF   #No.FUN-B90130 
         IF g_oma.oma10 IS NULL THEN LET g_success = 'N' END IF
         LET g_oma10 = g_oma.oma10
         LET g_oma75 = g_oma.oma75   #No.FUN-B90130
#No.FUN-B90130 --begin
         IF cl_null(sr.oma75) THEN 
            SELECT * INTO l_oom.* FROM oom_file
             WHERE oom07 <= g_oma.oma10 AND g_oma.oma10 <= oom08 
               AND oom01=YEAR(g_oma.oma09)           #TQC-C10002 add oma09
         ELSE 
            SELECT * INTO l_oom.* FROM oom_file
             WHERE oom07 <= g_oma.oma10 AND g_oma.oma10 <= oom08 
               AND oom16 = sr.oma75  
               AND oom01=YEAR(g_oma.oma09)           #TQC-C10002 add oma09 
         END IF 
#No.FUN-B90130 --end         
         IF STATUS THEN
#           CALL cl_err(g_oma10,'axr-128',0)
#No.FUN-710050--begin
#            CALL cl_err3("sel","oom_file",g_oma.oma10,g_oma.oma10,"axr-128","","",0)    #No.FUN-660116
            CALL s_errmsg('','',g_oma10,'axr-128',1) 
#No.FUN-710050--end
            LET g_success = 'N'
         END IF
         IF g_oma.oma10 > l_oom.oom09 AND g_date < l_oom.oom10 THEN
#No.FUN-710050--begin
#            CALL cl_err(g_oma.oma10,'axr-208',0)
            CALL s_errmsg('','',g_oma.oma10,'axr-208',1) 
#No.FUN-710050--end
            LET g_success = 'N'
         END IF
#No.FUN-B90130 --begin
         IF l_oom.oom04 != l_gec.gec05 AND g_aza.aza26 <> '2' THEN
            CALL s_errmsg('','',g_oma.oma10,'axr-142',1) 
            LET g_success = 'N'
         END IF
         IF l_oom.oom15 != l_gec.gec05 AND g_aza.aza26 = '2' THEN
            CALL s_errmsg('','',g_oma.oma10,'axr-142',1) 
            LET g_success = 'N'
         END IF

#         IF l_oom.oom04 != l_gec.gec05 THEN
##No.FUN-710050--begin
##            CALL cl_err(g_oma.oma10,'axr-142',0)
#            CALL s_errmsg('','',g_oma.oma10,'axr-142',1) 
##No.FUN-710050--end
#            LET g_success = 'N'
#         END IF
#No.FUN-B90130 --end        
#IF l_oom.oom01!=YEAR(g_date) OR l_oom.oom02!=MONTH(g_date)
         IF l_oom.oom01!=YEAR(g_date) OR 
            NOT l_oom.oom02 <= g_mm <= l_oom.oom021
            THEN CALL cl_err(g_oma.oma10,'axr-314',0)
            LET g_success = 'N'
         END IF
        #-MOD-AA0055-add-
         LET l_mm = MONTH(g_oma.oma02) 
         IF YEAR(g_oma.oma02) <> l_oom.oom01 OR (YEAR(g_oma.oma02) = l_oom.oom01 AND 
                                                 l_mm < l_oom.oom02 OR l_mm > l_oom.oom021) THEN
            CALL s_errmsg('','',g_oma.oma02,'axr-069',1) 
            LET g_success = 'N'
         END IF  
        #-MOD-AA0055-end-
         #----------------------------------------- 更新已開 GUI NO
        #CALL s_guiauno(g_oma.oma10,g_date,ar_no,l_gec.gec05)
 #		RETURNING g_i,g_oma.oma10
       #99.01.25 for 三角貿易
 
       IF g_unikey='N' THEN
         CALL s_guiauno(g_oma.oma10,g_oma.oma75,g_date,ar_no,l_gec.gec05)   #No.FUN-B90130 add oma75
	      RETURNING g_i,g_oma.oma10,sr.oma75  #No.FUN-B90130
         IF g_i THEN LET g_success = 'N' END IF
         CALL p340_insome(sr.*,l_gec.*)
       ELSE
         CALL s_guiauno(g_oma.oma10,g_oma.oma75,g_date,ar_no,g_gec.gec05)   #No.FUN-B90130 add oma75
	      RETURNING g_i,g_oma.oma10,sr.oma75  #No.FUN-B90130
         IF g_i THEN LET g_success = 'N' END IF
         CALL p340_insome(sr.*,g_gec.*)
       END IF
       # IF g_i THEN LET g_success = 'N' END IF
       # CALL p340_insome(sr.*,l_gec.*)
       IF NOT g_i THEN LET g_oma.oma10=oma10_t LET g_oma.oma75 = sr.oma75 END IF   #No.FUN-B90130
       IF l_first = 'Y' THEN LET g_start = g_oma.oma10 END IF
       LET l_first = 'N'
         LET t_oma10 = g_oma10
      END IF  
      IF g_oma10 IS NOT NULL THEN
         CALL p340_insomee() #CHI-A70028 add
         UPDATE oma_file SET oma10 = g_oma10,
                             oma09 = g_date,
                             oma71 = l_oom.oom13,   #MOD-BB0282 add
                             oma75 = g_oma75        #No.FUN-B90130  
          WHERE oma01 = sr.oma01
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#           CALL cl_err('upd oma',SQLCA.SQLCODE,0)   #No.FUN-660116
#No.FUN-710050--begin
#            CALL cl_err3("upd","oma_file",sr.oma01,"",SQLCA.SQLCODE,"","upd oma",0)    #No.FUN-660116
            CALL s_errmsg('oma01',sr.oma01,'upd oma',SQLCA.sqlcode,1) 
#No.FUN-710050--end
            LET g_success = 'N'
        #No.FUN-680022--begin-- add
         ELSE
            UPDATE omc_file SET omc12=g_oma10 WHERE omc01=sr.oma01
            IF SQLCA.sqlcode THEN
#No.FUN-710050--begin
#               CALL cl_err3("upd","omc_file",sr.oma01,"",SQLCA.sqlcode,"","update omc12",1)
               CALL s_errmsg('omc01',sr.oma01,'upd omc12',SQLCA.sqlcode,1) 
#No.FUN-710050--end
           #------------------------MOD-CB0085--------------------(S)
            ELSE
               SELECT oma02,oma03,oma09,oma32
                 INTO l_oma02,l_oma03,l_oma09,l_oma32
                 FROM oma_file
                WHERE oma01 = sr.oma01
               SELECT oag03 INTO l_oag03 FROM oag_file
                WHERE oag01 = l_oma32
               IF l_oag03 = "2" OR l_oag03 = "5" THEN
                  CALL s_rdatem(l_oma03,l_oma32,l_oma02,l_oma09,
                                l_oma02,g_plant)
                       RETURNING l_oma11,l_oma12
                  UPDATE oma_file SET oma11 = l_oma11,
                                      oma12 = l_oma12
                   WHERE oma01 = sr.oma01
                  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL s_errmsg('oma11,oma12',sr.oma01,'upd oma',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                  END IF
               END IF
           #------------------------MOD-CB0085--------------------(E)
            END IF 
        #No.FUN-680022--end-- add
         END IF
      END IF
     #CALL s_ar_upinv(sr.oma01) RETURNING g_cnt    #MOD-810020 #No.FUN-9C0014
      CALL s_ar_upinv(sr.oma01,'') RETURNING g_cnt #No.FUN-9C0014
      LET l_flag = 'N'
      #add 030625 NO.A083
      SELECT SUM(oot05),SUM(oot05x),SUM(oot05t)
        INTO l_oot05,l_oot05x,l_oot05t
        FROM oma_file,oot_file 
       WHERE oma01 = oot03
         AND oma01 = sr.oma01
      IF cl_null(l_oot05)  THEN LET l_oot05  = 0 END IF
      IF cl_null(l_oot05x) THEN LET l_oot05x = 0 END IF
      IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
 
      #modify 030625 NO.A083
      LET g_oma59 = g_oma59 + g_oma.oma59  - l_oot05
      LET g_oma59t= g_oma59t+ g_oma.oma59t - l_oot05t
      LET g_oma59x= g_oma59x+ g_oma.oma59x - l_oot05x
      LET l_oma04 = sr.oma04           #MOD-A50161 oma03 modify oma04
      LET l_oma21 = sr.oma21
      LET l_order1 = sr.order1
      LET l_order2 = sr.order2
      LET l_order3 = sr.order3
      LET l_order4 = sr.order4
 
    ON LAST ROW
#No.FUN-B90130 --begin 
       IF g_aza.aza26 ='2' THEN 
          UPDATE ome_file SET ome59 = g_oma59,
                              ome59t= g_oma59t,
                              ome59x= g_oma59x 
           WHERE ome01 = t_oma10 
             AND ome03 = g_oma75  
       ELSE  
          UPDATE ome_file SET ome59 = g_oma59,
                              ome59t= g_oma59t,
                              ome59x= g_oma59x 
           WHERE ome01 = t_oma10  
       END IF 
#No.FUN-B90130 --end
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#         CALL cl_err('upd ome',SQLCA.SQLCODE,0)   #No.FUN-660116
#No.FUN-710050--begin
#          CALL cl_err3("upd","ome_file",t_oma10,"",SQLCA.SQLCODE,"","upd ome",0)    #No.FUN-660116
          CALL s_errmsg('ome01',t_oma10,'upd ome',SQLCA.sqlcode,1) 
#No.FUN-710050--end
          LET g_success = 'N'
       END IF
       LET g_oma59 = 0
       LET g_oma59t= 0
       LET g_oma59x= 0
       LET g_end = t_oma10
 
END REPORT
 
FUNCTION p340_insome(sr,l_gec)    #INSERT INTO ome_file
  DEFINE sr        RECORD
                   order1     LIKE oma_file.oma04,                 #No.FUN-680123 VARCHAR(10),  #MOD-A50161 oma03 modify oma04 
                   order2     LIKE oma_file.oma04,                 #No.FUN-680123 VARCHAR(10),  #MOD-A50161 oma03 modify oma04 
                   order3     LIKE oma_file.oma04,                 #No.FUN-680123 VARCHAR(10),  #MOD-A50161 oma03 modify oma04 
                   order4     LIKE oma_file.oma04,                 #No.FUN-680123 VARCHAR(10),  #MOD-A50161 oma03 modify oma04 
                   oma00      LIKE oma_file.oma00,
                   oma01      LIKE oma_file.oma01,
                   omaconf    LIKE oma_file.omaconf,
                   oma04      LIKE oma_file.oma04,   #MOD-A50161 oma03 modify oma04
                   oma05      LIKE oma_file.oma05,
                   oma21      LIKE oma_file.oma21,
                   oma15      LIKE oma_file.oma15,
                   oma14      LIKE oma_file.oma14,
                   oma23      LIKE oma_file.oma23,
                   oma02      LIKE oma_file.oma02,
                   oma59      LIKE oma_file.oma59, 
                   oma59t     LIKE oma_file.oma59t,
                   oma59x     LIKE oma_file.oma59x,
                   oma75      LIKE oma_file.oma75    #No.FUN-B90130                   
                END RECORD,
         l_gec     RECORD LIKE gec_file.*,
         l_ome     RECORD LIKE ome_file.*
 
   INITIALIZE l_ome.* TO NULL
   LET l_ome.ome00 =g_oma.oma00[1,1]
   LET l_ome.ome01 =g_oma10
   LET l_ome.ome02 =g_date     
   LET l_ome.ome04 =sr.oma04     #MOD-A50161 oma03 modify oma04   
   SELECT occ11,occ18,occ231 INTO l_ome.ome042,l_ome.ome043,l_ome.ome044
          FROM occ_file WHERE occ01=sr.oma04    #MOD-A50161 oma03 modify oma04
   LET l_ome.ome05 =ar_no      
   LET l_ome.ome08 =g_oma.oma08
   LET l_ome.ome171=l_gec.gec08
   LET l_ome.ome172=l_gec.gec06
 # LET l_ome.ome21 =sr.oma21
   LET l_ome.ome21 =l_gec.gec01
   LET l_ome.ome211=l_gec.gec04 
   LET l_ome.ome212=l_gec.gec05 
   LET l_ome.ome213=l_gec.gec07 
   LET l_ome.ome59 =0      
   LET l_ome.ome59x=0       
   LET l_ome.ome59t=0       
   LET l_ome.omevoid='N'
   LET l_ome.omeprsw='0'
   LET l_ome.omeuser=g_user
   LET l_ome.omegrup=g_grup
   LET l_ome.omedate=TODAY
   LET l_ome.omelegal = g_legal #FUN-980011 add
   LET l_ome.ome03  =  g_oma75     #No.FUN-B90130
   #FUN-970108---Begin
   SELECT oom13 INTO l_ome.ome60 FROM oom_file
    WHERE oom07 <= l_ome.ome01 
      AND oom08 >= l_ome.ome01
      AND oom03 =  l_ome.ome05
      AND (oom16 = l_ome.ome03 OR oom16 IS NULL )    #No.FUN-B90130
   #FUN-970108---End
   #No.CHI-790002 START
   IF cl_null(l_ome.ome01) THEN LET l_ome.ome01=' ' END IF
   #No.CHI-790002 END  
   LET l_ome.omeoriu = g_user      #No.FUN-980030 10/01/04
   LET l_ome.omeorig = g_grup      #No.FUN-980030 10/01/04
#FUN-B90097 begin ---
   IF cl_null(l_ome.ome70) THEN LET l_ome.ome70 = 'N' END IF
   IF cl_null(l_ome.ome74) THEN LET l_ome.ome74 = 0 END IF
   IF cl_null(l_ome.ome75) THEN LET l_ome.ome75 = 0 END IF
   IF cl_null(l_ome.ome76) THEN LET l_ome.ome76 = 0 END IF
   IF cl_null(l_ome.ome77) THEN LET l_ome.ome77 = ' ' END IF
   IF cl_null(l_ome.ome78) THEN LET l_ome.ome78 = 0 END IF
   IF cl_null(l_ome.ome79) THEN LET l_ome.ome79 = 0 END IF
   IF cl_null(l_ome.ome80) THEN LET l_ome.ome80 = 0 END IF
#FUN-B90097 end ---
   IF l_ome.ome03 IS NULL THEN LET l_ome.ome03 = ' ' END IF    #No.FUN-B90130  
   IF cl_null(l_ome.ome22) THEN LET l_ome.ome22 = 'N'  END IF  #FUN-C40078
   IF cl_null(l_ome.omecncl) THEN LET l_ome.omecncl = 'N' END IF  #FUN-C70030 add
   IF cl_null(l_ome.ome81) THEN LET l_ome.ome81 = '1' END IF  #FUN-C80002 add
   INSERT INTO ome_file VALUES(l_ome.*)
   ##NO.TQC-790100 START--------------------------
   ##IF STATUS AND STATUS!= -239 THEN
   IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
   ##NO.TQC-790100 END----------------------------
#     CALL cl_err('ins ome:',SQLCA.SQLCODE,1)  #No.FUN-660116
      CALL cl_err3("ins","ome_file",l_ome.ome00,l_ome.ome01,SQLCA.SQLCODE,"","ins ome",1)    #No.FUN-660116
      LET g_success='N' 
      RETURN
   END IF
   ##NO.TQC-790100 START--------------------------
   ##IF SQLCA.sqlcode=-239 THEN
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
   ##NO.TQC-790100 END----------------------------
#No.FUN-B90130 --begin 
      IF g_aza.aza26 ='2' THEN 
         SELECT SUM(oma59),SUM(oma59x),SUM(oma59t)
           INTO g_oma59, g_oma59x, g_oma59t
           FROM oma_file 
          WHERE oma10=l_ome.ome01 
            AND oma75 = l_ome.ome03 
      ELSE 
         SELECT SUM(oma59),SUM(oma59x),SUM(oma59t)
           INTO g_oma59, g_oma59x, g_oma59t
           FROM oma_file 
          WHERE oma10=l_ome.ome01  
      END IF 
#No.FUN-B90130 --end      
      IF g_oma59 IS NULL THEN
         LET g_oma59 = 0 LET g_oma59x= 0 LET g_oma59t= 0
      END IF
#No.FUN-B90130 --begin 
      IF g_aza.aza26 ='2' THEN 
         UPDATE ome_file
            SET ome05 =ar_no,ome08=g_oma.oma08,
                ome21 =l_gec.gec01,ome211=l_gec.gec04,
                ome212=l_gec.gec05,ome213=l_gec.gec07,
                ome59=g_oma59,ome59x=g_oma59x,
                ome59t=g_oma59t
          WHERE ome01=l_ome.ome01 
            AND ome03 = l_ome.ome03 
      ELSE  
         UPDATE ome_file
            SET ome05 =ar_no,ome08=g_oma.oma08,
                ome21 =l_gec.gec01,ome211=l_gec.gec04,
                ome212=l_gec.gec05,ome213=l_gec.gec07,
                ome59=g_oma59,ome59x=g_oma59x,
                ome59t=g_oma59t
          WHERE ome01=l_ome.ome01 
      END IF 
#No.FUN-B90130 --end
      UPDATE ome_file
         SET ome05 =ar_no,ome08=g_oma.oma08,
             ome21 =l_gec.gec01,ome211=l_gec.gec04,
             ome212=l_gec.gec05,ome213=l_gec.gec07,
             ome59=g_oma59,ome59x=g_oma59x,
             ome59t=g_oma59t
       WHERE ome01=l_ome.ome01
      #No.+041 010330 by plum
      #IF STATUS THEN
      #  CALL cl_err('upd ome59:',STATUS,1) LET g_success='N' RETURN
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('upd ome59: ',SQLCA.SQLCODE,1)   #No.FUN-660116
          CALL cl_err3("upd","ome_file",l_ome.ome01,"",SQLCA.SQLCODE,"","upd ome59:",1)    #No.FUN-660116
          LET g_success='N' RETURN
       END IF
     #No.+041..end
   END IF
 
END FUNCTION

#CHI-A70028 add --start--
FUNCTION p340_insomee()    #INSERT INTO omee_file
  DEFINE l_omee    RECORD LIKE omee_file.*
   INITIALIZE l_omee.* TO NULL
   LET l_omee.omee01 = g_oma10 
   LET l_omee.omee02 = g_oma.oma01 
   LET l_omee.omeedate = TODAY 
   LET l_omee.omeegrup = g_grup
   LET l_omee.omeelegal = g_legal
   LET l_omee.omeeorig = g_grup 
   LET l_omee.omeeoriu = g_user
   LET l_omee.omeeuser = g_user
#No.FUN-B90130 --begin  
   #LET l_omee.omee03 = g_oma.oma75  #TQC-BC0118
   LET l_omee.omee03 = g_oma75
   IF l_omee.omee03 IS NULL THEN LET l_omee.omee03 =' ' END IF 
#No.FUN-B90130 --end
   INSERT INTO omee_file VALUES(l_omee.*)
   IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
      CALL cl_err3("ins","omee_file",l_omee.omee01,l_omee.omee02,SQLCA.SQLCODE,"","ins omee",1)
      LET g_success='N' 
      RETURN
   END IF
END FUNCTION
#CHI-A70028 add --end--
