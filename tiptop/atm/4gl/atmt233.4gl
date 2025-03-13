# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmt233.4gl
# Descriptions...: 提案維護作業
# Date & Author..: 206/01/09 By Elva
# Modify.........: NO:TQC-630072 06/03/07 By Melody 指定單據編號、執行功能(g_argv2)
# Modify.........: NO:FUN-590083 06/03/31 By Alexstar 新增資料多語言顯示功能 
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No:FUN-660104 06/06/19 By cl  Error Message  調整
# Modify.........: No:TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No:FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No:FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No:FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No:FUN-690025 06/09/20 By jamie 改判斷狀況碼ima1010、occ1004
# Modify.........: No:FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No:FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No:FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No:FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No:FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:TQC-6C0217 06/12/30 By Rayven SQL語句有誤，導致選不出資料
# Modify.........: No:TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:TQC-740324 07/04/26 By Elva 功能改善
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:TQC-7C0080 07/12/08 By Judy  1.進入單身時,活動方式描述被清空
#                                                  2.檢查料件單身的單位對庫存單位是否存在轉換率 
# Modify.........: No:TQC-810026 08/01/08 By chenl 若更改促銷日期后,相應折扣日期自動更新.
# Modify.........: No:FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No:FUN-840042 08/04/17 By TSD.liquor 自定欄位功能修改
# Modify.........: No:MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No:TQC-940097 09/05/08 By mike 復制 最后應該可以修改新資料的單身，然后顯示舊資料
# Modify.........: No:TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No:FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-980059 09/09/09 By arman GP5.2架構,修改SUB傳入相關參數
# Modify.........: No:FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A40055 10/02/27 by fumk 将多单身作业的construct和display array 改为DIALOG写法
# Modify.........: No:FUN-A50102 10/06/11 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No:FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No:TQC-AB0285 10/11/30 By shenyang GP5.2 SOP流程修改
# Modify.........: No:FUN-AB0034 11/12/10 By wujie    q_tqa1开窗使用的p_qry错误
# Modify.........: No:MOD-AC0171 10/12/29 By shiwuying 新增時會重複產生tsa_file
# Modify.........: No:TQC-AC0393 10/12/29 By lilingyu 查詢時,狀態page中"資料建立者,資料建立部門"無法下查詢條件
# Modify.........: No:MOD-B30248 11/03/17 By Summer 修改促銷進價後,需重計標準特售毛利,修改正常進價後,需重計正常銷售毛利 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BB0086 11/12/26 By tanxc 增加數量欄位小數取位 
# Modify.........: No:MOD-C30110 12/03/09 By yangxf 添加error message code atm-114
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-CC0123 12/12/26 By qirl 點擊生效進入界面輸入完門店資料後，點擊右側【退出】功能鈕還是會將該資料生效，帶出顯示生效日期。
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_tqx           RECORD LIKE tqx_file.*,       #提案單   (假單頭)
    g_tqx_t         RECORD LIKE tqx_file.*,       #提案單   (舊值)
    g_tqx_o         RECORD LIKE tqx_file.*,       #提案單   (舊值)
    g_tqx01_t       LIKE tqx_file.tqx01,          #Proj No.     (舊值)
    g_tqy           DYNAMIC ARRAY OF RECORD          #程式變數(ProgVariables)
                          tqy02      LIKE tqy_file.tqy02,
                          tqy36      LIKE tqy_file.tqy36,
                          tqy03      LIKE tqy_file.tqy03,
                          occ02      LIKE occ_file.occ02,
                          tqy04      LIKE tqy_file.tqy04,
                          tqa02_c    LIKE tqa_file.tqa02,
                          tqy07      LIKE tqy_file.tqy07,
                          tqa02_d    LIKE tqa_file.tqa02,
                          tqy05      LIKE tqy_file.tqy05,
                          too02      LIKE too_file.too02,
                          tqy06      LIKE tqy_file.tqy06,
                          top02      LIKE top_file.top02,
                          tqy37      LIKE tqy_file.tqy37,
                          tqy38      LIKE tqy_file.tqy38,
                          tqyud01 LIKE tqy_file.tqyud01,
                          tqyud02 LIKE tqy_file.tqyud02,
                          tqyud03 LIKE tqy_file.tqyud03,
                          tqyud04 LIKE tqy_file.tqyud04,
                          tqyud05 LIKE tqy_file.tqyud05,
                          tqyud06 LIKE tqy_file.tqyud06,
                          tqyud07 LIKE tqy_file.tqyud07,
                          tqyud08 LIKE tqy_file.tqyud08,
                          tqyud09 LIKE tqy_file.tqyud09,
                          tqyud10 LIKE tqy_file.tqyud10,
                          tqyud11 LIKE tqy_file.tqyud11,
                          tqyud12 LIKE tqy_file.tqyud12,
                          tqyud13 LIKE tqy_file.tqyud13,
                          tqyud14 LIKE tqy_file.tqyud14,
                          tqyud15 LIKE tqy_file.tqyud15
                       END RECORD,
    g_tqy_t         RECORD                 #程式變數 (舊值)
                          tqy02      LIKE tqy_file.tqy02,
                          tqy36      LIKE tqy_file.tqy36,
                          tqy03      LIKE tqy_file.tqy03,
                          occ02      LIKE occ_file.occ02,
                          tqy04      LIKE tqy_file.tqy04,
                          tqa02_c    LIKE tqa_file.tqa02,
                          tqy07      LIKE tqy_file.tqy07,
                          tqa02_d    LIKE tqa_file.tqa02,
                          tqy05      LIKE tqy_file.tqy05,
                          too02      LIKE too_file.too02,
                          tqy06      LIKE tqy_file.tqy06,
                          top02      LIKE top_file.top02,
                          tqy37      LIKE tqy_file.tqy37,
                          tqy38      LIKE tqy_file.tqy38,
                          tqyud01 LIKE tqy_file.tqyud01,
                          tqyud02 LIKE tqy_file.tqyud02,
                          tqyud03 LIKE tqy_file.tqyud03,
                          tqyud04 LIKE tqy_file.tqyud04,
                          tqyud05 LIKE tqy_file.tqyud05,
                          tqyud06 LIKE tqy_file.tqyud06,
                          tqyud07 LIKE tqy_file.tqyud07,
                          tqyud08 LIKE tqy_file.tqyud08,
                          tqyud09 LIKE tqy_file.tqyud09,
                          tqyud10 LIKE tqy_file.tqyud10,
                          tqyud11 LIKE tqy_file.tqyud11,
                          tqyud12 LIKE tqy_file.tqyud12,
                          tqyud13 LIKE tqy_file.tqyud13,
                          tqyud14 LIKE tqy_file.tqyud14,
                          tqyud15 LIKE tqy_file.tqyud15
                       END RECORD,
    g_tqy_o         RECORD                 #程式變數 (舊值)
                          tqy02      LIKE tqy_file.tqy02,
                          tqy36      LIKE tqy_file.tqy36,
                          tqy03      LIKE tqy_file.tqy03,
                          occ02      LIKE occ_file.occ02,
                          tqy04      LIKE tqy_file.tqy04,
                          tqa02_c    LIKE tqa_file.tqa02,
                          tqy07      LIKE tqy_file.tqy07,
                          tqa02_d    LIKE tqa_file.tqa02,
                          tqy05      LIKE tqy_file.tqy05,
                          too02      LIKE too_file.too02,
                          tqy06      LIKE tqy_file.tqy06,
                          top02      LIKE top_file.top02,
                          tqy37      LIKE tqy_file.tqy37,
                          tqy38      LIKE tqy_file.tqy38,
                          tqyud01 LIKE tqy_file.tqyud01,
                          tqyud02 LIKE tqy_file.tqyud02,
                          tqyud03 LIKE tqy_file.tqyud03,
                          tqyud04 LIKE tqy_file.tqyud04,
                          tqyud05 LIKE tqy_file.tqyud05,
                          tqyud06 LIKE tqy_file.tqyud06,
                          tqyud07 LIKE tqy_file.tqyud07,
                          tqyud08 LIKE tqy_file.tqyud08,
                          tqyud09 LIKE tqy_file.tqyud09,
                          tqyud10 LIKE tqy_file.tqyud10,
                          tqyud11 LIKE tqy_file.tqyud11,
                          tqyud12 LIKE tqy_file.tqyud12,
                          tqyud13 LIKE tqy_file.tqyud13,
                          tqyud14 LIKE tqy_file.tqyud14,
                          tqyud15 LIKE tqy_file.tqyud15
                       END RECORD,
    g_tqz           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          tqz02      LIKE tqz_file.tqz02,
                          tqz03      LIKE tqz_file.tqz03,
                          tqz031     LIKE tqz_file.tqz031,
                          ima021     LIKE ima_file.ima021,
                          ima1002    LIKE ima_file.ima1002,
                          ima135     LIKE ima_file.ima135,
                          tqz18      LIKE tqz_file.tqz18,
                          tqz04      LIKE tqz_file.tqz04,
                          tqz05      LIKE tqz_file.tqz05,
                          tqz06      LIKE tqz_file.tqz06,
                          tqz07      LIKE tqz_file.tqz07,
                          tqz08      LIKE tqz_file.tqz08,
                          tqz09      LIKE tqz_file.tqz09,
                          tqz11      LIKE tqz_file.tqz11,
                          tqz12      LIKE tqz_file.tqz12,
                          tqz13      LIKE tqz_file.tqz13,
                          tqz14      LIKE tqz_file.tqz14,
                          tqz15      LIKE tqz_file.tqz15,
                          tqz16      LIKE tqz_file.tqz16,
                          tqz17      LIKE tqz_file.tqz17, 
                          tqz10      LIKE tqz_file.tqz10,
                          tqa02_e    LIKE tqa_file.tqa02,
                          tqz19      LIKE tqz_file.tqz19,
                          tqz20      LIKE tqz_file.tqz20,
                          tqz21      LIKE tqz_file.tqz21,
                          tqzud01 LIKE tqz_file.tqzud01,
                          tqzud02 LIKE tqz_file.tqzud02,
                          tqzud03 LIKE tqz_file.tqzud03,
                          tqzud04 LIKE tqz_file.tqzud04,
                          tqzud05 LIKE tqz_file.tqzud05,
                          tqzud06 LIKE tqz_file.tqzud06,
                          tqzud07 LIKE tqz_file.tqzud07,
                          tqzud08 LIKE tqz_file.tqzud08,
                          tqzud09 LIKE tqz_file.tqzud09,
                          tqzud10 LIKE tqz_file.tqzud10,
                          tqzud11 LIKE tqz_file.tqzud11,
                          tqzud12 LIKE tqz_file.tqzud12,
                          tqzud13 LIKE tqz_file.tqzud13,
                          tqzud14 LIKE tqz_file.tqzud14,
                          tqzud15 LIKE tqz_file.tqzud15
                       END RECORD,
    g_tqz_t         RECORD
                          tqz02      LIKE tqz_file.tqz02,
                          tqz03      LIKE tqz_file.tqz03,
                          tqz031     LIKE tqz_file.tqz031,
                          ima021     LIKE ima_file.ima021,
                          ima1002    LIKE ima_file.ima1002,
                          ima135     LIKE ima_file.ima135,
                          tqz18      LIKE tqz_file.tqz18,
                          tqz04      LIKE tqz_file.tqz04,
                          tqz05      LIKE tqz_file.tqz05,
                          tqz06      LIKE tqz_file.tqz06,
                          tqz07      LIKE tqz_file.tqz07,
                          tqz08      LIKE tqz_file.tqz08,
                          tqz09      LIKE tqz_file.tqz09,
                          tqz11      LIKE tqz_file.tqz11,
                          tqz12      LIKE tqz_file.tqz12,
                          tqz13      LIKE tqz_file.tqz13,
                          tqz14      LIKE tqz_file.tqz14,
                          tqz15      LIKE tqz_file.tqz15,
                          tqz16      LIKE tqz_file.tqz16,
                          tqz17      LIKE tqz_file.tqz17, 
                          tqz10      LIKE tqz_file.tqz10,
                          tqa02_e    LIKE tqa_file.tqa02,
                          tqz19      LIKE tqz_file.tqz19,
                          tqz20      LIKE tqz_file.tqz20,
                          tqz21      LIKE tqz_file.tqz21,
                          tqzud01 LIKE tqz_file.tqzud01,
                          tqzud02 LIKE tqz_file.tqzud02,
                          tqzud03 LIKE tqz_file.tqzud03,
                          tqzud04 LIKE tqz_file.tqzud04,
                          tqzud05 LIKE tqz_file.tqzud05,
                          tqzud06 LIKE tqz_file.tqzud06,
                          tqzud07 LIKE tqz_file.tqzud07,
                          tqzud08 LIKE tqz_file.tqzud08,
                          tqzud09 LIKE tqz_file.tqzud09,
                          tqzud10 LIKE tqz_file.tqzud10,
                          tqzud11 LIKE tqz_file.tqzud11,
                          tqzud12 LIKE tqz_file.tqzud12,
                          tqzud13 LIKE tqz_file.tqzud13,
                          tqzud14 LIKE tqz_file.tqzud14,
                          tqzud15 LIKE tqz_file.tqzud15
                       END RECORD,
    g_tqz_o         RECORD
                          tqz02      LIKE tqz_file.tqz02,
                          tqz03      LIKE tqz_file.tqz03,
                          tqz031     LIKE tqz_file.tqz031,
                          ima021     LIKE ima_file.ima021,
                          ima1002    LIKE ima_file.ima1002,
                          ima135     LIKE ima_file.ima135,
                          tqz18      LIKE tqz_file.tqz18,
                          tqz04      LIKE tqz_file.tqz04,
                          tqz05      LIKE tqz_file.tqz05,
                          tqz06      LIKE tqz_file.tqz06,
                          tqz07      LIKE tqz_file.tqz07,
                          tqz08      LIKE tqz_file.tqz08,
                          tqz09      LIKE tqz_file.tqz09,
                          tqz11      LIKE tqz_file.tqz11,
                          tqz12      LIKE tqz_file.tqz12,
                          tqz13      LIKE tqz_file.tqz13,
                          tqz14      LIKE tqz_file.tqz14,
                          tqz15      LIKE tqz_file.tqz15,
                          tqz16      LIKE tqz_file.tqz16,
                          tqz17      LIKE tqz_file.tqz17, 
                          tqz10      LIKE tqz_file.tqz10,
                          tqa02_e    LIKE tqa_file.tqa02,
                          tqz19      LIKE tqz_file.tqz19,
                          tqz20      LIKE tqz_file.tqz20,
                          tqz21      LIKE tqz_file.tqz21,
                          tqzud01 LIKE tqz_file.tqzud01,
                          tqzud02 LIKE tqz_file.tqzud02,
                          tqzud03 LIKE tqz_file.tqzud03,
                          tqzud04 LIKE tqz_file.tqzud04,
                          tqzud05 LIKE tqz_file.tqzud05,
                          tqzud06 LIKE tqz_file.tqzud06,
                          tqzud07 LIKE tqz_file.tqzud07,
                          tqzud08 LIKE tqz_file.tqzud08,
                          tqzud09 LIKE tqz_file.tqzud09,
                          tqzud10 LIKE tqz_file.tqzud10,
                          tqzud11 LIKE tqz_file.tqzud11,
                          tqzud12 LIKE tqz_file.tqzud12,
                          tqzud13 LIKE tqz_file.tqzud13,
                          tqzud14 LIKE tqz_file.tqzud14,
                          tqzud15 LIKE tqz_file.tqzud15
                       END RECORD,
    g_gec04            LIKE gec_file.gec04,
    g_azp03            LIKE azp_file.azp03,
    g_tqz2             RECORD LIKE tqz_file.*,
    g_tqx17            LIKE tqx_file.tqx17,
    g_tqm01            LIKE tqm_file.tqm01,
    g_flag             LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
    g_flag1            LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
    g_argv1            LIKE tqx_file.tqx01,          # 提案單號
    g_rec_b,g_rec_b2   LIKE type_file.num5,          # 單身筆數        #No.FUN-680120 SMALLINT
    l_tqz01            LIKE tqz_file.tqz01,                                  
    l_tqy03            LIKE tqy_file.tqy03,                                  
    l_ima135           LIKE ima_file.ima135,
    l_ac               LIKE type_file.num5,             # 目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
    a                  LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    b                  LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    c                  LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    g_t1               LIKE oay_file.oayslip,           # 單別        #No.FUN-680120 VARCHAR(5)
    g_wc,g_wc2,g_wc3   LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(300)
    g_sql              LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(500)
 
#主程式開始
DEFINE  g_cnt           LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE  p_cnt           LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE  p_flag          LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
DEFINE  g_i             LIKE type_file.num5             #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE  g_j             LIKE type_file.num5             #No.FUN-680120 SMALLINT  #count/index for any purpose
DEFINE  g_msg           LIKE type_file.chr1000          #No.FUN-680120 VARCHAR(72)
DEFINE  g_row_count     LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE  g_curs_index    LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE  g_jump          LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5             #No.FUN-680120 SMALLINT
DEFINE  p_row,p_col     LIKE type_file.num5             #No.FUN-680120 SMALLINT
DEFINE  g_forupd_sql    STRING   #SELECT ... FOR UPDATE  SQL
DEFINE  g_before_input_done  LIKE type_file.num5        #No.FUN-680120 SMALLINT
DEFINE  g_b_flag        STRING                          #No.FUN-A40055
DEFINE g_argv2  STRING              #No.TQC-630072
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_forupd_sql = "SELECT * FROM tqx_file  WHERE tqx01 = ? ",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t233_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW t233_w AT 2,2 WITH FORM "atm/42f/atmt233"
   ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2) #..No.TQC-630072
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t233_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t233_a()
            END IF
         OTHERWISE
               CALL t233_q()
      END CASE
   END IF
 
   CALL t233_menu()
 
   CLOSE WINDOW t233_w                 # 結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION t233_cs()
DEFINE    l_type          LIKE aba_file.aba18          #No.FUN-680120 VARCHAR(2)
   CLEAR FORM                             #清除畫面
   CALL g_tqy.clear()
   CALL g_tqz.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" tqx01='",g_argv1 CLIPPED,"'"
      LET g_wc2=" 1=1 "
      LET g_wc3=" 1=1 "
   ELSE
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tqx.* TO NULL    #No.FUN-750051
   #No.FUN-A40055--begin
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON
         tqx01,tqx02,tqx12,tqx13,
         tqx03,tqx04,tqx05,tqx06,
         tqx08,tqx14,tqx15,tqx16,
         tqx09,tqx07,tqx10,tqx11,
         tqxuser,tqxgrup,
         tqxoriu,tqxorig,         #TQC-AC0393 
         tqxmodu,tqxdate,tqxacti,
         tqxud01,tqxud02,tqxud03,tqxud04,tqxud05,
         tqxud06,tqxud07,tqxud08,tqxud09,tqxud10,
         tqxud11,tqxud12,tqxud13,tqxud14,tqxud15
      END CONSTRUCT  
       
      CONSTRUCT g_wc2 ON tqy02,tqy36,tqy03,tqy04,tqy07,
                         tqy05,tqy06,tqy37,tqy38
                         ,tqyud01,tqyud02,tqyud03,tqyud04,tqyud05
                         ,tqyud06,tqyud07,tqyud08,tqyud09,tqyud10
                         ,tqyud11,tqyud12,tqyud13,tqyud14,tqyud15
                    FROM s_tqy[1].tqy02,s_tqy[1].tqy36,
                         s_tqy[1].tqy03,s_tqy[1].tqy04,
                         s_tqy[1].tqy07,s_tqy[1].tqy05,
                         s_tqy[1].tqy06,s_tqy[1].tqy37,
                         s_tqy[1].tqy38
                         ,s_tqy[1].tqyud01,s_tqy[1].tqyud02,
                          s_tqy[1].tqyud03,s_tqy[1].tqyud04,s_tqy[1].tqyud05
                         ,s_tqy[1].tqyud06,s_tqy[1].tqyud07,
                          s_tqy[1].tqyud08,s_tqy[1].tqyud09,s_tqy[1].tqyud10
                         ,s_tqy[1].tqyud11,s_tqy[1].tqyud12,
                          s_tqy[1].tqyud13,s_tqy[1].tqyud14,s_tqy[1].tqyud15    
      END CONSTRUCT
      
      CONSTRUCT g_wc3 ON tqz02,tqz03,tqz031,tqz18,tqz04,tqz05,
                         tqz06,tqz07,tqz08,tqz09,
                         tqz11,tqz12,tqz13,tqz14,
                         tqz15,tqz16,tqz17,tqz10,
                         tqz19,tqz20,tqz21
                         ,tqzud01,tqzud02,tqzud03,tqzud04,tqzud05
                         ,tqzud06,tqzud07,tqzud08,tqzud09,tqzud10
                         ,tqzud11,tqzud12,tqzud13,tqzud14,tqzud15
                    FROM s_tqz[1].tqz02,s_tqz[1].tqz03,s_tqz[1].tqz031,
                         s_tqz[1].tqz18,s_tqz[1].tqz04,s_tqz[1].tqz05,
                         s_tqz[1].tqz06,s_tqz[1].tqz07,
                         s_tqz[1].tqz08,s_tqz[1].tqz09,
                         s_tqz[1].tqz11,s_tqz[1].tqz12,
                         s_tqz[1].tqz13,s_tqz[1].tqz14,
                         s_tqz[1].tqz15,s_tqz[1].tqz16,
                         s_tqz[1].tqz17,s_tqz[1].tqz10,
                         s_tqz[1].tqz19,s_tqz[1].tqz20,
                         s_tqz[1].tqz21
                         ,s_tqz[1].tqzud01,s_tqz[1].tqzud02,
                          s_tqz[1].tqzud03,s_tqz[1].tqzud04,s_tqz[1].tqzud05
                         ,s_tqz[1].tqzud06,s_tqz[1].tqzud07,
                          s_tqz[1].tqzud08,s_tqz[1].tqzud09,s_tqz[1].tqzud10
                         ,s_tqz[1].tqzud11,s_tqz[1].tqzud12,
                          s_tqz[1].tqzud13,s_tqz[1].tqzud14,s_tqz[1].tqzud15
      END CONSTRUCT 
                         
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(tqx01) # 提案編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tqx"
               LET g_qryparam.default1 = g_tqx.tqx01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqx01
            WHEN INFIELD(tqx12) # 提案機構                                  
               CALL cl_init_qry_var()                                           
               LET g_qryparam.state = "c"                                       
               LET g_qryparam.form ="q_tqb"                                  
               LET g_qryparam.default1 = g_tqx.tqx12                     
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO tqx12 
            WHEN INFIELD(tqx13) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_tqa1"
               LET g_qryparam.form ="q_tqa"    #No.FUN-AB0034
               LET g_qryparam.default1 = g_tqx.tqx13
               LET g_qryparam.arg1 ="20" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqx13
            WHEN INFIELD(tqx03) # 活動類型
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_tqa1"
               LET g_qryparam.form ="q_tqa"    #No.FUN-AB0034
               LET g_qryparam.default1 = g_tqx.tqx03
               LET g_qryparam.arg1 ="15" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqx03
            WHEN INFIELD(tqx04) # 檔期類型
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_tqa1"
               LET g_qryparam.form ="q_tqa"    #No.FUN-AB0034
               LET g_qryparam.default1 = g_tqx.tqx04
               LET g_qryparam.arg1 ="17" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqx04
            WHEN INFIELD(tqx08) # 稅種
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form  ="q_gec"
               LET g_qryparam.default1 = g_tqx.tqx08
               LET g_qryparam.arg1  ="2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqx08
            WHEN INFIELD(tqx09) # 幣種
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_tqx.tqx09
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqx09
            WHEN INFIELD(tqy03) # 門店代碼
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_occ8"
               LET g_qryparam.arg1 = g_dbs
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqy03
               NEXT FIELD tqy03
            WHEN INFIELD(tqy04) # 系統碼
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tqy1"
               LET g_qryparam.arg1 =g_tqx.tqx01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqy04
               NEXT FIELD tqy04
             WHEN INFIELD(tqy07) # 系統區域碼
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tqy2"
               LET g_qryparam.arg1 =g_tqx.tqx01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqy07
               NEXT FIELD tqy07  
              WHEN INFIELD(tqz03)  # 產品編號
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.form ="q_ima15"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima15","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO tqz03
                  NEXT FIELD tqz03
              WHEN INFIELD(tqz08)  # 單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gfe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqz08
                  NEXT FIELD tqz08
              WHEN INFIELD(tqz10)  #活動方式
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_tqa1"
                  LET g_qryparam.arg1 ="18"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqz10
                  NEXT FIELD tqz10   
            OTHERWISE EXIT CASE
         END CASE  
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about         #BUG-4C0121
            CALL cl_about()      #BUG-4C0121
 
         ON ACTION help          #BUG-4C0121
            CALL cl_show_help()  #BUG-4C0121
 
         ON ACTION controlg      #BUG-4C0121
            CALL cl_cmdask()     #BUG-4C0121
     
         ON ACTION accept
            EXIT DIALOG

         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG 
          
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG      
      END DIALOG 
      #No.FUN-A40055--end
      #資料權限的檢查
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqxuser', 'tqxgrup')
      IF cl_null(g_wc2) THEN
          # 客戶資料查詢
      LET g_wc2 = " 1=1"
      END IF
      IF cl_null(g_wc3) THEN
         # 料件資料查詢
      LET g_wc3 = " 1=1"
      END IF
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         RETURN 
      END IF
   END IF                   
   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT  tqx01 FROM tqx_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY tqx01 "
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE  tqx01 ",
                     "  FROM tqx_file, tqy_file ",
                     " WHERE tqx01 = tqy01",
                     "   AND ", g_wc  CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     " ORDER BY tqx01 "
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT UNIQUE  tqx01 ",
                     "  FROM tqx_file,tqz_file ",
                     " WHERE tqx01 = tqz01   ",
                     "   AND ", g_wc  CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY tqx01 "
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE  tqx01 ",
                     "  FROM tqx_file, tqy_file,tqz_file ",
                     " WHERE tqx01 = tqy01  ",
                     "   AND tqx01 = tqz01 ",
                     "   AND ", g_wc  CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY tqx01 "
      END IF
   END IF
 
   PREPARE t233_prepare FROM g_sql
   DECLARE t233_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t233_prepare
 
   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(*) FROM tqx_file WHERE ",g_wc CLIPPED 
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT tqx01) ",
                   "  FROM tqx_file,tqy_file   ",
                   " WHERE tqy01 = tqx01     ",
                   "   AND ",g_wc  CLIPPED,
                   "   AND ",g_wc2 CLIPPED 
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(DISTINCT tqx01) ",
                   "  FROM tqx_file,tqz_file   ",
                   " WHERE tqx01 = tqz01     ",
                   "   AND ",g_wc  CLIPPED,     
                   "   AND ",g_wc3 CLIPPED 
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT tqx01) ",
                   "  FROM tqx_file,tqy_file,tqz_file  ",
                   " WHERE tqy01 = tqx01 ",
                   "   AND tqx01 = tqz01 ",
                   "   AND ",g_wc  CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   "   AND ",g_wc3 CLIPPED 
      END IF
   END IF
   PREPARE t233_precount FROM g_sql
   DECLARE t233_count CURSOR FOR t233_precount
