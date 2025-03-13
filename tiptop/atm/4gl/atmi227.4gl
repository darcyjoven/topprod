# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi227.4gl
# Descriptions...: 產品定價表維護作業
# Date & Author..: 05/12/20 By jackie
# Modify.........: No.TQC-630069 06/03/07 By Smapmin 流程訊息通知功能
# Modify.........: No.TQC-640083 06/04/08 By jackie 同一料件訂價單位不同可有重疊生效失效日期
# Modify.........: No.TQC-660071 06/06/14 By Smapmin 補充TQC-630069
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3
# Modify.........: No.TQC-660134 06/06/29 By cl   新增取價方式
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-690025 06/09/20 By jamie 改判斷狀況碼ima1010
# Modify.........: No.TQC-680107 06/09/22 By Rayven 不使用計價單位時，隱藏計價單位欄位
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740162 07/04/21 By chenl   修正整批產生中斷后仍然產生單據的問題。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7B0108 07/11/19 By wujie   單身料號的控管不應是ima1010!='1'，應判斷imaacti
# Modify.........: No.TQC-7B0118 07/12/08 By wujie   單身在多筆資料的“料件編號”、“單位”一致的情況下，生效日期和失效日期相互之間不能重疊，現在可以維護進重疊的資料
#                                                    狀態碼取消‘1’-申請，改為‘0’-開立，‘1’-已審核，‘2’-挂起，同時取消相應的“申請”和“取消申請”的按鈕
# Modify.........: No.TQC-7C0138 07/12/10 By wujie   單身日期區間判斷重疊有錯誤
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0010 08/02/14 By Carrier 資料中心功能
#                                         1.加入tqm07 & price_list array
#                                         2.加入bp2()
# Modify.........: FUN-830090 08/03/26 By Carrier 修改s_atmp227_carry的參數
# Modify.........: NO.FUN-840018 08/04/07 BY yiting 增加一個頁面放置清單資料
# Modify.........: NO.FUN-840033 08/04/08 BY yiting atmp227 call atmi227 add Price_List
# Modify.........: No.FUN-840068 08/04/17 By TSD.Achick 自定欄位功能修改
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.MOD-880196 08/08/25 By lumx    修改單身時候 更新單頭的修改者和修改日期
# Modify.........: No.MOD-820125 08/08/28 By chenl   對單價進行取位
# Modify.........: No.CHI-880031 08/09/09 By xiaofeizhu 查出資料后,應該停在第一筆資料上,不必預設是看資料清單,有需要瀏覽,再行點選
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-870100 09/07/16 By Cockroach  零售移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/08 By chenls 程序精簡
# Modify.........: No.TQC-A10097 10/01/11 By lilingyu 狀態頁簽有欄位無法下查詢條件
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30034 10/03/12 By Cockroach add orig/oriu
# Modify.........: No.FUN-A60077 10/06/27 By shenyang
# Modify.........: No.MOD-AA0053 10/10/12 By Summer 訂價類別欄位改為必填且Default '1.一般訂價' 
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0025 10/11/10 By chenying  修改料號開窗
# Modify.........: No.TQC-AB0153 10/11/29 By huangtao 修改批量產生單價時候折扣率為空的問題
# Modify.........: No.MOD-AC0064 10/10/12 By shenyang 城市處理產品價格時按對應幣別取位數
# Modify.........: No.MOD-AC0221 10/12/20 By suncx 調整畫面當，將單身供應商分攤率畫面顏色顯示改為非必填
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:CHI-BB0034 12/02/02 By ck2yuan 只有在查詢時才出現9025警告，其他action不需要
# Modify.........: No:TQC-C20152 12/02/14 By yangxf 控卡企业料号及添加QBE CONSTRUCT組合查詢條件
# Modify.........: No:MOD-C20189 12/02/23 By suncx 已審核資料不可重複審核
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-7C0010
 
#模組變數(Module Variables)
DEFINE
    g_tqm           RECORD LIKE tqm_file.*,       #單頭
    g_tqm_t         RECORD LIKE tqm_file.*,       #單頭(舊值)
    g_tqm_o         RECORD LIKE tqm_file.*,       #單頭(舊值)
    g_tqm01         LIKE tqm_file.tqm01,   #單頭KEY
    g_tqm01_t       LIKE tqm_file.tqm01,   #單頭KEY (舊值)
    g_t1            LIKE oay_file.oayslip,                  #No.FUN-680120 VARCHAR(05)
    g_tqn           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        tqn02       LIKE tqn_file.tqn02,   #項次
        tqn03       LIKE tqn_file.tqn03,   #產品編號
        ima02       LIKE ima_file.ima02,   #產品名稱
        tqn04       LIKE tqn_file.tqn04,   #定價單位
        ima908      LIKE ima_file.ima908,  #計價單位
        tqn08       LIKE tqn_file.tqn08,   #原價格                     #NO.FUN-870100 ADD
        tqn09       LIKE tqn_file.tqn09,   #折扣率%                    #NO.FUN-870100 ADD
        tqn05       LIKE tqn_file.tqn05,   #未稅單價
        tqn10       LIKE tqn_file.tqn10,   #供貨商分攤比率%            #NO.FUN-870100 ADD
        tqn06       LIKE tqn_file.tqn06,   #生效日期
        tqn07       LIKE tqn_file.tqn07    #失效日期
       ,tqnud01 LIKE tqn_file.tqnud01,
        tqnud02 LIKE tqn_file.tqnud02,
        tqnud03 LIKE tqn_file.tqnud03,
        tqnud04 LIKE tqn_file.tqnud04,
        tqnud05 LIKE tqn_file.tqnud05,
        tqnud06 LIKE tqn_file.tqnud06,
        tqnud07 LIKE tqn_file.tqnud07,
        tqnud08 LIKE tqn_file.tqnud08,
        tqnud09 LIKE tqn_file.tqnud09,
        tqnud10 LIKE tqn_file.tqnud10,
        tqnud11 LIKE tqn_file.tqnud11,
        tqnud12 LIKE tqn_file.tqnud12,
        tqnud13 LIKE tqn_file.tqnud13,
        tqnud14 LIKE tqn_file.tqnud14,
        tqnud15 LIKE tqn_file.tqnud15
                    END RECORD,
    g_tqn_t         RECORD                 #程式變數 (舊值)
        tqn02       LIKE tqn_file.tqn02,   #項次
        tqn03       LIKE tqn_file.tqn03,   #產品編號
        ima02       LIKE ima_file.ima02,   #產品名稱
        tqn04       LIKE tqn_file.tqn04,   #定價單位
        ima908      LIKE ima_file.ima908,  #計價單位
        tqn08       LIKE tqn_file.tqn08,   #原價格                     #NO.FUN-870100 ADD
        tqn09       LIKE tqn_file.tqn09,   #折扣率%                    #NO.FUN-870100 ADD
        tqn05       LIKE tqn_file.tqn05,   #未稅單價
        tqn10       LIKE tqn_file.tqn10,   #供貨商分攤比率%            #NO.FUN-870100 ADD 
        tqn06       LIKE tqn_file.tqn06,   #生效日期
        tqn07       LIKE tqn_file.tqn07    #失效日期
       ,tqnud01 LIKE tqn_file.tqnud01,
        tqnud02 LIKE tqn_file.tqnud02,
        tqnud03 LIKE tqn_file.tqnud03,
        tqnud04 LIKE tqn_file.tqnud04,
        tqnud05 LIKE tqn_file.tqnud05,
        tqnud06 LIKE tqn_file.tqnud06,
        tqnud07 LIKE tqn_file.tqnud07,
        tqnud08 LIKE tqn_file.tqnud08,
        tqnud09 LIKE tqn_file.tqnud09,
        tqnud10 LIKE tqn_file.tqnud10,
        tqnud11 LIKE tqn_file.tqnud11,
        tqnud12 LIKE tqn_file.tqnud12,
        tqnud13 LIKE tqn_file.tqnud13,
        tqnud14 LIKE tqn_file.tqnud14,
        tqnud15 LIKE tqn_file.tqnud15
                    END RECORD,
    g_tqn_o         RECORD                 #程式變數 (舊值)
        tqn02       LIKE tqn_file.tqn02,   #項次
        tqn03       LIKE tqn_file.tqn03,   #產品編號
        ima02       LIKE ima_file.ima02,   #產品名稱
        tqn04       LIKE tqn_file.tqn04,   #定價單位
        ima908      LIKE ima_file.ima908,  #計價單位
        tqn08       LIKE tqn_file.tqn08,   #原價格                     #NO.FUN-870100 ADD                                           
        tqn09       LIKE tqn_file.tqn09,   #折扣率%                    #NO.FUN-870100 ADD                                           
        tqn05       LIKE tqn_file.tqn05,   #未稅單價                                                                                
        tqn10       LIKE tqn_file.tqn10,   #供貨商分攤比率%            #NO.FUN-870100 ADD 
        tqn06       LIKE tqn_file.tqn06,   #生效日期
        tqn07       LIKE tqn_file.tqn07    #失效日期
       ,tqnud01 LIKE tqn_file.tqnud01,
        tqnud02 LIKE tqn_file.tqnud02,
        tqnud03 LIKE tqn_file.tqnud03,
        tqnud04 LIKE tqn_file.tqnud04,
        tqnud05 LIKE tqn_file.tqnud05,
        tqnud06 LIKE tqn_file.tqnud06,
        tqnud07 LIKE tqn_file.tqnud07,
        tqnud08 LIKE tqn_file.tqnud08,
        tqnud09 LIKE tqn_file.tqnud09,
        tqnud10 LIKE tqn_file.tqnud10,
        tqnud11 LIKE tqn_file.tqnud11,
        tqnud12 LIKE tqn_file.tqnud12,
        tqnud13 LIKE tqn_file.tqnud13,
        tqnud14 LIKE tqn_file.tqnud14,
        tqnud15 LIKE tqn_file.tqnud15
                    END RECORD,
    g_argv1         LIKE tqn_file.tqn01,        # 詢價單號
    g_argv2         STRING,   #TQC-630069
    g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_sql    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數             #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680120 SMALLINT
DEFINE g_argv3      LIKE type_file.chr1   #NO.FUN-84 0033
 
DEFINE  g_tqm_l       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
          tqm01       LIKE tqm_file.tqm01,
          tqm02       LIKE tqm_file.tqm02,
          tqm03       LIKE tqm_file.tqm03,
          tqm05       LIKE tqm_file.tqm05,
          tqm06       LIKE tqm_file.tqm06,
          tqm04       LIKE tqm_file.tqm04,
          tqmacti     LIKE tqm_file.tqmacti,
          tqm07       LIKE tqm_file.tqm07
                      END RECORD
DEFINE  g_tqmx        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
          sel         LIKE type_file.chr1,
          tqm01       LIKE tqm_file.tqm01
                      END RECORD
