# Prog. Version..: '5.10.00-08.01.04(00009)'     #
#
# Pattern name...: saxdt203.4gl
# Descriptions...: 集團撥入單維護作業
# Date & Author..: 03/12/12 By Hawk
# Modify       ..: 03/12/18 By Carrier
# Modify       ..: 04/01/12 By Carrier
#              ..: add adg17
# Modify.........: No:MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4B0082 04/11/10 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY  將變數用Like方式定義
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No:MOD-4C0087 04/12/23 By Carrier 修改s_tlf-->s_tlf2
# Modify.........: No.FUN-550026 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-560014 05/06/06 By day  單據編號修改
# Modify.........: No:MOD-560158 05/06/21 By Echo 無與EasyFlow整合，因此刪除link檔裡的整合程式
# Modify.........: No.MOD-560296 05/07/20 By Carrier s_upimg2替換成s_upimg1
# Modify.........: NO.FUN-580033 05/08/08 By Carrier 多單位內容修改
# Modify.........: No:MOD-590121 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No:FUN-610006 06/01/17 By Smapmin 雙單位畫面調整
# Modify.........: No:FUN-610090 06/02/07 By Nicola 拆併箱功能修改
# Modify.........: NO:TQC-620156 06/03/13 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: No:TQC-610088 06/03/27 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No:FUN-6A0165 06/11/10 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No:FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No:TQC-7B0083 07/11/21 By Carrier rvv88給預設值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_adh    RECORD LIKE adh_file.*,       #集團撥入單單頭檔
    g_adh_t  RECORD LIKE adh_file.*,       #集團撥入單單頭檔(舊值)
    g_adh_o  RECORD LIKE adh_file.*,       #集團撥入單單頭檔(舊值)
    g_adh01_t       LIKE adh_file.adh01,   #撥入單號(舊值)
    g_adh_rowid     LIKE type_file.chr18,  #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
 g_adi           DYNAMIC ARRAY of RECORD#集團撥入單單身檔
        adi02       LIKE adi_file.adi02,   #項次
        adi03       LIKE adi_file.adi03,   #撥出單號
        adi04       LIKE adi_file.adi04,   #撥出項次
        adi15       LIKE adi_file.adi15,   #采購編號
        adi16       LIKE adi_file.adi16,   #采購項次
        adi05       LIKE adi_file.adi05,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        adi06       LIKE adi_file.adi06,   #倉庫代號
        adi07       LIKE adi_file.adi07,   #儲位
        adi08       LIKE adi_file.adi08,   #批號
        adi09       LIKE adi_file.adi09,   #單位
        #No.FUN-580033  --begin
        adi10       LIKE adi_file.adi10,   #撥入數量
        adi33       LIKE adi_file.adi33,   #單位二
        adi34       LIKE adi_file.adi34,   #單位二轉換率
        adi35       LIKE adi_file.adi35,   #單位二數量
        adi30       LIKE adi_file.adi30,   #單位一
        adi31       LIKE adi_file.adi31,   #單位一轉換率
        adi32       LIKE adi_file.adi32    #單位一數量
        #No.FUN-580033  --end
                    END RECORD,
 g_adi_t         RECORD                 #集團撥入單單身檔 (舊值)
        adi02       LIKE adi_file.adi02,   #項次
        adi03       LIKE adi_file.adi03,   #撥出單號
        adi04       LIKE adi_file.adi04,   #撥出項次
        adi15       LIKE adi_file.adi15,   #采購編號
        adi16       LIKE adi_file.adi16,   #采購項次
        adi05       LIKE adi_file.adi05,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        adi06       LIKE adi_file.adi06,   #倉庫代號
        adi07       LIKE adi_file.adi07,   #儲位
        adi08       LIKE adi_file.adi08,   #批號
        adi09       LIKE adi_file.adi09,   #單位
        #No.FUN-580033  --begin
        adi10       LIKE adi_file.adi10,   #撥入數量
        adi33       LIKE adi_file.adi33,   #單位二
        adi34       LIKE adi_file.adi34,   #單位二轉換率
        adi35       LIKE adi_file.adi35,   #單位二數量
        adi30       LIKE adi_file.adi30,   #單位一
        adi31       LIKE adi_file.adi31,   #單位一轉換率
        adi32       LIKE adi_file.adi32    #單位一數量
        #No.FUN-580033  --end
                    END RECORD,
    g_cmd           LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(200)
    g_adi18         LIKE adi_file.adi18,
    g_adi19         LIKE adi_file.adi19,
    g_adi20         LIKE adi_file.adi20,
    g_adi15         LIKE adi_file.adi15,   #采購單號
    g_adi16         LIKE adi_file.adi16,   #采購項次
    g_azp01         LIKE azp_file.azp01,
    g_azp03         LIKE azp_file.azp03,
    g_oga01         LIKE oga_file.oga01,   #出貨單號
    g_oha01         LIKE oha_file.oha01,   #銷退單號
    g_oha09         LIKE oha_file.oha09,   #銷退單號
    g_rva01         LIKE rva_file.rva01,   #收貨單號
    g_rvu01         LIKE rvu_file.rvu01,   #入庫單號
    p_dbs           LIKE azp_file.azp03,
    t_dbs           LIKE azp_file.azp03,
    g_type          LIKE adz_file.adztype, #No.FUN-680108 VARCHAR(02)
    g_t1            LIKE oay_file.oayslip, #No.FUN-550026   #No.FUN-680108 VARCHAR(05)
    g_wc,g_sql,g_wc2    string,  #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,   #單身筆數   #No.FUN-680108 SMALLINT
    g_flag          LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680108 SMALLINT
DEFINE g_argv0      LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE g_forupd_sql         STRING         #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE g_chr        LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose #No.FUN-680108 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(72)
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE g_jump       LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5    #No.FUN-680108 SMALLINT
#FUN-580033  --begin
DEFINE t_adi            RECORD
                        pmm09  LIKE pmm_file.pmm09,   #撥出工廠
                        adi02  LIKE adi_file.adi02,   #撥入項次
                        adi03  LIKE adi_file.adi03,   #參考單號
                        adi04  LIKE adi_file.adi04,   #參考項次
                        adi15  LIKE adi_file.adi15,   #采購單號
                        adi16  LIKE adi_file.adi16,   #采購項次
                        adi05  LIKE adi_file.adi05,   #料件編號
                        adi06  LIKE adi_file.adi06,   #倉庫
                        adi07  LIKE adi_file.adi07,   #儲位
                        adi08  LIKE adi_file.adi08,   #批號
                        adi09  LIKE adi_file.adi09,   #單位
                        adi10  LIKE adi_file.adi10,   #撥入數量
                        adi33  LIKE adi_file.adi33,   #單位二
                        adi34  LIKE adi_file.adi34,   #單位二轉換率
                        adi35  LIKE adi_file.adi35,   #單位二數量
                        adi30  LIKE adi_file.adi30,   #單位一
                        adi31  LIKE adi_file.adi31,   #單位一轉換率
                        adi32  LIKE adi_file.adi32    #單位一數量
                        END RECORD,
    g_img_rowid         LIKE type_file.chr18,  #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
    g_change            LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
    g_ima906            LIKE ima_file.ima906,
    g_ima25             LIKE ima_file.ima25,
    g_ima907            LIKE ima_file.ima907,
    g_sw                LIKE type_file.num5,   #No.FUN-680108 SMALLINT
    g_factor            LIKE inb_file.inb08_fac,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10
#FUN-580033  --end
DEFINE g_imm01         LIKE imm_file.imm01     #No.FUN-610090
DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD #No:FUN-610090
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
                   
FUNCTION t203(p_argv0)
DEFINE
    p_argv0       LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)

    WHENEVER ERROR CONTINUE              #忽略一切錯誤
    LET g_wc2 = " 1=1"

    LET g_adh01_t = NULL                 #清除鍵值
    LET g_argv0 = p_argv0
    IF NOT cl_null(g_argv0) AND g_argv0 NOT MATCHES '[12]' THEN
       CALL cl_err(g_argv0,'axd-016',0)
       EXIT PROGRAM
    END IF
    IF g_argv0 = '1' THEN LET g_type = '16' END IF
    IF g_argv0 = '2' THEN LET g_type = '17' END IF
    IF g_argv0 = '3' THEN LET g_type = '18' END IF
    SELECT azp01,azp03 INTO g_azp01,g_azp03 FROM azp_file WHERE azp01 = g_plant

    INITIALIZE g_adh_t.* TO NULL
    INITIALIZE g_adh.* TO NULL

    LET g_forupd_sql = "SELECT * FROM adh_file WHERE ROWID = ? FOR UPDATE NOWAIT"
    DECLARE t203_cl CURSOR FROM g_forupd_sql

    #No.FUN-580033  --begin
    CALL t203_mu_ui()
    #No.FUN-580033  --end
    CALL t203_menu()

END FUNCTION

#QBE 查詢資料
FUNCTION t203_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
     CLEAR FORM                                   #清除畫面
     CALL g_adi.clear()
     CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

     CONSTRUCT BY NAME g_wc ON
                  adh00,adh01,adh02,adh06,adh03,adh04,adh05,
                  adhconf,adhpost,adh07,adhmksg,
                  adhuser,adhgrup,adhmodu,adhdate,adhacti

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adh01)        #need modify
                    CALL s_get_doc_no(g_adh.adh01) RETURNING g_t1     #No.FUN-550026
                    #CALL q_adz(FALSE,TRUE,g_t1,g_type,'axd') #TQC-670008
                    CALL q_adz(FALSE,TRUE,g_t1,g_type,'AXD')  #TQC-670008
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adh01
                    NEXT FIELD adh01
                WHEN INFIELD(adh03)
                    #CALL q_gen(0,0,g_adh.adh03) RETURNING g_adh.adh03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adh03
                    NEXT FIELD adh03
                WHEN INFIELD(adh04)
                    #CALL q_gem(0,0,g_adh.adh04) RETURNING g_adh.adh04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adh04
                    NEXT FIELD adh04
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
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
       #No:FUN-580031 --end--       HCN
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
     #No.FUN-580033  --begin
     CONSTRUCT g_wc2 ON adi02,adi03,adi04,adi15,adi16,  #螢幕上取單身條件
                        adi05,adi06,adi07,adi08,adi09,adi10,
                        adi33,adi35,adi30,adi32
        FROM s_adi[1].adi02,s_adi[1].adi03,s_adi[1].adi04,
             s_adi[1].adi15,s_adi[1].adi16,s_adi[1].adi05,
             s_adi[1].adi06,s_adi[1].adi07,s_adi[1].adi08,
             s_adi[1].adi09,s_adi[1].adi10,s_adi[1].adi33,
             s_adi[1].adi35,s_adi[1].adi30,s_adi[1].adi32
     #No.FUN-580033  --end

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(adi03)
                 CASE g_adh.adh00
                    WHEN '1'
                       CALL q_adg(TRUE,FALSE,g_adi[l_ac].adi03,
                                  g_adi[l_ac].adi04,'1')
                            RETURNING g_qryparam.multiret
                    WHEN '2'
                       CALL q_pmn4(FALSE,TRUE,g_adi[l_ac].adi03,g_adi[l_ac].adi04,
                                      g_adi[l_ac].adi15,g_adi[l_ac].adi16)
                            RETURNING g_qryparam.multiret
                 END CASE
                 DISPLAY g_qryparam.multiret TO s_adi[1].adi03
                 NEXT FIELD adi03

              WHEN INFIELD(adi07)
                 #CALL q_ime(0,0,g_adi[l_ac].adi07,g_adi[l_ac].adi06,'S')
                 #     RETURNING g_adi[l_ac].adi07
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ime"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_adi[1].adi07
                 NEXT FIELD adi07
              WHEN INFIELD(adi08)
                 #CALL q_img(0,0,g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                 #           g_adi[l_ac].adi07,g_adi[l_ac].adi08,'A')
                 #     RETURNING g_adi[l_ac].adi06,g_adi[l_ac].adi07,
                 #               g_adi[l_ac].adi08
                 LET g_qryparam.form ="q_img7"
                 LET g_qryparam.state = "c"
                 IF g_adi[l_ac].adi06 IS NOT NULL THEN
                    LET g_qryparam.where=" img02='",g_adi[l_ac].adi06,"'"
                 END IF
                 IF g_adi[l_ac].adi07 IS NOT NULL THEN
                    LET g_qryparam.where=" img03='",g_adi[l_ac].adi07,"'"
                 END IF
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_adi[1].adi08
                 NEXT FIELD adi08
              #No.FUN-580033  --begin
              WHEN INFIELD(adi33)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO adi33
                 NEXT FIELD adi33
              WHEN INFIELD(adi30)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO adi30
                 NEXT FIELD adi30
              #No.FUN-580033  --end
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
 
      #No:FUN-580031 --start--     HCN
          ON ACTION qbe_save
             CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN  RETURN END IF
    IF g_priv2='4' THEN                           #只能使用自己的資料
       LET g_wc = g_wc clipped," AND adhuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND adhgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
      LET g_wc = g_wc clipped," AND adhgrup IN ",cl_chk_tgrup_list()
    END IF

    IF g_wc2 = " 1=1" THEN		          # 若單身未輸入條件
       LET g_sql = "SELECT ROWID, adh01 FROM adh_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 2"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE adh_file.ROWID, adh01 ",
                  "  FROM adh_file, adi_file ",
                  " WHERE adh01 = adi01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 2"
    END IF
    PREPARE t203_prepare FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) EXIT PROGRAM END IF
    DECLARE t203_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t203_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM adh_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct adh01)",
                  " FROM adh_file,adi_file WHERE ",
                  " adh01=adi01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF
    PREPARE t203_precount FROM g_sql
    DECLARE t203_count CURSOR FOR t203_precount
    OPEN t203_count
    FETCH t203_count INTO g_row_count
    CLOSE t203_count
END FUNCTION

#中文的MENU
FUNCTION t203_menu()

   WHILE TRUE
      CALL t203_bp("G")
      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t203_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t203_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t203_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t203_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t203_x()
                CALL cl_set_field_pic(g_adh.adhconf,"",g_adh.adhpost,"","",g_adh.adhacti)  #NO.MOD-4B0082
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t203_b()
            ELSE
               LET g_action_choice = NULL
            END IF

#         WHEN "reproduce"
#            IF cl_chk_act_auth() THEN
#               CALL t203_copy()
#            END IF
         #WHEN "簽核狀態"                                 #MOD-560158
        ##@WHEN "btn01"
        #   IF cl_chk_act_auth() THEN
        #      CALL t203_sg()
        #   END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t203_y()
                CALL cl_set_field_pic(g_adh.adhconf,"",g_adh.adhpost,"","",g_adh.adhacti)  #NO.MOD-4B0082
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t203_w()
                CALL cl_set_field_pic(g_adh.adhconf,"",g_adh.adhpost,"","",g_adh.adhacti)  #NO.MOD-4B0082
            END IF

         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t203_s()
                CALL cl_set_field_pic(g_adh.adhconf,"",g_adh.adhpost,"","",g_adh.adhacti)  #NO.MOD-4B0082
            END IF

         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t203_z()
                CALL cl_set_field_pic(g_adh.adhconf,"",g_adh.adhpost,"","",g_adh.adhacti)  #NO.MOD-4B0082
            END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t203_out('o')
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         #No:FUN-6A0165-------adh--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_adh.adh01 IS NOT NULL THEN
                 LET g_doc.column1 = "adh01"
                 LET g_doc.value1 = g_adh.adh01
                 CALL cl_doc()
               END IF
         END IF
         #No:FUN-6A0165-------adh--------end----
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION t203_a()
    DEFINE  li_result LIKE type_file.num5     #No:FUN-560014    #No.FUN-680108 SMALLINT

    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無新增之功能
    CLEAR FORM                                # 清螢墓欄位內容
    CALL g_adi.clear()
    INITIALIZE g_adh.* LIKE adh_file.*
    LET g_adh01_t = NULL
    LET g_adh_t.*=g_adh.*
    LET g_adh.adh00 = g_argv0
    LET g_adh.adh02 = g_today                    #DEFAULT
    LET g_adh.adh06 = g_today                    #DEFAULT
    LET g_adh.adh03 = g_user                     #DEFAULT
    LET g_adh.adh04 = g_grup                     #DEFAULT
    IF cl_null(g_argv0) THEN LET g_adh.adh00 = '1' END IF

    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_adh.adhacti ='Y'                   #有效的資料
        LET g_adh.adhconf ='N'                   #有效的資料
        LET g_adh.adhpost ='N'                   #有效的資料
        LET g_adh.adhuser = g_user
        LET g_adh.adhgrup = g_grup               #使用者所屬群
        LET g_adh.adhdate = g_today
        LET g_adh.adh07   = '0'
        CALL t203_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_adh.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_adh.adh01 IS NULL THEN              # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
#No.FUN-560014  --start
        CALL s_auto_assign_no("axd",g_adh.adh01,g_adh.adh02,"","adh_file","adh01","","","")
          RETURNING li_result,g_adh.adh01
        IF (NOT li_result) THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_adh.adh01
#        IF g_adz.adzauno='Y' THEN   #need modify to add adh_file in it
#           CALL s_axdauno(g_adh.adh01,g_adh.adh02) RETURNING g_i,g_adh.adh01
#           IF g_i THEN #有問題
#              ROLLBACK WORK   #No:7829
#              CONTINUE WHILE
#           END IF
#           DISPLAY BY NAME g_adh.adh01
#        END IF
#No.FUN-560014  --end
        INSERT INTO adh_file VALUES(g_adh.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        COMMIT WORK
        SELECT ROWID INTO g_adh_rowid FROM adh_file
         WHERE adh01 = g_adh.adh01
        LET g_adh01_t = g_adh.adh01        #保留舊值
        LET g_adh_t.* = g_adh.*

        CALL g_adi.clear()
        LET g_rec_b=0
        CALL t203_b()                      #輸入單身
        SELECT * FROM adh_file WHERE adh01 = g_adh.adh01
        IF SQLCA.sqlcode = 0 THEN
           IF g_adz.adzconf = 'Y' THEN CALL t203_y() END IF
           IF g_adz.adzprnt = 'Y' THEN CALL t203_prt() END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION t203_i(p_cmd)
    DEFINE
        l_sw            LIKE type_file.chr1,   #檢查必要欄位是否空白  #No.FUN-680108 VARCHAR(1)
        p_cmd           LIKE type_file.chr1,                          #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5,                          #No.FUN-680108 SMALLINT
        l_obw           RECORD LIKE obw_file.*
    DEFINE li_result    LIKE type_file.num5    #No.FUN-550026         #No.FUN-680108 SMALLINT

    IF NOT cl_null(g_argv0) THEN
       LET g_adh.adh00 = g_argv0
    END IF

    CALL t203_adh07()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT BY NAME g_adh.adh00,g_adh.adh01,g_adh.adh02,g_adh.adh06,
                  g_adh.adh03,g_adh.adh04,g_adh.adh05,g_adh.adh07,
                  g_adh.adhmksg,g_adh.adhsign,g_adh.adhuser,g_adh.adhgrup,
                  g_adh.adhmodu,g_adh.adhdate,g_adh.adhacti,g_adh.adhconf,
                  g_adh.adhpost
                  WITHOUT DEFAULTS HELP 1

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t203_set_entry(p_cmd)
            CALL t203_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            #No.FUN-550026 --start--
            CALL cl_set_docno_format("adh01")
            #No.FUN-550026 ---end---

        AFTER FIELD adh00
            IF g_adh.adh00 MATCHES '[123]' THEN
               CALL t203_adh00()
            END IF

        AFTER FIELD adh01
            IF NOT cl_null(g_adh.adh01) THEN
#No.FUN-550026 --begin--
               CALL s_get_doc_no(g_adh.adh01) RETURNING g_t1   #No.FUN-560014
               CASE
                   WHEN g_adh.adh00 = '1' LET g_type = '16'
                   WHEN g_adh.adh00 = '2' LET g_type = '17'
                   WHEN g_adh.adh00 = '3' LET g_type = '18'
               END CASE
               CALL s_check_no("axd",g_adh.adh01,"",g_type,"adh_file","adh01","")
                    RETURNING li_result,g_adh.adh01
               IF (NOT li_result) THEN
                  NEXT FIELD adh01
               END IF
               DISPLAY BY NAME g_adh.adh01
#               SELECT * INTO g_adz.* FROM adz_file WHERE adzslip = g_t1
#                  AND adztype = g_type
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_adh.adh01,'mfg0014',0)
#                  NEXT FIELD adh01
#               END IF
#               IF g_adh_t.adh01 IS NULL OR
#                  (g_adh.adh01 != g_adh_t.adh01 ) THEN
                   LET  g_adh.adhmksg = g_adz.adzapr
                   LET  g_adh.adhsign = g_adz.adzsign
                   DISPLAY BY NAME g_adh.adhmksg
                   DISPLAY BY NAME g_adh.adhsign
#                END IF
                LET g_adh.adhprsw = 'Y'
                LET g_adh.adhmksg = g_adz.adzapr
                LET g_adh.adhsign = g_adz.adzsign
                DISPLAY BY NAME g_adh.adhmksg
                DISPLAY BY NAME g_adh.adhsign
#               IF p_cmd = 'a' AND cl_null(g_adh.adh01[5,10]) AND g_adz.adzauno='N'
#                  THEN NEXT FIELD adh01
#               END IF
#               IF g_adh.adh01 != g_adh_t.adh01 OR g_adh_t.adh01 IS NULL THEN
#                   IF g_adz.adzauno = 'Y'
#                     AND NOT cl_chk_data_continue(g_adh.adh01[5,10]) THEN
#                      CALL cl_err('','9056',0) NEXT FIELD adh01
#                   END IF
#                   SELECT count(*) INTO g_cnt FROM adh_file
#                       WHERE adh01 = g_adh.adh01
#                   IF g_cnt > 0 THEN   #資料重復
#                       CALL cl_err(g_adh.adh01,-239,0)
#                       LET g_adh.adh01 = g_adh_t.adh01
#                       DISPLAY BY NAME g_adh.adh01
#                       NEXT FIELD adh01
#                   END IF
#               END IF
#No.FUN-550026 --end--
            END IF

     AFTER FIELD adh03
            IF NOT cl_null(g_adh.adh03) THEN
               CALL t203_adh03('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adh.adh03 = g_adh_t.adh03
                  DISPLAY BY NAME g_adh.adh03
                  NEXT FIELD adh03
               END IF
               SELECT gen03 INTO g_adh.adh04 FROM gen_file
                WHERE gen01 = g_adh.adh03
               DISPLAY BY NAME g_adh.adh03
            END IF

     AFTER FIELD adh04
            IF NOT cl_null(g_adh.adh04) THEN
               CALL t203_adh04('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adh.adh04 = g_adh_t.adh04
                  DISPLAY BY NAME g_adh.adh04
                  NEXT FIELD adh04
               END IF
            END IF

        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
      
        #MOD-650015 --start
        #ON ACTION CONTROLO                       # 沿用所有欄位
        #    IF INFIELD(adh01) THEN
        #        LET g_adh.* = g_adh_t.*
        #        DISPLAY BY NAME g_adh.* ATTRIBUTE(YELLOW)
        #        NEXT FIELD adh01
        #    END IF
        #MOD-650015 --end

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adh01)        #need modify
                    CALL s_get_doc_no(g_adh.adh01) RETURNING g_t1   #No.FUN-550026
                    CASE
                       #WHEN g_adh.adh00='1' CALL q_adz(FALSE,FALSE,g_t1,'16','axd')  #TQC-670008
                       WHEN g_adh.adh00='1' CALL q_adz(FALSE,FALSE,g_t1,'16','AXD')   #TQC-670008
                            RETURNING g_t1
                       #WHEN g_adh.adh00='2' CALL q_adz(FALSE,FALSE,g_t1,'17','axd') #TQC-670008
                       WHEN g_adh.adh00='2' CALL q_adz(FALSE,FALSE,g_t1,'17','AXD')  #TQC-670008
                            RETURNING g_t1
                       #WHEN g_adh.adh00='3' CALL q_adz(FALSE,FALSE,g_t1,'18','axd') #TQC-670008
                       WHEN g_adh.adh00='3' CALL q_adz(FALSE,FALSE,g_t1,'18','AXD')  #TQC-670008
                            RETURNING g_t1
                    END CASE
                    LET g_adh.adh01 = g_t1
                    DISPLAY BY NAME g_adh.adh01
                    NEXT FIELD adh01
                WHEN INFIELD(adh03)
                    #CALL q_gen(0,0,g_adh.adh03) RETURNING g_adh.adh03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adh.adh03
                    CALL cl_create_qry() RETURNING g_adh.adh03
                    DISPLAY BY NAME g_adh.adh03
                    NEXT FIELD adh03
                WHEN INFIELD(adh04)
                    #CALL q_gem(0,0,g_adh.adh04) RETURNING g_adh.adh04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_adh.adh04
                    CALL cl_create_qry() RETURNING g_adh.adh04
                    DISPLAY BY NAME g_adh.adh04
                    NEXT FIELD adh04
                OTHERWISE EXIT CASE
            END CASE

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                       # 欄位說明
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
END FUNCTION

FUNCTION t203_adh00()
    CASE g_adh.adh00
        WHEN '1' LET g_msg= cl_getmsg('axd-082',g_lang)
        WHEN '2' LET g_msg= cl_getmsg('axd-083',g_lang)
        WHEN '3' LET g_msg= cl_getmsg('axd-084',g_lang)
    END CASE
    DISPLAY g_msg TO FORMONLY.e
END FUNCTION

FUNCTION t203_adh03(p_cmd)                  #人員
 DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(01)
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti

  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
   WHERE gen01 = g_adh.adh03

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET g_adh.adh03 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION

FUNCTION t203_adh04(p_cmd)                 #部門
 DEFINE p_cmd       LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti

  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
                          WHERE gem01 = g_adh.adh04

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET g_adh.adh04 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION

FUNCTION t203_adh07()
    DEFINE l_str LIKE type_file.chr8   #No.FUN-680108 VARCHAR(08)

    CASE g_adh.adh07
         WHEN '0' CALL cl_getmsg('apy-558',g_lang) RETURNING l_str
         WHEN '1' CALL cl_getmsg('apy-559',g_lang) RETURNING l_str
         WHEN 'S' CALL cl_getmsg('apy-561',g_lang) RETURNING l_str
         WHEN 'R' CALL cl_getmsg('apy-562',g_lang) RETURNING l_str
         WHEN 'W' CALL cl_getmsg('apy-563',g_lang) RETURNING l_str
    END CASE
    DISPLAY l_str TO FORMONLY.desc
END FUNCTION

FUNCTION t203_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_adh.* TO NULL              #No.FUN-6A0165

    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_adi.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(GREEN)
    CALL t203_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Waiting...." ATTRIBUTE(REVERSE)
    OPEN t203_count
    FETCH t203_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t203_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
        INITIALIZE g_adh.* TO NULL
    ELSE
        CALL t203_t('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION t203_t(p_flag)
    DEFINE
        p_flag  LIKE type_file.chr1       #No.FUN-680108 VARCHAR(1)

    CASE p_flag
        WHEN 'N' FETCH NEXT     t203_cs INTO g_adh_rowid,g_adh.adh01
        WHEN 'P' FETCH PREVIOUS t203_cs INTO g_adh_rowid,g_adh.adh01
        WHEN 'F' FETCH FIRST    t203_cs INTO g_adh_rowid,g_adh.adh01
        WHEN 'L' FETCH LAST     t203_cs INTO g_adh_rowid,g_adh.adh01
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
          FETCH ABSOLUTE g_jump t203_cs INTO g_adh_rowid,g_adh.adh01
          LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_adh.* TO NULL   #No.TQC-6B0105
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

    SELECT * INTO g_adh.* FROM adh_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_adh_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
    ELSE
         LET g_data_owner=g_adh.adhuser           #FUN-4C0052權限控管
         LET g_data_group=g_adh.adhgrup
        CALL t203_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION t203_show()
    LET g_adh_t.* = g_adh.*
    DISPLAY BY NAME g_adh.adh00,g_adh.adh01,g_adh.adh02,g_adh.adh06,
                    g_adh.adh05,g_adh.adh03,g_adh.adh04,g_adh.adh07,
                    g_adh.adhmksg,g_adh.adhsign,g_adh.adhuser,g_adh.adhgrup,
                    g_adh.adhmodu,g_adh.adhdate,g_adh.adhacti,g_adh.adhconf,
                    g_adh.adhpost
     CALL cl_set_field_pic(g_adh.adhconf,"",g_adh.adhpost,"","",g_adh.adhacti)  #NO.MOD-4B0082
    CALL t203_adh00()
    CALL t203_adh03('d')
    CALL t203_adh04('d')
    CALL t203_adh07()
    CALL t203_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION t203_u()
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_adh.adh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_adh.* FROM adh_file WHERE adh01=g_adh.adh01
    IF g_adh.adhacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_adh.adh01,'mfg1000',0)
        RETURN
    END IF
    IF g_adh.adhconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_adh.adh01,'9022',0)
        RETURN
    END IF
    IF g_adh.adhpost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_adh.adh01,'afa-101',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_adh01_t = g_adh.adh01
    LET g_adh_t.* = g_adh.*
    LET g_adh_o.* = g_adh.*
    BEGIN WORK
    OPEN t203_cl USING g_adh_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t203_cl:", STATUS, 1)
       CLOSE t203_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t203_cl INTO g_adh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
       CLOSE t203_cl ROLLBACK WORK RETURN
    END IF
    LET g_adh.adhmodu=g_user                     #修改者
    LET g_adh.adhdate = g_today                  #修改日期
    CALL t203_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t203_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_adh.*=g_adh_t.*
            CALL t203_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_adh.adh01 != g_adh01_t THEN
            UPDATE adi_file SET adi01= g_adh.adh01
                    WHERE adi01 = g_adh01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err('update adi:',SQLCA.sqlcode,0)
               CONTINUE WHILE
            END IF
        END IF
        UPDATE adh_file SET adh_file.* = g_adh.*    # 更新DB
         WHERE ROWID = g_adh_rowid             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t203_cl
    COMMIT WORK
