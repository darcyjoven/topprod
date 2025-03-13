# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apsi400.4gl
# Descriptions...: APS 需求訂單優先順序制定維護作業
# Date & Author..: 08/04/16 By jamie #FUN-840069
# Modify.........: NO:FUN-890041 08/09/09 BY DUKE 增加優先序自訂及獨立需求更新ACTION
# Modify.........: No:TQC-890042 08/09/09 BY DUKE 自訂排序ACTION 
# Modify.........: No:TQC-8A0004 08/10/01 BY DUKE change vmu24 from rpc13
# Modify.........: No:FUN-8A0052 08/10/09 BY DUKE 限定版本功能
# Modify.........: No:TQC-920083 09/02/25 BY DUKE 按10開始重排直接依序號重排即可
# Modify.........: No:CHI-930015 09/03/06 BY DUKE APS版本及儲存版本均改為開窗單選
# Modify.........: No:FUN-940001 09/04/01 BY DUKE 增加需求來源查詢ACTION, 透過vmu11銷售訂單及vmu25需求訂單來源串連對應作業
# Modify.........: No:FUN-940064 09/04/17 BY DUKE 主畫面增加整批嚴守交期及整批取消嚴守交期,
#                                                 優先序制定增加料件優先序制定(依客戶優先序制定),並於子畫面加上由10重排及依產品分類碼排序
# Modify.........: No:TQC-940150 09/04/29 By Duke 修正無單身資料時,需求來源action會當掉的狀況
# Modify.........: No:FUN-A30080 10/03/24 By Lilan 1.Action "獨立需求更新"內的SQL寫法改寫 
#                                                  2.一併調整原程式非制式寫作規範的SQL語法 
#                                                  3.原rpc13>rpc131的SQL寫法,當rpc131為NULL時，該筆資料會無法納入
#                                                  4.若已耗需求(rpc131)為null,納進需求檔(vmu_file)時,已出貨量(vmu13)預設塞0 
# Modify.........: No:FUN-A30109 10/03/29 By Lilan 寫法調整,使相容於GP1.X
# Modify.........: No.FUN-AB0090 10/12/01 By Mandy 優先序功能調整 
# Modify.......... No.TQC-AC0270 10/12/17 By Mandy 按"獨立需求更新"後,產生的vmu_file的優先順序,也應按優先序規則重排
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B80053 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B60063 11/07/31 By Mandy 當為預測資料時,按需求來源查詢無法串至正確的axmi171
# Modify.........: No.FUN-BA0036 11/11/29 By Mandy 原可沖銷量欄位,當需求來源類別(vmu25)為:一般訂單時,則其值直接給vmu24,當需求來源類別為:(0,2,3)時,其值為(vmu24-vmu13)
# Modify.........: No.FUN-BB0085 11/12/22 By xianghui 增加數量欄位小樹取位
#Modify..........: No.MOD-C80108 12/08/15 By SunLM vmu02增加開窗

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-840069 
#模組變數(Module Variables)
DEFINE   g_vmu01              LIKE vmu_file.vmu01,      #APS版本  (假單頭)
         g_vmu02              LIKE vmu_file.vmu02,      #儲存版本 (假單頭)
         g_vmu01_t            LIKE vmu_file.vmu01,      #APS版本  (假單頭)                 
         g_vmu02_t            LIKE vmu_file.vmu02,      #儲存版本 (假單頭)                 
         g_vmu              DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
            vmu10             LIKE vmu_file.vmu10,      #
            vmu22             LIKE vmu_file.vmu22,      #
            vmu18             LIKE vmu_file.vmu18,      #
            vmu03             LIKE vmu_file.vmu03,      #
            vmu23             LIKE vmu_file.vmu23,      #
            vmu24             LIKE vmu_file.vmu24,      #
            l_qty             LIKE vmu_file.vmu24,
            vmu04             LIKE vmu_file.vmu04,      #
            vmu06             LIKE vmu_file.vmu06,      #
            vmu08             LIKE vmu_file.vmu08,      #
            vmu09             LIKE vmu_file.vmu09,      #
            vmu25             LIKE vmu_file.vmu25,      #FUN-890041
            vmu11             LIKE vmu_file.vmu11,      #
            vmu12             LIKE vmu_file.vmu12,      #
            vmu13             LIKE vmu_file.vmu13,      #
            vmu14             LIKE vmu_file.vmu14,      #
            vmu15             LIKE vmu_file.vmu15,      #
            vmu16             LIKE vmu_file.vmu16,      #
            vmu17             LIKE vmu_file.vmu17,      #
            vmu19             LIKE vmu_file.vmu19,      #
            vmu21             LIKE vmu_file.vmu21       #
                             END RECORD,
         g_vmu_t             RECORD                     #程式變數 (舊值)
            vmu10             LIKE vmu_file.vmu10,      #
            vmu22             LIKE vmu_file.vmu22,      #
            vmu18             LIKE vmu_file.vmu18,      #
            vmu03             LIKE vmu_file.vmu03,      #
            vmu23             LIKE vmu_file.vmu23,      #
            vmu24             LIKE vmu_file.vmu24,      #
            l_qty             LIKE vmu_file.vmu24,
            vmu04             LIKE vmu_file.vmu04,      #
            vmu06             LIKE vmu_file.vmu06,      #
            vmu08             LIKE vmu_file.vmu08,      #
            vmu09             LIKE vmu_file.vmu09,      #
            vmu25             LIKE vmu_file.vmu25,      #FUN-890014
            vmu11             LIKE vmu_file.vmu11,      #
            vmu12             LIKE vmu_file.vmu12,      #
            vmu13             LIKE vmu_file.vmu13,      #
            vmu14             LIKE vmu_file.vmu14,      #
            vmu15             LIKE vmu_file.vmu15,      #
            vmu16             LIKE vmu_file.vmu16,      #
            vmu17             LIKE vmu_file.vmu17,      #
            vmu19             LIKE vmu_file.vmu19,      #
            vmu21             LIKE vmu_file.vmu21       #
                             END RECORD,

         g_name              LIKE vmu_file.vmu04,      #No.FUN-680135 VARCHAR(10)
         g_wc,g_wc2,g_sql    STRING,                   #No:FUN-580092 HCN
         l_sql,l_sql2        STRING,                   #FUN-890041
         l_sqls1,l_sqls2,l_sqls3   STRING,             #FUN-890041 
        #g_vmu_rowid         LIKE type_file.chr18,     #No.FUN-680135 INT # saki 20070821 rowid chr18 -> num10 #FUN-B50022 mark
         g_vmu03             LIKE vmu_file.vmu03,      #FUN-B50022 add
         g_rec_b             LIKE type_file.num10,     #單身筆數      #No.FUN-680135 INTEGER
         g_ss                LIKE type_file.chr1,      #決定後續步驟  #No.FUN-680135 VARCHAR(1)
         l_ac                LIKE type_file.num5,      #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
         g_argv1             LIKE vmu_file.vmu01       #No.FUN-680135 VARCHAR(10)

DEFINE    cust_vmu     DYNAMIC ARRAY OF RECORD
         #seq       LIKE  type_file.num5, #FUN-AB0090 mark
          seq       LIKE  vlp_file.vlp02, #FUN-AB0090 add
          vmu06     LIKE  vmu_file.vmu06,
          occ02     LIKE  occ_file.occ02,
          vmu15     LIKE  vmu_file.vmu15
          END RECORD

DEFINE    sales_vmu     DYNAMIC ARRAY OF RECORD
         #seq       LIKE  type_file.num5, #FUN-AB0090 mark
          seq       LIKE  vlp_file.vlp02, #FUN-AB0090 add
          gen01     LIKE  gen_file.gen01,
          gen02     LIKE  gen_file.gen02,
          gen03     LIKE  gen_file.gen03,
          gem02     LIKE  gem_file.gem02
          END RECORD

#FUN-940064  ADD  --STR-------------------------------------------
DEFINE    part_vmu     DYNAMIC ARRAY OF RECORD
         #seq       LIKE  type_file.num5, #FUN-AB0090 mark
          seq       LIKE  vlp_file.vlp02, #FUN-AB0090 add
          ima01     LIKE  ima_file.ima01,
          ima02     LIKE  ima_file.ima02,
          ima131    LIKE  ima_file.ima131,
          oba02     LIKE  oba_file.oba02
          END RECORD
#FUN-940064  ADD  --END-------------------------------------------

#FUN-A30080 add str ----------------------------
DEFINE g_tmp      RECORD
                   vmu01 LIKE vmu_file.vmu01,    #APS版本
                   vmu02 LIKE vmu_file.vmu02,    #儲存版本
                   vmu03 LIKE vmu_file.vmu03,    #需求訂單編號
                   vmu04 LIKE vmu_file.vmu04,    #交期
                   vmu05 LIKE vmu_file.vmu05,    #可否耗用
                   vmu06 LIKE vmu_file.vmu06,    #客戶編號
                   vmu07 LIKE vmu_file.vmu07,    #是否能排程
                   vmu08 LIKE vmu_file.vmu08,    #需求訂單形式
                   vmu09 LIKE vmu_file.vmu09,    #
                   vmu10 LIKE vmu_file.vmu10,    #訂單優先順序
                   vmu11 LIKE vmu_file.vmu11,
                   vmu12 LIKE vmu_file.vmu12,
                   vmu13 LIKE vmu_file.vmu13,
                   vmu14 LIKE vmu_file.vmu14,
                   vmu15 LIKE vmu_file.vmu15,
                   vmu16 LIKE vmu_file.vmu16,
                   vmu17 LIKE vmu_file.vmu17,
                   vmu18 LIKE vmu_file.vmu18,
                   vmu19 LIKE vmu_file.vmu19,
                   vmu20 LIKE vmu_file.vmu20,
                   vmu21 LIKE vmu_file.vmu21,
                   vmu22 LIKE vmu_file.vmu22,
                   vmu23 LIKE vmu_file.vmu23,
                   vmu24 LIKE vmu_file.vmu24,
                   vmu25 LIKE vmu_file.vmu25,
                   vmu26 LIKE vmu_file.vmu26
                 END RECORD
#FUN-A30080 add end ----------------------------

#主程式開始
DEFINE   g_cmd              STRING                   #FUN-940001 ADD
DEFINE   g_vlz70            LIKE vlz_file.vlz70      #FUN-8A0052 add
DEFINE   g_sql_limited      STRING                   #FUN-8A0052 add
DEFINE   g_chr              LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt              LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_cnts             LIKE type_file.num10
DEFINE   g_i                LIKE type_file.num5      #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE   g_msg              LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql       STRING                   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   mi_curs_index      LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_row_count        LIKE type_file.num10     #No:FUN-580092 HCN   #No.FUN-680135 INTEGER
DEFINE   l_row_count        LIKE type_file.num10     #FUN-890041
DEFINE   mi_jump            LIKE type_file.num10,    #No.FUN-680135 INTEGER
         mi_no_ask          LIKE type_file.num5,      #No.FUN-680135 SMALLINT
         l_choice01         LIKE type_file.chr1,     #FUN-890041 排序條件1
         l_choice02         LIKE type_file.chr1,     #FUN-890041 排序條件2
         l_choice03         LIKE type_file.chr1,     #FUN-890041 排序條件3
         l_choice04         LIKE type_file.chr1,     #FUN-890041 排序條件4     
         l_choice05         LIKE type_file.chr1      #FUN-AB0090 add
DEFINE g_rec_b_part         LIKE type_file.num10     #FUN-AB0090 add
DEFINE g_rec_b_cust         LIKE type_file.num10     #FUN-AB0090 add
DEFINE g_rec_b_sales        LIKE type_file.num10     #FUN-AB0090 add


MAIN
   DEFINE   p_row,p_col     LIKE type_file.num5      #No.FUN-680135  SMALLINT 

   #FUN-B50022---mod---str----
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP                                  #輸入的方式: 不打轉
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理
   #FUN-B50022---mod---end----

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time                 #No.FUN-6A0096
   LET g_argv1 = ARG_VAL(1)               #
   LET g_vmu01 = NULL                     #清除鍵值
   LET g_vmu02 = NULL                     #清除鍵值
   LET g_vmu01_t = NULL
   LET g_vmu02_t = NULL
   LET p_row = 4 LET p_col = 20

   OPEN WINDOW apsi400_w AT p_row,p_col WITH FORM "aps/42f/apsi400"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL i400_cre_temp()                 #FUN-AB0090 add

   IF NOT cl_null(g_argv1) THEN CALL i400_q() END IF

   CALL i400_menu()
   CLOSE WINDOW apsi400_w               #結束畫面
   DROP TABLE cust_tmp
   DROP TABLE sales_tmp
   DROP TABLE part_tmp                  #FUN-940064 ADD

    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time               #No.FUN-6A0096
END MAIN

FUNCTION i400_curs()

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "vmu01 = '",g_argv1,"'"
   ELSE
      CLEAR FORM                             #清除畫面
      CALL g_vmu.clear()
      CALL cl_set_head_visible("","YES")     
      CONSTRUCT g_wc ON vmu01,vmu02 FROM vmu01,vmu02

          ON ACTION CONTROLP
             CASE
                WHEN INFIELD(vmu01)     #APS版本名稱
                   CALL cl_init_qry_var()
                   #LET g_qryparam.state='c'  #CHI-930015 MARK
                   LET g_qryparam.form="q_vld01"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret  #CHI-930015 MARK
                   #DISPLAY g_qryparam.multiret TO vmu01                #CHI-930015 MARK 
                   CALL cl_create_qry() RETURNING g_vmu01,g_vmu02  #CHI-930015 ADD
                   DISPLAY g_vmu01 TO FORMONLY.vmu01       #CHI-930015 ADD
                   DISPLAY g_vmu02 TO FORMONLY.vmu02       #CHI-930015 ADD
                   NEXT FIELD vmu01
#MOD-C80108 add beg----
                WHEN INFIELD(vmu02)    
                   CALL cl_init_qry_var()
                   LET g_qryparam.form="q_vmu02"
                   CALL cl_create_qry() RETURNING g_vmu02
                   DISPLAY g_vmu02 TO FORMONLY.vmu02
                   NEXT FIELD vmu02
#MOD-C80108 add end-----                   
             END CASE

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121

      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
   END IF

   LET g_sql= "SELECT UNIQUE vmu01,vmu02 FROM vmu_file ",
              " WHERE ", g_wc  CLIPPED,
              " ORDER BY vmu01"
   DISPLAY g_sql
   PREPARE i400_prepare FROM g_sql      #預備一下
   DECLARE i400_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i400_prepare

   DELETE FROM   count_tmp
   LET g_sql="SELECT vmu01,vmu02  ",
             "  FROM vmu_file             ",
             " WHERE ", g_wc CLIPPED,
             " GROUP BY vmu01,vmu02 ",
             " INTO TEMP count_tmp"
   PREPARE i400_cnt_tmp  FROM g_sql
   EXECUTE i400_cnt_tmp
   DECLARE i400_count CURSOR FOR SELECT COUNT(*) FROM count_tmp

END FUNCTION