DEFINE g_gev04        LIKE gev_file.gev04
DEFINE l_ac1          LIKE type_file.num10
DEFINE g_rec_b1       LIKE type_file.num10
DEFINE g_bp_flag      LIKE type_file.chr10
DEFINE g_flag2        LIKE type_file.chr1
DEFINE g_gew06        LIKE gew_file.gew06
DEFINE g_gew07        LIKE gew_file.gew07
 
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5        #No.FUN-680120 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_chr2          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_chr3          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680120 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   t_azi03         LIKE azi_file.azi03          #No.MOD-820125
DEFINE   g_str           STRING 
DEFINE   l_table         STRING 
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
  LET g_argv1 = ARG_VAL(1)   #TQC-630069
  LET g_argv2 = ARG_VAL(2)   #TQC-630069
  LET g_argv3 = ARG_VAL(3)   #NO.FUN-84 0033 add
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)   #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
     LET g_sql = "tqm01.tqm_file.tqm01,",
                 "tqm02.tqm_file.tqm02,",
                 "tqm05.tqm_file.tqm05,",
                 "azi02.azi_file.azi02,",
                 "tqm06.tqm_file.tqm06,",
                 "tqm04.tqm_file.tqm04,",
                 "tqn03.tqn_file.tqn03,", 
                 "ima02.ima_file.ima02,",
                 "tqn04.tqn_file.tqn04,",
                 "tqn08.tqn_file.tqn08,",
                 "tqn09.tqn_file.tqn09,",
                 "tqn05.tqn_file.tqn05,",
                 "tqn10.tqn_file.tqn10,",
                 "tqn06.tqn_file.tqn06,",
                 "tqn07.tqn_file.tqn07"
    LET l_table=cl_prt_temptable("atmi227",g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
    CALL cl_err("insert_prep:",status,1)
   END IF
   
    LET g_forupd_sql = " SELECT * FROM tqm_file WHERE tqm01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i227_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW i227_w AT p_row,p_col
        WITH FORM "atm/42f/atmi227"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    IF g_sma.sma116=0 THEN
       CALL cl_set_comp_visible("ima908",FALSE)
    END IF
 
    #g_azw.azw04用來判斷是否使用零售系統
    IF g_azw.azw04 <> '2' THEN
       CALL cl_set_comp_visible("tqn08",FALSE)
       CALL cl_set_comp_visible("tqn09",FALSE)
       CALL cl_set_comp_visible("tqn10",FALSE)
    END IF
 
 
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i227_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i227_a()
             END IF
          OTHERWISE   #TQC-660071
             CALL i227_q()   #TQC-660071
       END CASE
    END IF
 
 
    CALL i227_menu()
    CLOSE WINDOW i227_w                              #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出使間) #No.FUN-690124  #No.FUN-6B0014
END MAIN
 
#QBE 查詢資料
FUNCTION i227_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_tqn.clear()
 
  IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
     LET g_wc = " tqm01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
     CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tqm.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
                       tqm01,tqm02,tqm03,tqm07,tqm05,tqm06,tqm04,  #No.FUN-7C0010
                       tqmuser,tqmgrup,tqmoriu,tqmorig,tqmmodu,tqmdate,tqmacti,  #TQC-A10097 add tqmoriu,tqmorig
                       tqmud01,tqmud02,tqmud03,tqmud04,tqmud05,
                       tqmud06,tqmud07,tqmud08,tqmud09,tqmud10,
                       tqmud11,tqmud12,tqmud13,tqmud14,tqmud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
     ON ACTION controlp
           CASE
               WHEN INFIELD(tqm03) #適用渠道
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="19"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqm03
                 NEXT FIELD tqm03
               WHEN INFIELD(tqm05)    #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqm05
                 NEXT FIELD tqm05
               WHEN INFIELD(tqm07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_azp"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqm07
                  NEXT FIELD tqm07
              OTHERWISE EXIT CASE
            END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
 
     CONSTRUCT g_wc2 ON tqn02,tqn03,tqn04,                      #螢幕上取單身條件
                        tqn08,tqn09,tqn05,tqn10,tqn06,tqn07        #No.FUN-870113 ADD tqn08,tqn09,tqn10
           ,tqnud01,tqnud02,tqnud03,tqnud04,tqnud05
           ,tqnud06,tqnud07,tqnud08,tqnud09,tqnud10
           ,tqnud11,tqnud12,tqnud13,tqnud14,tqnud15
            FROM s_tqn[1].tqn02,s_tqn[1].tqn03,s_tqn[1].tqn04,s_tqn[1].tqn08,s_tqn[1].tqn09,   #No.FUN-870100 ADD tqn08,tqn09
                 s_tqn[1].tqn05,s_tqn[1].tqn10,s_tqn[1].tqn06,s_tqn[1].tqn07                   #No.FUN-870100 ADD tqn10
                ,s_tqn[1].tqnud01,s_tqn[1].tqnud02,s_tqn[1].tqnud03,s_tqn[1].tqnud04,s_tqn[1].tqnud05
                ,s_tqn[1].tqnud06,s_tqn[1].tqnud07,s_tqn[1].tqnud08,s_tqn[1].tqnud09,s_tqn[1].tqnud10
                ,s_tqn[1].tqnud11,s_tqn[1].tqnud12,s_tqn[1].tqnud13,s_tqn[1].tqnud14,s_tqn[1].tqnud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
            CASE
               WHEN INFIELD(tqn03) #產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state ="c"
#                LET g_qryparam.form ="q_ima01"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO tqn03
                 NEXT FIELD tqn03
               WHEN INFIELD(tqn04) #定價單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqn04
                 NEXT FIELD tqn04
               OTHERWISE EXIT CASE
            END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
  END IF
  #資料權限的檢查
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqmuser', 'tqmgrup')
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT tqm01 FROM tqm_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY tqm01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE tqm_file.tqm01 ",
                   "  FROM tqm_file,tqn_file ",
                   " WHERE tqm01 = tqn01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY tqm01"
    END IF
 
    PREPARE i227_prepare FROM g_sql
    DECLARE i227_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i227_prepare
 
    DECLARE i227_list_cur CURSOR FOR i227_prepare
 
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM tqm_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT tqm01) ",
                  "FROM tqm_file,tqn_file ",
                  "WHERE tqn01=tqm01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i227_precount FROM g_sql
    DECLARE i227_count CURSOR FOR i227_precount
END FUNCTION
 
FUNCTION i227_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(100)
 
   WHILE TRUE
      IF cl_null(g_bp_flag) OR g_bp_flag <> 'list' THEN
         CALL i227_bp("G")
      ELSE
         CALL i227_bp1("G")
      END IF
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i227_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i227_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i227_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i227_u()
            END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i227_out()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i227_copy()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i227_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i227_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "related_document"
            IF cl_chk_act_auth()  THEN
               IF g_tqm.tqm01 IS NOT NULL THEN
                 LET g_doc.column1 = "tqm01"
                 LET g_doc.value1 = g_tqm.tqm01
                 CALL cl_doc()
               END IF
            END IF
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_tqn),'','')
             END IF
 
         WHEN "create_b" #創建單身
            IF cl_chk_act_auth() THEN
               CALL i227_cp()
            END IF
 
         WHEN "delete_b" #刪除單身
            IF cl_chk_act_auth() THEN
               CALL i227_dp()
            END IF
 
 
         WHEN "confirm" #審核
            IF cl_chk_act_auth() THEN
               CALL i227_confirm()
            END IF
 
         WHEN "unconfirm" #取消審核
            IF cl_chk_act_auth() THEN
               CALL i227_unconfirm()
            END IF
 
         WHEN "hang"     #挂起
            IF cl_chk_act_auth() THEN
               CALL i227_hang()
            END IF
 
         WHEN "unhang"     #挂起
            IF cl_chk_act_auth() THEN
               CALL i227_unhang()
            END IF
 
         WHEN "price_adjust"     #調價
            IF cl_chk_act_auth() THEN
               CALL i227_ap()
            END IF
 
         WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL i227_carry()
            END IF
 
         WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL i227_download()
            END IF
 
         WHEN "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_tqm.tqm01) THEN  #No.FUN-830090
                  IF NOT cl_null(g_tqm.tqm07) THEN
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '7' AND gev02 = g_tqm.tqm07
                  ELSE      #歷史資料,即沒有tqm07的值
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '7' AND gev02 = g_plant
                  END IF
                  IF NOT cl_null(g_gev04) THEN
                     LET l_cmd='aooq604 "',g_gev04,'" "7" "',g_prog,'" "',g_tqm.tqm01,'"'
                     CALL cl_cmdrun(l_cmd)
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i227_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_tqn.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_tqm.* LIKE tqm_file.*             #DEFAULT 設置
    LET g_tqm01_t = NULL
    LET g_tqm_t.* = g_tqm.*
    LET g_tqm_o.* = g_tqm.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tqm.tqm04='0'                #狀態碼
        LET g_tqm.tqm06='1'                #MOD-AA0053 add
        LET g_tqm.tqm07=g_plant            #No.FUN-7C0010
        LET g_tqm.tqmuser=g_user
        LET g_tqm.tqmgrup=g_grup
        LET g_tqm.tqmoriu=g_user          #TQC-A30034 ADD
        LET g_tqm.tqmorig=g_grup          #TQC-A30034 ADD 
        LET g_tqm.tqmdate=g_today
        LET g_tqm.tqmacti='Y'              #資料有效
 
        BEGIN WORK
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_tqm.tqm01 = g_argv1
        END IF
 
        CALL i227_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_tqm.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_tqm.tqm01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK
        LET g_tqm.tqmoriu = g_user      #No.FUN-980030 10/01/04
        LET g_tqm.tqmorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO tqm_file VALUES (g_tqm.*)
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
            CALL cl_err3("ins","tqm_file",g_tqm.tqm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        ELSE
        COMMIT WORK
        CALL cl_flow_notify(g_tqm.tqm01,'I')
        END IF
        SELECT tqm01 INTO g_tqm.tqm01 FROM tqm_file
            WHERE tqm01 = g_tqm.tqm01
        LET g_tqm01_t = g_tqm.tqm01        #保留舊值
        LET g_tqm_t.* = g_tqm.*
        LET g_tqm_o.* = g_tqm.*
        LET g_rec_b=0
        CALL i227_cp()
        CALL i227_b_fill('1=1')                 #單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i227_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_tqm.tqm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_tqm.* FROM tqm_file WHERE tqm01=g_tqm.tqm01
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
#判斷有效性
    IF g_tqm.tqmacti='Y' THEN            #若資料還有效
       IF g_tqm.tqm04 != '0' THEN
          CALL cl_err(g_tqm.tqm01,'atm-226',0)  #不是可處理的狀態
          RETURN
       END IF
    ELSE                                 #資料已無效
       CALL cl_err(g_tqm.tqm01,'mfg1000',0)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tqm01_t = g_tqm.tqm01
    BEGIN WORK
 
    OPEN i227_cl USING g_tqm.tqm01
    IF STATUS THEN
       CALL cl_err("OPEN i227_cl:", STATUS, 1)
       CLOSE i227_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i227_cl INTO g_tqm.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i227_cl
        RETURN
    END IF
    CALL i227_show()
    WHILE TRUE
        LET g_tqm01_t = g_tqm.tqm01
        LET g_tqm_o.* = g_tqm.*
        LET g_tqm.tqmmodu=g_user
        LET g_tqm.tqmdate=g_today
        CALL i227_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tqm.*=g_tqm_t.*
            CALL i227_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_tqm.tqm01 != g_tqm01_t THEN            # 更改定價編號
            UPDATE tqn_file SET tqn01 = g_tqm.tqm01
                WHERE tqn01 = g_tqm01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tqn_file",g_tqm01_t,"",SQLCA.sqlcode,"","tqn",1)  #No.FUN-660104
                CONTINUE WHILE
            END IF
        END IF
        UPDATE tqm_file SET tqm_file.* = g_tqm.*
            WHERE tqm01 = g_tqm01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tqm_file",g_tqm.tqm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
 
        #price list refill
        CALL i227_list_fill()
 
        EXIT WHILE
    END WHILE
    CLOSE i227_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tqm.tqm01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION i227_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n,l_i   LIKE type_file.num5,         #No.FUN-680120 SMALLINT
    p_cmd           LIKE type_file.chr1    #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
DEFINE g_chr  LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr2 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr3 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
        g_tqm.tqm01,g_tqm.tqm02,g_tqm.tqm03,g_tqm.tqm05,
        g_tqm.tqm06,g_tqm.tqm04,g_tqm.tqm07,      #No.FUN-7C0010
        g_tqm.tqmuser,g_tqm.tqmgrup,g_tqm.tqmmodu,g_tqm.tqmdate,g_tqm.tqmacti
       ,g_tqm.tqmud01,g_tqm.tqmud02,g_tqm.tqmud03,g_tqm.tqmud04,
       g_tqm.tqmud05,g_tqm.tqmud06,g_tqm.tqmud07,g_tqm.tqmud08,
       g_tqm.tqmud09,g_tqm.tqmud10,g_tqm.tqmud11,g_tqm.tqmud12,
       g_tqm.tqmud13,g_tqm.tqmud14,g_tqm.tqmud15 
      ,g_tqm.tqmorig,g_tqm.tqmoriu                             #TQC-A30034 ADD
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME
        g_tqm.tqm01,g_tqm.tqm02,g_tqm.tqm03,g_tqm.tqm05,
        g_tqm.tqm06,g_tqm.tqm04,
        g_tqm.tqmuser,g_tqm.tqmgrup,g_tqm.tqmmodu,g_tqm.tqmdate,g_tqm.tqmacti
       ,g_tqm.tqmud01,g_tqm.tqmud02,g_tqm.tqmud03,g_tqm.tqmud04,
       g_tqm.tqmud05,g_tqm.tqmud06,g_tqm.tqmud07,g_tqm.tqmud08,
       g_tqm.tqmud09,g_tqm.tqmud10,g_tqm.tqmud11,g_tqm.tqmud12,
       g_tqm.tqmud13,g_tqm.tqmud14,g_tqm.tqmud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i227_set_entry(p_cmd)
            CALL i227_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
 
        AFTER FIELD tqm01
            IF NOT cl_null(g_tqm.tqm01) AND ((g_tqm.tqm01 != g_tqm_t.tqm01) OR g_tqm_t.tqm01 IS NULL)THEN
               SELECT count(*) INTO l_n FROM tqm_file
                WHERE tqm01 = g_tqm.tqm01
               IF l_n > 0 THEN
                  CALL cl_err(g_tqm.tqm01,-239,1)
                  NEXT FIELD tqm01
               END IF
               #check tqm01 value by aooi601 setting
               CALL s_field_chk(g_tqm.tqm01,'7',g_plant,'tqm01') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(g_tqm.tqm01,'aoo-043',1)
                  LET g_tqm.tqm01 = g_tqm_o.tqm01
                  DISPLAY BY NAME g_tqm.tqm01
                  NEXT FIELD tqm01
               END IF
            END IF
 
        AFTER FIELD tqm03     #定價編號
            IF NOT cl_null(g_tqm.tqm03) THEN
                CALL i227_tqm03('d')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_tqm.tqm03,g_errno,1)
                   LET g_tqm.tqm03 = g_tqm_o.tqm03
                   DISPLAY BY NAME g_tqm.tqm03
                   NEXT FIELD tqm03
                END IF
            END IF
            LET g_tqm_o.tqm03 = g_tqm.tqm03
 
       AFTER FIELD tqm05   #幣別
            IF NOT cl_null(g_tqm.tqm05) THEN
                  CALL i227_tqm05('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tqm.tqm05,g_errno,1)
                     LET g_tqm.tqm05 = g_tqm_o.tqm05
                     DISPLAY BY NAME g_tqm.tqm05
                     NEXT FIELD tqm05
                  END IF
            END IF
            LET g_tqm_o.tqm05 = g_tqm.tqm05
 
        AFTER FIELD tqm06
            IF NOT cl_null(g_tqm.tqm06) THEN
               #check tqm06 value by aooi601 setting
               CALL s_field_chk(g_tqm.tqm06,'7',g_plant,'tqm06') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(g_tqm.tqm06,'aoo-043',1)
                  LET g_tqm.tqm06 = g_tqm_o.tqm06
                  DISPLAY BY NAME g_tqm.tqm06
                  NEXT FIELD tqm06
               END IF
            END IF
 
        AFTER FIELD tqmud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqmud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tqm03) #適用渠道
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="19"
                 LET g_qryparam.default1 = g_tqm.tqm03
                 CALL cl_create_qry() RETURNING g_tqm.tqm03
                 DISPLAY BY NAME g_tqm.tqm03
                 NEXT FIELD tqm03
 
               WHEN INFIELD(tqm05)      #代理商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_tqm.tqm05
                 CALL cl_create_qry() RETURNING g_tqm.tqm05
                 DISPLAY BY NAME g_tqm.tqm05
                 NEXT FIELD tqm05
              OTHERWISE EXIT CASE
            END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
 
    END INPUT
END FUNCTION
 
FUNCTION i227_tqm03(p_cmd)  #
    DEFINE l_tqa02   LIKE tqa_file.tqa02,
           l_tqaacti LIKE tqa_file.tqaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
      FROM tqa_file WHERE tqa01 = g_tqm.tqm03
                      AND tqa03='19'
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-222'
         WHEN l_tqaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_tqa02 TO  FORMONLY.tqa02
    END IF
END FUNCTION
 
FUNCTION i227_tqm05(p_cmd)  #
    DEFINE l_azi02   LIKE azi_file.azi02,
           l_aziacti LIKE azi_file.aziacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT azi02,aziacti INTO l_azi02,l_aziacti
      FROM azi_file
     WHERE azi01 = g_tqm.tqm05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-223'
                                   LET l_azi02 = NULL
         WHEN l_aziacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_azi02 TO  FORMONLY.azi02
    END IF
