# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saemt200.4gl
# Descriptions...: 設備保修工單庫存發料/退料作業
# Date & Author..: 04/07/19 By Carrier
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.FUN-550024 05/05/16 By Trisy 單據編號格式放大
# Modify.........: No.MOD-530629 05/06/08 By Carrier 更改單據查詢
# Modify.........: NO.FUN-560014 05/06/08 By jackie 單據編號修改
# Modify.........: No.MOD-560238 05/07/27 By vivien 自動編號修改
# Modify.........: No.FUN-580018 05/08/03 By elva 新增雙單位內容
# Modify.........: No.MOD-590123 05/09/09 By Carrier set_origin_field修改
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-5C0031 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-610006 06/01/17 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-610090 06/02/06 By Nicola 拆併箱功能修改
# Modify.........: NO.TQC-620156 06/03/13 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: No.FUN-660092 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680072 06/08/24 By zdyllq 類型轉換 
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-6A0015 06/12/18 By rainy 輸入料號後帶出預設倉庫/儲位
# Modify.........: No.FUN-6C0083 06/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750018 07/05/04 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750219 07/05/29 By jamie '確認'及'取消確認' action 按下後的窗 , 其中 yes/no/cancel 選項icon 應中文化
# Modify.........: No.TQC-750218 07/05/29 By jamie 單身 '備件' default 'N'
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810045 08/01/24 By rainy 項目管理 單身加專案編號(fiw41)/WBS(fiw42)/活動編號(fiw43)/理由碼(fiw44)
# Modify.........: No.FUN-840068 08/04/25 By TSD.Wind 自定欄位功能修改 
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID 
# Modify.........: No.TQC-930028 09/03/06 By mike 畫面無smydesc欄位，故MARK之
# Modify.........: No.FUN-920186 09/03/20 By lala 理由碼fiw44必須為庫存雜項
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun Lock img_file/imgg_file 失敗，不能直接Rollback
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.FUN-950056 09/07/27 By chenmoyan 去掉ima920
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No:MOD-A10078 10/01/20 By Smapmin 工單保修項目的備料必須存在設備基本資料的備料中
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/19 By vealxu ima26x 調整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  过账还原时的呆滞日期异动
# Modify.........: No.FUN-A40023 10/04/12 By vealxu ima26x 調整補充 
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AA0062 10/11/01 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-AB0058 10/11/15 By yinhy 審核段增加倉庫權限使用控管
# Modify.........: No.TQC-AB0358 10/11/30 By vealxu 未輸入單身資料，則自動刪除單頭資料
# Modify.........: No.TQC-AC0033 10/12/03 By yinhy 倉庫開窗修改
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80026 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-B90236 11/10/26 By zhuhao   資料處理
# Modify.........: No:FUN-BB0086 12/01/13 By tanxc 增加數量欄位小數取位 
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70087 12/08/03 By bart 整批寫入img_file
# Modify.........: No:FUN-C80107 12/09/07 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.MOD-CA0096 12/10/29 By Elise 還原AFTER FIELD fiw05/fiw06中TQC-AC0033的修改
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No.TQC-D20042 13/02/25 By fengrui 修正倉庫單據理由碼改善测试问题
# Modify.........: No:FUN-BC0062 13/02/28 By xujing 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查 
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
#模組變數(Module Variables)
DEFINE
    g_fiv           RECORD LIKE fiv_file.*,
    g_fiv_t         RECORD LIKE fiv_file.*,
    g_fiv01_t       LIKE fiv_file.fiv01,
    g_fiv_o         RECORD LIKE fiv_file.*,
    g_yy,g_mm       LIKE type_file.num5,                 #No.FUN-680072SMALLINT
    g_fiw           DYNAMIC ARRAY OF RECORD              #程式變數(Prinram Variables)
                    fiw02     LIKE fiw_file.fiw02,
                    fiw03     LIKE fiw_file.fiw03,
                    ima02     LIKE ima_file.ima02,
                    fiw04     LIKE fiw_file.fiw04,
                    fiw05     LIKE fiw_file.fiw05,
                    fiw06     LIKE fiw_file.fiw06,
                    fiw07     LIKE fiw_file.fiw07,
                    fiw07_fac LIKE fiw_file.fiw07_fac,
                    fiw08     LIKE fiw_file.fiw08,
                    fiw23     LIKE fiw_file.fiw23,
                    fiw24     LIKE fiw_file.fiw24,
                    fiw25     LIKE fiw_file.fiw25,
                    fiw20     LIKE fiw_file.fiw20,
                    fiw21     LIKE fiw_file.fiw21,
                    fiw22     LIKE fiw_file.fiw22,
                    fiw09     LIKE fiw_file.fiw09,
                    fiw41     LIKE fiw_file.fiw41,
                    fiw42     LIKE fiw_file.fiw42,
                    fiw43     LIKE fiw_file.fiw43,
                    fiw44     LIKE fiw_file.fiw44,
                    azf03     LIKE azf_file.azf03,  #FUN-CB0087 add
                    fiwud01   LIKE fiw_file.fiwud01,
                    fiwud02   LIKE fiw_file.fiwud02,
                    fiwud03   LIKE fiw_file.fiwud03,
                    fiwud04   LIKE fiw_file.fiwud04,
                    fiwud05   LIKE fiw_file.fiwud05,
                    fiwud06   LIKE fiw_file.fiwud06,
                    fiwud07   LIKE fiw_file.fiwud07,
                    fiwud08   LIKE fiw_file.fiwud08,
                    fiwud09   LIKE fiw_file.fiwud09,
                    fiwud10   LIKE fiw_file.fiwud10,
                    fiwud11   LIKE fiw_file.fiwud11,
                    fiwud12   LIKE fiw_file.fiwud12,
                    fiwud13   LIKE fiw_file.fiwud13,
                    fiwud14   LIKE fiw_file.fiwud14,
                    fiwud15   LIKE fiw_file.fiwud15
                    END RECORD,
    g_fiw_t         RECORD
                    fiw02     LIKE fiw_file.fiw02,
                    fiw03     LIKE fiw_file.fiw03,
                    ima02     LIKE ima_file.ima02,
                    fiw04     LIKE fiw_file.fiw04,
                    fiw05     LIKE fiw_file.fiw05,
                    fiw06     LIKE fiw_file.fiw06,
                    fiw07     LIKE fiw_file.fiw07,
                    fiw07_fac LIKE fiw_file.fiw07_fac,
                    fiw08     LIKE fiw_file.fiw08,
                    fiw23     LIKE fiw_file.fiw23,
                    fiw24     LIKE fiw_file.fiw24,
                    fiw25     LIKE fiw_file.fiw25,
                    fiw20     LIKE fiw_file.fiw20,
                    fiw21     LIKE fiw_file.fiw21,
                    fiw22     LIKE fiw_file.fiw22,
                    fiw09     LIKE fiw_file.fiw09,
                    fiw41     LIKE fiw_file.fiw41,
                    fiw42     LIKE fiw_file.fiw42,
                    fiw43     LIKE fiw_file.fiw43,
                    fiw44     LIKE fiw_file.fiw44,
                    azf03     LIKE azf_file.azf03,  #FUN-CB0087 add
                    fiwud01   LIKE fiw_file.fiwud01,
                    fiwud02   LIKE fiw_file.fiwud02,
                    fiwud03   LIKE fiw_file.fiwud03,
                    fiwud04   LIKE fiw_file.fiwud04,
                    fiwud05   LIKE fiw_file.fiwud05,
                    fiwud06   LIKE fiw_file.fiwud06,
                    fiwud07   LIKE fiw_file.fiwud07,
                    fiwud08   LIKE fiw_file.fiwud08,
                    fiwud09   LIKE fiw_file.fiwud09,
                    fiwud10   LIKE fiw_file.fiwud10,
                    fiwud11   LIKE fiw_file.fiwud11,
                    fiwud12   LIKE fiw_file.fiwud12,
                    fiwud13   LIKE fiw_file.fiwud13,
                    fiwud14   LIKE fiw_file.fiwud14,
                    fiwud15   LIKE fiw_file.fiwud15
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
    b_fiw               RECORD LIKE fiw_file.*,
    g_ima86             LIKE ima_file.ima86,
    g_t1                LIKE type_file.chr5,                #No.FUN-550024        #No.FUN-680072CHAR(5)
    g_img09             LIKE img_file.img09,
    g_ima25             LIKE ima_file.ima25,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_fiw20             LIKE fiw_file.fiw20,
    g_fiw21             LIKE fiw_file.fiw21,
    g_fiw22             LIKE fiw_file.fiw22,
    g_fiw23             LIKE fiw_file.fiw23,
    g_fiw24             LIKE fiw_file.fiw24,
    g_fiw25             LIKE fiw_file.fiw25,
    g_factor            LIKE fiw_file.fiw07_fac,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10,
    g_flag              LIKE type_file.chr1,         #No.FUN-680072 VARCHAR(1)
    g_buf               LIKE type_file.chr20,        #No.FUN-680072CHAR(20)
    g_rec_b             LIKE type_file.num5,         #單身筆數        #No.FUN-680072 SMALLINT
    l_ac                LIKE type_file.num5          #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
DEFINE g_argv1          LIKE aba_file.aba18          #No.FUN-680072CHAR(2)
DEFINE g_forupd_sql     STRING        #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5      #No.FUN-680072 SMALLINT
DEFINE g_chr           LIKE type_file.chr2            #No.FUN-680072 VARCHAR(2)
DEFINE g_cnt           LIKE type_file.num10          #No.FUN-680072 INTEGER
DEFINE g_i             LIKE type_file.num5           #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE g_msg           LIKE ze_file.ze03         #No.FUN-680072CHAR(72)
DEFINE g_row_count     LIKE type_file.num10          #No.FUN-680072 INTEGER
DEFINE g_curs_index    LIKE type_file.num10          #No.FUN-680072 INTEGER
DEFINE g_jump          LIKE type_file.num10          #No.FUN-680072 INTEGER
DEFINE g_no_ask        LIKE type_file.num5           #No.FUN-680072 SMALLINT
DEFINE g_imm01         LIKE imm_file.imm01           #No.FUN-610090
DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD       #No.FUN-610090
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
DEFINE g_fiw07_t       LIKE fiw_file.fiw07           #No.FUN-BB0086
DEFINE g_fiw20_t       LIKE fiw_file.fiw20           #No.FUN-BB0086
DEFINE g_fiw23_t       LIKE fiw_file.fiw23           #No.FUN-BB0086 
#DEFINE l_img_table      STRING             #FUN-C70087  #FUN-CC0095
#DEFINE l_imgg_table     STRING             #FUN-C70087  #FUN-CC0095
DEFINE l_flag01    LIKE type_file.chr1   #FUN-C80107 add

FUNCTION t200(p_argv1)
 
   DEFINE p_argv1       LIKE type_file.chr1     # 11/12/13         #No.FUN-680072CHAR(1)
   WHENEVER ERROR CALL cl_err_msg_log     #FUN-920186
   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
   CALL t200_def_form()
 
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM fiv_file WHERE fiv01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1=p_argv1
    DISPLAY g_argv1 TO fiv00
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    CALL t200_menu()
    #CALL s_padd_img_drop(l_img_table)   #FUN-C70087 #FUN-CC0095
    #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087 #FUN-CC0095
END FUNCTION
 
