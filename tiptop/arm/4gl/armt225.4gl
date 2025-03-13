# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt225.4gl
# Descriptions...: RMA隨機報關INVOICE維護作業
# Date & Author..: 98/05/04 plum
#        Modify..: 04/07/16 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550064 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.CHI-680012 06/12/06 By Claire 加入列印功能
# Modify.........: No.FUN-720014 07/03/02 By rainy 地址擴充為5欄255
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/23 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990113 09/10/12 By lilingyu "覆出單號 RMA單號"查詢時增加開窗功能
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/10 By huangtao  
# Modify.........: No.FUN-BB0085 11/12/23 By xianghui 增加數量欄位小數取位
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rme   RECORD LIKE rme_file.*,
    l_rmt   RECORD
               rmt31     LIKE rmt_file.rmt31,
               rmt33     LIKE rmt_file.rmt33,
               rmt03     LIKE rmt_file.rmt03,
               rmt04     LIKE rmt_file.rmt04,
               rmt06     LIKE rmt_file.rmt06,
               rmt061    LIKE rmt_file.rmt061,
               rmt13     LIKE rmt_file.rmt13,
               rmt32     LIKE rmt_file.rmt32,
               rmt34     LIKE rmt_file.rmt34,
               rmt35     LIKE rmt_file.rmt35,
               rmt12     LIKE rmt_file.rmt12
            END RECORD,
    g_rme_t RECORD LIKE rme_file.*,
    g_rme_o RECORD LIKE rme_file.*,
    g_rmf   RECORD LIKE rmf_file.*,
    g_rmt02    LIKE rmt_file.rmt02,
    g_rme01_t  LIKE rme_file.rme01,
    g_rmt           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rmt02     LIKE rmt_file.rmt02,
                    rmt03     LIKE rmt_file.rmt03,
                    rmt06     LIKE rmt_file.rmt06,
                    rmt061    LIKE rmt_file.rmt061,
                    rmt04     LIKE rmt_file.rmt04,
                    rmt12     LIKE rmt_file.rmt12,
                    rmt13     LIKE rmt_file.rmt13,
                    rmt14     LIKE rmt_file.rmt14,
                    rmt31     LIKE rmt_file.rmt31,
                    rmt33     LIKE rmt_file.rmt33,
                  #FUN-840068 --start---
                    rmtud01   LIKE rmt_file.rmtud01,
                    rmtud02   LIKE rmt_file.rmtud02,
                    rmtud03   LIKE rmt_file.rmtud03,
                    rmtud04   LIKE rmt_file.rmtud04,
                    rmtud05   LIKE rmt_file.rmtud05,
                    rmtud06   LIKE rmt_file.rmtud06,
                    rmtud07   LIKE rmt_file.rmtud07,
                    rmtud08   LIKE rmt_file.rmtud08,
                    rmtud09   LIKE rmt_file.rmtud09,
                    rmtud10   LIKE rmt_file.rmtud10,
                    rmtud11   LIKE rmt_file.rmtud11,
                    rmtud12   LIKE rmt_file.rmtud12,
                    rmtud13   LIKE rmt_file.rmtud13,
                    rmtud14   LIKE rmt_file.rmtud14,
                    rmtud15   LIKE rmt_file.rmtud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmt_t         RECORD
                    rmt02     LIKE rmt_file.rmt02,
                    rmt03     LIKE rmt_file.rmt03,
                    rmt06     LIKE rmt_file.rmt06,
                    rmt061    LIKE rmt_file.rmt061,
                    rmt04     LIKE rmt_file.rmt04,
                    rmt12     LIKE rmt_file.rmt12,
                    rmt13     LIKE rmt_file.rmt13,
                    rmt14     LIKE rmt_file.rmt14,
                    rmt31     LIKE rmt_file.rmt31,
                    rmt33     LIKE rmt_file.rmt33,
                  #FUN-840068 --start---
                    rmtud01   LIKE rmt_file.rmtud01,
                    rmtud02   LIKE rmt_file.rmtud02,
                    rmtud03   LIKE rmt_file.rmtud03,
                    rmtud04   LIKE rmt_file.rmtud04,
                    rmtud05   LIKE rmt_file.rmtud05,
                    rmtud06   LIKE rmt_file.rmtud06,
                    rmtud07   LIKE rmt_file.rmtud07,
                    rmtud08   LIKE rmt_file.rmtud08,
                    rmtud09   LIKE rmt_file.rmtud09,
                    rmtud10   LIKE rmt_file.rmtud10,
                    rmtud11   LIKE rmt_file.rmtud11,
                    rmtud12   LIKE rmt_file.rmtud12,
                    rmtud13   LIKE rmt_file.rmtud13,
                    rmtud14   LIKE rmt_file.rmtud14,
                    rmtud15   LIKE rmt_file.rmtud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmt_o         RECORD
                    rmt02     LIKE rmt_file.rmt02,
                    rmt03     LIKE rmt_file.rmt03,
                    rmt06     LIKE rmt_file.rmt06,
                    rmt061    LIKE rmt_file.rmt061,
                    rmt04     LIKE rmt_file.rmt04,
                    rmt12     LIKE rmt_file.rmt12,
                    rmt13     LIKE rmt_file.rmt13,
                    rmt14     LIKE rmt_file.rmt14,
                    rmt31     LIKE rmt_file.rmt31,
                    rmt33     LIKE rmt_file.rmt33,
                  #FUN-840068 --start---
                    rmtud01   LIKE rmt_file.rmtud01,
                    rmtud02   LIKE rmt_file.rmtud02,
                    rmtud03   LIKE rmt_file.rmtud03,
                    rmtud04   LIKE rmt_file.rmtud04,
                    rmtud05   LIKE rmt_file.rmtud05,
                    rmtud06   LIKE rmt_file.rmtud06,
                    rmtud07   LIKE rmt_file.rmtud07,
                    rmtud08   LIKE rmt_file.rmtud08,
                    rmtud09   LIKE rmt_file.rmtud09,
                    rmtud10   LIKE rmt_file.rmtud10,
                    rmtud11   LIKE rmt_file.rmtud11,
                    rmtud12   LIKE rmt_file.rmtud12,
                    rmtud13   LIKE rmt_file.rmtud13,
                    rmtud14   LIKE rmt_file.rmtud14,
                    rmtud15   LIKE rmt_file.rmtud15
                  #FUN-840068 --end--
                    END RECORD,
    g_wc,g_wc2,g_sql,g_wc3,w_sql   string,  #No.FUN-580092 HCN
    l_wc            LIKE type_file.chr1000,     #CHI-680012 add
    l_cmd           LIKE type_file.chr1000,     #CHI-680012 modify 
