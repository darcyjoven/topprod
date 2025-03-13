# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt220.4gl
# Descriptions...: RMA覆出報關INVOICE維護作業
# Date & Author..: 98/0r/04 plum
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
# Modify.........: No.CHI-680010 06/12/06 By Claire 加入列印功能串 armr110
# Modify.........: No.FUN-720014 07/03/02 By rainy 地址擴充為5欄255
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/23 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-840663 08/04/28 By Claire rms00 schema不存在,不可使用
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990114 09/10/12 By lilingyu "覆出單號 RMA單號"查詢時增加開窗功能
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/10 By huangtao modify 料號控管
# Modify.........: No.FUN-BB0085 11/12/22 By xianghui 增加數量欄位小數取位
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rme   RECORD LIKE rme_file.*,
    l_rms   RECORD
               rms31     LIKE rms_file.rms31,
               rms33     LIKE rms_file.rms33,
               rms03     LIKE rms_file.rms03,
               rms04     LIKE rms_file.rms04,
               rms06     LIKE rms_file.rms06,
               rms061    LIKE rms_file.rms061,
               rms13     LIKE rms_file.rms13,
               rms12     LIKE rms_file.rms12
            END RECORD,
    g_rme_t RECORD LIKE rme_file.*,
    g_rme_o RECORD LIKE rme_file.*,
    g_rmf   RECORD LIKE rmf_file.*,
    g_rms02    LIKE rms_file.rms02,
    g_rme01_t  LIKE rme_file.rme01,
    g_rms           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rms02     LIKE rms_file.rms02,
                    rms03     LIKE rms_file.rms03,
                    rms06     LIKE rms_file.rms06,
                    rms061    LIKE rms_file.rms061,
                    rms04     LIKE rms_file.rms04,
                    rms12     LIKE rms_file.rms12,
                    rms13     LIKE rms_file.rms13,
                    rms14     LIKE rms_file.rms14,
                    rms31     LIKE rms_file.rms31,
                    rms33     LIKE rms_file.rms33,
                    rms36     LIKE rms_file.rms36
                #FUN-840068 --start---
                   ,rmsud01   LIKE rms_file.rmsud01,
                    rmsud02   LIKE rms_file.rmsud02,
                    rmsud03   LIKE rms_file.rmsud03,
                    rmsud04   LIKE rms_file.rmsud04,
                    rmsud05   LIKE rms_file.rmsud05,
                    rmsud06   LIKE rms_file.rmsud06,
                    rmsud07   LIKE rms_file.rmsud07,
                    rmsud08   LIKE rms_file.rmsud08,
                    rmsud09   LIKE rms_file.rmsud09,
                    rmsud10   LIKE rms_file.rmsud10,
                    rmsud11   LIKE rms_file.rmsud11,
                    rmsud12   LIKE rms_file.rmsud12,
                    rmsud13   LIKE rms_file.rmsud13,
                    rmsud14   LIKE rms_file.rmsud14,
                    rmsud15   LIKE rms_file.rmsud15
                 #FUN-840068 --end--
                    END RECORD,
    g_rms_t         RECORD
                    rms02     LIKE rms_file.rms02,
                    rms03     LIKE rms_file.rms03,
                    rms06     LIKE rms_file.rms06,
                    rms061    LIKE rms_file.rms061,
                    rms04     LIKE rms_file.rms04,
                    rms12     LIKE rms_file.rms12,
                    rms13     LIKE rms_file.rms13,
                    rms14     LIKE rms_file.rms14,
                    rms31     LIKE rms_file.rms31,
                    rms33     LIKE rms_file.rms33,
                    rms36     LIKE rms_file.rms36
                #FUN-840068 --start---
                   ,rmsud01   LIKE rms_file.rmsud01,
                    rmsud02   LIKE rms_file.rmsud02,
                    rmsud03   LIKE rms_file.rmsud03,
                    rmsud04   LIKE rms_file.rmsud04,
                    rmsud05   LIKE rms_file.rmsud05,
                    rmsud06   LIKE rms_file.rmsud06,
                    rmsud07   LIKE rms_file.rmsud07,
                    rmsud08   LIKE rms_file.rmsud08,
                    rmsud09   LIKE rms_file.rmsud09,
                    rmsud10   LIKE rms_file.rmsud10,
                    rmsud11   LIKE rms_file.rmsud11,
                    rmsud12   LIKE rms_file.rmsud12,
                    rmsud13   LIKE rms_file.rmsud13,
                    rmsud14   LIKE rms_file.rmsud14,
                    rmsud15   LIKE rms_file.rmsud15
                 #FUN-840068 --end--
                    END RECORD,
    g_rms_o         RECORD
                    rms02     LIKE rms_file.rms02,
                    rms03     LIKE rms_file.rms03,
                    rms06     LIKE rms_file.rms06,
                    rms061    LIKE rms_file.rms061,
                    rms04     LIKE rms_file.rms04,
                    rms12     LIKE rms_file.rms12,
                    rms13     LIKE rms_file.rms13,
                    rms14     LIKE rms_file.rms14,
                    rms31     LIKE rms_file.rms31,
                    rms33     LIKE rms_file.rms33,
                    rms36     LIKE rms_file.rms36
                #FUN-840068 --start---
                   ,rmsud01   LIKE rms_file.rmsud01,
                    rmsud02   LIKE rms_file.rmsud02,
                    rmsud03   LIKE rms_file.rmsud03,
                    rmsud04   LIKE rms_file.rmsud04,
                    rmsud05   LIKE rms_file.rmsud05,
                    rmsud06   LIKE rms_file.rmsud06,
                    rmsud07   LIKE rms_file.rmsud07,
                    rmsud08   LIKE rms_file.rmsud08,
                    rmsud09   LIKE rms_file.rmsud09,
                    rmsud10   LIKE rms_file.rmsud10,
                    rmsud11   LIKE rms_file.rmsud11,
                    rmsud12   LIKE rms_file.rmsud12,
                    rmsud13   LIKE rms_file.rmsud13,
                    rmsud14   LIKE rms_file.rmsud14,
                    rmsud15   LIKE rms_file.rmsud15
                 #FUN-840068 --end--
                    END RECORD,
    g_wc,g_wc2,g_sql,g_wc3,w_sql   string,  #No.FUN-580092 HCN
    l_cmd           LIKE type_file.chr1000,     #CHI-680010 modify 
    l_wc            LIKE type_file.chr1000,     #CHI-680010 add
