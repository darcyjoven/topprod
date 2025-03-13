# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt230.4gl
# Descriptions...: 客退問題確認單維護作業
# Date & Author..: 98/04/23 By plum
#        Modify..: 04/07/16 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510044 05/02/03 By Mandy 報表轉XML
# Modify.........: No.FUN-550064 05/05/30 By Trisy 單據編號加大
# Modify.........: NO.FUN-560014 05/06/09 By jackie 單據編號修改
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: NO.TQC-5A0097 05/10/26 By Niocla 單據性質取位修改
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: No.TQC-630147 06/03/15 By 文件單號/RMA單號^P查無單別
# Modify.........: No.MOD-640452 06/04/13 By Sarah 回覆日期應控管不可小於提出日期
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b]
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740129 07/04/20 By sherry  錄入無此筆資料時，仍可錄入成功
# Modify.........: No.TQC-750041 07/05/14 By sherry  更改時文件編號能被修改。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770022 07/07/06 By Smapmin 修改開窗所帶的變數
# Modify.........: No.TQC-790051 07/09/10 By lumxa  點查詢時，狀態中的所有欄位都是灰色，不能被查詢
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/24 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: NO.FUN-860018 08/06/17 BY TSD.jarlin 轉成CR報表
# Modify.........: No.FUN-890102 08/09/23 By baofei  CR追單到31區
# Modify.........: No.TQC-930116 09/03/31 By chenyu 已經錄入的審核過或未審核的RMA單號要給出提示，不能讓這個單號無限制的審核
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10029 10/01/07 By Carrier 自动产生单身时没有资料,不做CLEAR FORM
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70130 10/09/08 By huangtao
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.MOD-B70070 11/07/08 By Vampire 註解 CALL s_check_no()
# Modify.........: No.FUN-910088 11/12/22 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/19 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rmn   RECORD LIKE rmn_file.*,
    g_rmn_t RECORD LIKE rmn_file.*,
    g_rmn_o RECORD LIKE rmn_file.*,
    l_rmo   RECORD LIKE rmo_file.*,
    g_rmo           DYNAMIC ARRAY OF RECORD    #程式變數(Prohram Variables)
                    rmo02     LIKE rmo_file.rmo02,
                    rmo04     LIKE rmo_file.rmo04,
                    rmo05     LIKE rmo_file.rmo05,
                    rmo06     LIKE rmo_file.rmo06,
                    rmo07     LIKE rmo_file.rmo07,
                    rmo08     LIKE rmo_file.rmo08,
                  #FUN-840068 --start---
                    rmoud01   LIKE rmo_file.rmoud01,
                    rmoud02   LIKE rmo_file.rmoud02,
                    rmoud03   LIKE rmo_file.rmoud03,
                    rmoud04   LIKE rmo_file.rmoud04,
                    rmoud05   LIKE rmo_file.rmoud05,
                    rmoud06   LIKE rmo_file.rmoud06,
                    rmoud07   LIKE rmo_file.rmoud07,
                    rmoud08   LIKE rmo_file.rmoud08,
                    rmoud09   LIKE rmo_file.rmoud09,
                    rmoud10   LIKE rmo_file.rmoud10,
                    rmoud11   LIKE rmo_file.rmoud11,
                    rmoud12   LIKE rmo_file.rmoud12,
                    rmoud13   LIKE rmo_file.rmoud13,
                    rmoud14   LIKE rmo_file.rmoud14,
                    rmoud15   LIKE rmo_file.rmoud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmo_t         RECORD
                    rmo02     LIKE rmo_file.rmo02,
                    rmo04     LIKE rmo_file.rmo04,
                    rmo05     LIKE rmo_file.rmo05,
                    rmo06     LIKE rmo_file.rmo06,
                    rmo07     LIKE rmo_file.rmo07,
                    rmo08     LIKE rmo_file.rmo08,
                  #FUN-840068 --start---
                    rmoud01   LIKE rmo_file.rmoud01,
                    rmoud02   LIKE rmo_file.rmoud02,
                    rmoud03   LIKE rmo_file.rmoud03,
                    rmoud04   LIKE rmo_file.rmoud04,
                    rmoud05   LIKE rmo_file.rmoud05,
                    rmoud06   LIKE rmo_file.rmoud06,
                    rmoud07   LIKE rmo_file.rmoud07,
                    rmoud08   LIKE rmo_file.rmoud08,
                    rmoud09   LIKE rmo_file.rmoud09,
                    rmoud10   LIKE rmo_file.rmoud10,
                    rmoud11   LIKE rmo_file.rmoud11,
                    rmoud12   LIKE rmo_file.rmoud12,
                    rmoud13   LIKE rmo_file.rmoud13,
                    rmoud14   LIKE rmo_file.rmoud14,
                    rmoud15   LIKE rmo_file.rmoud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmn01_t       LIKE rmn_file.rmn01,
    g_wc,g_wc2          STRING,  #No.FUN-580092 HCN
    g_sql,g_wc3,l_sql   STRING,  #No.FUN-580092 HCN
    g_t,g_t1            LIKE oay_file.oayslip,           #No.FUN-550064  #No.FUN-690010 VARCHAR(5)
    g_err,p_cmd         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5                 #No.FUN-690010 SMALLINT               #目前處理的SCREEN LINE
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570109  #No.FUN-690010 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_argv1  LIKE rmn_file.rmn01 #No.FUN-690010 VARCHAR(16)            #No.FUN-4A0081
DEFINE g_argv2  STRING              #No.FUN-4A0081
DEFINE l_table  STRING              #NO.FUN-860018  BY TSD.jarlin---                                                                
DEFINE g_str    STRING              #NO.FUN-860018  BY TSD.jarlin---    
DEFINE g_void            LIKE type_file.chr1  #CHI-C80041

MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0085
    p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF
    #--------NO.FUN-860018 BY TSD.jarlin<<temp table>>------(S)                                                                     
    LET g_sql = "ima021.ima_file.ima021,",  #物料編號                                                                               
                "rmn01.rmn_file.rmn01,",    #文件編號                                                                               
                "rmn02.rmn_file.rmn02,",    #客戶編號                                                                               
                "rmn03.rmn_file.rmn03,",    #客戶簡稱                                                                               
                "rmn05.rmn_file.rmn05,",    #RMA單號                                                                                
                "rmn06.rmn_file.rmn06,",    #提出問題時間                                                                           
                "rmn07.rmn_file.rmn07,",    #回覆問題時間                                                                           
                "rmo02.rmo_file.rmo02,",    #項次                                                                                   
                "rmo04.rmo_file.rmo04,",    #序號資料項次                                                                           
                "rmo05.rmo_file.rmo05,",    #料件編號                                                                               
                "rmo06.rmo_file.rmo06,",    #品名                                                                                   
                "rmo07.rmo_file.rmo07,",    #單位                                                                                   
                "rmo08.rmo_file.rmo08"      #數量                                                                                   
                                                                                                                                    
    LET l_table = cl_prt_temptable('armt230',g_sql) CLIPPED                                                                         
    IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
                                                                                                                                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"                                                                              
    PREPARE insert_prep FROM g_sql   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)                                                                                         
       EXIT PROGRAM                                                                                                                 
    END IF                                                                                                                          
    #--------NO.FUN-860018----------------------------------(E)  
    LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
    LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM rmn_file WHERE rmn01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t230_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 8
    OPEN WINDOW t230_w AT p_row,p_col WITH FORM "arm/42f/armt230"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #No.FUN-4A0081 --start--
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t230_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t230_a()
             END IF
          OTHERWISE 
                CALL t230_q()
       END CASE
    END IF
    #No.FUN-4A0081 ---end---
 
    CALL t230_menu()
    CLOSE WINDOW t230_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t230_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_rmo.clear()
 
    IF cl_null(g_argv1) THEN   #FUN-4A0081
       WHILE TRUE  
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rmn.* TO NULL    #No.FUN-750051
          CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
             rmn01,rmn05,rmn06,rmn02,rmn03,rmn04,rmn07,
             rmnuser,rmnmodu,rmnvoid,rmngrup,rmndate    #TQC-790051
           #FUN-840068   ---start---
            ,rmnud01,rmnud02,rmnud03,rmnud04,rmnud05,
             rmnud06,rmnud07,rmnud08,rmnud09,rmnud10,
             rmnud11,rmnud12,rmnud13,rmnud14,rmnud15
           #FUN-840068    ----end----
 
             #No.FUN-580031 --start--     HCN
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
             #No.FUN-580031 --end--       HCN
 
             ON ACTION CONTROLP
                 CASE
                   WHEN INFIELD(rmn02)    # 查詢客戶編號
#                    CALL q_occ(10,22,g_rmn.rmn02) RETURNING g_rmn.rmn02
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_occ"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rmn02
                     NEXT FIELD rmn02
                   WHEN INFIELD(rmn01) #查詢單据
         #---------------------No.TQC-630147 modify
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rmn"
                     LET g_qryparam.default1 = g_rmn.rmn01
                     CALL cl_create_qry()
                          RETURNING g_rmn.rmn01
                      DISPLAY BY NAME g_rmn.rmn01            
                     NEXT FIELD rmn01
#        #           LET g_t1=g_rmn.rmn01[1,3]
         #           LET g_t1 = s_get_doc_no(g_rmn.rmn01)     #No.FUN-550064