#   g_t             VARCHAR(3),
    g_t             LIKE type_file.chr5,    #No.FUN-690010 VARCHAR(05),                     #No.FUN-550064
    p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_auto          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
    g_err           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
    g_cnt1          LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
#   g_t1            VARCHAR(03),
    g_t1            LIKE oay_file.oayslip,                     #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
    g_cmd           LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    g_tmp           LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #目前處理的SCREEN LINE
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #目前處理的SCREEN LINE
    g_count         LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_cn            LIKE type_file.num5     #No.FUN-690010 SMALLINT               #符合單身條件筆數
 
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0085
    DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-690010 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t225_w AT p_row,p_col WITH FORM "arm/42f/armt225"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    LET g_forupd_sql =
        "SELECT * FROM rme_file WHERE rme01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t225_cl CURSOR FROM g_forupd_sql
    WHILE TRUE
      LET g_action_choice = ''
      CALL t225_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
    CLOSE WINDOW t225_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t225_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_rmt.clear()
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rme.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON            #螢幕上取單頭條件
        rme01,rme011,rme03,rme04,rme041,rme08,rme32,rme073,rme074,rme075,rme076,rme077   #FUN-720014 add rme076/077
     #FUN-840068   ---start---
       ,rmeud01,rmeud02,rmeud03,rmeud04,rmeud05,
        rmeud06,rmeud07,rmeud08,rmeud09,rmeud10,
        rmeud11,rmeud12,rmeud13,rmeud14,rmeud15
     #FUN-840068    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
          CASE WHEN INFIELD(rme03)             #查詢客戶資料
#                CALL q_occ(9,2,g_rme.rme03) RETURNING g_rme.rme03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rme03
                 NEXT FIELD rme03
#TQC-990113 --begin--
             WHEN INFIELD(rme01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rme01"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rme01
                 NEXT FIELD rme01
 
             WHEN INFIELD(rme011)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rme011"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rme011
                 NEXT FIELD rme011                              
#TQC-990113 --end--                  
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
 
    CONSTRUCT g_wc2 ON rmt02,rmt03,rmt06,rmt061,rmt04,rmt12,
                       rmt13,rmt14,rmt31,rmt33
                     #No.FUN-840068 --start--
                      ,rmtud01,rmtud02,rmtud03,rmtud04,rmtud05
                      ,rmtud06,rmtud07,rmtud08,rmtud09,rmtud10
                      ,rmtud11,rmtud12,rmtud13,rmtud14,rmtud15
                     #No.FUN-840068 ---end---
 
         FROM s_rmt[1].rmt02, s_rmt[1].rmt03, s_rmt[1].rmt06, s_rmt[1].rmt061,
              s_rmt[1].rmt04, s_rmt[1].rmt12,
              s_rmt[1].rmt13, s_rmt[1].rmt14,s_rmt[1].rmt31,
              s_rmt[1].rmt33
           #No.FUN-840068 --start--
             ,s_rmt[1].rmtud01,s_rmt[1].rmtud02,s_rmt[1].rmtud03
             ,s_rmt[1].rmtud04,s_rmt[1].rmtud05,s_rmt[1].rmtud06
             ,s_rmt[1].rmtud07,s_rmt[1].rmtud08,s_rmt[1].rmtud09
             ,s_rmt[1].rmtud10,s_rmt[1].rmtud11,s_rmt[1].rmtud12
             ,s_rmt[1].rmtud13,s_rmt[1].rmtud14,s_rmt[1].rmtud15
           #No.FUN-840068 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmt03)     #料件編號
#                 CALL q_ima(10,3,g_rmt[1].rmt03) RETURNING g_rmt[1].rmt03
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO rmt03
                  NEXT FIELD rmt03
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
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
       LET g_sql = "SELECT rme01 FROM rme_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY rme01"
     ELSE                                         # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE rme01 ",
                   "  FROM rme_file, rmt_file",
                   " WHERE rme01 = rmt01 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rme01"
    END IF
    PREPARE t225_prepare FROM g_sql
    DECLARE t225_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t225_prepare
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rme_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT rme01) FROM rme_file,rmt_file WHERE ",
                  "rmt01=rme01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t225_precount FROM g_sql
    DECLARE t225_count CURSOR FOR t225_precount
END FUNCTION
 
FUNCTION t225_menu()
 
   WHILE TRUE
      CALL t225_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t225_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t225_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t225_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認"
         WHEN "confirm"
            CALL t225_y()
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            CALL t225_z()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmt),'','')
            END IF
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rme.rme01 IS NOT NULL THEN
                 LET g_doc.column1 = "rme01"
                 LET g_doc.value1 = g_rme.rme01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0018-------add--------end----
 
        #CHI-680012-begin-add
         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_wc = "rme01='",g_rme.rme01 CLIPPED,"'"
              #LET l_cmd = "armr100 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 mark
               LET l_cmd = "armg100 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 add
                           " 'Y' ' ' '1' ",'\" ',l_wc CLIPPED,' \" '
               CALL cl_cmdrun(l_cmd)
            END IF
        #CHI-680012-end-add
      END CASE
   END WHILE
END FUNCTION
 
 
#處理INPUT
FUNCTION t225_i(r_cmd)
  DEFINE r_cmd          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),              #a:輸入 u:更改