END FUNCTION

FUNCTION t203_x()
    DEFINE
        l_chr LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF
    IF g_adh.adh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_adh.adhconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_adh.adh01,'9022',0)
        RETURN
    END IF
    IF g_adh.adhpost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_adh.adh01,'afa-101',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t203_cl USING g_adh_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t203_cl:", STATUS, 1)
       CLOSE t203_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t203_cl INTO g_adh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t203_show()
    IF cl_exp(0,0,g_adh.adhacti) THEN
        LET g_chr=g_adh.adhacti
        IF g_adh.adhacti='Y' THEN
            LET g_adh.adhacti='N'
        ELSE
            LET g_adh.adhacti='Y'
        END IF
        UPDATE adh_file
            SET adhacti=g_adh.adhacti,
               adhmodu=g_user, adhdate=g_today
            WHERE ROWID=g_adh_rowid
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
            LET g_adh.adhacti=g_chr
        END IF
        DISPLAY BY NAME g_adh.adhacti ATTRIBUTE(RED)
    END IF
    CLOSE t203_cl
    COMMIT WORK
END FUNCTION

FUNCTION t203_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF
    IF g_adh.adh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_adh.adhconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_adh.adh01,'9022',0)
        RETURN
    END IF
    IF g_adh.adhpost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_adh.adh01,'afa-101',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t203_cl USING g_adh_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t203_cl:", STATUS, 1)
       CLOSE t203_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t203_cl INTO g_adh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t203_show()
    IF cl_delh(15,16) THEN
        DELETE FROM adh_file WHERE ROWID = g_adh_rowid
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
        ELSE
           DELETE FROM adi_file WHERE adi01=g_adh.adh01
           CLEAR FORM
           CALL g_adi.clear()
           OPEN t203_count
           FETCH t203_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN t203_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL t203_t('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL t203_t('/')
           END IF
        END IF
    END IF
    CLOSE t203_cl
    COMMIT WORK
END FUNCTION

#單身
FUNCTION t203_b()
DEFINE
    l_buf           LIKE adi_file.adi03,             #儲存尚在使用中之下游檔案之檔名  #No.FUN-680108 VARCHAR(80)
    l_ac_t          LIKE type_file.num5,             #未取消的ARRAY CNT   #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,             #檢查重複用   #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,             #單身鎖住否   #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,             #處理狀態     #No.FUN-680108 VARCHAR(1)
    l_bcur          LIKE type_file.chr1,             #'1':表存放位置有值,'2':則為NULL #No.FUN-680108 VARCHAR(01)
    l_adi10         LIKE adi_file.adi10,
    l_adi11         LIKE adi_file.adi11,
    l_adi12         LIKE adi_file.adi12,
    l_adi13         LIKE adi_file.adi13,
    l_adi14         LIKE adi_file.adi14,
    l_adg13         LIKE adg_file.adg13,
    l_adg14         LIKE adg_file.adg14,
    l_adg15         LIKE adg_file.adg15,
    l_adg16         LIKE adg_file.adg16,
    l_adg17         LIKE adg_file.adg17,
    l_adb06         LIKE adb_file.adb06,
    l_ime05         LIKE ime_file.ime05,
    l_ime06         LIKE ime_file.ime06,
    l_pmm09         LIKE pmm_file.pmm09,
    l_ade13         LIKE ade_file.ade13,
    l_img  RECORD   LIKE img_file.*,
    l_img_rowid     LIKE type_file.chr18,            # Prog. Version..: '5.10.00-08.01.04(03) # saki 20070821 rowid chr18 -> num10 
    l_allow_insert  LIKE type_file.num5,             #可新增否   #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5              #可刪除否   #No.FUN-680108 SMALLINT

    LET g_action_choice = " "

    IF s_shut(0) THEN RETURN END IF
    IF g_adh.adh01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_adh.* FROM adh_file WHERE adh01=g_adh.adh01
    IF g_adh.adhacti MATCHES'[Nn]' THEN
       CALL cl_err(g_adh.adh01,'mfg1000',0)
       RETURN
    END IF
    IF g_adh.adhconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_adh.adh01,'9022',0)
        RETURN
    END IF
    IF g_adh.adhpost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_adh.adh01,'afa-101',0)
        RETURN
    END IF

    CALL cl_opmsg('b')
    #No.FUN-580033  --begin
    LET g_forupd_sql = "SELECT adi02,adi03,adi04,adi15,adi16,adi05,'','',",
                       "       adi06,adi07,adi08,adi09,adi10,adi18,adi19,adi20,",
                       "       adi33,adi34,adi35,adi30,adi31,adi32",
                       "  FROM adi_file",
                       " WHERE adi02=?  AND adi01=?",
                       "   FOR UPDATE NOWAIT"
    #No.FUN-580033  --end
       DECLARE t203_bcl CURSOR FROM g_forupd_sql