FUNCTION t200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 DEFINE
    l_type          LIKE type_file.chr1,          #No.FUN-680072CHAR(1)
    l_ima08         LIKE ima_file.ima08,
    l_ima75         LIKE ima_file.ima75
 
    CLEAR FORM                             #清除畫面
    CALL g_fiw.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fiv.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        fiv01,fiv02,fiv03,fiv04,fiv05,fiv06,fiv07,
        fivconf,fivpost,fivuser,fivgrup,fivmodu,fivdate,
        fivud01,fivud02,fivud03,fivud04,fivud05,
        fivud06,fivud07,fivud08,fivud09,fivud10,
        fivud11,fivud12,fivud13,fivud14,fivud15
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            CASE WHEN INFIELD(fiv01) #查詢單据
                      LET g_t1=s_get_doc_no(g_fiv.fiv01)     #No.FUN-550024
                      LET g_fiv.fiv00  =g_argv1
                      CASE WHEN g_fiv.fiv00 = '1'  LET g_chr='3'
                           WHEN g_fiv.fiv00 = '2'  LET g_chr='4'
 	              END CASE
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_fiv"
                      LET g_qryparam.arg1 = g_fiv.fiv00
                      LET g_qryparam.default1 = g_fiv.fiv01
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fiv01
                      NEXT FIELD fiv01
                 WHEN INFIELD(fiv02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_fil"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_fiv.fiv02
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fiv02
                      NEXT FIELD fiv02
                 WHEN INFIELD(fiv06)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_fiv.fiv06
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fiv06
                      NEXT FIELD fiv06
                 WHEN INFIELD(fiv07)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_pja2"  #FUN-810045
                      LET g_qryparam.default1 =  g_fiv.fiv07
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fiv07
                      NEXT FIELD fiv07
            END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
     END CONSTRUCT
 
     IF INT_FLAG THEN RETURN END IF
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fivuser', 'fivgrup')
 
     IF NOT cl_null(g_argv1) THEN
        LET g_wc = g_wc clipped," AND fiv00 = '",g_argv1,"'"
     END IF
     CONSTRUCT g_wc2 ON fiw02,fiw03,fiw04,fiw05,fiw06,fiw07,
                        fiw07_fac,fiw08,fiw23,fiw24,fiw25,fiw20,fiw21,fiw22,fiw09,
                        fiw41,fiw42,fiw43,fiw44     #FUN-810045 add
                        ,fiwud01,fiwud02,fiwud03,fiwud04,fiwud05
                        ,fiwud06,fiwud07,fiwud08,fiwud09,fiwud10
                        ,fiwud11,fiwud12,fiwud13,fiwud14,fiwud15
             FROM s_fiw[1].fiw02,     s_fiw[1].fiw03, s_fiw[1].fiw04,
                  s_fiw[1].fiw05,     s_fiw[1].fiw06, s_fiw[1].fiw07,
                  s_fiw[1].fiw07_fac, s_fiw[1].fiw08, s_fiw[1].fiw23,
                  s_fiw[1].fiw24,     s_fiw[1].fiw25, s_fiw[1].fiw20,
                  s_fiw[1].fiw21,     s_fiw[1].fiw22, s_fiw[1].fiw09,
                  s_fiw[1].fiw41,     s_fiw[1].fiw42, s_fiw[1].fiw43,s_fiw[1].fiw44   #FUN-810045
                  ,s_fiw[1].fiwud01,s_fiw[1].fiwud02,s_fiw[1].fiwud03
                  ,s_fiw[1].fiwud04,s_fiw[1].fiwud05,s_fiw[1].fiwud06
                  ,s_fiw[1].fiwud07,s_fiw[1].fiwud08,s_fiw[1].fiwud09
                  ,s_fiw[1].fiwud10,s_fiw[1].fiwud11,s_fiw[1].fiwud12
                  ,s_fiw[1].fiwud13,s_fiw[1].fiwud14,s_fiw[1].fiwud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION CONTROLP
          CASE WHEN INFIELD(fiw03)
#FUN-AA0059 --Begin--
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.form ="q_ima"
               #     LET g_qryparam.default1 = g_fiw[1].fiw03
               #     LET g_qryparam.state = "c"
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","",g_fiw[1].fiw03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO s_fiw[1].fiw03
                    NEXT FIELD fiw03
#No.TQC-AC0033 --Begin--
               WHEN INFIELD(fiw04)
                    CALL q_imd_1(TRUE,TRUE,g_fiw[1].fiw04,"","","","")  RETURNING  g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_fiw[1].fiw04
                    NEXT FIELD fiw04
               WHEN INFIELD(fiw05)
                    CALL q_ime_1(TRUE,TRUE,g_fiw[1].fiw05,g_fiw[1].fiw04,"","","","","")  RETURNING  g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_fiw[1].fiw05
                    NEXT FIELD fiw05
#No.TQC-AC0033 --End--
               WHEN INFIELD(fiw07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_fiw[1].fiw07
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fiw07
                    NEXT FIELD fiw07
               WHEN INFIELD(fiw20)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_fiw[1].fiw20
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fiw20
                    NEXT FIELD fiw20
               WHEN INFIELD(fiw23)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_fiw[1].fiw23
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fiw23
                    NEXT FIELD fiw23
               WHEN INFIELD(fiw44)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azf01a"
                    LET g_qryparam.default1 = g_fiw[1].fiw44
                    LET g_qryparam.arg1 = '4'
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fiw44
                    NEXT FIELD fiw44
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
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
 
     END CONSTRUCT
     IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
     IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql = "SELECT fiv01 FROM fiv_file",
                    " WHERE ", g_wc CLIPPED,
                   " ORDER BY fiv01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fiv01 ",
                   "  FROM fiv_file, fiw_file",
                   " WHERE fiv01 = fiw01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY fiv01"
    END IF
 
    PREPARE t200_prepare FROM g_sql
    DECLARE t200_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t200_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fiv_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fiv01) FROM fiv_file,fiw_file WHERE ",
                  "fiw01=fiv01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t200_precount FROM g_sql
    DECLARE t200_count CURSOR FOR t200_precount
 
END FUNCTION
 
FUNCTION t200_menu()
 
   WHILE TRUE
      CALL t200_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t200_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t200_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t200_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t200_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t200_b()
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
               CALL t200_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_z()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t200_s()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t200_t()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t200_x()
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_fiv.fiv01 IS NOT NULL THEN
                 LET g_doc.column1 = "fiv01"
                 LET g_doc.value1 = g_fiv.fiv01
                 CALL cl_doc()
               END IF
         END IF
                           
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t200_a()
    DEFINE   li_result   LIKE type_file.num5          #No.FUN-550024        #No.FUN-680072 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fiw.clear()
    INITIALIZE g_fiv.* TO NULL
    LET g_fiv_o.* = g_fiv.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fiv.fiv00  =g_argv1
        LET g_fiv.fiv04  =g_today
        LET g_fiv.fiv05  =g_today
        LET g_fiv.fivpost='N'
        LET g_fiv.fivconf='N'
        LET g_fiv.fivuser=g_user
        LET g_fiv.fivoriu = g_user #FUN-980030
        LET g_fiv.fivorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_fiv.fivgrup=g_grup
        LET g_fiv.fivdate=g_today
        CALL t200_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_fiv.* TO NULL
           LET INT_FLAG=0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fiv.fiv01 IS NULL THEN CONTINUE WHILE END IF
 
        BEGIN WORK
 
      CALL s_auto_assign_no("aem",g_fiv.fiv01,g_fiv.fiv04,g_chr,"fiv_file","fiv01","","","")                 #No.FUN-560014
      RETURNING li_result,g_fiv.fiv01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_fiv.fiv01
        LET g_fiv.fivplant = g_plant #FUN-980002
        LET g_fiv.fivlegal = g_legal #FUN-980002
        INSERT INTO fiv_file VALUES (g_fiv.*)
        IF SQLCA.sqlcode THEN                     #置入資料庫不成功
           CALL cl_err3("ins","fiv_file",g_fiv.fiv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092 #No.FUN-B80026---調整至回滾事務前---
           ROLLBACK WORK
           CONTINUE WHILE
        ELSE
           COMMIT WORK #No:7857
        END IF
        SELECT fiv01 INTO g_fiv.fiv01 FROM fiv_file WHERE fiv01 = g_fiv.fiv01
        LET g_fiv_t.* = g_fiv.*
 
        CALL g_fiw.clear()
        LET g_rec_b = 0
        IF g_fiv.fiv00 = '1' THEN
           IF cl_confirm('aem-020')  THEN CALL t200_g_b_1() END IF
        ELSE
           IF cl_confirm('aem-021')  THEN CALL t200_g_b_2() END IF
        END IF
 
        CALL t200_b()                   #輸入單身
 
        SELECT COUNT(*) INTO g_cnt FROM fiw_file WHERE fiw01=g_fiv.fiv01
        IF g_cnt>0 THEN
            IF g_fjh.fjhconf='Y' THEN CALL t200_s() END IF   #No.MOD-530629
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t200_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fiv.fiv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01=g_fiv.fiv01
    IF g_fiv.fivpost = 'X' THEN CALL cl_err('',9027,0) RETURN END IF
    IF g_fiv.fivconf = 'Y' THEN CALL cl_err('',9022,0) RETURN END IF
    IF g_fiv.fivpost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fiv_o.* = g_fiv.*
 
    BEGIN WORK
 
    OPEN t200_cl USING g_fiv.fiv01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_fiv.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF
    CALL t200_show()
    WHILE TRUE
        LET g_fiv.fivmodu=g_user
        LET g_fiv.fivdate=g_today
        CALL t200_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fiv.*=g_fiv_t.*
            CALL t200_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fiv.fiv01 != g_fiv01_t THEN            # 更改單號
           UPDATE fiw_five SET fiw01 = g_fiv.fiv01 WHERE fiw01 = g_fiv01_t
        END IF
        UPDATE fiv_file SET * = g_fiv.* WHERE fiv01 = g_fiv.fiv01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","fiv_file",g_fiv01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t200_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680072 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1           #判斷必要欄位是否有輸入        #No.FUN-680072 VARCHAR(1)
  DEFINE l_n             LIKE type_file.num5           #No.FUN-680072 SMALLINT
  DEFINE li_result       LIKE type_file.num5           #No.FUN-550024        #No.FUN-680072 SMALLINT
    DISPLAY BY NAME g_fiv.fiv00
    CALL cl_set_head_visible("","YES")                #No.FUN-6B0029
  
    INPUT BY NAME g_fiv.fivoriu,g_fiv.fivorig,
             g_fiv.fiv01,g_fiv.fiv02,g_fiv.fiv03,g_fiv.fiv04,
             g_fiv.fiv05,g_fiv.fiv06,g_fiv.fiv07,g_fiv.fivconf,
             g_fiv.fivpost,g_fiv.fivuser,g_fiv.fivgrup,
             g_fiv.fivmodu,g_fiv.fivdate,
             g_fiv.fivud01,g_fiv.fivud02,g_fiv.fivud03,g_fiv.fivud04,
             g_fiv.fivud05,g_fiv.fivud06,g_fiv.fivud07,g_fiv.fivud08,
             g_fiv.fivud09,g_fiv.fivud10,g_fiv.fivud11,g_fiv.fivud12,
             g_fiv.fivud13,g_fiv.fivud14,g_fiv.fivud15 
             WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t200_set_entry(p_cmd)
            CALL t200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fiv01")
         CALL cl_set_docno_format("fiv02")
 
        AFTER FIELD fiv01
         IF NOT cl_null(g_fiv.fiv01) THEN
 
               CASE WHEN g_fiv.fiv00 MATCHES "[1]" LET g_chr='3'
                    WHEN g_fiv.fiv00 MATCHES "[2]" LET g_chr='4'
               END CASE
 
            CALL s_check_no("aem",g_fiv.fiv01,g_fiv_t.fiv01,g_chr,"fiv_file","fiv01","")
            RETURNING li_result,g_fiv.fiv01
            DISPLAY BY NAME g_fiv.fiv01
            IF (NOT li_result) THEN
               NEXT FIELD fiv01
            END IF
         END IF
 
        AFTER FIELD fiv02
            IF NOT cl_null(g_fiv.fiv02) THEN
               CALL t200_fiv02(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fiv.fiv02,g_errno,0)
                  LET g_fiv.fiv02 = g_fiv_o.fiv02
                  DISPLAY BY NAME g_fiv.fiv02
                  NEXT FIELD fiv02
               END IF
               #FUN-CB0087--add--str-- 
               IF NOT t200_fiw44_chkall() THEN 
                  LET g_fiv.fiv02 = g_fiv_o.fiv02
                  DISPLAY BY NAME g_fiv.fiv02
                  NEXT FIELD fiv02
               END IF 
               #FUN-CB0087--add--end--
            END IF
 
        AFTER FIELD fiv04
            IF NOT cl_null(g_fiv.fiv04) THEN
              IF g_sma.sma53 IS NOT NULL AND g_fiv.fiv04 <= g_sma.sma53 THEN
	               CALL cl_err('','mfg9999',0) NEXT FIELD fiv04
	             END IF
               CALL s_yp(g_fiv.fiv04) RETURNING g_yy,g_mm
               IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
                  CALL cl_err('','mfg6091',0) NEXT FIELD fiv04
               END IF
            END IF
 
        AFTER FIELD fiv05
            IF NOT cl_null(g_fiv.fiv05) THEN
	       IF g_sma.sma53 IS NOT NULL AND g_fiv.fiv05 <= g_sma.sma53 THEN
	           CALL cl_err('','mfg9999',0) NEXT FIELD fiv05
	       END IF
               CALL s_yp(g_fiv.fiv05) RETURNING g_yy,g_mm
               IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
                  CALL cl_err('','mfg6091',0) NEXT FIELD fiv05
               END IF
            END IF
 
        AFTER FIELD fiv06
            IF NOT cl_null(g_fiv.fiv06) THEN
               CALL t200_fiv06(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fiv.fiv06,g_errno,0)
                  LET g_fiv.fiv06 = g_fiv_o.fiv06
                  DISPLAY BY NAME g_fiv.fiv06
                  NEXT FIELD fiv06
               END IF
               #FUN-CB0087--add--str-- 
               IF NOT t200_fiw44_chkall() THEN 
                  LET g_fiv.fiv06 = g_fiv_o.fiv06
                  DISPLAY BY NAME g_fiv.fiv06
                  NEXT FIELD fiv06
               END IF 
               #FUN-CB0087--add--end--
            END IF
 
        AFTER FIELD fiv07
            IF NOT cl_null(g_fiv.fiv07) THEN
               CALL t200_fiv07(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fiv.fiv07,g_errno,0)
                  LET g_fiv.fiv07 = g_fiv_o.fiv07
                  DISPLAY BY NAME g_fiv.fiv07
                  NEXT FIELD fiv07
               END IF
            END IF
 
        AFTER FIELD fivud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fivud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
         ON ACTION CONTROLP
            CASE WHEN INFIELD(fiv01) #查詢單据
                      LET g_t1=s_get_doc_no(g_fiv.fiv01)     #No.FUN-550024
                      CASE WHEN g_fiv.fiv00 MATCHES "[1]" LET g_chr='3'
                           WHEN g_fiv.fiv00 MATCHES "[2]" LET g_chr='4'
                      END CASE
                      CALL q_smy(FALSE,FALSE,g_t1,'AEM',g_chr) RETURNING g_t1  #TQC-670008
                      LET g_fiv.fiv01 = g_t1                 #No.FUN-550024
                      DISPLAY BY NAME g_fiv.fiv01
                      NEXT FIELD fiv01
                 WHEN INFIELD(fiv02)  #工單編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_fil"
                      LET g_qryparam.default1 = g_fiv.fiv02
                      CALL cl_create_qry() RETURNING g_fiv.fiv02
                      DISPLAY BY NAME g_fiv.fiv02
                      NEXT FIELD fiv02
                 WHEN INFIELD(fiv06)  #部門
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.default1 = g_fiv.fiv06
                      CALL cl_create_qry() RETURNING g_fiv.fiv06
                      DISPLAY BY NAME g_fiv.fiv06
                      NEXT FIELD fiv06
                 WHEN INFIELD(fiv07) #專案代號
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_pja2"  #FUN-810045
                      LET g_qryparam.default1 =  g_fiv.fiv07
                      CALL cl_create_qry() RETURNING g_fiv.fiv07
                      DISPLAY BY NAME g_fiv.fiv07
                      NEXT FIELD fiv07
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
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
 
FUNCTION t200_fiv02(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_filacti LIKE fil_file.filacti
   DEFINE l_filconf LIKE fil_file.filconf
   DEFINE l_fil05   LIKE fil_file.fil05
 
   SELECT filacti,filconf,fil05 INTO l_filacti,l_filconf,l_fil05
     FROM fil_file WHERE fil01 = g_fiv.fiv02
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aem-028' #FUN-580018
        WHEN l_filacti = 'N'      LET g_errno = '9028'
        WHEN l_filconf = 'N'      LET g_errno = '9029'
        WHEN l_fil05 NOT MATCHES '[12]'       LET g_errno= 'aem-025'
        WHEN SQLCA.SQLCODE != 0   LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
 
FUNCTION t200_fiv06(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file WHERE gem01 = g_fiv.fiv06
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
FUNCTION t200_fiv07(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_pjaacti LIKE pja_file.pjaacti  #FUN-810045
   DEFINE l_pjaclose LIKE pja_file.pjaclose #FUN-960038
 
   SELECT pjaacti,pjaclose INTO l_pjaacti,l_pjaclose   #No.FUN-960038 add pjaclose
     FROM pja_file WHERE pja01 = g_fiv.fiv07
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_pjaacti = 'N'     LET g_errno = '9028'  #FUN-810045
        WHEN l_pjaclose = 'Y'    LET g_errno = 'abg-503' #FUN-960038
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
 
FUNCTION t200_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fiv.* TO NULL               #No.FUN-6B0050
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t200_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_fiv.* TO NULL 
       RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fiv.* TO NULL
    ELSE
        OPEN t200_count
        FETCH t200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t200_cs INTO g_fiv.fiv01
        WHEN 'P' FETCH PREVIOUS t200_cs INTO g_fiv.fiv01
        WHEN 'F' FETCH FIRST    t200_cs INTO g_fiv.fiv01
        WHEN 'L' FETCH LAST     t200_cs INTO g_fiv.fiv01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t200_cs INTO g_fiv.fiv01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)
        INITIALIZE g_fiv.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01 = g_fiv.fiv01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fiv_file",g_fiv.fiv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
        INITIALIZE g_fiv.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fiv.fivuser   #FUN-4C0069
    LET g_data_group = g_fiv.fivgrup   #FUN-4C0069
    LET g_data_plant = g_fiv.fivplant #FUN-980030
    CALL t200_show()
END FUNCTION
 
FUNCTION t200_show()
    LET g_fiv_t.* = g_fiv.*                #保存單頭舊值
    DISPLAY BY NAME g_fiv.fivoriu,g_fiv.fivorig,
            g_fiv.fiv00,g_fiv.fiv01,g_fiv.fiv02,g_fiv.fiv03,
            g_fiv.fiv04,g_fiv.fiv05,g_fiv.fiv06,g_fiv.fiv07,
            g_fiv.fivconf,g_fiv.fivpost,g_fiv.fivuser,
            g_fiv.fivgrup,g_fiv.fivmodu,g_fiv.fivdate,
            g_fiv.fivud01,g_fiv.fivud02,g_fiv.fivud03,g_fiv.fivud04,
            g_fiv.fivud05,g_fiv.fivud06,g_fiv.fivud07,g_fiv.fivud08,
            g_fiv.fivud09,g_fiv.fivud10,g_fiv.fivud11,g_fiv.fivud12,
            g_fiv.fivud13,g_fiv.fivud14,g_fiv.fivud15 
 
    CALL t200_fiv06('d')
    CALL t200_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t200_r()
     DEFINE l_chr,l_sure LIKE type_file.chr1     #No.FUN-680072 VARCHAR(1)
     DEFINE l_i          LIKE type_file.num5     #FUN-810045
     DEFINE l_act        LIKE type_file.chr1     #FUN-810045
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fiv.fiv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01=g_fiv.fiv01
    IF g_fiv.fivpost = 'X' THEN CALL cl_err('',9027,0) RETURN END IF
    IF g_fiv.fivconf = 'Y' THEN CALL cl_err('',9022,0) RETURN END IF
    IF g_fiv.fivpost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t200_cl USING g_fiv.fiv01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_fiv.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t200_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fiv01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fiv.fiv01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fiv,fiw!"
        DELETE FROM fiv_file WHERE fiv01 = g_fiv.fiv01
        IF STATUS THEN
           CALL cl_err3("del","fiv_file",g_fiv.fiv01,"",STATUS,"","del fiv:",1)  #No.FUN-660092
           ROLLBACK WORK
           RETURN
        END IF
        DELETE FROM fiw_file WHERE fiw01 = g_fiv.fiv01
        IF STATUS THEN
           CALL cl_err3("del","fiw_file",g_fiv.fiv01,"",STATUS,"","del fiw:",1)  #No.FUN-660092
           ROLLBACK WORK
           RETURN
        END IF
        IF g_fiv.fiv00 = '1' THEN LET l_act = "1" ELSE LET l_act = '2' END IF
        FOR l_i = 1 TO g_rec_b 
          IF s_chk_rvbs(g_fiw[l_i].fiw41,g_fiw[l_i].fiw04) THEN
           #IF NOT s_del_rvbs(l_act,g_fiv.fiv01,g_fiw[l_i].fiw02,0)  THEN                   #FUN-880129      #TQC-B90236 mark
            IF NOT s_lot_del(g_prog,g_fiv.fiv01,'',0,g_fiw[l_i].fiw03,'DEL')  THEN            #TQC-B90236 add
               ROLLBACK WORK
               RETURN
            END IF
          END IF
        END FOR
 
        CLEAR FORM
        CALL g_fiw.clear()
    	INITIALIZE g_fiv.* TO NULL
        MESSAGE ""
        OPEN t200_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t200_cs
             CLOSE t200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        FETCH t200_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t200_cs
             CLOSE t200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t200_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t200_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL t200_fetch('/')
        END IF
    END IF
    CLOSE t200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680072 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680072 VARCHAR(1)
    l_type          LIKE type_file.chr1,                #No.FUN-680072CHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680072 SMALLINT
    l_ima25         LIKE ima_file.ima25,
    l_img09         LIKE img_file.img09,
    l_img10         LIKE img_file.img10,
    #l_azf09         LIKE azf_file.azf09,                #FUN-920186   #FUN-CB0087 mark
    l_i             LIKE type_file.num5                 #No.FUN-680072 SMALLINT
DEFINE  l_pjb25     LIKE pjb_file.pjb25,
        l_act       LIKE type_file.chr1
DEFINE  l_pjb09     LIKE pjb_file.pjb09   #No.FUN-850027 
DEFINE  l_pjb11     LIKE pjb_file.pjb11   #No.FUN-850027
DEFINE  l_tf        LIKE type_file.chr1   #No.FUN-BB0086
DEFINE  l_case      STRING   #No.FUN-BB0086
DEFINE  l_flag      LIKE type_file.chr1   #No.FUN-CB0087
DEFINE  l_where     STRING                #No.FUN-CB0087 
  
    LET g_action_choice = ""
    IF g_fiv.fiv01 IS NULL THEN RETURN END IF
 
    SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01=g_fiv.fiv01
    IF g_fiv.fivpost = 'X' THEN CALL cl_err('',9027,0) RETURN END IF
    IF g_fiv.fivconf = 'Y' THEN CALL cl_err('',9022,0) RETURN END IF
    IF g_fiv.fivpost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql = "SELECT fiw02,fiw03,'',fiw04,fiw05,fiw06,",
                       "       fiw07,fiw07_fac,fiw08,fiw23,fiw24,fiw25,",
                       "       fiw20,fiw21,fiw22,fiw09, ",
                       "       fiw41,fiw42,fiw43,fiw44,azf03, ",   #FUN-810045 add   #FUN-CB0087 add azf03
                       "       fiwud01,fiwud02,fiwud03,fiwud04,fiwud05,",
                       "       fiwud06,fiwud07,fiwud08,fiwud09,fiwud10,",
                       "       fiwud11,fiwud12,fiwud13,fiwud14,fiwud15 ", 
                       "  FROM fiw_file ",
                       "  LEFT OUTER JOIN azf_file ON fiw44=azf01 AND azf02 = '2' ", #FUN-CB0087 add
                       " WHERE fiw01= ? AND fiw02= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    IF g_rec_b=0 THEN CALL g_fiw.clear() END IF
 
    INPUT ARRAY g_fiw WITHOUT DEFAULTS FROM s_fiw.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           #No.FUN-BB0086--add--begin--
           LET g_fiw07_t = NULL 
           LET g_fiw20_t = NULL 
           LET g_fiw23_t = NULL 
           #No.FUN-BB0086--add--end--
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
 
            BEGIN WORK
 
            OPEN t200_cl USING g_fiv.fiv01
            IF STATUS THEN
               CALL cl_err("OPEN t200_cl:", STATUS, 1)
               CLOSE t200_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t200_cl INTO g_fiv.*          # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                  CLOSE t200_cl ROLLBACK WORK RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_fiw_t.* = g_fiw[l_ac].*  #BACKUP
               #No.FUN-BB0086--add--begin--
               LET g_fiw07_t = g_fiw[l_ac].fiw07 
               LET g_fiw20_t = g_fiw[l_ac].fiw20 
               LET g_fiw23_t = g_fiw[l_ac].fiw23
               #No.FUN-BB0086--add--end--
               OPEN t200_bcl USING g_fiv.fiv01,g_fiw_t.fiw02
               IF STATUS THEN
                  CALL cl_err("OPEN t200_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t200_bcl INTO g_fiw[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fiw_t.fiw02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL t200_fiw03('d')
                  CALL t200_set_entry_b(p_cmd)
                  IF g_sma.sma115 = 'Y' THEN
                     IF NOT cl_null(g_fiw[l_ac].fiw03) THEN
                        SELECT ima25 INTO g_ima25
                          FROM ima_file WHERE ima01=g_fiw[l_ac].fiw03
 
                        CALL s_chk_va_setting(g_fiw[l_ac].fiw03)
                             RETURNING g_flag,g_ima906,g_ima907
                     END IF
                  END IF
 
                  CALL t200_set_no_entry_b(p_cmd)
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fiw[l_ac].* TO NULL      #900423
            INITIALIZE g_fiw_t.* TO NULL
            LET g_fiw[l_ac].fiw07_fac=1
            LET g_fiw[l_ac].fiw08=0
            LET g_fiw[l_ac].fiw09='N'    #TQC-750218 add
            LET g_fiw[l_ac].fiw41 = g_fiv.fiv07   #FUN-810045 add
            LET g_fiw[l_ac].fiw21=1
            LET g_fiw[l_ac].fiw24=1
            CALL t200_set_entry_b(p_cmd)
            CALL t200_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_fiw[l_ac].fiw03) THEN
                 SELECT ima25 INTO g_ima25
                   FROM ima_file WHERE ima01=g_fiw[l_ac].fiw03
              END IF
 
              CALL s_chk_va_setting(g_fiw[l_ac].fiw03)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD fiw03
              END IF
 
              CALL t200_du_data_to_correct()
 
              CALL t200_set_origin_field()
              #計算fiw08的值,檢查數量的合理性
              CALL t200_check_inventory_qty(l_img10)
                  RETURNING g_flag
              IF g_flag = '1' THEN
                 IF g_ima906 = '3' OR g_ima906 = '2' THEN
                    NEXT FIELD fiw25
                 ELSE
                    NEXT FIELD fiw22
                 END IF
              END IF
            END IF
 
           IF s_chk_rvbs(g_fiw[l_ac].fiw41,g_fiw[l_ac].fiw04) THEN
             LET g_success = 'Y'
             CALL t200_rvbs()
             IF g_success = 'N' THEN
                CANCEL INSERT
             END IF
           END IF
 
            INSERT INTO fiw_file(fiw01,fiw02,fiw03,fiw04,fiw05,
                                 fiw06,fiw07,fiw07_fac,fiw08,fiw09,
                                 fiw20,fiw21,fiw22,fiw23,fiw24,fiw25,
                                 fiw41,fiw42,fiw43,fiw44,  #FUN-810045
                                 fiwud01,fiwud02,fiwud03,fiwud04,fiwud05,
                                 fiwud06,fiwud07,fiwud08,fiwud09,fiwud10,
                                 fiwud11,fiwud12,fiwud13,fiwud14,fiwud15,
                                 fiwplant,fiwlegal) #FUN-980002
            VALUES(g_fiv.fiv01,      g_fiw[l_ac].fiw02,    g_fiw[l_ac].fiw03,
                   g_fiw[l_ac].fiw04,g_fiw[l_ac].fiw05,    g_fiw[l_ac].fiw06,
                   g_fiw[l_ac].fiw07,g_fiw[l_ac].fiw07_fac,g_fiw[l_ac].fiw08,
                   g_fiw[l_ac].fiw09,g_fiw[l_ac].fiw20,    g_fiw[l_ac].fiw21,
                   g_fiw[l_ac].fiw22,g_fiw[l_ac].fiw23,    g_fiw[l_ac].fiw24,
                   g_fiw[l_ac].fiw25,
                   g_fiw[l_ac].fiw41,g_fiw[l_ac].fiw42,g_fiw[l_ac].fiw43,g_fiw[l_ac].fiw44,  #FUN-810045
                   g_fiw[l_ac].fiwud01,g_fiw[l_ac].fiwud02,g_fiw[l_ac].fiwud03,
                   g_fiw[l_ac].fiwud04,g_fiw[l_ac].fiwud05,g_fiw[l_ac].fiwud06,
                   g_fiw[l_ac].fiwud07,g_fiw[l_ac].fiwud08,g_fiw[l_ac].fiwud09,
                   g_fiw[l_ac].fiwud10,g_fiw[l_ac].fiwud11,g_fiw[l_ac].fiwud12,
                   g_fiw[l_ac].fiwud13,g_fiw[l_ac].fiwud14,g_fiw[l_ac].fiwud15,
                   g_plant,g_legal) #FUN-980002
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","fiw_file",g_fiv.fiv01,g_fiw[l_ac].fiw02,SQLCA.sqlcode,"","ins fiw",1)  #No.FUN-660092
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD fiw02                            #default 序號
            IF g_fiw[l_ac].fiw02 IS NULL OR g_fiw[l_ac].fiw02 = 0 THEN
               SELECT max(fiw02)+1 INTO g_fiw[l_ac].fiw02
                 FROM fiw_file WHERE fiw01 = g_fiv.fiv01
               IF g_fiw[l_ac].fiw02 IS NULL THEN
                  LET g_fiw[l_ac].fiw02 = 1
               END IF
            END IF
 
        AFTER FIELD fiw02                        #check 序號是否重複
            IF NOT cl_null(g_fiw[l_ac].fiw02) THEN
               IF g_fiw[l_ac].fiw02 != g_fiw_t.fiw02 OR
                  g_fiw_t.fiw02 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM fiw_file
                   WHERE fiw01 = g_fiv.fiv01
                     AND fiw02 = g_fiw[l_ac].fiw02
                  IF l_n > 0 THEN
                     LET g_fiw[l_ac].fiw02 = g_fiw_t.fiw02
                     CALL cl_err('',-239,0)
                     NEXT FIELD fiw02
                  END IF
               END IF
            END IF
 
        BEFORE FIELD fiw03
            CALL t200_set_entry_b(p_cmd)
            CALL t200_set_no_required()  #FUN-580018
 
        AFTER FIELD fiw03
            IF NOT cl_null(g_fiw[l_ac].fiw03) THEN
              #FUN-AA0059 --------------add start-----------------
               IF NOT s_chk_item_no(g_fiw[l_ac].fiw03,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_fiw[l_ac].fiw03 = g_fiw_t.fiw03
                  DISPLAY BY NAME g_fiw[l_ac].fiw03
                  NEXT FIELD fiw03
               END IF 
              #FUN-AA0059 -----------add end---------------------
               CALL t200_fiw03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fiw[l_ac].fiw03,g_errno,0)
                  LET g_fiw[l_ac].fiw03 = g_fiw_t.fiw03
                  DISPLAY BY NAME g_fiw[l_ac].fiw03
                  NEXT FIELD fiw03
               END IF
               SELECT ima25 INTO l_ima25 FROM ima_file
                WHERE ima01=g_fiw[l_ac].fiw03 AND imaacti='Y'
               IF cl_null(g_fiw[l_ac].fiw07) THEN
                  LET g_fiw[l_ac].fiw07=l_ima25
                  LET g_fiw[l_ac].fiw08=s_digqty(g_fiw[l_ac].fiw08,g_fiw[l_ac].fiw07)   #No.FUN-BB0086
                  DISPLAY BY NAME g_fiw[l_ac].fiw07
               END IF
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_fiw[l_ac].fiw03)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD fiw03
                  END IF
                  IF g_ima906 = '3' THEN
                     LET g_fiw[l_ac].fiw23=g_ima907
                  END IF
                  SELECT ima25 INTO g_ima25
                    FROM ima_file WHERE ima01=g_fiw[l_ac].fiw03
                  IF cl_null(g_fiw[l_ac].fiw20) AND
                     cl_null(g_fiw[l_ac].fiw23) THEN
                     CALL t200_du_default(p_cmd)
                  END IF
                  CALL t200_set_no_entry_b(p_cmd)
                  CALL t200_set_required()
               END IF
               IF g_aza.aza115='Y' AND t200_fiw44_check() THEN NEXT FIELD fiw44 END IF  #FUN-CB0087 add 
            END IF
 
        AFTER FIELD fiw04
            IF NOT cl_null(g_fiw[l_ac].fiw04) THEN
               CALL t200_fiw04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fiw[l_ac].fiw04,g_errno,0)
                  LET g_fiw[l_ac].fiw04 = g_fiw_t.fiw04
                  DISPLAY BY NAME g_fiw[l_ac].fiw04
                  NEXT FIELD fiw04
               END IF
               #No.FUN-AA0062  --Begin
               IF NOT s_chk_ware(g_fiw[l_ac].fiw04) THEN
                  NEXT FIELD fiw04
               END IF
               #No.FUN-AA0062  --End
               IF g_aza.aza115='Y' AND t200_fiw44_check() THEN NEXT FIELD fiw44 END IF  #FUN-CB0087 add 
            END IF
	IF NOT s_imechk(g_fiw[l_ac].fiw04,g_fiw[l_ac].fiw05) THEN NEXT FIELD fiw05 END IF  #FUN-D40103 add
 
        AFTER FIELD fiw05
            IF cl_null(g_fiw[l_ac].fiw05) THEN LET g_fiw[l_ac].fiw05 = ' ' END IF    #No.TQC-AC0033 mark  #MOD-CA0096 remark
	#FUN-D40103--mark--str--
        #   #IF NOT cl_null(g_fiw[l_ac].fiw05) THEN     #No.TQC-AC0033 add  #MOD-CA0096 mark
        #      SELECT * FROM ime_file
        #       WHERE ime01 = g_fiw[l_ac].fiw04
        #         AND ime02 = g_fiw[l_ac].fiw05
        #      IF SQLCA.sqlcode THEN
        #         CALL cl_err3("sel","ime_file",g_fiw[l_ac].fiw04,g_fiw[l_ac].fiw05,SQLCA.sqlcode,"","",1)  #No.FUN-660092
        #         NEXT FIELD fiw05
        #      END IF
        #   #ELSE                              #No.TQC-AC0033 add   #MOD-CA0096 mark 
        #   #  LET g_fiw[l_ac].fiw05 = ' '     #No.TQC-AC0033 add   #MOD-CA0096 mark
        #   #END IF                            #No.TQC-AC0033 add   #MOD-CA0096 mark
 	#FUN-D40103--mark--end--
	IF NOT s_imechk(g_fiw[l_ac].fiw04,g_fiw[l_ac].fiw05) THEN NEXT FIELD fiw05 END IF  #FUN-D40103 add 

        AFTER FIELD fiw06
            IF cl_null(g_fiw[l_ac].fiw06) THEN LET g_fiw[l_ac].fiw06 = ' ' END IF    #No.TQC-AC0033 mark  #MOD-CA0096 remark
           #IF NOT cl_null(g_fiw[l_ac].fiw06) THEN                                    #No.TQC-AC0033 add  #MOD-CA0096 mark
              SELECT img09,img10 INTO l_img09,l_img10
                FROM img_file
               WHERE img01 = g_fiw[l_ac].fiw03
                 AND img02 = g_fiw[l_ac].fiw04
                 AND img03 = g_fiw[l_ac].fiw05
                 AND img04 = g_fiw[l_ac].fiw06
              IF SQLCA.sqlcode THEN
                 IF g_fiv.fiv00 = '1' THEN
                    CALL cl_err(g_fiw[l_ac].fiw03,'mfg6069',0)  
                    NEXT FIELD fiw03
                 ELSE
                    IF NOT cl_conf(18,10,'mfg1401') THEN NEXT FIELD fiw03 END IF
                       CALL s_add_img(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,
                                      g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06,
                                      g_fiv.fiv02      ,g_fiw[l_ac].fiw02,
                                      g_fiv.fiv04)
                    IF g_errno='N' THEN NEXT FIELD fiw03 END IF
                 END IF
              END IF
              IF g_sma.sma115 = 'N' THEN
                 IF cl_null(g_fiw[l_ac].fiw07) THEN   #若單位空白
                    LET g_fiw[l_ac].fiw07=g_img09
                    LET g_fiw[l_ac].fiw08=s_digqty(g_fiw[l_ac].fiw08,g_fiw[l_ac].fiw07)   #No.FUN-BB0086
                 END IF
              ELSE
                 SELECT COUNT(*) INTO g_cnt FROM img_file
                  WHERE img01 = g_fiw[l_ac].fiw03   #料號
                    AND img02 = g_fiw[l_ac].fiw04   #倉庫
                    AND img03 = g_fiw[l_ac].fiw05   #儲位
                    AND img04 = g_fiw[l_ac].fiw06   #批號
                    AND img18 < g_fiv.fiv04   #錄入日期
                 IF g_cnt > 0 THEN    #大於有效日期
                    call cl_err('','aim-400',0)   #須修改
                    NEXT FIELD fiw06
                 END IF
                 CALL t200_du_default(p_cmd)
              END IF
           #ELSE                              #No.TQC-AC0033 add  #MOD-CA0096 mark
           #  LET g_fiw[l_ac].fiw06 = ' '     #No.TQC-AC0033 add  #MOD-CA0096 mark
           #END IF                            #No.TQC-AC0033 add  #MOD-CA0096 mark
 
        AFTER FIELD fiw07
            IF NOT cl_null(g_fiw[l_ac].fiw07) THEN
               CALL t200_fiw07(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fiw[l_ac].fiw07,SQLCA.sqlcode,0)
                  LET g_fiw[l_ac].fiw07 = g_fiw_t.fiw07
                  DISPLAY BY NAME g_fiw[l_ac].fiw07
                  NEXT FIELD fiw07
               END IF
               IF g_fiw[l_ac].fiw07=l_img09 THEN
                   LET g_fiw[l_ac].fiw07_fac =  1
               ELSE
                  CALL s_umfchk(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw07,l_img09)
                        RETURNING g_cnt,g_fiw[l_ac].fiw07_fac
                  IF g_cnt = 1 THEN
                     CALL cl_err('','mfg3075',0)
                     NEXT FIELD fiw07
                  END IF
               END IF
               DISPLAY BY NAME g_fiw[l_ac].fiw07_fac
               #No.FUN-BB0086--add--begin---
               IF NOT t200_fiw08_check_1(l_img10,l_i) THEN 
                  LET g_fiw07_t = g_fiw[l_ac].fiw07
                  NEXT FIELD fiw08
               END IF 
               LET g_fiw07_t = g_fiw[l_ac].fiw07
               #No.FUN-BB0086--add--end---
            END IF
 
        AFTER FIELD fiw07_fac
            IF g_fiw[l_ac].fiw07_fac=0 THEN
               NEXT FIELD fiw07_fac
            END IF
 
        AFTER FIELD fiw08
           IF NOT t200_fiw08_check_1(l_img10,l_i) THEN NEXT FIELD fiw08 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_fiw[l_ac].fiw08) THEN
            #   IF g_fiv.fiv00 = "1" THEN
            #      IF g_fiw[l_ac].fiw08*g_fiw[l_ac].fiw07_fac > l_img10 THEN
            #         IF g_sma.sma894[1,1]='N' THEN
            #            CALL cl_err(g_fiw[l_ac].fiw08*g_fiw[l_ac].fiw07_fac,'mfg1303',1)
            #            NEXT FIELD fiw08
            #         ELSE
            #            IF NOT cl_confirm('mfg3469') THEN
            #               NEXT FIELD fiw08
            #            END IF
            #         END IF
            #      END IF
            #   ELSE
            #      CALL t200_fiw08_check() RETURNING l_i
            #      IF l_i=1 THEN
            #         CALL cl_err(g_fiw[l_ac].fiw08,'aem-022',0)
            #         NEXT FIELD fiw08
            #      END IF
            #   END IF
            #END IF
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD fiw23
           IF NOT cl_null(g_fiw[l_ac].fiw03) THEN
              SELECT ima25 INTO g_ima25
                FROM ima_file WHERE ima01=g_fiw[l_ac].fiw03
           END IF
           CALL t200_set_no_required()
 
        AFTER FIELD fiw23  #第二單位
           IF cl_null(g_fiw[l_ac].fiw03) THEN NEXT FIELD fiw03 END IF
           IF NOT cl_null(g_fiw[l_ac].fiw23) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_fiw[l_ac].fiw23
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_fiw[l_ac].fiw23,"",STATUS,"","gfe:",1)  #No.FUN-660092
                 NEXT FIELD fiw23
              END IF
              CALL s_du_umfchk(g_fiw[l_ac].fiw03,'','','',
                               g_ima25,g_fiw[l_ac].fiw23,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fiw[l_ac].fiw23,g_errno,0)
                 NEXT FIELD fiw23
              END IF
              IF cl_null(g_fiw_t.fiw23) OR g_fiw_t.fiw23 <> g_fiw[l_ac].fiw23 THEN
                 LET g_fiw[l_ac].fiw24 = g_factor
              END IF
              CALL s_chk_imgg(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,
                              g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06,
                              g_fiw[l_ac].fiw23) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_fiv.fiv00 = '1' THEN    #發料
                    CALL cl_err('sel img:',STATUS,0)
                    NEXT FIELD fiw04
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD fiw23 END IF
                 END IF
                 CALL s_add_imgg(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,
                                 g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06,
                                 g_fiw[l_ac].fiw23,g_fiw[l_ac].fiw24,
                                 g_fiv.fiv01,
                                 g_fiw[l_ac].fiw02,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD fiw23
                 END IF
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT t200_fiw25_check(p_cmd,l_i) THEN
                 LET g_fiw23_t = g_fiw[l_ac].fiw23
                 NEXT FIELD fiw25
              END IF 
              LET g_fiw23_t = g_fiw[l_ac].fiw23
              #No.FUN-BB0086--add--end--
           END IF
           CALL t200_du_data_to_correct()
           CALL t200_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
 
        BEFORE FIELD fiw25
           IF cl_null(g_fiw[l_ac].fiw03) THEN NEXT FIELD fiw03 END IF
           IF NOT cl_null(g_fiw[l_ac].fiw23) AND g_ima906='3' THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_fiw[l_ac].fiw23
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_fiw[l_ac].fiw23,"",STATUS,"","gfe:",1)  #No.FUN-660092
                 NEXT FIELD fiw03
              END IF
              CALL s_du_umfchk(g_fiw[l_ac].fiw03,'','','',
                               g_ima25,g_fiw[l_ac].fiw23,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fiw[l_ac].fiw23,g_errno,0)
                 NEXT FIELD fiw04
              END IF
              IF cl_null(g_fiw_t.fiw23) OR g_fiw_t.fiw23 <> g_fiw[l_ac].fiw23 THEN
                 LET g_fiw[l_ac].fiw24 = g_factor
              END IF
              CALL s_chk_imgg(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,
                              g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06,
                              g_fiw[l_ac].fiw23) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_fiv.fiv00 = '1' THEN    #發料
                    CALL cl_err('sel img:',STATUS,0)
                    NEXT FIELD fiw03
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD fiw03 END IF
                 END IF
                 CALL s_add_imgg(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,
                                 g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06,
                                 g_fiw[l_ac].fiw23,g_fiw[l_ac].fiw24,
                                 g_fiv.fiv01,
                                 g_fiw[l_ac].fiw02,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD fiw03
                 END IF
              END IF
           END IF
           CALL t200_du_data_to_correct()
           CALL t200_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
 
        AFTER FIELD fiw24  #第二轉換率
           IF NOT cl_null(g_fiw[l_ac].fiw24) THEN
              IF g_fiw[l_ac].fiw24=0 THEN
                 NEXT FIELD fiw24
              END IF
           END IF
 
        AFTER FIELD fiw25  #第二數量
           IF NOT t200_fiw25_check(p_cmd,l_i) THEN NEXT FIELD fiw25 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_fiw[l_ac].fiw25) THEN
           #   IF g_fiw[l_ac].fiw25 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD fiw25
           #   END IF
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      g_fiw_t.fiw25 <> g_fiw[l_ac].fiw25 THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_fiw[l_ac].fiw25*g_fiw[l_ac].fiw24
           #         IF cl_null(g_fiw[l_ac].fiw22) OR g_fiw[l_ac].fiw22=0 THEN #CHI-960022
           #            LET g_fiw[l_ac].fiw22=g_tot*g_fiw[l_ac].fiw21
           #            DISPLAY BY NAME g_fiw[l_ac].fiw22                      #CHI-960022
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--mark--end--
 
        AFTER FIELD fiw20  #第一單位
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           #No.FUN-BB0086--add--end--
           IF cl_null(g_fiw[l_ac].fiw03) THEN NEXT FIELD fiw03 END IF
           IF NOT cl_null(g_fiw[l_ac].fiw20) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_fiw[l_ac].fiw20
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_fiw[l_ac].fiw20,"",STATUS,"","gfe:",1)  #No.FUN-660092
                 NEXT FIELD fiw20
              END IF
              CALL s_du_umfchk(g_fiw[l_ac].fiw03,'','','',
                               g_fiw[l_ac].fiw07,g_fiw[l_ac].fiw20,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fiw[l_ac].fiw20,g_errno,0)
                 NEXT FIELD fiw20
              END IF
              IF cl_null(g_fiw_t.fiw20) OR g_fiw_t.fiw20 <> g_fiw[l_ac].fiw20 THEN
                 LET g_fiw[l_ac].fiw21 = g_factor
              END IF
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,
                                 g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06,
                                 g_fiw[l_ac].fiw20) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_fiv.fiv00 = '1' THEN    #發料
                       CALL cl_err('sel img:',STATUS,0)
                       NEXT FIELD fiw04
                    END IF
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD fiw20 END IF
                    END IF
                    CALL s_add_imgg(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,
                                    g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06,
                                    g_fiw[l_ac].fiw20,g_fiw[l_ac].fiw21,
                                    g_fiv.fiv01,
                                    g_fiw[l_ac].fiw02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD fiw20
                    END IF
                 END IF
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT cl_null(g_fiw[l_ac].fiw22) THEN
                 CALL t200_fiw22_check(l_img10) RETURNING l_tf,l_case
              END IF
              #No.FUN-BB0086--add--end--
           END IF
           CALL t200_du_data_to_correct()
           CALL t200_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--add--begin--   
           LET g_fiw20_t = g_fiw[l_ac].fiw20
           IF NOT l_tf THEN 
              CASE l_case  
                 WHEN "fiw22" NEXT FIELD fiw22
                 WHEN "fiw25" NEXT FIELD fiw25
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF 
           #No.FUN-BB0086--add--end--
 
        AFTER FIELD fiw21  #第一轉換率
           IF NOT cl_null(g_fiw[l_ac].fiw21) THEN
              IF g_fiw[l_ac].fiw21=0 THEN
                 NEXT FIELD fiw21
              END IF
           END IF
 
        AFTER FIELD fiw22  #第一數量
           #No.FUN-BB0086--add--begin--
           CALL t200_fiw22_check(l_img10) RETURNING l_tf,l_case
           IF NOT l_tf THEN 
              CASE l_case 
                 WHEN "fiw22" NEXT FIELD fiw22
                 WHEN "fiw25" NEXT FIELD fiw25
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF 
           #No.FUN-BB0086--add--end--
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_fiw[l_ac].fiw22) THEN
           #   IF g_fiw[l_ac].fiw22 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD fiw22
           #   END IF
           #END IF
           ##計算fiw08的值,檢查數量的合理性
           #CALL t200_set_origin_field()
           #CALL t200_check_inventory_qty(l_img10)
           #    RETURNING g_flag
           #IF g_flag = '1' THEN
           #   IF g_ima906 = '3' OR g_ima906 = '2' THEN
           #      NEXT FIELD fiw25
           #   ELSE
           #      NEXT FIELD fiw22
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--mark--end--
     
       AFTER FIELD fiw41
          IF NOT cl_null(g_fiw[l_ac].fiw41) THEN
             SELECT COUNT(*) INTO g_cnt FROM pja_file
              WHERE pja01 = g_fiw[l_ac].fiw41
                AND pjaacti = 'Y'    
                AND pjaclose = 'N'                   #No.FUN-960038
             IF g_cnt = 0 THEN
                CALL cl_err(g_fiw[l_ac].fiw41,'asf-984',0)
                NEXT FIELD fiw41
             END IF
          ELSE
             NEXT FIELD fiw44
          END IF
         
       BEFORE FIELD fiw42
         IF cl_null(g_fiw[l_ac].fiw41) THEN
            NEXT FIELD fiw41
         END IF
 
       AFTER FIELD fiw42
          IF NOT cl_null(g_fiw[l_ac].fiw42) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjb_file
              WHERE pjb01 = g_fiw[l_ac].fiw41
                AND pjb02 = g_fiw[l_ac].fiw42
                AND pjbacti = 'Y'    
             IF g_cnt = 0 THEN
                CALL cl_err(g_fiw[l_ac].fiw42,'apj-051',0)
                LET g_fiw[l_ac].fiw42 = g_fiw_t.fiw42
                NEXT FIELD fiw42
             ELSE
                SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11 
                 FROM pjb_file WHERE pjb01 = g_fiw[l_ac].fiw41
                  AND pjb02 = g_fiw[l_ac].fiw42
                  AND pjbacti = 'Y'            
                IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                   CALL cl_err(g_fiw[l_ac].fiw42,'apj-090',0)
                   LET g_fiw[l_ac].fiw42 = g_fiw_t.fiw42
                   NEXT FIELD fiw42
                END IF
             END IF
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_fiw[l_ac].fiw42
             IF l_pjb25 = 'Y' THEN
                NEXT FIELD fiw43
             ELSE
                LET g_fiw[l_ac].fiw43 = ' '
                DISPLAY BY NAME g_fiw[l_ac].fiw43
                NEXT FIELD fiw44
             END IF
          END IF
 
       BEFORE FIELD fiw43
         IF cl_null(g_fiw[l_ac].fiw42) THEN
            NEXT FIELD fiw42
         ELSE
            SELECT pjb25 INTO l_pjb25 FROM pjb_file
             WHERE pjb02 = g_fiw[l_ac].fiw42
            IF l_pjb25 = 'N' THEN  #WBS不做活動時，活動帶空白，跳開不輸入
               LET g_fiw[l_ac].fiw43 = ' '
               DISPLAY BY NAME g_fiw[l_ac].fiw43
               NEXT FIELD fiw44
            END IF
         END IF

       AFTER FIELD fiw43
          IF NOT cl_null(g_fiw[l_ac].fiw43) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjk_file
              WHERE pjk02 = g_fiw[l_ac].fiw43
                AND pjk11 = g_fiw[l_ac].fiw42
                AND pjkacti = 'Y'    
             IF g_cnt = 0 THEN
                CALL cl_err(g_fiw[l_ac].fiw43,'apj-049',0)
                NEXT FIELD fiw43
             END IF
          END IF

       #FUN-CB0087--add--str--
       BEFORE FIELD fiw44
          IF g_aza.aza115 = 'Y' AND cl_null(g_fiw[l_ac].fiw44) THEN 
             CALL s_reason_code(g_fiv.fiv01,g_fiv.fiv02,'',g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,'',g_fiv.fiv06) RETURNING g_fiw[l_ac].fiw44
             CALL t200_azf03_desc() #TQC-D20042 add
             DISPLAY BY NAME g_fiw[l_ac].fiw44
          END IF
       #FUN-CB0087--add--end--
       AFTER FIELD fiw44
         IF NOT cl_null(g_fiw[l_ac].fiw44) THEN
            #FUN-CB0087--add--str--
            IF NOT t200_fiw44_check() THEN
               NEXT FIELD fiw44
            ELSE 
               SELECT azf03 INTO g_fiw[l_ac].azf03 FROM azf_file WHERE azf01=g_fiw[l_ac].fiw44 AND azf02='2'   
            END IF  
            #FUN-CB0087--add--end--- 
            #FUN-CB0087--mark--str-- 
            #SELECT COUNT(*) INTO g_cnt FROM azf_file     
            #  WHERE azf01=g_fiw[l_ac].fiw44 AND azf02='2' AND azfacti='Y'
            #IF g_cnt = 0 THEN
            #   CALL cl_err(g_fiw[l_ac].fiw44,'asf-453',0)
            #   NEXT FIELD fiw44
            #END IF
            #SELECT azf09 INTO l_azf09 FROM azf_file     
            #  WHERE azf01=g_fiw[l_ac].fiw44 AND azf02='2' AND azfacti='Y'
            #IF l_azf09 != '4' THEN
            #   CALL cl_err(g_fiw[l_ac].fiw44,'aoo-403',0)
            #   NEXT FIELD fiw44
            #END IF
            #FUN-CB0087--mark--end--
         ELSE  #料號如果要做專案控管的話，一定要輸入理由碼
           IF g_smy.smy59 = 'Y' THEN
              CALL cl_err('','apj-201',0)
              NEXT FIELD fiw44
           END IF  
         END IF
         CALL t200_azf03_desc() #TQC-D20042 add
 
       AFTER FIELD fiwud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fiwud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
          IF g_fiw_t.fiw02 > 0 AND g_fiw_t.fiw02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
              IF g_fiv.fiv00 = '1' THEN LET l_act = "1" ELSE LET l_act = '2' END IF
              IF s_chk_rvbs(g_fiw[l_ac].fiw41,g_fiw[l_ac].fiw04) THEN
                #IF NOT s_del_rvbs(l_act,g_fiv.fiv01,g_fiw[l_ac].fiw02,0)  THEN                      #FUN-880129  #TQC-B90236 mark
                 IF NOT s_lot_del(g_prog,g_fiv.fiv01,g_fiw[l_ac].fiw02,0,g_fiw[l_ac].fiw03,'DEL')  THEN            #TQC-B90236 add
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              END IF
             DELETE FROM fiw_file
              WHERE fiw01 = g_fiv.fiv01 AND fiw02 = g_fiw_t.fiw02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","fiw_file",g_fiv.fiv01,g_fiw_t.fiw02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
          COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fiw[l_ac].* = g_fiw_t.*
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fiw[l_ac].fiw02,-263,1)
               LET g_fiw[l_ac].* = g_fiw_t.*
            ELSE
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_fiw[l_ac].fiw03) THEN
                     SELECT ima25 INTO g_ima25
                       FROM ima_file WHERE ima01=g_fiw[l_ac].fiw03
                  END IF
 
                  CALL s_chk_va_setting(g_fiw[l_ac].fiw03)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD fiw03
                  END IF
 
                  CALL t200_du_data_to_correct()
 
                  CALL t200_set_origin_field()
                  #計算fiw08的值,檢查數量的合理性
                  CALL t200_check_inventory_qty(l_img10)
                      RETURNING g_flag
                  IF g_flag = '1' THEN
                     IF g_ima906 = '3' OR g_ima906 = '2' THEN
                        NEXT FIELD fiw25
                     ELSE
                        NEXT FIELD fiw22
                     END IF
                  END IF
               END IF
              IF s_chk_rvbs(g_fiw[l_ac].fiw41,g_fiw[l_ac].fiw04) THEN
                LET g_success = 'Y'
                CALL t200_rvbs()
                IF g_success = 'N' THEN
                   NEXT FIELD fiw41
                END IF
              END IF
               UPDATE fiw_file SET fiw02     = g_fiw[l_ac].fiw02,
                                   fiw03     = g_fiw[l_ac].fiw03,
                                   fiw04     = g_fiw[l_ac].fiw04,
                                   fiw05     = g_fiw[l_ac].fiw05,
                                   fiw06     = g_fiw[l_ac].fiw06,
                                   fiw07     = g_fiw[l_ac].fiw07,
                                   fiw07_fac = g_fiw[l_ac].fiw07_fac,
                                   fiw08     = g_fiw[l_ac].fiw08,
                                   fiw09     = g_fiw[l_ac].fiw09,
                                   fiw41     = g_fiw[l_ac].fiw41,
                                   fiw42     = g_fiw[l_ac].fiw42,
                                   fiw43     = g_fiw[l_ac].fiw43,
                                   fiw44     = g_fiw[l_ac].fiw44,
                                   fiw20     = g_fiw[l_ac].fiw20,
                                   fiw21     = g_fiw[l_ac].fiw21,
                                   fiw22     = g_fiw[l_ac].fiw22,
                                   fiw23     = g_fiw[l_ac].fiw23,
                                   fiw24     = g_fiw[l_ac].fiw24,
                                   fiw25     = g_fiw[l_ac].fiw25,
                                   fiwud01   = g_fiw[l_ac].fiwud01,
                                   fiwud02   = g_fiw[l_ac].fiwud02,
                                   fiwud03   = g_fiw[l_ac].fiwud03,
                                   fiwud04   = g_fiw[l_ac].fiwud04,
                                   fiwud05   = g_fiw[l_ac].fiwud05,
                                   fiwud06   = g_fiw[l_ac].fiwud06,
                                   fiwud07   = g_fiw[l_ac].fiwud07,
                                   fiwud08   = g_fiw[l_ac].fiwud08,
                                   fiwud09   = g_fiw[l_ac].fiwud09,
                                   fiwud10   = g_fiw[l_ac].fiwud10,
                                   fiwud11   = g_fiw[l_ac].fiwud11,
                                   fiwud12   = g_fiw[l_ac].fiwud12,
                                   fiwud13   = g_fiw[l_ac].fiwud13,
                                   fiwud14   = g_fiw[l_ac].fiwud14,
                                   fiwud15   = g_fiw[l_ac].fiwud15
                WHERE fiw01=g_fiv.fiv01 AND fiw02=g_fiw_t.fiw02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","fiw_file",g_fiw[l_ac].fiw02,g_fiw[l_ac].fiw03,SQLCA.sqlcode,"","upd fiw",1)  #No.FUN-660092
                  LET g_fiw[l_ac].* = g_fiw_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fiw[l_ac].* = g_fiw_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fiw.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE t200_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
           CALL t200_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fiw02) AND l_ac > 1 THEN
              LET g_fiw[l_ac].* = g_fiw[l_ac-1].*
              LET g_fiw[l_ac].fiw02 = NULL
              NEXT FIELD fiw02
           END IF
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(fiw03)
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form ="q_ima"
                 #    LET g_qryparam.default1 = g_fiw[1].fiw03
                 #    CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw03
                     CALL q_sel_ima(FALSE, "q_ima", "", g_fiw[1].fiw03, "", "", "", "" ,"",'' )  RETURNING g_fiw[1].fiw03