FUNCTION i400_menu()

   WHILE TRUE
      CALL i400_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i400_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL i400_b()
            ELSE
               LET g_action_choice = NULL
            END IF


         #FUN-940001 ADD  --STR--
         WHEN  "aps_need_ord_from"
              CALL i400_needord_from()
         #FUN-940001 ADD  --END--

         WHEN "aps_re_sort"
            IF cl_chk_act_auth() THEN
               LET l_choice01 = NULL   #FUN-890041 add
               LET l_choice02 = NULL   #FUN-890041 add
               LET l_choice03 = NULL   #FUN-890041 add
               LET l_choice04 = NULL   #FUN-890041 add
               CALL i400_b_y()
               CALL i400_b_fill(0)
            END IF

         #FUN-890041
         #-------begin-----------------

         WHEN "inddemd_up"
         #TQC-890042
               CALL i400_indrefresh()


         WHEN "order_set_owner"
           #FUN-AB0090---mark---str---
           #IF g_rec_b>0 THEN  #TQC-890042
           #   #FUN-890041 建立TEMP FILE
           #    CALL i400_cre_temp()                 
           #END IF
           #FUN-AB0090---mark---str---
           #FUN-AB0090---add----str---
            IF cl_chk_act_auth() THEN
                IF g_rec_b>0 THEN  
                    CALL i400_reorder_cursor()           
                    CALL i400_fill_part_tmp()            
                    CALL i400_fill_cust_tmp()            
                    CALL i400_fill_sales_tmp()           
                    CALL i400_orderset_owner()
                END IF
            END IF
           #FUN-AB0090---add----end---
 

         #-------end------------------

         #FUN-940064  ADD  --STR-----------
         WHEN "all_setY_redate"
            CALL i400_all_setY_redate()

         WHEN "all_setN_redate"
            CALL i400_all_setN_redate()
         #FUN-940064  ADD  --END-----------

         WHEN "next"
            CALL i400_fetch('N')
         WHEN "previous"
            CALL i400_fetch('P')
         WHEN  "help"
            CALL cl_show_help()
         WHEN  "exit"
            EXIT WHILE
         WHEN  "jump"
            CALL i400_fetch('/')
         WHEN  "first"
            CALL i400_fetch('F')
         WHEN  "last"
            CALL i400_fetch('L')

         #FUN-940001 ADD  --STR--
         WHEN  "aps_need_ord_from"
            CALL i400_needord_from()
         #FUN-940001 ADD  --END--

         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vmu),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i400_q()
   LET g_row_count = 0
   LET mi_curs_index = 0

   CALL cl_navigator_setting(mi_curs_index,g_row_count)

   MESSAGE ""

   CALL cl_opmsg('q')
   CALL i400_curs()                           #取得查詢條件

   IF INT_FLAG THEN                           #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF

   OPEN i400_count
    FETCH i400_count INTO g_row_count         #No:FUN-580092 HCN
    DISPLAY g_row_count TO FORMONLY.cnt       #No:FUN-580092 HCN

   OPEN i400_b_curs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                      #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_vmu01 TO NULL
      INITIALIZE g_vmu02 TO NULL
   ELSE
      CALL i400_fetch('F')                    #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION i400_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式   #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10     #絕對的筆數 #No.FUN-680135 INTEGER

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i400_b_curs INTO g_vmu01,g_vmu02
      WHEN 'P' FETCH PREVIOUS i400_b_curs INTO g_vmu01,g_vmu02
      WHEN 'F' FETCH FIRST    i400_b_curs INTO g_vmu01,g_vmu02
      WHEN 'L' FETCH LAST     i400_b_curs INTO g_vmu01,g_vmu02
      WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                  LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR mi_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121
                  
                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121
                  
                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
      FETCH ABSOLUTE mi_jump i400_b_curs INTO g_vmu01,g_vmu02
      LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_vmu01,SQLCA.sqlcode,0)
      INITIALIZE g_vmu01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'L' LET mi_curs_index = g_row_count #No:FUN-580092 HCN
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE

      CALL cl_navigator_setting(mi_curs_index, g_row_count) #No:FUN-580092 HCN
      CALL i400_show()
   END IF
END FUNCTION

FUNCTION i400_show()
   DISPLAY g_vmu01 TO FORMONLY.vmu01              #單頭
   DISPLAY g_vmu02 TO FORMONLY.vmu02              #單頭

   CALL i400_b_fill(0)                            #單身

   CALL cl_show_fld_cont()                        #No:FUN-550037 hmf
END FUNCTION