END FUNCTION
 
FUNCTION i227_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("tqm01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i227_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tqm01",FALSE)
    END IF
END FUNCTION
 
 
#Query 查詢
FUNCTION i227_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tqm.* TO NULL             #No.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tqn.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i227_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_tqm.* TO NULL
        RETURN
    END IF
    OPEN i227_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tqm.* TO NULL
    ELSE
        OPEN i227_count
        FETCH i227_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i227_list_fill()  #No.FUN-7C0010
        LET g_bp_flag = NULL   #CHI-880031 
        CALL i227_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
FUNCTION i227_list_fill()
  DEFINE l_tqm01         LIKE tqm_file.tqm01
  DEFINE l_i             LIKE type_file.num10
 
    CALL g_tqm_l.clear()
    LET l_i = 1
    FOREACH i227_list_cur INTO l_tqm01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach list_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT tqm01,tqm02,tqm03,tqm05,tqm06,tqm04,tqmacti,tqm07
         INTO g_tqm_l[l_i].*
         FROM tqm_file
        WHERE tqm01=l_tqm01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_tqm_l TO s_tqm_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
          
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION controlg      
             CALL cl_cmdask()     
          
          ON ACTION help          
             CALL cl_show_help()  
 
    END DISPLAY
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i227_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i227_cs INTO g_tqm.tqm01
        WHEN 'P' FETCH PREVIOUS i227_cs INTO g_tqm.tqm01
        WHEN 'F' FETCH FIRST    i227_cs INTO g_tqm.tqm01
        WHEN 'L' FETCH LAST     i227_cs INTO g_tqm.tqm01
        WHEN '/'
 
      IF (NOT mi_no_ask) THEN
        CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
        LET INT_FLAG = 0  ######tqm for prompt bug
        PROMPT g_msg CLIPPED,': ' FOR g_jump
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
        END PROMPT
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           EXIT CASE
        END IF
      END IF
      FETCH ABSOLUTE g_jump i227_cs INTO g_tqm.tqm01
      LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)
        INITIALIZE g_tqm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_tqm.* FROM tqm_file WHERE tqm01 = g_tqm.tqm01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tqm_file",g_tqm.tqm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        INITIALIZE g_tqm.* TO NULL
        RETURN
    END IF
 
    CALL i227_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i227_show()
DEFINE g_chr  LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr2 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr3 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    LET g_tqm_t.* = g_tqm.*                #保存單頭舊值
    LET g_tqm_o.* = g_tqm.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_tqm.tqm01,g_tqm.tqm02,g_tqm.tqm03,g_tqm.tqm05,g_tqm.tqm06,
        g_tqm.tqm04,g_tqm.tqm07,     #No.FUN-7C0010
        g_tqm.tqmuser,g_tqm.tqmgrup,g_tqm.tqmmodu,g_tqm.tqmdate,g_tqm.tqmacti
       ,g_tqm.tqmud01,g_tqm.tqmud02,g_tqm.tqmud03,g_tqm.tqmud04,
        g_tqm.tqmud05,g_tqm.tqmud06,g_tqm.tqmud07,g_tqm.tqmud08,
        g_tqm.tqmud09,g_tqm.tqmud10,g_tqm.tqmud11,g_tqm.tqmud12,
        g_tqm.tqmud13,g_tqm.tqmud14,g_tqm.tqmud15 
       ,g_tqm.tqmoriu,g_tqm.tqmorig        #TQC-A30034 ADD
 
    CALL i227_tqm03('d')
    CALL i227_tqm05('d')
    CALL i227_b_fill(g_wc2)                 #單身
    LET g_chr = 'N'
    LET g_chr2= 'N'
    LET g_chr3= 'N'
    CASE g_tqm.tqm04
       WHEN '1' LET g_chr = 'Y'
       WHEN '2' LET g_chr2= 'Y'
    END CASE
    CALL cl_set_field_pic1(g_chr,"","","","",g_tqm.tqmacti,"",g_chr2)
 
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i227_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_tqm.tqm01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i227_cl USING g_tqm.tqm01
    IF STATUS THEN
       CALL cl_err("OPEN i227_cl:", STATUS, 1)
       CLOSE i227_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i227_cl INTO g_tqm.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    IF g_tqm.tqm04 !='0' THEN
       CALL cl_err('','art-458',0)
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL i227_show()
    IF cl_exp(0,0,g_tqm.tqmacti) THEN                   #審核一下
        LET g_chr=g_tqm.tqmacti
        IF g_tqm.tqmacti='Y' THEN
            LET g_tqm.tqmacti='N'
        ELSE
            LET g_tqm.tqmacti='Y'
        END IF
        UPDATE tqm_file                    #更改有效碼
            SET tqmacti=g_tqm.tqmacti
            WHERE tqm01=g_tqm.tqm01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tqm_file",g_tqm.tqm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            LET g_tqm.tqmacti=g_chr
        END IF
        DISPLAY g_tqm.tqmacti TO tqmacti
        DISPLAY g_tqm.tqm04 TO tqm04
 
        #price list refill
        CALL i227_list_fill()
 
    END IF
    CLOSE i227_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tqm.tqm01,'V')
    LET g_chr = 'N'
    LET g_chr2= 'N'
    LET g_chr3= 'N'
    CASE g_tqm.tqm04
       WHEN '1' LET g_chr = 'Y'
       WHEN '2' LET g_chr2= 'Y'
    END CASE
    CALL cl_set_field_pic1(g_chr,"","","","",g_tqm.tqmacti,"",g_chr2)
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION i227_r()
 DEFINE l_i LIKE type_file.num5          #No.FUN-680120 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    IF g_tqm.tqm01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'r') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-044',1)
       RETURN
    END IF
    IF g_tqm.tqmacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tqm.tqm01,'mfg1000',0)
        RETURN
    ELSE
       IF g_tqm.tqm04 != '0' THEN
          CALL cl_err(g_tqm.tqm01,'atm-239',0)  #不是可處理的狀態
          RETURN
       END IF
    END IF
    SELECT COUNT(*) INTO l_i
      FROM tqo_file
     WHERE tqo02 = g_tqm.tqm01
    IF l_i <> 0 THEN
       CALL cl_err(g_tqm.tqm01,'atm-513',1)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i227_cl USING g_tqm.tqm01
    IF STATUS THEN
       CALL cl_err("OPEN i227_cl:", STATUS, 1)
       CLOSE i227_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i227_cl INTO g_tqm.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i227_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tqm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tqm.tqm01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM tqm_file WHERE tqm01 = g_tqm.tqm01
            DELETE FROM tqn_file WHERE tqn01 = g_tqm.tqm01
 
            CLEAR FORM
            CALL g_tqn.clear()
 
         OPEN i227_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i227_cs
            CLOSE i227_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i227_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i227_cs
            CLOSE i227_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i227_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i227_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i227_fetch('/')
         END IF
         #price list refill
         CALL i227_list_fill()
    END IF
    CLOSE i227_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tqm.tqm01,'D')
END FUNCTION
 
#單身
FUNCTION i227_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
    l_sql           STRING ,    #NO.FUN-910082
    l_tqn06         LIKE tqn_file.tqn06,
    l_tqn07         LIKE tqn_file.tqn07,
    l_tqn04         LIKE tqn_file.tqn04,
    l_tqn08         LIKE tqn_file.tqn08,                                  #No.FUN-870100 ADD
    l_tqn09         LIKE tqn_file.tqn09,                                  #No.FUN-870100 ADD
    l_tqn10         LIKE tqn_file.tqn10,                                  #No.FUN-870100 ADD
    l_rtz05         LIKE rtz_file.rtz05,                                  #No.FUN-870100 ADD
    l_rth04         LIKE rth_file.rth04,                                  #No.FUN-870100 ADD
    l_rtg05         LIKE rtg_file.rtg05,                                  #No.FUN-870100
    l_rtg08         LIKE rtg_file.rtg08,                                  #No.FUN-870100
    l_ima25         LIKE ima_file.ima25,                                  #No.FUN-870100 ADD
    l_ima31         LIKE ima_file.ima31
 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_tqm.tqm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqm.* FROM tqm_file WHERE tqm01=g_tqm.tqm01
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
    IF g_tqm.tqmacti='Y' THEN            #若資料還有效
       IF g_tqm.tqm04 != '0' THEN
          CALL cl_err(g_tqm.tqm01,'atm-226',0)  #不是可處理的狀態
          RETURN
       END IF
    ELSE                                 #資料已無效
       CALL cl_err(g_tqm.tqm01,'mfg1000',0)
       RETURN
    END IF
 
    SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = g_tqm.tqm05
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT tqn02,tqn03,'',tqn04,'',tqn08,tqn09,tqn05,tqn10,tqn06,tqn07 ", #No.FUN-870100 ADD tqn08,tqn09,tqn10
                       "   FROM tqn_file ",
                       "   WHERE tqn01=?  AND tqn02=? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i227_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_tqn.clear() END IF
 
        INPUT ARRAY g_tqn WITHOUT DEFAULTS FROM s_tqn.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
       END IF
 
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            CALL cl_set_comp_required("tqn07",FALSE)  #0210
            BEGIN WORK
 
            OPEN i227_cl USING g_tqm.tqm01
            IF STATUS THEN
               CALL cl_err("OPEN i227_cl:", STATUS, 1)
               CLOSE i227_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i227_cl INTO g_tqm.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i227_cl
              RETURN
            END IF
 
            # 修改狀態時才作備份舊值的動作
            IF g_rec_b >= l_ac THEN
                LET p_cmd="u"
                LET g_tqn_t.* = g_tqn[l_ac].*  #BACKUP
                LET g_tqn_o.* = g_tqn[l_ac].*  #BACKUP
 
                OPEN i227_bcl USING g_tqm.tqm01,g_tqn_t.tqn02
                IF STATUS THEN
                   CALL cl_err("OPEN i227_bcl:", STATUS, 1)
                   CLOSE i227_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i227_bcl INTO g_tqn[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_tqn_t.tqn02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
 
                   SELECT ima02 INTO g_tqn[l_ac].ima02
                     FROM ima_file
                    WHERE ima01=g_tqn[l_ac].tqn03
 
                   SELECT ima908 INTO g_tqn[l_ac].ima908
                     FROM ima_file
                    WHERE ima01=g_tqn[l_ac].tqn03
                END IF
            END IF
 
        BEFORE INSERT
            LET p_cmd="a"
            LET l_n = ARR_COUNT()
            INITIALIZE g_tqn[l_ac].* TO NULL       #900423
            LET g_tqn_t.* = g_tqn[l_ac].*          #新輸入資料
            LET g_tqn_o.* = g_tqn[l_ac].*          #新輸入資料
            LET g_tqn[l_ac].tqn09 = 100            #No.FUN-870100 ADD
            NEXT FIELD tqn02
 
        BEFORE FIELD tqn02                        #default 序號
            IF g_tqn[l_ac].tqn02 IS NULL OR g_tqn[l_ac].tqn02 = 0 THEN
                SELECT max(tqn02)+1
                   INTO g_tqn[l_ac].tqn02
                   FROM tqn_file
                   WHERE tqn01 = g_tqm.tqm01
                IF g_tqn[l_ac].tqn02 IS NULL THEN
                    LET g_tqn[l_ac].tqn02 = 1
                END IF
            END IF
 
        AFTER FIELD tqn02                        #check 序號是否重複
            IF NOT g_tqn[l_ac].tqn02 IS NULL THEN
               IF g_tqn[l_ac].tqn02 != g_tqn_t.tqn02 OR
                  g_tqn_t.tqn02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM tqn_file
                       WHERE tqn01 = g_tqm.tqm01 AND
                             tqn02 = g_tqn[l_ac].tqn02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_tqn[l_ac].tqn02 = g_tqn_t.tqn02
                       NEXT FIELD tqn02
                   END IF
               END IF
            END IF
 
        AFTER FIELD tqn03
    IF g_azw.azw04 <> '2' THEN              #No.FUN-870100 零售行業別判斷
            IF cl_null(g_tqn[l_ac].tqn03) THEN
               CALL cl_err('','aim-927',0)
               NEXT FIELD tqn03
            END IF
            IF NOT cl_null(g_tqn[l_ac].tqn03) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_tqn[l_ac].tqn03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tqn[l_ac].tqn03= g_tqn_t.tqn03
                  NEXT FIELD tqn03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
              CALL i227_tqn03('d')
              IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_tqn[l_ac].tqn03,g_errno,1)
                LET g_tqn[l_ac].tqn03 = g_tqn_t.tqn03
                DISPLAY BY NAME g_tqn[l_ac].tqn03
                NEXT FIELD tqn03
              END IF
              SELECT count(*) INTO l_n
                FROM tqn_file
               WHERE tqn01 = g_tqm.tqm01
                 AND tqn02 = g_tqn[l_ac].tqn02
              IF l_n =0 THEN
                 SELECT ima31 INTO l_ima31
                   FROM ima_file
                  WHERE ima01=g_tqn[l_ac].tqn03
                 LET g_tqn[l_ac].tqn04  = l_ima31
              ELSE
                 SELECT tqn04 INTO l_tqn04
                   FROM tqn_file
                  WHERE tqn01 = g_tqm.tqm01
                    AND tqn02 = g_tqn[l_ac].tqn02
                 LET g_tqn[l_ac].tqn04  = l_tqn04
              END IF
              DISPLAY g_tqn[l_ac].tqn04 TO tqn04
            END IF
    ELSE
            IF cl_null(g_tqn[l_ac].tqn03) THEN
               CALL cl_err('','aim-927',0)
               NEXT FIELD tqn03
            END IF
            IF NOT cl_null(g_tqn[l_ac].tqn03) THEN