#FUN-AA0059 --End--
                     NEXT FIELD fiw03
                WHEN INFIELD(fiw04) OR INFIELD(fiw05) OR INFIELD(fiw06)
                     CALL q_img4(FALSE,TRUE,g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,  ##NO.FUN-660085
                                             g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06,'A')
                     RETURNING g_fiw[l_ac].fiw04,g_fiw[l_ac].fiw05,g_fiw[l_ac].fiw06
                     IF cl_null(g_fiw[l_ac].fiw04) THEN LET g_fiw[l_ac].fiw04 = ' ' END IF
                     IF cl_null(g_fiw[l_ac].fiw05) THEN LET g_fiw[l_ac].fiw05 = ' ' END IF
                     IF cl_null(g_fiw[l_ac].fiw06) THEN LET g_fiw[l_ac].fiw06 = ' ' END IF
                     IF INFIELD(fiw04) THEN NEXT FIELD fiw04 END IF
                     IF INFIELD(fiw05) THEN NEXT FIELD fiw05 END IF
                     IF INFIELD(fiw06) THEN NEXT FIELD fiw06 END IF
                WHEN INFIELD(fiw07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_fiw[1].fiw07
                     CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw07
                     NEXT FIELD fiw07
               WHEN INFIELD(fiw20) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_fiw[l_ac].fiw20
                    CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw20
                    DISPLAY BY NAME g_fiw[l_ac].fiw20
                    NEXT FIELD fiw20
 
               WHEN INFIELD(fiw23) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_fiw[l_ac].fiw23
                    CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw23
                    DISPLAY BY NAME g_fiw[l_ac].fiw23
                    NEXT FIELD fiw23
 
                WHEN INFIELD(fiw41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"  
                  CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw41 
                  DISPLAY BY NAME g_fiw[l_ac].fiw41
                  NEXT FIELD fiw41
                WHEN INFIELD(fiw42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.arg1 = g_fiw[l_ac].fiw41  
                  CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw42 
                  DISPLAY BY NAME g_fiw[l_ac].fiw42
                  NEXT FIELD fiw42
                WHEN INFIELD(fiw43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.arg1 = g_fiw[l_ac].fiw42  
                  CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw43 
                  DISPLAY BY NAME g_fiw[l_ac].fiw43
                  NEXT FIELD fiw43
                  
                WHEN INFIELD(fiw44)
                  #FUN-CB0087---add---str---         
                  CALL s_get_where(g_fiv.fiv01,g_fiv.fiv02,'',g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,'',g_fiv.fiv06) RETURNING l_flag,l_where
                  IF l_flag AND g_aza.aza115 = 'Y' THEN 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_fiw[l_ac].fiw44
                  ELSE
                  #FUN-CB0087---add---end---
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azf01a"        #FUN-920186
                     LET g_qryparam.default1 = g_fiw[l_ac].fiw44
                     LET g_qryparam.arg1 = '4'              #FUN-920186
                  END IF #FUN-CB0087 add   
                  CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw44
                  DISPLAY BY NAME g_fiw[l_ac].fiw44
                  CALL t200_azf03_desc() #TQC-D20042 add
                  NEXT FIELD fiw44
           END CASE
 
        ON ACTION q_imd    #查詢倉庫
#No.FUN-AA0062  --Begin
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form ="q_imd"
#                     LET g_qryparam.default1 = g_fiw[l_ac].fiw04
#                     LET g_qryparam.default2 = 'A'
#                     CALL cl_create_qry() RETURNING g_fiw[l_ac].fiw04
                     CALL q_imd_1(FALSE,TRUE,g_fiw[l_ac].fiw04,"","","","") RETURNING g_fiw[l_ac].fiw04
                     NEXT FIELD fiw04
#No.FUN-AA0062  --End                    
        ON ACTION q_ime    #查詢倉庫儲位
#No.FUN-AA0062  --Begin
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form ="q_ime1"
#                     LET g_qryparam.default1 = g_fiw[l_ac].fiw04
#                     LET g_qryparam.default2 = g_fiw[l_ac].fiw05
#                     LET g_qryparam.default3 = 'A'
#                     CALL cl_create_qry()
                     CALL q_ime_2(FALSE,TRUE,"","","","")
                     RETURNING g_fiw[l_ac].fiw04,g_fiw[l_ac].fiw05
                     NEXT FIELD fiw05
#No.FUN-AA0062  --End
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
 
    LET g_fiv.fivmodu = g_user
    LET g_fiv.fivdate = g_today
    UPDATE fiv_file SET fivmodu = g_fiv.fivmodu,fivdate = g_fiv.fivdate
     WHERE fiv01 = g_fiv.fiv01
    DISPLAY BY NAME g_fiv.fivmodu,g_fiv.fivdate
 
    CLOSE t200_bcl
    COMMIT WORK
#   CALL  t200_delall()     #TQC-AB0358  #CHI-C30002 mark
    CALL t200_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t200_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM fiv_file WHERE fiv01 = g_fiv.fiv01
         INITIALIZE g_fiv.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t200_fiw03(p_cmd)
 DEFINE l_ima02   LIKE ima_file.ima02,
        l_imaacti LIKE ima_file.imaacti,
        l_ima35   LIKE ima_file.ima35,      #CHI-6A0015
        l_ima36   LIKE ima_file.ima36,      #CHI-6A0015
        p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
  DEFINE l_fjb03 LIKE fjb_file.fjb03   #MOD-A10078
  DEFINE l_flag  LIKE type_file.chr1   #MOD-A10078 
 
 
  LET g_errno = " "
  SELECT UNIQUE fiy03 FROM fiy_file
   WHERE fiy01 IN (SELECT fim03 FROM fim_file WHERE fim01 = g_fiv.fiv02)
     AND fiy03 = g_fiw[l_ac].fiw03
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aem-015'
                                 LET g_fiw[l_ac].ima02 = NULL
       WHEN SQLCA.SQLCODE = 0
            SELECT ima02,ima35,ima36,imaacti INTO l_ima02,l_ima35,l_ima36,l_imaacti   #CHI-6A0015 add ima35/36
              FROM ima_file  WHERE ima01 = g_fiw[l_ac].fiw03
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                           LET g_fiw[l_ac].ima02 = NULL
                 WHEN l_imaacti='N'        LET g_errno = '9028'
                 WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
                 OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  #-----MOD-A10078---------
  DECLARE fjb03_cur_2 CURSOR FOR 
    SELECT fjb03 FROM fjb_file 
      WHERE fjb01 IN (SELECT fil03 FROM fil_file WHERE fil01=g_fiv.fiv02) 
  LET l_fjb03 = ''
  LET l_flag = '0'
  FOREACH fjb03_cur_2 INTO l_fjb03
     IF l_fjb03 = g_fiw[l_ac].fiw03 THEN
        LET l_flag = '1'
        EXIT FOREACH
     ELSE
        CONTINUE FOREACH
     END IF
  END FOREACH
  IF l_flag = '0' THEN
     LEt g_errno = 'aem-051'
  END IF
  #-----END MOD-A10078-----
  
  IF cl_null(g_errno) THEN
     LET g_fiw[l_ac].ima02 = l_ima02
     IF cl_null(g_fiw_t.fiw03) OR g_fiw_t.fiw03 <> g_fiw[l_ac].fiw03 THEN   #
       #No.FUN-AA0062  --Begin
       IF NOT s_chk_ware(l_ima35) THEN
         LET l_ima35 = ''
         LET l_ima36 = ''
       END IF
       #No.FUN-AA0062  --End 
       LET g_fiw[l_ac].fiw04 = l_ima35    #CHI-6A0015 add
       LET g_fiw[l_ac].fiw05 = l_ima36    #CHI-6A0015 add
     END IF                                                                 #TQC-750018
     DISPLAY BY NAME g_fiw[l_ac].ima02
  END IF
END FUNCTION
 
FUNCTION t200_fiw04(p_cmd)
 DEFINE l_imdacti LIKE imd_file.imdacti,
        p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
  LET g_errno = " "
  SELECT imdacti INTO l_imdacti
    FROM imd_file  WHERE imd01 = g_fiw[l_ac].fiw04
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-004'
       WHEN l_imdacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
END FUNCTION
 
FUNCTION t200_fiw07(p_cmd)
    DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
           p_cmd      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
      FROM gfe_file WHERE gfe01 = g_fiw[l_ac].fiw07
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-319'
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION t200_b_askkey()
DEFINE l_wc2          LIKE type_file.chr1000        #No.FUN-680072CHAR(200)
 
    CONSTRUCT l_wc2 ON fiw02,fiw03,fiw04,fiw05,fiw06,
                       fiw07,fiw07_fac,fwi08,fiw23,fiw24,fiw25,
                       fiw20,fiw21,fiw22,fiw09,
                       fiw41,fiw42,fiw43,fiw44      #FUN-810045
                       ,fiwud01,fiwud02,fiwud03,fiwud04,fiwud05
                       ,fiwud06,fiwud07,fiwud08,fiwud09,fiwud10
                       ,fiwud11,fiwud12,fiwud13,fiwud14,fiwud15
         FROM s_fiw[1].fiw02,s_fiw[1].fiw03,s_fiw[1].fiw04,
              s_fiw[1].fiw05,s_fiw[1].fiw06,s_fiw[1].fiw07,
              s_fiw[1].fiw07_fac,  #FUN-810045
              s_fiw[1].fiw08,s_fiw[1].fiw23,s_fiw[1].fiw24,
              s_fiw[1].fiw25,s_fiw[1].fiw20,s_fiw[1].fiw21,
              s_fiw[1].fiw22,s_fiw[1].fiw09,
              s_fiw[1].fiw41,s_fiw[1].fiw42,s_fiw[1].fiw43,s_fiw[1].fiw44   #FUN-810045 add
              ,s_fiw[1].fiwud01,s_fiw[1].fiwud02,s_fiw[1].fiwud03
              ,s_fiw[1].fiwud04,s_fiw[1].fiwud05,s_fiw[1].fiwud06
              ,s_fiw[1].fiwud07,s_fiw[1].fiwud08,s_fiw[1].fiwud09
              ,s_fiw[1].fiwud10,s_fiw[1].fiwud11,s_fiw[1].fiwud12
              ,s_fiw[1].fiwud13,s_fiw[1].fiwud14,s_fiw[1].fiwud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION CONTROLP
          CASE WHEN INFIELD(fiw03)
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form ="q_ima"
                 #   LET g_qryparam.default1 = g_fiw[1].fiw03
                 #   LET g_qryparam.state = "c"
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","",g_fiw[1].fiw03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO s_fiw[1].fiw03
                    NEXT FIELD fiw03
#FUN-AA0062 --Begin
               WHEN INFIELD(fiw04)
                    CALL q_imd_1(TRUE,TRUE,g_fiw[1].fiw04,"","","","")  RETURNING  g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_fiw[1].fiw04
                    NEXT FIELD fiw03
               WHEN INFIELD(fiw05)
                    CALL q_ime_1(TRUE,TRUE,g_fiw[1].fiw05,g_fiw[1].fiw04,"","","","","")  RETURNING  g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_fiw[1].fiw05
                    NEXT FIELD fiw03
#FUN-AA0062 --End
               WHEN INFIELD(fiw07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_fiw[1].fiw07
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fiw07
                    NEXT FIELD fiw07
               WHEN INFIELD(fiw20)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_fiw[1].fiw20
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fiw20
                    NEXT FIELD fiw20
               WHEN INFIELD(fiw23)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_fiw[1].fiw23
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fiw23
                    NEXT FIELD fiw23
 
                WHEN INFIELD(fiw41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"  
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fiw41
                  NEXT FIELD fiw41
                WHEN INFIELD(fiw42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fiw42
                  NEXT FIELD fiw42
                WHEN INFIELD(fiw43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fiw43
                  NEXT FIELD fiw43
                WHEN INFIELD(fiw44)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"     #FUN-920186
                  LET g_qryparam.state = "c"   #多選
                  LET g_qryparam.arg1 = '4'           #FUN-920186
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fiw44
                  NEXT FIELD fiw44
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t200_b_fill(l_wc2)
END FUNCTION
 
#TQC-AB0358 --------------add start---------
#CHI-C30002 -------- mark -------- begin
#FUNCTION t200_delall()

#   SELECT COUNT(*) INTO g_cnt FROM fiw_file
#    WHERE fiw01 = g_fiv.fiv01

#   IF g_cnt = 0 THEN
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM fiv_file WHERE fiv01 = g_fiv.fiv01
#      CALL g_fiw.clear()
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
#TQC-AB0358 --------------add end---------------

FUNCTION t200_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000        #No.FUN-680072CHAR(200)
 
    LET g_sql =
        "SELECT fiw02,fiw03,'',fiw04,fiw05,fiw06,fiw07,fiw07_fac,fiw08,",
        "       fiw23,fiw24,fiw25,fiw20,fiw21,fiw22,fiw09, ",
        "       fiw41,fiw42,fiw43,fiw44,azf03, ",   #FUN-810045 add #FUN-CB0087 add azf03
        "       fiwud01,fiwud02,fiwud03,fiwud04,fiwud05,",
        "       fiwud06,fiwud07,fiwud08,fiwud09,fiwud10,",
        "       fiwud11,fiwud12,fiwud13,fiwud14,fiwud15 ", 
        "  FROM fiw_file ",
        "  LEFT OUTER JOIN azf_file ON fiw44=azf01 AND azf02='2' ", #FUN-CB0087 add
        " WHERE fiw01 ='",g_fiv.fiv01,"'",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
 
    PREPARE t200_pb FROM g_sql
    DECLARE fiw_curs CURSOR FOR t200_pb
    DISPLAY "g_sql=",g_sql
    CALL g_fiw.clear()
 
    LET g_cnt = 1
    FOREACH fiw_curs INTO g_fiw[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       SELECT ima02 INTO g_fiw[g_cnt].ima02 FROM ima_file
        WHERE ima01=g_fiw[g_cnt].fiw03
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_fiw.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION t200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_fiw TO s_fiw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL t200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL t200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL t200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL t200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL t200_fetch('L')
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
         CALL t200_def_form()   #FUN-610006
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
    #@ON ACTION 庫存過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
    #@ON ACTION 作廢
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t200_s()
   DEFINE l_cnt   LIKE type_file.num10          #No.FUN-680072INTEGER
   DEFINE l_fil05 LIKE fil_file.fil05
   DEFINE g_fiw   RECORD LIKE fiw_file.*        #No.FUN-610090
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_fiv.fiv01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_fiv.* FROM fiv_file
    WHERE fiv01 = g_fiv.fiv01
 
   IF g_fiv.fivpost = 'X' THEN
      CALL cl_err('',9027,0)
      RETURN
   END IF
 
   IF g_fiv.fivconf = 'N' THEN
      CALL cl_err('','mfg3550',0)
      RETURN
   END IF
 
   IF g_fiv.fivpost = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
 
   SELECT fil05 INTO l_fil05 FROM fil_file
    WHERE fil01 = g_fiv.fiv02
 
   IF l_fil05 MATCHES '[34]' THEN
      CALL cl_err(g_fiv.fiv02,'aem-024',0)
      RETURN
   END IF
  
               
   IF g_sma.sma53 IS NOT NULL AND g_fiv.fiv05 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      RETURN
   END IF
 
   CALL s_yp(g_fiv.fiv05) RETURNING g_yy,g_mm
 
   IF g_yy > g_sma.sma51 THEN    # 與目前會計年度,期間比較
      CALL cl_err(g_yy,'mfg6090',0)
      RETURN
   ELSE
      IF g_yy = g_sma.sma51 AND g_mm > g_sma.sma52 THEN
         CALL cl_err(g_mm,'mfg6091',0)
         RETURN
      END IF
   END IF
 
   #No.+022 010328 by linda add 無單身不可確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM fiw_file
    WHERE fiw01 = g_fiv.fiv01
 
   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('mfg0176') THEN
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   BEGIN WORK
 
   OPEN t200_cl USING g_fiv.fiv01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t200_cl INTO g_fiv.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
 
   CALL t200_s1()
 
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
   END IF
 
   IF g_success = 'Y' THEN
      UPDATE fiv_file SET fivpost = 'Y'
       WHERE fiv01=g_fiv.fiv01
      IF SQLCA.SQLCODE OR STATUS=100 THEN
         CALL cl_err3("upd","fiv_file",g_fiv.fiv01,"",SQLCA.sqlcode,"","upd fivpost: ",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
 
      LET g_fiv.fivpost = 'Y'
 
      DISPLAY BY NAME g_fiv.fivpost
 
      UPDATE fil_file SET fil05 = '2'
       WHERE fil01 = g_fiv.fiv02
      IF SQLCA.SQLCODE OR STATUS=100 THEN
         CALL cl_err3("upd","fil_file",g_fiv.fiv02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
 
      COMMIT WORK
   ELSE
      LET g_fiv.fivpost='N'
      ROLLBACK WORK
   END IF
 
   IF g_fiv.fivpost = "N" THEN
      DECLARE t200_s1_c2 CURSOR FOR SELECT * FROM fiw_file
        WHERE fiw01 = g_fiv.fiv01
 
      LET g_imm01 = ""
      LET g_success = "Y"
      BEGIN WORK
 
      FOREACH t200_s1_c2 INTO b_fiw.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
 
         IF g_sma.sma115 = 'Y' THEN
            IF g_ima906 = '2' THEN  #子母單位
               LET g_unit_arr[1].unit= b_fiw.fiw20
               LET g_unit_arr[1].fac = b_fiw.fiw21
               LET g_unit_arr[1].qty = b_fiw.fiw22
               LET g_unit_arr[2].unit= b_fiw.fiw23
               LET g_unit_arr[2].fac = b_fiw.fiw24
               LET g_unit_arr[2].qty = b_fiw.fiw25
               CALL s_dismantle(g_fiv.fiv01,b_fiw.fiw02,g_fiv.fiv04,
                                b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,
                                b_fiw.fiw06,g_unit_arr,g_imm01)
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
 
   MESSAGE ''
 
END FUNCTION
 
FUNCTION t200_s1()
   DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
   DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t200_s1_c1 CURSOR FOR SELECT * FROM fiw_file
                                 WHERE fiw01 = g_fiv.fiv01

   FOREACH t200_s1_c1 INTO b_fiw.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = b_fiw.fiw03
         AND img02 = b_fiw.fiw04
         AND img03 = b_fiw.fiw05
         AND img04 = b_fiw.fiw06
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,g_fiv.fiv01,b_fiw.fiw02,g_fiv.fiv05,l_img_table)  #FUN-CC0095
          CALL s_padd_img_data1(b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,g_fiv.fiv01,b_fiw.fiw02,g_fiv.fiv05)  #FUN-CC0095
       END IF

       CALL s_chk_imgg(b_fiw.fiw03,b_fiw.fiw04,
                       b_fiw.fiw05,b_fiw.fiw06,
                       b_fiw.fiw20) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,b_fiw.fiw20,g_fiv.fiv01,b_fiw.fiw02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,b_fiw.fiw20,g_fiv.fiv01,b_fiw.fiw02) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(b_fiw.fiw03,b_fiw.fiw04,
                       b_fiw.fiw05,b_fiw.fiw06,
                       b_fiw.fiw23) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,b_fiw.fiw23,g_fiv.fiv01,b_fiw.fiw02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,b_fiw.fiw23,g_fiv.fiv01,b_fiw.fiw02) #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_img FROM g_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM g_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end   
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF #FUN-CC0095 
      ELSE
         #CALL s_padd_img_del(l_img_table) #FUN-CC0095
         #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table) #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
   #FUN-C70087---end
   
   CALL s_showmsg_init()   #No.FUN-6C0083 
 
   DECLARE t200_s1_c CURSOR FOR SELECT * FROM fiw_file
                                 WHERE fiw01 = g_fiv.fiv01
 
   FOREACH t200_s1_c INTO b_fiw.*
      IF STATUS THEN
         EXIT FOREACH
      END IF
 
      IF cl_null(b_fiw.fiw03) THEN
         CONTINUE FOREACH
      END IF
      
      IF g_sma.sma115 = 'Y' THEN
         IF b_fiw.fiw22 != 0 OR b_fiw.fiw25 != 0 THEN
            CALL t200_update_du('s')
            IF g_success='N' THEN    #No.FUN-6C0083
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
         END IF
      END IF
 
      CALL t200_update(b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,
                       b_fiw.fiw08,b_fiw.fiw07,b_fiw.fiw07_fac)
 
      IF g_success='N' THEN    #No.FUN-6C0083
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
   END FOREACH
 
   IF g_totsuccess="N" THEN    #TQC-620156
      LET g_success="N"
   END IF
   CALL s_showmsg()   #No.FUN-6C0083
 
END FUNCTION
 
FUNCTION t200_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor)
  DEFINE p_ware   LIKE tlf_file.tlf031,        #No.FUN-680072CHAR(10)
         p_loca   LIKE tlf_file.tlf032,        #No.FUN-680072CHAR(10)
         p_lot    LIKE tlf_file.tlf033,        #No.FUN-680072CHAR(20)
         p_qty    LIKE tlf_file.tlf10,         #No.FUN-680072DECIMAL(15,3)
         p_uom    LIKE tlf_file.tlf11,         #No.FUN-680072CHAR(04)
         p_factor LIKE tlf_file.tlf12,         #No.FUN-680072DECIMAL(16,8)
         u_type   LIKE type_file.num5,         #No.FUN-680072SMALLINT
         l_qty    LIKE img_file.img10,         #No.B161
         l_ima01  LIKE ima_file.ima01,
         l_ima25  LIKE ima_file.ima01,
#         l_imaqty LIKE ima_file.ima262,       #No.FUN-A20044
         l_imaqty LIKE type_file.num15_3,      #No.FUN-A20044
         l_imafac LIKE img_file.img21,
         l_img    RECORD
                  img10   LIKE img_file.img10,
                  img16   LIKE img_file.img16,
                  img23   LIKE img_file.img23,
                  img24   LIKE img_file.img24,
                  img09   LIKE img_file.img09,
                  img21   LIKE img_file.img21
                  END RECORD,
         l_cnt   LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1)
       LET g_success = 'N'
       RETURN
    END IF
 
    MESSAGE "update img_file ..."
 
    LET g_forupd_sql =
        "SELECT img10,img16,img23,img24,img09,img21 FROM img_file ",   #mod by liuxqa 091020
        " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ?  FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING b_fiw.fiw03,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE img_lock
       RETURN
    END IF
 
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       CALL cl_err('lock img fail1',STATUS,1)
       LET g_success='N'
       CLOSE img_lock
       RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
 
    LET l_qty= l_img.img10 - p_qty
 
    CASE WHEN g_fiv.fiv00 ="1" LET u_type=-1
         WHEN g_fiv.fiv00 ="2" LET u_type=+1
    END CASE
 
    CALL s_upimg(b_fiw.fiw03,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_fiv.fiv05,#FUN-8C0084
          '','','','','','','','','','','','','','','','','','')
 
    IF g_success='N' THEN RETURN END IF
 
    MESSAGE "update ima_file ..."
 
    LET g_forupd_sql =
        "SELECT ima25,ima86 FROM ima_file WHERE ima01= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql
 
    OPEN ima_lock USING b_fiw.fiw03
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       LET g_success = 'N'
       CLOSE ima_lock
       RETURN
    END IF
 
    FETCH ima_lock INTO l_ima25,g_ima86
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       LET g_success = 'N'
       CLOSE ima_lock
       RETURN
    END IF
 
    IF b_fiw.fiw07=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(b_fiw.fiw03,b_fiw.fiw07,l_ima25)
                RETURNING g_cnt,l_imafac
 
    ##Modify:98/11/13----單位換算率抓不到--------###
       IF g_cnt = 1 THEN
          CALL cl_err('','abm-731',1)
          LET g_success ='N'
       END IF
    END IF
 
    IF cl_null(l_imafac)  THEN LET l_imafac = 1 END IF
 
    LET l_imaqty = p_qty * l_imafac
 
    CALL s_udima(b_fiw.fiw03,l_img.img23,l_img.img24,l_imaqty,
                 g_fiv.fiv05,u_type)  RETURNING l_cnt
 
    IF g_success='N' THEN RETURN END IF
 
    #------------------------------------------- insert tlf_file
    MESSAGE "insert tlf_file ..."
 
    IF g_success='Y' THEN
       CALL t200_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,
                     u_type)
    END IF
 
    MESSAGE "seq#",b_fiw.fiw03 USING'<<<',' post ok!'
 
END FUNCTION
 
FUNCTION t200_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                  u_type)
   DEFINE p_ware     LIKE tlf_file.tlf031,                         #No.FUN-680072CHAR(10)
          p_loca     LIKE tlf_file.tlf032,                         #No.FUN-680072CHAR(10)
          p_lot      LIKE tlf_file.tlf033,                         #No.FUN-680072CHAR(20)
          p_qty      LIKE tlf_file.tlf10,                          #No.FUN-680072DECIMAL (11,3)
          p_uom      LIKE tlf_file.tlf11,                          #No.FUN-680072CHAR(04)
          p_factor   LIKE tlf_file.tlf12,                          #No.FUN-680072DECIMAL(16,8)
          p_unit     LIKE ima_file.ima25,##單位
          p_img10    LIKE img_file.img10,#異動後數量
          u_type     LIKE type_file.num5,                          #No.FUN-680072SMALLINT
          l_sta      LIKE type_file.num5,                          #No.FUN-680072SMALLINT
          g_cnt      LIKE type_file.num5                           #No.FUN-680072SMALLINT
 
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01=b_fiw.fiw03         #異動料件編號
   IF g_fiv.fiv00 ='2' THEN
      #----來源----
      LET g_tlf.tlf02=90
      LET g_tlf.tlf026=g_fiv.fiv02        #來源單號
      #---目的----
      LET g_tlf.tlf03=50                  #'Stock'
      LET g_tlf.tlf030=g_plant
      LET g_tlf.tlf031=p_ware             #倉庫
      LET g_tlf.tlf032=p_loca             #儲位
      LET g_tlf.tlf033=p_lot              #批號
      LET g_tlf.tlf034=p_img10            #異動後數量
      LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=b_fiw.fiw01        #雜收單號
      LET g_tlf.tlf037=b_fiw.fiw02        #雜收項次
   END IF
   IF g_fiv.fiv00 ='1' THEN
      #----來源----
      LET g_tlf.tlf02=50                  #'Stock'
      LET g_tlf.tlf020=g_plant
      LET g_tlf.tlf021=p_ware             #倉庫
      LET g_tlf.tlf022=p_loca             #儲位
      LET g_tlf.tlf023=p_lot              #批號
      LET g_tlf.tlf024=p_img10            #異動後數量
      LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=b_fiw.fiw01        #雜發/報廢單號
      LET g_tlf.tlf027=b_fiw.fiw02        #雜發/報廢項次
      #---目的----
      LET g_tlf.tlf03 =90
      LET g_tlf.tlf036=g_fiv.fiv02        #目的單號
   END IF
 
   LET g_tlf.tlf06=g_fiv.fiv05      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom			#發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
 
   CASE WHEN g_fiv.fiv00 = '1' LET g_tlf.tlf13='aemt201'
        WHEN g_fiv.fiv00 = '2' LET g_tlf.tlf13='aemt202'
   END CASE
 
   LET g_tlf.tlf17=g_fiv.fiv03              #Remark
   LET g_tlf.tlf19=g_fiv.fiv06
   LET g_tlf.tlf61= g_ima86
   LET g_tlf.tlf20 = b_fiw.fiw41
   LET g_tlf.tlf41 = b_fiw.fiw42
   LET g_tlf.tlf42 = b_fiw.fiw43
   LET g_tlf.tlf43 = b_fiw.fiw44
 
   CALL s_tlf(1,0)
 
END FUNCTION
 
FUNCTION t200_t()
 DEFINE l_cnt,l_i  LIKE type_file.num10     #No.FUN-680072INTEGER
 DEFINE l_fil05    LIKE fil_file.fil05
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fiv.fiv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01=g_fiv.fiv01
 
   IF g_fiv.fivpost = 'N' THEN CALL cl_err('','mfg0178',0) RETURN END IF
   IF g_fiv.fivconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF

   #FUN-BC0062 ---------Begin--------
   #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-936',1)
      RETURN
   END IF
   #FUN-BC0062 ---------End----------
 
   SELECT fil05 INTO l_fil05 FROM fil_file WHERE fil01=g_fiv.fiv02
   IF l_fil05 MATCHES '[34]' THEN
      CALL cl_err(g_fiv.fiv02,'aem-024',0)
      RETURN
   END IF
   
               
   IF g_sma.sma53 IS NOT NULL AND g_fiv.fiv05 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
   CALL s_yp(g_fiv.fiv05) RETURNING g_yy,g_mm
   IF g_yy > g_sma.sma51 THEN# 與目前會計年度,期間比較
      CALL cl_err(g_yy,'mfg6090',0) RETURN
   ELSE
      IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52
         THEN CALL cl_err(g_mm,'mfg6091',0) RETURN
      END IF
   END IF
   #No.+022 010328 by linda add 無單身不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM fiw_file
    WHERE fiw01=g_fiv.fiv01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('asf-663') THEN RETURN END IF
 
   LET g_success = 'Y'
 
   BEGIN WORK
   OPEN t200_cl USING g_fiv.fiv01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_fiv.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
 
   CALL t200_t1()
   IF SQLCA.SQLCODE THEN LET g_success='N' END IF
 
   IF g_success = 'Y' THEN
      UPDATE fiv_file SET fivpost='N' WHERE fiv01=g_fiv.fiv01
      IF SQLCA.SQLCODE OR STATUS=100 THEN
         CALL cl_err3("upd","fiv_file",g_fiv.fiv01,"",SQLCA.sqlcode,"","upd fivpost: ",1)  #No.FUN-660092
         ROLLBACK WORK RETURN
      END IF
      LET g_fiv.fivpost='N'
      DISPLAY BY NAME g_fiv.fivpost
      SELECT COUNT(*) INTO l_i FROM fiv_file
       WHERE fiv02=g_fiv.fiv02 AND fivpost='Y'
      IF l_i =0 THEN
         UPDATE fil_file SET fil05='1' WHERE fil01=g_fiv.fiv02
         IF SQLCA.SQLCODE OR STATUS=100 THEN
            CALL cl_err3("upd","fil_file",g_fiv.fiv02,"",SQLCA.SQLCODE,"","upd fivpost:",1)  #No.FUN-660092
            ROLLBACK WORK RETURN
         END IF
      END IF
      COMMIT WORK
   ELSE
      LET g_fiv.fivpost='Y'
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION t200_t1()
  DECLARE t200_t1_c CURSOR FOR SELECT * FROM fiw_file WHERE fiw01=g_fiv.fiv01
  FOREACH t200_t1_c INTO b_fiw.*
      IF STATUS THEN LET g_success='N' RETURN END IF
      MESSAGE '_t1() read fiw:',b_fiw.fiw03
      IF cl_null(b_fiw.fiw03) THEN CONTINUE FOREACH END IF
      IF cl_null(b_fiw.fiw04) THEN LET b_fiw.fiw04=' ' END IF
      IF cl_null(b_fiw.fiw05) THEN LET b_fiw.fiw05=' ' END IF
      IF cl_null(b_fiw.fiw06) THEN LET b_fiw.fiw06=' ' END IF
      CALL t200_u_img()
#     CALL t200_u_ima()      #FUN-A20044
      CALL t200_u_tlf()
      IF g_sma.sma115 = 'Y' THEN
         IF b_fiw.fiw22 != 0 OR b_fiw.fiw25 != 0 THEN
            CALL t200_update_du('t')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION
 
FUNCTION t200_u_img() # Update img_file
    DEFINE l_qty        LIKE img_file.img10,
           u_type       LIKE type_file.num5,         #No.FUN-680072 SMALLINT
           l_img01      LIKE img_file.img01          #add by liuxqa   091020 
 
    MESSAGE 'u_img!'
 
    MESSAGE 'update img_file ...'
    LET g_forupd_sql =
      " SELECT img01 FROM img_file ",    #mod by liuxqa 091020
      "   WHERE img01= ? ",
      "    AND img02= ? ",
      "    AND img03= ? ",
      "    AND img04= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock1 CURSOR FROM g_forupd_sql
    OPEN img_lock1 USING b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06
    IF STATUS THEN
       CALL cl_err("OPEN img_lock1:", STATUS, 1)
       LET g_success='N'
       CLOSE img_lock1
    END IF
    FETCH img_lock1 INTO l_img01    #mod by liuxqa 091020
    IF STATUS THEN
       CALL cl_err('lock img fail2',STATUS,1) LET g_success='N' RETURN
    END IF
   LET l_qty=b_fiw.fiw08*b_fiw.fiw07_fac
 
   CASE WHEN g_fiv.fiv00 ="1" LET u_type=+1
        WHEN g_fiv.fiv00 ="2" LET u_type=-1
   END CASE
   CALL s_upimg(b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,u_type,l_qty,g_today, #FUN-8C0084
                '','','','','','','','','','','','','','',0,0,'','')
   IF g_success = 'N' THEN
      CALL cl_err('u_upimg(-1)','9050',0) RETURN
   END IF
END FUNCTION

#No.FUN-A40023 ----mark---start--
##No.FUN-A20044 --- mark-start --- 
#{
#FUNCTION t200_u_ima() #------------------------------------ Update ima_file
#    DEFINE l_ima26,l_ima261,l_ima262    LIKE ima_file.ima26    
# 
#    MESSAGE "u_ima!"
#    LET l_ima26=0 LET l_ima261=0 LET l_ima262=0             
#    SELECT SUM(img10*img21) INTO l_ima26  FROM img_file    
#    WHERE img01=b_fiw.fiw03 AND img23='Y' AND img24='Y'    
#     
#    IF STATUS THEN 
#      CALL cl_err3("sel","img_file",b_fiw.fiw03,"",STATUS,"","sel sum1:",1)  #No.FUN-660092
#      LET g_success='N' 
#    END IF
#    IF l_ima26 IS NULL THEN LET l_ima26=0 END IF
#    SELECT SUM(img10*img21) INTO l_ima261 FROM img_file
#           WHERE img01=b_fiw.fiw03 AND img23='N'
#    IF STATUS THEN 
#       CALL cl_err3("sel","img_file",b_fiw.fiw03,"",STATUS,"","sel sum2:",1)  #No.FUN-660092
#       LET g_success='N'
#    END IF
#    IF l_ima261 IS NULL THEN LET l_ima261=0 END IF
#    SELECT SUM(img10*img21) INTO l_ima262 FROM img_file
#           WHERE img01=b_fiw.fiw03 AND img23='Y'
#    IF STATUS THEN 
#       CALL cl_err3("sel","img_file",b_fiw.fiw03,"",STATUS,"","sel sum3:",1)  #No.FUN-660092
#       LET g_success='N' 
#    END IF
#    IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
#    UPDATE ima_file SET
#                    ima26=l_ima26,ima261=l_ima261,ima262=l_ima262
#               WHERE ima01= b_fiw.fiw03
#    IF STATUS THEN
#       CALL cl_err3("upd","ima_file",b_fiw.fiw03,"",STATUS,"","upd ima26*:",1)  #No.FUN-660092
#       LET g_success='N'
#       RETURN
#    END IF
#    IF STATUS=100 THEN
#       CALL cl_err('upd ima26*:','mfg0177',1) LET g_success='N' RETURN
#    END IF
#END FUNCTION
#}
##No.FUN-A20044 ---mark-end ----
#No.FUN-A40023 ----mark---end-- 

FUNCTION t200_u_tlf() #------------------------------------ Update tlf_file
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131                                                           
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131                                                           
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
    MESSAGE "d_tlf!"
    #異動單號/項次
  ##NO.FUN-8C0131   add--begin                                                                                                      
    LET l_sql =  " SELECT  * FROM tlf_file ",                                                                                       
                 "  WHERE  tlf01 = '",b_fiw.fiw03,"'",                                                                              
                 "    AND ((tlf026='",g_fiv.fiv01,"' AND tlf027=",b_fiw.fiw02,")) OR ", 
                 "        (tlf036='",g_fiv.fiv01,"' AND tlf037=",b_fiw.fiw02,")) ", 
                 "   AND tlf06 ='",g_fiv.fiv05,"'"                                                                                  
    DECLARE t200_u_tlf_c CURSOR FROM l_sql                                                                                          
    LET l_i = 0                                                                                                                     
    CALL la_tlf.clear()                                                                                                             
    FOREACH t200_u_tlf_c INTO g_tlf.*                                                                                               
       LET l_i = l_i + 1                                                                                                            
       LET la_tlf[l_i].* = g_tlf.*                                                                                                  
    END FOREACH                                                                                                                     
                                                                                                                                    
  ##NO.FUN-8C0131   add--end 
    DELETE FROM tlf_file
     WHERE tlf01 =b_fiw.fiw03
       AND ((tlf026=g_fiv.fiv01 AND tlf027=b_fiw.fiw02)
        OR  (tlf036=g_fiv.fiv01 AND tlf037=b_fiw.fiw02))
       AND tlf06 =g_fiv.fiv05 #異動日期
    IF STATUS THEN
       CALL cl_err3("del","tlf_file",b_fiw.fiw03,g_fiv.fiv05,STATUS,"","del tlf:",1)  #No.FUN-660092
       LET g_success='N'
       RETURN 
    END IF
    IF STATUS=100 THEN
       CALL cl_err('del tlf:','mfg0177',1) LET g_success='N' RETURN
    END IF
  ##NO.FUN-8C0131   add--begin                                                                                                      
    FOR l_i = 1 TO la_tlf.getlength()                                                                                               
       LET g_tlf.* = la_tlf[l_i].*                                                                                                  
       IF NOT s_untlf1('') THEN                                                                                                     
          LET g_success='N' RETURN                                                                                                  
       END IF                                                                                                                       
    END FOR                                                                                                                         
  ##NO.FUN-8C0131   add--end
END FUNCTION
 
FUNCTION t200_y() #確認
    DEFINE l_fiw04 LIKE fiw_file.fiw04   #No.FUN-AB0058 add
    DEFINE l_n     LIKE type_file.num5   #No.FUN-CB0087 add

    IF g_fiv.fiv01 IS NULL THEN RETURN END IF
#CHI-C30107 -------- add -------- begin
    IF g_fiv.fivpost='X' THEN
       CALL cl_err(g_fiv.fiv01,'mfg1000',0)
       RETURN
    END IF
    IF g_fiv.fivconf='Y' THEN RETURN END IF
    IF g_fiv.fivpost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------- add -------- end
    SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01=g_fiv.fiv01
    IF g_fiv.fivpost='X' THEN
       CALL cl_err(g_fiv.fiv01,'mfg1000',0)
       RETURN
    END IF
    IF g_fiv.fivconf='Y' THEN RETURN END IF
    IF g_fiv.fivpost='Y' THEN RETURN END IF
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF      #TQC-750219 mod #CHI-C30107 mark
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t200_cl USING g_fiv.fiv01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_fiv.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)
        CLOSE t200_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE fiv_file SET fivconf='Y'
     WHERE fiv01 = g_fiv.fiv01
    IF STATUS THEN
       CALL cl_err3("upd","fiv_file",g_fiv.fiv01,"",STATUS,"","upd fivconf",1)  #No.FUN-660092
       LET g_success = 'N'
    END IF
    #No.FUN-AB0058  --Begin
    DECLARE t200_y_c2 CURSOR FOR
     SELECT fiw04 FROM fiw_file WHERE fiw01=g_fiv.fiv01
     FOREACH t200_y_c2 INTO l_fiw04
        IF SQLCA.sqlcode THEN
           LET g_showmsg = g_fiv.fiv01,'t200_y_c2 foreach:'
           CALL s_errmsg('fiv01',g_fiv.fiv01,g_showmsg,SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF NOT s_chk_ware(l_fiw04) THEN  #检查仓库是否属于当前门店
           LET g_success='N'
           RETURN
        END IF
    END FOREACH
    #No.FUN-AB0058  --End
    #FUN-CB0087--add--str--
    IF g_aza.aza115='Y' THEN
       SELECT COUNT(*) INTO l_n FROM fiw_file WHERE trim(fiw44) IS NULL AND fiw01=g_fiv.fiv01
       IF l_n>=1 THEN 
          CALL cl_err('','aim-888',1)
          LET g_success='N'
       END IF 
    END IF 
    #FUN-CB0087--add--end--
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT fivconf INTO g_fiv.fivconf FROM fiv_file
     WHERE fiv01 = g_fiv.fiv01
    DISPLAY BY NAME g_fiv.fivconf
END FUNCTION
 
FUNCTION t200_z() #取消確認
    IF g_fiv.fiv01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01=g_fiv.fiv01
    IF g_fiv.fivconf='N' THEN RETURN END IF
    IF g_fiv.fivpost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF       #TQC-750219  mod
 
    LET g_success='Y'
    BEGIN WORK
    OPEN t200_cl USING g_fiv.fiv01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_fiv.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)
        CLOSE t200_cl
        ROLLBACK WORK
        RETURN
    END IF
    UPDATE fiv_file SET fivconf='N'
        WHERE fiv01 = g_fiv.fiv01
    IF STATUS THEN
        CALL cl_err3("upd","fiv_file",g_fiv.fiv01,"",STATUS,"","upd cofconf",1)  #No.FUN-660092
        LET g_success='N'
    END IF
    IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_cmmsg(1)
    ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(1)
    END IF
    SELECT fivconf INTO g_fiv.fivconf FROM fiv_file
        WHERE fiv01 = g_fiv.fiv01
    DISPLAY BY NAME g_fiv.fivconf
END FUNCTION
 
FUNCTION t200_x()
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01=g_fiv.fiv01
   IF g_fiv.fiv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fiv.fivconf = 'Y' THEN CALL cl_err('',9022,0) RETURN END IF
   IF g_fiv.fivpost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 
   BEGIN WORK
 
   OPEN t200_cl USING g_fiv.fiv01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_fiv.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fiv.fiv01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   IF cl_void(0,0,g_fiv.fivpost) THEN
        LET g_chr = g_fiv.fivpost
        IF g_fiv.fivpost = 'N' THEN
            LET g_fiv.fivpost = 'X'
        ELSE
            LET g_fiv.fivpost = 'N'
        END IF
 
        UPDATE fiv_file
            SET fivpost = g_fiv.fivpost,
                fivmodu = g_user,
                fivdate = g_today
            WHERE fiv01 = g_fiv.fiv01
        IF SQLCA.sqlcode OR STATUS=100 THEN
            CALL cl_err3("upd","fiv_file",g_fiv.fiv01,"",SQLCA.sqlcode,"","up fivpost:",1)  #No.FUN-660092
        END IF
        DISPLAY BY NAME g_fiv.fivpost
    END IF
    CLOSE t200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t200_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fiv00,fiv01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fiv00,fiv01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t200_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    CALL cl_set_comp_entry("fiw09",TRUE)
    CALL cl_set_comp_entry("fiw20,fiw21,fiw22,fiw23,fiw24,fiw25",TRUE)
    CALL cl_set_comp_entry("fiw41,fiw42,fiw43,fiw44",TRUE) #FUN-810045
END FUNCTION
 
FUNCTION t200_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
      IF g_fiv.fiv00 = '2' THEN
         CALL cl_set_comp_entry("fiw09",FALSE)
      END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("fiw23,fiw24,fiw25",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("fiw23",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("fiw24,fiw21",FALSE)
   END IF
 
   IF g_fiv.fiv00 = "2" AND NOT cl_null(g_fiw[l_ac].fiw41) THEN
    CALL cl_set_comp_entry("fiw41,fiw42,fiw43",FALSE) 
   END IF
   IF g_fiv.fiv00 = "2" AND NOT cl_null(g_fiw[l_ac].fiw44) THEN
    CALL cl_set_comp_entry("fiw44",FALSE) 
   END IF
END FUNCTION
 
FUNCTION t200_g_b_1()
  DEFINE l_fit   RECORD LIKE fit_file.*
  DEFINE l_fim   RECORD LIKE fim_file.*
  DEFINE l_fiy   RECORD    #程式變數(Program Variables)
                 fiy03  LIKE fiy_file.fiy03,
                 fiy04  LIKE fiy_file.fiy04,
                 fiy05  LIKE fiy_file.fiy05
                 END RECORD
  DEFINE l_fac   LIKE img_file.img21
  DEFINE l_ima25 LIKE ima_file.ima25
  DEFINE l_fiw20 LIKE fiw_file.fiw20
  DEFINE l_fiw21 LIKE fiw_file.fiw21
  DEFINE l_fiw22 LIKE fiw_file.fiw22
  DEFINE l_fiw23 LIKE fiw_file.fiw23
  DEFINE l_fiw24 LIKE fiw_file.fiw24
  DEFINE l_fiw25 LIKE fiw_file.fiw25
  DEFINE l_i     LIKE type_file.num5          #No.FUN-680072 SMALLINT
  DEFINE l_fjb03 LIKE fjb_file.fjb03   #MOD-A10078
  DEFINE l_flag  LIKE type_file.chr1   #MOD-A10078 
 
    DROP TABLE t200_temp
    CREATE TEMP TABLE t200_temp(
              fiy03 LIKE fiy_file.fiy03,
              fiy04 LIKE fiy_file.fiy04,
              fiy05 LIKE fiy_file.fiy05)
 
    IF g_fiv.fiv02 IS NULL THEN RETURN END IF
 
    DECLARE t200_fiy_b_cur CURSOR FOR
     SELECT fiy03,fiy04,SUM(fiy05) FROM fiy_file
      WHERE fiy01 in ( SELECT fim03 FROM fim_file WHERE fim01 = g_fiv.fiv02 )
      GROUP BY fiy03,fiy04
      ORDER BY fiy03,fiy04
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare t200_fiy_b_cur',SQLCA.sqlcode,0)  
       RETURN
    END IF
    FOREACH t200_fiy_b_cur INTO l_fiy.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach t200_fiy_b_cur',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
        #-----MOD-A10078---------
        DECLARE fjb03_cur CURSOR FOR 
          SELECT fjb03 FROM fjb_file 
            WHERE fjb01 IN (SELECT fil03 FROM fil_file WHERE fil01=g_fiv.fiv02) 
        LET l_fjb03 = ''
        LET l_flag = '0'
        FOREACH fjb03_cur INTO l_fjb03
           IF l_fjb03 = l_fiy.fiy03 THEN
              LET l_flag = '1'
              EXIT FOREACH
           ELSE
              CONTINUE FOREACH
           END IF
        END FOREACH
        IF l_flag = '0' THEN
           CALL cl_err(l_fiy.fiy03,'aem-051',1)
           EXIT FOREACH
        END IF
        #-----END MOD-A10078-----
        SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_fiy.fiy03
        LET l_fac=1
        CALL s_umfchk(l_fiy.fiy03,l_fiy.fiy04,l_ima25)
             RETURNING g_cnt,l_fac
        IF g_cnt=1 THEN
           CALL cl_err('','abm-731',0)
           LET l_fac = 1
        END IF
        LET l_fiy.fiy05=l_fiy.fiy05*l_fac
 
        INSERT INTO t200_temp VALUES(l_fiy.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","t200_temp","","",SQLCA.sqlcode,"","insert t200_temp",1)  #No.FUN-660092
           EXIT FOREACH
        END IF
    END FOREACH
 
    DECLARE t200_fiw_b1_cur CURSOR FOR
     SELECT fiy03,fiy04,SUM(fiy05) FROM t200_temp
      GROUP BY fiy03,fiy04
      ORDER BY fiy03,fiy04
 
    LET l_i = 1
    FOREACH t200_fiw_b1_cur INTO l_fiy.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach t200_fiy_b_cur',SQLCA.sqlcode,0)  
           EXIT FOREACH
        END IF
        IF g_sma.sma115 = 'Y' THEN
           CALL t200_set_du_by_origin(l_fiy.fiy03,l_fiy.fiy04,l_fiy.fiy05)
                RETURNING g_fiw20,g_fiw21,g_fiw22,g_fiw23,g_fiw24,g_fiw25
        END IF
        INSERT INTO fiw_file(fiw01,fiw02,fiw03,fiw07,fiw07_fac,fiw08,fiw09,  #TQC-750218 add fiw09
                             fiw20,fiw21,fiw22,fiw23,fiw24,fiw25,
                             fiwplant,fiwlegal) #FUN-980002
        VALUES(g_fiv.fiv01,l_i,l_fiy.fiy03,l_fiy.fiy04,1,l_fiy.fiy05,'N',    #TQC-750218 add 'N'    
               g_fiw20,g_fiw21,g_fiw22,g_fiw23,g_fiw24,g_fiw25,
               g_plant,g_legal) #FUN-980002
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","fiw_file",g_fiv.fiv01,l_i,SQLCA.sqlcode,"","insert fiy_file",1)  #No.FUN-660092
           EXIT FOREACH
        END IF
        LET l_i=l_i+1
    END FOREACH
 
    CALL t200_b_fill(' 1=1')
 
END FUNCTION
 
FUNCTION t200_g_b_2()
  DEFINE l_fiw   RECORD    #程式變數(Program Variables)
                 fiw03      LIKE fiw_file.fiw03,
                 fiw04      LIKE fiw_file.fiw04,
                 fiw05      LIKE fiw_file.fiw05,
                 fiw06      LIKE fiw_file.fiw06,
                 fiw08      LIKE fiw_file.fiw08,
                 fiw23      LIKE fiw_file.fiw23,
                 fiw24      LIKE fiw_file.fiw24,
                 fiw25      LIKE fiw_file.fiw25,
                 fiw20      LIKE fiw_file.fiw20,
                 fiw21      LIKE fiw_file.fiw21,
                 fiw22      LIKE fiw_file.fiw22,
                 fiw41      LIKE fiw_file.fiw41,
                 fiw42      LIKE fiw_file.fiw42,
                 fiw43      LIKE fiw_file.fiw43,
                 fiw44      LIKE fiw_file.fiw44
                 END RECORD
  DEFINE l_fac   LIKE img_file.img21
  DEFINE l_ima25 LIKE ima_file.ima25
  DEFINE l_ima35 LIKE ima_file.ima35
  DEFINE l_ima36 LIKE ima_file.ima36
  DEFINE l_img09 LIKE img_file.img09
  DEFINE l_chr   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
  DEFINE l_i     LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
    IF g_fiv.fiv02 IS NULL THEN RETURN END IF
 
    DECLARE t200_fiw_b2_cur CURSOR FOR            #Total Issue Qty
     SELECT fiw03,fiw04,fiw05,fiw06,SUM(fiw07_fac*fiw08),
            fiw23,fiw24,SUM(fiw25),fiw20,fiw21,SUM(fiw22),  #FUN-580018
            fiw41,fiw42,fiw43,fiw44     #FUN-810045
       FROM fiw_file,fiv_file
      WHERE fiw01 = fiv01 AND fiv00 = '1'
        AND fivconf = 'Y' AND fivpost = 'Y'
        AND fiv02 = g_fiv.fiv02
      GROUP BY fiw03,fiw04,fiw05,fiw06,fiw23,fiw24,fiw20,fiw21, #FUN-580018
            fiw41,fiw42,fiw43,fiw44     #FUN-810045
      ORDER BY fiw03,fiw04,fiw05,fiw06,fiw23,fiw24,fiw20,fiw21 #FUN-580018
    IF SQLCA.sqlcode THEN
       CALL  cl_err('declare t200_fiw_b2_cur',SQLCA.sqlcode,0)   
       RETURN
    END IF
 
    LET l_i=1
    FOREACH t200_fiw_b2_cur INTO l_fiw.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach t200_fiw_b2_cur',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
 
        SELECT img09 INTO l_img09 FROM img_file
         WHERE img01 = l_fiw.fiw03
           AND img02 = l_fiw.fiw04
           AND img03 = l_fiw.fiw05
           AND img04 = l_fiw.fiw06
 
        SELECT ima25,ima35,ima36 INTO l_ima25,l_ima35,l_ima36
          FROM ima_file WHERE ima01=l_fiw.fiw03
        
        SELECT * FROM img_file
         WHERE img01 = l_fiw.fiw03
           AND img02 = l_ima35
           AND img03 = l_ima36
           AND img04 = ' '
        IF SQLCA.sqlcode THEN
           LET l_chr=g_sma.sma892[2,2]
           LET g_sma.sma892[2,2]='N'
           CALL s_add_img(l_fiw.fiw03,l_ima35,
                          l_ima36,' ',
                          g_fiv.fiv02,g_i,
                          g_fiv.fiv04)
           LET g_sma.sma892[2,2]=l_chr
        END IF
        
        LET l_fac=1
        IF l_img09 <> l_ima25 THEN
           CALL s_umfchk(l_fiw.fiw03,l_img09,l_ima25)
                RETURNING g_cnt,l_fac
           IF g_cnt=1 THEN
              CALL cl_err('','abm-731',0)
              LET l_fac = 1
           END IF
        END IF
 
        LET l_fiw.fiw08=l_fiw.fiw08*l_fac
        LET l_fiw.fiw08=s_digqty(l_fiw.fiw08,l_ima25)   #No.FUN-BB0086
 
        SELECT * FROM fiw_file
         WHERE fiw01=g_fiv.fiv01 AND fiw03=l_fiw.fiw03
           AND fiw04=l_ima35 AND fiw05=l_ima36 AND fiw06=' '
        #No.FUN-AA0062  --Begin
        IF NOT s_chk_ware(l_ima35) THEN
          LET l_ima35 = ''
          LET l_ima36 = ''
        END IF
        #No.FUN-AA0062  --End
        IF SQLCA.sqlcode =100 THEN
           INSERT INTO fiw_file(fiw01,fiw02,fiw03,fiw04,fiw05,
                                fiw06,fiw07,fiw07_fac,fiw08,fiw09,
                                fiw20,fiw21,fiw22,fiw23,fiw24,fiw25,
                                fiw41,fiw42,fiw43,fiw44 ,             #FUN-810045 add
                                fiwplant,fiwlegal) #FUN-980002
           VALUES(g_fiv.fiv01,l_i,l_fiw.fiw03,l_ima35,l_ima36,
                  ' ',l_ima25, 1, l_fiw.fiw08,'Y',l_fiw.fiw20,l_fiw.fiw21,
                  l_fiw.fiw22,l_fiw.fiw23,l_fiw.fiw24,l_fiw.fiw25,
                  l_fiw.fiw41,l_fiw.fiw42,l_fiw.fiw43,l_fiw.fiw44 ,  #FUN-810045
                  g_plant,g_legal) #FUN-980002
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","fiw_file",g_fiv.fiv01,l_i,SQLCA.sqlcode,"","insert fiw_file",1)  #No.FUN-660092
           ELSE
              LET l_i = l_i + 1
           END IF
        ELSE
           UPDATE fiw_file SET fiw08=fiw08+l_fiw.fiw08,
                               fiw22=fiw22+l_fiw.fiw22, #FUN-580018
                               fiw25=fiw25+l_fiw.fiw25  #FUN-580018
            WHERE fiw01=g_fiv.fiv01
              AND fiw03=l_fiw.fiw03
              AND fiw04=l_ima35
              AND fiw05=l_ima36
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","fiw_file",g_fiv.fiv01,l_fiw.fiw03,SQLCA.sqlcode,"","update fiw_file",1)  #No.FUN-660092
           END IF
        END IF
 
    END FOREACH
 
    DECLARE t200_fiw_b3_cur CURSOR FOR            #Total Return Qty
     SELECT fiw03,fiw04,fiw05,fiw06,SUM(fiw07_fac*fiw08),
            fiw23,fiw24,fiw25,fiw20,fiw21,fiw22  #FUN-580018
       FROM fiw_file,fiv_file
      WHERE fiw01 = fiv01 AND fiv00 = '2'
        AND fivconf = 'Y' AND fivpost = 'Y'
        AND fiv02 = g_fiv.fiv02
      GROUP BY fiw03,fiw04,fiw05,fiw06
      ORDER BY fiw03,fiw04,fiw05,fiw06
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare t200_fiw_b3_cur',SQLCA.sqlcode,0)  
       RETURN
    END IF
 
    FOREACH t200_fiw_b3_cur INTO l_fiw.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach t200_fiw_b3_cur',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
 
        SELECT img09 INTO l_img09 FROM img_file
         WHERE img01 = l_fiw.fiw03
           AND img02 = l_fiw.fiw04
           AND img03 = l_fiw.fiw05
           AND img04 = l_fiw.fiw06
 
        SELECT ima25,ima35,ima36 INTO l_ima25,l_ima35,l_ima36
          FROM ima_file WHERE ima01=l_fiw.fiw03
 
        #No.FUN-AA0062  --Begin
        IF NOT s_chk_ware(l_ima35) THEN
          LET l_ima35 = ''
          LET l_ima36 = ''
        END IF
        #No.FUN-AA0062  --End
        LET l_fac=1
        IF l_img09 <> l_ima25 THEN
           CALL s_umfchk(l_fiw.fiw03,l_img09,l_ima25)
                RETURNING g_cnt,l_fac
           IF g_cnt=1 THEN
              CALL cl_err('','abm-731',0)
              LET l_fac = 1
           END IF
        END IF
    
        LET l_fiw.fiw08=l_fiw.fiw08*l_fac
        LET l_fiw.fiw08=s_digqty(l_fiw.fiw08,l_ima25)   #No.FUN-BB0086
        UPDATE fiw_file SET fiw08=fiw08-l_fiw.fiw08,
                            fiw22=fiw22-l_fiw.fiw22, #FUN-580018
                            fiw25=fiw25-l_fiw.fiw25  #FUN-580018
         WHERE fiw01=g_fiv.fiv01
           AND fiw03=l_fiw.fiw03
           AND fiw04=l_ima35
           AND fiw05=l_ima36
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","fiw_file",g_fiv.fiv01,l_fiw.fiw03,SQLCA.sqlcode,"","update fiw_file",1)  #No.FUN-660092
        END IF
 
    END FOREACH
 
    CALL t200_b_fill(' 1=1')
 
END FUNCTION
 
FUNCTION t200_fiw08_check()
  DEFINE l_qty     LIKE fiw_file.fiw08
  DEFINE l_qty1    LIKE fiw_file.fiw08
  DEFINE l_qty2    LIKE fiw_file.fiw08
  DEFINE l_qty3    LIKE fiw_file.fiw08
  DEFINE l_ima25   LIKE ima_file.ima25
  DEFINE l_img09   LIKE img_file.img09
  DEFINE l_fac     LIKE img_file.img21
 
    IF g_fiw[l_ac].fiw03 IS NULL THEN RETURN END IF
    IF g_fiw[l_ac].fiw04 IS NULL THEN RETURN END IF
    IF g_fiw[l_ac].fiw05 IS NULL THEN LET g_fiw[l_ac].fiw05 = ' ' END IF
    IF g_fiw[l_ac].fiw06 IS NULL THEN LET g_fiw[l_ac].fiw06 = ' ' END IF
 
    SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=g_fiw[l_ac].fiw03
    IF SQLCA.sqlcode THEN
       RETURN
    END IF
 
    DECLARE t200_fiw08_cur_1 CURSOR FOR
     SELECT img09,SUM(fiw07_fac*fiw08)   #總發料量
       FROM fiw_file,fiv_file,img_file
      WHERE fiw01 = fiv01 AND fiv00 = '1'
        AND fivconf = 'Y' AND fivpost = 'Y'
        AND fiv02 = g_fiv.fiv02
        AND fiw03 = g_fiw[l_ac].fiw03
        AND img01 = fiw03 AND img02 = fiw04
        AND img03 = fiw05 AND img04 = fiw06
      GROUP BY img09
      ORDER BY img09
 
    LET l_qty1=0
    FOREACH t200_fiw08_cur_1 INTO l_img09,l_qty
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach t200_fiw08_cur_1',SQLCA.sqlcode,0)  
           EXIT FOREACH
        END IF
 
        IF cl_null(l_qty) THEN LET l_qty=0 END IF
        IF l_qty=0 THEN CONTINUE FOREACH END IF
 
        LET l_fac=1
        IF l_img09 <> l_ima25 THEN
           CALL s_umfchk(g_fiw[l_ac].fiw03,l_img09,l_ima25)
                RETURNING g_cnt,l_fac
           IF g_cnt=1 THEN
              CALL cl_err('','abm-731',0)
              LET l_fac = 1
           END IF
        END IF
        LET l_qty=l_qty*l_fac
        LET l_qty1=l_qty1+l_qty
    END FOREACH
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
 
    DECLARE t200_fiw08_cur_2 CURSOR FOR
     SELECT img09,SUM(fiw07_fac*fiw08)    #已退料量
       FROM fiw_file,fiv_file,img_file
      WHERE fiw01 = fiv01 AND fiv00 = '2'
        AND fivconf = 'Y' AND fivpost = 'Y'
        AND fiv02 = g_fiv.fiv02
        AND fiw03 = g_fiw[l_ac].fiw03
        AND img01 = fiw03 AND img02 = fiw04
        AND img03 = fiw05 AND img04 = fiw06
      GROUP BY img09
      ORDER BY img09
 
    LET l_qty2=0
    FOREACH t200_fiw08_cur_2 INTO l_img09,l_qty
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach t200_fiw08_cur_2',SQLCA.sqlcode,0)   
           EXIT FOREACH
        END IF
 
        IF cl_null(l_qty) THEN LET l_qty=0 END IF
        IF l_qty=0 THEN CONTINUE FOREACH END IF
 
        LET l_fac=1
        IF l_img09 <> l_ima25 THEN
           CALL s_umfchk(g_fiw[l_ac].fiw03,l_img09,l_ima25)
                RETURNING g_cnt,l_fac
           IF g_cnt=1 THEN
              CALL cl_err('','abm-731',0)
              LET l_fac = 1
           END IF
        END IF
        LET l_qty=l_qty*l_fac
        LET l_qty2=l_qty2+l_qty
    END FOREACH
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    DECLARE t200_fiw08_cur_3 CURSOR FOR
     SELECT img09,SUM(fiw07_fac*fiw08)    #當前退料單中已KEY的退料量
       FROM fiw_file,fiv_file,img_file
      WHERE fiw01 = fiv01 AND fiv00 = '2'
        AND fiv02 = g_fiv.fiv02
        AND fiw03 = g_fiw[l_ac].fiw03
        AND img01 = fiw03 AND img02 = fiw04
        AND img03 = fiw05 AND img04 = fiw06
        AND fiv01 = g_fiv.fiv01 AND fiw02 <> g_fiw[l_ac].fiw02
      GROUP BY img09
      ORDER BY img09
 
    LET l_qty3=0
    FOREACH t200_fiw08_cur_3 INTO l_img09,l_qty
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach t200_fiw08_cur_3',SQLCA.sqlcode,0)   
           EXIT FOREACH
        END IF
 
        IF cl_null(l_qty) THEN LET l_qty=0 END IF
        IF l_qty=0 THEN CONTINUE FOREACH END IF
 
        LET l_fac=1
        IF l_img09 <> l_ima25 THEN
           CALL s_umfchk(g_fiw[l_ac].fiw03,l_img09,l_ima25)
                RETURNING g_cnt,l_fac
           IF g_cnt=1 THEN
              CALL cl_err('','abm-731',0)
              LET l_fac = 1
           END IF
        END IF
        LET l_qty=l_qty*l_fac
        LET l_qty3=l_qty3+l_qty
    END FOREACH
    IF cl_null(l_qty3) THEN LET l_qty3=0 END IF
 
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = g_fiw[l_ac].fiw03 AND img02 = g_fiw[l_ac].fiw04
       AND img03 = g_fiw[l_ac].fiw05 AND img04 = g_fiw[l_ac].fiw06
 
    IF l_img09 <> l_ima25 THEN
       CALL s_umfchk(g_fiw[l_ac].fiw03,l_img09,l_ima25)
            RETURNING g_cnt,l_fac
       IF g_cnt=1 THEN
          CALL cl_err('','abm-731',0)
          LET l_fac = 1
       END IF
    END IF
    LET l_qty=g_fiw[l_ac].fiw07_fac*g_fiw[l_ac].fiw08*l_fac
 
    IF (l_qty > l_qty1-l_qty2-l_qty3) THEN   #都是庫存單位下的數量
       RETURN 1
    ELSE
       RETURN 0
    END IF
 
END FUNCTION
 
FUNCTION t200_set_required()
   #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_required("fiw23,fiw25,fiw20,fiw22",TRUE)
   END IF
   #單位不同,轉換率,數量必KEY
   IF NOT cl_null(g_fiw[l_ac].fiw20) THEN
      CALL cl_set_comp_required("fiw22",TRUE)
   END IF
   IF NOT cl_null(g_fiw[l_ac].fiw23) THEN
      CALL cl_set_comp_required("fiw25",TRUE)
   END IF
END FUNCTION
 
FUNCTION t200_set_no_required()
 
  CALL cl_set_comp_required("fiw23,fiw24,fiw25,fiw20,fiw21,fiw22",FALSE)
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t200_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,     #No.FUN-680072 VARCHAR(1)
            l_factor LIKE img_file.img21      #No.FUN-680072 DECIMAL(16,8)
 
    LET l_item = g_fiw[l_ac].fiw03
 
    SELECT ima25,ima906,ima907
      INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_ima25,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
 
    LET l_unit1 = l_ima25
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF p_cmd = 'a' THEN
       LET g_fiw[l_ac].fiw23=l_unit2
       LET g_fiw[l_ac].fiw24=l_fac2
       LET g_fiw[l_ac].fiw25=l_qty2
       LET g_fiw[l_ac].fiw20=l_unit1
       LET g_fiw[l_ac].fiw21=l_fac1
       LET g_fiw[l_ac].fiw22=l_qty1
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t200_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE fiw_file.fiw24,
            l_qty2   LIKE fiw_file.fiw25,
            l_fac1   LIKE fiw_file.fiw21,
            l_qty1   LIKE fiw_file.fiw22,
            l_factor LIKE img_file.img21,     #No.FUN-680072DEC(16,8)
            l_ima25  LIKE ima_file.ima25
 
    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25 INTO l_ima25
      FROM ima_file WHERE ima01=g_fiw[l_ac].fiw03
    LET l_fac2=g_fiw[l_ac].fiw24
    LET l_qty2=g_fiw[l_ac].fiw25
    LET l_fac1=g_fiw[l_ac].fiw21
    LET l_qty1=g_fiw[l_ac].fiw22
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_fiw[l_ac].fiw07=g_fiw[l_ac].fiw20
                   LET g_fiw[l_ac].fiw08=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_fiw[l_ac].fiw07=l_ima25
                   LET g_fiw[l_ac].fiw08=l_tot
                   LET g_fiw[l_ac].fiw08=s_digqty(g_fiw[l_ac].fiw08,g_fiw[l_ac].fiw07)   #No.FUN-BB0086
          WHEN '3' LET g_fiw[l_ac].fiw07=g_fiw[l_ac].fiw20
                   LET g_fiw[l_ac].fiw08=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_fiw[l_ac].fiw24=l_qty1/l_qty2
                   ELSE
                      LET g_fiw[l_ac].fiw24=0
                   END IF
       END CASE
    END IF
 
    LET g_factor = 1
    CALL s_umfchk(g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw07,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    LET g_fiw[l_ac].fiw07_fac = g_factor
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t200_du_data_to_correct()
 
   IF cl_null(g_fiw[l_ac].fiw20) THEN
      LET g_fiw[l_ac].fiw21 = NULL
      LET g_fiw[l_ac].fiw22 = NULL
   END IF
 
   IF cl_null(g_fiw[l_ac].fiw23) THEN
      LET g_fiw[l_ac].fiw24 = NULL
      LET g_fiw[l_ac].fiw25 = NULL
   END IF
 
   DISPLAY BY NAME g_fiw[l_ac].fiw21
   DISPLAY BY NAME g_fiw[l_ac].fiw22
   DISPLAY BY NAME g_fiw[l_ac].fiw24
   DISPLAY BY NAME g_fiw[l_ac].fiw25
 
END FUNCTION
 
FUNCTION t200_check_inventory_qty(p_img10)
   DEFINE l_img10   LIKE img_file.img10
   DEFINE p_img10   LIKE img_file.img10
   DEFINE l_i       LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
   IF g_sma.sma117 = 'N' THEN   #No.FUN-610090
      IF NOT cl_null(g_fiw[l_ac].fiw08) THEN
         LET l_img10 = p_img10
         IF g_fiv.fiv00 = "1" THEN
            IF g_fiw[l_ac].fiw08 * g_fiw[l_ac].fiw07_fac > l_img10 THEN
               LET l_flag01 = NULL    #FUN-C80107 add
               #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_fiw[l_ac].fiw04) RETURNING l_flag01   #FUN-C80107 add #FUN-D30024--mark
               CALL s_inv_shrt_by_warehouse(g_fiw[l_ac].fiw04,g_plant) RETURNING l_flag01     #FUN-D30024--add  #TQC-D40078 g_plant
              #IF g_sma.sma894[1,1]='N' THEN    ##FUN-C80107 mark
               IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
                  CALL cl_err(g_fiw[l_ac].fiw08*g_fiw[l_ac].fiw07_fac,'mfg1303',1)
                  RETURN 1
               ELSE
                  IF NOT cl_confirm('mfg3469') THEN
                     RETURN 1
                  END IF
               END IF
            END IF
         ELSE
            CALL t200_fiw08_check() RETURNING l_i
            IF l_i=1 THEN
               CALL cl_err(g_fiw[l_ac].fiw08,'aem-022',0)
               RETURN 1
            END IF
         END IF
      END IF
   END IF
   RETURN 0
 
END FUNCTION
 
FUNCTION t200_set_du_by_origin(p_fiw03,p_fiw07,p_fiw08)
DEFINE  l_ima25      LIKE ima_file.ima25
DEFINE  l_ima906     LIKE ima_file.ima906
DEFINE  l_ima907     LIKE ima_file.ima907
DEFINE  l_cnt        LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  l_factor     LIKE fiw_file.fiw24
DEFINE  p_fiw03      LIKE fiw_file.fiw03
DEFINE  p_fiw07      LIKE fiw_file.fiw07
DEFINE  p_fiw08      LIKE fiw_file.fiw08
DEFINE  l_fiw20      LIKE fiw_file.fiw20
DEFINE  l_fiw21      LIKE fiw_file.fiw21
DEFINE  l_fiw22      LIKE fiw_file.fiw22
DEFINE  l_fiw23      LIKE fiw_file.fiw23
DEFINE  l_fiw24      LIKE fiw_file.fiw24
DEFINE  l_fiw25      LIKE fiw_file.fiw25
 
      SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
        FROM ima_file WHERE ima01=p_fiw03
      LET l_fiw20=p_fiw07
      LET l_factor = 1
      CALL s_umfchk(p_fiw03,l_fiw20,l_ima25)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET l_fiw21=l_factor
      LET l_fiw22=p_fiw08
      LET l_fiw23=l_ima907
      LET l_factor = 1
      CALL s_umfchk(p_fiw03,l_fiw23,l_ima25)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET l_fiw24=l_factor
      LET l_fiw25=0
      IF l_ima906 = '3' THEN
         LET l_factor = 1
         CALL s_umfchk(p_fiw03,l_fiw20,l_fiw23)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET l_fiw25=l_fiw22*l_factor
         LET l_fiw25=s_digqty(l_fiw25,l_fiw23)   #No.FUN-BB0086
      END IF
      RETURN l_fiw20,l_fiw21,l_fiw22,l_fiw23,l_fiw24,l_fiw25
 
END FUNCTION
 
FUNCTION t200_update_du(p_type)
DEFINE l_ima25   LIKE ima_file.ima25,
       u_type    LIKE type_file.num5,             #No.FUN-680072SMALLINT
       p_type    LIKE type_file.chr1              #No.FUN-680072CHAR(1)
 
   IF g_sma.sma115 = 'N' THEN RETURN END IF
 
   IF p_type = 's' THEN
      CASE WHEN g_fiv.fiv00 ="1" LET u_type=-1
           WHEN g_fiv.fiv00 ="2" LET u_type=+1
      END CASE
   ELSE
      CASE WHEN g_fiv.fiv00 ="1" LET u_type=+1
           WHEN g_fiv.fiv00 ="2" LET u_type=-1
      END CASE
   END IF
 
   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    WHERE ima01 = b_fiw.fiw03
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01 = b_fiw.fiw03
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(b_fiw.fiw23) THEN
         CALL t200_upd_imgg('1',b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,
                         b_fiw.fiw06,b_fiw.fiw23,b_fiw.fiw24,b_fiw.fiw25,u_type,'2')
         IF g_success='N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(b_fiw.fiw25) THEN                                         #CHI-860005
               CALL t200_tlff(b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,l_ima25,
                              b_fiw.fiw25,0,b_fiw.fiw23,b_fiw.fiw24,u_type,'2')
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF NOT cl_null(b_fiw.fiw20) THEN
         CALL t200_upd_imgg('1',b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,
                            b_fiw.fiw06,b_fiw.fiw20,b_fiw.fiw21,b_fiw.fiw22,u_type,'1')
         IF g_success='N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(b_fiw.fiw22) THEN                                          #CHI-860005
               CALL t200_tlff(b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,l_ima25,
                           b_fiw.fiw22,0,b_fiw.fiw20,b_fiw.fiw21,u_type,'1')
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF p_type = 't' THEN
         CALL t200_tlff_w()
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(b_fiw.fiw23) THEN
         CALL t200_upd_imgg('2',b_fiw.fiw03,b_fiw.fiw04,b_fiw.fiw05,
                            b_fiw.fiw06,b_fiw.fiw23,b_fiw.fiw24,b_fiw.fiw25,u_type,'2')
         IF g_success = 'N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(b_fiw.fiw25) THEN                                           #CHI-860005  
               CALL t200_tlff(b_fiw.fiw04,b_fiw.fiw05,b_fiw.fiw06,l_ima25,
                              b_fiw.fiw25,0,b_fiw.fiw23,b_fiw.fiw24,u_type,'2')
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF p_type = 't' THEN
         CALL t200_tlff_w()
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t200_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
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
         l_imgg01   LIKE imgg_file.imgg01,        #add by liuxqa 091020
         p_no       LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
         p_type     LIKE type_file.num10          #No.FUN-680072 INTEGER
 
    LET g_forupd_sql =
        "SELECT imgg01 FROM imgg_file ",          #mod by liuxqa 091020
        " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO l_imgg01      #mod by liuxqa 091020 
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-660092
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_fiv.fiv04, #FUN-8C0083
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t200_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag)
DEFINE
#  l_ima262   LIKE ima_file.ima262,     #FUN-A20044
   l_avl_stk   LIKE type_file.num15_3,  #FUN-A20044
   l_ima25    LIKE ima_file.ima25,
   l_ima55    LIKE ima_file.ima55,
   l_ima86    LIKE ima_file.ima86,
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位
   p_lot      LIKE img_file.img04,     	 ##批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_img10    LIKE img_file.img10,       ##異動後數量
   l_imgg10   LIKE imgg_file.imgg10,
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   u_type     LIKE type_file.num5,       ##+1:雜收 -1:雜發  0:報廢  #No.FUN-680072 SMALLINT
   p_flag     LIKE type_file.chr1,                                  #No.FUN-680072 VARCHAR(1)
   g_cnt      LIKE type_file.num5                                   #No.FUN-680072 SMALLINT
 
#  CALL s_getima(b_fiw.fiw03) RETURNING l_ima262,l_ima25,l_ima55,l_ima86  #No.FUN-A20044
   CALL s_getima(b_fiw.fiw03) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86 #No.FUN-A20044

   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
   IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
   IF p_uom IS NULL THEN
      CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
   END IF
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=b_fiw.fiw03 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
   INITIALIZE g_tlff.* TO NULL
 
   LET g_tlff.tlff01=b_fiw.fiw03         #異動料件編號
   IF g_fiv.fiv00 ='2' THEN
      #----來源----
      LET g_tlff.tlff02=90
      LET g_tlff.tlff026=g_fiv.fiv02        #來源單號
      #---目的----
      LET g_tlff.tlff03=50                  #'Stock'
      LET g_tlff.tlff030=g_plant
      LET g_tlff.tlff031=p_ware             #倉庫
      LET g_tlff.tlff032=p_loca             #儲位
      LET g_tlff.tlff033=p_lot              #批號
      LET g_tlff.tlff034=l_imgg10           #異動後數量
      LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlff.tlff036=b_fiw.fiw01        #雜收單號
      LET g_tlff.tlff037=b_fiw.fiw02        #雜收項次
   END IF
   IF g_fiv.fiv00 ='1' THEN
      #----來源----
      LET g_tlff.tlff02=50                  #'Stock'
      LET g_tlff.tlff020=g_plant
      LET g_tlff.tlff021=p_ware             #倉庫
      LET g_tlff.tlff022=p_loca             #儲位
      LET g_tlff.tlff023=p_lot              #批號
      LET g_tlff.tlff024=l_imgg10           #異動後數量
      LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlff.tlff026=b_fiw.fiw01        #雜發/報廢單號
      LET g_tlff.tlff027=b_fiw.fiw02        #雜發/報廢項次
      #---目的----
      LET g_tlff.tlff03 =90
      LET g_tlff.tlff036=g_fiv.fiv02        #目的單號
   END IF
   LET g_tlff.tlff06=g_fiv.fiv05      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_uom			#發料單位
   LET g_tlff.tlff12 =p_factor        #發料/庫存 換算率
   CASE WHEN g_fiv.fiv00 = '1' LET g_tlff.tlff13='aemt201'
        WHEN g_fiv.fiv00 = '2' LET g_tlff.tlff13='aemt202'
   END CASE
   LET g_tlff.tlff17=g_fiv.fiv03              #Remark                           
   LET g_tlff.tlff19=g_fiv.fiv06                                                
   LET g_tlff.tlff20=g_fiv.fiv07              #Project code                     
                                                                                
   LET g_tlff.tlff61= g_ima86                                                   
   IF cl_null(b_fiw.fiw25) OR b_fiw.fiw25=0 THEN                                
      CALL s_tlff(p_flag,NULL)                                                  
   ELSE                                                                         
      CALL s_tlff(p_flag,b_fiw.fiw23)                                           
   END IF                                                                       
END FUNCTION  
 
 
FUNCTION t200_tlff_w()                                                          
                                                                                
    MESSAGE "d_tlff!"                                                           
    CALL ui.Interface.refresh()                                                 
                                                                                
    DELETE FROM tlff_file                                                       
     WHERE tlff01 =b_fiw.fiw03                                                  
       AND ((tlff026=g_fiv.fiv01 AND tlff027=b_fiw.fiw02) OR                    
            (tlff036=g_fiv.fiv01 AND tlff037=b_fiw.fiw02)) #異動單號/項次       
       AND tlff06 =g_fiv.fiv04 #異動日期                                        
                                                                                
    IF STATUS THEN                                                              
       CALL cl_err3("del","tlff_file",b_fiw.fiw03,g_fiv.fiv04,STATUS,"","del tlff:",1)  #No.FUN-660092
       LET g_success='N' 
       RETURN
     END IF
END FUNCTION
 
FUNCTION t200_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("fiw23,fiw25,fiw20,fiw22",FALSE)
      CALL cl_set_comp_visible("fiw07,fiw07_fac,fiw08",TRUE)
   ELSE
      CALL cl_set_comp_visible("fiw23,fiw25,fiw20,fiw22",TRUE)
      CALL cl_set_comp_visible("fiw07,fiw07_fac,fiw08",FALSE)
   END IF
   CALL cl_set_comp_visible("fiw24,fiw21",FALSE)
   CALL cl_set_comp_visible("fiv07,fiw41,fiw42,fiw43",g_aza.aza08 = 'Y') #FUN-810045 add  #FUN-CB0087 remove fiw44
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("fiw23",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("fiw25",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("fiw20",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("fiw22",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("fiw23",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("fiw25",g_msg CLIPPED)
      CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("fiw20",g_msg CLIPPED)
      CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("fiw22",g_msg CLIPPED)
   END IF
   IF g_aza.aza115='Y' THEN CALL cl_set_comp_required('fiw44',TRUE) END IF #FUN-CB0087 add
END FUNCTION
 
FUNCTION t200_rvbs()
  DEFINE b_rvbs  RECORD  LIKE rvbs_file.*
 
  LET b_rvbs.rvbs00 = g_prog
  LET b_rvbs.rvbs01 = g_fiv.fiv01
  LET b_rvbs.rvbs02 = g_fiw[l_ac].fiw02
  LET b_rvbs.rvbs021 = g_fiw[l_ac].fiw03
  LET b_rvbs.rvbs06 = g_fiw[l_ac].fiw08 * g_fiw[l_ac].fiw07_fac  #數量*庫存單位換算率
  LET b_rvbs.rvbs08 = g_fiw[l_ac].fiw41
  
  CASE g_fiv.fiv00
  WHEN "1" #出庫
        LET b_rvbs.rvbs09 = -1
        CALL s_ins_rvbs("1",b_rvbs.*)
  WHEN "2" #入庫 
        LET b_rvbs.rvbs09 = 1  #1入庫  -1 出庫
        CALL s_ins_rvbs("2",b_rvbs.*)
  END CASE
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001,002,003,004,005,006> #
#Patch....NO.TQC-610035 <001> #
#No.FUN-9C0072 精簡程式碼

#No.FUN-BB0086--add--begin--
FUNCTION t200_fiw08_check_1(l_img10,l_i)
DEFINE l_i          LIKE type_file.num5
DEFINE l_img10   LIKE img_file.img10
   IF NOT cl_null(g_fiw[l_ac].fiw08) AND NOT cl_null(g_fiw[l_ac].fiw07) THEN
      IF cl_null(g_fiw_t.fiw08) OR cl_null(g_fiw07_t) OR g_fiw_t.fiw08 != g_fiw[l_ac].fiw08 OR g_fiw07_t != g_fiw[l_ac].fiw07 THEN
         LET g_fiw[l_ac].fiw08=s_digqty(g_fiw[l_ac].fiw08,g_fiw[l_ac].fiw07)
         DISPLAY BY NAME g_fiw[l_ac].fiw08
      END IF
   END IF

   IF NOT cl_null(g_fiw[l_ac].fiw08) THEN
      IF g_fiv.fiv00 = "1" THEN
         IF g_fiw[l_ac].fiw08*g_fiw[l_ac].fiw07_fac > l_img10 THEN
            #FUN-D30024---modify---str---
            LET l_flag01 = NULL
            CALL s_inv_shrt_by_warehouse(g_fiw[l_ac].fiw04,g_plant) RETURNING l_flag01        #TQC-D40078 g_plant
            IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
            #IF g_sma.sma894[1,1]='N' THEN
            #FUN-D30024---modify---end---
               CALL cl_err(g_fiw[l_ac].fiw08*g_fiw[l_ac].fiw07_fac,'mfg1303',1)
               RETURN FALSE 
            ELSE
               IF NOT cl_confirm('mfg3469') THEN
                  RETURN FALSE 
               END IF
            END IF
         END IF
      ELSE
         CALL t200_fiw08_check() RETURNING l_i
         IF l_i=1 THEN
            CALL cl_err(g_fiw[l_ac].fiw08,'aem-022',0)
            RETURN FALSE 
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t200_fiw22_check(l_img10)
DEFINE l_img10   LIKE img_file.img10
   IF NOT cl_null(g_fiw[l_ac].fiw22) AND NOT cl_null(g_fiw[l_ac].fiw20) THEN
      IF cl_null(g_fiw_t.fiw22) OR cl_null(g_fiw20_t) OR g_fiw_t.fiw22 != g_fiw[l_ac].fiw22 OR g_fiw20_t != g_fiw[l_ac].fiw20 THEN
         LET g_fiw[l_ac].fiw22=s_digqty(g_fiw[l_ac].fiw22,g_fiw[l_ac].fiw20)
         DISPLAY BY NAME g_fiw[l_ac].fiw22
      END IF
   END IF

  IF NOT cl_null(g_fiw[l_ac].fiw22) THEN
      IF g_fiw[l_ac].fiw22 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE,'fiw22'
      END IF
   END IF

   CALL t200_set_origin_field()
   CALL t200_check_inventory_qty(l_img10)
       RETURNING g_flag
   IF g_flag = '1' THEN
      IF g_ima906 = '3' OR g_ima906 = '2' THEN
         RETURN FALSE,'fiw25'
      ELSE
         RETURN FALSE,'fiw22'
      END IF
   END IF
   CALL cl_show_fld_cont()                   
   RETURN TRUE,''
END FUNCTION 

FUNCTION t200_fiw25_check(p_cmd,l_i)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_i          LIKE type_file.num5
   IF NOT cl_null(g_fiw[l_ac].fiw25) AND NOT cl_null(g_fiw[l_ac].fiw23) THEN
      IF cl_null(g_fiw_t.fiw25) OR cl_null(g_fiw23_t) OR g_fiw_t.fiw25 != g_fiw[l_ac].fiw25 OR g_fiw23_t != g_fiw[l_ac].fiw23 THEN
         LET g_fiw[l_ac].fiw25=s_digqty(g_fiw[l_ac].fiw25,g_fiw[l_ac].fiw23)
         DISPLAY BY NAME g_fiw[l_ac].fiw25
      END IF
   END IF

   IF NOT cl_null(g_fiw[l_ac].fiw25) THEN
      IF g_fiw[l_ac].fiw25 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE 
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_fiw_t.fiw25 <> g_fiw[l_ac].fiw25 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_fiw[l_ac].fiw25*g_fiw[l_ac].fiw24
            IF cl_null(g_fiw[l_ac].fiw22) OR g_fiw[l_ac].fiw22=0 THEN 
               LET g_fiw[l_ac].fiw22=g_tot*g_fiw[l_ac].fiw21
               LET g_fiw[l_ac].fiw22=s_digqty(g_fiw[l_ac].fiw22,g_fiw[l_ac].fiw20)   #No.FUN-BB0086
               DISPLAY BY NAME g_fiw[l_ac].fiw22                      
            END IF                                                    
         END IF
      END IF
   END IF
   CALL cl_show_fld_cont()                           
   RETURN TRUE
END FUNCTION 
#No.FUN-BB0086--add--end--

#FUN-CB0087--add--str--
FUNCTION t200_fiw44_check()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5
DEFINE l_azf09       LIKE azf_file.azf09

   LET l_flag = FALSE 
   IF cl_null(g_fiw[l_ac].fiw44) THEN RETURN TRUE END IF 
   IF g_aza.aza115='Y' THEN 
      CALL s_get_where(g_fiv.fiv01,g_fiv.fiv02,'',g_fiw[l_ac].fiw03,g_fiw[l_ac].fiw04,'',g_fiv.fiv06) RETURNING l_flag,l_where
   END IF 
   IF g_aza.aza115='Y' AND l_flag THEN
      LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_fiw[l_ac].fiw44,"' AND ",l_where
      PREPARE ggc08_pre1 FROM l_sql
      EXECUTE ggc08_pre1 INTO l_n
      IF l_n < 1 THEN
         CALL cl_err(g_fiw[l_ac].fiw44,'aim-425',0)
         RETURN FALSE 
      END IF
   ELSE 
      SELECT COUNT(*) INTO g_cnt FROM azf_file     
       WHERE azf01=g_fiw[l_ac].fiw44 AND azf02='2' AND azfacti='Y'
      IF g_cnt = 0 THEN
         CALL cl_err(g_fiw[l_ac].fiw44,'asf-453',0)
         RETURN FALSE 
      END IF
      SELECT azf09 INTO l_azf09 FROM azf_file     
       WHERE azf01=g_fiw[l_ac].fiw44 AND azf02='2' AND azfacti='Y'
      IF l_azf09 != '4' THEN
         CALL cl_err(g_fiw[l_ac].fiw44,'aoo-403',0)
         RETURN FALSE 
      END IF
   END IF  
   RETURN TRUE 
END FUNCTION 

FUNCTION t200_fiw44_chkall()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_azf09       LIKE azf_file.azf09

   IF g_fiw.getLength() = 0 THEN RETURN TRUE END IF 
   IF g_aza.aza115='Y' THEN 
      FOR l_cnt=1 TO g_fiw.getLength()
         CALL s_get_where(g_fiv.fiv01,g_fiv.fiv02,'',g_fiw[l_cnt].fiw03,g_fiw[l_cnt].fiw04,'',g_fiv.fiv06) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n = 0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_fiw[l_cnt].fiw44,"' AND ",l_where
            PREPARE ggc08_pre2 FROM l_sql
            EXECUTE ggc08_pre2 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE 
            END IF
         ELSE
            SELECT COUNT(*) INTO l_n FROM azf_file
             WHERE azf01=g_fiw[l_cnt].fiw44 AND azf02='2' AND azfacti='Y'
            IF l_n = 0 THEN
               CALL cl_err(g_fiw[l_cnt].fiw44,'asf-453',0)
               RETURN FALSE
            END IF
            SELECT azf09 INTO l_azf09 FROM azf_file
             WHERE azf01=g_fiw[l_cnt].fiw44 AND azf02='2' AND azfacti='Y'
            IF l_azf09 != '4' THEN
               CALL cl_err(g_fiw[l_cnt].fiw44,'aoo-403',0)
               RETURN FALSE
            END IF
         END IF 
      END FOR 
   END IF  
   RETURN TRUE 
END FUNCTION 
#FUN-CB0087--add--end--
#TQC-D20042---add---str---
FUNCTION t200_azf03_desc()
   LET g_fiw[l_ac].azf03 = ''
   IF NOT cl_null(g_fiw[l_ac].fiw44) THEN
      SELECT azf03 INTO g_fiw[l_ac].azf03 FROM azf_file WHERE azf01=g_fiw[l_ac].fiw44 AND azf02='2'
   END IF
   DISPLAY BY NAME g_fiw[l_ac].azf03 
END FUNCTION
#TQC-D20042---add---end---