#   g_t             VARCHAR(3),
    g_t             LIKE aba_file.aba00,    #No.FUN-690010 VARCHAR(05),                     #No.FUN-550064
    p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_err           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
    g_cnt1          LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
#   g_t1            VARCHAR(03),
    g_t1            LIKE oay_file.oayslip,                     #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
    g_cmd           LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    g_tmp           LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #目前處理的SCREEN LINE
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    g_count         LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_cn            LIKE type_file.num5     #No.FUN-690010 SMALLINT               #符合單身條件筆數
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690010 SMALLINT
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
 
    OPEN WINDOW t220_w AT p_row,p_col WITH FORM "arm/42f/armt220"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_forupd_sql =
        "SELECT * FROM rme_file WHERE rme01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t220_cl CURSOR FROM g_forupd_sql
    WHILE TRUE
      LET g_action_choice = ''
      CALL t220_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
    CLOSE WINDOW t220_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t220_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_rms.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rme.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        rme01,rme011,rme03,rme04,rme041,rme08,rme31,rme073,rme074,rme075,rme076,rme077    #FUN-720014 add rme076/077
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
#TQC-990114 --begin--
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
#TQC-990114 --end--                         
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
 
    CONSTRUCT g_wc2 ON rms02,rms03,rms06,rms061,rms04,rms12,
                       rms13,rms14,rms31,rms33,rms36
                   #No.FUN-840068 --start--
                      ,rmsud01,rmsud02,rmsud03,rmsud04,rmsud05
                      ,rmsud06,rmsud07,rmsud08,rmsud09,rmsud10
                      ,rmsud11,rmsud12,rmsud13,rmsud14,rmsud15
                   #No.FUN-840068 ---end---
         FROM s_rms[1].rms02, s_rms[1].rms03,s_rms[1].rms06, s_rms[1].rms061,
              s_rms[1].rms04, s_rms[1].rms12, s_rms[1].rms13, s_rms[1].rms14,s_rms[1].rms31,
              s_rms[1].rms33,s_rms[1].rms36
           #No.FUN-840068 --start--
             ,s_rms[1].rmsud01,s_rms[1].rmsud02,s_rms[1].rmsud03
             ,s_rms[1].rmsud04,s_rms[1].rmsud05,s_rms[1].rmsud06
             ,s_rms[1].rmsud07,s_rms[1].rmsud08,s_rms[1].rmsud09
             ,s_rms[1].rmsud10,s_rms[1].rmsud11,s_rms[1].rmsud12
             ,s_rms[1].rmsud13,s_rms[1].rmsud14,s_rms[1].rmsud15
           #No.FUN-840068 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rms03)     #料件編號
#                 CALL q_ima(10,3,g_rms[1].rms03) RETURNING g_rms[1].rms03
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO rms03
                  NEXT FIELD rms03
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
                   " WHERE  ", g_wc CLIPPED,
                   " ORDER BY rme01"
     ELSE                                         # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE rme01 ",
                   "  FROM rme_file, rms_file",
                  #" WHERE rme01 = rms01 AND rms00='1' ",   #MOD-840663 mark
                   " WHERE rme01 = rms01 ",                 #MOD-840663
                   " AND ", g_wc CLIPPED,
                   " AND ",g_wc2 CLIPPED,
                   " ORDER BY rme01"
    END IF
    PREPARE t220_prepare FROM g_sql
    DECLARE t220_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t220_prepare
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rme_file WHERE ",
                   g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT rme01) FROM rme_file,rms_file WHERE ",
                  "rms01=rme01 AND  ",
                  g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t220_precount FROM g_sql
    DECLARE t220_count CURSOR FOR t220_precount
END FUNCTION
 
FUNCTION t220_menu()
 
   WHILE TRUE
      CALL t220_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t220_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t220_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t220_b()
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
            CALL t220_y()
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            CALL t220_z()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rms),'','')
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
        #CHI-680010-begin-add
         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_wc = "rme01='",g_rme.rme01 CLIPPED,"'"
              #LET l_cmd = "armr110 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 mark
               LET l_cmd = "armg110 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 add
                           " 'Y' ' ' '1' ",'\" ',l_wc CLIPPED,' \" '
               CALL cl_cmdrun(l_cmd)
            END IF
        #CHI-680010-end-add
      END CASE
   END WHILE
END FUNCTION
 
 
#處理INPUT
FUNCTION t220_i(r_cmd)
  DEFINE r_cmd          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),              #a:輸入 u:更改