#        g_t             VARCHAR(3)
         g_t            LIKE type_file.chr5       #No.FUN-690010 VARCHAR(05)                     #No.FUN-550064
    DISPLAY BY NAME g_rme.rme01,g_rme.rme011, g_rme.rme03,g_rme.rme04,
                    g_rme.rme041,g_rme.rme08, g_rme.rme32, g_rme.rme073,
                    g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077  #FUN-720014 add rme076/077
                  #FUN-840068     ---start---
                   ,g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
                    g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
                    g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
                    g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15
                  #FUN-840068     ----end----
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_rme.rme01,g_rme.rme011, g_rme.rme03,g_rme.rme04,
                  g_rme.rme041,g_rme.rme08, g_rme.rme32, g_rme.rme073,
                  g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077    #FUN-720014 add rme076/077
                #FUN-840068     ---start---
                 ,g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
                  g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
                  g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
                  g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15
                #FUN-840068     ----end----
 
       WITHOUT DEFAULTS
 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t225_set_entry(p_cmd)
            CALL t225_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550064 --start--
         CALL cl_set_docno_format("rme011")
         #No.FUN-550064 ---end---
 
        BEFORE FIELD rme073
           IF cl_null(g_rme.rme073) AND g_rme.rme03 <> 'MISC' THEN
              SELECT occ241,occ242,occ243,occ244,occ245                                 #FUN-720014 add occ244/245
                 INTO g_rme.rme073,g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077  #FUN-720014 add rme076/077
                 FROM occ_file
                 WHERE occ01 = g_rme.rme03
              DISPLAY BY NAME g_rme.rme073,g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077   #FUN-720014 add rme076/rme077
           END IF
 
        AFTER FIELD rme03
            IF g_rme.rme03 != g_rme_o.rme03 OR g_rme_o.rme03 IS NULL THEN
               CALL t225_get_add()
            #SELECT occ02 INTO g_rme.rme04 FROM occ_file WHERE occ01=g_rme.rme03
             IF SQLCA.sqlcode OR STATUS THEN
                CALL cl_err(g_rme.rme03,SQLCA.sqlcode,0)
                LET g_rme.rme03 = g_rme_t.rme03
                LET g_rme.rme04 = g_rme_t.rme04
                LET g_rme.rme041= g_rme_t.rme041
                LET g_rme.rme073= g_rme_t.rme073
                LET g_rme.rme074= g_rme_t.rme074
                LET g_rme.rme075= g_rme_t.rme075
                LET g_rme.rme076= g_rme_t.rme076  #FUN-720014 add
                LET g_rme.rme077= g_rme_t.rme077  #FUN-720014 add
                DISPLAY BY NAME g_rme.rme04,g_rme.rme041,g_rme.rme073,
                                g_rme.rme074,g_rme.rme075,g_rme.rme03
                NEXT FIELD rme03
             END IF
             DISPLAY BY NAME g_rme.rme04,g_rme.rme041,g_rme.rme073,
                             g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077   #FUN-720014 add rme076/077
            END IF
            LET g_rme_o.rme03 = g_rme.rme03
 
      #FUN-840068     ---start---
        AFTER FIELD rmeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      #FUN-840068     ----end----
 
        ON ACTION CONTROLP
          CASE WHEN INFIELD(rme03)             #查詢客戶資料
#                CALL q_occ(9,2,g_rme.rme03) RETURNING g_rme.rme03
#                CALL FGL_DIALOG_SETBUFFER( g_rme.rme03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_rme.rme03
                 CALL cl_create_qry() RETURNING g_rme.rme03
#                 CALL FGL_DIALOG_SETBUFFER( g_rme.rme03 )
                 DISPLAY BY NAME g_rme.rme03
                 NEXT FIELD rme03
            END CASE
 
        ON ACTION CONTROLF                     #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
#找出送貨地址
FUNCTION t225_get_add()
    SELECT occ09,occ11,occ241,occ242,occ243,occ244,occ245                                             #FUN-720014 add occ244/245
      INTO g_rme.rme04,g_rme.rme041,g_rme.rme073,g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077  #FUN-720014 add rme076/077
      FROM occ_file WHERE occ01=g_rme.rme03 AND occacti='Y'
END FUNCTION
 