#        #           CALL q_oay(0,0,g_t1,'75',g_sys) RETURNING g_t1
         #           CALL q_oay(TRUE,TRUE,g_t1,'75',g_sys) RETURNING g_qryparam.multiret
         #           DISPLAY g_qryparam.multiret TO rmn01
         #           NEXT FIELD rmn01
         #---------------------No:No.TQC-630147 end
                   WHEN INFIELD(rmn05) #查詢RMA單
#                    CALL q_rma(0,0,'70') RETURNING g_rmn.rmn05
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rma"
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.arg1 = '70'          #No.TQC-630148 add
                     LET g_qryparam.arg2 = g_doc_len     #No.TQC-630148 add
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rmn05
                     NEXT FIELD rmn05
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
 
             #No.FUN-580031 --start--     HCN
             ON ACTION qbe_select
                CALL cl_qbe_list() RETURNING lc_qbe_sn
                CALL cl_qbe_display_condition(lc_qbe_sn)
             #No.FUN-580031 --end--       HCN
          END CONSTRUCT
          IF INT_FLAG THEN RETURN END IF
       EXIT WHILE
       END WHILE
 
       #單身QBE查詢
       CONSTRUCT g_wc2 ON rmo02,rmo04,rmo05,rmo06,rmo07,rmo08
                        #No.FUN-840068 --start--
                         ,rmoud01,rmoud02,rmoud03,rmoud04,rmoud05
                         ,rmoud06,rmoud07,rmoud08,rmoud09,rmoud10
                         ,rmoud11,rmoud12,rmoud13,rmoud14,rmoud15
                        #No.FUN-840068 ---end---
            FROM s_rmo[1].rmo02, s_rmo[1].rmo04, s_rmo[1].rmo05, s_rmo[1].rmo06,
                 s_rmo[1].rmo07, s_rmo[1].rmo08
              #No.FUN-840068 --start--
                ,s_rmo[1].rmoud01,s_rmo[1].rmoud02,s_rmo[1].rmoud03
		,s_rmo[1].rmoud04,s_rmo[1].rmoud05,s_rmo[1].rmoud06
                ,s_rmo[1].rmoud07,s_rmo[1].rmoud08,s_rmo[1].rmoud09
                ,s_rmo[1].rmoud10,s_rmo[1].rmoud11,s_rmo[1].rmoud12
	        ,s_rmo[1].rmoud13,s_rmo[1].rmoud14,s_rmo[1].rmoud15
              #No.FUN-840068 ---end---
 
          #No.FUN-580031 --start--     HCN
          BEFORE CONSTRUCT
             CALL cl_qbe_display_condition(lc_qbe_sn)
          #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
          #No.FUN-580031 --start--     HCN
          ON ACTION qbe_save
             CALL cl_qbe_save()
          #No.FUN-580031 --end--       HCN
       END CONSTRUCT
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    #FUN-4A0081
    ELSE
        LET g_wc =" rmn01 = '",g_argv1,"'"    #No.FUN-4A0081
        LET g_wc2=" 1=1"
    END IF
    #--
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmnuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmngrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmngrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmnuser', 'rmngrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN                     # 若單身未輸入條件
       LET g_sql = " SELECT rmn01 FROM rmn_file",
                   " WHERE ", g_wc CLIPPED,
                   "ORDER BY rmn01"
    ELSE                                       # 若單身有輸入條件
       LET g_sql = " SELECT UNIQUE rmn01 ",
                   " FROM rmn_file, rmo_file",
                   " WHERE rmn01 = rmo01",
                   " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "ORDER BY rmn01"
    END IF
 
    PREPARE t230_prepare FROM g_sql
    DECLARE t230_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t230_prepare
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM rmn_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT rmn01) FROM rmn_file,rmo_file WHERE ",
                 "rmo01=rmn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t230_precount FROM g_sql
    DECLARE t230_count CURSOR FOR t230_precount
END FUNCTION
 
FUNCTION t230_menu()
 
   WHILE TRUE
      CALL t230_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t230_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t230_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t230_u('U')
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t230_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t230_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t230_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "reply_date"
            IF cl_chk_act_auth() THEN
               CALL t230_di()
            END IF
         WHEN "update_reply_date"
            IF cl_chk_act_auth() THEN
               CALL t230_d('W')
            END IF
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t230_y()
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t230_z()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmo),'','')
            END IF
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rmn.rmn01 IS NOT NULL THEN
                 LET g_doc.column1 = "rmn01"
                 LET g_doc.value1 = g_rmn.rmn01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0018-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t230_v()    #CHI-D20010
               CALL t230_v(1)   #CHI-D20010
               IF g_rmn.rmnconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rmn.rmnconf,"","","",g_void,g_rmn.rmnvoid)  
            END IF
         #CHI-C80041---end 
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t230_v(2)
               IF g_rmn.rmnconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rmn.rmnconf,"","","",g_void,g_rmn.rmnvoid)
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t230_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
 
    MESSAGE ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    CLEAR FORM
    CALL g_rmo.clear()
    INITIALIZE g_rmn.* TO NULL
    LET g_rmn_o.* = g_rmn.*
    CALL cl_opmsg('a')
 
    WHILE TRUE
        INITIALIZE g_rmn.* TO NULL
        LET p_cmd="a"
        LET g_rmn.rmnvoid='Y'
        LET g_rmn.rmnconf='N'
        LET g_rmn.rmnuser=g_user
        LET g_rmn.rmnoriu = g_user #FUN-980030
        LET g_rmn.rmnorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_rmn.rmngrup=g_grup
        LET g_rmn.rmndate=g_today
        LET g_rmn.rmn01=g_rmz.rmz17
        LET g_rmn.rmn06=g_today
        LET g_rmn.rmn07=NULL
        BEGIN WORK
        CALL t230_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0) EXIT WHILE
        END IF
        IF g_rmn.rmn01 IS NULL THEN CONTINUE WHILE END IF
#       BEGIN WORK  #No:7876   #No.TQC-A10029 
      #No.FUN-550064 --start--
        CALL s_auto_assign_no('arm',g_rmn.rmn01,g_today,"75","rmn_file","rmn01","","","") #No.FUN-560014
        RETURNING li_result,g_rmn.rmn01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_rmn.rmn01
 
#       IF g_oay.oayauno='Y' THEN
#           CALL s_armauno(g_rmn.rmn01,g_today) RETURNING g_i,g_rmn.rmn01
#           IF g_i THEN CONTINUE WHILE END IF       #有問題
#           DISPLAY BY NAME g_rmn.rmn01
#       END IF
 
        LET g_rmn.rmnplant = g_plant #FUN-980007
        LET g_rmn.rmnlegal = g_legal #FUN-980007
        INSERT INTO rmn_file VALUES (g_rmn.*)
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
           LET  g_success = 'N'
#           CALL cl_err(g_rmn.rmn01,STATUS,1)#FUN-660111
           CALL cl_err3("ins","rmn_file",g_rmn.rmn01,"",STATUS,"","",1) #FUN-660111
           ROLLBACK WORK  #No:7876
           CONTINUE WHILE
        ELSE
#          COMMIT WORK    #No:7876   #No.TQC-A10029
           CALL cl_flow_notify(g_rmn.rmn01,'I')
        END IF
 
        SELECT rmn01 INTO g_rmn.rmn01 FROM rmn_file WHERE rmn01=g_rmn.rmn01
 
        CALL g_rmo.clear()
        LET g_rec_b=0                               #No.FUN-680064
        #由 RMA單(rmn05)依單頭所輸入: rmc01=rmn05  產生單身:rmo
        IF cl_confirm('aap-701') THEN
           CALL t230_g_b()
           IF g_rec_b=0 OR g_success="N" THEN ROLLBACK WORK CONTINUE WHILE END IF
        END IF
        #No.TQC-A10029  --Begin
        COMMIT WORK 
        #No.TQC-A10029  --End  
        LET g_rmn_t.* = g_rmn.*
        CALL t230_b()                   #單身的conf
        #No.TQC-A10029  --Begin
        #IF INT_FLAG THEN
        #   LET INT_FLAG=0
        #   CALL t230_show()
        #   EXIT WHILE
        #END IF
        #IF g_success="N" THEN
        #   ROLLBACK WORK
        #   CALL cl_err('',9044,0)
        #ELSE
        #    COMMIT WORK
        #END IF
        #No.TQC-A10029  --End  
       #CLEAR FORM
       #CALL t230_show()
        EXIT WHILE
    END WHILE
END FUNCTION
 