END FUNCTION
 
FUNCTION t233_menu()
 
   WHILE TRUE
      CALL t233_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL t233_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL t233_q() 
            END IF 
         WHEN "delete" 
            IF cl_chk_act_auth() THEN 
               CALL t233_r() 
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN 
               CALL t233_u() 
            END IF
         WHEN "output"
           #LET g_msg = "atmr233 '",g_tqx.tqx01 CLIPPED,"' " CLIPPED #FUN-C30085 
            LET g_msg = "atmg233 '",g_tqx.tqx01 CLIPPED,"' " CLIPPED #FUN-C30085 
            CALL cl_cmdrun(g_msg)
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t233_copy()
            END IF
         WHEN "detail"   #產品資料
            IF cl_chk_act_auth() THEN 
             #No.FUN-A40055--begin
               CASE g_b_flag
                   WHEN '1' CALL t233_b()
                   WHEN '2' CALL t233_b2()
               END CASE 
            ELSE    
               LET g_action_choice = NULL 
               #No.FUN-A40055--end  
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         #選擇客戶
         WHEN "choose_cust" 
            IF cl_chk_act_auth() THEN
               CALL t233_g_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #維護客戶
         WHEN "maintain_cust" 
            IF cl_chk_act_auth() THEN
               CALL t233_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.FUN-A40055--begin
#         WHEN "qry_cust_detail"                                                 
#            IF cl_chk_act_auth() THEN                                           
#               CALL t233_bp2('G')                                               
#            ELSE                                                                
#               LET g_action_choice = NULL                                       
#            END IF                                                              
         #No.FUN-A40055--end
         #選擇產品
         WHEN "choose_item" 
            IF cl_chk_act_auth() THEN
               CALL t233_g_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         #維護產品
         WHEN "maintain_item" 
            IF cl_chk_act_auth() THEN
               CALL t233_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         #明細資料
         WHEN "detail_data" 
            IF cl_chk_act_auth() THEN
               SELECT COUNT(*) INTO g_cnt FROM tsa_file
               WHERE tsa01=g_tqx.tqx01
               IF g_cnt=0 THEN
                  SELECT COUNT(*) INTO g_i FROM tqy_file
                  WHERE tqy01=g_tqx.tqx01
                  SELECT COUNT(*) INTO g_j FROM tqz_file
                  WHERE tqz01=g_tqx.tqx01
                  IF g_i>0 AND g_j>0 THEN
                     CALL t233_detail_d('p','',0,0) RETURNING g_errno
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_tqx.tqx01,g_errno,0)
                     END IF
                  END IF
               END IF
               CALL t233_1_detail(g_tqx.tqx01)
               SELECT * INTO g_tqx.* FROM tqx_file WHERE tqx01=g_tqx.tqx01
               CALL t233_show()
            ELSE
               LET g_action_choice = NULL
            END IF
         #費用資料
         WHEN "expense_detail" 
            IF cl_chk_act_auth() THEN
              CALL t233_2_detail(g_tqx.tqx01,'')
              SELECT * INTO g_tqx.* FROM tqx_file WHERE tqx01=g_tqx.tqx01
              CALL t233_show()
              LET INT_FLAG=0
            ELSE
               LET g_action_choice = NULL
            END IF
         #申請
         WHEN "apply_check" 
            IF cl_chk_act_auth() THEN 
               CALL t233_approving()
            END IF
         #取消申請
         WHEN "undo_check" 
            IF cl_chk_act_auth() THEN 
               CALL t233_unapproving()
            END IF
         #審核
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN 
               CALL t233_confirm()
            END IF
         #取消審核
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN 
               CALL t233_undo_confirm()
            END IF
         #生效
         WHEN "effect" 
            IF cl_chk_act_auth() THEN 
                CALL t233_effect()
            END IF
         #取消生效
         WHEN "undo_effect" 
            IF cl_chk_act_auth() THEN 
               CALL t233_undo_effect()
            END IF
         #結案
         WHEN "closing" 
            IF cl_chk_act_auth() THEN 
               CALL t233_close()
            END IF
         #取消結案
         WHEN "unclosing" 
            IF cl_chk_act_auth() THEN 
               CALL t233_unclose()
            END IF
         #挂起
         WHEN "pending" 
            IF cl_chk_act_auth() THEN 
               CALL t233_hold()
            END IF
         #取消挂起
         WHEN "undo_pending" 
            IF cl_chk_act_auth() THEN 
               CALL t233_unhold()
            END IF
         #作廢
         WHEN "void" 
            IF cl_chk_act_auth() THEN
               CALL t233_x()
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tqx.tqx01 IS NOT NULL THEN
                 LET g_doc.column1 = "tqx01"
                 LET g_doc.value1 = g_tqx.tqx01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t233_a()
DEFINE li_result    LIKE type_file.num5                  #No.FUN-680120 SMALLINT
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_tqy.clear()
   CALL g_tqz.clear()
 
   INITIALIZE g_tqx.* LIKE tqx_file.*             #DEFAULT 設定
   LET g_tqx01_t = NULL
 
   # 預設值及將數值類變數清成零
   LET g_tqx.tqx02 = g_today           #提案日期
   LET g_tqx.tqx07 = '1'               #狀態碼
   LET g_tqx.tqx17 = 0                 #總費用金額
   LET g_tqx.tqx18 = 0                 #總目標未稅金額
   LET g_tqx.tqx19 = 0                 #總目標含稅金額
   LET g_tqx.tqxuser = g_user
   LET g_tqx.tqxoriu = g_user #FUN-980030
   LET g_tqx.tqxorig = g_grup #FUN-980030
   LET g_data_plant = g_plant #FUN-980030
   LET g_tqx.tqxgrup = g_grup
   LET g_tqx.tqxdate = g_today
   LET g_tqx.tqxacti = 'Y'              #資料有效
   LET g_tqx_t.* = g_tqx.*
   LET g_tqx_o.* = g_tqx.*
   CALL cl_opmsg('a')
   WHILE TRUE
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_tqx.tqx01 = g_argv1
      END IF
 
      CALL t233_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_tqx.* TO NULL
         EXIT WHILE
      END IF
      IF g_tqx.tqx01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK 
      #CALL s_auto_assign_no("axm",g_tqx.tqx01,g_today,"01","tqx_file","tqx01","","","") #FUN-A70130
      CALL s_auto_assign_no("atm",g_tqx.tqx01,g_today,"U2","tqx_file","tqx01","","","") #FUN-A70130
           RETURNING li_result,g_tqx.tqx01
      IF (NOT li_result) THEN                                                   
         ROLLBACK WORK                                                          
         CONTINUE WHILE                                                         
      END IF
      DISPLAY BY NAME g_tqx.tqx01
      LET g_tqx.tqxplant = g_plant  #FUN-980009
      LET g_tqx.tqxlegal = g_legal  #FUN-980009
      INSERT INTO tqx_file VALUES (g_tqx.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104      #FUN-B80061    ADD
         ROLLBACK WORK  
        # CALL cl_err3("ins","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104     #FUN-B80061    MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL t233_sum()
         CALL cl_flow_notify(g_tqx.tqx01,'I')
      END IF
 
      SELECT tqx01 INTO g_tqx.tqx01 FROM tqx_file
       WHERE tqx01 = g_tqx.tqx01
      LET g_tqx01_t = g_tqx.tqx01        #保留舊值
      LET g_tqx_t.* = g_tqx.*
 
      LET g_rec_b=0                   #No.FUN-680064
      #是否要批量生成客戶資料
      IF cl_confirm('atm-022') THEN
         CALL t233_g_b()
      END IF
 
      # 輸入客戶資料
      CALL t233_b()                                 #輸入單身-1
 
      #是否要批量生成料件資料
      IF cl_confirm('atm-021') THEN
         CALL t233_g_b2()
      END IF
 
      # 輸入料件資料
      CALL t233_b2()                   #輸入單身-2
 
      # 批次生成提案明細資料
      CALL t233_detail_p()
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t233_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tqx.tqx01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_tqx.* FROM tqx_file
    WHERE tqx01 = g_tqx.tqx01
 
   #非開立狀態，不能修改
   IF g_tqx.tqx07 != '1' THEN
      CALL cl_err(g_tqx.tqx01,'atm-226',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tqx01_t = g_tqx.tqx01
   LET g_tqx_o.* = g_tqx.*
 
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t233_cl USING g_tqx.tqx01 
   IF STATUS THEN
      CALL cl_err("OPEN t233_cl.", STATUS, 1)
      CLOSE t233_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t233_cl INTO g_tqx.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t233_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t233_show()
   WHILE TRUE
      LET g_tqx01_t = g_tqx.tqx01
      LET g_tqx.tqxmodu = g_user
      LET g_tqx.tqxdate = g_today
      CALL t233_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_tqx.*=g_tqx_t.*
         CALL t233_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_tqx.tqx01 != g_tqx01_t THEN            # 更改單號
         UPDATE tqy_file SET tqy01 = g_tqx.tqx01
          WHERE tqy01 = g_tqx01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tqy_file",g_tqx01_t,"",SQLCA.sqlcode,"","upd tqy",1)   #No.FUN-660104
            CONTINUE WHILE
         END IF
 
         UPDATE tqz_file SET tqz01 = g_tqx.tqx01
          WHERE tqz01 = g_tqx01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tqz_file",g_tqx01_t,"",SQLCA.sqlcode,"","upd tqz",1)   #No.FUN-660104
            CONTINUE WHILE
         END IF
      END IF
 
      LET g_tqx.tqx07 = '1' 
      UPDATE tqx_file
         SET tqx_file.* = g_tqx.* WHERE tqx01 = g_tqx01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tqx_file",g_tqx01_t,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_tqx.tqx07
      EXIT WHILE
   END WHILE
 
   CLOSE t233_cl
 
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tqx.tqx01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#處理INPUT
FUNCTION t233_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入    #No.FUN-680120 VARCHAR(1)
    l_tqb02         LIKE tqb_file.tqb02,
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    p_cmd           LIKE type_file.chr1,          #a.輸入 u.更改            #No.FUN-680120 VARCHAR(1)
    li_result       LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
    DISPLAY BY NAME g_tqx.tqx07,g_tqx.tqx17,g_tqx.tqx18,g_tqx.tqx19,
                    g_tqx.tqxacti,g_tqx.tqxuser,g_tqx.tqxgrup,
                    g_tqx.tqxmodu,g_tqx.tqxdate
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_tqx.tqx01,g_tqx.tqx02,g_tqx.tqx12,  g_tqx.tqxoriu,g_tqx.tqxorig,
                  g_tqx.tqx13,g_tqx.tqx03,g_tqx.tqx04,
                  g_tqx.tqx05,g_tqx.tqx06,g_tqx.tqx08,
                  g_tqx.tqx09,g_tqx.tqx10,g_tqx.tqx11,
                  g_tqx.tqxud01,g_tqx.tqxud02,g_tqx.tqxud03,g_tqx.tqxud04,
                  g_tqx.tqxud05,g_tqx.tqxud06,g_tqx.tqxud07,g_tqx.tqxud08,
                  g_tqx.tqxud09,g_tqx.tqxud10,g_tqx.tqxud11,g_tqx.tqxud12,
                  g_tqx.tqxud13,g_tqx.tqxud14,g_tqx.tqxud15 
 
          WITHOUT DEFAULTS 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t233_set_entry(p_cmd)
           CALL t233_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD tqx01                  #提案編號
           IF NOT cl_null(g_tqx.tqx01) THEN
              #CALL s_check_no("axm",g_tqx.tqx01,g_tqx_t.tqx01,'01',"tqx_file","tqx01","") #FUN-A70130
              CALL s_check_no("atm",g_tqx.tqx01,g_tqx_t.tqx01,'U2',"tqx_file","tqx01","") #FUN-A70130
                   RETURNING li_result,g_tqx.tqx01
              IF (NOT li_result) THEN
                  NEXT FIELD tqx01
              END IF
 
              IF g_tqx.tqx01 != g_tqx_t.tqx01
                 OR cl_null(g_tqx_t.tqx01) THEN
                 SELECT count(*) INTO g_cnt FROM tqx_file
                 WHERE tqx01 = g_tqx.tqx01
                 IF g_cnt>0 THEN
                    CALL cl_err(g_tqx.tqx01,-239,0)
                    LET g_tqx.tqx01 = g_tqx_t.tqx01
                    DISPLAY BY NAME g_tqx.tqx01
                    NEXT FIELD tqx01
                 END IF
              END IF
           END IF
 
         AFTER FIELD tqx12        #提案機構
           IF NOT cl_null(g_tqx.tqx12) THEN
              IF g_tqx.tqx12 != g_tqx_o.tqx12 OR
                 cl_null(g_tqx_o.tqx12) THEN
                 CALL t233_tqx12(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tqx.tqx12,g_errno,0)
                    LET g_tqx.tqx12=g_tqx_o.tqx12
                    DISPLAY BY NAME g_tqx.tqx12
                    NEXT FIELD tqx12
                 END IF
              END IF
              LET g_tqx_o.tqx12 = g_tqx.tqx12
           END IF
 
        AFTER FIELD tqx13
           IF NOT cl_null(g_tqx.tqx13) THEN
              IF g_tqx.tqx13 != g_tqx_o.tqx13
                 OR cl_null(g_tqx_o.tqx13) THEN
                 SELECT COUNT(*) INTO g_cnt
                   FROM tqz_file
                  WHERE tqz01=g_tqx.tqx01
                 IF g_cnt > 0 THEN
                    CALL cl_err(g_tqx.tqx13,'atm-034',0)
                    LET g_tqx.tqx13=g_tqx_o.tqx13
                    DISPLAY BY NAME g_tqx.tqx13
                    NEXT FIELD tqx13
                 END IF
                 SELECT * FROM tqa_file
                  WHERE tqa01=g_tqx.tqx13 
                    AND tqa03='20'
                    AND tqaacti='Y'
                 IF STATUS = 100 THEN
                    CALL cl_err3("sel","tqa_file",g_tqx.tqx13,"","anm-027","","",1)   #No.FUN-660104
                    LET g_tqx.tqx13=g_tqx_o.tqx13
                    DISPLAY BY NAME g_tqx.tqx13
                    NEXT FIELD tqx13
                 END IF
              END IF
              LET g_tqx_o.tqx13 = g_tqx.tqx13
           END IF
           
        AFTER FIELD tqx03    #提案活動類別
           IF NOT cl_null(g_tqx.tqx03) THEN
              IF g_tqx.tqx03 != g_tqx_o.tqx03
                 OR cl_null(g_tqx_o.tqx03) THEN
                 CALL t233_tqa02(p_cmd,'',0)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tqx.tqx03,g_errno,0)
                    LET g_tqx.tqx03=g_tqx_o.tqx03
                    DISPLAY BY NAME g_tqx.tqx03
                    NEXT FIELD tqx03
                 END IF
              END IF
              LET g_tqx_o.tqx03 = g_tqx.tqx03
           END IF
 
        AFTER FIELD tqx04          #檔期類型
           IF NOT cl_null(g_tqx.tqx04) THEN
              IF g_tqx.tqx04 != g_tqx_o.tqx04
                 OR cl_null(g_tqx_o.tqx04) THEN
                 CALL t233_tqa02(p_cmd,'',0)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tqx.tqx04,g_errno,0)
                    LET g_tqx.tqx04=g_tqx_o.tqx04
                    DISPLAY BY NAME g_tqx.tqx04
                    NEXT FIELD tqx04
                 END IF
              END IF
              LET g_tqx_o.tqx04 = g_tqx.tqx04
           END IF  
 
        AFTER FIELD tqx08          #稅種
           IF NOT cl_null(g_tqx.tqx08) THEN
              IF g_tqx.tqx08 != g_tqx_o.tqx08
                 OR cl_null(g_tqx_o.tqx08) THEN
                 CALL t233_tqx08(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tqx.tqx08,g_errno,0)
                    LET g_tqx.tqx08=g_tqx_o.tqx08
                    DISPLAY BY NAME g_tqx.tqx08
                    NEXT FIELD tqx08
                 END IF
              END IF
              LET g_tqx_o.tqx08 = g_tqx.tqx08
           END IF     
 
        AFTER FIELD tqx09           #幣別
           IF NOT cl_null(g_tqx.tqx09) THEN
              IF g_tqx.tqx09 != g_tqx_o.tqx09
                 OR cl_null(g_tqx_o.tqx09) THEN
                 CALL t233_tqx09(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tqx.tqx09,g_errno,0)
                    LET g_tqx.tqx09=g_tqx_o.tqx09
                    DISPLAY BY NAME g_tqx.tqx09
                    NEXT FIELD tqx09
                 END IF
              END IF
              LET g_tqx_o.tqx09 = g_tqx.tqx09
           END IF   
        
        AFTER FIELD tqx10        
           IF NOT cl_null(g_tqx.tqx10) THEN
              IF g_tqx.tqx10<=0 THEN
                 CALL cl_err('','atm-373',0)
                 NEXT FIELD tqx10
              END IF
           END IF
           
        AFTER FIELD tqx11        
           IF NOT cl_null(g_tqx.tqx11) THEN
              IF g_tqx.tqx11<=0 THEN
                 CALL cl_err('','atm-373',0)
                 NEXT FIELD tqx11
              END IF
           END IF
 
        AFTER FIELD tqxud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqxud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,并要求重新輸入
           IF INT_FLAG THEN
              EXIT INPUT  
           END IF
 
        ON ACTION CONTROLP
           CASE 
              WHEN INFIELD(tqx01) #查詢單據
                 LET g_t1 = g_tqx.tqx01[1,g_doc_len]
                 CALL q_oay(FALSE,FALSE,g_t1,'U2','ATM') RETURNING g_t1   #TQC-670008   #FUN-A70130
                 LET g_tqx.tqx01 = g_t1
                 DISPLAY BY NAME g_tqx.tqx01
                 NEXT FIELD tqx01
              WHEN INFIELD(tqx12) # 提案機構
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_tqb"                                
                 LET g_qryparam.default1 = g_tqx.tqx12                   
                 CALL cl_create_qry() RETURNING g_tqx.tqx12              
                 DISPLAY BY NAME g_tqx.tqx12
              WHEN INFIELD(tqx13) 
                 CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_tqa1"
                 LET g_qryparam.form ="q_tqa"    #No.FUN-AB0034
                 LET g_qryparam.default1 = g_tqx.tqx13
                 LET g_qryparam.arg1 ="20" 
                 CALL cl_create_qry() RETURNING g_tqx.tqx13
                 DISPLAY BY NAME g_tqx.tqx13
              WHEN INFIELD(tqx03) # 活動類型
                 CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_tqa1"
                 LET g_qryparam.form ="q_tqa"    #No.FUN-AB0034
                 LET g_qryparam.default1 = g_tqx.tqx03
                 LET g_qryparam.arg1 ="15" 
                 CALL cl_create_qry() RETURNING g_tqx.tqx03
                 DISPLAY BY NAME g_tqx.tqx03
              WHEN INFIELD(tqx04) # 檔期類型
                 CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_tqa1"
                 LET g_qryparam.form ="q_tqa"    #No.FUN-AB0034
                 LET g_qryparam.default1 = g_tqx.tqx04
                 LET g_qryparam.arg1 ="17" 
                 CALL cl_create_qry() RETURNING g_tqx.tqx04
                 DISPLAY BY NAME g_tqx.tqx04
            WHEN INFIELD(tqx08) # 稅種
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gec"
                 LET g_qryparam.default1 = g_tqx.tqx08
                 LET g_qryparam.arg1 ="2"
                 CALL cl_create_qry() RETURNING g_tqx.tqx08
                 DISPLAY BY NAME g_tqx.tqx08    
            WHEN INFIELD(tqx09) # 幣種
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_tqx.tqx09
                 CALL cl_create_qry() RETURNING g_tqx.tqx09
                 DISPLAY BY NAME g_tqx.tqx09
              OTHERWISE EXIT CASE
        END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                RETURNING g_fld_name,g_frm_name           #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  #Add on 040913
     
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #BUG-4C0121
           CALL cl_about()      #BUG-4C0121
 
        ON ACTION help          #BUG-4C0121
           CALL cl_show_help()  #BUG-4C0121
    END INPUT