#TQC-C20152 add begin ----
               IF NOT s_chk_item_no(g_tqn[l_ac].tqn03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tqn[l_ac].tqn03= g_tqn_t.tqn03
                  NEXT FIELD tqn03
               END IF
#TQC-C20152 add end -----
               CALL i227_tqn03('d')
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tqn[l_ac].tqn03,g_errno,1)
                 LET g_tqn[l_ac].tqn03 = g_tqn_t.tqn03
                 DISPLAY BY NAME g_tqn[l_ac].tqn03
                 NEXT FIELD tqn03
               END IF
              SELECT count(*) INTO l_n
                FROM tqn_file
               WHERE tqn01 = g_tqm.tqm01
                 AND tqn02 = g_tqn[l_ac].tqn02
              IF l_n =0 THEN
                 SELECT ima31 INTO l_ima31
                   FROM ima_file
                  WHERE ima01=g_tqn[l_ac].tqn03
                 LET g_tqn[l_ac].tqn04  = l_ima31
              ELSE
                 SELECT tqn04 INTO l_tqn04
                   FROM tqn_file
                  WHERE tqn01 = g_tqm.tqm01
                    AND tqn02 = g_tqn[l_ac].tqn02
                 LET g_tqn[l_ac].tqn04  = l_tqn04
              END IF  
              DISPLAY g_tqn[l_ac].tqn04 TO tqn04
            END IF
                 IF NOT cl_null(g_tqn[l_ac].tqn03) AND NOT cl_null(g_tqn[l_ac].tqn04) THEN
                    SELECT rtz05 INTO l_rtz05 FROM rtz_file WHERE rtz01=g_plant
                    IF NOT cl_null(l_rtz05) THEN 
                       SELECT rtg05,rtg08 INTO l_rtg05,l_rtg08 
                         FROM rtg_file,rtf_file 
                        WHERE rtg01 = l_rtz05 
                          AND rtg01 = rtf01 
                          AND rtg03 = g_tqn[l_ac].tqn03
                          AND rtg04 = g_tqn[l_ac].tqn04
                          AND rtfconf='Y'
                          AND rtg09='Y'
                       IF l_rtg08='Y' THEN
                          SELECT rth04 INTO l_rth04
                            FROM rth_file
                           WHERE rth01  = g_tqn[l_ac].tqn03
                             AND rth02  = g_tqn[l_ac].tqn04
                             AND rthplant = g_plant
                             AND rthacti = 'Y'
                          LET g_tqn[l_ac].tqn08=l_rth04
                       ELSE
                          LET g_tqn[l_ac].tqn08=l_rtg05
                       END IF
                    END IF
                    IF cl_null(g_tqn[l_ac].tqn08) THEN
                       LET  g_tqn[l_ac].tqn08 = 0
                       DISPLAY BY NAME g_tqn[l_ac].tqn08
                    END IF
                 END IF
    END IF
 
 
        AFTER FIELD tqn04
    IF g_azw.azw04 <> '2' THEN              #No.FUN-870100
            IF NOT cl_null(g_tqn[l_ac].tqn04) THEN
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_tqn[l_ac].tqn04 != g_tqn_o.tqn04) THEN
                 SELECT count(*) INTO l_n FROM gfe_file
                  WHERE gfe01 = g_tqn[l_ac].tqn04
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                     CALL cl_err('','mfg0019',0)
                     LET g_tqn[l_ac].tqn04 = g_tqn_t.tqn04
                     NEXT FIELD tqn04
                 END IF
              END IF
            ELSE
              CALL cl_err('tqn04','aim-927',0)
              NEXT FIELD tqn04
            END IF
    ELSE
            IF NOT cl_null(g_tqn[l_ac].tqn04) THEN
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_tqn[l_ac].tqn04 != g_tqn_o.tqn04) THEN
                 SELECT count(*) INTO l_n FROM gfe_file
                  WHERE gfe01 = g_tqn[l_ac].tqn04
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err('','mfg0019',0)
                    LET g_tqn[l_ac].tqn04 = g_tqn_t.tqn04
                    NEXT FIELD tqn04
                 ELSE
                    IF NOT cl_null(g_tqn[l_ac].tqn03) THEN
                    SELECT rtz05 INTO l_rtz05 FROM rtz_file WHERE rtz01=g_plant                                                     
                    IF NOT cl_null(l_rtz05) THEN   
                       SELECT rtg05,rtg08 INTO l_rtg05,l_rtg08
                         FROM rtg_file,rtf_file
                        WHERE rtg01 = l_rtz05 
                          AND rtg01 = rtf01
                          AND rtg03 = g_tqn[l_ac].tqn03
                          AND rtg04 = g_tqn[l_ac].tqn04
                          AND rtfconf='Y'
                          AND rtg09='Y'
                       IF l_rtg08='Y' THEN
                          SELECT rth04 INTO l_rth04
                            FROM rth_file
                           WHERE rth01  = g_tqn[l_ac].tqn03
                             AND rth02  = g_tqn[l_ac].tqn04
                             AND rthplant = g_plant
                             AND rthacti = 'Y'
                          LET g_tqn[l_ac].tqn08=l_rth04
                       ELSE
                          LET g_tqn[l_ac].tqn08=l_rtg05
                       END IF
                   END IF
                       IF cl_null(g_tqn[l_ac].tqn08) THEN
                          LET  g_tqn[l_ac].tqn08 = 0
                          DISPLAY BY NAME g_tqn[l_ac].tqn08
                       END IF
                       IF p_cmd ='u' AND g_tqn[l_ac].tqn08 !=g_tqn_o.tqn08 THEN
                          IF g_tqn[l_ac].tqn08 != 0 THEN
                             LET g_tqn[l_ac].tqn05 = g_tqn[l_ac].tqn08*g_tqn[l_ac].tqn09/100
                             DISPLAY BY NAME g_tqn[l_ac].tqn05
                          END IF
                       END IF
                    END IF
                 END IF
              END IF
            ELSE
              CALL cl_err('tqn04','aim-927',0)
              NEXT FIELD tqn04
            END IF
    END IF
 
        AFTER FIELD tqn09
            IF cl_null(g_tqn[l_ac].tqn09) THEN
               IF cl_null(g_tqn[l_ac].tqn05) THEN
                  CALL cl_err('','aim-927',0)
                  NEXT FIELD tqn09
               ELSE
                  IF NOT cl_null(g_tqn[l_ac].tqn08) AND g_tqn[l_ac].tqn08 !=0 THEN
                     LET g_tqn[l_ac].tqn09 = g_tqn[l_ac].tqn05*100/g_tqn[l_ac].tqn08
                     DISPLAY BY NAME g_tqn[l_ac].tqn09
                  ELSE
                     LET g_tqn[l_ac].tqn09 = 100
                  END IF
               END IF
            ELSE
               IF g_tqn[l_ac].tqn09 <= 0 THEN
                  CALL cl_err(g_tqn[l_ac].tqn09,'-32406',0)
                  LET g_tqn[l_ac].tqn09 = g_tqn_t.tqn09
                  NEXT FIELD tqn09
               ELSE
                    IF NOT cl_null(g_tqn[l_ac].tqn08) AND g_tqn[l_ac].tqn08 !=0 THEN
                       LET g_tqn[l_ac].tqn05 = g_tqn[l_ac].tqn08*g_tqn[l_ac].tqn09/100
                       DISPLAY BY NAME g_tqn[l_ac].tqn05
                    END IF
               END IF
            END IF
        AFTER FIELD tqn05
    IF g_azw.azw04 <> '2' THEN           #No.FUN-870100   
            IF NOT cl_null(g_tqn[l_ac].tqn05) THEN
               IF p_cmd='a' OR (p_cmd='u' AND 
                                g_tqn[l_ac].tqn05 <> g_tqn_t.tqn05) THEN
                  LET g_tqn[l_ac].tqn05= cl_digcut(g_tqn[l_ac].tqn05,t_azi03)
               END IF
               IF g_tqn[l_ac].tqn05 < 0 THEN
                  CALL cl_err(g_tqn[l_ac].tqn05,'aim-391',0)
                  LET g_tqn[l_ac].tqn05 = g_tqn_t.tqn05
                  NEXT FIELD tqn05
               END IF
            END IF
    ELSE
            IF cl_null(g_tqn[l_ac].tqn05) THEN
               IF cl_null(g_tqn[l_ac].tqn09) THEN
                  CALL cl_err('','aim-927',0)
                  NEXT FIELD tqn05
               ELSE
                  IF NOT cl_null(g_tqn[l_ac].tqn08) AND g_tqn[l_ac].tqn08 !=0 THEN
                     LET g_tqn[l_ac].tqn05 = g_tqn[l_ac].tqn08*g_tqn[l_ac].tqn09/100
                     LET g_tqn[l_ac].tqn05= cl_digcut(g_tqn[l_ac].tqn05,t_azi03)   #MOD-AC0064
                     DISPLAY BY NAME g_tqn[l_ac].tqn05
                  ELSE
                     CALL cl_err('','aim-927',0)
                     NEXT FIELD tqn05
                  END IF
               END IF
            ELSE
               IF g_tqn[l_ac].tqn05 <= 0 THEN                  
                  CALL cl_err(g_tqn[l_ac].tqn05,'aic-208',0)    
                  LET g_tqn[l_ac].tqn05 = g_tqn_t.tqn05
                  NEXT FIELD tqn05
               ELSE    #END IF
                     IF NOT cl_null(g_tqn[l_ac].tqn08) AND g_tqn[l_ac].tqn08 !=0 THEN
                        LET g_tqn[l_ac].tqn09 = g_tqn[l_ac].tqn05*100/g_tqn[l_ac].tqn08
                        DISPLAY BY NAME g_tqn[l_ac].tqn09
                     END IF
               END IF
            END IF
    END IF
 
        AFTER FIELD tqn10
            IF NOT cl_null(g_tqn[l_ac].tqn10) THEN
               IF g_tqn[l_ac].tqn10 <= 0 THEN
                  CALL cl_err(g_tqn[l_ac].tqn10,'atm-114',0)
                  LET g_tqn[l_ac].tqn10 = g_tqn_t.tqn10
                  NEXT FIELD tqn10
               END IF
            END IF
 
        BEFORE FIELD tqn06
            CALL cl_set_comp_required("tqn07",FALSE)  #0210
 
        AFTER FIELD tqn06
           IF NOT cl_null(g_tqn[l_ac].tqn06) THEN
              IF NOT cl_null(g_tqn[l_ac].tqn07) THEN
                 IF g_tqn[l_ac].tqn07<g_tqn[l_ac].tqn06 THEN
                    CALL cl_err(g_tqn[l_ac].tqn06,'mfg3009',0)
                    LET g_tqn[l_ac].tqn06 = g_tqn_t.tqn06
                    NEXT FIELD tqn06
                 END IF
              END IF
            IF g_tqn[l_ac].tqn03 IS NOT NULL AND (NOT cl_null(g_tqn[l_ac].tqn07)) THEN          #No.TQC-7B0118
               CALL i227_check()
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_tqn[l_ac].tqn06 = g_tqn_t.tqn06
                   LET g_tqn[l_ac].tqn07 = g_tqn_t.tqn07
                   NEXT FIELD tqn06
               END IF
            END IF
           END IF
 
        AFTER FIELD tqn07
           IF NOT cl_null(g_tqn[l_ac].tqn07) THEN
              IF NOT cl_null(g_tqn[l_ac].tqn06) THEN
                 IF g_tqn[l_ac].tqn07<g_tqn[l_ac].tqn06 THEN
                    CALL cl_err(g_tqn[l_ac].tqn06,'mfg3009',0)
                    LET g_tqn[l_ac].tqn07 = g_tqn_t.tqn07
                    NEXT FIELD tqn07
                 END IF
              END IF
            IF g_tqn[l_ac].tqn03 IS NOT NULL AND (NOT cl_null(g_tqn[l_ac].tqn06)) THEN          #No.TQC-7B0118
               CALL i227_check()
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_tqn[l_ac].tqn06 = g_tqn_t.tqn06
                   LET g_tqn[l_ac].tqn07 = g_tqn_t.tqn07
                   NEXT FIELD tqn06
               END IF
            END IF
           END IF                  #No.TQC-7B0118
 
        AFTER FIELD tqnud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqnud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               INITIALIZE g_tqn[l_ac].* TO NULL  #重要欄位空白,無效
               DISPLAY g_tqn[l_ac].* TO s_tqn.*
               CALL g_tqn.deleteElement(g_rec_b+1)
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF NOT cl_null(g_tqn[l_ac].tqn06) AND (g_tqn[l_ac].tqn06 != g_tqn_t.tqn06 OR g_tqn_t.tqn06 IS NULL) THEN
               CALL i227_check()
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_tqn[l_ac].tqn06 = g_tqn_t.tqn06
                   LET g_tqn[l_ac].tqn07 = g_tqn_t.tqn07
                   NEXT FIELD tqn06
               END IF
            END IF
            IF cl_null(g_tqn[l_ac].tqn08) THEN LET g_tqn[l_ac].tqn08=0 END IF #No.FUN-870100
            INSERT INTO tqn_file(tqn01,tqn02,tqn03,tqn04,
                                 tqn08,tqn09,tqn05,tqn10,tqn06,tqn07         #No.FUN-870100 ADD tqn08,tqn09,tqn10
                                ,tqnud01,tqnud02,tqnud03,
                                 tqnud04,tqnud05,tqnud06,
                                 tqnud07,tqnud08,tqnud09,
                                 tqnud10,tqnud11,tqnud12,
                                 tqnud13,tqnud14,tqnud15)
            VALUES(g_tqm.tqm01,g_tqn[l_ac].tqn02,
                   g_tqn[l_ac].tqn03,g_tqn[l_ac].tqn04,
                   g_tqn[l_ac].tqn08,g_tqn[l_ac].tqn09,                       #No.FUN-870100 ADD tqn08,tqn09
                   g_tqn[l_ac].tqn05,g_tqn[l_ac].tqn10,                       #No.FUN-870100 ADD tqn10
                   g_tqn[l_ac].tqn06,g_tqn[l_ac].tqn07
                  ,g_tqn[l_ac].tqnud01,
                   g_tqn[l_ac].tqnud02,
                   g_tqn[l_ac].tqnud03,
                   g_tqn[l_ac].tqnud04,
                   g_tqn[l_ac].tqnud05,
                   g_tqn[l_ac].tqnud06,
                   g_tqn[l_ac].tqnud07,
                   g_tqn[l_ac].tqnud08,
                   g_tqn[l_ac].tqnud09,
                   g_tqn[l_ac].tqnud10,
                   g_tqn[l_ac].tqnud11,
                   g_tqn[l_ac].tqnud12,
                   g_tqn[l_ac].tqnud13,
                   g_tqn[l_ac].tqnud14,
                   g_tqn[l_ac].tqnud15)
 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tqn_file",g_tqm.tqm01,g_tqn[l_ac].tqn02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                # 新增至資料庫發生錯誤時, CANCEL INSERT,
                # 不需要讓舊值回復到原變數
                CANCEL INSERT
            ELSE
                IF g_success='Y' THEN
                   COMMIT WORK
                   MESSAGE 'INSERT O.K'
                ELSE
                   CALL cl_rbmsg(1)
                   ROLLBACK WORK
                   MESSAGE 'INSERT FAIL'
                END IF
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_tqn_t.tqn02 > 0 AND
               g_tqn_t.tqn02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM tqn_file
                    WHERE tqn01 = g_tqm.tqm01 AND
                          tqn02 = g_tqn_t.tqn02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","tqn_file",g_tqm.tqm01,g_tqn_t.tqn02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        AFTER DELETE
            IF g_success='Y' THEN
               COMMIT WORK
            ELSE
               CALL cl_rbmsg(1) ROLLBACK WORK
            END IF
            LET l_n = ARR_COUNT()
            INITIALIZE g_tqn[l_n+1].* TO NULL
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tqn[l_ac].* = g_tqn_t.*
               CLOSE i227_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           IF NOT cl_null(g_tqn[l_ac].tqn06) AND
              (g_tqn[l_ac].tqn06 != g_tqn_t.tqn06
               OR g_tqn[l_ac].tqn04 !=g_tqn_t.tqn04
               OR g_tqn[l_ac].tqn03 !=g_tqn_t.tqn03) THEN      #No.TQC-7B0118
               CALL i227_check()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_tqn[l_ac].tqn06 = g_tqn_t.tqn06
                  LET g_tqn[l_ac].tqn07 = g_tqn_t.tqn07
                  NEXT FIELD tqn06
               END IF
           END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tqn[l_ac].tqn02,-263,1)
               LET g_tqn[l_ac].* = g_tqn_t.*
            ELSE
               UPDATE tqn_file SET tqn02= g_tqn[l_ac].tqn02,
                                   tqn03= g_tqn[l_ac].tqn03,
                                   tqn04= g_tqn[l_ac].tqn04,
                                   tqn08= g_tqn[l_ac].tqn08,                           #No.FUN-870100
                                   tqn09= g_tqn[l_ac].tqn09,                           #No.FUN-870100
                                   tqn05= g_tqn[l_ac].tqn05,
                                   tqn10= g_tqn[l_ac].tqn10,                           #No.FUN-870100
                                   tqn06= g_tqn[l_ac].tqn06,
                                   tqn07= g_tqn[l_ac].tqn07
                                  ,tqnud01 = g_tqn[l_ac].tqnud01,
                                   tqnud02 = g_tqn[l_ac].tqnud02,
                                   tqnud03 = g_tqn[l_ac].tqnud03,
                                   tqnud04 = g_tqn[l_ac].tqnud04,
                                   tqnud05 = g_tqn[l_ac].tqnud05,
                                   tqnud06 = g_tqn[l_ac].tqnud06,
                                   tqnud07 = g_tqn[l_ac].tqnud07,
                                   tqnud08 = g_tqn[l_ac].tqnud08,
                                   tqnud09 = g_tqn[l_ac].tqnud09,
                                   tqnud10 = g_tqn[l_ac].tqnud10,
                                   tqnud11 = g_tqn[l_ac].tqnud11,
                                   tqnud12 = g_tqn[l_ac].tqnud12,
                                   tqnud13 = g_tqn[l_ac].tqnud13,
                                   tqnud14 = g_tqn[l_ac].tqnud14,
                                   tqnud15 = g_tqn[l_ac].tqnud15
 
               WHERE tqn01=g_tqm.tqm01 AND tqn02=g_tqn_t.tqn02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","tqn_file",g_tqm.tqm01,g_tqn_t.tqn02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                   LET g_tqn[l_ac].* = g_tqn_t.*
               ELSE
                   IF g_success='Y' THEN
                      COMMIT WORK
                      MESSAGE 'UPDATE O.K'
                   ELSE
                      CALL cl_rbmsg(1)
                      ROLLBACK WORK
                      MESSAGE 'UPDATE FAIL'
                   END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               # 當為修改狀態且取消輸入時, 才作回復舊值的動作
               IF p_cmd = 'u' THEN
                  LET g_tqn[l_ac].* = g_tqn_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_tqn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
 
               CLOSE i227_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF NOT cl_null(g_tqn[l_ac].tqn06) AND (g_tqn[l_ac].tqn06 != g_tqn_t.tqn06 OR g_tqn_t.tqn06 IS NULL) THEN
               CALL i227_check()
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_tqn[l_ac].tqn06 = g_tqn_t.tqn06
                   LET g_tqn[l_ac].tqn07 = g_tqn_t.tqn07
                   NEXT FIELD tqn06
               END IF
            END IF
            LET l_ac_t = l_ac  #FUN-D30033 add 
            # 除了修改狀態取消時, 其餘不需要回復舊值或備份舊值
            CLOSE i227_bcl
            COMMIT WORK
 
            CALL g_tqn.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tqn02) AND l_ac > 1 THEN
                LET g_tqn[l_ac].* = g_tqn[l_ac-1].*
                NEXT FIELD tqn02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tqn03) #產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_ima01"
