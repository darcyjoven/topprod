# Prog. Version..: '5.10.00-08.01.04(00009)'     #
# Pattern name...: saxdt202.4gl
# Descriptions...: 集團撥出單維護作業
# Date & Author..: 03/12/09 By Carrier
# Modify.........: No.MOD-4B0082 04/11/10 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY  將變數用Like方式定義
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No:MOD-4C0087 04/12/23 By Carrier 修改imdacit-->imdacti
# Modify.........: No.MOD-540145 05/05/10 By vivien  更新control-f的寫法
# Modify.........: No.FUN-550026 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-560014 05/06/06 By day  單據編號修改
# Modify.........: No:MOD-560158 05/06/21 By Echo 無與EasyFlow整合，因此刪除link檔裡的整合程式
# Modify.........: No.MOD-560296 05/07/20 By Carrier 批號存單號,庫位存項次
# Modify.........: NO.FUN-580033 05/08/08 By Carrier 多單位內容修改
# Modify.........: No:MOD-590121 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-610018 06/01/17 By ice 新增含稅總金額pmm40t
# Modify.........: No:FUN-610090 06/02/06 By Nicola 拆併箱功能修改
# Modify.........: No:FUN-610067 06/01/11 By Smapmin 雙單位畫面調整
# Modify.........: NO:TQC-620156 06/03/13 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No:CHI-6A0015 06/12/19 By rainy 輸入料號後自動帶出預設的倉庫/儲位
# Modify.........: No:FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:TQC-750018 07/05/04 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No:TQC-790002 07/09/03 By Sarah Primary Key：複合key在.NSERT INTO table前需增加判斷，如果是NULL就給值blank(字串型態) or 0(數值型態)
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No:TQC-7B0083 07/11/21 By Carrier rvv88給預設值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_adf    RECORD LIKE adf_file.*,       #集團撥出單單頭檔
    g_adf_t  RECORD LIKE adf_file.*,       #集團撥出單單頭檔(舊值)
    g_adf_o  RECORD LIKE adf_file.*,       #集團撥出單單頭檔(舊值)
    g_adf01_t       LIKE adf_file.adf01,   #撥出單號(舊值)
    g_adf_rowid     LIKE type_file.chr18,  #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
    g_adg           DYNAMIC ARRAY of RECORD#集團撥出單單身檔
        adg02       LIKE adg_file.adg02,   #項次
        adg03       LIKE adg_file.adg03,   #申請單號
        adg04       LIKE adg_file.adg04,   #申請項次
        adg05       LIKE adg_file.adg05,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #品名
        adg06       LIKE adg_file.adg06,   #倉庫代號
        adg07       LIKE adg_file.adg07,   #儲位
        adg08       LIKE adg_file.adg08,   #批號
        adg09       LIKE adg_file.adg09,   #撥入工廠代號
        adg10       LIKE adg_file.adg10,   #撥入工廠倉庫
        adg11       LIKE adg_file.adg11,   #單位
        adg12       LIKE adg_file.adg12,   #撥出數量
        #No.FUN-580033  --begin
        adg33       LIKE adg_file.adg33,   #單位二
        adg34       LIKE adg_file.adg34,   #單位二轉換率
        adg35       LIKE adg_file.adg35,   #單位二數量
        adg30       LIKE adg_file.adg30,   #單位一
        adg31       LIKE adg_file.adg31,   #單位一轉換率
        adg32       LIKE adg_file.adg32,   #單位一數量
        #No.FUN-580033  --end
        adg17       LIKE adg_file.adg17
                    END RECORD,
    g_adg_t         RECORD                 #集團撥出單單身檔 (舊值)
        adg02       LIKE adg_file.adg02,   #項次
        adg03       LIKE adg_file.adg03,   #申請單號
        adg04       LIKE adg_file.adg04,   #申請項次
        adg05       LIKE adg_file.adg05,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #品名
        adg06       LIKE adg_file.adg06,   #倉庫代號
        adg07       LIKE adg_file.adg07,   #儲位
        adg08       LIKE adg_file.adg08,   #批號
        adg09       LIKE adg_file.adg09,   #撥入工廠代號
        adg10       LIKE adg_file.adg10,   #撥入工廠倉庫
        adg11       LIKE adg_file.adg11,   #單位
        adg12       LIKE adg_file.adg12,   #撥出數量
        #No.FUN-580033  --begin
        adg33       LIKE adg_file.adg33,   #單位二
        adg34       LIKE adg_file.adg34,   #單位二轉換率
        adg35       LIKE adg_file.adg35,   #單位二數量
        adg30       LIKE adg_file.adg30,   #單位一
        adg31       LIKE adg_file.adg31,   #單位一轉換率
        adg32       LIKE adg_file.adg32,   #單位一數量
        #No.FUN-580033  --end
        adg17       LIKE adg_file.adg17
                    END RECORD,
    g_pmm           DYNAMIC ARRAY of RECORD
        pmm01       LIKE pmm_file.pmm01,
        pmm04       LIKE pmm_file.pmm04,
        pmm09       LIKE pmm_file.pmm09,
        azp01       LIKE azp_file.azp01
                    END RECORD,
    b_rvv           RECORD LIKE rvv_file.*,
    g_rowid         LIKE type_file.chr18,  #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
    g_i1            LIKE type_file.num5,   #No.FUN-680108 SMALLINT
    g_cmd           LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(200)
    g_azp01         LIKE azp_file.azp01,
    g_azp03         LIKE azp_file.azp03,
    g_rvu01         LIKE rvu_file.rvu01,
    g_rvu           RECORD LIKE rvu_file.*,
    g_img10         LIKE img_file.img10,   #庫存數量
    g_ima25         LIKE ima_file.ima25,   #庫存數量
    p_dbs           LIKE azp_file.azp03,
    g_type          LIKE adz_file.adztype, #No.FUN-680108 VARCHAR(02)
    g_t1            LIKE adz_file.adzslip, #No.FUN-550026   #No.FUN-680108 VARCHAR(05)
     g_wc,g_sql,g_wc2    string,           #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680108 SMALLINT
    g_flag          LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
    g_adg18         LIKE adg_file.adg18,
    g_adg19         LIKE adg_file.adg19,
    g_adg20         LIKE adg_file.adg20,
    g_pmm01         LIKE pmm_file.pmm01,
    g_pmm25         LIKE pmm_file.pmm25,
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680108 SMALLINT
DEFINE g_argv0      LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE g_chr        LIKE adf_file.adfacti  #No.FUN-680108 VARCHAR(01)
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose   #No.FUN-680108 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(72)
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-680108 INTEGER  
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE g_jump       LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5    #No.FUN-680108 SMALLINT
#FUN-580033  --begin
DEFINE t_adg RECORD
             adg02  LIKE adg_file.adg02,   #撥出項次
             adg03  LIKE adg_file.adg03,   #申請單號
             adg04  LIKE adg_file.adg04,   #申請單項次
             ade16  LIKE ade_file.ade16,   #撥入單
             ade17  LIKE ade_file.ade17,   #撥入單項次
             adi15  LIKE adi_file.adi15,   #采購單
             adi16  LIKE adi_file.adi16,   #采購單項次
             rvb01  LIKE rvb_file.rvb01,   #收貨單
             rvb02  LIKE rvb_file.rvb01,   #收貨單項次
             adg05  LIKE adg_file.adg05,   #料件
             adg06  LIKE adg_file.adg06,   #撥出倉庫
             adg07  LIKE adg_file.adg07,   #儲位
             adg08  LIKE adg_file.adg08,   #批號
             adg09  LIKE adg_file.adg09,   #撥入工廠代號
             adg10  LIKE adg_file.adg10,   #撥入工廠倉庫
             adg11  LIKE adg_file.adg11,   #單位
             adg12  LIKE adg_file.adg12,   #撥出數量
             adg33  LIKE adg_file.adg33,   #單位二
             adg34  LIKE adg_file.adg34,   #單位二轉換率
             adg35  LIKE adg_file.adg35,   #單位二數量
             adg30  LIKE adg_file.adg30,   #單位一
             adg31  LIKE adg_file.adg31,   #單位一轉換率
             adg32  LIKE adg_file.adg32    #單位一數量
             END RECORD,
       g_change     LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
       g_ima906     LIKE ima_file.ima906,
       g_ima907     LIKE ima_file.ima907,
       g_img09      LIKE img_file.img09,
       g_sw         LIKE type_file.num5,   #No.FUN-680108 SMALLINT
       g_factor     LIKE inb_file.inb08_fac,
       g_tot        LIKE img_file.img10,
       g_qty        LIKE img_file.img10
#FUN-580033  --end
DEFINE g_imm01      LIKE imm_file.imm01      #No.FUN-610090
DEFINE g_unit_arr   DYNAMIC ARRAY OF RECORD  #No:FUN-610090
                       unit   LIKE ima_file.ima25,
                       fac    LIKE img_file.img21,
                       qty    LIKE img_file.img10
                    END RECORD
                   
FUNCTION t202(p_argv0)
   DEFINE p_argv0   LIKE type_file.chr1   #No.FUN-680108 VARCHAR(01)

   WHENEVER ERROR CONTINUE                #忽略一切錯誤
   LET g_wc2 = " 1=1"

   LET g_adf01_t = NULL                   #清除鍵值
   LET g_argv0 = p_argv0

   IF NOT cl_null(g_argv0) AND g_argv0 NOT MATCHES '[12]' THEN
      CALL cl_err(g_argv0,'axd-016',0)
      EXIT PROGRAM
   END IF

   IF g_argv0 = '1' THEN LET g_type = '13' END IF

   IF g_argv0 = '2' THEN LET g_type = '14' END IF

   IF g_argv0 = '3' THEN LET g_type = '15' END IF

   SELECT azp01,azp03 INTO g_azp01,g_azp03 FROM azp_file WHERE azp01 = g_plant

   INITIALIZE g_adf_t.* TO NULL
   INITIALIZE g_adf.* TO NULL

   LET g_forupd_sql = "SELECT * FROM adf_file WHERE ROWID = ? FOR UPDATE NOWAIT"
   DECLARE t202_cl CURSOR FROM g_forupd_sql

   CALL g_x.clear()

   #No.FUN-580033  --begin
   CALL t202_mu_ui()
   #No.FUN-580033  --end

   CALL t202_menu()

END FUNCTION