END FUNCTION
 
FUNCTION t233_tqa02(p_cmd,p_flag,p_ac)
   DEFINE p_cmd         LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   DEFINE p_flag        LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   DEFINE p_ac          LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_tqa02      LIKE tqa_file.tqa02
   DEFINE l_tqaacti    LIKE tqa_file.tqaacti
   DEFINE l_tqa02_1    LIKE tqa_file.tqa02
   DEFINE l_tqaacti_1  LIKE tqa_file.tqaacti
 
   LET g_errno=''
   IF p_flag = '1' THEN
      IF NOT cl_null(g_tqy[p_ac].tqy04) THEN
         SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01 = g_tqy[p_ac].tqy04
            AND tqa03 = '10'
      END IF
      IF NOT cl_null(g_tqy[p_ac].tqy07) THEN
         SELECT tqa02,tqaacti INTO l_tqa02_1,l_tqaacti_1
           FROM tqa_file
          WHERE tqa01 = g_tqy[p_ac].tqy07
            AND tqa03 = '11'
      END IF
   END IF
   IF p_flag = '2' THEN
      SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
        FROM tqa_file
       WHERE tqa01 = g_tqz[p_ac].tqz10
         AND tqa03 = '18'
   END IF
   CASE WHEN INFIELD(tqx03)   #活動類型
           SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
             FROM tqa_file
            WHERE tqa01 = g_tqx.tqx03
              AND tqa03 = '15'
           
        WHEN INFIELD(tqx04)   #檔期類型
           SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
             FROM tqa_file
            WHERE tqa01 = g_tqx.tqx04
              AND tqa03 = '17'
   END CASE
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-027'
                                 LET l_tqa02 = ''
                                 LET l_tqa02_1 = ''
        WHEN l_tqaacti = 'N'  LET g_errno = '9028' # 此資料已無效
        WHEN p_flag = '1' AND l_tqaacti_1 = 'N'  
                                 LET g_errno = '9028' # 此資料已無效
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   
   IF cl_null(g_errno) OR p_cmd='d' THEN
      CASE WHEN INFIELD(tqx03)
                DISPLAY l_tqa02 TO FORMONLY.tqa02_a 
           WHEN INFIELD(tqx04) 
                DISPLAY l_tqa02 TO FORMONLY.tqa02_b  
      END CASE
      IF p_flag = '1' THEN
         LET g_tqy[p_ac].tqa02_c = l_tqa02
         LET g_tqy[p_ac].tqa02_d = l_tqa02_1
      END IF
      IF p_flag = '2' THEN
         LET g_tqz[p_ac].tqa02_e = l_tqa02
      END IF
   END IF
 
END FUNCTION
 
#稅種
FUNCTION t233_tqx08(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   DEFINE l_gec04  LIKE gec_file.gec01
   DEFINE l_gec05  LIKE gec_file.gec05
   DEFINE l_gec07  LIKE gec_file.gec07
   DEFINE l_gecacti LIKE gec_file.gecacti
 
   LET g_errno = ' '
 
   SELECT gec04,gec05,gec07,gecacti
   INTO l_gec04,l_gec05,l_gec07,l_gecacti
   FROM gec_file
   WHERE gec01 = g_tqx.tqx08
     AND gec011= '2'
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-027'
                                 LET l_gec04 = ''
                                 LET l_gec05 = ''
                                 LET l_gec07 = ''
        WHEN l_gecacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
      LET g_tqx.tqx14 = l_gec04
      LET g_tqx.tqx15 = l_gec05
      LET g_tqx.tqx16 = l_gec07
      DISPLAY BY NAME g_tqx.tqx14
      DISPLAY BY NAME g_tqx.tqx15
      DISPLAY BY NAME g_tqx.tqx16
   END IF
 
END FUNCTION     
 
FUNCTION t233_tqx09(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   DEFINE l_azi02   LIKE azi_file.azi02 
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = ' '
 
   SELECT azi02,aziacti INTO l_azi02,l_aziacti FROM azi_file
    WHERE azi01 = g_tqx.tqx09
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-027'
                                 LET l_azi02 = ''
        WHEN l_aziacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
 
END FUNCTION
 
FUNCTION t233_tqx12(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   DEFINE l_tqb02   LIKE tqb_file.tqb02
   DEFINE l_tqbacti LIKE tqb_file.tqbacti
 
   LET g_errno = ' '
 
   SELECT tqb02,tqbacti INTO l_tqb02,l_tqbacti FROM tqb_file
   WHERE tqb01 = g_tqx.tqx12
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-027'
                                 LET l_tqb02 = ''
        WHEN l_tqbacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_tqb02 TO FORMONLY.tqb02
   END IF
 
END FUNCTION
 
FUNCTION t233_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
 
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tqx.* TO NULL               #No.FUN-6B0043  add
 
   MESSAGE ""
 
   CALL cl_opmsg('q')
   CLEAR FORM
 
   CALL g_tqy.clear()
   CALL g_tqz.clear()
 
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t233_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! " 
   OPEN t233_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tqx.* TO NULL
   ELSE
      OPEN t233_count
      FETCH t233_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t233_fetch('F')                  # 讀出TEMP第一筆并顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t233_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t233_cs INTO g_tqx.tqx01
      WHEN 'P' FETCH PREVIOUS t233_cs INTO g_tqx.tqx01
      WHEN 'F' FETCH FIRST    t233_cs INTO g_tqx.tqx01
      WHEN 'L' FETCH LAST     t233_cs INTO g_tqx.tqx01
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0 
            PROMPT g_msg CLIPPED,'. ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         #BUG-4C0121
                  CALL cl_about()      #BUG-4C0121
 
               ON ACTION help          #BUG-4C0121
                  CALL cl_show_help()  #BUG-4C0121
 
               ON ACTION controlg      #BUG-4C0121
                  CALL cl_cmdask()     #BUG-4C0121
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t233_cs INTO g_tqx.tqx01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0)
      INITIALIZE g_tqx.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_tqx.* FROM tqx_file
    WHERE tqx01 = g_tqx.tqx01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
      INITIALIZE g_tqx.* TO NULL
      RETURN
   ELSE
      CALL t233_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t233_show()
DEFINE l_tqb02 LIKE tqb_file.tqb02 
DEFINE l_tqa02_a LIKE tqa_file.tqa02 
DEFINE l_tqa02_b LIKE tqa_file.tqa02 
       
   LET g_tqx_t.* = g_tqx.*                #保存單頭舊值
   DISPLAY BY NAME g_tqx.tqx01,g_tqx.tqx02,g_tqx.tqx12, g_tqx.tqxoriu,g_tqx.tqxorig,
                   g_tqx.tqx13,g_tqx.tqx03,g_tqx.tqx04,
                   g_tqx.tqx05,g_tqx.tqx06,g_tqx.tqx08,
                   g_tqx.tqx14,g_tqx.tqx15,g_tqx.tqx16,
                   g_tqx.tqx09,g_tqx.tqx10,g_tqx.tqx11,
                   g_tqx.tqx07,g_tqx.tqx17,g_tqx.tqx18,
                   g_tqx.tqx19,g_tqx.tqxacti,
                   g_tqx.tqxmodu,g_tqx.tqxgrup,g_tqx.tqxdate,
                   g_tqx.tqxuser,
                   g_tqx.tqxud01,g_tqx.tqxud02,g_tqx.tqxud03,g_tqx.tqxud04,
                   g_tqx.tqxud05,g_tqx.tqxud06,g_tqx.tqxud07,g_tqx.tqxud08,
                   g_tqx.tqxud09,g_tqx.tqxud10,g_tqx.tqxud11,g_tqx.tqxud12,
                   g_tqx.tqxud13,g_tqx.tqxud14,g_tqx.tqxud15 
 
   SELECT tqa02 INTO l_tqa02_a  #活動類別
     FROM tqa_file
    WHERE tqa01 = g_tqx.tqx03
      AND tqa03 = '15'
   DISPLAY l_tqa02_a TO FORMONLY.tqa02_a
   
   SELECT tqa02 INTO l_tqa02_b  #檔期類型
     FROM tqa_file
    WHERE tqa01 = g_tqx.tqx04
      AND tqa03 = '17'
   DISPLAY l_tqa02_b TO FORMONLY.tqa02_b
 
   CALL t233_tqx12('d')
   CALL t233_tqx09('d')
 
   CALL t233_b_fill(g_wc2)                  #單身
   CALL t233_b2_fill(g_wc3)                 #單身
   CALL t233_pic_show()
   CALL cl_show_fld_cont()                  #FUN-590083
END FUNCTION
 
# 取消整筆 (所有合乎單頭的資料)
FUNCTION t233_r()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_tqx.tqx01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
 
   SELECT * INTO g_tqx.* FROM tqx_file
    WHERE tqx01=g_tqx.tqx01
 
   IF g_tqx.tqx07 MATCHES '[24]' THEN  
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
   IF g_tqx.tqx07 = '5' THEN  
      CALL cl_err("","aap-730",0)
      RETURN
   END IF
   IF g_tqx.tqx07 = '3' THEN  
      CALL cl_err("","9021",0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK 
   OPEN t233_cl USING g_tqx.tqx01 
   IF STATUS THEN
      CALL cl_err("OPEN t233_cl.", STATUS, 1)
      CLOSE t233_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t233_cl INTO g_tqx.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t233_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tqx01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tqx.tqx01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM tqy_file WHERE tqy01 = g_tqx.tqx01
      IF STATUS THEN 
         CALL cl_err3("del","tqy_file",g_tqx.tqx01,"",STATUS,"","del tqy.",1)   #No.FUN-660104
         ROLLBACK WORK
         RETURN 
      END IF
      DELETE FROM tqz_file WHERE tqz01 = g_tqx.tqx01
      IF STATUS THEN
         CALL cl_err3("del","tqz_file",g_tqx.tqx01,"",STATUS,"","del tqz.",1)   #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tqx_file WHERE tqx01 = g_tqx.tqx01
      IF STATUS THEN 
         CALL cl_err3("del","tqx_file",g_tqx.tqx01,"",STATUS,"","del tqx.",1)   #No.FUN-660104
         ROLLBACK WORK 
         RETURN 
      END IF
      DELETE FROM tsa_file WHERE tsa01 = g_tqx.tqx01
      IF STATUS THEN 
         CALL cl_err3("del","tsa_file",g_tqx.tqx01,"",STATUS,"","del tsa.",1)   #No.FUN-660104
         ROLLBACK WORK
         RETURN 
      END IF
      DELETE FROM tsb_file WHERE tsb01 = g_tqx.tqx01
      IF STATUS THEN 
         CALL cl_err3("del","tsb_file",g_tqx.tqx01,"",STATUS,"","del tsb.",1)   #No.FUN-660104
         ROLLBACK WORK
         RETURN 
      END IF
 
      INITIALIZE g_tqx.* TO NULL
 
      CLEAR FORM
      CALL g_tqy.clear()
      CALL g_tqz.clear()
 
      OPEN t233_count 
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t233_cs
         CLOSE t233_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t233_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t233_cs
         CLOSE t233_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN t233_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t233_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t233_fetch('/')
      END IF
   END IF
 
   CLOSE t233_cl
 
   IF g_success = 'Y' THEN 
      COMMIT WORK
      CALL cl_flow_notify(g_tqx.tqx01,'D')
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t233_g_b()
   CALL t233_g_b1()
   CALL t233_b_fill('1=1')
   CALL t233_b2_fill('1=1')
END FUNCTION
 
FUNCTION t233_g_b1()
   DEFINE l_occ01      LIKE occ_file.occ01
   DEFINE l_wc         LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
   DEFINE l_tqy        RECORD LIKE tqy_file.*
   DEFINE l_plant      LIKE tqy_file.tqy36          #No.FUN-680120 VARCHAR(10) 
   DEFINE l_dbs        LIKE type_file.chr21         #No.FUN-680120 VARCHAR(21)
 
   IF cl_null(g_tqx.tqx01) THEN RETURN END IF 
   IF g_tqx.tqx07 != '1' THEN
      CALL cl_err('','atm-239',0)
      RETURN
   END IF
   
   # QBE 查詢客戶編號
   OPEN WINDOW t233_g_b_w AT 4,24 WITH FORM "atm/42f/atmt233_1"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("atmt233_1")
 
   LET l_plant = g_plant
   LET l_dbs = g_dbs
 
   INPUT l_plant WITHOUT DEFAULTS
      FROM azp01
 
      ON ACTION controlp
         CASE WHEN INFIELD(azp01)     #工廠別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 LET g_qryparam.default1 = l_plant
                 CALL cl_create_qry() RETURNING l_plant
                 DISPLAY l_plant TO azp01
                 NEXT FIELD azp01
         END CASE
 
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
 
   SELECT azp03 INTO l_dbs
     FROM azp_file
    WHERE azp01=l_plant
   IF SQLCA.SQLCODE THEN
      LET l_dbs=g_dbs      
   END IF 
 
   CONSTRUCT BY NAME l_wc ON occ01, occ1007, occ1008
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
              WHEN INFIELD(occ01)  # 門店代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_occ8" 
                  LET g_qryparam.arg1 =l_dbs
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ01
              WHEN INFIELD(occ1007)    
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqa1"
                  LET g_qryparam.arg1 ="10"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1007
                  NEXT FIELD occ1007
              WHEN INFIELD(occ1008)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqa1"
                  LET g_qryparam.arg1 ="11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1008
                  NEXT FIELD occ1008
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW t233_g_b_w
      RETURN
   END IF
   IF cl_null(l_wc) THEN LET l_wc = " 1=1" END IF
 
 
   CLOSE WINDOW t233_g_b_w
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t233_cl USING g_tqx.tqx01
   IF STATUS THEN
      CALL cl_err("OPEN t233_cl.", STATUS, 1)
      CLOSE t233_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t233_cl INTO g_tqx.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0)
      CLOSE t233_cl
      ROLLBACK WORK RETURN
   END IF
 
   CALL g_tqy.clear()
 
   LET g_sql = "SELECT occ01, occ1007, occ1008, occ1009, occ1010",
               #"  FROM ",s_dbstring(l_dbs CLIPPED),"occ_file ", #TQC-940177 
               "  FROM ",cl_get_target_table(l_plant,'occ_file'),  #FUN-A50102
               " WHERE  occ1004='1' AND occ06='1' ",   #No.FUN-690025
               "   AND occacti = 'Y' ",
               "   AND ",l_wc CLIPPED
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
   PREPARE occ_pre FROM g_sql
   DECLARE occ_curs CURSOR FOR occ_pre
 
   LET l_occ01 = NULL
   INITIALIZE l_tqy.* TO NULL
   LET l_tqy.tqy01 = g_tqx.tqx01 
   
   FOREACH occ_curs INTO l_tqy.tqy03,l_tqy.tqy04,
                         l_tqy.tqy07,l_tqy.tqy05,
                         l_tqy.tqy06
      IF STATUS THEN CALL cl_err('occ_curs',SQLCA.sqlcode,0) EXIT FOREACH END IF
 
      IF cl_null(l_tqy.tqy03) THEN 
         CONTINUE FOREACH
      END IF
        
      #判斷同一提案號碼下不能有相同的門店  
       SELECT COUNT(*)  INTO  g_cnt
         FROM  tqy_file
        WHERE  tqy01=g_tqx.tqx01  AND  tqy03=l_tqy.tqy03
        IF g_cnt>0 THEN
           CALL cl_err('','atm-024',0)
           CONTINUE FOREACH
        END IF    
 
      # 獲取序號
      SELECT MAX(tqy02)+1 INTO l_tqy.tqy02
        FROM tqy_file
       WHERE tqy01 = g_tqx.tqx01
      IF cl_null(l_tqy.tqy02) THEN
         LET l_tqy.tqy02 = 1
      END IF
 
      INSERT INTO tqy_file(tqy01,tqy02,tqy03,tqy04,
                              tqy07,tqy05,tqy06,tqy37,
                              tqy36,tqy10,tqy11,tqy12,
                              tqy13,tqy14,
                              tqyplant,tqylegal) #FUN-980009
                       VALUES(g_tqx.tqx01,l_tqy.tqy02,
                              l_tqy.tqy03,l_tqy.tqy04,
                              l_tqy.tqy07,l_tqy.tqy05,
                              l_tqy.tqy06,'N',l_plant,0,0,0,0,0,
                              g_plant,g_legal)   #FUN-980009
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tqy_file",l_tqy.tqy02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         LET g_success='N'
         EXIT FOREACH     
      END IF
      SELECT COUNT(*) INTO g_cnt FROM tqz_file
      WHERE tqz01=g_tqx.tqx01
      IF g_cnt>0 THEN
         CALL t233_detail_d('a','c','',l_tqy.tqy02)
              RETURNING g_errno
         IF NOT cl_null(g_errno) THEN
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF
      
   END FOREACH
 
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
#選擇料號
FUNCTION t233_g_b2()
   DEFINE l_wc         LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
   DEFINE l_tqy        RECORD LIKE tqy_file.*
   DEFINE l_plant      LIKE tqy_file.tqy36          #No.FUN-680120 VARCHAR(10)
   DEFINE l_dbs        LIKE type_file.chr21         #No.FUN-680120 VARCHAR(21)
   DEFINE l_sql        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(300)
   DEFINE l_ima01      LIKE ima_file.ima01
   DEFINE l_n          LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_cnt        LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_tqz04  LIKE tqz_file.tqz04,
          l_tqz05  LIKE tqz_file.tqz05,
          l_tqz06  LIKE tqz_file.tqz06,
          l_tqz07  LIKE tqz_file.tqz07,
          l_tqz08  LIKE tqz_file.tqz08,
          l_tqz09  LIKE tqz_file.tqz09,
          l_tqz13  LIKE tqz_file.tqz13,
          l_tqz15  LIKE tqz_file.tqz15,
          l_tqz031 LIKE tqz_file.tqz031,
          l_tqy36  LIKE tqy_file.tqy36
 
   IF cl_null(g_tqx.tqx01) THEN RETURN END IF 
   IF g_tqx.tqx07 != '1' THEN
      CALL cl_err('','atm-239',0)
      RETURN
   END IF
 
   OPEN WINDOW t200_g_b2_w AT 4,24 WITH FORM "atm/42f/atmt233_5"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("atmt233_5")
 
   CONSTRUCT BY NAME l_wc ON ima01,ima135,ima06, ima1004, ima1005,
                              ima1006, ima1007, ima1008, ima1009
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima01)              #料號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_ima02"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO ima01
                 NEXT FIELD ima01
            WHEN INFIELD(ima06)             #分群碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_imz1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima06
                 NEXT FIELD ima06
            WHEN INFIELD(ima1004)         #品類
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_tqa2"
                 LET g_qryparam.arg1 ="1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1004
                 NEXT FIELD ima1004
            WHEN INFIELD(ima1005)         #品牌
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_tqa2"
                 LET g_qryparam.arg1 ="2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1005
                 NEXT FIELD ima1005
            WHEN INFIELD(ima1006)         #系列
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_tqa2"
                 LET g_qryparam.arg1 ="3"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1006
                 NEXT FIELD ima1006
            WHEN INFIELD(ima1007)         #型別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_tqa2"
                 LET g_qryparam.arg1 ="4"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1007
                 NEXT FIELD ima1007
            WHEN INFIELD(ima1008)         #規格
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_tqa2"
                 LET g_qryparam.arg1 ="5"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1008
                 NEXT FIELD ima1008
            WHEN INFIELD(ima1009)         #屬性
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_tqa2"
                 LET g_qryparam.arg1 ="6"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima1009
                 NEXT FIELD ima1009
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW t200_g_b2_w
      RETURN
   END IF
   IF cl_null(l_wc) THEN LET l_wc = " 1=1" END IF
   LET l_tqz04=g_today
   LET l_tqz05=g_today
 
   INPUT l_tqz04,l_tqz05 WITHOUT DEFAULTS FROM a,b
 
      AFTER FIELD a
         IF NOT cl_null(l_tqz04) AND NOT cl_null(l_tqz05) THEN
            IF l_tqz05<l_tqz04 THEN
               CALL cl_err('','mfg5067',0)
               NEXT FIELD a
            END IF
         END IF
         
      AFTER FIELD b          #促銷終止日
         IF NOT cl_null(l_tqz05) THEN
            IF l_tqz05<l_tqz04 THEN
               CALL cl_err('','mfg5067',0)
               NEXT FIELD b
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
      LET INT_FLAG = 0 
      CLOSE WINDOW t200_g_b2_w
      RETURN
   END IF
 
   CLOSE WINDOW t200_g_b2_w
 
   LET g_success='Y'
 
   BEGIN WORK
 
   LET l_sql="SELECT ima01,ima02,ima31 FROM ima_file,tqh_file",
             " WHERE ima1010='1'  ",    #No.FUN-690025
             "   AND imaacti='Y'  ",
             "   AND tqh02=ima1006  ",
             "   AND tqhacti= 'Y' ",
             "   AND tqh01='",g_tqx.tqx13,"'",
             "   AND ",l_wc CLIPPED
   PREPARE g_item_pre FROM l_sql
   DECLARE g_item_cur CURSOR FOR g_item_pre
 
   FOREACH g_item_cur INTO l_ima01,l_tqz031,l_tqz08
      IF SQLCA.SQLCODE THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO l_cnt FROM tqz_file
       WHERE tqz01=g_tqx.tqx01
         AND tqz03=l_ima01
      IF l_cnt> 0 THEN
         CONTINUE FOREACH
      END IF
      SELECT MAX(tqz02)+1 INTO l_n
        FROM tqz_file
       WHERE tqz01=g_tqx.tqx01
      IF cl_null(l_n) OR l_n=0 THEN
         LET l_n=1
      END IF
 
      DECLARE tqy_cur1 CURSOR FOR
       SELECT tqy03,tqy36 FROM tqy_file
        WHERE tqy01= g_tqx.tqx01
          AND tqy02=(SELECT MIN(tqy02) FROM tqy_file
                      WHERE tqy01=g_tqx.tqx01)
      OPEN tqy_cur1
      FETCH tqy_cur1 INTO l_tqy03,l_tqy36
      CLOSE tqy_cur1
      IF SQLCA.sqlcode THEN 
         LET g_success='N'
         EXIT FOREACH
      ELSE
         SELECT azp03 INTO l_dbs
           FROM azp_file
          WHERE azp01 = l_tqy36
         IF SQLCA.SQLCODE THEN
            LET l_dbs=s_dbstring(g_dbs CLIPPED) #TQC-940177      
         ELSE
            LET l_dbs=s_dbstring(l_dbs CLIPPED) #TQC-940177    
         END IF
         LET l_plant = l_tqy36       #No.FUN-980059
         CALL s_fetch_price2(l_tqy03,l_ima01,l_tqz08,
                             g_tqx.tqx02,'1',l_plant,g_tqx.tqx09)   #No.FUN-980059
         RETURNING g_tqm01,l_tqz15,g_flag   #正常進價
         CALL s_fetch_price2(l_tqy03,l_ima01,l_tqz08,
                             g_tqx.tqx02,'3',l_plant,g_tqx.tqx09)   #No.FUN-980059
         RETURNING g_tqm01,l_tqz13,g_flag1  #標准特價
         IF g_tqx.tqx16='Y' THEN
            LET l_tqz15=l_tqz15*(1+g_tqx.tqx14/100)
            LET l_tqz13=l_tqz13*(1+g_tqx.tqx14/100)
         END IF
      END IF
      LET l_tqz06 = l_tqz04 - g_tqx.tqx10
      LET l_tqz07 = l_tqz05 + g_tqx.tqx11 
 
      INSERT INTO tqz_file(tqz01,tqz02,tqz03,tqz031,tqz04,
                              tqz05,tqz06,tqz07,tqz08,
                              tqz09,tqz13,tqz14,tqz15,tqz16,
                              tqz17,tqz19,tqz20,tqz21,
                              tqzplant,tqzlegal) #FUN-980009
      VALUES(g_tqx.tqx01,l_n,l_ima01,l_tqz031,l_tqz04,l_tqz05,
             l_tqz06,l_tqz07,l_tqz08,l_tqz09,
             l_tqz13,0,l_tqz15,0,0,0,0,0,
             g_plant,g_legal)                    #FUN-980009
      IF SQLCA.SQLCODE THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
      
      SELECT COUNT(*) INTO g_cnt FROM tqz_file
      WHERE tqz01=g_tqx.tqx01
      IF g_cnt>0 THEN
         CALL t233_detail_d('a','i','',l_n)
              RETURNING g_errno
         IF NOT cl_null(g_errno) THEN
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF  #by elva}
 
   END FOREACH
 
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL t233_b2_fill('1=1')
 
END FUNCTION
 
#生效
FUNCTION t233_effect() 
   DEFINE l_occ01         LIKE occ_file.occ01
   DEFINE l_wc            LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(200)
   DEFINE l_tqy38         LIKE tqy_file.tqy38
   DEFINE l_sql           LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(300)
          l_rec_b         LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_ac2           LIKE type_file.num5   ,       # 目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
          l_i             LIKE type_file.num5   ,       # 目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_exit_sw       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680120 SMALLINT
          l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680120 SMALLINT
   DEFINE l_tqx07     LIKE tqx_file.tqx07 
   DEFINE l_tqxacti   LIKE tqx_file.tqxacti
   DEFINE l_tqy        DYNAMIC ARRAY OF RECORD      
                             a          LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)   
                             tqy02      LIKE tqy_file.tqy02,
                             tqy36a     LIKE tqy_file.tqy36,
                             tqy03      LIKE tqy_file.tqy03,
                             tqy04a     LIKE tqy_file.tqy04,
                             tqy07a     LIKE tqy_file.tqy07,
                             tqy05      LIKE tqy_file.tqy05,
                             tqy06      LIKE tqy_file.tqy06
                          END RECORD,
          l_plant         LIKE tqy_file.tqy36,             #No.FUN-680120 VARCHAR(10)
          l_dbs           LIKE type_file.chr21             #No.FUN-680120 VARCHAR(21)
 
   IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
   SELECT tqx07,tqxacti INTO l_tqx07,l_tqxacti
     FROM tqx_file
    WHERE tqx01 = g_tqx.tqx01
 
   IF l_tqxacti = 'N' THEN
      CALL cl_err(g_tqx.tqx01,'mfg1000',0)
      RETURN 
   END IF
   
   # 生效時判斷是否當前為已審核
   IF l_tqx07 != '3' THEN 
      CALL cl_err(g_tqx.tqx01,'atm-053',0)
      RETURN 
   END IF
 
   # QBE 查詢客戶編號
   OPEN WINDOW t233_g_b2_w AT 4,24 WITH FORM "atm/42f/atmt233_2"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("atmt233_2")
 
   CALL cl_set_head_visible("grid01,g01","YES")  #No.FUN-6B0031
   CONSTRUCT BY NAME l_wc ON tqy03,tqy04,tqy07
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
              WHEN INFIELD(tqy03)            # 門店代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_tqy"
                  LET g_qryparam.arg1 = g_tqx.tqx01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqy03
              WHEN INFIELD(tqy04)            #系統碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqy1"
                  LET g_qryparam.arg1 =g_tqx.tqx01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqy04
                  NEXT FIELD tqy04
              WHEN INFIELD(tqy07)            #系統區域碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqy2"
                  LET g_qryparam.arg1 =g_tqx.tqx01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqy07
                  NEXT FIELD tqy07
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
  
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW t233_g_b2_w
      RETURN
   END IF
   IF cl_null(l_wc) THEN LET l_wc = " 1=1" END IF
 
   LET l_tqy38 = g_today
   INPUT BY NAME l_tqy38 WITHOUT DEFAULTS
      
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t233_g_b2_w RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   LET l_sql ="SELECT 'Y',tqy02,tqy36,tqy03,tqy04,tqy07,",
                "       tqy05,tqy06 ",
                "  FROM tqy_file ",
                " WHERE tqy01 = '",g_tqx.tqx01,"'",
             #  "   AND tqy37 = 'N' ",     #TQC-CC0123--mark--
                "   AND ",l_wc CLIPPED,
                " ORDER BY tqy03 "
    PREPARE t233_pb_2 FROM l_sql
    DECLARE tqy_curs_2 CURSOR FOR t233_pb_2
 
    CALL l_tqy.clear()
    LET l_n = 1
    FOREACH tqy_curs_2 INTO l_tqy[l_n].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       LET l_n = l_n + 1
       IF l_n > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
  	  EXIT FOREACH
       END IF
    END FOREACH
    CALL l_tqy.deleteElement(l_n)
    LET l_rec_b = l_n-1
 
   CALL cl_opmsg('b')
   LET l_allow_insert = FALSE  #cl_detail_input_auth("insert")
   LET l_allow_delete = FALSE  #cl_detail_input_auth("delete")
  
   WHILE TRUE
   LET l_exit_sw = 'y' 
   LET l_ac2=1
   INPUT ARRAY l_tqy WITHOUT DEFAULTS FROM s_tqy2.* 
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
           IF l_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
        
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #BUG-4C0121
          CALL cl_about()      #BUG-4C0121
 
       ON ACTION help          #BUG-4C0121
          CALL cl_show_help()  #BUG-4C0121
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("grid01,g01","AUTO")
   END INPUT
       
  FOR l_i=1 TO l_rec_b
    IF l_tqy[l_i].a='Y' THEN
       UPDATE tqy_file SET tqy37='Y',tqy38=l_tqy38
        WHERE tqy01=g_tqx.tqx01
          AND tqy03=l_tqy[l_i].tqy03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","tqy_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
          LET g_success = 'N'
          EXIT FOR
       END IF
    ELSE
       UPDATE tqy_file SET tqy37='N',tqy38=NULL
        WHERE tqy01=g_tqx.tqx01
          AND tqy03=l_tqy[l_i].tqy03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","tqy_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
          LET g_success = 'N'
          EXIT FOR
       END IF
    END IF
  END FOR
 
    IF l_exit_sw = 'y' THEN
          EXIT WHILE
       ELSE
          CONTINUE WHILE
       END IF
 
  END WHILE
 
   IF g_success='Y' THEN
      COMMIT WORK
      CALL t233_b_fill('1=1')
   ELSE
      ROLLBACK WORK
   END IF
 
   CLOSE WINDOW t233_g_b2_w
 