#                LET g_qryparam.default1 = g_tqn[l_ac].tqn03
#                CALL cl_create_qry() RETURNING g_tqn[l_ac].tqn03
                 CALL q_sel_ima(FALSE, "q_ima01","",g_tqn[l_ac].tqn03,"","","","","",'' ) 
                      RETURNING   g_tqn[l_ac].tqn03
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_tqn[l_ac].tqn03
                 NEXT FIELD tqn03
               WHEN INFIELD(tqn04)  #定價單位
              IF g_azw.azw04 ='2' THEN       
                 SELECT ima25 INTO l_ima25
                   FROM ima_file
                  WHERE ima01 = g_tqn[l_ac].tqn03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe01"
                 LET g_qryparam.arg1 = l_ima25
              ELSE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
              END IF
                 LET g_qryparam.default1 = g_tqn[l_ac].tqn04
                 CALL cl_create_qry() RETURNING g_tqn[l_ac].tqn04
                 DISPLAY g_tqn[l_ac].tqn04 TO tqn04
                 NEXT FIELD tqn04
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
        ON ACTION CONTROLS
           CALL cl_set_head_visible("","AUTO")
        END INPUT
        UPDATE tqm_file SET tqmmodu = g_user, tqmdate = g_today
         WHERE tqm01 = g_tqm.tqm01
        DISPLAY g_user TO tqmmodu
        DISPLAY g_today TO tqmdate
 
        CLOSE i227_bcl
        COMMIT WORK
        CALL i227_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i227_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM tqm_file WHERE tqm01 = g_tqm.tqm01
         INITIALIZE g_tqm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i227_tqn03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima908  LIKE ima_file.ima908,
           l_ima1010 LIKE ima_file.ima1010,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
 
    SELECT ima02,ima908,ima1010,imaacti
      INTO l_ima02,l_ima908,l_ima1010,l_imaacti
      FROM ima_file
     WHERE ima01 = g_tqn[l_ac].tqn03
       AND (ima130 IS NULL OR ima130 <>'2')
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 100
         WHEN l_imaacti='N'       LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'    #No.FUN-690022 add
 
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_tqn[l_ac].ima02  = l_ima02
    LET g_tqn[l_ac].ima908 = l_ima908
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_tqn[l_ac].ima02 TO ima02
       DISPLAY g_tqn[l_ac].ima908 TO ima908
    END IF
 
END FUNCTION
 