FUNCTION t225_u()
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rme.rmevoid = 'N' THEN  CALL cl_err('void=N',9027,0) RETURN END IF
   #IF g_rme.rmepost = 'Y' THEN  CALL cl_err('post=Y','aap-730',0) RETURN END IF
    IF g_rme.rmegen = 'N' THEN  CALL cl_err('t160:gen=N','aap-717',0)
        RETURN END IF
    IF g_rme.rme32   = 'Y' THEN  CALL cl_err('rme32=Y',9023,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rme_o.* = g_rme.*
    BEGIN WORK
 
    OPEN t225_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t225_cl:", STATUS, 1)
       CLOSE t225_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t225_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t225_cl ROLLBACK WORK RETURN
    END IF
    CALL t225_show()
    WHILE TRUE
        LET g_rme.rmemodu=g_user
        LET g_rme.rmedate=g_today
        CALL t225_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rme.*=g_rme_t.*
            CALL t225_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE rme_file SET * = g_rme.* WHERE rme01 = g_rme.rme01
        IF STATUS THEN 
  #      CALL cl_err(g_rme.rme01,STATUS,0)#FUN-660111
       CALL cl_err3("upd","rme_file",g_rme_t.rme01,"",STATUS,"","",1) #FUN-660111
         CONTINUE WHILE END IF
       #IF g_rme.rme01 != g_rme_t.rme01 THEN CALL t225_chkkey() END IF
        EXIT WHILE
    END WHILE
    CLOSE t225_cl
    COMMIT WORK
 
 
END FUNCTION
 
FUNCTION t225_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rme.* TO NULL              #No.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    LET p_cmd="u"
    CALL t225_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_rme.* TO NULL RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t225_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL
    ELSE
        OPEN t225_count
        FETCH t225_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t225_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
    LET g_auto="N"
END FUNCTION
 
FUNCTION t225_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t225_cs INTO g_rme.rme01
        WHEN 'P' FETCH PREVIOUS t225_cs INTO g_rme.rme01
        WHEN 'F' FETCH FIRST    t225_cs INTO g_rme.rme01
        WHEN 'L' FETCH LAST     t225_cs INTO g_rme.rme01
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
            FETCH ABSOLUTE g_jump t225_cs INTO g_rme.rme01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF SQLCA.sqlcode THEN
  #      CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)#FUN-660111
        CALL cl_err3("sel","rme_file",g_rme.rme01,"",SQLCA.sqlcode,"","",1) #FUN-660111 
        INITIALIZE g_rme.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rme.rmeuser #FUN-4C0055
        LET g_data_group = g_rme.rmegrup #FUN-4C0055
        LET g_data_plant = g_rme.rmeplant #FUN-980030
    END IF
 
    CALL t225_show()
END FUNCTION
 
FUNCTION t225_show()
 
    LET g_rme_t.* = g_rme.*                #保存單頭舊值
    DISPLAY BY NAME
 
        g_rme.rme01,g_rme.rme011,g_rme.rme08,g_rme.rme03,g_rme.rme04,
        g_rme.rme041,g_rme.rme073,g_rme.rme074,g_rme.rme075,g_rme.rme32,
        g_rme.rme076,g_rme.rme077   #FUN-720014 add
      #FUN-840068     ---start---
       ,g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
        g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
        g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
        g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15
      #FUN-840068     ----end----
 
    #CKP
    CALL cl_set_field_pic(g_rme.rme32  ,"","","","",g_rme.rmevoid)
 
    CALL t225_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t225_g_b()
     DEFINE l_rmt14 LIKE rmt_file.rmt14,
            l_misc  LIKE type_file.chr1    #No.FUN-690010 VARCHAR(01)
 
  #LET l_misc="N"
   LET g_cnt = 1
   LET g_rec_b = 0
   BEGIN WORK
 
 
    OPEN t225_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t225_cl:", STATUS, 1)
       CLOSE t225_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t225_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t225_cl ROLLBACK WORK RETURN
    END IF
 
  #WHILE TRUE
    #IF l_misc="N" THEN                #料件非'MISC'者
        LET g_sql =" select rmf31,rmf33,rmf03,rmf04,rmf06,rmf061, ",
                   "        rmb13,rmf32,rmf34,rmf35,sum(rmf22) ",
                   " from rmf_file,rmb_file,rma_file ",
                   " where rmf07=rmb01 and rmf03=rmb03 ",
                   " and rmf01='",g_rme.rme01,"'",
                   " AND rmf07='",g_rme.rme011,"'",
                  #" AND rmf03 !='MISC' AND rma01=rmb01 ",
                   " AND rma01=rmb01 ",
                   " AND rma09 !='6' AND rmavoid='Y' ",
                   " group by rmf31,rmf33,rmf03,rmf04,rmf06,rmf061,rmb13,rmf32,rmf34,rmf35 ",
                   " order by 1,2,3 "
    {ELSE                              #料件'MISC'者
        LET g_sql =" select rmf31,rmf33,rmf03,rmf04,rmf06,rmf061, ",
                   "        0,rmf32,rmf34,rmf35,rmf22  ",
                   " from rmf_file  ",
                   " where rmf01='",g_rme.rme01,"' AND rmf07='",
                    g_rme.rme011,"'",
                   " AND rmf03 ='MISC' ",
                   " order by 1,2,3 "
     END IF }
 
     PREPARE t225_rmtpb FROM g_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('pre1:',SQLCA.sqlcode,0)
        LET g_success="N" RETURN
     END IF
     DECLARE rmc_curs                       #SCROLL CURSOR
         CURSOR FOR t225_rmtpb
 
     FOREACH rmc_curs INTO l_rmt.*          #單身 ARRAY 填充
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
            LET g_success="N" EXIT FOREACH
         ELSE
            IF l_rmt.rmt12 IS NULL THEN LET l_rmt.rmt12=0 END IF
            IF l_rmt.rmt13 IS NULL THEN LET l_rmt.rmt13=0 END IF
            LET l_rmt14=l_rmt.rmt12*l_rmt.rmt13
             #No.MOD-470041
            INSERT INTO rmt_file(rmt01,rmt02,rmt03,rmt04,rmt06,rmt061,
                                 rmt12,rmt13,rmt14,rmt31,rmt32,rmt33,
                                 rmt34,rmt35,  #No.MOD-470041(end)
                                 rmtplant,rmtlegal)  #FUN-980007
 
            VALUES (g_rme.rme01,g_cnt,l_rmt.rmt03,l_rmt.rmt04,l_rmt.rmt06,
                    l_rmt.rmt061,l_rmt.rmt12,l_rmt.rmt13,
                    l_rmt14,l_rmt.rmt31,l_rmt.rmt32,l_rmt.rmt33,
                    l_rmt.rmt34,l_rmt.rmt35,
                    g_plant,g_legal)                 #FUN-980007
 
            IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
       #        CALL cl_err('ins rmt',STATUS,1)#FUN-660111
               CALL cl_err3("ins","rmt_file",g_rme.rme01,g_cnt,STATUS,"","ins rmt",1) #FUN-660111
               LET g_success="N"
               EXIT FOREACH
            END IF
            LET g_rec_b = g_rec_b + 1
            LET g_cnt = g_cnt + 1
         END IF
     END FOREACH
    #IF l_misc ="Y" THEN EXIT WHILE END IF
    #LET l_misc="Y"
  #END WHILE
    IF g_rec_b =0 THEN
       CALL cl_err('body: ','aap-129',0)
       LET g_success="N"
       RETURN
    ELSE
       IF g_success="Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
          CALL cl_rbmsg(3) sleep 1
       END IF
    END IF
    CALL t225_b_fill(" 1=1")
    MESSAGE ""
END FUNCTION
 
FUNCTION t225_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    g_n             LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_ima01         LIKE ima_file.ima01,   #料件編號
    g_tmp           LIKE rmc_file.rmc01,   #料件編號
    l_ima25         LIKE ima_file.ima25,   #料件編號: 單位
    l_gfe01         LIKE gfe_file.gfe01,   #料件編號: 單位
    g_rmt07,g_rmt311,l_total,l_i  LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF g_rme.rme01 IS NULL THEN
       CALL cl_err('','aap-105',0) RETURN
    END IF
    IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9027,0) RETURN END IF
   #IF g_rme.rmepost = 'Y' THEN CALL cl_err('post=Y','aap-730',0) RETURN END IF
    IF g_rme.rmegen = 'N' THEN  CALL cl_err('t160:gen=N','aap-717',0)
        RETURN END IF
    IF g_rme.rme32   = 'Y' THEN CALL cl_err('rme32=Y',9003,0) RETURN END IF
    LET g_success='Y'
    IF g_rec_b =0 THEN
       #由 RMA單(rmt)依單頭所輸入: rme011(rmf01) 產生單身:rmt
        IF cl_confirm('aap-701') THEN
          CALL t225_g_b()
          IF g_rec_b=0 OR g_success="N" THEN MESSAGE "" RETURN END IF
          LET g_auto="Y"
        END IF
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT rmt02,rmt03,rmt06,rmt061,rmt04,rmt12,rmt13,rmt14,rmt31,rmt33,",
    #No.FUN-840068 --start--
      "       rmtud01,rmtud02,rmtud03,rmtud04,rmtud05,",
      "       rmtud06,rmtud07,rmtud08,rmtud09,rmtud10,",
      "       rmtud11,rmtud12,rmtud13,rmtud14,rmtud15 ",
    #No.FUN-840068 ---end---
      " FROM rmt_file ",
      "  WHERE rmt01= ? ",
      "   AND rmt02= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t225_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_rmt
              WITHOUT DEFAULTS
              FROM s_rmt.*
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
            LET l_total=ARR_COUNT()
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN t225_cl USING g_rme.rme01
            IF STATUS THEN
               CALL cl_err("OPEN t225_cl:", STATUS, 1)
               CLOSE t225_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t225_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t225_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rmt_t.* = g_rmt[l_ac].*  #BACKUP
               LET g_rmt_o.* = g_rmt[l_ac].*  #BACKUP
                OPEN t225_bcl USING g_rme.rme01,g_rmt_t.rmt02
                IF STATUS THEN
                    CALL cl_err("OPEN t225_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t225_bcl INTO g_rmt[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rmt_t.rmt02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD rmt02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO rmt_file(rmt01,rmt02,rmt03,rmt04,rmt06,
                                 rmt061,rmt12,rmt13,rmt14,rmt31,
                               #FUN-840068 --start--
                                 #rmt33)
                                  rmt33,
                                  rmtud01,rmtud02,rmtud03,
                                  rmtud04,rmtud05,rmtud06,
                                  rmtud07,rmtud08,rmtud09,
                                  rmtud10,rmtud11,rmtud12,
                                  rmtud13,rmtud14,rmtud15,
                                  rmtplant,rmtlegal) #FUN-980007
                               #FUN-840068 --end--
            VALUES(g_rme.rme01,g_rmt[l_ac].rmt02,
                   g_rmt[l_ac].rmt03,g_rmt[l_ac].rmt04,
                   g_rmt[l_ac].rmt06,g_rmt[l_ac].rmt061,
                   g_rmt[l_ac].rmt12,g_rmt[l_ac].rmt13,
                   g_rmt[l_ac].rmt14,g_rmt[l_ac].rmt31,
                 #FUN-840068 --start--
                  #g_rmt[l_ac].rmt33)
                   g_rmt[l_ac].rmt33,
                   g_rmt[l_ac].rmtud01,g_rmt[l_ac].rmtud02,
                   g_rmt[l_ac].rmtud03,g_rmt[l_ac].rmtud04,
                   g_rmt[l_ac].rmtud05,g_rmt[l_ac].rmtud06,
                   g_rmt[l_ac].rmtud07,g_rmt[l_ac].rmtud08,
                   g_rmt[l_ac].rmtud09,g_rmt[l_ac].rmtud10,
                   g_rmt[l_ac].rmtud11,g_rmt[l_ac].rmtud12,
                   g_rmt[l_ac].rmtud13,g_rmt[l_ac].rmtud14,
                   g_rmt[l_ac].rmtud15,
                   g_plant,g_legal)                  #FUN-980007
                 #FUN-840068 --end--
 
            IF SQLCA.sqlcode THEN
  #             CALL cl_err(g_rmt[l_ac].rmt02,SQLCA.sqlcode,0)#FUN-660111
               CALL cl_err3("ins","rmt_file",g_rme.rme01,g_rmt[l_ac].rmt02,SQLCA.sqlcode,"","",1) #FUN-660111
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
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rmt[l_ac].* TO NULL      #900423
            LET g_rmt[l_ac].rmt12 = 0        #Body default
            LET g_rmt[l_ac].rmt13 = 0        #Body default
            LET g_rmt[l_ac].rmt14 = 0        #Body default
            LET g_rmt_t.* = g_rmt[l_ac].*         #新輸入資料
            LET g_rmt_o.* = g_rmt[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmt02
 
        BEFORE FIELD rmt02                        #default 序號
            IF g_rmt[l_ac].rmt02 IS NULL OR
               g_rmt[l_ac].rmt02 = 0 THEN
                SELECT max(rmt02)+1
                   INTO g_rmt[l_ac].rmt02
                   FROM rmt_file
                   WHERE rmt01 = g_rme.rme01
                IF g_rmt[l_ac].rmt02 IS NULL THEN
                    LET g_rmt[l_ac].rmt02 = 1
                END IF
           END IF
 
        AFTER FIELD rmt02                        #check 序號是否重複
          IF NOT cl_null(g_rmt[l_ac].rmt02) THEN
              IF g_rmt[l_ac].rmt02 != g_rmt_o.rmt02 OR
                 g_rmt_o.rmt02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM rmt_file
                      WHERE rmt01 = g_rme.rme01 AND
                            rmt02 = g_rmt[l_ac].rmt02
                  IF l_n > 0 THEN
                      LET g_rmt[l_ac].rmt02 = g_rmt_t.rmt02
                      CALL cl_err('',-239,0) NEXT FIELD rmt02
                  END IF
              END IF
             #IF g_auto="Y" THEN NEXT FIELD rmt12 END IF
              LET g_rmt_o.rmt02=g_rmt[l_ac].rmt02
          END IF
 
       AFTER FIELD rmt03
             IF NOT cl_null(g_rmt[l_ac].rmt03) THEN
#FUN-AB0025 ----------------------------mark-----------------------------
#FUN-AA0059 ---------------------start----------------------------
#               IF NOT s_chk_item_no(g_rmt[l_ac].rmt03,"") THEN
#                  CALL cl_err('',g_errno,1)
#                  LET g_rmt[l_ac].rmt03= g_rmt_t.rmt03
#                  NEXT FIELD rmt03
#               END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0025 -----------------------------mark---------------------------
                LET g_err="N"
                LET g_n  =0
                SELECT count(*) INTO g_n FROM rmt_file
                 WHERE rmt01 = g_rme.rme01 AND rmt02 <> g_rmt[l_ac].rmt02
                   AND rmt31 = g_rmt[l_ac].rmt31
                   AND rmt33 = g_rmt[l_ac].rmt33
                   AND rmt03 = g_rmt[l_ac].rmt03
                IF g_n >= 1 THEN
                   LET g_rmt[l_ac].rmt31 = g_rmt_t.rmt31
                   LET g_rmt[l_ac].rmt33 = g_rmt_t.rmt33
                   LET g_rmt[l_ac].rmt03 = g_rmt_t.rmt03
                   DISPLAY g_rmt[l_ac].* TO s_rmt[l_sl].*
                   CALL cl_err('',-239,0) NEXT FIELD rmt31
                END IF
                CALL t225_get_rmbf()
                IF g_err="Y" THEN
                   CALL cl_err('INVOICE hadnot the part no!',100,0)
                   DISPLAY g_rmt[l_ac].* TO s_rmt[l_sl].*
                   NEXT FIELD rmt31
                END IF
                LET g_rmt_o.rmt03 = g_rmt[l_ac].rmt03
            END IF
 
       AFTER FIELD rmt12
          #FUN-BB0085-add-str--
          IF NOT cl_null(g_rmt[l_ac].rmt12) AND NOT cl_null(g_rmt[l_ac].rmt04) THEN 
             LET g_rmt[l_ac].rmt12 = s_digqty(g_rmt[l_ac].rmt12,g_rmt[l_ac].rmt04)
             DISPLAY BY NAME g_rmt[l_ac].rmt12
          END IF
          #FUN-BB0085-add-end--
          IF NOT cl_null(g_rmt[l_ac].rmt12) THEN
              IF g_rmt[l_ac].rmt12 < 0 THEN
                  NEXT FIELD rmt12
              END IF
              LET g_rmt[l_ac].rmt14=g_rmt[l_ac].rmt12*g_rmt[l_ac].rmt13
          END IF
          #------MOD-5A0095 START----------
          DISPLAY BY NAME g_rmt[l_ac].rmt14
          #------MOD-5A0095 END------------
 
       AFTER FIELD rmt13
          IF g_rmt[l_ac].rmt02 IS NOT NULL THEN
              IF NOT cl_null(g_rmt[l_ac].rmt13) THEN
                  IF g_rmt[l_ac].rmt13 < 0 THEN
                      NEXT FIELD rmt13
                  END IF
                  LET g_rmt[l_ac].rmt14=g_rmt[l_ac].rmt12*g_rmt[l_ac].rmt13
              END IF
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_rmt[l_ac].rmt14
              #------MOD-5A0095 END------------
          END IF
 
       AFTER FIELD rmt14
          IF g_rmt[l_ac].rmt02 IS NOT NULL THEN
              IF NOT cl_null(g_rmt[l_ac].rmt14) THEN
                  IF g_rmt[l_ac].rmt14 < 0 THEN
                      NEXT FIELD rmt14
                  END IF
              END IF
          END IF
 
 
       AFTER FIELD rmt31
          IF NOT cl_null(g_rmt[l_ac].rmt31) THEN
             SELECT UNIQUE(COUNT(*)) INTO l_n FROM rmf_file
                    WHERE rmf01=g_rme.rme01 AND  rmf31=g_rmt[l_ac].rmt31
             IF l_n =0  THEN
                 CALL cl_err('no plt!',100,0)
                 NEXT FIELD rmt31
             END IF
             LET g_rmt_o.rmt31 = g_rmt[l_ac].rmt31
         END IF
 
       AFTER FIELD rmt33
          IF NOT cl_null(g_rmt[l_ac].rmt33) THEN
             SELECT UNIQUE(COUNT(*)) INTO l_n FROM rmf_file
                    WHERE rmf01=g_rme.rme01 AND  rmf33=g_rmt[l_ac].rmt33
             IF l_n =0  THEN
                 CALL cl_err('no plt!',100,0)
                 NEXT FIELD rmt33
             END IF
             LET g_rmt_o.rmt33 = g_rmt[l_ac].rmt33
          END IF
 
      #No.FUN-840068 --start--
        AFTER FIELD rmtud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmtud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmt_t.rmt02 > 0 AND
               g_rmt_t.rmt02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmt_file
                    WHERE rmt01 = g_rme.rme01 AND
                          rmt02 = g_rmt_t.rmt02
                IF SQLCA.sqlcode THEN
    #                CALL cl_err(g_rmt_t.rmt02,SQLCA.sqlcode,0)#FUN-660111
                    CALL cl_err3("del","rmt_file",g_rme.rme01,g_rme.rme02,STATUS,"","",1) #FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmt[l_ac].* = g_rmt_t.*
               CLOSE t225_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rmt[l_ac].rmt02,-263,1)
               LET g_rmt[l_ac].* = g_rmt_t.*
            ELSE
                UPDATE rmt_file SET
                       rmt02=g_rmt[l_ac].rmt02,
                       rmt03=g_rmt[l_ac].rmt03,
                       rmt04=g_rmt[l_ac].rmt04,
                       rmt06=g_rmt[l_ac].rmt06,
                       rmt061=g_rmt[l_ac].rmt061,
                       rmt12=g_rmt[l_ac].rmt12,
                       rmt13=g_rmt[l_ac].rmt13,
                       rmt14=g_rmt[l_ac].rmt14,
                       rmt31=g_rmt[l_ac].rmt31,
                       rmt33=g_rmt[l_ac].rmt33,
                     #FUN-840068 --start--
                       rmtud01 = g_rmt[l_ac].rmtud01,
                       rmtud02 = g_rmt[l_ac].rmtud02,
                       rmtud03 = g_rmt[l_ac].rmtud03,
                       rmtud04 = g_rmt[l_ac].rmtud04,
                       rmtud05 = g_rmt[l_ac].rmtud05,
                       rmtud06 = g_rmt[l_ac].rmtud06,
                       rmtud07 = g_rmt[l_ac].rmtud07,
                       rmtud08 = g_rmt[l_ac].rmtud08,
                       rmtud09 = g_rmt[l_ac].rmtud09,
                       rmtud10 = g_rmt[l_ac].rmtud10,
                       rmtud11 = g_rmt[l_ac].rmtud11,
                       rmtud12 = g_rmt[l_ac].rmtud12,
                       rmtud13 = g_rmt[l_ac].rmtud13,
                       rmtud14 = g_rmt[l_ac].rmtud14,
                       rmtud15 = g_rmt[l_ac].rmtud15
                     #FUN-840068 --end-- 
 
                 WHERE rmt01=g_rme.rme01 AND
                       rmt02=g_rmt_t.rmt02
                IF SQLCA.sqlcode THEN
   #                 CALL cl_err(g_rmt[l_ac].rmt02,SQLCA.sqlcode,0)#FUN-660111
                    CALL cl_err3("upd","rmt_file",g_rme.rme01,g_rmt_t.rmt02,SQLCA.sqlcode,"","",1) #FUN-660111
                    LET g_rmt[l_ac].* = g_rmt_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmt[l_ac].* = g_rmt_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmt.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t225_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D40030 add
           #CKP
           #LET g_rmt_t.* = g_rmt[l_ac].*          # 900423
            CLOSE t225_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t225_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmt03)     #料件編號