END FUNCTION
 
FUNCTION t233_undo_effect() 
   DEFINE l_occ01           LIKE occ_file.occ01
   DEFINE l_wc              LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(200)
   DEFINE l_tqy38           LIKE tqy_file.tqy38
   DEFINE l_sql             LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(300)
          l_rec_b           LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_ac2             LIKE type_file.num5   ,                  # 目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
          l_i               LIKE type_file.num5   ,                  # 目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
          l_n               LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_exit_sw         LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_allow_insert    LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT
          l_allow_delete    LIKE type_file.num5                 #可刪除否        #No.FUN-680120 SMALLINT
   DEFINE l_tqx07           LIKE tqx_file.tqx07 
   DEFINE l_tqxacti         LIKE tqx_file.tqxacti
   DEFINE l_tqy          DYNAMIC ARRAY OF RECORD      
                               a          LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
                               tqy02      LIKE tqy_file.tqy02,
                               tqy36a     LIKE tqy_file.tqy36,
                               tqy03      LIKE tqy_file.tqy03,
                               tqy04a     LIKE tqy_file.tqy04,
                               tqy07a     LIKE tqy_file.tqy07,
                               tqy05      LIKE tqy_file.tqy05,
                               tqy06      LIKE tqy_file.tqy06
                            END RECORD
 
   IF cl_null(g_tqx.tqx01) THEN RETURN END IF
   SELECT tqx07,tqxacti INTO l_tqx07,l_tqxacti
     FROM tqx_file
    WHERE tqx01 = g_tqx.tqx01
 
   IF l_tqxacti = 'N' THEN
      CALL cl_err(g_tqx.tqx01,'mfg1000',0)
      RETURN 
   END IF
   
   # 生效時判斷是否當前為已審核
   IF l_tqx07 != '3' THEN 
      CALL cl_err(g_tqx.tqx01,'atm-053',0)
      RETURN 
   END IF
   
   # QBE 查詢客戶編號
   OPEN WINDOW t233_g_b3_w AT 4,24 WITH FORM "atm/42f/atmt233_3"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("atmt233_3")
 
   CALL cl_set_head_visible("grid01","YES")  #No.FUN-6B0031
   CONSTRUCT BY NAME l_wc ON tqy03,tqy04,tqy07
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
              WHEN INFIELD(tqy03)             #門店代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_tqy"
                  LET g_qryparam.arg1 = g_tqx.tqx01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqy03
              WHEN INFIELD(tqy04)             #系統碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqy1"
                  LET g_qryparam.arg1 =g_tqx.tqx01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqy04
                  NEXT FIELD tqy04
              WHEN INFIELD(tqy07)             #系統區域碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqy2"
                  LET g_qryparam.arg1 =g_tqx.tqx01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqy07
                  NEXT FIELD tqy07
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
  
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW t233_g_b3_w
      RETURN
   END IF
   IF cl_null(l_wc) THEN LET l_wc = " 1=1" END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
  LET l_sql ="SELECT 'Y',tqy02,tqy36,tqy03,tqy04,tqy07,",
                "       tqy05,tqy06 ",
                "  FROM tqy_file ",
                " WHERE tqy01 = '",g_tqx.tqx01,"'",
        #       "   AND tqy37 = 'Y' ",    #已生效的    #TQC-CC0123--mark--
                "   AND ",l_wc CLIPPED,
                " ORDER BY tqy03 "
    PREPARE t233_pb_3 FROM l_sql
    DECLARE tqy_curs_3 CURSOR FOR t233_pb_3
 
    CALL l_tqy.clear()
    LET l_n = 1
    FOREACH tqy_curs_3 INTO l_tqy[l_n].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       LET l_n = l_n + 1
       IF l_n > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
  	  EXIT FOREACH
       END IF
    END FOREACH
    CALL l_tqy.deleteElement(l_n)
    LET l_rec_b = l_n-1
 
   CALL cl_opmsg('b')
   LET l_allow_insert = FALSE  #cl_detail_input_auth("insert")
   LET l_allow_delete = FALSE  #cl_detail_input_auth("delete")
  
   WHILE TRUE
   LET l_exit_sw = 'y' 
   LET l_ac2=1
   INPUT ARRAY l_tqy WITHOUT DEFAULTS FROM s_tqy2.* 
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,
                   DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
 
       BEFORE INPUT
           IF l_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF     
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #BUG-4C0121
          CALL cl_about()      #BUG-4C0121
 
       ON ACTION help          #BUG-4C0121
          CALL cl_show_help()  #BUG-4C0121
 
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("grid01","AUTO")
       END INPUT
   IF INT_FLAG THEN               #TQC-AB0285                                                       
      LET INT_FLAG = 0            #TQC-AB0285
      CLOSE WINDOW t233_g_b3_w    #TQC-AB0285                                                        
      RETURN                      #TQC-AB0285                                                       
   END IF                         #TQC-AB0285
  FOR l_i=1 TO l_rec_b
    IF l_tqy[l_i].a='Y' THEN
       UPDATE tqy_file SET tqy37='N',tqy38=NULL
        WHERE tqy01=g_tqx.tqx01
          AND tqy03=l_tqy[l_i].tqy03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","tqy_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
          LET g_success = 'N'
          EXIT FOR
       END IF
    END IF
  END FOR
 
    IF l_exit_sw = 'y' THEN
          EXIT WHILE
       ELSE
          CONTINUE WHILE
       END IF
 
  END WHILE
 
   IF g_success='Y' THEN
      CALL t233_b_fill('1=1')
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
     CLOSE WINDOW t233_g_b3_w
 
END FUNCTION
 
FUNCTION t233_b()
DEFINE
   l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT   #No.FUN-680120 SMALLINT
   l_n             LIKE type_file.num5,              #檢查重復用          #No.FUN-680120 SMALLINT
   l_lock_sw       LIKE type_file.chr1,              #單身鎖住否          #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,              #處理狀態            #No.FUN-680120 VARCHAR(1)
   l_exit_sw       LIKE type_file.chr1,              #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,              #可新增否            #No.FUN-680120 SMALLINT
   l_allow_delete  LIKE type_file.num5,              #可刪除否            #No.FUN-680120 SMALLINT
   l_dbs           LIKE type_file.chr21,             #No.FUN-680120 VARCHAR(21)
   l_sql           LIKE type_file.chr1000            #No.FUN-680120 VARCHAR(400)
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_tqx.tqx01 IS NULL THEN RETURN END IF
   SELECT * INTO g_tqx.* FROM tqx_file
    WHERE tqx01 = g_tqx.tqx01
 
   #非開立狀態，不能修改
   IF g_tqx.tqx07 != '1' THEN
      CALL cl_err(g_tqx.tqx01,'atm-226',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tqy02,tqy36,tqy03,'',tqy04,'',tqy07,'',tqy05,",
                      "       '',tqy06,'',tqy37,tqy38 ",
                      "  FROM tqy_file ",
                      " WHERE tqy01 = ? AND tqy02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t233_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET g_tqx.tqxmodu = g_user
   LET g_tqx.tqxdate = g_today
   DISPLAY BY NAME g_tqx.tqxmodu,g_tqx.tqxdate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   WHILE TRUE
   LET l_exit_sw = 'y' 
   INPUT ARRAY g_tqy WITHOUT DEFAULTS FROM s_tqy.* 
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,
                   DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_success = 'Y'
          OPEN t233_cl USING g_tqx.tqx01 
          IF STATUS THEN
             CALL cl_err("OPEN t233_cl.", STATUS, 1)
             CLOSE t233_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t233_cl INTO g_tqx.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0) # 資料被他人LOCK
             CLOSE t233_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_tqy_t.* = g_tqy[l_ac].*  #BACKUP
             LET g_tqy_o.* = g_tqy[l_ac].*  #BACKUP
             OPEN t233_b2cl USING g_tqx.tqx01,g_tqy_t.tqy02
             IF STATUS THEN
                CALL cl_err("OPEN t233_b2cl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t233_b2cl INTO g_tqy[l_ac].* 
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_tqy_t.tqy02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             CALL t233_tqy03(p_cmd,l_ac)
             CALL cl_show_fld_cont()    
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_tqy[l_ac].* TO NULL         #90423
          LET g_tqy_t.* = g_tqy[l_ac].*         #新輸入資料
          LET g_tqy_o.* = g_tqy[l_ac].*         #新輸入資料
          LET g_tqy[l_ac].tqy37='N'
          LET g_tqy[l_ac].tqy36=g_plant
          CALL cl_show_fld_cont()                  #FUN-590083
          NEXT FIELD tqy02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO tqy_file(tqy01,tqy02,tqy36,tqy03,
                                  tqy04,tqy07,tqy05,tqy06,
                                  tqy37,tqy38,tqy10,tqy11,
                                  tqy12,tqy13,tqy14,
                                  tqyud01,tqyud02,tqyud03,
                                  tqyud04,tqyud05,tqyud06,
                                  tqyud07,tqyud08,tqyud09,
                                  tqyud10,tqyud11,tqyud12,
                                  tqyud13,tqyud14,tqyud15,
                                  tqyplant,tqylegal #FUN-980009
                                  )
                           VALUES(g_tqx.tqx01,
                                  g_tqy[l_ac].tqy02,
                                  g_tqy[l_ac].tqy36,
                                  g_tqy[l_ac].tqy03,
                                  g_tqy[l_ac].tqy04,
                                  g_tqy[l_ac].tqy07,
                                  g_tqy[l_ac].tqy05,
                                  g_tqy[l_ac].tqy06,
                                  g_tqy[l_ac].tqy37,
                                  g_tqy[l_ac].tqy38,
                                  0,0,0,0,0,
                                  g_tqy[l_ac].tqyud01,
                                  g_tqy[l_ac].tqyud02,
                                  g_tqy[l_ac].tqyud03,
                                  g_tqy[l_ac].tqyud04,
                                  g_tqy[l_ac].tqyud05,
                                  g_tqy[l_ac].tqyud06,
                                  g_tqy[l_ac].tqyud07,
                                  g_tqy[l_ac].tqyud08,
                                  g_tqy[l_ac].tqyud09,
                                  g_tqy[l_ac].tqyud10,
                                  g_tqy[l_ac].tqyud11,
                                  g_tqy[l_ac].tqyud12,
                                  g_tqy[l_ac].tqyud13,
                                  g_tqy[l_ac].tqyud14,
                                  g_tqy[l_ac].tqyud15,
                                  g_plant,g_legal    #FUN-980009
                                  )
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tqy_file",g_tqy[l_ac].tqy02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
             CANCEL INSERT
             ROLLBACK WORK
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn3
             # 批次生成提案明細資料
             SELECT COUNT(*) INTO g_cnt
             FROM tqz_file
             WHERE tqz01=g_tqx.tqx01
             IF g_cnt>0 THEN
                CALL t233_detail_d('a','c','',g_tqy[l_ac].tqy02)
                     RETURNING g_errno
                IF NOT cl_null(g_errno) THEN
                   LET g_success='N'
                END IF
             END IF
             IF g_success='Y' THEN
                COMMIT WORK
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       BEFORE FIELD tqy02                        #default 序號
          IF g_tqy[l_ac].tqy02 IS NULL OR
             g_tqy[l_ac].tqy02 = 0 THEN
             SELECT MAX(tqy02)+1
               INTO g_tqy[l_ac].tqy02
               FROM tqy_file
              WHERE tqy01 = g_tqx.tqx01
             IF g_tqy[l_ac].tqy02 IS NULL THEN
                LET g_tqy[l_ac].tqy02 = 1
             END IF
          END IF
 
       AFTER FIELD tqy02                        #check 序號是否重復
          IF NOT cl_null(g_tqy[l_ac].tqy02) THEN
             IF g_tqy[l_ac].tqy02 != g_tqy_t.tqy02
                OR g_tqy_t.tqy02 IS NULL THEN
                SELECT COUNT(*) INTO l_n
                FROM tqy_file
                WHERE tqy01 = g_tqx.tqx01
                      AND tqy02 = g_tqy[l_ac].tqy02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_tqy[l_ac].tqy02 = g_tqy_t.tqy02
                   NEXT FIELD tqy02
                END IF
             END IF
             IF p_cmd='a' THEN
                LET g_tqy[l_ac].tqy37='N'
                LET g_tqy[l_ac].tqy36=g_plant
             END IF
          END IF
 
       BEFORE FIELD tqy36
          IF cl_null(g_tqy[l_ac].tqy36) THEN
             LET g_tqy[l_ac].tqy36=g_plant
          END IF
       
       AFTER FIELD tqy36
          IF NOT cl_null(g_tqy[l_ac].tqy36) THEN
             SELECT COUNT(*) INTO g_cnt FROM azp_file
              WHERE azp01=g_tqy[l_ac].tqy36
             IF g_cnt<=0 THEN 
                ERROR 'WRONG database!'
                NEXT FIELD tqy36
             ELSE
                LET g_plant_new = g_tqy[l_ac].tqy36
             END IF 
          END IF
 
       AFTER FIELD tqy03   # 門店代碼
          IF NOT cl_null(g_tqy[l_ac].tqy03) THEN
                CALL t233_tqy03(p_cmd,l_ac)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_tqy[l_ac].tqy03,g_errno,0)
                   NEXT FIELD tqy03
                END IF
             LET g_tqy_o.tqy03 = g_tqy[l_ac].tqy03
          END IF
 
        AFTER FIELD tqyud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqyud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
       BEFORE DELETE                            #是否取消單身
          IF g_tqy_t.tqy02 > 0 AND
             NOT cl_null(g_tqy_t.tqy02) THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM tqy_file
              WHERE tqy01 = g_tqx.tqx01
                AND tqy02 = g_tqy_t.tqy02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tqy_file",g_tqy_t.tqy02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                ROLLBACK WORK 
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn3
             # 批次生成提案明細資料
             SELECT COUNT(*) INTO g_cnt
             FROM tqz_file
             WHERE tqz01=g_tqx.tqx01
             IF g_cnt>0 THEN
                CALL t233_detail_d('d','c',g_tqy_t.tqy02,'')
                     RETURNING g_errno
                IF NOT cl_null(g_errno) THEN
                   LET g_success='N'
                END IF
             END IF
             IF g_success='Y' THEN 
                COMMIT WORK
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_tqy[l_ac].* = g_tqy_t.*
             CLOSE t233_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_tqy[l_ac].tqy02,-263,1)
             LET g_tqy[l_ac].* = g_tqy_t.*
          ELSE
             UPDATE tqy_file SET tqy02 = g_tqy[l_ac].tqy02,
                                    tqy36 = g_tqy[l_ac].tqy36,
                                    tqy03 = g_tqy[l_ac].tqy03,
                                    tqy04 = g_tqy[l_ac].tqy04,
                                    tqy07 = g_tqy[l_ac].tqy07,
                                    tqy05 = g_tqy[l_ac].tqy05,
                                    tqy06 = g_tqy[l_ac].tqy06,
                                    tqy37 = g_tqy[l_ac].tqy37,
                                    tqy38 = g_tqy[l_ac].tqy38,
                                    tqyud01 = g_tqy[l_ac].tqyud01,
                                    tqyud02 = g_tqy[l_ac].tqyud02,
                                    tqyud03 = g_tqy[l_ac].tqyud03,
                                    tqyud04 = g_tqy[l_ac].tqyud04,
                                    tqyud05 = g_tqy[l_ac].tqyud05,
                                    tqyud06 = g_tqy[l_ac].tqyud06,
                                    tqyud07 = g_tqy[l_ac].tqyud07,
                                    tqyud08 = g_tqy[l_ac].tqyud08,
                                    tqyud09 = g_tqy[l_ac].tqyud09,
                                    tqyud10 = g_tqy[l_ac].tqyud10,
                                    tqyud11 = g_tqy[l_ac].tqyud11,
                                    tqyud12 = g_tqy[l_ac].tqyud12,
                                    tqyud13 = g_tqy[l_ac].tqyud13,
                                    tqyud14 = g_tqy[l_ac].tqyud14,
                                    tqyud15 = g_tqy[l_ac].tqyud15
              WHERE tqy01 = g_tqx.tqx01
                AND tqy02 = g_tqy_t.tqy02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tqy_file",g_tqy[l_ac].tqy02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                LET g_tqy[l_ac].* = g_tqy_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                # 更新相關明細資料檔
                IF g_tqy[l_ac].tqy02 != g_tqy_t.tqy02 THEN
                   SELECT COUNT(*) INTO g_cnt
                   FROM tqy_file
                   WHERE tqy01=g_tqx.tqx01
                   IF g_cnt>0 THEN
                      CALL t233_detail_d('u','c',g_tqy_t.tqy02,
                                         g_tqy[l_ac].tqy02)
                           RETURNING g_errno
                      IF NOT cl_null(g_errno) THEN
                         LET g_success='N'
                      END IF
                   END IF
                END IF
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30033 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
            #IF p_cmd = 'a' THEN       #FUN-D30033 mark
            #   CALL g_tqy.deleteElement(l_ac) #FUN-D30033 mark
            #END IF                    #FUN-D30033 mark
             IF p_cmd = 'u' THEN  
                LET g_tqy[l_ac].* = g_tqy_t.*
             #FUN-D30033--add--begin--
             ELSE
                CALL g_tqy.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET g_b_flag = '1'
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end----
             END IF
             CLOSE t233_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30033 add
          CLOSE t233_b2cl
          COMMIT WORK
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(tqy36)     # 查詢dbs
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azp"
                LET g_qryparam.default1 = g_tqy[l_ac].tqy36
                CALL cl_create_qry() RETURNING g_tqy[l_ac].tqy36
                DISPLAY BY NAME g_tqy[l_ac].tqy36
  
             WHEN INFIELD(tqy03)     # 查詢門店資料
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_occ3"
                LET g_qryparam.default1 = g_tqy[l_ac].tqy03
                SELECT azp03 INTO g_azp03 FROM azp_file
                 WHERE azp01=g_tqy[l_ac].tqy36
                IF cl_null(g_azp03) THEN LET g_azp03=g_dbs  END IF
                LET g_qryparam.arg1 = g_azp03
                CALL cl_create_qry() RETURNING g_tqy[l_ac].tqy03	
                DISPLAY BY NAME g_tqy[l_ac].tqy03
             OTHERWISE
                EXIT CASE
         END CASE
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tqy02) AND l_ac > 1 THEN
              LET g_tqy[l_ac].* = g_tqy[l_ac-1].*
              NEXT FIELD tqy02
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #BUG-4C0121
          CALL cl_about()      #BUG-4C0121
 
       ON ACTION help          #BUG-4C0121
          CALL cl_show_help()  #BUG-4C0121
 
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")
       END INPUT
       
       CALL t233_delall()
 
       UPDATE tqx_file SET tqxmodu = g_tqx.tqxmodu,
                           tqxdate = g_tqx.tqxdate
        WHERE tqx01 = g_tqx.tqx01
    
       CLOSE t233_b2cl
       IF g_success='Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
 
       IF l_exit_sw = 'y' THEN
          EXIT WHILE
       ELSE
          CONTINUE WHILE
       END IF
   END WHILE