FUNCTION i227_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
 
    CONSTRUCT l_wc2 ON tqn02,tqn03,ima02,tqn04,ima908,  #螢幕上取單身條件
                       tqn08,tqn09,tqn05,tqn10,tqn06,tqn07               #No.FUN-870100 add tqn08,tqn09,tqn10
           FROM s_tqn[1].tqn02,s_tqn[1].tqn03,s_tqn[1].ima02,
                s_tqn[1].tqn04,s_tqn[1].ima908,
                s_tqn[1].tqn08,s_tqn[1].tqn09,                           #No.FUN-870100 add
                s_tqn[1].tqn05,
                s_tqn[1].tqn10,                                          #No.FUN-870100 add
                s_tqn[1].tqn06,s_tqn[1].tqn07
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i227_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i227_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT tqn02,tqn03,'',tqn04,'',",
        "       tqn08,tqn09,tqn05,tqn10,tqn06,tqn07 ",                   #No.FUN-870100 add tqn08,tqn09,tqn10
        "      ,tqnud01,tqnud02,tqnud03,tqnud04,tqnud05,",
        "       tqnud06,tqnud07,tqnud08,tqnud09,tqnud10,",
        "       tqnud11,tqnud12,tqnud13,tqnud14,tqnud15", 
        "  FROM tqn_file ",
        " WHERE tqn01 ='",g_tqm.tqm01,"'"  #單頭
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY tqn02 " 
    DISPLAY g_sql
   
    PREPARE i227_pb FROM g_sql
    DECLARE tqn_cs                       #SCROLL CURSOR
        CURSOR FOR i227_pb
    CALL g_tqn.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH tqn_cs INTO g_tqn[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_ac = g_cnt
        CALL i227_tqn03('d')
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tqn.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i227_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN #FUN-D30033 add
      RETURN                                         #FUN-D30033 add
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tqn TO s_tqn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
 
        ON ACTION CONTROLS
           CALL cl_set_head_visible("","AUTO")
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION first
         CALL i227_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i227_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i227_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION next
         CALL i227_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION last
         CALL i227_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION create_b
         LET g_action_choice="create_b"
         EXIT DISPLAY
 
      ON ACTION delete_b
         LET g_action_choice="delete_b"
         EXIT DISPLAY
 
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
 
      ON ACTION hang
         LET g_action_choice="hang"
         EXIT DISPLAY
 
      ON ACTION unhang
         LET g_action_choice="unhang"
         EXIT DISPLAY
 
      ON ACTION price_adjust
         LET g_action_choice="price_adjust"
         EXIT DISPLAY
     ON ACTION  output
         LET g_action_choice="output"            
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION carry
         LET g_action_choice = "carry"
         EXIT DISPLAY
 
      ON ACTION download
         LET g_action_choice = "download"
         EXIT DISPLAY
 
      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DISPLAY
 
      ON ACTION price_list
         LET g_bp_flag = 'list'
         EXIT DISPLAY
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i227_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN #FUN-D30033 add
      RETURN                                         #FUN-D30033 add
   END IF                                            #FUN-D30033 add
 
   LET g_action_choice = " "
 
   DISPLAY ARRAY g_tqn TO s_tqn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_tqm_l TO s_tqm_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
     
      ON ACTION main
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i227_fetch('/')
         END IF
         CALL cl_set_comp_visible("page15", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page15", TRUE)
         EXIT DISPLAY
 
      ON ACTION CONTROLS
         CALL cl_set_head_visible("","AUTO")
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION first
         CALL i227_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         EXIT DISPLAY
 
      ON ACTION previous
         CALL i227_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DISPLAY
 
      ON ACTION jump
         CALL i227_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DISPLAY
 
      ON ACTION next
         CALL i227_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DISPLAY
 
      ON ACTION last
         CALL i227_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DISPLAY
 
      ON ACTION create_b
         LET g_action_choice="create_b"
         EXIT DISPLAY
 
      ON ACTION delete_b
         LET g_action_choice="delete_b"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
 
      ON ACTION hang
         LET g_action_choice="hang"
         EXIT DISPLAY
 
      ON ACTION unhang
         LET g_action_choice="unhang"
         EXIT DISPLAY
 
      ON ACTION price_adjust
         LET g_action_choice="price_adjust"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION carry
         LET g_action_choice = "carry"
         EXIT DISPLAY
 
      ON ACTION download
         LET g_action_choice = "download"
         EXIT DISPLAY
 
      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DISPLAY
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i227_fetch('/')
         CALL cl_set_comp_visible("page15", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page15", TRUE)
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i227_copy()
DEFINE
    l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_newno         LIKE tqm_file.tqm01,
    l_oldno         LIKE tqm_file.tqm01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tqm.tqm01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i227_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno FROM tqm01
 
        AFTER FIELD tqm01
            IF NOT cl_null(l_newno) THEN
               SELECT COUNT(*) INTO l_n FROM tqm_file
                WHERE tqm01 = l_newno
               IF l_n >0 THEN
                  CALL cl_err(l_newno,-239,1)
                  LET l_newno = ''
                  NEXT FIELD tqm01
               END IF
               CALL s_field_chk(l_newno,'7',g_plant,'tqm01') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(l_newno,'aoo-043',1)
                  NEXT FIELD tqm01
               END IF
            END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_tqm.tqm01
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM tqm_file         #單頭複製
        WHERE tqm01=g_tqm.tqm01
        INTO TEMP y
    UPDATE y
        SET tqm01=l_newno,    #新的鍵值
            tqmuser=g_user,   #資料所有者
            tqmgrup=g_grup,   #資料所有者所屬群
            tqmmodu=NULL,     #資料更改日期
            tqmdate=g_today,  #資料建立日期
            tqmacti='Y',      #有效資料
            tqmoriu=g_user,        #TQC-A30034 ADD
            tqmorig=g_grup,        #TQC-A30034 ADD
            tqm07 = g_plant,  #No.FUN-7C0010
            tqm04='0'         #狀態碼
    INSERT INTO tqm_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM tqn_file         #單身複製
        WHERE tqn01=g_tqm.tqm01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
    UPDATE x
        SET tqn01=l_newno
    INSERT INTO tqn_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tqn_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_tqm.tqm01
     SELECT tqm_file.* INTO g_tqm.* FROM tqm_file
      WHERE tqm01 = l_newno
     CALL i227_u()
     CALL i227_b()
     #SELECT tqm_file.* INTO g_tqm.* FROM tqm_file  #FUN-C80046
     # WHERE tqm01 = l_oldno #FUN-C80046
     #CALL i227_show()       #FUN-C80046
END FUNCTION
 
 
FUNCTION i227_confirm()
 
DEFINE l_n        LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqm.tqm01 IS NULL THEN RETURN END IF
#CHI-C30107 ------------------- add ----------------- begin
    IF g_tqm.tqmacti='N' THEN
       CALL cl_err(g_tqm.tqm01,'mfg1000',0)
       RETURN
    END IF
    IF g_tqm.tqm04 = '1' THEN CALL cl_err(g_tqm.tqm01,'9023',0) RETURN END IF 

    SELECT count(*) INTO l_n FROM tqn_file
     WHERE tqn01 = g_tqm.tqm01
    IF l_n = 0 THEN
       CALL cl_err('','atm-228',1)
       RETURN
    END IF
    IF NOT cl_confirm('axr-108') THEN RETURN END IF 
#CHI-C30107 ------------------- add ----------------- end
    SELECT * INTO g_tqm.* FROM tqm_file WHERE tqm01=g_tqm.tqm01
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
    IF g_tqm.tqmacti='N' THEN
       CALL cl_err(g_tqm.tqm01,'mfg1000',0)
       RETURN
    END IF
    IF g_tqm.tqm04 = '1' THEN CALL cl_err(g_tqm.tqm01,'9023',0) RETURN END IF #MOD-C20189
 
    SELECT count(*) INTO l_n FROM tqn_file
     WHERE tqn01 = g_tqm.tqm01
    IF l_n = 0 THEN
       CALL cl_err('','atm-228',1)
       RETURN
    END IF
#   IF NOT cl_confirm('axr-108') THEN RETURN END IF #CHI-C30107 mark
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN i227_cl USING g_tqm.tqm01
    IF STATUS THEN
       CALL cl_err("OPEN i227_cl:", STATUS, 1)
       CLOSE i227_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i227_cl INTO g_tqm.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)
        CLOSE i227_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE tqm_file SET tqm04='1'    #No.TQC-7B0118
     WHERE tqm01 = g_tqm.tqm01
    IF STATUS THEN
       CALL cl_err3("upd","tqm_file",g_tqm.tqm01,"",STATUS,"","upd tqm04",1)  #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       CALL i227_list_fill()  #No.FUN-7C0010
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tqm04 INTO g_tqm.tqm04 FROM tqm_file
     WHERE tqm01 = g_tqm.tqm01
    DISPLAY BY NAME g_tqm.tqm04
 
    LET g_chr = 'N'
    LET g_chr2= 'N'
    LET g_chr3= 'N'
    CASE g_tqm.tqm04
       WHEN '1' LET g_chr = 'Y'
       WHEN '2' LET g_chr2= 'Y'
    END CASE
    CALL cl_set_field_pic1(g_chr,"","","","",g_tqm.tqmacti,"",g_chr2)
END FUNCTION
 
FUNCTION i227_unconfirm()
 
DEFINE l_n LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqm.tqm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqm.* FROM tqm_file WHERE tqm01=g_tqm.tqm01
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
    IF g_tqm.tqm04!='1' THEN     #No.TQC-7B0118
       CALL cl_err('','9025',0)  #不在已審核狀態，不可取消申審核！
       RETURN
    END IF
    IF NOT cl_confirm('axr-109') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
        OPEN i227_cl USING g_tqm.tqm01
        IF STATUS THEN
           CALL cl_err("OPEN i227_cl:", STATUS, 1)
           CLOSE i227_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH i227_cl INTO g_tqm.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)
            CLOSE i227_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE tqm_file SET tqm04='0'    #No.TQC-7B0118
            WHERE tqm01 = g_tqm.tqm01
        IF STATUS THEN
            CALL cl_err3("upd","tqm_file",g_tqm.tqm01,"",STATUS,"","upd tqm04",1)  #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            CALL i227_list_fill()  #No.FUN-7C0010
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT tqm04 INTO g_tqm.tqm04 FROM tqm_file
            WHERE tqm01 = g_tqm.tqm01
        DISPLAY BY NAME g_tqm.tqm04
 
        LET g_chr = 'N'
        LET g_chr2= 'N'
        LET g_chr3= 'N'
        CASE g_tqm.tqm04
       WHEN '1' LET g_chr = 'Y'
       WHEN '2' LET g_chr2= 'Y'
    END CASE
    CALL cl_set_field_pic1(g_chr,"","","","",g_tqm.tqmacti,"",g_chr2)
END FUNCTION
 
FUNCTION i227_cp()
DEFINE l_tqn_tqn06  LIKE tqn_file.tqn06,
       l_tqn_tqn07  LIKE tqn_file.tqn07
DEFINE l_sql  LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(400)
DEFINE l_n    LIKE type_file.num5           #No.FUN-680120 SMALLINT
DEFINE l_k         LIKE tqn_file.tqn02
DEFINE l_tqn04     LIKE tqn_file.tqn04,
       l_tqn08     LIKE tqn_file.tqn08,     #No.FUN-870100 ADD
       l_tqn09     LIKE tqn_file.tqn09,     #No.FUN-870100 ADD
       l_tqn05     LIKE tqn_file.tqn05,
       l_tqn06     LIKE tqn_file.tqn06,
       l_tqn07     LIKE tqn_file.tqn07
DEFINE l_ima01     LIKE ima_file.ima01,
       l_ima31     LIKE ima_file.ima31,
       l_ima25     LIKE ima_file.ima25,
       l_rth04     LIKE rth_file.rth04,     #No.FUN-870100 ADD
       l_rtg05     LIKE rtg_file.rtg05,     #No.FUN-870100
       l_rtg08     LIKE rtg_file.rtg08,     #No.FUN-870100
       l_rtz05     LIKE rtz_file.rtz05,     #No.FUN-870100 add
       l_ima31_fac LIKE ima_file.ima31_fac
DEFINE l_flag3     LIKE type_file.num5      #No.FUN-680120 SMALLINT
DEFINE l_method    LIKE type_file.chr1,     #No.FUN-680120 VARCHAR(01)     #取價方式      #No.TQC-660134
       l_source    LIKE type_file.chr1,     #No.FUN-680120 VARCHAR(01)     #料件來源碼    #No.TQC-660134
       l_rate      LIKE rme_file.rme30,     #No.FUN-680120 DECIMAL(8,3)      #價格/成本比率 #No.TQC-660134
       l_cost      LIKE imb_file.imb118     #No.FUN-680120 DECIMAL(20,6)     #成本價        #No.TQC-660134
 
    LET l_tqn06 = ''
    LET l_tqn07 = ''
    IF g_tqm.tqm01 IS NULL THEN
       CALL cl_err('','atm-238',1)
       RETURN
    END IF
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
    IF g_tqm.tqm04 = '1' OR g_tqm.tqm04='2'  THEN     #No.TQC-7B0118
       CALL cl_err(g_tqm.tqm01,'atm-239',1)
       RETURN
    END IF
    IF g_tqm.tqmacti = 'N' THEN
       CALL cl_err(g_tqm.tqm01,'mfg1000',1)
       RETURN
    END IF
    SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01=g_tqm.tqm05
 
    OPEN WINDOW i227_w1
        WITH FORM "atm/42f/atmi227_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    CLEAR FORM                             #清除畫面
 WHILE TRUE
    CONSTRUCT BY NAME g_wc3 ON             # 螢幕上取單頭條件
                      ima01,ima135,ima06,ima1004,ima1005,ima1006,
                      ima1007,ima1008,ima1009
 
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
 
     ON ACTION CONTROLP
           CASE
               WHEN INFIELD(ima01) #料件編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state ="c"
#                LET g_qryparam.form ="q_ima02"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO ima01
                 NEXT FIELD ima01
               WHEN INFIELD(ima06) #分群碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_imz1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima06
                 NEXT FIELD ima06
               WHEN INFIELD(ima1004) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1004
                 NEXT FIELD ima1004
               WHEN INFIELD(ima1005) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1005
                 NEXT FIELD ima1005
               WHEN INFIELD(ima1006) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="3"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1006
                 NEXT FIELD ima1006
               WHEN INFIELD(ima1007) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="4"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1007
                 NEXT FIELD ima1007
               WHEN INFIELD(ima1008) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="5"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1008
                 NEXT FIELD ima1008
               WHEN INFIELD(ima1009) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="6"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1009
                 NEXT FIELD ima1009
              OTHERWISE EXIT CASE
          END CASE
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION controlg      
         CALL cl_cmdask()     
      
      ON ACTION help          
         CALL cl_show_help()  
 
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
    #組合出查詢條件及游標
    LET l_sql=  " SELECT ima01 FROM ima_file ",
#               "  WHERE imaacti='Y' AND ",g_wc3,   #No.No.TQC-7B0108         #TQC-C20152 mark
                "  WHERE imaacti='Y' AND ima928 = 'N' ",                      #TQC-C20152 add        
                "    AND (ima120 IS NULL OR ima120 = ' ' OR ima120 = '1') ",  #TQC-C20152 add 
                "    AND NOT EXISTS (SELECT 1 FROM rty_file ",                #TQC-C20152 add
                "                            WHERE rty01 = '",g_plant,"'",    #TQC-C20152 add
                "    AND rty02 = ima01 AND rty06 = '4' AND rtyacti = 'Y')",   #TQC-C20152 add               
                "    AND ",g_wc3,                                             #TQC-C20152 add 
                "  ORDER BY ima01"
 
    PREPARE ima_prepare FROM  l_sql
    DECLARE ima_cs
        SCROLL CURSOR WITH HOLD FOR ima_prepare
 
    INPUT l_method,l_rate,l_tqn04,l_tqn05,l_tqn06,l_tqn07    #No.TQC-660134
      WITHOUT DEFAULTS FROM e,f,a,b,c,d                      #No.TQC-660134
 
      BEFORE INPUT
        LET l_method='0'
        LET l_rate  = NULL
 
      AFTER FIELD e
        IF cl_null(l_method)THEN NEXT FIELD e END IF
        IF l_method='0' THEN
           CALL cl_set_comp_entry("b",TRUE)
           CALL cl_set_comp_entry("f",FALSE)
           LET l_rate = NULL
           DISPLAY l_rate TO f
        ELSE
           CALL cl_set_comp_entry("f",TRUE)
           CALL cl_set_comp_entry("b",FALSE)
           LET l_rate = 1
           DISPLAY l_rate TO f
           LET l_tqn05 = NULL
           DISPLAY l_tqn05 TO b
        END IF
 
      AFTER FIELD f
        IF cl_null(l_rate) THEN NEXT FIELD f END IF
        IF l_rate <=0 THEN
           CALL cl_err(l_rate,"atm-091",0)
        END IF
 
      AFTER FIELD a
         IF NOT cl_null(l_tqn04) THEN
            SELECT count(*) INTO l_n
              FROM gfe_file
             WHERE gfe01 = l_tqn04
               AND gfeacti = 'Y'
            IF l_n = 0 THEN
              CALL cl_err(l_tqn04,'100',1)
              NEXT FIELD a
            END IF
          END IF
 
      AFTER FIELD b
         IF NOT  cl_null(l_tqn05) THEN                                 # MOD-AC0064 
            CALL cl_digcut(l_tqn05,t_azi03) RETURNING l_tqn05    # MOD-AC0064 
            DISPLAY l_tqn05 TO b                                 # MOD-AC0064 
         END IF                                                  # MOD-AC0064 
         IF l_tqn05<=0 THEN
            CALL cl_err(l_tqn05,'mfg9243',0)
            NEXT FIELD b
         END IF
 
      AFTER FIELD c
         IF NOT cl_null(l_tqn06) THEN
            IF NOT cl_null(l_tqn07) THEN
               IF l_tqn06>l_tqn07 THEN
                  CALL cl_err(l_tqn06,'axm-522',0)
                  NEXT FIELD c
               END IF
            END IF
         END IF
 
      AFTER FIELD d
         IF NOT cl_null(l_tqn07) THEN
            IF NOT cl_null(l_tqn06) THEN
               IF l_tqn06>l_tqn07 THEN
                  CALL cl_err(l_tqn07,'axm-522',0)
                  NEXT FIELD d
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(a)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gfe"
              LET g_qryparam.default1 = l_tqn04
              CALL cl_create_qry() RETURNING l_tqn04
              DISPLAY l_tqn04 TO FORMONLY.a
              NEXT FIELD a
          OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW i227_w1
       RETURN    #No.TQC-740162
    END IF
 
    FOREACH ima_cs INTO l_ima01
      LET l_tqn_tqn06=''
      LET l_tqn_tqn07=''
      IF NOT cl_null(l_ima01) THEN
         LET l_sql = " SELECT tqn06,tqn07 FROM tqn_file ",
                     "  WHERE tqn01 = '",g_tqm.tqm01,"'",
                     "    AND tqn03 = '",l_ima01,"'",
                     "    AND tqn04 = '",l_tqn04,"'"   #TQC-640083
 
        PREPARE tqn_prepare FROM  l_sql
        DECLARE tqn_cs1 CURSOR FOR tqn_prepare
        LET l_flag3=''
        FOREACH tqn_cs1 INTO l_tqn_tqn06,l_tqn_tqn07
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             LET  l_flag3= 2
             EXIT FOREACH
          END IF
          IF cl_null(l_tqn_tqn07) THEN
           IF NOT (NOT cl_null(l_tqn06) AND NOT cl_null(l_tqn07) AND
                   (l_tqn06<l_tqn_tqn06 AND l_tqn07<l_tqn_tqn06)) THEN
             LET  l_flag3=1
             EXIT FOREACH
           ELSE
             LET l_flag3=0
             EXIT FOREACH
           END IF
          END IF
          IF NOT cl_null(l_tqn_tqn07) THEN
             IF cl_null(l_tqn07) then
               IF l_tqn06<=l_tqn_tqn07 THEN
                  LET  l_flag3=1
                  EXIT FOREACH
               END IF
             ELSE
               IF NOT cl_null(l_tqn07) THEN
                 IF (l_tqn_tqn06<=l_tqn06 AND l_tqn06<=l_tqn_tqn07)
                   OR (l_tqn_tqn06<=l_tqn07 AND l_tqn07<=l_tqn_tqn07) THEN
                      LET  l_flag3=1
                      EXIT FOREACH
                 END IF
               END IF
             END IF
           END IF
           IF NOT cl_null(l_tqn_tqn07) THEN
              IF l_tqn06>l_tqn_tqn07 OR l_tqn07<l_tqn_tqn06  THEN
                 LET l_flag3=0
              ELSE
                 LET  l_flag3=1
                 EXIT FOREACH
              END IF
           END IF
       END FOREACH
 
       IF l_flag3=2 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       IF l_flag3=1 THEN
          CALL cl_err(l_ima01,'lib-028',0)
          CONTINUE FOREACH
       ELSE            	
          SELECT max(tqn02)+1
            INTO l_k
            FROM tqn_file
           WHERE tqn01 = g_tqm.tqm01
          IF l_k IS NULL THEN
             LET l_k = 1
          END IF
          IF l_method!=0 THEN
             SELECT ima08 INTO l_source FROM ima_file
              WHERE ima01=l_ima01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","ima_file",l_ima01,"",SQLCA.sqlcode,"","select ima08",1)
             END IF
             CALL s_cost(l_method,l_source,l_ima01)
                  RETURNING l_cost
             IF cl_null(l_cost) THEN
                CALL cl_err(l_ima01,"atm-092",1)
             END IF
             LET l_tqn05=l_cost*l_rate
          END IF
 
            IF g_azw.azw04 = '2' THEN      
                       LET l_rth04 = NULL
                       LET l_rtg05 = NULL
                       LET l_rtg08 = NULL
                    SELECT rtz05 INTO l_rtz05 FROM rtz_file WHERE rtz01=g_plant                                                     
                    IF NOT cl_null(l_rtz05) THEN   
                       SELECT rtg05,rtg08 INTO l_rtg05,l_rtg08
                         FROM rtg_file,rtf_file
                        WHERE rtg01 = l_rtz05
                          AND rtg01 = rtf01
                          AND rtg03 = l_ima01
                          AND rtg04 = l_tqn04  
                          AND rtfconf='Y'
                          AND rtg09='Y'
                       IF l_rtg08='Y' THEN
                          SELECT rth04 INTO l_rth04
                            FROM rth_file
                           WHERE rth01  = l_ima01     #g_tqn[l_ac].tqn03
                             AND rth02  = l_tqn04     #g_tqn[l_ac].tqn04
                             AND rthplant = g_plant
                             AND rthacti = 'Y'
                          LET l_tqn08=l_rth04
                       ELSE
                          LET l_tqn08=l_rtg05
                       END IF
                    END IF 
                       IF cl_null(l_tqn08) THEN
                          LET l_tqn08 = 0
                          LET l_tqn09 = 100              #TQC-AB0153
                       ELSE
                          IF l_tqn08 = 0 THEN
                             LET l_tqn09 = 100
                          ELSE
                             IF NOT cl_null(l_tqn05) AND l_tqn05 != 0 THEN
                                LET l_tqn09 = l_tqn05*100/l_tqn08
                             ELSE
                                LET l_tqn09 = 100
                             END IF
                          END IF
                       END IF
            END IF
 
           CALL cl_digcut(l_tqn05,t_azi03) RETURNING l_tqn05
          IF cl_null(l_tqn08) THEN
             LET l_tqn08=0
          END IF
          INSERT INTO tqn_file
               (tqn01,tqn02,tqn03,tqn04,tqn08,tqn09,tqn05,tqn06,tqn07)    #No.FUN-870100 ADD tqn08,tqn09
               VALUES(g_tqm.tqm01,l_k,l_ima01,l_tqn04,l_tqn08,l_tqn09,l_tqn05,  #No.FUN-870100 ADD tqn08,tqn09
                      l_tqn06,l_tqn07)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tqn_file",g_tqm.tqm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
             EXIT FOREACH
          END IF
       END IF
    END IF
 
  END FOREACH
 
  CALL i227_b_fill(g_wc2)   #填充單身
  EXIT WHILE
 END WHILE
 
  CLOSE WINDOW i227_w1                #結束畫面
END FUNCTION
 
FUNCTION i227_dp()
DEFINE l_sql    LIKE type_file.chr1000,       #No.FUN-680120 (1000)
       l_ima01  LIKE ima_file.ima01
 
    IF cl_null(g_tqm.tqm01) THEN
       CALL cl_err('','atm-238',1)
       RETURN
    END IF
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
    IF g_tqm.tqm04 = '1' OR g_tqm.tqm04='2' THEN         #No.TQC-7B0118
       CALL cl_err(g_tqm.tqm01,'atm-239',1)
       RETURN
    END IF
    IF g_tqm.tqmacti = 'N' THEN
       CALL cl_err(g_tqm.tqm01,'mfg1000',1)
       RETURN
    END IF
 
    OPEN WINDOW i227_w3
        WITH FORM "atm/42f/atmi227_3"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    CLEAR FORM
 
   WHILE TRUE
    CONSTRUCT BY NAME g_wc5 ON
                      ima01,ima135,ima06,ima1004,ima1005,ima1006,
                      ima1007,ima1008,ima1009
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
     ON ACTION CONTROLP
           CASE
               WHEN INFIELD(ima01) #料件編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state ="c"
#                LET g_qryparam.form ="q_ima02"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO ima01
                 NEXT FIELD ima01
               WHEN INFIELD(ima06) #分群碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_imz1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima06
                 NEXT FIELD ima06
               WHEN INFIELD(ima1004) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1004
                 NEXT FIELD ima1004
               WHEN INFIELD(ima1005) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1005
                 NEXT FIELD ima1005
               WHEN INFIELD(ima1006) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="3"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1006
                 NEXT FIELD ima1006
               WHEN INFIELD(ima1007) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="4"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1007
                 NEXT FIELD ima1007
               WHEN INFIELD(ima1008) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="5"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1008
                 NEXT FIELD ima1008
               WHEN INFIELD(ima1009) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="6"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1009
                 NEXT FIELD ima1009
              OTHERWISE EXIT CASE
          END CASE
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION controlg      
         CALL cl_cmdask()     
      
      ON ACTION help          
         CALL cl_show_help()  
 
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
    #組合出查詢條件及游標
    LET l_sql=  " SELECT ima01 FROM ima_file ",
                "  WHERE ",g_wc5,
                "  ORDER BY ima01"
 
    PREPARE ima_prepared FROM  l_sql
    DECLARE ima_csd
        SCROLL CURSOR WITH HOLD FOR ima_prepared
 
    IF NOT cl_confirm('atm-242') THEN EXIT WHILE END IF
 
    FOREACH ima_csd INTO l_ima01
      IF NOT cl_null(l_ima01) THEN
         LET l_sql = " DELETE FROM tqn_file ",
                     "  WHERE tqn01 = '",g_tqm.tqm01,"'",
                     "    AND tqn03 = '",l_ima01,"'"
         PREPARE del_tqn FROM l_sql
         EXECUTE del_tqn
         MESSAGE ""
      END IF
    END FOREACH
    CALL i227_b_fill(g_wc2)   #填充單身
    EXIT WHILE
 
   END WHILE
 
   CLOSE WINDOW i227_w3
 
END FUNCTION
 
 
FUNCTION i227_hang()
 
DEFINE l_n        LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqm.tqm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqm.* FROM tqm_file WHERE tqm01=g_tqm.tqm01
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
    IF g_tqm.tqmacti='N' THEN
       CALL cl_err(g_tqm.tqm01,'mfg1000',0)
       RETURN
    END IF
    IF g_tqm.tqm04!='1' THEN     #No.TQC-7B0118
       CALL cl_err('','atm-234',0)
       RETURN
    END IF
    SELECT count(*) INTO l_n FROM tqn_file
     WHERE tqn01 = g_tqm.tqm01
    IF l_n = 0 THEN
       CALL cl_err('','atm-230',1)
       RETURN
    END IF
    IF NOT cl_confirm('atm-236') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN i227_cl USING g_tqm.tqm01
    IF STATUS THEN
       CALL cl_err("OPEN i227_cl:", STATUS, 1)
       CLOSE i227_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i227_cl INTO g_tqm.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)
        CLOSE i227_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE tqm_file SET tqm04='2'
     WHERE tqm01 = g_tqm.tqm01
    IF STATUS THEN
       CALL cl_err3("upd","tqm_file",g_tqm.tqm01,"",STATUS,"","upd tqm04",1)  #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       CALL i227_list_fill()  #No.FUN-7C0010
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tqm04 INTO g_tqm.tqm04 FROM tqm_file
     WHERE tqm01 = g_tqm.tqm01
    DISPLAY BY NAME g_tqm.tqm04
 
    LET g_chr = 'N'
    LET g_chr2= 'N'
    LET g_chr3= 'N'
    CASE g_tqm.tqm04
       WHEN '1' LET g_chr = 'Y'
       WHEN '2' LET g_chr2= 'Y'
    END CASE
    CALL cl_set_field_pic1(g_chr,"","","","",g_tqm.tqmacti,"",g_chr2)