#由不良品分析單(rmn)依QBE條件自動產生符合的單身
# (rmn05=rmc01 )
FUNCTION t230_g_b()
 
    LET g_sql =" SELECT '','','',rmc02,rmc04,rmc06,rmc05,rmc31 ",
               " FROM rma_file,rmc_file ",
               " WHERE rmc01='",g_rmn.rmn05,"' ",
               "  AND rma01=rmc01 AND rma09 !='6' AND rmavoid='Y' ",
               "  AND rmc04 !='MISC' ORDER BY rmc02 "
 
    PREPARE t230_rmcpb FROM g_sql
    IF SQLCA.SQLCODE != 0 THEN
       CALL cl_err('pre1:',SQLCA.sqlcode,0)
       LET g_success="N"
       RETURN
    END IF
    DECLARE rmc_curs                       #SCROLL CURSOR
        CURSOR FOR t230_rmcpb
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH rmc_curs INTO l_rmo.*          #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       ELSE
          INSERT INTO rmo_file(rmo01,rmo02,rmo03,rmo04,rmo05,rmo06,rmo07,rmo08, #No.MOD-470041
                               rmoplant,rmolegal) #FUN-980007
          VALUES (g_rmn.rmn01,g_cnt,'',l_rmo.rmo04,l_rmo.rmo05,l_rmo.rmo06,
                  l_rmo.rmo07,l_rmo.rmo08 ,
                  g_plant,g_legal)                #FUN-980007
 
          IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#             CALL cl_err('ins rmo',STATUS,1)#FUN-660111
             CALL cl_err3("ins","rmo_file",g_rmn.rmn01,g_cnt,STATUS,"","ins rmo",1) #FUN-660111
    #        ROLLBACK WORK  #No.TQC-A10029
             LET g_success="N"
             RETURN
          END IF
          LET g_rec_b = g_rec_b + 1
          LET g_cnt = g_cnt + 1
       END IF
    END FOREACH
    IF g_rec_b =0 THEN
       CALL cl_err('body: ','aap-129',0)
    #No.TQC-A10029  --Begin
    #   #No.TQC-740129---begin
    #   LET g_cnt = 0
    #   CALL t230_delall()
    #   #No.TQC-740129---end
    #   LET g_success="N"
    #   ROLLBACK WORK
    #   RETURN
    #ELSE
    #   COMMIT WORK
    #No.TQC-A10029  --End  
    END IF
    CALL t230_b_fill(" 1=1")
END FUNCTION
 
#處理INPUT
FUNCTION t230_i(p_cmd)
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
    DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
           g_tmp       LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
    DISPLAY BY NAME
            g_rmn.rmn01,g_rmn.rmn05,g_rmn.rmn06,
            g_rmn.rmn02,g_rmn.rmn03,g_rmn.rmn04,
            g_rmn.rmn07,g_rmn.rmnconf,g_rmn.rmnuser,
            g_rmn.rmngrup,g_rmn.rmnmodu,g_rmn.rmndate,g_rmn.rmnvoid,
          #FUN-840068     ---start---
            g_rmn.rmnud01,g_rmn.rmnud02,g_rmn.rmnud03,g_rmn.rmnud04,
            g_rmn.rmnud05,g_rmn.rmnud06,g_rmn.rmnud07,g_rmn.rmnud08,
            g_rmn.rmnud09,g_rmn.rmnud10,g_rmn.rmnud11,g_rmn.rmnud12,
            g_rmn.rmnud13,g_rmn.rmnud14,g_rmn.rmnud15 
          #FUN-840068     ----end----
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_rmn.rmn01,g_rmn.rmn05,g_rmn.rmn06, g_rmn.rmnoriu,g_rmn.rmnorig,
                  g_rmn.rmn02,g_rmn.rmn03,g_rmn.rmn04,g_rmn.rmn07
                #FUN-840068     ---start---
                 ,g_rmn.rmnud01,g_rmn.rmnud02,g_rmn.rmnud03,g_rmn.rmnud04,
                  g_rmn.rmnud05,g_rmn.rmnud06,g_rmn.rmnud07,g_rmn.rmnud08,
                  g_rmn.rmnud09,g_rmn.rmnud10,g_rmn.rmnud11,g_rmn.rmnud12,
                  g_rmn.rmnud13,g_rmn.rmnud14,g_rmn.rmnud15 
                #FUN-840068     ----end----
          WITHOUT DEFAULTS
 
#No.FUN-570109 --start
       BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL t230_set_entry(p_cmd)
             CALL t230_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
#No.FUN-570109 --end
 
       AFTER FIELD rmn01
         IF NOT cl_null(g_rmn.rmn01) THEN
            CALL s_check_no('arm',g_rmn.rmn01,g_rmn_o.rmn01,"75","rmn_file","rmn01","")
            RETURNING li_result,g_rmn.rmn01
            DISPLAY BY NAME g_rmn.rmn01
            IF (NOT li_result) THEN
               LET g_rmn.rmn01=g_rmn_o.rmn01
               NEXT FIELD rmn01
            END IF
#           DISPLAY g_smy.smydesc TO smydesc
 
#        IF NOT cl_null(g_rmn.rmn01) THEN
#            LET g_t=g_rmn.rmn01[1,3]
#            CALL s_axmslip(g_t,'75',g_sys)           #檢查 客退單別: 75
#            IF NOT cl_null(g_errno) THEN               #抱歉 有問題
#                  CALL cl_err(g_t,g_errno,0)
#                  NEXT FIELD rmn01
#            END IF
#            IF cl_null(g_rmn.rmn01[5,10]) AND NOT cl_null(g_rmn.rmn01[1,3]) THEN
#               IF g_oay.oayauno = 'N' THEN
#                  CALL cl_err('','aap-011',0)  #此單別無自動編號,需人工
#                  NEXT FIELD rmn01
#               ELSE
#                  NEXT FIELD rmn05
#               END IF
#            END IF
#            IF g_rmn.rmn01 != g_rmn01_t OR g_rmn_o.rmn01 IS NULL THEN
#                IF g_oay.oayauno = 'Y' AND NOT cl_chk_data_continue(g_rmn.rmn01[5,10]) THEN
#                      CALL cl_err('','9056',0) NEXT FIELD oea01
#                END IF
#                SELECT count(*) INTO g_cnt FROM rmn_file
#                    WHERE rmn01 = g_rmn.rmn01
#                IF g_cnt > 0 THEN   #資料重複
#                    CALL cl_err(g_rmn.rmn01,-239,0)
#                    LET g_rmn.rmn01 = g_rmn_o.rmn01
#                    DISPLAY BY NAME g_rmn.rmn01
#                    NEXT FIELD rmn01
#                END IF
#            END IF
#            LET g_rmn_o.rmn01 = g_rmn.rmn01
        #No.FUN-550064 ---end---
         END IF
 
       AFTER FIELD rmn05
            IF NOT cl_null(g_rmn.rmn05) THEN
      #No.FUN-550064 --start--
#            LET g_t = g_rmn.rmn05[1,g_doc_len]
#MOD-B70070 --- mark --- start ---
#            CALL s_check_no('arm',g_rmn.rmn05,g_rmn_o.rmn05,"70","","","")   #FUN-A70130
#            RETURNING li_result,g_rmn.rmn05
#            DISPLAY BY NAME g_rmn.rmn05
#            IF (NOT li_result) THEN
#               LET g_rmn.rmn05=g_rmn_o.rmn05
#               NEXT FIELD rmn05
#            END IF
#MOD-B70070 --- mark ---  end  ---

#               LET g_t=g_rmn.rmn05[1,3]
#               CALL s_axmslip(g_t,'70',g_sys)           #檢查RMA單單別:70
#               IF NOT cl_null(g_errno) THEN               #抱歉, 有問題
#                     CALL cl_err(g_t,g_errno,0)
#                     NEXT FIELD rmn05
#               END IF
                #No.TQC-930116 add --begin
                SELECT COUNT(*) INTO g_cnt FROM rmn_file
                 WHERE rmn05 = g_rmn.rmn05
                IF g_cnt > 0 THEN
                   IF NOT cl_confirm('arm-050') THEN
                      NEXT FIELD rmn05
                   END IF
                END IF
                #No.TQC-930116 add --end
                SELECT rma03,rma04,rma05
                   INTO g_rmn.rmn02,g_rmn.rmn03,g_rmn.rmn04
                   FROM rma_file
                   WHERE rma01 = g_rmn.rmn05 AND rma09 !='6' AND rmavoid='Y'
                IF STATUS THEN           #表RMA單無此單號
   #                 CALL cl_err(g_rmn.rmn05,'arm-004',0)#FUN-660111
                    CALL cl_err3("sel","rma_file",g_rmn.rmn05,"","arm-004","","",1) #FUN-660111
                    LET g_rmn.rmn05  = g_rmn_t.rmn05
                    DISPLAY BY NAME g_rmn.rmn05
                    NEXT FIELD rmn05
                END IF
                DISPLAY BY NAME g_rmn.rmn02,g_rmn.rmn03,g_rmn.rmn04
           END IF
 
       AFTER FIELD rmn02
         IF NOT cl_null(g_rmn.rmn02) THEN
            IF (g_rmn.rmn02 != g_rmn_o.rmn02 OR g_rmn_o.rmn02 IS NULL) AND
               g_rmn.rmn02 !='MISC' THEN
               SELECT occ02,occ11 INTO g_rmn.rmn03,g_rmn.rmn04 FROM occ_file
                      WHERE occ01=g_rmn.rmn02 AND occacti='Y'
               IF STATUS THEN
     #             CALL cl_err('occ: ','anm-045',0)#FUN-660111
                  CALL cl_err3("sel","occ_file",g_rmn.rmn02,"","anm-045","","occ: ",1) #FUN-660111
                  NEXT FIELD rmn02
               END IF
               DISPLAY BY NAME g_rmn.rmn03,g_rmn.rmn04
            END IF
            LET g_rmn_o.rmn02 = g_rmn.rmn02
         END IF
 
       AFTER FIELD rmn06
         IF p_cmd="a" THEN EXIT INPUT END IF
 
        #FUN-840068     ---start---
        AFTER FIELD rmnud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmnud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
 
       ON ACTION CONTROLP
         CASE
           WHEN INFIELD(rmn02)    # 查詢客戶編號