END FUNCTION
 
#門店代碼
FUNCTION t233_tqy03(p_cmd,p_no)
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          p_no            LIKE type_file.num10,         #No.FUN-680120 INTEGER
          l_sql           LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(400)
   DEFINE l_occ02         LIKE occ_file.occ02,
          l_tqy04         LIKE tqy_file.tqy04,
          l_tqy07         LIKE tqy_file.tqy07,
          l_tqy05         LIKE tqy_file.tqy05,
          l_tqy06         LIKE tqy_file.tqy06,
          l_occacti       LIKE occ_file.occacti,
          l_occ1004       LIKE occ_file.occ1004 
   DEFINE l_dbs           LIKE type_file.chr21          #No.FUN-680120 VARCHAR(21)
   DEFINE l_plant         LIKE tqy_file.tqy36           #FUN-A50102
 
   LET g_errno = ""
 
   SELECT azp03 INTO l_dbs
     FROM azp_file
    WHERE azp01=g_tqy[p_no].tqy36
   LET l_plant = g_tqy[p_no].tqy36    #FUN-A50102
   IF SQLCA.SQLCODE THEN
      LET l_dbs=g_dbs
      LET l_plant = g_plant           #FUN-A50102
   END IF
 
   LET l_sql= " SELECT occ02,occ1007,occ1008,occ1009,occ1010,occacti,occ1004 ",
              #"   FROM ",s_dbstring(l_dbs CLIPPED),"occ_file ", #TQC-940177 
              "   FROM ",cl_get_target_table(l_plant,'occ_file'),  #FUN-A50102   
              "  WHERE occ01='",g_tqy[p_no].tqy03,"' ",
              "    AND occ06='1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE tqy03_pre FROM l_sql
  DECLARE tqy03_cur CURSOR FOR tqy03_pre   
  OPEN tqy03_cur
  FETCH tqy03_cur INTO l_occ02,l_tqy04,l_tqy07,l_tqy05,l_tqy06,l_occacti,l_occ1004
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-027'
                                 LET l_occ02 = ''
                                 LET l_tqy04 = ''
                                 LET l_tqy07 = ''
                                 LET l_tqy05 = ''
                                 LET l_tqy06 = ''
        WHEN l_occacti='N'       LET g_errno='9028'
        WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'  #No.FUN-690023  add
        WHEN l_occ1004!='1'      LET g_errno='9029'   #No.FUN-690025
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   CLOSE tqy03_cur
   
   IF cl_null(g_errno) OR p_cmd='d' THEN
      LET g_tqy[p_no].occ02 = l_occ02
      LET g_tqy[p_no].tqy04 = l_tqy04
      LET g_tqy[p_no].tqy07 = l_tqy07
      LET g_tqy[p_no].tqy05 = l_tqy05
      LET g_tqy[p_no].tqy06 = l_tqy06
   END IF
 
   IF cl_null(g_errno) THEN
      CALL t233_tqy05(p_cmd,p_no)
      CALL t233_tqy06(p_cmd,p_no)
      CALL t233_tqa02(p_cmd,'1',p_no)
   END IF
 
END FUNCTION
 
#省份
FUNCTION t233_tqy05(p_cmd,p_no)
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          p_no            LIKE type_file.num10,         #No.FUN-680120 INTEGER
          l_sql           LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(400)
   DEFINE l_too02         LIKE too_file.too02,
          l_tooacti       LIKE too_file.tooacti
 
   LET g_errno = ""
 
   LET l_sql="SELECT too02 ",
             "  FROM too_file ",
             " WHERE too01 = '",g_tqy[p_no].tqy05,"' "
 
    PREPARE tqy03_pre2 FROM l_sql
    DECLARE tqy03_cur2 CURSOR FOR tqy03_pre2   
    OPEN tqy03_cur2
    FETCH tqy03_cur2 INTO l_too02
    LET g_tqy[p_no].too02 = l_too02
    CLOSE tqy03_cur2
END FUNCTION
 
#地級市
FUNCTION t233_tqy06(p_cmd,p_no)
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          p_no            LIKE type_file.num10,         #TQC-740324 
          l_sql           LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(400)
   DEFINE l_top02      LIKE top_file.top02,
          l_topacti    LIKE top_file.topacti
 
   LET g_errno = ""
 
   LET l_sql = "SELECT top02 ",
               "  FROM top_file ",
               " WHERE top01 = '",g_tqy[p_no].tqy06,"' "
 
    PREPARE tqy02_pre3 FROM l_sql
    DECLARE tqy02_cur3 CURSOR FOR tqy02_pre3  
    OPEN tqy02_cur3
    FETCH tqy02_cur3 INTO l_top02
    LET g_tqy[p_no].top02 = l_top02
    CLOSE tqy02_cur3
 
END FUNCTION
 
FUNCTION t233_b2()
   DEFINE p_cmd           LIKE type_file.chr1,          #處理狀態               #No.FUN-680120 VARCHAR(1)
          l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT      #No.FUN-680120 SMALLINT
          l_n             LIKE type_file.num5,          #檢查重復用             #No.FUN-680120 SMALLINT
          l_cnt           LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #單身鎖住否             #No.FUN-680120 VARCHAR(1)
          l_exit_sw       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #可新增否               #No.FUN-680120 SMALLINT
          l_allow_delete  LIKE type_file.num5,          #可刪除否               #No.FUN-680120 SMALLINT
          l_ima06     LIKE ima_file.ima06,
          l_tqy03     LIKE tqy_file.tqy03
   DEFINE g_cnt       LIKE type_file.num10,
          l_fac       LIKE inb_file.inb08_fac,
          g_ima25     LIKE ima_file.ima25
 
   LET g_action_choice = "" #TQC-740324
   IF s_shut(0) THEN RETURN END IF
   IF g_tqx.tqx01 IS NULL THEN RETURN END IF
 
   SELECT tqx_file.* INTO g_tqx.* FROM tqx_file
    WHERE tqx01=g_tqx.tqx01
 
   #非開立狀態，不能修改
   IF g_tqx.tqx07 != '1' THEN
      CALL cl_err(g_tqx.tqx01,'atm-226',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tqz02,tqz03,tqz031,'','','',",
                      "       tqz18,tqz04,tqz05,tqz06,",
                      "       tqz07,tqz08,tqz09,",
                      "       tqz11,tqz12,tqz13,",
                      "       tqz14,tqz15,tqz16,",
                      "       tqz17,tqz10,'',",
                      "       tqz19,tqz20,tqz21 ",
                      "  FROM tqz_file",
                      "  WHERE tqz01 = ?  AND tqz02 = ?",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t233_bcl CURSOR FROM g_forupd_sql
 
   LET g_tqx.tqxmodu = g_user
   LET g_tqx.tqxdate = g_today
   DISPLAY BY NAME g_tqx.tqxmodu,g_tqx.tqxdate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tqz WITHOUT DEFAULTS FROM s_tqz.* 
       ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b2 != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_success = 'Y'
          OPEN t233_cl USING g_tqx.tqx01 
          IF STATUS THEN
             CALL cl_err("OPEN t233_cl.", STATUS, 1)
             CLOSE t233_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t233_cl INTO g_tqx.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0) # 資料被他人LOCK
             CLOSE t233_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b2 >= l_ac THEN
             LET p_cmd='u'
             LET g_tqz_t.* = g_tqz[l_ac].*  #BACKUP
             LET g_tqz_o.* = g_tqz[l_ac].*  #BACKUP
             OPEN t233_bcl USING g_tqx.tqx01,
                                 g_tqz_t.tqz02
             IF STATUS THEN
                CALL cl_err("OPEN t233_bcl.", STATUS, 1)
                ROLLBACK WORK
                RETURN
             END IF
             FETCH t233_bcl INTO g_tqz[l_ac].* 
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_tqz_t.tqz02,SQLCA.sqlcode,1)
                ROLLBACK WORK
                RETURN
             END IF
             CALL t233_tqz03('d',l_ac)
             CALL t233_tqa02(p_cmd,'2',l_ac)  #TQC-7C0080
             CALL cl_show_fld_cont()    #FUN-55037
             CALL t233_set_entry_b(p_cmd)  
             CALL t233_set_no_entry_b(p_cmd)  
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_tqz[l_ac].* TO NULL
          LET g_tqz[l_ac].tqz09=0
          LET g_tqz[l_ac].tqz11=0
          LET g_tqz[l_ac].tqz12=0
          LET g_tqz[l_ac].tqz13=0
          LET g_tqz[l_ac].tqz14=0
          LET g_tqz[l_ac].tqz15=0
          LET g_tqz[l_ac].tqz16=0
          LET g_tqz[l_ac].tqz17=0
          LET g_tqz[l_ac].tqz19=0
          LET g_tqz[l_ac].tqz20=0
          LET g_tqz[l_ac].tqz21=0
          LET g_tqz_t.* = g_tqz[l_ac].*         #新輸入資料
          LET g_tqz_o.* = g_tqz[l_ac].*         #新輸入資料
          NEXT FIELD tqz02 
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          IF cl_null(g_tqz[l_ac].tqz03) THEN
             NEXT FIELD tqz03
             CANCEL INSERT
          END IF
          INSERT INTO tqz_file(tqz01,tqz02,tqz03,tqz031,
                                  tqz04,tqz05,tqz06,
                                  tqz07,tqz08,tqz09,
                                  tqz10,tqz11,tqz12,
                                  tqz13,tqz14,tqz15,
                                  tqz16,tqz17,tqz18,tqz19,
                                  tqz20,tqz21,
                                  tqzud01,tqzud02,tqzud03,
                                  tqzud04,tqzud05,tqzud06,
                                  tqzud07,tqzud08,tqzud09,
                                  tqzud10,tqzud11,tqzud12,
                                  tqzud13,tqzud14,tqzud15,
                                  tqzplant,tqzlegal   #FUN-980009
                               )
          VALUES(g_tqx.tqx01,g_tqz[l_ac].tqz02,
                 g_tqz[l_ac].tqz03,g_tqz[l_ac].tqz031,
                 g_tqz[l_ac].tqz04,
                 g_tqz[l_ac].tqz05,g_tqz[l_ac].tqz06,
                 g_tqz[l_ac].tqz07,g_tqz[l_ac].tqz08,
                 g_tqz[l_ac].tqz09,g_tqz[l_ac].tqz10,
                 g_tqz[l_ac].tqz11,g_tqz[l_ac].tqz12,
                 g_tqz[l_ac].tqz13,g_tqz[l_ac].tqz14,
                 g_tqz[l_ac].tqz15,g_tqz[l_ac].tqz16,
                 g_tqz[l_ac].tqz17,g_tqz[l_ac].tqz18,
                 g_tqz[l_ac].tqz19,
                 g_tqz[l_ac].tqz20,g_tqz[l_ac].tqz21,
                 g_tqz[l_ac].tqzud01, g_tqz[l_ac].tqzud02,
                 g_tqz[l_ac].tqzud03, g_tqz[l_ac].tqzud04,
                 g_tqz[l_ac].tqzud05, g_tqz[l_ac].tqzud06,
                 g_tqz[l_ac].tqzud07, g_tqz[l_ac].tqzud08,
                 g_tqz[l_ac].tqzud09, g_tqz[l_ac].tqzud10,
                 g_tqz[l_ac].tqzud11, g_tqz[l_ac].tqzud12,
                 g_tqz[l_ac].tqzud13, g_tqz[l_ac].tqzud14,
                 g_tqz[l_ac].tqzud15,
                 g_plant,g_legal       #FUN-980009 
                )
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tqz_file",g_tqz[l_ac].tqz03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
             CANCEL INSERT
             ROLLBACK WORK
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b2=g_rec_b2+1
             DISPLAY g_rec_b2 TO FORMONLY.cn2
             # 批次生成提案明細資料
             SELECT COUNT(*) INTO g_cnt FROM tqy_file
              WHERE tqy01=g_tqx.tqx01
             IF g_cnt>0 THEN
                CALL t233_detail_d('a','i','',g_tqz[l_ac].tqz02)
                     RETURNING g_errno
                IF NOT cl_null(g_errno) THEN
                   LET g_success='N'
                END IF
             END IF
             IF g_success='Y' THEN
                COMMIT WORK
                CALL t233_sum()
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       BEFORE FIELD tqz02                        #default 序號
          IF cl_null(g_tqz[l_ac].tqz02) OR
             g_tqz[l_ac].tqz02 = 0 THEN
             SELECT MAX(tqz02)+1
               INTO g_tqz[l_ac].tqz02
               FROM tqz_file
              WHERE tqz01 = g_tqx.tqx01
             IF g_tqz[l_ac].tqz02 IS NULL THEN
                LET g_tqz[l_ac].tqz02 = 1
             END IF
          END IF
 
       AFTER FIELD tqz02                        #check 序號是否重復
          IF NOT cl_null(g_tqz[l_ac].tqz02) THEN
             IF g_tqz[l_ac].tqz02 != g_tqz_t.tqz02 OR
                cl_null(g_tqz_t.tqz02) THEN
                SELECT COUNT(*) INTO l_n
                  FROM tqz_file
                 WHERE tqz01 = g_tqx.tqx01
                   AND tqz02 = g_tqz[l_ac].tqz02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_tqz[l_ac].tqz02 = g_tqz_t.tqz02
                   NEXT FIELD tqz02
                END IF
             END IF
          END IF
  
       BEFORE FIELD tqz03               #料號
          CALL t233_set_entry_b(p_cmd)  
 
       AFTER FIELD tqz03   # 料件品項 
         IF NOT cl_null(g_tqz[l_ac].tqz03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_tqz[l_ac].tqz03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_tqz[l_ac].tqz03= g_tqz_t.tqz03
               NEXT FIELD tqz03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_tqz[l_ac].tqz03 != g_tqz_t.tqz03
               OR cl_null(g_tqz_t.tqz03) THEN
               SELECT COUNT(*) INTO l_n FROM tqz_file
                WHERE tqz01 = g_tqx.tqx01
                  AND tqz03 = g_tqz[l_ac].tqz03
               IF l_n>0 THEN
                  CALL cl_err(g_tqz[l_ac].tqz03,'atm-310',0) 
                  NEXT FIELD tqz03
               END IF
               IF g_tqz[l_ac].tqz03[1,4] != 'MISC' THEN
                  CALL t233_tqz03('a',l_ac)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tqz[l_ac].tqz03,g_errno,0)
                     NEXT FIELD tqz03
                  END IF
               END IF   
               IF NOT cl_null(g_tqx.tqx13) AND
                  g_tqz[l_ac].tqz03[1,4] != 'MISC' THEN
                  SELECT * FROM tqh_file,ima_file
                   WHERE tqh02=ima1006 
                     AND tqhacti= 'Y'
                     AND ima01=g_tqz[l_ac].tqz03
                     AND tqh01=g_tqx.tqx13
                  IF STATUS = 100 THEN
                     CALL cl_err3("sel","tqh_file,ima_file",g_tqz[l_ac].tqz03,"","atm-018","","",1)   #No.FUN-660104
                     NEXT FIELD tqz03
                  END IF
               END IF
            END IF
         END IF
         CALL t233_set_no_entry_b(p_cmd)
 
      AFTER FIELD tqz04   # 促銷起始日
         IF NOT cl_null(g_tqz[l_ac].tqz04) AND 
            NOT cl_null(g_tqz[l_ac].tqz05) THEN
            IF g_tqz[l_ac].tqz04 != g_tqz_t.tqz04
               OR cl_null(g_tqz_t.tqz04) THEN
               # 促銷終止日不可小于起始日
               IF g_tqz[l_ac].tqz05 < g_tqz[l_ac].tqz04 THEN
                  CALL cl_err(g_tqz[l_ac].tqz04,'axm-262',0)
                  NEXT FIELD tqz04
               END IF
            END IF
         END IF
         IF p_cmd='u' AND g_tqz[l_ac].tqz04 <> g_tqz_t.tqz04 THEN
            LET g_tqz[l_ac].tqz06 = g_tqz[l_ac].tqz04 - g_tqx.tqx10
         END IF
              
      AFTER FIELD tqz05   # 促銷終止日
         IF NOT cl_null(g_tqz[l_ac].tqz05) THEN
            IF g_tqz[l_ac].tqz05 != g_tqz_t.tqz05
               OR cl_null(g_tqz_t.tqz05) THEN
               # 促銷終止日不可小于起始日
               IF g_tqz[l_ac].tqz05 < g_tqz[l_ac].tqz04 THEN
                  CALL cl_err(g_tqz[l_ac].tqz05,'anm-091',0)
                  NEXT FIELD tqz05
               END IF
            END IF
         END IF
         IF p_cmd='u' AND g_tqz[l_ac].tqz05 <> g_tqz_t.tqz05 THEN
            LET g_tqz[l_ac].tqz07 = g_tqz[l_ac].tqz05 + g_tqx.tqx11
         END IF
 
      BEFORE FIELD  tqz06 # 進貨折扣起始日
         IF NOT cl_null(g_tqz[l_ac].tqz04) AND 
            cl_null(g_tqz[l_ac].tqz06) THEN
            # 取得起始日期 和 提前期 之預算結果
            CALL t233_calc_date(g_tqz[l_ac].tqz04,"-",
                                g_tqx.tqx10)
                 RETURNING g_tqz[l_ac].tqz06
            DISPLAY BY NAME g_tqz[l_ac].tqz06
         END IF
 
      AFTER FIELD tqz06   # 進貨折扣起始日
         IF NOT cl_null(g_tqz[l_ac].tqz06) AND
            NOT cl_null(g_tqz[l_ac].tqz07) THEN
            IF g_tqz[l_ac].tqz06 != g_tqz_t.tqz06
               OR cl_null(g_tqz_t.tqz06) THEN
               # 進貨折扣日不可小于起始日
               IF g_tqz[l_ac].tqz07 < g_tqz[l_ac].tqz06 THEN
                  CALL cl_err(g_tqz[l_ac].tqz06,'axm-262',0)
                  NEXT FIELD tqz06
               END IF
               CALL t233_tqz07()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD tqz06
               END IF 
            END IF
         END IF
         
      BEFORE FIELD  tqz07 # 計算進貨折扣終止日 
         IF NOT cl_null(g_tqz[l_ac].tqz05) AND 
            cl_null(g_tqz[l_ac].tqz07) THEN
            # 取得起始日期 和 提前期 之預算結果
            CALL t233_calc_date(g_tqz[l_ac].tqz05,"+",
                                g_tqx.tqx11)
                 RETURNING g_tqz[l_ac].tqz07
            DISPLAY BY NAME g_tqz[l_ac].tqz07
         END IF
      
      AFTER FIELD tqz07   # 進貨折扣終止日
         IF NOT cl_null(g_tqz[l_ac].tqz07) THEN
            IF g_tqz[l_ac].tqz07 != g_tqz_t.tqz07
               OR cl_null(g_tqz_t.tqz07) THEN
               # 進貨折扣日不可小于起始日
               IF g_tqz[l_ac].tqz07 < g_tqz[l_ac].tqz06 THEN
                  CALL cl_err(g_tqz[l_ac].tqz07,'anm-091',0)
                  NEXT FIELD tqz07
               END IF
               CALL t233_tqz07()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD tqz07
               END IF 
            END IF
         END IF
 
      AFTER FIELD tqz08   # 單位
         IF NOT cl_null(g_tqz[l_ac].tqz08) THEN
            IF g_tqz[l_ac].tqz08 != g_tqz_t.tqz08
               OR cl_null(g_tqz_t.tqz08) THEN
               CALL t233_tqz08(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tqz[l_ac].tqz08,g_errno,0)
                  NEXT FIELD tqz08
               END IF
               SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01=g_tqz[l_ac].tqz03
               CALL s_umfchk(g_tqz[l_ac].tqz03,g_tqz[l_ac].tqz08,g_ima25)
                    RETURNING g_cnt,l_fac
               IF g_cnt = 1 THEN
                  CALL cl_err('','mfg3075',1)
                  LET g_tqz[l_ac].tqz08 = g_tqz_t.tqz08
                  DISPLAY BY NAME g_tqz[l_ac].tqz08
                  NEXT FIELD tqz08
               END IF
               #抓取正常進價和標准特價
               CALL t233_get_price()
            END IF
            #No.FUN-BB0086--add--begin--
            LET g_tqz[l_ac].tqz19 = s_digqty(g_tqz[l_ac].tqz19,g_tqz[l_ac].tqz08)
            DISPLAY BY NAME g_tqz[l_ac].tqz19
            #No.FUN-BB0086--add--end--
         END IF
 
      AFTER FIELD tqz09   # 促銷進價
         IF NOT cl_null(g_tqz[l_ac].tqz09) THEN
            IF g_tqz[l_ac].tqz09 <= 0 THEN
               CALL cl_err('','atm-114',0)
               NEXT FIELD tqz09
            END IF
            IF g_tqz[l_ac].tqz09 != g_tqz_t.tqz09
               OR cl_null(g_tqz_t.tqz09) THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM tqz_file,ima_file
                WHERE tqz01 = g_tqx.tqx01
                  AND tqz09 <> g_tqz[l_ac].tqz09
                  AND tqz03 = ima01
                  AND ima135 = g_tqz[l_ac].ima135
               IF g_cnt>0 THEN
                  CALL cl_err('','atm-012',0)
                  NEXT FIELD tqz09
               END IF
               # 計算促銷毛利
               CALL t233_tqz12()
               
               #計算標準特售毛利
               CALL t233_tqz14() #MOD-B30248 add
            END IF
         END IF
 
      AFTER FIELD tqz11             #促銷售價
         IF NOT cl_null(g_tqz[l_ac].tqz11) THEN
            IF g_tqz[l_ac].tqz11<=0 THEN
               CALL cl_err('','atm-114',0)       #MOD-C30110 add atm-144
               NEXT FIELD tqz11
            END IF
            IF g_tqz[l_ac].tqz11 != g_tqz_t.tqz11
               OR cl_null(g_tqz_t.tqz11) THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM tqz_file,ima_file
                WHERE tqz01 = g_tqx.tqx01
                  AND tqz11 <> g_tqz[l_ac].tqz11
                  AND tqz03 = ima01
                  AND ima135 = g_tqz[l_ac].ima135
               IF g_cnt>0 THEN
                  CALL cl_err('','atm-013',0)
                  NEXT FIELD tqz11
               END IF
               #計算促銷毛利
               CALL t233_tqz12()
            END IF
         END IF
 
      AFTER FIELD tqz13           #標准特價
         IF NOT cl_null(g_tqz[l_ac].tqz13) THEN
            IF g_tqz[l_ac].tqz13<=0 THEN
               CALL cl_err('','atm-114',0)       #MOD-C30110 add atm-144
               NEXT FIELD tqz13
            END IF
            IF g_tqz[l_ac].tqz13 != g_tqz_t.tqz13
               OR cl_null(g_tqz_t.tqz13) THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM tqz_file,ima_file
                WHERE tqz01 = g_tqx.tqx01
                  AND tqz13 <> g_tqz[l_ac].tqz13
                  AND tqz03 = ima01
                  AND ima135 = g_tqz[l_ac].ima135
               IF g_cnt>0 THEN
                  CALL cl_err('','atm-014',0)
                  NEXT FIELD tqz13
               END IF
               #計算標准特售毛利
               CALL t233_tqz14()
            END IF
         END IF
 
      AFTER FIELD tqz15  # 正常進價
         IF NOT cl_null(g_tqz[l_ac].tqz15) THEN
            IF g_tqz[l_ac].tqz15<=0 THEN
               CALL cl_err('','atm-114',0)
               NEXT FIELD tqz15
            END IF
            IF g_tqz[l_ac].tqz15 != g_tqz_t.tqz15
               OR cl_null(g_tqz_t.tqz15) THEN
               SELECT COUNT(*) INTO g_cnt                                      
                 FROM tqz_file,ima_file                                     
                WHERE tqz01 = g_tqx.tqx01                           
                  AND tqz15 <> g_tqz[l_ac].tqz15
                  AND tqz03 = ima01
                  AND ima135 = g_tqz[l_ac].ima135
               IF g_cnt>0 THEN
                  CALL cl_err('','atm-015',0)
                  NEXT FIELD tqz15
               END IF
               # 計算正常銷售毛利
               CALL t233_tqz17() #MOD-B30248 add
            END IF
         END IF
 
      AFTER FIELD tqz16  # 正常售價
         IF NOT cl_null(g_tqz[l_ac].tqz16) THEN
            IF g_tqz[l_ac].tqz16<=0 THEN
               CALL cl_err('','atm-114',0)
               NEXT FIELD tqz16
            END IF
            IF g_tqz[l_ac].tqz16 != g_tqz_t.tqz16
               OR cl_null(g_tqz_t.tqz16) THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM tqz_file,ima_file
                WHERE tqz01 = g_tqx.tqx01
                  AND tqz16 <> g_tqz[l_ac].tqz16
                  AND tqz03 = ima01
                  AND ima135 = g_tqz[l_ac].ima135
               IF g_cnt>0 THEN
                  CALL cl_err('','atm-016',0)
                  NEXT FIELD tqz16
               END IF
               # 計算正常銷售毛利
               CALL t233_tqz17()
            END IF
         END IF
 
      AFTER FIELD tqz10 
         IF NOT cl_null(g_tqz[l_ac].tqz10) THEN
              IF g_tqz[l_ac].tqz10 != g_tqz_t.tqz10
                 OR cl_null(g_tqz_t.tqz10) THEN
                 CALL t233_tqa02(p_cmd,'2',l_ac)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tqz[l_ac].tqz10,g_errno,0)
                    LET g_tqz[l_ac].tqz10=g_tqz_t.tqz10
                    NEXT FIELD tqz10
                 END IF
              END IF
           END IF
 
        AFTER FIELD tqzud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqzud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
                 
      BEFORE DELETE                            #是否取消單身
         IF g_tqz_t.tqz02 > 0
            AND g_tqz_t.tqz02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            DELETE FROM tqz_file
             WHERE tqz01 = g_tqx.tqx01
                   AND tqz02 = g_tqz_t.tqz02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tqz_file",g_tqz_t.tqz02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
               CANCEL DELETE
            END IF
            LET g_rec_b2 = g_rec_b2-1
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            # 批次生成提案明細資料
            SELECT COUNT(*) INTO g_cnt FROM tqy_file
            WHERE tqy01=g_tqx.tqx01
            IF g_cnt>0 THEN
               CALL t233_detail_d('d','i',g_tqz_t.tqz02,'')
                    RETURNING g_errno
               IF NOT cl_null(g_errno) THEN
                  LET g_success='N'
               END IF
            END IF
            IF g_success='Y' THEN
               COMMIT WORK
               CALL t233_sum()
            ELSE
               ROLLBACK WORK
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tqz[l_ac].* = g_tqz_t.*
            CLOSE t233_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         UPDATE tqz_file SET tqz02 = g_tqz[l_ac].tqz02,
                                tqz03 = g_tqz[l_ac].tqz03,
                                tqz031= g_tqz[l_ac].tqz031,
                                tqz04 = g_tqz[l_ac].tqz04,
                                tqz05 = g_tqz[l_ac].tqz05,
                                tqz06 = g_tqz[l_ac].tqz06,
                                tqz07 = g_tqz[l_ac].tqz07,
                                tqz08 = g_tqz[l_ac].tqz08,
                                tqz09 = g_tqz[l_ac].tqz09,
                                tqz10 = g_tqz[l_ac].tqz10,
                                tqz11 = g_tqz[l_ac].tqz11,
                                tqz12 = g_tqz[l_ac].tqz12,
                                tqz13 = g_tqz[l_ac].tqz13,
                                tqz14 = g_tqz[l_ac].tqz14,
                                tqz15 = g_tqz[l_ac].tqz15,
                                tqz16 = g_tqz[l_ac].tqz16,
                                tqz17 = g_tqz[l_ac].tqz17, 
                                tqz18 = g_tqz[l_ac].tqz18, 
                                tqz19 = g_tqz[l_ac].tqz19, 
                                tqz20 = g_tqz[l_ac].tqz20, 
                                tqz21 = g_tqz[l_ac].tqz21,
                                tqzud01 = g_tqz[l_ac].tqzud01,
                                tqzud02 = g_tqz[l_ac].tqzud02,
                                tqzud03 = g_tqz[l_ac].tqzud03,
                                tqzud04 = g_tqz[l_ac].tqzud04,
                                tqzud05 = g_tqz[l_ac].tqzud05,
                                tqzud06 = g_tqz[l_ac].tqzud06,
                                tqzud07 = g_tqz[l_ac].tqzud07,
                                tqzud08 = g_tqz[l_ac].tqzud08,
                                tqzud09 = g_tqz[l_ac].tqzud09,
                                tqzud10 = g_tqz[l_ac].tqzud10,
                                tqzud11 = g_tqz[l_ac].tqzud11,
                                tqzud12 = g_tqz[l_ac].tqzud12,
                                tqzud13 = g_tqz[l_ac].tqzud13,
                                tqzud14 = g_tqz[l_ac].tqzud14,
                                tqzud15 = g_tqz[l_ac].tqzud15
          WHERE tqz01 = g_tqx.tqx01
            AND tqz02 = g_tqz_t.tqz02
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tqz_file",g_tqz[l_ac].tqz02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            LET g_tqz[l_ac].* = g_tqz_t.*
            ROLLBACK WORK
         ELSE
            MESSAGE 'UPDATE O.K'
            UPDATE tqx_file SET tqxmodu = g_user,
                                   tqxdate = g_today
             WHERE tqx01 = g_tqx.tqx01
            # 更新相關明細資料檔
            IF g_tqz[l_ac].tqz02 != g_tqz_t.tqz02 THEN
               SELECT COUNT(*) INTO g_cnt FROM tqy_file
                WHERE tqy01=g_tqx.tqx01
               IF g_cnt>0 THEN
                  CALL t233_detail_d('u','i',g_tqz_t.tqz02,
                                     g_tqz[l_ac].tqz02)
                       RETURNING g_errno
                  IF NOT cl_null(g_errno) THEN
                     LET g_success='N'
                  END IF
               END IF
            END IF
            IF g_success='Y' THEN
               COMMIT WORK
               CALL t233_sum()
            ELSE
               ROLLBACK WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_tqz[l_ac].* = g_tqz_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_tqz.deleteElement(l_ac)
               IF g_rec_b2 != 0 THEN 
                  LET g_action_choice = "detail"
                  LET g_b_flag = '2'
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE t233_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac #FUN-D30033 add
         CLOSE t233_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tqz03)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_ima15"