FUNCTION t202_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN

    CLEAR FORM                             #清除畫面
    CALL g_adg.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_adf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
                 adf00,adf01,adf02,adf09,adf07,adf03,adf04,
                 adf05,adf06,adf08,
                 adfconf,adfpost,adf10,adfmksg,
                 adfuser,adfgrup,adfmodu,adfdate,adfacti

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(adf01)
                LET g_t1=s_get_doc_no(g_adf.adf01)    #No.FUN-550026
                #CALL q_adz(TRUE,FALSE,g_t1,g_type,'axd')  #TQC-670008 
                CALL q_adz(TRUE,FALSE,g_t1,g_type,'AXD')   #TQC-670008
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO adf01
                NEXT FIELD adf01
             WHEN INFIELD(adf07)
                #CALL q_adc(0,0,g_adf.adf07,g_azp01,'I')
                #     RETURNING g_adf.adf07
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_adc"
                LET g_qryparam.state = "c"
                LET g_qryparam.arg1 = g_azp01
                LET g_qryparam.arg2 = 'I'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO adf07
                NEXT FIELD adf07
             WHEN INFIELD(adf03)
                #CALL q_gen(0,0,g_adf.adf03) RETURNING g_adf.adf03
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO adf03
                NEXT FIELD adf03
             WHEN INFIELD(adf04)
                #CALL q_gem(0,0,g_adf.adf04) RETURNING g_adf.adf04
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO adf04
                NEXT FIELD adf04
             WHEN INFIELD(adf05)
                #CALL q_obn(0,0,g_adf.adf05) RETURNING g_adf.adf05
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_obn"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO adf05
                NEXT FIELD adf05
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
    CONSTRUCT g_wc2 ON adg02,adg03,adg04,adg05,adg06,adg07,  #螢幕上取單身條件
                       adg08,adg09,adg10,adg11,adg12,adg33,
                       adg35,adg30,adg32,adg17
       FROM s_adg[1].adg02,s_adg[1].adg03,s_adg[1].adg04,
            s_adg[1].adg05,s_adg[1].adg06,s_adg[1].adg07,
            s_adg[1].adg08,s_adg[1].adg09,s_adg[1].adg10,
            s_adg[1].adg11,s_adg[1].adg12,s_adg[1].adg33,
            s_adg[1].adg35,s_adg[1].adg30,s_adg[1].adg32,
            s_adg[1].adg17
    #No.FUN-580033  --end

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
       #No:FUN-580031 --end--       HCN

       ON ACTION CONTROLP
          CASE WHEN INFIELD(adg03)
                   #CALL q_ade(5,3,g_adg[l_ac].adg03,g_adg[l_ac].adg04,g_adf.adf00)
                   #     RETURNING g_adg[l_ac].adg03,g_adg[l_ac].adg04
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ade"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1 = g_adf.adf00
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_adg[1].adg03
                   NEXT FIELD adg03
               WHEN INFIELD(adg06)
                   #CALL q_img5(0,0,g_adg[l_ac].adg05,g_adg[l_ac].adg06,g_adg[l_ac].adg07,g_adg[l_ac].adg08,'S')
                   #     RETURNING g_adg[l_ac].adg06,g_adg[l_ac].adg07,g_adg[l_ac].adg08
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_img8"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.multiret_index = 1
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_adg[1].adg06
                   NEXT FIELD adg06
               WHEN INFIELD(adg07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_img8"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.multiret_index = 2
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_adg[1].adg07
                   NEXT FIELD adg07
               WHEN INFIELD(adg08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_img8"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.multiret_index = 3
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_adg[1].adg08
                   NEXT FIELD adg08
                #No.FUN-580033  --begin
                WHEN INFIELD(adg33)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO adg33
                   NEXT FIELD adg33
                WHEN INFIELD(adg30)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO adg30
                   NEXT FIELD adg30
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
      LET g_wc = g_wc clipped," AND adfuser = '",g_user,"'"
   END IF

   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND adfgrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      LET g_wc = g_wc clipped," AND adfgrup IN ",cl_chk_tgrup_list()
   END IF


   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT ROWID, adf01 FROM adf_file ",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY 2"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE adf_file.ROWID, adf01 ",
                 "  FROM adf_file, adg_file ",
                 " WHERE adf01 = adg01",
                 "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 " ORDER BY 2"
   END IF

   PREPARE t202_prepare FROM g_sql
   IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) EXIT PROGRAM END IF

   DECLARE t202_cs SCROLL CURSOR WITH HOLD FOR t202_prepare

   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM adf_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(distinct adf01)",
                " FROM adf_file,adg_file WHERE ",
                " adf01=adg01 AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
   END IF

   PREPARE t202_precount FROM g_sql
   DECLARE t202_count CURSOR FOR t202_precount

END FUNCTION

FUNCTION t202_menu()

   WHILE TRUE
      CALL t202_bp("G")
      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t202_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t202_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t202_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t202_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t202_x()
                CALL cl_set_field_pic(g_adf.adfconf,"",g_adf.adfpost,"","",g_adf.adfacti)  #NO.MOD-4B0082
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t202_b()
            ELSE
               LET g_action_choice = NULL
            END IF

#         WHEN "reproduce"
#            IF cl_chk_act_auth() THEN
#               CALL t202_copy()
#            END IF

         #WHEN "簽核狀態"                          #MOD-560158
        ##@WHEN "btn01"
        #   IF cl_chk_act_auth() THEN
        #      CALL t202_sg()
        #   END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t202_y()
                CALL cl_set_field_pic(g_adf.adfconf,"",g_adf.adfpost,"","",g_adf.adfacti)  #NO.MOD-4B0082
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t202_w()
                CALL cl_set_field_pic(g_adf.adfconf,"",g_adf.adfpost,"","",g_adf.adfacti)  #NO.MOD-4B0082
            END IF

         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t202_s()
                CALL cl_set_field_pic(g_adf.adfconf,"",g_adf.adfpost,"","",g_adf.adfacti)  #NO.MOD-4B0082
            END IF

         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t202_z()
                CALL cl_set_field_pic(g_adf.adfconf,"",g_adf.adfpost,"","",g_adf.adfacti)  #NO.MOD-4B0082
            END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t202_out('o')
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         #No:FUN-6A0165-------adf--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_adf.adf01 IS NOT NULL THEN
                 LET g_doc.column1 = "adf01"
                 LET g_doc.value1 = g_adf.adf01
                 CALL cl_doc()
               END IF
         END IF
         #No:FUN-6A0165-------adf--------end----
      END CASE
   END WHILE
END FUNCTION

FUNCTION t202_a()
   DEFINE li_result     LIKE type_file.num5    #No.FUN-560014    #No.FUN-680108 SMALLINT

    MESSAGE ""
    #若非由MENU進入本程式,則無新增之功能
    CLEAR FORM                                 # 清螢墓欄位內容
    CALL g_adg.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_adf.* LIKE adf_file.*
    LET g_adf01_t = NULL
    LET g_adf_t.*=g_adf.*
    LET g_adf.adf00 = g_argv0
    LET g_adf.adf02 = g_today                    #DEFAULT
    LET g_adf.adf09 = g_today                    #DEFAULT
    LET g_adf.adf03 = g_user                     #DEFAULT
    LET g_adf.adf04 = g_grup                     #DEFAULT
    IF cl_null(g_argv0) THEN LET g_adf.adf00 = '1' END IF

    SELECT ada02 INTO g_adf.adf07 FROM adf_file
     WHERE ada01 = g_azp01
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_adf.adfacti ='Y'                   #有效的資料
        LET g_adf.adfconf ='N'                   #有效的資料
        LET g_adf.adfpost ='N'                   #有效的資料
        LET g_adf.adfuser = g_user
        LET g_adf.adfgrup = g_grup               #使用者所屬群
        LET g_adf.adfdate = g_today
        LET g_adf.adf10 = '0'
        CALL t202_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_adf.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_adf.adf01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
#No.FUN-560014  --start
        CALL s_auto_assign_no("axd",g_adf.adf01,g_adf.adf02,"","adf_file","adf01","","","")
          RETURNING li_result,g_adf.adf01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_adf.adf01
#       IF g_adz.adzauno='Y' THEN   #need modify to add adf_file in it
#          CALL s_axdauno(g_adf.adf01,g_adf.adf02) RETURNING g_i,g_adf.adf01
#          IF g_i THEN #有問題
#             CONTINUE WHILE
#          END IF
#          DISPLAY BY NAME g_adf.adf01
#       END IF
#No.FUN-560014  --end
        INSERT INTO adf_file VALUES(g_adf.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           ROLLBACK WORK   #No:7829
           CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF

        COMMIT WORK

        SELECT ROWID INTO g_adf_rowid FROM adf_file
         WHERE adf01 = g_adf.adf01

        LET g_adf01_t = g_adf.adf01        #保留舊值
        LET g_adf_t.* = g_adf.*

        CALL g_adg.clear()
        LET g_rec_b=0
        CALL t202_b()                   #輸入單身
        EXIT WHILE
    END WHILE

    SELECT * FROM adf_file WHERE adf01 = g_adf.adf01
    IF SQLCA.sqlcode = 0 THEN
       IF g_adz.adzconf = 'Y' THEN
          CALL t202_y()
       END IF

       IF g_adz.adzprnt = 'Y' THEN
          CALL t202_prt()
       END IF
    END IF

END FUNCTION

FUNCTION t202_i(p_cmd)
   DEFINE li_result   LIKE type_file.num5    #No.FUN-560014          #No.FUN-680108 SMALLINT
   DEFINE l_sw        LIKE type_file.chr1,   #檢查必要欄位是否空白   #No.FUN-680108 VARCHAR(1)
          p_cmd       LIKE type_file.chr1,                           #No.FUN-680108 VARCHAR(1)
          l_n         LIKE type_file.num5,                           #No.FUN-680108 SMALLINT
          l_obw       RECORD LIKE obw_file.*

    IF NOT cl_null(g_argv0) THEN
       LET g_adf.adf00 = g_argv0
    END IF

    CALL t202_adf10()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT BY NAME g_adf.adf00,g_adf.adf01,g_adf.adf02,g_adf.adf09,
                  g_adf.adf07,g_adf.adf03,g_adf.adf04,g_adf.adf05,
                  g_adf.adf06,g_adf.adf08,g_adf.adf10,g_adf.adfmksg,
                  g_adf.adfconf,g_adf.adfpost,g_adf.adfuser,g_adf.adfgrup,
                  g_adf.adfmodu,g_adf.adfdate,g_adf.adfacti
                  WITHOUT DEFAULTS HELP 1

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t202_set_entry(p_cmd)
            CALL t202_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            #No.FUN-550026 --start--
            CALL cl_set_docno_format("adf01")
            #No.FUN-550026 ---end---

        AFTER FIELD adf00
            IF g_adf.adf00 MATCHES '[123]' THEN
               CALL t202_adf00()
            END IF

#No.FUN-560014-begin
        AFTER FIELD adf01
            IF NOT cl_null(g_adf.adf01) THEN
               LET g_t1 = s_get_doc_no(g_adf.adf01)  #No.FUN-550026
               CASE
                  WHEN g_adf.adf00='1' LET g_type='13'
                  WHEN g_adf.adf00='2' LET g_type='14'
                  WHEN g_adf.adf00='3' LET g_type='15'
               END CASE
               CALL s_check_no("axd",g_adf.adf01,"",g_type,"adf_file","adf01","")
                    RETURNING li_result,g_adf.adf01
               IF (NOT li_result) THEN
                  NEXT FIELD adf01
               END IF
               DISPLAY BY NAME g_adf.adf01
#              SELECT * INTO g_adz.* FROM adz_file WHERE adzslip = g_t1
#                 AND adztype = g_type
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_adf.adf01,'mfg0014',0)
#                 NEXT FIELD adf01
#              END IF
#               IF g_adf_t.adf01 IS NULL OR
#                  (g_adf.adf01 != g_adf_t.adf01 ) THEN
                   LET  g_adf.adfmksg = g_adz.adzapr
                   LET  g_adf.adfsign = g_adz.adzsign
                   DISPLAY BY NAME g_adf.adfmksg
                    DISPLAY BY NAME g_adf.adfsign
#                END IF
                 LET g_adf.adfprsw = 'Y'
#              IF p_cmd = 'a' AND cl_null(g_adf.adf01[5,10]) AND g_adz.adzauno='N'
#                 THEN NEXT FIELD adf01
#              END IF
#              IF g_adf.adf01 != g_adf_t.adf01 OR g_adf_t.adf01 IS NULL THEN
#                  IF g_adz.adzauno = 'Y'
#                    AND NOT cl_chk_data_continue(g_adf.adf01[5,10]) THEN
#                     CALL cl_err('','9056',0) NEXT FIELD adf01
#                  END IF
#                  SELECT count(*) INTO g_cnt FROM adf_file
#                      WHERE adf01 = g_adf.adf01
#                  IF g_cnt > 0 THEN   #資料重復
#                      CALL cl_err(g_adf.adf01,-239,0)
#                      LET g_adf.adf01 = g_adf_t.adf01
#                      DISPLAY BY NAME g_adf.adf01
#                      NEXT FIELD adf01
#                  END IF
#              END IF
            END IF
#No.FUN-560014-end

        AFTER FIELD adf07
            IF NOT cl_null(g_adf.adf07) THEN
               CALL t202_adc02('a','1')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adf.adf07 = g_adf_t.adf07
                  DISPLAY BY NAME g_adf.adf07
                  NEXT FIELD adf07
               END IF
            END IF

        AFTER FIELD adf03
            IF NOT cl_null(g_adf.adf03) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_adf.adf03 != g_adf_t.adf03) THEN
                  CALL t202_adf03('a')
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err('',g_errno,0)
                     LET g_adf.adf03 = g_adf_t.adf03
                     DISPLAY BY NAME g_adf.adf03
                     NEXT FIELD adf03
                  END IF
                  SELECT gen03 INTO g_adf.adf04 FROM gen_file
                   WHERE gen01 = g_adf.adf03
                  DISPLAY BY NAME g_adf.adf03
                  DISPLAY BY NAME g_adf.adf04
               END IF
            END IF

        AFTER FIELD adf04
            IF NOT cl_null(g_adf.adf04) THEN
               CALL t202_adf04('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adf.adf04 = g_adf_t.adf04
                  DISPLAY BY NAME g_adf.adf04
                  NEXT FIELD adf04
               END IF
            END IF

        AFTER FIELD adf05
            IF NOT cl_null(g_adf.adf05) THEN
               CALL t202_adf05('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adf.adf05 = g_adf_t.adf05
                  DISPLAY BY NAME g_adf.adf05
                  NEXT FIELD adf05
               END IF
            END IF

        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      #MOD-650015 --start
      #  ON ACTION CONTROLO                       # 沿用所有欄位
      #      IF INFIELD(adf01) THEN
      #          LET g_adf.* = g_adf_t.*
      #          DISPLAY BY NAME g_adf.* ATTRIBUTE(YELLOW)
      #          NEXT FIELD adf01
      #      END IF
      #MOD-650015 --end
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adf01)        #need modify
                    CALL s_get_doc_no(g_adf.adf01) RETURNING g_t1   #No.FUN-550026
                    CASE
                       #WHEN g_adf.adf00='1' CALL q_adz(FALSE,FALSE,g_t1,'13','axd')  #TQC-670008
                       WHEN g_adf.adf00='1' CALL q_adz(FALSE,FALSE,g_t1,'13','AXD')   #TQC-670008
                                                 RETURNING g_t1
                       #WHEN g_adf.adf00='2' CALL q_adz(FALSE,FALSE,g_t1,'14','axd')  #TQC-670008
                       WHEN g_adf.adf00='2' CALL q_adz(FALSE,FALSE,g_t1,'14','AXD')   #TQC-670008
                                                 RETURNING g_t1
                       #WHEN g_adf.adf00='3' CALL q_adz(FALSE,FALSE,g_t1,'15','axd')  #TQC-670008
                       WHEN g_adf.adf00='3' CALL q_adz(FALSE,FALSE,g_t1,'15','AXD')   #TQC-670008
                                                 RETURNING g_t1
                    END CASE
                    LET g_adf.adf01 = g_t1
                    DISPLAY BY NAME g_adf.adf01
                    NEXT FIELD adf01
                WHEN INFIELD(adf07)
                    #CALL q_adc(0,0,g_adf.adf07,g_azp01,'I')
                    #     RETURNING g_adf.adf07
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adc"
                    LET g_qryparam.default1=g_adf.adf07
                    LET g_qryparam.arg1 = g_azp01
                    LET g_qryparam.arg2 = 'I'
                    CALL cl_create_qry() RETURNING g_adf.adf07
#                    CALL FGL_DIALOG_SETBUFFER( g_adf.adf07 )
                    DISPLAY BY NAME g_adf.adf07
                    NEXT FIELD adf07
                WHEN INFIELD(adf03)
                    #CALL q_gen(0,0,g_adf.adf03) RETURNING g_adf.adf03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adf.adf03
                    CALL cl_create_qry() RETURNING g_adf.adf03
#                    CALL FGL_DIALOG_SETBUFFER( g_adf.adf03 )
                    DISPLAY BY NAME g_adf.adf03
                    NEXT FIELD adf03
                WHEN INFIELD(adf04)
                    #CALL q_gem(0,0,g_adf.adf04) RETURNING g_adf.adf04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_adf.adf04
                    CALL cl_create_qry() RETURNING g_adf.adf04
#                    CALL FGL_DIALOG_SETBUFFER( g_adf.adf04 )
                    DISPLAY BY NAME g_adf.adf04
                    NEXT FIELD adf04
                WHEN INFIELD(adf05)
                    #CALL q_obn(0,0,g_adf.adf05) RETURNING g_adf.adf05
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_obn"
                    LET g_qryparam.default1=g_adf.adf05
                    CALL cl_create_qry() RETURNING g_adf.adf05
#                    CALL FGL_DIALOG_SETBUFFER( g_adf.adf05 )
                    DISPLAY BY NAME g_adf.adf05
                    NEXT FIELD adf05
                OTHERWISE EXIT CASE
            END CASE

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

FUNCTION t202_adf00()

   CASE g_adf.adf00
      WHEN '1'
         LET g_msg= cl_getmsg('axd-082',g_lang)
      WHEN '2'
         LET g_msg= cl_getmsg('axd-083',g_lang)
      WHEN '3'
         LET g_msg= cl_getmsg('axd-084',g_lang)
   END CASE

   DISPLAY g_msg TO FORMONLY.e

END FUNCTION

FUNCTION t202_adc02(p_cmd,p_kind)    #在途倉
   DEFINE p_cmd       LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
          p_kind      LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
          l_adc08     LIKE adc_file.adc08,
          l_adc02     LIKE adc_file.adc02,
          l_adcacti   LIKE adc_file.adcacti

   LET g_errno = ' '

   IF p_kind = '1' THEN
      LET l_adc02 = g_adf.adf07
   ELSE
      LET l_adc02 = g_adg[l_ac].adg06
   END IF

   SELECT adc08,adcacti INTO l_adc08,l_adcacti FROM adc_file
    WHERE adc02 = l_adc02
      AND adc01 = g_azp01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-004'
                                  LET g_adf.adf07 = NULL
        WHEN l_adcacti='N'        LET g_errno = '9028'
        WHEN l_adc08<>'I' AND p_kind='1'  LET g_errno = 'axd-019'
        WHEN l_adc08<>'S' AND p_kind='2'  LET g_errno = 'axd-022'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

END FUNCTION

FUNCTION t202_adf03(p_cmd)    #人員
   DEFINE p_cmd       LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
          l_gen02     LIKE gen_file.gen02,
          l_genacti   LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
    WHERE gen01 = g_adf.adf03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                  LET g_adf.adf03 = NULL
        WHEN l_genacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
 
END FUNCTION

FUNCTION t202_adf04(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti

  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
                          WHERE gem01 = g_adf.adf04

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET g_adf.adf04 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION

FUNCTION t202_adf05(p_cmd)    #調撥流程
 DEFINE p_cmd       LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
        l_obnacti   LIKE obn_file.obnacti

  LET g_errno = ' '
  SELECT obnacti INTO l_obnacti FROM obn_file
                          WHERE obn01 = g_adf.adf05

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'tri-006'
                                 LET g_adf.adf05 = NULL
       WHEN l_obnacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION

FUNCTION t202_adf10()
    DEFINE l_str LIKE type_file.chr8   #No.FUN-680108 VARCHAR(08)

    CASE g_adf.adf10
         WHEN '0' CALL cl_getmsg('apy-558',g_lang) RETURNING l_str
         WHEN '1' CALL cl_getmsg('apy-559',g_lang) RETURNING l_str
         WHEN 'S' CALL cl_getmsg('apy-561',g_lang) RETURNING l_str
         WHEN 'R' CALL cl_getmsg('apy-562',g_lang) RETURNING l_str
         WHEN 'W' CALL cl_getmsg('apy-563',g_lang) RETURNING l_str
    END CASE
    DISPLAY l_str TO FORMONLY.desc

END FUNCTION

FUNCTION t202_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_adf.* TO NULL              #No.FUN-6A0165 

    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FROM
    CALL g_adg.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(GREEN)
    CALL t202_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Waiting...." ATTRIBUTE(REVERSE)
    OPEN t202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
        INITIALIZE g_adf.* TO NULL
    ELSE
        OPEN t202_count
        FETCH t202_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
        CALL t202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION t202_fetch(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680108 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     t202_cs INTO g_adf_rowid,g_adf.adf01
        WHEN 'P' FETCH PREVIOUS t202_cs INTO g_adf_rowid,g_adf.adf01
        WHEN 'F' FETCH FIRST    t202_cs INTO g_adf_rowid,g_adf.adf01
        WHEN 'L' FETCH LAST     t202_cs INTO g_adf_rowid,g_adf.adf01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t202_cs INTO g_adf_rowid,g_adf.adf01
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_adf.* TO NULL  #TQC-6B0105
       LET g_adf_rowid = NULL      #TQC-6B0105
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

    SELECT * INTO g_adf.* FROM adf_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_adf_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
        INITIALIZE g_adf.* TO NULL
        RETURN
    ELSE
       LET g_data_owner=g_adf.adfuser           #FUN-4C0052權限控管
       LET g_data_group=g_adf.adfgrup
 
    END IF

    CALL t202_show()                      # 重新顯示

END FUNCTION

FUNCTION t202_show()

   LET g_adf_t.* = g_adf.*

   DISPLAY BY NAME g_adf.adf00,g_adf.adf01,g_adf.adf02,g_adf.adf07,
                   g_adf.adf08,g_adf.adf03,g_adf.adf04,g_adf.adf05,
                   g_adf.adf06,g_adf.adf09,g_adf.adf10,
                   g_adf.adfmksg,g_adf.adfconf,
                   g_adf.adfpost,g_adf.adfuser,g_adf.adfgrup,
                   g_adf.adfmodu,g_adf.adfdate,g_adf.adfacti

   CALL cl_set_field_pic(g_adf.adfconf,"",g_adf.adfpost,"","",g_adf.adfacti)  #NO.MOD-4B0082

   CALL t202_adf00()

   CALL t202_adc02('d','1')

   CALL t202_adf03('d')

   CALL t202_adf04('d')

   CALL t202_adf05('d')

   CALL t202_adf10()

   CALL t202_b_fill(g_wc2)

   CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

END FUNCTION

FUNCTION t202_u()

   IF s_shut(0) THEN RETURN END IF

   #若非由MENU進入本程式,則無更新之功能
   IF g_adf.adf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_adf.* FROM adf_file WHERE adf01=g_adf.adf01

   IF g_adf.adfacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_adf.adf01,'mfg1000',0)
      RETURN
   END IF

   IF g_adf.adfconf ='Y' THEN    #檢查資料是否為審核
      CALL cl_err(g_adf.adf01,'9022',0)
      RETURN
   END IF

   IF g_adf.adfpost ='Y' THEN    #檢查資料是否為過帳
      CALL cl_err(g_adf.adf01,'afa-101',0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_adf01_t = g_adf.adf01
   LET g_adf_t.* = g_adf.*
   LET g_adf_o.* = g_adf.*

   BEGIN WORK

   OPEN t202_cl USING g_adf_rowid
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t202_cl INTO g_adf.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_adf.adfmodu = g_user                   #修改者
   LET g_adf.adfdate = g_today                  #修改日期

   CALL t202_show()                          # 顯示最新資料

   WHILE TRUE
      CALL t202_i("u")                      # 欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_adf.*=g_adf_t.*
         CALL t202_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF g_adf.adf01 != g_adf01_t THEN
         UPDATE adg_file SET adg01= g_adf.adf01
          WHERE adg01 = g_adf01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err('update adg:',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE adf_file SET adf_file.* = g_adf.*    # 更新DB
       WHERE ROWID = g_adf_rowid             # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t202_cl
   COMMIT WORK

END FUNCTION

FUNCTION t202_x()
   DEFINE l_chr LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF s_shut(0) THEN RETURN END IF

   IF g_adf.adf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_adf.adfconf ='Y' THEN          #檢查資料是否為審核
      CALL cl_err(g_adf.adf01,'9022',0)
      RETURN
   END IF

   IF g_adf.adfpost ='Y' THEN          #檢查資料是否為過帳
      CALL cl_err(g_adf.adf01,'afa-101',0)
      RETURN
   END IF

   BEGIN WORK

   OPEN t202_cl USING g_adf_rowid
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t202_cl INTO g_adf.*         # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL t202_show()

   IF cl_exp(0,0,g_adf.adfacti) THEN
      LET g_chr=g_adf.adfacti

      IF g_adf.adfacti='Y' THEN
         LET g_adf.adfacti='N'
      ELSE
         LET g_adf.adfacti='Y'
      END IF

      UPDATE adf_file SET adfacti = g_adf.adfacti,
                          adfmodu = g_user,
                          adfdate = g_today
       WHERE ROWID = g_adf_rowid
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
         LET g_adf.adfacti=g_chr
      END IF
      DISPLAY BY NAME g_adf.adfacti ATTRIBUTE(RED)
   END IF

   CLOSE t202_cl
   COMMIT WORK

END FUNCTION

FUNCTION t202_r()
   DEFINE l_chr LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF s_shut(0) THEN RETURN END IF

   IF g_adf.adf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_adf.adfconf ='Y' THEN    #檢查資料是否為審核
      CALL cl_err(g_adf.adf01,'9022',0)
      RETURN
   END IF

   IF g_adf.adfpost ='Y' THEN    #檢查資料是否為過帳
      CALL cl_err(g_adf.adf01,'afa-101',0)
      RETURN
   END IF

   BEGIN WORK

   OPEN t202_cl USING g_adf_rowid
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t202_cl INTO g_adf.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL t202_show()

   IF cl_delh(15,16) THEN
      DELETE FROM adf_file WHERE ROWID = g_adf_rowid
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
      ELSE
         DELETE FROM adg_file WHERE adg01=g_adf.adf01
         CLEAR FORM
         CALL g_adg.clear()
      END IF

      OPEN t202_count
      FETCH t202_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      OPEN t202_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t202_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t202_fetch('/')
      END IF
   END IF

   CLOSE t202_cl
   COMMIT WORK

END FUNCTION

#單身
FUNCTION t202_b()
DEFINE
    l_buf           LIKE type_file.chr1000,#儲存尚在使用中之下游檔案之檔名     #No.FUN-680108 VARCHAR(80)
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用   #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否   #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態     #No.FUN-680108 VARCHAR(1)
    l_bcur          LIKE type_file.chr1,   #'1':表存放位置有值,'2':則為NULL    #No.FUN-680108 VARCHAR(01)
    l_ade05         LIKE ade_file.ade05,
    l_adg13         LIKE adg_file.adg13,
    l_adg14         LIKE adg_file.adg14,
    l_adg15         LIKE adg_file.adg15,
    l_adg16         LIKE adg_file.adg16,
    l_adi01         LIKE adi_file.adi01,
    l_adi02         LIKE adi_file.adi02,
    l_adi06         LIKE adi_file.adi06,
    l_adi07         LIKE adi_file.adi07,
    l_adi08         LIKE adi_file.adi08,
    l_img10         LIKE img_file.img10,
    l_img09         LIKE img_file.img09,
    l_imd11         LIKE imd_file.imd11,
    l_imd12         LIKE imd_file.imd12,
    l_ime05         LIKE ime_file.ime05,
    l_ime06         LIKE ime_file.ime06,
    l_allow_insert  LIKE type_file.num5,   #可新增否   #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否   #No.FUN-680108 SMALLINT
DEFINE l_ima35      LIKE ima_file.ima35,   #TQC-750018
       l_ima36      LIKE ima_file.ima36    #TQC-750018

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF
    IF g_adf.adf01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_adf.* FROM adf_file WHERE adf01=g_adf.adf01
    IF g_adf.adfacti MATCHES'[Nn]' THEN
       CALL cl_err(g_adf.adf01,'mfg1000',0)
       RETURN
    END IF
    IF g_adf.adfconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_adf.adf01,'9022',0)
        RETURN
    END IF
    IF g_adf.adfpost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_adf.adf01,'afa-101',0)
        RETURN
    END IF

    CALL cl_opmsg('b')
    #No.FUN-580033  --begin
    LET g_forupd_sql="SELECT adg02,adg03,adg04,adg05,'','',adg06,adg07,adg08,",
                     "       adg09,adg10,adg11,adg12,adg33,adg34,adg35,adg30,",
                     "       adg31,adg32,adg17,adg18,adg19,adg20",
                     "  FROM adg_file ",
                     " WHERE adg02= ? AND adg01= ?",
                     "   FOR UPDATE NOWAIT"
    #No.FUN-580033  --end

    DECLARE t202_bcl CURSOR FROM g_forupd_sql

      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_adg WITHOUT DEFAULTS FROM s_adg.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           #No.FUN-550026 --start--
           CALL cl_set_docno_format("adg03")
           #No.FUN-550026 ---end---

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT

            BEGIN WORK
            OPEN t202_cl USING g_adf_rowid
            IF STATUS THEN
               CALL cl_err("OPEN t202_cl:", STATUS, 1)
               CLOSE t202_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t202_cl INTO g_adf.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
                CLOSE t202_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_adg_t.* = g_adg[l_ac].*  #BACKUP
               OPEN t202_bcl USING g_adg_t.adg02,g_adf.adf01
               IF STATUS THEN
                  CALL cl_err("OPEN t202_bcl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t202_bcl INTO g_adg[l_ac].*,g_adg18,g_adg19,g_adg20
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_adg_t.adg02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
                  SELECT ima02,ima021 INTO g_adg[l_ac].ima02,g_adg[l_ac].ima021
                    FROM ima_file
                   WHERE ima01 = g_adg[l_ac].adg05
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
               #No.FUN-580033  --begin
               LET g_change='N'
               CALL t202_set_entry_b(p_cmd)
               CALL t202_set_no_entry_b(p_cmd)
               #No.FUN-280033  --end
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adg[l_ac].* TO NULL      #900423
            INITIALIZE g_adg18 TO NULL
            INITIALIZE g_adg19 TO NULL
            INITIALIZE g_adg20 TO NULL
            #No.FUN-580033  --begin
            LET g_change='Y'
            #No.FUN-580033  --end
            LET g_adg[l_ac].adg17 = 0
            LET g_adg_t.* = g_adg[l_ac].*     #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adg02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #No.FUN-580033  --begin
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_adg[l_ac].adg05)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD adg05
               END IF
               CALL t202_du_data_to_correct()
            END IF
            CALL t202_set_origin_field()
            INSERT INTO adg_file(adg01,adg02,adg03,adg04,adg05,
                   adg06,adg07,adg08,adg09,adg10,adg11,adg12,
                   adg13,adg14,adg15,adg16,adg17,adg18,adg19,
                   adg20,adg21,adg22,adg23,adg30,adg31,adg32,
                   adg33,adg34,adg35)
            VALUES(g_adf.adf01,g_adg[l_ac].adg02,
                   g_adg[l_ac].adg03, g_adg[l_ac].adg04,
                   g_adg[l_ac].adg05, g_adg[l_ac].adg06,
                   g_adg[l_ac].adg07, g_adg[l_ac].adg08,
                   g_adg[l_ac].adg09, g_adg[l_ac].adg10,
                   g_adg[l_ac].adg11, g_adg[l_ac].adg12,
                   l_adg13,l_adg14,l_adg15,l_adg16,0,
                   g_adg18,g_adg19,g_adg20,'','','',
                   g_adg[l_ac].adg30, g_adg[l_ac].adg31,
                   g_adg[l_ac].adg32, g_adg[l_ac].adg33,
                   g_adg[l_ac].adg34, g_adg[l_ac].adg35)
            #No.FUN-580033  --end
            IF SQLCA.SQLcode  THEN
                CALL cl_err(g_adg[l_ac].adg02,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                IF g_aza.aza40='Y' THEN  #NO.A112
                   IF g_adf.adf00<>'1' THEN   #銷售預測
                      CALL t202_m()
                   END IF
                END IF  #NO.A112
                COMMIT WORK
            END IF

        BEFORE FIELD adg02                        # dgeeault 序號
            IF g_adg[l_ac].adg02 IS NULL or g_adg[l_ac].adg02 = 0 THEN
                SELECT max(adg02)+1 INTO g_adg[l_ac].adg02 FROM adg_file
                    WHERE adg01 = g_adf.adf01
                IF g_adg[l_ac].adg02 IS NULL THEN
                    LET g_adg[l_ac].adg02 = 1
                END IF
            END IF

        AFTER FIELD adg02
            IF g_adg[l_ac].adg02 IS NOT NULL THEN
               IF g_adg[l_ac].adg02 != g_adg_t.adg02 OR
                  g_adg_t.adg02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM adg_file
                   WHERE adg01 = g_adf.adf01
                     AND adg02 = g_adg[l_ac].adg02
                  IF l_n > 0 THEN
                      CALL cl_err(g_adg[l_ac].adg02,-239,0)
                      LET g_adg[l_ac].adg02 = g_adg_t.adg02
                      NEXT FIELD adg02
                  END IF
               END IF
            END IF

        AFTER FIELD adg03
            IF NOT cl_null(g_adg[l_ac].adg03) THEN
               SELECT * FROM add_file WHERE add01 = g_adg[l_ac].adg03
                  AND addacti = 'Y' AND add06 = '1'
                  AND addconf = 'Y' AND add07 = 'N'
                  AND add00 = g_adf.adf00
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adg[l_ac].adg03,SQLCA.sqlcode,0)
                  LET g_adg[l_ac].adg03 = g_adg_t.adg03
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adg[l_ac].adg03
                  #------MOD-5A0095 END------------
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adg[l_ac].adg03
                  #------MOD-5A0095 END------------
                  NEXT FIELD adg03
               END IF
            END IF

        BEFORE FIELD adg04
           #No.FUN-580033  --begin
           CALL t202_set_entry_b(p_cmd)
           CALL t202_set_no_required()
           #No.FUN-580033  --end

        AFTER FIELD adg04
            IF NOT cl_null(g_adg[l_ac].adg04) THEN
                #No.FUN-580033  --begin
               SELECT ade03,ade06,ade07,ade04,ade05-ade12,ima02,ima021,ima25,
                      ima906,
                      ade18,ade19,ade20,ade30,ade31,ade32,ade33,ade34,ade35,
                      ima35,ima36     #CHI-6A0015 add
                 INTO g_adg[l_ac].adg05,g_adg[l_ac].adg09,g_adg[l_ac].adg10,
                      g_adg[l_ac].adg11,l_ade05,
                      g_adg[l_ac].ima02,g_adg[l_ac].ima021,g_ima25,g_ima906,
                      g_adg18,g_adg19,g_adg20,
                      g_adg[l_ac].adg30,g_adg[l_ac].adg31,g_adg[l_ac].adg32,
                      g_adg[l_ac].adg33,g_adg[l_ac].adg34,g_adg[l_ac].adg35,
                     #g_adg[l_ac].adg06,g_adg[l_ac].adg07    #CHI-6A0015 add  #TQC-750018
                      l_ima35,l_ima36     #TQC-750018
               #No.FUN-580033  --end
                 FROM ade_file,add_file,OUTER ima_file
                WHERE ade01 = add01
                  AND ade01 = g_adg[l_ac].adg03
                  AND ade02 = g_adg[l_ac].adg04
                  AND addacti = 'Y' AND add00 = g_adf.adf00
                  AND addconf = 'Y' AND add06 = '1'
                  AND ade03 = ima_file.ima01 AND add07 = 'N'
                  AND ade13 = 'N'
                IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adg[l_ac].adg04,SQLCA.sqlcode,0)
                  LET g_adg[l_ac].adg04 = g_adg_t.adg04
                  NEXT FIELD adg03
               END IF

               #TQC-750018
               IF cl_null(g_adg_t.adg02) OR g_adg_t.adg02 <> g_adg[l_ac].adg02 
                 OR cl_null(g_adg_t.adg03) OR g_adg_t.adg03 <> g_adg[l_ac].adg03 THEN
                  LET g_adg[l_ac].adg06 = l_ima35
                  LET g_adg[l_ac].adg07 = l_ima36
                  LET g_adg[l_ac].adg08 = NULL
               END IF
               #TQC-750018

               CASE g_adf.adf00
                    WHEN '1' LET l_adg13='1'
                    WHEN '2' SELECT adb05 INTO l_adg13
                               FROM ada_file,adb_file
                              WHERE ada01=adb01 AND ada01=g_plant
                                AND adb02=g_adg[l_ac].adg09
                    WHEN '3' SELECT ade16,ade17 INTO l_adi01,l_adi02
                               FROM ade_file
                              WHERE ade01=g_adg[l_ac].adg03
                                AND ade02=g_adg[l_ac].adg04
                             SELECT adi11,adi12,adi13,adi14,adi06,adi07,adi08
                               INTO l_adg13,l_adg14,l_adg15,l_adg16,
                                    l_adi06,l_adi07,l_adi08
                               FROM adi_file
                              WHERE adi01=l_adi01 AND adi02=l_adi02
               END CASE
               IF cl_null(l_adg13) THEN LET l_adg13='' END IF

               IF cl_null(g_adg[l_ac].adg12) OR g_adg[l_ac].adg03 <> g_adg_t.adg03
                  OR g_adg[l_ac].adg04 <> g_adg_t.adg04 THEN
                  LET g_adg[l_ac].adg12 = l_ade05
               END IF
               IF cl_null(g_adg[l_ac].adg06) OR g_adg[l_ac].adg03 <> g_adg_t.adg03
                  OR g_adg[l_ac].adg04 <> g_adg_t.adg04 THEN
                  LET g_adg[l_ac].adg06 = l_adi06
               END IF
               IF cl_null(g_adg[l_ac].adg07) OR g_adg[l_ac].adg03 <> g_adg_t.adg03
                  OR g_adg[l_ac].adg04 <> g_adg_t.adg04 THEN
                  LET g_adg[l_ac].adg07 = l_adi07
               END IF
               IF cl_null(g_adg[l_ac].adg08) OR g_adg[l_ac].adg03 <> g_adg_t.adg03
                  OR g_adg[l_ac].adg04 <> g_adg_t.adg04 THEN
                  LET g_adg[l_ac].adg08 = l_adi08
               END IF
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_adg[l_ac].adg05
               DISPLAY BY NAME g_adg[l_ac].adg09
               DISPLAY BY NAME g_adg[l_ac].adg10
               DISPLAY BY NAME g_adg[l_ac].adg11
               DISPLAY BY NAME g_adg[l_ac].ima02
               DISPLAY BY NAME g_adg[l_ac].ima021
               DISPLAY BY NAME g_adg[l_ac].adg06
               DISPLAY BY NAME g_adg[l_ac].adg07
               DISPLAY BY NAME g_adg[l_ac].adg08
               #------MOD-5A0095 END------------
            END IF
            #No.FUN-580033  --begin
            CALL t202_set_no_entry_b(p_cmd)
            CALL t202_set_required()
            #No.FUN-580033  --end

        AFTER FIELD adg06
            IF NOT cl_null(g_adg[l_ac].adg06) THEN
               CALL t202_adc02('a','2')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adg[l_ac].adg06 = g_adg_t.adg06
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adg[l_ac].adg06
                  #------MOD-5A0095 END------------
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adg[l_ac].adg06
                  #------MOD-5A0095 END------------
                  NEXT FIELD adg06
               END IF
               SELECT imd11,imd12 INTO l_imd11,l_imd12 FROM imd_file
                WHERE imd01 = g_adg[l_ac].adg06
                   #AND imdacit = 'Y' #MOD-4B0169
                   AND imdacti = 'Y' #No.MOD-4C0087
               IF STATUS THEN
                   CALL cl_err(g_adg[l_ac].adg06,STATUS,1)
               END IF
                #MOD-4B0169(end)
 
               IF l_imd11 = 'N' THEN
                   CALL cl_err(g_adg[l_ac].adg06,'mfg6080',1) #MOD-4B0169
               END IF
               IF l_imd12 = 'N' THEN
                   CALL cl_err(g_adg[l_ac].adg06,'mfg6085',1) #MOD-4B0169
               END IF
            END IF

        AFTER FIELD adg07
            IF cl_null(g_adg[l_ac].adg07) THEN LET g_adg[l_ac].adg07 = ' ' END IF
            SELECT ime05,ime06 INTO l_ime05,l_ime06 FROM ime_file
             WHERE ime01 = g_adg[l_ac].adg06
               AND ime02 = g_adg[l_ac].adg07
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_adg[l_ac].adg07,SQLCA.sqlcode,0)
               NEXT FIELD adg07
            END IF
            IF l_ime05 = 'N' THEN
               CALL cl_err(g_adg[l_ac].adg07,'mfg6081',0)
            END IF
            IF l_ime06 = 'N' THEN
               CALL cl_err(g_adg[l_ac].adg07,'mfg6086',0)
            END IF

        AFTER FIELD adg08
            IF cl_null(g_adg[l_ac].adg08) THEN LET g_adg[l_ac].adg08 = ' ' END IF
            SELECT * FROM img_file WHERE img01 = g_adg[l_ac].adg05
               AND img02 = g_adg[l_ac].adg06
               AND img03 = g_adg[l_ac].adg07
               AND img04 = g_adg[l_ac].adg08
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_adg[l_ac].adg05,SQLCA.sqlcode,0)
               NEXT FIELD adg05
            END IF

        AFTER FIELD adg12
            IF NOT cl_null(g_adg[l_ac].adg12) THEN
               IF g_adg[l_ac].adg12 <= 0 THEN
                  NEXT FIELD adg12
               END IF
               IF g_adg[l_ac].adg12 > l_ade05 THEN
                  CALL cl_err(g_adg[l_ac].adg12,'axd-023',0)
                  LET g_adg[l_ac].adg12 = g_adg_t.adg12
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adg[l_ac].adg12
                  #------MOD-5A0095 END------------
                  NEXT FIELD adg12
               END IF
               SELECT img10 INTO l_img10 FROM img_file
                WHERE img01 = g_adg[l_ac].adg05
                  AND img02 = g_adg[l_ac].adg06
                  AND img03 = g_adg[l_ac].adg07
                  AND img04 = g_adg[l_ac].adg08
               IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
               IF l_img10 < g_adg[l_ac].adg12 THEN
                  CALL cl_err(g_adg[l_ac].adg12,'mfg3471',0)
                  NEXT FIELD adg12
               END IF
            END IF

        #No.FUN-580033  --begin
        BEFORE FIELD adg35  #第二單位
           IF cl_null(g_adg[l_ac].adg05) THEN NEXT FIELD adg05 END IF
           IF g_adg[l_ac].adg06 IS NULL OR g_adg[l_ac].adg07 IS NULL OR
              g_adg[l_ac].adg08 IS NULL THEN
              NEXT FIELD adg06
           END IF
           IF NOT cl_null(g_adg[l_ac].adg33) THEN
              CALL t202_unit(g_adg[l_ac].adg33)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD adg04
              END IF
              CALL s_chk_imgg(g_adg[l_ac].adg05,g_adg[l_ac].adg06,
                              g_adg[l_ac].adg07,g_adg[l_ac].adg08,
                              g_adg[l_ac].adg33) RETURNING g_flag
              IF g_flag = 1 THEN
                 NEXT FIELD adg06
              END IF
           END IF

        AFTER FIELD adg35  #第二數量
           IF NOT cl_null(g_adg[l_ac].adg35) THEN
              IF g_adg[l_ac].adg35 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD adg35
              END IF
              IF p_cmd = 'a' THEN
                 IF g_ima906='3' THEN
                    LET g_tot=g_adg[l_ac].adg35*g_adg[l_ac].adg34
                    IF cl_null(g_adg[l_ac].adg32) OR g_adg[l_ac].adg32=0 THEN
                       LET g_adg[l_ac].adg32=g_tot*g_adg[l_ac].adg31
                    END IF
                 END IF
              END IF
           END IF
           CALL cl_show_fld_cont()                   #No:FUN-560197

        BEFORE FIELD adg32  #第二單位
           IF cl_null(g_adg[l_ac].adg05) THEN NEXT FIELD adg05 END IF
           IF g_adg[l_ac].adg06 IS NULL OR g_adg[l_ac].adg07 IS NULL OR
              g_adg[l_ac].adg08 IS NULL THEN
              NEXT FIELD adg06
           END IF
           IF NOT cl_null(g_adg[l_ac].adg30) THEN
              CALL t202_unit(g_adg[l_ac].adg30)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD adg04
              END IF
              IF g_ima906 ='2' THEN
                 CALL s_chk_imgg(g_adg[l_ac].adg05,g_adg[l_ac].adg06,
                                 g_adg[l_ac].adg07,g_adg[l_ac].adg08,
                                 g_adg[l_ac].adg30) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD adg06
                 END IF
              END IF
           END IF

        AFTER FIELD adg32  #第一數量
           IF NOT cl_null(g_adg[l_ac].adg32) THEN
              IF g_adg[l_ac].adg32 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD adg32
              END IF
           END IF
           CALL t202_du_data_to_correct()
           CALL t202_set_origin_field()
           IF g_adg[l_ac].adg12 <= 0 THEN
              NEXT FIELD adg12
           END IF
           IF g_adg[l_ac].adg12 > l_ade05 THEN
              CALL cl_err(g_adg[l_ac].adg12,'axd-023',0)
              LET g_adg[l_ac].adg12 = g_adg_t.adg12
              NEXT FIELD adg12
           END IF
           #沒有考慮單位換算
           SELECT img09,img10 INTO l_img09,l_img10 FROM img_file
            WHERE img01 = g_adg[l_ac].adg05
              AND img02 = g_adg[l_ac].adg06
              AND img03 = g_adg[l_ac].adg07
              AND img04 = g_adg[l_ac].adg08
           IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
           CALL s_umfchk(g_adg[l_ac].adg05,l_img09,g_adg[l_ac].adg11)
                RETURNING g_cnt,g_factor
           IF g_cnt=1 THEN
              CALL cl_err('img09/adg11','abm-731',0)
              NEXT FIELD adg06
           END IF
           IF l_img10*g_factor < g_adg[l_ac].adg12 THEN
              CALL cl_err(g_adg[l_ac].adg12,'mfg3471',0)
              IF g_ima906 MATCHES '[23]' THEN
                 NEXT FIELD adg35
              ELSE
                 NEXT FIELD adg32
              END IF
           END IF
        #No.FUN-580033  --end

        BEFORE DELETE                            #是否取消單身
            IF g_adg_t.adg02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM adg_file
                 WHERE adg01=g_adf.adf01 AND adg02 = g_adg_t.adg02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adg_t.adg02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete Ok"
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_adg[l_ac].* = g_adg_t.*
               CLOSE t202_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adg[l_ac].adg02,-263,1)
               LET g_adg[l_ac].* = g_adg_t.*
            ELSE
               #No.FUN-580033  --begin
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_adg[l_ac].adg05)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD adg05
                  END IF
                  CALL t202_du_data_to_correct()
               END IF
               CALL t202_set_origin_field()
        UPDATE adg_file 
               SET adg02=g_adg[l_ac].adg02,adg03=g_adg[l_ac].adg03,
                   adg04=g_adg[l_ac].adg04,adg05=g_adg[l_ac].adg05,
                   adg06=g_adg[l_ac].adg06,adg07=g_adg[l_ac].adg07, 
                   adg08=g_adg[l_ac].adg08,adg09=g_adg[l_ac].adg09,
                   adg10=g_adg[l_ac].adg10,adg11=g_adg[l_ac].adg11,
                   adg12=g_adg[l_ac].adg12,adg13=l_adg13, 
                   adg14=l_adg14,adg15=l_adg15,adg16=l_adg16,
                   adg18=g_adg18,adg19=adg19,adg20=g_adg20 
        WHERE CURRENT OF t202_bcl
              #No.FUN-580033  --end
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adg[l_ac].adg02,SQLCA.sqlcode,0)
                  LET g_adg[l_ac].* = g_adg_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  IF g_aza.aza40='Y' THEN  #NO.A112
                     IF g_adf.adf00<>'1' THEN   #銷售預測
                        CALL t202_m()
                     END IF
                  END IF  #NO.A112
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
                  LET g_adg[l_ac].* = g_adg_t.*
               END IF
               CLOSE t202_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t202_bcl
            COMMIT WORK
      
        ON ACTION CONTROLN
            CALL t202_b_askkey()
            EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(adg02) AND l_ac > 1 THEN
                LET g_adg[l_ac].* = g_adg[l_ac-1].*
                NEXT FIELD adg02
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adg03)
                    #CALL q_ade(5,3,g_adg[l_ac].adg03,g_adg[l_ac].adg04,g_adf.adf00)
                    #     RETURNING g_adg[l_ac].adg03,g_adg[l_ac].adg04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ade"
                    LET g_qryparam.arg1 = g_adf.adf00
                    LET g_qryparam.default1 = g_adg[l_ac].adg03
                    LET g_qryparam.default2 = g_adg[l_ac].adg04
                    CALL cl_create_qry() RETURNING g_adg[l_ac].adg03,g_adg[l_ac].adg04