#            CALL q_occ(10,22,g_rmn.rmn02) RETURNING g_rmn.rmn02
#            CALL FGL_DIALOG_SETBUFFER( g_rmn.rmn02 )
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_occ"
             LET g_qryparam.default1 = g_rmn.rmn02
             CALL cl_create_qry() RETURNING g_rmn.rmn02
#             CALL FGL_DIALOG_SETBUFFER( g_rmn.rmn02 )
             DISPLAY BY NAME g_rmn.rmn02
             NEXT FIELD rmn02
           WHEN INFIELD(rmn01) #查詢單据
#            LET g_t1=g_rmn.rmn01[1,3]
             LET g_t1 = s_get_doc_no(g_rmn.rmn01)     #No.FUN-550064
#            CALL q_oay(0,0,g_t1,'75',g_sys) RETURNING g_t1
             #CALL q_oay(FALSE,FALSE,g_t1,'75',g_sys) RETURNING g_t1 #TQC-670008
             CALL q_oay(FALSE,FALSE,g_t1,'75','ARM') RETURNING g_t1  #TQC-670008
#             CALL FGL_DIALOG_SETBUFFER( g_t1 )
#            LET g_rmn.rmn01[1,3]=g_t1   #No.TQC-5A0097
             LET g_rmn.rmn01 = g_t1                 #No.FUN-550064
             DISPLAY BY NAME g_rmn.rmn01
             NEXT FIELD rmn01
           WHEN INFIELD(rmn05) #查詢RMA單
#            CALL q_rma(0,0,'70') RETURNING g_rmn.rmn05
#            CALL FGL_DIALOG_SETBUFFER( g_rmn.rmn05 )
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_rma"
             LET g_qryparam.arg1 = '70'
             LET g_qryparam.arg2 = g_doc_len     #No.TQC-630148 add
             CALL cl_create_qry() RETURNING g_rmn.rmn05
#             CALL FGL_DIALOG_SETBUFFER( g_rmn.rmn05 )
             DISPLAY BY NAME g_rmn.rmn05
             NEXT FIELD rmn05
         END CASE
 
       ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG 
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
FUNCTION t230_di()
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmn.* FROM rmn_file WHERE rmn01 = g_rmn.rmn01
    IF g_rmn.rmn01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_rmn.rmnvoid = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
    IF g_rmn.rmnconf = 'N' THEN CALL cl_err('','arm-005',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rmn_t.* = g_rmn.*
    LET g_rmn_o.* = g_rmn.*
    BEGIN WORK
 
    OPEN t230_cl USING g_rmn.rmn01
    IF STATUS THEN
       CALL cl_err("OPEN t230_cl:", STATUS, 1)
       CLOSE t230_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t230_cl INTO g_rmn.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t230_cl ROLLBACK WORK RETURN
    END IF
 
    INPUT BY NAME g_rmn.rmn07
       BEFORE FIELD rmn07
          LET g_rmn.rmn07 = g_today
 
      #start MOD-640452 add
       AFTER FIELD rmn07
          IF NOT cl_null(g_rmn.rmn07) THEN
             IF g_rmn.rmn07 < g_rmn.rmn06 THEN
                CALL cl_err('','arm-540',0)   #回覆日期不可小於提出日期！
                NEXT FIELD rmn07
             END IF
          END IF
      #end MOD-640452 add
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       ROLLBACK WORK
       RETURN
    END IF
 
    UPDATE rmn_file SET rmn07 = g_rmn.rmn07
       WHERE rmn01 = g_rmn.rmn01
    IF STATUS THEN
    #   CALL cl_err('Up rmn:',sqlca.sqlcode,0)#FUN-660111
       CALL cl_err3("upd","rmn_file",g_rmn_t.rmn01,"","sqlca.sqlcode","","Up rmn:",1) #FUN-660111
       ROLLBACK WORK
    ELSE
       COMMIT WORK
       CALL t230_d('W')
    END IF
END FUNCTION
 
FUNCTION t230_u(p_cmd)
    DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmn.* FROM rmn_file WHERE rmn01 = g_rmn.rmn01
    IF g_rmn.rmn01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_rmn.rmnvoid = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
    IF p_cmd = 'D' THEN
       IF g_rmn.rmnconf = 'N' THEN CALL cl_err('','arm-005',0) RETURN END IF
    ELSE
       IF g_rmn.rmnconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rmn_t.* = g_rmn.*
    LET g_rmn_o.* = g_rmn.*
    BEGIN WORK
 
    OPEN t230_cl USING g_rmn.rmn01
    IF STATUS THEN
       CALL cl_err("OPEN t230_cl:", STATUS, 1)
       CLOSE t230_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t230_cl INTO g_rmn.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t230_cl ROLLBACK WORK RETURN
    END IF
    CALL t230_show()
    WHILE TRUE
        LET g_rmn01_t = g_rmn.rmn01
        LET g_rmn_t.* = g_rmn.*
        LET g_rmn.rmnmodu=g_user
        LET g_rmn.rmndate=g_today
        CALL t230_i("u")
        IF INT_FLAG OR g_success="N" THEN
            LET g_success = "Y"
            LET INT_FLAG = 0
            LET g_rmn.*=g_rmn_t.*
            CALL t230_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
        UPDATE rmn_file SET rmn_file.* = g_rmn.* WHERE rmn01 = g_rmn.rmn01
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
  #         CALL cl_err(g_rmn.rmn01,STATUS,0)#FUN-660111
           CALL cl_err3("upd","rmn_file",g_rmn_t.rmn01,"",STATUS,"","",1) #FUN-660111
            CONTINUE WHILE
        END IF
 
        IF p_cmd="D" AND INT_FLAG=0 THEN
           IF NOT cl_conf3(0,0,9065) THEN
              CALL t230_d('W')
           END IF
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t230_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rmn.rmn01,'U')
 
END FUNCTION
 
FUNCTION t230_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rmn.* TO NULL               #No.FUN-6A0018
    CALL cl_opmsg('q')
    LET p_cmd="u"
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
    CALL t230_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       INITIALIZE g_rmn.* TO NULL RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t230_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)    
        INITIALIZE g_rmn.* TO NULL
    ELSE
        OPEN t230_count
        FETCH t230_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t230_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
 
FUNCTION t230_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t230_cs INTO g_rmn.rmn01
        WHEN 'P' FETCH PREVIOUS t230_cs INTO g_rmn.rmn01
        WHEN 'F' FETCH FIRST    t230_cs INTO g_rmn.rmn01
        WHEN 'L' FETCH LAST     t230_cs INTO g_rmn.rmn01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t230_cs INTO g_rmn.rmn01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)
        INITIALIZE g_rmn.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rmn.* FROM rmn_file WHERE rmn01 = g_rmn.rmn01
    IF SQLCA.sqlcode THEN
   #     CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)#FUN-660111
           CALL cl_err3("sel","rmn_file",g_rmn.rmn01,"",SQLCA.sqlcode,"","",1) #FUN-66011m
        INITIALIZE g_rmn.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rmn.rmnuser #FUN-4C0055
        LET g_data_group = g_rmn.rmngrup #FUN-4C0055
        LET g_data_plant = g_rmn.rmnplant #FUN-980030
    END IF
 
    CALL t230_show()
END FUNCTION
 
FUNCTION t230_show()
    LET g_rmn_t.* = g_rmn.*                #保存單頭舊值
    DISPLAY BY NAME g_rmn.rmnoriu,g_rmn.rmnorig,
 
        g_rmn.rmn01,g_rmn.rmn02,g_rmn.rmn03,g_rmn.rmn04,g_rmn.rmn05,
        g_rmn.rmn06,g_rmn.rmn07,g_rmn.rmnconf,g_rmn.rmnuser,
        g_rmn.rmngrup,g_rmn.rmnmodu,g_rmn.rmndate,g_rmn.rmnvoid,
      #FUN-840068     ---start---
        g_rmn.rmnud01,g_rmn.rmnud02,g_rmn.rmnud03,g_rmn.rmnud04,
        g_rmn.rmnud05,g_rmn.rmnud06,g_rmn.rmnud07,g_rmn.rmnud08,
        g_rmn.rmnud09,g_rmn.rmnud10,g_rmn.rmnud11,g_rmn.rmnud12,
        g_rmn.rmnud13,g_rmn.rmnud14,g_rmn.rmnud15 
      #FUN-840068     ----end----
 
    #CKP
    #CALL cl_set_field_pic(g_rmn.rmnconf  ,"","","","",g_rmn.rmnvoid) #CHI-C80041
    IF g_rmn.rmnconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
    CALL cl_set_field_pic(g_rmn.rmnconf,"","","",g_void,g_rmn.rmnvoid)  #CHI-C80041
 
    CALL t230_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t230_b()