#                LET g_qryparam.default1 = g_tqz[l_ac].tqz03
#                LET g_qryparam.arg1 = g_tqx.tqx13
#                CALL cl_create_qry() RETURNING g_tqz[l_ac].tqz03
                 CALL q_sel_ima(FALSE, "q_ima15","",g_tqz[l_ac].tqz03,g_tqx.tqx13,"","","","",'' ) 
                  RETURNING   g_tqz[l_ac].tqz03 
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_tqz[l_ac].tqz03 TO tqz03
            WHEN INFIELD(tqz08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_tqz[l_ac].tqz08
                 CALL cl_create_qry() RETURNING g_tqz[l_ac].tqz08
                 DISPLAY g_tqz[l_ac].tqz08 TO tqz08
            WHEN INFIELD(tqz10)
                 CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_tqa1"
                 LET g_qryparam.form ="q_tqa"    #No.FUN-AB0034
                 LET g_qryparam.arg1 ="18"
                 LET g_qryparam.default1 = g_tqz[l_ac].tqz10
                 CALL cl_create_qry() RETURNING g_tqz[l_ac].tqz10
                 DISPLAY BY NAME g_tqz[l_ac].tqz10
            OTHERWISE
                 EXIT CASE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tqz02) AND l_ac > 1 THEN
            LET g_tqz[l_ac].* = g_tqz[l_ac-1].*
            NEXT FIELD tqz02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
           
 
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")
   END INPUT
 
   UPDATE tqx_file SET tqxmodu = g_tqx.tqxmodu,
                          tqxdate = g_tqx.tqxdate
    WHERE tqx01 = g_tqx.tqx01
 
   CLOSE t233_bcl
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
#進貨折扣終止日
FUNCTION t233_tqz07()
   DEFINE l_tqy03 LIKE tqy_file.tqy03
 
   LET g_errno=''
   DECLARE tqy07_cur CURSOR FOR
      SELECT tqy03 FROM tqy_file
       WHERE tqy01 = g_tqx.tqx01
   FOREACH tqy07_cur INTO l_tqy03  
      SELECT COUNT(*) INTO g_cnt
        FROM tqx_file,tqy_file,tqz_file
       WHERE tqx01 = tqy01 AND tqx01 = tqz01
             AND tqy03 = l_tqy03
             AND tqz03 = g_tqz[l_ac].tqz03
             AND ((tqz06<=g_tqz[l_ac].tqz07
                   AND tqz07>=g_tqz[l_ac].tqz07)
                   OR(tqz06<=g_tqz[l_ac].tqz06
                      AND tqz07>=g_tqz[l_ac].tqz06))
             AND tqz01<>g_tqx.tqx01 
      IF g_cnt>0 THEN
         LET g_errno='atm-010'
         EXIT FOREACH
      END IF
   END FOREACH
 
END FUNCTION
 
#單位
FUNCTION t233_tqz08(p_cmd)   
   DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_gfeacti    LIKE gfe_file.gfeacti,
          l_tqy36  LIKE tqy_file.tqy36,
          l_dbs        LIKE type_file.chr21          #No.FUN-680120 VARCHAR(21)
 
   SELECT gfeacti INTO l_gfeacti FROM gfe_file
    WHERE gfe01 = g_tqz[l_ac].tqz08
 
   CASE WHEN SQLCA.SQLCODE=100  LET g_errno='afa-319'
        WHEN l_gfeacti='N'      LET g_errno='9028'
        OTHERWISE               LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO g_cnt
        FROM tqz_file,ima_file
       WHERE tqz01 = g_tqx.tqx01 
             AND tqz08 <> g_tqz[l_ac].tqz08
             AND tqz03 = ima01
             AND ima135 = g_tqz[l_ac].ima135
             AND tqz02<>g_tqz_t.tqz02
      IF g_cnt>0 THEN
         LET g_errno='atm-011'
      END IF
   END IF
 
END FUNCTION
 
#抓取正常進價、標准特價
FUNCTION t233_get_price()
   DEFINE l_tqy03   LIKE tqy_file.tqy03,
          l_tqy36   LIKE tqy_file.tqy36,
          l_dbs     LIKE type_file.chr21,           #No.FUN-680120 VARCHAR(21)
          l_plant   LIKE type_file.chr21            #No.FUN-980059 VARCHAR(21)
 
   SELECT COUNT(*) INTO g_cnt
     FROM tqy_file
    WHERE tqy01=g_tqx.tqx01
   IF g_cnt>0 THEN
      DECLARE tqy_cur CURSOR FOR
       SELECT tqy03,tqy36 FROM tqy_file
        WHERE tqy01= g_tqx.tqx01
          AND tqy02=(SELECT MIN(tqy02) FROM tqy_file
                      WHERE tqy01=g_tqx.tqx01)
      OPEN tqy_cur
      FETCH tqy_cur INTO l_tqy03,l_tqy36
      CLOSE tqy_cur
      IF SQLCA.sqlcode THEN
         RETURN
      END IF
      SELECT azp03 INTO l_dbs
        FROM azp_file
       WHERE azp01 = l_tqy36
      IF SQLCA.SQLCODE THEN
         LET l_dbs=s_dbstring(g_dbs CLIPPED) #TQC-940177   
      ELSE
         LET l_dbs=s_dbstring(l_dbs CLIPPED) #TQC-940177 
      END IF
      LET l_plant = l_tqy36      #No.FUN-980059
      CALL s_fetch_price2(l_tqy03,g_tqz[l_ac].tqz03,
                          g_tqz[l_ac].tqz08,g_tqx.tqx02,'1',l_plant,g_tqx.tqx09)   #No.FUN-980059
         RETURNING g_tqm01,g_tqz[l_ac].tqz15,g_flag   #正常進價
      CALL s_fetch_price2(l_tqy03,g_tqz[l_ac].tqz03,
                          g_tqz[l_ac].tqz08,g_tqx.tqx02,'3',l_plant,g_tqx.tqx09)   #No.FUN-980059
         RETURNING g_tqm01,g_tqz[l_ac].tqz13,g_flag1  #標准特價
      IF g_tqx.tqx16='Y' THEN
         LET g_tqz[l_ac].tqz15=g_tqz[l_ac].tqz15*(1+g_tqx.tqx14/100)
         LET g_tqz[l_ac].tqz13=g_tqz[l_ac].tqz13*(1+g_tqx.tqx14/100)
      END IF   
   END IF
 
END FUNCTION    
 
#料號
FUNCTION t233_tqz03(p_cmd,p_ac)
   DEFINE p_cmd         LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   DEFINE p_ac          LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_ima02       LIKE ima_file.ima02
   DEFINE l_ima021      LIKE ima_file.ima021
   DEFINE l_ima1002     LIKE ima_file.ima1002
   DEFINE l_ima1010     LIKE ima_file.ima1010
   DEFINE l_ima31       LIKE ima_file.ima31
   DEFINE l_ima135      LIKE ima_file.ima135
   DEFINE l_imaacti     LIKE ima_file.imaacti
 
   LET g_errno = ' '
 
   SELECT ima02,ima021,ima1002,ima135,ima31,ima1010,imaacti
     INTO l_ima02,l_ima021,l_ima1002,l_ima135,l_ima31,l_ima1010,l_imaacti
     FROM ima_file
    WHERE ima01 = g_tqz[p_ac].tqz03
      AND (ima130 IS NULL OR ima130<>'2')
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-027'
                                 LET l_ima02 = NULL
                                 LET l_ima021= NULL
                                 LET l_ima135= NULL
                                 LET l_ima31 = NULL
                                 LET l_ima1002 = NULL
        WHEN l_imaacti = 'N'     LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038' #No.FUN-690022 add
 
        WHEN l_ima1010 !='1'     LET g_errno = 'atm-017'   #No.FUN-690025
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   LET g_tqz[p_ac].ima021 = l_ima021
   LET g_tqz[p_ac].ima1002= l_ima1002
   LET g_tqz[p_ac].ima135 = l_ima135
   IF p_cmd = 'a' THEN
      LET g_tqz[p_ac].tqz031 = l_ima02
      LET g_tqz[p_ac].tqz08 = l_ima31
      DISPLAY BY NAME g_tqz[p_ac].tqz031
      DISPLAY BY NAME g_tqz[p_ac].tqz08
   END IF
   DISPLAY BY NAME g_tqz[p_ac].ima021
   DISPLAY BY NAME g_tqz[p_ac].ima1002
   DISPLAY BY NAME g_tqz[p_ac].ima135
 
END FUNCTION
 
# 計算促銷毛利
# 促銷毛利=(促銷售價-促銷進價)/促銷售價
FUNCTION t233_tqz12()
 
   IF cl_null(g_tqz[l_ac].tqz11) THEN
      LET g_tqz[l_ac].tqz11=0
   END IF
   IF cl_null(g_tqz[l_ac].tqz09) THEN
      LET g_tqz[l_ac].tqz11=0
   END IF
   IF g_tqz[l_ac].tqz11=0 THEN
      LET g_tqz[l_ac].tqz12=0
   ELSE
      LET g_tqz[l_ac].tqz12 = 
         (g_tqz[l_ac].tqz11 - g_tqz[l_ac].tqz09)/g_tqz[l_ac].tqz11*100
   END IF
   DISPLAY BY NAME g_tqz[l_ac].tqz12
 
END FUNCTION
 
# 計算標准特售毛利
FUNCTION t233_tqz14()
 
   IF cl_null(g_tqz[l_ac].tqz11) THEN
      LET g_tqz[l_ac].tqz11=0
   END IF
   IF cl_null(g_tqz[l_ac].tqz09) THEN
      LET g_tqz[l_ac].tqz09=0
   END IF
   IF cl_null(g_tqz[l_ac].tqz13) THEN
      LET g_tqz[l_ac].tqz13=0
   END IF
   IF g_tqz[l_ac].tqz13=0 THEN
      LET g_tqz[l_ac].tqz14=0
   ELSE
      LET g_tqz[l_ac].tqz14 =
         (g_tqz[l_ac].tqz11 - g_tqz[l_ac].tqz09)/g_tqz[l_ac].tqz13*100
   END IF
   DISPLAY BY NAME g_tqz[l_ac].tqz14
 
END FUNCTION
 
# 計算正常毛利
FUNCTION t233_tqz17()
 
   IF cl_null(g_tqz[l_ac].tqz15) THEN
      LET g_tqz[l_ac].tqz15=0
   END IF
   IF cl_null(g_tqz[l_ac].tqz16) THEN
      LET g_tqz[l_ac].tqz16=0
   END IF
   IF g_tqz[l_ac].tqz16=0 THEN
      LET g_tqz[l_ac].tqz17=0
   ELSE
      LET g_tqz[l_ac].tqz17 = 
          (g_tqz[l_ac].tqz16 - g_tqz[l_ac].tqz15)/g_tqz[l_ac].tqz16*100
   END IF
   DISPLAY BY NAME g_tqz[l_ac].tqz17
 
END FUNCTION
 
#計算金額合計值
FUNCTION t233_sum()
 
   #未稅金額
   SELECT SUM(tqz20) INTO g_tqx.tqx18
     FROM tqz_file
    WHERE tqz01=g_tqx.tqx01
   IF cl_null(g_tqx.tqx18) THEN
      LET g_tqx.tqx18=0
   END IF
   UPDATE tqx_file SET tqx18=g_tqx.tqx18
    WHERE tqx01=g_tqx.tqx01
   DISPLAY BY NAME g_tqx.tqx18
 
   #含稅金額
   SELECT SUM(tqz21) INTO g_tqx.tqx19
     FROM tqz_file
    WHERE tqz01=g_tqx.tqx01
   IF cl_null(g_tqx.tqx19) THEN
      LET g_tqx.tqx19=0
   END IF
   UPDATE tqx_file SET tqx19=g_tqx.tqx19
    WHERE tqx01=g_tqx.tqx01
   DISPLAY BY NAME g_tqx.tqx19
 
END FUNCTION
 