#                 CALL q_ima(10,3,g_rmt[l_ac].rmt03) RETURNING g_rmt[l_ac].rmt03
#                 CALL FGL_DIALOG_SETBUFFER( g_rmt[l_ac].rmt03 )
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_rmt[l_ac].rmt03
#                  CALL cl_create_qry() RETURNING g_rmt[l_ac].rmt03
                   CALL q_sel_ima(FALSE, "q_ima","",g_rmt[l_ac].rmt03,"","","","","",'' ) 
                     RETURNING  g_rmt[l_ac].rmt03

#FUN-AA0059---------mod------------end-----------------
#                  CALL FGL_DIALOG_SETBUFFER( g_rmt[l_ac].rmt03 )

                   DISPLAY BY NAME g_rmt[l_ac].rmt03           #No.MOD-490371
                  NEXT FIELD rmt03
               OTHERWISE EXIT CASE
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
 
        END INPUT
 
    CLOSE t225_bcl
    COMMIT WORK
 
#   LET g_t1 = g_rme.rme01[1,3]
    LET g_t1=s_get_doc_no(g_rme.rme01)     #No.FUN-550064
    SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
    IF g_oay.oayconf = 'Y' THEN CALL t225_y() END IF
 
END FUNCTION
 
FUNCTION t225_get_rmbf()
    DEFINE l_rmf22   LIKE rmf_file.rmf22,
           l_rmb13   LIKE rmb_file.rmb13
 
      SELECT rmb04,rmb05,rmb06,rmb13
        INTO g_rmt[l_ac].rmt04,g_rmt[l_ac].rmt06,g_rmt[l_ac].rmt061,l_rmb13
        FROM rmb_file
       WHERE rmb01=g_rme.rme011 AND rmb03=g_rmt[l_ac].rmt03
            #rmb11 >0
        IF SQLCA.sqlcode THEN
           LET g_err="Y"
           LET g_rmt[l_ac].* = g_rmt_t.*
           LET g_rmt[l_ac].rmt02 = g_rmt_o.rmt02
           RETURN
        END IF
        SELECT sum(rmf22) INTO l_rmf22 FROM rmf_file
         WHERE rmf01 = g_rme.rme01
           AND rmf31 = g_rmt[l_ac].rmt31
           AND rmf33 = g_rmt[l_ac].rmt33
           AND rmf03 = g_rmt[l_ac].rmt03
        IF SQLCA.sqlcode THEN
           LET g_err="Y"
           RETURN
        END IF
        LET g_rmt[l_ac].rmt12 = s_digqty(g_rmt[l_ac].rmt12,g_rmt[l_ac].rmt04)  #FUN-BB0085
        DISPLAY BY NAME g_rmt[l_ac].rmt12                                      #FUN-BB0085

        IF g_rmt[l_ac].rmt13=0 THEN LET g_rmt[l_ac].rmt13=l_rmb13 END IF
        IF g_rmt[l_ac].rmt12=0 THEN LET g_rmt[l_ac].rmt12=l_rmf22 END IF
       #IF g_rmt[l_ac].rmt12=0 THEN LET g_rmt[l_ac].rmt12=l_rmb12 END IF
        LET g_rmt[l_ac].rmt14=g_rmt[l_ac].rmt12*g_rmt[l_ac].rmt13
        DISPLAY g_rmt[l_ac].rmt12,g_rmt[l_ac].rmt13,g_rmt[l_ac].rmt14
             TO s_rmt[l_sl].rmt12,s_rmt[l_sl].rmt13,s_rmt[l_sl].rmt14