DEFINE
    l_ac_t            LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    g_n               LIKE type_file.num5,                #No.FUN-690010 SMALLINT,
    l_n,l_cnt         LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw         LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    g_tmp             LIKE type_file.chr20,                #No.FUN-690010 VARCHAR(20),               #
    g_rmc31           LIKE type_file.num5,                 #No.FUN-690010 SMALLINT,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmn.* FROM rmn_file WHERE rmn01 = g_rmn.rmn01
    IF g_rmn.rmn01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN
    END IF
    IF g_rmn.rmnvoid = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
    IF g_rmn.rmnconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT rmo02,rmo04,rmo05,rmo06,rmo07,rmo08, ",
    #No.FUN-840068 --start--
      "        rmoud01,rmoud02,rmoud03,rmoud04,rmoud05,",
      "        rmoud06,rmoud07,rmoud08,rmoud09,rmoud10,",
      "        rmoud11,rmoud12,rmoud13,rmoud14,rmoud15 ", 
    #No.FUN-840068 ---end---
      " FROM rmo_file",
      "  WHERE rmo01= ? ",
      "   AND rmo02= ? ",
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t230_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_rmo WITHOUT DEFAULTS FROM s_rmo.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN t230_cl USING g_rmn.rmn01
            IF STATUS THEN
               CALL cl_err("OPEN t230_cl:", STATUS, 1)
               CLOSE t230_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t230_cl INTO g_rmn.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t230_cl ROLLBACK WORK RETURN
            END IF
           #IF g_rmo_t.rmo02 IS NOT NULL AND g_rmo_t.rmo02 > 0 THEN
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rmo_t.* = g_rmo[l_ac].*  #BACKUP
                OPEN t230_bcl USING g_rmn.rmn01,g_rmo_t.rmo02
                IF STATUS THEN
                    CALL cl_err("OPEN t230_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t230_bcl INTO g_rmo[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rmo_t.rmo02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD rmo02
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO rmo_file(rmo01,rmo02,rmo04,
                                 rmo05,rmo06,rmo07,rmo08, #)
                               #FUN-840068 --start--
                                 rmoud01,rmoud02,rmoud03,
                                 rmoud04,rmoud05,rmoud06,
                                 rmoud07,rmoud08,rmoud09,
                                 rmoud10,rmoud11,rmoud12,
                                 rmoud13,rmoud14,rmoud15,
                                 rmoplant,rmolegal) #FUN-980007
                               #FUN-840068 --end--
            VALUES(g_rmn.rmn01,g_rmo[l_ac].rmo02,
                   g_rmo[l_ac].rmo04,
                   g_rmo[l_ac].rmo05,g_rmo[l_ac].rmo06,
                   g_rmo[l_ac].rmo07,g_rmo[l_ac].rmo08, #)
                 #FUN-840068 --start--
                   g_rmo[l_ac].rmoud01,
                   g_rmo[l_ac].rmoud02,
                   g_rmo[l_ac].rmoud03,
                   g_rmo[l_ac].rmoud04,
                   g_rmo[l_ac].rmoud05,
                   g_rmo[l_ac].rmoud06,
                   g_rmo[l_ac].rmoud07,
                   g_rmo[l_ac].rmoud08,
                   g_rmo[l_ac].rmoud09,
                   g_rmo[l_ac].rmoud10,
                   g_rmo[l_ac].rmoud11,
                   g_rmo[l_ac].rmoud12,
                   g_rmo[l_ac].rmoud13,
                   g_rmo[l_ac].rmoud14,
                   g_rmo[l_ac].rmoud15,
                   g_plant,g_legal)                 #FUN-980007
                 #FUN-840068 --end--
 
            IF SQLCA.sqlcode THEN
   #            CALL cl_err(g_rmo[l_ac].rmo02,SQLCA.sqlcode,0)#FUN-660111
               CALL cl_err3("ins","rmo_file",g_rmn.rmn01,g_rmo[l_ac].rmo02,SQLCA.sqlcode,"","",1) #FUN-660111
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
          #CKP
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_rmo[l_ac].* TO NULL      #900423
          LET g_rmo_t.* = g_rmo[l_ac].*             #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD rmo02
 
        BEFORE FIELD rmo02                  #default項次
          IF g_rmo[l_ac].rmo02 IS NULL OR g_rmo[l_ac].rmo02 = 0 THEN
             SELECT max(rmo02)+1 INTO g_rmo[l_ac].rmo02
             FROM rmo_file WHERE rmo01 = g_rmn.rmn01
             IF g_rmo[l_ac].rmo02 IS NULL THEN
                LET g_rmo[l_ac].rmo02 = 1
             END IF
          END IF
 
        AFTER FIELD rmo02               #check 項次是否重複
          IF NOT cl_null(g_rmo[l_ac].rmo02) THEN
              IF g_rmo[l_ac].rmo02 != g_rmo_t.rmo02 OR
                 g_rmo_t.rmo02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM rmo_file
                 WHERE rmo01 = g_rmn.rmn01 AND rmo02 = g_rmo[l_ac].rmo02
                   IF l_n > 0 THEN
                      LET g_rmo[l_ac].rmo02 = g_rmo_t.rmo02
                      CALL cl_err('',-239,0) NEXT FIELD rmo02
                   END IF
              END IF
          END IF
 
       AFTER FIELD rmo04
          IF NOT cl_null(g_rmo[l_ac].rmo04) THEN
              SELECT COUNT(*) INTO g_n FROM rmo_file
               WHERE rmo01=g_rmn.rmn01 AND rmo02 <> g_rmo[l_ac].rmo02
                 AND rmo04=g_rmo[l_ac].rmo04
              IF g_n >=1 THEN
                 LET g_rmo[l_ac].rmo04=g_rmo_t.rmo04
                 DISPLAY g_rmo[l_ac].rmo04 TO s_rmo[l_ac].rmo04
                 CALL cl_err('',-239,0)
                 NEXT FIELD rmo04
              END IF
              LET g_err="N"
              CALL t230_get_rmc()
              IF g_err="Y" THEN
                 NEXT FIELD rmo04
              END IF
          END IF
          NEXT FIELD rmo08
 
       AFTER FIELD rmo08          # check數量
         IF g_rmo[l_ac].rmo08 < 0 THEN
            NEXT FIELD rmo08
         END IF
         LET g_rmo[l_ac].rmo08 = s_digqty(g_rmo[l_ac].rmo08,g_rmo[l_ac].rmo07)   #FUN-910088--add--start--
         DISPLAY BY NAME g_rmo[l_ac].rmo08                                       #FUN-910088--add--end--
         SELECT rmc31 INTO g_rmc31 FROM rmc_file
                WHERE rmc01=g_rmn.rmn05 AND rmc02=g_rmo[l_ac].rmo04
         IF g_rmo[l_ac].rmo08 > g_rmc31 THEN
            CALL cl_err(g_rmc31,'arm-041',0)
            LET g_rmo[l_ac].rmo08=g_rmo_t.rmo08
            DISPLAY g_rmo[l_ac].rmo08 TO s_rmo[l_ac].rmo08
            NEXT FIELD rmo08
         END IF
 
      #No.FUN-840068 --start--
        AFTER FIELD rmoud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmoud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #No.FUN-840068 ---end---
 
       BEFORE DELETE                            #是否取消單身
          IF g_rmo_t.rmo02 > 0 AND g_rmo_t.rmo02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM rmo_file
                 WHERE rmo01 = g_rmn.rmn01 AND
                       rmo02 = g_rmo[l_ac].rmo02
             IF SQLCA.sqlcode THEN
     #            CALL cl_err(g_rmo_t.rmo02,SQLCA.sqlcode,0)#FUN-660111
                 CALL cl_err3("del","rmo_file",g_rmn.rmn01,g_rmo[l_ac].rmo02,SQLCA.sqlcode,"","",1) #FUN-660111
                 ROLLBACK WORK
                 CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
         ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_rmo[l_ac].* = g_rmo_t.*
                CLOSE t230_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_rmo[l_ac].rmo02,-263,1)
                 LET g_rmo[l_ac].* = g_rmo_t.*
             ELSE
                 UPDATE rmo_file SET
                        rmo02=g_rmo[l_ac].rmo02,
                        rmo03=g_rmn.rmn05,
                        rmo04=g_rmo[l_ac].rmo04,
                        rmo05=g_rmo[l_ac].rmo05,
                        rmo06=g_rmo[l_ac].rmo06,
                        rmo07=g_rmo[l_ac].rmo07,
                        rmo08=g_rmo[l_ac].rmo08
                      #FUN-840068 --start--
                       ,rmoud01 = g_rmo[l_ac].rmoud01,
                        rmoud02 = g_rmo[l_ac].rmoud02,
                        rmoud03 = g_rmo[l_ac].rmoud03,
                        rmoud04 = g_rmo[l_ac].rmoud04,
                        rmoud05 = g_rmo[l_ac].rmoud05,
                        rmoud06 = g_rmo[l_ac].rmoud06,
                        rmoud07 = g_rmo[l_ac].rmoud07,
                        rmoud08 = g_rmo[l_ac].rmoud08,
                        rmoud09 = g_rmo[l_ac].rmoud09,
                        rmoud10 = g_rmo[l_ac].rmoud10,
                        rmoud11 = g_rmo[l_ac].rmoud11,
                        rmoud12 = g_rmo[l_ac].rmoud12,
                        rmoud13 = g_rmo[l_ac].rmoud13,
                        rmoud14 = g_rmo[l_ac].rmoud14,
                        rmoud15 = g_rmo[l_ac].rmoud15
                      #FUN-840068 --end-- 
                  WHERE rmo01=g_rmn.rmn01
                    AND rmo02=g_rmo_t.rmo02
                 IF SQLCA.sqlcode THEN
  #                   CALL cl_err(g_rmo[l_ac].rmo02,SQLCA.sqlcode,0)#FUN-660111
                     CALL cl_err3("upd","rmo_file",g_rmn.rmn01,g_rmo_t.rmo02,SQLCA.sqlcode,"","",1) #FUN-660111
                     LET g_rmo[l_ac].* = g_rmo_t.*
                     DISPLAY g_rmo[l_ac].* TO s_rmo[l_sl].*
                 ELSE
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                 END IF
             END IF
 
         AFTER ROW
             LET l_ac = ARR_CURR()
         #   LET l_ac_t = l_ac   #FUN-D40030 mark
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmo[l_ac].* = g_rmo_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmo.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
                CLOSE t230_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET l_ac_t = l_ac   #FUN-D40030 add
            #CKP
            #LET g_rmo_t.* = g_rmo[l_ac].*          # 900423
             CLOSE t230_bcl
             COMMIT WORK
 
         # ON ACTION CONTROLN
         #    CALL t230_b_askkey()
         #    EXIT INPUT
 
           ON ACTION CONTROLO                        #沿用所有欄位
              IF INFIELD(rmo02) AND l_ac > 1 THEN
                 LET g_rmo[l_ac].* = g_rmo[l_ac-1].*
                 LET g_rmo[l_ac].rmo02 = NULL
                 NEXT FIELD rmo02
              END IF
 
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(rmo04)
#                  CALL q_rma1(0,0,g_rmn.rmn05,'70') RETURNING g_tmp,g_rmo[l_ac].rmo04
#                  CALL FGL_DIALOG_SETBUFFER( g_tmp )
#                  CALL FGL_DIALOG_SETBUFFER( g_rmo[l_ac].rmo04 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rma1"
                   IF NOT cl_null(g_rmn.rmn05) THEN
                       LET g_qryparam.construct = "N"
                       LET g_qryparam.where = " rmc01 = '",g_rmn.rmn05,"'"
                   END IF
                   LET g_qryparam.default1 = g_rmn.rmn05
                   LET g_qryparam.arg1 = "70"
                   LET g_qryparam.arg2 = g_doc_len   #MOD-770022
                   CALL cl_create_qry() RETURNING g_tmp,g_rmo[l_ac].rmo04