#        g_t             VARCHAR(3)
         g_t            LIKE type_file.chr5       #No.FUN-690010 VARCHAR(05)                     #No.FUN-550064
    DISPLAY BY NAME g_rme.rme01,g_rme.rme011, g_rme.rme03,g_rme.rme04,
                    g_rme.rme041,g_rme.rme08, g_rme.rme31,g_rme.rme073,
                    g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077  #FUN-720014 add rme076/077
 
                  #FUN-840068     ---start---
                   ,g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
                    g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
                    g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
                    g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15
                  #FUN-840068     ----end----
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
    INPUT BY NAME   g_rme.rme01,g_rme.rme011, g_rme.rme03,g_rme.rme04,
                    g_rme.rme041,g_rme.rme08, g_rme.rme31,g_rme.rme073,
                    g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077  #FUN-720014 add rme076/077
 
                  #FUN-840068     ---start---
                   ,g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
                    g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
                    g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
                    g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15
                  #FUN-840068     ----end----
 
       WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t220_set_entry(r_cmd)
           CALL t220_set_no_entry(r_cmd)
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
              DISPLAY BY NAME g_rme.rme073,g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077  #FUN-720014 add rme076/077
           END IF
 
        AFTER FIELD rme03
            IF g_rme.rme03 != g_rme_o.rme03 OR g_rme_o.rme03 IS NULL THEN
               CALL t220_get_add()
            #SELECT occ02 INTO g_rme.rme04 FROM occ_file WHERE occ01=g_rme.rme03
             IF SQLCA.sqlcode OR STATUS THEN
                CALL cl_err(g_rme.rme03,SQLCA.sqlcode,0)
                LET g_rme.rme03 = g_rme_t.rme03
                LET g_rme.rme04 = g_rme_t.rme04
                LET g_rme.rme041= g_rme_t.rme041
                LET g_rme.rme073= g_rme_t.rme073
                LET g_rme.rme074= g_rme_t.rme074
                LET g_rme.rme075= g_rme_t.rme075
                LET g_rme.rme076= g_rme_t.rme076
                LET g_rme.rme077= g_rme_t.rme077
                DISPLAY BY NAME g_rme.rme04,g_rme.rme041,g_rme.rme073,g_rme.rme03
                NEXT FIELD rme03
             END IF
             DISPLAY BY NAME g_rme.rme04,g_rme.rme041,g_rme.rme073
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
#                      CALL FGL_DIALOG_SETBUFFER( g_rme.rme03 )
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
 
FUNCTION t220_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rme01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t220_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rme01",FALSE)
    END IF
 
END FUNCTION
 
#找出送貨地址
FUNCTION t220_get_add()
    SELECT occ09,occ11,occ241,occ242,occ243,occ244,occ245                                             #FUN-720014 add occ244/245
      INTO g_rme.rme04,g_rme.rme041,g_rme.rme073,g_rme.rme074,g_rme.rme075,g_rme.rme076,g_rme.rme077  #FUN-720014 add rme076/077
      FROM occ_file WHERE occ01=g_rme.rme03 AND occacti='Y'
END FUNCTION
 
