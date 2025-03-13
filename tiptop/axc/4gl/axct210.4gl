# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axct210.4gl
# Descriptions...: 每日工時維護作業
# Date & Author..: 01/11/06 BY DS/P
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.FUN-660160 06/06/23 By Sarah 根據參數(ccz06)決定cal02開窗為'部門代號'或'作業編號'或'工作中心'
# Modify.........: No.FUN-670037 06/07/13 By Sarah 增加cam10(投入標準人工工時),cam11(投入標準機器工時)
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0075 06/10/23 By bnlent g_no_ask --> mi_no_ask
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/10 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/07 By TSD.liquor 自定欄位功能修改
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A60080 10/07/08 By destiny 增加平行工艺逻辑
# Modify.........: No.FUN-A90065 10/10/18 By jan 增加cam081欄位
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No.TQC-B30191 11/03/28 By destiny 新增时orig,oriu栏位无值
# Modify.........: No.TQC-B40093 11/04/13 By yinhy 1.狀態PAGE中，資料建立者，資料建立部門欄位無法下查詢條件
#                                                  2.查詢時，工單編號欄位開窗無值顯示
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60248 11/06/21 By yinhy 查詢時，calorig、caloriu欄位無值
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫
# Modify.........: No:CHI-C80041 13/01/03 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題											

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_cal           RECORD LIKE cal_file.*, 
    g_cal_t         RECORD LIKE cal_file.*,  
    g_cal_o         RECORD LIKE cal_file.*,   
    g_cal01_t       LIKE cal_file.cal01,  
    g_cal02_t       LIKE cal_file.cal01,  
    g_cam           DYNAMIC ARRAY OF RECORD   
                     cam03  LIKE cam_file.cam03,  #序
                     cam04  LIKE cam_file.cam04,  #工單編號
                     cam012 LIKE cam_file.cam012, #NO.FUN-A60080
                     cam06  LIKE cam_file.cam06,  #製程序
                     ecm04  LIKE ecm_file.ecm04,   
                     cam07  LIKE cam_file.cam07,  #約當產量
                     cam08  LIKE cam_file.cam08,  #投入工時
                     cam081 LIKE cam_file.cam081, #投入機時 #FUN-A90065
                     cam10  LIKE cam_file.cam10,  #投入標準人工工時   #FUN-670037 add
                     cam11  LIKE cam_file.cam11,  #投入標準機器工時   #FUN-670037 add
                     #FUN-840202 --start---
                     camud01 LIKE cam_file.camud01,
                     camud02 LIKE cam_file.camud02,
                     camud03 LIKE cam_file.camud03,
                     camud04 LIKE cam_file.camud04,
                     camud05 LIKE cam_file.camud05,
                     camud06 LIKE cam_file.camud06,
                     camud07 LIKE cam_file.camud07,
                     camud08 LIKE cam_file.camud08,
                     camud09 LIKE cam_file.camud09,
                     camud10 LIKE cam_file.camud10,
                     camud11 LIKE cam_file.camud11,
                     camud12 LIKE cam_file.camud12,
                     camud13 LIKE cam_file.camud13,
                     camud14 LIKE cam_file.camud14,
                     camud15 LIKE cam_file.camud15
                     #FUN-840202 --end--
                    END RECORD,
    g_cam_t         RECORD       
                     cam03  LIKE cam_file.cam03,  #序
                     cam04  LIKE cam_file.cam04,  #工單編號
                     cam012 LIKE cam_file.cam012, #NO.FUN-A60080
                     cam06  LIKE cam_file.cam06,  #製程序
                     ecm04  LIKE ecm_file.ecm04,   
                     cam07  LIKE cam_file.cam07,  #約當產量
                     cam08  LIKE cam_file.cam08,  #投入工時
                     cam081 LIKE cam_file.cam081, #投入機時 #FUN-A90065
                     cam10  LIKE cam_file.cam10,  #投入標準人工工時   #FUN-670037 add
                     cam11  LIKE cam_file.cam11,  #投入標準機器工時   #FUN-670037 add
                     #FUN-840202 --start---
                     camud01 LIKE cam_file.camud01,
                     camud02 LIKE cam_file.camud02,
                     camud03 LIKE cam_file.camud03,
                     camud04 LIKE cam_file.camud04,
                     camud05 LIKE cam_file.camud05,
                     camud06 LIKE cam_file.camud06,
                     camud07 LIKE cam_file.camud07,
                     camud08 LIKE cam_file.camud08,
                     camud09 LIKE cam_file.camud09,
                     camud10 LIKE cam_file.camud10,
                     camud11 LIKE cam_file.camud11,
                     camud12 LIKE cam_file.camud12,
                     camud13 LIKE cam_file.camud13,
                     camud14 LIKE cam_file.camud14,
                     camud15 LIKE cam_file.camud15
                     #FUN-840202 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    l_za05          LIKE za_file.za05,
    g_refresh       LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(01)
 
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp       STRING   #No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_msg           LIKE ze_file.ze03            #No.FUN-680122 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680122 SMALLINT   #No.FUN-6A0075
DEFINE g_void          LIKE type_file.chr1          #CHI-C80041
 
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    LET g_refresh='Y' 
   
    WHILE g_refresh='Y' 
       LET g_refresh='N' 
       LET p_row = 3 LET p_col = 8
 
       OPEN WINDOW t210_w AT p_row,p_col              #顯示畫面
            WITH FORM "axc/42f/axct210"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       
       CALL cl_ui_init()
 
       LET g_forupd_sql = " SELECT * FROM cal_file ",
                          "  WHERE cal01=? AND cal02= ? ",
                          " FOR UPDATE "
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE t210_cl CURSOR FROM g_forupd_sql 
 
       CALL t210_menu()
 
       CLOSE WINDOW t210_w
    END WHILE  
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
#QBE 查詢資料
FUNCTION t210_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_cam.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_cal.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        cal01,cal02,cal03,calfirm,caluser,calgrup,calmodu,caldate,
        #FUN-840202   ---start---
        calud01,calud02,calud03,calud04,calud05,
        calud06,calud07,calud08,calud09,calud10,
        calud11,calud12,calud13,calud14,calud15,
        #FUN-840202    ----end----
        caloriu,calorig     #TQC-B40093
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE WHEN INFIELD(cal02)
               #start FUN-660160 modify
               #CALL cl_init_qry_var()
               #LET g_qryparam.form     = "q_gem"
               #LET g_qryparam.state = "c"
               #CALL cl_create_qry() RETURNING g_qryparam.multiret
                CASE g_ccz.ccz06
                   WHEN '3'
                      CALL q_ecd(TRUE,TRUE,"")
                           RETURNING g_qryparam.multiret
                   WHEN '4'
                      CALL q_eca(TRUE,TRUE,"")
                           RETURNING g_qryparam.multiret
                   OTHERWISE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     ="q_gem"
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                END CASE
               #end FUN-660160 modify
                DISPLAY g_qryparam.multiret TO cal02
                NEXT FIELD cal02
                EXIT CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('caluser', 'calgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND caluser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND calgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    CONSTRUCT g_wc2 ON cam03,cam04,cam012,cam06,cam07,cam08,cam081,cam10,cam11  #螢幕上取單身條件   #FUN-670037 add cam10,cam11  #NO.FUN-A60080 add cam012 #FUN-A90065
                       #No.FUN-840202 --start--
                       ,camud01,camud02,camud03,camud04,camud05
                       ,camud06,camud07,camud08,camud09,camud10
                       ,camud11,camud12,camud13,camud14,camud15
                       #No.FUN-840202 ---end---
            FROM s_cam[1].cam03,s_cam[1].cam04,s_cam[1].cam012,s_cam[1].cam06,   #NO.FUN-A60080 add cam012
                 s_cam[1].cam07,s_cam[1].cam08,s_cam[1].cam081,   #FUN-A90065 
                 s_cam[1].cam10,s_cam[1].cam11   #FUN-670037 add 
                 #No.FUN-840202 --start--
                 ,s_cam[1].camud01,s_cam[1].camud02,s_cam[1].camud03,s_cam[1].camud04,s_cam[1].camud05
                 ,s_cam[1].camud06,s_cam[1].camud07,s_cam[1].camud08,s_cam[1].camud09,s_cam[1].camud10
                 ,s_cam[1].camud11,s_cam[1].camud12,s_cam[1].camud13,s_cam[1].camud14,s_cam[1].camud15
                 #No.FUN-840202 ---end---
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
        #No.FUN-580031 --end--       HCN
        ON ACTION controlp 
            CASE
              WHEN INFIELD(cam04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_sfb"
                 LET g_qryparam.state = "c"
                 #No.TQC-B40093 --Mark Begin 
                 #LET g_qryparam.arg1  = ""
                 #IF g_qryparam.arg1 IS NOT NULL AND g_qryparam.arg1 != ' ' THEN
                 #   LET g_qryparam.where = g_qryparam.where CLIPPED,"
                 #   AND sfb04 IN ('",g_qryparam.arg1 CLIPPED,"') "
                 #END IF
                 #No.TQC-B40093 --Mark End
                 #LET g_qryparam.where = g_qryparam.where CLIPPED, " ORDER BY 1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cam04
                 NEXT FIELD cam04
              #NO.FUN-A60080--begin
              WHEN INFIELD(cam012)
                 CALL cl_init_qry_var()
               # LET g_qryparam.form  = "q_cam012"            #FUN-B10056 mark
                 LET g_qryparam.form  = "q_cam012_1"          #FUN-B10056
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cam012
                 NEXT FIELD cam012              
              #NO.FUN-A60080--end   
              WHEN INFIELD(cam06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_ecm"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cam06
                 NEXT FIELD cam06
              OTHERWISE EXIT CASE
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
             ON ACTION qbe_save
                CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE cal01,cal02 FROM cal_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY cal02"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cal01,cal02 ",
                   "  FROM cal_file,cam_file ",
                   " WHERE cal01 = cam01 ",
                   "   AND cal02 = cam02 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY cal02"
    END IF
 
    PREPARE t210_prepare FROM g_sql
    DECLARE t210_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t210_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
#       LET g_sql="SELECT UNIQUE cal01,cal02 ",      #No.TQC-720019
        LET g_sql_tmp="SELECT UNIQUE cal01,cal02 ",  #No.TQC-720019
                  "  FROM cal_file ",
                  " WHERE ", g_wc CLIPPED,
                  " INTO TEMP x "
    ELSE
#       LET g_sql="SELECT UNIQUE cal01,cal02 FROM cal_file,cam_file ",      #No.TQC-720019
        LET g_sql_tmp="SELECT UNIQUE cal01,cal02 FROM cal_file,cam_file ",  #No.TQC-720019
                  " WHERE cam01=cal01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " INTO TEMP x "
    END IF
    DROP TABLE x
#   PREPARE t210_precount_x FROM g_sql      #No.TQC-720019
    PREPARE t210_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE t210_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE t210_precount FROM g_sql
    DECLARE t210_count CURSOR FOR t210_precount
END FUNCTION
 
FUNCTION t210_menu()
 
   WHILE TRUE
      CALL t210_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t210_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t210_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t210_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL t210_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t210_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
               CALL t210_firm() 
            END IF  
            #圖形顯示
            CALL cl_set_field_pic(g_cal.calfirm,"","","","",g_cal.calacti)
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN 
               CALL t210_unfirm() 
            END IF  
            #圖形顯示
            CALL cl_set_field_pic(g_cal.calfirm,"","","","",g_cal.calacti)
        #WHEN "switch_plant"                  #FUN-B10030
        #   CALL cl_cmdrun('aoos901')         #FUN-B10030
        #   #IF NOT axc_stup("axct210") THEN  #FUN-B10030 
        #   #   EXIT PROGRAM                  #FUN-B10030
        #   #END IF                           #FUN-B10030
        #   LET g_refresh = 'Y'               #FUN-B10030  
        #   EXIT WHILE                        #FUN-B10030
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cam),'','')
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_cal.cal01 IS NOT NULL THEN
                LET g_doc.column1 = "cal01"
                LET g_doc.column2 = "cal02"
                LET g_doc.value1 = g_cal.cal01
                LET g_doc.value2 = g_cal.cal02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0019-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t210_v()                #CHI-D20010
               CALL t210_v(1)                #CHI-D20010
               IF g_cal.calfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cal.calfirm,"","","",g_void,g_cal.calacti)
            END IF
         #CHI-C80041---end 

         #CHI-D20010---add--str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t210_v(2)
               IF g_cal.calfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cal.calfirm,"","","",g_void,g_cal.calacti)
            END IF
         #CHI-D20010---add--end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t210_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_cam.clear()
    INITIALIZE g_cal.* LIKE cal_file.*             #DEFAULT 設定
    LET g_cal01_t = NULL
    LET g_cal02_t = NULL
 
    LET g_cal_o.* = g_cal.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cal.cal01=g_today 
        LET g_cal.cal05=0 
        LET g_cal.calfirm='N'
        LET g_cal.calacti='Y'
        LET g_cal.caluser=g_user
        LET g_cal.calgrup=g_grup
        LET g_cal.caldate=g_today
        LET g_cal.calinpd=g_today
       #LET g_cal.calplant=g_plant #FUN-980009 add     FUN-A50075
        LET g_cal.callegal=g_legal #FUN-980009 add
        LET g_cal.caloriu = g_user      #No.TQC-B60248
        LET g_cal.calorig = g_grup      #No.TQC-B60248
        CALL t210_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_cal.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cal.cal01 IS NULL OR g_cal.cal02 IS NULL THEN  #KEY 不可空白
            CONTINUE WHILE
        END IF
        #LET g_cal.caloriu = g_user      #No.FUN-980030 10/01/04
        #LET g_cal.calorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cal_file VALUES (g_cal.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err(g_cal.cal01,SQLCA.sqlcode,1)
            CONTINUE WHILE
        END IF
        SELECT cal01,cal02 INTO g_cal.cal01,g_cal.cal02 FROM cal_file
            WHERE cal01=g_cal.cal01
              AND cal02=g_cal.cal02 
        LET g_cal01_t = g_cal.cal01        #保留舊值
        LET g_cal02_t = g_cal.cal02        #保留舊值
        LET g_cal_t.* = g_cal.*
        LET g_rec_b=0
        CALL t210_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t210_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cal.cal01 IS NULL OR g_cal.cal02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT cal_file.* INTO g_cal.* FROM cal_file WHERE cal01=g_cal.cal01
                                          AND cal02=g_cal.cal02 
    IF g_cal.calfirm='X' THEN RETURN END IF  #CHI-C80041                                      
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cal01_t = g_cal.cal01
    LET g_cal02_t = g_cal.cal02
    LET g_cal_o.* = g_cal.*
    BEGIN WORK
 
    OPEN t210_cl USING g_cal.cal01,g_cal.cal02
    IF STATUS THEN
       CALL cl_err("OPEN t210_cl:", STATUS, 1)
       CLOSE t210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t210_cl INTO g_cal.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t210_cl ROLLBACK WORK RETURN
    END IF
    CALL t210_show()
    WHILE TRUE
        LET g_cal01_t = g_cal.cal01
        LET g_cal02_t = g_cal.cal02
        LET g_cal.calmodu=g_user
        LET g_cal.caldate=g_today
        CALL t210_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cal.*=g_cal_t.*
            CALL t210_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE cal_file SET cal_file.* = g_cal.*
            WHERE cal01=g_cal.cal01 
              AND cal02=g_cal.cal02 
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t210_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t210_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680122 VARCHAR(1)
    l_gem02         LIKE gem_file.gem02, 
    l_desc          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
    l_cnt           LIKE type_file.num5           #No.FUN-680122 SMALLINT
 
    DISPLAY BY NAME g_cal.cal01,g_cal.cal02,g_cal.cal03,
                    g_cal.cal05,g_cal.calfirm,g_cal.caluser,
                    g_cal.calgrup,g_cal.calmodu,g_cal.caldate,  
                    g_cal.calorig,g_cal.caloriu,                 #TQC-B30191
                    #FUN-840202     ---start---
                    g_cal.calud01,g_cal.calud02,g_cal.calud03,g_cal.calud04,
                    g_cal.calud05,g_cal.calud06,g_cal.calud07,g_cal.calud08,
                    g_cal.calud09,g_cal.calud10,g_cal.calud11,g_cal.calud12,
                    g_cal.calud13,g_cal.calud14,g_cal.calud15 
                    #FUN-840202     ----end----
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME
        g_cal.cal01,g_cal.cal02,g_cal.cal03,g_cal.calfirm,
        g_cal.caluser,g_cal.calgrup,g_cal.calmodu,g_cal.caldate,
        #FUN-840202     ---start---
        g_cal.calud01,g_cal.calud02,g_cal.calud03,g_cal.calud04,
        g_cal.calud05,g_cal.calud06,g_cal.calud07,g_cal.calud08,
        g_cal.calud09,g_cal.calud10,g_cal.calud11,g_cal.calud12,
        g_cal.calud13,g_cal.calud14,g_cal.calud15 
        #FUN-840202     ----end----
        WITHOUT DEFAULTS  
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t210_set_entry(p_cmd)
            CALL t210_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            #No.FUN-550025 --start--
            CALL cl_set_docno_format("cam04")
            #No.FUN-550025 ---end---
       {
        BEFORE FIELD cal01                
            IF p_cmd = 'u' AND g_chkey = 'N' THEN NEXT FIELD cal03 END IF
       }
        AFTER FIELD cal02                
            IF NOT cl_null(g_cal.cal02) THEN
               IF g_cal.cal02 !=g_cal02_t OR g_cal02_t IS NULL OR 
                  g_cal.cal01 !=g_cal01_t OR g_cal01_t IS NULL THEN
                   SELECT count(*) INTO g_cnt FROM cal_file
                       WHERE cal02= g_cal.cal02
                         AND cal01= g_cal.cal01 
                   IF g_cnt > 0 THEN   #資料重複
                       LET g_msg=g_cal.cal01 CLIPPED,g_cal.cal02 CLIPPED
                       CALL cl_err(g_msg,-239,0)
                       LET g_cal.cal01 = g_cal01_t
                       LET g_cal.cal02 = g_cal02_t
                       DISPLAY BY NAME g_cal.cal01 
                       DISPLAY BY NAME g_cal.cal02 
                       NEXT FIELD cal02
                   END IF
               END IF
              #start FUN-660160 modify
              #SELECT gem02 INTO l_gem02 FROM gem_file 
              # WHERE gem01=g_cal.cal02 
               CASE g_ccz.ccz06
                  WHEN '3'
                     SELECT ecd02 INTO l_gem02
                       FROM ecd_file
                      WHERE ecd01 = g_cal.cal02
                  WHEN '4'
                     SELECT eca02 INTO l_gem02
                       FROM eca_file
                      WHERE eca01 = g_cal.cal02
                  OTHERWISE
                     SELECT gem02 INTO l_gem02
                       FROM gem_file
                      WHERE gem01 = g_cal.cal02
               END CASE
              #end FUN-660160 modify
               DISPLAY l_gem02 TO FORMONLY.gem02 
            END IF
 
        #FUN-840202     ---start---
        AFTER FIELD calud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD calud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
 
       AFTER INPUT  
          LET g_cal.caluser = s_get_data_owner("cal_file") #FUN-C10039
          LET g_cal.calgrup = s_get_data_group("cal_file") #FUN-C10039
        ON ACTION controlp
           CASE WHEN INFIELD(cal02)
               #start FUN-660160 modify
               #CALL cl_init_qry_var()
               #LET g_qryparam.form     = "q_gem"
               #LET g_qryparam.default1 = g_cal.cal02
               #CALL cl_create_qry() RETURNING g_cal.cal02
                CASE g_ccz.ccz06
                   WHEN '3'
                      CALL q_ecd(FALSE,TRUE,g_cal.cal02)
                           RETURNING g_cal.cal02
                   WHEN '4'
                      CALL q_eca(FALSE,TRUE,g_cal.cal02)
                           RETURNING g_cal.cal02
                   OTHERWISE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     ="q_gem"
                      LET g_qryparam.default1 = g_cal.cal02
                      CALL cl_create_qry() RETURNING g_cal.cal02
                END CASE
               #end FUN-660160 modify