#                    CALL FGL_DIALOG_SETBUFFER( g_adg[l_ac].adg03 )
#                    CALL FGL_DIALOG_SETBUFFER( g_adg[l_ac].adg04 )
                    NEXT FIELD adg03
                WHEN INFIELD(adg06) OR INFIELD(adg07) OR INFIELD(adg08)
                    #CALL q_img5(0,0,g_adg[l_ac].adg05,g_adg[l_ac].adg06,g_adg[l_ac].adg07,g_adg[l_ac].adg08,'S')
                    #     RETURNING g_adg[l_ac].adg06,g_adg[l_ac].adg07,g_adg[l_ac].adg08
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_img8"
                    LET g_qryparam.default1 = g_adg[l_ac].adg06
                    LET g_qryparam.default2 = g_adg[l_ac].adg07
                    LET g_qryparam.default3 = g_adg[l_ac].adg08
                    LET g_qryparam.arg1 = g_adg[l_ac].adg05
                    LET g_qryparam.arg2 = g_plant
                    CALL cl_create_qry() RETURNING g_adg[l_ac].adg06,g_adg[l_ac].adg07,g_adg[l_ac].adg08
#                    CALL FGL_DIALOG_SETBUFFER( g_adg[l_ac].adg06 )
#                    CALL FGL_DIALOG_SETBUFFER( g_adg[l_ac].adg07 )
#                    CALL FGL_DIALOG_SETBUFFER( g_adg[l_ac].adg08 )
                    IF INFIELD(adg06) THEN NEXT FIELD adg06 END IF
                    IF INFIELD(adg07) THEN NEXT FIELD adg07 END IF
                    IF INFIELD(adg08) THEN NEXT FIELD adg08 END IF
               #FUN-580033  --begin
               WHEN INFIELD(adg30) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_adg[l_ac].adg30
                    CALL cl_create_qry() RETURNING g_adg[l_ac].adg30
                    DISPLAY BY NAME g_adg[l_ac].adg30
                    NEXT FIELD adg30

               WHEN INFIELD(adg33) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_adg[l_ac].adg33
                    CALL cl_create_qry() RETURNING g_adg[l_ac].adg33
                    DISPLAY BY NAME g_adg[l_ac].adg33
                    NEXT FIELD adg33
               #FUN-580033  --end
               OTHERWISE EXIT CASE
           END CASE

       ON ACTION CONTROLT
           CASE
              WHEN INFIELD(adg06) #預設倉庫/ 儲位
                  #CALL q_imf(0,0,g_adg[l_ac].adg05,g_adg[l_ac].adg06,g_adg[l_ac].adg07,'*')
                  #     RETURNING g_adg[l_ac].adg06,g_adg[l_ac].adg07
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imf"
                  LET g_qryparam.default1 = g_adg[l_ac].adg06
                  LET g_qryparam.default2 = g_adg[l_ac].adg07
                  LET g_qryparam.arg1 = g_adg[l_ac].adg05
                  CALL cl_create_qry() RETURNING g_adg[l_ac].adg06,g_adg[l_ac].adg07
                  NEXT FIELD adg06
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
     LET g_adf.adfmodu = g_user
     LET g_adf.adfdate = g_today
     UPDATE adf_file SET adfmodu = g_adf.adfmodu,adfdate = g_adf.adfdate
      WHERE adf01 = g_adf.adf01
     IF SQLCA.SQLCODE OR STATUS = 100 THEN
        CALL cl_err('upd adf',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_adf.adfmodu,g_adf.adfdate
    #FUN-5B0113-end

    CLOSE t202_bcl
    COMMIT WORK
#    CALL t202_delall()
END FUNCTION
 
FUNCTION t202_delall()
    SELECT COUNT(*) INTO g_cnt FROM adg_file
        WHERE adg01 = g_adf.adf01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM adf_file WHERE adf01 = g_adf.adf01
    END IF
END FUNCTION

FUNCTION t202_b_askkey()
DEFINE
    l_wc           LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(200)

    #No.FUN-580033  --begin
    CONSTRUCT l_wc ON adg02,adg03,adg04,adg05,adg06,  #螢幕上取單身條件
                      adg07,adg08,adg09,adg10,adg11,adg12,
                      adg33,adg35,adg30,adg32,adg17
       FROM s_adg[1].adg02,s_adg[1].adg03,s_adg[1].adg04,
            s_adg[1].adg05,s_adg[1].adg06,s_adg[1].adg07,
            s_adg[1].adg08,s_adg[1].adg09,s_adg[1].adg10,
            s_adg[1].adg11,s_adg[1].adg12,s_adg[1].adg33,
            s_adg[1].adg35,s_adg[1].adg30,s_adg[1].adg32,
            s_adg[1].adg17
    #No.FUN-580033  --end

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adg03)
                    #CALL q_ade(5,3,g_adg[l_ac].adg03,g_adg[l_ac].adg04,g_adf.adf00)
                    #     RETURNING g_adg[l_ac].adg03,g_adg[l_ac].adg04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ade"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = g_adf.adf00
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adg[1].adg03
                    NEXT FIELD adg03
                WHEN INFIELD(adg06)
                    #CALL q_img5(0,0,g_adg[l_ac].adg05,g_adg[l_ac].adg06,g_adg[l_ac].adg07,g_adg[l_ac].adg08,'S')
                    #     RETURNING g_adg[l_ac].adg06,g_adg[l_ac].adg07,g_adg[l_ac].adg08
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_img8"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.multiret_index = 1
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adg[1].adg06
                    NEXT FIELD adg06
                WHEN INFIELD(adg07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_img8"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.multiret_index = 2
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adg[1].adg07
                    NEXT FIELD adg07
                WHEN INFIELD(adg08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_img8"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.multiret_index = 3
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adg[1].adg08
                    NEXT FIELD adg08
                #No.FUN-580033  --begin
                WHEN INFIELD(adg33)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO adg33
                   NEXT FIELD adg33
                WHEN INFIELD(adg30)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO adg30
                   NEXT FIELD adg30
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
    CALL t202_b_fill(l_wc)
END FUNCTION

FUNCTION t202_b_fill(p_wc)         #BODY FILL UP
DEFINE
    p_wc    LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(400)

    #No.FUN-580033  --begin
    LET g_sql =
       "SELECT adg02,adg03,adg04,adg05,ima02,ima021,adg06,adg07,",
       "       adg08,adg09,adg10,adg11,adg12,adg33,adg34,adg35,",
       "       adg30,adg31,adg32,adg17 ",
       " FROM adg_file,ima_file",
       " WHERE adg01 = '",g_adf.adf01,"' AND ",p_wc CLIPPED ,
       "   AND ima01 = adg05 ",
       " ORDER BY adg02"
    #No.FUN-580033  --end
    PREPARE t202_prepare2 FROM g_sql      #預備一下
    DECLARE adg_cs CURSOR FOR t202_prepare2

    CALL g_adg.clear()
    LET g_cnt = 1
    FOREACH adg_cs INTO g_adg[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_adg.deleteElement(g_cnt)

    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t202_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adg TO s_adg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL t202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION previous
         CALL t202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION jump
         CALL t202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION next
         CALL t202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION last
         CALL t202_fetch('L')
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
         CALL t202_mu_ui()   #FUN-610067
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
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
      #ON ACTION btn01                                      #MOD-560158
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
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION


FUNCTION t202_copy()
DEFINE
    l_newno         LIKE adf_file.adf01,
    l_oldno         LIKE adf_file.adf01
DEFINE li_result    LIKE type_file.num5    #No.FUN-550026    #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_adf.adf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_adf.adf00 = '1' THEN LET g_type = '13' END IF
    IF g_adf.adf00 = '2' THEN LET g_type = '14' END IF
    IF g_adf.adf00 = '3' THEN LET g_type = '15' END IF

    LET g_before_input_done = FALSE
    CALL t202_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno FROM adf01
        AFTER FIELD adf01
            IF l_newno IS NULL THEN
                NEXT FIELD adf01
            END IF
            LET g_t1 = s_get_doc_no(l_newno)   #No.FUN-550026
            SELECT * INTO g_adz.* FROM adz_file WHERE adzslip = g_t1
               AND adztype = g_type
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_newno,'mfg0014',0)
               NEXT FIELD adf01
            END IF
#            IF cl_null(l_newno[5,10]) AND g_adz.adzauno='N'
            IF cl_null(l_newno[g_no_sp,g_no_ep]) AND g_adz.adzauno='N'  #No.FUN-550026
               THEN NEXT FIELD adf01
            END IF
            IF g_adz.adzauno='Y' THEN   #need modify to add adf_file in it
#No.FUN-550026 --start--
            CALL  s_auto_assign_no("apm",l_newno,g_adf.adf02,"","","",
                  "","","")
                  RETURNING li_result,l_newno
            IF (NOT li_result) THEN
                  NEXT FIELD adf01
            END IF
               DISPLAY l_newno TO adf01

#              CALL s_axdauno(l_newno,g_adf.adf02) RETURNING g_i,l_newno
#              IF g_i THEN #有問題
#                 NEXT FIELD adf01
#              END IF
#              DISPLAY l_newno TO adf01
#No.FUN-550026 --end--
            END IF

            SELECT count(*) INTO g_cnt FROM adf_file
                WHERE adf01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD adf01
            END IF
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adf01)        #need modify
                    LET g_t1=l_newno[1,3]
                    CASE
                       #WHEN g_adf.adf00='1' CALL q_adz(FALSE,FALSE,g_t1,'13','axd') #TQC-670008
                       WHEN g_adf.adf00='1' CALL q_adz(FALSE,FALSE,g_t1,'13','AXD')  #TQC-670008
                                                 RETURNING g_t1
                       #WHEN g_adf.adf00='2' CALL q_adz(FALSE,FALSE,g_t1,'14','axd') #TQC-670008
                       WHEN g_adf.adf00='2' CALL q_adz(FALSE,FALSE,g_t1,'14','AXD')  #TQC-670008
                                                 RETURNING g_t1
                       #WHEN g_adf.adf00='3' CALL q_adz(FALSE,FALSE,g_t1,'15','axd') #TQC-670008
                       WHEN g_adf.adf00='3' CALL q_adz(FALSE,FALSE,g_t1,'15','AXD')  #TQC-670008
                                                 RETURNING g_t1
                    END CASE
                    LET l_newno[1,3]=g_t1
                    DISPLAY l_newno TO adf01
                    NEXT FIELD adf01
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
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM adf_file
        WHERE adf01=g_adf.adf01
        INTO TEMP y
    UPDATE y
        SET y.adf01=l_newno,    #資料鍵值
            y.adfuser = g_user,
            y.adfgrup = g_grup,
            y.adfdate = g_today,
            y.adfacti = 'Y',
            y.adfconf = 'N',
            y.adfpost = 'N'
    INSERT INTO adf_file  #複製單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL  cl_err(l_newno,SQLCA.sqlcode,0)
    END IF
    DROP TABLE x
    SELECT * FROM adg_file
       WHERE adg01 = g_adf.adf01
       INTO TEMP x
    UPDATE x
       SET adg01 = l_newno
    INSERT INTO adg_file    #複製單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_newno,SQLCA.sqlcode,0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno = g_adf.adf01
        SELECT ROWID,adf_file.* INTO g_adf_rowid,g_adf.* FROM adf_file
               WHERE adf01 =  l_newno
        CALL t202_u()
        CALL t202_show()
        LET g_adf.adf01 = l_oldno
        SELECT ROWID,adf_file.* INTO g_adf_rowid,g_adf.* FROM adf_file
               WHERE adf01 = g_adf.adf01
        CALL t202_show()
    END IF
    DISPLAY BY NAME g_adf.adf01
END FUNCTION

FUNCTION t202_y() #確認
    IF g_adf.adf01 IS NULL THEN RETURN END IF
    SELECT * INTO g_adf.* FROM adf_file WHERE adf01=g_adf.adf01
    IF g_adf.adfacti='N' THEN
       CALL cl_err(g_adf.adf01,'mfg1000',0)
       RETURN
    END IF
    IF g_adf.adfconf='Y' THEN RETURN END IF
    IF g_adf.adfpost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK

    OPEN t202_cl USING g_adf_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t202_cl:", STATUS, 1)
       CLOSE t202_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t202_cl INTO g_adf.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
        CLOSE t202_cl
        ROLLBACK WORK
        RETURN
    END IF

    UPDATE adf_file SET adfconf='Y',adf10='1'
     WHERE adf01 = g_adf.adf01
    IF STATUS THEN
       CALL cl_err('upd adfconf',STATUS,0)
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT adfconf,adf10 INTO g_adf.adfconf,g_adf.adf10 FROM adf_file
     WHERE adf01 = g_adf.adf01
    DISPLAY BY NAME g_adf.adfconf
    DISPLAY BY NAME g_adf.adf10
    CALL t202_adf10()
END FUNCTION

FUNCTION t202_w() #取消確認
    IF g_adf.adf01 IS NULL THEN RETURN END IF
    SELECT * INTO g_adf.* FROM adf_file WHERE adf01=g_adf.adf01
    IF g_adf.adfconf='N' THEN RETURN END IF
    IF g_adf.adfpost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK
    OPEN t202_cl USING g_adf_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t202_cl:", STATUS, 1)
       CLOSE t202_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t202_cl INTO g_adf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
        CLOSE t202_cl
        ROLLBACK WORK
        RETURN
    END IF
    UPDATE adf_file SET adfconf='N',adf10='0'
        WHERE adf01 = g_adf.adf01
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
    SELECT adfconf,adf10 INTO g_adf.adfconf,g_adf.adf10 FROM adf_file
        WHERE adf01 = g_adf.adf01
    DISPLAY BY NAME g_adf.adfconf
    DISPLAY BY NAME g_adf.adf10
    CALL t202_adf10()
END FUNCTION

FUNCTION t202_s()
   DEFINE l_cnt   LIKE type_file.num10,  #No.FUN-680108 INTEGER
          l_i     LIKE type_file.num5,   #No.FUN-680108 SMALLINT
          l_cmd   LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(300)
          l_plant LIKE azp_file.azp01,
          l_dbs   LIKE azp_file.azp03
   DEFINE b_adg   RECORD LIKE adg_file.* #No:FUN-610090

   IF s_shut(0) THEN RETURN END IF

   IF g_adf.adf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_adf.* FROM adf_file
    WHERE adf01 = g_adf.adf01

   IF g_adf.adfacti = 'N' THEN
      CALL cl_err(g_adf.adf01,'mfg1000',0)
      RETURN
   END IF

   IF g_adf.adfpost = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF

   IF g_adf.adfconf = 'N' THEN
      CALL cl_err('','mfg3550',0)
      RETURN
   END IF

   IF YEAR(g_adf.adf02)*12+MONTH(g_adf.adf02)<g_sma.sma51*12+g_sma.sma52 THEN
      CALL cl_err(g_adf.adf02,'axd-024',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM adg_file WHERE adg01=g_adf.adf01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   IF NOT cl_confirm('mfg0176') THEN
      RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t202_cl USING g_adf_rowid
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t202_cl INTO g_adf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF


   CALL t202_ss()

   IF g_success = 'Y' THEN
      UPDATE adf_file SET adfpost = 'Y',
                          adf09 = g_adf.adf09
       WHERE adf01 = g_adf.adf01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd adfpost: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK
         RETURN
      END IF

      LET g_adf.adfpost = 'Y'
      DISPLAY BY NAME g_adf.adfpost ATTRIBUTE(REVERSE)
      DISPLAY BY NAME g_adf.adf09 ATTRIBUTE(REVERSE)
      COMMIT WORK
   ELSE
      LET g_adf.adfpost = 'N'
      ROLLBACK WORK
   END IF

   #-----No:FUN-610090-----
   IF g_adf.adfpost = "N" THEN
      DECLARE t202_s1_c2 CURSOR FOR SELECT * FROM adg_file
        WHERE adg01 = g_adf.adf01

      LET g_imm01 = ""
      LET g_success = "Y"
      BEGIN WORK

      FOREACH t202_s1_c2 INTO b_adg.*
         IF STATUS THEN
            EXIT FOREACH
         END IF

         IF g_sma.sma115 = 'Y' THEN
            IF g_ima906 = '2' THEN  #子母單位
               LET g_unit_arr[1].unit= b_adg.adg30
               LET g_unit_arr[1].fac = b_adg.adg31
               LET g_unit_arr[1].qty = b_adg.adg32
               LET g_unit_arr[2].unit= b_adg.adg33
               LET g_unit_arr[2].fac = b_adg.adg34
               LET g_unit_arr[2].qty = b_adg.adg35
               CALL s_dismantle(g_adf.adf01,b_adg.adg02,g_adf.adf09,
                                b_adg.adg05,b_adg.adg06,b_adg.adg07,
                                b_adg.adg08,g_unit_arr,g_imm01)
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

   #對每一張采購單進行發出
   IF g_adf.adfmksg='N' AND g_adf.adf00='2' THEN
      FOR l_i=1 TO g_i1-1
         SELECT azp03 INTO l_dbs FROM azp_file
          WHERE azp01 = g_pmm[l_i].azp01
         IF SQLCA.sqlcode THEN
            CALL cl_err('select azp03',SQLCA.sqlcode,0)
            EXIT FOR
         END IF
         LET l_cmd = "gpmp554 '",g_pmm[l_i].pmm01 CLIPPED,"' ",
                             "'",g_pmm[l_i].pmm04 CLIPPED,"' ",
                             "'",g_pmm[l_i].pmm09 CLIPPED,"' ",
                             "'",g_pmm[l_i].azp01 CLIPPED,"' ",
                             "'",l_dbs CLIPPED,"'"
         #CALL cl_cmdrun(l_cmd)      #FUN-660216 remark
         CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
      END FOR
   END IF

   MESSAGE ''

END FUNCTION

FUNCTION t202_ss()

   LET g_i1=1
   CALL t202_y1()
   IF g_success = 'N' THEN
      RETURN
   END IF

END FUNCTION

FUNCTION t202_y1()
  DEFINE b_adg RECORD
               adg02  LIKE adg_file.adg02,   #撥出項次
               adg03  LIKE adg_file.adg03,   #申請單號
               adg04  LIKE adg_file.adg04,   #申請單項次

               ade16  LIKE ade_file.ade16,   #撥入單
               ade17  LIKE ade_file.ade17,   #撥入單項次
               adi15  LIKE adi_file.adi15,   #采購單
               adi16  LIKE adi_file.adi16,   #采購單項次
               rvb01  LIKE rvb_file.rvb01,   #收貨單
               rvb02  LIKE rvb_file.rvb01,   #收貨單項次

               adg05  LIKE adg_file.adg05,   #料件
               adg06  LIKE adg_file.adg06,   #撥出倉庫
               adg07  LIKE adg_file.adg07,   #儲位
               adg08  LIKE adg_file.adg08,   #批號
               adg09  LIKE adg_file.adg09,   #撥入工廠代號
               adg10  LIKE adg_file.adg10,   #撥入工廠倉庫
               adg11  LIKE adg_file.adg11,   #單位
               #No.FUN-580033  --begin
               adg12  LIKE adg_file.adg12,   #撥出數量

               adg33  LIKE adg_file.adg33,   #單位二
               adg34  LIKE adg_file.adg34,   #單位二轉換率
               adg35  LIKE adg_file.adg35,   #單位二數量
               adg30  LIKE adg_file.adg30,   #單位一
               adg31  LIKE adg_file.adg31,   #單位一轉換率
               adg32  LIKE adg_file.adg32    #單位一數量
               #No.FUN-580033  --end
               END RECORD,
         l_adg09 LIKE adg_file.adg09,
         l_rvb01 LIKE rvb_file.rvb01

  #對于adg中的每一筆都要insert到adq_file中
  IF g_adf.adf00 MATCHES '[12]' THEN
     LET g_sql=" SELECT adg02,adg03,adg04,'','','','','','',adg05,adg06,",
               "        adg07,adg08,adg09,adg10,adg11,adg12,",  #No.FUN-580033
               "        adg33,adg34,adg35,adg30,adg31,adg32 ",  #No.FUN-580033
               "   FROM adg_file",
               "  WHERE adg01='",g_adf.adf01,"'",
               "  ORDER BY adg09,adg02,adg03,adg04"
  ELSE
     LET g_sql=" SELECT adg02,adg03,adg04,ade16,ade17,adi15,adi16,",
               "        rvb01,rvb02,adg05,adg06,adg07,adg08,",
               "        adg09,adg10,adg11,adg12,",              #No.FUN-580033
               "        adg33,adg34,adg35,adg30,adg31,adg32 ",  #No.FUN-580033
               "   FROM adg_file,ade_file,add_file,adh_file,adi_file,",
               "        pmn_file,rva_file,rvb_file",
               "  WHERE adg01='",g_adf.adf01,"'",
               "    AND add01=ade01 AND add00='3'",       #申請單
               "    AND adg03=ade01 AND adg04=ade02 ",
               "    AND adh01=adi01 AND adh00='2'",       #撥入單
               "    AND ade16=adi01 AND ade17=adi02 ",
               "    AND adi15=pmn01 AND adi16=pmn02 ",    #采購單
               "    AND rva01=rvb01 AND rva07=adi01 AND rvb32=adi02", #收貨單
               "  ORDER BY adg09,rvb01,adg02,adg03,adg04"
  END IF
  PREPARE t202_pp FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  DECLARE t202_y1_c1 SCROLL CURSOR FOR t202_pp
  LET l_adg09 = NULL
  LET l_rvb01 = NULL

  CALL s_showmsg_init()   #No:FUN-6C0083 
  
  FOREACH t202_y1_c1 INTO b_adg.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_adg.adg03) THEN CONTINUE FOREACH END IF

      IF cl_null(l_adg09) OR l_adg09 <> b_adg.adg09 THEN   #單身換成另一個工廠
         LET g_head = 1
      ELSE
         LET g_head = 0
         IF g_adf.adf00 = '3' THEN                         #切換成另一張收貨單
            IF cl_null(l_rvb01) OR l_rvb01 <> b_adg.rvb01 THEN
               LET g_head = 1
            ELSE
               LET g_head = 0
            END IF
         END IF
      END IF
      CALL t202_y2(b_adg.*)
      LET l_adg09 = b_adg.adg09
      LET l_rvb01 = b_adg.rvb01
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

FUNCTION t202_y2(p_adg)
  DEFINE p_adg       RECORD
                     adg02  LIKE adg_file.adg02,   #撥出項次
                     adg03  LIKE adg_file.adg03,   #申請單號
                     adg04  LIKE adg_file.adg04,   #申請單項次

                     ade16  LIKE ade_file.ade16,   #撥入單
                     ade17  LIKE ade_file.ade17,   #撥入單項次
                     adi15  LIKE adi_file.adi15,   #采購單
                     adi16  LIKE adi_file.adi16,   #采購單項次
                     rvb01  LIKE rvb_file.rvb01,   #收貨單
                     rvb02  LIKE rvb_file.rvb01,   #收貨單項次

                     adg05  LIKE adg_file.adg05,   #料件
                     adg06  LIKE adg_file.adg06,   #撥出倉庫
                     adg07  LIKE adg_file.adg07,   #儲位
                     adg08  LIKE adg_file.adg08,   #批號
                     adg09  LIKE adg_file.adg09,   #撥入工廠代號
                     adg10  LIKE adg_file.adg10,   #撥入工廠倉庫
                     adg11  LIKE adg_file.adg11,   #單位
                     #No.FUN-580033  --begin
                     adg12  LIKE adg_file.adg12,   #撥出數量

                     adg33  LIKE adg_file.adg33,   #單位二
                     adg34  LIKE adg_file.adg34,   #單位二轉換率
                     adg35  LIKE adg_file.adg35,   #單位二數量
                     adg30  LIKE adg_file.adg30,   #單位一
                     adg31  LIKE adg_file.adg31,   #單位一轉換率
                     adg32  LIKE adg_file.adg32    #單位一數量
                     #No.FUN-580033  --end
                     END RECORD,
         l_buf       LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(100)
         l_tot       LIKE adg_file.adg12,
         l_pmm       RECORD LIKE pmm_file.*,
         l_pmn       RECORD LIKE pmn_file.*,
         l_adu       RECORD LIKE adu_file.*,
         l_smy       RECORD LIKE smy_file.*,
         l_cnt       LIKE type_file.num10,         #No.FUN-680108 INTEGER 
         l_img_rowid LIKE type_file.chr18,         #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         l_img10,t_img10 LIKE img_file.img10,
         l_img21_fac LIKE img_file.img21,
         l_fac       LIKE img_file.img21,
         l_img23     LIKE img_file.img23,
         l_img24     LIKE img_file.img24,
         l_img09     LIKE img_file.img09,
         l_ade13     LIKE ade_file.ade13,
         l_azp02     LIKE azp_file.azp02,
         l_ima02     LIKE ima_file.ima02,
         l_adi17     LIKE adi_file.adi17,
         l_rvv       RECORD LIKE rvv_file.*,
         l_adw       RECORD LIKE adw_file.*,
         l_dbs       LIKE azp_file.azp03
DEFINE   li_result   LIKE type_file.num5   #No.FUN-680108 SMALLINT 
DEFINE   l_pmm40     LIKE pmm_file.pmm40,  #No.FUN-610018
         l_pmm40t    LIKE pmm_file.pmm40t  #No.FUN-610018

###########check夠不夠發料 ade_file集團調撥申請單###########################
  #當前撥出申請單可撥出總數量
  SELECT ade05-ade12 INTO l_tot FROM add_file,ade_file
   WHERE ade01 = p_adg.adg03 AND ade02 = p_adg.adg04
     AND add01 = ade01 AND addacti = 'Y'
     AND addconf = 'Y' AND add07 = 'N'
     AND add06 = '1' AND add00 = g_adf.adf00
     AND ade13 = 'N'

  IF cl_null(l_tot) THEN LET l_tot = 0 END IF
  IF cl_null(p_adg.adg12) THEN LET p_adg.adg12 = 0 END IF

  #撥出數量大于申請單上可撥數量
  IF p_adg.adg12 > l_tot THEN
     LET l_buf = p_adg.adg03 CLIPPED,' ',p_adg.adg04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-023',1)
     LET g_success = 'N' RETURN
  ELSE
     #可以撥出，更新申請單上剩余的可撥量         ok
     SELECT ade13 INTO l_ade13 FROM ade_file WHERE ade01=p_adg.adg03
                                               AND ade02=p_adg.adg04
     IF cl_null(l_ade13) OR l_ade13='Y' THEN    #若申請單已結案,則不得有異動
        LET l_buf = p_adg.adg03 CLIPPED,' ',p_adg.adg04 CLIPPED
        CALL cl_err(l_buf CLIPPED,'9004',1)
        LET g_success = 'N' RETURN
     END IF

     UPDATE ade_file SET ade12 = ade12 + p_adg.adg12
      WHERE ade01 = p_adg.adg03 AND ade02 = p_adg.adg04
     IF SQLCA.sqlcode THEN
        CALL cl_err('update ade',SQLCA.sqlcode,0)
        LET g_success = 'N' RETURN
     END IF
  END IF

  IF g_adf.adf00='3' THEN     #check撥入單有撥入數量可用來倉退
     IF cl_null(p_adg.ade16) OR cl_null(p_adg.ade17) THEN
        CALL cl_err(p_adg.adg03,'axd-091',1)
        LET g_success='N' RETURN
     END IF
     SELECT adi10-adi17 INTO l_adi17 FROM adi_file
      WHERE adi01=p_adg.ade16 AND adi02=p_adg.ade17
     IF cl_null(l_adi17) THEN LET l_adi17=0 END IF
     IF l_adi17<p_adg.adg12 THEN
        CALL cl_err(p_adg.adg03,'axd-091',1)
        LET g_success='N' RETURN
     END IF
  END IF

##############update img 撥出倉###########################
  SELECT img09,ROWID INTO g_img09,l_img_rowid FROM img_file#No.FUN-580033
   WHERE img01 = p_adg.adg05 AND img02 = p_adg.adg06
     AND img03 = p_adg.adg07 AND img04 = p_adg.adg08
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err('update img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err('update img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     END IF
     RETURN
 END IF
 #No.FUN-580033 --begin
 LET g_factor=1
 IF g_img09 <> p_adg.adg11 THEN
    CALL s_umfchk(p_adg.adg05,p_adg.adg11,g_img09)
         RETURNING g_cnt,g_factor
    IF g_cnt=1 THEN
       LET g_factor=1
    END IF
 END IF
 LET g_qty=p_adg.adg12*g_factor
 #No.FUN-580033 --end
#更新調出倉庫、儲位、批號的img_file的數量
#                1           2  3           4
      #CALL s_upimg(l_img_rowid,-1,p_adg.adg12,g_adf.adf02,#No.FUN-580033
      CALL s_upimg(l_img_rowid,-1,g_qty,g_adf.adf02,#No.FUN-580033
#         5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22
          '','','','','','','','','','','','','','','','','','')
      IF g_success = 'N' THEN
         CALL cl_err('update img',SQLCA.sqlcode,0)
         RETURN
      END IF
#---->若庫存異動後其庫存量小於等於零時將該筆資料刪除
      CALL s_delimg(l_img_rowid)
      IF SQLCA.sqlcode THEN
         CALL cl_err('delimg',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF

##############update img 在途倉###########################
      CALL s_upimg(-3333,+1,p_adg.adg12,g_adf.adf02,
#       5           6           7           8
 #       p_adg.adg05,g_adf.adf07,g_adf.adf01,p_adg.adg02,  #No.MOD-560296
         p_adg.adg05,g_adf.adf07,p_adg.adg02,g_adf.adf01,  #No.MOD-560296
#       9           10          11          12          13
        g_adf.adf01,p_adg.adg02,p_adg.adg11,p_adg.adg12,p_adg.adg11,
#       14  15   16   17  18  19  20  21  22
        1,  '',   1, '',  '', '', '', '', '')
      IF g_success = 'N' THEN
         CALL cl_err('upimg',SQLCA.sqlcode,0)
         RETURN
      END IF

##############update ima 撥出倉###########################
#---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
      SELECT img10,img21,img23,img24
        INTO l_img10,l_img21_fac,l_img23,l_img24
       FROM  img_file
      WHERE img01= p_adg.adg05 AND img02= p_adg.adg06
        AND img03= p_adg.adg07 AND img04= p_adg.adg08
      IF s_udima(p_adg.adg05,              #料件編號
                 l_img23,                  #是否可用倉儲
                 l_img24,                  #是否為MRP可用倉儲
                 p_adg.adg12*l_img21_fac,  #調撥數量(換算為庫存單位)
                 g_adf.adf02,              #最近一次調撥日期
                 -1)                       #表調撥出
      THEN LET g_success = 'N' CALL cl_err('upima',SQLCA.sqlcode,0) RETURN
      END IF

##############update tlf_file#############################
      SELECT img10 INTO t_img10 FROM img_file
       WHERE img01 = p_adg.adg05 AND img02 = g_adf.adf07
         #AND img03 = g_adf.adf01 AND img04 = p_adg.adg02   #No.MOD-560296
          AND img03 = p_adg.adg02 AND img04 = g_adf.adf01   #No.MOD-560296
      IF cl_null(t_img10) THEN LET t_img10 = 0 END IF
      CALL t202_tlf(t_img10,p_adg.*,'1',l_img10)
      IF g_success = 'N' THEN RETURN END IF
      CALL t202_tlf(t_img10,p_adg.*,'2',l_img10)
      IF g_success = 'N' THEN RETURN END IF

      #No.FUN-580033  --begin
      IF g_sma.sma115='Y' THEN
         LET t_adg.*=p_adg.*
         CALL t202_update_du(p_adg.adg06,p_adg.adg07,p_adg.adg08,-1,+1,NULL)
         IF g_success='N' THEN RETURN END IF
         CALL t202_update_du(g_adf.adf07,p_adg.adg02,g_adf.adf01,+1,+1,-3333)
         IF g_success='N' THEN RETURN END IF
      END IF
      #No.FUN-580033  --end

###############外部調撥/外部退回###########
      IF p_adg.adg09 <> g_azp01 THEN
         SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adg.adg09
         IF SQLCA.sqlcode THEN
            CALL cl_err(p_adg.adg09,SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
################外部調撥################
         IF g_adf.adf00 = '2' THEN
            IF g_head = 1 THEN
               #找數據庫
               LET g_sql = " SELECT * FROM ",p_dbs CLIPPED,".adu_file",
                           "  WHERE adu01 = '",g_azp01,"'"
               PREPARE t202_prepare1 FROM g_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('select aud',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               DECLARE t202_curs1 SCROLL CURSOR FOR t202_prepare1
               IF SQLCA.sqlcode THEN
                  CALL cl_err('select aud',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               OPEN t202_curs1
               FETCH t202_curs1 INTO l_adu.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('select aud',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               #########INSERT 采購單單頭檔[pmm_file]#############
           #No.FUN-550026 --start--
#No.FUN-560014-begin
              IF cL_null(p_dbs) THEN
                 LET p_dbs=g_dbs
              END IF
              CALL s_check_no("apm",l_adu.adu02,"","2","","",p_dbs)
#No.FUN-560014-end
              RETURNING li_result,l_adu.adu02
              IF (NOT li_result) THEN
                 LET g_success = 'N'
                 RETURN
              END IF
              CALL s_get_doc_no(l_adu.adu02) RETURNING l_adu.adu02#No.FUN-580033
              DISPLAY BY NAME l_adu.adu02
#              CALL s_mfgslip1(l_adu.adu02,'apm','2',p_dbs)
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(l_adu.adu02,g_errno,0)
#                 LET g_success = 'N'
#                 RETURN
#              END IF
           #No.FUN-550026 --end--
               LET g_sql = "SELECT * FROM ",p_dbs CLIPPED,".smy_file",
                           " WHERE smyslip = '",l_adu.adu02,"'"
               PREPARE t202_prepare3 FROM g_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('select smy',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               DECLARE t202_curs2 SCROLL CURSOR FOR t202_prepare3
               IF SQLCA.sqlcode THEN
                  CALL cl_err('select smy',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               OPEN t202_curs2
               FETCH t202_curs2 INTO l_smy.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('select smy',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
#No.FUN-560014-begin
               CALL s_auto_assign_no("axd",l_adu.adu02,g_adf.adf02,"","","",p_dbs,"","")
                 RETURNING li_result,g_pmm01
               IF (NOT li_result) THEN
                   LET g_success = 'N'
                   RETURN
               END IF
#              CALL s_smyauno1(l_adu.adu02,g_adf.adf02,p_dbs)
#                   RETURNING g_cnt,g_pmm01
#              IF g_cnt <> 0 THEN
#                 CALL cl_err('','mfg3326',1)
#                 LET g_success = 'N'
#                 RETURN
#              END IF
#No.FUN-560014-end
               IF l_smy.smyapr = 'Y' THEN
                  LET g_pmm25 = 'S'
               ELSE
                  LET g_pmm25 = '1'
               END IF
               LET l_pmm40 = 0     #No.FUN-610018
               LET l_pmm40t= 0     #No.FUN-610018
               LET g_sql = " INSERT INTO ",p_dbs CLIPPED,".pmm_file",
                           "(pmm01,pmm02,pmm04,pmm09,pmm10,pmm12,pmm43,pmm42,pmm13,pmm18,",
                           " pmm20,pmm21,pmm22,pmmmksg,pmm25,pmm40,pmm40t,pmm41,",    #No.FUN-610018
                           " pmm45,pmmacti,pmmuser,pmmgrup,pmmmodu,pmmdate)",
                           " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #No.FUN-610018
               PREPARE t202_pre3 FROM g_sql
               EXECUTE t202_pre3 USING
                  g_pmm01,'ICT',g_today,l_adu.adu01,l_adu.adu05,l_adu.adu06,
                  l_adu.adu09,l_adu.adu11,l_adu.adu07,'Y',l_adu.adu03,
                  l_adu.adu08,l_adu.adu10,
                  l_smy.smyapr,g_pmm25,l_pmm40,l_pmm40t,l_adu.adu04,'Y','Y',   #No.FUN-610018
                  g_user,g_grup,' ',g_today
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET g_pmm[g_i1].pmm01=g_pmm01
               LET g_pmm[g_i1].pmm04=g_today
               LET g_pmm[g_i1].pmm09=l_adu.adu01
               LET g_pmm[g_i1].azp01=p_adg.adg09
               LET g_i1=g_i1+1
            END IF   #head=1
            #########INSERT 采購單單身檔[pmn_file]#############
            LET l_pmn.pmn01 = g_pmm01  LET l_pmn.pmn011 = 'ICT'
            LET g_sql = " SELECT MAX(pmn02)+1 FROM ",p_dbs CLIPPED,".pmn_file",
                        "  WHERE pmn01 = '",l_pmn.pmn01,"'"
            PREPARE t202_prepare4 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('select pmn',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            DECLARE t202_curs4 SCROLL CURSOR FOR t202_prepare4
            IF SQLCA.sqlcode THEN
               CALL cl_err('select pmn',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            OPEN t202_curs4
            FETCH t202_curs4 INTO l_pmn.pmn02
            IF cl_null(l_pmn.pmn02) OR l_pmn.pmn02 = 0 THEN
               LET l_pmn.pmn02 = 1
            END IF
            LET g_sql = "SELECT ima02,ima25,ima15 ",
                        "  FROM ",p_dbs CLIPPED,".ima_file",
                        " WHERE ima01 = '",p_adg.adg05 CLIPPED,"'"
            PREPARE t202_prepare5 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('select ima',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            DECLARE t202_curs5 SCROLL CURSOR FOR t202_prepare5
            IF SQLCA.sqlcode THEN
               CALL cl_err('select ima',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            OPEN t202_curs5
            FETCH t202_curs5 INTO l_pmn.pmn041,l_pmn.pmn08,l_pmn.pmn64

            LET l_pmn.pmn07 = p_adg.adg11
            LET l_dbs = p_dbs CLIPPED,"."
            CALL s_umfchk1(p_adg.adg05,l_pmn.pmn07,l_pmn.pmn08,l_dbs)
                 RETURNING l_cnt,l_fac
            IF l_cnt=1 THEN
               CALL cl_err('','abm-731',0)
               LET l_fac = 1
            END IF
            IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
            LET g_sql = " INSERT INTO ",p_dbs CLIPPED,".pmn_file",
#                         1      2      3     4    5      6    7
                        "(pmn01,pmn011,pmn02,pmn24,pmn25,pmn16,pmn14,",
#                         8      9      10    11   12     13   14
                        " pmn65,pmn04,pmn041,pmn07,pmn08,pmn09,pmn20,",
#                         15     16     17    18   19     20   21
                        " pmn31,pmn50,pmn51,pmn55,pmn58,pmn52,pmn64,",
#                         22     23     24    25   26     27
                        " pmn63,pmn33,pmn31t,pmn53,pmn57,pmn61,", #No.FUN-580033
#                         28    29    30    31    32    33
                        " pmn62,pmn42,pmn44,pmn80,pmn81,pmn82,",  #No.FUN-580033
#                         34    35    36    37    38
                        " pmn83,pmn84,pmn85,pmn86,pmn87 )",       #No.FUN-580033
                        " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #No.FUN-580033
            PREPARE t202_pre6 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('insert pmn',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            EXECUTE t202_pre6 USING
#                1       2     3           4               5
               g_pmm01,'ICT',l_pmn.pmn02,g_adf.adf01,p_adg.adg02,
#                6      7   8    9          10           11
               g_pmm25,'Y','1',p_adg.adg05,l_pmn.pmn041,p_adg.adg11,
#                12        13     14         15  16  17  18  19   20
               l_pmn.pmn08,l_fac,p_adg.adg12,'0','0','0','0','0',p_adg.adg10,
#                21         22   23        24  25  26  27  28  29  30
               l_pmn.pmn64,'N',g_adf.adf06,'0','0','0','0','0','0','0',
               #No.FUN-580033  --begin
               p_adg.adg30,p_adg.adg31,p_adg.adg32,p_adg.adg33,
               p_adg.adg34,p_adg.adg35,p_adg.adg11,p_adg.adg12
               #No.FUN-580033  --end

            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
         ELSE
            IF g_adf.adf00 = '3' THEN
               UPDATE adi_file SET adi17 = adi17 + p_adg.adg12  #倉退數量
                WHERE adi01=p_adg.ade16 AND adi02 = p_adg.ade17
               IF SQLCA.sqlcode THEN
                  CALL cl_err('update adi17',SQLCA.sqlcode,0)
                  LET g_success = 'N' RETURN
               END IF
               IF g_head=1 THEN
                  ###對rvu倉退單編號
                  SELECT * INTO l_adw.* FROM adw_file WHERE adw01=p_adg.adg09
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('select adw',SQLCA.sqlcode,0)
                     LET g_success='N'
                     RETURN
                  END IF
           #No.FUN-550026 --start--
              CALL s_check_no("apm",l_adw.adw02,"","4","","",g_azp03)   #No.FUN-560014
              RETURNING li_result,l_adw.adw02
              IF (NOT li_result) THEN
                 LET g_success = 'N' RETURN
              END IF
              CALL s_get_doc_no(l_adw.adw02) RETURNING l_adw.adw02
              DISPLAY BY NAME l_adw.adw02
#                 CALL s_mfgslip1(l_adw.adw02,'apm','4',g_azp03)  #檢查單別
#                 IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
#                    CALL cl_err(l_adw.adw02,g_errno,0)
#                    LET g_success = 'N' RETURN
#                 END IF
               CALL s_auto_assign_no("axd",l_adw.adw02,g_today,"4","","",g_azp03,"","")    #No.FUN-560014
                  RETURNING li_result,g_rvu01
   	        IF (NOT li_result) THEN
                LET g_success='N' RETURN
  	        END IF
#                 CALL s_smyauno1(l_adw.adw02,g_today,g_azp03)
#                      RETURNING g_i,g_rvu01  #后六位
#                 IF g_i THEN LET g_success='N' RETURN END IF
           #No.FUN-550026 --end--
                  SELECT azp02 INTO l_azp02 FROM azp_file
                   WHERE azp01=p_adg.adg09
                  LET l_azp02=l_azp02[1,8]
#                                      1     2     3     4     5     6
                  INSERT INTO rvu_file(rvu00,rvu02,rvu03,rvu01,rvu04,rvu05,
#                        7     8     9     10    11      12    13
                         rvu06,rvu07,rvu08,rvu09,rvuconf,rvu20,rvuuser,
#                        14      15      16      17
                         rvugrup,rvumodu,rvudate,rvuacti)
#                        1   2            3           4       5
                  VALUES('3',p_adg.rvb01 ,g_today    ,g_rvu01,p_adg.adg09,
#                        6       7           8           9     10   11
                         l_azp02,l_adw.adw03,l_adw.adw04,'ICT',NULL,'Y',
#                        12  13     14     15 16      17
                         'N',g_user,g_grup,'',g_today,'Y')
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('insert rvu',SQLCA.sqlcode,0)
                     LET g_success='N' RETURN
                  END IF
               END IF
               SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file
                WHERE rvv01 = g_rvu01
               IF cl_null(l_rvv.rvv02) OR l_rvv.rvv02 = 0 THEN
                  LET l_rvv.rvv02 = 1
               END IF
               SELECT ima02 INTO l_ima02 FROM ima_file
                WHERE ima01=p_adg.adg05
               SELECT img09,img10 INTO l_img09,g_img10 FROM img_file
                WHERE img01 = p_adg.adg05 AND img02 = p_adg.adg06
                  AND img03 = p_adg.adg07 AND img04 = p_adg.adg08
               CALL s_umfchk(p_adg.adg05,p_adg.adg11,l_img09)
                    RETURNING g_cnt,l_fac
               IF g_cnt=1 THEN
                  CALL cl_err('','abm-731',0)
                  LET l_fac = 1
               END IF
               IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF  #no.TQC-790003
          #                         1     2     3     4     5     6
               INSERT INTO rvv_file(rvv01,rvv02,rvv03,rvv04,rvv05,rvv06,
          #                         7     8     9     10    11    12
                                    rvv09,rvv17,rvv23,rvv24,rvv25,rvv26,
          #                         13    14    15    16    17
                                    rvv31,rvv031,rvv32,rvv33,rvv34,
          #                         18    19        20    21    22
                                    rvv35,rvv35_fac,rvv36,rvv37,rvv38,
          #                         23    24
                                    rvv39,rvv41,rvv80,rvv81,rvv82,#No.FUN-580033
                                    rvv83,rvv84,rvv85,rvv86,rvv87,rvv88)#No.FUN-580033  #No.TQC-7B0083
          #             1       2           3   4           5
               VALUES  (g_rvu01,l_rvv.rvv02,'3',p_adg.rvb01,p_adg.rvb02,
          #             6           7           8           9 10   11
                        p_adg.adg09,today      ,p_adg.adg12,0,'N' ,'N',
          #             12          13          14      15
                        l_adw.adw05,p_adg.adg05,l_ima02,p_adg.adg06,
          #             16          17          18          19
                        p_adg.adg07,p_adg.adg08,p_adg.adg11,l_fac,
          #             20          21         22 2324      19
                        g_adf.adf01,p_adg.adg02,0,0,'',p_adg.adg30,#No.FUN-580033
                        p_adg.adg31,p_adg.adg32,p_adg.adg33,#No.FUN-580033
                        p_adg.adg34,p_adg.adg35,p_adg.adg11,#No.FUN-580033
                        p_adg.adg12,0)                      #No.FUN-580033  #No.TQC-7B0083
               IF SQLCA.sqlcode THEN
                  CALL cl_err('insert rvv',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               CALL t202_bu(g_adf.adf01,p_adg.adg02,p_adg.adi15,
                            p_adg.adi16,p_adg.rvb01,p_adg.rvb02)
            END IF    #--adf00='3'
         END IF       #--adf00='2'
      END IF          #p_adg
END FUNCTION

FUNCTION t202_z()
DEFINE l_cnt  LIKE type_file.num10   #No.FUN-680108 INTEGER
   IF s_shut(0) THEN RETURN END IF
   IF g_adf.adf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_adf.* FROM adf_file WHERE adf01=g_adf.adf01

   IF g_adf.adfpost = 'N' THEN CALL cl_err('','mfg0178',0) RETURN END IF
   IF g_adf.adfconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF

   IF YEAR(g_adf.adf02)*12+MONTH(g_adf.adf02)<g_sma.sma51*12+g_sma.sma52 THEN
      CALL cl_err(g_adf.adf02,'axd-024',0)
      RETURN
   END IF

   IF NOT cl_confirm('asf-663') THEN RETURN END IF

   BEGIN WORK LET g_success = 'Y'

   OPEN t202_cl USING g_adf_rowid
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t202_cl INTO g_adf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t202_cl ROLLBACK WORK RETURN
   END IF

   LET g_head = 1
   CALL t202_z1()
   IF SQLCA.SQLCODE THEN LET g_success='N' END IF

   IF g_success = 'Y' THEN
      UPDATE adf_file SET adfpost='N',adf09 = NULL WHERE adf01=g_adf.adf01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd adfpost: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK RETURN
      END IF
      LET g_adf.adfpost='N'
      LET g_adf.adf09  =NULL
      DISPLAY BY NAME g_adf.adfpost ATTRIBUTE(REVERSE)
      DISPLAY BY NAME g_adf.adf09 ATTRIBUTE(REVERSE)
      COMMIT WORK
   ELSE
      LET g_adf.adfpost='Y'
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION

FUNCTION t202_z1()
  DEFINE p_adg    RECORD
                  adg02  LIKE adg_file.adg02,   #撥出項次
                  adg03  LIKE adg_file.adg03,   #申請單號
                  adg04  LIKE adg_file.adg04,   #申請單項次

                  ade16  LIKE ade_file.ade16,   #撥入單
                  ade17  LIKE ade_file.ade17,   #撥入單項次
                  adi15  LIKE adi_file.adi15,   #采購單
                  adi16  LIKE adi_file.adi16,   #采購單項次
                  rvb01  LIKE rvb_file.rvb01,   #收貨單
                  rvb02  LIKE rvb_file.rvb01,   #收貨單項次

                  adg05  LIKE adg_file.adg05,   #料件
                  adg06  LIKE adg_file.adg06,   #撥出倉庫
                  adg07  LIKE adg_file.adg07,   #儲位
                  adg08  LIKE adg_file.adg08,   #批號
                  adg09  LIKE adg_file.adg09,   #撥入工廠代號
                  adg10  LIKE adg_file.adg10,   #撥入工廠倉庫
                  adg11  LIKE adg_file.adg11,   #單位
                  #No.FUN-580033  --begin
                  adg12  LIKE adg_file.adg12,   #撥出數量

                  adg33  LIKE adg_file.adg33,   #單位二
                  adg34  LIKE adg_file.adg34,   #單位二轉換率
                  adg35  LIKE adg_file.adg35,   #單位二數量
                  adg30  LIKE adg_file.adg30,   #單位一
                  adg31  LIKE adg_file.adg31,   #單位一轉換率
                  adg32  LIKE adg_file.adg32    #單位一數量
                  #No.FUN-580033  --end
                  END RECORD,
          l_n     LIKE img_file.img10,
          l_buf   LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(60)
          l_adg11 LIKE adg_file.adg11

  #對于adg中的每一筆都要insert到adq_file中
  IF g_adf.adf00 MATCHES '[12]' THEN
     LET g_sql=" SELECT adg02,adg03,adg04,'','','','','','',adg05,adg06,",
               "        adg07,adg08,adg09,adg10,adg11,adg12,", #No.FUN-580033
               "        adg33,adg34,adg35,adg30,adg31,adg32 ", #No.FUN-580033
               "   FROM adg_file",
               "  WHERE adg01='",g_adf.adf01,"'",
               "  ORDER BY adg09,adg02,adg03,adg04"
  ELSE
     LET g_sql=" SELECT adg02,adg03,adg04,ade16,ade17,adi15,adi16,",
               "        rvb01,rvb02,adg05,adg06,adg07,adg08,",
               "        adg09,adg10,adg11,adg12,",             #No.FUN-580033
               "        adg33,adg34,adg35,adg30,adg31,adg32 ", #No.FUN-580033
               "   FROM adg_file,ade_file,add_file,adh_file,adi_file,",
               "        pmn_file,rva_file,rvb_file",
               "  WHERE adg01='",g_adf.adf01,"'",
               "    AND add01=ade01 AND add00='3'",       #申請單
               "    AND adg03=ade01 AND adg04=ade02 ",
               "    AND adh01=adi01 AND adh00='2'",       #撥入單
               "    AND ade16=adi01 AND ade17=adi02 ",
               "    AND adi15=pmn01 AND adi16=pmn02 ",    #采購單
               "    AND rva01=rvb01 AND rva07=adi01 AND rvb32=adi02", #收貨單
               "  ORDER BY adg09,rvb01,adg02,adg03,adg04"
  END IF
  PREPARE t202_pp1 FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('select adg',SQLCA.sqlcode,0)
     LET g_success = 'N'
     RETURN
  END IF
  DECLARE t202_z1_c1 SCROLL CURSOR FOR t202_pp1
  LET l_adg11 = NULL
  FOREACH t202_z1_c1 INTO p_adg.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(p_adg.adg03) THEN CONTINUE FOREACH END IF

      #檢查是不是有撥入狀況,如果是的話,不能過帳還原
      LET l_n = 0
      SELECT img10 INTO l_n FROM img_file
       WHERE img01 = p_adg.adg05 AND img02 = g_adf.adf07
 #        AND img03 = g_adf.adf01 AND img04 = p_adg.adg02   #No.MOD-560296
          AND img03 = p_adg.adg02 AND img04 = g_adf.adf01   #No.MOD-560296
         #AND img10 > 0
      LET l_buf = g_adf.adf01 CLIPPED,' ',p_adg.adg02 CLIPPED
      IF cl_null(l_n) THEN LET l_n = 0 END IF
      IF l_n <> p_adg.adg12 THEN
         CALL cl_err(l_buf,'axd-059',0)
         LET g_success = 'N'
         RETURN
      END IF

      IF cl_null(l_adg11) OR l_adg11 <> p_adg.adg11 THEN
         LET g_head = 1
      ELSE
         LET g_head = 0
      END IF
      CALL t202_update3(p_adg.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION

FUNCTION t202_update3(p_adg)
  DEFINE p_adg RECORD
               adg02  LIKE adg_file.adg02,   #撥出項次
               adg03  LIKE adg_file.adg03,   #申請單號
               adg04  LIKE adg_file.adg04,   #申請單項次

               ade16  LIKE ade_file.ade16,   #撥入單
               ade17  LIKE ade_file.ade17,   #撥入單項次
               adi15  LIKE adi_file.adi15,   #采購單
               adi16  LIKE adi_file.adi16,   #采購單項次
               rvb01  LIKE rvb_file.rvb01,   #收貨單
               rvb02  LIKE rvb_file.rvb01,   #收貨單項次

               adg05  LIKE adg_file.adg05,   #料件
               adg06  LIKE adg_file.adg06,   #撥出倉庫
               adg07  LIKE adg_file.adg07,   #儲位
               adg08  LIKE adg_file.adg08,   #批號
               adg09  LIKE adg_file.adg09,   #撥入工廠代號
               adg10  LIKE adg_file.adg10,   #撥入工廠倉庫
               adg11  LIKE adg_file.adg11,   #單位
               #No.FUN-580033  --begin
               adg12  LIKE adg_file.adg12,   #撥出數量

               adg33  LIKE adg_file.adg33,   #單位二
               adg34  LIKE adg_file.adg34,   #單位二轉換率
               adg35  LIKE adg_file.adg35,   #單位二數量
               adg30  LIKE adg_file.adg30,   #單位一
               adg31  LIKE adg_file.adg31,   #單位一轉換率
               adg32  LIKE adg_file.adg32    #單位一數量
               #No.FUN-580033  --end
               END RECORD,
         l_tot   LIKE adg_file.adg12,
         l_img_rowid LIKE type_file.chr18,    #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         l_img10,t_img10 LIKE img_file.img10,
         l_img21_fac LIKE img_file.img21,
         l_img23 LIKE img_file.img23,
         l_img24 LIKE img_file.img24,
         l_ade13 LIKE ade_file.ade13,
         l_buf  LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(60)

###########check ade_file集團調撥申請單###########################
  #當前撥出申請單可撥出總數量
  SELECT ade05-ade12 INTO l_tot FROM add_file,ade_file
   WHERE ade01 = p_adg.adg03 AND ade02 = p_adg.adg04
     AND add01 = ade01 AND addacti = 'Y'
     AND addconf = 'Y' AND add07 = 'N'
     AND add06 = '1' AND add00 = g_adf.adf00
     AND ade13 = 'N'

  IF cl_null(l_tot) THEN LET l_tot = 0 END IF
  IF cl_null(p_adg.adg12) THEN LET p_adg.adg12 = 0 END IF

  #撥出數量與申請單上可撥數量之和是否大于零，因為撥出數量有可能為負
  IF p_adg.adg12 + l_tot < 0 THEN
     LET l_buf = p_adg.adg03 CLIPPED,' ',p_adg.adg04 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-028',1)
     LET g_success = 'N' RETURN
  ELSE
     #可以撥出，更新申請單上剩余的可撥量
     SELECT ade13 INTO l_ade13 FROM ade_file WHERE ade01=p_adg.adg03
                                               AND ade02=p_adg.adg04
     IF cl_null(l_ade13) OR l_ade13='Y' THEN    #若申請單已結案,則不得有異動
        LET l_buf = p_adg.adg03 CLIPPED,' ',p_adg.adg04 CLIPPED
        CALL cl_err(l_buf CLIPPED,'9004',1)
        LET g_success = 'N' RETURN
     END IF

     UPDATE ade_file SET ade12 = ade12 - p_adg.adg12
      WHERE ade01 = p_adg.adg03 AND ade02 = p_adg.adg04
     IF SQLCA.sqlcode THEN
        CALL cl_err('update ade',SQLCA.sqlcode,0)
        LET g_success = 'N' RETURN
     END IF
  END IF

###############update img 撥出倉#################
  SELECT img09,ROWID INTO g_img09,l_img_rowid FROM img_file #No.FUN-580033
   WHERE img01 = p_adg.adg05 AND img02 = p_adg.adg06
     AND img03 = p_adg.adg07 AND img04 = p_adg.adg08
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err('update img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err('update img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     END IF
     RETURN
 END IF
 #No.FUN-580033 --begin
 LET g_factor=1
 IF g_img09 <> p_adg.adg11 THEN
    CALL s_umfchk(p_adg.adg05,p_adg.adg11,g_img09)
         RETURNING g_cnt,g_factor
    IF g_cnt=1 THEN
       LET g_factor=1
    END IF
 END IF
 LET g_qty=p_adg.adg12*g_factor
 #No.FUN-580033 --end
#更新調出倉庫、儲位、批號的img_file的數量
#                1           2  3           4
      #CALL s_upimg(l_img_rowid,+1,p_adg.adg12,g_today, #No.FUN-580033
      CALL s_upimg(l_img_rowid,+1,g_qty,g_today, #No.FUN-580033
#         5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22
          '','','','','','','','','','','','','','','','','','')
      IF g_success = 'N' THEN
         CALL cl_err('update img',SQLCA.sqlcode,0)
         RETURN
      END IF

##############update img 在途倉###########################

  SELECT ROWID INTO l_img_rowid FROM img_file
   WHERE img01 = p_adg.adg05 AND img02 = g_adf.adf07
 #    AND img03 = g_adf.adf01 AND img04 = p_adg.adg02  #No.MOD-560296
      AND img03 = p_adg.adg02 AND img04 = g_adf.adf01  #No.MOD-560296
  IF SQLCA.sqlcode THEN
     #---->已被別的使用者鎖住
     IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
         LET g_errno = 'mfg3465'
         CALL cl_err('update img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     ELSE
         LET g_errno = 'mfg3466'
         CALL cl_err('update img',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
     END IF
     RETURN
 END IF
#更新調出倉庫、儲位、批號的img_file的數量
#                1           2  3           4
      DELETE FROM img_file WHERE ROWID = l_img_rowid
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete img',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF

##############update ima 撥出倉###########################
#---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
      SELECT img10,img21,img23,img24
        INTO l_img10,l_img21_fac,l_img23,l_img24
       FROM  img_file
      WHERE img01= p_adg.adg05 AND img02= p_adg.adg06
        AND img03= p_adg.adg07 AND img04= p_adg.adg08
      IF s_udima(p_adg.adg05,              #料件編號
                 l_img23,                  #是否可用倉儲
                 l_img24,                  #是否為MRP可用倉儲
                 p_adg.adg12*l_img21_fac,  #調撥數量(換算為庫存單位)
                 g_today,                  #最近一次調撥日期
                 +1)                       #表調撥入
      THEN
         CALL cl_err('update ima',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF

##############update tlf_file#############################
      DELETE FROM tlf_file WHERE (tlf026 = g_adf.adf01 OR tlf036 = g_adf.adf01)
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_adf.adf01,SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF

      #No.FUN-580033  --begin
      IF g_sma.sma115='Y' THEN
         SELECT ima906 INTO g_ima906 FROM ima_file
          WHERE ima01=p_adg.adg05
         LET t_adg.*=p_adg.*
         CALL t202_update_du(p_adg.adg06,p_adg.adg07,p_adg.adg08,+1,-1,NULL)
         IF g_success='N' THEN RETURN END IF
         CALL t202_update_du(g_adf.adf07,p_adg.adg02,g_adf.adf01,-1,-1,NULL)
         IF g_success='N' THEN RETURN END IF
         IF g_ima906 MATCHES '[23]' THEN
            DELETE FROM imgg_file
             WHERE imgg01=p_adg.adg05 AND imgg02=g_adf.adf07
               AND imgg03=p_adg.adg02 AND imgg04=g_adf.adf01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err('delete imgg',SQLCA.sqlcode,1)
               LET g_success='N' RETURN
            END IF
            DELETE FROM tlff_file
             WHERE (tlff026 = g_adf.adf01 OR tlff036 = g_adf.adf01)
               AND (tlff027 = t_adg.adg02 OR tlff037 = t_adg.adg02)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err(g_adf.adf01,SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
      #No.FUN-580033  --end

################外部調撥################
      IF p_adg.adg09 <> g_azp01 THEN
         IF g_adf.adf00 = '2' THEN
            IF g_head = 1 THEN
               SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adg.adg09
               IF SQLCA.sqlcode THEN
                  CALL cl_err(p_adg.adg09,SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET g_sql = " DELETE FROM ",p_dbs CLIPPED,".pmm_file ",
                           " WHERE pmm01 = (SELECT pmn01 FROM ",p_dbs CLIPPED,".pmn_file ",
                           "                 WHERE pmn24 = '",g_adf.adf01,"'",
                           "                   AND pmn25 =  ",p_adg.adg02,")"
               PREPARE t202_pre7 FROM g_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('delete pmm',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               EXECUTE t202_pre7
               IF SQLCA.sqlcode THEN
                  CALL cl_err('delete pmm',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET g_sql = " DELETE FROM ",p_dbs CLIPPED,".pmn_file",
                           "  WHERE pmn24 = '",g_adf.adf01,"'"
               PREPARE t202_pre8 FROM g_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('delete pmn',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               EXECUTE t202_pre8
               IF SQLCA.sqlcode THEN
                  CALL cl_err('delete pmn',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF   #--head=1
         ELSE
            IF g_adf.adf00 = '3' THEN
               UPDATE adi_file SET adi17 = adi17 - p_adg.adg12
                WHERE adi01=p_adg.ade16 AND adi02 = p_adg.ade17
               IF SQLCA.sqlcode THEN
                  CALL cl_err('update adi17',SQLCA.sqlcode,0)
                  LET g_success = 'N' RETURN
               END IF
               DELETE FROM rvu_file WHERE rvu01 = (SELECT UNIQUE rvv01
                      FROM rvv_file WHERE rvv36=g_adf.adf01
                                      AND rvv37=p_adg.adg02)
               IF SQLCA.sqlcode THEN
                  CALL cl_err('delete rvu',SQLCA.sqlcode,0)
                  LET g_success = 'N' RETURN
               END IF
               DELETE FROM rvv_file
                WHERE rvv36=g_adf.adf01 AND rvv37=p_adg.adg02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('delete rvv',SQLCA.sqlcode,0)
                  LET g_success ='N'
                  RETURN
               END IF
               CALL t202_bu(g_adf.adf01,p_adg.adg02,p_adg.adi15,
                            p_adg.adi16,p_adg.rvb01,p_adg.rvb02)
            END IF
         END IF         #adf00='2'
      END IF      #p_adg.adg09
END FUNCTION

FUNCTION t202_prt()
   IF cl_confirm('mfg3242') THEN CALL t202_out('a') END IF
END FUNCTION

FUNCTION t202_out(p_cmd)
   DEFINE l_cmd         LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(200)
          p_cmd         LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
          l_prog        LIKE zz_file.zz01,     #No.FUN-680108 VARCHAR(10)
          l_wc,l_wc2    LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(50)
          l_prtway      LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
          l_lang        LIKE type_file.chr1    # Prog. Version..: '5.10.00-08.01.04(0.中文/1.英文/2.簡體)   #No.FUN-680108 VARCHAR(1)

   IF cl_null(g_adf.adf01) THEN CALL cl_err('','-400',0) RETURN END IF
   OPTIONS FORM LINE FIRST + 1

 #NO.MOD-4B0082  --begin
#   LET p_row = 3 LET p_col = 3
#   OPEN WINDOW w1 AT p_row,p_col WITH 2 ROWS, 75 COLUMNS
#        ATTRIBUTE(BORDER,CYAN)
          MENU ""
               ON ACTION List_Of_Conglomerate_Trans_Out_Notes
                  LET l_prog='axdr203'
                  EXIT MENU
               ON ACTION Detail_List_Of_Conglomerate_Trans_Out_Notes
                  LET l_prog='axdr207'
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
      IF l_prog = 'axdr203' OR p_cmd = 'a' THEN
         LET l_wc='adf01="',g_adf.adf01,'"'
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
              " '",g_lang CLIPPED,"' 'Y' ' ' '1'",    #TQC-610088
              " '",l_wc CLIPPED,"' ",l_wc2
      CALL cl_cmdrun(l_cmd)
   END IF
#   CLOSE WINDOW w1
#   OPTIONS FORM LINE FIRST + 2
 #NO.MOD-4B0082  --end
END FUNCTION

 #MOD-560158
#FUNCTION t202_sg()
#   IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
#      CALL cl_err('aza23','mfg3551',0)
#      RETURN
#   END IF
#
#   IF g_adf.adf01 IS NULL OR g_adf.adf01 = ' ' THEN   #尚未查詢資料
#      CALL cl_err('', -400, 0)
#      RETURN
#   END IF
#
#   IF g_adf.adf10 NOT MATCHES "[S1WR]" THEN
#      RETURN
#   END IF
#
#   CALL aws_efstat(g_adf.adf01)
#END FUNCTION
 #END MOD-560158

FUNCTION t202_tlf(p_img10,p_adg,p_type,s_img10)
  DEFINE p_adg   RECORD
                 adg02  LIKE adg_file.adg02,   #撥出項次
                 adg03  LIKE adg_file.adg03,   #申請單號
                 adg04  LIKE adg_file.adg04,   #申請單項次

                 ade16  LIKE ade_file.ade16,   #撥入單
                 ade17  LIKE ade_file.ade17,   #撥入單項次
                 adi15  LIKE adi_file.adi15,   #采購單
                 adi16  LIKE adi_file.adi16,   #采購單項次
                 rvb01  LIKE rvb_file.rvb01,   #收貨單
                 rvb02  LIKE rvb_file.rvb01,   #收貨單項次

                 adg05  LIKE adg_file.adg05,   #料件
                 adg06  LIKE adg_file.adg06,   #撥出倉庫
                 adg07  LIKE adg_file.adg07,   #儲位
                 adg08  LIKE adg_file.adg08,   #批號
                 adg09  LIKE adg_file.adg09,   #撥入工廠代號
                 adg10  LIKE adg_file.adg10,   #撥入工廠倉庫
                 adg11  LIKE adg_file.adg11,   #單位
                 #No.FUN-580033  --begin
                 adg12  LIKE adg_file.adg12,   #撥出數量

                 adg33  LIKE adg_file.adg33,   #單位二
                 adg34  LIKE adg_file.adg34,   #單位二轉換率
                 adg35  LIKE adg_file.adg35,   #單位二數量
                 adg30  LIKE adg_file.adg30,   #單位一
                 adg31  LIKE adg_file.adg31,   #單位一轉換率
                 adg32  LIKE adg_file.adg32    #單位一數量
                 #No.FUN-580033  --end
                 END RECORD,
         p_img10 LIKE img_file.img10,
         s_img10 LIKE img_file.img10,
         p_type  LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)

      INITIALIZE g_tlf.* TO NULL

      IF p_type = '1' THEN
         LET g_tlf.tlf02  = '50'        #來源
         LET g_tlf.tlf01  = p_adg.adg05
         LET g_tlf.tlf020 = g_plant
         LET g_tlf.tlf021 = p_adg.adg06
         LET g_tlf.tlf022 = p_adg.adg07
         LET g_tlf.tlf023 = p_adg.adg08
         LET g_tlf.tlf024 = s_img10 - p_adg.adg12
         LET g_tlf.tlf025 = p_adg.adg11
         LET g_tlf.tlf026 = g_adf.adf01
         LET g_tlf.tlf027 = p_adg.adg02

         LET g_tlf.tlf03  = '99'
         LET g_tlf.tlf030 = ' '
         LET g_tlf.tlf031 = ' '
         LET g_tlf.tlf032 = ' '
         LET g_tlf.tlf033 = ' '
         LET g_tlf.tlf034 = 0
         LET g_tlf.tlf035 = ' '
         LET g_tlf.tlf036 = g_adf.adf01
         LET g_tlf.tlf037 = 0
      ELSE
         LET g_tlf.tlf02  = '99'       #目的
         LET g_tlf.tlf01  = p_adg.adg05
         LET g_tlf.tlf020 = ' '
         LET g_tlf.tlf021 = ' '
         LET g_tlf.tlf022 = ' '
         LET g_tlf.tlf023 = ' '
         LET g_tlf.tlf024 = 0
         LET g_tlf.tlf025 = ' '
         LET g_tlf.tlf026 = g_adf.adf01
         LET g_tlf.tlf027 = 0

         LET g_tlf.tlf03  = '50'
         LET g_tlf.tlf030 = g_plant
         LET g_tlf.tlf031 = g_adf.adf07
          LET g_tlf.tlf033 = g_adf.adf01   #No.MOD-560296
          LET g_tlf.tlf032 = p_adg.adg02   #No.MOD-560296
         LET g_tlf.tlf034 = p_img10 + p_adg.adg12
         LET g_tlf.tlf035 = p_adg.adg11
         LET g_tlf.tlf036 = g_adf.adf01
         LET g_tlf.tlf037 = p_adg.adg02
      END IF

      LET g_tlf.tlf04  = ' '
      LET g_tlf.tlf05  = ' '
      LET g_tlf.tlf06  = g_adf.adf02
      LET g_tlf.tlf07  = g_today
      LET g_tlf.tlf08  = TIME
      LET g_tlf.tlf09  = g_user
      LET g_tlf.tlf10  = p_adg.adg12
      LET g_tlf.tlf11  = p_adg.adg11
      LET g_tlf.tlf12  = 1
      LET g_tlf.tlf13  = 'axdt202'
      LET g_tlf.tlf14  = ' '
      LET g_tlf.tlf15  = ' '
      LET g_tlf.tlf16  = ' '
      LET g_tlf.tlf17  = ' '
      LET g_tlf.tlf18  = s_imaQOH(p_adg.adg05)
      LET g_tlf.tlf19  = ' '
      LET g_tlf.tlf20  = ' '
      LET g_tlf.tlf61  = ' '

      CALL s_tlf(0,0)
      IF g_success='N' THEN RETURN END IF
END FUNCTION

#*********倉退update ************************************************
#更新相關的檔案
FUNCTION t202_bu(p_adf01,p_adg02,p_pmn01,p_pmn02,p_rvb01,p_rvb02)
   DEFINE
      p_adf01         LIKE adf_file.adf01,
      p_adg02         LIKE adg_file.adg02,
      p_rvb01         LIKE rvb_file.rvb01,
      p_rvb02         LIKE rvb_file.rvb02,
      l_rvb01         LIKE rvb_file.rvb01,
      l_rvb02         LIKE rvb_file.rvb02,
      p_pmn01         LIKE pmn_file.pmn01,
      p_pmn02         LIKE pmn_file.pmn02,
      l_rvb29         LIKE rvb_file.rvb29,
      l_rvb291        LIKE rvb_file.rvb29,
      l_rvb30         LIKE rvb_file.rvb30,
      l_rvv17         LIKE rvv_file.rvv17,
      g_rvv17         LIKE rvv_file.rvv17,
      l_qty           LIKE rvb_file.rvb07 #No.FUN-680108 DEC(12,3)

#--------如果有驗收單, 則更新rvb,採購單
      SELECT SUM(rvv17) INTO l_rvb30 FROM rvv_file,rvu_file     #計算已入庫量
       WHERE rvv04=p_rvb01 AND rvv05=p_rvb02
             AND rvuconf ='Y' AND rvu00='1' AND rvv01=rvu01
      SELECT SUM(rvv17) INTO l_rvb29 FROM rvv_file,rvu_file     #計算驗退
       WHERE rvv04=p_rvb01 AND rvv05=p_rvb02
             AND rvuconf ='Y' AND rvu00='2' AND rvv01=rvu01
      SELECT SUM(rvv17) INTO l_rvb291 FROM rvv_file,rvu_file    #計算倉退
       WHERE rvv04=p_rvb01 AND rvv05=p_rvb02
             AND rvuconf ='Y' AND rvu00='3' AND rvv01=rvu01
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
      IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF
      IF cl_null(l_rvb291) THEN LET l_rvb291=0 END IF
      SELECT rvb07 INTO l_qty FROM rvb_file
       WHERE rvb01=p_rvb01 AND rvb02=p_rvb02
      IF l_qty<(l_rvb30+l_rvb29) THEN #BugNo:5547
         CALL cl_err('rvb07<rvb29+30:','asf-660',1)
         LET g_success = 'N' RETURN
      END IF
      UPDATE rvb_file SET rvb29 = l_rvb29,         #驗退量
                          rvb30 = l_rvb30,         #入庫量
                          rvb09 = l_rvb30-l_rvb291,#允請量
                          rvb31 = rvb07-l_rvb29-l_rvb30
       WHERE rvb01 = p_rvb01 AND rvb02 = p_rvb02
      IF SQLCA.sqlcode THEN
         CALL cl_err('退 upd rvb29,rvb09,rvb31:',SQLCA.sqlcode,1)
         LET g_success = 'N' RETURN
      END IF
#---------更新採購單退貨量

      LET g_rvv17=0
      DECLARE rvb01_rvb02 CURSOR FOR
      SELECT rvb01,rvb02 FROM rvb_file
       WHERE rvb04=p_pmn01 AND rvb03=p_pmn02
      FOREACH rvb01_rvb02 INTO l_rvb01,l_rvb02
          IF SQLCA.sqlcode THEN
             LET g_success='N' RETURN
          END IF
          SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file,rvu_file     #計算倉退
           WHERE rvv04=l_rvb01 AND rvv05=l_rvb02
             AND rvuconf ='Y' AND rvu00='3' AND rvv01=rvu01 AND rvv25='N'
          IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF
          LET g_rvv17=g_rvv17+l_rvv17
      END FOREACH

      SELECT SUM(rvb29) INTO l_rvb29 FROM rvb_file,rva_file  #計算驗退
       WHERE rvb04=p_pmn01 AND rvb03=p_pmn02
         AND rvaconf='Y' AND rvb01=rva01 AND rvb35='N'
      IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF

      UPDATE pmn_file SET pmn55 = l_rvb29,
                          pmn58 = g_rvv17
      WHERE pmn01 = p_pmn01 AND pmn02 = p_pmn02
      IF SQLCA.sqlcode THEN
         CALL cl_err('upd pmn55:',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
#-----更新超短交量 = 收貨量 - 訂購量
      CALL s_udpmn57(p_pmn01,p_pmn02)
END FUNCTION

FUNCTION t202_m()
DEFINE
        p_cmd           LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5,   #No.FUN-680108 SMALLINT
        l_desc          LIKE ze_file.ze03      #No.FUN-680108 VARCHAR(20)

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    OPEN WINDOW t202_ww AT 8,10     #顯示畫面 統一編號欄位加長
         WITH FORM "axd/42f/axdt202_m" ATTRIBUTE(BORDER,CYAN)
          CALL cl_ui_locale("axdt202_m")   #NO.MOD-4B0082
    CALL cl_opmsg('u')

    CALL t202_adg18(g_adg18) RETURNING l_desc
    DISPLAY g_adg18  TO FORMONLY.adg18
    DISPLAY l_desc TO FORMONLY.desc
    DISPLAY g_adg19  TO FORMONLY.adg19
    DISPLAY g_adg20  TO FORMONLY.adg20
    CALL cl_anykey('')
    CLOSE WINDOW t202_ww
END FUNCTION

FUNCTION t202_adg18(p_ade18)
DEFINE p_ade18  LIKE ade_file.ade18
DEFINE l_desc   LIKE ze_file.ze03      #No.FUN-680108 VARCHAR(20)

    CASE p_ade18
         WHEN '1'  CALL cl_getmsg('axm-024',g_lang) RETURNING l_desc
         WHEN '2'  CALL cl_getmsg('axm-025',g_lang) RETURNING l_desc
         WHEN '3'  CALL cl_getmsg('axm-026',g_lang) RETURNING l_desc
    END CASE
    RETURN l_desc
END FUNCTION

FUNCTION t202_set_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("adf00,adf01",TRUE)
   END IF

END FUNCTION

FUNCTION t202_set_no_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("adf00,adf01",FALSE)
       END IF
   END IF

END FUNCTION

#No.FUN-580033  --begin
FUNCTION t202_mu_ui()
    CALL cl_set_comp_visible("adg31,adg34",FALSE)
    CALL cl_set_comp_visible("adg30,adg33,adg32,adg35",g_sma.sma115='Y')
    CALL cl_set_comp_visible("adg11,adg12",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adg33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adg35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adg30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adg32",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adg33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adg35",g_msg CLIPPED)
       CALL cl_getmsg('asm-014',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adg30",g_msg CLIPPED)
       CALL cl_getmsg('asm-016',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("adg32",g_msg CLIPPED)
    END IF

END FUNCTION

FUNCTION t202_set_origin_field()
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
    LET l_fac2=g_adg[l_ac].adg34
    LET l_qty2=g_adg[l_ac].adg35
    LET l_fac1=g_adg[l_ac].adg31
    LET l_qty1=g_adg[l_ac].adg32

    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_adg[l_ac].adg11=g_adg[l_ac].adg30
                   LET g_adg[l_ac].adg12=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_adg[l_ac].adg11=g_ima25
                   LET g_adg[l_ac].adg12=l_tot
          WHEN '3' LET g_adg[l_ac].adg11=g_adg[l_ac].adg30
                   LET g_adg[l_ac].adg12=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_adg[l_ac].adg34 =l_qty1/l_qty2
                   ELSE
                      LET g_adg[l_ac].adg34 =0
                   END IF
       END CASE
    #No.MOD-590121  --begin
    #ELSE  #不使用雙單位
    #   LET g_adg[l_ac].adg11=g_adg[l_ac].adg30
    #   LET g_adg[l_ac].adg12=l_qty1
    #No.MOD-590121  --end
    END IF

END FUNCTION

FUNCTION t202_set_required()

  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("adg33,adg35,adg30,adg32",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_adg[l_ac].adg30) THEN
     CALL cl_set_comp_required("adg32",TRUE)
  END IF
  IF NOT cl_null(g_adg[l_ac].adg33) THEN
     CALL cl_set_comp_required("adg35",TRUE)
  END IF

END FUNCTION

FUNCTION t202_set_no_required()

  CALL cl_set_comp_required("adg33,adg35,adg30,adg32",FALSE)

END FUNCTION

#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t202_du_data_to_correct()

   IF cl_null(g_adg[l_ac].adg33) THEN
      LET g_adg[l_ac].adg34 = NULL
      LET g_adg[l_ac].adg35 = NULL
   END IF

   IF cl_null(g_adg[l_ac].adg30) THEN
      LET g_adg[l_ac].adg31 = NULL
      LET g_adg[l_ac].adg32 = NULL
   END IF
   DISPLAY BY NAME g_adg[l_ac].adg31
   DISPLAY BY NAME g_adg[l_ac].adg32
   DISPLAY BY NAME g_adg[l_ac].adg34
   DISPLAY BY NAME g_adg[l_ac].adg35

END FUNCTION
#檢查單位是否存在於單位檔中
FUNCTION t202_unit(p_key)
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

FUNCTION t202_update_du(p_ware,p_loc,p_lot,p_type,p_type1,p_rowid)
DEFINE p_ware    LIKE img_file.img02
DEFINE p_loc     LIKE img_file.img03
DEFINE p_lot     LIKE img_file.img04
DEFINE p_type    LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE p_type1   LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE p_rowid   LIKE type_file.chr18   #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
DEFINE l_ima25   LIKE ima_file.ima25
DEFINE l_img09   LIKE img_file.img09
DEFINE l_fac1    LIKE img_file.img21
DEFINE l_fac2    LIKE img_file.img21

   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    WHERE ima01 = t_adg.adg05
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF

   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01=t_adg.adg05 AND img02=p_ware
      AND img03=p_loc       AND img04=p_lot
   IF NOT cl_null(t_adg.adg33) THEN
      LET g_factor=1
      CALL s_umfchk(t_adg.adg05,t_adg.adg33,l_img09)
           RETURNING g_cnt,g_factor
      LET l_fac2=g_factor
   END IF
   IF NOT cl_null(t_adg.adg30) THEN
      LET g_factor=1
      CALL s_umfchk(t_adg.adg05,t_adg.adg30,l_img09)
           RETURNING g_cnt,g_factor
      LET l_fac1=g_factor
   END IF
 
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=t_adg.adg05
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(t_adg.adg35) AND t_adg.adg35<>0 THEN
         CALL t202_upd_imgg('1',t_adg.adg05,p_ware,p_loc,p_lot,
                   t_adg.adg33,l_fac2,t_adg.adg35,'2',p_type,p_rowid)
         IF g_success='N' THEN RETURN END IF
         IF p_type1=1 THEN
            CALL t202_tlff(p_ware,p_loc,p_lot,l_ima25,
                           t_adg.adg35,0,t_adg.adg33,l_fac2,'2',p_type)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(t_adg.adg32) AND t_adg.adg32<>0 THEN
         CALL t202_upd_imgg('1',t_adg.adg05,p_ware,p_loc,p_lot,
                   t_adg.adg30,l_fac1,t_adg.adg32,'1',p_type,p_rowid)
         IF g_success='N' THEN RETURN END IF
         IF p_type1=1 THEN
            CALL t202_tlff(p_ware,p_loc,p_lot,l_ima25,
                           t_adg.adg32,0,t_adg.adg30,l_fac1,'1',p_type)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(t_adg.adg35) AND t_adg.adg35<>0 THEN
         CALL t202_upd_imgg('2',t_adg.adg05,p_ware,p_loc,p_lot,
                   t_adg.adg33,l_fac2,t_adg.adg35,'2',p_type,p_rowid)
         IF g_success = 'N' THEN RETURN END IF
         IF p_type1=1 THEN
            CALL t202_tlff(p_ware,p_loc,p_lot,l_ima25,
                           t_adg.adg35,0,t_adg.adg33,l_fac2,'2',p_type)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      #No.CHI-770019  --Begin
      #IF NOT cl_null(t_adg.adg32) AND t_adg.adg32<>0 THEN
      #   IF p_type1=1 THEN
      #      CALL t202_tlff(p_ware,p_loc,p_lot,l_ima25,
      #                     t_adg.adg32,0,t_adg.adg30,l_fac1,'1',p_type)
      #      IF g_success='N' THEN RETURN END IF
      #   END IF
      #END IF
      #No.CHI-770019  --End  
   END IF

END FUNCTION

FUNCTION t202_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_no,p_type,p_rowid)
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
         p_rowid    LIKE type_file.chr18,  #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
         p_no       LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
         p_type     LIKE type_file.num5    #No.FUN-680108 SMALLINT

    IF cl_null(p_rowid) THEN
       LET g_forupd_sql =
           "SELECT rowid FROM imgg_file ",
           " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
           "   AND imgg09= ? FOR UPDATE NOWAIT "
 
       DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
       OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
       IF STATUS THEN
          CALL cl_err("OPEN imgg_lock:", STATUS, 1)
          LET g_success='N'
          CLOSE imgg_lock
          ROLLBACK WORK
          RETURN
       END IF
       FETCH imgg_lock INTO l_rowid
       IF STATUS THEN
          CALL cl_err('lock imgg fail',STATUS,1)
          LET g_success='N'
          CLOSE imgg_lock
          ROLLBACK WORK
          RETURN
       END IF
    END IF

    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err('ima25 null',SQLCA.sqlcode,0)
       LET g_success = 'N' RETURN
    END IF

    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF

    IF cl_null(p_rowid) THEN
       CALL s_upimgg(l_rowid,p_type,p_imgg10,g_adf.adf02,
             '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    ELSE
       IF p_rowid='-3333' THEN
          CALL s_upimgg(p_rowid,p_type,p_imgg10,g_adf.adf02,
                p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','',p_imgg09,p_imgg10,
                p_imgg09,1,l_imgg21,'','','','','','','',p_imgg211)
       END IF
    END IF
    IF g_success='N' THEN RETURN END IF

END FUNCTION

FUNCTION t202_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   p_flag,p_type)
DEFINE
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位
   p_lot      LIKE img_file.img04,     	 ##批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_img10    LIKE img_file.img10,       ##異動後數量
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   l_imgg10   LIKE imgg_file.imgg10,
   p_flag     LIKE type_file.chr1,       #No.FUN-680108 VARCHAR(01)
   p_type     LIKE type_file.num5,       #No.FUN-680108 SMALLINT
   l_imo05    LIKE imo_file.imo05,
   g_cnt      LIKE type_file.num5        #No.FUN-680108 SMALLINT

    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF

    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=t_adg.adg05 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
    INITIALIZE g_tlff.* TO NULL
#----來源----
    IF p_type = -1 THEN
       LET g_tlff.tlff02  = '50'        #來源
       LET g_tlff.tlff01  = t_adg.adg05
       LET g_tlff.tlff020 = g_plant
       LET g_tlff.tlff021 = p_ware
       LET g_tlff.tlff022 = p_loca
       LET g_tlff.tlff023 = p_lot
       LET g_tlff.tlff024 = l_imgg10
       LET g_tlff.tlff025 = t_adg.adg11
       LET g_tlff.tlff026 = g_adf.adf01
       LET g_tlff.tlff027 = t_adg.adg02

       LET g_tlff.tlff03  = '99'
       LET g_tlff.tlff030 = ' '
       LET g_tlff.tlff031 = ' '
       LET g_tlff.tlff032 = ' '
       LET g_tlff.tlff033 = ' '
       LET g_tlff.tlff034 = 0
       LET g_tlff.tlff035 = ' '
       LET g_tlff.tlff036 = g_adf.adf01
       LET g_tlff.tlff037 = 0
    ELSE
       LET g_tlff.tlff02  = '99'       #目的
       LET g_tlff.tlff01  = t_adg.adg05
       LET g_tlff.tlff020 = ' '
       LET g_tlff.tlff021 = ' '
       LET g_tlff.tlff022 = ' '
       LET g_tlff.tlff023 = ' '
       LET g_tlff.tlff024 = 0
       LET g_tlff.tlff025 = ' '
       LET g_tlff.tlff026 = g_adf.adf01
       LET g_tlff.tlff027 = 0

       LET g_tlff.tlff03  = '50'
       LET g_tlff.tlff030 = g_plant
       LET g_tlff.tlff031 = p_ware
       LET g_tlff.tlff032 = p_loca
       LET g_tlff.tlff033 = p_lot
       LET g_tlff.tlff034 = l_imgg10
       LET g_tlff.tlff035 = t_adg.adg11
       LET g_tlff.tlff036 = g_adf.adf01
       LET g_tlff.tlff037 = t_adg.adg02
    END IF

    LET g_tlff.tlff04  = ' '
    LET g_tlff.tlff05  = ' '
    LET g_tlff.tlff06  = g_adf.adf02
    LET g_tlff.tlff07  = g_today
    LET g_tlff.tlff08  = TIME
    LET g_tlff.tlff09  = g_user
    LET g_tlff.tlff10  = p_qty
    LET g_tlff.tlff11  = p_uom
    LET g_tlff.tlff12  = p_factor
    LET g_tlff.tlff13  = 'axdt202'
    LET g_tlff.tlff14  = ' '
    LET g_tlff.tlff15  = ' '
    LET g_tlff.tlff16  = ' '
    LET g_tlff.tlff17  = ' '
    LET g_tlff.tlff18  = s_imaQOH(t_adg.adg05)
    LET g_tlff.tlff19  = ' '
    LET g_tlff.tlff20  = ' '
    LET g_tlff.tlff61  = ' '

    IF cl_null(t_adg.adg35) OR t_adg.adg35=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,t_adg.adg33)
    END IF
END FUNCTION

FUNCTION t202_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   CALL cl_set_comp_entry("adg35",TRUE)
END FUNCTION

FUNCTION t202_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("adg35",FALSE)
   END IF

END FUNCTION
#No.FUN-580033  --end

#Patch....NO:MOD-5A0095 <001,002,003,004,005,006> #
#Patch....NO:TQC-610037 <001> #