END FUNCTION
 
FUNCTION t225_b_askkey()
DEFINE           l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON rmt02,rmt03,rmt06,rmt061,rmt04,rmt12,
                       rmt13,rmt14,rmt31,rmt33
            FROM s_rmt[1].rmt02, s_rmt[1].rmt03, s_rmt[1].rmt06, s_rmt[1].rmt061,
                 s_rmt[1].rmt04, s_rmt[1].rmt12, s_rmt[1].rmt13,s_rmt[1].rmt14,s_rmt[1].rmt31, s_rmt[1].rmt33
       ON IDLE g_idle_seconds
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    CALL t225_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t225_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
       LET g_sql ="SELECT rmt02,rmt03,rmt06,rmt061,rmt04,rmt12,rmt13,rmt14,rmt31,rmt33 ",
                #No.FUN-840068 --start--
                  "      ,rmtud01,rmtud02,rmtud03,rmtud04,rmtud05,",
                  "       rmtud06,rmtud07,rmtud08,rmtud09,rmtud10,",
                  "       rmtud11,rmtud12,rmtud13,rmtud14,rmtud15 ",
                #No.FUN-840068 ---end---
                  " FROM rme_file,rmt_file ",
                  " WHERE rme01=rmt01 ",
                  " AND rmt01= '",g_rme.rme01,"'"," AND ",p_wc2 CLIPPED,
                  " ORDER BY rmt02 "
    PREPARE t225_pb FROM g_sql
    DECLARE rmt_curs                       #SCROLL CURSOR
        CURSOR FOR t225_pb
 
    CALL g_rmt.clear()
    LET g_cnt = 1
    FOREACH rmt_curs INTO g_rmt[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_rmt.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t225_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmt TO s_rmt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
     #CHI-680012-begin-add
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
     #CHI-680012-end-add
      ON ACTION first
         CALL t225_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t225_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t225_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t225_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t225_fetch('L')
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #CKP
         CALL cl_set_field_pic(g_rme.rme32  ,"","","","",g_rme.rmevoid)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
 
FUNCTION t225_y()         # when g_rme.rme32  ='N' (Turn to 'Y')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 --------------- add --------------- begin
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rme32   = 'Y' THEN CALL cl_err('rme32=Y',9023,0) RETURN END IF
   IF g_rme.rmepost = 'N' THEN CALL cl_err('t160:post=N','arm-027',0)
      RETURN END IF
   IF g_rme.rmegen = 'N' THEN  CALL cl_err('t160:gen=N','aap-717',0)
       RETURN END IF
   IF g_rmt[1].rmt02 IS NULL THEN
      CALL cl_err(g_rme.rme01,'arm-034',1) RETURN END IF
   IF NOT cl_upsw(0,0,'N') THEN RETURN END IF
#CHI-C30107 --------------- add --------------- end
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rme32   = 'Y' THEN CALL cl_err('rme32=Y',9023,0) RETURN END IF
   IF g_rme.rmepost = 'N' THEN CALL cl_err('t160:post=N','arm-027',0)
      RETURN END IF
   IF g_rme.rmegen = 'N' THEN  CALL cl_err('t160:gen=N','aap-717',0)
       RETURN END IF
   IF g_rmt[1].rmt02 IS NULL THEN
      CALL cl_err(g_rme.rme01,'arm-034',1) RETURN END IF
#  IF NOT cl_upsw(0,0,'N') THEN RETURN END IF  #CHI-C30107 mark
   LET g_rme_t.* = g_rme.*
   BEGIN WORK
 
 
    OPEN t225_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t225_cl:", STATUS, 1)
       CLOSE t225_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t225_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t225_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t225_up_rmb('Y')      #UPDATE rmb
   IF g_success = 'N' THEN
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
      RETURN
   END IF
   UPDATE rme_file SET rme32 = 'Y',rmemodu=g_user,rmedate=g_today
          WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
  #    CALL cl_err('upd rmegen ',STATUS,1)#FUN-660111
       CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rmegen",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      LET g_rme.rme32  ="Y"
      LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
      COMMIT WORK
      DISPLAY BY NAME g_rme.rme32
      CALL cl_cmmsg(3) sleep 1
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rme.rme32
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rme.rme32  ,"","","","",g_rme.rmevoid)
END FUNCTION
 