FUNCTION i400_b()
   DEFINE   l_vmu10          LIKE vmu_file.vmu10       #FUN-A30109 add
   DEFINE   l_vmu22          LIKE vmu_file.vmu22       #FUN-A30109 add
   DEFINE   l_ac_t           LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-680135 SMALLINT 
            l_n              LIKE type_file.num5,      #檢查重複用         #No.FUN-680135 SMALLINT
            l_lock_sw        LIKE type_file.chr1,      #單身鎖住否         #No.FUN-680135 VARCHAR(1)
            p_cmd            LIKE type_file.chr1,      #處理狀態           #No.FUN-680135 VARCHAR(1)
            l_allow_insert   LIKE type_file.num5,      #可新增否           #No.FUN-680135 SMALLINT
            l_allow_delete   LIKE type_file.num5,      #可刪除否           #No.FUN-680135 SMALLINT
            ls_cnt           LIKE type_file.num5       #No.FUN-680135      SMALLINT

   LET g_action_choice = ""

   IF g_vmu01 IS NULL THEN
      RETURN
   END IF
  #LET l_allow_insert = cl_detail_input_auth("insert")
  #LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE 

   CALL cl_opmsg('b')

   LET g_forupd_sql =
                     "SELECT vmu10,vmu22 ",
                     "  FROM vmu_file    ",
                    #" WHERE vmu01=? AND vmu02=? AND vmu03=? FOR UPDATE NOWAIT " #FUN-B50022 mark
                     " WHERE vmu01=? AND vmu02=? AND vmu03=? FOR UPDATE        " #FUN-B50022 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50022 add

   DECLARE i400_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_vmu WITHOUT DEFAULTS FROM s_vmu.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET g_vmu_t.* = g_vmu[l_ac].*  #BACKUP
            LET p_cmd='u'
            OPEN i400_b_curl USING g_vmu01,g_vmu02,g_vmu[l_ac].vmu03
            IF STATUS THEN
               CALL cl_err("OPEN i400_b_cur1:",STATUS,1)
               LET l_lock_sw = "Y"
            ELSE
              #FETCH i400_b_curl INTO g_vmu[l_ac].*      #FUN-A30109 mark
               FETCH i400_b_curl INTO l_vmu10,l_vmu22    #FUN-A30109 add
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_vmu_t.vmu10,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF

      BEFORE FIELD vmu10                        #default 序號
         #只有update才需要作下面此段，否則會造成array size錯誤
         IF p_cmd = 'u' THEN
            IF (g_vmu[l_ac].vmu10 IS NULL OR g_vmu[l_ac].vmu10=0) AND l_ac>1 THEN
               IF g_vmu[l_ac+1].vmu10>g_vmu[l_ac-1].vmu10+1 THEN
                  LET g_vmu[l_ac].vmu10=g_vmu[l_ac-1].vmu10+1
               END IF
            END IF
         END IF
         IF g_vmu[l_ac].vmu10 IS NULL OR g_vmu[l_ac].vmu10 = 0 THEN
            SELECT max(vmu10)+1
              INTO g_vmu[l_ac].vmu10
              FROM vmu_file
             WHERE vmu01 = g_vmu01
               AND vmu02 = g_vmu02
            IF g_vmu[l_ac].vmu10 IS NULL THEN
               LET g_vmu[l_ac].vmu10 = 1
            END IF
         END IF

      AFTER FIELD vmu10                        #check 序號是否重複
         IF NOT cl_null(g_vmu[l_ac].vmu10) THEN
            IF g_vmu[l_ac].vmu10 != g_vmu_t.vmu10 OR g_vmu_t.vmu10 IS NULL THEN
               SELECT count(*)
                 INTO l_n
                 FROM vmu_file
                WHERE vmu01 = g_vmu01
                  AND vmu02 = g_vmu02
                  AND vmu10 = g_vmu[l_ac].vmu10
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_vmu[l_ac].vmu10 = g_vmu_t.vmu10
                  NEXT FIELD vmu10
               END IF
            END IF
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_vmu[l_ac].* = g_vmu_t.*
            CLOSE i400_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_vmu[l_ac].vmu10,-263,1)
            LET g_vmu[l_ac].* = g_vmu_t.*
         ELSE
            UPDATE vmu_file SET vmu10=g_vmu[l_ac].vmu10,
                                vmu22=g_vmu[l_ac].vmu22
             WHERE vmu01=g_vmu01
               AND vmu02=g_vmu02
               AND vmu03=g_vmu[l_ac].vmu03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","vmu_file",g_vmu01,g_vmu_t.vmu10,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_vmu[l_ac].* = g_vmu_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_vmu[l_ac].* = g_vmu_t.*
            END IF
            CLOSE i400_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i400_b_curl
         COMMIT WORK

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION aps_re_sort_b
         LET l_choice01 = NULL   #FUN-890041 add
         LET l_choice02 = NULL   #FUN-890041 add
         LET l_choice03 = NULL   #FUN-890041 add
         LET l_choice04 = NULL   #FUN-890041 add
         CASE WHEN INFIELD(vmu10) CALL i400_b_y()
                                  CALL i400_b_fill(0)
                                  EXIT INPUT
         END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","YES")                                                                                        

   END INPUT

   CLOSE i400_b_curl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i400_b_y()
   DEFINE r,i,j LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE cust_cnt,sales_cnt  LIKE type_file.num10  #FUN-890041 add
   DEFINE part_cnt            LIKE type_file.num10  #FUN-940064 ADD

   #FUN-890041  增加排序判斷 choice01 - 05
   LET l_sql = '  ORDER BY'
   
   #FUN-940064  MARK  --STR------------------------------------------------- 
   # IF l_choice01 = '1' THEN  LET l_sqls1 = ' vmu23,'
   #    ELSE  IF l_choice01 = '2' THEN  LET l_sqls1 = ' vmu06,'
   #      ELSE  IF l_choice01 = '3' THEN  LET l_sqls1 = ' vmu16,'
   #        ELSE  IF l_choice01 = '4' and l_choice04='R' THEN  LET l_sqls1 = ' vmu08 desc,'
   #        ELSE  IF l_choice01 = '4' and (l_choice04='F' or cl_null(l_choice04))  THEN  LET l_sqls1 = ' vmu08, '
   #          ELSE  IF l_choice01 = '5' THEN  LET l_sqls1 = ' vmu04,'
   #                ELSE LET l_sqls1 = ' '
   #                END IF
   #              END IF
   #              END IF 
   #            END IF
   #          END IF
   # END IF
   #
   #IF l_choice02 = '1' THEN  LET l_sqls2 = ' vmu23,'
   #   ELSE  IF l_choice02 = '2' THEN  LET l_sqls2 = ' vmu06,'
   #     ELSE  IF l_choice02 = '3' THEN  LET l_sqls2 = ' vmu16,'
   #       ELSE  IF l_choice02 = '4' and l_choice04='R' THEN  LET l_sqls2 = ' vmu08 desc,'
   #       ELSE  IF l_choice02 = '4' and (l_choice04='F' or cl_null(l_choice04)) THEN  LET l_sqls2 = ' vmu08,'   
   #         ELSE  IF l_choice02 = '5' THEN  LET l_sqls2 = ' vmu04,'
   #               ELSE LET l_sqls2 = ' '
   #               END IF
   #             END IF
   #             END IF
   #           END IF
   #         END IF
   #END IF
   #
   #IF l_choice03 = '1' THEN  LET l_sqls3 = ' vmu23,'
   #   ELSE  IF l_choice03 = '2' THEN  LET l_sqls3 = ' vmu06,'
   #     ELSE  IF l_choice03 = '3' THEN  LET l_sqls3 = ' vmu16,'
   #       ELSE  IF l_choice03 = '4' and l_choice04='R' THEN  LET l_sqls3 = ' vmu08,'
   #       ELSE  IF l_choice03 = '4' and (l_choice04='F' or cl_null(l_choice04)) THEN  LET l_sqls3 = ' vmu08, '  
   #         ELSE  IF l_choice03 = '5' THEN  LET l_sqls3 = ' vmu04,'
   #               ELSE LET l_sqls3 = ' '
   #               END IF
   #             END IF
   #             END IF 
   #           END IF
   #         END IF
   #END IF
   #FUN-940064  MARK  --END-------------------------------------------------

   #FUN-940064  ADD   --STR-------------------------------------------------  
   CASE 
     WHEN l_choice01 = '1'   LET l_sqls1 = ' vmu23,'
     WHEN l_choice01 = '2'   LET l_sqls1 = ' vmu06,'
     WHEN l_choice01 = '3'   LET l_sqls1 = ' vmu16,'
     WHEN l_choice01 = '4' AND l_choice04='R'  LET l_sqls1 = ' vmu08 desc,'
     WHEN l_choice01 = '4' AND (l_choice04='F' OR cl_null(l_choice04))    LET l_sqls1 = ' vmu08, '
     WHEN l_choice01 = '5'   LET l_sqls1 = ' vmu04,'
     OTHERWISE
          LET l_sqls1 = ' '
   END CASE   
 
   CASE 
     WHEN l_choice02 = '1'   LET l_sqls2 = ' vmu23,'
     WHEN l_choice02 = '2'   LET l_sqls2 = ' vmu06,'
     WHEN l_choice02 = '3'   LET l_sqls2 = ' vmu16,'
     WHEN l_choice02 = '4' AND l_choice04='R'  LET l_sqls2 = ' vmu08 desc,'
     WHEN l_choice02 = '4' AND (l_choice04='F' OR cl_null(l_choice04))    LET l_sqls2 = ' vmu08, '
     WHEN l_choice02 = '5'   LET l_sqls2 = ' vmu04,'
     OTHERWISE
          LET l_sqls2 = ' '
   END CASE   
 
   CASE 
     WHEN l_choice03 = '1'   LET l_sqls3 = ' vmu23,'
     WHEN l_choice03 = '2'   LET l_sqls3 = ' vmu06,'
     WHEN l_choice03 = '3'   LET l_sqls3 = ' vmu16,'
     WHEN l_choice03 = '4' AND l_choice04='R'  LET l_sqls3 = ' vmu08 desc,'
     WHEN l_choice03 = '4' AND (l_choice04='F' OR cl_null(l_choice04))    LET l_sqls3 = ' vmu08, '
     WHEN l_choice03 = '5'   LET l_sqls3 = ' vmu04,'
     OTHERWISE
          LET l_sqls3 = ' '
   END CASE   
   #FUN-940064  ADD   --END-------------------------------------------------


   LET cust_cnt  = 0
   LET sales_cnt = 0
   LET part_cnt  = 0     #FUN-940064 ADD

   IF l_choice01<>'2' AND l_choice02<>'2' AND l_choice03<>'2' THEN
      DELETE FROM cust_tmp
   END IF

   IF l_choice01<>'3' AND l_choice02<>'3' AND l_choice03<>'3' THEN
      DELETE FROM sales_tmp
   END IF

  #FUN-940064  ADD  --STR--
   IF l_choice01<>'1' AND l_choice02<>'1' AND l_choice03<>'1' THEN
     DELETE FROM part_tmp
   END IF
  #FUN-940064  ADD  --END--

   SELECT count(*) INTO cust_cnt FROM cust_tmp
   SELECT count(*) INTO sales_cnt FROM sales_tmp
   SELECT count(*) INTO part_cnt FROM part_tmp  #FUN-940064 ADD

  #FUN-940064  MARK  --STR---------------------------------------------------
  ##IF cust_cnt>0 THEN  #TQC-920083 MARK
  # IF cust_cnt>0 AND sales_cnt=0  THEN    #TQC-920083 ADD
  #   IF l_choice01='2' THEN
  #      LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,cust_tmp  ",
  #                   " WHERE vmu06=cust01 and vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
  #                   " order by seq,",l_sqls2,l_sqls3," vmu04"
  #   ELSE
  #   IF l_choice02='2' THEN
  #     LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,cust_tmp  ",
  #                  " WHERE vmu06=cust01 and vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
  #                  " order by ",l_sqls1," seq,",l_sqls3," vmu04"
  #   ELSE
  #   IF l_choice03='2' THEN
  #     LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,cust_tmp  ",
  #                  " WHERE vmu06=cust01 and vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
  #                  " order by ",l_sqls1,l_sqls2," seq,vmu04 "
  #   END IF
  #   END IF
  #   END IF
  # END IF
  #
  # #IF sales_cnt>0 THEN   #TQC-920083 MARK
  # IF cust_cnt=0 AND sales_cnt>0  THEN    #TQC-920083 ADD
  #   IF l_choice01='3' THEN
  #      LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,sales_tmp  ",
  #                   " WHERE vmu16=gen01 and vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
  #                   " order by seq,",l_sqls2,l_sqls3," vmu04"
  #   ELSE
  #   IF l_choice02='3' THEN
  #      LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,sales_tmp  ",
  #                   " WHERE vmu16=gen01 and vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
  #                   " order by ",l_sqls1," seq,",l_sqls3," vmu04"
  #   ELSE
  #   IF l_choice03='3' THEN
  #      LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,sales_tmp  ",
  #                   " WHERE vmu16=gen01 and vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
  #                   " order by ",l_sqls1,l_sqls2," seq,vmu04 "
  #   END IF
  #   END IF
  #   END IF
  # END IF
  #
  # IF cust_cnt>0 AND sales_cnt>0 THEN
  #    LET l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file,cust_tmp, sales_tmp ",
  #                " WHERE vmu06=cust01 and vmu16=gen01 and  vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'"   
  #    IF l_choice01='2' THEN LET l_sql = l_sql," order by cust_tmp.seq,"
  #       ELSE
  #       IF l_choice01='3' THEN LET l_sql = l_sql," order by sales_tmp.seq,"
  #          ELSE  LET l_sql = l_sql," order by ",l_sqls1
  #       END IF
  #    END IF
  #    IF l_choice02='2' THEN LET l_sql = l_sql,"  cust_tmp.seq,"
  #       ELSE
  #       IF l_choice02='3' THEN LET l_sql = l_sql," sales_tmp.seq,"
  #          ELSE  LET l_sql = l_sql,l_sqls2
  #       END IF
  #    END IF
  #    IF l_choice03='2' THEN LET l_sql = l_sql,"  cust_tmp.seq,vmu04"
  #       ELSE
  #       IF l_choice03='3' THEN LET l_sql = l_sql," sales_tmp.seq,vmu04"
  #          ELSE  LET l_sql = l_sql,l_sqls3," vmu04"
  #       END IF
  #    END IF
  # END IF
  #FUN-940064  MARK  --END-------------------------------------------------

  #FUN-940064  ADD   --STR-------------------------------------------------
   IF cust_cnt=0 AND sales_cnt=0  AND part_cnt>0 THEN    
      CASE
        WHEN l_choice01='1' 
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,part_tmp  ",     #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,part_tmp  ",  #FUN-B50022 add
                       "  WHERE vmu23=ima01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       "  ORDER BY part_tmp.seq,",l_sqls2,l_sqls3," vmu04"
        WHEN l_choice02='1' 
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,part_tmp  ",     #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,part_tmp  ",  #FUN-B50022 add
                       "  WHERE vmu23=ima01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       "  ORDER BY ",l_sqls1," part_tmp.seq,",l_sqls3," vmu04"
        WHEN l_choice03='1' 
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,part_tmp  ",     #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,part_tmp  ",  #FUN-B50022 add
                       "  WHERE vmu23=ima01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       "  ORDER BY ",l_sqls1,l_sqls2," part_tmp.seq,vmu04 "
     END CASE
   END IF

   IF cust_cnt>0 AND sales_cnt=0  AND part_cnt=0 THEN    
      CASE 
        WHEN l_choice01='2'
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,cust_tmp  ",     #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,cust_tmp  ",  #FUN-B50022 add
                       "  WHERE vmu06=cust01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       "  ORDER BY cust_tmp.seq,",l_sqls2,l_sqls3," vmu04"
        WHEN l_choice02='2'
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,cust_tmp  ",     #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,cust_tmp  ",  #FUN-B50022 add
                       "  WHERE vmu06=cust01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       "  ORDER BY  ",l_sqls1," cust_tmp.seq,",l_sqls3," vmu04"
        WHEN l_choice03='2'
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,cust_tmp  ",     #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,cust_tmp  ",  #FUN-B50022 add
                       "  WHERE vmu06=cust01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       "  ORDER BY ",l_sqls1,l_sqls2," cust_tmp.seq,vmu04 "
      END CASE
   END IF

   IF cust_cnt=0 AND sales_cnt>0  AND part_cnt=0 THEN    
      CASE
        WHEN l_choice01='3' 
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,sales_tmp  ",    #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,sales_tmp  ", #FUN-B50022 add
                       "  WHERE vmu16=gen01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       " ORDER BY sales_tmp.seq,",l_sqls2,l_sqls3," vmu04"
        WHEN l_choice02='3' 
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,sales_tmp  ",    #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,sales_tmp  ", #FUN-B50022 add
                       "  WHERE vmu16=gen01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       "  ORDER BY ",l_sqls1," sales_tmp.seq,",l_sqls3," vmu04"
        WHEN l_choice03='3' 
         #LET  l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file ,sales_tmp  ",    #FUN-B50022 mark
          LET  l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file ,sales_tmp  ", #FUN-B50022 add
                       "  WHERE vmu16=gen01 AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02, "'",
                       "  ORDER BY ",l_sqls1,l_sqls2," sales_tmp.seq,vmu04 "
     END CASE
   END IF

   IF cust_cnt>0 AND sales_cnt>0  AND part_cnt>0 THEN    
     #LET l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file,cust_tmp, sales_tmp,part_tmp ",    #FUN-B50022 mark
      LET l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file,cust_tmp, sales_tmp,part_tmp ", #FUN-B50022 add
                  " WHERE vmu06=cust01 AND vmu16=gen01 AND vmu23=ima01 ",
                  "   AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02,"' ORDER BY " 
      CASE
        WHEN l_choice01='1'
             LET l_sql = l_sql," part_tmp.seq,"
        WHEN l_choice01='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice01='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls1
      END CASE
      CASE
        WHEN l_choice02='1'
             LET l_sql = l_sql," part_tmp.seq,"
        WHEN l_choice02='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice02='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls2
      END CASE
      CASE
        WHEN l_choice03='1'
             LET l_sql = l_sql," part_tmp.seq,"
        WHEN l_choice03='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice03='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls3
      END CASE
   END IF


   IF cust_cnt>0 AND sales_cnt>0  AND part_cnt=0 THEN    
     #LET l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file,cust_tmp, sales_tmp ",      #FUN-B50022 mark
      LET l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file,cust_tmp, sales_tmp ",   #FUN-B50022 add
                  "  WHERE vmu06=cust01 AND vmu16=gen01 ",
                  "    AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02,"' ORDER BY " 
      CASE
        WHEN l_choice01='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice01='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql," ",l_sqls1
      END CASE
      CASE
        WHEN l_choice02='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice02='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls2
      END CASE
      CASE
        WHEN l_choice03='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice03='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls3
      END CASE
   END IF


   IF cust_cnt>0 AND sales_cnt=0  AND part_cnt>0 THEN    
     #LET l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file,cust_tmp, part_tmp ",    #FUN-B50022 mark
      LET l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file,cust_tmp, part_tmp ", #FUN-B50022 add
                  "  WHERE vmu06=cust01 AND vmu23=ima01 ",
                  "    AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02,"' ORDER BY " 
      CASE
        WHEN l_choice01='1'
             LET l_sql = l_sql," part_tmp.seq,"
        WHEN l_choice01='2' 
             LET l_sql = l_sql," cust_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls1
      END CASE
      CASE
        WHEN l_choice02='1'
             LET l_sql = l_sql," part_tmp.seq,"
        WHEN l_choice02='2' 
             LET l_sql = l_sql," cust_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls2
      END CASE
      CASE
        WHEN l_choice03='1'
             LET l_sql = l_sql," part_tmp.seq,"
        WHEN l_choice03='2' 
             LET l_sql = l_sql," cust_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls3
      END CASE
   END IF

   IF cust_cnt=0 AND sales_cnt>0  AND part_cnt>0 THEN    
     #LET l_sql = " SELECT vmu_file.ROWID,vmu10 FROM vmu_file,sales_tmp,part_tmp ",      #FUN-B50022 mark
      LET l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file,sales_tmp,part_tmp ",   #FUN-B50022 add
                  "  WHERE vmu16=gen01 AND vmu23=ima01 ",
                  "    AND vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02,"' ORDER BY " 
      CASE
        WHEN l_choice01='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice01='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls1
      END CASE
      CASE
        WHEN l_choice02='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice02='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls2
      END CASE
      CASE
        WHEN l_choice03='2'
             LET l_sql = l_sql," cust_tmp.seq,"
        WHEN l_choice03='3' 
             LET l_sql = l_sql," sales_tmp.seq,"
        OTHERWISE
             LET l_sql = l_sql,"  ",l_sqls3
      END CASE
   END IF
  #FUN-940064  ADD   --END-------------------------------------------------

   #TQC-920083  MARK  --STR--
   #IF cust_cnt=0 AND sales_cnt=0 THEN
   #LET l_sql = " SELECT ROWID,vmu10 FROM vmu_file  ",
   #            " WHERE vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02,"' order by ",
   #              l_sqls1,l_sqls2,l_sqls3," vmu04"
   #END IF  
   #TQC-920083  MARK   --END--

   #TQC-920083  ADD  --STR--
   #IF cust_cnt=0 AND sales_cnt=0 THEN  #FUN-940064  MARK
    IF cust_cnt=0 AND sales_cnt=0 AND part_cnt=0 THEN   #FUN-940064 ADD
       IF l_sqls1=' ' and l_sqls2= ' '  and l_sqls3=' ' THEN
         #LET l_sql = " SELECT ROWID,vmu10 FROM vmu_file  ",              #FUN-B50022 mark
          LET l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file  ",  #FUN-B50022 add
                      "  WHERE vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02,"' ORDER BY vmu10"
       ELSE
         #LET l_sql = " SELECT ROWID,vmu10 FROM vmu_file  ",              #FUN-B50022 mark
          LET l_sql = " SELECT vmu01,vmu02,vmu03,vmu10 FROM vmu_file  ",  #FUN-B50022 add
                      "  WHERE vmu01='",g_vmu01,"' AND vmu02= '",g_vmu02,"' ORDER BY ",
                      l_sqls1,l_sqls2,l_sqls3,"vmu04"
       END IF
    END IF

           

   #TQC-920083 ADD  --STR--
   #  IF l_sqls1=' ' and l_sqls2= ' '  and l_sqls3=' ' THEN
   #     LET l_sql = l_sql, " vmu10"
   #  ELSE LET l_sql = l_sql, ", vmu04 "
   #  END IF
   #TQC-920083 ADD --END--

   #FUN-940064  ADD  --STR--------------------------------------------
    LET l_sql = l_sql CLIPPED
    IF l_sql.substring(l_sql.getlength(),l_sql.getlength())=',' THEN
       LET l_sql = l_sql,' 1'
    END IF
   #FUN-940064  ADD  --END--------------------------------------------

   PREPARE i400_vmu_1_p FROM l_sql
   IF STATUS THEN CALL cl_err('pre i400_vmu_1_p',STATUS,1) END IF

   #FUN-890041  MARK
   #DECLARE i400_b_y_c CURSOR FOR
   # SELECT ROWID,vmu10 FROM vmu_file WHERE vmu01=g_vmu01 AND vmu02=g_vmu02,l_sql 
   DECLARE i400_b_y_c CURSOR FOR i400_vmu_1_p
   IF STATUS THEN CALL cl_err('dec i400_b_y_c',STATUS,1) END IF


   BEGIN WORK
   LET g_success = 'Y'
   LET i=0

  #FOREACH i400_b_y_c INTO g_vmu_rowid,j                #FUN-B50022 mark
   FOREACH i400_b_y_c INTO g_vmu01,g_vmu02,g_vmu03,j    #FUN-B50022 add
      IF STATUS THEN
         CALL cl_err('foreach',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET i=i+10
      UPDATE vmu_file SET vmu10 = i 
      #WHERE ROWID = g_vmu_rowid  #FUN-B50022 mark
       WHERE vmu01 = g_vmu01      #FUN-B50022 add
         AND vmu02 = g_vmu02      #FUN-B50022 add
         AND vmu03 = g_vmu03      #FUN-B50022 add
      IF STATUS THEN
         CALL cl_err3("upd","vmu_file",g_vmu01,j,SQLCA.sqlcode,"","upd vmu10",1)    #No.FUN-660081
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH


   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF

END FUNCTION

FUNCTION i400_b_fill(p_key)              #BODY FILL UP

   DEFINE p_key  LIKE vmu_file.vmu10

   #FUN-890041 add vmu25
  #FUN-BA0036--mark---str---
  #DECLARE vmu_curs CURSOR FOR
  #    SELECT vmu10,vmu22,vmu18,vmu03,vmu23,vmu24,vmu24-vmu13,vmu04,vmu06,vmu08,vmu09,
  #           vmu25,vmu11,vmu12,vmu13,vmu14,vmu15,vmu16,vmu17,vmu19,vmu21
  #      FROM vmu_file
  #     WHERE vmu01 = g_vmu01 
  #       AND vmu02 = g_vmu02
  #       AND vmu10 >= p_key
  #     ORDER BY vmu10
  #FUN-BA0036--mark---end---
  #FUN-BA0036--add----str---
   LET g_sql = 
      "SELECT vmu10,vmu22,vmu18,vmu03,vmu23,vmu24, ",
      "CASE WHEN vmu25 = '1' THEN vmu24 ELSE vmu24-vmu13 END,", #原可沖銷量vmu25 = '1':一般訂單時,直接給vmu24
      "vmu04,vmu06,vmu08,vmu09, ",
      "       vmu25,vmu11,vmu12,vmu13,vmu14,vmu15,vmu16,vmu17,vmu19,vmu21 ",
      "  FROM vmu_file ",
      " WHERE vmu01 = '",g_vmu01 ,"'",
      "   AND vmu02 = '",g_vmu02 ,"'",
      "   AND vmu10 >= ",p_key,
      " ORDER BY vmu10 "
   PREPARE vmu_curs_p1 FROM g_sql
   DECLARE vmu_curs CURSOR FOR vmu_curs_p1
  #FUN-BA0036--add----end---

   CALL g_vmu.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH vmu_curs INTO g_vmu[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_rec_b = g_rec_b + 1 

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_vmu.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_vmu TO s_vmu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index,g_row_count) #No:FUN-580092 HCN

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      #FUN-940001  ADD  --STR--
      ON ACTION aps_need_ord_from
         #TQC-940150 MOD --STR--------------------
         #LET g_action_choice="aps_need_ord_from"
          IF g_rec_b = 0 THEN
             CALL cl_err('','arm-034',1)
          ELSE
            LET g_action_choice="aps_need_ord_from"
          END IF
         #TQC-940150 MOD --END--------------------
         EXIT DISPLAY
      #FUN-940001  ADD  --END--


      ON ACTION aps_re_sort
         LET g_action_choice="aps_re_sort"
         EXIT DISPLAY


      #FUN-890041  ADD   --STR--
      ON ACTION inddemd_up
         LET g_action_choice="inddemd_up"
         EXIT DISPLAY

      ON ACTION order_set_owner
         LET g_action_choice="order_set_owner"
         EXIT DISPLAY
      #FUN-890041  ADD   --END-- 

      #FUN-940064  ADD  --STR--
      ON ACTION all_setY_redate
         LET g_action_choice = "all_setY_redate"
         EXIT DISPLAY
      ON ACTION all_setN_redate
         LET g_action_choice = "all_setN_redate"
         EXIT DISPLAY
      #FUN-940064  ADD  --END--

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION first
         CALL i400_del_tmp() #FUN-AB0090 add
         CALL i400_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL i400_del_tmp() #FUN-AB0090 add
         CALL i400_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i400_del_tmp() #FUN-AB0090 add
         CALL i400_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i400_del_tmp() #FUN-AB0090 add
         CALL i400_fetch('L')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i400_del_tmp() #FUN-AB0090 add
         CALL i400_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
        LET g_action_choice = 'exporttoexcel'
        EXIT DISPLAY

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


#FUN-890041 add  獨立需求更新
FUNCTION i400_indrefresh()
  DEFINE  l_cnt     LIKE  type_file.num5     #TQC-AC0270 add
  DEFINE  order01   LIKE  type_file.chr1,    #TQC-AC0270 add
          order02   LIKE  type_file.chr1,    #TQC-AC0270 add
          order03   LIKE  type_file.chr1,    #TQC-AC0270 add
          order04   LIKE  type_file.chr1     #TQC-AC0270 add
  DEFINE  l_vmu       DYNAMIC ARRAY OF RECORD  
          vmu01     LIKE  vmu_file.vmu01,
          vmu02     LIKE  vmu_file.vmu02,
          vmu03     LIKE  vmu_file.vmu03,
          vmu04     LIKE  vmu_file.vmu04,
          vmu10     LIKE  vmu_file.vmu10
          END RECORD
  DEFINE  l_rpc       DYNAMIC ARRAY OF RECORD
            rpc01     LIKE  rpc_file.rpc01,
            rpc02     LIKE  rpc_file.rpc02,
            rpc03     LIKE  rpc_file.rpc03,
            rpc21     LIKE  rpc_file.rpc21,
            rpc12     LIKE  rpc_file.rpc12,
            rpc13     LIKE  rpc_file.rpc13,
            rpc131    LIKE  rpc_file.rpc131,
            ima133    LIKE  ima_file.ima133
            END RECORD

  DEFINE    i         LIKE  type_file.num5
  DEFINE    l_vmucnt  LIKE  type_file.num5
  DEFINE    l_newcnt  LIKE  type_file.num5
  DEFINE    l_vlfcnt  LIKE  type_file.num5
  DEFINE    l_sqty    LIKE  type_file.num5
  DEFINE    l_part    LIKE  rpc_file.rpc01
  DEFINE    l_needno  LIKE  vlf_file.vlf16
  DEFINE    l_rpc03   LIKE  type_file.chr2
 #DEFINE    l_seq1    LIKE  type_file.num10  #獨立性需求會用到的序號 #FUN-A30080 GP1.X需要

     #FUN-8A0052  add---str
     SELECT vlz70 INTO g_vlz70
         FROM vlz_file
       WHERE vlz01 =g_vmu01
         AND vlz02 =g_vmu02
     IF NOT cl_null(g_vlz70) THEN
        CALL s_get_sql_msp04(g_vlz70,'rpc02') RETURNING g_sql_limited
     ELSE
        LET g_sql_limited = ' 1=1 '
     END IF
     #FUN-8A0052  add ---end

    #FUN-A30080 mark str ---------------
    ##TQC-8A0004  change vmu24 from rpc13
    #LET l_sql2="insert into vmu_file(vmu01,vmu02,vmu03,vmu04,vmu05,vmu06,vmu07,",
    #           "vmu08,vmu09,vmu10,vmu11,vmu12,vmu13,vmu14,",
    #           "vmu15,vmu16,vmu17,vmu18,vmu19,vmu20,vmu21,",
    #           "vmu22,vmu23,vmu24,vmu25,vmu26)  ",
    #           "  select a.vmu01,a.vmu02,a.vmu03,a.vmu04,a.vmu05,a.vmu06,",
    #           "a.vmu07,a.vmu08,a.vmu09,a.vmu10,a.vmu11,a.vmu12,a.vmu13,",
    #           "a.vmu14,",
    #           "a.vmu15,a.vmu16,a.vmu17,a.vmu18,a.vmu19,a.vmu20,a.vmu21,",
    #           "a.vmu22,a.vmu23,a.vmu24,a.vmu25,a.vmu26 from ",
    #           "(select vld01 vmu01,vld02 vmu02, ",
    #           " case when rpc03<10 then rpc02||'-000'||rpc03 ",
    #           "      when rpc03<100 then rpc02||'-00'||rpc03 ",
    #           "      when rpc03<1000 then rpc02||'-0'||rpc03 ",
    #           "      else rpc02||'-'||rpc03 end vmu03,rpc12 vmu04",
    #           ",0 vmu05,null vmu06,1 vmu07,'R' vmu08, ",
    #           "null vmu09,null vmu10,rpc02 vmu11,null vmu12,",
    #           "rpc131 vmu13,ima31 vmu14,null vmu15,null vmu16,",
    #           "ima31_fac vmu17, ",
    #           "rpc21 vmu18,null vmu19,null vmu20,null vmu21,0 vmu22 ",
    #           ",rpc01 vmu23,rpc13 vmu24,'2' vmu25,rpc03 vmu26 ",
    #           "from rpc_file,vld_file ,ima_file ",
    #           "where  rpc13>rpc131 and rpc18='Y' and rpc19='N' and ",
    #           "rpc12>=vld03 and rpc12<=vld04  ",
    #           "   AND ",g_sql_limited , #FUN-8A0052 add
    #           " and rpc01=ima01  and vld01= '",g_vmu01,"'",
    #           " and vld02='",g_vmu02,"'",
    #           " ) a,  ",
    #           " (select vmu01,vmu02,vmu11,vmu26 from vmu_file where ",
    #           " vmu01= '",g_vmu01, "' and vmu02='",g_vmu02,"' ) b ",
    #           " where  a.vmu11=b.vmu11 and a.vmu26=b.vmu26  and ",
    #           " b.vmu01 is null  "
    #FUN-A30080 mark end ---------------

    #FUN-A30080 add str ------------
     LET l_sql2 ="SELECT a.vmu01,a.vmu02,a.vmu03,a.vmu04,a.vmu05,",
                 "       a.vmu06,a.vmu07,a.vmu08,a.vmu09,a.vmu10,",
                 "       a.vmu11,a.vmu12,a.vmu13,a.vmu14,a.vmu15,",
                 "       a.vmu16,a.vmu17,a.vmu18,a.vmu19,a.vmu20,",
                 "       a.vmu21,a.vmu22,a.vmu23,a.vmu24,a.vmu25,a.vmu26",
                 "  FROM ",
                 #  子查詢資料表 a.由獨立需求擋(rpc_file)與MDS沖銷條件檔(vld_file)所組合的TABLE,並付予欄位別名
                 "       (SELECT vld01 vmu01,vld02 vmu02, ",
                 "               CASE WHEN rpc03<10 then rpc02||'-000'||rpc03 ",
                 "                    WHEN rpc03<100 then rpc02||'-00'||rpc03 ",
                 "                    WHEN rpc03<1000 then rpc02||'-0'||rpc03 ",
                 "                    ELSE rpc02||'-'||rpc03 ",
                 "                END vmu03, ",                  
                 "               rpc12 vmu04,0 vmu05,null vmu06,1 vmu07,'R' vmu08, ",
                 "               null vmu09,null vmu10,rpc02 vmu11,null vmu12,NVL(rpc131,0) vmu13, ",
                 "               ima31 vmu14,null vmu15,null vmu16,ima31_fac vmu17,rpc12 vmu18, ",
                 "               null vmu19,null vmu20,null vmu21,0 vmu22,rpc01 vmu23,rpc13 vmu24, ",
                 "               '2' vmu25,rpc03 vmu26",
                 "          FROM rpc_file,vld_file,ima_file ",
                 "         WHERE NVL(rpc13,0) > NVL(rpc131,0)",          #需求數量>已耗需求
                 "           AND rpc18='Y' ",
                 "           AND rpc19='N' ",
                 "           AND rpc12 >= vld03",                        #需求日期>=沖銷資料起始日
                 "           AND rpc12 <= vld04",                        #需求日期<=沖銷資料截止日
                 "           AND ",g_sql_limited,
                 "           AND rpc01 = ima01",
                 "           AND vld01='",g_vmu01,"'",                   #APS版本
                #"           AND vld02 ='",g_vmu02,"') a,",                #儲存版本 #FUN-B50022 mark
                 "           AND vld02 ='",g_vmu02,"') a LEFT OUTER JOIN", #儲存版本 #FUN-B50022 add
                 #  子查詢資料表 b:依APS版本、儲存版本查詢出以需求訂單單號、需求來源項次為條件值的TABLE
                 "       (SELECT vmu01,vmu02,vmu11,vmu26",
                 "          FROM vmu_file",
                 "         WHERE vmu01 ='",g_vmu01,"'",
                #FUN-B50022--mod---str----
                #"           AND vmu02 ='",g_vmu02,"') b", #FUN-B50022 mark
                #" WHERE a.vmu11 = b.vmu11(+)",                          #銷售訂單編號
                #"   AND a.vmu26 = b.vmu26(+)",                          #需求來源項次
                #"   AND b.vmu01 is null"
                 "           AND vmu02 ='",g_vmu02,"') b ",
                 "    ON a.vmu11 = b.vmu11 ",                          #銷售訂單編號
                 "   AND a.vmu26 = b.vmu26 ",                          #需求來源項次
                 "   AND b.vmu01 is NULL "
                #FUN-B50022--mod---end----
    #FUN-A30080 add end ------------

  
     PREPARE i400_p_ins_vmu  FROM l_sql2
    #IF STATUS THEN CALL cl_err('pre ins_vmu',STATUS,1) END IF           #FUN-A30080 mark
    #EXECUTE i400_p_ins_vmu                                              #FUN-A30080 mark
    #IF NOT STATUS THEN CALL cl_err('',9062,1) 
    #   ELSE  CALL cl_err('',9050,1)
    #END IF

    #FUN-A30080 add str ------------
     DECLARE ins_vmu CURSOR FOR i400_p_ins_vmu
     INITIALIZE g_tmp.* TO NULL
     LET l_newcnt = 0 #TQC-AC0270 add
     FOREACH ins_vmu INTO g_tmp.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH ins_vmu:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #TQC-AC0270--add----str---
        SELECT MAX(vmu10) + 10 INTO g_tmp.vmu10
          FROM vmu_file
         WHERE vmu01 = g_vmu01
           AND vmu02 = g_vmu02
        #TQC-AC0270--add----end---

       #此段為GP1.X的邏輯
       #SELECT MAX(SUBSTR(vmu03,5,4)) INTO l_seq1
       #  FROM vmu_file
       # WHERE vmu01 = g_vmu01
       #   AND vmu02 = g_vmu02
       #   AND vmu03 LIKE 'SIR%'
       #LET l_seq1 = l_seq1 + 1
       #LET g_tmp.vmu03 = 'SIR-',l_seq1 USING '&&&&'

        LET g_tmp.vmu13 = s_digqty(g_tmp.vmu13,g_tmp.vmu14)   #FUN-BB0085
        LET g_tmp.vmu24 = s_digqty(g_tmp.vmu24,g_tmp.vmu14)   #FUN-BB0085
        INSERT INTO vmu_file(vmu01,vmu02,vmu03,vmu04,vmu05,vmu06,vmu07,
                             vmu08,vmu09,vmu10,vmu11,vmu12,vmu13,vmu14,
                             vmu15,vmu16,vmu17,vmu18,vmu19,vmu20,vmu21,
                             vmu22,vmu23,vmu24,vmu25,vmu26,vmulegal,vmuplant) #FUN-B50022 add vmulegal,vmuplant
                      VALUES(g_tmp.*,g_legal,g_plant)                         #FUN-B50022 add g_legal,g_plant
        IF STATUS THEN
           CALL cl_err('ins vmu_file',STATUS,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--
           EXIT PROGRAM
        END IF
        LET l_newcnt = l_newcnt + 1  #TQC-AC0270 add
     END FOREACH
    #FUN-A30080 add end -------------

 
    #FUN-890041 補vlf_file data  #FUN-A30080 mod 整短SQL命令改為大寫,並分段排版
    LET l_sql=" SELECT rpc01,rpc02,rpc03,rpc21,rpc12,rpc13,rpc131,ima133 ",
              "   FROM rpc_file,vld_file, ",
              "        (SELECT * FROM vlf_file WHERE vlf01='",g_vmu01,"' AND vlf02='",g_vmu02,"'), ",
              "        ima_file  ",
              "  WHERE rpc02 = vlf10 ",
              "    AND rpc03 = vlf11 ",
              "    AND rpc01 = ima01    ",
              "    AND vlf01 is null    ",
              "    AND rpc13 > rpc131   ",
              "    AND rpc18 = 'Y'      ",
              "    AND rpc19 = 'N'      ",
              "    AND rpc12 >= vld03   ",
              "    AND rpc12 <= vld04   ",
              "    AND ",g_sql_limited ,    #FUN-8A0052 add
              "    AND vld01= '",g_vmu01,"' AND vld02='",g_vmu02,"' ORDER BY rpc02 "

    PREPARE rpc_pre FROM l_sql
    DECLARE rpc_inds CURSOR FOR rpc_pre
    LET  i = 1
    FOREACH rpc_inds INTO l_rpc[i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF NOT cl_null(l_rpc[i].ima133) THEN LET l_part = l_rpc[i].ima133
          ELSE LET l_part = l_rpc[i].rpc01
       END IF
       LET l_rpc03 = l_rpc[i].rpc03
       IF l_rpc[i].rpc03<10 THEN LET l_needno=l_rpc[i].rpc02,'-000',l_rpc03 
       ELSE 
       IF l_rpc[i].rpc03<100 THEN LET l_needno=l_rpc[i].rpc02,'-00',l_rpc03
       ELSE
       IF l_rpc[i].rpc03<1000 THEN LET l_needno=l_rpc[i].rpc02,'-0',l_rpc03
       ELSE
       IF l_rpc[i].rpc03<10000 THEN LET l_needno=l_rpc[i].rpc02,'-',l_rpc03
       END IF
       END IF
       END IF
       END IF
       select max(vlf05)+1 into l_vlfcnt FROM vlf_file 
              where vlf01=g_vmu01  and vlf02=g_vmu02 and vlf03=l_part and vlf06='9'
       IF cl_null(l_vlfcnt) THEN LET l_vlfcnt=1  END IF
       #TQC-8A0004  change vlf19='3'
       INSERT INTO vlf_file(vlf01,vlf02,vlf03,vlf04,vlf05,vlf06,vlf07,
                   vlf10,vlf11,vlf12,vlf13,vlf15,vlf16,vlf17,vlf18,vlf19,
                   vlfplant,vlflegal)  #FUN-B50022 add
          values(g_vmu01,g_vmu02,l_part,'99/12/31',l_vlfcnt,'9',0,
                 l_rpc[i].rpc02,l_rpc[i].rpc03,l_rpc[i].rpc21,'2',
                 l_rpc[i].rpc01,l_needno,l_rpc[i].rpc12,
                 l_rpc[i].rpc13-l_rpc[i].rpc131,'3',
                 g_plant,g_legal) #FUN-B50022 add
       select sum(vlf18) into l_sqty from vlf_file
              where vlf01=g_vmu01 and vlf02=g_vmu02 and vlf03=l_part and vlf06='9'
       update vlf_file set vlf07=l_sqty
          where vlf01=g_vmu01 and vlf02=g_vmu02 and vlf03=l_part and vlf06='9'

       IF STATUS THEN 
          ROLLBACK WORK  
          EXIT FOREACH
       END IF
       LET i = i + 1
    END FOREACH
     

    #TQC-AC0270---mark---str---
    ##重計優先順序
    #LET l_sql=" SELECT vmu01,vmu02,vmu03,vmu04,vmu10 FROM vmu_file ",
    #          " WHERE vmu01='",g_vmu01,"' and vmu02= '",g_vmu02,"'",
    #          " ORDER BY vmu04,vmu03 "
  
    #PREPARE vmu_pre FROM l_sql
    #DECLARE vmu_inds CURSOR FOR vmu_pre
    #LET i = 1
    #LET l_newcnt = 0
    #FOREACH vmu_inds INTO l_vmu[i].*
    #   IF SQLCA.sqlcode THEN
    #      CALL cl_err('foreach:',SQLCA.sqlcode,1)
    #      EXIT FOREACH
    #   END IF
    #   IF l_vmu[i].vmu10 IS NULL  then LET l_newcnt = l_newcnt + 1 END IF
    #   UPDATE vmu_file set vmu10=i*10 WHERE
    #     vmu01=g_vmu01 and vmu02=g_vmu02 and vmu03=l_vmu[i].vmu03
    #   LET i=i + 1
    #END FOREACH
    #IF NOT cl_null(g_vmu01) THEN CALL i400_show() END IF
    #IF  l_newcnt > 0 THEN
    #   CALL cl_err('',9062,1)
    #ELSE
    #   CALL cl_err('','aps-709',1) 
    #END IF 
    #TQC-AC0270---mark---end---
    #TQC-AC0270---add----str---
    CALL i400_reorder_cursor()           
    CALL i400_fill_part_tmp()            
    CALL i400_fill_cust_tmp()            
    CALL i400_fill_sales_tmp()            
    LET order01 = NULL
    LET order02 = NULL
    LET order03 = NULL
    LET order04 = NULL
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt
      FROM vlo_file
     WHERE vlo01 = g_vmu01
       AND vlo02 = g_vmu02
    IF l_cnt >=1 THEN
        SELECT vlo03,vlo04,vlo05,vlo06 
          INTO order01,order02,order03,order04
          FROM vlo_file
         WHERE vlo01 = g_vmu01
           AND vlo02 = g_vmu02
    END IF
    IF cl_null(order01) THEN LET order01 = '1' END IF
    IF cl_null(order02) THEN LET order02 = '2' END IF
    IF cl_null(order03) THEN LET order03 = '3' END IF
    CALL i400_reorder_vmu(g_vmu01,g_vmu02,order01,order02,order03,order04) 
    CALL i400_b_fill(0)
    IF  l_newcnt > 0 THEN
       CALL cl_err('',9062,1)      #資料更新成功
    ELSE
       CALL cl_err('','aps-709',1) #無可更新之資料!
    END IF 
    #TQC-AC0270---add----end---
END FUNCTION

#FUN-890041   優先序自訂
FUNCTION   i400_orderset_owner()
DEFINE     l_cnt     LIKE  type_file.num5 #FUN-AB0090 add
DEFINE     p_row     LIKE  type_file.num5,
           p_col     LIKE  type_file.num5
DEFINE     order01   LIKE  type_file.chr1,
           order02   LIKE  type_file.chr1,
           order03   LIKE  type_file.chr1,
           order04   LIKE  type_file.chr1,
           order05   LIKE  type_file.chr1  #FUN-AB0090 add
DEFINE     l_order01 LIKE  type_file.chr1,
           l_order02 LIKE  type_file.chr1,
           l_order03 LIKE  type_file.chr1,
           l_order04 LIKE  type_file.chr1

  LET p_row = 5 LET p_col = 31
 #FUN-AB0090----mark---str---
 #LET  order01 = '1'
 #LET  order02 = '2'
 #LET  order03 = '3'
 #FUN-AB0090----mark---end---
  #FUN-AB0090--add---str---
  LET l_cnt = 0 
  SELECT COUNT(*) INTO l_cnt
    FROM vlo_file
   WHERE vlo01 = g_vmu01
     AND vlo02 = g_vmu02
  IF l_cnt >=1 THEN
      SELECT vlo03,vlo04,vlo05,vlo06 
        INTO order01,order02,order03,order04
        FROM vlo_file
       WHERE vlo01 = g_vmu01
         AND vlo02 = g_vmu02
  END IF
  IF cl_null(order01) THEN LET order01 = '1' END IF
  IF cl_null(order02) THEN LET order02 = '2' END IF
  IF cl_null(order03) THEN LET order03 = '3' END IF
  LET l_choice01 = order01
  LET l_choice02 = order02
  LET l_choice03 = order03
  LET l_choice04 = order04
  LET order05 = 'N'
  LET l_choice05 = 'N'
  #FUN-AB0090--add---end---
  OPEN WINDOW i4001_w AT 8,24 WITH FORM "aps/42f/apsi4001"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 

  CALL cl_set_comp_required("order04",FALSE)
  CALL cl_ui_locale("apsi4001")
  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
  CALL cl_set_comp_entry("order01,order02,order03,order04",FALSE) #FUN-AB0090 add
  INPUT order01,order02,order03,order04,order05 WITHOUT DEFAULTS  #FUN-AB0090 add order05
        FROM FORMONLY.order01,FORMONLY.order02, 
        FORMONLY.order03,FORMONLY.order04,
        FORMONLY.order05                                          #FUN-AB0090 add order05

    #FUN-940064 ADD  --STR--
     ON CHANGE  order01
        LET l_choice01 = order01
        LET l_choice02 = order02
        LET l_choice03 = order03
        IF order01='4' OR order02='4' OR order03='4' THEN
           CALL cl_set_comp_required("order04",TRUE)
        END IF

     ON CHANGE order02
        LET l_choice01 = order01
        LET l_choice02 = order02
        LET l_choice03 = order03
        IF order01='4' OR order02='4' OR order03='4' THEN
           CALL cl_set_comp_required("order04",TRUE)
        END IF

     ON CHANGE order03
        LET l_choice01 = order01
        LET l_choice02 = order02
        LET l_choice03 = order03
        IF order01='4' OR order02='4' OR order03='4' THEN
           CALL cl_set_comp_required("order04",TRUE)
        END IF

     ON CHANGE order04
        LET  l_choice04 = order04
    #FUN-940064 ADD  --END--
     #FUN-AB0090--add----str---
     ON CHANGE order05
        LET  l_choice05 = order05
     #FUN-AB0090--add----end---

     AFTER FIELD order01
        IF order01='4' or order02='4' or order03='4' THEN 
           CALL cl_set_comp_required("order04",TRUE) 
        END IF
    
     AFTER FIELD order02
        IF order01='4' or order02='4' or order03='4' THEN
           CALL cl_set_comp_required("order04",TRUE)
        END IF
    
     AFTER FIELD order03
        IF order01='4' or order02='4' or order03='4' THEN
           CALL cl_set_comp_required("order04",TRUE)
        END IF
    
     AFTER FIELD order04
        LET  l_choice04 = order04

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT

     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121

     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121

     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121

     #FUN-940064   ADD  料號優先序制定--STR-------------------------
     ON ACTION   part_order_set
        #FUN-AB0090--add---str--
        IF l_choice05 = 'N' THEN
            #請選擇"要"重新計算APS需求訂單檔(vmu_file)的優先順序,才能調整優先序制定!
            CALL cl_err('','aps-104',0)
        ELSE
        #FUN-AB0090--add---end--
            IF l_choice01<>'1' and l_choice02<>'1' and l_choice03<>'1' THEN
               CALL cl_err('','aps-737',0)
            ELSE
              #CALL i400_part_order_set() #FUN-AB0090 mark
               CALL i400_input_part()     #FUN-AB0090 add
            END IF
        END IF #FUN-AB0090 add
     #FUN-940064    ADD  料號優先序制定--END-------------------------

     #FUN-890041   add 客戶優先序制定,業務員優先序制定
     #----------------------begin--------------------
     ON ACTION   cust_order_set
        #FUN-AB0090--add---str--
        IF order05 = 'N' THEN
            #請選擇"要"重新計算APS需求訂單檔(vmu_file)的優先順序,才能調整優先序制定!
            CALL cl_err('','aps-104',0)
        ELSE
        #FUN-AB0090--add---end--
            IF l_choice01<>'2' and l_choice02<>'2' and l_choice03<>'2' THEN
               CALL cl_err('','aps-721',0)
            ELSE
              #CALL i400_cust_order_set() #FUN-AB0090 mark
               CALL i400_input_cust()     #FUN-AB0090 add
            END IF 
        END IF #FUN-AB0090 add

     ON ACTION  sales_order_set

        #FUN-AB0090--add---str--
        IF order05 = 'N' THEN
            #請選擇"要"重新計算APS需求訂單檔(vmu_file)的優先順序,才能調整優先序制定!
            CALL cl_err('','aps-104',0)
        ELSE
            #FUN-AB0090--add---end--
            IF l_choice01<>'3' and l_choice02<>'3' and l_choice03<>'3' THEN
               CALL cl_err('','aps-722',0)
            ELSE  
              #CALL i400_sales_order_set() #FUN-AB0090 mark 
               CALL i400_input_sales()     #FUN-AB0090 add
            END IF
        END IF #FUN-AB0090 add
     #-----------------------end--------------------

  END INPUT
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW i4001_w
     RETURN
  ELSE
   #FUN-AB0090--mark---str---
   #LET l_choice01 = order01
   #LET l_choice02 = order02
   #LET l_choice03 = order03
   #LET l_choice04 = order04
   #IF l_choice01<>'2'  and l_choice02<>'2' and l_choice03<>'2' THEN
   #   DELETE FROM  cust_tmp
   #END IF
   #IF l_choice01<>'3'  and l_choice02<>'3' and l_choice03<>'3' THEN
   #   DELETE FROM  sales_tmp
   #END IF
   #
   ##FUN-940064  ADD  --STR-----------------------------------------
   #IF l_choice01<>'1'  and l_choice02<>'1' and l_choice03<>'1' THEN
   #   DELETE FROM  part_tmp
   #END IF

   ##FUN-940064  ADD  --END-----------------------------------------
   #CALL i400_b_y()      
   #FUN-AB0090--mark---end---
   #FUN-AB0090--add----str---
    IF order05 = 'Y' THEN
        CALL i400_reorder_vmu(g_vmu01,g_vmu02,order01,order02,order03,order04) 
    END IF
   #FUN-AB0090--add----end---
    CALL i400_b_fill(0)
    CLOSE WINDOW i4001_w
  END IF
END FUNCTION


#建立sort需要之temp_file
FUNCTION i400_cre_temp()
  #客戶優先序TEMP FILE
   DROP TABLE cust_tmp
   CREATE TEMP TABLE cust_tmp(
       seq        LIKE   type_file.num5,  #順序
       cust01     LIKE   vmu_file.vmu06,  #客戶代號
       cust02     LIKE   occ_file.occ02,  #客戶名稱
       cust03     LIKE   vmu_file.vmu15)  #客戶群組


   #業務員優先序TEMP FILE
   DROP TABLE sales_tmp
   CREATE TEMP TABLE sales_tmp( 
       seq       LIKE   type_file.num5,
       gen01     LIKE   vmu_file.vmu16,
       gen02     LIKE   gen_file.gen02,
       gen03     LIKE   gen_file.gen03,
       gem02     LIKE   gem_file.gem02 )  #順序


   #FUN-940064  ADD  --STR-----------------------
   #料件優先序TEMP FILE
   DROP TABLE part_tmp
   CREATE TEMP TABLE part_tmp(
       seq       LIKE type_file.num5,
       ima01     LIKE ima_file.ima01,
       ima02     LIKE ima_file.ima02,
       ima131    LIKE ima_file.ima131,
       oba02     LIKE oba_file.oba02 )  #順序
   #FUN-940064  ADD  --END----------------------- 

END FUNCTION

#FUN-890041 客戶優先序制定
FUNCTION i400_cust_order_set()
DEFINE     p_row     LIKE  type_file.num5,
           p_col     LIKE  type_file.num5,
           j         LIKE  type_file.num5,
           j2        LIKE  type_file.num5,
           l_seq     LIKE  type_file.num5,
           l_vmu06   LIKE  vmu_file.vmu06,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5     
DEFINE     order     LIKE  type_file.num5
DEFINE     l_sql     string

  LET l_allow_insert = FALSE
  LET l_allow_delete = FALSE

  CALL i4002_set_no_entry()
  OPEN WINDOW i400_2_w AT 15,20 WITH FORM "aps/42f/apsi4002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("apsi4002")
  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
  DECLARE i400_2_c CURSOR FOR
  SELECT distinct 0 seq,vmu06,occ02,vmu15 from vmu_file,occ_file 
  where vmu06=occ01 
    and vmu01 = g_vmu01
    and vmu02 = g_vmu02
    order by vmu06 

  CALL cust_vmu.clear()
  LET g_cnt = 1

  DELETE  FROM  cust_tmp
  FOREACH i400_2_c INTO cust_vmu[g_cnt].*
    IF STATUS THEN
       CALL cl_err('foreach vmu',STATUS,0)
       EXIT FOREACH
    END IF
    LET cust_vmu[g_cnt].seq = g_cnt * 10
    INSERT INTO cust_tmp(seq,cust01,cust02,cust03) 
                  values(cust_vmu[g_cnt].seq,cust_vmu[g_cnt].vmu06,cust_vmu[g_cnt].occ02,
                         cust_vmu[g_cnt].vmu15)
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  LET g_cnts = g_cnt - 1

  WHILE TRUE

     #INPUT array cust_vmu WITHOUT DEFAULTS FROM cust_w.*
     INPUT ARRAY cust_vmu WITHOUT DEFAULTS FROM cust_w.*
        ATTRIBUTE(COUNT=g_rec_b-1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE ROW
           CALL i4002_set_no_entry()
           LET j=ARR_CURR()

        AFTER FIELD seq
           LET l_seq = get_fldbuf(seq)
           LET l_vmu06 = get_fldbuf(vmu06)
           IF (cl_null(l_seq)  or  l_seq<0 or l_seq>999999) and (NOT cl_null(l_vmu06)) THEN
              CALL cl_err('','mfg3291',0)
              NEXT FIELD seq
           END IF
           FOR j2=1 to g_cnts 
               IF cust_vmu[j2].seq=l_seq and j2<>j THEN
                  CALL cl_err('','abx-044',1)
                  NEXT FIELD seq
               END IF
           END FOR

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121

        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121

        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121

        #項次由10重排
        ON ACTION i4002_sor_ten
           CALL i4002_sor_ten()
        #依客戶代號排序 
        ON ACTION i4002_cust_no_sort
           CALL i4002_cust_sortno()
        #依客戶群組排序
        ON ACTION i4002_cust_group_sort
           CALL i4002_cust_sortgroup()

     END INPUT

     IF INT_FLAG THEN
        CALL cl_err('',9001,0)
        CLOSE WINDOW i400_2_w
        LET INT_FLAG = 0
        RETURN
     END IF
     EXIT WHILE
  END WHILE
  #IF g_success='Y' THEN
     CALL i4002_sor_ten()
     COMMIT WORK
  #ELSE
  #   ROLLBACK WORK
  #END IF
  CLOSE WINDOW i400_2_w                #結束畫面

END FUNCTION

FUNCTION i4002_set_no_entry()
   CALL cl_set_comp_entry("vmu06,occ02,vmu15",FALSE)
   CALL cl_set_comp_entry("seq",TRUE)
END FUNCTION


FUNCTION  i4002_sor_ten()
  DELETE FROM cust_tmp
  FOR g_cnt = 1 to g_max_rec
      IF NOT cl_null(cust_vmu[g_cnt].vmu06) THEN
         INSERT INTO cust_tmp(seq,cust01,cust02,cust03)
                       values(cust_vmu[g_cnt].seq,cust_vmu[g_cnt].vmu06,cust_vmu[g_cnt].occ02,
                              cust_vmu[g_cnt].vmu15)
      END IF
  END FOR
  CALL cust_vmu.clear()
 
  DECLARE i400_2_c2 CURSOR FOR
  SELECT  seq,cust01,cust02,cust03 from cust_tmp order by seq

  LET g_cnt = 1

  FOREACH i400_2_c2 INTO cust_vmu[g_cnt].*
    IF STATUS THEN
       CALL cl_err('foreach vmu',STATUS,0)
       EXIT FOREACH
    END IF
    LET cust_vmu[g_cnt].seq = g_cnt * 10
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  DISPLAY ARRAY cust_vmu TO cust_w.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) 
END FUNCTION

FUNCTION  i4002_cust_sortno()
  DELETE FROM cust_tmp
  FOR g_cnt = 1 to g_max_rec
      IF NOT cl_null(cust_vmu[g_cnt].vmu06) THEN
      INSERT INTO cust_tmp(seq,cust01,cust02,cust03)
                    values(cust_vmu[g_cnt].seq,cust_vmu[g_cnt].vmu06,cust_vmu[g_cnt].occ02,
                           cust_vmu[g_cnt].vmu15)
      END IF
  END FOR
  CALL cust_vmu.clear()

  DECLARE i400_2_c3 CURSOR FOR
     SELECT  seq,cust01,cust02,cust03 from cust_tmp order by cust01

  LET g_cnt = 1
  FOREACH i400_2_c3 INTO cust_vmu[g_cnt].*
  IF STATUS THEN
       CALL cl_err('foreach vmu',STATUS,0)
       EXIT FOREACH
    END IF
    LET cust_vmu[g_cnt].seq = g_cnt * 10
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  DISPLAY ARRAY cust_vmu TO cust_w.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

END FUNCTION

FUNCTION  i4002_cust_sortgroup()
  DELETE FROM cust_tmp
  FOR g_cnt = 1 to g_max_rec
      IF NOT cl_null(cust_vmu[g_cnt].vmu06) THEN
         INSERT INTO cust_tmp(seq,cust01,cust02,cust03)
                values(cust_vmu[g_cnt].seq,cust_vmu[g_cnt].vmu06,cust_vmu[g_cnt].occ02,
                       cust_vmu[g_cnt].vmu15)
      END IF
  END FOR
  CALL cust_vmu.clear()

  DECLARE i400_2_c4 CURSOR FOR
      SELECT  seq,cust01,cust02,cust03 from cust_tmp order by cust03
  LET g_cnt = 1
  FOREACH i400_2_c4 INTO cust_vmu[g_cnt].*
    IF STATUS THEN
       CALL cl_err('foreach vmu',STATUS,0)
       EXIT FOREACH
    END IF
    LET cust_vmu[g_cnt].seq = g_cnt * 10
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
 DISPLAY ARRAY cust_vmu TO cust_w.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

END FUNCTION



FUNCTION i400_sales_order_set()
DEFINE     p_row     LIKE  type_file.num5,
           p_col     LIKE  type_file.num5,
           j         LIKE  type_file.num5,
           j2        LIKE  type_file.num5,
           l_seq     LIKE  type_file.num5,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5
DEFINE     order     LIKE  type_file.num5
DEFINE     l_sql     string

  LET l_allow_insert = FALSE
  LET l_allow_delete = FALSE

  CALL i4003_set_no_entry()
  OPEN WINDOW i400_3_w AT 15,20 WITH FORM "aps/42f/apsi4003"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

  CALL cl_ui_locale("apsi4003")
  CALL cl_set_head_visible("","YES")     
  DECLARE i400_3_c CURSOR FOR
    select distinct 0 seq,gen01,gen02,gen03,gem03 
    from vmu_file,gen_file,gem_file
    where vmu16=gen01 and gen03=gem01
      and vmu01=g_vmu01
      and vmu02=g_vmu02
      order by gen01

  CALL sales_vmu.clear()
  LET g_cnt = 1

  DELETE FROM  sales_tmp
  FOREACH i400_3_c INTO sales_vmu[g_cnt].*
    IF STATUS THEN
       CALL cl_err('foreach vmu',STATUS,0)
       EXIT FOREACH
    END IF
    LET sales_vmu[g_cnt].seq = g_cnt * 10
    INSERT INTO sales_tmp(seq,gen01,gen02,gen03,gem02)
                 values(sales_vmu[g_cnt].seq,sales_vmu[g_cnt].gen01,sales_vmu[g_cnt].gen02,
                        sales_vmu[g_cnt].gen03,sales_vmu[g_cnt].gem02)

    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  LET g_cnts = g_cnt-1
  WHILE TRUE

    INPUT ARRAY sales_vmu WITHOUT DEFAULTS FROM sales_w.*
        ATTRIBUTE(COUNT=g_rec_b-1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
       BEFORE ROW
          CALL i4003_set_no_entry()
          LET j=ARR_CURR()

       AFTER FIELD seq
          LET l_seq = get_fldbuf(seq)
          IF cl_null(l_seq)  or  l_seq<0 or l_seq>999999 THEN
             CALL cl_err('','mfg3291',0)
             NEXT FIELD seq
          END IF
          FOR j2=1 to g_cnts
              IF sales_vmu[j2].seq=l_seq and j2<>j THEN
                 CALL cl_err('','abx-044',1)
                 NEXT FIELD seq
              END IF
          END FOR

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121

       #項次由10重排
       ON ACTION i4003_sor_ten
          CALL i4003_sor_ten()

       #依業務員排序
       ON ACTION sales_no_sort
          CALL i4003_sales_sortno()
       #依部門排序
       ON ACTION depart_sort
          CALL i4003_sales_sortdept()


    END INPUT

    IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       CLOSE WINDOW i400_3_w
       LET INT_FLAG = 0
       RETURN
    END IF
    EXIT WHILE
 END WHILE
 #IF g_success='Y' THEN
    CALL i4003_sor_ten()
    COMMIT WORK
 #ELSE
 #   ROLLBACK WORK
 #END IF

 CLOSE WINDOW i400_3_w                #結束畫面

END FUNCTION


FUNCTION i4003_set_no_entry()
   CALL cl_set_comp_entry("gen01,gen02,gen03,gem02",FALSE)
   CALL cl_set_comp_entry("seq",TRUE)
END FUNCTION

FUNCTION  i4003_sor_ten()
 DELETE FROM sales_tmp
 FOR g_cnt = 1 to g_max_rec
   IF NOT cl_null(sales_vmu[g_cnt].gen01) THEN
      INSERT INTO sales_tmp(seq,gen01,gen02,gen03,gem02)
         values(sales_vmu[g_cnt].seq,sales_vmu[g_cnt].gen01,sales_vmu[g_cnt].gen02,
                sales_vmu[g_cnt].gen03,sales_vmu[g_cnt].gem02)
   END IF
 END FOR
 CALL sales_vmu.clear()

 DECLARE i400_3_c2 CURSOR FOR
 SELECT  seq,gen01,gen02,gen03,gem02 from sales_tmp order by seq

 LET g_cnt = 1
 FOREACH i400_3_c2 INTO sales_vmu[g_cnt].*
   IF STATUS THEN
      CALL cl_err('foreach vmu',STATUS,0)
      EXIT FOREACH
   END IF
   LET sales_vmu[g_cnt].seq = g_cnt * 10
   LET g_cnt = g_cnt + 1
   IF g_cnt > g_max_rec THEN
      CALL cl_err( '', 9035, 0 )
      EXIT FOREACH
   END IF
 END FOREACH
 DISPLAY ARRAY sales_vmu TO sales_w.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
END FUNCTION

FUNCTION  i4003_sales_sortno()
  DELETE FROM sales_tmp
  FOR g_cnt = 1 to g_max_rec
      IF NOT cl_null(sales_vmu[g_cnt].gen01) THEN
         INSERT INTO sales_tmp(seq,gen01,gen02,gen03,gem02)
             values(sales_vmu[g_cnt].seq,sales_vmu[g_cnt].gen01,sales_vmu[g_cnt].gen02,
                    sales_vmu[g_cnt].gen03,sales_vmu[g_cnt].gem02)
     END IF
 END FOR
 CALL sales_vmu.clear()

 DECLARE i400_3_c3 CURSOR FOR
     SELECT  seq,gen01,gen02,gen03,gem02 from sales_tmp order by gen01
 LET g_cnt = 1
 FOREACH i400_3_c3 INTO sales_vmu[g_cnt].*
   IF STATUS THEN
      CALL cl_err('foreach vmu',STATUS,0)
      EXIT FOREACH
   END IF
   LET sales_vmu[g_cnt].seq = g_cnt * 10
   LET g_cnt = g_cnt + 1
   IF g_cnt > g_max_rec THEN
      CALL cl_err( '', 9035, 0 )
      EXIT FOREACH
   END IF
 END FOREACH
DISPLAY ARRAY sales_vmu TO sales_w.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

END FUNCTION

FUNCTION  i4003_sales_sortdept()
  DELETE FROM sales_tmp
  FOR g_cnt = 1 to g_max_rec
      IF NOT cl_null(sales_vmu[g_cnt].gen01) THEN
         INSERT INTO sales_tmp(seq,gen01,gen02,gen03,gem02)
             values(sales_vmu[g_cnt].seq,sales_vmu[g_cnt].gen01,sales_vmu[g_cnt].gen02,
                    sales_vmu[g_cnt].gen03,sales_vmu[g_cnt].gem02)
     END IF
 END FOR
 CALL sales_vmu.clear()

 DECLARE i400_3_c4 CURSOR FOR
     SELECT  seq,gen01,gen02,gen03,gem02 from sales_tmp order by gem02
 LET g_cnt = 1
 FOREACH i400_3_c4 INTO sales_vmu[g_cnt].*
   IF STATUS THEN
      CALL cl_err('foreach vmu',STATUS,0)
      EXIT FOREACH
   END IF
   LET sales_vmu[g_cnt].seq = g_cnt * 10
   LET g_cnt = g_cnt + 1
   IF g_cnt > g_max_rec THEN
      CALL cl_err( '', 9035, 0 )
      EXIT FOREACH
   END IF
 END FOREACH
DISPLAY ARRAY sales_vmu TO sales_w.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

END FUNCTION

#FUN-940001   ADD  --STR----------------------------------------
FUNCTION   i400_needord_from()
  DEFINE  l_oea901   LIKE   oea_file.oea901
  DEFINE  l_vlf03    LIKE   vlf_file.vlf03
  DEFINE  l_vlf21    LIKE   vlf_file.vlf21
  DEFINE  l_vlf22    LIKE   vlf_file.vlf22
  DEFINE  l_vlf23    LIKE   vlf_file.vlf23

  SELECT oea901 INTO l_oea901
    FROM oea_file
   WHERE oea01 = g_vmu[l_ac].vmu11

  CASE  g_vmu[l_ac].vmu25
        WHEN '0'  #合約訂單
           LET  g_cmd = "axmt400 '",g_vmu[l_ac].vmu11,"' 'query'"                    
           CALL cl_cmdrun(g_cmd)

        WHEN '1'  #一般訂單
           IF l_oea901 = 'Y' THEN
              LET  g_cmd = "axmt810 '",g_vmu[l_ac].vmu11,"' 'query'"
              CALL cl_cmdrun(g_cmd)
           ELSE
             LET  g_cmd = "axmt410 '",g_vmu[l_ac].vmu11,"' 'query'"
             CALL cl_cmdrun(g_cmd)
           END IF

        WHEN '2' #獨立需求
           LET  g_cmd = "amri506 '",g_vmu[l_ac].vmu11,"' 'query'"
           CALL cl_cmdrun(g_cmd)
  
        WHEN '3' #預測
          #FUN-B60063--mod---str---
          #SELECT vlf03,vlf21,vlf22,vlf23 INTO 
          #       l_vlf03, l_vlf21, l_vlf22, l_vlf23 
          #FROM vlf_file
          #WHERE vlf01 = g_vmu01
          #  AND vlf02 = g_vmu02
          #  AND vlf03 = g_vmu[l_ac].vmu23
          #  AND vlf26 = g_vmu[l_ac].vmu03
          #LET  g_cmd = "axmi171 '",l_vlf03,"' '",l_vlf21,"' '",l_vlf22,"' '",l_vlf23,"' "
           LET  g_cmd = "axmi171 '",g_vmu[l_ac].vmu23,"' '",g_vmu[l_ac].vmu06,"' '",g_vmu[l_ac].vmu18,"' '",g_vmu[l_ac].vmu16,"' "
          #FUN-B60063--mod---end---
           CALL cl_cmdrun(g_cmd)

  END CASE
END FUNCTION
#FUN-940001  ADD  --END------------------------------------------

#FUN-940064  ADD  --STR------------------------------------------
FUNCTION  i400_all_setY_redate()
  UPDATE  vmu_file SET vmu22 = 1
   WHERE  vmu01 = g_vmu01
     AND  vmu02 = g_vmu02
  CALL i400_show()
END FUNCTION

FUNCTION  i400_all_setN_redate()
  UPDATE  vmu_file SET vmu22 = 0
   WHERE  vmu01 = g_vmu01
     AND  vmu02 = g_vmu02
  CALL i400_show()
END FUNCTION

FUNCTION  i400_part_order_set()
DEFINE     p_row     LIKE  type_file.num5,
           p_col     LIKE  type_file.num5,
           j         LIKE  type_file.num5,
           j2        LIKE  type_file.num5,
           l_seq     LIKE  type_file.num5,
           l_vmu23   LIKE  vmu_file.vmu23,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5     
DEFINE     order     LIKE  type_file.num5
DEFINE     l_sql     string

  LET l_allow_insert = FALSE
  LET l_allow_delete = FALSE

  CALL i4004_set_no_entry()
  OPEN WINDOW i400_4_w AT 15,20 WITH FORM "aps/42f/apsi4004"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("apsi4004")
  CALL cl_set_head_visible("","YES")     
  DECLARE i400_4_c CURSOR FOR
  SELECT distinct 0 seq,ima01,ima02,ima131,oba02 
    FROM vmu_file,ima_file,OUTER oba_file 
   WHERE vmu23 = ima01 
    AND vmu01  = g_vmu01
    AND vmu02  = g_vmu02
    AND ima131 = oba_file.oba01
    ORDER BY ima01 

  CALL part_vmu.clear()
  LET g_cnt = 1

  DELETE  FROM  part_tmp
  FOREACH i400_4_c INTO part_vmu[g_cnt].*
    IF STATUS THEN
       CALL cl_err('foreach vmu',STATUS,0)
       EXIT FOREACH
    END IF
    LET part_vmu[g_cnt].seq = g_cnt * 10
    INSERT INTO part_tmp(seq,ima01,ima02,ima131,oba02) 
                  VALUES(part_vmu[g_cnt].seq,part_vmu[g_cnt].ima01,part_vmu[g_cnt].ima02,
                         part_vmu[g_cnt].ima131,part_vmu[g_cnt].oba02)
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  LET g_cnts = g_cnt - 1

  WHILE TRUE

     INPUT ARRAY part_vmu WITHOUT DEFAULTS FROM part_w.*
        ATTRIBUTE(COUNT=g_rec_b-1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE ROW
           CALL i4004_set_no_entry()
           LET j=ARR_CURR()

        AFTER FIELD seq
           LET l_seq = get_fldbuf(seq)
           LET l_vmu23 = get_fldbuf(vmu23)
           IF (cl_null(l_seq)  OR  l_seq<0 OR l_seq>999999) AND 
              (NOT cl_null(l_vmu23)) THEN
              CALL cl_err('','mfg3291',0)
              NEXT FIELD seq
           END IF
           FOR j2=1 TO g_cnts 
               IF part_vmu[j2].seq = l_seq AND j2<>j THEN
                  CALL cl_err('','abx-044',1)
                  NEXT FIELD seq
               END IF
           END FOR

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         
           CALL cl_about()      

        ON ACTION help          
           CALL cl_show_help()  

        ON ACTION controlg      
           CALL cl_cmdask()     

        #項次由10重排
        ON ACTION i4004_sor_ten
           CALL i4004_sor_ten()
        #依產品分類碼排序 
        ON ACTION i4004_part_group_sort
           CALL i4004_part_sortgroup()

     END INPUT

     IF INT_FLAG THEN
        CALL cl_err('',9001,0)
        CLOSE WINDOW i400_4_w
        LET INT_FLAG = 0
        RETURN
     END IF
     EXIT WHILE
  END WHILE
  CALL i4004_sor_ten()
  COMMIT WORK
  CLOSE WINDOW i400_4_w                #結束畫面

END FUNCTION

FUNCTION i4004_set_no_entry()
  CALL cl_set_comp_entry("ima01,ima02,ima131,oba02",FALSE)
  CALL cl_set_comp_entry("seq",TRUE)
END FUNCTION

FUNCTION  i4004_sor_ten()
  DELETE FROM part_tmp
  FOR g_cnt = 1 TO g_max_rec
    IF NOT cl_null(part_vmu[g_cnt].ima01) THEN
       INSERT INTO part_tmp(seq,ima01,ima02,ima131,oba02)
                     VALUES(part_vmu[g_cnt].seq,part_vmu[g_cnt].ima01,part_vmu[g_cnt].ima02,
                            part_vmu[g_cnt].ima131,part_vmu[g_cnt].oba02)
    END IF
  END FOR
  CALL part_vmu.clear()
 
  DECLARE i400_4_c2 CURSOR FOR
  SELECT  seq,ima01,ima02,ima131,oba02 FROM part_tmp ORDER BY seq
 
  LET g_cnt = 1
  FOREACH i400_4_c2 INTO part_vmu[g_cnt].*
    IF STATUS THEN
       CALL cl_err('foreach vmu',STATUS,0)
       EXIT FOREACH
    END IF
    LET part_vmu[g_cnt].seq = g_cnt * 10
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  DISPLAY ARRAY part_vmu TO part_w.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
END FUNCTION

FUNCTION i4004_part_sortgroup() 
  DELETE FROM part_tmp
  FOR g_cnt = 1 to g_max_rec
      IF NOT cl_null(part_vmu[g_cnt].ima01) THEN
         INSERT INTO part_tmp(seq,ima01,ima02,ima131,oba02)
             values(part_vmu[g_cnt].seq,part_vmu[g_cnt].ima01,part_vmu[g_cnt].ima02,
                    part_vmu[g_cnt].ima131,part_vmu[g_cnt].oba02)
      END IF
  END FOR
  CALL part_vmu.clear()

  DECLARE i400_4_c4 CURSOR FOR
      SELECT  seq,ima01,ima02,ima131,oba02 from part_tmp order by ima131
  LET g_cnt = 1
  FOREACH i400_4_c4 INTO part_vmu[g_cnt].*
    IF STATUS THEN
       CALL cl_err('foreach vmu',STATUS,0)
       EXIT FOREACH
    END IF
    LET part_vmu[g_cnt].seq = g_cnt * 10
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  DISPLAY ARRAY part_vmu TO part_w.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

END FUNCTION

#FUN-940064  ADD  --END--------------------------------------------



#FUN-AB0090---add---str--#1210
FUNCTION i400_reorder_cursor()
    #=>料件
    DECLARE i400_part_c1 CURSOR FOR
    SELECT UNIQUE vlp02,vmu23,ima02,ima131,oba02
      FROM vmu_file,OUTER vlp_file,OUTER ima_file,OUTER oba_file 
     WHERE vmu01 = g_vmu01
       AND vmu02 = g_vmu02
       AND vlp_file.vlp01 = '1' #料件
       AND vmu23 = vlp_file.vlp03
       AND vmu23 = ima_file.ima01
       AND ima131 = oba_file.oba01
      ORDER BY vlp02,vmu23
    
    DECLARE i400_part_c2 CURSOR FOR
    SELECT seq,ima01,ima02,ima131,oba02 
      FROM part_tmp
      ORDER BY seq

    #=>客戶
    DECLARE i400_cust_c1 CURSOR FOR
    SELECT UNIQUE vlp02,vmu06,occ02,vmu15 
      FROM vmu_file,OUTER vlp_file,OUTER occ_file 
     WHERE vmu01 = g_vmu01
       AND vmu02 = g_vmu02
       AND vlp_file.vlp01 = '2' #客戶
       AND vmu06 = vlp_file.vlp03
       AND vmu06 = occ_file.occ01
      ORDER BY vlp02,vmu06

    DECLARE i400_cust_c2 CURSOR FOR
    SELECT seq,cust01,cust02,cust03
      FROM cust_tmp
     ORDER BY seq

    #=>業務
    DECLARE i400_sales_c1 CURSOR FOR
    SELECT UNIQUE vlp02,vmu16,gen02,gen03,gem03
      FROM vmu_file,OUTER vlp_file,OUTER gen_file,OUTER gem_file
     WHERE vmu01 = g_vmu01
       AND vmu02 = g_vmu02
       AND vlp_file.vlp01 = '3' #業務
       AND vmu16 = vlp_file.vlp03
       AND vmu16 = gen_file.gen01 
       AND gen03 = gem_file.gem01
      ORDER BY vlp02,vmu16

    DECLARE i400_sales_c2 CURSOR FOR
    SELECT seq,gen01,gen02,gen03,gem02
      FROM sales_tmp
     ORDER BY seq
END FUNCTION

FUNCTION i400_fill_part_tmp()
  DEFINE l_cnt    LIKE type_file.num5

  SELECT COUNT(*) INTO l_cnt 
    FROM part_tmp
  IF l_cnt = 0 THEN 
      DELETE FROM part_tmp
      CALL part_vmu.clear()
      LET g_cnt = 1
      FOREACH i400_part_c1 INTO part_vmu[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach i400_part_c1',STATUS,0)
           EXIT FOREACH
        END IF
        INSERT INTO part_tmp(seq,ima01,ima02,ima131,oba02) 
                      VALUES(part_vmu[g_cnt].seq,part_vmu[g_cnt].ima01,part_vmu[g_cnt].ima02,
                             part_vmu[g_cnt].ima131,part_vmu[g_cnt].oba02)
        LET g_cnt = g_cnt + 1
      END FOREACH
      CALL part_vmu.deleteElement(g_cnt)
      LET g_rec_b_part = g_cnt - 1
  ELSE
      CALL part_vmu.clear()
      LET g_cnt = 1
      FOREACH i400_part_c2 INTO part_vmu[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach i400_part_c2',STATUS,0)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      END FOREACH
      CALL part_vmu.deleteElement(g_cnt)
      LET g_rec_b_part = g_cnt - 1
  END IF 
END FUNCTION

FUNCTION i400_fill_cust_tmp()
  DEFINE l_cnt    LIKE type_file.num5

  SELECT COUNT(*) INTO l_cnt 
    FROM cust_tmp
  IF l_cnt = 0 THEN 
      DELETE FROM cust_tmp
      CALL cust_vmu.clear()
      LET g_cnt = 1
      FOREACH i400_cust_c1 INTO cust_vmu[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach i400_cust_c1',STATUS,0)
           EXIT FOREACH
        END IF
        INSERT INTO cust_tmp(seq,cust01,cust02,cust03) 
                      values(cust_vmu[g_cnt].seq,cust_vmu[g_cnt].vmu06,cust_vmu[g_cnt].occ02,
                             cust_vmu[g_cnt].vmu15)
        LET g_cnt = g_cnt + 1
      END FOREACH
      CALL cust_vmu.deleteElement(g_cnt)
      LET g_rec_b_cust = g_cnt - 1
  ELSE
      CALL cust_vmu.clear()
      LET g_cnt = 1
      FOREACH i400_cust_c2 INTO cust_vmu[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach i400_cust_c2',STATUS,0)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      END FOREACH
      CALL cust_vmu.deleteElement(g_cnt)
      LET g_rec_b_cust = g_cnt - 1
  END IF 
END FUNCTION

FUNCTION i400_fill_sales_tmp()
  DEFINE l_cnt    LIKE type_file.num5

  SELECT COUNT(*) INTO l_cnt 
    FROM sales_tmp
  IF l_cnt = 0 THEN 
      DELETE FROM sales_tmp
      CALL sales_vmu.clear()
      LET g_cnt = 1
      FOREACH i400_sales_c1 INTO sales_vmu[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach i400_sales_c1',STATUS,0)
           EXIT FOREACH
        END IF
        INSERT INTO sales_tmp(seq,gen01,gen02,gen03,gem02)
                     values(sales_vmu[g_cnt].seq,sales_vmu[g_cnt].gen01,sales_vmu[g_cnt].gen02,
                            sales_vmu[g_cnt].gen03,sales_vmu[g_cnt].gem02)
        LET g_cnt = g_cnt + 1
      END FOREACH
      CALL sales_vmu.deleteElement(g_cnt)
      LET g_rec_b_sales = g_cnt - 1
  ELSE
      CALL sales_vmu.clear()
      LET g_cnt = 1
      FOREACH i400_sales_c2 INTO sales_vmu[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach i400_sales_c2',STATUS,0)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      END FOREACH
      CALL sales_vmu.deleteElement(g_cnt)
      LET g_rec_b_sales = g_cnt - 1
  END IF 
END FUNCTION

FUNCTION i400_input_part()
DEFINE     p_row     LIKE  type_file.num5,
           p_col     LIKE  type_file.num5,
           j         LIKE  type_file.num5,
           j2        LIKE  type_file.num5,
           l_seq     LIKE  type_file.num5,
           l_vmu23   LIKE  vmu_file.vmu23,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5     
DEFINE     order     LIKE  type_file.num5
DEFINE     l_sql     string

  LET l_allow_insert = FALSE
  LET l_allow_delete = FALSE

  OPEN WINDOW i400_4_w AT 15,20 WITH FORM "aps/42f/apsi4004"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("apsi4004")
  CALL cl_set_head_visible("","YES")     

  WHILE TRUE

     INPUT ARRAY part_vmu WITHOUT DEFAULTS FROM part_w.*
        ATTRIBUTE(COUNT=g_rec_b-1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE ROW
            LET l_ac = ARR_CURR()
        ON ROW CHANGE
           IF INT_FLAG THEN          
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              EXIT INPUT
           END IF
           UPDATE part_tmp
              SET seq = part_vmu[l_ac].seq
            WHERE ima01 = part_vmu[l_ac].ima01

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         
           CALL cl_about()      

        ON ACTION help          
           CALL cl_show_help()  

        ON ACTION controlg      
           CALL cl_cmdask()     

        #依產品分類碼排序 
        ON ACTION i4004_part_group_sort
           CALL i400_reorder_part2()
           CALL i400_fill_part_tmp()

        #項次由10重排
        ON ACTION i4004_sor_ten
           CALL i400_reorder_part1()
           CALL i400_fill_part_tmp()

     END INPUT

     IF INT_FLAG THEN
        CALL cl_err('',9001,0)
        CLOSE WINDOW i400_4_w
        LET INT_FLAG = 0
        RETURN
     END IF
     EXIT WHILE
  END WHILE
  CALL i400_fill_part_tmp()
  CLOSE WINDOW i400_4_w                #結束畫面

END FUNCTION

FUNCTION i400_reorder_part1() 
DEFINE l_seq_old     LIKE vlp_file.vlp02
DEFINE l_seq_new     LIKE vlp_file.vlp02
DEFINE l_seq_last    LIKE vlp_file.vlp02
DEFINE l_ima01       LIKE ima_file.ima01

  DECLARE i400_reorder_part1 CURSOR FOR
   SELECT seq,ima01
    FROM part_tmp
   ORDER BY seq,ima01

   LET l_seq_new = 0
   LET l_seq_last = ''
   FOREACH i400_reorder_part1 INTO l_seq_old,l_ima01
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:i400_reorder_part1',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(l_seq_last) THEN
           LET l_seq_new = l_seq_new + 10
       ELSE
           IF NOT cl_null(l_seq_old) THEN
               IF l_seq_last <> l_seq_old THEN
                   LET l_seq_new = l_seq_new + 10
               END IF
           ELSE
               LET l_seq_new = l_seq_new + 10
           END IF
       END IF
       UPDATE part_tmp
          SET seq = l_seq_new
        WHERE ima01 = l_ima01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_seq_last = l_seq_old
   END FOREACH
END FUNCTION

FUNCTION i400_reorder_part2() 
DEFINE l_seq_old     LIKE vlp_file.vlp02
DEFINE l_seq_new     LIKE vlp_file.vlp02
DEFINE l_ima01       LIKE ima_file.ima01
DEFINE l_ima131      LIKE ima_file.ima131

  DECLARE i400_reorder_part2 CURSOR FOR
   SELECT seq,ima01,ima131
    FROM part_tmp
   ORDER BY ima131,ima01

   LET l_seq_new = 10
   FOREACH i400_reorder_part2 INTO l_seq_old,l_ima01,l_ima131
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:i400_reorder_part2',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE part_tmp
          SET seq = l_seq_new
        WHERE ima01 = l_ima01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_seq_new = l_seq_new + 10
   END FOREACH
END FUNCTION

FUNCTION i400_input_cust()
DEFINE     p_row     LIKE  type_file.num5,
           p_col     LIKE  type_file.num5,
           j         LIKE  type_file.num5,
           j2        LIKE  type_file.num5,
           l_seq     LIKE  type_file.num5,
           l_vmu23   LIKE  vmu_file.vmu23,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5     
DEFINE     order     LIKE  type_file.num5
DEFINE     l_sql     string

  LET l_allow_insert = FALSE
  LET l_allow_delete = FALSE

  OPEN WINDOW i400_2_w AT 15,20 WITH FORM "aps/42f/apsi4002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("apsi4002")
  CALL cl_set_head_visible("","YES")     

  WHILE TRUE

     INPUT ARRAY cust_vmu WITHOUT DEFAULTS FROM cust_w.*
        ATTRIBUTE(COUNT=g_rec_b-1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE ROW
            LET l_ac = ARR_CURR()
        ON ROW CHANGE
           IF INT_FLAG THEN          
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              EXIT INPUT
           END IF
           UPDATE cust_tmp
                 SET seq = cust_vmu[l_ac].seq
            WHERE cust01 = cust_vmu[l_ac].vmu06

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         
           CALL cl_about()      

        ON ACTION help          
           CALL cl_show_help()  

        ON ACTION controlg      
           CALL cl_cmdask()     

        #依客戶代號排序 
        ON ACTION i4002_cust_no_sort
           CALL i400_reorder_cust2()
           CALL i400_fill_cust_tmp()

        #依客戶群組排序
        ON ACTION i4002_cust_group_sort
           CALL i400_reorder_cust3()
           CALL i400_fill_cust_tmp()

        #項次由10重排
        ON ACTION i4002_sor_ten
           CALL i400_reorder_cust1()
           CALL i400_fill_cust_tmp()

     END INPUT

     IF INT_FLAG THEN
        CALL cl_err('',9001,0)
        CLOSE WINDOW i400_2_w
        LET INT_FLAG = 0
        RETURN
     END IF
     EXIT WHILE
  END WHILE
  CALL i400_fill_cust_tmp()
  CLOSE WINDOW i400_2_w                #結束畫面

END FUNCTION

FUNCTION i400_reorder_cust1() 
DEFINE l_seq_old     LIKE vlp_file.vlp02
DEFINE l_seq_new     LIKE vlp_file.vlp02
DEFINE l_seq_last    LIKE vlp_file.vlp02
DEFINE l_cust01      LIKE occ_file.occ01

  DECLARE i400_reorder_cust1 CURSOR FOR
   SELECT seq,cust01
    FROM cust_tmp
   ORDER BY seq,cust01

   LET l_seq_new = 0
   LET l_seq_last = ''
   FOREACH i400_reorder_cust1 INTO l_seq_old,l_cust01
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:i400_reorder_cust1',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(l_seq_last) THEN
           LET l_seq_new = l_seq_new + 10
       ELSE
           IF NOT cl_null(l_seq_old) THEN
               IF l_seq_last <> l_seq_old THEN
                   LET l_seq_new = l_seq_new + 10
               END IF
           ELSE
               LET l_seq_new = l_seq_new + 10
           END IF
       END IF
       UPDATE cust_tmp
          SET seq = l_seq_new
        WHERE cust01 = l_cust01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_seq_last = l_seq_old
   END FOREACH
END FUNCTION

FUNCTION i400_reorder_cust2()
DEFINE l_seq_old     LIKE vlp_file.vlp02
DEFINE l_seq_new     LIKE vlp_file.vlp02
DEFINE l_cust01      LIKE occ_file.occ01
DEFINE l_cust02      LIKE occ_file.occ02
DEFINE l_cust03      LIKE vmu_file.vmu15

  DECLARE i400_reorder_cust2 CURSOR FOR
   SELECT seq,cust01,cust02,cust03 
     FROM cust_tmp
   ORDER BY cust01

   LET l_seq_new = 10
   FOREACH i400_reorder_cust2 INTO l_seq_old,l_cust01,l_cust02,l_cust03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:i400_reorder_cust2',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE cust_tmp
          SET seq = l_seq_new
        WHERE cust01 = l_cust01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_seq_new = l_seq_new + 10
   END FOREACH
END FUNCTION

FUNCTION i400_reorder_cust3()
DEFINE l_seq_old     LIKE vlp_file.vlp02
DEFINE l_seq_new     LIKE vlp_file.vlp02
DEFINE l_cust01      LIKE occ_file.occ01
DEFINE l_cust02      LIKE occ_file.occ02
DEFINE l_cust03      LIKE vmu_file.vmu15

  DECLARE i400_reorder_cust3 CURSOR FOR
   SELECT seq,cust01,cust02,cust03 
     FROM cust_tmp
   ORDER BY cust03,cust01

   LET l_seq_new = 10
   FOREACH i400_reorder_cust3 INTO l_seq_old,l_cust01,l_cust02,l_cust03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:i400_reorder_cust3',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE cust_tmp
          SET seq = l_seq_new
        WHERE cust01 = l_cust01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_seq_new = l_seq_new + 10
   END FOREACH
END FUNCTION

FUNCTION i400_input_sales()
DEFINE     p_row     LIKE  type_file.num5,
           p_col     LIKE  type_file.num5,
           j         LIKE  type_file.num5,
           j2        LIKE  type_file.num5,
           l_seq     LIKE  type_file.num5,
           l_vmu23   LIKE  vmu_file.vmu23,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5     
DEFINE     order     LIKE  type_file.num5
DEFINE     l_sql     string

  LET l_allow_insert = FALSE
  LET l_allow_delete = FALSE

  OPEN WINDOW i400_3_w AT 15,20 WITH FORM "aps/42f/apsi4003"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("apsi4003")
  CALL cl_set_head_visible("","YES")     

  WHILE TRUE

     INPUT ARRAY sales_vmu WITHOUT DEFAULTS FROM sales_w.*
        ATTRIBUTE(COUNT=g_rec_b-1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE ROW
            LET l_ac = ARR_CURR()
        ON ROW CHANGE
           IF INT_FLAG THEN          
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              EXIT INPUT
           END IF
           UPDATE sales_tmp
              SET seq = sales_vmu[l_ac].seq
            WHERE gen01 = sales_vmu[l_ac].gen01

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         
           CALL cl_about()      

        ON ACTION help          
           CALL cl_show_help()  

        ON ACTION controlg      
           CALL cl_cmdask()     

        #依業務員排序
        ON ACTION sales_no_sort
           CALL i400_reorder_sales2()
           CALL i400_fill_sales_tmp()

        #依部門排序
        ON ACTION depart_sort
           CALL i400_reorder_sales3()
           CALL i400_fill_sales_tmp()

        #項次由10重排
        ON ACTION i4003_sor_ten
           CALL i400_reorder_sales1()
           CALL i400_fill_sales_tmp()
        

     END INPUT

     IF INT_FLAG THEN
        CALL cl_err('',9001,0)
        CLOSE WINDOW i400_3_w
        LET INT_FLAG = 0
        RETURN
     END IF
     EXIT WHILE
  END WHILE
  CALL i400_fill_cust_tmp()
  CLOSE WINDOW i400_3_w                #結束畫面

END FUNCTION

FUNCTION i400_reorder_sales1() 
DEFINE l_seq_old     LIKE vlp_file.vlp02
DEFINE l_seq_new     LIKE vlp_file.vlp02
DEFINE l_seq_last    LIKE vlp_file.vlp02
DEFINE l_gen01       LIKE gen_file.gen01

  DECLARE i400_reorder_sales1 CURSOR FOR
   SELECT seq,gen01
    FROM sales_tmp
   ORDER BY seq,gen01

   LET l_seq_new = 0
   LET l_seq_last = ''
   FOREACH i400_reorder_sales1 INTO l_seq_old,l_gen01
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:i400_reorder_sales1',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(l_seq_last) THEN
           LET l_seq_new = l_seq_new + 10
       ELSE
           IF NOT cl_null(l_seq_old) THEN
               IF l_seq_last <> l_seq_old THEN
                   LET l_seq_new = l_seq_new + 10
               END IF
           ELSE
               LET l_seq_new = l_seq_new + 10
           END IF
       END IF
       UPDATE sales_tmp
          SET seq = l_seq_new
        WHERE gen01 = l_gen01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_seq_last = l_seq_old
   END FOREACH
END FUNCTION

FUNCTION i400_reorder_sales2()
DEFINE l_seq_old     LIKE vlp_file.vlp02
DEFINE l_seq_new     LIKE vlp_file.vlp02
DEFINE l_gen01       LIKE gen_file.gen01
DEFINE l_gen03       LIKE gen_file.gen03

  DECLARE i400_reorder_sales2 CURSOR FOR
   SELECT seq,gen01,gen03
     FROM sales_tmp
   ORDER BY gen01

   LET l_seq_new = 10
   FOREACH i400_reorder_sales2 INTO l_seq_old,l_gen01,l_gen03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:i400_reorder_sales2',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE sales_tmp
          SET seq = l_seq_new
        WHERE gen01 = l_gen01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_seq_new = l_seq_new + 10
   END FOREACH
END FUNCTION

FUNCTION i400_reorder_sales3()
DEFINE l_seq_old     LIKE vlp_file.vlp02
DEFINE l_seq_new     LIKE vlp_file.vlp02
DEFINE l_gen01       LIKE gen_file.gen01
DEFINE l_gen03       LIKE gen_file.gen03

  DECLARE i400_reorder_sales3 CURSOR FOR
   SELECT seq,gen01,gen03
     FROM sales_tmp
   ORDER BY gen03,gen01

   LET l_seq_new = 10
   FOREACH i400_reorder_sales3 INTO l_seq_old,l_gen01,l_gen03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:i400_reorder_cust3',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE sales_tmp
          SET seq = l_seq_new
        WHERE gen01 = l_gen01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_seq_new = l_seq_new + 10
   END FOREACH
END FUNCTION

FUNCTION i400_reorder_vmu(p_vmu01,p_vmu02,p_s1,p_s2,p_s3,p_s4) 
DEFINE p_vmu01         LIKE vmu_file.vmu01
DEFINE p_vmu02         LIKE vmu_file.vmu02
DEFINE p_s1            LIKE vlo_file.vlo03
DEFINE p_s2            LIKE vlo_file.vlo04
DEFINE p_s3            LIKE vlo_file.vlo05
DEFINE p_s4            LIKE vlo_file.vlo06
#DEFINE l_vmu_rowid     LIKE type_file.chr18  #FUN-B50022 mark
DEFINE l_vmu01         LIKE vmu_file.vmu01    #FUN-B50022 add
DEFINE l_vmu02         LIKE vmu_file.vmu02    #FUN-B50022 add
DEFINE l_vmu03         LIKE vmu_file.vmu03    #FUN-B50022 add
DEFINE l_seq_1         LIKE vlp_file.vlp02
DEFINE l_seq_2         LIKE vlp_file.vlp02
DEFINE l_seq_3         LIKE vlp_file.vlp02
DEFINE l_vmu08         LIKE vmu_file.vmu08
DEFINE l_vmu04         LIKE vmu_file.vmu04
DEFINE l_vmu10         LIKE vmu_file.vmu10
DEFINE l_sql           STRING                                                   
DEFINE l_order1        STRING                                                   
DEFINE l_order2        STRING                                                   
DEFINE l_order3        STRING                                                   

   LET g_success = 'Y'
   CASE 
        WHEN p_s1 = '1' #料號
              LET l_order1 = 'part_tmp.seq'
        WHEN p_s1 = '2' #客戶
              LET l_order1 = 'cust_tmp.seq'
        WHEN p_s1 = '3' #業務員
              LET l_order1 = 'sales_tmp.seq'
        WHEN p_s1 = '4' AND p_s4='F' #需求形式
              LET l_order1 = 'vmu08'
        WHEN p_s1 = '4' AND p_s4='R' #需求形式
              LET l_order1 = 'vmu08 DESC'
        WHEN p_s1 = '5' #交期
              LET l_order1 = 'vmu04'
   END CASE

   CASE 
        WHEN p_s2 = '1' #料號
              LET l_order2 = 'part_tmp.seq'
        WHEN p_s2 = '2' #客戶
              LET l_order2 = 'cust_tmp.seq'
        WHEN p_s2 = '3' #業務員
              LET l_order2 = 'sales_tmp.seq'
        WHEN p_s2 = '4' AND p_s4='F' #需求形式
              LET l_order2 = 'vmu08'
        WHEN p_s2 = '4' AND p_s4='R' #需求形式
              LET l_order2 = 'vmu08 DESC'
        WHEN p_s2 = '5' #交期
              LET l_order2 = 'vmu04'
   END CASE

   CASE 
        WHEN p_s3 = '1' #料號
              LET l_order3 = 'part_tmp.seq'
        WHEN p_s3 = '2' #客戶
              LET l_order3 = 'cust_tmp.seq'
        WHEN p_s3 = '3' #業務員
              LET l_order3 = 'sales_tmp.seq'
        WHEN p_s3 = '4' AND p_s4='F' #需求形式
              LET l_order3 = 'vmu08'
        WHEN p_s3 = '4' AND p_s4='R' #需求形式
              LET l_order3 = 'vmu08 DESC'
        WHEN p_s3 = '5' #交期
              LET l_order3 = 'vmu04'
   END CASE

  #FUN-B50022---mod---str----
  #LET l_sql = "SELECT vmu_file.ROWID,part_tmp.seq, ",
  #            "                      cust_tmp.seq, ",
  #            "                      sales_tmp.seq,vmu08,vmu04 ",
  #            "  FROM vmu_file,part_tmp,cust_tmp,sales_tmp ",
  #            " WHERE vmu01 = '",p_vmu01,"'",
  #            "   AND vmu02 = '",p_vmu02,"'",
  #            "   AND vmu23 =  part_tmp.ima01 (+) ",  #TQC-AC0270 mod
  #            "   AND vmu06 =  cust_tmp.cust01 (+) ", #TQC-AC0270 mod
  #            "   AND vmu16 = sales_tmp.gen01 (+) ",  #TQC-AC0270 mod
  #            "  ORDER BY ",l_order1 CLIPPED,",",
  #                          l_order2 CLIPPED,",",
  #                          l_order3 CLIPPED,",",
  #            " vmu04 " #交期

   LET l_sql = "SELECT vmu01,vmu02,vmu03,part_tmp.seq, ",
               "                      cust_tmp.seq, ",
               "                      sales_tmp.seq,vmu08,vmu04 ",
               "  FROM vmu_file ",
               "  LEFT OUTER JOIN part_tmp  ON vmu23 = part_tmp.ima01  ",
               "  LEFT OUTER JOIN cust_tmp  ON vmu06 = cust_tmp.cust01 ",
               "  LEFT OUTER JOIN sales_tmp ON vmu16 = sales_tmp.gen01 ",
               " WHERE vmu01 = '",p_vmu01,"'",
               "   AND vmu02 = '",p_vmu02,"'",
               "  ORDER BY ",l_order1 CLIPPED,",",
                             l_order2 CLIPPED,",",
                             l_order3 CLIPPED,",",
               " vmu04 " #交期
  #FUN-B50022---mod---end----
               
   PREPARE i400_reorder_vmu_p FROM l_sql
   DECLARE i400_reorder_vmu_c CURSOR FOR i400_reorder_vmu_p

   LET l_vmu10 = 10
  #FOREACH i400_reorder_vmu_c INTO l_vmu_rowid,l_seq_1,l_seq_2,l_seq_3,l_vmu08,l_vmu04             #FUN-B50022 mark
   FOREACH i400_reorder_vmu_c INTO l_vmu01,l_vmu02,l_vmu03,l_seq_1,l_seq_2,l_seq_3,l_vmu08,l_vmu04 #FUN-B50022 add
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:s_reorder_vmu_c',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       UPDATE vmu_file
          SET vmu10 = l_vmu10
       #WHERE ROWID = l_vmu_rowid  #FUN-B50022 mark
        WHERE vmu01 = l_vmu01      #FUN-B50022 add
          AND vmu02 = l_vmu02      #FUN-B50022 add
          AND vmu03 = l_vmu03      #FUN-B50022 add
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('UPDATE vmu_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_vmu10 = l_vmu10 + 10
   END FOREACH
END FUNCTION

FUNCTION i400_del_tmp()
   DELETE FROM cust_tmp
   DELETE FROM sales_tmp
   DELETE FROM part_tmp
END FUNCTION
#FUN-AB0090--add---end--