FUNCTION t220_u()
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rme.rmevoid = 'N' THEN  CALL cl_err('void=N',9028,0) RETURN END IF
   #IF g_rme.rmepost = 'Y' THEN  CALL cl_err('post=Y','aap-730',0) RETURN END IF
    IF g_rme.rmegen = 'N'  THEN  CALL cl_err('t160:gen=N','aap-717',0)
       RETURN END IF
    IF g_rme.rme31 = 'Y'   THEN  CALL cl_err('rme31=Y',9023,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET p_cmd="u"
    LET g_rme_o.* = g_rme.*
    BEGIN WORK
    OPEN t220_cl USING g_rme.rme01
    FETCH t220_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t220_cl ROLLBACK WORK RETURN
    END IF
    CALL t220_show()
    WHILE TRUE
        LET g_rme.rmemodu=g_user
        LET g_rme.rmedate=g_today
        CALL t220_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rme.*=g_rme_t.*
            CALL t220_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE rme_file SET * = g_rme.* WHERE rme01 = g_rme.rme01
        IF STATUS THEN 
 #       CALL cl_err(g_rme.rme01,STATUS,0)#FUN-660111
        CALL cl_err3("upd","rme_file",g_rme_t.rme01,"",STATUS,"","",1) #FUN-660111
        CONTINUE WHILE END IF
        EXIT WHILE
    END WHILE
    CLOSE t220_cl
    COMMIT WORK
 
 
END FUNCTION
 
FUNCTION t220_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rme.* TO NULL              #No.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    LET p_cmd="u"
    CALL t220_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0 
       INITIALIZE g_rme.* TO NULL RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t220_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL
    ELSE
        OPEN t220_count
        FETCH t220_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t220_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t220_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t220_cs INTO g_rme.rme01
        WHEN 'P' FETCH PREVIOUS t220_cs INTO g_rme.rme01
        WHEN 'F' FETCH FIRST    t220_cs INTO g_rme.rme01
        WHEN 'L' FETCH LAST     t220_cs INTO g_rme.rme01
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
            FETCH ABSOLUTE g_jump t220_cs INTO g_rme.rme01
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
    #    CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)#FUN-660111
         CALL cl_err3("sel","rme_file",g_rme.rme01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rme.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rme.rmeuser #FUN-4C0055
        LET g_data_group = g_rme.rmegrup #FUN-4C0055
        LET g_data_plant = g_rme.rmeplant #FUN-980030
    END IF
 
    CALL t220_show()
END FUNCTION
 
FUNCTION t220_show()
 
    LET g_rme_t.* = g_rme.*                #保存單頭舊值
    DISPLAY BY NAME
 
        g_rme.rme01,g_rme.rme011,g_rme.rme08,g_rme.rme03,g_rme.rme04,
        g_rme.rme041,g_rme.rme073,g_rme.rme074,g_rme.rme075,g_rme.rme31,
        g_rme.rme076,g_rme.rme077     #FUN-720014 add
 
      #FUN-840068     ---start---
       ,g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
        g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
        g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
        g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15
      #FUN-840068     ----end----
 
    #CKP
    CALL cl_set_field_pic(g_rme.rme31  ,"","","","",g_rme.rmevoid)
 
    CALL t220_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t220_g_b()
     DEFINE l_rms14 LIKE rms_file.rms14
 
     LET g_sql =" select rmf31,rmf33,rmf03,rmf04,rmf06,rmf061, ",
                "        rmb13,sum(rmf22) ",
                " from rmf_file,rmb_file,rma_file ",
                " where rmf07=rmb01 and rmf03=rmb03 AND rma01=rmb01 ",
                " and rmf01='",g_rme.rme01,"' AND rmf07='",g_rme.rme011,"'",
                " and rma09 !='6' and rmavoid='Y' ",
                " GROUP BY rmf31,rmf33,rmf03,rmf04,rmf06,rmf061,rmb13 ",
                " order by 1,2,3 "
 
    PREPARE t220_rmspb FROM g_sql
    IF SQLCA.SQLCODE != 0 THEN
       CALL cl_err('pre1:',SQLCA.sqlcode,0)
       LET g_success="N"
       RETURN
    END IF
    DECLARE rmc_curs                       #SCROLL CURSOR
        CURSOR FOR t220_rmspb
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH rmc_curs INTO l_rms.*          #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
        ELSE
           LET l_rms14=l_rms.rms12*l_rms.rms13
            INSERT INTO rms_file(rms01,rms02,rms03,rms04,rms06,  #No.MOD-470041
                   rms061,rms12,rms13,rms14,rms31,rms32,rms33,
 
                #FUN-840068   ---start---
                  #rms34,rms35,rms36)
                   rms34,rms35,rms36,
                   rmsud01,rmsud02,rmsud03,rmsud04,rmsud05,
                   rmsud06,rmsud07,rmsud08,rmsud09,rmsud10,
                   rmsud11,rmsud12,rmsud13,rmsud14,rmsud15,
                   rmsplant,rmslegal)     #FUN-980007
                #FUN-840068    ----end----
 
           VALUES (g_rme.rme01,g_cnt,l_rms.rms03,l_rms.rms04,l_rms.rms06,
                   l_rms.rms061,l_rms.rms12,l_rms.rms13,
                   l_rms14,l_rms.rms31,'',l_rms.rms33,
                #FUN-840068   ---start---
                  #'',0,'')
                   '',0,'',
                   '','','','','','','','','','','','','','','',
                   g_plant,g_legal) #FUN-980007
                #FUN-840068    ----end----
           IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
   #           CALL cl_err('ins rms',STATUS,1)#FUN-660111
           CALL cl_err3("ins","rms_file",g_rme.rme01,g_cnt,STATUS,"","ins rms",1) #FUN-660111
              ROLLBACK WORK
              LET g_success="N"
              EXIT FOREACH
           END IF
           LET g_rec_b = g_rec_b + 1
           LET g_cnt = g_cnt + 1
        END IF
    END FOREACH
    IF g_rec_b =0 THEN
       CALL cl_err('body: ','aap-129',0)
       LET g_success="N"
       RETURN
    ELSE
       COMMIT WORK
     # CALL cl_cmmsg(3) sleep 1
    END IF
    CALL t220_b_fill(" 1=1")
END FUNCTION
 
FUNCTION t220_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_ima01         LIKE ima_file.ima01,   #料件編號
    g_tmp           LIKE rmc_file.rmc01,   #料件編號
    l_ima25         LIKE ima_file.ima25,   #料件編號: 單位
    l_gfe01         LIKE gfe_file.gfe01,   #料件編號: 單位
    g_rms07,g_rms311,l_total,l_i  LIKE type_file.num5,    #No.FUN-690010 SMALLINT
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
    IF g_rme.rme31   = 'Y' THEN CALL cl_err('rme31=Y',9003,0) RETURN END IF
    IF g_rec_b =0 THEN
       #由 RMA單(rms)依單頭所輸入: rme011(rmf01) 產生單身:rms
        IF cl_confirm('aap-701') THEN
           CALL t220_g_b()
           IF g_rec_b=0 OR g_success="N" THEN RETURN END IF
        END IF
    END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT rms02,rms03,rms06,rms061,rms04,rms12,rms13,rms14,",
      "        rms31,rms33,rms36 ",
 
   #No.FUN-840068 --start--
      "       ,rmsud01,rmsud02,rmsud03,rmsud04,rmsud05,",
      "        rmsud06,rmsud07,rmsud08,rmsud09,rmsud10,",
      "        rmsud11,rmsud12,rmsud13,rmsud14,rmsud15 ",
   #No.FUN-840068 ---end---
 
      "   FROM rms_file ",
      "  WHERE rms01= ? ",
      "    AND rms02= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t220_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_rms
              WITHOUT DEFAULTS
              FROM s_rms.*
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
 
            OPEN t220_cl USING g_rme.rme01
            FETCH t220_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t220_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rms_t.* = g_rms[l_ac].*  #BACKUP
               LET g_rms_o.* = g_rms[l_ac].*  #BACKUP
                OPEN t220_bcl USING g_rme.rme01,g_rms_t.rms02
                IF STATUS THEN
                    CALL cl_err("OPEN t220_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t220_bcl INTO g_rms[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rms_t.rms02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD rms02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO rms_file(rms01,rms02,rms03,rms04,rms06,
                                 rms061,rms12,rms13,rms14,rms31,
 
                               #FUN-840068 --start--
                                #rms33,rms36)
                                 rms33,rms36,
                                 rmsud01,rmsud02,rmsud03,
                                 rmsud04,rmsud05,rmsud06,
                                 rmsud07,rmsud08,rmsud09,
                                 rmsud10,rmsud11,rmsud12,
                                 rmsud13,rmsud14,rmsud15,
                                 rmsplant,rmslegal)        #FUN-980007
                               #FUN-840068 --end-- 
 
            VALUES(g_rme.rme01,g_rms[l_ac].rms02,
                   g_rms[l_ac].rms03,g_rms[l_ac].rms04,
                   g_rms[l_ac].rms06,g_rms[l_ac].rms061,
                   g_rms[l_ac].rms12,g_rms[l_ac].rms13,
                   g_rms[l_ac].rms14,g_rms[l_ac].rms31,
 
                 #FUN-840068 --start--
                  #g_rms[l_ac].rms33,g_rms[l_ac].rms36)
                   g_rms[l_ac].rms33,g_rms[l_ac].rms36,
                   g_rms[l_ac].rmsud01,g_rms[l_ac].rmsud02,
                   g_rms[l_ac].rmsud03,g_rms[l_ac].rmsud04,
                   g_rms[l_ac].rmsud05,g_rms[l_ac].rmsud06,
                   g_rms[l_ac].rmsud07,g_rms[l_ac].rmsud08,
                   g_rms[l_ac].rmsud09,g_rms[l_ac].rmsud10,
                   g_rms[l_ac].rmsud11,g_rms[l_ac].rmsud12,
                   g_rms[l_ac].rmsud13,g_rms[l_ac].rmsud14,
                   g_rms[l_ac].rmsud15,
                   g_plant,g_legal)                         #FUN-980007
                 #FUN-840068 --end--
 
            IF SQLCA.sqlcode THEN
   #             CALL cl_err(g_rms[l_ac].rms02,SQLCA.sqlcode,0)#FUN-660111
                CALL cl_err3("ins","rms_file",g_rme.rme01,g_rms[l_ac].rms02,SQLCA.sqlcode,"","",1) #FUN-660111
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
            INITIALIZE g_rms[l_ac].* TO NULL      #900423
            LET g_rms[l_ac].rms12 = 0        #Body default
            LET g_rms[l_ac].rms13 = 0        #Body default
            LET g_rms[l_ac].rms14 = 0        #Body default
            LET g_rms_t.* = g_rms[l_ac].*         #新輸入資料
            LET g_rms_o.* = g_rms[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rms02
 
        BEFORE FIELD rms02                        #default 序號
            IF g_rms[l_ac].rms02 IS NULL OR
               g_rms[l_ac].rms02 = 0 THEN
                SELECT max(rms02)+1
                   INTO g_rms[l_ac].rms02
                   FROM rms_file
                   WHERE rms01 = g_rme.rme01
                IF g_rms[l_ac].rms02 IS NULL THEN
                    LET g_rms[l_ac].rms02 = 1
                END IF
           END IF
 
        AFTER FIELD rms02                        #check 序號是否重複
             IF NOT cl_null(g_rms[l_ac].rms02) THEN
                 IF g_rms[l_ac].rms02 != g_rms_o.rms02 OR
                    g_rms_o.rms02 IS NULL THEN
                    SELECT count(*) INTO l_n FROM rms_file
                      WHERE rms01 = g_rme.rme01 AND
                            rms02 = g_rms[l_ac].rms02
                    IF l_n > 0 THEN
                       LET g_rms[l_ac].rms02 = g_rms_t.rms02
                       CALL cl_err('',-239,0) NEXT FIELD rms02
                    END IF
                 END IF
                 LET g_rms_o.rms02=g_rms[l_ac].rms02
             END IF
 
       AFTER FIELD rms03
             IF NOT cl_null(g_rms[l_ac].rms03) THEN
#FUN-AB0025 -----------------------------mark ------------------------------
#FUN-AA0059 ---------------------start----------------------------
#               IF NOT s_chk_item_no(g_rms[l_ac].rms03,"") THEN
#                  CALL cl_err('',g_errno,1)
#                  LET g_rms[l_ac].rms03= g_rms_t.rms03
#                  NEXT FIELD rms03
#               END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0025 -----------------------------mark -------------------------------
                 LET g_err="N"
                 LET l_n=0
                 SELECT count(*) INTO l_n FROM rms_file  #查核是否重覆(rms_file)
                      WHERE rms02 <> g_rms[l_ac].rms02 AND rms01 = g_rme.rme01
                        AND rms31 = g_rms[l_ac].rms31
                        AND rms33 = g_rms[l_ac].rms33
                        AND rms03 = g_rms[l_ac].rms03
                 IF l_n >= 1 THEN
                    LET g_rms[l_ac].rms03 = g_rms_t.rms03
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_rms[l_ac].rms03
                    #------MOD-5A0095 END------------
                    CALL cl_err('',-239,0) NEXT FIELD rms31
                 END IF
                 CALL t220_get_rmbf()
                 IF g_err="Y" THEN
                    CALL cl_err('INVOICE#: no this part#! ',100,0)
                    DISPLAY g_rms[l_ac].* TO s_rms[l_ac].*
                    NEXT FIELD rms31
                 END IF
             END IF
             LET g_rms_o.rms03 = g_rms[l_ac].rms03
 
       AFTER FIELD rms12
          #FUN-BB0085-add-str--
          IF NOT cl_null(g_rms[l_ac].rms12) AND NOT cl_null(g_rms[l_ac].rms04) THEN 
             LET g_rms[l_ac].rms12= s_digqty(g_rms[l_ac].rms12,g_rms[l_ac].rms04)
             DISPLAY BY NAME g_rms[l_ac].rms12
          END IF
          #FUN-BB0085-add-end--
          IF NOT cl_null(g_rms[l_ac].rms12) THEN
              IF g_rms[l_ac].rms12 < 0 THEN
                  NEXT FIELD rms12
              END IF
          END IF
          LET g_rms[l_ac].rms14=g_rms[l_ac].rms12*g_rms[l_ac].rms13
          #------MOD-5A0095 START----------
          DISPLAY BY NAME g_rms[l_ac].rms14
          #------MOD-5A0095 END------------
 
       AFTER FIELD rms13
          IF NOT cl_null(g_rms[l_ac].rms13) THEN
              IF g_rms[l_ac].rms13 < 0 THEN
                  NEXT FIELD rms13
              END IF
              LET g_rms[l_ac].rms14=g_rms[l_ac].rms12*g_rms[l_ac].rms13
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_rms[l_ac].rms14
              #------MOD-5A0095 END------------
          END IF
 
       AFTER FIELD rms14
          IF NOT cl_null(g_rms[l_ac].rms14) THEN
              IF g_rms[l_ac].rms14 < 0 THEN
                  NEXT FIELD rms14
              END IF
          END IF
 
       AFTER FIELD rms31
          IF NOT cl_null(g_rms[l_ac].rms31) THEN
              SELECT UNIQUE(COUNT(*)) INTO l_n FROM rmf_file
                     WHERE rmf01=g_rme.rme01 AND  rmf31=g_rms[l_ac].rms31
              IF l_n =0  THEN CALL cl_err('no plt!',100,0)
                 NEXT FIELD rms31 END IF
              LET g_rms_o.rms31 = g_rms[l_ac].rms31
          END IF
 
       AFTER FIELD rms33
          IF NOT cl_null(g_rms[l_ac].rms33) THEN
             SELECT UNIQUE(COUNT(*)) INTO l_n FROM rmf_file
                    WHERE rmf01=g_rme.rme01 AND  rmf33=g_rms[l_ac].rms33
             IF l_n =0  THEN CALL cl_err('no plt!',100,0)
                NEXT FIELD rms33 END IF
             LET g_rms_o.rms33 = g_rms[l_ac].rms33
          END IF
 
     #No.FUN-840068 --start--
        AFTER FIELD rmsud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmsud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_rms_t.rms02 > 0 AND
               g_rms_t.rms02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rms_file
                    WHERE rms01 = g_rme.rme01 AND
                          rms02 = g_rms_t.rms02
                IF SQLCA.sqlcode THEN
      #              CALL cl_err(g_rms_t.rms02,SQLCA.sqlcode,0)#FUN-660111
                    CALL cl_err3("del","rms_file",g_rme.rme01,g_rms_t.rms02,SQLCA.sqlcode,"","",1) #FUN-660111
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
               LET g_rms[l_ac].* = g_rms_t.*
               CLOSE t220_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rms[l_ac].rms02,-263,1)
               LET g_rms[l_ac].* = g_rms_t.*
            ELSE
                UPDATE rms_file SET
                       rms02=g_rms[l_ac].rms02,
                       rms03=g_rms[l_ac].rms03,
                       rms04=g_rms[l_ac].rms04,
                       rms06=g_rms[l_ac].rms06,
                       rms061=g_rms[l_ac].rms061,
                       rms12=g_rms[l_ac].rms12,
                       rms13=g_rms[l_ac].rms13,
                       rms14=g_rms[l_ac].rms14,
                       rms31=g_rms[l_ac].rms31,
                       rms33=g_rms[l_ac].rms33,
                       rms36=g_rms[l_ac].rms36
 
                     #FUN-840068 --start--
                      ,rmsud01 = g_rms[l_ac].rmsud01,
                       rmsud02 = g_rms[l_ac].rmsud02,
                       rmsud03 = g_rms[l_ac].rmsud03,
                       rmsud04 = g_rms[l_ac].rmsud04,
                       rmsud05 = g_rms[l_ac].rmsud05,
                       rmsud06 = g_rms[l_ac].rmsud06,
                       rmsud07 = g_rms[l_ac].rmsud07,
                       rmsud08 = g_rms[l_ac].rmsud08,
                       rmsud09 = g_rms[l_ac].rmsud09,
                       rmsud10 = g_rms[l_ac].rmsud10,
                       rmsud11 = g_rms[l_ac].rmsud11,
                       rmsud12 = g_rms[l_ac].rmsud12,
                       rmsud13 = g_rms[l_ac].rmsud13,
                       rmsud14 = g_rms[l_ac].rmsud14,
                       rmsud15 = g_rms[l_ac].rmsud15
                     #FUN-840068 --end-- 
 
                 WHERE rms01=g_rme.rme01 AND
                       rms02=g_rms_t.rms02
                IF SQLCA.sqlcode THEN
     #               CALL cl_err(g_rms[l_ac].rms02,SQLCA.sqlcode,0)#FUN-660111
                    CALL cl_err3("upd","rms_file",g_rme.rme01,g_rms_t.rms02,SQLCA.sqlcode,"","",1) #FUN-660111
                    LET g_rms[l_ac].* = g_rms_t.*
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
                  LET g_rms[l_ac].* = g_rms_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rms.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t220_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D40030 add
           #CKP
           #LET g_rms_t.* = g_rms[l_ac].*          # 900423
            CLOSE t220_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t220_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #帶上一筆的備註值
            IF INFIELD(rms36) AND l_ac > 1 THEN
                LET g_rms[l_ac].rms36 = g_rms[l_ac-1].rms36
                NEXT FIELD rms36
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rms03)     #料件編號
#                 CALL q_ima(10,3,g_rms[l_ac].rms03) RETURNING g_rms[l_ac].rms03
#                 CALL FGL_DIALOG_SETBUFFER( g_rms[l_ac].rms03 )
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_rms[l_ac].rms03
#                  CALL cl_create_qry() RETURNING g_rms[l_ac].rms03
                   CALL q_sel_ima(FALSE, "q_ima","",g_rms[l_ac].rms03,"","","","","",'' ) 
                   RETURNING  g_rms[l_ac].rms03
#FUN-AA0059---------mod------------end-----------------
#                  CALL FGL_DIALOG_SETBUFFER( g_rms[l_ac].rms03 )
                   DISPLAY BY NAME g_rms[l_ac].rms03         #No.MOD-490173
                  NEXT FIELD rms03
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
 
    CLOSE t220_bcl
    COMMIT WORK
 
#   LET g_t1 = g_rme.rme01[1,3]
    LET g_t1=s_get_doc_no(g_rme.rme01)     #No.FUN-550064
    SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
    IF g_oay.oayconf = 'Y' THEN CALL t220_y() END IF
 
END FUNCTION
 
FUNCTION t220_get_rmbf()
    DEFINE l_rmb13   LIKE rmb_file.rmb13,
           l_rmf22   LIKE rmf_file.rmf22
 
      SELECT rmb04,rmb05,rmb06,rmb13
        INTO g_rms[l_ac].rms04,g_rms[l_ac].rms06,g_rms[l_ac].rms061,l_rmb13
        FROM rmb_file
       WHERE rmb01=g_rme.rme011 AND rmb03=g_rms[l_ac].rms03
           # rmb11 >0
        IF SQLCA.sqlcode THEN
           LET g_err="Y"
           LET g_rms[l_ac].rms04 = g_rms_t.rms04
           LET g_rms[l_ac].rms06 = g_rms_t.rms06
           LET g_rms[l_ac].rms061= g_rms_t.rms061
           LET g_rms[l_ac].rms13 = g_rms_t.rms13
           RETURN
        END IF
        SELECT sum(rmf22) INTO l_rmf22 FROM rmf_file
         WHERE rmf01=g_rme.rme01 AND rmf31=g_rms[l_ac].rms31
           AND rmf33=g_rms[l_ac].rms33 AND rmf03=g_rms[l_ac].rms03
        IF SQLCA.sqlcode THEN
           LET g_err="Y"
           RETURN
        END IF
        LET g_rms[l_ac].rms12= s_digqty(g_rms[l_ac].rms12,g_rms[l_ac].rms04)    #FUN-BB0085
        DISPLAY BY NAME g_rms[l_ac].rms12                                       #FUN-BB0085
        IF g_rms[l_ac].rms13=0 THEN LET g_rms[l_ac].rms13=l_rmb13 END IF
        IF g_rms[l_ac].rms12=0 THEN LET g_rms[l_ac].rms12=l_rmf22 END IF
       #IF g_rms[l_ac].rms12=0 THEN LET g_rms[l_ac].rms12=l_rmb12 END IF
        LET g_rms[l_ac].rms14=g_rms[l_ac].rms12*g_rms[l_ac].rms13
END FUNCTION
 
FUNCTION t220_get_ima()
        SELECT ima02,ima021,ima25
              INTO g_rms[l_ac].rms13,g_rms[l_ac].rms14,g_rms[l_ac].rms12
              FROM ima_file  WHERE ima01="MISC"
        IF SQLCA.sqlcode THEN
           LET g_err="Y"
           LET g_rms[l_ac].* = g_rms_t.*
           RETURN
        END IF
END FUNCTION
 
FUNCTION t220_b_askkey()
DEFINE           l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON rms02,rms03,rms06,rms061,rms04,rms12,
                       rms13,rms14,rms31,rms33,rms36
 
                   #No.FUN-840068 --start--
                      ,rmsud01,rmsud02,rmsud03,rmsud04,rmsud05
                      ,rmsud06,rmsud07,rmsud08,rmsud09,rmsud10
                      ,rmsud11,rmsud12,rmsud13,rmsud14,rmsud15
                   #No.FUN-840068 ---end---
 
            FROM s_rms[1].rms02, s_rms[1].rms03, s_rms[1].rms06, s_rms[1].rms061,
                 s_rms[1].rms04, s_rms[1].rms12,
                 s_rms[1].rms13,s_rms[1].rms14,s_rms[1].rms31,
                 s_rms[1].rms33,s_rms[1].rms36
 
           #No.FUN-840068 --start--
                ,s_rms[1].rmsud01,s_rms[1].rmsud02,s_rms[1].rmsud03
                ,s_rms[1].rmsud04,s_rms[1].rmsud05,s_rms[1].rmsud06
                ,s_rms[1].rmsud07,s_rms[1].rmsud08,s_rms[1].rmsud09
                ,s_rms[1].rmsud10,s_rms[1].rmsud11,s_rms[1].rmsud12
                ,s_rms[1].rmsud13,s_rms[1].rmsud14,s_rms[1].rmsud15
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
    CALL t220_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t220_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
       LET g_sql =" SELECT rms02,rms03,rms06,rms061,rms04,rms12, ",
                  "        rms13,rms14,rms31,rms33,rms36  ",
 
               #No.FUN-840068 --start--
                  "       ,rmsud01,rmsud02,rmsud03,rmsud04,rmsud05,",
                  "        rmsud06,rmsud07,rmsud08,rmsud09,rmsud10,",
                  "        rmsud11,rmsud12,rmsud13,rmsud14,rmsud15 ",
               #No.FUN-840068 ---end---
 
                  " FROM rme_file,rms_file ",
                  " WHERE rme01=rms01 ",
                  " AND rms01= '",g_rme.rme01,"'"," AND ",p_wc2 CLIPPED,
                  " ORDER BY rms02 "
    PREPARE t220_pb FROM g_sql
    DECLARE rms_curs                       #SCROLL CURSOR
        CURSOR FOR t220_pb
 
    CALL g_rms.clear()
    LET g_cnt = 1
    FOREACH rms_curs INTO g_rms[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_rms.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t220_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rms TO s_rms.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL t220_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
     #CHI-680010-begin-add
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
     #CHI-680010-end-add
 
 
      ON ACTION previous
         CALL t220_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t220_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t220_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t220_fetch('L')
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
         CALL cl_set_field_pic(g_rme.rme31  ,"","","","",g_rme.rmevoid)
 
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
 
 
FUNCTION t220_y()         # when g_rme.rme31  ='N' (Turn to 'Y')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ------------------- add --------------------- begin
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmepost = 'N' THEN CALL cl_err('t160:post=N','arm-027',0)
      RETURN END IF
   IF g_rme.rme31   = 'Y' THEN CALL cl_err('rme31=Y',9023,0) RETURN END IF
   IF g_rms[1].rms02 IS NULL THEN
      CALL cl_err(g_rme.rme01,'arm-034',1) RETURN END IF
   IF g_rme.rmegen = 'N' THEN  CALL cl_err('t160:gen=N','aap-717',0)
      RETURN END IF
   IF NOT cl_upsw(0,0,'N') THEN RETURN END IF
#CHI-C30107 ------------------- add --------------------- end
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmepost = 'N' THEN CALL cl_err('t160:post=N','arm-027',0)
      RETURN END IF
   IF g_rme.rme31   = 'Y' THEN CALL cl_err('rme31=Y',9023,0) RETURN END IF
   IF g_rms[1].rms02 IS NULL THEN
      CALL cl_err(g_rme.rme01,'arm-034',1) RETURN END IF
   IF g_rme.rmegen = 'N' THEN  CALL cl_err('t160:gen=N','aap-717',0)
      RETURN END IF
#  IF NOT cl_upsw(0,0,'N') THEN RETURN END IF #CHI-C30107 mark
   LET g_rme_t.* = g_rme.*
   BEGIN WORK
 
    OPEN t220_cl USING g_rme.rme01
    FETCH t220_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t220_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t220_up_rmb('Y')      #UPDATE rmb
   IF g_success = 'N' THEN
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
      RETURN
   END IF
   UPDATE rme_file SET rme31 = 'Y',rmemodu=g_user,rmedate=g_today
          WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
  #    CALL cl_err('upd rme31 ',STATUS,1)#FUN-660111
      CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rme31",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      LET g_rme.rme31  ="Y"
      LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
      COMMIT WORK
      DISPLAY BY NAME g_rme.rme31
      CALL cl_cmmsg(3) sleep 1
   ELSE
      LET g_rme.rme31  ='N'
      LET g_rme.rmemodu=g_rme_t.rmemodu LET g_rme.rmedate=g_rme_t.rmedate
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rme.rme31
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rme.rme31  ,"","","","",g_rme.rmevoid)
END FUNCTION
 
FUNCTION t220_z()    # when g_rme.rme31 ='Y' (Turn to 'N')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
  #IF g_rme.rmepost = 'Y' THEN CALL cl_err('post=Y:','aap-730',0)
  #   RETURN END IF
   IF g_rme.rme31   = 'N' THEN CALL cl_err('rme31=N',9025,0) RETURN END IF
   IF g_rme.rmegen = 'N' THEN  CALL cl_err('t160:gen=N','aap-717',0)
      RETURN END IF
   IF NOT cl_upsw(0,0,'Y') THEN RETURN END IF
   LET g_rme_t.* = g_rme.*
   BEGIN WORK
 
    OPEN t220_cl USING g_rme.rme01
    FETCH t220_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t220_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t220_up_rmb('Z')
   IF g_success="N" THEN
      ROLLBACK WORK
      DISPLAY BY NAME g_rme.rme31
      RETURN
   END IF
   UPDATE rme_file SET rme31   = 'N',rmemodu=g_user,
                       rmedate=g_today
          WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
  #    CALL cl_err('upd rme31',STATUS,1)#FUN-660111
      CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rme31",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN LET g_rme.rme31  ='N'
           LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
           COMMIT WORK
           CALL cl_cmmsg(3) sleep 1
      ELSE LET g_rme.rme31  ='Y'
           LET g_rme.rmemodu=g_rme_t.rmemodu LET g_rme.rmedate=g_rme_t.rmedate
           ROLLBACK WORK
           CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rme.rme31
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rme.rme31  ,"","","","",g_rme.rmevoid)
END FUNCTION
 
FUNCTION t220_up_rmb(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_i   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   IF g_rec_b > 0 THEN
      FOR l_i = 1 TO g_rec_b
        IF g_rms[l_i].rms02 IS NULL OR g_rms[l_i].rms03 IS NULL OR
           g_rms[l_i].rms03='MISC' THEN
           EXIT FOR END IF
 
        IF p_cmd="Y" THEN             #當執行 Y.確認時
             UPDATE rmb_file SET rmb111=rmb111+g_rms[l_i].rms12
                WHERE rmb01=g_rme.rme011 AND rmb03=g_rms[l_i].rms03
        ELSE                          #當執行 Z.取消確認時
             UPDATE rmb_file SET rmb111=rmb111-g_rms[l_i].rms12
                WHERE rmb01=g_rme.rme011 AND rmb03=g_rms[l_i].rms03
        END IF
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err('up rmb:',SQLCA.sqlcode,1)
           LET g_success="N"
           EXIT FOR
        END IF
      END FOR
   END IF
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001,002,003> #