END FUNCTION
 
FUNCTION i227_unhang()
DEFINE l_n LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqm.tqm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqm.* FROM tqm_file WHERE tqm01=g_tqm.tqm01
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
    IF g_tqm.tqm04!='2' THEN      #No.TQC-7B0118
       CALL cl_err('','atm-235',0)  #不在已挂起狀態，不可取消挂起！
       RETURN
    END IF
    IF NOT cl_confirm('atm-237') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
        OPEN i227_cl USING g_tqm.tqm01
        IF STATUS THEN
           CALL cl_err("OPEN i227_cl:", STATUS, 1)
           CLOSE i227_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH i227_cl INTO g_tqm.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tqm.tqm01,SQLCA.sqlcode,0)
            CLOSE i227_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE tqm_file SET tqm04='1'     #No.TQC-7B0118
            WHERE tqm01 = g_tqm.tqm01
        IF STATUS THEN
            CALL cl_err3("upd","tqm_file",g_tqm.tqm01,"",STATUS,"","upd tqm04",1)  #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            CALL i227_list_fill()  #No.FUN-7C0010
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT tqm04 INTO g_tqm.tqm04 FROM tqm_file
            WHERE tqm01 = g_tqm.tqm01
        DISPLAY BY NAME g_tqm.tqm04
 
        LET g_chr = 'N'
        LET g_chr2= 'N'
        LET g_chr3= 'N'
        CASE g_tqm.tqm04
           WHEN '1' LET g_chr = 'Y'
           WHEN '2' LET g_chr2= 'Y'
        END CASE
        CALL cl_set_field_pic1(g_chr,"","","","",g_tqm.tqmacti,"",g_chr2)
END FUNCTION
 
FUNCTION i227_ap()
DEFINE l_n    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       l_sql  LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(400)
       l_ima25       LIKE ima_file.ima25,
       l_ima31       LIKE ima_file.ima31,
       l_ima31_fac   LIKE ima_file.ima31_fac
DEFINE l_unit        LIKE tqn_file.tqn04,   #No.FUN-680120 VARCHAR(4)
       l_method      LIKE type_file.chr1,   #No.FUN-680120 VARCHAR(1)
       l_percent     LIKE sga_file.sga04,   #No.FUN-680120 DECIMAL(7,3)
       l_sum         LIKE tqn_file.tqn05    #No.FUN-680120 DECIMAL(18,2)
DEFINE l_tqn02       LIKE tqn_file.tqn02,
       l_tqn03       LIKE tqn_file.tqn03,
       l_tqn04       LIKE tqn_file.tqn04,
       l_tqn05       LIKE tqn_file.tqn05
DEFINE t_tqn05       LIKE tqn_file.tqn05    #No.MOD-820125
 
    IF cl_null(g_tqm.tqm01) THEN
       CALL cl_err('','atm-238',1)
       RETURN
    END IF
    IF NOT s_dc_ud_flag('7',g_tqm.tqm07,g_plant,'u') THEN
       CALL cl_err(g_tqm.tqm07,'aoo-045',1)
       RETURN
    END IF
    IF g_tqm.tqm04 = '1' OR g_tqm.tqm04='2' THEN     #No.TQC-7B0118
       CALL cl_err(g_tqm.tqm01,'atm-239',1)
       RETURN
    END IF
    IF g_tqm.tqmacti = 'N' THEN
       CALL cl_err(g_tqm.tqm01,'mfg1000',1)
       RETURN
    END IF
    SELECT count(*) INTO l_n
      FROM tqn_file
     WHERE tqn01 = g_tqm.tqm01
    IF l_n = 0 THEN
       CALL cl_err(g_tqm.tqm01,'atm-240',1)
       RETURN
    END IF
    SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01=g_tqm.tqm05
 
    OPEN WINDOW i227_w2
        WITH FORM "atm/42f/atmi227_2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    CLEAR FORM
 
 WHILE TRUE
    CONSTRUCT BY NAME g_wc4 ON
                      ima01,ima135,ima06,ima1004,ima1005,ima1006,
                      ima1007,ima1008,ima1009
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
     ON ACTION CONTROLP
           CASE
               WHEN INFIELD(ima01) #料件編號