#                   CALL FGL_DIALOG_SETBUFFER( g_tmp )
#                   CALL FGL_DIALOG_SETBUFFER( g_rmo[l_ac].rmo04 )
                   DISPLAY g_rmo[l_ac].rmo04 TO rmo04
              END CASE
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG CALL cl_cmdask()
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
 
       END INPUT
 
 
   #FUN-5B0113-begin
    LET g_rmn.rmnmodu = g_user
    LET g_rmn.rmndate = g_today
    UPDATE rmn_file SET rmnmodu = g_rmn.rmnmodu,rmndate = g_rmn.rmndate
     WHERE rmn01 = g_rmn.rmn01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('upd rmn',SQLCA.SQLCODE,1) #FUN-660111
       CALL cl_err3("upd","rmn_file",g_rmn.rmn01,"",SQLCA.sqlcode,"","upd rmn",1) #FUN-660111
    END IF
    DISPLAY BY NAME g_rmn.rmnmodu,g_rmn.rmndate
   #FUN-5B0113-end
 
    CLOSE t230_bcl
    LET g_cnt=0
    SELECT COUNT(*) INTO g_cnt FROM rmo_file WHERE rmo01=g_rmn.rmn01
    COMMIT WORK
    IF p_cmd="u" THEN LET INT_FLAG=0 END IF
#   IF g_cnt=0 THEN           #CHI-C30002 mark
#      CALL t230_delall()     #CHI-C30002 mark
#   END IF                    #CHI-C30002 mark
    CALL t230_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t230_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rmn.rmn01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rmn_file ",
                  "  WHERE rmn01 LIKE '",l_slip,"%' ",
                  "    AND rmn01 > '",g_rmn.rmn01,"'"
      PREPARE t230_pb1 FROM l_sql 
      EXECUTE t230_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t230_v()  #CHI-D20010
         CALL t230_v(1) #CHI-D20010
         IF g_rmn.rmnconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_rmn.rmnconf,"","","",g_void,g_rmn.rmnvoid) 
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rmn_file WHERE rmn01 = g_rmn.rmn01
         INITIALIZE g_rmn.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t230_get_rmc()
    DEFINE l_cnt  LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   {SELECT COUNT(*) INTO l_cnt FROM rmo_file
      WHERE rmo03=g_rmo[l_ac].rmo03 AND rmo04=g_rmo[l_ac].rmo04
    IF l_cnt >=1 THEN
       CALL cl_err('rmc: ','aap-737',0)
       LET g_err="Y" RETURN
    END IF}
    SELECT rmc04,rmc06,rmc05,rmc31
      INTO g_rmo[l_ac].rmo05,g_rmo[l_ac].rmo06,g_rmo[l_ac].rmo07,
           g_rmo[l_ac].rmo08
      FROM rmc_file
      WHERE rmc01=g_rmn.rmn05 AND rmc02=g_rmo[l_ac].rmo04
        AND rmc14 IN ('0','1','2')
    IF SQLCA.sqlcode THEN
 #      CALL cl_err('rmc: ','aap-129',0)#FUN-660111
       CALL cl_err3("sel","rmc_file",g_rmn.rmn05,g_rmo[l_ac].rmo04,"aap-129","","rmc:",1) #FUN-660111
       LET g_err="Y"
    END IF
 
END FUNCTION
 
FUNCTION t230_delall()
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       IF cl_delb(0,0) THEN
           INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
           LET g_doc.column1 = "rmn01"         #No.FUN-9B0098 10/02/24
           LET g_doc.value1 = g_rmn.rmn01      #No.FUN-9B0098 10/02/24
           CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
          DELETE FROM rmn_file WHERE rmn01 = g_rmn.rmn01
          #No.TQC-A10029  --Begin
          #CLEAR FORM
          #No.TQC-A10029  --End  
          CALL g_rmo.clear()
       END IF
    END IF
END FUNCTION
 