#                CALL FGL_DIALOG_SETBUFFER( g_cal.cal02 )
                DISPLAY BY NAME g_cal.cal02
                NEXT FIELD cal02
               EXIT CASE
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
FUNCTION t210_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("cal01,cal02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t210_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cal01,cal02",FALSE)
    END IF
 
END FUNCTION
 
#Query 查詢     
FUNCTION t210_q()
  DEFINE l_cal01 LIKE cal_file.cal01 
  DEFINE l_cal02 LIKE cal_file.cal02 
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cal.* TO NULL             #No.FUN-6A0019
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_cam.clear()
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL t210_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN t210_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cal.* TO NULL
    ELSE
       OPEN t210_count
       FETCH t210_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt 
       CALL t210_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t210_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680122 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t210_cs INTO g_cal.cal01,g_cal.cal02
        WHEN 'P' FETCH PREVIOUS t210_cs INTO g_cal.cal01,g_cal.cal02
        WHEN 'F' FETCH FIRST    t210_cs INTO g_cal.cal01,g_cal.cal02
        WHEN 'L' FETCH LAST     t210_cs INTO g_cal.cal01,g_cal.cal02
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0075
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t210_cs INTO g_cal.cal01,g_cal.cal02
            LET mi_no_ask = FALSE   #No.FUN-6A0075
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)
        INITIALIZE g_cal.* TO NULL  #TQC-6B0105
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
    SELECT cal_file.* INTO g_cal.* FROM cal_file WHERE cal01=g_cal.cal01
                                          AND cal02=g_cal.cal02 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)
        INITIALIZE g_cal.* TO NULL
        RETURN
    ELSE                                    
       LET g_data_owner=g_cal.caluser           #FUN-4C0061權限控管
       LET g_data_group=g_cal.calgrup
    END IF
    CALL t210_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t210_show()
    DEFINE l_cnt      LIKE type_file.num5           #No.FUN-680122 SMALLINT
    DEFINE l_desc     LIKE type_file.chr20          #No.FUN-680122CHAR(10)
    DEFINE l_gem02    LIKE gem_file.gem02 
 
    LET g_cal_t.* = g_cal.*                      #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_cal.cal01,g_cal.cal02,g_cal.cal03,g_cal.cal05,
        g_cal.calfirm,g_cal.caluser,g_cal.calgrup,g_cal.calmodu,
        g_cal.caldate, 
        #FUN-840202     ---start---
        g_cal.calud01,g_cal.calud02,g_cal.calud03,g_cal.calud04,
        g_cal.calud05,g_cal.calud06,g_cal.calud07,g_cal.calud08,
        g_cal.calud09,g_cal.calud10,g_cal.calud11,g_cal.calud12,
        g_cal.calud13,g_cal.calud14,g_cal.calud15, 
        #FUN-840202     ----end----
        g_cal.caloriu,g_cal.calorig        #No.TQC-B60248
   #start FUN-660160 modify
   #SELECT gem02 INTO l_gem02 FROM gem_file 
   # WHERE gem01=g_cal.cal02 
    CASE g_ccz.ccz06
       WHEN '3'
          SELECT ecd02 INTO l_gem02
            FROM ecd_file
           WHERE ecd01 = g_cal.cal02
       WHEN '4'
          SELECT eca02 INTO l_gem02
            FROM eca_file
           WHERE eca01 = g_cal.cal02
       OTHERWISE
          SELECT gem02 INTO l_gem02
            FROM gem_file
           WHERE gem01 = g_cal.cal02
    END CASE
   #end FUN-660160 modify
    DISPLAY l_gem02 TO FORMONLY.gem02 
    CALL t210_b_fill(g_wc2)                 #單身
 
    #圖形顯示
    #CALL cl_set_field_pic(g_cal.calfirm,"","","","",g_cal.calacti)  #CHI-C80041
    IF g_cal.calfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cal.calfirm,"","","",g_void,g_cal.calacti)  #CHI-C80041
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t210_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cal.cal01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_cal.calfirm='X' THEN RETURN END IF  #CHI-C80041
    BEGIN WORK
 
    OPEN t210_cl USING g_cal.cal01,g_cal.cal02
    IF STATUS THEN
       CALL cl_err("OPEN t210_cl:", STATUS, 1)
       CLOSE t210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t210_cl INTO g_cal.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t210_cl ROLLBACK WORK RETURN
    END IF
    CALL t210_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cal01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cal02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cal.cal01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cal.cal02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM cal_file WHERE cal01 = g_cal.cal01
                                AND cal02 = g_cal.cal02
         DELETE FROM cam_file WHERE cam01 = g_cal.cal01
                                AND cam02 = g_cal.cal02
         INITIALIZE g_cal.* TO NULL
         CLEAR FORM
         CALL g_cam.clear()
         DROP TABLE x