FUNCTION t225_z()    # when g_rme.rme32 ='Y' (Turn to 'N')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
  #IF g_rme.rmepost = 'Y' THEN CALL cl_err('post=Y:','aap-730',0)
  #   RETURN END IF
   IF g_rme.rme32   = 'N' THEN CALL cl_err('rme32=N',9025,0) RETURN END IF
   IF g_rme.rmegen = 'N' THEN  CALL cl_err('t160:gen=N','aap-717',0)
       RETURN END IF
   IF NOT cl_upsw(0,0,'Y') THEN RETURN END IF
   LET g_rme_t.* = g_rme.*
   BEGIN WORK
 
 
    OPEN t225_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t225_cl:", STATUS, 1)
       CLOSE t225_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t225_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t225_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t225_up_rmb('Z')
   IF g_success="N" THEN
      ROLLBACK WORK
      DISPLAY BY NAME g_rme.rme32
      RETURN
   END IF
   UPDATE rme_file SET rme32   = 'N',rmemodu=g_user,
                       rmedate=g_today
          WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
 #     CALL cl_err('upd rme32',STATUS,1)#FUN-660111
      CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rme32",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN LET g_rme.rme32  ='N'
           LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
           COMMIT WORK
           CALL cl_cmmsg(3) sleep 1
      ELSE
           ROLLBACK WORK
           CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rme.rme32
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rme.rme32  ,"","","","",g_rme.rmevoid)
END FUNCTION
 