# 調用方式: CALL t233_calc_date(p_date,p_chr,p_interal) RETURNING l_date
# 函數目的: 取得起始日期 和 提前期 之預算結果
# 傳入參數: p_date ( 需計算的參考日期)
#           p_chr  ( 計算運算符號)
#           p_interal ( 需加減間距) 
# 返回參數: l_date ( 運算結果日期)
# 特別注意: 本函數只考慮間隔天數小于30天狀況
FUNCTION t233_calc_date(p_date,p_chr,p_interal)
   DEFINE p_date        LIKE type_file.dat,              #No.FUN-680120 DATE
          p_chr         LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          p_interal     LIKE type_file.num10,            #No.FUN-680120 INTEGER
          l_date        LIKE type_file.dat,              #No.FUN-680120 DATE
          l_year        LIKE type_file.num5,             #No.FUN-680120 VARCHAR(04)
          l_month       LIKE type_file.num5,             #No.FUN-680120 VARCHAR(02)
          l_month_day   LIKE type_file.num10,            #No.FUN-680120 INTEGER
          l_day         LIKE type_file.num5,             #No.FUN-680120 VARCHAR(02)
          l_tmpday      LIKE type_file.num10             #No.FUN-680120 INTEGER
 
   IF cl_null(p_date) OR cl_null(p_interal) THEN 
      RETURN 
   END IF
 
   IF cl_null(p_chr) OR p_chr NOT MATCHES '[-+]' THEN RETURN END IF
 
   # 抓取當前年份
   LET l_year = YEAR(p_date)
 
   # 抓取當前月及當前月最大天數
   LET l_month = MONTH(p_date) USING "&&"
   CALL s_months(p_date) RETURNING l_month_day
 
   # 抓取當前天
   LET l_day = DAY(p_date) USING "&&"
 
   CASE p_chr
      WHEN "-"  LET l_tmpday = l_day - p_interal
      WHEN "+"  LET l_tmpday = l_day + p_interal
   END CASE
 
   # 若計算結果正跨月,則加月
   CASE WHEN l_tmpday > l_month_day 
             LET l_day   = (l_tmpday - l_month_day) USING "&&"
             LET l_month = (l_month + 1) USING "&&"
             IF l_month > 12 THEN
                LET l_month = 1 USING "&&"
                LET l_year = l_year + 1
             END IF
   # 若計算結果負跨月,則減月
        WHEN l_tmpday <= 0 
             LET l_month = (l_month - 1) USING "&&"
             IF l_month = 0 THEN
                LET l_month = 12 USING "&&"
                LET l_year = l_year - 1
             END IF
             LET l_date = MDY(l_month,l_day,l_year)
             CALL s_months(l_date) RETURNING l_month_day
             LET l_day  = (l_tmpday + l_month_day) USING "&&"
   # 否則計算結果只需累計天數
        OTHERWISE
             LET l_day = l_tmpday
   END CASE
 
   LET l_date = MDY(l_month,l_day,l_year)
   RETURN l_date
END FUNCTION
 
FUNCTION t233_b_askkey()
   DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
   CONSTRUCT l_wc2 ON tqy02,tqy03,tqy04,tqy07,tqy05,
                      tqy06,tqy37,tqy38
      FROM s_tqy[1].tqy02,s_tqy[1].tqy03,
           s_tqy[1].tqy04,s_tqy[1].tqy07,
           s_tqy[1].tqy05,s_tqy[1].tqy06,
           s_tqy[1].tqy37,s_tqy[1].tqy38
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL t233_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t233_b_fill(p_wc2)  
   DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
   LET g_sql = "SELECT tqy02,tqy36,tqy03,'',tqy04,'',tqy07,'',",
               "       tqy05,'',tqy06,'',tqy37,tqy38, ",
               "       tqyud01,tqyud02,tqyud03,tqyud04,tqyud05,",
               "       tqyud06,tqyud07,tqyud08,tqyud09,tqyud10,",
               "       tqyud11,tqyud12,tqyud13,tqyud14,tqyud15", 
               "  FROM tqy_file ",
               " WHERE tqy01 = '",g_tqx.tqx01,"'",
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY tqy02 "
   PREPARE t233_pb FROM g_sql
   DECLARE tqy_curs CURSOR FOR t233_pb
 
   CALL g_tqy.clear()
   LET l_ac = 1
   FOREACH tqy_curs INTO g_tqy[l_ac].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
      CALL t233_tqy03('d',l_ac)
      SELECT tqa02 INTO g_tqy[l_ac].tqa02_c
        FROM tqa_file
       WHERE tqa01 = g_tqy[l_ac].tqy04
         AND tqa03 = '10'
      SELECT tqa02 INTO g_tqy[l_ac].tqa02_d
        FROM tqa_file
       WHERE tqa01 = g_tqy[l_ac].tqy07
         AND tqa03 = '11'
      LET l_ac = l_ac + 1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_tqy.deleteElement(l_ac)
   LET g_rec_b = l_ac-1
   DISPLAY g_rec_b TO FORMONLY.cn3
 
END FUNCTION
 
FUNCTION t233_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #No.FUN-A40055--begin
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_tqy TO s_tqy.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
   #      EXIT DISPLAY 
   #  &include "qry_string.4gl"
      LET g_b_flag='1'
   END DISPLAY   
   
   DISPLAY ARRAY g_tqz TO s_tqz.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    #FUN-55037   
   END DISPLAY
      #No.FUN-A40055--begin 
      BEFORE DIALOG 
         CALL cl_show_fld_cont()          
      #No.FUN-A40055--end 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
                                                                                      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac=1
         EXIT DIALOG
      ON ACTION first
         CALL t233_fetch('F')
         EXIT DIALOG
      ON ACTION previous
         CALL t233_fetch('P')
         EXIT DIALOG
      ON ACTION jump
         CALL t233_fetch('/')
         EXIT DIALOG
      ON ACTION next
         CALL t233_fetch('N')
         EXIT DIALOG
      ON ACTION last
         CALL t233_fetch('L')
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  #FUN-590083
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION accept
        # LET g_action_choice="maintain_item"  #FUN-A40055 mark
         LET g_action_choice="detail"          #FUN-A40055 modify 
         EXIT DIALOG
       # CALL t233_b2()
    
      # 選擇客戶
      ON ACTION choose_cust
         LET g_action_choice="choose_cust"
         EXIT DIALOG
 
      # 維護客戶信息
      ON ACTION maintain_cust
         LET g_action_choice="maintain_cust"
         EXIT DIALOG
      #No.FUN-A40055--begin     
#     ON ACTION qry_cust_detail                                                 
#        LET g_action_choice="qry_cust_detail"                                  
#        EXIT DIALOG                                                          
      #No.FUN-A40055--end     
 
      # 選擇料件
      ON ACTION choose_item
         LET g_action_choice="choose_item"
         EXIT DIALOG
 
      # 維護料件信息
      ON ACTION maintain_item
         LET g_action_choice="maintain_item"
         EXIT DIALOG
 
      # 維護明細資料
      ON ACTION detail_data
         LET g_action_choice="detail_data"
         EXIT DIALOG
 
      # 費用明細資料
      ON ACTION expense_detail
         LET g_action_choice="expense_detail"
         EXIT DIALOG
 
      # 申請
      ON ACTION apply_check
         LET g_action_choice="apply_check"
         EXIT DIALOG
 
      # 取消申請
      ON ACTION undo_check 
         LET g_action_choice="undo_check"
         EXIT DIALOG
 
      # 審核
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
 
      # 取消審核 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
         
      #生效
      ON ACTION effect
         LET g_action_choice="effect"
         EXIT DIALOG
 
      #取消生效
      ON ACTION undo_effect
         LET g_action_choice="undo_effect"
         EXIT DIALOG
 
      # 挂起 
      ON ACTION pending
         LET g_action_choice="pending"
         EXIT DIALOG
 
      # 取消挂起 
      ON ACTION undo_pending
         LET g_action_choice="undo_pending"
         EXIT DIALOG
 
      # 結案
      ON ACTION closing
         LET g_action_choice="closing"
         EXIT DIALOG
 
      # 取消結案
      ON ACTION unclosing
         LET g_action_choice="unclosing"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG
 
      &include "qry_string.4gl"
   END DIALOG
     #No.FUN-A40055--end
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t233_b2_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
   IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF 
   LET g_sql = "SELECT tqz02,tqz03,tqz031,ima021,ima1002,ima135,",
               "       tqz18,tqz04,tqz05,tqz06,",
               "       tqz07,tqz08,tqz09,",
               "       tqz11,tqz12,",
               "       tqz13,tqz14,tqz15,",
               "       tqz16,tqz17,tqz10,'',",
               "       tqz19,tqz20,tqz21, ",
               "       tqzud01,tqzud02,tqzud03,tqzud04,tqzud05,",
               "       tqzud06,tqzud07,tqzud08,tqzud09,tqzud10,",
               "       tqzud11,tqzud12,tqzud13,tqzud14,tqzud15", 
               "  FROM tqz_file, OUTER ima_file   ",
               " WHERE tqz01 = '",g_tqx.tqx01 CLIPPED,"'",
               "   AND tqz_file.tqz03 = ima_file.ima01 ",
               "   AND ima_file.ima1010 = '1' ",   #No.FUN-690025
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY tqz02"
   PREPARE t233_pb2 FROM g_sql
   DECLARE tqz_curs CURSOR FOR t233_pb2
 
   CALL g_tqz.clear()
   LET g_cnt = 1
   FOREACH tqz_curs INTO g_tqz[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach.',STATUS,1)
         EXIT FOREACH
      END IF
      
      SELECT tqa02 INTO g_tqz[g_cnt].tqa02_e
        FROM tqa_file
       WHERE tqa01 = g_tqz[g_cnt].tqz10
         AND tqa03 = '18'
      CALL t233_tqz03('d',g_cnt)
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_tqz.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t233_x()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_tqx.tqx01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
 
   SELECT * INTO g_tqx.* FROM tqx_file
    WHERE tqx01=g_tqx.tqx01
 
   # 若已作廢，則返回
   #IF g_tqx.tqx07 = '7' THEN CALL cl_err('','9024',0) RETURN END IF
   
   # 若已經審核，則返回
   IF g_tqx.tqx07 = '4' THEN CALL cl_err('','aap-086',0) RETURN END IF
   
   # 若申請中，已審核，挂起，已結案，作廢則返回
   IF g_tqx.tqx07 matches '[2345]' THEN
      CALL cl_err('','atm-046',0)
      RETURN
   END IF 
 
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t233_cl USING g_tqx.tqx01 
   IF STATUS THEN
      CALL cl_err("OPEN t233_cl.", STATUS, 1)
      CLOSE t233_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t233_cl INTO g_tqx.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE tqx_file SET tqxacti = 'N'
      WHERE tqx01 = g_tqx.tqx01
   IF STATUS THEN
      CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",STATUS,"","",1)   #No.FUN-660104
      LET g_success = 'N'
   END IF
   IF SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err('','aap-161',0) LET g_success='N' 
   END IF
   CLOSE t233_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tqx.tqx01,'V')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t233_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("cancel", FALSE)  #TQC-740324
   DISPLAY ARRAY g_tqy TO s_tqy.* ATTRIBUTE(COUNT=g_rec_b)
   
    BEFORE ROW
         LET l_ac = ARR_CURR()
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
END FUNCTION
 