#        EXECUTE t210_precount_x                  #No.TQC-720019
         PREPARE t210_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE t210_precount_x2                 #No.TQC-720019
         OPEN t210_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t210_cs
            CLOSE t210_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t210_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t210_cs
            CLOSE t210_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t210_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t210_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE   #No.FUN-6A0075
            CALL t210_fetch('/')
         END IF
    END IF
    CLOSE t210_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t210_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cal.cal01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t210_cl USING g_cal.cal01,g_cal.cal02
    IF STATUS THEN
       CALL cl_err("OPEN t210_cl:", STATUS, 1)
       CLOSE t210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t210_cl INTO g_cal.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t210_cl ROLLBACK WORK RETURN
    END IF
    CALL t210_show()
    IF cl_exp(0,0,g_cal.calacti) THEN                   #確認一下
        LET g_chr=g_cal.calacti
        IF g_cal.calacti='Y' THEN
            LET g_cal.calacti='N'
        ELSE
            LET g_cal.calacti='Y'
        END IF
        UPDATE cal_file                    #更改有效碼
            SET calacti=g_cal.calacti
            WHERE cal01=g_cal.cal01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)
            LET g_cal.calacti=g_chr
        END IF
        DISPLAY BY NAME g_cal.calacti 
    END IF
    CLOSE t210_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t210_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680122 VARCHAR(1)
    l_cam08         LIKE cam_file.cam08,
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否        #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cal.cal01 IS NULL OR g_cal.cal02 IS NULL THEN
        RETURN
    END IF
    SELECT cal_file.* INTO g_cal.* FROM cal_file WHERE cal01=g_cal.cal01 
                                          AND cal02=g_cal.cal02 
    IF g_cal.calfirm='X' THEN RETURN END IF  #CHI-C80041
    IF g_cal.calfirm='Y' THEN RETURN END IF 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT cam03,cam04,cam012,cam06,'',cam07,cam08,cam081,cam10,cam11, ",   #FUN-670037 add cam10,cam11 #NO.FUN-A60080 add cam012 #FUN-A90065
                       #No.FUN-840202 --start--
                       "       camud01,camud02,camud03,camud04,camud05,",
                       "       camud06,camud07,camud08,camud09,camud10,",
                       "       camud11,camud12,camud13,camud14,camud15", 
                       #No.FUN-840202 ---end---
                       "  FROM cam_file  ",
                       "  WHERE cam01=? ",
                       "    AND cam02=? ",
                       "    AND cam03=? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t210_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_cam WITHOUT DEFAULTS FROM s_cam.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3 
            LET l_lock_sw = 'N'          
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t210_cl USING g_cal.cal01,g_cal.cal02
            IF STATUS THEN
               CALL cl_err("OPEN t210_cl:", STATUS, 1)
               CLOSE t210_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t210_cl INTO g_cal.*          #鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)      #資料被他人LOCK
                CLOSE t210_cl
                ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET g_cam_t.* = g_cam[l_ac].* 
                LET p_cmd='u'
 
                OPEN t210_bcl USING g_cal.cal01, g_cal.cal02, g_cam_t.cam03
 
                IF STATUS THEN
                   CALL cl_err("OPEN t210_bcl:", STATUS, 1)
                   CLOSE t210_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t210_bcl INTO g_cam[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cam_t.cam03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL t210_cam06(' ')           
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO cam_file(cam01,cam02,cam03,cam04,
                                 cam06,cam07,cam08,cam081,cam10,cam11,   #FUN-670037 add cam10,cam11 #FUN-A90065
                                 #FUN-840202 --start--
                                 camud01,camud02,camud03,
                                 camud04,camud05,camud06,
                                 camud07,camud08,camud09,
                                 camud10,camud11,camud12,
                                #camud13,camud14,camud15,camplant,camlegal #FUN-980009 add camplant,camlegal    #FUN-A50075
                                 camud13,camud14,camud15,camlegal,cam012 #NO.FUN-A60080 add cam012
                                 #FUN-840202 --end--
                                )
            VALUES(g_cal.cal01,g_cal.cal02,g_cam[l_ac].cam03,
                   g_cam[l_ac].cam04,g_cam[l_ac].cam06,
                   g_cam[l_ac].cam07,g_cam[l_ac].cam08,g_cam[l_ac].cam081,  #FUN-A90065
                   g_cam[l_ac].cam10,g_cam[l_ac].cam11,          #FUN-670037 add
                   #FUN-840202 --start--
                   g_cam[l_ac].camud01,
                   g_cam[l_ac].camud02,
                   g_cam[l_ac].camud03,
                   g_cam[l_ac].camud04,
                   g_cam[l_ac].camud05,
                   g_cam[l_ac].camud06,
                   g_cam[l_ac].camud07,
                   g_cam[l_ac].camud08,
                   g_cam[l_ac].camud09,
                   g_cam[l_ac].camud10,
                   g_cam[l_ac].camud11,
                   g_cam[l_ac].camud12,
                   g_cam[l_ac].camud13,
                   g_cam[l_ac].camud14,
                  #g_cam[l_ac].camud15,g_plant,g_legal  #FUN-980009 add g_plant,g_legal    #FUN-A50075
                   g_cam[l_ac].camud15,g_legal,          #FUN-A50075 
                   #FUN-840202 --end--
                   g_cam[l_ac].cam012 #NO.FUN-A60080
                  )
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_cam[l_ac].cam03,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2 
                COMMIT WORK
            END IF
            SELECT SUM(cam08) INTO l_cam08 FROM cam_file 
               WHERE cam01=g_cal.cal01 AND cam02=g_cal.cal02 
            IF cl_null(l_cam08) THEN LET l_cam08=0 END IF 
            UPDATE cal_file SET cal05= l_cam08 
               WHERE cal01=g_cal.cal01  AND cal02=g_cal.cal02  
            IF STATUS THEN CALL cl_err('UPD cal05',STATUS,1) END IF  
            DISPLAY l_cam08 TO cal05 
            LET g_cam_t.* = g_cam[l_ac].*          # 900423
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_cam[l_ac].* TO NULL      #900423
            LET g_cam_t.* = g_cam[l_ac].*         #新輸入資料
            LET g_cam[l_ac].cam10 = 0   #FUN-670037 add
            LET g_cam[l_ac].cam11 = 0   #FUN-670037 add 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cam03
 
        BEFORE FIELD cam03                        #default 序號
            IF g_cam[l_ac].cam03 IS NULL OR
               g_cam[l_ac].cam03 = 0 THEN
                SELECT max(cam03)+1
                   INTO g_cam[l_ac].cam03
                   FROM cam_file
                   WHERE cam01 = g_cal.cal01
                     AND cam02 = g_cal.cal02
                IF g_cam[l_ac].cam03 IS NULL THEN
                    LET g_cam[l_ac].cam03 = 1
                END IF
#               DISPLAY g_cam[l_ac].cam03 TO cam03 #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD cam03         
            IF NOT g_cam[l_ac].cam03 IS NULL THEN
               IF g_cam[l_ac].cam03 != g_cam_t.cam03 OR
                  g_cam_t.cam03 IS NULL THEN
                   SELECT count(*)
                       INTO l_n
                       FROM cam_file
                       WHERE cam01 = g_cal.cal01 AND
                             cam02 = g_cal.cal02 AND 
                             cam03 = g_cam[l_ac].cam03 
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cam[l_ac].cam03 = g_cam_t.cam03
                       NEXT FIELD cam03
                   END IF
               END IF
            END IF
 
        AFTER FIELD cam04	
            IF NOT cl_null(g_cam[l_ac].cam04) THEN   # 重要欄位不可空白
               #須存在製程追縱檔
               SELECT COUNT(*) INTO g_cnt FROM ecm_file 
                WHERE ecm01=g_cam[l_ac].cam04 
               IF g_cnt=0 THEN 
                 CALL cl_err(g_cam[l_ac].cam04,'axc-193',1)
                 NEXT FIELD cam04 
               END IF   
           # LET INT_FLAG = 0  ######add for prompt bug
           #      PROMPT "該工單未產生製程追縱檔! 請重新輸入!" FOR g_chr 
           #         ON IDLE g_idle_seconds
           #            CALL cl_on_idle()
#          #             CONTINUE PROMPT
 
 #                    ON ACTION about         #MOD-4C0121
 #                       CALL cl_about()      #MOD-4C0121
#                
 #                    ON ACTION help          #MOD-4C0121
 #                       CALL cl_show_help()  #MOD-4C0121
#                
 #                    ON ACTION controlg      #MOD-4C0121
 #                       CALL cl_cmdask()     #MOD-4C0121
 
           #      END PROMPT
           #      NEXT FIELD cam04 
           #    END IF 
            END IF 

        #NO.FUN-A60080--begin
        AFTER FIELD cam012 
            IF NOT cl_null(g_cam[l_ac].cam012) THEN  
               CALL t210_cam012()
               IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_cam[l_ac].cam012,g_errno,1) 
                 NEXT FIELD cam012 
               END IF 
            END IF         
        #NO.FUN-A60080--end 
        AFTER FIELD cam06 
            IF NOT cl_null(g_cam[l_ac].cam06) THEN  
               CALL t210_cam06('d')
               IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_cam[l_ac].cam06,g_errno,1) 
                 NEXT FIELD cam06 
               END IF 
               DISPLAY g_cam[l_ac].cam06 TO cam06 
               DISPLAY g_cam[l_ac].ecm04 TO ecm04 
            END IF 
         
        AFTER FIELD cam07 
           IF NOT cl_null(g_cam[l_ac].cam07) THEN
              IF g_cam[l_ac].cam07 <=0 THEN 
                 NEXT FIELD cam07 
              END IF 
           END IF 
 
       #start FUN-670037 add 
        AFTER FIELD cam10 
           IF cl_null(g_cam[l_ac].cam10) OR g_cam[l_ac].cam10 < 0 THEN
              CALL cl_err('','mfg3291',0)
              NEXT FIELD cam10 
           END IF 
 
        AFTER FIELD cam11 
           IF cl_null(g_cam[l_ac].cam11) OR g_cam[l_ac].cam11 < 0 THEN
              CALL cl_err('','mfg3291',0)
              NEXT FIELD cam11 
           END IF 
       #end FUN-670037 add 
 
        #No.FUN-840202 --start--
        AFTER FIELD camud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD camud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_cam_t.cam03 > 0 AND
               g_cam_t.cam03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM cam_file
                    WHERE cam01 = g_cal.cal01 AND cam02=g_cal.cal02 
                      AND cam03 = g_cam_t.cam03
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_cam_t.cam03,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2 
            COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cam[l_ac].* = g_cam_t.*
               CLOSE t210_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cam[l_ac].cam03,-263,1)
               LET g_cam[l_ac].* = g_cam_t.*
            ELSE
               UPDATE cam_file SET cam03 = g_cam[l_ac].cam03,
                                   cam04 = g_cam[l_ac].cam04,
                                   cam012 = g_cam[l_ac].cam012, #NO.FUN-A60080
                                   cam06 = g_cam[l_ac].cam06,
                                   cam07 = g_cam[l_ac].cam07,
                                   cam08 = g_cam[l_ac].cam08,
                                   cam081= g_cam[l_ac].cam081,  #FUN-A90065
                                   cam10 = g_cam[l_ac].cam10,   #FUN-670037 add
                                   cam11 = g_cam[l_ac].cam11,   #FUN-670037 add
                                   #FUN-840202 --start--
                                   camud01 = g_cam[l_ac].camud01,
                                   camud02 = g_cam[l_ac].camud02,
                                   camud03 = g_cam[l_ac].camud03,
                                   camud04 = g_cam[l_ac].camud04,
                                   camud05 = g_cam[l_ac].camud05,
                                   camud06 = g_cam[l_ac].camud06,
                                   camud07 = g_cam[l_ac].camud07,
                                   camud08 = g_cam[l_ac].camud08,
                                   camud09 = g_cam[l_ac].camud09,
                                   camud10 = g_cam[l_ac].camud10,
                                   camud11 = g_cam[l_ac].camud11,
                                   camud12 = g_cam[l_ac].camud12,
                                   camud13 = g_cam[l_ac].camud13,
                                   camud14 = g_cam[l_ac].camud14,
                                   camud15 = g_cam[l_ac].camud15
                                   #FUN-840202 --end-- 
               WHERE cam01=g_cal.cal01
                 AND cam02=g_cal.cal02
                 AND cam03=g_cam_t.cam03
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_cam[l_ac].cam03,SQLCA.sqlcode,0)
                   LET g_cam[l_ac].* = g_cam_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
            SELECT SUM(cam08) INTO l_cam08 FROM cam_file 
               WHERE cam01=g_cal.cal01 AND cam02=g_cal.cal02 
            IF cl_null(l_cam08) THEN LET l_cam08=0 END IF 
            UPDATE cal_file SET cal05= l_cam08 
               WHERE cal01=g_cal.cal01  AND cal02=g_cal.cal02  
            IF STATUS THEN CALL cl_err('UPD cal05',STATUS,1) END IF  
            DISPLAY l_cam08 TO cal05 
            LET g_cam_t.* = g_cam[l_ac].*          # 900423
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_cam[l_ac].* = g_cam_t.*
               #FUN-D40030--add--begin--					
               ELSE					
                  CALL g_cam.deleteElement(l_ac)					
                  IF g_rec_b != 0 THEN					
                     LET g_action_choice = "detail"					
                     LET l_ac = l_ac_t					
                  END IF					
               #FUN-D40030--add--end----					
               END IF
               CLOSE t210_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D40030 add
            CLOSE t210_bcl
            COMMIT WORK
 
        ON ACTION controlp 
            CASE
              WHEN INFIELD(cam04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_sfb"
                   LET g_qryparam.default1 = g_cam[l_ac].cam04
                   LET g_qryparam.arg1     = ""
                   IF g_qryparam.arg1 IS NOT NULL AND g_qryparam.arg1 != ' ' THEN
                      LET g_qryparam.where = g_qryparam.where CLIPPED,"
                      AND sfb04 IN ('",g_qryparam.arg1 CLIPPED,"') "
                   END IF
                  # LET g_qryparam.where = g_qryparam.where CLIPPED, " ORDER BY 1"
                   CALL cl_create_qry() RETURNING g_cam[l_ac].cam04
                   #CALL FGL_DIALOG_SETBUFFER( g_cam[l_ac].cam04 )
                   DISPLAY g_cam[l_ac].cam04 TO cam04
                   NEXT FIELD cam04
              #NO.FUN-A60080--begin
              WHEN INFIELD(cam012)
                   CALL cl_init_qry_var()
                 # LET g_qryparam.form     = "q_ecm_1"              #FUN-B10056 mark
                   LET g_qryparam.form     = "q_ecb012_1"           #FUN-B10056
                   LET g_qryparam.arg1 = g_cam[l_ac].cam04
                   LET g_qryparam.default1 = g_cam[l_ac].cam012
#                   LET g_qryparam.default2 = g_cam[l_ac].cam06
                   CALL cl_create_qry() RETURNING g_cam[l_ac].cam012
                   IF cl_null(g_cam[l_ac].cam012) THEN LET g_cam[l_ac].cam012 = ' ' END IF   #FUN-B10056   
                   #DISPLAY g_cam[l_ac].cam06 TO cam06
                   DISPLAY g_cam[l_ac].ecm04 TO cam012
                   NEXT FIELD cam012              
              #NO.FUN-A60080--end    
              WHEN INFIELD(cam06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_ecm"
                   LET g_qryparam.default1 = g_cam[l_ac].ecm04
                   LET g_qryparam.default2 = g_cam[l_ac].cam06
                   CALL cl_create_qry() RETURNING g_cam[l_ac].ecm04,
                                                  g_cam[l_ac].cam06
#                   CALL FGL_DIALOG_SETBUFFER( g_cam[l_ac].ecm04 )
#                   CALL FGL_DIALOG_SETBUFFER( g_cam[l_ac].cam06 )
                   DISPLAY g_cam[l_ac].cam06 TO cam06
                   DISPLAY g_cam[l_ac].ecm04 TO ecm04
                   NEXT FIELD cam06
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cam03) AND l_ac > 1 THEN
                LET g_cam[l_ac].* = g_cam[l_ac-1].*
                LET g_cam[l_ac].cam03 = NULL   #TQC-620018
                NEXT FIELD cam03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controls                                      #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")                    #No.FUN-6A0092       
 
 
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
 
        END INPUT
 
    #FUN-5B0113-begin
     LET g_cal.calmodu = g_user
     LET g_cal.caldate = g_today
     UPDATE cal_file SET calmodu = g_cal.calmodu,caldate = g_cal.caldate
      WHERE cal01 = g_cal.cal01
        AND cal02 = g_cal.cal02
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err('upd cal',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_cal.calmodu,g_cal.caldate
    #FUN-5B0113-end
 
    CLOSE t210_bcl
    COMMIT WORK
    CALL t210_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t210_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin      
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
         #CALL t210_v()             #CHI-D20010
         CALL t210_v(1)             #CHI-D20010
         IF g_cal.calfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_cal.calfirm,"","","",g_void,g_cal.calacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM cal_file WHERE cal01 = g_cal.cal01
         INITIALIZE g_cal.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
{
FUNCTION t210_delall()
    SELECT COUNT(*) INTO g_cnt FROM cam_file
        WHERE cam01 = g_cal.cal01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM cal_file WHERE cal01 = g_cal.cal01
    END IF
END FUNCTION
}   
#NO.FUN-A60080--begin
FUNCTION t210_cam012()
DEFINE   l_n   LIKE type_file.num5 

   LET g_errno = ' '
   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM ecm_file WHERE ecm01=g_cam[l_ac].cam04
   AND ecm012=g_cam[l_ac].cam012 
   IF l_n=0 THEN 
      LET g_errno='axc-216'
   END IF 
END FUNCTION 
#NO.FUN-A60080--end 
FUNCTION t210_cam06(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
    l_genacti       LIKE gen_file.genacti
 
    LET g_errno = ' '
    LET g_cam[l_ac].ecm04=''
    SELECT ecm04 INTO g_cam[l_ac].ecm04 
      FROM ecm_file 
     WHERE ecm01=g_cam[l_ac].cam04 
       AND ecm03=g_cam[l_ac].cam06 
       AND ecm012=g_cam[l_ac].cam012 #NO.FUN-A60080
    IF STATUS=100 THEN 
      LET g_errno='aec-085' 
      #CALL cl_err('','aec-085',1) 
    ELSE 
     IF STATUS >0 AND NOT cl_null(g_cam[l_ac].ecm04) THEN 
       DISPLAY g_cam[l_ac].ecm04 TO ecm04 
     ELSE 
       IF STATUS !=0 THEN 
         LET g_errno='axr-334' 
       END IF 
     END IF 
    END IF 
END FUNCTION
 
FUNCTION t210_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    CLEAR gen02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON cam02,cam03,cam04,cam012   #NO.FUN-A60080
         FROM s_cam[1].cam02,s_cam[1].cam03,s_cam[1].cam04,s_cam[1].cam012  #NO.FUN-A60080
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t210_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t210_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    LET g_sql =
        "SELECT cam03,cam04,cam012,cam06,'',cam07,cam08,cam081,cam10,cam11, ",   #FUN-670037 add cam10,cam11  #NO.FUN-A60080 #FUN-A90065
        #No.FUN-840202 --start--
        "       camud01,camud02,camud03,camud04,camud05,",
        "       camud06,camud07,camud08,camud09,camud10,",
        "       camud11,camud12,camud13,camud14,camud15", 
        #No.FUN-840202 ---end---
        " FROM cam_file ",
        " WHERE cam01 ='",g_cal.cal01,"' ",  #單頭
        "   AND cam02 ='",g_cal.cal02,"' ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE t210_pb FROM g_sql
    DECLARE cam_curs                       #SCROLL CURSOR
        CURSOR FOR t210_pb
 
    CALL g_cam.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH cam_curs INTO g_cam[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ecm04 INTO g_cam[g_cnt].ecm04 FROM ecm_file 
         WHERE ecm01=g_cam[g_cnt].cam04 
           AND ecm03=g_cam[g_cnt].cam06 
           AND ecm012=g_cam[g_cnt].cam012
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_cam.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
    DISPLAY ARRAY g_cam TO s_cam.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
      ON ACTION first 
         CALL t210_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t210_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL t210_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t210_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last 
         CALL t210_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
  
     ON ACTION controls                                 #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")            #No.FUN-6A0092
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #圖形顯示
         #CALL cl_set_field_pic(g_cal.calfirm,"","","","",g_cal.calacti)  #CHI-C80041
         IF g_cal.calfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_cal.calfirm,"","","",g_void,g_cal.calacti)  #CHI-C80041
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
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
     
      #CHI-D20010--add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010--add---end

      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                      #FUN-B10030
    #    LET g_action_choice="switch_plant"       #FUN-B10030
   #     EXIT DISPLAY                             #FUN-B10030
 
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
   
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t210_copy()
DEFINE
    l_cal		RECORD LIKE cal_file.*,
    l_oldno,l_newno	LIKE cal_file.cal01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cal.cal01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY "" AT 1,1
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1 
    LET g_before_input_done = FALSE
    CALL t210_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM cal01
       AFTER FIELD cal01
          IF NOT cl_null(l_newno)  THEN
             SELECT count(*) INTO g_cnt FROM cal_file
                 WHERE cal01 = l_newno
                   AND calfirm <> 'X'  #CHI-C80041
             IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 NEXT FIELD cal01
             END IF
          END IF
 
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
        DISPLAY BY NAME g_cal.cal01 
        RETURN
    END IF
    LET l_cal.* = g_cal.*
    LET l_cal.cal01  =l_newno   #新的鍵值
    LET l_cal.caluser=g_user    #資料所有者
    LET l_cal.calgrup=g_grup    #資料所有者所屬群
    LET l_cal.calmodu=NULL      #資料修改日期
    LET l_cal.caldate=g_today   #資料建立日期
    LET l_cal.calacti='Y'       #有效資料
   #LET l_cal.calplant=g_plant #FUN-980009 add     #FUN-A50075
    LET l_cal.callegal=g_legal #FUN-980009 add 
    BEGIN WORK
    LET l_cal.caloriu = g_user      #No.FUN-980030 10/01/04
    LET l_cal.calorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO cal_file VALUES (l_cal.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err('cal:',SQLCA.sqlcode,0)
        RETURN
    END IF
 
    DROP TABLE x
    SELECT cal_file.* FROM cam_file         #單身複製
        WHERE cam01=g_cal.cal01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)
        RETURN
    END IF
    UPDATE x
        SET   cam01=l_newno
    INSERT INTO cam_file
        SELECT cal_file.* FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err('cam:',SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        
     LET l_oldno = g_cal.cal01
     SELECT cal_file.* INTO g_cal.* FROM cal_file WHERE cal01 = l_newno
     CALL t210_u()
     CALL t210_b()
     #SELECT cal_file.* INTO g_cal.* FROM cal_file WHERE cal01 = l_oldno  #FUN-C80046
     #CALL t210_show()  #FUN-C80046
END FUNCTION
 
FUNCTION t210_firm()
  IF g_cal.cal01 IS NULL OR g_cal.cal02 IS NULL THEN 
     CALL cl_err('','-400',0) RETURN 
  END IF 
#CHI-C30107 --------------- add ----------------- begin
  SELECT COUNT(*) INTO g_cnt FROM cam_file
   WHERE cam01=g_cal.cal01
  IF g_cnt = 0 THEN
     CALL cl_err('','arm-034',1) RETURN
  END IF
  IF g_cal.calfirm='X' THEN RETURN END IF  #CHI-C80041
  IF g_cal.calfirm='Y' THEN CALL cl_err('','9023',1) RETURN END IF
  IF NOT cl_confirm('axr-108') THEN RETURN END IF
  SELECT * INTO g_cal.* FROM cal_file WHERE cal01=g_cal.cal01
                                        AND cal02=g_cal.cal02 
#CHI-C30107 --------------- add ----------------- end
  #no.7377
  SELECT COUNT(*) INTO g_cnt FROM cam_file
   WHERE cam01=g_cal.cal01
  IF g_cnt = 0 THEN
     CALL cl_err('','arm-034',1) RETURN
  END IF
  #no.7377(end)
  IF g_cal.calfirm='X' THEN RETURN END IF  #CHI-C80041
  IF g_cal.calfirm='Y' THEN CALL cl_err('','9023',1) RETURN END IF 
# IF NOT cl_confirm('axr-108') THEN RETURN END IF #CHI-C30107 mark
  BEGIN WORK 
  LET g_success='Y'
  UPDATE cal_file SET calfirm='Y' 
    WHERE cal01=g_cal.cal01 
      AND cal02=g_cal.cal02 
  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
    CALL cl_err('UPD cal',STATUS,1) LET g_success='N' 
  END IF 
  IF g_success='Y' THEN 
    LET g_cal.calfirm='Y' DISPLAY BY NAME g_cal.calfirm
    COMMIT WORK 
  ELSE 
    ROLLBACK WORK 
  END IF 
END FUNCTION
 
FUNCTION t210_unfirm()
  IF g_cal.cal01 IS NULL OR g_cal.cal02 IS NULL THEN 
     CALL cl_err('','-400',0) RETURN 
  END IF 
  IF g_cal.calfirm='X' THEN RETURN END IF  #CHI-C80041
  IF g_cal.calfirm='N' THEN CALL cl_err('','9025',1) RETURN END IF 
  IF NOT cl_confirm('aim-302') THEN RETURN END IF
  BEGIN WORK
  LET g_success='Y'
  UPDATE cal_file SET calfirm='N' 
    WHERE cal01=g_cal.cal01 
      AND cal02=g_cal.cal02 
  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
    CALL cl_err('UPD cal',STATUS,1) LET g_success='N' 
  END IF 
  IF g_success='Y' THEN 
    LET g_cal.calfirm='N' DISPLAY BY NAME g_cal.calfirm COMMIT WORK 
  ELSE 
    ROLLBACK WORK 
  END IF 
END FUNCTION
#FUN-B80056
#CHI-C80041---begin
#FUNCTION t210_v()                 #CHI-D20010
FUNCTION t210_v(p_type)            #CHI-D20010
   DEFINE l_chr LIKE type_file.chr1
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cal.cal01) OR cl_null(g_cal.cal02) THEN CALL cl_err('',-400,0) RETURN END IF  
  
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_cal.calfirm='X' THEN RETURN END IF
   ELSE
      IF g_cal.calfirm<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t210_cl USING g_cal.cal01,g_cal.cal02
   IF STATUS THEN
      CALL cl_err("OPEN t210_cl:", STATUS, 1)
      CLOSE t210_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t210_cl INTO g_cal.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cal.cal01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t210_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_cal.calfirm = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
  #IF cl_void(0,0,g_cal.calfirm)   THEN                                #CHI-D20010
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
        LET l_chr=g_cal.calfirm
       #IF g_cal.calfirm='N' THEN                                      #CHI-D20010
        IF p_type = 1 THEN                                             #CHI-D20010
            LET g_cal.calfirm='X' 
        ELSE
            LET g_cal.calfirm='N'
        END IF
        UPDATE cal_file
            SET calfirm=g_cal.calfirm,  
                calmodu=g_user,
                caldate=g_today
            WHERE cal01=g_cal.cal01
              AND cal02=g_cal.cal02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","cal_file",g_cal.cal01,"",SQLCA.sqlcode,"","",1)  
            LET g_cal.calfirm=l_chr 
        END IF
        DISPLAY BY NAME g_cal.calfirm
   END IF
 
   CLOSE t210_cl
   COMMIT WORK
   CALL cl_flow_notify(g_cal.cal01,'V')
 
END FUNCTION
#CHI-C80041---end