FUNCTION t225_up_rmb(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_i   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   IF g_rec_b > 0 THEN
      FOR l_i = 1 TO g_rec_b
        IF g_rmt[l_i].rmt02 IS NULL OR g_rmt[l_i].rmt03 IS NULL THEN
           EXIT FOR END IF
        IF g_rmt[l_i].rmt03='MISC' THEN CONTINUE FOR END IF
        IF p_cmd="Y" THEN             #當執行 Y.確認
             UPDATE rmb_file SET rmb121=rmb121+g_rmt[l_i].rmt12
                WHERE rmb01=g_rme.rme011 AND rmb03=g_rmt[l_i].rmt03
        ELSE                          #當執行 Z.取消確認時
             UPDATE rmb_file SET rmb121=rmb121-g_rmt[l_i].rmt12
                WHERE rmb01=g_rme.rme011 AND rmb03=g_rmt[l_i].rmt03
        END IF
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
   #        CALL cl_err('up rmb:',SQLCA.sqlcode,1)#FUN-660111
           CALL cl_err3("upd","rmb_file",g_rme.rme011,g_rmt[l_i].rmt03,SQLCA.sqlcode,"","up rmd:",1) #FUN-660111
           LET g_success="N"
           EXIT FOR
        END IF
      END FOR
   END IF
END FUNCTION
 
#genero
#單頭
FUNCTION t225_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rme01",TRUE)
   END IF
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rmt31",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t225_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rme01",FALSE)
   END IF
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' THEN
           CALL cl_set_comp_entry("rmt31",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002> #