#FUN-AB0025---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state ="c"
#                LET g_qryparam.form ="q_ima02"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AB0025---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO ima01
                 NEXT FIELD ima01
               WHEN INFIELD(ima06) #分群碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_imz1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima06
                 NEXT FIELD ima06
               WHEN INFIELD(ima1004) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1004
                 NEXT FIELD ima1004
               WHEN INFIELD(ima1005) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1005
                 NEXT FIELD ima1005
               WHEN INFIELD(ima1006) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="3"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1006
                 NEXT FIELD ima1006
               WHEN INFIELD(ima1007) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="4"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1007
                 NEXT FIELD ima1007
               WHEN INFIELD(ima1008) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="5"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1008
                 NEXT FIELD ima1008
               WHEN INFIELD(ima1009) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1 ="6"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1009
                 NEXT FIELD ima1009
          END CASE
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION controlg      
         CALL cl_cmdask()     
      
      ON ACTION help          
         CALL cl_show_help()  
 
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    INPUT l_unit,l_method,l_percent,l_sum WITHOUT DEFAULTS FROM e,f,g,h
 
       BEFORE FIELD e
         CALL cl_set_comp_entry("g",TRUE)
         CALL cl_set_comp_entry("h",TRUE)
         LET l_percent = ''
         LET l_sum     = ''
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(e)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gfe"
              LET g_qryparam.default1 = l_unit
              CALL cl_create_qry() RETURNING l_unit
              DISPLAY l_unit TO FORMONLY.e
              NEXT FIELD e
          OTHERWISE EXIT CASE
         END CASE
 
       ON CHANGE f
         IF l_method='1' THEN
            CALL cl_set_comp_entry("h",FALSE)
            CALL cl_set_comp_entry("g",TRUE)
            NEXT FIELD g
         ELSE
            CALL cl_set_comp_entry("g",FALSE)
            CALL cl_set_comp_entry("h",TRUE)
            NEXT FIELD h
         END IF
 
       AFTER FIELD g
         IF NOT cl_null(l_percent) THEN
            IF l_percent = 0 THEN
               CALL cl_err('','atm-241',0)
               NEXT FIELD g
            END IF
         END IF
 
       AFTER FIELD h
         IF NOT cl_null(l_sum) THEN  
            CALL cl_digcut(l_sum,t_azi03) RETURNING l_sum   # MOD-AC0064                                                       
            DISPLAY l_sum TO h                                 # MOD-AC0064           
            IF l_sum <= 0 THEN
               CALL cl_err('','mfg9243',0)
               NEXT FIELD h
            END IF
         END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       
       ON ACTION about         
          CALL cl_about()      
       
       ON ACTION controlg      
          CALL cl_cmdask()     
       
       ON ACTION help          
          CALL cl_show_help()  
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW i227_w1
     END IF
 
       LET l_sql = " SELECT tqn02,tqn03,tqn04,tqn05 ",
                   "   FROM tqn_file,ima_file ",
                   "  WHERE tqn03=ima01 AND tqn01='",g_tqm.tqm01,"'",
                   "    AND ",g_wc4 CLIPPED
       PREPARE tqn02_prepare FROM  l_sql
       DECLARE tqn02_cs SCROLL CURSOR WITH HOLD FOR tqn02_prepare
       FOREACH tqn02_cs INTO l_tqn02,l_tqn03,l_tqn04,l_tqn05
         IF STATUS THEN
            EXIT FOREACH
         END IF
         SELECT ima25,ima31,ima31_fac INTO l_ima25,l_ima31,l_ima31_fac
           FROM ima_file
          WHERE ima01=l_tqn03
 
         IF l_method = '1' THEN
            IF NOT cl_null(l_tqn02) AND NOT cl_null(l_percent) THEN  #按百分比調IF
              IF l_tqn04 =l_unit THEN
#存在與INPUT相同的單位，則調整此產品（包括銷售單位和庫存單位）單價
                  UPDATE  tqn_file
                     SET  tqn05=(1+l_percent/100)*tqn05
                   WHERE  tqn01=g_tqm.tqm01
                     AND  tqn03 = l_tqn03
                     AND  tqn02 = l_tqn02
                IF g_azw.azw04 = '2' THEN   
                  UPDATE tqn_file
                     SET  tqn09=tqn05*100/tqn08
                   WHERE  tqn01=g_tqm.tqm01
                     AND  tqn03 = l_tqn03
                     AND  tqn02 = l_tqn02
                     AND  tqn08 <> 0
                END IF
              ELSE
               	CONTINUE FOREACH
              END IF
            END IF
         ELSE
       	    IF NOT cl_null(l_tqn02) AND NOT cl_null(l_sum) THEN  #按金額調整
       	        IF l_ima31=l_unit  THEN
 #存在與INPUT的相同的單位并且為銷售單位,若對應庫存單位的單身亦存在要更新
                  LET t_tqn05 = l_sum
                  LET t_tqn05 = cl_digcut(t_tqn05,t_azi03)
       	          UPDATE  tqn_file
                     SET  tqn05=t_tqn05    #No.MOD-820125
                   WHERE  tqn01=g_tqm.tqm01
                     AND  tqn03=l_tqn03
                     AND  tqn04=l_ima31
                IF g_azw.azw04 = '2' THEN  
                  UPDATE tqn_file
                     SET  tqn09=l_sum*100/tqn08
                   WHERE  tqn01=g_tqm.tqm01
                     AND  tqn03=l_tqn03
                     AND  tqn04=l_ima31
                     AND  tqn08 <> 0
                END IF
 
                  LET t_tqn05 = l_sum/l_ima31_fac
                  LET t_tqn05 = cl_digcut(t_tqn05,t_azi03) 
                  UPDATE  tqn_file
                     SET  tqn05=t_tqn05           #No.MOD-820125
                   WHERE  tqn01=g_tqm.tqm01
                     AND  tqn03=l_tqn03
                     AND  tqn04=l_ima25
                IF g_azw.azw04= '2' THEN     
                  UPDATE tqn_file
                     SET  tqn09=(l_sum/l_ima31_fac)*100/tqn08
                   WHERE  tqn01=g_tqm.tqm01
                     AND  tqn03=l_tqn03
                     AND  tqn04=l_ima25
                     AND  tqn08 <> 0
                END IF
 
       	        ELSE
       	          IF l_ima25=l_unit THEN   #存在與INPUT的相同的單位并且為庫存單位
                     LET t_tqn05 = l_sum
                     LET t_tqn05 = cl_digcut(t_tqn05,t_azi03)
       	             UPDATE  tqn_file
                        SET  tqn05=t_tqn05 #No.MOD-820125
                      WHERE  tqn01=g_tqm.tqm01
                        AND  tqn03=l_tqn03
                        AND  tqn04=l_ima25
                IF g_azw.azw04= '2' THEN             
                     UPDATE  tqn_file
                        SET  tqn09=l_sum*100/tqn08
                      WHERE  tqn01=g_tqm.tqm01
                        AND  tqn03=l_tqn03
                        AND  tqn04=l_ima25
                        AND  tqn08 <> 0
                END IF
 
                      LET t_tqn05 = l_sum*l_ima31_fac
                      LET t_tqn05 = cl_digcut(t_tqn05,t_azi03) 
                      UPDATE tqn_file
                        SET  tqn05=t_tqn05             #No.MOD-820125
                      WHERE  tqn01=g_tqm.tqm01
                        AND  tqn03=l_tqn03
                        AND  tqn04=l_ima31
                IF g_azw.azw04= '2' THEN              
                     UPDATE  tqn_file
                        SET  tqn09=l_sum*l_ima31_fac*100/tqn08
                      WHERE  tqn01=g_tqm.tqm01
                        AND  tqn03=l_tqn03
                        AND  tqn04=l_ima31
                        AND  tqn08 <> 0
                END IF
 
       	          ELSE
       	              CONTINUE FOREACH
       	          END IF	
       	        END IF
  	     ELSE
       	        CONTINUE FOREACH
             END IF
          END IF
   END FOREACH
 
   CALL i227_b_fill(g_wc2)     #填充單身
   EXIT WHILE
  END WHILE
   CLOSE WINDOW i227_w2                #結束畫面
END FUNCTION
 
FUNCTION i227_check()
DEFINE l_tqn06           LIKE tqn_file.tqn06,
       l_tqn07           LIKE tqn_file.tqn07,
       l_min06           LIKE tqn_file.tqn06,
       l_max07           LIKE tqn_file.tqn07,
       l_sql             LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(400)
DEFINE l_n               LIKE type_file.num5          #No.TQC-7B0118
 
            LET g_errno = NULL
            #判斷生效失效日期是否符合條件
            LET l_sql = " SELECT tqn06,tqn07 FROM tqn_file ",     #No.TQC-7B0118
                        "  WHERE tqn01 = '",g_tqm.tqm01,"'",
                        "    AND tqn03 = '",g_tqn[l_ac].tqn03,"'",
                        "    AND tqn04 = '",g_tqn[l_ac].tqn04,"'",   #TQC-640083
                        "    AND tqn02 != '",g_tqn[l_ac].tqn02,"'",
                        "  GROUP BY tqn06,tqn07  "
            PREPARE i227_precount1 FROM l_sql
            IF SQLCA.sqlcode THEN
               LET g_errno = SQLCA.sqlcode USING '-------' RETURN
            END IF
            DECLARE i227_count1 CURSOR FOR i227_precount1
            SELECT MIN(tqn06),MAX(tqn07) INTO l_min06,l_max07 FROM tqn_file
             WHERE tqn01 = g_tqm.tqm01
               AND tqn03 = g_tqn[l_ac].tqn03
               AND tqn04 = g_tqn[l_ac].tqn04
               AND tqn02<> g_tqn[l_ac].tqn02
 
            IF cl_null(l_min06) AND cl_null(l_max07) THEN     #沒有日期邊界限制，就沒有必要再判斷了
               LET g_errno=NULL
               RETURN
            END IF
            IF cl_null(g_tqn[l_ac].tqn07) THEN
               IF cl_null(l_max07) THEN
                  SELECT COUNT(*) INTO l_n FROM tqn_file WHERE tqn03 =g_tqn[l_ac].tqn03
                  IF l_n >0  THEN   #單身第一筆資料無需做此判斷
                     LET g_errno='atm-229'
                     RETURN
                  END IF
               ELSE
                  IF g_tqn[l_ac].tqn06 <=l_max07 THEN              #No.TQC-7C0138
                     LET g_errno='atm-229'
                     RETURN
                  END IF                                           #No.TQC-7C0138
               END IF
            ELSE
               FOREACH i227_count1 INTO l_tqn06,l_tqn07
                 IF g_tqn[l_ac].tqn07 < l_min06 THEN
                      LET g_errno=null
                      RETURN
                 END IF
                 IF cl_null(l_tqn07) THEN
                    LET l_tqn07 ='9999/12/30'
                 END IF
                 IF NOT(g_tqn[l_ac].tqn07 < l_tqn06 OR g_tqn[l_ac].tqn06 > l_tqn07) THEN
                      LET g_errno='atm-229'
                      RETURN
                 END IF
               END FOREACH
            END IF
 
 
 
END FUNCTION
 
FUNCTION i227_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_sql     LIKE type_file.chr1000
 
   IF cl_null(g_tqm.tqm01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_tqm.tqmacti <> 'Y' THEN
      CALL cl_err(g_tqm.tqm01,'aoo-090',1)
      RETURN
   END IF
   #input data center
   LET g_gev04 = NULL
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file
    WHERE gev01 = '7' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
   IF cl_null(g_gev04) THEN RETURN END IF
 
 
   #開窗選擇拋轉的db清單
   LET l_sql = "SELECT COUNT(*) FROM &tqm_file WHERE tqm01='",g_tqm.tqm01,"'"
   CALL s_dc_sel_db1(g_gev04,'7',l_sql)
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL g_tqmx.clear()
   LET g_tqmx[1].sel = 'Y'
   LET g_tqmx[1].tqm01 = g_tqm.tqm01
   IF cl_null(g_wc2) THEN LET g_wc2 = ' 1=1' END IF
   FOR l_i = 1 TO g_azp1.getLength()
       LET g_azp[l_i].sel   = g_azp1[l_i].sel
       LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
       LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
       LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
   END FOR
 
   CALL s_showmsg_init()
   CALL s_atmp227_carry_tqm(g_tqmx,g_azp,g_gev04,g_wc2,'0')  #No.FUN-830090
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION i227_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
  DEFINE l_j          LIKE type_file.num10
 
   IF cl_null(g_tqm.tqm01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL g_tqmx.clear()
   FOR l_i = 1 TO g_tqm_l.getLength()
       LET g_tqmx[l_i].sel   = 'Y'
       LET g_tqmx[l_i].tqm01 = g_tqm_l[l_i].tqm01
   END FOR
   CALL s_atmp227_download(g_tqmx,g_wc2)
 
END FUNCTION

FUNCTION i227_out()        # FUN-A60077
   DEFINE l_name    LIKE type_file.chr20,                
#         l_time          LIKE type_file.chr8       
          l_sql     LIKE type_file.chr1000,                   
          l_chr        LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,       
          
          sr               RECORD 
                                  tqm01    LIKE tqm_file.tqm01,
                                  tqm02    LIKE tqm_file.tqm02,
                                  tqm05    LIKE tqm_file.tqm05,
                                  azi02    LIKE azi_file.azi02,
                                  tqm06    LIKE tqm_file.tqm06,
                                  tqm04    LIKE tqm_file.tqm04,
                                  tqn03    LIKE tqn_file.tqn03,  
                                  ima02    LIKE ima_file.ima02,
                                  tqn04    LIKE tqn_file.tqn04,
                                  tqn08    LIKE tqn_file.tqn08,
                                  tqn09    LIKE tqn_file.tqn09,
                                  tqn05    LIKE tqn_file.tqn05,
                                  tqn10    LIKE tqn_file.tqn10,
                                  tqn06    LIKE tqn_file.tqn06,
                                  tqn07    LIKE tqn_file.tqn07
                        END RECORD
     IF cl_null(g_wc) THEN
       LET g_wc=" tqm01='",g_tqm.tqm01,"'"
       LET g_wc2=" 1=1 "
    END IF   
    LET g_str=''    
    CALL cl_del_data(l_table)                               
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog  
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('toluser', 'tolgrup')
 
     LET g_sql = "SELECT  tqm01,tqm02,tqm05,azi02,tqm06,tqm04,tqn03,ima02, ",
                 "tqn04,tqn08,tqn09,tqn05,tqn10,tqn06,tqn07 ",
                 "  FROM tqm_file,tqn_file,ima_file,azi_file ",
                 " where tqm01=tqn01 AND tqn03=ima01 AND tqm05=azi01 ",
                 " AND ", g_wc," AND ",g_wc2 CLIPPED
   PREPARE r227_prepare1 FROM g_sql

   DECLARE r227_curs1 CURSOR FOR r227_prepare1
 
    FOREACH r227_curs1 INTO sr.*
      IF STATUS != 0 THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
       EXECUTE insert_prep USING  sr.tqm01,sr.tqm02,
                     sr.tqm05,sr.azi02,sr.tqm06,sr.tqm04,                                                                       
                     sr.tqn03 ,sr.ima02,sr.tqn04,sr.tqn08,
                     sr.tqn09,sr.tqn05,sr.tqn10,sr.tqn06,sr.tqn07    
      END FOREACH  
     CLOSE r227_curs1
      ERROR ""
      LET g_str=g_wc 
      LET g_sql=" SELECT * FROM ",g_cr_db_str  CLIPPED,l_table CLIPPED
      
     CALL cl_prt_cs1('atmi227','atmi227',g_sql,g_str)

END FUNCTION
#MOD-AC0221