FUNCTION t230_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)
 
    CONSTRUCT l_wc2 ON rmo02,rmo04,rmo05,rmo06,rmo07,rmo08
                     #No.FUN-840068 --start--
                      ,rmoud01,rmoud02,rmoud03,rmoud04,rmoud05
                      ,rmoud06,rmoud07,rmoud08,rmoud09,rmoud10
                      ,rmoud11,rmoud12,rmoud13,rmoud14,rmoud15
                     #No.FUN-840068 ---end---
         FROM s_rmo[1].rmo02,s_rmo[1].rmo04, s_rmo[1].rmo05, s_rmo[1].rmo06,
              s_rmo[1].rmo07,s_rmo[1].rmo08
            #No.FUN-840068 --start--
             ,s_rmo[1].rmoud01,s_rmo[1].rmoud02,s_rmo[1].rmoud03
             ,s_rmo[1].rmoud04,s_rmo[1].rmoud05,s_rmo[1].rmoud06
             ,s_rmo[1].rmoud07,s_rmo[1].rmoud08,s_rmo[1].rmoud09
             ,s_rmo[1].rmoud10,s_rmo[1].rmoud11,s_rmo[1].rmoud12
	     ,s_rmo[1].rmoud13,s_rmo[1].rmoud14,s_rmo[1].rmoud15
            #No.FUN-840068 ---end---
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t230_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t230_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)
 
    LET l_sql =
         "SELECT rmo02,rmo04,rmo05,rmo06,rmo07,rmo08",
       #No.FUN-840068 --start--
         "      ,rmoud01,rmoud02,rmoud03,rmoud04,rmoud05,",
         "       rmoud06,rmoud07,rmoud08,rmoud09,rmoud10,",
         "       rmoud11,rmoud12,rmoud13,rmoud14,rmoud15 ", 
       #No.FUN-840068 ---end---
         " FROM rmn_file,rmo_file ",
         " WHERE rmo01 ='",g_rmn.rmn01,"'",  # 單頭
         " AND rmn01=rmo01 ",
         " AND ",p_wc2 CLIPPED,              # 單身
         " ORDER BY 1"
 
    PREPARE t230_pb FROM l_sql
    DECLARE rmo_curs                       #SCROLL CURSOR
        CURSOR FOR t230_pb
 
    CALL g_rmo.clear()
    LET g_cnt = 1
    FOREACH rmo_curs INTO g_rmo[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    #CKP
    CALL g_rmo.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t230_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmo TO s_rmo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t230_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t230_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t230_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t230_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t230_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
         #CKP
         #CALL cl_set_field_pic(g_rmn.rmnconf  ,"","","","",g_rmn.rmnvoid)  #CHI-C80041
         IF g_rmn.rmnconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
         CALL cl_set_field_pic(g_rmn.rmnconf,"","","",g_void,g_rmn.rmnvoid)  #CHI-C80041
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION reply_date
         LET g_action_choice="reply_date"
         EXIT DISPLAY
 
      ON ACTION update_reply_date
         LET g_action_choice="update_reply_date"
         EXIT DISPLAY
 
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
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
 
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0018  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t230_out()
DEFINE
    sr              RECORD
        rmn01       LIKE rmn_file.rmn01,   # rmn單號
        rmn02       LIKE rmn_file.rmn02,   # 客戶編號
        rmn03       LIKE rmn_file.rmn03,   # 客戶簡稱
        rmn05       LIKE rmn_file.rmn05,   # RMA 單號
        rmn06       LIKE rmn_file.rmn06,   # 提出日期
        rmn07       LIKE rmn_file.rmn07,   # reply_date
        rmo02       LIKE rmo_file.rmo02,   # 項次
        rmo04       LIKE rmo_file.rmo04,   # RMA: RET#
        rmo05       LIKE rmo_file.rmo05,   # 產品編號
        rmo06       LIKE rmo_file.rmo06,   # 品名
        rmo07       LIKE rmo_file.rmo07,   # 單位
        rmo08       LIKE rmo_file.rmo08,   # 數量
        ima021      LIKE ima_file.ima021   #FUN-510044
                    END RECORD,
    l_name          LIKE type_file.chr20                #External(Disk) file name  #No.FUN-690010 VARCHAR(20)
    #-----NO.FUN-860018 BY TSD.jarlin----------(S)                                                                                  
       CALL cl_del_data(l_table)                                                                                                    
       SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog                                                                       
    #-----NO.FUN-860018------------------------(E)    
 
 
    IF cl_null(g_rmn.rmn01) THEN
       CALL cl_err('','arm-019',0) RETURN END IF
    IF g_wc IS NULL THEN LET g_wc=" rmn01='",g_rmn.rmn01,"'" END IF
 
    CALL cl_wait()
 
#    LET l_name = 'armt230.out'
#    CALL cl_outnam('armt230') RETURNING l_name
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql=" SELECT rmn01,rmn02,rmn03,rmn05,rmn06,rmn07,rmo02,",
              "        rmo04,rmo05,rmo06,rmo07,rmo08,ima021 ", #add ima021 #FUN-510044
              " FROM rmn_file,rmo_file LEFT JOIN ima_file ON rmo05 = ima_file.ima01 ",
              " WHERE rmn01=rmo01 AND ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED,
              " AND rmnconf <> 'X' ",  #CHI-C80041
              " ORDER BY rmn01,rmo02 "
    PREPARE t230_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t230_co                         # SCROLL CURSOR
        CURSOR FOR t230_p1
 
#    START REPORT t230_rep TO l_name
 
    FOREACH t230_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #-----NO.FUN-860018 BY TSD.jarlin--------(S)                                                                                
          EXECUTE insert_prep USING sr.ima021,                                                                                      
                  sr.rmn01,sr.rmn02,sr.rmn03,                                                                                       
                  sr.rmn05,sr.rmn06,sr.rmn07,                                                                                       
                  sr.rmo02,sr.rmo04,sr.rmo05,                                                                                       
                  sr.rmo06,sr.rmo07,sr.rmo08                                                                                        
                                                                                                                                    
          IF SQLCA.sqlcode THEN                                                                                                     
             CALL cl_err('execute:',status,1)                                                                                       
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
             EXIT PROGRAM                                                                                                           
          END IF                                                                                                                    
        #-----NO.FUN-860018----------------------(E)    
#        OUTPUT TO REPORT t230_rep(sr.*)
    END FOREACH
    #-----NO.FUN-860018 BY TSD.jarlin----------(S)                                                                                  
        LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED                                                                            
                    ,l_table CLIPPED                                                                                                
                    ," ORDER BY rmn01,rmn02"                                                                                        
                                                                                                                                    
        IF g_zz05='Y' THEN                                                                                                          
           CALL cl_wcchp(g_wc,'rmn01,rmn05,rmn06,rmn02,                                                                             
                         rmn03,rmn04,rmn07,rmnuser,                                                                                 
                         rmnmodu,rmnvoid,rmngrup,rmndate')                                                                          
           RETURNING g_str                                                                                                          
        ELSE                                                                                                                        
           LET g_str = ''                                                                                                           
        END IF                                                                                                                      
        LET g_str = g_str                                                                                                           
        CALL cl_prt_cs3('armt230','armt230',l_sql,g_str)                                                                            
    #-----NO.FUN-860018------------------------(E)       
#    FINISH REPORT t230_rep
 
    CLOSE t230_co
    MESSAGE ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#No.FUN-860018---begin
#REPORT t230_rep(sr)
#DEFINE
#   l_last_sw       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#   sr              RECORD
#       rmn01       LIKE rmn_file.rmn01,   # rmn單號
#       rmn02       LIKE rmn_file.rmn02,   # 客戶編號
#       rmn03       LIKE rmn_file.rmn03,   # 客戶簡稱
#       rmn05       LIKE rmn_file.rmn05,   # RMA 單號
#       rmn06       LIKE rmn_file.rmn06,   # 提出日期
#       rmn07       LIKE rmn_file.rmn07,   # reply_date
#       rmo02       LIKE rmo_file.rmo02,   # 項次
#       rmo04       LIKE rmo_file.rmo04,   # RMA: RET#
#       rmo05       LIKE rmo_file.rmo05,   # 產品編號
#       rmo06       LIKE rmo_file.rmo06,   # 品名
#       rmo07       LIKE rmo_file.rmo07,   # 單位
#       rmo08       LIKE rmo_file.rmo08,   # 數量
#       ima021      LIKE ima_file.ima021   #FUN-510044
#                   END RECORD
 
#  OUTPUT
#  TOP MARGIN g_top_margin
#  LEFT MARGIN g_left_margin
#  BOTTOM MARGIN g_bottom_margin
#  PAGE LENGTH g_page_line
 
#  ORDER BY sr.rmn01,sr.rmo02
 
#  FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_x[9] CLIPPED,' ',sr.rmn01,
#               COLUMN 60,g_x[12] CLIPPED,' ',sr.rmn06
#         PRINT g_x[10] CLIPPED,' ',sr.rmn05
#         PRINT g_x[11] CLIPPED,' ',sr.rmn02,"(",sr.rmn03,")",
#               COLUMN 60,g_x[13] CLIPPED,' ',sr.rmn07
#         PRINT g_head CLIPPED,pageno_total
#         PRINT g_dash
#         PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#         PRINTX name=H2 g_x[37],g_x[38]
#         PRINT g_dash1
#         LET l_last_sw = 'y'
 
#      BEFORE GROUP OF sr.rmn01
#         SKIP TO TOP OF PAGE
 
#      ON EVERY ROW
#         PRINTX name=D1 COLUMN g_c[31],sr.rmo02 USING '---&',
#                        COLUMN g_c[32],sr.rmo04 USING '---&',
#                        COLUMN g_c[33],sr.rmo05,
#                        COLUMN g_c[34],sr.rmo06,
#                        COLUMN g_c[35],sr.rmo07,
#                        COLUMN g_c[36],cl_numfor(sr.rmo08,36,2)
#         PRINTX name=D2 COLUMN g_c[37],' ',
#                        COLUMN g_c[38],sr.ima021
 
#      ON LAST ROW
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED,COLUMN (g_len-10),g_x[7] CLIPPED
#         LET l_last_sw = 'n'
 
#      PAGE TRAILER
#         IF l_last_sw = 'y' THEN
#            PRINT g_dash
#            PRINT g_x[4] CLIPPED,COLUMN (g_len-10),g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#END REPORT
#No.FUN-860018---END
#No.FUN-890102
FUNCTION t230_d(p_cmd)         # W:update_reply_date,D:確認時,R:取消確認時
   DEFINE   p_cmd LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
            l_ac  LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rmn.* FROM rmn_file WHERE rmn01 = g_rmn.rmn01
   IF g_rmn.rmn01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmn.rmnvoid = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
   IF p_cmd ="W" THEN
      IF g_rmn.rmnconf = 'N' THEN CALL cl_err('','arm-005',0) RETURN END IF
     #IF NOT cl_sure(0,0) THEN RETURN END IF            #MOD-640452 mark
      IF NOT cl_confirm("arm-541") THEN RETURN END IF   #MOD-640452
   END IF
 
   BEGIN WORK
 
   OPEN t230_cl USING g_rmn.rmn01
   IF STATUS THEN
      CALL cl_err("OPEN t230_cl:", STATUS, 1)
      CLOSE t230_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t230_cl INTO g_rmn.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t230_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
   FOR l_ac=1 TO g_rec_b
     IF g_rmo[l_ac].rmo04 IS NULL THEN EXIT FOR END IF
     CASE
     WHEN p_cmd="D"                   #當執行 Y.確認時
         UPDATE rmc_file SET rmc29 = g_rmn.rmn06,rmc26=g_rmn.rmn01
              WHERE rmc01 = g_rmn.rmn05 AND rmc02=g_rmo[l_ac].rmo04
     WHEN p_cmd="R"                #當執行 Z.取消確認時
         UPDATE rmc_file
            SET rmc29 = NULL, rmc26=NULL, rmc30=NULL
            WHERE rmc01 = g_rmn.rmn05 AND rmc02=g_rmo[l_ac].rmo04
     OTHERWISE                    #當執行 W.update_reply_date
         UPDATE rmc_file SET rmc30 = g_rmn.rmn07
              WHERE rmc01 = g_rmn.rmn05 AND rmc02=g_rmo[l_ac].rmo04
     END CASE
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
    #    CALL cl_err('upd rmc: ',STATUS,1)#FUN-660111
        CALL cl_err3("upd","rmc_file",g_rmn.rmn05,g_rmo[l_ac].rmo04,STATUS,"","upd rmc:",1) #FUN-660111
        LET g_success = 'N' EXIT FOR
     END IF
   END FOR
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(3) sleep 1
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rmn.rmn07
   MESSAGE ''
END FUNCTION
 
#--------確認程式---------
FUNCTION t230_y()         # when g_rmn.rmnconf='N' (Turn to 'Y')
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ------------ add ------------- begin 
   IF g_rmn.rmn01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmn.rmnvoid = 'N'  THEN CALL cl_err('',9028,0) RETURN END IF
   IF g_rmn.rmnconf = 'Y'  THEN CALL cl_err('',9003,0) RETURN END IF
   IF NOT cl_upsw(0,0,'N') THEN RETURN END IF  
#CHI-C30107 ------------ add ------------- end
   SELECT * INTO g_rmn.* FROM rmn_file WHERE rmn01 = g_rmn.rmn01
   IF g_rmn.rmn01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmn.rmnvoid = 'N'  THEN CALL cl_err('',9028,0) RETURN END IF
   IF g_rmn.rmnconf = 'Y'  THEN CALL cl_err('',9003,0) RETURN END IF
#  IF NOT cl_upsw(0,0,'N') THEN RETURN END IF  #CHI-C30107 mark
   LET g_rmn_t.*=g_rmn.*
 
   BEGIN WORK
 
    OPEN t230_cl USING g_rmn.rmn01
    IF STATUS THEN
       CALL cl_err("OPEN t230_cl:", STATUS, 1)
       CLOSE t230_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t230_cl INTO g_rmn.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t230_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
 
   CALL t230_y1()
 
   IF g_success = 'Y' THEN
      CALL t230_d('D')     #確認
      CALL cl_flow_notify(g_rmn.rmn01,'Y')
      LET g_rmn.rmnconf="Y"
      LET g_rmn.rmnmodu=g_user
      LET g_rmn.rmndate=g_today
   ELSE
      LET g_rmn.rmnconf='N'
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rmn.rmnconf,g_rmn.rmnmodu,g_rmn.rmndate
   MESSAGE ''
    #CKP
    #CALL cl_set_field_pic(g_rmn.rmnconf  ,"","","","",g_rmn.rmnvoid) #CHI-C80041
    IF g_rmn.rmnconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
    CALL cl_set_field_pic(g_rmn.rmnconf,"","","",g_void,g_rmn.rmnvoid)  #CHI-C80041
 
END FUNCTION
 
FUNCTION t230_y1()
   UPDATE rmn_file SET rmnconf = 'Y',
                       rmnmodu = g_user,
                       rmndate = g_today
                 WHERE rmn01   = g_rmn.rmn01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #   CALL cl_err('upd rmnconf',STATUS,1)#FUN-660111
      CALL cl_err3("upd","rmn_file",g_rmn.rmn01,"",STATUS,"","upd rmnconf",1) #FUN-660111
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t230_z()    # when g_rmn.rmnconf='Y' (Turn to 'N')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rmn.* FROM rmn_file WHERE rmn01 = g_rmn.rmn01
   IF g_rmn.rmn01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmn.rmnvoid = 'N' THEN CALL cl_err('',9028,0) RETURN END IF
   IF g_rmn.rmnconf = 'N' THEN CALL cl_err('',9025,0) RETURN END IF
   IF g_rmn.rmn07 IS NOT NULL THEN CALL cl_err('','arm-020',0) RETURN END IF
   IF NOT cl_upsw(0,0,'Y') THEN RETURN END IF
   LET g_rmn_t.*=g_rmn.*
   BEGIN WORK
 
   OPEN t230_cl USING g_rmn.rmn01
   IF STATUS THEN
      CALL cl_err("OPEN t230_cl:", STATUS, 1)
      CLOSE t230_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t230_cl INTO g_rmn.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t230_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
   CALL t230_z1()
   IF g_success = 'Y' THEN
      CALL t230_d('R')      #取消確認
      LET g_rmn.rmnconf='N'
      LET g_rmn.rmnmodu=g_user LET g_rmn.rmndate=g_today
      COMMIT WORK
#     CALL cl_cmmsg(3) sleep 1
   ELSE
      LET g_rmn.rmnconf='Y'
      ROLLBACK WORK
#     CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rmn.rmnconf,g_rmn.rmnmodu,g_rmn.rmndate
   MESSAGE ''
   #CKP
   #CALL cl_set_field_pic(g_rmn.rmnconf  ,"","","","",g_rmn.rmnvoid)  #CHI-C80041
   IF g_rmn.rmnconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_rmn.rmnconf,"","","",g_void,g_rmn.rmnvoid)  #CHI-C80041
END FUNCTION
 
FUNCTION t230_z1()
   UPDATE rmn_file SET rmnconf = 'N',
                       rmnuser = g_user,
                       rmndate = g_today
                 WHERE rmn01   = g_rmn.rmn01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #   CALL cl_err('upd rmnconf',STATUS,1)#FUN-660111
      CALL cl_err3("upd","rmn_file",g_rmn.rmn01,"",STATUS,"","upd rmnconf",1) #FUN-660111
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t230_x()
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmn.* FROM rmn_file WHERE rmn01 = g_rmn.rmn01
    IF g_rmn.rmn01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rmn.rmnconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rmn.rmnvoid = 'N' THEN CALL cl_err('',9028,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t230_cl USING g_rmn.rmn01
    IF STATUS THEN
       CALL cl_err("OPEN t230_cl:", STATUS, 1)
       CLOSE t230_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t230_cl INTO g_rmn.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t230_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t230_show()
 
    IF cl_exp(0,0,g_rmn.rmnvoid) THEN
       UPDATE rmn_file                    #更改有效碼
          SET rmnvoid='N',rmnmodu=g_user,rmndate=g_today
          WHERE rmn01=g_rmn.rmn01
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
   #       CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)#FUN-660111
          CALL cl_err3("upd","rmn_file",g_rmn.rmn01,"",SQLCA.sqlcode,"","",1) #FUN-660111
          LET g_rmn.rmnvoid='Y'
       ELSE
          LET g_rmn.rmnvoid='N'
          LET g_rmn.rmnmodu=g_user
          LET g_rmn.rmndate=g_today
       END IF
       DISPLAY BY NAME g_rmn.rmnvoid,g_rmn.rmnmodu,g_rmn.rmndate
    END IF
 
    COMMIT WORK
 
    CALL cl_flow_notify(g_rmn.rmn01,'V')
    #CKP
    #CALL cl_set_field_pic(g_rmn.rmnconf  ,"","","","",g_rmn.rmnvoid)  #CHI-C80041
    IF g_rmn.rmnconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
    CALL cl_set_field_pic(g_rmn.rmnconf,"","","",g_void,g_rmn.rmnvoid)  #CHI-C80041
END FUNCTION
 
#No.FUN-570109 --start
FUNCTION t230_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rmn01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t230_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
  #IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='Y' THEN     #No.TQC-750041
      CALL cl_set_comp_entry("rmn01",FALSE)
   END IF
END FUNCTION
#No.FUN-570109 --end
#CHI-C80041---begin
#FUNCTION t230_v()  #CHI-D20010
FUNCTION t230_v(p_type) #CHI-D20010
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  #CHI-D20010
DEFINE   p_type             LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rmn.rmn01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_rmn.rmnconf ='X' THEN RETURN END IF
   ELSE
      IF g_rmn.rmnconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t230_cl USING g_rmn.rmn01
   IF STATUS THEN
      CALL cl_err("OPEN t230_cl:", STATUS, 1)
      CLOSE t230_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t230_cl INTO g_rmn.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rmn.rmn01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t230_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_rmn.rmnconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_rmn.rmnconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010 
  #IF cl_void(0,0,g_rmn.rmnconf)   THEN #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN        #CHI-D20010
        LET l_chr=g_rmn.rmnconf
       #IF g_rmn.rmnconf='N' THEN  #CHI-D20010
        IF p_type = 1 THEN         #CHI-D20010
            LET g_rmn.rmnconf='X' 
        ELSE
            LET g_rmn.rmnconf='N'
        END IF
        UPDATE rmn_file
            SET rmnconf=g_rmn.rmnconf,  
                rmnmodu=g_user,
                rmndate=g_today
            WHERE rmn01=g_rmn.rmn01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","rmn_file",g_rmn.rmn01,"",SQLCA.sqlcode,"","",1)  
            LET g_rmn.rmnconf=l_chr 
        END IF
        DISPLAY BY NAME g_rmn.rmnconf
   END IF
 
   CLOSE t230_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rmn.rmn01,'V')
 
END FUNCTION
#CHI-C80041---end