#    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_adi WITHOUT DEFAULTS FROM s_adi.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           #No.FUN-550026 --start--
           CALL cl_set_docno_format("adi03")
           #No.FUN-550026 ---end---

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
            OPEN t203_cl USING g_adh_rowid
            IF STATUS THEN
               CALL cl_err("OPEN t203_cl:", STATUS, 1)
               CLOSE t203_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t203_cl INTO g_adh.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
                CLOSE t203_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_adi_t.* = g_adi[l_ac].*  #BACKUP
               OPEN t203_bcl USING g_adi_t.adi02,g_adh.adh01
               IF STATUS THEN
                  CALL cl_err("OPEN t203_bcl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t203_bcl INTO g_adi[l_ac].*,g_adi18,g_adi19,g_adi20
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_adi_t.adi02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
                  SELECT ima02,ima021 INTO g_adi[l_ac].ima02,g_adi[l_ac].ima021
                    FROM ima_file
                   WHERE ima01 = g_adi[l_ac].adi05
               END IF
               CALL t203_set_entry_b(p_cmd)
               CALL t203_set_no_entry_b(p_cmd)
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adi[l_ac].* TO NULL      #900423
            INITIALIZE g_adi18 TO NULL
            INITIALIZE g_adi19 TO NULL
            INITIALIZE g_adi20 TO NULL
            LET g_adi_t.* = g_adi[l_ac].*     #新輸入資料
            CALL t203_set_entry_b(p_cmd)
            CALL t203_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adi02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #No.FUN-580033  --begin
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_adi[l_ac].adi05)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD adi05
               END IF
               CALL t203_du_data_to_correct()
            END IF
            CALL t203_set_origin_field()
            LET l_adi11=l_adg13
            LET l_adi12=l_adg14
            CASE g_adh.adh00
                WHEN '2' SELECT adb06 INTO l_adb06 FROM adb_file
                          WHERE adb02=g_plant AND adb01=l_pmm09
                WHEN '3' SELECT adb06 INTO l_adb06 FROM adb_file
                          WHERE adb01=g_plant AND adb02=l_pmm09
            END CASE
            CASE l_adg13
                WHEN '1' LET l_adi13=l_adg15
                WHEN '2' LET l_adi13=l_adg15*l_adb06
                WHEN '4' LET l_adi13=l_adg15*l_adg14
                WHEN '3' LET l_adi13=l_adg15 LET l_adi14=l_adg16
            END CASE
            INSERT INTO adi_file(adi01,adi02,adi03,adi04,adi05,
                                 adi06,adi07,adi08,adi09,adi10,
                                 adi11,adi12,adi13,adi14,adi15,
                                 adi16,adi17,adi18,adi19,adi20,
                                 adi30,adi31,adi32,adi33,adi34,adi35)
            VALUES(g_adh.adh01,g_adi[l_ac].adi02,
                   g_adi[l_ac].adi03, g_adi[l_ac].adi04,
                   g_adi[l_ac].adi05, g_adi[l_ac].adi06,
                   g_adi[l_ac].adi07, g_adi[l_ac].adi08,
                   g_adi[l_ac].adi09, g_adi[l_ac].adi10,
                   l_adi11,l_adi12,   l_adi13,l_adi14,
                   g_adi[l_ac].adi15, g_adi[l_ac].adi16,
                   0,g_adi18,g_adi19,g_adi20,
                   g_adi[l_ac].adi30, g_adi[l_ac].adi31,
                   g_adi[l_ac].adi32, g_adi[l_ac].adi33,
                   g_adi[l_ac].adi34, g_adi[l_ac].adi35)
            #No.FUN-580033  --end
            IF SQLCA.SQLcode  THEN
                CALL cl_err(g_adi[l_ac].adi02,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                IF g_aza.aza40='Y' THEN  #NO.A112
                   IF g_adh.adh00<>'1' THEN   #銷售預測
                      CALL t203_m()
                   END IF
                END IF  #NO.A112
                COMMIT WORK
            END IF

        BEFORE FIELD adi02                        # dgeeault 序號
            IF g_adi[l_ac].adi02 IS NULL or g_adi[l_ac].adi02 = 0 THEN
                SELECT max(adi02)+1 INTO g_adi[l_ac].adi02 FROM adi_file
                    WHERE adi01 = g_adh.adh01
                IF g_adi[l_ac].adi02 IS NULL THEN
                    LET g_adi[l_ac].adi02 = 1
                END IF
            END IF
           #No.FUN-580033  --begin
           CALL t203_set_entry_b(p_cmd)
           CALL t203_set_no_required()
           #No.FUN-580033  --end

        AFTER FIELD adi02
            IF g_adi[l_ac].adi02 IS NOT NULL THEN
               IF g_adi[l_ac].adi02 != g_adi_t.adi02 OR
                  g_adi_t.adi02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM adi_file
                   WHERE adi01 = g_adh.adh01
                     AND adi02 = g_adi[l_ac].adi02
                  IF l_n > 0 THEN                     #避免數據重復
                     CALL cl_err(g_adi[l_ac].adi02,-239,0)
                     LET g_adi[l_ac].adi02 = g_adi_t.adi02
                     NEXT FIELD adi02
                  END IF
               END IF
            END IF

            IF g_adh.adh00 = '3' THEN
               IF cl_null(g_adi[l_ac].adi03) THEN
                  CALL q_ogb1(FALSE,FALSE,g_adi[l_ac].adi15,g_adi[l_ac].adi16,
                                 g_adi[l_ac].adi03,g_adi[l_ac].adi04)
                       RETURNING g_adi[l_ac].adi15,g_adi[l_ac].adi16,
                                 g_adi[l_ac].adi03,g_adi[l_ac].adi04,
                                 g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                                 g_adi[l_ac].adi09,g_adi[l_ac].adi10,
                                 g_adi18,g_adi19,g_adi20,l_adg13,l_adg14,
                  #No.FUN-580033  --begin
                                 l_adg15,l_adg16,l_pmm09,g_adi[l_ac].adi30,
                                 g_adi[l_ac].adi31,g_adi[l_ac].adi32,
                                 g_adi[l_ac].adi33,g_adi[l_ac].adi34,
                                 g_adi[l_ac].adi35
                  SELECT ima25,ima906 INTO g_ima25,g_ima906 FROM ima_file
                   WHERE ima01=g_adi[l_ac].adi05
                  #No.FUN-580033  --end

                  LET l_adi10 = g_adi[l_ac].adi10
                  SELECT ima02,ima021 INTO g_adi[l_ac].ima02,g_adi[l_ac].ima021
                    FROM ima_file WHERE ima01 = g_adi[l_ac].adi05
               END IF
            END IF
           #No.FUN-580033  --begin
           CALL t203_set_no_entry_b(p_cmd)
           CALL t203_set_required()
           #No.FUN-580033  --end

        BEFORE FIELD adi04
           #No.FUN-580033  --begin
           CALL t203_set_entry_b(p_cmd)
           CALL t203_set_no_required()
           #No.FUN-580033  --end

        AFTER FIELD adi04
            IF NOT cl_null(g_adi[l_ac].adi04) THEN
               CASE g_adh.adh00
               WHEN '1'
                  SELECT UNIQUE adg05,adg10,adg11,adg12,
                         #No.FUN-580033  --begin
                         adg13,adg14,adg15,adg16,adg17,adg18,adg19,adg20,ade13,
                         adg30,adg31,adg32,adg33,adg34,adg35
                    INTO g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                         g_adi[l_ac].adi09,l_adi10,
                         l_adg13,l_adg14,l_adg15,l_adg16,l_adg17,
                         g_adi18,g_adi19,g_adi20,l_ade13,
                         g_adi[l_ac].adi30,g_adi[l_ac].adi31,
                         g_adi[l_ac].adi32,g_adi[l_ac].adi33,
                         g_adi[l_ac].adi34,g_adi[l_ac].adi35
                         #No.FUN-580033  --end
                    FROM adg_file,adf_file,add_file,ade_file
                   WHERE adg01 = adf01 AND adfacti = 'Y'    #撥出單有效
                     AND adf10 = '1'   AND adfconf = 'Y'    #已核准（已審核）
                     AND adfpost = 'Y'                      #已過帳
                     AND add01 = ade01                      #撥出申請單
                     AND ade01 = adg03 AND ade02 = adg04    #撥出單與申請單join
                     AND add07 = 'N' AND addacti = 'Y'      #未結案，有效
                     AND adg01 = g_adi[l_ac].adi03
                     AND adg02 = g_adi[l_ac].adi04
                  IF SQLCA.sqlcode THEN                     #找不到滿足條件
                     CALL cl_err('',SQLCA.sqlcode,0)        #的撥出單及項次
                     LET g_adi[l_ac].adi03 = g_adi_t.adi03
                     LET g_adi[l_ac].adi04 = g_adi_t.adi04
                     NEXT FIELD adi03
                  ELSE IF l_ade13='Y' THEN
                          CALL cl_err('','9004',0)
                          NEXT FIELD adi03
                       END IF
                  END IF
               WHEN '2'
                  #   采購單號 項次  料件  倉庫  單位 采購量 工廠
                  #No.FUN-580033  --begin
                  SELECT pmn01,pmn02,pmn04,pmn52,pmn07,pmn20,pmm09, #join采購單
                         pmn80,pmn81,pmn82,pmn83,pmn84,pmn85
                    INTO g_adi[l_ac].adi15,g_adi[l_ac].adi16,g_adi[l_ac].adi05,
                         g_adi[l_ac].adi06,g_adi[l_ac].adi09,l_adi10,l_pmm09,
                         g_adi[l_ac].adi30,g_adi[l_ac].adi31,g_adi[l_ac].adi32,
                         g_adi[l_ac].adi33,g_adi[l_ac].adi34,g_adi[l_ac].adi35
                  #No.FUN-580033  --end
                    FROM pmm_file,pmn_file
                   WHERE pmm01 = pmn01 AND pmm02 = 'ICT'
                     AND pmn24 = g_adi[l_ac].adi03
                     AND pmn25 = g_adi[l_ac].adi04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('','axd-029',0)
                     NEXT FIELD adi03
                  END IF
                  SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = l_pmm09
                  LET g_sql = " SELECT UNIQUE adg13,adg14,adg15,adg16,",
                              "        adg17,adg18,adg19,adg20,ade13 ",
                              "   FROM ",p_dbs,".adf_file,",p_dbs,".adg_file,",
                                         p_dbs,".add_file,",p_dbs,".ade_file",
                              "  WHERE adf01 = adg01 AND adfconf = 'Y' ",   #撥出單，已審核
                              "    AND adf10 = '1'   AND adfpost = 'Y' ",   #已核准，已過帳
                              "    AND adfacti = 'Y' ",                     #有效
                              "    AND adg03 = ade01 AND adg04 = ade02 ",   #撥出單和撥出申請單join
                              "    AND adf00 = add00 ",                     #
                              "    AND add01 = ade01 AND addacti = 'Y' ",   #撥出申請單有效
                              "    AND addconf = 'Y' AND add06 = '1'   ",   #已審核（已核准）
                              "    AND add07 = 'N'   ",
                              "    AND adg01 = '",g_adi[l_ac].adi03,"' AND adg02 = '",g_adi[l_ac].adi04,"'"  #撥出單和采購單join
                  PREPARE t203_prepare3 FROM g_sql
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,0)
                     NEXT FIELD adi03
                  END IF
                  DECLARE t203_curs3 SCROLL CURSOR FOR t203_prepare3
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,0)
                     NEXT FIELD adi03
                  END IF
                  OPEN t203_curs3
                  FETCH t203_curs3 INTO l_adg13,l_adg14,l_adg15,
                        l_adg16,l_adg17,g_adi18,g_adi19,g_adi20,l_ade13
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('','axd-030',0)
                     NEXT FIELD adi03
                  ELSE IF l_ade13='Y' THEN
                          CALL cl_err('','9004',0)
                          NEXT FIELD adi03
                       END IF
                  END IF
               END CASE
               #No.FUN-580033  --begin
               SELECT ima02,ima021,ima906,ima25
                 INTO g_adi[l_ac].ima02,g_adi[l_ac].ima021,g_ima906,g_ima25
                 FROM ima_file
                WHERE ima01 = g_adi[l_ac].adi05
               IF cl_null(l_adg17) THEN LET l_adg17=0 END IF
               LET l_adi10=l_adi10-l_adg17    #未撥入數量
               IF cl_null(g_adi[l_ac].adi10) OR g_adi[l_ac].adi03 <> g_adi_t.adi03
                  OR g_adi[l_ac].adi04 <> g_adi_t.adi04 THEN
                  LET g_adi[l_ac].adi10 = l_adi10
               END IF
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_adi[l_ac].adi05
               DISPLAY BY NAME g_adi[l_ac].adi06
               DISPLAY BY NAME g_adi[l_ac].adi09
               DISPLAY BY NAME g_adi[l_ac].adi15
               DISPLAY BY NAME g_adi[l_ac].adi16
               DISPLAY BY NAME g_adi[l_ac].ima02
               DISPLAY BY NAME g_adi[l_ac].ima021
               DISPLAY BY NAME g_adi[l_ac].adi10
               #------MOD-5A0095 END------------
               IF NOT cl_null(g_adi[l_ac].adi33) THEN
                  LET g_factor=1
                  CALL s_umfchk(g_adi[l_ac].adi05,g_adi[l_ac].adi33,g_ima25)
                       RETURNING g_cnt,g_factor
                  LET g_adi[l_ac].adi34=g_factor
               END IF
               IF NOT cl_null(g_adi[l_ac].adi30) THEN
                  LET g_factor=1
                  CALL s_umfchk(g_adi[l_ac].adi05,g_adi[l_ac].adi30,g_ima25)
                       RETURNING g_cnt,g_factor
                  LET g_adi[l_ac].adi31=g_factor
               END IF
               #No.FUN-580033  --end
            END IF
           #No.FUN-580033  --begin
           CALL t203_set_no_entry_b(p_cmd)
           CALL t203_set_required()
           #No.FUN-580033  --end

        AFTER FIELD adi16
            IF NOT cl_null(g_adi[l_ac].adi16) THEN
               IF g_adh.adh00 = '2' THEN
                  SELECT * FROM pmn_file,pmm_file
                   WHERE pmn01 = pmm01 AND pmm02 = 'ICT'
                     AND pmn01 = g_adi[l_ac].adi15 AND pmn02 = g_adi[l_ac].adi16
                     AND pmn24 = g_adi[l_ac].adi03 AND pmn25 = g_adi[l_ac].adi04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_adi[l_ac].adi15,'axd-073',0)
                     NEXT FIELD adi03
                  END IF
               END IF
            END IF

        AFTER FIELD adi07
           IF cl_null(g_adi[l_ac].adi07) THEN LET g_adi[l_ac].adi07 = ' ' END IF
            SELECT ime05,ime06 INTO l_ime05,l_ime06 FROM ime_file
             WHERE ime01 = g_adi[l_ac].adi06
               AND ime02 = g_adi[l_ac].adi07
            IF l_ime05 = 'N' THEN
               CALL cl_err(g_adi[l_ac].adi07,'mfg6081',0)
            END IF
            IF l_ime06 = 'N' THEN
               CALL cl_err(g_adi[l_ac].adi07,'mfg6086',0)
            END IF

        AFTER FIELD adi08
           IF cl_null(g_adi[l_ac].adi08) THEN LET g_adi[l_ac].adi08 = ' ' END IF
            SELECT * INTO l_img.*
              FROM img_file
             WHERE img01 = g_adi[l_ac].adi05
               AND img02 = g_adi[l_ac].adi06
               AND img03 = g_adi[l_ac].adi07
               AND img04 = g_adi[l_ac].adi08
            IF SQLCA.sqlcode THEN
               IF NOT cl_confirm('mfg1401') THEN NEXT FIELD adi15 END IF
                  CALL s_add_img(g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                                 g_adi[l_ac].adi07,g_adi[l_ac].adi08,
                                 g_adh.adh01      ,g_adi[l_ac].adi02,
                                 g_adh.adh02)
               IF g_errno='N' THEN NEXT FIELD adi05 END IF
            END IF
            IF NOT s_actimg(l_img.img01,l_img.img02,l_img.img03,l_img.img04) THEN
               CALL cl_err('','axd-027',0)
               NEXT FIELD adi08
            END IF

       AFTER FIELD adi10
           IF g_adi[l_ac].adi10 < 1 THEN NEXT FIELD adi10 END IF
           IF g_adi[l_ac].adi10 > l_adi10 THEN
              CALL cl_err(g_adi[l_ac].adi10,'axd-069',0)
              NEXT FIELD adi10
           END IF

       #No.FUN-580033  --begin
       BEFORE FIELD adi35  #第二單位
          IF cl_null(g_adi[l_ac].adi05) THEN NEXT FIELD adi05 END IF
          IF g_adi[l_ac].adi06 IS NULL OR g_adi[l_ac].adi07 IS NULL OR
             g_adi[l_ac].adi08 IS NULL THEN
             NEXT FIELD adi07
          END IF
          IF NOT cl_null(g_adi[l_ac].adi33) THEN
             CALL t203_unit(g_adi[l_ac].adi33)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD adi04
             END IF
             CALL s_chk_imgg(g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                             g_adi[l_ac].adi07,g_adi[l_ac].adi08,
                             g_adi[l_ac].adi33) RETURNING g_flag
             IF g_flag = 1 THEN
                IF g_sma.sma892[3,3] = 'Y' THEN
                   IF NOT cl_confirm('aim-995') THEN
                      NEXT FIELD adi04
                   END IF
                END IF
                CALL s_add_imgg(g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                                g_adi[l_ac].adi07,g_adi[l_ac].adi08,
                                g_adi[l_ac].adi33,g_adi[l_ac].adi34,
                                g_adh.adh01,
                                g_adi[l_ac].adi02,0) RETURNING g_flag
                IF g_flag = 1 THEN
                   NEXT FIELD adi04
                END IF
             END IF
          END IF

       AFTER FIELD adi35  #第二數量
          IF NOT cl_null(g_adi[l_ac].adi35) THEN
             IF g_adi[l_ac].adi35 < 0 THEN
                CALL cl_err('','aim-391',0)  #
                NEXT FIELD adi35
             END IF
             IF p_cmd = 'a' THEN
                IF g_ima906='3' THEN
                   LET g_tot=g_adi[l_ac].adi35*g_adi[l_ac].adi34
                   IF cl_null(g_adi[l_ac].adi32) OR g_adi[l_ac].adi32=0 THEN
                      LET g_adi[l_ac].adi32=g_tot*g_adi[l_ac].adi31
                   END IF
                END IF
             END IF
          END IF
          CALL cl_show_fld_cont()                   #No:FUN-560197

       BEFORE FIELD adi32  #第二單位
          IF cl_null(g_adi[l_ac].adi05) THEN NEXT FIELD adi05 END IF
          IF g_adi[l_ac].adi06 IS NULL OR g_adi[l_ac].adi07 IS NULL OR
             g_adi[l_ac].adi08 IS NULL THEN
             NEXT FIELD adi07
          END IF
          IF NOT cl_null(g_adi[l_ac].adi30) THEN
             CALL t203_unit(g_adi[l_ac].adi30)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD adi04
             END IF
             IF g_ima906 ='2' THEN
                CALL s_chk_imgg(g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                                g_adi[l_ac].adi07,g_adi[l_ac].adi08,
                                g_adi[l_ac].adi30) RETURNING g_flag
                IF g_flag = 1 THEN
                   IF g_sma.sma892[3,3] = 'Y' THEN
                      IF NOT cl_confirm('aim-995') THEN
                         NEXT FIELD adi04
                      END IF
                   END IF
                   CALL s_add_imgg(g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                                   g_adi[l_ac].adi07,g_adi[l_ac].adi08,
                                   g_adi[l_ac].adi30,g_adi[l_ac].adi31,
                                   g_adh.adh01,
                                   g_adi[l_ac].adi02,0) RETURNING g_flag
                   IF g_flag = 1 THEN
                      NEXT FIELD adi04
                   END IF
                END IF
             END IF
          END IF

       AFTER FIELD adi32  #第一數量
          IF NOT cl_null(g_adi[l_ac].adi32) THEN
             IF g_adi[l_ac].adi32 < 0 THEN
                CALL cl_err('','aim-391',0)  #
                NEXT FIELD adi32
             END IF
          END IF
          CALL t203_du_data_to_correct()
          CALL t203_set_origin_field()
          IF g_adi[l_ac].adi10 < 1 THEN NEXT FIELD adi10 END IF
          IF g_adi[l_ac].adi10 > l_adi10 THEN
             CALL cl_err(g_adi[l_ac].adi10,'axd-069',0)
             NEXT FIELD adi10
          END IF
       #NO.FUN-580033  --end

       BEFORE DELETE                            #是否取消單身
            IF g_adi_t.adi02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
               IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM adi_file
                    WHERE adi01=g_adh.adh01 AND adi02 = g_adi_t.adi02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adi_t.adi02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_adi[l_ac].* = g_adi_t.*
               CLOSE t203_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adi[l_ac].adi02,-263,1)
               LET g_adi[l_ac].* = g_adi_t.*
            ELSE
               #No.FUN-580033  --begin
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_adi[l_ac].adi05)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD adi04
                  END IF
                  CALL t203_du_data_to_correct()
               END IF
               CALL t203_set_origin_field()
               LET l_adi11=l_adg13
               LET l_adi12=l_adg14
               CASE g_adh.adh00
                   WHEN '2' SELECT adb06 INTO l_adb06 FROM adb_file
                             WHERE adb02=g_plant AND adb01=l_pmm09
                   WHEN '3' SELECT adb06 INTO l_adb06 FROM adb_file
                             WHERE adb01=g_plant AND adb02=l_pmm09
               END CASE
               CASE l_adg13
                   WHEN '1' LET l_adi13=l_adg15
                   WHEN '2' LET l_adi13=l_adg15*l_adb06
                   WHEN '4' LET l_adi13=l_adg15*l_adg14
                   WHEN '3' LET l_adi13=l_adg15 LET l_adi14=l_adg16
               END CASE
               UPDATE adi_file
                  SET adi02=g_adi[l_ac].adi02,adi03=g_adi[l_ac].adi03,
                      adi04=g_adi[l_ac].adi04,adi05=g_adi[l_ac].adi05,
                      adi06=g_adi[l_ac].adi06,adi07=g_adi[l_ac].adi07,
                      adi08=g_adi[l_ac].adi08,adi09=g_adi[l_ac].adi09,
                      adi10=g_adi[l_ac].adi10,adi11=l_adi11,
                      adi12=l_adi12,adi13=l_adi13,adi14=l_adi14,
                      adi15=g_adi[l_ac].adi15,adi16=g_adi[l_ac].adi16,
                      adi18=g_adi18,adi19=g_adi19,adi20=g_adi20,
                      adi30=g_adi[l_ac].adi30,adi31=g_adi[l_ac].adi31,
                      adi32=g_adi[l_ac].adi32,adi33=g_adi[l_ac].adi33,
                      adi34=g_adi[l_ac].adi34,adi35=g_adi[l_ac].adi35
                   WHERE CURRENT OF t203_bcl
              #No.FUN-580033  --end
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adi[l_ac].adi02,SQLCA.sqlcode,0)
                  LET g_adi[l_ac].* = g_adi_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  IF g_aza.aza40='Y' THEN  #NO.A112
                     IF g_adh.adh00<>'1' THEN   #銷售預測
                        CALL t203_m()
                     END IF
                  END IF  #NO.A112
                  CLOSE t203_bcl
                  COMMIT WORK
              END IF
           END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_adi[l_ac].* = g_adi_t.*
              END IF
              CLOSE t203_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t203_bcl
           COMMIT WORK

        ON ACTION CONTROLN
            CALL t203_b_askkey()
            EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(adi02) AND l_ac > 1 THEN
                LET g_adi[l_ac].* = g_adi[l_ac-1].*
                NEXT FIELD adi02
            END IF
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adi03)
                    CASE g_adh.adh00
                       WHEN '1'
                          CALL q_adg(FALSE,FALSE,g_adi[l_ac].adi03,g_adi[l_ac].adi04,'1')
                               RETURNING g_adi[l_ac].adi03,g_adi[l_ac].adi04
                       WHEN '2'
                          CALL q_pmn4(FALSE,FALSE,g_adi[l_ac].adi03,g_adi[l_ac].adi04,
                                         g_adi[l_ac].adi15,g_adi[l_ac].adi16)
                               RETURNING g_adi[l_ac].adi03,g_adi[l_ac].adi04,
                                         g_adi[l_ac].adi15,g_adi[l_ac].adi16
                    END CASE
                    NEXT FIELD adi03

                WHEN INFIELD(adi07)
                    #CALL q_ime(0,0,g_adi[l_ac].adi07,g_adi[l_ac].adi06,'S')
                    #     RETURNING g_adi[l_ac].adi07
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ime"
                    LET g_qryparam.default1 = g_adi[l_ac].adi07
                     LET g_qryparam.arg1 = g_adi[l_ac].adi06 #倉庫編號 #MOD-4A0063
                     LET g_qryparam.arg2     = 'S'          #倉庫類別 #MOD-4A0063
                   #LET g_qryparam.where = " ime04='S'"
                    CALL cl_create_qry() RETURNING g_adi[l_ac].adi07
                    NEXT FIELD adi07
                WHEN INFIELD(adi08)
                    #CALL q_img(0,0,g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                    #           g_adi[l_ac].adi07,g_adi[l_ac].adi08,'A')
                    #     RETURNING g_adi[l_ac].adi06,g_adi[l_ac].adi07,
                    #               g_adi[l_ac].adi08
                    LET g_qryparam.form ="q_img7"
                    LET g_qryparam.default1 = g_adi[l_ac].adi06
                    LET g_qryparam.default2 = g_adi[l_ac].adi07
                    LET g_qryparam.default3 = g_adi[l_ac].adi08
                    IF g_adi[l_ac].adi06 IS NOT NULL THEN
                       LET g_qryparam.where=" img02='",g_adi[l_ac].adi06,"'"
                    END IF
                    IF g_adi[l_ac].adi07 IS NOT NULL THEN
                       LET g_qryparam.where=" img03='",g_adi[l_ac].adi07,"'"
                    END IF
                    CALL cl_create_qry() RETURNING g_adi[l_ac].adi06,
                         g_adi[l_ac].adi07,g_adi[l_ac].adi08
                    NEXT FIELD adi08
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
 
        END INPUT

    #FUN-5B0113-begin
     LET g_adh.adhmodu = g_user
     LET g_adh.adhdate = g_today
     UPDATE adh_file SET adhmodu = g_adh.adhmodu,adhdate = g_adh.adhdate
      WHERE adh01 = g_adh.adh01
     IF SQLCA.SQLCODE OR STATUS = 100 THEN
        CALL cl_err('upd adh',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_adh.adhmodu,g_adh.adhdate
    #FUN-5B0113-end

    CLOSE t203_bcl
    COMMIT WORK
#    CALL t203_delall()
END FUNCTION

FUNCTION t203_delall()
    SELECT COUNT(*) INTO g_cnt FROM adi_file
        WHERE adi01 = g_adh.adh01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM adh_file WHERE adh01 = g_adh.adh01
    END IF
END FUNCTION

FUNCTION t203_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000    #No.FUN-680108 VARCHAR(200)

    #No.FUN-580033  --begin
    CONSTRUCT l_wc ON adi02,adi03,adid04,adi15,adi16,adi05,  #螢幕上取單身條件
                      adi06,adi07,adi08,adi09,adi10,adi33,
                      adi35,adi30,adi32
       FROM s_adi[1].adi02,s_adi[1].adi03,s_adi[1].adi04,
            s_adi[1].adi15,s_adi[1].adi16,s_adi[1].adi05,
            s_adi[1].adi06,s_adi[1].adi07,s_adi[1].adi08,
            s_adi[1].adi09,s_adi[1].adi10,s_adi[1].adi33,
            s_adi[1].adi35,s_adi[1].adi30,s_adi[1].adi32
    #No.FUN-580033  --end

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(adi03)
                 CASE g_adh.adh00
                    WHEN '1'
                       CALL q_adg(TRUE,FALSE,g_adi[l_ac].adi03,
                                  g_adi[l_ac].adi04,'1')
                            RETURNING g_qryparam.multiret
                    WHEN '2'
                       CALL q_pmn4(FALSE,TRUE,g_adi[l_ac].adi03,g_adi[l_ac].adi04,
                                      g_adi[l_ac].adi15,g_adi[l_ac].adi16)
                            RETURNING g_qryparam.multiret
                 END CASE
                 DISPLAY g_qryparam.multiret TO s_adi[1].adi03
                 NEXT FIELD adi03

              WHEN INFIELD(adi07)
                 #CALL q_ime(0,0,g_adi[l_ac].adi07,g_adi[l_ac].adi06,'S')
                 #     RETURNING g_adi[l_ac].adi07
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ime"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_adi[1].adi07
                 NEXT FIELD adi07
              WHEN INFIELD(adi08)
                 #CALL q_img(0,0,g_adi[l_ac].adi05,g_adi[l_ac].adi06,
                 #           g_adi[l_ac].adi07,g_adi[l_ac].adi08,'A')
                 #     RETURNING g_adi[l_ac].adi06,g_adi[l_ac].adi07,
                 #               g_adi[l_ac].adi08
                 LET g_qryparam.form ="q_img7"
                 LET g_qryparam.state = "c"
                 IF g_adi[l_ac].adi06 IS NOT NULL THEN
                    LET g_qryparam.where=" img02='",g_adi[l_ac].adi06,"'"
                 END IF
                 IF g_adi[l_ac].adi07 IS NOT NULL THEN
                    LET g_qryparam.where=" img03='",g_adi[l_ac].adi07,"'"
                 END IF
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_adi[1].adi08
                 NEXT FIELD adi08
              #No.FUN-580033  --begin
              WHEN INFIELD(adi33)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO adi33
                 NEXT FIELD adi33
              WHEN INFIELD(adi30)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO adi30
                 NEXT FIELD adi30
              #No.FUN-580033  --end
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
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    CALL t203_b_fill(l_wc)
END FUNCTION

FUNCTION t203_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc  LIKE type_file.chr1000        #No.FUN-680108 VARCHAR(400)

    #No.FUN-580033  --begin
    LET g_sql =
    "SELECT adi02,adi03,adi04,adi15,adi16,adi05,ima02,ima021,",
       "       adi06,adi07,adi08,adi09,adi10,adi33,adi34,adi35, ",
       "       adi30,adi31,adi32 ",
       " FROM adi_file,OUTER ima_file",
       " WHERE adi01 = '",g_adh.adh01,"' AND ",p_wc CLIPPED ,
       "   AND ima_file.ima01 = adi05 ",
       " ORDER BY adi02"
    #No.FUN-580033  --end
    PREPARE t203_prepare2 FROM g_sql      #預備一下
    DECLARE adi_cs CURSOR FOR t203_prepare2

    CALL g_adi.clear()

    LET g_cnt = 1
    FOREACH adi_cs INTO g_adi[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adi.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t203_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1      #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adi TO s_adi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
         CALL t203_t('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION previous
         CALL t203_t('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION jump
         CALL t203_t('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION next
         CALL t203_t('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION last
         CALL t203_t('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         CALL t203_mu_ui()   #FUN-610006
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      #@ON ACTION 簽核狀況
      #ON ACTION btn01                               #MOD-560158
     #   LET g_action_choice="btn01"
     #   EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION related_document                #No:FUN-6A0165  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION


FUNCTION t203_copy()
DEFINE
    l_newno         LIKE adh_file.adh01,
    l_oldno         LIKE adh_file.adh01,
    li_result       LIKE type_file.num5     #No:FUN-560014   #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_adh.adh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_adh.adh00 = '1' THEN LET g_type = '16' END IF
    IF g_adh.adh00 = '2' THEN LET g_type = '17' END IF
    IF g_adh.adh00 = '3' THEN LET g_type = '18' END IF

    LET g_before_input_done = FALSE
    CALL t203_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno FROM adh01
#No.FUN-560014-begin
        BEFORE INPUT
           CALL cl_set_docno_format("adh01")
#No.FUN-560014-end

        AFTER FIELD adh01
            IF l_newno IS NULL THEN
                NEXT FIELD adh01
            END IF
#No.FUN-560014-begin
            LET g_t1 = s_get_doc_no(l_newno)
            CALL s_check_no("axd",l_newno,"",g_type,"adh_file","adh01","")
                 RETURNING li_result,l_newno
            DISPLAY l_newno TO adh01
            IF (NOT li_result) THEN
               NEXT FIELD adh01
            END IF
#           SELECT * INTO g_adz.* FROM adz_file WHERE adzslip = g_t1
#              AND adztype = g_type
#           IF SQLCA.sqlcode THEN
#              CALL cl_err(l_newno,'mfg0014',0)
#              NEXT FIELD adh01
#           END IF
            BEGIN WORK
            CALL s_auto_assign_no("axd",l_newno,g_adh.adh02,g_type,"adh_file","adh01","","","")
              RETURNING li_result,l_newno
            IF (NOT li_result) THEN
                NEXT FIELD adh01
            END IF
#            IF cl_null(l_newno[5,10]) AND g_adz.adzauno='N'
#               THEN NEXT FIELD adh01
#            END IF
#            IF g_adz.adzauno='Y' THEN   #need modify to add adh_file in it
#               CALL s_axdauno(l_newno,g_adh.adh02) RETURNING g_i,l_newno
#               IF g_i THEN #有問題
#                 NEXT FIELD adh01
#               END IF
#               DISPLAY l_newno TO adh01
#            END IF
#No.FUN-560014-end

            SELECT count(*) INTO g_cnt FROM adh_file
                WHERE adh01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD adh01
            END IF
#No.FUN-560014-end

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adh01)        #need modify
                    LET g_t1=s_get_doc_no(l_newno)   #No.FUN-560014
                    CASE g_adh.adh00
                       WHEN 1
                          #CALL q_adz(FALSE,FALSE,g_t1,'16','axd') RETURNING g_t1  #TQC-670008
                           CALL q_adz(FALSE,FALSE,g_t1,'16','AXD') RETURNING g_t1  #TQC-670008
                       WHEN 2
                          #CALL q_adz(FALSE,FALSE,g_t1,'17','axd') RETURNING g_t1  #TQC-670008
                           CALL q_adz(FALSE,FALSE,g_t1,'17','AXD') RETURNING g_t1  #TQC-670008
                       WHEN 3
                          #CALL q_adz(FALSE,FALSE,g_t1,'18','axd') RETURNING g_t1  #TQC-670008
                           CALL q_adz(FALSE,FALSE,g_t1,'18','AXD') RETURNING g_t1  #TQC-670008
                    END CASE
                    LET l_newno=g_t1                 #No:FUN-560014
                    DISPLAY l_newno TO adh01
                    NEXT FIELD adh01
           END CASE
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        ROLLBACK WORK           #No.FUN-560014
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM adh_file
        WHERE adh01=g_adh.adh01
        INTO TEMP y
    UPDATE y
        SET y.adh01=l_newno,    #資料鍵值
            y.adhuser = g_user,
            y.adhgrup = g_grup,
            y.adhdate = g_today,
            y.adhacti = 'Y',
            y.adhconf = 'N',
            y.adhpost = 'N'
    INSERT INTO adh_file  #複製單頭
        SELECT * FROM y
#No.FUN-560014-begin
    IF SQLCA.sqlcode THEN
        CALL  cl_err(l_newno,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
#No.FUN-560014-end
    DROP TABLE x
    SELECT * FROM adi_file
       WHERE adi01 = g_adh.adh01
       INTO TEMP x
    UPDATE x
       SET adi01 = l_newno
    INSERT INTO adi_file    #複製單身
       SELECT * FROM x
#No.FUN-560014-begin
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_newno,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
#No.FUN-560014-end
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno = g_adh.adh01
        SELECT ROWID,adh_file.* INTO g_adh_rowid,g_adh.* FROM adh_file
               WHERE adh01 =  l_newno
        CALL t203_u()
        CALL t203_show()
        LET g_adh.adh01 = l_oldno
        SELECT ROWID,adh_file.* INTO g_adh_rowid,g_adh.* FROM adh_file
               WHERE adh01 = g_adh.adh01
        CALL t203_show()
    END IF
    DISPLAY BY NAME g_adh.adh01
END FUNCTION

FUNCTION t203_y() #確認
    IF g_adh.adh01 IS NULL THEN RETURN END IF
    SELECT * INTO g_adh.* FROM adh_file WHERE adh01=g_adh.adh01
    IF g_adh.adhacti='N' THEN
       CALL cl_err(g_adh.adh01,'mfg1000',0)
       RETURN
    END IF
    IF g_adh.adhconf='Y' THEN RETURN END IF
    IF g_adh.adhpost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK

    OPEN t203_cl USING g_adh_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t203_cl:", STATUS, 1)
       CLOSE t203_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t203_cl INTO g_adh.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
        CLOSE t203_cl
        ROLLBACK WORK
        RETURN
    END IF

    UPDATE adh_file SET adhconf='Y',adh07 = '1'
     WHERE adh01 = g_adh.adh01
    IF STATUS THEN
       CALL cl_err('upd adhconf',STATUS,0)
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT adhconf,adh07 INTO g_adh.adhconf,g_adh.adh07 FROM adh_file
     WHERE adh01 = g_adh.adh01
    DISPLAY BY NAME g_adh.adhconf
    DISPLAY BY NAME g_adh.adh07
    CALL t203_adh07()
END FUNCTION

FUNCTION t203_w() #取消確認
    IF g_adh.adh01 IS NULL THEN RETURN END IF
    SELECT * INTO g_adh.* FROM adh_file WHERE adh01=g_adh.adh01
    IF g_adh.adhconf='N' THEN RETURN END IF
    IF g_adh.adhpost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK
    OPEN t203_cl USING g_adh_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t203_cl:", STATUS, 1)
       CLOSE t203_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t203_cl INTO g_adh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
        CLOSE t203_cl
        ROLLBACK WORK
        RETURN
    END IF
    UPDATE adh_file SET adhconf='N',adh07='0'
        WHERE adh01 = g_adh.adh01
    IF STATUS THEN
        CALL cl_err('upd cofconf',STATUS,0)
        LET g_success='N'
    END IF
    IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_cmmsg(1)
    ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(1)
    END IF
    SELECT adhconf,adh07 INTO g_adh.adhconf,g_adh.adh07 FROM adh_file
        WHERE adh01 = g_adh.adh01
    DISPLAY BY NAME g_adh.adhconf
    DISPLAY BY NAME g_adh.adh07
    CALL t203_adh07()
END FUNCTION

FUNCTION t203_s()
DEFINE l_cnt  LIKE type_file.num10      #No.FUN-680108 INTEGER
   IF s_shut(0) THEN RETURN END IF
   IF g_adh.adh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_adh.* FROM adh_file WHERE adh01=g_adh.adh01

   IF g_adh.adhacti='N' THEN
      CALL cl_err(g_adh.adh01,'mfg1000',0)
      RETURN
   END IF
   IF g_adh.adhpost = 'Y' THEN                       #若已扣帳,不可扣帳
      CALL cl_err('',9023,0) RETURN
   END IF
   IF g_adh.adhconf = 'N' THEN                       #未確認者,不可扣帳
      CALL cl_err('','mfg3550',0) RETURN
   END IF

   #單據日期需大于目前會計年度sma51,會計期別sma52
   IF YEAR(g_adh.adh02)*12+MONTH(g_adh.adh02)<g_sma.sma51*12+g_sma.sma52 THEN
      CALL cl_err(g_adh.adh02,'axd-024',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM adi_file WHERE adi01=g_adh.adh01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   IF NOT cl_confirm('mfg0176') THEN RETURN END IF

   BEGIN WORK LET g_success = 'Y'

    OPEN t203_cl USING g_adh_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t203_cl:", STATUS, 1)
       CLOSE t203_cl
       ROLLBACK WORK
       RETURN
    END IF
   FETCH t203_cl INTO g_adh.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t203_cl ROLLBACK WORK RETURN
   END IF


   CALL t203_ss()

#   INPUT BY NAME g_adh.adh06 WITHOUT DEFAULTS HELP 1
#       AFTER FIELD adh06
#           IF cl_null(g_adh.adh06) THEN
#              NEXT FIELD adh06
#           END IF
#   END INPUT

   IF g_success = 'Y' THEN                      #庫存扣賬成功
      UPDATE adh_file SET adhpost='Y',adh06=g_adh.adh06 WHERE adh01=g_adh.adh01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd adhpost: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK RETURN
      END IF
      LET g_adh.adhpost='Y'
      DISPLAY BY NAME g_adh.adhpost ATTRIBUTE(REVERSE)
      DISPLAY BY NAME g_adh.adh06   ATTRIBUTE(REVERSE)
      COMMIT WORK
   ELSE
      LET g_adh.adhpost='N'
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION

FUNCTION t203_ss()
   IF g_adh.adh00 <> '3' THEN
      CALL t203_y1()
   ELSE
      CALL t203_y1_3()
   END IF
   IF g_success='N' THEN RETURN END IF

END FUNCTION

FUNCTION t203_y1()
  DEFINE b_adi RECORD
               pmm09  LIKE pmm_file.pmm09,   #撥出工廠
               adi02  LIKE adi_file.adi02,   #撥入項次
               adi03  LIKE adi_file.adi03,   #撥出單號
               adi04  LIKE adi_file.adi04,   #撥出項次
               adi15  LIKE adi_file.adi15,   #采購單號
               adi16  LIKE adi_file.adi16,   #采購項次
               adi05  LIKE adi_file.adi05,   #料件編號
               adi06  LIKE adi_file.adi06,   #倉庫
               adi07  LIKE adi_file.adi07,   #儲位
               adi08  LIKE adi_file.adi08,   #批號
               adi09  LIKE adi_file.adi09,   #單位
               #No.FUN-580033  --begin
               adi10  LIKE adi_file.adi10,   #撥入數量
               adi33  LIKE adi_file.adi33,   #單位二
               adi34  LIKE adi_file.adi34,   #單位二轉換率
               adi35  LIKE adi_file.adi35,   #單位二數量
               adi30  LIKE adi_file.adi30,   #單位一
               adi31  LIKE adi_file.adi31,   #單位一轉換率
               adi32  LIKE adi_file.adi32    #單位一數量
               #No.FUN-580033  --end
               END RECORD,
          l_pmm09 LIKE pmm_file.pmm09

  #對于adi中的每一筆都要insert到adq_file中
  #No.FUN-580033  --begin
  DECLARE t203_y1_c1 CURSOR FOR
   SELECT pmm09,adi02,adi03,adi04,adi15,adi16,adi05,
          adi06,adi07,adi08,adi09,adi10,adi33,adi34,
          adi35,adi30,adi31,adi32
     FROM adi_file,OUTER (pmn_file,OUTER pmm_file)
    WHERE adi01=g_adh.adh01 AND pmm_file.pmm01 = pmn_file.pmn01
      AND adi15 = pmn_file.pmn01 AND adi16 = pmn_file.pmn02
    ORDER BY pmm09,adi02,adi03,adi04
  #No.FUN-580033  --end
  
  CALL s_showmsg_init()   #No:FUN-6C0083 
  
  LET l_pmm09 = NULL
  FOREACH t203_y1_c1 INTO b_adi.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_adi.adi03) THEN CONTINUE FOREACH END IF
      IF cl_null(l_pmm09) OR l_pmm09 <> b_adi.pmm09 THEN   #單身換成另一個工廠
         LET g_head = 1                                    #或是內部調撥
      ELSE
         LET g_head = 0
      END IF
      #No.FUN-580033  --begin
      SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01=b_adi.adi05
      #No.FUN-580033  --end

      CASE g_adh.adh00
           WHEN '1' CALL t203_y2_1(b_adi.*)
           WHEN '2' CALL t203_y2_2(b_adi.*)
      END CASE
      LET l_pmm09 = b_adi.pmm09
      IF g_success='N' THEN
         #TQC-620156...............begin
         LET g_totsuccess="N"
         LET g_success='Y'
         CONTINUE FOREACH   #No:FUN-6C0083
         #TQC-620156...............end
      END IF
  END FOREACH
  IF g_totsuccess="N" THEN    #TQC-620156
     LET g_success="N"
  END IF

  CALL s_showmsg()   #No:FUN-6C0083

END FUNCTION

FUNCTION t203_y1_3()
  DEFINE b_adi RECORD
               oga03  LIKE oga_file.oga03,   #撥出工廠
               adi02  LIKE adi_file.adi02,   #撥入項次
               adi03  LIKE adi_file.adi03,   #撥出單號
               adi04  LIKE adi_file.adi04,   #撥出項次
               adi15  LIKE adi_file.adi15,   #出貨單號
               adi16  LIKE adi_file.adi16,   #出貨項次
               adi05  LIKE adi_file.adi05,   #料件編號
               adi06  LIKE adi_file.adi06,   #倉庫
               adi07  LIKE adi_file.adi07,   #儲位
               adi08  LIKE adi_file.adi08,   #批號
               adi09  LIKE adi_file.adi09,   #單位
               #No.FUN-580033  --begin
               adi10  LIKE adi_file.adi10,   #撥入數量
               adi33  LIKE adi_file.adi33,   #單位二
               adi34  LIKE adi_file.adi34,   #單位二轉換率
               adi35  LIKE adi_file.adi35,   #單位二數量
               adi30  LIKE adi_file.adi30,   #單位一
               adi31  LIKE adi_file.adi31,   #單位一轉換率
               adi32  LIKE adi_file.adi32    #單位一數量
               #No.FUN-580033  --end
               END RECORD,
          l_oga03 LIKE oga_file.oga03,
          l_adi15 LIKE adi_file.adi15

  CALL s_showmsg_init()   #No:FUN-6C0083 

  #對于adi中的每一筆都要insert到adq_file中
  #No.FUN-580033  --begin
  DECLARE t203_y1_3_c1 CURSOR FOR
   SELECT oga03,adi02,adi03,adi04,adi15,adi16,adi05,
          adi06,adi07,adi08,adi09,adi10,adi33,adi34,
          adi35,adi30,adi31,adi32
     FROM adi_file,oga_file,ogb_file
    WHERE adi01=g_adh.adh01 AND oga01 = ogb01
      AND adi15 = ogb01 AND adi16 = ogb03
    ORDER BY oga03,adi15,adi16,adi02
  #No.FUN-580033  --end
  LET l_oga03 = NULL
  FOREACH t203_y1_3_c1 INTO b_adi.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_adi.adi03) THEN CONTINUE FOREACH END IF
      IF cl_null(l_oga03) OR l_oga03 <> b_adi.oga03 THEN   #單身換成另一個工廠
         LET g_head = 1                                    #或是內部調撥
      ELSE
         LET g_head = 0
         IF g_adh.adh00 = '3' THEN
            IF cl_null(l_adi15) OR l_adi15 <> b_adi.adi15 THEN
               LET g_head = 1
            ELSE
               LET g_head = 0
            END IF
         END IF
      END IF
      #No.FUN-580033  --begin
      SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01=b_adi.adi05
      #No.FUN-580033  --end
      
      CALL t203_y2_3(b_adi.*)
      LET l_oga03 = b_adi.oga03
      LET l_adi15 = b_adi.adi15
      IF g_success='N' THEN
         #TQC-620156...............begin
         LET g_totsuccess="N"
         LET g_success='Y'
         CONTINUE FOREACH   #No:FUN-6C0083
         #TQC-620156...............end
      END IF
  END FOREACH
  IF g_totsuccess="N" THEN    #TQC-620156
     LET g_success="N"
  END IF

  CALL s_showmsg()   #No:FUN-6C0083

END FUNCTION

FUNCTION t203_y2_1(p_adi)
  DEFINE p_adi   RECORD
               pmm09  LIKE pmm_file.pmm09,   #撥出工廠
               adi02  LIKE adi_file.adi02,   #撥入項次
               adi03  LIKE adi_file.adi03,   #參考單號
               adi04  LIKE adi_file.adi04,   #參考項次
               adi15  LIKE adi_file.adi15,   #采購單號
               adi16  LIKE adi_file.adi16,   #采購項次
               adi05  LIKE adi_file.adi05,   #料件編號
               adi06  LIKE adi_file.adi06,   #倉庫
               adi07  LIKE adi_file.adi07,   #儲位
               adi08  LIKE adi_file.adi08,   #批號
               adi09  LIKE adi_file.adi09,   #單位
               #No.FUN-580033  --begin
               adi10  LIKE adi_file.adi10,   #撥入數量
               adi33  LIKE adi_file.adi33,   #單位二
               adi34  LIKE adi_file.adi34,   #單位二轉換率
               adi35  LIKE adi_file.adi35,   #單位二數量
               adi30  LIKE adi_file.adi30,   #單位一
               adi31  LIKE adi_file.adi31,   #單位一轉換率
               adi32  LIKE adi_file.adi32    #單位一數量
               #No.FUN-580033  --end
                 END RECORD,
         l_buf   LIKE adi_file.adi03,                    #No.FUN-680108 VARCHAR(100)
         l_tot1  LIKE adg_file.adg12,
         l_img_rowid       LIKE type_file.chr18,         #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         l_ade13 LIKE ade_file.ade13,
         l_ade01 LIKE ade_file.ade01,
         l_ade02 LIKE ade_file.ade02,
         l_adg01 LIKE adg_file.adg01,
         l_adg02 LIKE adg_file.adg02,
         l_adg12 LIKE adg_file.adg12,
         l_adg17 LIKE adg_file.adg17,
         l_adf07 LIKE adf_file.adf07,
         d_img10 LIKE img_file.img10,
         l_img   RECORD LIKE img_file.*,
         t_img   RECORD LIKE img_file.*

  ################UPDATE 集團調撥申請單單身檔[ade_file] ##################
  SELECT adg01,adg02,adg03,adg04,adg12,adg17
    INTO l_adg01,l_adg02,l_ade01,l_ade02,l_adg12,l_adg17
    FROM adg_file,adi_file
   WHERE adi03 = adg01 AND adi04 = adg02
     AND adi01 = g_adh.adh01 AND adi02 = p_adi.adi02
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF

  IF cl_null(l_adg12) THEN LET l_adg12=0 END IF   #撥出數量
  IF cl_null(l_adg17) THEN LET l_adg17=0 END IF   #已撥入量
  LET l_tot1 = l_adg12 - l_adg17                  #可撥出量

  IF p_adi.adi10 > l_tot1 THEN     #撥入量大于可撥出量
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-069',1)
     LET g_success = 'N' RETURN
  END IF
  #更新申請單上已撥入撥量
  SELECT ade13 INTO l_ade13 FROM ade_file WHERE ade01=l_ade01 AND ade02=l_ade02
  IF cl_null(l_ade13) OR l_ade13='Y' THEN    #若申請單已結案,則不得有異動
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'9004',1)
     LET g_success = 'N' RETURN
  END IF
  UPDATE ade_file SET ade15 = ade15 + p_adi.adi10
   WHERE ade01 = l_ade01 AND ade02 = l_ade02
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  #更新撥出單上已撥入撥量
  UPDATE adg_file SET adg17 = adg17 + p_adi.adi10
   WHERE adg01 = l_adg01 AND adg02 = l_adg02
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  ##########################update img 在途倉#############################

  SELECT UNIQUE adf07 INTO l_adf07 FROM adf_file,adg_file     #撥出單在途倉
   WHERE adf01 = adg01 AND adg01 = p_adi.adi03 AND adg02 = p_adi.adi04
  SELECT ROWID,img_file.* INTO g_img_rowid,l_img.* FROM img_file#No.FUN-580033
   WHERE img01 = p_adi.adi05 AND img02 = l_adf07
 #    AND img03 = p_adi.adi03 AND img04 = p_adi.adi04   #No.MOD-560296
      AND img03 = p_adi.adi04 AND img04 = p_adi.adi03   #No.MOD-560296
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err('select img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err('select img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     END IF
  END IF
  #更新調出倉庫、儲位、批號的img_file的數量(內部)#1
  #            1           2  3           4
  CALL s_upimg(g_img_rowid,-1,p_adi.adi10,l_img.img16, #No.FUN-580033
  #            5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22
               '','','','','','','','','','','','','','','','','','')
  IF g_success = 'N' THEN RETURN END IF

#  LET g_rowid_t=l_img_rowid  #No.FUN-580033
  #No.FUN-580033  --begin
  #SELECT img10 INTO d_img10 FROM img_file WHERE ROWID=l_img_rowid
  #IF d_img10=0 THEN
  #   DELETE FROM img_file WHERE ROWID=l_img_rowid
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err('delete img',SQLCA.sqlcode,0)
  #      LET g_success='N' RETURN
  #   END IF
  #END IF
  #No.FUN-580033  --end
#  #---->若庫存異動後其庫存量小於等於零時將該筆資料刪除
#  CALL s_delimg(l_img_rowid)
#  IF SQLCA.sqlcode THEN
#     CALL cl_err('s_upimg',SQLCA.sqlcode,0)
#     LET g_success = 'N' RETURN
#  END IF

##############update img 撥入倉###########################

  SELECT ROWID,img_file.*
    INTO l_img_rowid,t_img.*
    FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = p_adi.adi06
     AND img03 = p_adi.adi07 AND img04 = p_adi.adi08
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err('select img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err('select img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     END IF
  END IF
  #No.FUN-580033  --begin
  LET g_factor=1
  IF t_img.img09 <> p_adi.adi09 THEN
     CALL s_umfchk(p_adi.adi05,p_adi.adi09,t_img.img09)
          RETURNING g_cnt,g_factor
     IF g_cnt=1 THEN
        LET g_factor=1
     END IF
  END IF
  LET g_qty=p_adi.adi10*g_factor
  #CALL s_upimg(l_img_rowid,+1,p_adi.adi10,g_adh.adh02,
  CALL s_upimg(l_img_rowid,+1,g_qty      ,g_adh.adh02,
  #No.FUN-580033  --end
       #       5           6           7           8
               p_adi.adi05,p_adi.adi06,p_adi.adi07,p_adi.adi08,
       #       9           10          11          12          13
               g_adh.adh01,p_adi.adi02,p_adi.adi09,p_adi.adi10,p_adi.adi09,
       #       14  15          16   17          18          19
               1,  t_img.img21,1,   t_img.img26,t_img.img35,t_img.img27,
       #       20          21          22
               t_img.img28,t_img.img19,t_img.img36)
  IF g_success = 'N' THEN RETURN END IF

##############update ima 撥入倉###########################

  #---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
  IF s_udima(p_adi.adi05,              #料件編號
             t_img.img23,              #是否可用倉儲
             t_img.img24,              #是否為MRP可用倉儲
             p_adi.adi10*t_img.img21,  #調撥數量(換算為庫存單位)
             t_img.img16,              #最近一次調撥日期
             +1)                       #表調撥入
  THEN LET g_success = 'N' RETURN
  END IF

##############update tlf_file#############################
  CALL t203_tlf(l_img.img10,p_adi.*,'1',l_adf07,t_img.img10,t_img.img35)
  IF g_success = 'N' THEN RETURN END IF
  CALL t203_tlf(l_img.img10,p_adi.*,'2',l_adf07,t_img.img10,t_img.img35)
  IF g_success = 'N' THEN RETURN END IF

  #No.FUN-580033  --begin
  IF g_sma.sma115='Y' THEN
     LET t_adi.*=p_adi.*
     SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=p_adi.adi05
     #在途倉
     CALL t203_update_du(l_adf07,p_adi.adi04,p_adi.adi03,-1,+1,g_dbs,'1')
     IF g_success='N' THEN RETURN END IF
     IF NOT cl_null(p_adi.adi33) THEN
        CALL s_delimgg1(NULL,p_adi.adi05,l_adf07,p_adi.adi04,
                        p_adi.adi03,p_adi.adi33,g_dbs)
        IF g_success='N' THEN RETURN END IF
     END IF
     IF g_ima906 = '2' AND NOT cl_null(p_adi.adi30) THEN
        CALL s_delimgg1(NULL,p_adi.adi05,l_adf07,p_adi.adi04,
                        p_adi.adi03,p_adi.adi30,g_dbs)
        IF g_success='N' THEN RETURN END IF
     END IF

     #撥入倉
     CALL t203_update_du(p_adi.adi06,p_adi.adi07,p_adi.adi08,+1,+1,g_dbs,'2')
     IF g_success='N' THEN RETURN END IF
  END IF
  SELECT img10 INTO d_img10 FROM img_file WHERE ROWID=g_img_rowid
  IF d_img10=0 THEN
     DELETE FROM img_file WHERE ROWID=g_img_rowid
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete img',SQLCA.sqlcode,0)
        LET g_success='N' RETURN
     END IF
  END IF
  #No.FUN-580033  --end
END FUNCTION

FUNCTION t203_y2_2(p_adi)
  DEFINE p_adi       RECORD
                       pmm09  LIKE pmm_file.pmm09,   #撥出工廠
                       adi02  LIKE adi_file.adi02,   #撥入項次
                       adi03  LIKE adi_file.adi03,   #參考單號
                       adi04  LIKE adi_file.adi04,   #參考項次
                       adi15  LIKE adi_file.adi15,   #采購單號
                       adi16  LIKE adi_file.adi16,   #采購項次
                       adi05  LIKE adi_file.adi05,   #料件編號
                       adi06  LIKE adi_file.adi06,   #倉庫
                       adi07  LIKE adi_file.adi07,   #儲位
                       adi08  LIKE adi_file.adi08,   #批號
                       adi09  LIKE adi_file.adi09,   #單位
                       #No.FUN-580033  --begin
                       adi10  LIKE adi_file.adi10,   #撥入數量
                       adi33  LIKE adi_file.adi33,   #單位二
                       adi34  LIKE adi_file.adi34,   #單位二轉換率
                       adi35  LIKE adi_file.adi35,   #單位二數量
                       adi30  LIKE adi_file.adi30,   #單位一
                       adi31  LIKE adi_file.adi31,   #單位一轉換率
                       adi32  LIKE adi_file.adi32    #單位一數量
                       #No.FUN-580033  --end
                     END RECORD,
         l_buf       LIKE adi_file.adi03,                #No.FUN-680108 VARCHAR(100)
         l_dbs       LIKE azp_file.azp03,
         l_fac       LIKE ima_file.ima31_fac,         #No.FUN-680108 DEC(16,8) 
         l_tot1      LIKE adg_file.adg12,
         l_ima02,l_ima02_1 LIKE ima_file.ima02,
         l_img_rowid       LIKE type_file.chr18,         #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         l_ade01     LIKE ade_file.ade01,
         l_ade02     LIKE ade_file.ade02,
         l_adg01     LIKE adg_file.adg01,
         l_adg02     LIKE adg_file.adg02,
         l_adg06     LIKE adg_file.adg06,
         l_adg07     LIKE adg_file.adg07,
         l_adg08     LIKE adg_file.adg08,
         l_adg12     LIKE adg_file.adg12,
         l_adg17     LIKE adg_file.adg17,
         l_adf07     LIKE adf_file.adf07,
         l_img04     LIKE img_file.img04,
         l_img09     LIKE img_file.img09,
         l_ogb14     LIKE ogb_file.ogb14,
         l_adi13     LIKE adi_file.adi13,
         l_adi14     LIKE adi_file.adi14,
         d_img10     LIKE img_file.img10,
         l_ogb       RECORD LIKE ogb_file.*,
         l_oga       RECORD LIKE oga_file.*,
         l_rvb       RECORD LIKE rvb_file.*,
         l_adv       RECORD LIKE adv_file.*,
         l_rvv       RECORD LIKE rvv_file.*,
         l_img       RECORD LIKE img_file.*,
         t_img       RECORD LIKE img_file.*

  ########UPDATE 集團調撥申請單單身檔[ade_file,adg_file] ########

  SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adi.pmm09
  IF SQLCA.sqlcode THEN
     CALL cl_err('azp_file',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  LET l_dbs=p_dbs CLIPPED,"."
  LET g_sql = " SELECT UNIQUE adf07,adg01,adg02,adg03,adg04,adg12,adg17,",
              "        adg06,adg07,adg08 ",
              "   FROM ",p_dbs,".adg_file,",p_dbs,".adf_file",
              "  WHERE adg01 = '",p_adi.adi03,"' AND adg02 = ",p_adi.adi04,
              "    AND adf01 = adg01"
  PREPARE t203_prepare4 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  DECLARE t203_curs4 SCROLL CURSOR FOR t203_prepare4
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  OPEN t203_curs4
  FETCH t203_curs4 INTO l_adf07,l_adg01,l_adg02,l_ade01,
                        l_ade02,l_adg12,l_adg17,
                        l_adg06,l_adg07,l_adg08
  IF SQLCA.sqlcode THEN
     CALL cl_err('','axd-030',0)
     LET g_success = 'N' RETURN
  END IF
  IF cl_null(l_adg12) THEN LET l_adg12=0 END IF   #撥出數量
  IF cl_null(l_adg17) THEN LET l_adg17=0 END IF   #已撥入量
  LET l_tot1 = l_adg12 - l_adg17                  #可撥出量

  IF p_adi.adi10 > l_tot1 THEN     #撥入量大于可撥出量
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-069',1)
     LET g_success = 'N' RETURN
  END IF
  #修改申請單上的已撥入量
  CALL t203_ade13(l_ade01,l_ade02,p_dbs) RETURNING g_flag
  IF g_flag=1 THEN    #若申請單已結案,則不得有異動
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'9004',1)
     LET g_success = 'N' RETURN
  END IF

  LET g_sql = " UPDATE ",p_dbs,".ade_file SET ade15 = ade15 + ",p_adi.adi10,
              "  WHERE ade01 = '",l_ade01,"' AND ade02 = ",l_ade02
  PREPARE t203_prepare5 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_prepare5
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  #修改撥出單上的已撥入量
  LET g_sql = " UPDATE ",p_dbs,".adg_file SET adg17 = adg17 + ",p_adi.adi10,
              "  WHERE adg01 = '",l_adg01,"' AND adg02 = ",l_adg02
  PREPARE t203_prepare13 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_prepare13
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  ##########################update img 在途倉#############################

  LET l_img04 = p_adi.adi04
  LET g_sql = " SELECT ROWID,img_file.* FROM ",p_dbs,".img_file",
              "  WHERE img01 = '",p_adi.adi05,"' AND img02 = '",l_adf07,"'",
   #No.MOD-560296  --begin
#             "    AND img03 = '",p_adi.adi03,"' AND img04 = '",l_img04 CLIPPED,"'"
              "    AND img03 = '",l_img04 CLIPPED,"' AND img04 = '",p_adi.adi03,"'"
   #No.MOD-560296  --end
  PREPARE t203_prepare6 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select img',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  DECLARE t203_curs6 SCROLL CURSOR FOR t203_prepare6
  IF SQLCA.sqlcode THEN
     CALL cl_err('select img',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  OPEN t203_curs6
  FETCH t203_curs6 INTO g_img_rowid,l_img.* #No.FUN-580033
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err(p_adi.adi03,'mfg3465',0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err(p_adi.adi03,'mfg3466',0)
         LET g_success = 'N' RETURN
     END IF
  END IF
  #更新調出倉庫、儲位、批號的img_file的數量 (外部)#2
  LET t_dbs = p_dbs CLIPPED,"."
  #No.FUN-560296  --begin
  #              1           2  3           4
  CALL s_upimg1(g_img_rowid,-1,p_adi.adi10,l_img.img16, #No.FUN-580033
  #             5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22  23
                '','','','','','','','','','','','','','','','','','',t_dbs)
  #No.FUN-560296  --end
  IF g_success = 'N' THEN RETURN END IF

  #---->若庫存異動後其庫存量小於等於零時將該筆資料刪除
  #No.FUN-580033  --begin
  #LET g_rowid_t=l_img_rowid
  #CALL s_delimg1(g_img_rowid,p_dbs)  #s_delimg1不參考sma882
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('s_delimg1',SQLCA.sqlcode,0)
  #   LET g_success = 'N' RETURN
  #END IF
  #No.FUN-580033  --end
##############update ima 撥出倉###########################
    IF s_udima1(p_adi.adi05,             #料件編號
                l_img.img23,             #是否可用倉儲
                l_img.img24,             #是否為MRP可用倉儲
                p_adi.adi10*l_img.img21, #調撥數量(換算為料件庫存單)
                l_img.img16,             #最近一次撥出日期
                -1,                      #表撥出
                l_dbs)                   #資料庫編號
        THEN RETURN 1
        END IF
    IF g_success = 'N' THEN RETURN END IF

##############update img 撥入倉###########################

  SELECT ROWID,img_file.*
    INTO l_img_rowid,t_img.*
    FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = p_adi.adi06
     AND img03 = p_adi.adi07 AND img04 = p_adi.adi08
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err('select img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err('select img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     END IF
  END IF
  #No.FUN-580033  --begin
  LET g_factor=1
  IF t_img.img09 <> p_adi.adi09 THEN
     CALL s_umfchk(p_adi.adi05,p_adi.adi09,t_img.img09)
          RETURNING g_cnt,g_factor
     IF g_cnt=1 THEN
        LET g_factor=1
     END IF
  END IF
  LET g_qty=p_adi.adi10*g_factor
  #CALL s_upimg(l_img_rowid,+1,p_adi.adi10,g_adh.adh02,
  CALL s_upimg(l_img_rowid,+1,g_qty      ,g_adh.adh02,
  #No.FUN-580033  --end
       #       5           6           7           8
               p_adi.adi05,p_adi.adi06,p_adi.adi07,p_adi.adi08,
       #       9           10          11          12          13
               g_adh.adh01,p_adi.adi02,p_adi.adi09,p_adi.adi10,p_adi.adi09,
       #       14  15          16   17          18          19
               1,  t_img.img21,1,   t_img.img26,t_img.img35,t_img.img27,
       #       20          21          22
               t_img.img28,t_img.img19,t_img.img36)
  IF g_success = 'N' THEN RETURN END IF

##############update ima 撥入倉###########################

  #---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
  IF s_udima(p_adi.adi05,              #料件編號
             t_img.img23,              #是否可用倉儲
             t_img.img24,              #是否為MRP可用倉儲
             p_adi.adi10*t_img.img21,  #調撥數量(換算為庫存單位)
             t_img.img16,              #最近一次調撥日期
             +1)                       #表調撥入
  THEN LET g_success = 'N' RETURN
  END IF

##############update tlf_file#############################
  CALL t203_tlf(l_img.img10,p_adi.*,'1',l_adf07,t_img.img10,t_img.img35)
  IF g_success = 'N' THEN RETURN END IF
  CALL t203_tlf(l_img.img10,p_adi.*,'2',l_adf07,t_img.img10,t_img.img35)
  IF g_success = 'N' THEN RETURN END IF

  #No.FUN-580033  --begin
  IF g_sma.sma115='Y' THEN
     LET t_adi.*=p_adi.*
     SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=p_adi.adi05
     #在途倉
     CALL t203_update_du(l_adf07,l_img04,p_adi.adi03,-1,+1,p_dbs,'1')
     IF g_success='N' THEN RETURN END IF
     IF NOT cl_null(p_adi.adi33) THEN
        CALL s_delimgg1(NULL,p_adi.adi05,l_adf07,l_img04,
                        p_adi.adi03,p_adi.adi33,p_dbs)
        IF g_success='N' THEN RETURN END IF
     END IF
     IF g_ima906 = '2' AND NOT cl_null(p_adi.adi30) THEN
        CALL s_delimgg1(NULL,p_adi.adi05,l_adf07,l_img04,
                        p_adi.adi03,p_adi.adi30,p_dbs)
        IF g_success='N' THEN RETURN END IF
     END IF

     #撥入倉
     CALL t203_update_du(p_adi.adi06,p_adi.adi07,p_adi.adi08,+1,+1,g_dbs,'2')
     IF g_success='N' THEN RETURN END IF
  END IF
  CALL s_delimg1(g_img_rowid,p_dbs)  #s_delimg1不參考sma882
  IF SQLCA.sqlcode THEN
     CALL cl_err('s_delimg1',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  #No.FUN-580033  --end
################外部調撥################

  ################（產生出貨單、收貨單、收貨入庫單單頭）################
#  IF g_head=1 THEN
     #分銷系統參數(二)設定--出貨單
     LET g_sql = " SELECT * FROM ",p_dbs CLIPPED,".adv_file",
                 "  WHERE adv01 = '",g_azp01,"'"
     PREPARE t203_prepare7 FROM g_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('select adv',SQLCA.sqlcode,0)
        LET g_success = 'N'
        RETURN
     END IF
     DECLARE t203_curs7 SCROLL CURSOR FOR t203_prepare7
     IF SQLCA.sqlcode THEN
        CALL cl_err('select adv',SQLCA.sqlcode,0)
        LET g_success = 'N'
        RETURN
     END IF
     OPEN t203_curs7
     FETCH t203_curs7 INTO l_adv.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('select adv',SQLCA.sqlcode,0)
        LET g_success = 'N'
        RETURN
     END IF
#  END IF

  CALL t203_ins_oga_rva_rvu(p_adi.pmm09,p_adi.adi15,l_adv.*)
  IF g_success = 'N' THEN RETURN END IF

  #########INSERT 出貨單單身檔[p_dbs.ogb_file]#############

  LET g_sql = " SELECT MAX(ogb03)+1 FROM ",p_dbs CLIPPED,".ogb_file",
              "  WHERE ogb01 = '",g_oga01,"'"
  PREPARE t203_prepare8 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select ogb',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  DECLARE t203_curs8 SCROLL CURSOR FOR t203_prepare8
  IF SQLCA.sqlcode THEN
     CALL cl_err('select ogb',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  OPEN t203_curs8
  FETCH t203_curs8 INTO l_ogb.ogb03
  IF cl_null(l_ogb.ogb03) OR l_ogb.ogb03 = 0 THEN
     LET l_ogb.ogb03 = 1
  END IF
  LET g_sql = "SELECT ima02,img09 ",        #在撥出單處抓品名
              "  FROM ",p_dbs CLIPPED,".ima_file,",p_dbs CLIPPED,".img_file",
              " WHERE ima01 = '",p_adi.adi05 CLIPPED,"'",
              "   AND ima01=img01         AND img02='",l_adg06,"'",
              "   AND img03='",l_adg07,"' AND img04='",l_adg08,"'"
  PREPARE t203_prepare9 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select ima',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  DECLARE t203_curs9 SCROLL CURSOR FOR t203_prepare9
  IF SQLCA.sqlcode THEN
     CALL cl_err('select ima',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  OPEN t203_curs9
  FETCH t203_curs9 INTO l_ogb.ogb06,l_ogb.ogb15
  IF SQLCA.sqlcode THEN
     CALL cl_err('select ima',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  LET l_dbs=p_dbs CLIPPED,"."
  CALL s_umfchk1(p_adi.adi05,p_adi.adi09,l_ogb.ogb15,p_dbs)
       RETURNING g_cnt,l_fac
  IF g_cnt=1 THEN
     CALL cl_err('','abm-731',0)
     LET l_fac = 1
  END IF
  LET l_ogb.ogb16=p_adi.adi10*l_fac
  IF cl_null(l_ogb.ogb16) THEN LET l_ogb.ogb16=0 END IF

  SELECT adi13,adi14 INTO l_adi13,l_adi14 FROM adi_file
   WHERE adi01=g_adh.adh01 AND adi02=p_adi.adi02
  IF cl_null(l_adi13) THEN LET l_adi13=0 END IF
  IF cl_null(l_adi14) THEN LET l_adi14=0 END IF
  LET l_ogb.ogb13=l_adi13
  LET l_ogb.ogb14=l_adi14
  LET l_ogb.ogb14t=l_ogb.ogb14*(1+l_adv.adv07/100)
  IF cl_null(l_ogb.ogb14t) THEN LET l_ogb.ogb14t=0 END IF

  LET g_sql = " INSERT INTO ",p_dbs CLIPPED,".ogb_file",
#               1     2     3      4      5     6     7
              "(ogb01,ogb03,ogb31, ogb32, ogb04,ogb05,ogb06,",
#               8     9     10     11     12    13    14
              " ogb12,ogb09,ogb091,ogb092,ogb13,ogb14,ogb17,",
#               15        16     17        18    19    20
              " ogb05_fac,ogb14t,ogb15_fac,ogb16,ogb18,ogb60,",
#               21    22
              " ogb63,ogb64,ogb08,ogb15,ogb910,ogb911,ogb912,", #No.FUN-580033
              " ogb913,ogb914,ogb915,ogb916,ogb917 )",          #No.FUN-580033
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #No.FUN-580033
  PREPARE t203_pre6 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('insert ogb',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  EXECUTE t203_pre6 USING
#    1       2           3           4
     g_oga01,l_ogb.ogb03,g_adh.adh01,p_adi.adi02,
#    5           6           7           8
     p_adi.adi05,p_adi.adi09,l_ogb.ogb06,p_adi.adi10,
#    9           10          11          12          13          14
     l_adg06    ,l_adg07    ,l_adg08    ,l_ogb.ogb13,l_ogb.ogb14,'N',
#    15  16           17    18          19  20  21  22
     '0',l_ogb.ogb14t,l_fac,l_ogb.ogb16,'0','0','0','0',g_plant, #No.FUN-580033
     l_ogb.ogb15,p_adi.adi30,p_adi.adi31,p_adi.adi32,p_adi.adi33,#No.FUN-580033
     p_adi.adi34,p_adi.adi35,p_adi.adi09,p_adi.adi10             #No.FUN-580033
  IF SQLCA.sqlcode THEN
     CALL cl_err('insert ogb',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF

  LET g_sql="SELECT oga211,oga23,oga24,SUM(ogb14) FROM ",
             p_dbs CLIPPED,".ogb_file,",p_dbs CLIPPED,".oga_file",
            " WHERE ogb01='",g_oga01,"'",
            "   AND oga01=ogb01",
            " GROUP BY oga211,oga23,oga24"
  PREPARE t203_sel_ogb14 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select ogb14',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  EXECUTE t203_sel_ogb14 INTO l_oga.oga211,l_oga.oga23,l_oga.oga24,l_ogb14
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 =l_oga.oga23     #No.CHI-6A0004
  LET l_oga.oga50=l_ogb14
  IF cl_null(l_oga.oga50) THEN LET l_oga.oga50=0 END IF
  LET l_oga.oga501=l_oga.oga50*l_oga.oga24
  IF cl_null(l_oga.oga501) THEN LET l_oga.oga501=0 END IF
  LET l_oga.oga501=cl_digcut(l_oga.oga501,t_azi04)       #No.CHI-6A0004   
  LET l_oga.oga51=l_oga.oga50*(1+l_oga.oga211/100)
  IF cl_null(l_oga.oga51) THEN LET l_oga.oga51=0 END IF
  LET l_oga.oga511=l_oga.oga51*l_oga.oga24
  IF cl_null(l_oga.oga511) THEN LET l_oga.oga511=0 END IF
  LET l_oga.oga511=cl_digcut(l_oga.oga511,t_azi04)        #No.CHI-6A0004 
  LET g_sql=" UPDATE ",p_dbs CLIPPED,".oga_file ",
            "    SET oga50=?,oga501=?,oga51=?,oga511=?",
            "  WHERE oga01='",g_oga01,"'"
  PREPARE t203_upd_oga FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update oga',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  EXECUTE t203_upd_oga USING l_oga.oga50,l_oga.oga501,l_oga.oga51,l_oga.oga511


  #########INSERT 收貨單單身檔[rvb_file]#############

  SELECT MAX(rvb02)+1 INTO l_rvb.rvb02 FROM rvb_file WHERE rvb01 = g_rva01
  IF cl_null(l_rvb.rvb02) OR l_rvb.rvb02 = 0 THEN
     LET l_rvb.rvb02 = 1
  END IF
#                      1     2     3     4     5     6
  INSERT INTO rvb_file(rvb01,rvb02,rvb04,rvb03,rvb05,rvb06,
#                      7     8     9     10    11    12
                       rvb07,rvb08,rvb09,rvb10,rvb12,rvb15,
#                      13    14    15    16    17    18
                       rvb16,rvb18,rvb19,rvb29,rvb30,rvb31,
#                      19    20    21    22    23    24
                       rvb33,rvb35,rvb36,rvb37,rvb38,rvb39,rvb32,#No.FUN-580033
                       rvb80,rvb81,rvb82,rvb83,rvb84,rvb85,      #No.FUN-580033
                       rvb86,rvb87)                              #No.FUN-580033
#          1       2           3           4           5           6
  VALUES  (g_rva01,l_rvb.rvb02,p_adi.adi15,p_adi.adi16,p_adi.adi05,0,
#          7           8           9          10       11         12
           p_adi.adi10,p_adi.adi10,p_adi.adi10,l_adi13,g_adh.adh02,0,
#          13 14  15 16 17 18
           0,'10','1',0,0,p_adi.adi10,
#          19          20  21          22          23          24
           p_adi.adi10,'N',p_adi.adi06,p_adi.adi07,p_adi.adi08,'N',#No.FUN-580033
           p_adi.adi02,p_adi.adi30,p_adi.adi31,p_adi.adi32,        #No.FUN-580033
           p_adi.adi33,p_adi.adi34,p_adi.adi35,p_adi.adi09,        #No.FUN-580033
           p_adi.adi10)                                            #No.FUN-580033
  IF SQLCA.sqlcode THEN
     CALL cl_err('insert rvb',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  ##############出貨后upate 采購單上的交貨量############
  CALL t203_upd_pmn1(p_adi.adi15,p_adi.adi16)
  IF g_success = 'N' THEN RETURN END IF

  #########INSERT 入庫單單身檔[rvv_file]#############
  SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file WHERE rvv01 = g_rvu01
  IF cl_null(l_rvv.rvv02) OR l_rvv.rvv02 = 0 THEN
     LET l_rvv.rvv02 = 1
  END IF
  SELECT pmn041 INTO l_ima02_1 FROM pmn_file
   WHERE pmn24 = p_adi.adi03 AND pmn25 = p_adi.adi04
  LET l_rvv.rvv031 = l_ima02_1
  SELECT img09 INTO l_img09 FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = p_adi.adi06
     AND img03 = p_adi.adi07 AND img04 = p_adi.adi08
  CALL s_umfchk(p_adi.adi05,p_adi.adi09,l_img09)
       RETURNING g_cnt,l_fac
  IF g_cnt=1 THEN
     CALL cl_err('','abm-731',0)
     LET l_fac = 1
  END IF
  IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF   #no.TQC-790003
#                      1     2     3     4     5     6
  INSERT INTO rvv_file(rvv01,rvv02,rvv03,rvv04,rvv05,rvv06,
#                      7     8     9     10    11    12
                       rvv09,rvv17,rvv23,rvv24,rvv25,rvv26,
#                      13    14    15    16    17
                       rvv31,rvv031,rvv32,rvv33,rvv34,
#                      18    19        20    21    22    23    24
                       rvv35,rvv35_fac,rvv36,rvv37,rvv38,rvv39,rvv41,#No.FUN-580033
                     rvv80,rvv81,rvv82,rvv83,rvv84,rvv85,rvv86,rvv87,rvv88)#No.FUN-580033  #No.TQC-7B0083
#          1       2           3   4       5           6
  VALUES  (g_rvu01,l_rvv.rvv02,'1',g_rva01,l_rvb.rvb02,p_adi.pmm09,
#          7           8           9 10   11  12
           g_adh.adh02,p_adi.adi10,0,'N' ,'N',NULL,
#          13          14           15          16          17
           p_adi.adi05,l_rvv.rvv031,p_adi.adi06,p_adi.adi07,p_adi.adi08,
#          18          19    20          21          22
           p_adi.adi09,l_fac,p_adi.adi15,p_adi.adi16,l_adi13,
#          23                  24
           p_adi.adi10*l_adi13,'',p_adi.adi30,p_adi.adi31,p_adi.adi32,#No.FUN-580033
          p_adi.adi33,p_adi.adi34,p_adi.adi35,p_adi.adi09,p_adi.adi10,0)#No.FUN-580033  #No.TQC-7B0083
  IF SQLCA.sqlcode THEN
     CALL cl_err('insert rvv',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF

  ##############入庫后upate 收貨單############
  CALL t203_upd_rvb(l_rvb.rvb02)
  IF g_success = 'N' THEN RETURN END IF

  ##############入庫后upate 采購單############
  CALL t203_upd_pmn2(p_adi.adi15,p_adi.adi16)
  IF g_success = 'N' THEN RETURN END IF

END FUNCTION

FUNCTION t203_y2_3(p_adi)   #倉退
  DEFINE p_adi       RECORD
                     oga03  LIKE oga_file.oga03,   #撥出工廠
                     adi02  LIKE adi_file.adi02,   #撥入項次
                     adi03  LIKE adi_file.adi03,   #撥出單號
                     adi04  LIKE adi_file.adi04,   #撥出項次
                     adi15  LIKE adi_file.adi15,   #出貨單號
                     adi16  LIKE adi_file.adi16,   #出貨項次
                     adi05  LIKE adi_file.adi05,   #料件編號
                     adi06  LIKE adi_file.adi06,   #倉庫
                     adi07  LIKE adi_file.adi07,   #儲位
                     adi08  LIKE adi_file.adi08,   #批號
                     adi09  LIKE adi_file.adi09,   #單位
                     #No.FUN-580033  --begin
                     adi10  LIKE adi_file.adi10,   #撥入數量
                     adi33  LIKE adi_file.adi33,   #單位二
                     adi34  LIKE adi_file.adi34,   #單位二轉換率
                     adi35  LIKE adi_file.adi35,   #單位二數量
                     adi30  LIKE adi_file.adi30,   #單位一
                     adi31  LIKE adi_file.adi31,   #單位一轉換率
                     adi32  LIKE adi_file.adi32    #單位一數量
                     #No.FUN-580033  --end
                     END RECORD,
         l_buf       LIKE adi_file.adi03,                #No.FUN-680108 VARCHAR(100)
         l_fac       LIKE ima_file.ima31_fac,      #No.FUN-680108 DEC(16,8) 
         l_tot1      LIKE adg_file.adg12,
         l_ima02,l_ima02_1 LIKE ima_file.ima02,
         l_img_rowid       LIKE type_file.chr18,         #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         l_ade01     LIKE ade_file.ade01,
         l_ade02     LIKE ade_file.ade02,
         l_adg01     LIKE adg_file.adg01,
         l_adg02     LIKE adg_file.adg02,
         l_adg06     LIKE adg_file.adg06,
         l_adg07     LIKE adg_file.adg07,
         l_adg08     LIKE adg_file.adg08,
         l_adg12     LIKE adg_file.adg12,
         l_adg17     LIKE adg_file.adg17,
         l_adf07     LIKE adf_file.adf07,
         l_img04     LIKE img_file.img04,
         l_img09     LIKE img_file.img09,
         l_dbs       LIKE azp_file.azp03,
         l_adi13     LIKE adi_file.adi13,
         l_adi14     LIKE adi_file.adi14,
         l_oha211    LIKE oha_file.oha211,
         l_ogb       RECORD LIKE ogb_file.*,
         l_ohb       RECORD LIKE ohb_file.*,
         l_img       RECORD LIKE img_file.*,
         t_img       RECORD LIKE img_file.*

  ########UPDATE 集團調撥申請單單身檔[ade_file,adg_file] ########

  SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adi.oga03
  IF SQLCA.sqlcode THEN
     CALL cl_err('azp_file',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  LET l_dbs=p_dbs CLIPPED,"."
  LET g_sql = " SELECT UNIQUE adf07,adg01,adg02,adg03,adg04,adg12,adg17,",
              "        adg06,adg07,adg08 ",
              "   FROM ",p_dbs,".adg_file,",p_dbs,".adf_file",
              "  WHERE adg01 = '",p_adi.adi03,"' AND adg02 = ",p_adi.adi04,
              "    AND adf01 = adg01"
  PREPARE t203_prepare_3_1 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  DECLARE t203_curs_3_1 SCROLL CURSOR FOR t203_prepare_3_1
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  OPEN t203_curs_3_1
  FETCH t203_curs_3_1 INTO l_adf07,l_adg01,l_adg02,l_ade01,
                           l_ade02,l_adg12,l_adg17,
                           l_adg06,l_adg07,l_adg08
  IF SQLCA.sqlcode THEN
     CALL cl_err('','axd-030',0)
     LET g_success = 'N' RETURN
  END IF
  IF cl_null(l_adg12) THEN LET l_adg12=0 END IF   #撥出數量
  IF cl_null(l_adg17) THEN LET l_adg17=0 END IF   #已撥入量
  LET l_tot1 = l_adg12 - l_adg17                  #可撥出量

  IF p_adi.adi10 > l_tot1 THEN     #撥入量大于可撥出量
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-069',1)
     LET g_success = 'N' RETURN
  END IF
  #修改申請單上的已撥入量
  CALL t203_ade13(l_ade01,l_ade02,p_dbs) RETURNING g_flag
  IF g_flag=1 THEN    #若申請單已結案,則不得有異動
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'9004',1)
     LET g_success = 'N' RETURN
  END IF

  LET g_sql = " UPDATE ",p_dbs,".ade_file SET ade15 = ade15 + ",p_adi.adi10,
              "  WHERE ade01 = '",l_ade01,"' AND ade02 = ",l_ade02
  PREPARE t203_prepare_3_2 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_prepare_3_2
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  #修改撥出單上的已撥入量
  LET g_sql = " UPDATE ",p_dbs,".adg_file SET adg17 = adg17 + ",p_adi.adi10,
              "  WHERE adg01 = '",l_adg01,"' AND adg02 = ",l_adg02
  PREPARE t203_prepare_3_3 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_prepare_3_3
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  ##########################update img 在途倉#############################

  LET l_img04 = p_adi.adi04
  LET g_sql = " SELECT ROWID,img_file.* FROM ",p_dbs,".img_file",
              "  WHERE img01 = '",p_adi.adi05,"' AND img02 = '",l_adf07,"'",
   #No.MOD-560296  --begin
#             "    AND img03 = '",p_adi.adi03,"' AND img04 = '",l_img04 CLIPPED,"'"
              "    AND img03 = '",l_img04 CLIPPED,"' AND img04 = '",p_adi.adi03,"'"
   #No.MOD-560296  --end
  PREPARE t203_prepare_3_4 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select img',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  DECLARE t203_curs_3_4 SCROLL CURSOR FOR t203_prepare_3_4
  IF SQLCA.sqlcode THEN
     CALL cl_err('select img',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  OPEN t203_curs_3_4
  FETCH t203_curs_3_4 INTO g_img_rowid,l_img.* #No.FUN-580033
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err(p_adi.adi03,'mfg3465',0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err(p_adi.adi03,'mfg3466',0)
         LET g_success = 'N' RETURN
     END IF
  END IF
  #更新調出倉庫、儲位、批號的img_file的數量 #(倉退)#3
  LET t_dbs = p_dbs CLIPPED,"."
  #No.FUN-560296  --begin
  #              1           2  3           4
  CALL s_upimg1(g_img_rowid,-1,p_adi.adi10,l_img.img16, #No.FUN-580033
  #             5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22  23
                '','','','','','','','','','','','','','','','','','',t_dbs)
  #No.FUN-560296  --end
  IF g_success = 'N' THEN RETURN END IF

  #---->若庫存異動後其庫存量小於等於零時將該筆資料刪除
  #No.FUN-580033  --begin
  #LET g_rowid_t=l_img_rowid
  #CALL s_delimg1(l_img_rowid,p_dbs)  #s_delimg1不參考sma882
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('s_delimg1',SQLCA.sqlcode,0)
  #   LET g_success = 'N' RETURN
  #END IF
  #No.FUN-580033  --end
##############update ima 撥出倉###########################
    IF s_udima1(p_adi.adi05,             #料件編號
                l_img.img23,             #是否可用倉儲
                l_img.img24,             #是否為MRP可用倉儲
                p_adi.adi10*l_img.img21, #調撥數量(換算為料件庫存單)
                l_img.img16,             #最近一次撥出日期
                -1,                      #表撥出
                l_dbs)                   #資料庫編號
        THEN RETURN 1
        END IF
    IF g_success = 'N' THEN RETURN END IF

##############update img 撥入倉###########################

  SELECT ROWID,img_file.*
    INTO l_img_rowid,t_img.*
    FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = p_adi.adi06
     AND img03 = p_adi.adi07 AND img04 = p_adi.adi08
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err('select img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err('select img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     END IF
  END IF
  #No.FUN-580033  --begin
  LET g_factor=1
  IF t_img.img09 <> p_adi.adi09 THEN
     CALL s_umfchk(p_adi.adi05,p_adi.adi09,t_img.img09)
          RETURNING g_cnt,g_factor
     IF g_cnt=1 THEN
        LET g_factor=1
     END IF
  END IF
  LET g_qty=p_adi.adi10*g_factor
  #CALL s_upimg(l_img_rowid,+1,p_adi.adi10,g_adh.adh02,
  CALL s_upimg(l_img_rowid,+1,g_qty      ,g_adh.adh02,
  #No.FUN-580033  --end
       #       5           6           7           8
               p_adi.adi05,p_adi.adi06,p_adi.adi07,p_adi.adi08,
       #       9           10          11          12          13
               g_adh.adh01,p_adi.adi02,p_adi.adi09,p_adi.adi10,p_adi.adi09,
       #       14  15          16   17          18          19
               1,  t_img.img21,1,   t_img.img26,t_img.img35,t_img.img27,
       #       20          21          22
               t_img.img28,t_img.img19,t_img.img36)
  IF g_success = 'N' THEN RETURN END IF

##############update ima 撥入倉###########################

  #---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
  IF s_udima(p_adi.adi05,              #料件編號
             t_img.img23,              #是否可用倉儲
             t_img.img24,              #是否為MRP可用倉儲
             p_adi.adi10*t_img.img21,  #調撥數量(換算為庫存單位)
             t_img.img16,              #最近一次調撥日期
             +1)                       #表調撥入
  THEN LET g_success = 'N' RETURN
  END IF

##############update tlf_file#############################
  CALL t203_tlf(l_img.img10,p_adi.*,'1',l_adf07,t_img.img10,t_img.img35)
  IF g_success = 'N' THEN RETURN END IF
  CALL t203_tlf(l_img.img10,p_adi.*,'2',l_adf07,t_img.img10,t_img.img35)
  IF g_success = 'N' THEN RETURN END IF
  #No.FUN-580033  --begin
  IF g_sma.sma115='Y' THEN
     LET t_adi.*=p_adi.*
     SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=p_adi.adi05
     #在途倉
     CALL t203_update_du(l_adf07,l_img04,p_adi.adi03,-1,+1,p_dbs,'1')
     IF g_success='N' THEN RETURN END IF
     IF NOT cl_null(p_adi.adi33) THEN
        CALL s_delimgg1(NULL,p_adi.adi05,l_adf07,l_img04,
                        p_adi.adi03,p_adi.adi33,p_dbs)
        IF g_success='N' THEN RETURN END IF
     END IF
     IF g_ima906 = '2' AND NOT cl_null(p_adi.adi30) THEN
        CALL s_delimgg1(NULL,p_adi.adi05,l_adf07,l_img04,
                        p_adi.adi03,p_adi.adi30,p_dbs)
        IF g_success='N' THEN RETURN END IF
     END IF

     #撥入倉
     CALL t203_update_du(p_adi.adi06,p_adi.adi07,p_adi.adi08,+1,+1,g_dbs,'2')
     IF g_success='N' THEN RETURN END IF
  END IF
  CALL s_delimg1(g_img_rowid,p_dbs)  #s_delimg1不參考sma882
  IF SQLCA.sqlcode THEN
     CALL cl_err('s_delimg1',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  #No.FUN-580033  --end
################外部調撥################

  ################（產生銷退單單頭）################
  CALL t203_ins_oha(p_adi.oga03,p_adi.adi15)
  IF g_success = 'N' THEN RETURN END IF

  #########INSERT 出貨單單身檔[ohb_file]#############

  SELECT * INTO l_ogb.* FROM ogb_file
   WHERE ogb01=p_adi.adi15 AND ogb02=p_adi.adi16
  SELECT MAX(ohb03)+1 INTO l_ohb.ohb03 FROM ohb_file WHERE ohb01 = g_oha01
  IF cl_null(l_ohb.ohb03) OR l_ohb.ohb03 = 0 THEN
     LET l_ohb.ohb03 = 1
  END IF
  SELECT img09 INTO l_img09 FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = p_adi.adi06
     AND img03 = p_adi.adi07 AND img04 = p_adi.adi08
  CALL s_umfchk(p_adi.adi05,p_adi.adi09,l_img09)
       RETURNING g_cnt,l_fac
  IF g_cnt=1 THEN
     CALL cl_err('','abm-731',0)
     LET l_fac = 1
  END IF
  SELECT oha211 INTO l_oha211 FROM oha_file WHERE oha01=g_oha01
  SELECT adi13,adi14 INTO l_adi13,l_adi14 FROM adi_file
   WHERE adi01=g_adh.adh01 AND adi02=p_adi.adi02
  IF cl_null(l_adi13) THEN LET l_adi13=0 END IF
  IF cl_null(l_adi14) THEN LET l_adi14=0 END IF
#                      1     2     3     4     5     6
  INSERT INTO ohb_file(ohb01,ohb03,ohb30,ohb31,ohb32,ohb33,
#                      7     8     9     10        11    12
                       ohb34,ohb04,ohb05,ohb05_fac,ohb06,ohb07,
#                      13    14    15     16     17    18
                       ohb08,ohb09,ohb091,ohb092,ohb11,ohb12,
#                      19    20    21    22        23    24
                       ohb13,ohb14,ohb15,ohb15_fac,ohb16,ohb60,
 ohb14t,ohb910,ohb911,ohb912,ohb913,ohb914,ohb915,ohb916,ohb917) #No.FUN-580033
#          1       2           3    4           5           6
  VALUES  (g_oha01,l_ohb.ohb03,NULL,p_adi.adi15,p_adi.adi16,g_adh.adh01,
#          7           8           9           10    11         12
           p_adi.adi02,p_adi.adi05,p_adi.adi09,l_fac,l_ogb.ogb06,l_ogb.ogb07,
#          13          14          15          16          17
           l_ogb.ogb08,p_adi.adi06,p_adi.adi07,p_adi.adi08,l_ogb.ogb11,
#          18          19        20       21      22
           p_adi.adi10,l_adi13  ,l_adi14 ,l_img09,l_fac,
#          23                  24
           p_adi.adi10*l_fac  ,0,l_adi14*(1+l_oha211/100), #No.FUN-580033
           p_adi.adi30,p_adi.adi31,p_adi.adi32,p_adi.adi33,#No.FUN-580033
           p_adi.adi34,p_adi.adi35,p_adi.adi09,p_adi.adi10)#No.FUN-580033
 
  IF SQLCA.sqlcode THEN
     CALL cl_err('insert ohb',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  UPDATE oha_file SET oha50=(SELECT SUM(ohb14) FROM ohb_file
                              WHERE ohb01=g_oha01 )
   WHERE oha01=g_oha01
  ##############出貨后upate 采購單上的交貨量############
  CALL t203_bu1(p_adi.adi15,p_adi.adi16,g_oha09)
  IF g_success = 'N' THEN RETURN END IF

END FUNCTION

FUNCTION t203_z()
   DEFINE l_cnt   LIKE type_file.num10    #No.FUN-680108 INTEGER
   DEFINE b_adi   RECORD LIKE adi_file.*  #No:FUN-610090

   IF s_shut(0) THEN RETURN END IF

   IF g_adh.adh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_adh.* FROM adh_file WHERE adh01=g_adh.adh01

   IF g_adh.adhpost = 'N' THEN CALL cl_err('','mfg0178',0) RETURN END IF

   IF g_adh.adhconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF

   IF NOT cl_confirm('asf-663') THEN RETURN END IF

   BEGIN WORK LET g_success = 'Y'

   OPEN t203_cl USING g_adh_rowid
   IF STATUS THEN
      CALL cl_err("OPEN t203_cl:", STATUS, 1)
      CLOSE t203_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t203_cl INTO g_adh.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t203_cl
      ROLLBACK WORK
      RETURN
   END IF


   CALL t203_zz()
   IF SQLCA.SQLCODE THEN LET g_success='N' END IF

   IF g_success = 'Y' THEN
       UPDATE adh_file SET adhpost='N' WHERE adh01=g_adh.adh01 #No.MOD-490398
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd adhpost: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK RETURN
      END IF
      LET g_adh.adhpost='N'
       #LET g_adh.adh06  ='' #No.MOD-490398
      DISPLAY BY NAME g_adh.adhpost,g_adh.adh06 ATTRIBUTE(REVERSE)
      COMMIT WORK
   ELSE
      LET g_adh.adhpost='Y'
      ROLLBACK WORK
   END IF

   MESSAGE ''

   #-----No:FUN-610090-----
   IF g_adh.adhpost = "Y" THEN
      DECLARE t203_s1_c2 CURSOR FOR SELECT * FROM adi_file
        WHERE adi01 = g_adh.adh01

      LET g_imm01 = ""
      LET g_success = "Y"
      BEGIN WORK

      FOREACH t203_s1_c2 INTO b_adi.*
         IF STATUS THEN
            EXIT FOREACH
         END IF

         IF g_sma.sma115 = 'Y' THEN
            IF g_ima906 = '2' THEN  #子母單位
               LET g_unit_arr[1].unit= b_adi.adi30
               LET g_unit_arr[1].fac = b_adi.adi31
               LET g_unit_arr[1].qty = b_adi.adi32
               LET g_unit_arr[2].unit= b_adi.adi33
               LET g_unit_arr[2].fac = b_adi.adi34
               LET g_unit_arr[2].qty = b_adi.adi35
               CALL s_dismantle(g_adh.adh01,b_adi.adi02,g_adh.adh02,
                                b_adi.adi05,b_adi.adi06,b_adi.adi07,
                                b_adi.adi08,g_unit_arr,g_imm01)
                      RETURNING g_imm01
            END IF
         END IF
      END FOREACH

      IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
         COMMIT WORK
         LET g_msg="aimt324 '",g_imm01,"'"
         CALL cl_cmdrun_wait(g_msg)
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   #-----No:FUN-610090 END-----

END FUNCTION

FUNCTION t203_zz()
   IF g_adh.adh00 <> '3' THEN
      CALL t203_z1()
   ELSE
      CALL t203_z1_3()
   END IF
   IF g_success='N' THEN RETURN END IF

END FUNCTION

FUNCTION t203_z1()
  DEFINE b_adi RECORD
               pmm09  LIKE pmm_file.pmm09,   #撥出工廠
               adi02  LIKE adi_file.adi02,   #撥入項次
               adi03  LIKE adi_file.adi03,   #參考單號
               adi04  LIKE adi_file.adi04,   #參考項次
               adi15  LIKE adi_file.adi15,   #采購單號
               adi16  LIKE adi_file.adi16,   #采購項次
               adi05  LIKE adi_file.adi05,   #料件編號
               adi06  LIKE adi_file.adi06,   #倉庫
               adi07  LIKE adi_file.adi07,   #儲位
               adi08  LIKE adi_file.adi08,   #批號
               adi09  LIKE adi_file.adi09,   #單位
               #No.FUN-580033  --begin
               adi10  LIKE adi_file.adi10,   #撥入數量
               adi33  LIKE adi_file.adi33,   #單位二
               adi34  LIKE adi_file.adi34,   #單位二轉換率
               adi35  LIKE adi_file.adi35,   #單位二數量
               adi30  LIKE adi_file.adi30,   #單位一
               adi31  LIKE adi_file.adi31,   #單位一轉換率
               adi32  LIKE adi_file.adi32    #單位一數量
               #No.FUN-580033  --end
               END RECORD,
        l_n     LIKE type_file.num5,        #No.FUN-680108 SMALLINT
        l_buf   LIKE adi_file.adi03,        #No.FUN-680108 VARCHAR(60)
        l_pmm09 LIKE pmm_file.pmm09

  #對于adi中的每一筆都要insert到adq_file中
  #No.FUN-580033  --begin
  DECLARE t203_z1_c1 CURSOR FOR
   SELECT pmm09,adi02,adi03,adi04,adi15,adi16,adi05,adi06,adi07,
          adi08,adi09,adi10,adi33,adi34,adi35,adi30,adi31,adi32
     FROM adi_file,OUTER (pmn_file,OUTER pmm_file)
    WHERE adi01=g_adh.adh01
      AND pmm_file.pmm01 = pmn_file.pmn01 AND adi03 = pmn_file.pmn24 AND adi04 = pmn_file.pmn25
    ORDER BY pmm09,adi03,adi04,adi02
  #No.FUN-580033  --end
  LET l_pmm09 = NULL
  FOREACH t203_z1_c1 INTO b_adi.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_adi.adi03) THEN CONTINUE FOREACH END IF
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM ade_file,add_file
       WHERE ade16 = g_adh.adh01 AND ade17 = b_adi.adi02
         AND add01 = ade01 AND addconf='Y'
         AND add00 = '3'
      LET l_buf = g_adh.adh01 CLIPPED,' ',b_adi.adi02 CLIPPED
      IF cl_null(l_n) THEN LET l_n = 0 END IF
      IF l_n > 0 THEN
         CALL cl_err(l_buf,'axd-080',0)
         LET g_success = 'N'
         RETURN
      END IF
      IF cl_null(l_pmm09) OR l_pmm09 <> b_adi.pmm09 THEN   #單身換成另一個工廠
         LET g_head = 1                                    #或是內部調撥
      ELSE
         LET g_head = 0
      END IF
      CASE g_adh.adh00
           WHEN '1' CALL t203_z2_1(b_adi.*)
           WHEN '2' CALL t203_z2_2(b_adi.*)
      END CASE
      LET l_pmm09 = b_adi.pmm09
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION

FUNCTION t203_z1_3()
  DEFINE b_adi RECORD
               oga03  LIKE oga_file.oga03,   #撥出工廠
               adi02  LIKE adi_file.adi02,   #撥入項次
               adi03  LIKE adi_file.adi03,   #撥出單號
               adi04  LIKE adi_file.adi04,   #撥出項次
               adi15  LIKE adi_file.adi15,   #出貨單號
               adi16  LIKE adi_file.adi16,   #出貨項次
               adi05  LIKE adi_file.adi05,   #料件編號
               adi06  LIKE adi_file.adi06,   #倉庫
               adi07  LIKE adi_file.adi07,   #儲位
               adi08  LIKE adi_file.adi08,   #批號
               adi09  LIKE adi_file.adi09,   #單位
               #No.FUN-580033  --begin
               adi10  LIKE adi_file.adi10,   #撥入數量
               adi33  LIKE adi_file.adi33,   #單位二
               adi34  LIKE adi_file.adi34,   #單位二轉換率
               adi35  LIKE adi_file.adi35,   #單位二數量
               adi30  LIKE adi_file.adi30,   #單位一
               adi31  LIKE adi_file.adi31,   #單位一轉換率
               adi32  LIKE adi_file.adi32    #單位一數量
               #No.FUN-580033  --end
               END RECORD,
        l_oga03 LIKE oga_file.oga03,
        l_adi15 LIKE adi_file.adi15

  #對于adi中的每一筆都要insert到adq_file中
  #No.FUN-580033  --begin
  DECLARE t203_z1_3 CURSOR FOR
   SELECT oga03,adi02,adi03,adi04,adi15,adi16,adi05,
          adi06,adi07,adi08,adi09,adi10,adi33,adi34,adi35,adi30,adi31,adi32
     FROM adi_file,oga_file,ogb_file
    WHERE adi01=g_adh.adh01 AND oga01 = ogb01
      AND adi15 = ogb01 AND adi16 = ogb03
    ORDER BY oga03,adi15,adi16,adi02
  #No.FUN-580033  --end
  LET l_oga03 = NULL
  FOREACH t203_z1_3 INTO b_adi.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_adi.adi03) THEN CONTINUE FOREACH END IF
      #檢查是不是有倉退申請狀況,如果是的話,不能過帳還原

      IF cl_null(l_oga03) OR l_oga03 <> b_adi.oga03 THEN   #單身換成另一個工廠
         LET g_head = 1                                    #或是內部調撥
      ELSE
         LET g_head = 0
         IF g_adh.adh00 = '3' THEN
            IF cl_null(l_adi15) OR l_adi15 <> b_adi.adi15 THEN
               LET g_head = 1
            ELSE
               LET g_head = 0
            END IF
         END IF
      END IF
      CALL t203_z2_3(b_adi.*)
      LET l_oga03 = b_adi.oga03
      LET l_adi15 = b_adi.adi15
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION

FUNCTION t203_z2_1(p_adi)
  DEFINE p_adi   RECORD
                 pmm09  LIKE pmm_file.pmm09,   #撥出工廠
                 adi02  LIKE adi_file.adi02,   #撥入項次
                 adi03  LIKE adi_file.adi03,   #參考單號
                 adi04  LIKE adi_file.adi04,   #參考項次
                 adi15  LIKE adi_file.adi15,   #采購單號
                 adi16  LIKE adi_file.adi16,   #采購項次
                 adi05  LIKE adi_file.adi05,   #料件編號
                 adi06  LIKE adi_file.adi06,   #倉庫
                 adi07  LIKE adi_file.adi07,   #儲位
                 adi08  LIKE adi_file.adi08,   #批號
                 adi09  LIKE adi_file.adi09,   #單位
                 #No.FUN-580033  --begin
                 adi10  LIKE adi_file.adi10,   #撥入數量
                 adi33  LIKE adi_file.adi33,   #單位二
                 adi34  LIKE adi_file.adi34,   #單位二轉換率
                 adi35  LIKE adi_file.adi35,   #單位二數量
                 adi30  LIKE adi_file.adi30,   #單位一
                 adi31  LIKE adi_file.adi31,   #單位一轉換率
                 adi32  LIKE adi_file.adi32    #單位一數量
                 #No.FUN-580033  --end
                 END RECORD,
         l_tot1  LIKE adg_file.adg12,
         l_adg   RECORD LIKE adg_file.*,
         p_dbs   LIKE azp_file.azp03,
         t_img,l_img     RECORD LIKE img_file.*,
         l_img_rowid     LIKE type_file.chr18,        #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         l_adf07 LIKE adf_file.adf07,
         l_adf02 LIKE adf_file.adf02,
         l_adg01 LIKE adg_file.adg01,
         l_adg02 LIKE adg_file.adg02,
         l_adg12 LIKE adg_file.adg12,
         l_adg17 LIKE adg_file.adg17,
         l_ade01 LIKE ade_file.ade01,
         l_ade02 LIKE ade_file.ade02,
         l_ade13 LIKE ade_file.ade13,
         l_cnt   LIKE type_file.num5,                 #No.FUN-680108 SMALLINT
         l_buf   LIKE adi_file.adi03                  #No.FUN-680108 VARCHAR(60)

  ####################UPDATE 集團調撥申請單單身檔[ade_file] ################

  SELECT adg01,adg02,adg03,adg04,adg12,adg17
    INTO l_adg01,l_adg02,l_ade01,l_ade02,l_adg12,l_adg17
    FROM adg_file,adi_file
   WHERE adi03 = adg01 AND adi04 = adg02
     AND adi01 = g_adh.adh01 AND adi02 = p_adi.adi02
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF

  IF cl_null(l_adg12) THEN LET l_adg12 = 0 END IF
  IF cl_null(l_adg17) THEN LET l_adg17 = 0 END IF
  LET l_tot1 = l_adg12 - l_adg17
  IF l_tot1 + p_adi.adi10 < 0 THEN
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-069',1)
     LET g_success = 'N' RETURN
  END IF

  #更新申請單上已撥入撥量
  SELECT ade13 INTO l_ade13 FROM ade_file WHERE ade01=l_ade01 AND ade02=l_ade02
  IF cl_null(l_ade13) OR l_ade13='Y' THEN    #若申請單已結案,則不得有異動
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'9004',1)
     LET g_success = 'N' RETURN
  END IF
  UPDATE ade_file SET ade15 = ade15 - p_adi.adi10
   WHERE ade01 = l_ade01 AND ade02 = l_ade02
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  #更新申請單上已撥入撥量
  UPDATE adg_file SET adg17 = adg17 - p_adi.adi10
   WHERE adg01 = l_adg01 AND adg02 = l_adg02
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  ##########################update img 在途倉#############################

  SELECT UNIQUE adf07 INTO l_adf07 FROM adf_file,adg_file     #撥出單在途倉
   WHERE adf01 = adg01 AND adg01 = p_adi.adi03 AND adg02 = p_adi.adi04
  SELECT ROWID,img_file.* INTO l_img_rowid,l_img.* FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = l_adf07
 #    AND img03 = p_adi.adi03 AND img04 = p_adi.adi04  #No.MOD-560296
      AND img03 = p_adi.adi04 AND img04 = p_adi.adi03  #No.MOD-560296
  IF SQLCA.sqlcode = 100 THEN             #表示沒有該在途倉的資料，加重新INSERT
     #更新調出倉庫、儲位、批號的img_file的數量
     #            1           2  3           4
     SELECT adg_file.*,adf02 INTO l_adg.*,l_adf02 FROM adg_file,adf_file
      WHERE adg01 = p_adi.adi03 AND adg02 = p_adi.adi04
        AND adg01 = adf01
     CALL s_upimg(-3333,+1,p_adi.adi10,l_adf02,
#       5           6           7           8
 #      p_adi.adi05,l_adf07,l_adg.adg01,l_adg.adg02,  #No.MOD-560296
        p_adi.adi05,l_adf07,l_adg.adg02,l_adg.adg01,  #No.MOD-560296
#       9           10          11          12          13
       l_adg.adg01,l_adg.adg02,l_adg.adg11,p_adi.adi10,l_adg.adg11,
#       14  15   16   17  18  19  20  21  22
       1,  '',   1, '',  '', '', '', '', '')
     IF g_success = 'N' THEN RETURN END IF
  ELSE                         #表示該在途倉還存在,只要UPDATE
     IF SQLCA.sqlcode THEN
        #---->已被別的使用者鎖住
        IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
            LET g_errno = 'mfg3465'
            LET g_success = 'N' RETURN
        ELSE
            LET g_errno = 'mfg3466'
            LET g_success = 'N' RETURN
        END IF
     END IF
     #更新調出倉庫、儲位、批號的img_file的數量
     #            1           2  3           4
     CALL s_upimg(l_img_rowid,+1,p_adi.adi10,l_img.img16,
     #            5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22
                  '','','','','','','','','','','','','','','','','','')
     IF g_success = 'N' THEN RETURN END IF
  END IF
##############update img 撥入倉###########################

  SELECT ROWID,img_file.*
    INTO l_img_rowid,t_img.*
    FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = p_adi.adi06
     AND img03 = p_adi.adi07 AND img04 = p_adi.adi08
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         LET g_success = 'N' RETURN
     END IF
  END IF
  #No.FUN-580033  --begin
  LET g_factor=1
  IF t_img.img09 <> p_adi.adi09 THEN
     CALL s_umfchk(p_adi.adi05,p_adi.adi09,t_img.img09)
          RETURNING g_cnt,g_factor
     IF g_cnt=1 THEN
        LET g_factor=1
     END IF
  END IF
  LET g_qty=p_adi.adi10*g_factor
  #CALL s_upimg(l_img_rowid,-1,p_adi.adi10,g_adh.adh02,
  CALL s_upimg(l_img_rowid,-1,g_qty,g_adh.adh02,
  #No.FUN-580033  --end
               '','','','','','','','','','','','','','','','','','')
  IF g_success = 'N' THEN RETURN END IF

##############update ima 撥入倉###########################

  #---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
  IF s_udima(p_adi.adi05,              #料件編號
             t_img.img23,              #是否可用倉儲
             t_img.img24,              #是否為MRP可用倉儲
             p_adi.adi10*t_img.img21,  #調撥數量(換算為庫存單位)
             t_img.img16,              #最近一次調撥日期
             -1)                       #表調撥入
  THEN LET g_success = 'N' RETURN
  END IF

##############update tlf_file#############################

  DELETE FROM tlf_file WHERE (tlf026 = g_adh.adh01 OR tlf036 = g_adh.adh01)
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_adh.adh01,SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
  #No.FUN-580033  --begin
  IF g_sma.sma115='Y' THEN
     LET t_adi.*=p_adi.*
     SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=p_adi.adi05
     #在途倉
     CALL t203_update_du(l_adf07,p_adi.adi04,p_adi.adi03,+1,-1,g_dbs,'1')
     IF g_success='N' THEN RETURN END IF

     #撥入倉
     CALL t203_update_du(p_adi.adi06,p_adi.adi07,p_adi.adi08,-1,-1,g_dbs,'2')
     IF g_success='N' THEN RETURN END IF
     IF g_ima906 MATCHES '[23]' THEN
        DELETE FROM tlff_file
         WHERE (tlff026 = g_adh.adh01 OR tlff036 = g_adh.adh01)
           AND (tlff027 = t_adi.adi02 OR tlff037 = t_adi.adi02)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err(g_adh.adh01,SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
  END IF
  #No.FUN-580033  --end
END FUNCTION

FUNCTION t203_z2_2(p_adi)
  DEFINE p_adi   RECORD
                 pmm09  LIKE pmm_file.pmm09,   #撥出工廠
                 adi02  LIKE adi_file.adi02,   #撥入項次
                 adi03  LIKE adi_file.adi03,   #參考單號
                 adi04  LIKE adi_file.adi04,   #參考項次
                 adi15  LIKE adi_file.adi15,   #采購單號
                 adi16  LIKE adi_file.adi16,   #采購項次
                 adi05  LIKE adi_file.adi05,   #料件編號
                 adi06  LIKE adi_file.adi06,   #倉庫
                 adi07  LIKE adi_file.adi07,   #儲位
                 adi08  LIKE adi_file.adi08,   #批號
                 adi09  LIKE adi_file.adi09,   #單位
                 #No.FUN-580033  --begin
                 adi10  LIKE adi_file.adi10,   #撥入數量
                 adi33  LIKE adi_file.adi33,   #單位二
                 adi34  LIKE adi_file.adi34,   #單位二轉換率
                 adi35  LIKE adi_file.adi35,   #單位二數量
                 adi30  LIKE adi_file.adi30,   #單位一
                 adi31  LIKE adi_file.adi31,   #單位一轉換率
                 adi32  LIKE adi_file.adi32    #單位一數量
                 #No.FUN-580033  --end
                 END RECORD,
         l_tot1  LIKE adg_file.adg12,
         l_adg   RECORD LIKE adg_file.*,
         p_dbs   LIKE azp_file.azp03,
         l_dbs   LIKE azp_file.azp03,
         t_img,l_img     RECORD LIKE img_file.*,
         l_img_rowid     LIKE type_file.chr18,         #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         l_img04 LIKE img_file.img04,
         l_adf07 LIKE adf_file.adf07,
         l_adf02 LIKE adf_file.adf02,
         l_adg01 LIKE adg_file.adg01,
         l_adg02 LIKE adg_file.adg02,
         l_adg12 LIKE adg_file.adg12,
         l_adg17 LIKE adg_file.adg17,
         l_ade01 LIKE ade_file.ade01,
         l_ade02 LIKE ade_file.ade02,
         l_cnt   LIKE type_file.num5,                  #No.FUN-680108 SMALLINT
         l_buf   LIKE adi_file.adi03                   #No.FUN-680108 VARCHAR(60)

  ##################UPDATE 集團調撥申請單單身檔[ade_file] ##################

  SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adi.pmm09
  LET l_dbs=p_dbs CLIPPED,"."
  LET g_sql = " SELECT UNIQUE adf02,adf07,adg01,adg02,adg03,adg04,adg_file.* ",
              "   FROM ",p_dbs,".adg_file,",p_dbs,".adf_file",
              "  WHERE adg01 = '",p_adi.adi03,"' AND adg02 = ",p_adi.adi04,
              "    AND adf01 = adg01"
  PREPARE t203_prepare10 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  DECLARE t203_curs10 SCROLL CURSOR FOR t203_prepare10
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  OPEN t203_curs10
  FETCH t203_curs10 INTO l_adf02,l_adf07,l_adg01,l_adg02,
                         l_ade01,l_ade02,l_adg.*
  IF SQLCA.sqlcode THEN
     CALL cl_err('','axd-030',0)
     LET g_success = 'N' RETURN
  END IF
  IF cl_null(l_adg.adg12) THEN LET l_adg.adg12 = 0 END IF
  IF cl_null(l_adg.adg17) THEN LET l_adg.adg17 = 0 END IF
  LET l_tot1 = l_adg.adg12 - l_adg.adg17
  IF l_tot1 + p_adi.adi10 < 0 THEN
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-069',1)
     LET g_success = 'N' RETURN
  END IF

  #修改申請單上的已撥入量
  CALL t203_ade13(l_ade01,l_ade02,p_dbs) RETURNING g_flag
  IF g_flag=1 THEN    #若申請單已結案,則不得有異動
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'9004',1)
     LET g_success = 'N' RETURN
  END IF

  LET g_sql = " UPDATE ",p_dbs,".ade_file SET ade15 = ade15 - ",p_adi.adi10,
              "  WHERE ade01 = '",l_ade01,"' AND ade02 = ",l_ade02
  PREPARE t203_prepare11 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_prepare11
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  #修改撥出單上的已撥入量
  LET g_sql = " UPDATE ",p_dbs,".adg_file SET adg17 = adg17 - ",p_adi.adi10,
              "  WHERE adg01 = '",l_adg01,"' AND adg02 = ",l_adg02
  PREPARE t203_prepare14 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_prepare14
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  ##########################update img 在途倉#############################

  LET l_img04=p_adi.adi04
  LET g_sql = " SELECT ROWID,img_file.* FROM ",p_dbs CLIPPED,".img_file",
              "  WHERE img01 = '",p_adi.adi05,"' AND img02 = '",l_adf07,"'",
   #No.MOD-560296  --begin
#             "    AND img03 = '",p_adi.adi03,"' AND img04 = '",l_img04 CLIPPED,"'"
              "    AND img03 = '",l_img04 CLIPPED,"' AND img04 = '",p_adi.adi03,"'"
   #No.MOD-560296  --end
  PREPARE t203_prepare12 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select img',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  DECLARE t203_curs12 SCROLL CURSOR FOR t203_prepare12
  IF SQLCA.sqlcode THEN
     CALL cl_err('select img',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  OPEN t203_curs12
  FETCH t203_curs12 INTO l_img_rowid,l_img.*
  IF SQLCA.sqlcode = 100 THEN          #表示沒有該在途倉的資料，加重新INSERT
     LET t_dbs = p_dbs CLIPPED,"."
     #No.FUN-560296  --begin
     #             1     2  3           4
     CALL s_upimg1(-3333,+1,p_adi.adi10,l_adf02,
     #             5           6           7           8
 #                  p_adi.adi05,l_adf07,l_adg.adg01,l_adg.adg02,  #No.MOD-560296
                    p_adi.adi05,l_adf07,l_adg.adg02,l_adg.adg01,  #No.MOD-560296
     #             9           10          11          12          13
                   l_adg.adg01,l_adg.adg02,l_adg.adg11,p_adi.adi10,l_adg.adg11,
     #             14  15   16   17  18  19  20  21  22
                   1,  '',   1, '',  '', '', '', '', '',t_dbs)
     #No.FUN-560296  --end
     OPEN t203_curs12
     FETCH t203_curs12 INTO l_img_rowid,l_img.*
     IF g_success = 'N' THEN RETURN END IF
  ELSE
     IF SQLCA.sqlcode THEN
        #---->已被別的使用者鎖住
        IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
            LET g_errno = 'mfg3465'
            LET g_success = 'N' RETURN
        ELSE
            LET g_errno = 'mfg3466'
            LET g_success = 'N' RETURN
        END IF
     END IF
     #更新調出倉庫、儲位、批號的img_file的數量
     LET t_dbs = p_dbs CLIPPED,"."
     #No.FUN-560296  --begin
     #              1           2  3           4
     CALL s_upimg1(l_img_rowid,+1,p_adi.adi10,l_img.img16,
     #             5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22  23
                   '','','','','','','','','','','','','','','','','','',t_dbs)
     #No.FUN-560296  --end
     IF g_success = 'N' THEN RETURN END IF
  END IF
##############update ima 撥出倉###########################
    IF s_udima1(p_adi.adi05,             #料件編號
                l_img.img23,             #是否可用倉儲
                l_img.img24,             #是否為MRP可用倉儲
                p_adi.adi10*l_img.img21, #調撥數量(換算為料件庫存單)
                l_img.img16,             #最近一次撥出日期
                +1,                      #表撥出
                l_dbs)                   #資料庫編號
        THEN RETURN 1
        END IF
    IF g_success = 'N' THEN RETURN END IF
##############update img 撥入倉###########################

  SELECT ROWID,img_file.*
    INTO l_img_rowid,t_img.*
    FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = p_adi.adi06
     AND img03 = p_adi.adi07 AND img04 = p_adi.adi08
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         LET g_success = 'N' RETURN
     END IF
  END IF
  #No.FUN-580033  --begin
  LET g_factor=1
  IF t_img.img09 <> p_adi.adi09 THEN
     CALL s_umfchk(p_adi.adi05,p_adi.adi09,t_img.img09)
          RETURNING g_cnt,g_factor
     IF g_cnt=1 THEN
        LET g_factor=1
     END IF
  END IF
  LET g_qty=p_adi.adi10*g_factor
  #CALL s_upimg(l_img_rowid,-1,p_adi.adi10,g_adh.adh02,
  CALL s_upimg(l_img_rowid,-1,g_qty,g_adh.adh02,
  #No.FUN-580033  --end
               '','','','','','','','','','','','','','','','','','')
  IF g_success = 'N' THEN RETURN END IF

##############update ima 撥入倉###########################

  #---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
  IF s_udima(p_adi.adi05,              #料件編號
             t_img.img23,              #是否可用倉儲
             t_img.img24,              #是否為MRP可用倉儲
             p_adi.adi10*t_img.img21,  #調撥數量(換算為庫存單位)
             t_img.img16,              #最近一次調撥日期
             -1)                       #表調撥入
  THEN LET g_success = 'N' RETURN
  END IF

##############update tlf_file#############################

  DELETE FROM tlf_file WHERE (tlf026 = g_adh.adh01 OR tlf036 = g_adh.adh01)
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_adh.adh01,SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF

  #No.FUN-580033  --begin
  IF g_sma.sma115='Y' THEN
     LET t_adi.*=p_adi.*
     SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=p_adi.adi05
     #在途倉
     CALL t203_update_du(l_adf07,l_img04,p_adi.adi03,+1,-1,p_dbs,'1')
     IF g_success='N' THEN RETURN END IF

     #撥入倉
     CALL t203_update_du(p_adi.adi06,p_adi.adi07,p_adi.adi08,-1,-1,g_dbs,'2')
     IF g_success='N' THEN RETURN END IF
     IF g_ima906 MATCHES '[23]' THEN
        DELETE FROM tlff_file
         WHERE (tlff026 = g_adh.adh01 OR tlff036 = g_adh.adh01)
           AND (tlff027 = t_adi.adi02 OR tlff037 = t_adi.adi02)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err(g_adh.adh01,SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
  END IF
  #No.FUN-580033  --end
################外部調撥（出貨單、收貨單、收貨入庫單）################
  IF g_head = 1 THEN
     LET g_sql = " DELETE FROM ",p_dbs CLIPPED,".oga_file ",   #（出貨單）
                 "  WHERE oga16 = '",g_adh.adh01,"'",
                 "    AND oga03 = '",g_plant,"'"
     PREPARE t203_pre7 FROM g_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete oga',SQLCA.sqlcode,0)
        LET g_success = 'N'
        RETURN
     END IF
     EXECUTE t203_pre7
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete oga',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
     LET g_sql = " DELETE FROM ",p_dbs CLIPPED,".ogb_file ",
                 "  WHERE ogb31 = '",g_adh.adh01,"'",
                 "    AND ogb08 = '",g_plant,"'"
     PREPARE t203_pre8 FROM g_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete ogb',SQLCA.sqlcode,0)
        LET g_success = 'N'
        RETURN
     END IF
     EXECUTE t203_pre8
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete ogb',SQLCA.sqlcode,0)
        LET g_success = 'N'
        RETURN
     END IF
     #（收貨單）
     SELECT rva01 INTO g_rva01 FROM rva_file
      WHERE rva07 = g_adh.adh01
        AND rva05 = p_adi.pmm09
     DELETE FROM rva_file WHERE rva01 = g_rva01
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete rva',SQLCA.sqlcode,0)
        LET g_success = 'N' RETURN
     END IF
     DELETE FROM rvb_file WHERE rvb01 = g_rva01
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete rvb',SQLCA.sqlcode,0)
        LET g_success = 'N' RETURN
     END IF
     #（入庫單）
     SELECT rvu01 INTO g_rvu01 FROM rvu_file WHERE rvu02 = g_rva01 AND rvu00='1'
     DELETE FROM rvu_file WHERE rvu02 = g_rva01 AND rvu00 = '1'
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete rvu',SQLCA.sqlcode,0)
        LET g_success = 'N' RETURN
     END IF
     DELETE FROM rvv_file WHERE rvv01 = g_rvu01
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete rvv',SQLCA.sqlcode,0)
        LET g_success = 'N' RETURN
     END IF
  END IF
  ##########################upate 采購單上的交貨量#######################
  CALL t203_upd_pmn2(p_adi.adi15,p_adi.adi16)
  IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION t203_z2_3(p_adi)
  DEFINE p_adi   RECORD
                 oga03  LIKE oga_file.oga03,   #撥出工廠
                 adi02  LIKE adi_file.adi02,   #撥入項次
                 adi03  LIKE adi_file.adi03,   #撥出單號
                 adi04  LIKE adi_file.adi04,   #撥出項次
                 adi15  LIKE adi_file.adi15,   #出貨單號
                 adi16  LIKE adi_file.adi16,   #出貨項次
                 adi05  LIKE adi_file.adi05,   #料件編號
                 adi06  LIKE adi_file.adi06,   #倉庫
                 adi07  LIKE adi_file.adi07,   #儲位
                 adi08  LIKE adi_file.adi08,   #批號
                 adi09  LIKE adi_file.adi09,   #單位
                 #No.FUN-580033  --begin
                 adi10  LIKE adi_file.adi10,   #撥入數量
                 adi33  LIKE adi_file.adi33,   #單位二
                 adi34  LIKE adi_file.adi34,   #單位二轉換率
                 adi35  LIKE adi_file.adi35,   #單位二數量
                 adi30  LIKE adi_file.adi30,   #單位一
                 adi31  LIKE adi_file.adi31,   #單位一轉換率
                 adi32  LIKE adi_file.adi32    #單位一數量
                 #No.FUN-580033  --end
                 END RECORD,
         l_tot1  LIKE adg_file.adg12,
         l_adg   RECORD LIKE adg_file.*,
         p_dbs   LIKE azp_file.azp03,
         l_dbs   LIKE azp_file.azp03,
         t_img,l_img     RECORD LIKE img_file.*,
         l_img_rowid     LIKE type_file.chr18,         #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         l_img04 LIKE img_file.img04,
         l_adf07 LIKE adf_file.adf07,
         l_adf02 LIKE adf_file.adf02,
         l_adg01 LIKE adg_file.adg01,
         l_adg02 LIKE adg_file.adg02,
         l_adg12 LIKE adg_file.adg12,
         l_adg17 LIKE adg_file.adg17,
         l_ade01 LIKE ade_file.ade01,
         l_ade02 LIKE ade_file.ade02,
         l_cnt   LIKE type_file.num5,                 #No.FUN-680108 SMALLINT
         l_buf   LIKE adi_file.adi03                  #No.FUN-680108 VARCHAR(60)

  ##################UPDATE 集團調撥申請單單身檔[ade_file] ##################

  SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adi.oga03
  LET l_dbs=p_dbs CLIPPED,"."
  LET g_sql = " SELECT UNIQUE adf02,adf07,adg01,adg02,adg03,adg04,adg_file.* ",
              "   FROM ",p_dbs,".adg_file,",p_dbs,".adf_file",
              "  WHERE adg01 = '",p_adi.adi03,"' AND adg02 = ",p_adi.adi04,
              "    AND adf01 = adg01"
  PREPARE t203_prepare_3_5 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  DECLARE t203_curs_3_5 SCROLL CURSOR FOR t203_prepare_3_5
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  OPEN t203_curs_3_5
  FETCH t203_curs_3_5 INTO l_adf02,l_adf07,l_adg01,l_adg02,
                           l_ade01,l_ade02,l_adg.*
  IF SQLCA.sqlcode THEN
     CALL cl_err('','axd-030',0)
     LET g_success = 'N' RETURN
  END IF
  IF cl_null(l_adg.adg12) THEN LET l_adg.adg12 = 0 END IF
  IF cl_null(l_adg.adg17) THEN LET l_adg.adg17 = 0 END IF
  LET l_tot1 = l_adg.adg12 - l_adg.adg17
  IF l_tot1 + p_adi.adi10 < 0 THEN
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-069',1)
     LET g_success = 'N' RETURN
  END IF

  #修改申請單上的已撥入量
  CALL t203_ade13(l_ade01,l_ade02,p_dbs) RETURNING g_flag
  IF g_flag=1 THEN    #若申請單已結案,則不得有異動
     LET l_buf = p_adi.adi03 CLIPPED,' ',p_adi.adi04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'9004',1)
     LET g_success = 'N' RETURN
  END IF
  LET g_sql = " UPDATE ",p_dbs,".ade_file SET ade15 = ade15 - ",p_adi.adi10,
              "  WHERE ade01 = '",l_ade01,"' AND ade02 = ",l_ade02
  PREPARE t203_prepare_3_6 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_prepare_3_6
  IF SQLCA.sqlcode THEN
     CALL cl_err('update ade',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  #修改撥出單上的已撥入量
  LET g_sql = " UPDATE ",p_dbs,".adg_file SET adg17 = adg17 - ",p_adi.adi10,
              "  WHERE adg01 = '",l_adg01,"' AND adg02 = ",l_adg02
  PREPARE t203_prepare_3_7 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_prepare_3_7
  IF SQLCA.sqlcode THEN
     CALL cl_err('update adg',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF

  ##########################update img 在途倉#############################

  LET l_img04=p_adi.adi04
  LET g_sql = " SELECT ROWID,img_file.* FROM ",p_dbs CLIPPED,".img_file",
              "  WHERE img01 = '",p_adi.adi05,"' AND img02 = '",l_adf07,"'",
   #No.MOD-560296  --begin
#             "    AND img03 = '",p_adi.adi03,"' AND img04 = '",l_img04 CLIPPED,"'"
              "    AND img03 = '",l_img04 CLIPPED,"' AND img04 = '",p_adi.adi03,"'"
   #No.MOD-560296  --end
  PREPARE t203_prepare_3_8 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select img',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  DECLARE t203_curs_3_8 SCROLL CURSOR FOR t203_prepare_3_8
  IF SQLCA.sqlcode THEN
     CALL cl_err('select img',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  OPEN t203_curs_3_8
  FETCH t203_curs_3_8 INTO l_img_rowid,l_img.*
  IF SQLCA.sqlcode = 100 THEN          #表示沒有該在途倉的資料，加重新INSERT
     LET t_dbs = p_dbs CLIPPED,"."
     #No.FUN-560296  --begin
     #             1     2  3           4
     CALL s_upimg1(-3333,+1,p_adi.adi10,l_adf02,
     #             5           6           7           8
 #                  p_adi.adi05,l_adf07,l_adg.adg01,l_adg.adg02,  #No.MOD-560296
                    p_adi.adi05,l_adf07,l_adg.adg02,l_adg.adg01,  #No.MOD-560296
     #             9           10          11          12          13
                   l_adg.adg01,l_adg.adg02,l_adg.adg11,p_adi.adi10,l_adg.adg11,
     #             14  15   16   17  18  19  20  21  22
                   1,  '',   1, '',  '', '', '', '', '',t_dbs)
     #No.FUN-560296  --end
     OPEN t203_curs_3_8
     FETCH t203_curs_3_8 INTO l_img_rowid,l_img.*
     IF g_success = 'N' THEN RETURN END IF
  ELSE
     IF SQLCA.sqlcode THEN
        #---->已被別的使用者鎖住
        IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
            LET g_errno = 'mfg3465'
            LET g_success = 'N' RETURN
        ELSE
            LET g_errno = 'mfg3466'
            LET g_success = 'N' RETURN
        END IF
     END IF
     #更新調出倉庫、儲位、批號的img_file的數量
     LET t_dbs = p_dbs CLIPPED,"."
     #No.FUN-560296  --begin
     #              1           2  3           4
     CALL s_upimg1(l_img_rowid,+1,p_adi.adi10,l_img.img16,
     #             5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22  23
                   '','','','','','','','','','','','','','','','','','',t_dbs)
     #No.FUN-560296  --end
     IF g_success = 'N' THEN RETURN END IF
  END IF
##############update ima 撥出倉###########################
    IF s_udima1(p_adi.adi05,             #料件編號
                l_img.img23,             #是否可用倉儲
                l_img.img24,             #是否為MRP可用倉儲
                p_adi.adi10*l_img.img21, #調撥數量(換算為料件庫存單)
                l_img.img16,             #最近一次撥出日期
                +1,                      #表撥出
                l_dbs)                   #資料庫編號
        THEN RETURN 1
        END IF
    IF g_success = 'N' THEN RETURN END IF
##############update img 撥入倉###########################

  SELECT ROWID,img_file.*
    INTO l_img_rowid,t_img.*
    FROM img_file
   WHERE img01 = p_adi.adi05 AND img02 = p_adi.adi06
     AND img03 = p_adi.adi07 AND img04 = p_adi.adi08
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         LET g_success = 'N' RETURN
     END IF
  END IF
  #No.FUN-580033  --begin
  LET g_factor=1
  IF t_img.img09 <> p_adi.adi09 THEN
     CALL s_umfchk(p_adi.adi05,p_adi.adi09,t_img.img09)
          RETURNING g_cnt,g_factor
     IF g_cnt=1 THEN
        LET g_factor=1
     END IF
  END IF
  LET g_qty=p_adi.adi10*g_factor
  #CALL s_upimg(l_img_rowid,-1,p_adi.adi10,g_adh.adh02,
  CALL s_upimg(l_img_rowid,-1,g_qty,g_adh.adh02,
  #No.FUN-580033  --end
               '','','','','','','','','','','','','','','','','','')
  IF g_success = 'N' THEN RETURN END IF

##############update ima 撥入倉###########################

  #---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
  IF s_udima(p_adi.adi05,              #料件編號
             t_img.img23,              #是否可用倉儲
             t_img.img24,              #是否為MRP可用倉儲
             p_adi.adi10*t_img.img21,  #調撥數量(換算為庫存單位)
             t_img.img16,              #最近一次調撥日期
             -1)                       #表調撥入
  THEN LET g_success = 'N' RETURN
  END IF

##############update tlf_file#############################

  DELETE FROM tlf_file WHERE (tlf026 = g_adh.adh01 OR tlf036 = g_adh.adh01)
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_adh.adh01,SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF

  #No.FUN-580033  --begin
  IF g_sma.sma115='Y' THEN
     LET t_adi.*=p_adi.*
     SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=p_adi.adi05
     #在途倉
     CALL t203_update_du(l_adf07,l_img04,p_adi.adi03,+1,-1,p_dbs,'1')
     IF g_success='N' THEN RETURN END IF

     #撥入倉
     CALL t203_update_du(p_adi.adi06,p_adi.adi07,p_adi.adi08,-1,-1,g_dbs,'2')
     IF g_success='N' THEN RETURN END IF
     IF g_ima906 MATCHES '[23]' THEN
        DELETE FROM tlff_file
         WHERE (tlff026 = g_adh.adh01 OR tlff036 = g_adh.adh01)
           AND (tlff027 = t_adi.adi02 OR tlff037 = t_adi.adi02)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err(g_adh.adh01,SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
  END IF
  #No.FUN-580033  --end
################外部調撥（銷退單）################
  IF g_head = 1 THEN
     SELECT oha01,oha09 INTO g_oha01,g_oha09 FROM oha_file
      WHERE oha01 = (SELECT UNIQUE ohb01 FROM ohb_file
                      WHERE ohb33=g_adh.adh01 AND ohb34 = p_adi.adi02)
     DELETE FROM oha_file WHERE oha01 = g_oha01
     IF SQLCA.sqlcode THEN
        CALL cl_err('delete oha',SQLCA.sqlcode,0)
        LET g_success = 'N'
        RETURN
     END IF
  END IF
  DELETE FROM ohb_file WHERE ohb33 = g_adh.adh01 AND ohb34 = p_adi.adi02
  IF SQLCA.sqlcode THEN
     CALL cl_err('delete ohb',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  CALL t203_bu1(p_adi.adi15,p_adi.adi16,g_oha09)
  IF g_success = 'N' THEN RETURN END IF

END FUNCTION



FUNCTION t203_prt()
   IF cl_confirm('mfg3242') THEN CALL t203_out('a') END IF
END FUNCTION

FUNCTION t203_out(p_cmd)
   DEFINE l_cmd         LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(200)
          p_cmd         LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
          l_prog        LIKE zz_file.zz01,     #No.FUN-680108 VARCHAR(10)
          l_wc,l_wc2    LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(50)
          l_prtway      LIKE zz_file.zz22,     #No.FUN-680108 VARCHAR(1)
          l_lang        LIKE type_file.chr1    # Prog. Version..: '5.10.00-08.01.04(0.中文/1.英文/2.簡體) #No.FUN-680108 VARCHAR(1)

   IF cl_null(g_adh.adh01) THEN CALL cl_err('','-400',0) RETURN END IF
   OPTIONS FORM LINE FIRST + 1
 #NO.MOD-4B0082  --begin
#   LET p_row = 3 LET p_col = 3

#   OPEN WINDOW w1 AT p_row,p_col WITH 2 ROWS, 75 COLUMNS
#        ATTRIBUTE(BORDER,CYAN)
   MENU ""
        ON ACTION List_of_Conglomerate_Trans_In_Notes
                 LET l_prog='axdr204'
                 EXIT MENU
        ON ACTION Detail_List_Of_Conglomerate_Trans_In_Notes
                 LET l_prog='axdr208'
                 EXIT MENU
       ON ACTION exit
          EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 


        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

   END MENU
   IF NOT cl_null(l_prog) THEN #BugNo:5548
      IF l_prog = 'axdr204' OR p_cmd = 'a' THEN
         LET l_wc='adh01="',g_adh.adh01,'"'
      ELSE
         LET l_wc=g_wc CLIPPED,' AND ',g_wc2
      END IF
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
       WHERE zz01 = l_prog
      IF SQLCA.sqlcode OR l_wc2 IS NULL OR l_wc = ' ' THEN
         LET l_wc2 = " 'Y' 'Y' 'Y' "
      END IF
      LET l_cmd = l_prog CLIPPED,
              " '",g_today CLIPPED,"' '",g_user,"'",  #TQC-610088
              " '",g_lang CLIPPED,"' 'Y' ' ' '1'",  #TQC-610088
              " '",l_wc CLIPPED,"' ",l_wc2
      CALL cl_cmdrun(l_cmd)
   END IF
#   CLOSE WINDOW w1
#   OPTIONS FORM LINE FIRST + 2
 #NO.MOD-4B0082  --end
END FUNCTION

FUNCTION t203_tlf(p_img10,p_adi,p_type,p_adf07,s_img10,p_img35)
  DEFINE p_adi   RECORD
                 pmm09  LIKE pmm_file.pmm09,   #撥出工廠
                 adi02  LIKE adi_file.adi02,   #撥入項次
                 adi03  LIKE adi_file.adi03,   #撥出單號
                 adi04  LIKE adi_file.adi04,   #撥出項次
                 adi15  LIKE adi_file.adi15,   #參考單號
                 adi16  LIKE adi_file.adi16,   #參考項次
                 adi05  LIKE adi_file.adi05,   #料件編號
                 adi06  LIKE adi_file.adi06,   #倉庫
                 adi07  LIKE adi_file.adi07,   #儲位
                 adi08  LIKE adi_file.adi08,   #批號
                 adi09  LIKE adi_file.adi09,   #單位
                 #No.FUN-580033  --begin
                 adi10  LIKE adi_file.adi10,   #撥入數量
                 adi33  LIKE adi_file.adi33,   #單位二
                 adi34  LIKE adi_file.adi34,   #單位二轉換率
                 adi35  LIKE adi_file.adi35,   #單位二數量
                 adi30  LIKE adi_file.adi30,   #單位一
                 adi31  LIKE adi_file.adi31,   #單位一轉換率
                 adi32  LIKE adi_file.adi32    #單位一數量
                 #No.FUN-580033  --end
                 END RECORD,
          l_dbs   LIKE azp_file.azp03,  #No.MOD-4C0087
         p_img10 LIKE img_file.img10,
         s_img10 LIKE img_file.img10,
         p_img35 LIKE img_file.img35,
         p_adf07 LIKE adf_file.adf07,
         p_type  LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)

      INITIALIZE g_tlf.* TO NULL

      IF p_type = '1' THEN
         LET g_tlf.tlf02  = '50'     #來源
         LET g_tlf.tlf01  = p_adi.adi05
         IF g_adh.adh00 = '1' THEN
            LET g_tlf.tlf020 = g_plant
         ELSE
            LET g_tlf.tlf020 = p_adi.pmm09
         END IF
         LET g_tlf.tlf021 = p_adf07
          LET g_tlf.tlf023 = p_adi.adi03  #No.MOD-560296
          LET g_tlf.tlf022 = p_adi.adi04  #No.MOD-560296
         LET g_tlf.tlf024 = p_img10 - p_adi.adi10
         LET g_tlf.tlf025 = p_adi.adi09
         #LET g_tlf.tlf026 = g_adh.adh01
         #LET g_tlf.tlf027 = p_adi.adi02
         LET g_tlf.tlf026 = p_adi.adi03
         LET g_tlf.tlf027 = p_adi.adi04

         LET g_tlf.tlf03  = '99'
         LET g_tlf.tlf030 = ' '
         LET g_tlf.tlf031 = ' '
         LET g_tlf.tlf032 = ' '
         LET g_tlf.tlf033 = ' '
         LET g_tlf.tlf034 = 0
         LET g_tlf.tlf035 = ' '
         LET g_tlf.tlf036 = g_adh.adh01
         LET g_tlf.tlf037 = 0
      ELSE
         LET g_tlf.tlf02  = '99'       #目的
         LET g_tlf.tlf01  = p_adi.adi05
         LET g_tlf.tlf020 = ' '
         LET g_tlf.tlf021 = ' '
         LET g_tlf.tlf022 = ' '
         LET g_tlf.tlf023 = ' '
         LET g_tlf.tlf024 = 0
         LET g_tlf.tlf025 = ' '
         LET g_tlf.tlf026 = g_adh.adh01
         LET g_tlf.tlf027 = 0

         LET g_tlf.tlf03  = '50'
         LET g_tlf.tlf030 = g_plant
         LET g_tlf.tlf031 = p_adi.adi06
         LET g_tlf.tlf032 = p_adi.adi07
         LET g_tlf.tlf033 = p_adi.adi08
         LET g_tlf.tlf034 = s_img10 + p_adi.adi10
         LET g_tlf.tlf035 = p_adi.adi09
         LET g_tlf.tlf036 = g_adh.adh01
         LET g_tlf.tlf037 = p_adi.adi02
      END IF
      LET g_tlf.tlf04  = ' '
      LET g_tlf.tlf05  = ' '
      LET g_tlf.tlf06  = g_adh.adh02
      LET g_tlf.tlf07  = g_today
      LET g_tlf.tlf08  = TIME
      LET g_tlf.tlf09  = g_user
      LET g_tlf.tlf10  = p_adi.adi10
      LET g_tlf.tlf11  = p_adi.adi09
      LET g_tlf.tlf12  = 1
      LET g_tlf.tlf13  = 'axdt203'
      LET g_tlf.tlf14  = ''
      LET g_tlf.tlf15  = ' '
      LET g_tlf.tlf16  = ' '
      LET g_tlf.tlf17  = ' '
      LET g_tlf.tlf18  = s_imaQOH(p_adi.adi05)
      LET g_tlf.tlf19  = ' '
      LET g_tlf.tlf20  = p_img35
      LET g_tlf.tlf61  = ' '

       #No.MOD-4C0087  --begin
      IF p_type='2' THEN
         CALL s_tlf(0,0)
      ELSE
         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_tlf.tlf020
         IF cl_null(l_dbs) THEN
            LET l_dbs=g_dbs
            CALL cl_err('s_tlf',SQLCA.sqlcode,0)
         END IF
         LET l_dbs=l_dbs CLIPPED,"."
         CALL s_tlf2(0,0,l_dbs)
      END IF
       #No.MOD-4C0087  --end
      IF g_success='N' THEN RETURN END IF
END FUNCTION

FUNCTION t203_ins_oga_rva_rvu(p_pmm09,p_adi15,p_adv)
  DEFINE p_pmm09 LIKE pmm_file.pmm09,
         p_adi15 LIKE adi_file.adi15,
         p_adv   RECORD LIKE adv_file.*,
         l_oga   RECORD LIKE oga_file.*,
         l_rva   RECORD LIKE rva_file.*,
         l_adu   RECORD LIKE adu_file.*,
         l_rvu   RECORD LIKE rvu_file.*,
         l_azp02 LIKE azp_file.azp02,
         l_rvu05 LIKE rvu_file.rvu05,
         li_result LIKE type_file.num5,     #No:FUN-560014   #No.FUN-680108 SMALLINT
         l_sys   LIKE smy_file.smysys,
         l_kind  LIKE smy_file.smykind

     IF g_head = 1 THEN
        #########INSERT 出貨單單頭檔[p_dbs.oga_file]#############

#No.FUN-560014-begin
        IF cl_null(p_dbs) THEN
           LET p_dbs=g_dbs
        END IF
        CALL s_check_no("axm",p_adv.adv02,"","50","","",p_dbs)
              RETURNING li_result,p_adv.adv02
        IF (NOT li_result) THEN
           LET g_success = 'N'
           RETURN
        END IF
        CALL s_get_doc_no(p_adv.adv02) RETURNING p_adv.adv02 #No.FUN-580033
#       CALL s_axmslip1(p_adv.adv02,'50','AXM',p_dbs)   #檢查單別
#       IF NOT cl_null(g_errno) THEN
#          CALL cl_err(p_adv.adv02,g_errno,0)
#          LET g_success = 'N'
#          RETURN
#       END IF
        IF cl_null(t_dbs) THEN
           LET t_dbs=g_dbs
        END IF
        CALL s_auto_assign_no("axm",p_adv.adv02,g_adh.adh02,"","","",t_dbs,"","")
                  RETURNING li_result,g_oga01
        IF (NOT li_result) THEN
           LET g_success = 'N'
           RETURN
        END IF
#       CALL s_mutiauno('axm',p_adv.adv02,g_adh.adh02,t_dbs)   #組出貨單后六碼
#            RETURNING g_cnt,g_oga01
#       IF g_cnt <> 0 THEN
#          CALL cl_err('','mfg3326',1)
#          LET g_success = 'N'
#          RETURN
#       END IF
#No.FUN-560014  --end
        LET g_sql = " INSERT INTO ",p_dbs CLIPPED,".oga_file",
#                     1       2       3       4       5      6      7     8
                    "(oga00,  oga08,  oga09,  oga01,  oga02, oga021,oga03,oga04,",
#                     9       10      11      12      13     14     15
                    " oga14,  oga15,  oga16,  oga161, oga162,oga163,oga20,",
#                     16      17      18      19      20     21     22
                    " oga21,  oga211, oga212, oga213, oga23, oga24, oga25,",
#                     23      24      25      26      27     28     29
                    " oga05,  oga13,  oga50,  oga52,  oga53, oga54, oga903,",
#                     30      31      32      33
                    " ogaconf,oga30,  ogapost,ogaprsw,",
#                     34      35      36      37      38     39     40
                    " ogauser,ogagrup,ogamodu,ogadate,oga501,oga51,oga511)",
                    " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                    "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        PREPARE t203_pre3 FROM g_sql
        EXECUTE t203_pre3 USING
#          1   2   3   4       5           6           7           8
           '1','1','2',g_oga01,g_adh.adh02,g_adh.adh02,p_adv.adv01,p_adv.adv01,
#          9           10          11          12  13    14  15
           p_adv.adv04,p_adv.adv05,g_adh.adh01,'0','100','0','Y',
#          16          17          18          19          20
           p_adv.adv06,p_adv.adv07,p_adv.adv08,p_adv.adv09,p_adv.adv10,
#          21          22          23          24          25  26  27
           p_adv.adv11,p_adv.adv03,p_adv.adv12,p_adv.adv13,'0','0','0',
#          28  29  30  31  32  33  34     35     36  37      38  39  40
           '0','Y','Y','N','Y','0',g_user,g_grup,' ',g_today,'0','0','0'
        IF SQLCA.sqlcode THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           RETURN
        END IF

        #########INSERT 收貨單單頭檔[rva_file]#############

        #分銷系統參數(一)設定--采購/收貨
        SELECT * INTO l_adu.* FROM adu_file WHERE adu01 = p_pmm09
        IF SQLCA.sqlcode THEN
           CALL cl_err('select adu',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF
#No.FUN-560014  --start
         CALL s_check_no("apm",l_adu.adu021,"","3","","","")
           RETURNING li_result,l_adu.adu021
         IF (NOT li_result) THEN
              LET g_success = 'N' RETURN
         END IF
         CALL s_get_doc_no(l_adu.adu021) RETURNING l_adu.adu021 #No.FUN-580033
         CALL s_auto_assign_no("apm",l_adu.adu021,g_adh.adh02,"3","","","","","")
           RETURNING li_result,g_rva01
         IF (NOT li_result) THEN
              LET g_success = 'N' RETURN
         END IF
#        CALL s_mfgslip(l_adu.adu021,'apm','3')   #檢查單別
#        IF NOT cl_null(g_errno) THEN             #抱歉, 有問題
#           CALL cl_err(l_adu.adu021,g_errno,0)
#           LET g_success = 'N' RETURN
#        END IF
#        CALL s_smyauno(l_adu.adu021,g_adh.adh02)
#              RETURNING g_i,g_rva01
#        IF g_i THEN LET g_success='N' RETURN END IF
#No.FUN-560014  --end

#                            1     2     3     4     5     6     7     8
        INSERT INTO rva_file(rva01,rva06,rva02,rva05,rva07,rva10,rva04,rvaconf,
#                            9       10      11      12      13      14
                             rvaprsw,rvaprno,rvaacti,rvauser,rvagrup,rvamodu,
#                            15
                             rvadate)
#                          1       2           3           4
                    VALUES(g_rva01,g_adh.adh02,p_adi15,p_pmm09,
#                          5           6     7   8   9
                           g_adh.adh01,'ICT','N','Y','Y',
#                          10 11 12     13    14   15
                           0,'Y',g_user,g_grup,' ',g_today)
        IF SQLCA.sqlcode THEN
           CALL cl_err('insert rva',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF

        #########INSERT 入庫單單頭檔[rvu_file]#############

         #No.MOD-560296  --begin
        CALL s_get_doc_no(g_adh.adh01) RETURNING g_t1   #No.FUN-550026
        CALL s_get_doc_no(g_rva01) RETURNING g_t1   #No.FUN-550026
         #No.MOD-560296  --end
        SELECT * INTO g_smy.* FROM smy_file WHERE smyslip =g_t1
        IF SQLCA.sqlcode THEN
           CALL cl_err('select smy',SQLCA.sqlcode,0)
           LET g_success = 'N'
           RETURN
        END IF

        #g_smy.smy52 為入庫單單別
        IF g_smy.smy57[3] = 'Y' THEN   #入庫單流水號預設同收貨單流水號
#No.FUN-560014-begin
#          LET g_rvu01 = g_smy.smy52,g_rva01[4,10]
           LET g_rvu01 = g_smy.smy52,g_rva01[g_no_sp-1,g_no_ep]
        ELSE
           SELECT smysys,smykind INTO l_sys,l_kind FROM smy_file WHERE smyslip = g_smy.smy52
           CALL s_auto_assign_no(l_sys,g_smy.smy52,g_adh.adh02,l_kind,"","","","","")
             RETURNING li_result,g_rvu01
           IF (NOT li_result) THEN
               LET g_success='N'
               RETURN
           END IF
#           CALL s_smyauno(g_smy.smy52,g_adh.adh02)
#                RETURNING g_i,g_rvu01
#           IF g_i THEN LET g_success='N' RETURN END IF
#No.FUN-560014-begin
        END IF
        SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = p_pmm09
        IF SQLCA.sqlcode THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF
        LET l_rvu05=l_azp02[1,8]
        INSERT INTO rvu_file(rvu00,rvu02,rvu03,rvu01,rvu04,rvu05,rvu06,rvu07,
                             rvu08,rvu09,rvu20,rvuconf,rvuacti,rvuuser,
                             rvugrup,rvumodu,rvudate,rvu10)
                    VALUES  ('1',g_rva01,g_adh.adh02,g_rvu01,p_pmm09,
                             l_rvu05,g_grup,g_user,'ICT',NULL,'N','Y',
                             'Y',g_user,g_grup,' ',g_today,'N')
        IF SQLCA.sqlcode THEN
           CALL cl_err('insert rvu',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF
     END IF   #g_head=1
END FUNCTION

FUNCTION t203_upd_pmn1(p_adi15,p_adi16)
   DEFINE p_adi15 LIKE adi_file.adi15,
          p_adi16 LIKE adi_file.adi16,
          l_rvb07 LIKE rvb_file.rvb07,
          l_rvb30 LIKE rvb_file.rvb30,
          l_pmn51 LIKE pmn_file.pmn51

#           入庫量     實收數量      在驗量
     SELECT SUM(rvb30),SUM(rvb07),SUM(rvb07-rvb29-rvb30)
       INTO l_rvb30,l_rvb07,l_pmn51
       FROM rva_file,rvb_file
      WHERE rvb04=p_adi15 AND rvb03=p_adi16
        AND rvb35='N' AND rvaconf='Y' AND rva01=rvb01

     IF cl_null(l_rvb07) THEN LET l_rvb07=0 END IF
     IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
     IF cl_null(l_pmn51) THEN LET l_pmn51=0 END IF

     #-->(1-1)更新采購單已交量/在驗量
     MESSAGE "Update pmn_file ..."
     UPDATE pmn_file
        SET pmn50=l_rvb07,            #已交量
            pmn51=l_pmn51,            #在驗量
            pmn53=l_rvb30             #入庫量
      WHERE pmn01=p_adi15 AND pmn02=p_adi16
     IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
        LET g_success = 'N'
        CALL cl_err('upd pmn50:',SQLCA.sqlcode,1)
        RETURN
     END IF
END FUNCTION

FUNCTION t203_upd_rvb(p_rvb02)
   DEFINE p_rvb02  LIKE rvb_file.rvb02,
          l_rvb30  LIKE rvb_file.rvb30,
          l_rvb29  LIKE rvb_file.rvb29,
          l_rvb291 LIKE rvb_file.rvb09,
          g_qty    LIKE rvb_file.rvb09,
          l_rvb18  LIKE rvb_file.rvb18

     MESSAGE "u_rvb!"
      SELECT SUM(rvv17) INTO l_rvb30 FROM rvv_file,rvu_file     #計算已入庫量
       WHERE rvv04=g_rva01 AND rvv05=p_rvb02
             AND rvuconf='Y' AND rvu00='1' AND rvv01=rvu01
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
   #----
      SELECT SUM(rvv17) INTO l_rvb29 FROM rvv_file,rvu_file     #計算退(只算
       WHERE rvv04=g_rva01 AND rvv05=p_rvb02
             AND rvuconf='Y' AND rvu00='2' AND rvv01=rvu01
      IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF
   #----
      SELECT rvb07 INTO g_qty FROM rvb_file                     #實收數量
       WHERE rvb01=g_rva01 AND rvb02=p_rvb02
      IF g_qty<(l_rvb30+l_rvb29) THEN #BugNo:5547
         CALL cl_err('rvb07<rvb29+30:','asf-660',1)
         LET g_success = 'N' RETURN
      END IF
   #----
      SELECT SUM(rvv17) INTO l_rvb291 FROM rvv_file,rvu_file    #計算倉退
       WHERE rvv04=g_rva01 AND rvv05=p_rvb02
             AND rvuconf='Y' AND rvu00='3' AND rvv01=rvu01
      IF cl_null(l_rvb291) THEN LET l_rvb291=0 END IF

      IF l_rvb30>0 THEN  #有入庫
         LET l_rvb18='30'               #狀況(入「庫存」)
      ELSE
         LET l_rvb18='10'               #狀況(在收貨檢驗區)
      END IF

      UPDATE rvb_file SET rvb29 = l_rvb29,         #退貨量
                          rvb30 = l_rvb30,         #入庫量
                          rvb09 = l_rvb30-l_rvb291, #允請量
                          rvb31 = rvb07-l_rvb29-l_rvb30,  #
                          rvb18=l_rvb18
       WHERE rvb01 = g_rva01 AND rvb02 = p_rvb02
      IF SQLCA.sqlcode THEN
         CALL cl_err('upd rvb29,rvb09,rvb31:',SQLCA.sqlcode,1)
         LET g_success = 'N' RETURN
      END IF
END FUNCTION

FUNCTION t203_upd_pmn2(p_adi15,p_adi16)
   DEFINE p_rvv25 LIKE rvv_file.rvv25,
          p_adi15 LIKE adi_file.adi15,
          p_adi16 LIKE adi_file.adi16,
          l_pmn50 LIKE pmn_file.pmn50,
          l_pmn51 LIKE pmn_file.pmn51,
          l_pmn55 LIKE pmn_file.pmn55,
          l_pmn53 LIKE pmn_file.pmn53

        SELECT SUM(rvb30),SUM(rvb07-rvb29-rvb30),SUM(rvb07),SUM(rvb29)
          INTO l_pmn53,l_pmn51,l_pmn50,l_pmn55
          FROM rvb_file,rva_file        #計算入庫量,在驗量
         WHERE rvb04=p_adi15 AND rvb03=p_adi16
           AND rvaconf='Y' AND rvb01=rva01 AND rvb35='N'
        IF cl_null(l_pmn53) THEN LET l_pmn53=0 END IF
        IF cl_null(l_pmn51) THEN LET l_pmn51=0 END IF
        IF cl_null(l_pmn50) THEN LET l_pmn50=0 END IF
        IF cl_null(l_pmn55) THEN LET l_pmn55=0 END IF

        UPDATE pmn_file
           SET pmn53=l_pmn53,            #入庫量
               pmn51=l_pmn51,            #在驗量
               pmn50=l_pmn50,            #收貨量
               pmn55=l_pmn55             #驗退量
         WHERE pmn01 = p_adi15 AND pmn02 = p_adi16
        IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('upd pmn53,51 s2:',SQLCA.sqlcode,1)
            RETURN
        END IF
END FUNCTION

FUNCTION t203_ins_oha(p_oga03,p_adi15)
  DEFINE p_oga03 LIKE oga_file.oga03,
         p_adi15 LIKE adi_file.adi15,
         l_oga   RECORD LIKE oga_file.*,
         l_adx   RECORD LIKE adx_file.*,
         l_azp02 LIKE azp_file.azp02,
         li_result LIKE type_file.num5     #No:FUN-560014   #No.FUN-680108 SMALLINT

     IF g_head = 1 THEN
        SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_oga03
        IF SQLCA.sqlcode THEN
           CALL cl_err('select azp',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF
        SELECT * INTO l_adx.* FROM adx_file WHERE adx01=p_oga03
        IF SQLCA.sqlcode THEN
           CALL cl_err('select adx',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF

        #########INSERT 銷退單單頭檔[oha_file]#############

#No.FUN-560014-begin
         #No.MOD-4C0087  --begin
        #CALL s_axmslip1(l_adx.adx02,'60','AXM',p_dbs)   #檢查單別
         #No.MOD-4C0087  --end
#       CALL s_axmslip1(l_adx.adx02,'60','AXM',g_dbs)   #檢查單別
#       IF NOT cl_null(g_errno) THEN
#          CALL cl_err(l_adx.adx02,g_errno,0)
#          LET g_success = 'N'
#          RETURN
#       END IF
        CALL s_check_no("axm",l_adx.adx02,"","60","","",g_dbs)
             RETURNING li_result,l_adx.adx02
        IF (NOT li_result) THEN
           LET g_success = 'N'
           RETURN
        END IF
        CALL s_get_doc_no(l_adx.adx02) RETURNING l_adx.adx02  #No.FUN-580033
        CALL s_auto_assign_no("axm",l_adx.adx02,g_adh.adh02,"60","","","","","")
          RETURNING li_result,g_oha01
        IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
        END IF
#        CALL s_axmauno(l_adx.adx02,g_adh.adh02)   #組出貨單后六碼
#             RETURNING g_cnt,g_oha01
#        IF g_cnt <> 0 THEN
#           CALL cl_err('','mfg3326',1)
#           LET g_success = 'N'
#           RETURN
#        END IF
#No.FUN-560014-end
        LET g_oha09=l_adx.adx03
        SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_adi15
#                            1      2      3     4     5     6     7
        INSERT INTO oha_file(oha08 ,oha05 ,oha01,oha02,oha09,oha16,oha03,
#                            8      9      10    11    12    13    14
                             oha032,oha04 ,oha10,oha14,oha15,oha21,oha211,
#                            15     16     17    18    19    20    21
                             oha212,oha213,oha23,oha24,oha25,oha26,oha31,
#                            22     23     24    25    26    27    28
                             oha41 ,oha42 ,oha43,oha44,oha47,oha50,oha53,
#                            29     30    31      32
                             oha54 ,oha99,ohaconf,ohapost)
#              1   2   3           4       5           6       7
        VALUES('1','1',g_oha01    ,g_today,l_adx.adx03,p_adi15,l_oga.oga03,
#              8            9           10   11          12
               l_oga.oga032,l_oga.oga04,NULL,l_oga.oga14,l_oga.oga15,
#              13           14           15           16
               l_oga.oga21 ,l_oga.oga211,l_oga.oga212,l_oga.oga213,
#              17           18           19           20
               l_oga.oga23 ,l_oga.oga24 ,l_oga.oga25 ,l_oga.oga26 ,
#              21           22  23  24  25  26  27 282930   31  32
               l_oga.oga31 ,'N','N','N','N',NULL,0,0,0,NULL,'Y','Y')
        IF SQLCA.sqlcode THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           RETURN
        END IF
     END IF   #g_head=1
END FUNCTION

FUNCTION t203_bu1(p_adi15,p_adi16,p_oha09)   #更新出貨單銷退量 & 訂單銷退量
  DEFINE p_adi15   LIKE adi_file.adi15
  DEFINE p_adi16   LIKE adi_file.adi16
  DEFINE p_oha09   LIKE oha_file.oha09
  DEFINE l_a       LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)
  DEFINE tot1      LIKE ohb_file.ohb12
  DEFINE tot2      LIKE ohb_file.ohb12

   MESSAGE "bu!"
   IF p_oha09 = '1' THEN RETURN END IF
   IF NOT cl_null(p_adi15) THEN                     #更新出貨單銷退量
      SELECT SUM(ohb12) INTO tot1 FROM ohb_file, oha_file
          WHERE ohb31=p_adi15 AND ohb32=p_adi16
           AND ohb01=oha01 AND ohapost='Y' AND oha09='2'
      SELECT SUM(ohb12) INTO tot2 FROM ohb_file, oha_file
          WHERE ohb31=p_adi15 AND ohb32=p_adi16
           AND ohb01=oha01 AND ohapost='Y' AND oha09='3'
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
      LET g_chr='N'
UPDATE ogb_file SET ogb63=tot1,ogb64=tot2                           
       WHERE ogb01 = p_adi15 AND ogb03 = p_adi16
      IF STATUS THEN
         CALL cl_err('upd ogb63,64',STATUS,1) LET g_success = 'N' RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd ogb63,64','axm-176',1) LET g_success = 'N' RETURN
      END IF
   END IF

   IF p_oha09 != '4' THEN RETURN END IF      #bugno:5730 add ......

END FUNCTION
FUNCTION t203_m()
DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-680108 SMALLINT
        l_desc          LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(20)

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    OPEN WINDOW t203_ww AT 8,10     #顯示畫面 統一編號欄位加長
         WITH FORM "axd/42f/axdt203_m" ATTRIBUTE(BORDER,CYAN)
          CALL cl_ui_locale("axdt203_m")  #NO.MOD-4B0082
    CALL cl_opmsg('u')

    CALL t203_adi18(g_adi18) RETURNING l_desc
    DISPLAY g_adi18  TO FORMONLY.adi18
    DISPLAY l_desc TO FORMONLY.desc
    DISPLAY g_adi19  TO FORMONLY.adi19
    DISPLAY g_adi20  TO FORMONLY.adi20
    CALL cl_anykey('')
    CLOSE WINDOW t203_ww
END FUNCTION

FUNCTION t203_adi18(p_ade18)
DEFINE p_ade18  LIKE ade_file.ade18
DEFINE l_desc   LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(20)

    CASE p_ade18
         WHEN '1'  CALL cl_getmsg('axm-024',g_lang) RETURNING l_desc
         WHEN '2'  CALL cl_getmsg('axm-025',g_lang) RETURNING l_desc
         WHEN '3'  CALL cl_getmsg('axm-026',g_lang) RETURNING l_desc
    END CASE
    RETURN l_desc
END FUNCTION

FUNCTION t203_ade13(p_ade01,p_ade02,p_dbs)   #檢查對應的申請單是否結案
DEFINE p_ade01  LIKE ade_file.ade01
DEFINE p_ade02  LIKE ade_file.ade02
DEFINE p_dbs    LIKE azp_file.azp03
DEFINE l_ade13  LIKE ade_file.ade13

  LET g_sql = " SELECT ade13 FROM ",p_dbs,".ade_file",
              "  WHERE ade01 = '",p_ade01,"' AND ade02 = ",p_ade02
  PREPARE t203_ade13_prepare FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select ade13',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  EXECUTE t203_ade13_prepare INTO l_ade13
  IF SQLCA.sqlcode THEN
     CALL cl_err('select ade13',SQLCA.sqlcode,0)
     LET g_success = 'N' RETURN
  END IF
  IF cl_null(l_ade13) OR l_ade13='Y' THEN    #若申請單已結案,則不得有異動
     RETURN 1
  ELSE
     RETURN 2
  END IF
END FUNCTION

 #MOD-560158
#FUNCTION t203_sg()
#  IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
#     CALL cl_err('aza23','mfg3551',0)
#     RETURN
#  END IF
#
#  IF g_adh.adh01 IS NULL OR g_adh.adh01 = ' ' THEN   #尚未查詢資料
#     CALL cl_err('', -400, 0)
#     RETURN
#  END IF
#
#  IF g_adh.adh07 NOT MATCHES "[S1WR]" THEN
#     RETURN
#  END IF
#
#  CALL aws_efstat(g_adh.adh01)
#END FUNCTION
 #END MOD-560158

FUNCTION t203_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("adh00,adh01",TRUE)
   END IF

END FUNCTION

FUNCTION t203_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("adh00,adh01",FALSE)
       END IF
   END IF

END FUNCTION

FUNCTION t203_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680108 VARCHAR(1)

      CALL cl_set_comp_entry("adi03,adi04,ade15,adi16",TRUE)
      #No.FUN-580033  --begin
      CALL cl_set_comp_entry("adi35",TRUE)
      #No.FUN-580033  --end

END FUNCTION

FUNCTION t203_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680108 VARCHAR(1)

      CASE g_adh.adh00
           WHEN '1' CALL cl_set_comp_entry("adi15,adi16",FALSE)
           WHEN '3' CALL cl_set_comp_entry("adi03,adi04,adi15,adi16",FALSE)
      END CASE
      #No.FUN-580033  --begin
      IF g_ima906 = '1' THEN
         CALL cl_set_comp_entry("adi35",FALSE)
      END IF
      #No.FUN-580033  --end

END FUNCTION

#No.FUN-580033  --begin
FUNCTION t203_mu_ui()
    CALL cl_set_comp_visible("adi31,adi34",FALSE)
    CALL cl_set_comp_visible("adi30,adi33,adi32,adi35",g_sma.sma115='Y')
    CALL cl_set_comp_visible("adi09,adi10",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adi33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adi35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adi30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adi32",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adi33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adi35",g_msg CLIPPED)
       CALL cl_getmsg('asm-017',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adi30",g_msg CLIPPED)
       CALL cl_getmsg('asm-019',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adi32",g_msg CLIPPED)
    END IF

END FUNCTION

FUNCTION t203_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE imn_file.imn34,
            l_qty2   LIKE imn_file.imn35,
            l_fac1   LIKE imn_file.imn31,
            l_qty1   LIKE imn_file.imn32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680108  DECIMAL(16,8)

    #No.MOD-590121  --begin
    IF g_sma.sma115='N' THEN RETURN END IF
    #No.MOD-590121  --end
    LET l_fac2=g_adi[l_ac].adi34
    LET l_qty2=g_adi[l_ac].adi35
    LET l_fac1=g_adi[l_ac].adi31
    LET l_qty1=g_adi[l_ac].adi32

    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_adi[l_ac].adi09=g_adi[l_ac].adi30
                   LET g_adi[l_ac].adi10=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_adi[l_ac].adi09=g_ima25
                   LET g_adi[l_ac].adi10=l_tot
          WHEN '3' LET g_adi[l_ac].adi09=g_adi[l_ac].adi30
                   LET g_adi[l_ac].adi10=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_adi[l_ac].adi34 =l_qty1/l_qty2
                   ELSE
                      LET g_adi[l_ac].adi34 =0
                   END IF
       END CASE
    #No.MOD-590121  --begin
    #ELSE  #不使用雙單位
    #   LET g_adi[l_ac].adi09=g_adi[l_ac].adi30
    #   LET g_adi[l_ac].adi10=l_qty1
    #No.MOD-590121  --end
    END IF

END FUNCTION

FUNCTION t203_set_required()

  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("adi33,adi35,adi30,adi32",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_adi[l_ac].adi30) THEN
     CALL cl_set_comp_required("adi32",TRUE)
  END IF
  IF NOT cl_null(g_adi[l_ac].adi33) THEN
     CALL cl_set_comp_required("adi35",TRUE)
  END IF

END FUNCTION

FUNCTION t203_set_no_required()

  CALL cl_set_comp_required("adi33,adi35,adi30,adi32",FALSE)

END FUNCTION

#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t203_du_data_to_correct()

   IF cl_null(g_adi[l_ac].adi33) THEN
      LET g_adi[l_ac].adi34 = NULL
      LET g_adi[l_ac].adi35 = NULL
   END IF

   IF cl_null(g_adi[l_ac].adi30) THEN
      LET g_adi[l_ac].adi31 = NULL
      LET g_adi[l_ac].adi32 = NULL
   END IF
   DISPLAY BY NAME g_adi[l_ac].adi31
   DISPLAY BY NAME g_adi[l_ac].adi32
   DISPLAY BY NAME g_adi[l_ac].adi34
   DISPLAY BY NAME g_adi[l_ac].adi35

END FUNCTION
#檢查單位是否存在於單位檔中
FUNCTION t203_unit(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti

    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION t203_update_du(p_ware,p_loc,p_lot,p_type,p_type1,p_dbs,p_chr)
DEFINE p_ware    LIKE img_file.img02
DEFINE p_loc     LIKE img_file.img03
DEFINE p_lot     LIKE img_file.img04
DEFINE p_type    LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE p_type1   LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE p_dbs     LIKE azp_file.azp03
DEFINE p_chr     LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)
DEFINE l_rowid   LIKE type_file.chr18   #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
DEFINE l_ima25   LIKE ima_file.ima25
DEFINE l_img09   LIKE img_file.img09
DEFINE l_fac1    LIKE img_file.img21
DEFINE l_fac2    LIKE img_file.img21

   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    WHERE ima01 = t_adi.adi05
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF
   IF NOT cl_null(t_adi.adi33) THEN
      CALL s_du_umfchk1(t_adi.adi05,p_ware,p_loc,p_lot,
                        NULL,t_adi.adi33,g_ima906,p_dbs)
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('adi33',g_errno,0)
         LET g_success='N' RETURN
      END IF
      LET l_fac2=g_factor
   END IF
   IF NOT cl_null(t_adi.adi30) THEN
      CALL s_du_umfchk1(t_adi.adi05,p_ware,p_loc,p_lot,
                        NULL,t_adi.adi30,1,p_dbs)
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('adi30',g_errno,0)
         LET g_success='N' RETURN
      END IF
      LET l_fac1=g_factor
   END IF
 
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=t_adi.adi05
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(t_adi.adi35) AND t_adi.adi35<>0 THEN
         CALL t203_upd_imgg('1',t_adi.adi05,p_ware,p_loc,p_lot,
                   t_adi.adi33,l_fac2,t_adi.adi35,'2',p_type,p_type1,p_dbs)
         IF g_success='N' THEN RETURN END IF
         IF p_type1=1 THEN
            CALL t203_tlff(p_ware,p_loc,p_lot,l_ima25,
                           t_adi.adi35,t_adi.adi33,l_fac2,'2',p_type,p_dbs,p_chr)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(t_adi.adi32) AND t_adi.adi32<>0 THEN
         CALL t203_upd_imgg('1',t_adi.adi05,p_ware,p_loc,p_lot,
                   t_adi.adi30,l_fac1,t_adi.adi32,'1',p_type,p_type1,p_dbs)
         IF g_success='N' THEN RETURN END IF
         IF p_type1=1 THEN
            CALL t203_tlff(p_ware,p_loc,p_lot,l_ima25,
                           t_adi.adi32,t_adi.adi30,l_fac1,'1',p_type,p_dbs,p_chr)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(t_adi.adi35) AND t_adi.adi35<>0 THEN
         CALL t203_upd_imgg('2',t_adi.adi05,p_ware,p_loc,p_lot,
                   t_adi.adi33,l_fac2,t_adi.adi35,'2',p_type,p_type1,p_dbs)
         IF g_success = 'N' THEN RETURN END IF
         IF p_type1=1 THEN
            CALL t203_tlff(p_ware,p_loc,p_lot,l_ima25,
                           t_adi.adi35,t_adi.adi33,l_fac2,'2',p_type,p_dbs,p_chr)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      #No.CHI-770019  --Begin
      #IF NOT cl_null(t_adi.adi32) AND t_adi.adi32<>0 THEN
      #   IF p_type1=1 THEN
      #      CALL t203_tlff(p_ware,p_loc,p_lot,l_ima25,
      #                     t_adi.adi32,t_adi.adi30,l_fac1,'1',p_type,p_dbs,p_chr)
      #      IF g_success='N' THEN RETURN END IF
      #   END IF
      #END IF
      #No.CHI-770019  --End  
   END IF

END FUNCTION

FUNCTION t203_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_no,p_type,p_type1,p_dbs)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         l_rowid    LIKE type_file.chr18,  #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         p_type1    LIKE type_file.num5,   #No.FUN-680108 SMALLINT
         p_dbs      LIKE azp_file.azp03,
         l_dbs      LIKE azp_file.azp03,
         p_no       LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
         p_type     LIKE type_file.num5    #No.FUN-680108 SMALLINT

    LET l_dbs = s_madd_img_catstr(p_dbs)

    IF p_type1=-1 THEN
       CALL s_mchk_imgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_dbs)
            RETURNING g_flag
       IF g_flag= 1 THEN
          SELECT ima25,ima906 INTO l_ima25,l_ima906
            FROM ima_file WHERE ima01=p_imgg01
          IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
             CALL cl_err('ima25 null',SQLCA.sqlcode,0)
             LET g_success = 'N' RETURN
          END IF

          CALL s_umfchk1(p_imgg01,p_imgg09,l_ima25,l_dbs)
                RETURNING g_cnt,l_imgg21
          IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
             CALL cl_err('','mfg3075',0)
             LET g_success = 'N' RETURN
          END IF

          CALL s_madd_imgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,
                           p_imgg211,g_adh.adh01,t_adi.adi02,l_imgg21,p_dbs)
               RETURNING g_flag
          IF g_flag = 1 THEN
             CALL cl_err('madd_imgg',SQLCA.sqlcode,1)
             LET g_success='N' RETURN
          END IF
       END IF
    END IF
    CALL s_mupimgg(p_type,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                   p_imgg09,p_imgg10,g_adh.adh02,l_dbs)
    IF g_success='N' THEN RETURN END IF

END FUNCTION

FUNCTION t203_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_uom,p_factor,
                   p_flag,p_type,p_dbs,p_chr)
DEFINE
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位
   p_lot      LIKE img_file.img04,     	 ##批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   p_flag     LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
   p_type     LIKE type_file.num5,   #No.FUN-680108 SMALLINT
   p_chr      LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
   p_dbs      LIKE azp_file.azp03,
   l_dbs      LIKE azp_file.azp03,
   l_imgg10   LIKE imgg_file.imgg10

    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF

    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

    INITIALIZE g_tlff.* TO NULL

    IF p_chr = '1' THEN
       LET g_tlff.tlff02  = '50'     #來源
       LET g_tlff.tlff01  = t_adi.adi05
       IF g_adh.adh00 = '1' THEN
          LET g_tlff.tlff020 = g_plant
       ELSE
          LET g_tlff.tlff020 = t_adi.pmm09
       END IF
       LET g_tlff.tlff021 = p_ware
       LET g_tlff.tlff022 = p_loca
       LET g_tlff.tlff023 = p_lot
       LET g_tlff.tlff024 = l_imgg10
       LET g_tlff.tlff025 = p_unit
       LET g_tlff.tlff026 = t_adi.adi03
       LET g_tlff.tlff027 = t_adi.adi04

       LET g_tlff.tlff03  = '99'
       LET g_tlff.tlff030 = ' '
       LET g_tlff.tlff031 = ' '
       LET g_tlff.tlff032 = ' '
       LET g_tlff.tlff033 = ' '
       LET g_tlff.tlff034 = 0
       LET g_tlff.tlff035 = ' '
       LET g_tlff.tlff036 = g_adh.adh01
       LET g_tlff.tlff037 = 0
    ELSE
       LET g_tlff.tlff02  = '99'       #目的
       LET g_tlff.tlff01  = t_adi.adi05
       LET g_tlff.tlff020 = ' '
       LET g_tlff.tlff021 = ' '
       LET g_tlff.tlff022 = ' '
       LET g_tlff.tlff023 = ' '
       LET g_tlff.tlff024 = 0
       LET g_tlff.tlff025 = ' '
       LET g_tlff.tlff026 = g_adh.adh01
       LET g_tlff.tlff027 = 0

       LET g_tlff.tlff03  = '50'
       LET g_tlff.tlff030 = g_plant
       LET g_tlff.tlff031 = p_ware
       LET g_tlff.tlff032 = p_loca
       LET g_tlff.tlff033 = p_lot
       LET g_tlff.tlff034 = l_imgg10
       LET g_tlff.tlff035 = p_unit
       LET g_tlff.tlff036 = g_adh.adh01
       LET g_tlff.tlff037 = t_adi.adi02
    END IF
    LET g_tlff.tlff04  = ' '
    LET g_tlff.tlff05  = ' '
    LET g_tlff.tlff06  = g_adh.adh02
    LET g_tlff.tlff07  = g_today
    LET g_tlff.tlff08  = TIME
    LET g_tlff.tlff09  = g_user
    LET g_tlff.tlff10  = p_qty
    LET g_tlff.tlff11  = p_uom
    LET g_tlff.tlff12  = p_factor
    LET g_tlff.tlff13  = 'axdt203'
    LET g_tlff.tlff14  = ''
    LET g_tlff.tlff15  = ' '
    LET g_tlff.tlff16  = ' '
    LET g_tlff.tlff17  = ' '
    LET g_tlff.tlff18  = s_imaQOH(t_adi.adi05)
    LET g_tlff.tlff19  = ' '
    LET g_tlff.tlff20  = ' '
    LET g_tlff.tlff61  = ' '

    IF p_chr ='2' THEN
       IF cl_null(t_adi.adi35) OR t_adi.adi35=0 THEN
          CALL s_tlff(p_flag,NULL)
       ELSE
          CALL s_tlff(p_flag,t_adi.adi33)
       END IF
    ELSE
       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_tlff.tlff020
       IF cl_null(t_adi.adi35) OR t_adi.adi35=0 THEN
          CALL s_tlff2(p_flag,NULL,l_dbs)
       ELSE
          CALL s_tlff2(p_flag,t_adi.adi33,l_dbs)
       END IF
    END IF
    IF g_success='N' THEN RETURN END IF
END FUNCTION

#No.FUN-580033  --end
#Patch....NO:MOD-5A0095 <001> #
#Patch....NO:TQC-610037 <> #