FUNCTION t233_detail_p()
DEFINE  l_tsa      RECORD LIKE tsa_file.*
DEFINE  l_tqy_cnt  LIKE type_file.num10            #No.FUN-680120 INTEGER  # 提案客戶資料筆數
DEFINE  l_tqz_cnt  LIKE type_file.num10            #No.FUN-680120 INTEGER  # 提案料件資料筆數
 
   IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t233_cl USING g_tqx.tqx01  # 加鎖
   IF STATUS THEN
      CALL cl_err("OPEN t233_cl.", STATUS, 1)
      CLOSE t233_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t233_cl INTO g_tqx.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0)
      CLOSE t233_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_i = 0 
   LET l_tqy_cnt = 0 
   LET l_tqz_cnt = 0 
 
   # 判該提案是否存在客戶，料件資料明細
   SELECT COUNT(*) INTO g_i FROM tsa_file
    WHERE tsa01 = g_tqx.tqx01
   SELECT COUNT(*) INTO l_tqy_cnt FROM tqy_file
    WHERE tqy01 = g_tqx.tqx01
   SELECT COUNT(*) INTO l_tqz_cnt FROM tqz_file
    WHERE tqz01 = g_tqx.tqx01
   IF cl_null(g_i) THEN LET g_i = 0 END IF
   IF cl_null(l_tqy_cnt) THEN LET l_tqy_cnt = 0 END IF
   IF cl_null(l_tqz_cnt) THEN LET l_tqz_cnt = 0 END IF
 
   INITIALIZE l_tsa.* TO NULL
   LET l_tsa.tsa01 = g_tqx.tqx01
   LET l_tsa.tsa04 = 0 
   LET l_tsa.tsa05 = 0 
   LET l_tsa.tsa08 = 0 
 
   IF g_i = 0 THEN 
      # 新增處理
      IF l_tqy_cnt = 0 OR l_tqy_cnt = 0 THEN 
         ROLLBACK WORK
         RETURN
      ELSE 
         # 針對每筆客戶資料組合所有料件咨詢 tqy_file*tqz_file
         DECLARE p_tqy_curs CURSOR FOR
          SELECT tqy02 FROM tqy_file
           WHERE tqy01 = g_tqx.tqx01
           ORDER BY tqy02
         FOREACH p_tqy_curs INTO l_tsa.tsa02
            IF STATUS THEN
               CALL cl_err('p_tqy_curs',SQLCA.sqlcode,0)
               LET g_success = 'N'
               EXIT FOREACH 
            END IF
 
            # 組合料件信息
            DECLARE p_tqz_curs CURSOR FOR
             SELECT tqz02 FROM tqz_file
              WHERE tqz01 = g_tqx.tqx01
              ORDER BY tqz02
            FOREACH p_tqz_curs INTO l_tsa.tsa03
               IF STATUS THEN
                  CALL cl_err('p_tqy_curs',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  EXIT FOREACH 
               END IF
 
               LET l_tsa.tsaplant = g_plant  #FUN-980009
               LET l_tsa.tsalegal = g_legal  #FUN-980009
               INSERT INTO tsa_file VALUES (l_tsa.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","tsa_file",l_tsa.tsa03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                  LET g_success='N'
                  EXIT FOREACH     
               END IF
            END FOREACH
 
            IF g_success='N' THEN 
               EXIT FOREACH     
            END IF
         END FOREACH
      END IF    
   ELSE 
      # 更新處理 
     #CALL t101_detail_b('a',g_tqy[l_ac].tqy02) #MOD-AC0171 Mark #單身維護和自動產生單身時已產生過tsa_file的資料這裡直接mark
   END IF
 
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
 
# 非批處理新增，單身新增客戶料件資料，則需新增tsa_file
FUNCTION t101_detail_b(p_cmd,p_tqy02)
DEFINE  p_cmd         LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE  p_tqy02   LIKE tqy_file.tqy02
DEFINE  l_tsa      RECORD LIKE tsa_file.*
DEFINE  l_tsa_cnt  LIKE type_file.num10            #No.FUN-680120 INTEGER  # 提案客戶資料筆數
 
   IF cl_null(g_tqx.tqx01) THEN RETURN END IF
   IF cl_null(p_cmd) OR p_cmd NOT MATCHES '[aud]' THEN RETURN END IF
   IF cl_null(p_tqy02) THEN RETURN END IF
 
   LET g_i = 0 
   LET l_tsa_cnt = 0 
 
   # 判該提案是否存在客戶，料件資料明細
   SELECT COUNT(*) INTO g_i FROM tsa_file
    WHERE tsa01 = g_tqx.tqx01
   SELECT COUNT(*) INTO l_tsa_cnt FROM tsa_file
    WHERE tsa01 = g_tqx.tqx01
      AND tsa02 = p_tqy02
   IF cl_null(g_i) THEN LET g_i = 0 END IF
   IF cl_null(l_tsa_cnt) THEN LET l_tsa_cnt = 0 END IF
 
   IF g_i != 0 THEN 
      IF p_cmd = 'a' OR p_cmd = 'u' THEN 
         # 新增處理
         BEGIN WORK
         LET g_success = 'Y'
 
         OPEN t233_cl USING g_tqx.tqx01  # 加鎖
         IF STATUS THEN
            CALL cl_err("OPEN t233_cl.", STATUS, 1)
            CLOSE t233_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH t233_cl INTO g_tqx.*    
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_tqx.tqx01,SQLCA.sqlcode,0)
            CLOSE t233_cl
            ROLLBACK WORK
            RETURN
         END IF
       
         # 針對該筆客戶資料組合所有料件咨詢 tqy_file.tqy02*tqz_file
         INITIALIZE l_tsa.* TO NULL
         LET l_tsa.tsa01 = g_tqx.tqx01
         LET l_tsa.tsa02 = p_tqy02
         LET l_tsa.tsa04 = 0 
         LET l_tsa.tsa05 = 0 
         LET l_tsa.tsa08 = 0 
 
         # 組合料件信息
         IF p_cmd = 'a' THEN   # 新增
            DECLARE b_tqz_curs CURSOR FOR
             SELECT tqz02 FROM tqz_file
              WHERE tqz01 = g_tqx.tqx01
              ORDER BY tqz02
            FOREACH b_tqz_curs INTO l_tsa.tsa03
               IF STATUS THEN
                  CALL cl_err('b_tqy_curs',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  EXIT FOREACH 
               END IF
 
               LET l_tsa.tsaplant = g_plant  #FUN-980009
               LET l_tsa.tsalegal = g_legal  #FUN-980009
               INSERT INTO tsa_file VALUES (l_tsa.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","tsa_file",l_tsa.tsa03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                  LET g_success='N'
                  EXIT FOREACH     
               END IF
            END FOREACH
         ELSE   # 更新
            UPDATE tsa_file SET tsa02 = l_tsa.tsa02 
             WHERE tsa01 = l_tsa.tsa01
               AND tsa02 = g_tqy_t.tqy02   # 舊值
            IF STATUS THEN
               CALL cl_err3("upd","tsa_file",l_tsa.tsa01,g_tqy_t.tqy02,STATUS,"","",1)   #No.FUN-660104
               LET g_success = 'N'
            END IF
         END IF
      ELSE 
         # 刪除相關tsa_file明細資料
         DELETE FROM tsa_file
          WHERE tsa01 = g_tqx.tqx01
            AND tsa02 = p_tqy02
         IF STATUS THEN 
            CALL cl_err3("del","tsa_file",g_tqx.tqx01,p_tqy02,STATUS,"","",1)   #No.FUN-660104
            LET g_success = 'N'
         END IF
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t233_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("tqx01",TRUE)
    END IF 
END FUNCTION
 
FUNCTION t233_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("tqx01",FALSE) 
    END IF
END FUNCTION
 
FUNCTION t233_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1               #No.FUN-680120 VARCHAR(1)
                                                                                
    CALL cl_set_comp_entry("tqz031",TRUE)                                                               
END FUNCTION                                                                    
                                                                                
FUNCTION t233_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
                                                                                
    IF g_tqz[l_ac].tqz03[1,4] != 'MISC' THEN
       CALL cl_set_comp_entry("tqz031",FALSE)
    END IF
END FUNCTION
 
# 申請核准
FUNCTION t233_approving()
    DEFINE l_cnt  LIKE type_file.num5          #No.FUN-680120 SMALLINT
    DEFINE l_tqy03 LIKE tqy_file.tqy03 
    DEFINE l_tqz03 LIKE tqz_file.tqz03
    DEFINE l_tqz06,l_tqz06_1 LIKE tqz_file.tqz06
    DEFINE l_tqz07,l_tqz07_1 LIKE tqz_file.tqz07
    DEFINE l_ima1006         LIKE ima_file.ima1006 
    DEFINE  l_tqz09  LIKE tqz_file.tqz09 #TQC-740324
    
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
    SELECT * INTO g_tqx.* FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    # 申請核准時判斷是否當前為開立狀態
    IF g_tqx.tqx07 != '1' THEN 
       CALL cl_err(g_tqx.tqx01,'atm-046',0)
       RETURN 
    END IF
    IF g_tqx.tqxacti = 'N' THEN   
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
 
    DECLARE t233_tqz_cs CURSOR FOR
     SELECT tqz09 FROM tqz_file 
      WHERE tqz01=g_tqx.tqx01
    FOREACH t233_tqz_cs INTO l_tqz09
       IF cl_null(l_tqz09) OR l_tqz09 = 0 THEN
          CALL cl_err(g_tqx.tqx01,'atm-248',0)
          RETURN
       END IF
    END FOREACH
    IF NOT cl_confirm('atm-232') THEN RETURN END IF
    
#判斷是否所有產品對應此債權代碼及所有客戶的系列代碼都存在
#判斷進貨日期不能重疊
    
    LET g_sql = "SELECT tqz03,tqz06,tqz07 FROM tqz_file WHERE tqz01 = '",g_tqx.tqx01,"'"
    DECLARE aprc_cl CURSOR FROM g_sql
    FOREACH aprc_cl INTO l_tqz03, l_tqz06, l_tqz07
       IF STATUS THEN 
          CALL cl_err('aprc_cl',SQLCA.sqlcode,0) 
          EXIT FOREACH 
       END IF
       
       SELECT ima1006 INTO l_ima1006 
         FROM ima_file
        WHERE ima01 = l_tqz03
       IF STATUS THEN 
          CALL cl_err3("sel","ima_file",l_tqz03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
          EXIT FOREACH 
       END IF       
       IF NOT cl_null(g_tqx.tqx13) THEN
          SELECT * FROM tqh_file WHERE tqh01=g_tqx.tqx13
             AND tqh02=l_ima1006
          IF STATUS = 100 THEN
             CALL cl_err3("sel","tqh_file",g_tqx.tqx13,"","atm-018","","",1)   #No.FUN-660104
             EXIT FOREACH
          END IF
       END IF
          
       LET g_sql = "SELECT tqy03 FROM tqy_file WHERE tqy01 = '",g_tqx.tqx01,"'"
       DECLARE aprb_cl CURSOR FROM g_sql
       FOREACH aprb_cl INTO l_tqy03
          IF STATUS THEN 
              CALL cl_err('aprb_cl',SQLCA.sqlcode,0) 
              EXIT FOREACH 
          END IF
          # 判斷進貨日期            
           LET g_sql = "SELECT tqz06,tqz07 FROM tqx_file,tqz_file,tqy_file",
                       " WHERE tqx01=tqz01 AND tqy01=tqz01 AND tqx07='3' ",
                       "   AND tqy03='",l_tqy03,"'",
                       "   AND tqz03='",l_tqz03,"'"     
           DECLARE apra_cl CURSOR FROM g_sql
           FOREACH apra_cl INTO l_tqz06_1,l_tqz07_1
              IF STATUS THEN 
                  CALL cl_err('apra_cl',SQLCA.sqlcode,0) 
                  EXIT FOREACH 
              END IF
                  IF (l_tqz06_1>=l_tqz06 AND l_tqz06_1<l_tqz07 ) OR
                     (l_tqz07_1>=l_tqz06 AND l_tqz07_1<l_tqz07 ) OR
                     (l_tqz06_1<l_tqz06 AND l_tqz07_1>l_tqz07 ) THEN
                      CALL cl_err(l_tqz03,'atm-019',1)
                      RETURN
                  END IF                  
           END FOREACH
        END FOREACH 
   END FOREACH    
 
   BEGIN WORK
   
    UPDATE tqx_file SET tqx07 = '2'
     WHERE tqx01 = g_tqx.tqx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
       ROLLBACK WORK
       RETURN 
    ELSE
       COMMIT WORK
    END IF
   
    SELECT tqx07 INTO g_tqx.tqx07 
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    DISPLAY BY NAME g_tqx.tqx07
 
    CALL t233_pic_show()
END FUNCTION
 
# 取消申請
FUNCTION t233_unapproving()
DEFINE  l_tqx07  LIKE tqx_file.tqx07 
   
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
    SELECT tqx07 INTO l_tqx07
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    # 取消核准時判斷是否當前為已申請核准
    IF l_tqx07 != '2' THEN 
       CALL cl_err(g_tqx.tqx01,'atm-231',0)
       RETURN 
    END IF
    IF g_tqx.tqxacti = 'N' THEN   
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
 
    IF NOT cl_confirm('atm-233') THEN RETURN END IF
 
    BEGIN WORK
    
    UPDATE tqx_file SET tqx07 = '1'
     WHERE tqx01 = g_tqx.tqx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
       ROLLBACK WORK
       RETURN 
    ELSE
       COMMIT WORK
    END IF
 
    SELECT tqx07 INTO g_tqx.tqx07 
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    DISPLAY BY NAME g_tqx.tqx07
 
    CALL t233_pic_show()
END FUNCTION
 
# 審核
FUNCTION t233_confirm()
DEFINE  l_tqx07  LIKE tqx_file.tqx07 
   
#CHI-C30107 ------------- add ------------- begin
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF

    SELECT tqx07 INTO l_tqx07
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01

    # 審核時判斷是否當前為已申請核准
    IF l_tqx07 != '2' THEN
       CALL cl_err(g_tqx.tqx01,'atm-227',0)
       RETURN
    END IF
    IF g_tqx.tqxacti = 'N' THEN
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF 
    SELECT * INTO g_tqx.* FROM tqx_file WHERE tqx01 = g_tqx.tqx01
#CHI-C30107 ------------- add ------------- end
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
    SELECT tqx07 INTO l_tqx07
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    # 審核時判斷是否當前為已申請核准
    IF l_tqx07 != '2' THEN 
       CALL cl_err(g_tqx.tqx01,'atm-227',0)
       RETURN 
    END IF
    IF g_tqx.tqxacti = 'N' THEN   
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
    
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark

 
    BEGIN WORK
    
    UPDATE tqx_file SET tqx07 = '3'
     WHERE tqx01 = g_tqx.tqx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       ROLLBACK WORK
       RETURN 
    ELSE
       COMMIT WORK
    END IF
 
    SELECT tqx07 INTO g_tqx.tqx07 
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    DISPLAY BY NAME g_tqx.tqx07
 
    CALL t233_pic_show()
END FUNCTION
 
# 取消審核
FUNCTION t233_undo_confirm()
DEFINE  l_tqx07  LIKE tqx_file.tqx07 
DEFINE  l_n      LIKE type_file.num5   #TQC-740324
   
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
    SELECT tqx07 INTO l_tqx07
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
    SELECT COUNT(*) INTO l_n FROM tqy_file                                      
     WHERE tqy01 = g_tqx.tqx01                                                  
       AND tqy37 = 'Y'                                                          
    IF l_n > 0 THEN                                                             
       CALL cl_err('','atm-249',0)                                              
       RETURN                                                                   
    END IF                                                                      
 
    # 取消審核時判斷是否當前為已審核
    IF l_tqx07 != '3' THEN 
       CALL cl_err(g_tqx.tqx01,'9025',0)
       RETURN 
    END IF
    IF g_tqx.tqxacti = 'N' THEN   
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
 
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
    BEGIN WORK
    
    UPDATE tqx_file SET tqx07 = '2'
     WHERE tqx01 = g_tqx.tqx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       ROLLBACK WORK
       RETURN 
    ELSE
       COMMIT WORK
    END IF
 
    SELECT tqx07 INTO g_tqx.tqx07 
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    DISPLAY BY NAME g_tqx.tqx07
 
    CALL t233_pic_show()
END FUNCTION
 
# 挂起
FUNCTION t233_hold()
DEFINE  l_tqx07  LIKE tqx_file.tqx07 
   
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
    SELECT tqx07 INTO l_tqx07
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    IF l_tqx07 = '4' THEN 
       CALL cl_err(g_tqx.tqx01,'atm-025',0)
       RETURN 
    END IF
    # 挂起時需判斷當前狀態是否為已審核 
    IF l_tqx07 != '3' THEN 
       CALL cl_err(g_tqx.tqx01,'aap-717',0)
       RETURN 
    END IF
    IF g_tqx.tqxacti = 'N' THEN   
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
 
    IF NOT cl_confirm('atm-026') THEN RETURN END IF
 
    BEGIN WORK
    
    UPDATE tqx_file SET tqx07 = '4'
     WHERE tqx01 = g_tqx.tqx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       ROLLBACK WORK
       RETURN 
    ELSE
       COMMIT WORK
    END IF
 
    SELECT tqx07 INTO g_tqx.tqx07 
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    DISPLAY BY NAME g_tqx.tqx07
 
    CALL t233_pic_show()
END FUNCTION
 
# 取消挂起
FUNCTION t233_unhold()
DEFINE  l_tqx07  LIKE tqx_file.tqx07 
   
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
    SELECT tqx07 INTO l_tqx07
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    # 取消挂起時需判斷當前狀態是否為已挂起
    IF l_tqx07 != '4' THEN 
       CALL cl_err(g_tqx.tqx01,'atm-020',0)
       RETURN 
    END IF
    IF g_tqx.tqxacti = 'N' THEN   
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
 
    IF NOT cl_confirm('atm-027') THEN RETURN END IF
 
    BEGIN WORK
    UPDATE tqx_file SET tqx07 = '3'
     WHERE tqx01 = g_tqx.tqx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       ROLLBACK WORK
       RETURN 
    ELSE
       COMMIT WORK
    END IF
 
    SELECT tqx07 INTO g_tqx.tqx07 
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    DISPLAY BY NAME g_tqx.tqx07
 
    CALL t233_pic_show()
END FUNCTION
 
# 顯示審核等相關圖片
FUNCTION t233_pic_show()
DEFINE  l_confirm    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_approve    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_close      LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_void       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_valid      LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_apply      LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_hold       LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1) 
 
    LET l_confirm = 'N'
    LET l_approve = 'N'
    LET l_close   = 'N'
    LET l_void    = 'N'
    LET l_apply   = 'N'
    LET l_hold    = 'N'
    CASE g_tqx.tqx07
       WHEN '5' LET l_close = 'Y'
       WHEN '2' LET l_approve = 'Y'
       WHEN '3' LET l_confirm = 'Y'
       WHEN '4' LET l_hold = 'Y'
    END CASE
    CALL cl_set_field_pic1(l_confirm,"","",l_close,l_void,l_valid,l_approve,l_hold)
END FUNCTION 
 
#提案明細資料處理作業
FUNCTION t233_detail_d(p_cmd,p_source,p_o_value,p_n_value)
  DEFINE p_cmd      LIKE type_file.chr1,    #動作類型：'a'-新增,'u'-修改,'d'-刪除,'p'-批量        #No.FUN-680120 VARCHAR(1)
         p_source   LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)     #數據來源：'c'-客戶,'i'-料件
         p_o_value  LIKE type_file.num10,            #No.FUN-680120 INTEGER     #舊值
         p_n_value  LIKE type_file.num10,            #No.FUN-680120 INTEGER     #新值
         l_tqx18    LIKE tqx_file.tqx18,
         l_tqx19    LIKE tqx_file.tqx19,
         l_tqz19  LIKE tqz_file.tqz19,
         l_tqz20  LIKE tqz_file.tqz20,
         l_tqz21  LIKE tqz_file.tqz21,
         l_n      LIKE type_file.num5,            #No.FUN-680120 SMALLINT
         l_sql      LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(400)
         l_sql1     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(400)
         l_value    LIKE type_file.num10,         #No.FUN-680120 INTEGER
         l_value1   LIKE type_file.num10,         #No.FUN-680120 INTEGER
         l_errno    STRING        #返回錯誤號
 
  LET l_errno=' '
 
  CASE WHEN p_cmd='a'
            IF p_source='c' THEN
               LET l_sql="SELECT tqz02 FROM tqz_file ",
                         " WHERE tqz01='",g_tqx.tqx01 CLIPPED,"'"
               DECLARE ac_cur CURSOR FROM l_sql
               FOREACH ac_cur INTO l_value
                  LET l_sql1="INSERT INTO tsa_file(tsa01,tsa02,",
                             "tsa03,tsa04,tsa05,tsa08,",
                             "tsaplant,tsalegal) ", #FUN-980009
                             " VALUES('",g_tqx.tqx01 CLIPPED,"',",
                             p_n_value,",",l_value,",0,0,0,",
                             "'",g_plant,"','",g_legal,"')" #FUN-980009
                  PREPARE ac_cur1 FROM l_sql1
                  EXECUTE ac_cur1
                  IF SQLCA.SQLCODE THEN
                     LET l_errno = SQLCA.SQLCODE
                     RETURN l_errno
                  END IF
               END FOREACH
            END IF
            IF p_source='i' THEN
               LET l_sql="SELECT tqy02 FROM tqy_file ",
                         " WHERE tqy01='",g_tqx.tqx01 CLIPPED,"'"
               DECLARE ai_cur CURSOR FROM l_sql
               FOREACH ai_cur INTO l_value
                  LET l_sql1="INSERT INTO tsa_file(tsa01,tsa02,",
                             "tsa03,tsa04,tsa05,tsa08,",
                             "tsaplant,tsalegal)",
                             " VALUES('",g_tqx.tqx01 CLIPPED,"',",
                             l_value,",",p_n_value,",0,0,0,",
                             "'",g_plant,"','",g_legal,"')" #FUN-980009
                                 
                  PREPARE ai_cur1 FROM l_sql1
                  EXECUTE ai_cur1
                  IF SQLCA.SQLCODE THEN
                     LET l_errno = SQLCA.SQLCODE
                     RETURN l_errno
                  END IF
               END FOREACH
            END IF
       WHEN p_cmd='u'
            IF p_source='c' THEN
               UPDATE tsa_file
               SET tsa02 = p_n_value
               WHERE tsa02=p_o_value
                     AND tsa01=g_tqx.tqx01
               IF SQLCA.SQLCODE THEN
                  LET l_errno = SQLCA.SQLCODE
                  RETURN l_errno
               END IF
            END IF
            IF p_source='i' THEN
               UPDATE tsa_file
               SET tsa03 = p_n_value
               WHERE tsa01=g_tqx.tqx01
                     AND tsa03=p_o_value
               IF SQLCA.SQLCODE THEN
                  LET l_errno = SQLCA.SQLCODE
                  RETURN l_errno
               END IF
            END IF
       WHEN p_cmd='p'
            LET l_sql="SELECT tqy02 FROM tqy_file ",
                      " WHERE tqy01='",g_tqx.tqx01 CLIPPED,"'"  
            PREPARE pc_pre FROM l_sql
            DECLARE pc_cur CURSOR FOR pc_pre
            FOREACH pc_cur INTO l_value
               LET l_sql1="SELECT tqz02 FROM tqz_file ",
                          " WHERE tqz01='",g_tqx.tqx01 CLIPPED,"'"
               PREPARE pc_pre1 FROM l_sql1
               DECLARE pc_cur1 CURSOR FOR pc_pre1
               FOREACH pc_cur1 INTO l_value1
                  INSERT INTO tsa_file(tsa01,tsa02,tsa03,
                                          tsa04,tsa05,tsa08,
                                       tsaplant,tsalegal) #FUN-980009
                  VALUES(g_tqx.tqx01,l_value,l_value1,0,0,0,
                         g_plant,g_legal) #FUN-980009
                  IF SQLCA.SQLCODE THEN
                     LET l_errno = SQLCA.SQLCODE
                     RETURN l_errno
                  END IF
               END FOREACH
            END FOREACH
       WHEN p_cmd='d'
            IF p_source='c' THEN
               DELETE FROM tsa_file
               WHERE tsa01=g_tqx.tqx01 AND tsa02=p_o_value
               IF SQLCA.SQLCODE THEN
                  LET l_errno = SQLCA.SQLCODE
                  RETURN l_errno
               END IF
               DELETE FROM tsb_file
               WHERE tsb01=g_tqx.tqx01 AND tsb03=p_o_value
               IF SQLCA.SQLCODE THEN
                  LET l_errno = SQLCA.SQLCODE
                  RETURN l_errno
               END IF
            END IF
            IF p_source='i' THEN
               DELETE FROM tsa_file
               WHERE tsa01=g_tqx.tqx01 AND tsa03=p_o_value
               IF SQLCA.SQLCODE THEN
                  LET l_errno = SQLCA.SQLCODE
                  RETURN l_errno
               END IF
            END IF
            DECLARE t233_tqz02_cs CURSOR FOR
             SELECT tqz02 FROM tqz_file 
              WHERE tqz01=g_tqx.tqx01
            FOREACH t233_tqz02_cs INTO l_n
               SELECT SUM(tsa04),SUM(tsa05),SUM(tsa08) 
                 INTO l_tqz19,l_tqz20,l_tqz21
                 FROM tsa_file
                WHERE tsa01=g_tqx.tqx01
                  AND tsa03=l_n
               IF SQLCA.SQLCODE THEN
                  LET l_tqz19=NULL
                  LET l_tqz20=NULL
                  LET l_tqz21=NULL
               END IF
               UPDATE tqz_file SET tqz19=l_tqz19,tqz20=l_tqz20,tqz21=l_tqz21
                WHERE tqz01=g_tqx.tqx01
                  AND tqz02=l_n
            END FOREACH
            SELECT SUM(tsa05),SUM(tsa08) INTO g_tqx.tqx18,g_tqx.tqx19
              FROM tsa_file
             WHERE tsa01=g_tqx.tqx01
            IF SQLCA.SQLCODE THEN
               LET g_tqx.tqx18=NULL
               LET g_tqx.tqx19=NULL
            END IF
            UPDATE tqx_file SET tqx18=g_tqx.tqx18,tqx19=g_tqx.tqx19
             WHERE tqx01=g_tqx.tqx01
            IF p_source='c' THEN
               CALL t233_b2_fill(' 1=1')
            END IF
  END CASE
  DISPLAY BY NAME g_tqx.tqx18
  DISPLAY BY NAME g_tqx.tqx19
  DISPLAY ARRAY g_tqz TO s_tqz.* ATTRIBUTE(COUNT=g_rec_b2)
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
  
  RETURN l_errno
 
END FUNCTION
 
FUNCTION t233_delall()
DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680120 SMALLINT
    IF l_ac > 0 THEN  #FUN-D30033 add
       IF NOT cl_null(g_tqy[l_ac].tqy02) and cl_null(g_tqy[l_ac].tqy03) THEN 
          # 未輸入單身資料,
 
          DELETE FROM tqy_file 
           WHERE tqy01 = g_tqx.tqx01
             AND tqy02 = g_tqy[l_ac].tqy02
 
          SELECT COUNT(*) INTO l_cnt FROM tsa_file
           WHERE tsa01=g_tqx.tqx01
             AND tsa02=g_tqy[l_ac].tqy02
             AND tsa03=g_tqz[l_ac].tqz02
  
          IF l_cnt>0 THEN
             DELETE FROM tsa_file 
              WHERE tsa01=g_tqx.tqx01
                AND tsa02=g_tqy[l_ac].tqy02
                AND tsa03=g_tqz[l_ac].tqz02
          END IF
       END IF
    END IF  #FUN-D30033 add
END FUNCTION
 
FUNCTION t233_copy()  
   DEFINE l_newno        LIKE tqx_file.tqx01,
          l_oldno        LIKE tqx_file.tqx01,
          l_tqx01_t  LIKE tqx_file.tqx01,
          l_tqx02_t  LIKE tqx_file.tqx02,
          l_newdate      LIKE tqx_file.tqx04,
          l_cnt1         LIKE type_file.num10,           #No.FUN-680120 INTEGER
          l_cnt2         LIKE type_file.num10,           #No.FUN-680120 INTEGER
          l_cnt3         LIKE type_file.num10,           #No.FUN-680120 INTEGER
          l_cnt4         LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE li_result    LIKE type_file.num5                  #No.FUN-680120 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tqx.tqx01 IS NULL THEN
      CALL cl_err('',-420,0)
      RETURN
   END IF
   LET l_tqx01_t = g_tqx.tqx01
   LET l_tqx02_t = g_tqx.tqx02
 
   BEGIN WORK
   LET g_before_input_done = FALSE      #TQC-940097    
   CALL t233_set_entry('a')             #TQC-940097   
   LET l_newdate = g_today 
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT l_newno,l_newdate WITHOUT DEFAULTS
      FROM tqx01,tqx02 
 
      AFTER FIELD tqx01               #提案單號
         IF NOT cl_null(l_newno) THEN
            #CALL s_check_no("axm",l_newno,g_tqx_t.tqx01,"01","tqx_file","tqx01","") #FUN-A70130
           #CALL s_check_no("atm",l_newno,g_tqx_t.tqx01,"U2","tqx_file","tqx01","") #FUN-A70130
            CALL s_check_no("atm",l_newno,"","U2","tqx_file","tqx01","") #FUN-A70130  #FUN-B50026 mod
                   RETURNING li_result,g_tqx.tqx01
              IF (NOT li_result) THEN
                  NEXT FIELD tqx01
              END IF
         END IF
         #CALL s_auto_assign_no("axm",l_newno,g_today,"01","tqx_file","tqx01","","","") #FUN-A70130
         CALL s_auto_assign_no("atm",l_newno,g_today,"U2","tqx_file","tqx01","","","") #FUN-A70130
              RETURNING li_result,l_newno
         IF (NOT li_result) THEN                                             
             ROLLBACK WORK                                                    
             NEXT FIELD tqx01                                                 
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tqx01) #查詢單據
                 CALL q_oay(FALSE,FALSE,l_newno,'U2','ATM') RETURNING l_newno   #TQC-670008  #FUN-A70130
                 DISPLAY l_newno TO tqx01
                 NEXT FIELD tqx01
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
 
   END INPUT
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_tqx.tqx01
       RETURN
   END IF
 
   DROP TABLE y
   SELECT * FROM tqx_file         #單頭復制
    WHERE tqx01=l_tqx01_t
     INTO TEMP y
   UPDATE y SET tqx01=l_newno,    #新的鍵值97-05-26
                tqx02=l_newdate,  #新的日期No.B359
                tqx07='1',        #狀況碼
                tqxuser=g_user,   #資料所有者
                tqxgrup=g_grup,   #資料所有者所屬群
                tqxmodu=NULL,     #資料修改日期
                tqxdate=g_today,  #資料建立日期
                tqxacti='Y'       #有效資料
   INSERT INTO tqx_file
   SELECT * FROM y
 
   LET l_oldno = g_tqx.tqx01
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","tqx_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660104
      ROLLBACK WORK
      RETURN
   END IF
 
   LET p_row = 10 LET p_col = 27
   OPEN WINDOW t233_4_w AT p_row,p_col WITH FORM "atm/42f/atmt233_4"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("atmt233_4")
 
   LET a='N'  LET b='N'  LET c='N'
 
   INPUT BY NAME a,b,c 
      WITHOUT DEFAULTS
 
      AFTER FIELD a
         IF NOT cl_null(a) THEN
            IF a NOT MATCHES '[YN]' THEN
               NEXT FIELD a
            END IF
         END IF
 
      AFTER FIELD b 
         IF NOT cl_null(b) THEN
            IF b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
         END IF
     
      AFTER FIELD c 
         IF NOT cl_null(c) THEN
            IF c NOT MATCHES '[YN]' THEN
               NEXT FIELD c
            END IF
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0 LET a='N' LET b='N' LET c='N'
      CLOSE WINDOW t233_4_w
      ROLLBACK WORK
      RETURN
   END IF
   CLOSE WINDOW t233_4_w
 
   IF a='Y' THEN    #門店資料
      DROP TABLE x 
      SELECT * FROM tqy_file         #單身復制
       WHERE tqy01=l_tqx01_t
        INTO TEMP x
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","x",l_tqx01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
      UPDATE x SET tqy01=l_newno,
                   tqy37='N',
                   tqy38=''
      INSERT INTO tqy_file
      SELECT * FROM x
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tqy_file",l_tqx01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   IF b='Y' THEN    #產品資料
      DROP TABLE m 
      SELECT * FROM tqz_file         #單身復制
       WHERE tqz01=l_tqx01_t
        INTO TEMP m 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","m",l_tqx01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
      UPDATE m SET tqz01=l_newno
      INSERT INTO tqz_file
      SELECT * FROM m 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tqz_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   IF c='Y' THEN    #費用資料
      DROP TABLE n 
      SELECT * FROM tsb_file         #單身復制
       WHERE tsb01=l_tqx01_t
        INTO TEMP n 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","n",l_tqx01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
      UPDATE n SET tsb01=l_newno
      INSERT INTO tsb_file
      SELECT * FROM n 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tsb_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   IF a='Y' AND b='Y' THEN    #copy明細資料
      DROP TABLE p 
      SELECT * FROM tsa_file        
       WHERE tsa01=l_tqx01_t
        INTO TEMP p 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","p",l_tqx01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
      UPDATE p SET tsa01=l_newno
      INSERT INTO tsa_file
      SELECT * FROM p 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tsa_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   COMMIT WORK
 
   SELECT tqx_file.* INTO g_tqx.*
     FROM tqx_file
    WHERE tqx01 = l_newno
   
   CALL t233_u()
   CALL t233_b() 
   CALL t233_b2()  
   #FUN-C80046---begin
   #SELECT tqx_file.* INTO g_tqx.*  
   #  FROM tqx_file  
   # WHERE tqx01 = l_tqx01_t 
   #CALL t233_show()   
   #FUN-C80046---end
END FUNCTION
 
# 結案
FUNCTION t233_close()
DEFINE  l_tqx07  LIKE tqx_file.tqx07 
   
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
    SELECT tqx07 INTO l_tqx07
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    # 結案時判斷是否當前為已審核狀態
    IF l_tqx07 != '3' THEN 
       CALL cl_err(g_tqx.tqx01,'9026',0)
       RETURN 
    END IF
    IF g_tqx.tqxacti = 'N' THEN   
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
    
    IF NOT cl_confirm('amm-049') THEN RETURN END IF
 
    BEGIN WORK
    
    UPDATE tqx_file SET tqx07 = '5'
     WHERE tqx01 = g_tqx.tqx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       ROLLBACK WORK
       RETURN 
    ELSE
       COMMIT WORK
    END IF
 
    SELECT tqx07 INTO g_tqx.tqx07 
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    DISPLAY BY NAME g_tqx.tqx07
 
    CALL t233_pic_show()
END FUNCTION
 
# 取消結案
FUNCTION t233_unclose()
DEFINE  l_tqx07  LIKE tqx_file.tqx07 
   
    IF cl_null(g_tqx.tqx01) THEN RETURN END IF
 
    SELECT tqx07 INTO l_tqx07
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    # 取消審核時判斷是否當前為已審核
    IF l_tqx07 != '5' THEN 
       CALL cl_err(g_tqx.tqx01,'atm-005',0)
       RETURN 
    END IF
    IF g_tqx.tqxacti = 'N' THEN   
       CALL cl_err(g_tqx.tqx01,'mfg1000',0)
       RETURN
    END IF
 
    IF NOT cl_confirm('amm-050') THEN RETURN END IF
 
    BEGIN WORK
    
    UPDATE tqx_file SET tqx07 = '3'
     WHERE tqx01 = g_tqx.tqx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tqx_file",g_tqx.tqx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       ROLLBACK WORK
       RETURN 
    ELSE
       COMMIT WORK
    END IF
 
    SELECT tqx07 INTO g_tqx.tqx07 
      FROM tqx_file
     WHERE tqx01 = g_tqx.tqx01
 
    DISPLAY BY NAME g_tqx.tqx07
 
    CALL t233_pic_show()
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18
