# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi500.4gl
# Descriptions...: 產品結構資料維護作業
# Date & Author..: NO.FUN-A50089 10/05/21 By destiny 
# Modify.........: No.FUN-A60083 10/07/10 By destiny 平行工藝
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No.FUN-A70143 10/07/30 By destiny 平行工藝
# Modify.........: No.TQC-A80112 10/08/24 By destiny 更新标准BOM时不要更新项次
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.CHI-AC0037 10/12/31 By lixh1  控卡單身為回收料時,bmb06可以為負,但不可為0
# Modify.........: No.FUN-AC0076 11/01/04 By wangxin 加action串查abmi612
# Modify.........: No.FUN-B10013 11/01/21 By lixh1  新增'拋轉資料'和'資料拋磚歷史'ACTION
# Modify.........: No.FUN-B10018 11/01/26 By vealxu 發放還原調整
# Modify.........: No.TQC-B20087 11/02/17 By jan 1.標準產品BOM否給預設值 2.發放後修改單身資料,重新產生的abmi600資料有誤
# Modify.........: No.FUN-B20101 11/02/28 By shenyang 將abmi500改成三階結構
# Modify.........: No.FUN-B30033 11/03/10 By shenyang 將abmi500改成三階結構
# Modify.........: No.MOD-B30509 11/03/15 By shenyang 修改aabmi500 bug 
# Modify.........: No.MOD-B30502 11/03/15 By shenyang 修改aabmi500 bug
# Modify.........: No.MOD-B30511 11/03/15 By shenyang 修改aabmi500 bug
# Modify.........: No.MOD-B30505 11/03/17 BY shenyang  修改複製
# Modify.........: No.TQC-B40076 11/04/17 BY destiny 进入到工艺序栏位后如果不输入值就无法离开此栏位,造成输入不便 
# Modify.........: No.TQC-B30173 11/04/19 BY destiny 开启作业后第一次点bom预览无响应
# Modify.........: No.TQC-B40144 11/04/24 BY destiny 現在確定即會退出單身輸入，不進入單身二輸入，為避免用戶錯誤操作誤刪資料，MRAK掉自動刪除單頭功能
# Modify.........: No.TQC-B60249 11/06/22 BY lixh1 過濾掉單身以失效的資料  
# Modify.........: No.TQC-B60234 11/06/22 BY suncx BOM預覽BUG修改   
# Modify.........: No.FUN-B80100 11/08/11 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-B80108 11/08/11 By xianghui 處理元件單身資料顯示不是及時顯示的問題
# Modify.........: No.FUN-BB0085 11/12/06 By xianghui 增加數量欄位小數取位
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No.TQC-C50256 12/06/04 By fengrui 錯誤信息重複提示問題
# Modify.........: No.CHI-C30107 12/06/05 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/12 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40105 13/04/27 By dongsz bom預覽時，抓取組成用量的總和

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"  
#No.FUN-A50089 
#模組變數(Module Variables)
DEFINE
    tm              RECORD
        plant       ARRAY[20]  OF LIKE azp_file.azp01,   
        dbs         ARRAY[20]  OF LIKE type_file.chr21 
                    END RECORD,
    g_bra           RECORD LIKE bra_file.*,       #主件料件(假單頭)
    g_bra_t         RECORD LIKE bra_file.*,       #主件料件(舊值)
    g_bra_o         RECORD LIKE bra_file.*,       #主件料件(舊值)
    g_bra01_t       LIKE bra_file.bra01,   #(舊值)#單頭KEY值
    g_bra06_t       LIKE bra_file.bra06,   #(舊值)#單頭KEY值
    g_bra011_t      LIKE bra_file.bra011,   #(舊值)#單頭KEY值
   #g_bra012_t      LIKE bra_file.bra012,   #(舊值)#單頭KEY值   #FUN-B20101
   #g_bra013_t      LIKE bra_file.bra013,   #(舊值)#單頭KEY值   #FUN-B20101
    g_brb10_fac_t   LIKE brb_file.brb10_fac,   #(舊值)
    g_ima08_h       LIKE ima_file.ima08,   #來源碼
    g_ima37_h       LIKE ima_file.ima37,   #補貨政策
    g_ima08_b       LIKE ima_file.ima08,   #來源碼
    g_ima37_b       LIKE ima_file.ima37,   #補貨政策
    g_ima25_b       LIKE ima_file.ima25,   #庫存單位
    g_ima63_b       LIKE ima_file.ima63,   #發料單位
    g_ima70_b       LIKE ima_file.ima63,   #消耗料件
    g_ima86_b       LIKE ima_file.ima86,   #成本單位
    g_ima107_b      LIKE ima_file.ima107,  #LOCATION
    g_ima04         LIKE ima_file.ima04,   
    g_db_type       LIKE type_file.chr3,  
   #FUN-B20101--add--begin
    g_bra1          DYNAMIC ARRAY OF RECORD 
                    bra012  LIKE bra_file.bra012,
                    ecu014  LIKE ecu_file.ecu014,
                    bra013  LIKE bra_file.bra013,
                    ecb06   LIKE ecb_file.ecb06,
                    ecb17   LIKE ecb_file.ecb17
                    END RECORD,
    g_bra1_t        RECORD
                    bra012  LIKE bra_file.bra012,
                    ecu014  LIKE ecu_file.ecu014,
                    bra013  LIKE bra_file.bra013,
                    ecb06   LIKE ecb_file.ecb06,
                    ecb17   LIKE ecb_file.ecb17
                    END RECORD, 
    g_bra1_o        RECORD
                    bra012  LIKE bra_file.bra012,
                    ecu014  LIKE ecu_file.ecu014,
                    bra013  LIKE bra_file.bra013,
                    ecb06   LIKE ecb_file.ecb06,
                    ecb17   LIKE ecb_file.ecb17
                    END RECORD,       
    g_bra2           RECORD LIKE bra_file.*,            
    #FUN-B20101--add--end 
    g_brb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)    	              
                    brb02    LIKE brb_file.brb02,       #元件項次
                    brb30    LIKE brb_file.brb30,       #計算方式 
                    brb03    LIKE brb_file.brb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    brb09    LIKE brb_file.brb09,       #作業編號
                    brb16    LIKE brb_file.brb16,       #UTE/SUB
                    brb14    LIKE brb_file.brb14,       #Required/Optional
                    brb04    LIKE brb_file.brb04,       #生效日
                    brb05    LIKE brb_file.brb05,       #失效日
                    brb06    LIKE brb_file.brb06,       #組成用量
                    brb07    LIKE brb_file.brb07,       #底數
                    brb10    LIKE brb_file.brb10,       #發料單位
                    brb08    LIKE brb_file.brb08,       #損耗率
                    brb081   LIKE brb_file.brb081,
                    brb082   LIKE brb_file.brb082,
                    brb19    LIKE brb_file.brb19,
                    brb24    LIKE brb_file.brb24,       #工程變異單號
                    brb13    LIKE brb_file.brb13,       #insert_loc
                    brb31    LIKE brb_file.brb31       #代買料否 
                    END RECORD,
    g_brb_t         RECORD                 #程式變數 (舊值)    	              
                    brb02    LIKE brb_file.brb02,       #元件項次
                    brb30    LIKE brb_file.brb30,       #計算方式 
                    brb03    LIKE brb_file.brb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    brb09    LIKE brb_file.brb09,       #作業編號
                    brb16    LIKE brb_file.brb16,       #UTE/SUB
                    brb14    LIKE brb_file.brb14,       #Required/Optional
                    brb04    LIKE brb_file.brb04,       #生效日
                    brb05    LIKE brb_file.brb05,       #失效日
                    brb06    LIKE brb_file.brb06,       #組成用量
                    brb07    LIKE brb_file.brb07,       #底數
                    brb10    LIKE brb_file.brb10,       #發料單位
                    brb08    LIKE brb_file.brb08,       #損耗率
                    brb081   LIKE brb_file.brb081,
                    brb082   LIKE brb_file.brb082,
                    brb19    LIKE brb_file.brb19,
                    brb24    LIKE brb_file.brb24,       #工程變異單號
                    brb13    LIKE brb_file.brb13,       #insert_loc
                    brb31    LIKE brb_file.brb31       #代買料否 
                    END RECORD,
    g_brb_o         RECORD                 #程式變數 (舊值)    	              
                    brb02    LIKE brb_file.brb02,       #元件項次
                    brb30    LIKE brb_file.brb30,       #計算方式 
                    brb03    LIKE brb_file.brb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    brb09    LIKE brb_file.brb09,       #作業編號
                    brb16    LIKE brb_file.brb16,       #UTE/SUB
                    brb14    LIKE brb_file.brb14,       #Required/Optional
                    brb04    LIKE brb_file.brb04,       #生效日
                    brb05    LIKE brb_file.brb05,       #失效日
                    brb06    LIKE brb_file.brb06,       #組成用量
                    brb07    LIKE brb_file.brb07,       #底數
                    brb10    LIKE brb_file.brb10,       #發料單位
                    brb08    LIKE brb_file.brb08,       #損耗率
                    brb081   LIKE brb_file.brb081,
                    brb082   LIKE brb_file.brb082,
                    brb19    LIKE brb_file.brb19,
                    brb24    LIKE brb_file.brb24,       #工程變異單號
                    brb13    LIKE brb_file.brb13,       #insert_loc
                    brb31    LIKE brb_file.brb31       #代買料否 
                    END RECORD,    
    g_brb11         LIKE  brb_file.brb11,
    g_brb13         LIKE  brb_file.brb13,
    g_brb31         LIKE  brb_file.brb31,   
    g_brb23         LIKE  brb_file.brb23,
    g_brb10_fac     LIKE  brb_file.brb10_fac, 
    g_brb10_fac2    LIKE  brb_file.brb10_fac2,
    g_brb15         LIKE  brb_file.brb15,
    g_brb18         LIKE  brb_file.brb18,
    g_brb17         LIKE  brb_file.brb17,
    g_brb27         LIKE  brb_file.brb27,
    g_brb28         LIKE  brb_file.brb28,
    g_brb20         LIKE  brb_file.brb20,
    g_brb19         LIKE  brb_file.brb19,
    g_brb21         LIKE  brb_file.brb21,
    g_brb22         LIKE  brb_file.brb22,
    g_brb25         LIKE  brb_file.brb25,
    g_brb26         LIKE  brb_file.brb26,
    g_brb11_o       LIKE  brb_file.brb11,
    g_brb13_o       LIKE  brb_file.brb13,
    g_brb31_o       LIKE  brb_file.brb31,  
    g_brb23_o       LIKE  brb_file.brb23,
    g_brb25_o       LIKE  brb_file.brb23,
    g_brb26_o       LIKE  brb_file.brb23,
    g_brb10_fac_o   LIKE  brb_file.brb10_fac,
    g_brb10_fac2_o  LIKE  brb_file.brb10_fac2,
    g_brb15_o       LIKE  brb_file.brb15,
    g_brb18_o       LIKE  brb_file.brb18,
    g_brb17_o       LIKE  brb_file.brb17,
    g_brb27_o       LIKE  brb_file.brb27,
    g_brb20_o       LIKE  brb_file.brb20,
    g_brb19_o       LIKE  brb_file.brb19,
    g_brb21_o       LIKE  brb_file.brb21,
    g_brb22_o       LIKE  brb_file.brb22,
    g_ima01         LIKE  ima_file.ima01,
    g_ecb06         LIKE  ecb_file.ecb06,
    g_sql           string,                 
    g_wc,g_wc2      string,                
    g_vdate         LIKE type_file.dat,     
    g_sw            LIKE type_file.num5,    #單位是否可轉換
    g_factor        LIKE ima_file.ima31_fac, #單位換算率
    g_cmd           LIKE type_file.chr1000,  
    g_aflag         LIKE type_file.chr1,   
    g_modify_flag   LIKE type_file.chr1,   
 
    g_tipstr        LIKE ze_file.ze03,       #顯示內容為"<依公式生成>"的字符串
 
    g_ecd02         LIKE ecd_file.ecd02,
    g_rec_b         LIKE type_file.num5,  #單身筆數
    g_rec_b2        LIKE type_file.num5,  #FUN-B20101
    l_ac            LIKE type_file.num5,  #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5,   #目前處理的SCREEN LINE
    l_s2            LIKE type_file.num5    #FUN-B20101
DEFINE p_row,p_col  LIKE type_file.num5     
DEFINE g_bmt_tmp    DYNAMIC ARRAY OF RECORD LIKE bmt_file.*  
DEFINE  g_bra_l       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      bra01_l     LIKE bra_file.bra01,
                      bra06_l     LIKE bra_file.bra06,
                      bra011_l    LIKE bra_file.bra011,
                  #   bra012_l    LIKE bra_file.bra012,  #FUN-B30033
                  #   bra013_l    LIKE bra_file.bra013,  #FUN-B30033
                      ima02_l     LIKE ima_file.ima02,
                      ima021_l    LIKE ima_file.ima021,
                      ima55_l     LIKE ima_file.ima55,
                      ima05_l     LIKE ima_file.ima05,
                      ima08_l     LIKE ima_file.ima08,
                      bra05_l     LIKE bra_file.bra05,
                      bra08_l     LIKE bra_file.bra08
                      END RECORD
DEFINE  g_brax        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      sel         LIKE type_file.chr1,
                      bra01       LIKE bra_file.bra01,
                    # bra06       LIKE bra_file.bra06     #FUN-B10013
                      bra011      LIKE bra_file.bra011    #FUN-B10013 
                      END RECORD
DEFINE g_gev04        LIKE gev_file.gev04
DEFINE l_ac1          LIKE type_file.num10
DEFINE l_ac2          LIKE type_file.num10   #FUN-B20101  
DEFINE g_rec_b1       LIKE type_file.num10
DEFINE g_bp_flag      LIKE type_file.chr10
DEFINE g_flag2        LIKE type_file.chr1
DEFINE g_gew06        LIKE gew_file.gew06
DEFINE g_gew07        LIKE gew_file.gew07
DEFINE g_argv1        LIKE bra_file.bra01
DEFINE g_argv2        LIKE bra_file.bra02
DEFINE g_argv3        STRING      
#FUN-B10013 ------------Begin---------------------
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_sql          string
DEFINE l_bra01_1      LIKE bra_file.bra01
DEFINE l_bra06_1      LIKE bra_file.bra06
DEFINE l_bra10_1      LIKE bra_file.bra10
#FUN-B10013 ------------End-----------------------    
DEFINE l_table         STRING     #FUN-B20101  
DEFINE g_brb10_t      LIKE brb_file.brb10     #FUN-BB0085
DEFINE
   g_value ARRAY[20] OF RECORD
            fname     LIKE type_file.chr5,  #欄位名稱，從'att01'~'att10'
            imx000    LIKE imx_file.imx000, #該欄位在imx_file中對應的欄位名稱
            visible   LIKe type_file.chr1,  #是否可見，'Y'或'N'
            nvalue    STRING,
            value     STRING  #存放當前當前組
            END RECORD,
    g_att  DYNAMIC ARRAY OF RECORD
            att01   LIKE imx_file.imx01, # 明細屬性欄位
            att02   LIKE imx_file.imx01, # 明細屬性欄位
            att03   LIKE imx_file.imx01, # 明細屬性欄位
            att04   LIKE imx_file.imx01, # 明細屬性欄位
            att05   LIKE imx_file.imx01, # 明細屬性欄位
            att06   LIKE imx_file.imx01, # 明細屬性欄位
            att07   LIKE imx_file.imx01, # 明細屬性欄位
            att08   LIKE imx_file.imx01, # 明細屬性欄位
            att09   LIKE imx_file.imx01, # 明細屬性欄位
            att10   LIKE imx_file.imx01, # 明細屬性欄位
            att11   LIKE imx_file.imx01, # 明細屬性欄位
            att12   LIKE imx_file.imx01, # 明細屬性欄位
            att13   LIKE imx_file.imx01, # 明細屬性欄位
            att14   LIKE imx_file.imx01, # 明細屬性欄位
            att15   LIKE imx_file.imx01, # 明細屬性欄位
            att16   LIKE imx_file.imx01, # 明細屬性欄位
            att17   LIKE imx_file.imx01, # 明細屬性欄位
            att18   LIKE imx_file.imx01, # 明細屬性欄位
            att19   LIKE imx_file.imx01, # 明細屬性欄位
            att20   LIKE imx_file.imx01  # 明細屬性欄位
        END RECORD
 
DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*
 
DEFINE   l_chk_boa     LIKE type_file.chr1,   
         l_chk_bob     LIKE type_file.chr1     
DEFINE   g_wsw03       LIKE wsw_file.wsw03     
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1    
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_level         LIKE type_file.num5    
DEFINE   g_msg           LIKE ze_file.ze03    
DEFINE   g_status        LIKE type_file.num5   
DEFINE   g_cnt2          LIKE type_file.num10    #FUN-B20101 
DEFINE   g_row_count     LIKE type_file.num10  
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10   
DEFINE   mi_no_ask       LIKE type_file.num5   
DEFINE   g_before_input_done   LIKE type_file.num5    
DEFINE   g_itm DYNAMIC ARRAY OF RECORD
                  db      LIKE type_file.chr20,  
                  tblname LIKE cre_file.cre08,  
                  ima01   LIKE ima_file.ima01,
                  ima02   LIKE ima_file.ima02
               END RECORD
DEFINE   b_brb           RECORD LIKE brb_file.*
DEFINE p_md         LIKE type_file.chr1       
DEFINE p_bra06      LIKE bra_file.bra06       
DEFINE g_confirm    LIKE type_file.chr1        
DEFINE g_wc_o            STRING                #g_wc舊值備份
DEFINE g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #節點名稱
          pid            STRING,                 #父節點id
          id             STRING,                 #節點id
          has_children   BOOLEAN,                #TRUE:有子節點, FALSE:無子節點
          expanded       BOOLEAN,                #TRUE:展開, FALSE:不展開
          level          LIKE type_file.num5,    #階層
          path           STRING,                 #節點路徑，以"."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空白
          treekey1       STRING,
          treekey2       STRING
          END RECORD
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑(check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop)
DEFINE g_flag_b          LIKE type_file.chr1     #FUN-D30033 add

MAIN
DEFINE  p_sma124  LIKE sma_file.sma121        
DEFINE  l_brb13   LIKE ze_file.ze03    
DEFINE  l_cnt     LIKE type_file.num10     #FUN-B10013    
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF

   
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)   
 
    LET g_db_type=cl_db_get_database_type()
    LET g_wc2=' 1=1'
 #FUN-B20101--mark--begin 
 #   LET g_forupd_sql =
 #  "SELECT * FROM bra_file WHERE bra01=? AND bra06=? AND bra011=? AND bra012=? AND bra013=?  FOR UPDATE"  #FUN-B20101
 #  "SELECT bra01,bra04,bra05,bra06,bra08,bra10,bra011,bra014 FROM bra_file WHERE bra01=? AND bra06=? AND  bra011=?  FOR UPDATE"  #FUN-B20101
 #  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
 #  DECLARE i500_cl CURSOR FROM g_forupd_sql
 #FUN-B20101--mark--end 
 #  CALL s_decl_brb()
 
    CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time    
#No.FUN-B20101---Begin                                                                                                              
   LET g_sql = "bra01.bra_file.bra01,",                                                                                           
               "bra06.bra_file.bra06,",  
               "bra011.bra_file.bra011,",
               "ecu03.ecu_file.ecu03,",                                                                                             
               "bra012.bra_file.bra012,",
               "ecu014.ecu_file.ecu014,",
               "bra013.bra_file.bra013,",
               "ecb06.ecb_file.ecb06,", 
               "ecb17.ecb_file.ecb17,",
               "ima02.ima_file.ima02,",                                                                                             
               "ima021.ima_file.ima021,",
               "brb03.brb_file.brb03,",
               "brb02.brb_file.brb02,",
               "ima05.ima_file.ima05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "p_level.type_file.num5,",
               "lb_qty.type_file.num20_6,",   
               "lc_qty.type_file.num20_6,",  
               "brb10.brb_file.brb10,", 
               "brb19.brb_file.brb19,",
               "brb01.brb_file.brb01,", 
               "brb01.brb_file.brb01,",      
               "brb02.brb_file.brb02,",    
               "no.type_file.num5,",      
               "g_sma118.sma_file.sma118"                                                               
                                                                                                
    LET l_table = cl_prt_temptable('abmi500',g_sql) CLIPPED                                                                          
  # IF l_table = -1 THEN EXIT PROGRAM END IF           
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "                                                                                                  
    PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
    END IF 
#No.FUN-B20101--end  
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i500_w AT p_row,p_col WITH FORM "abm/42f/abmi500"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_comp_entry('bra014,brb19',FALSE)
    LET g_tree_reload = "N"      #tree是否要重新整理 Y/N 
    LET g_tree_b = "N"           #tree是否進入單身 Y/N  
    LET g_tree_focus_idx = 0     #focus節點index     
    IF s_industry('slk') THEN
        CALL cl_set_comp_visible("bra06",g_sma.sma118='Y') 
        CALL cl_set_comp_visible("bra06_l",g_sma.sma118='Y')   
    ELSE 
        CALL cl_set_comp_visible("bra06,brb30",g_sma.sma118='Y')
        CALL cl_set_comp_visible("bra06_l",g_sma.sma118='Y')   
    END IF  
    CALL cl_set_comp_visible("brb09",FALSE)  
    IF g_sma.sma542='N' THEN 
       CALL cl_err('','abm-213',1)
       CLOSE WINDOW i500_w             
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time           
    END IF 
    IF s_industry('slk') THEN
        SELECT  ze03  INTO l_brb13 FROM ze_file WHERE ze01 = 'abmi600' AND ze02 = g_lang
        CALL cl_set_comp_att_text("brb13",l_brb13)
        CALL i500_set_brb30()
    END IF
    SELECT ze03 INTO g_tipstr FROM ze_file WHERE
      ze01 = 'lib-294' AND ze02 = g_lang
 
    --IF NOT cl_null(g_argv1) THEN
       --CALL i500_q(0)
    --END IF
    LET g_action_choice = ''
 
    CALL i500_menu()
 
    CLOSE WINDOW i500_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
    RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION i500_curs(p_idx) 
DEFINE l_flag      LIKE type_file.chr1   #判斷單身是否給條件
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   
DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     
DEFINE l_wc   STRING                #雙按Tree的節點時的查詢條件 

    LET l_wc = NULL
    IF p_idx > 0 THEN
       IF g_tree_b = "N" THEN
          LET l_wc = g_wc_o             #還原QBE的查詢條件
       ELSE
          IF g_tree[p_idx].level = 1 THEN
            LET l_wc = "bra01='",g_tree[p_idx].treekey2 CLIPPED,"'"
          ELSE
             IF g_tree[p_idx].has_children THEN
               LET l_wc = "bra01='",g_tree[p_idx].treekey2 CLIPPED,"'"
             ELSE
                LET l_wc = "bra01='",g_tree[p_idx].treekey2 CLIPPED,"'"
             END IF
          END IF
       END IF
    END IF
    
    CLEAR FORM                            #清除畫面
    CALL g_bra1.clear()              #FUN-B20101
    CALL g_brb.clear()
    LET l_flag = 'N'
    LET g_vdate = g_today
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " bra01 = '",g_argv1,"' AND bra06 = '",g_argv2,"'"
       LET g_wc2= " 1=1"
       IF NOT cl_null(g_vdate) THEN
          LET  g_wc2 = g_wc2  clipped,
                      " AND (brb04 <='", g_vdate,"'"," OR brb04 IS NULL )",
                      " AND (brb05 >  '",g_vdate,"'"," OR brb05 IS NULL )"
       END IF
    ELSE
        CALL cl_set_head_visible("","YES")   
        INITIALIZE g_bra.* TO NULL  
        IF p_idx = 0 THEN
          DIALOG ATTRIBUTES(UNBUFFERED)        #FUN-B20101  
        # CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件 #FUN-B20101
          CONSTRUCT g_wc ON                                        #FUN-B20101
              bra01,bra011,bra012,bra013,bra06,
              bra10,bra014,bra04,bra05,bra08,   
              brauser,bragrup,bramodu,bradate,braacti,braorig,braoriu
          FROM bra01,bra011,s_bra[1].bra012,s_bra[1].bra013,bra06,         #FUN-B20101
                  bra10,bra014,bra04,bra05,bra08,                          #FUN-B20101
                  brauser,bragrup,bramodu,bradate,braacti,braorig,braoriu  #FUN-B20101
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          END  CONSTRUCT          #FUN-B20101
     #FUN-B20101--add--begin
          CONSTRUCT g_wc2 ON brb02,brb30,brb03,
                                #brb09,
                                brb16,brb14,brb04,brb05,brb06,brb07,
                                brb10,brb08,brb081,brb082,brb19,brb24,   
                                brb13,brb31              
                  FROM s_brb[1].brb02,s_brb[1].brb30,s_brb[1].brb03,
                       #s_brb[1].brb09, 
                       s_brb[1].brb16,s_brb[1].brb14,s_brb[1].brb04,
                       s_brb[1].brb05,s_brb[1].brb06,s_brb[1].brb07,
                       s_brb[1].brb10,s_brb[1].brb08,s_brb[1].brb081,
                       s_brb[1].brb082,s_brb[1].brb19,s_brb[1].brb24,
                       s_brb[1].brb13,s_brb[1].brb31
                  BEFORE CONSTRUCT
                     CALL cl_qbe_display_condition(lc_qbe_sn)
              END CONSTRUCT 
     #FUN-B20101--add--end     
              ON ACTION CONTROLP
                  CASE
                     WHEN INFIELD(bra01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_bra01"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO bra01
                        NEXT FIELD bra01
                     WHEN INFIELD(bra011)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_bra011"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO bra011
                        NEXT FIELD bra011     
                     WHEN INFIELD(bra012)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_bra012"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO bra012
                        NEXT FIELD bra012     
                     WHEN INFIELD(bra013)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_bra013"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO bra013
                        NEXT FIELD bra013                                                                     
                     WHEN INFIELD(bra08)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form  = "q_bra08"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO bra08
                        NEXT FIELD bra08
               #FUN-B20101--add--begin
                     WHEN INFIELD(brb03) #料件主檔
                             CALL cl_init_qry_var()
                             LET g_qryparam.form = "q_brb03"
                             LET g_qryparam.state = 'c'
                             CALL cl_create_qry() RETURNING g_qryparam.multiret
                             DISPLAY g_qryparam.multiret TO brb03
                             NEXT FIELD brb03
                        WHEN INFIELD(brb10) #單位檔
                             CALL cl_init_qry_var()
                             LET g_qryparam.form = "q_brb10"
                             LET g_qryparam.state = 'c'
                             CALL cl_create_qry() RETURNING g_qryparam.multiret
                             DISPLAY g_qryparam.multiret TO brb10
                             NEXT FIELD brb10
               #FUN-B20101--add--end
                     OTHERWISE EXIT CASE
                   END CASE
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
              #  CONTINUE CONSTRUCT    #FUN-B20101
                 CONTINUE DIALOG       #FUN-B20101
 
              ON ACTION about      
                 CALL cl_about()   
         
              ON ACTION help         
                 CALL cl_show_help()
         
              ON ACTION controlg  
                 CALL cl_cmdask() 
 
              ON ACTION qbe_select
                 CALL cl_qbe_list() RETURNING lc_qbe_sn
                 CALL cl_qbe_display_condition(lc_qbe_sn)
       #  END CONSTRUCT             #FUN-B20101
       #FUN-B20101--add--begin
             ON ACTION accept
                ACCEPT DIALOG

             ON ACTION cancel
                LET INT_FLAG = TRUE
                EXIT DIALOG
          END  DIALOG   #FUN-B20101
        #FUN-B20101--add--end
          IF INT_FLAG THEN 
             RETURN 
           END IF
          LET g_wc = g_wc CLIPPED,cl_get_extra_cond('brauser', 'bragrup')
          DISPLAY g_vdate TO FORMONLY.vdate             #輸入有效日期
          CALL cl_set_head_visible("","YES")           
          INPUT g_vdate WITHOUT DEFAULTS FROM vdate
             ON ACTION controlg       
                CALL cl_cmdask()  
 
             ON IDLE g_idle_seconds  
                CALL cl_on_idle()   
                CONTINUE INPUT       
 
             ON ACTION about         
                CALL cl_about()     
 
             ON ACTION help          
                CALL cl_show_help()  
          END INPUT                
#FUN-B20101--mark--begin 
#          IF g_vdate IS NULL OR g_vdate = ' ' THEN
#            DIALOG ATTRIBUTES(UNBUFFERED)        #FUN-B20101 
#             CONSTRUCT g_wc2 ON brb02,brb30,brb03,
#                                #brb09,
#                                brb16,brb14,brb04,brb05,brb06,brb07,
#                                brb10,brb08,brb081,brb082,brb19,brb24,   
#                                brb13,brb31              
#                  FROM s_brb[1].brb02,s_brb[1].brb30,s_brb[1].brb03,
#                       #s_brb[1].brb09, 
#                       s_brb[1].brb16,s_brb[1].brb14,s_brb[1].brb04,
#                       s_brb[1].brb05,s_brb[1].brb06,s_brb[1].brb07,
#                       s_brb[1].brb10,s_brb[1].brb08,s_brb[1].brb081,
#                       s_brb[1].brb082,s_brb[1].brb19,s_brb[1].brb24,
#                       s_brb[1].brb13,s_brb[1].brb31
#                  BEFORE CONSTRUCT
#                     CALL cl_qbe_display_condition(lc_qbe_sn)
#             END CONSTRUCT           #FUN-B20101
#                  ON ACTION CONTROLP
#                     CASE
#                        WHEN INFIELD(brb03) #料件主檔
#                             CALL cl_init_qry_var()
#                             LET g_qryparam.form = "q_brb03"
#                             LET g_qryparam.state = 'c'
#                             CALL cl_create_qry() RETURNING g_qryparam.multiret
#                             DISPLAY g_qryparam.multiret TO brb03
#                             NEXT FIELD brb03
#                        WHEN INFIELD(brb10) #單位檔
#                             CALL cl_init_qry_var()
#                             LET g_qryparam.form = "q_brb10"
#                             LET g_qryparam.state = 'c'
#                             CALL cl_create_qry() RETURNING g_qryparam.multiret
#                             DISPLAY g_qryparam.multiret TO brb10
#                             NEXT FIELD brb10
#                        OTHERWISE EXIT CASE
#                     END  CASE
# 
#                  ON IDLE g_idle_seconds
#                     CALL cl_on_idle()
#         #            CONTINUE CONSTRUCT   #FUN-B20101
#                     CONTINUE DIALOG       #FUN-B20101
# 
#                  ON ACTION about        
#                     CALL cl_about()    
# 
#                  ON ACTION help         
#                     CALL cl_show_help()  
# 
#                  ON ACTION controlg   
#                     CALL cl_cmdask()   
# 
#                  ON ACTION qbe_save
#                     CALL cl_qbe_save()
#          #   END CONSTRUCT          #FUN-B20101
#         #FUN-B20101--add--begin
#                 ON ACTION accept
#                    ACCEPT DIALOG
#
#                 ON ACTION cancel
#                    LET INT_FLAG = TRUE
#                    EXIT DIALOG
#            END  DIALOG   #FUN-B20101
#        #FUN-B20101--add--end 
#             IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
#             IF INT_FLAG THEN RETURN END IF
#          ELSE
#            DIALOG ATTRIBUTES(UNBUFFERED)        #FUN-B20101 
#             CONSTRUCT g_wc2 ON brb02,brb30,brb03,
#                                #brb09,
#                                brb16,brb14,brb04,brb05,brb06,brb07,
#                                brb10,brb08,brb081,brb082,brb19,brb24                 
#                  FROM s_brb[1].brb02,s_brb[1].brb30,s_brb[1].brb03,
#                       #s_brb[1].brb09, 
#                       s_brb[1].brb16,s_brb[1].brb14,s_brb[1].brb04,
#                       s_brb[1].brb05,s_brb[1].brb06,s_brb[1].brb07,
#                       s_brb[1].brb10,s_brb[1].brb08,s_brb[1].brb081,
#                       s_brb[1].brb082,s_brb[1].brb19,s_brb[1].brb24
#                  BEFORE CONSTRUCT
#                     CALL cl_qbe_display_condition(lc_qbe_sn)
#             END  CONSTRUCT        #FUN-B20101
#                  ON ACTION CONTROLP
#                     CASE
#                        WHEN INFIELD(brb03) #料件主檔
#                             CALL cl_init_qry_var()
#                             LET g_qryparam.form = "q_brb03"
#                             LET g_qryparam.state = 'c'
#                             CALL cl_create_qry() RETURNING g_qryparam.multiret
#                             DISPLAY g_qryparam.multiret TO brb03
#                             NEXT FIELD brb03
#                        WHEN INFIELD(brb10) #單位檔
#                             CALL cl_init_qry_var()
#                             LET g_qryparam.form = "q_brb10"
#                             LET g_qryparam.state = 'c'
#                             CALL cl_create_qry() RETURNING g_qryparam.multiret
#                             DISPLAY g_qryparam.multiret TO brb10
#                             NEXT FIELD brb10
#                        OTHERWISE EXIT CASE
#                     END  CASE
# 
#                  ON IDLE g_idle_seconds
#                     CALL cl_on_idle()
#                #    CONTINUE CONSTRUCT     #FUN-B20101
#                     CONTINUE DIALOG       #FUN-B20101
# 
#                  ON ACTION about     
#                     CALL cl_about()      
# 
#                  ON ACTION help        
#                     CALL cl_show_help() 
# 
#                  ON ACTION controlg    
#                     CALL cl_cmdask()    
# 
#                  ON ACTION qbe_save
#                     CALL cl_qbe_save()
#          #   END CONSTRUCT     FUN-B20101
#          #FUN-B20101--add--begin
#                 ON ACTION accept
#                    ACCEPT DIALOG
#
#                 ON ACTION cancel
#                    LET INT_FLAG = TRUE
#                    EXIT DIALOG
#            END  DIALOG   #FUN-B20101
#        #FUN-B20101--add--end
#          IF INT_FLAG THEN
#             RETURN
#          END IF
#          IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
#          IF NOT cl_null(g_vdate) THEN
#             LET  g_wc2 = g_wc2  clipped,
#                         " AND (brb04 <='", g_vdate,"'"," OR brb04 IS NULL )",
#                         " AND (brb05 >  '",g_vdate,"'"," OR brb05 IS NULL )" 
#          END IF
#       END IF
#FUN-B20101--mark--end
#MOD-B30511--add--begin
        IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
        IF NOT cl_null(g_vdate) THEN
           LET  g_wc2 = g_wc2  clipped,
                " AND (brb04 <='", g_vdate,"'"," OR brb04 IS NULL )",
                " AND (brb05 >  '",g_vdate,"'"," OR brb05 IS NULL )"
        END IF
#MOD-B30511--add--end
       ELSE
          LET g_wc = l_wc CLIPPED
    END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('brauser', 'bragrup') 
      IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份
      LET g_wc_o = g_wc CLIPPED
      END IF  
    END IF
    IF l_flag = 'N' THEN   # 若單身未輸入條件
     # LET g_sql = "SELECT  bra01,bra06,bra011,bra012,bra013 FROM bra_file ", #FUN-B20101
       LET g_sql = "SELECT UNIQUE bra01,bra06,bra011 FROM bra_file ",               #FUN-B20101        
                   " WHERE ", g_wc CLIPPED,
    #              " ORDER BY bra01,bra06,bra011,bra012,bra013 "              #FUN-B20101
                   " ORDER BY bra01,bra06,bra011 "                            #FUN-B20101  
     ELSE     # 若單身有輸入條件
    #  LET g_sql = "SELECT UNIQUE  bra01,bra06,bra011,bra012,bra013 ",        #FUN-B20101
       LET g_sql = "SELECT UNIQUE  bra01,bra06,bra011 ",                      #FUN-B20101 
                   "  FROM bra_file, brb_file ",
                   " WHERE bra01 = brb01 ",
                   "   AND bra06 = brb29 ",         
                   "   AND bra011= brb011 ",     
                   "   AND bra012= brb012 ",
                   "   AND bra013= brb013 ",             
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
         #         " ORDER BY bra01,bra06,bra011,bra012,bra013 "               #FUN-B20101
                   " ORDER BY bra01,bra06,bra011 "                             #FUN-B20101
    END IF
 
    PREPARE i500_prepare FROM g_sql
    DECLARE i500_curs SCROLL CURSOR WITH HOLD FOR i500_prepare
   #DECLARE i500_list_cur CURSOR FOR i500_prepare  #FUN-B30033 jan add--mark

    IF l_flag = 'N' THEN   # 取合乎條件筆數
     #  LET g_sql="SELECT COUNT(UNIQUE bra01||bra06||bra011||bra012||bra013) FROM bra_file WHERE ",g_wc CLIPPED #FUN-B20101
        LET g_sql="SELECT COUNT(UNIQUE bra01||bra06||bra011) FROM bra_file WHERE ",g_wc CLIPPED                 #FUN-B20101 
    ELSE
     #  LET g_sql="SELECT COUNT(UNIQUE bra01||bra06||bra011||bra012||bra013) FROM bra_file,brb_file WHERE ",    #FUN-B20101
        LET g_sql="SELECT COUNT(UNIQUE bra01||bra06||bra011) FROM bra_file,brb_file WHERE ",                    #FUN-B20101 
                  "brb01=bra01 AND bra06=brb29 AND bra011= brb011 AND bra012= brb012 AND bra013= brb013 AND ",
                   g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE i500_precount FROM g_sql
    DECLARE i500_count CURSOR FOR i500_precount
END FUNCTION

#FUN-B30033 jan add--(s)
FUNCTION i500_list_cs(p_wc,p_wc2)
DEFINE p_wc,p_wc2 STRING

    IF cl_null(p_wc) THEN LET p_wc= " bra01= '",g_bra.bra01,"' AND bra06= '",g_bra.bra06,"' AND bra011='",g_bra.bra011,"'" END IF
    IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1"  END IF
    IF p_wc2 = " 1=1" THEN   # 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE bra01,bra06,bra011 FROM bra_file ",      
                   " WHERE ", p_wc CLIPPED,
                   " ORDER BY bra01,bra06,bra011 "                        
    ELSE     # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  bra01,bra06,bra011 ",                 
                   "  FROM bra_file, brb_file ",
                   " WHERE bra01 = brb01 ",
                   "   AND bra06 = brb29 ",         
                   "   AND bra011= brb011 ",     
                   "   AND bra012= brb012 ",
                   "   AND bra013= brb013 ",             
                   "   AND ",p_wc CLIPPED,
                   "   AND ",p_wc2 CLIPPED,
                   " ORDER BY bra01,bra06,bra011 "       
    END IF
 
    PREPARE i500_prepare1 FROM g_sql
    DECLARE i500_list_cur CURSOR FOR i500_prepare1
END FUNCTION
#FUN-B30033 jan add--(e)
 
FUNCTION i500_menu()
   DEFINE
      l_cmd           LIKE type_file.chr1000,
      l_priv1         LIKE zy_file.zy03,       # 使用者執行權限
      l_priv2         LIKE zy_file.zy04,       # 使用者資料權限
      l_priv3         LIKE zy_file.zy05,       # 使用部門資料權限
      l_ima903        LIKE ima_file.ima903
   WHILE TRUE
      IF cl_null(g_bp_flag) OR g_bp_flag <> 'list' THEN
         CALL i500_bp("G")
      ELSE
         CALL i500_bp1("G")
      END IF 
      IF g_bp_flag = 'list' AND l_ac1>0 THEN #將清單的資料回傳到主畫面
        SELECT bra_file.*
         #INTO g_bra.*           #FUN-B20101
          INTO g_bra.bra01,g_bra.bra011,g_bra.bra012,g_bra.bra013,g_bra.bra014,g_bra.bra02, 
              g_bra.bra03,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra07,g_bra.bra08,g_bra.bra09,
              g_bra.bra10,g_bra.braacti,g_bra.bradate,g_bra.bragrup,g_bra.bramodu,g_bra.braorig,g_bra.braoriu,g_bra.brauser 
          FROM bra_file 
          WHERE bra01=g_bra_l[l_ac1].bra01_l
            AND bra06=g_bra_l[l_ac1].bra06_l
            AND bra011=g_bra_l[l_ac1].bra011_l
          # AND bra012=g_bra_l[l_ac1].bra012_l
          # AND bra013=g_bra_l[l_ac1].bra013_l
      END IF
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               LET g_wc=''      #FUN-B30033
               LET g_wc2 =''    #FUN-B30033
               CALL i500_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
                LET g_wc='' 
               CALL i500_q(0)
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i500_r()
               LET g_bp_flag = "main"
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i500_u()
               LET g_bp_flag = "main"
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i500_x()
               CALL i500_show()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i500_copy()
               LET g_bp_flag = "main"
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                CALL i500_confirm()
                CALL i500_show() #MOD-B30502
                LET g_bp_flag = "main"
            END IF
         WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
               CALL i500_unconfirm()
               CALL i500_show() #MOD-B30502
               LET g_bp_flag = "main"
           END IF
         #FUN-AC0076 add --------------begin---------------
         #@WHEN "分量耗損" 
           WHEN "haosun"
              IF cl_chk_act_auth() THEN
                 LET l_cmd = "abmi612 '",g_bra.bra01,"'"
                 CALL cl_cmdrun_wait(l_cmd)
              END IF    
         #FUN-AC0076 add ---------------end----------------  
         WHEN "unrelease"
           IF cl_chk_act_auth() THEN
               CALL i500_unrelease()
               LET g_bp_flag = "main"
           END IF
   #FUN-B20101--add--begin        
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i500_out()
            END IF  
   #FUN-B20101--add--end 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i500_b()
#               IF g_ima08_h = 'A' AND g_bra.bra01 IS NOT NULL THEN
#                  CALL p500_tm(0,0,g_bra.bra01)      #主件為family
#               END IF
               LET g_bp_flag = "main"
            ELSE                                       #FUN-B20101
               LET g_action_choice = NULL              #FUN-B20101
            END IF
         #  LET g_action_choice = ""                   #FUN-B20101
         WHEN "help"
            CALL cl_show_help()
            LET g_bp_flag = "main"
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_bp_flag = "main"
         WHEN "bom_release"     
            IF cl_chk_act_auth() THEN
               CALL i500_j()
               CALL i500_show()     #MOD-840104 add
               LET g_bp_flag = "main"
            END IF
       #@WHEN "明細單身"
         WHEN "contents"
            IF cl_chk_act_auth() THEN  
             IF l_ac > 0 AND  l_ac2>0 THEN      
               LET l_cmd = "abmi505 "," '",g_bra.bra01,"'",
                           " '",g_vdate,"' '",g_bra.bra06,"' ",
                           " '",g_brb[l_ac].brb03,"'"," '",g_bra.bra011,"' ",
                         # " '",g_bra.bra012,"' "," '",g_bra.bra013,"' "      #FUN-B20101
                           " '",g_bra1[l_ac2].bra012,"' "," '",g_bra1[l_ac2].bra013,"' "      #FUN-B20101 
               CALL cl_cmdrun(l_cmd)
                  IF g_wc2 IS NULL THEN
                     LET g_wc2 = " 1= 1"
                  END IF
             # CALL i500_b_fill(g_wc2)                 #單身 #FUN-B20101
              CALL i500_show()    #FUN-B20101
               CALL i500_bp_refresh()
               LET g_bp_flag = "main"
             END IF                   
            END IF    
       WHEN "updbom"     
          IF cl_chk_act_auth() THEN
             CALL i500_updbom()
             CALL i500_show()     
             LET g_bp_flag = "main"
          END IF                            
       WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_bra.bra01 IS NOT NULL THEN
                LET g_doc.column1 = "bra01"
                LET g_doc.value1  = g_bra.bra01
                CALL cl_doc()
                LET g_bp_flag = "main"
             END IF
          END IF  
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_brb),'','')
              LET g_bp_flag = "main"
            END IF
#FUN-B10013 ---------------------------Begin---------------------------------------
         WHEN "carry"
             IF cl_chk_act_auth() THEN
                CALL ui.Interface.refresh()
                SELECT COUNT(*) INTO l_cnt FROM bra_file 
                 WHERE bra01 = g_bra.bra01
                   AND bra011 = g_bra.bra011
                   AND bra10 = '2'                                    
                IF l_cnt < 1 THEN
                   CALL cl_err(g_bra.bra01,'aoo-091',1)
                   CONTINUE WHILE
                END IF 
                IF g_bra.bra014 = 'Y'  THEN 
                   LET g_success = 'Y'   #FUN-B20101
                   CALL i500_carry()
              #FUN-B20101--add--begin
                   IF g_success = 'N' THEN
                      LET g_success='Y'
                      CONTINUE WHILE
                   END IF
              #FUN-B20101--add--end
                   LET l_sql = "SELECT DISTINCT bra01,bra06,bra10 FROM bra_file ",
                               " WHERE bra01 = '",g_bra.bra01,"'",
                               "   AND bra011 = '",g_bra.bra011,"'",
                               "   AND bra10 = '2' "
                   PREPARE bra_car FROM l_sql
                   DECLARE bra_sel CURSOR WITH HOLD FOR bra_car  
                   FOREACH bra_sel INTO l_bra01_1,l_bra06_1,l_bra10_1    
                      IF SQLCA.sqlcode THEN
                         CALL cl_err('foreach',SQLCA.sqlcode,1)
                         CONTINUE FOREACH
                      END IF    
                      CALL s_abmi600_com_carry(l_bra01_1,l_bra06_1,l_bra10_1,g_plant,0)
                   END FOREACH
                ELSE 
                   LET g_success = 'Y'   #FUN-B20101
                   CALL i500_carry()
                   #FUN-B20101--add--begin
                   IF g_success = 'N' THEN
                      LET g_success='Y'
                      CONTINUE WHILE
                   END IF
              #FUN-B20101--add--end
                END IF
                LET g_bp_flag = "main"
             END IF
          WHEN "qry_carry_history"
             IF cl_chk_act_auth() THEN
                IF NOT cl_null(g_bra.bra01) THEN  
                   IF NOT cl_null(g_bra.bra08) THEN
                      SELECT gev04 INTO g_gev04 FROM gev_file
                       WHERE gev01 = '2' AND gev02 = g_bra.bra08
                   ELSE      #歷史資料,即沒有ima916的值
                      SELECT gev04 INTO g_gev04 FROM gev_file
                       WHERE gev01 = '2' AND gev02 = g_plant
                   END IF
                   IF NOT cl_null(g_gev04) THEN
                      LET l_cmd='aooq604 "',g_gev04,'" "2" "',g_prog,'" "',g_bra.bra01,'"'  #FUN-B30033
               #      LET l_cmd='aooq604 "',g_gev04,'" "2" "',g_prog,'" "',g_bra.bra01,'"||'+'||"',g_bra.bra011,'"'  #FUN-B30033
                      CALL cl_cmdrun(l_cmd)
                   END IF
                ELSE
                   CALL cl_err('',-400,0)
                END IF
                LET g_bp_flag = "main"
             END IF             
#FUN-B10013 ---------------------------End-----------------------------------------
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i500_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
 #  CALL g_brb.clear()
    CALL g_bra1.clear()         #FUN-B20101
    INITIALIZE g_bra.* LIKE bra_file.*             #DEFAULT 設定
    LET g_wc_o=''  #FUN-B30033 jan add 
    LET g_vdate = NULL   
#FUN-B20101--modity
  # LET g_bra01_t = NULL
  # LET g_bra06_t = NULL
    LET g_bra01_t = NULL
    LET g_bra06_t = NULL  
#FUN-B20101--modity      
    #預設值及將數值類變數清成零
    LET g_bra011_t = g_bra.bra011
    LET g_bra_t.bra014 = g_bra.bra014
    LET g_bra_t.bra02  = g_bra.bra02
    LET g_bra_t.bra04  = g_bra.bra04
    LET g_bra_t.bra05  = g_bra.bra05
    LET g_bra_t.bra08  = g_bra.bra08
    LET g_bra_t.bra10  = g_bra.bra10
 #  LET g_bra_t.* = g_bra.*
 #  LET g_bra_o.* = g_bra.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bra.brauser=g_user
        LET g_bra.braoriu = g_user 
        LET g_bra.braorig = g_grup 
        LET g_bra.bra10 = 0       
        LET g_bra.bragrup=g_grup
        LET g_bra.bradate=g_today
        LET g_bra.braacti='Y'              #資料有效
        LET g_bra.bra08=g_plant          
        LET g_bra.bra09=0               
        LET g_bra.bra06=' '          
        LET g_bra.bra014='N'
        LET g_confirm = 'N'             
        IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'a') THEN                                                                           
           CALL cl_err(g_bra.bra08,'aoo-078',1)                                                                                         
           RETURN                                                                                                                       
        END IF   
        LET g_bra.bra06 = ' '          
        CALL i500_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_bra.* TO NULL
            LET INT_FLAG = 0
            LET g_bp_flag ="main"
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bra.bra01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_bra.bra011 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
    #FUN-B20101--mark--begin
    #   IF g_bra.bra012 IS NULL THEN                # KEY 不可空白
    #       CONTINUE WHILE
    #   END IF
    #   IF g_bra.bra013 IS NULL THEN                # KEY 不可空白
    #       CONTINUE WHILE
    #   END IF              
    #FUN-B20101--mark--end          
        IF g_bra.bra06 IS NULL THEN                 # KEY 不可空白
            LET g_bra.bra06 = ' '
        END IF
        SELECT count(*) INTO g_cnt FROM bra_file
            WHERE bra01 = g_bra.bra01
              AND bra011= g_bra.bra011
    #         AND bra012= g_bra.bra012     #FUN-B20101
    #         AND bra013= g_bra.bra013     #FUN-B20101
              AND bra06 = g_bra.bra06 
        IF g_cnt > 0 THEN   #資料重復
            CALL cl_err('',-239,1)
            CONTINUE WHILE
        END IF
        IF cl_null(g_bra.bra10) THEN
           LET g_bra.bra10 = '0'
        END IF
       #No.FUN-A70131--begin
#       IF cl_null(g_bra.bra012) THEN 
#          LET g_bra.bra012=' '
#       END IF 
#       IF cl_null(g_bra.bra013) THEN 
#          LET g_bra.bra013=0
#       END IF 
       #No.FUN-A70131--end   
#        INSERT INTO bra_file VALUES (g_bra.*)   #FUN-B20101
#       INSERT INTO  bra_file(bra01,bra011,bra06) VALUES (g_bra.bra01,g_bra.bra011,g_bra.bra06)
#       IF SQLCA.sqlcode THEN      #置入資料庫不成功
#           CALL cl_err3("ins","bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)  #No.TQC-660046
#           CONTINUE WHILE
#       END IF       
 #FUN-B20101--modity         
      # LET g_bra012_t = g_bra.bra012        #保留舊值   
      # LET g_bra013_t = g_bra.bra013        #保留舊值  
        LET g_bra01_t = g_bra.bra01
        LET g_bra06_t = g_bra.bra06
        LET g_bra011_t = g_bra.bra011 
   #    LET g_bra_t.* = g_bra.*
 #FUN-B20101--modity
        CALL g_bra1.clear() 
     #  CALL g_brb.clear()
        LET g_rec_b = 0
        LET g_rec_b2=0
        DISPLAY g_rec_b TO FORMONLY.cn2
        CALL i500_b()                   #輸入單身
#        IF g_ima08_h = 'A' AND g_aflag = 'Y' THEN      #主件為family 時
#           CALL p500_tm(0,0,g_bra.bra01)
#        END IF
#        CASE aws_mdmdata('bra_file','insert',g_bra.bra01,base.TypeInfo.create(g_bra),'CreateBOMData') #FUN-890113        
#           WHEN 0  #無與 MDM 整合
#                MESSAGE 'INSERT O.K'
#           WHEN 1  #呼叫 MDM 成功
#                MESSAGE 'INSERT O.K, INSERT MDM O.K'
#           WHEN 2  #呼叫 MDM 失敗
#                ROLLBACK WORK
#                CONTINUE WHILE      
#        END CASE
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i500_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bra.bra01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'u') THEN
       CALL cl_err(g_bra.bra08,'aoo-045',1)
       RETURN
    END IF
    IF g_bra.braacti ='N' THEN    #資料若為無效,仍可更改.  
        CALL cl_err(g_bra.bra01,'mfg1000',0) RETURN       
    END IF                                                
    IF g_bra.bra10 <> '0' THEN
       CALL cl_err('','aim1006',0)
       RETURN
    END IF 
    MESSAGE ""
    CALL cl_opmsg('u')
#FUN-B20101--modity
#   LET g_bra012_t = g_bra.bra012  
#   LET g_bra013_t = g_bra.bra013
    LET g_bra01_t = g_bra.bra01
    LET g_bra06_t = g_bra.bra06 
    LET g_bra011_t = g_bra.bra011
    LET g_bra_t.*  = g_bra.*
#FUN-B20101--modity 
    BEGIN WORK
 #FUN-B20101--mark--begin 
 #  OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013  #FUN-B20101
 #  OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011              #FUN-B20101
 #  IF STATUS THEN
 #     CALL cl_err("OPEN i500_cl:", STATUS, 1)
 #     CLOSE i500_cl
 #     ROLLBACK WORK
 #     RETURN
 #  END IF
 # FETCH i500_cl INTO g_bra.*            # 鎖住將被更改或取消的資料
 # FETCH i500_cl INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014  #FUN-B20101
 #  IF SQLCA.sqlcode THEN
 #      CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)      # 資料被他人LOCK
 #      CLOSE i500_cl
 #       ROLLBACK WORK 
 #      RETURN
 #  END IF
 # CALL i500_show()
 #FUN-B20101--mark--end
    WHILE TRUE
#FUN-B20101--modity
#       LET g_bra01_t = g_bra.bra01
#       LET g_bra06_t = g_bra.bra06
#       LET g_bra011_t = g_bra.bra011
#       LET g_bra012_t = g_bra.bra012  
#       LET g_bra013_t = g_bra.bra013 
        LET g_bra01_t = g_bra.bra01
        LET g_bra06_t = g_bra.bra06
        LET g_bra011_t = g_bra.bra011
#FUN-B20101--modity
        LET g_bra.bramodu=g_user
        LET g_bra.bradate=g_today
        CALL i500_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bra.*=g_bra_t.*
            LET g_bra.bra01 = g_bra01_t
            LET g_bra.bra06 = g_bra06_t
            LET g_bra.bra011 = g_bra011_t 
            CALL i500_show()
            CALL cl_err('','9001',0)
            LET g_bp_flag ="main"
            EXIT WHILE
        END IF
        IF (g_bra.bra01 != g_bra01_t) OR (g_bra.bra06 != g_bra06_t)
     #  OR (g_bra.bra011 != g_bra011_t) OR (g_bra.bra012 != g_bra012_t)    #FUN-B20101
     #  OR (g_bra.bra013 != g_bra013_t) THEN            # 更改單號         #FUN-B20101
        OR (g_bra.bra011 != g_bra011_t) THEN    #FUN-B20101
            UPDATE brb_file SET brb01 = g_bra.bra01,
                                brb29 = g_bra.bra06,
                                brb011= g_bra.bra011 
                             #  brb012=g_bra.bra012,     #FUN-B20101
                             #  brb013=g_bra.bra013      #FUN-B20101
                WHERE brb01 = g_bra01_t
                  AND brb29 = g_bra06_t
                  AND brb011=g_bra011_t
                # AND brb012=g_bra012_t               #FUN-B20101
                # AND brb013=g_bra013_t               #FUN-B20101
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","brb_file",g_bra01_t,g_bra06_t,SQLCA.sqlcode,"","brb",1)  #No.TQC-660046
                CONTINUE WHILE   
            ELSE #新增料件時系統參數(sma18 低階碼是重新計算)
                 UPDATE sma_file SET sma18 = 'Y' WHERE sma00 = '0'
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  
                 END IF
            END IF
        END IF
       #UPDATE bra_file SET bra_file.* = g_bra.*
        #FUN-B20101--modity
        UPDATE bra_file SET bra_file.bra01 = g_bra.bra01,
                            bra_file.bra04 = g_bra.bra04,
                            bra_file.bra05 = g_bra.bra05,
                            bra_file.bra06 = g_bra.bra06,
                            bra_file.bra08 = g_bra.bra08,
                            bra_file.bra10 = g_bra.bra10,
                            bra_file.bra011= g_bra.bra011,
                            bra_file.bra014= g_bra.bra014
        #FUN-B20101--modity
            WHERE bra01=g_bra01_t AND bra06=g_bra01_t
           #  AND bra011=g_bra011_t AND bra012=g_bra012_t         #FUN-B20101
           #  AND bra013=g_bra013_t                               #FUN-B20101
              AND bra011=g_bra011_t                               #FUN-B20101
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","bra_file",g_bra01_t,g_bra06_t,SQLCA.sqlcode,"","",1) 
            CONTINUE WHILE
        END IF
        CALL i500_list_cs(g_wc,g_wc2) #FUN-B30033 jan add
        CALL i500_list_fill()
#        CASE aws_mdmdata('bra_file','update',g_bra.bra01,base.TypeInfo.create(g_bra),'CreateBOMData') 
#           WHEN 0  #無與 MDM 整合
#                MESSAGE 'UPDATE O.K'
#           WHEN 1  #呼叫 MDM 成功
#                MESSAGE 'UPDATE O.K, UPDATE MDM O.K'
#           WHEN 2  #呼叫 MDM 失敗
#                ROLLBACK WORK
#                BEGIN WORK
#                CONTINUE WHILE
#        END CASE
# 
        EXIT WHILE
    END WHILE
 #  CLOSE i500_cl       #FUN-B20101
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i500_i(p_cmd)
DEFINE
    p_cmd     LIKE type_file.chr1,       #a:輸入 u:更改
    l_cmd     LIKE type_file.chr50    
 
    DISPLAY BY NAME g_bra.bra05,g_bra.bra10,g_bra.brauser,g_bra.bramodu,  
                    g_bra.bragrup,g_bra.bradate,g_bra.braacti,g_bra.braoriu,
                    g_bra.braorig
    CALL cl_set_head_visible("","YES")    
    INPUT BY NAME 
      # g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013,   #FUN-B20101
        g_bra.bra01,g_bra.bra06,g_bra.bra011,                             #FUN-B20101
        g_bra.bra10,g_bra.bra014,g_bra.bra04,g_bra.bra08
        WITHOUT DEFAULTS
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i500_i_set_entry(p_cmd)
            CALL i500_i_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            IF g_sma.sma09 = 'N' THEN
               CALL cl_set_act_visible("create_item_master", FALSE)
            ELSE
               CALL cl_set_act_visible("create_item_master", TRUE)
            END IF
 
        BEFORE FIELD bra01
            IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
               NEXT FIELD bra04
            END IF
            IF g_sma.sma60 = 'Y'  # 若須分段輸入
               THEN CALL s_inp5(6,11,g_bra.bra01) RETURNING g_bra.bra01
                DISPLAY BY NAME g_bra.bra01
            END IF
 
        AFTER FIELD bra01                         #主件料號
            IF NOT cl_null(g_bra.bra01) THEN
               #FUN-AA0059 ------------------------addstart-----------------------
               IF NOT s_chk_item_no(g_bra.bra01,'') THEN
                  CALL cl_err('',g_errno,1) 
                  LET g_bra.bra01 = g_bra_o.bra01
                  DISPLAY BY NAME g_bra.bra01
                  NEXT FIELD bra01
               END IF 
               #FUN-AA0059 ------------------------add end----------------------- 
               CALL s_field_chk(g_bra.bra01,'2',g_plant,'bra01') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(g_bra.bra01,'aoo-043',1)
                  LET g_bra.bra01 = g_bra_o.bra01
                  DISPLAY BY NAME g_bra.bra01
                  NEXT FIELD bra01
               END IF
                IF g_sma.sma118 != 'Y' THEN #FUN-550014 add if 判斷
                   IF g_bra.bra01 != g_bra01_t OR g_bra01_t IS NULL THEN   #FUN-B20101
                       SELECT count(*) INTO g_cnt FROM bra_file
                           WHERE bra01 = g_bra.bra01
                             AND bra06 = g_bra.bra06 
                              AND bra011=g_bra.bra011 
                           #  AND bra012=g_bra.bra012    #FUN-B20101
                           #  AND bra013=g_bra.bra013    #FUN-B20101
                       IF g_cnt > 0 THEN   #資料重復
                           CALL cl_err(g_bra.bra01,-239,0)
                           LET g_bra.bra01 = g_bra01_t
                           DISPLAY BY NAME g_bra.bra01
                           NEXT FIELD bra01
                       END IF
                   END IF
                ELSE
                   IF NOT cl_null(g_bra.bra06) AND 
                      ((g_bra.bra01 != g_bra01_t OR g_bra01_t IS NULL) OR
                      (g_bra.bra06 != g_bra06_t OR g_bra06_t IS NULL)) THEN
                       SELECT count(*) INTO g_cnt FROM bra_file
                           WHERE bra01 = g_bra.bra01
                             AND bra06 = g_bra.bra06 
                             AND bra011=g_bra.bra011 
                         #   AND bra012=g_bra.bra012     #FUN-B20101
                         #   AND bra013=g_bra.bra013     #FUN-B20101
                       IF g_cnt > 0 THEN   #資料重復
                           CALL cl_err('',-239,0)
                           LET g_bra.bra01 = g_bra01_t
                           LET g_bra.bra06 = g_bra06_t
                           DISPLAY BY NAME g_bra.bra01
                           DISPLAY BY NAME g_bra.bra06
                           NEXT FIELD bra01
                       END IF
                   END IF
                END IF
                IF g_bra.bra01 != g_bra01_t OR g_bra01_t IS NULL THEN     
                   CALL i500_bra01('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_bra.bra01,g_errno,0)
                      LET g_bra.bra01 = g_bra_o.bra01
                      DISPLAY BY NAME g_bra.bra01
                      NEXT FIELD bra01
                   END IF
                   CALL i500_check()
                   IF NOT cl_null(g_errno) THEN 
                      CALL cl_err('',g_errno,1)
                      NEXT FIELD bra011 
                   END IF                    
                END IF    
            END IF 
            IF cl_null(g_bra.bra01) THEN 
               NEXT FIELD bra01
            END IF 
            CALL i500_set_bra014()   #TQC-B20087
            
        AFTER FIELD bra06                         #特性代碼
               IF cl_null(g_bra.bra06) THEN
                   LET g_bra.bra06 = ' '
               END IF
            IF NOT cl_null(g_bra.bra01) AND g_bra.bra06 IS NOT NULL AND g_sma.sma118 = 'Y' THEN     
                IF (g_bra.bra01 != g_bra01_t OR g_bra01_t IS NULL) OR
                   (g_bra.bra06 != g_bra06_t OR g_bra06_t IS NULL) THEN
#                    SELECT count(*) INTO g_cnt FROM bra_file
#                        WHERE bra01 = g_bra.bra01
#                          AND bra06 = g_bra.bra06 
#                    IF g_cnt > 0 THEN   #資料重復
#                        CALL cl_err('',-239,0)
#                        LET g_bra.bra01 = g_bra01_t
#                        LET g_bra.bra06 = g_bra06_t
#                        DISPLAY BY NAME g_bra.bra01
#                        DISPLAY BY NAME g_bra.bra06
#                        NEXT FIELD bra01
#                    END IF
                   CALL i500_check()
                   IF NOT cl_null(g_errno) THEN 
                      CALL cl_err('',g_errno,1)
                      NEXT FIELD bra06 
                   END IF 
                END IF
            END IF
            
        AFTER FIELD bra011                           
            IF NOT cl_null(g_bra.bra011) THEN 
               IF p_cmd='a' OR (p_cmd='u' AND g_bra.bra011 !=g_bra011_t) THEN 
                  CALL i500_check()
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD bra011 
                  END IF 
                  CALL i500_bra011()
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD bra011 
                  END IF                   
               END IF 
            END IF 
            #IF cl_null(g_bra.bra011) THEN 
            IF g_bra.bra011 IS NULL THEN 
               NEXT FIELD bra011
            END IF
            CALL i500_set_bra014()   #TQC-B20087
    #FUN-B20101--mark--begin        
   #    AFTER FIELD bra012                          
   #       #IF NOT cl_null(g_bra.bra012) THEN   #FUN-B20101
   #        IF NOT cl_null(g_bra1[l_ac2].bra012) THEN   #FUN-B20101 
   #       #    IF p_cmd='a' OR (p_cmd='u' AND g_bra.bra012 !=g_bra01_t2) THEN 
   #           IF p_cmd='a' OR (p_cmd='u' AND g_bra1[l_ac2].bra012!=g_bra1_t.bra012) THEN   #FUN-B20101
   #              CALL i500_check()
   #              IF NOT cl_null(g_errno) THEN 
   #                 CALL cl_err('',g_errno,1)
   #                 NEXT FIELD bra012 
   #              END IF 
   #              CALL i500_bra012()
   #              IF NOT cl_null(g_errno) THEN 
   #                 CALL cl_err('',g_errno,1)
   #                 NEXT FIELD bra012 
   #              END IF                   
   #           END IF 
   #        END IF 
   #      #  IF g_bra.bra012 IS NULL THEN        #FUN-B20101
   #        IF g_bra1[l_ac2].bra012 IS NULL THEN #FUN-B20101
   #           #NEXT FIELD bra012
   #         #  LET g_bra.bra012=' '             #FUN-B20101
   #            LET g_bra1[l_ac2].bra012 = ' '             #FUN-B20101
   #        END IF            
            
   #    AFTER FIELD bra013                          
   #      #  IF NOT cl_null(g_bra.bra013) THEN       #FUN-B20101
   #      #     IF p_cmd='a' OR (p_cmd='u' AND g_bra.bra013 !=g_bra01_t3) THEN  #FUN-B20101
   #         IF NOT cl_null(g_bra1[l_ac2].bra013) THEN       #FUN-B20101
   #            IF p_cmd='a' OR (p_cmd='u' AND g_bra1[l_ac2].bra013 != g_bra1_t.bra013) THEN  #FUN-B20101
   #              CALL i500_check()
   #              IF NOT cl_null(g_errno) THEN 
   #                 CALL cl_err('',g_errno,1)
   #                 NEXT FIELD bra013 
   #              END IF 
   #              CALL i500_bra013()
   #              IF NOT cl_null(g_errno) THEN 
   #                 CALL cl_err('',g_errno,1)
   #                 NEXT FIELD bra013 
   #              END IF                   
   #           END IF 
   #        END IF 
   #        #IF cl_null(g_bra.bra013) THEN 
   #      # IF g_bra.bra013 IS NULL THEN   #FUN-B20101
   #        IF g_bra1[l_ac2].bra013 IS NULL THEN   #FUN-B20101 
   #           NEXT FIELD bra013
   #        END IF
   #FUN-B20101--mark--end  
        AFTER FIELD bra014
            IF NOT cl_null(g_bra.bra014) THEN 
               IF g_bra.bra014='Y' THEN 
                  CALL i500_bra014()
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD bra014 
                  END IF 
               END IF 
            END IF       
            
        ON CHANGE bra014 
            IF g_bra.bra014='Y' THEN 
               CALL i500_bra014()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,1)
                  LET g_bra.bra014=g_bra_t.bra014
                  NEXT FIELD bra014 
               END IF 
            END IF     
                                                      
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
  
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP     #查詢條件
            CASE
               WHEN INFIELD(bra01) #料件主檔
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = g_bra.bra01
                 #   CALL cl_create_qry() RETURNING g_bra.bra01
                    CALL q_sel_ima(FALSE, "q_ima", "", g_bra.bra01, "", "", "", "" ,"",'' )  RETURNING g_bra.bra01
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_bra.bra01
                    NEXT FIELD bra01
               WHEN INFIELD(bra011) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ecu02_3"         #FUN-B20101
                    LET g_qryparam.arg1 = g_bra.bra01
                    LET g_qryparam.default1 = g_bra.bra011
                #FUN-B20101--modify
                #   LET g_qryparam.default2 = g_bra.bra012
                #   CALL cl_create_qry() RETURNING g_bra.bra011,g_bra.bra012
                #   DISPLAY BY NAME g_bra.bra011,g_bra.bra012
                    CALL cl_create_qry() RETURNING g_bra.bra011
                    DISPLAY BY NAME g_bra.bra011
                #FUN-B20101--modify
                    NEXT FIELD bra011
       #FUN-B20101--mark--begin
        #      WHEN INFIELD(bra012) 
        #           CALL cl_init_qry_var()
        #           LET g_qryparam.form = "q_ecu02_1"
        #           LET g_qryparam.arg1 = g_bra.bra01
#       #            LET g_qryparam.arg2 = g_bra.bra011
        #           LET g_qryparam.default1 = g_bra.bra011
        #      #FUN-B20101--modify    
        #      #    LET g_qryparam.default2 = g_bra.bra012
        #      #    CALL cl_create_qry() RETURNING g_bra.bra011,g_bra.bra012
        #      #    DISPLAY BY NAME g_bra.bra011,g_bra.bra012
        #           LET g_qryparam.default2 = g_bra1[l_ac2].bra012
        #           CALL cl_create_qry() RETURNING g_bra.bra011,g_bra1[l_ac2].bra012
        #           DISPLAY BY NAME g_bra.bra011,g_bra1[l_ac2].bra012
        #      #FUN-B20101--modify
        #           NEXT FIELD bra012
        #      WHEN INFIELD(bra013) 
        #           CALL cl_init_qry_var()
        #           LET g_qryparam.form = "q_ecb03_1"
        #           LET g_qryparam.arg1 = g_bra.bra01
        #           LET g_qryparam.arg2 = g_bra.bra011
        #      #FUN-B20101--modify
        #     #     LET g_qryparam.arg3 = g_bra.bra012
        #     #     LET g_qryparam.default1 = g_bra.bra013
        #     #     CALL cl_create_qry() RETURNING g_bra.bra013
        #     #     DISPLAY BY NAME g_bra.bra013
        #           LET g_qryparam.arg3 = g_bra1[l_ac2].bra012
        #           LET g_qryparam.default1 = g_bra1[l_ac2].bra013
        #           CALL cl_create_qry() RETURNING g_bra1[l_ac2].bra013
        #           DISPLAY BY NAME g_bra1[l_ac2].bra013
        #     #FUN-B20101--modify
        #           NEXT FIELD bra013       
        #FUN-B20101--mark--end                                                     
               OTHERWISE EXIT CASE
             END CASE
 
        ON ACTION create_item_master   #建立料建資料
             IF g_sma.sma09 = 'Y' THEN
                IF s_industry('slk') THEN LET l_cmd = "aimi100_slk '",g_bra.bra01,"'" END IF  
                IF s_industry('icd') THEN LET l_cmd = "aimi100_icd '",g_bra.bra01,"'" END IF  
                IF s_industry('std') THEN LET l_cmd = "aimi100 '",g_bra.bra01,"'" END IF  
                IF cl_null(l_cmd) THEN LET l_cmd = "aimi100 '",g_bra.bra01,"'" END IF
                CALL cl_cmdrun(l_cmd)
                NEXT FIELD bra01
             ELSE
                CALL cl_err(' ','asm-625',0)
                NEXT FIELD bra01
             END IF
 
      ON ACTION about      
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help() 
 
    END INPUT
END FUNCTION

FUNCTION i500_check()
DEFINE   l_n   LIKE type_file.num5 
    LET g_errno=' '
    IF NOT cl_null(g_bra.bra01) AND NOT cl_null(g_bra.bra011) 
     # AND NOT cl_null(g_bra.bra012) AND NOT cl_null(g_bra.bra013)  #FUN-B20101
       AND g_bra.bra06 IS NOT NULL  THEN 
       SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bra.bra01
     #    AND bra011=g_bra.bra011 AND bra012=g_bra.bra012     #FUN-B20101 
     #    AND bra013=g_bra.bra013 AND bra06=g_bra.bra06       #FUN-B20101
          AND bra011=g_bra.bra011                             #FUN-B20101
          AND bra06 =g_bra.bra06                              #FUN-B20101
       IF l_n>0 THEN 
          LET g_errno='abm-212'
       END IF 
    END IF 
    
END FUNCTION 
 

FUNCTION i500_bra011()
DEFINE   l_n        LIKE type_file.num5 
DEFINE   l_n1       LIKE type_file.num5 
DEFINE   l_ecu10    LIKE ecu_file.ecu10
DEFINE   l_ecuacit  LIKE ecu_file.ecuacti 
DEFINE   l_ecu03    LIKE ecu_file.ecu03
DEFINE   l_ecu014   LIKE ecu_file.ecu014 

    LET g_errno=' '
    IF cl_null(g_bra.bra01) THEN 
       CALL cl_err('','abm-211',1)
       RETURN 
    END IF 
#    SELECT ecu10,ecuacti INTO l_ecu10,l_ecuacti  FROM ecu_file WHERE ecu01=g_bra.bra01 AND ecu02=g_bra.bra011 
#    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
#         WHEN l_ecuacti='N'        LET g_errno = '9028'
#         WHEN l_ecu10 !='Y'        LET g_errno = 'mfg3550'
#         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE        
    SELECT COUNT(*) INTO l_n FROM ecu_file WHERE ecu01=g_bra.bra01 AND ecu02=g_bra.bra011 AND ecuacti='Y' AND ecu10='Y' 
    IF l_n=0 THEN 
       LET g_errno='mfg4030'
    ELSE 
       SELECT DISTINCT ecu03 INTO l_ecu03 FROM ecu_file WHERE ecu01=g_bra.bra01 AND ecu02=g_bra.bra011
       DISPLAY l_ecu03 TO ecu03
#      IF NOT cl_null(g_bra.bra012) THEN             #FUN-B20101
#         SELECT ecu014 INTO l_ecu014 FROM ecu_file 
#           WHERE ecu01=g_bra.bra01 AND ecu02=g_bra.bra011
#             AND ecu012=g_bra.bra012                #FUN-B20101
#            DISPLAY l_ecu014 TO ecu014
#      END IF 
       SELECT COUNT(*) INTO l_n1 FROM bra_file WHERE bra01=g_bra.bra01 AND bra011=g_bra.bra011 AND bra014='Y' 
       IF l_n1>0 THEN
          LET g_bra.bra014='Y' 
          DISPLAY BY NAME g_bra.bra014
       END IF 
    END IF 
    
END FUNCTION 

#TQC-B20087--begin--add---
FUNCTION i500_set_bra014()
DEFINE l_cnt      LIKE type_file.num5

  IF NOT cl_null(g_bra.bra01) AND NOT cl_null(g_bra.bra011) THEN
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM bra_file
      WHERE bra01=g_bra.bra01  AND bra014='Y'
     IF l_cnt = 0 THEN
        SELECT COUNT(*) INTO l_cnt FROM ima_file 
         WHERE ima01=g_bra.bra01 AND ima94=g_bra.bra011 AND imaacti='Y'
        IF l_cnt > 0 THEN 
           LET g_bra.bra014='Y'
           DISPLAY BY NAME g_bra.bra014
        END IF
     END IF
  END IF
END FUNCTION
#TQC-B20087--end--add------

FUNCTION i500_bra012(p_bra012)
DEFINE   l_n        LIKE type_file.num5 
DEFINE   l_ecu10    LIKE ecu_file.ecu10
DEFINE   l_ecuacti  LIKE ecu_file.ecuacti 
DEFINE   l_ecu014   LIKE ecu_file.ecu014 
DEFINE   p_bra012   LIKE bra_file.bra012   #FUN-B20101
    LET g_errno=' '
    SELECT ecu014,ecu10,ecuacti INTO l_ecu014,l_ecu10,l_ecuacti  FROM ecu_file 
     WHERE ecu01=g_bra.bra01 AND ecu02=g_bra.bra011
     # AND ecu012=g_bra.bra012     #FUN-B20101
       AND ecu012=p_bra012         #FUN-B20101
        
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-214'
         WHEN l_ecuacti='N'        LET g_errno = '9028'
         WHEN l_ecu10 !='Y'        LET g_errno = 'mfg3550'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
  #  DISPLAY l_ecu014 TO g_bra1[l_ac2].ecu014
     LET g_bra1[l_ac2].ecu014 = l_ecu014
     DISPLAY BY NAME g_bra1[l_ac2].ecu014
END FUNCTION 

FUNCTION i500_bra013(p_bra012,p_bra013)
DEFINE   l_n        LIKE type_file.num5 
DEFINE   l_ecbacti  LIKE ecb_file.ecbacti 
DEFINE   l_ecb17    LIKE ecb_file.ecb17
DEFINE   p_bra012   LIKE bra_file.bra012   #FUN-B20101
DEFINE   p_bra013   LIKE bra_file.bra013   #FUN-B20101
    LET g_errno=' '
    SELECT ecbacti INTO l_ecbacti  FROM ecb_file 
     WHERE ecb01=g_bra.bra01 AND ecb02=g_bra.bra011
     # AND ecb012=g_bra.bra012 AND ecb03=g_bra.bra013    #FUN-B20101
       AND ecb012=p_bra012 AND ecb03=p_bra013            #FUN-B20101
        
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-215'
         WHEN l_ecbacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
    IF cl_null(g_errno) THEN 
       SELECT ecb06,ecb17 INTO g_ecb06,l_ecb17 FROM ecb_file 
        WHERE ecb01=g_bra.bra01 AND ecb02=g_bra.bra011
       #  AND ecb012=g_bra.bra012 AND ecb03=g_bra.bra013   #FUN-B20101
          AND ecb012=p_bra012 AND ecb03=p_bra013           #FUN-B20101   
    #  DISPLAY g_ecb06 TO g_bra1[l_ac2].ecb06    
    #  DISPLAY l_ecb17 TO g_bra1[l_ac2].ecb17
       LET g_bra1[l_ac2].ecb06 = g_ecb06 
       LET g_bra1[l_ac2].ecb17 = l_ecb17
       DISPLAY BY NAME g_bra1[l_ac2].ecb06
       DISPLAY BY NAME g_bra1[l_ac2].ecb17
    END IF 
END FUNCTION 

FUNCTION i500_bra014()
DEFINE   l_bra011 LIKE bra_file.bra011
    LET g_errno=' '
    DECLARE i500_bra011 CURSOR FOR SELECT DISTINCT bra011 FROM bra_file WHERE bra01=g_bra.bra01 AND bra014='Y' 
    FOREACH i500_bra011 INTO l_bra011
        IF l_bra011 !=g_bra.bra011 THEN 
           LET g_errno='abm-217' 
           EXIT FOREACH 
        END IF 
    END FOREACH 
END FUNCTION 

FUNCTION i500_bra01(p_cmd)  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,  
           l_bmz01   LIKE bmz_file.bmz01,
           l_bmz03   LIKE bmz_file.bmz03,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima55   LIKE ima_file.ima55,
           l_ima05   LIKE ima_file.ima05,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT  ima02,ima021,ima55, ima08,imaacti,ima05
       INTO l_ima02,l_ima021,l_ima55, g_ima08_h,l_imaacti,
            l_ima05
       FROM ima_file
      WHERE ima01 = g_bra.bra01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02 = NULL LET l_ima021 = NULL
                            LET l_ima55 = NULL LET g_ima08_h = NULL
                            LET l_imaacti = NULL
                            LET l_ima05=NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02   TO FORMONLY.ima02_h
           DISPLAY l_ima021  TO FORMONLY.ima021_h
           DISPLAY g_ima08_h TO FORMONLY.ima08_h
           DISPLAY l_ima55   TO FORMONLY.ima55
           DISPLAY l_ima05   TO FORMONLY.ima05_h
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i500_q(p_idx)   
    DEFINE p_idx  LIKE type_file.num5    #雙按Tree的節點index 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
  # INITIALIZE g_bra.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
  # CALL g_bra1.clear()         #FUN-B20101
  # CALL g_brb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i500_curs(p_idx)      #取得查詢條件   
    IF INT_FLAG THEN
        INITIALIZE g_bra.* TO NULL
        CALL g_bra_l.clear()
        CALL g_tree.clear()
        LET g_tree_focus_idx =0
        LET INT_FLAG = 0
        LET g_bp_flag ="main"
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i500_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bra.* TO NULL
    ELSE
        OPEN i500_count
        FETCH i500_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt

         IF p_idx = 0 THEN
           CALL i500_fetch('F',0)        #讀出TEMP第一筆並顯示
           #CALL i500_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #Tree填充
        ELSE
           #Tree的最上層是QBE結果，才可以指定jump
           IF g_tree[p_idx].level = 1 THEN
              CALL i500_fetch('T',p_idx) #讀出TEMP中，雙點Tree的指定節點並顯示
           ELSE
              CALL i500_fetch('F',0)
           END IF
        END IF
        CALL i500_list_cs(g_wc,g_wc2) #FUN-B30033 jan add
        CALL i500_list_fill()     
        LET g_bp_flag = NULL     
        CALL i500_fetch('F',0)                  # 讀出TEMP第一筆并顯示
    END IF 
    MESSAGE " "
END FUNCTION
 
FUNCTION i500_list_fill()
  DEFINE l_bra01         LIKE bra_file.bra01
  DEFINE l_bra06         LIKE bra_file.bra06
  DEFINE l_bra011        LIKE bra_file.bra011
  DEFINE l_bra012        LIKE bra_file.bra012
  DEFINE l_bra013        LIKE bra_file.bra013  
  DEFINE l_i             LIKE type_file.num10
 
    CALL g_bra_l.clear()
    LET l_i = 1
  # FOREACH i500_list_cur INTO l_bra01,l_bra06,l_bra011,l_bra012,l_bra013   #FUN-B20101
    FOREACH i500_list_cur INTO l_bra01,l_bra06,l_bra011                     #FUN-B20101
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach list_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
  #    SELECT bra01,bra06,bra011,bra012,bra013,ima02,ima021,ima55,ima05,ima08,bra05,bra08  #FUN-B30033
       SELECT DISTINCT bra01,bra06,bra011,ima02,ima021,ima55,ima05,ima08,bra05,bra08  #FUN-B30033 
         INTO g_bra_l[l_i].*
         FROM bra_file, ima_file
        WHERE bra01=l_bra01
          AND bra06=l_bra06
          AND bra011=l_bra011
       #  AND bra012=l_bra012                                                #FUN-B20101
       #  AND bra013=l_bra013                                                #FUN-B20101
          AND bra01=ima_file.ima01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_bra_l TO s_bra_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION

FUNCTION i500_bp_refresh()
   DISPLAY ARRAY g_brb TO s_brb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION
 
FUNCTION i500_fetch(p_flag,p_idx)    
DEFINE
    p_flag     LIKE type_file.chr1       #處理方式
    
DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index  
DEFINE l_i       LIKE type_file.num5     
DEFINE l_jump    LIKE type_file.num5     #跳到QBE中Tree的指定筆

    MESSAGE ""
    IF p_flag = 'T' AND p_idx <= 0 THEN      #Tree index錯誤就改讀取第一筆資料
       LET p_flag = 'F'
    END IF
   CASE p_flag
   #FUN-B20101--modify
   #    WHEN 'N' FETCH NEXT     i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013 
   #    WHEN 'P' FETCH PREVIOUS i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013 
   #    WHEN 'F' FETCH FIRST    i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013
   #    WHEN 'L' FETCH LAST     i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013
        WHEN 'N' FETCH NEXT     i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011
        WHEN 'P' FETCH PREVIOUS i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011
        WHEN 'F' FETCH FIRST    i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011
        WHEN 'L' FETCH LAST     i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011
   #FUN-B20101--modify
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0 
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
            LET mi_no_ask = FALSE
         #  FETCH ABSOLUTE g_jump i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013 
            FETCH ABSOLUTE g_jump i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011      #FUN-B20101
        #Tree雙點指定筆
        WHEN 'T'
           #讀出TEMP中，雙點Tree的指定節點並顯示
           LET l_jump = 0
           IF g_tree[p_idx].level = 1 THEN   #最高層              
              LET l_jump = g_tree[p_idx].id  #ex:當id=5，表示要跳到第5筆
           END IF
           IF l_jump <= 0 THEN
              LET l_jump = 1
           END IF
           LET g_jump = l_jump
      #    FETCH ABSOLUTE g_jump i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013      
           FETCH ABSOLUTE g_jump i500_curs INTO g_bra.bra01,g_bra.bra06,g_bra.bra011        #FUN-B20101  
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)
       INITIALIZE g_bra.* TO NULL 
       DISPLAY BY NAME g_bra.braoriu,g_bra.braorig, 
        g_bra.bra01,g_bra.bra011,                  
        g_bra.bra06,g_bra.bra10,g_bra.bra014,g_bra.bra04,g_bra.bra05,
        g_bra.brauser,g_bra.bragrup,g_bra.bramodu,                  
        g_bra.bradate,g_bra.braacti,g_bra.bra08                    
       RETURN
    ELSE
       CALL i500_show()    #FUN-B30033
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
  #SELECT * INTO g_bra.* FROM bra_file                  #FUN-B20101
#    SELECT DISTINCT braoriu,braorig,bra01,bra011,bra06,bra10,bra014,bra04,bra05,
#                    brauser,bragrup,bramodu,bradate,braacti,bra08
#               INTO g_bra.braoriu,g_bra.braorig,
#                    g_bra.bra01,g_bra.bra011,
#                    g_bra.bra06,g_bra.bra10,g_bra.bra014,g_bra.bra04,g_bra.bra05,
#                    g_bra.brauser,g_bra.bragrup,g_bra.bramodu,
#                    g_bra.bradate,g_bra.braacti,g_bra.bra08
#    FROM bra_file 
#    WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06 
#     # AND bra011=g_bra.bra011 AND bra012=g_bra.bra012   #FUN-B20101
#    # AND bra013=g_bra.bra013                           #FUN-B20101
#      AND bra011=g_bra.bra011                           #FUN-B20101
#   IF SQLCA.sqlcode THEN
#       CALL cl_err3("sel","bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1) 
#       INITIALIZE g_bra.* TO NULL
#       RETURN
#   ELSE
#       LET g_data_owner = g_bra.brauser     
#       LET g_data_group = g_bra.bragrup      
#   END IF
#  CALL i500_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i500_show()
DEFINE l_count    LIKE type_file.num5   
DEFINE l_ecb06    LIKE ecb_file.ecb06 
DEFINE l_ecb17    LIKE ecb_file.ecb17
DEFINE l_ecu03    LIKE ecu_file.ecu03
DEFINE l_ecu014   LIKE ecu_file.ecu014
  # LET g_bra_t.* = g_bra.*                #保存單頭舊值
#MOD-B30502--add--begin
         SELECT DISTINCT braoriu,braorig,bra01,bra011,bra06,bra10,bra014,bra04,bra05,
                    brauser,bragrup,bramodu,bradate,braacti,bra08
               INTO g_bra.braoriu,g_bra.braorig,
                    g_bra.bra01,g_bra.bra011,
                    g_bra.bra06,g_bra.bra10,g_bra.bra014,g_bra.bra04,g_bra.bra05,
                    g_bra.brauser,g_bra.bragrup,g_bra.bramodu,
                    g_bra.bradate,g_bra.braacti,g_bra.bra08
    FROM bra_file
    WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06
      AND bra011=g_bra.bra011                           #FUN-B20101
   IF SQLCA.sqlcode THEN
       INITIALIZE g_bra.* TO NULL
   ELSE
       LET g_data_owner = g_bra.brauser
       LET g_data_group = g_bra.bragrup
   END IF
#MOD-B30502--add--end
    DISPLAY BY NAME g_bra.braoriu,g_bra.braorig,                              # 顯示單頭值
      # g_bra.bra01,g_bra.bra011,g_bra.bra012,g_bra.bra013,                   #FUN-B20101
        g_bra.bra01,g_bra.bra011,                                             #FUN-B20101
        g_bra.bra06,g_bra.bra10,g_bra.bra014,g_bra.bra04,g_bra.bra05,
        g_bra.brauser,g_bra.bragrup,g_bra.bramodu,                          #FUN-B20101 xiugai 
        g_bra.bradate,g_bra.braacti,g_bra.bra08                             #FUN-B20101
   #FUN-B20101--mark--begin     
   #  SELECT DISTINCT ecb06,ecb17 INTO g_ecb06,l_ecb17 FROM ecb_file WHERE ecb01=g_bra.bra01
   #    AND ecb02=g_bra.bra011 AND ecb03=g_bra.bra013 
   #    AND ecb012=g_bra.bra012
   #FUN-B20101--mark--end
     SELECT DISTINCT ecu03 INTO l_ecu03 FROM ecu_file WHERE ecu01=g_bra.bra01 
     AND ecu02=g_bra.bra011 
     #AND ecu012=g_bra.bra012
   #FUN-B20101--mark--begin
   #  SELECT DISTINCT ecu014 INTO l_ecu014 FROM ecu_file WHERE ecu01=g_bra.bra01 
   #  AND ecu02=g_bra.bra011 AND ecu012=g_bra.bra012
   #  DISPLAY g_ecb06 TO FORMONLY.ecb06 
   #  DISPLAY l_ecb17 TO FORMONLY.ecb17  
   #FUN-B20101--mark--end
     DISPLAY l_ecu03 TO FORMONLY.ecu03
   #  DISPLAY l_ecu014 TO FORMONLY.ecu014  #FUN-B20101
     SELECT count(*)
       INTO l_count
       FROM brb_file
      WHERE brb01 = g_bra.bra01
        AND brb011=g_bra.bra011
     #  AND brb012=g_bra.bra012   #FUN-B20101
     #  AND brb013=g_bra.bra013   #FUN-B20101
        AND brb30='3'
  
         
    IF l_count = 0 THEN
#      CALL cl_set_act_visible("preview_bom", FALSE)
       CALL cl_set_act_visible("edit_formula",FALSE)  
    ELSE
#      CALL cl_set_act_visible("preview_bom", TRUE)
       CALL cl_set_act_visible("edit_formula",FALSE)
    END IF

#   CALL i500_pic()  #MOD-840435     #FUN-B30033  mark
 
    CALL i500_bra01('d')
    CALL i500_b_fill_1(g_wc)                #FUN-B20101
 #  CALL i500_b_fill(g_wc2)                 #單身  #FUN-B20101
    IF (g_bra1[1].bra012 IS NOT NULL) OR (g_bra1[1].bra013 IS NOT NULL)  THEN   
        CALL i500_b_fill(g_bra1[1].bra012,g_bra1[1].bra013)     #FUN-B20101
    END IF
#   CALL i500_bp_refresh()   #FUN-B30033  mark
    CALL i500_pic()          #FUN-B30033
    CALL cl_show_fld_cont()           
END FUNCTION
#FUN-B20101--add--begin      
FUNCTION i500_check_1(p_bra012,p_bra013)
DEFINE   l_n   LIKE type_file.num5
DEFINE   p_bra012 LIKE  bra_file.bra012
DEFINE   p_bra013 LIKE  bra_file.bra013
    LET g_errno=' '
       IF NOT cl_null(g_bra1[l_ac2].bra012) AND NOT cl_null(g_bra1[l_ac2].bra013)  #FUN-B20101
       AND g_bra.bra06 IS NOT NULL  THEN
       SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bra.bra01
          AND bra011=g_bra.bra011 AND bra012=p_bra012     #FUN-B20101
          AND bra013=p_bra013 AND bra06=g_bra.bra06       #FUN-B20101
       IF l_n>0 THEN
          LET g_errno='abm-212'
       END IF
    END IF

END FUNCTION 

FUNCTION i500_out()
  IF g_bra.bra01 IS NULL THEN
       LET g_action_choice = " "
       RETURN 
    END IF
  IF cl_null(g_wc) THEN
       LET g_wc =" bra01='",g_bra.bra01,"'",
                 " AND bra011= ",g_bra.bra011
    END IF
   CLOSE WINDOW screen
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
    LET g_wc=cl_replace_str(g_wc, "'", "\"")
    LET g_msg = "abmr003",
                " '",g_today,"' ''",
                " '",g_lang,"' 'Y' '' '1'",
                " '",g_wc CLIPPED,"' ", 
                "  '' '",g_today,"' " 

    CALL cl_cmdrun(g_msg)
   CALL cl_set_act_visible("accept,cancel", FALSE) 
END FUNCTION  
#FUN-B20101--add--end  

FUNCTION i500_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_bra.bra01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'u') THEN
       CALL cl_err(g_bra.bra08,'aoo-045',1)
       RETURN
    END IF
    IF g_bra.bra10 <>'0' THEN 
       CALL cl_err('','abm-216',1)
       RETURN
    END IF 
    BEGIN WORK
 #FUN-B20101--mark--begin
 # # OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013  #FUN-B20101
 #   OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011              #FUN-B20101
 #   IF STATUS THEN
 #      CALL cl_err("OPEN i500_cl:", STATUS, 1)
 #      CLOSE i500_cl
 #      ROLLBACK WORK
 #      RETURN
 #   END IF
 #   FETCH i500_cl INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014   # 鎖住將被更改或取消的資料#FUN-B20101
 #   IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)          #資料被他人LOCK
 #       RETURN
 #   END IF
    CALL i500_show()
 #FUN-B20101--mark--end
    IF cl_exp(0,0,g_bra.braacti) THEN
        LET g_chr=g_bra.braacti
        IF g_bra.braacti='Y' THEN
            LET g_bra.braacti='N'
        ELSE
            LET g_bra.braacti='Y'
        END IF
        UPDATE bra_file                    #更改有效碼
            SET braacti=g_bra.braacti
            WHERE bra01=g_bra.bra01
              AND bra06=g_bra.bra06   
              AND bra011=g_bra.bra011 
            # AND bra012=g_bra.bra012      #FUN-B20101
            # AND bra013=g_bra.bra013      #FUN-B20101
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)  #No.TQC-660046
            LET g_bra.braacti=g_chr
        END IF
        DISPLAY BY NAME g_bra.braacti                           #FUN-B20101 xiugai
    END IF
     LET g_bp_flag = "main"
  # CLOSE i500_cl        #FUN-B20101
    COMMIT WORK
END FUNCTION
#bom发放 
FUNCTION i500_j()
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_brb01  LIKE brb_file.brb01 
   DEFINE l_brb02  LIKE brb_file.brb02 
   DEFINE l_brb03  LIKE brb_file.brb03 
   DEFINE l_brb04  LIKE brb_file.brb04 
   DEFINE l_ima01   LIKE ima_file.ima01   
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_brb012  LIKE brb_file.brb012  #FUN-B20101
   DEFINE l_brb013  LIKE brb_file.brb013  #FUN-B20101
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bra.bra01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'u') THEN
       CALL cl_err(g_bra.bra08,'aoo-045',1)
       RETURN
    END IF
    SELECT ima01,imaacti INTO l_ima01,l_imaacti FROM ima_file 
     WHERE ima01 = g_bra.bra01
     IF l_imaacti = 'N' THEN 
        CALL cl_err('','9028',0)
        RETURN 
     END IF
     IF l_imaacti MATCHES '[PH]' THEN
        CALL cl_err('','abm-038',0)   #TQC-9C0192
        RETURN
     END IF  
    IF g_bra.bra10 = 0 THEN CALL cl_err('','aco-174',0) RETURN END IF  
    IF g_bra.bra10 = 2 THEN CALL cl_err('','abm-003',0) RETURN END IF 
    IF g_bra.braacti='N' THEN
       CALL cl_err(g_bra.braacti,'aap-127',0) RETURN
    END IF
    IF NOT cl_null(g_bra.bra05) THEN
       CALL cl_err(g_bra.bra05,'abm-003',0) RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM brb_file WHERE brb01 = g_bra.bra01 AND brb29 = g_bra.bra06 
                                 #FUN-B20101--modity
                                            #  AND brb011= g_bra.bra011 AND brb012= g_bra.bra012  
                                            #  AND brb013= g_bra.bra013
                                               AND brb011= g_bra.bra011 
                                 #FUN-B20101--modity
    IF g_cnt=0 THEN
       CALL cl_err(g_bra.bra01,'arm-034',0) RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bra.bra01 AND bra014='Y' 
    IF l_n=0 THEN 
#       CALL cl_err(g_bra.bra01,'arm-',0) RETURN
        IF NOT cl_confirm('abm-218') THEN 
           CALL cl_err('','abm-223',1)
           RETURN 
        ELSE
           LET g_bra.bra014='Y'       #MOD-B30502 
     	   UPDATE bra_file SET bra014=g_bra.bra014 WHERE bra01=g_bra.bra01 AND bra011=g_bra.bra011 AND bra06=g_bra.bra06
#          AND bra012=g_bra.bra012 AND bra013=g_bra.bra013 AND bra06=g_bra.bra06
           DISPLAY BY NAME g_bra.bra014   #MOD-B30502
        END IF 
    END IF 
    BEGIN WORK
#FUN-B20101--mark--begin 
#   OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013
#   OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011                 #FUN-B20101
#    IF STATUS THEN
#       CALL cl_err("OPEN i500_cl:", STATUS, 1)
#       CLOSE i500_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#  #  FETCH i500_cl INTO g_bra.*     #FUN-B20101
#    FETCH i500_cl INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014        
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0) RETURN
#    END IF
#   CALL i500_show()
#FUN-B20101--mark--end
    IF NOT cl_confirm('abm-004') THEN RETURN END IF
    LET g_bra.bra05=g_today
    CALL cl_set_head_visible("","YES")  
    INPUT BY NAME g_bra.bra05 WITHOUT DEFAULTS
 
      AFTER FIELD bra05
        IF cl_null(g_bra.bra05) THEN NEXT FIELD bra05 END IF
 
      AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
        IF cl_null(g_bra.bra05) THEN NEXT FIELD bra05 END IF
 
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
       LET g_bra.bra05=NULL
       DISPLAY BY NAME g_bra.bra05
       LET INT_FLAG=0
       ROLLBACK WORK
       RETURN
    END IF
    UPDATE bra_file SET bra05=g_bra.bra05, 
                        bra10='2'          
                  WHERE bra01=g_bra.bra01
                    AND bra06=g_bra.bra06
                    AND bra011=g_bra.bra011  
                #   AND bra012=g_bra.bra012   #FUN-B20101
                #   AND bra013=g_bra.bra013   #FUN-B20101
    IF SQLCA.SQLERRD[3]=0 THEN
       LET g_bra.bra05=NULL
       DISPLAY BY NAME g_bra.bra05
       CALL cl_err3("upd","bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","up bra05",1)  #No.TQC-660046
       ROLLBACK WORK
       RETURN
    END IF
    #FUN-B10018--begin--
    IF g_bra.bra014='Y' THEN 
       CALL i500_updbma()
    END IF     
    #FUN-B10018--end---
    DECLARE i500_up_cs CURSOR FOR
     SELECT brb01,brb02,brb03,brb04,brb012,brb013   #FUN-B20101
       FROM brb_file
      WHERE brb01 = g_bra.bra01
        AND brb29 = g_bra.bra06 
        AND brb011=g_bra.bra011
       #AND brb012=g_bra.bra012  #FUN-B20101
       #AND brb013=g_bra.bra013  #FUN-B20101
        AND (brb05 > g_bra.bra05 OR brb05 IS NULL )
    LET g_success = 'Y'
    FOREACH i500_up_cs INTO l_brb01,l_brb02,l_brb03,l_brb04,l_brb012,l_brb013  #FUN-B20101
        UPDATE brb_file
           SET brb04 = g_bra.bra05
         WHERE brb01 = l_brb01
           AND brb02 = l_brb02
           AND brb03 = l_brb03
           AND brb04 = l_brb04
           AND brb011=g_bra.bra011
        #  AND brb012=g_bra.bra012 #FUN-B20101
        #  AND brb013=g_bra.bra013 #FUN-B20101     
           AND brb012=l_brb012     #FUN-B20101
           AND brb013=l_brb013     #FUN-B20101          
        IF SQLCA.SQLERRD[3]=0 THEN
           LET g_bra.bra05=NULL
           DISPLAY BY NAME g_bra.bra05
           CALL cl_err3("upd","brb_file",l_brb01,l_brb02,SQLCA.sqlcode,"","up brb04",1)  
           LET g_success = 'N'
           EXIT FOREACH
        END IF
    END FOREACH
    ###################################
    CALL i500_list_cs(g_wc,g_wc2) #FUN-B30033 jan add
    CALL i500_list_fill()
    #只有设定为产品BOM的资料才会在发放时更新bma_file,bmb_file
#    IF g_bra.bra014='Y' THEN 
#       CALL i500_updbma()
#    END IF 
    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
    LET g_wc2 = "     (brb04 <='", g_bra.bra05,"'"," OR brb04 IS NULL )",
                " AND (brb05 >  '",g_bra.bra05,"'"," OR brb05 IS NULL )"
    LET g_wc2 = g_wc2 CLIPPED
  # CALL i500_b_fill(g_wc2)    #FUN-B20101
    CALl i500_b_fill(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013)     #FUN-B20101
    CALL i500_bp_refresh()
    SELECT DISTINCT bra05,bra10 INTO g_bra.bra05,g_bra.bra10  FROM bra_file   #FUN-B20101
     WHERE bra01=g_bra.bra01  
       AND bra06=g_bra.bra06 
       AND bra011=g_bra.bra011 
     # AND bra012=g_bra.bra012   #FUN-B20101
     # AND bra013=g_bra.bra013   #FUN-B20101
    DISPLAY BY NAME g_bra.bra05
    DISPLAY BY NAME g_bra.bra10
 
END FUNCTION
#No.FUN-A60083--begin

#用于发放后异动单身时更新bmb_file
FUNCTION i500_updbmb(p_brb,p_brb03,p_brb06,p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1
DEFINE   l_bmb   RECORD LIKE bmb_file.*
DEFINE   p_brb   RECORD LIKE brb_file.*
DEFINE   p_brb03 LIKE brb_file.brb03 
DEFINE   p_brb06 LIKE brb_file.brb06
DEFINE   l_n     LIKE type_file.num5
DEFINE   l_brb06 LIKE brb_file.brb06 
DEFINE   l_bmb02 LIKE bmb_file.bmb02 #No.TQC-A80112
    
   #LET l_bmb.bmb06=p_brb06+g_brb[l_i].brb06
    LET l_bmb.bmb03=p_brb.brb03   LET l_bmb.bmb01=p_brb.brb01 
    LET l_bmb.bmb02=p_brb.brb02   LET l_bmb.bmb04=p_brb.brb04
    LET l_bmb.bmb05=p_brb.brb05   LET l_bmb.bmb07=p_brb.brb07
    LET l_bmb.bmb08=p_brb.brb08   LET l_bmb.bmb081=p_brb.brb081
    LET l_bmb.bmb082=p_brb.brb082 LET l_bmb.bmb09=g_ecb06
    LET l_bmb.bmb10=p_brb.brb10   LET l_bmb.bmb10_fac=p_brb.brb10_fac
    LET l_bmb.bmb10_fac2=p_brb.brb10_fac2 LET l_bmb.bmb11=p_brb.brb11
    LET l_bmb.bmb13=p_brb.brb13   LET l_bmb.bmb14=p_brb.brb14
    LET l_bmb.bmb15=p_brb.brb15   LET l_bmb.bmb16=p_brb.brb16
    LET l_bmb.bmb17=p_brb.brb17   LET l_bmb.bmb18=p_brb.brb18
    LET l_bmb.bmb19=p_brb.brb19   LET l_bmb.bmb20=p_brb.brb20
    LET l_bmb.bmb21=p_brb.brb21   LET l_bmb.bmb22=p_brb.brb22
    LET l_bmb.bmb23=p_brb.brb23   LET l_bmb.bmb24=p_brb.brb24
    LET l_bmb.bmb25=p_brb.brb25   LET l_bmb.bmb26=p_brb.brb26
    LET l_bmb.bmb27=p_brb.brb27   LET l_bmb.bmb28=p_brb.brb28
    LET l_bmb.bmb29=p_brb.brb29   LET l_bmb.bmb30=p_brb.brb30
    LET l_bmb.bmb31=p_brb.brb31   LET l_bmb.bmb33=p_brb.brb33
    LET l_bmb.bmbmodu=p_brb.brbmodu LET l_bmb.bmbdate=p_brb.brbdate
    LET l_bmb.bmbcomm=p_brb.brbcomm
    LET l_bmb.bmb06=p_brb.brb06   #TQC-B20087

    SELECT SUM(brb06) INTO l_brb06 FROM brb_file,bra_file WHERE bra01=brb01
       AND bra011=brb011 AND bra012=brb012 AND bra013=brb013 AND brb01=g_bra.bra01 
       AND brb29=g_bra.bra06 AND brb011=g_bra.bra011 
       AND bra10='2' AND brb03=p_brb.brb03 AND brb09=g_ecb06 
     # AND (bra012 !=g_bra.bra012 OR bra013 !=g_bra.bra013)  #FUN-B20101
       AND (bra012 != g_bra1[l_ac2].bra012 OR bra013 != g_bra1[l_ac2].bra013)   #FUN-B20101
       AND (brb04 <=g_today OR brb04 IS NULL )
       AND (brb05 > g_today OR brb05 IS NULL )       
    IF cl_null(l_brb06) THEN 
       LET l_brb06=0
    END IF       
    SELECT MAX(bmb02) INTO l_bmb.bmb02 FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb29=g_bra.bra06
    IF cl_null(l_bmb.bmb02) THEN 
       LET l_bmb.bmb02=0
    END IF 
    LET l_bmb.bmb02=l_bmb.bmb02+g_sma.sma19       
    
    #新增 按照新增元件和作业编号向bmb_file插值
    IF p_cmd='a' THEN 
       LET l_n=0
       SELECT COUNT(*) INTO l_n FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb03=p_brb.brb03 
          AND bmb09=g_ecb06 AND bmb29=g_bra.bra06 
       LET l_bmb.bmb06=l_bmb.bmb06+l_brb06          
       IF l_n>0 THEN 
           #No.TQC-A80112--begin
           SELECT bmb02 INTO l_bmb02 FROM bmb_file WHERE bmb01=g_bra.bra01 
              AND bmb03=p_brb.brb03 AND bmb29=g_bra.bra06 AND bmb09=g_ecb06
           LET l_bmb.bmb02=l_bmb02      
           #No.TQC-A80112--end 
           DELETE FROM bmb_file WHERE bmb01=g_bra.bra01 
           AND bmb03=p_brb.brb03 AND bmb29=g_bra.bra06 
           AND bmb09=g_ecb06 
           INSERT INTO bmb_file VALUES(l_bmb.*)
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
              CALL cl_err3('ins',"brb_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
              LET g_success='N' 
              RETURN 
           END IF         
       ELSE
          INSERT INTO bmb_file VALUES(l_bmb.*)
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
              CALL cl_err3('ins',"brb_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
              LET g_success='N' 
              RETURN 
           END IF                	   
       END IF   	  
    END IF 
    #修改 如果元件变了,先按旧元件删掉bmb_file的资料,然后新增新元件的资料,如未变则更新bmb
    IF p_cmd='u' THEN 
       IF p_brb.brb03!=p_brb03 THEN 
          SELECT bmb06 INTO l_brb06 FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb03=p_brb03 
             AND bmb09=g_ecb06 AND bmb29=g_bra.bra06 
          IF l_brb06>p_brb06 THEN 
             UPDATE bmb_file SET bmb06=bmb06-p_brb06
                           WHERE bmb01=g_bra.bra01 
                             AND bmb03=p_brb.brb03 
                             AND bmb09=g_ecb06 
                             AND bmb29=g_bra.bra06 
                             AND bmb09=g_ecb06
          ELSE 
          	  DELETE FROM bmb_file WHERE bmb01=g_bra.bra01 
              AND bmb03=p_brb03 AND bmb29=g_bra.bra06 
              AND bmb09=g_ecb06
          END IF        
       END IF 
       #No.TQC-A80112--begin
       SELECT COUNT(*) INTO l_n FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb03=p_brb.brb03 
          AND bmb09=g_ecb06 AND bmb29=g_bra.bra06           
       IF l_n>0 THEN 
           SELECT bmb02 INTO l_bmb02 FROM bmb_file WHERE bmb01=g_bra.bra01 
              AND bmb03=p_brb.brb03 AND bmb29=g_bra.bra06 AND bmb09=g_ecb06
           LET l_bmb.bmb02=l_bmb02 
       END IF      
       #No.TQC-A80112--end        
       DELETE FROM bmb_file WHERE bmb01=g_bra.bra01 
       AND bmb03=p_brb.brb03 AND bmb29=g_bra.bra06 
       AND bmb09=g_ecb06 
       LET l_bmb.bmb06=l_bmb.bmb06+l_brb06   
       INSERT INTO bmb_file VALUES(l_bmb.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
          CALL cl_err3('ins',"brb_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
          LET g_success='N' 
          RETURN 
       END IF             	  
    END IF 
    #删除 
    IF p_cmd='d' THEN 
       SELECT bmb06 INTO l_brb06 FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb03=p_brb.brb03 
          AND bmb09=g_ecb06 AND bmb29=g_bra.bra06 
       IF l_brb06>p_brb.brb06 THEN 
          UPDATE bmb_file SET bmb06=bmb06-p_brb.brb06
                        WHERE bmb01=g_bra.bra01 
                          AND bmb03=p_brb.brb03 
                          AND bmb09=g_ecb06 
                          AND bmb29=g_bra.bra06 
                          AND bmb09=g_ecb06
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
              CALL cl_err3('del',"brb_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
              LET g_success='N' 
              RETURN 
           END IF      
       END IF 
       IF l_brb06=p_brb.brb06 THEN
       	  DELETE FROM bmb_file WHERE bmb01=g_bra.bra01 
           AND bmb03=p_brb.brb03 AND bmb29=g_bra.bra06 
           AND bmb09=g_ecb06
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
              CALL cl_err3('del',"brb_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
              LET g_success='N' 
              RETURN 
           END IF                      
       END IF 
    END IF 
END FUNCTION 
#No.FUN-A60083--end

#将bra_file,brb_file的资料分别更新到bma_file,bmb_file
FUNCTION i500_updbma()
DEFINE   l_n      LIKE type_file.num5
DEFINE   l_n1     LIKE type_file.num5
DEFINE   l_bma    RECORD LIKE bma_file.*
DEFINE   l_bmb    RECORD LIKE bmb_file.*
DEFINE   l_brb    RECORD LIKE brb_file.*
DEFINE   l_brb02  LIKE brb_file.brb02
DEFINE   l_brb03  LIKE brb_file.brb03
DEFINE   l_brb06  LIKE brb_file.brb06
DEFINE   l_bmb02  LIKE bmb_file.bmb02
DEFINE   l_i      LIKE type_file.num5 
DEFINE   l_ecb06  LIKE ecb_file.ecb06	   #FUN-B10018

    LET l_bma.bma01=g_bra.bra01
    LET l_bma.bma06=g_bra.bra06
    LET l_bma.bma05=g_bra.bra05
    LET l_bma.bma02=g_bra.bra02
    LET l_bma.bma03=g_bra.bra03
    LET l_bma.bma04=g_bra.bra04
    LET l_bma.bma06=g_bra.bra06
    LET l_bma.bma07=g_bra.bra07
    LET l_bma.bma08=g_bra.bra08
    LET l_bma.bma09=g_bra.bra09
    LET l_bma.bma10='2'
    LET l_bma.bmaacti=g_bra.braacti
    LET l_bma.bmagrup=g_bra.bragrup
    LET l_bma.bmamodu=g_bra.bramodu
    LET l_bma.bmadate=g_bra.bradate
    LET l_bma.bmauser=g_bra.brauser
    LET l_bma.bmaorig=g_bra.braorig
    LET l_bma.bmaoriu=g_bra.braoriu

    SELECT COUNT(*) INTO l_n FROM bma_file WHERE bma01=g_bra.bra01 AND bma06=g_bra.bra06
    IF l_n=0 THEN 
       INSERT INTO bma_file VALUES(l_bma.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
          CALL cl_err3('ins',"bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
          LET g_success='N' 
          RETURN 
       END IF 
    ELSE 
    	 UPDATE bma_file SET bma05=l_bma.bma05,
    	                     bma09=l_bma.bma09,
    	                     bma08=l_bma.bma08
    	               WHERE bma01=g_bra.bra01
    	                 AND bma06=g_bra.bra06  
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
          CALL cl_err3('upd',"bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
          LET g_success='N' 
          RETURN 
       END IF     	                    
    END IF 
#    DECLARE i500_brb1 CURSOR FOR SELECT DISTINCT brb03 FROM brb_file,bra_file  
#      WHERE bra01=brb01 AND bra011=brb011 AND bra012=brb012 AND bra013=brb013 AND bra06=brb29
#        AND brb01=g_bra.bra01 AND brb29=g_bra.bra06 AND brb011=g_bra.bra011 AND brb012=g_bra.bra012
#        AND brb013=g_bra.bra013 AND bra10='2'
#    FOREACH i500_brb1 INTO l_brb03
#    FOR l_i=1 TO g_rec_b  #FUN-B10018 mark
#FUN-B10018--begin--add--
     DELETE FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb29=g_bra.bra06  
     DECLARE i500_brb1 CURSOR FOR SELECT* FROM brb_file,bra_file 
       WHERE bra01=brb01 AND bra011=brb011 AND bra012=brb012 AND bra013=brb013 AND bra06=brb29
         AND brb01=g_bra.bra01 AND brb29=g_bra.bra06 AND brb011=g_bra.bra011 AND bra10='2'
         AND (brb04 <=g_today OR brb04 IS NULL )
         AND (brb05 > g_today OR brb05 IS NULL )
     FOREACH i500_brb1 INTO l_brb.* 
        SELECT ecb06 INTO l_ecb06 FROM ecb_file
         WHERE ecb01=l_brb.brb01 AND ecb02=l_brb.brb011
           AND ecb012=l_brb.brb012 AND ecb03=l_brb.brb013
#FUN-B10018--end--add------
        #计算组成用量(将所有该主件料号+制程编号的相同元件的组成用量汇总)
        LET l_brb06=0
        SELECT SUM(brb06) INTO l_brb06 FROM brb_file,bra_file WHERE bra01=brb01
           AND bra011=brb011 AND bra012=brb012 AND bra013=brb013 AND brb01=g_bra.bra01 
           AND brb29=g_bra.bra06 AND brb011=g_bra.bra011 
           AND bra10='2' AND brb03=l_brb.brb03 AND brb09=l_ecb06  #FUN-B10018
           AND (bra012 !=l_brb.brb012 OR bra013 !=l_brb.brb013)	  #FUN-B10018
           AND (brb04 <=g_today OR brb04 IS NULL )
           AND (brb05 > g_today OR brb05 IS NULL )
        IF cl_null(l_brb06) THEN 
           LET l_brb06=0
        END IF 
#FUN-B10018--begin--mark---
#        #将brb_file第一笔资料插到bmb_file里   
#        DECLARE i500_brb2 CURSOR FOR SELECT * FROM brb_file WHERE brb01=g_bra.bra01 
#            AND brb011=g_bra.bra011 AND brb03=g_brb[l_i].brb03 AND brb29=g_bra.bra06
#            AND (brb04 <=g_today OR brb04 IS NULL )
#            AND (brb05 > g_today OR brb05 IS NULL )
#        FOREACH i500_brb2 INTO l_brb.*
#            EXIT FOREACH 
#        END FOREACH 
#FUN-B10018--end--mark
        LET l_bmb.bmb03=l_brb.brb03	   #FUN-B10018
        LET l_bmb.bmb06=l_brb06+l_brb.brb06	  #FUN-B10018
        LET l_bmb.bmb01=l_brb.brb01
        LET l_bmb.bmb02=l_brb.brb02
        LET l_bmb.bmb04=l_brb.brb04
        LET l_bmb.bmb05=l_brb.brb05
        LET l_bmb.bmb07=l_brb.brb07
        LET l_bmb.bmb08=l_brb.brb08
        LET l_bmb.bmb081=l_brb.brb081
        LET l_bmb.bmb082=l_brb.brb082
#       LET l_bmb.bmb09=l_brb.brb09
        LET l_bmb.bmb09=l_ecb06	  #FUN-B10018
        LET l_bmb.bmb10=l_brb.brb10
        LET l_bmb.bmb10_fac=l_brb.brb10_fac
        LET l_bmb.bmb10_fac2=l_brb.brb10_fac2
        LET l_bmb.bmb11=l_brb.brb11
        LET l_bmb.bmb13=l_brb.brb13
        LET l_bmb.bmb14=l_brb.brb14
        LET l_bmb.bmb15=l_brb.brb15
        LET l_bmb.bmb16=l_brb.brb16
        LET l_bmb.bmb17=l_brb.brb17
        LET l_bmb.bmb18=l_brb.brb18
        LET l_bmb.bmb19=l_brb.brb19
        LET l_bmb.bmb20=l_brb.brb20
        LET l_bmb.bmb21=l_brb.brb21
        LET l_bmb.bmb22=l_brb.brb22
        LET l_bmb.bmb23=l_brb.brb23
        LET l_bmb.bmb24=l_brb.brb24
        LET l_bmb.bmb25=l_brb.brb25
        LET l_bmb.bmb26=l_brb.brb26
        LET l_bmb.bmb27=l_brb.brb27
        LET l_bmb.bmb28=l_brb.brb28
        LET l_bmb.bmb29=l_brb.brb29
        LET l_bmb.bmb30=l_brb.brb30
        LET l_bmb.bmb31=l_brb.brb31
        LET l_bmb.bmb33=l_brb.brb33
        LET l_bmb.bmbmodu=l_brb.brbmodu
        LET l_bmb.bmbdate=l_brb.brbdate
        LET l_bmb.bmbcomm=l_brb.brbcomm
        SELECT COUNT(*) INTO l_n1 FROM bmb_file WHERE bmb01=g_bra.bra01 
           AND bmb03=l_brb.brb03 AND bmb29=g_bra.bra06 AND bmb09=l_ecb06	   #FUN-B10018
        SELECT MAX(bmb02) INTO l_bmb.bmb02 FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb29=g_bra.bra06
        IF cl_null(l_bmb.bmb02) THEN 
           LET l_bmb.bmb02=0
        END IF 
        LET l_bmb.bmb02=l_bmb.bmb02+g_sma.sma19
        IF l_n1=0 THEN 
           INSERT INTO bmb_file VALUES(l_bmb.*)
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
              CALL cl_err3('ins',"brb_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
              LET g_success='N' 
              RETURN 
           END IF            
        ELSE 
      	 #保留原有资料的项次 再更新bmb_file
       	 #No.TQC-A80112--begin
       	 SELECT bmb02 INTO l_bmb02 FROM bmb_file WHERE bmb01=g_bra.bra01 
           AND bmb03=l_brb.brb03 AND bmb29=g_bra.bra06 AND bmb09=l_ecb06  #FUN-B10018
           LET l_bmb.bmb02=l_bmb02
           #No.TQC-A80112--end
           DELETE FROM bmb_file WHERE bmb01=g_bra.bra01 
           AND bmb03=l_brb.brb03 AND bmb29=g_bra.bra06   #FUN-B10018
           INSERT INTO bmb_file VALUES(l_bmb.*)
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
              CALL cl_err3('ins',"brb_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
              LET g_success='N' 
              RETURN 
           END IF            
        END IF 
     END FOREACH   #FUN-B10018
#    END FOR       #FUN-B10018
     
END FUNCTION  

#FUN-B10013 -----------------------------Begin----------------------------------
FUNCTION i500_carry()
   DEFINE l_cnt1   LIKE type_file.num10 
   DEFINE l_i      LIKE type_file.num10
   DEFINE l_gew03  LIKE gew_file.gew03
   IF cl_null(g_bra.bra01) THEN   
      CALL cl_err('',-400,0)
      LET g_success = 'N'       #TQC-C50256 add
      RETURN 
   END IF
   SELECT COUNT(*) INTO l_cnt1 FROM bra_file WHERE bra01 = g_bra.bra01
                                   AND bra011 = g_bra.bra011
                                   AND bra10 = '2'
                                   
   IF l_cnt1 < 1 THEN
      CALL cl_err(g_bra.bra01,'aoo-091',1)
      LET g_success = 'N'       #TQC-C50256 add
      RETURN
   END IF   
   LET g_gev04 = NULL                                                           
                                                                                
   #是否為資料中心的拋轉DB                                                      
   SELECT gev04 INTO g_gev04 FROM gev_file                                      
    WHERE gev01 = '2' AND gev02 = g_plant                                       
      AND gev03 = 'Y'                                                           
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_gev04,'aoo-036',1)                                          
      LET g_success = 'N'       #TQC-C50256 add
      RETURN                                                                    
   END IF
 
   IF cl_null(g_gev04) THEN
      LET g_success = 'N'       #TQC-C50256 add
      RETURN
   END IF

   SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file                               
    WHERE gew01 = g_gev04 AND gew02 = '2'                                       
   IF NOT cl_null(l_gew03) THEN                                                 
      IF l_gew03 = '2' THEN                                                     
          IF NOT cl_confirm('anm-929') THEN   #詢問是否執行拋轉
             LET g_success = 'N'       #TQC-C50256 add
             RETURN 
          END IF      
      END IF   
      LET l_sql = "SELECT COUNT(*) FROM &bra_file WHERE bra01='",g_bra.bra01,"'",
                                              "  AND bra011='",g_bra.bra011,"'",
                                              "  AND bra10 = '2'"
      CALL s_dc_sel_db1(g_gev04,'2',l_sql)
      IF INT_FLAG THEN
         LET INT_FLAG=0
         LET g_success = 'N'       #TQC-C50256 add
         RETURN
      END IF     
      CALL g_brax.clear()
  
      LET g_brax[1].sel = 'Y'
      LET g_brax[1].bra01 = g_bra.bra01
      LET g_brax[1].bra011 = g_bra.bra011
      FOR l_i = 1 TO g_azp1.getLength()
         LET g_azp[l_i].sel   = g_azp1[l_i].sel
         LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
         LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
         LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
      END FOR
 
      CALL s_showmsg_init()
      CALL s_abmi500_carry(g_brax,g_azp,g_gev04,g_bra.bra01,g_bra.bra011,g_plant)
     #FUN-B20101--add--begin
      IF g_success = 'N' THEN
         CALL s_showmsg() 
         RETURN
      END IF
     #FUN-B20101--add--end 
      CALL s_showmsg()
   ELSE
      LET g_success = 'N'       #TQC-C50256 add
      RETURN                    #TQC-C50256 add 
   END IF            
END FUNCTION
#FUN-B10013 -----------------------------End------------------------------------
FUNCTION i500_r()
    DEFINE l_chr LIKE type_file.chr1   
    DEFINE l_cnt LIKE type_file.num10 
 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bra.bra01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'r') THEN
       CALL cl_err(g_bra.bra08,'aoo-044',1)
       RETURN
    END IF
 
    IF g_bra.bra10 <> '0'  THEN CALL cl_err('','aim1006',0) RETURN END IF
   
    #考慮參數(sma101) BOM表發放后是否可以修改單身
    IF NOT cl_null(g_bra.bra05) AND g_sma.sma101 = 'N' THEN
       IF g_ima08_h MATCHES '[MPXTSVU]' THEN    #單頭料件來源碼='MPXT'才control #FUN-590116 add S   
          CALL cl_err('','abm-120',0)
          RETURN
       END IF
    END IF
 
    #No.B236 010326 by linda add 存在工單之BOM詢問是否可取消
#    LET l_cnt=0
#    SELECT COUNT(*) INTO l_cnt
#      FROM sfa_file
#     WHERE sfa29 = g_bra.bra01
#    IF l_cnt >0 AND l_cnt IS NOT NULL THEN 
#       CALL cl_err("",'mfg-074', 1)
#       RETURN
#    END IF
    BEGIN WORK
#FUN-B20101--mark--begin 
# #  OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013   #FUN-B20101
#    OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011                             #FUN-B20101
#    IF STATUS THEN
#       CALL cl_err("OPEN i500_cl:", STATUS, 1)
#       CLOSE i500_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#   # FETCH i500_cl INTO g_bra.*    #FUN-B20101
#    FETCH i500_cl INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0) RETURN
#    END IF
#   CALL i500_show()
#FUN-B20101--mark--end
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL           
        LET g_doc.column1 = "bra01"          
        LET g_doc.value1  = g_bra.bra01      
        CALL cl_del_doc()                                            
        DELETE FROM bra_file WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06 
          #AND bra011=g_bra.bra011  AND bra012=g_bra.bra012 AND bra013=g_bra.bra013    #FUN-B20101
           AND bra011=g_bra.bra011                                                     #FUN-B20101 
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("del","bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","del bra",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM brb_file WHERE brb01=g_bra.bra01
                               AND brb29=g_bra.bra06  
                               AND brb011=g_bra.bra011
                          #FUN-B20101--modity
                          #    AND brb012=g_bra.bra012
                          #    AND brb013=g_bra.bra013
                          #FUN-B20101--modity
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","brb_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","del brb",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF 
    LET g_msg=TIME
#    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    #FUN-980001 add plant & legal
#       VALUES ('abmi500',g_user,g_today,g_msg,g_bra.bra01,g_bra.bra06,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
#    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    #FUN-980001 add plant & legal
#       VALUES ('abmi500',g_user,g_today,g_msg,g_bra.bra01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
    END IF
#    IF g_sma.sma845='Y'   #低階碼可否部份重計
#       THEN
#       LET g_success='Y'
#       CALL s_uima146(g_bra.bra01)
#       MESSAGE ""
#    END IF
 
    CALL i500_list_cs(g_wc,g_wc2) #FUN-B30033 jan add
    CALL i500_list_fill()
 
    COMMIT WORK
 #  CLOSE i500_cl     #FUN-B20101
    CLEAR FORM
    
    CALL g_bra1.clear()
    CALL g_brb.clear()
    CALL i500_tree_update()
    
END FUNCTION

FUNCTION i500_updbom()
DEFINE   l_bra012    LIKE bra_file.bra012
DEFINE   l_bra011    LIKE bra_file.bra011
DEFINE   l_bra013    LIKE bra_file.bra013
DEFINE   l_success   LIKE type_file.chr1
DEFINE   l_n         LIKE type_file.num5 

    IF s_shut(0) THEN RETURN END IF
    IF g_bra.bra01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'u') THEN
       CALL cl_err(g_bra.bra08,'aoo-045',1)
       RETURN
    END IF
    IF g_bra.bra10 ='2' THEN 
       CALL cl_err('','abm-219',1)
       RETURN
    END IF 
    BEGIN WORK
    LET l_success='Y'
#FUN-B20101---marh--begin
#   OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013    #FUN-B20101
#    OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011                              #FUN-B20101
#    IF STATUS THEN
#       CALL cl_err("OPEN i500_cl:", STATUS, 1)
#       CLOSE i500_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    #  FETCH i500_cl INTO g_bra.*               # 鎖住將被更改或取消的資料  #FUN-B20101
#    FETCH i500_cl INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014 
#    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)          #資料被他人LOCK
#        RETURN
#    END IF
    CALL i500_show()
#FUN-B20101--mark--end
    IF g_bra.bra014='Y' THEN 
       IF NOT cl_confirm('abm-220') THEN RETURN END IF 
    ELSE 
    	 IF NOT cl_confirm('abm-221') THEN RETURN END IF
    END IF   
        IF g_bra.bra014='N' THEN
           DECLARE i500_sel1 CURSOR FOR SELECT DISTINCT bra011 FROM bra_file WHERE bra01=g_bra.bra01
               AND bra014='Y' AND bra06=g_bra.bra06
           FOREACH i500_sel1 INTO l_bra011
              IF l_bra011 !=g_bra.bra011 THEN 
                 LET l_success='N'
                 EXIT FOREACH 
              END IF 
           END FOREACH 
        END IF 
        IF l_success='N' THEN 
           CALL cl_err('','abm-222',1)
           RETURN 
        END IF 
        LET g_chr=g_bra.bra014
        IF g_bra.bra014='Y' THEN
            LET g_bra.bra014='N'
        ELSE
            LET g_bra.bra014='Y'
        END IF
        DECLARE i500_sel2 CURSOR FOR SELECT bra012,bra013 FROM bra_file WHERE bra01=g_bra.bra01
           AND bra011=g_bra.bra011 AND bra06=g_bra.bra06 
        FOREACH i500_sel2 INTO l_bra012,l_bra013  
           UPDATE bra_file                   
               SET bra014=g_bra.bra014
               WHERE bra01=g_bra.bra01
                 AND bra06=g_bra.bra06   
                 AND bra011=g_bra.bra011 
                 AND bra012=l_bra012
                 AND bra013=l_bra013
           IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)  #No.TQC-660046
               LET g_bra.bra014=g_chr
           END IF
        END FOREACH 
        #FUN-B10018--begin--add--
        LET l_n = 0
        SELECT COUNT(*) INTO l_n FROM bra_file
         WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06 AND bra011=g_bra.bra011 AND bra014='Y' AND bra10='2'
        IF l_n > 0 THEN
           CALL i500_updbma()
           IF g_success = 'N' THEN
              ROLLBACK WORK
              RETURN
           END IF
         END IF
         #FUN-B10018--end--add--
        DISPLAY BY NAME g_bra.bra014
    #END IF
    LET g_bp_flag = "main"
#   CLOSE i500_cl  #FUN-B20101--mark
    COMMIT WORK    
    
END FUNCTION  

#單身
FUNCTION i500_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT
    l_ac2_t         LIKE type_file.num5,   #FUN-B20101
    l_n             LIKE type_file.num5,  #檢查重復用
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否
    p_cmd           LIKE type_file.chr1,   #處理狀態
    l_buf           LIKE type_file.chr50, 
    l_cmd           LIKE type_file.chr1000,
    l_uflag,l_chr   LIKE type_file.chr1,   
    l_ima08         LIKE ima_file.ima08,
    l_brb01         LIKE ima_file.ima01,
    l_qpa           LIKE brb_file.brb06,
    l_ima04         LIKE ima_file.ima04,
    l_i             LIKE type_file.num5, 
    l_success       LIKE type_file.chr1,  
    l_cnt           LIKE type_file.num5, 
    l_result        LIKE gep_file.gep01,   #aooi503返回的合成后的公式前綴
    l_str           LIKE gep_file.gep01,
 
    l_valid,l_count LIKE type_file.num5,  
    l_formula01     LIKE gep_file.gep01,
    l_formula02     LIKE gep_file.gep01,
    l_formula03     LIKE gep_file.gep01,
 
    l_viewcad_cmd   LIKE type_file.chr1000,
    l_allow_insert  LIKE type_file.num5,     #可新增否
    l_allow_delete  LIKE type_file.num5      #可刪除否
DEFINE l_m          LIKE type_file.num5        
DEFINE l_r          LIKE type_file.num5       
DEFINE l_ima151     LIKE ima_file.ima151      
DEFINE r_ima151     LIKE ima_file.ima151   
DEFINE l_count1     LIKE type_file.num5     
DEFINE l_mdm_tag    LIKE type_file.num5     
DEFINE l_mdm_action STRING             
DEFINE l_icm RECORD LIKE icm_file.*          
DEFINE l_loop       LIKE type_file.chr1       #是否為無窮迴圈Y/N  
DEFINE l_flag       LIKE type_file.chr1 
DEFINE l_tf         LIKE type_file.chr1   #FUN-BB0085
 
    LET l_mdm_action = g_action_choice
    LET p_md = 'u'                       
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bra.bra01) THEN
        RETURN
    END IF
    CALL cl_set_comp_entry('brb16',FALSE)
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'u') THEN
       CALL cl_err(g_bra.bra08,'aoo-045',1)
       RETURN
    END IF
    IF g_bra.bra10 <>0 AND g_sma.sma101!='Y'  THEN RETURN END IF  
    #考慮參數(sma101) BOM表發放后是否可以修改單身
    IF NOT cl_null(g_bra.bra05) AND g_sma.sma101 = 'N' THEN
       IF g_ima08_h MATCHES '[MPXTSVU]' THEN    #單頭料件來源碼='MPXT'才control #FUN-590116 add S   
          CALL cl_err('','abm-120',0)
          RETURN
       END IF
    END IF
    IF g_bra.braacti ='N' THEN    #資料若為無效,仍可更改. 
        CALL cl_err(g_bra.bra01,'mfg1000',0) RETURN       
    END IF                                               
    LET l_uflag ='N'
    LET g_aflag ='N'
 
    CALL cl_opmsg('b')
  #FUN-B20101--add--begin
    LET g_forupd_sql =
        "SELECT bra012,'',bra013,'','' ",
        "FROM bra_file ",
        "WHERE bra01=? AND bra011=? ",
        " AND bra06=? AND bra012=? AND bra013=? ",
        " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bc2  CURSOR FROM g_forupd_sql
  #FUN-B20101--add--end 
    LET g_forupd_sql =
#      "SELECT brb02,brb30,brb03,'','','',brb09,brb16,brb14,brb04,brb05,brb06,brb07,",
#      "       brb10,brb08,brb081,brb082,brb19,brb24,brb13,brb31  ", 
      " SELECT * ",     
      " FROM brb_file ",
      "   WHERE brb01 = ? ",
      "     AND brb011= '",g_bra.bra011,"' ",
      "     AND brb012= ? ",     #FUN-B20101   #MOD-B30509
      "     AND brb013= ? ",     #FUN-B20101   #MOD-B30509
      "   AND brb29 = ? ", 
      "   AND brb02 = ? ",
      "   AND brb03 = ? ",
      "   AND brb04 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

     IF g_sma.sma09 = 'N' THEN
        CALL cl_set_act_visible("create_item_master", FALSE)
     ELSE
        CALL cl_set_act_visible("create_item_master", TRUE)
     END IF
    LET l_flag = 'N'                      #FUN-B20101
    WHILE TRUE                            #FUN-B20101
#   CALL FGL_DIALOG_SETFIELDORDER(FALSE)  #欄位切換時屏蔽調中間欄位的BEFORE FIELD

    IF g_rec_b2 >0 THEN LET l_ac2 = 1 END IF   #FUN-D30033 add
    IF g_rec_b >0 THEN LET l_ac = 1 END IF   #FUN-D30033 add

    DIALOG ATTRIBUTES(UNBUFFERED)        #FUN-B20101
   #FUN-B20101--add--begin
    INPUT ARRAY g_bra1
          FROM s_bra.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE, #FUN-B20101
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
          BEFORE INPUT
          IF g_rec_b2 != 0 THEN
             CALL fgl_set_arr_curr(l_ac2)
          END IF
          LET g_flag_b ='2'  #FUN-D30033 add

          BEFORE ROW
             LET p_cmd = ''
             LET l_ac2 = DIALOG.getCurrentRow("s_bra")
             LET l_lock_sw = 'N'            #DEFAULT
             LET l_n  = ARR_COUNT()
          IF g_rec_b2>= l_ac2 THEN
             BEGIN WORK
             LET p_cmd='u'
             LET g_bra1_t.*=g_bra1[l_ac2].* 
             LET l_sql = "SELECT bra01,bra06,bra011,bra012,bra013 ",
                         "WHERE bra01=g_bra.bra01 AND bra011=g_bra.bra011 AND bra012=g_bra1[l_ac2].bra012 "
             PREPARE i500_prepare_r FROM l_sql
             EXECUTE i500_prepare_r into g_bra.bra01,g_bra.bra06,
                                         g_bra.bra011,g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013
             OPEN i500_bc2  USING  g_bra.bra01,g_bra.bra011,
                                   g_bra.bra06,g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013
             IF STATUS THEN
               CALL cl_err("OPEN i500_bc2:", STATUS, 1)
               LET l_lock_sw = "Y"
             ELSE
               FETCH i500_bc2 INTO g_bra1[l_ac2].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_bra01_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                 CALL i500_bra012(g_bra1[l_ac2].bra012)
                 CALL i500_bra013(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013) 
                 CALL   i500_b_fill(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013) 
               END IF
             END IF
      #      SELECT ecu014 INTO g_bra1[l_ac2].ecu014 FROM ecu_file  WHERE ecu012=g_bra1[l_ac2].bra012
             CALL cl_show_fld_cont()     
          END IF
          BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            CALL g_brb.clear()
            INITIALIZE g_bra1[l_ac2].* TO NULL 
            LET g_bra1_t.* = g_bra1[l_ac2].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD bra012 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
         
      #   IF cl_null(g_bra1[l_ac2].bra012) THEN 
      #     LET g_bra1[l_ac2].bra012=' '
      #   END IF 
      #   IF cl_null(g_bra1[l_ac2].bra013) THEN 
      #     LET g_bra1[l_ac2].bra013=0
      #   END IF 
         CALL i500_bra_init()
         INSERT INTO bra_file  VALUES (g_bra2.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","bra_file",g_bra.bra01,g_bra1[l_ac2].bra012,SQLCA.sqlcode,"","ins bra:",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
               LET g_rec_b2=g_rec_b2+1
      #       DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
         AFTER FIELD bra012
            IF NOT cl_null(g_bra1[l_ac2].bra012) THEN   
               IF p_cmd='a' OR (p_cmd='u' AND g_bra1[l_ac2].bra012!=g_bra1_t.bra012) THEN   #FUN-B20101
                 CALL i500_check_1(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013)
                  IF NOT cl_null(g_errno) THEN
                     LET  g_bra1[l_ac2].bra012 = g_bra1_t.bra012
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD bra012
                     
                  END IF
                  CALL i500_bra012(g_bra1[l_ac2].bra012)
                  IF NOT cl_null(g_errno) THEN
                    LET  g_bra1[l_ac2].bra012 = g_bra1_t.bra012
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD bra012
                  END IF
               END IF
            END IF
            IF g_bra1[l_ac2].bra012 IS NULL THEN           
                LET g_bra1[l_ac2].bra012 = ' '             
            END IF
          AFTER FIELD bra013
             IF NOT cl_null(g_bra1[l_ac2].bra013) THEN      
                IF p_cmd='a' OR (p_cmd='u' AND g_bra1[l_ac2].bra013 != g_bra1_t.bra013) THEN 
         #        CALL i500_check()
                  CALL i500_check_1(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013)
                  IF NOT cl_null(g_errno) THEN
                     LET  g_bra1[l_ac2].bra013 = g_bra1_t.bra013
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD bra013
                  END IF
                  CALL i500_bra013(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013)
                  IF NOT cl_null(g_errno) THEN
                     LET  g_bra1[l_ac2].bra013 = g_bra1_t.bra013
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD bra013
                  END IF
               END IF
            END IF
            #TQC-B40076--begin
            #IF g_bra1[l_ac2].bra013 IS NULL THEN 
            #   NEXT FIELD bra013
            #END IF
            #TQC-B40076--end
        BEFORE DELETE  
           IF (g_bra1[l_ac2].bra012 IS NOT NULL) OR (g_bra1[l_ac2].bra013 IS NOT NULL)   THEN
              IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF

               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
              DELETE FROM bra_file
               WHERE bra01 = g_bra.bra01
                 AND bra06 = g_bra.bra06   #FUN-B30033 jan add
                 AND bra011 = g_bra.bra011
                 AND bra012 = g_bra1_t.bra012
                 AND bra013 = g_bra1_t.bra013
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","bra_file",g_bra.bra01,g_bra.bra011,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 DELETE FROM brb_file  #bra-->brb FUN-B30033 jan 
                  WHERE brb01 = g_bra.bra01
                    AND brb29 = g_bra.bra06   #FUN-B30033 jan add
                    AND brb011 = g_bra.bra011
                    AND brb012 = g_bra1_t.bra012
                    AND brb013 = g_bra1_t.bra013
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","brb_file",g_bra.bra01,g_bra.bra011,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                   LET g_rec_b2=g_rec_b2-1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   COMMIT WORK
                END IF
              END IF
            END IF
          ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bra1[l_ac2].*=g_bra1_t.*
               CLOSE i500_bc2
               ROLLBACK WORK
               EXIT DIALOG 
            END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bra1[l_ac2].bra012,-263,1)
              LET g_bra1[l_ac2].*=g_bra1_t.*
           ELSE
           #   IF cl_null(g_bra1[l_ac2].bra012) THEN
           #     LET g_bra1[l_ac2].bra012=' '
           #   END IF
           #   IF cl_null(g_bra1[l_ac2].bra013) THEN
           #      LET g_bra1[l_ac2].bra013=0
           #   END IF
              UPDATE bra_file SET bra012 = g_bra1[l_ac2].bra012,
                                  bra013 = g_bra1[l_ac2].bra013
                              WHERE bra01 = g_bra.bra01
                                    AND bra011 = g_bra.bra011
                                    AND bra012 = g_bra1_t.bra012
                                    AND bra013 = g_bra1_t.bra013
              IF SQLCA.sqlcode  THEN
                 CALL cl_err3("upd","bra_file",g_bra.bra01,g_bra1[l_ac2].bra012,SQLCA.sqlcode,"","",1) 
                 LET g_bra1[l_ac2].*=g_bra1_t.*
              ELSE
                 UPDATE bra_file SET bradate = g_today,bramodu=g_user
                 WHERE bra01 = g_bra.bra01
                      AND bra011 = g_bra.bra011
              END IF
         END IF
         AFTER ROW
            LET l_ac2 = DIALOG.getCurrentRow("s_bra")
            LET l_ac2_t = l_ac2      
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bra1[l_ac2].* = g_bra1_t.*
               END IF
               CLOSE i500_bc2
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF cl_null(g_bra1[l_ac2].bra012) OR 
               cl_null(g_bra1[l_ac2].bra013) THEN
               CALL g_bra1.deleteElement(l_ac2)
            END IF
            CLOSE i500_bc2
            COMMIT WORK
          
        ON ACTION controlp
           CASE
              WHEN INFIELD(bra012)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ecu02_4"
                    LET g_qryparam.arg1 = g_bra.bra01
                    LET g_qryparam.arg2 = g_bra.bra011
                    LET g_qryparam.default1 = g_bra1[l_ac2].bra012
                    CALL cl_create_qry() RETURNING g_bra1[l_ac2].bra012
                    DISPLAY BY NAME g_bra1[l_ac2].bra012
                    NEXT FIELD bra012
               WHEN INFIELD(bra013)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ecb03_1"
                    LET g_qryparam.arg1 = g_bra.bra01
                    LET g_qryparam.arg2 = g_bra.bra011
                    LET g_qryparam.arg3 = g_bra1[l_ac2].bra012
                    LET g_qryparam.default1 = g_bra1[l_ac2].bra013
                    CALL cl_create_qry() RETURNING g_bra1[l_ac2].bra013
                    DISPLAY BY NAME g_bra1[l_ac2].bra013
                    NEXT FIELD bra013
           END CASE
       ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bra012) AND l_ac2 > 1 THEN
                LET g_bra1[l_ac2].* = g_bra1[l_ac2-1].*
                NEXT FIELD bra012
            END IF
       ON ACTION CONTROLR
           CALL cl_show_req_fields()

       #TQC-C30136--mark--str--
       #ON ACTION CONTROLG
       #    CALL cl_cmdask()
       #TQC-C30136--mark--end--


       ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
       ON ACTION controls
        CALL cl_set_head_visible("","AUTO") 

    END INPUT 
   #FUN-B20101--add--end 
    INPUT ARRAY g_brb
    #     WITHOUT DEFAULTS               #FUN-B20101
          FROM s_brb.*
     #    ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,     #FUN-B20101
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE, #FUN-B20101
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
    #FUN-B20101--add
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM bra_file WHERE bra01=g_bra.bra01 AND bra011=g_bra.bra011
               AND bra012=g_bra1[l_ac2].bra012 AND bra013=g_bra1[l_ac2].bra013
            IF l_cnt=0  THEN
                LET l_flag = 'Y'
                CALL cl_err('','abm500',1)
                EXIT DIALOG  
            END IF 
   #FUN-B20101--add--end
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_modify_flag = 'N' 
            LET g_brb10_t = NULL        #FUN-BB0085
            LET g_flag_b ='1'  #FUN-D30033 add           
    
        BEFORE ROW
            LET p_cmd=''
          # LET l_ac = ARR_CURR()           #FUN-B20101
            LET l_ac = DIALOG.getCurrentRow("s_brb")   #FUN-B20101
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            LET g_success = 'Y'
#FUN-B20101--mark--begin 
#         #  OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013   #FUN-B20101
#            OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011                             #FUN-B20101
#            IF STATUS THEN
#                CALL cl_err("OPEN i500_cl:", STATUS, 1)
#                CLOSE i500_cl
#                RETURN
#            END IF
#          #  FETCH i500_cl INTO g_bra.*          # 鎖住將被更改或取消的資料 #FUN-B20101
#            FETCH i500_cl INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014
#            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)  # 資料被他人LOCK
#               CLOSE i500_cl
#               RETURN
#            END IF
#FUN-B20101--mark--end
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_brb_t.* = g_brb[l_ac].*  #BACKUP
               LET g_brb_o.* = g_brb[l_ac].*
               OPEN i500_bcl USING g_bra.bra01,g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013,
                                   g_bra.bra06,g_brb_t.brb02,g_brb_t.brb03,g_brb_t.brb04  
                IF STATUS THEN
                    CALL cl_err("OPEN i500_bcl:", STATUS, 1)
                ELSE
                    FETCH i500_bcl INTO b_brb.*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_brb_t.brb02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL i500_b_move_to()
                        LET g_brb10_t = g_brb[l_ac].brb10    #FUN-BB0085
                    END IF

                    #如果某一行計算方式是"公式",則在料件名稱和規格處填充"<依公式生成>"字樣
                    IF g_brb[l_ac].brb30 = '3' THEN
                       LET g_brb[l_ac].ima02_b  = g_tipstr
                       LET g_brb[l_ac].ima021_b = g_tipstr
                    END IF
                END IF

                #增加判斷,如果當前計算方式為公式則忽略該函數
                IF (g_brb[l_ac].brb30 != '3') OR (cl_null(g_brb[l_ac].brb30)) THEN 
                   CALL i500_brb03('d')           
                END IF
 
              IF g_brb[l_ac].brb30 != '3' THEN
                 CALL cl_set_act_visible("edit_formula",FALSE)
              ELSE
                 CALL cl_set_act_visible("edit_formula",TRUE)  
              END IF
                CALL cl_show_fld_cont()  
            END IF
            CALL i500_b_set_entry()
            CALL i500_b_set_no_entry()
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            CALL i500_tree_loop(g_bra.bra01,g_brb[l_ac].brb03,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
            IF l_loop = "Y" THEN
               CALL cl_err(g_brb[l_ac].brb03,"agl1000",1)
               CANCEL INSERT
            ELSE
            
            CALL i500_b_move_back() 
            LET b_brb.brb33 = '0'
            #No.FUN-A70131--begin            
           #IF cl_null(g_brb[l_ac].brb012) THEN  #No.FUN-A70143 
            IF cl_null(b_brb.brb012) THEN        #No.FUN-A70143     
               LET b_brb.brb012 = ' '
            END IF     
            IF cl_null(b_brb.brb013) THEN 
               LET b_brb.brb013 = 0
            END IF    
            #No.FUN-A70131--end            
            INSERT INTO brb_file VALUES (b_brb.*)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","brb_file",g_bra.bra01,g_brb[l_ac].brb02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
            	  #No.FUN-A60008--begin
            	  IF g_bra.bra10 =2 AND g_sma.sma101='Y'  THEN 
            	     CALL i500_updbmb(b_brb.*,'','','a')
            	  END IF
            	  #No.FUN-A60008--end
                LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N 
                LET g_modify_flag='Y'
               UPDATE bra_file SET bradate = g_today
                               WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06
                               # AND bra011=g_bra.bra011 AND bra012=g_bra.bra012 
                               # AND bra013=g_bra.bra013
                                AND bra011=g_bra.bra011           #FUN-B20101 
                MESSAGE 'INSERT O.K'
                #update 上一項次失效日
                CALL i500_update('a')
#                IF g_sma.sma845='Y'   #低階碼可否部份重計
#                   THEN
#                    LET g_success='Y'                                
#                   CALL s_uima146(g_brb[l_ac].brb03)
#                   MESSAGE ""
#                   IF g_success='N' THEN
#                       #不可輸入此元件料號,因為產品結構偵錯發現有誤! 
#                       CALL cl_err(g_brb[l_ac].brb03,'abm-602',1)    
#                      LET g_brb[l_ac].* = g_brb_t.*
#                      DISPLAY g_brb[l_ac].* TO s_brb[l_sl].*
#                      ROLLBACK WORK
#                       CALL g_brb.deleteElement(l_ac)              
#                       CANCEL INSERT                           
#                   END IF
#                END IF
                IF l_uflag = 'N' THEN
                  #新增料件時系統參數(sma18 低階碼是重新計算)
                   UPDATE sma_file SET sma18 = 'Y'
                        WHERE sma00 = '0'
                   IF SQLCA.SQLERRD[3]  = 0 THEN
                      CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  
                   END IF
                   LET l_uflag = 'Y'
                END IF
                IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF
                LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                LET l_mdm_tag = 1                    #FUN-850147
                LET g_wsw03 = g_bra.bra01 CLIPPED ,'|', g_brb[l_ac].brb02 CLIPPED 
#                CASE aws_mdmdata('brb_file','insert',g_wsw03,base.TypeInfo.create(b_brb),'CreateBOMData')          
#                     WHEN 0  #無與 MDM 整合
#                        MESSAGE 'INSERT O.K'
#                     WHEN 1  #呼叫 MDM 成功
#                        MESSAGE 'INSERT O.K, INSERT MDM O.K'
#                     WHEN 2  #呼叫 MDM 失敗
#                        ROLLBACK WORK
#                        CANCEL INSERT
#                        CONTINUE INPUT
#                END CASE
                IF s_industry('icd')  THEN 
                   SELECT COUNT(*) INTO l_n FROM icm_file                                                              
                    WHERE icm01 = b_brb.brb03 AND icm02 = b_brb.brb01  
                   IF l_n =0 THEN 
                      INITIALIZE l_icm.* TO NULL                                                                                    
                      LET l_icm.icm01 = b_brb.brb03                                                                                 
                      LET l_icm.icm02 = b_brb.brb01                                                                                 
                      LET l_icm.icmacti = 'Y'                                                                                       
                      LET l_icm.icmdate = g_today                                                                                   
                      LET l_icm.icmgrup = g_grup                                                                                    
                      LET l_icm.icmmodu = ''                                                                                        
                      LET l_icm.icmuser = g_user                                                                                    
                      LET l_icm.icmoriu = g_user     
                      LET l_icm.icmorig = g_grup     
                      INSERT INTO icm_file VALUES (l_icm.*)
                     IF SQLCA.sqlcode THEN 
                        CALL cl_err3("ins","icm_file",b_brb.brb01,b_brb.brb03,SQLCA.sqlcode,"","",1)
                        ROLLBACK WORK
                        CANCEL INSERT
                     END IF  
                   END IF                                      
                END IF                                  
                COMMIT WORK
#              CALL i500_tree_update()
            END IF
        END IF     
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_brb[l_ac].* TO NULL     
            LET g_brb15 ='N'
            LET g_brb19 ='Y'    LET g_brb21 ='Y'
            LET g_brb22 ='Y'    LET g_brb23 = 100
            LET g_brb11 = NULL  LET g_brb13 = NULL
            LET g_brb31 = 'N'
            LET g_brb[l_ac].brb31 = 'N'
            LET g_brb18 = 0     LET g_brb17 = 'N'
            LET g_brb20 = NULL
            LET g_brb28 = 0 # 誤差容許率預設值應為 0
            LET g_brb10_fac = 1 LET g_brb10_fac2 = 1
            LET g_brb[l_ac].brb16 = '0'
            LET g_brb[l_ac].brb14 = '0'
            LET g_brb[l_ac].brb04 = g_today #Body default
            LET g_brb[l_ac].brb06 = 1         #Body default
            LET g_brb[l_ac].brb07 = 1         #Body default
            LET g_brb[l_ac].brb08 = 0         #Body default
            LET g_brb[l_ac].brb19 = '1'
            LET g_brb[l_ac].brb081= 0
            LET g_brb[l_ac].brb082= 1
            LET g_brb[l_ac].brb09 = g_ecb06
            IF g_sma.sma118 != 'Y' THEN
                LET g_brb[l_ac].brb30 = ' '
            ELSE
                LET g_brb[l_ac].brb30 = '1'
            END IF
            IF g_brb[l_ac].brb30 != '3' THEN
               CALL cl_set_act_visible("edit_formula",FALSE)
            ELSE
               CALL cl_set_act_visible("edit_formula",TRUE)  
            END IF
            LET g_brb_t.* = g_brb[l_ac].*         #新輸入資料
            LET g_brb_o.* = g_brb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD brb02
  
        BEFORE FIELD brb03
          IF g_brb[l_ac].brb30 = '3' THEN
             CALL cl_set_act_visible("edit_formula", TRUE)
          ELSE
             CALL cl_set_act_visible("edit_formula", FALSE)
          END IF
          #如果brb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_brb[l_ac].brb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bra.bra01,g_brb[l_ac].brb03,1) RETURNING l_result
             IF cl_null(g_brb[l_ac].brb03) THEN
                LET g_brb[l_ac].brb03 = l_result
                #如果公式內容不為空則將品名規格都設置為"<依公式生成>"
                IF NOT cl_null(l_result) THEN
                  LET g_brb[l_ac].ima02_b = g_tipstr
                  LET g_brb[l_ac].ima021_b = g_tipstr
                ELSE
                  #否則將品名和規格清空
                  LET g_brb[l_ac].ima02_b = ''
                  LET g_brb[l_ac].ima021_b = ''
                END IF
             ELSE
                IF l_result != g_brb[l_ac].brb03 THEN
                   LET g_brb[l_ac].brb03 = l_result
                   #如果公式內容不為空則將品名規格都設置為"<依公式生成>"
                   IF NOT cl_null(l_result) THEN
                     LET g_brb[l_ac].ima02_b = g_tipstr
                     LET g_brb[l_ac].ima021_b = g_tipstr
                   ELSE
                     #否則將品名和規格清空
                     LET g_brb[l_ac].ima02_b = ''
                     LET g_brb[l_ac].ima021_b = ''
                   END IF
                END IF
             END IF
          END IF
 
        BEFORE FIELD brb06
          IF g_brb[l_ac].brb30 = '3' THEN
             CALL cl_set_act_visible("edit_formula", TRUE)
          ELSE
             CALL cl_set_act_visible("edit_formula", FALSE)
          END IF
          #如果brb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_brb[l_ac].brb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bra.bra01,g_brb[l_ac].brb03,2) RETURNING l_result
             IF cl_null(g_brb[l_ac].brb03) THEN
                LET g_brb[l_ac].brb03 = l_result
             ELSE
                IF l_result != g_brb[l_ac].brb03 THEN
                   LET g_brb[l_ac].brb03 = l_result
                END IF
             END IF
          END IF
 
        BEFORE FIELD brb08
          IF g_brb[l_ac].brb30 = '3' THEN
             CALL cl_set_act_visible("edit_formula", TRUE)
          ELSE
             CALL cl_set_act_visible("edit_formula", FALSE)
          END IF
          #如果brb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_brb[l_ac].brb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bra.bra01,g_brb[l_ac].brb03,3) RETURNING l_result
             IF cl_null(g_brb[l_ac].brb03) THEN
                LET g_brb[l_ac].brb03 = l_result
             ELSE
                IF l_result != g_brb[l_ac].brb03 THEN
                   LET g_brb[l_ac].brb03 = l_result
                END IF
             END IF
          END IF
 
        #當計算方式被修改時觸發
        ON CHANGE brb30
           #如果當前選擇的類型是"3.公式"時
           IF g_brb[l_ac].brb30 = '3' THEN
              #判斷當前的主件是否為進行多屬性料件管理的料件,如果是才可以繼續,否則要禁止選擇該項
              IF NOT cl_is_multi_feature_manage(g_bra.bra01) THEN
                 CALL cl_err(g_bra.bra01,'lib-299',0)
                 LET g_brb[l_ac].brb30 = '1'  #強制改回到"1.固定"
                 DISPLAY g_brb[l_ac].brb30 TO brb30
              END IF
           END IF
 
        BEFORE FIELD brb02                        #default 項次
            IF g_brb[l_ac].brb02 IS NULL OR g_brb[l_ac].brb02 = 0 THEN
                SELECT max(brb02)
                   INTO g_brb[l_ac].brb02
                   FROM brb_file
                   WHERE brb01 = g_bra.bra01
                     AND brb29 = g_bra.bra06  
                     AND brb011= g_bra.bra011
                   # AND brb012= g_bra.bra012         #FUN-B20101
                   # AND brb013= g_bra.bra013         #FUN-B20101
                     AND brb012= g_bra1[l_ac2].bra012
                     AND brb013= g_bra1[l_ac2].bra013
                IF g_brb[l_ac].brb02 IS NULL
                   THEN LET g_brb[l_ac].brb02 = 0
                END IF
                LET g_brb[l_ac].brb02 = g_brb[l_ac].brb02 + g_sma.sma19
            END IF
            IF p_cmd = 'a'
              THEN LET g_brb20 = g_brb[l_ac].brb02
            END IF
 
        AFTER FIELD brb02                        #default 項次
            IF g_brb[l_ac].brb02 IS NOT NULL AND
               g_brb[l_ac].brb02 <> 0 AND p_cmd='a' THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM brb_file
                      WHERE brb01=g_bra.bra01
                        AND brb29=g_bra.bra06 
                        AND brb011= g_bra.bra011
                       #AND brb012= g_bra.bra012         #FUN-B20101
                       #AND brb013= g_bra.bra013         #FUN-B20101
                        AND brb012= g_bra1[l_ac2].bra012
                        AND brb013= g_bra1[l_ac2].bra013
                        AND brb02=g_brb[l_ac].brb02
               IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN 
                     NEXT FIELD brb02 
                  ELSE
                     FOR l_i = 1 TO g_rec_b
                       IF l_i <> l_ac THEN
                         IF g_brb[l_i].brb02 = g_brb[l_ac].brb02 AND g_brb[l_i].brb04 <> g_brb[l_ac].brb04 THEN
                            LET g_brb[l_i].brb05 = g_brb[l_ac].brb04
                            DISPLAY BY NAME g_brb[l_i].brb04
                         END IF
                       END IF
                     END FOR
                  END IF
               END IF
            END IF
             #若有更新項次時,插件位置的key值更新為變動后的項次
             IF p_cmd = 'u' AND (g_brb[l_ac].brb02 != g_brb_t.brb02) THEN
                SELECT COUNT(*) INTO l_n FROM brb_file
                       WHERE brb01=g_bra.bra01
                         AND brb02=g_brb[l_ac].brb02
                         AND brb011= g_bra.bra011
                       # AND brb012= g_bra.bra012
                       # AND brb013= g_bra.bra013   
                         AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                         AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101 
                IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN 
                     NEXT FIELD brb02 
                  ELSE
                     FOR l_i = 1 TO g_rec_b
                       IF l_i <> l_ac THEN
                         IF g_brb[l_i].brb02 = g_brb[l_ac].brb02 AND g_brb[l_i].brb04 <> g_brb[l_ac].brb04 THEN
                            LET g_brb[l_i].brb05 = g_brb[l_ac].brb04
                            DISPLAY BY NAME g_brb[l_i].brb04
                         END IF
                       END IF
                     END FOR
                  END IF
                END IF
#               UPDATE bmt_file
#                  SET bmt02 = g_brb[l_ac].brb02,
#                      bmt06 = g_brb[l_ac].brb13    
#                WHERE bmt01 = g_bra.bra01
#                  AND bmt03 = g_brb[l_ac].brb03
#                  AND bmt04 = g_brb[l_ac].brb04
#                  AND bmt02 = g_brb_t.brb02
             END IF
            IF s_industry('slk') THEN
               IF g_brb[l_ac].brb02 IS NOT NULL AND g_brb[l_ac].brb03 IS NOT NULL AND 
                  g_brb[l_ac].brb04 IS NOT NULL AND g_brb[l_ac].brb13 IS NOT NULL AND p_cmd = 'a' THEN 
                 SELECT COUNT(*) INTO l_r  FROM brb_file WHERE brb01 = g_bra.bra01 
                                                           AND brb011= g_bra.bra011
                                                        #  AND brb012= g_bra.bra012
                                                        #  AND brb013= g_bra.bra013
                                                           AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                                                           AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                                                           AND brb02 = g_brb[l_ac].brb02
                                                           AND brb03 = g_brb[l_ac].brb03
                                                           AND brb04 = g_brb[l_ac].brb04
                                                           AND brb13 = g_brb[l_ac].brb13
                IF l_r >0 THEN
                   CALL cl_err('','abm-644',0)
                   NEXT FIELD brb02
                END IF
               END IF
           END IF 
 
        AFTER FIELD brb03                         #(元件料件)
            #FUN-AA0059 -------------------------add start---------------------------
            IF NOT cl_null(g_brb[l_ac].brb03) THEN
               IF NOT s_chk_item_no(g_brb[l_ac].brb03,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_brb[l_ac].brb03=g_brb_t.brb03
                  NEXT FIELD brb03
               END IF 
            END IF     
            #FUN-AA0059 --------------------------add end------------------------
            #增加判斷邏輯
            IF g_brb[l_ac].brb30 = '3' THEN   #如果當前的計算方式是"3.公式"的話那么就不進行正常的檢測了       
               #新的檢核邏輯:檢查對應的公式是否存在
               IF NOT cl_null(g_brb[l_ac].brb03) THEN
                  #現在是檢查其中公式前綴對應的三個公式是否至少存在一個
                  LET l_str = '&',g_brb[l_ac].brb03 CLIPPED,'-1&'
                  SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
                  IF l_count > 0 THEN LET l_valid = TRUE
                  ELSE
                    LET l_str = '&',g_brb[l_ac].brb03 CLIPPED,'-2&'
                    SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
                    IF l_count > 0 THEN LET l_valid = TRUE
                    ELSE
                      LET l_str = '&',g_brb[l_ac].brb03 CLIPPED,'-3&'
                      SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
                      IF l_count > 0 THEN LET l_valid = TRUE
                      ELSE LET l_valid = FALSE
                      END IF
                    END IF
                 END IF
                 IF NOT l_valid THEN
                    CALL cl_err(g_brb[l_ac].brb03,'lib-253',1)
                    NEXT FIELD brb03
                 ELSE
                    #因為用戶可能手輸公式名稱,這時就需要來給品名規格賦一下值
                    LET g_brb[l_ac].ima02_b = g_tipstr
                    LET g_brb[l_ac].ima021_b = g_tipstr
                 END IF
               ELSE
                 #否則清除可能有品名規格中出現的<依公式生成>字樣
                 LET g_brb[l_ac].ima02_b = ''
                 LET g_brb[l_ac].ima021_b = ''
               END IF
            ELSE
               #以下是原有判斷邏輯
               IF cl_null(g_brb[l_ac].brb03) THEN
                  LET g_brb[l_ac].brb03=g_brb_t.brb03
               END IF
               IF NOT cl_null(g_brb[l_ac].brb03) THEN
                   #IF cl_null(g_brb_t.brb03) THEN   
                   IF cl_null(g_brb_t.brb03) OR g_brb_t.brb03 <> g_brb[l_ac].brb03 THEN     #MOD-740315
                      SELECT COUNT(*) INTO l_n FROM brb_file
                             WHERE brb01=g_bra.bra01
                               AND brb011= g_bra.bra011
                             # AND brb012= g_bra.bra012         #FUN-B20101
                             # AND brb013= g_bra.bra013         #FUN-B20101
                               AND brb012= g_bra1[l_ac2].bra012
                               AND brb013= g_bra1[l_ac2].bra013
                               AND brb29=g_bra.bra06
                               AND brb03=g_brb[l_ac].brb03
                      IF l_n>0 THEN
                         IF NOT cl_confirm('abm-728') THEN NEXT FIELD brb03 END IF
                      END IF
                   END IF
                   CALL i500_brb03(p_cmd)    #必需讀取(料件主檔) 
                           IF NOT cl_null(g_errno) THEN
                               CALL cl_err('',g_errno,0)
                               LET g_brb[l_ac].brb03=g_brb_t.brb03
                               NEXT FIELD brb03
                           END IF
                   IF p_cmd = 'a' THEN LET g_brb15 = g_ima70_b END IF
                   IF s_bomchk(g_bra.bra01,g_brb[l_ac].brb03,g_ima08_h,g_ima08_b)
                             THEN NEXT FIELD brb03
                   END IF
                   IF g_brb[l_ac].brb10 IS NULL OR g_brb[l_ac].brb10 = ' '
                              OR g_brb[l_ac].brb03 != g_brb_t.brb03
                             THEN LET g_brb[l_ac].brb10 = g_ima63_b
                                  DISPLAY g_ima63_b   TO s_brb[l_sl].brb10
                      CALL i500_brb081_check() RETURNING l_tf           #FUN-BB0085 
                   END IF
                   IF g_ima08_b = 'D'
                             THEN LET g_brb17 = 'Y'
                             ELSE LET g_brb17 = 'N'
                   END IF
               END IF
            END IF    
            IF s_industry('slk') THEN  
               IF NOT cl_null(g_brb[l_ac].brb03) THEN
                  SELECT ima151 INTO r_ima151 FROM ima_file WHERE ima01 = g_brb[l_ac].brb03
                  IF g_brb[l_ac].brb30 = '1' THEN   
                     IF  r_ima151 = 'Y' THEN
                         CALL cl_err('','abm-645',0)
                         NEXT FIELD brb03
                     END IF
                  END IF
                  IF g_brb[l_ac].brb30 = '4' THEN   
                     IF  r_ima151 <> 'Y' THEN
                         CALL cl_err('','abm-646',0)
                         NEXT FIELD brb03
                     END IF
                  END IF
              END IF
              IF g_brb[l_ac].brb02 IS NOT NULL AND g_brb[l_ac].brb03 IS NOT NULL AND 
                 g_brb[l_ac].brb04 IS NOT NULL AND g_brb[l_ac].brb13 IS NOT NULL AND p_cmd = 'a'THEN 
                SELECT COUNT(*) INTO l_r  FROM brb_file WHERE brb01 = g_bra.bra01
                                                          AND brb011= g_bra.bra011
                                                        # AND brb012= g_bra.bra012
                                                        # AND brb013= g_bra.bra013 
                                                          AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                                                          AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                                                          AND brb29 = g_bra.bra06 
                                                          AND brb02 = g_brb[l_ac].brb02
                                                          AND brb03 = g_brb[l_ac].brb03
                                                          AND brb04 = g_brb[l_ac].brb04
                                                          AND brb13 = g_brb[l_ac].brb13
               IF l_r >0 THEN
                  CALL cl_err('','abm-644',0)
                  NEXT FIELD brb02
               END IF
              END IF
              IF NOT cl_null(g_brb[l_ac].brb03) THEN      
                CALL i500_brb30(g_brb[l_ac].brb30,g_brb[l_ac].brb03)  RETURNING l_success
                IF l_success = 'N' THEN 
                  LET g_brb[l_ac].brb03 = g_brb_t.brb03 
                  NEXT FIELD brb03
                END IF    
              END IF   
            END IF
            IF NOT l_tf THEN NEXT FIELD brb081 END IF     #FUN-BB0085
 
        AFTER FIELD brb04                        #check 是否重復
            IF NOT cl_null(g_brb[l_ac].brb04) THEN
               IF NOT cl_null(g_brb[l_ac].brb05) THEN
                  IF g_brb[l_ac].brb05 < g_brb[l_ac].brb04 THEN 
                     CALL cl_err(g_brb[l_ac].brb04,'mfg2604',0)
                     NEXT FIELD brb04
                  END IF
               END IF
                IF g_brb[l_ac].brb04 IS NOT NULL AND
                   (g_brb[l_ac].brb04 != g_brb_t.brb04 OR
                    g_brb_t.brb04 IS NULL OR
                    g_brb[l_ac].brb02 != g_brb_t.brb02 OR
                    g_brb_t.brb02 IS NULL OR
                    g_brb[l_ac].brb03 != g_brb_t.brb03 OR
                    g_brb_t.brb03 IS NULL) THEN
                    SELECT count(*) INTO l_n
                        FROM brb_file
                        WHERE brb01 = g_bra.bra01
                           AND brb29 = g_bra.bra06 
                           AND brb011= g_bra.bra011
                         # AND brb012= g_bra.bra012
                         # AND brb013= g_bra.bra013
                           AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                           AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                           AND brb02 = g_brb[l_ac].brb02
                           AND brb03 = g_brb[l_ac].brb03
                           AND brb04 = g_brb[l_ac].brb04
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_brb[l_ac].brb02 = g_brb_t.brb02
                        LET g_brb[l_ac].brb03 = g_brb_t.brb03
                        LET g_brb[l_ac].brb04 = g_brb_t.brb04
                        DISPLAY g_brb[l_ac].brb02 TO s_brb[l_sl].brb02
                        DISPLAY g_brb[l_ac].brb03 TO s_brb[l_sl].brb03
                        DISPLAY g_brb[l_ac].brb04 TO s_brb[l_sl].brb04
                        NEXT FIELD brb02
                    END IF
                END IF
                CALL i500_bdate(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_brb[l_ac].brb04,g_errno,0)
                   LET g_brb[l_ac].brb04 = g_brb_t.brb04
                   DISPLAY g_brb[l_ac].brb04 TO s_brb[l_sl].brb04
                   NEXT FIELD brb04
                END IF
            END IF
            IF s_industry('slk') THEN
              IF g_brb[l_ac].brb02 IS NOT NULL AND g_brb[l_ac].brb03 IS NOT NULL AND 
                 g_brb[l_ac].brb04 IS NOT NULL AND g_brb[l_ac].brb13 IS NOT NULL AND p_cmd = 'a' THEN 
                SELECT COUNT(*) INTO l_r  FROM brb_file WHERE brb01 = g_bra.bra01
                                                          AND brb29 = g_bra.bra06 
                                                          AND brb011= g_bra.bra011
                                                       #  AND brb012= g_bra.bra012
                                                       #  AND brb013= g_bra.bra013
                                                          AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                                                          AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                                                          AND brb02 = g_brb[l_ac].brb02
                                                          AND brb03 = g_brb[l_ac].brb03
                                                          AND brb04 = g_brb[l_ac].brb04
                                                          AND brb13 = g_brb[l_ac].brb13
               IF l_r >0 THEN
                  CALL cl_err('','abm-644',0)
                  NEXT FIELD brb02
               END IF
              END IF
           END IF
           
        AFTER FIELD brb05   #check失效日小于生效日
            IF NOT cl_null(g_brb[l_ac].brb05) THEN
               IF NOT cl_null(g_brb[l_ac].brb04) THEN
                  IF g_brb[l_ac].brb05 < g_brb[l_ac].brb04 THEN 
                     CALL cl_err(g_brb[l_ac].brb05,'mfg2604',0)
                     NEXT FIELD brb05
                  END IF
               END IF
                IF g_brb[l_ac].brb05 IS NOT NULL OR g_brb[l_ac].brb05 != ' '
                   THEN IF g_brb[l_ac].brb05 < g_brb[l_ac].brb04
                          THEN CALL cl_err(g_brb[l_ac].brb05,'mfg2604',0)
                          NEXT FIELD brb04
                        END IF
                END IF
                CALL i500_edate(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_brb[l_ac].brb05,g_errno,0)
                   LET g_brb[l_ac].brb05 = g_brb_t.brb05
                   DISPLAY g_brb[l_ac].brb05 TO s_brb[l_sl].brb05
                   NEXT FIELD brb04
                END IF
            END IF
 
        AFTER FIELD brb06    #組成用量不可小于零
          IF NOT cl_null(g_brb[l_ac].brb06) THEN
             IF g_brb[l_ac].brb14 <> '2' THEN   
                IF g_brb[l_ac].brb06 <= 0 THEN
                   CALL cl_err(g_brb[l_ac].brb06,'mfg2614',0)
                   LET g_brb[l_ac].brb06 = g_brb_o.brb06
                   DISPLAY BY NAME g_brb[l_ac].brb06
                   NEXT FIELD brb06
                END IF
             ELSE
               #IF g_brb[l_ac].brb06 > 0 THEN      #CHI-AC0037
                IF g_brb[l_ac].brb06 >= 0 THEN     #CHI-AC0037
                   CALL cl_err('','asf-603',0)
                   NEXT FIELD brb06
                 END IF
             END IF             
          END IF
          LET g_brb_o.brb06 = g_brb[l_ac].brb06
 
        AFTER FIELD brb07    #底數不可小于等于零
            IF NOT cl_null(g_brb[l_ac].brb07) THEN
                IF g_brb[l_ac].brb07 <= 0
                 THEN CALL cl_err(g_brb[l_ac].brb07,'mfg2615',0)
                      LET g_brb[l_ac].brb07 = g_brb_o.brb07
                       DISPLAY BY NAME g_brb[l_ac].brb07
                      NEXT FIELD brb07
                END IF
                LET g_brb_o.brb07 = g_brb[l_ac].brb07
            ELSE
               CALL cl_err(g_brb[l_ac].brb07,'mfg3291',1)
               LET g_brb[l_ac].brb07 = g_brb_o.brb07
               NEXT FIELD brb07
            END IF
 
        AFTER FIELD brb08    #損耗率
            IF NOT cl_null(g_brb[l_ac].brb08) THEN
                IF g_brb[l_ac].brb08 < 0 OR g_brb[l_ac].brb08 > 100
                 THEN CALL cl_err(g_brb[l_ac].brb08,'mfg4063',0)
                      LET g_brb[l_ac].brb08 = g_brb_o.brb08
                      NEXT FIELD brb08
                END IF
                LET g_brb_o.brb08 = g_brb[l_ac].brb08
            END IF
            IF cl_null(g_brb[l_ac].brb08) THEN
                LET g_brb[l_ac].brb08 = 0
            END IF
            DISPLAY BY NAME g_brb[l_ac].brb08
            
        AFTER FIELD brb081    #固定損耗量
           IF NOT i500_brb081_check() THEN NEXT FIELD  brb081 END IF          #FUN-BB0085
           #FUN-BB0085--mark--str----------------- 
           #IF NOT cl_null(g_brb[l_ac].brb081) THEN
           #    IF g_brb[l_ac].brb081 < 0 THEN 
           #       CALL cl_err(g_brb[l_ac].brb081,'aec-020',0)
           #       LET g_brb[l_ac].brb081 = g_brb_o.brb081
           #       NEXT FIELD brb081
           #    END IF
           #    LET g_brb_o.brb081 = g_brb[l_ac].brb081
           #END IF
           #IF cl_null(g_brb[l_ac].brb081) THEN
           #    LET g_brb[l_ac].brb081 = 0
           #END IF
           #DISPLAY BY NAME g_brb[l_ac].brb081
           #FUN-BB0085--mark--end------------------
            
        AFTER FIELD brb082    #損耗批量
            IF NOT cl_null(g_brb[l_ac].brb082) THEN
                IF g_brb[l_ac].brb082 <= 0 THEN 
                   CALL cl_err(g_brb[l_ac].brb082,'alm-808',0)
                   LET g_brb[l_ac].brb082 = g_brb_o.brb082
                   NEXT FIELD brb082
                END IF
                LET g_brb_o.brb082 = g_brb[l_ac].brb082
            END IF
            IF cl_null(g_brb[l_ac].brb082) THEN
                LET g_brb[l_ac].brb082 = 1
            END IF
            DISPLAY BY NAME g_brb[l_ac].brb082
                         
        AFTER FIELD brb09    #作業編號
            IF NOT cl_null(g_brb[l_ac].brb09)
               THEN
               SELECT COUNT(*) INTO g_cnt FROM ecd_file
                WHERE ecd01=g_brb[l_ac].brb09
               IF g_cnt=0
                  THEN
                  CALL cl_err('sel ecd_file',100,0)
                  NEXT FIELD brb09
               END IF
            END IF
            IF g_brb[l_ac].brb09 IS NULL THEN
                LET g_brb[l_ac].brb09 = ' '
            END IF
 
        AFTER FIELD brb10   #發料單位
           IF g_brb[l_ac].brb10 IS NULL OR g_brb[l_ac].brb10 = ' '
             THEN LET g_brb[l_ac].brb10 = g_brb_o.brb10
             DISPLAY BY NAME g_brb[l_ac].brb10
             ELSE 
                IF cl_null(g_brb[l_ac].brb30) THEN
                   LET g_brb[l_ac].brb30 = ' '
                END IF
                 IF ((g_brb_o.brb10 IS NULL) OR (g_brb_t.brb10 IS NULL)
                      OR (g_brb[l_ac].brb10 != g_brb_o.brb10))
                     AND (g_brb[l_ac].brb30 <> '3' )   #如果是當前方式為“公式”則不判斷
                  THEN CALL i500_brb10()
                       IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_brb[l_ac].brb10,g_errno,0)
                           LET g_brb[l_ac].brb10 = g_brb_o.brb10
                           DISPLAY g_brb[l_ac].brb10 TO s_brb[l_sl].brb10
                           NEXT FIELD brb10
                       ELSE IF g_brb[l_ac].brb10 != g_ima25_b
                            THEN CALL s_umfchk(g_brb[l_ac].brb03,
                                 g_brb[l_ac].brb10,g_ima25_b)
                                 RETURNING g_sw,g_brb10_fac  #發料/庫存單位
                                 IF g_sw THEN
                                   CALL cl_err(g_brb[l_ac].brb10,'mfg2721',0)
                                   LET g_brb[l_ac].brb10 = g_brb_o.brb10
                                   DISPLAY g_brb[l_ac].brb10 TO
                                           s_brb[l_sl].brb10
                                   NEXT FIELD brb10
                                 END IF
                            ELSE   LET g_brb10_fac  = 1
                            END  IF
                            IF g_brb[l_ac].brb10 != g_ima86_b  #發料/成本單位
                            THEN CALL s_umfchk(g_brb[l_ac].brb03,
                                         g_brb[l_ac].brb10,g_ima86_b)
                                 RETURNING g_sw,g_brb10_fac2
                                 IF g_sw THEN
                                   CALL cl_err(g_brb[l_ac].brb03,'mfg2722',0)
                                   LET g_brb[l_ac].brb10 = g_brb_o.brb10
                                   DISPLAY g_brb[l_ac].brb10 TO
                                             s_brb[l_sl].brb10
                                   NEXT FIELD brb10
                                 END IF
                            ELSE LET g_brb10_fac2 = 1
                          END IF
                       END IF
                  END IF
          END IF
          LET g_brb_o.brb10 = g_brb[l_ac].brb10
          #FUN-BB0085-add-str--
          IF NOT i500_brb081_check() THEN 
             LET g_brb10_t = g_brb[l_ac].brb10
             NEXT FIELD brb081
          END IF
          LET g_brb10_t = g_brb[l_ac].brb10
          #FUN-BB0085-add-end--
 
#        AFTER FIELD brb16  #替代特性
#           IF NOT cl_null(g_brb[l_ac].brb16) THEN
#               IF g_brb[l_ac].brb16 NOT MATCHES'[01257]' THEN  #FUN-A20037
#                   LET g_brb[l_ac].brb16 = g_brb_o.brb16
#                   DISPLAY BY NAME g_brb[l_ac].brb16
#                   NEXT FIELD brb16
#               END IF
#               IF NOT cl_null(g_brb[l_ac].brb14) THEN
#                  IF g_brb[l_ac].brb14 = '2' THEN
#                     LET g_brb[l_ac].brb16 = '0'
#                  END IF
#               END IF
#               IF g_brb[l_ac].brb16 != '0' AND        #詢問是否輸入取代或替代料件
#                  (g_brb[l_ac].brb16 != g_brb_o.brb16)
#                   THEN
#                       CALL i5002_prompt()
#               END IF
#               LET g_brb_o.brb16 = g_brb[l_ac].brb16
#           END IF
 
        AFTER FIELD brb14  
           IF NOT cl_null(g_brb[l_ac].brb14) THEN
               IF g_brb[l_ac].brb14 NOT MATCHES'[0123]' THEN  #FUN-910053 add 23
                   LET g_brb[l_ac].brb14 = g_brb_o.brb14
                   DISPLAY BY NAME g_brb[l_ac].brb14
                   NEXT FIELD brb14
               END IF
              IF g_brb[l_ac].brb14 = '2' THEN
                 LET g_brb[l_ac].brb16 = '0'
              END IF
              IF cl_null(g_brb[l_ac].brb06) OR g_brb[l_ac].brb06=0 THEN
                 IF g_brb[l_ac].brb14 = '2' THEN
                    LET g_brb[l_ac].brb06 = -1
                 ELSE
                    LET g_brb[l_ac].brb06 = 1
                 END IF
              ELSE
                 IF g_brb[l_ac].brb14 = '2' AND g_brb[l_ac].brb06 > 0 THEN
                    LET g_brb[l_ac].brb06=g_brb[l_ac].brb06 * (-1)
                 END IF
                 IF g_brb[l_ac].brb14 <> '2' AND g_brb[l_ac].brb06 < 0 THEN
                    LET g_brb[l_ac].brb06=g_brb[l_ac].brb06 * (-1)
                 END IF
              END IF
           END IF
 
        AFTER FIELD brb19
          IF NOT cl_null(g_brb[l_ac].brb19) THEN
              IF g_brb[l_ac].brb19 NOT MATCHES'[1234]' THEN
                  LET g_brb[l_ac].brb19 = g_brb_o.brb19
                  DISPLAY BY NAME g_brb[l_ac].brb19
                  NEXT FIELD brb19
              END IF
          END IF
#          IF NOT s_industry('slk') THEN    
#             IF g_ima107_b = 'Y' THEN #Y:自動開窗輸入insert_loc
#                CALL i500_loc('u')
#             END IF
#          END IF                           
        
          AFTER FIELD brb30
             IF cl_null(g_brb[l_ac].brb30) THEN
                LET g_brb[l_ac].brb30 = ' '
             END IF
           IF s_industry('slk') THEN
            IF NOT cl_null(g_brb[l_ac].brb03) THEN      
             CALL i500_brb30(g_brb[l_ac].brb30,g_brb[l_ac].brb03)  RETURNING l_success
             IF l_success = 'N' THEN 
                LET g_brb[l_ac].brb30 = g_brb_t.brb30
                NEXT FIELD brb30
             END IF  
            END IF               
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_brb_t.brb02 > 0 AND
               g_brb_t.brb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM brb_file
                    WHERE brb01 = g_bra.bra01
                      AND brb29 = g_bra.bra06 
                      AND brb011=g_bra.bra011
                    # AND brb012=g_bra.bra012
                    # AND brb013=g_bra.bra013          
                      AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                      AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101            
                      AND brb02 = g_brb_t.brb02
                      AND brb03 = g_brb_t.brb03
                      AND brb04 = g_brb_t.brb04
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 OR g_success='N' THEN
                    LET l_buf = g_brb_t.brb02 clipped,'+',
                                g_brb_t.brb03 clipped,'+',
                                g_brb_t.brb04
                    CALL cl_err(l_buf,SQLCA.sqlcode,0)   
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE
                    #No.FUN-A60008--begin
            	      IF g_bra.bra10 =2 AND g_sma.sma101='Y'  THEN 
            	         
            	         CALL i500_updbmb(b_brb.*,'','','d')
            	      END IF
            	      #No.FUN-A60008--end                 	
                    LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N  
                END IF
#                IF g_sma.sma845='Y' THEN  #低階碼可否部份重計
#                    LET g_success='Y'
#                    CALL s_uima146(g_brb[l_ac].brb03)
#                    MESSAGE ""
#                    IF g_success='N' THEN
#                       CALL cl_err(g_brb[l_ac].brb03,'abm-002',1)
#                       ROLLBACK WORK
#                       CANCEL DELETE
#                     ELSE
#                    LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N 
#                    END IF
#                END IF
                #如果當前定義了公式則刪除對應的公式
                IF g_brb[l_ac].brb30 = '3' THEN
                   IF NOT cl_null(g_brb[l_ac].brb03) THEN
                      LET l_formula01 = '&',g_brb[l_ac].brb03 CLIPPED,'-1&'
                      LET l_formula02 = '&',g_brb[l_ac].brb03 CLIPPED,'-2&'
                      LET l_formula03 = '&',g_brb[l_ac].brb03 CLIPPED,'-3&'
 
                      #公式單頭檔
                      DELETE FROM gep_file WHERE
                        gep01 = l_formula01 OR gep01 = l_formula02 OR
                        gep01 = l_formula03
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","gep_file",l_formula01,l_formula02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                         ROLLBACK WORK
                         CANCEL DELETE
                       ELSE
                        LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N  
                      END IF
                      #公式單身檔(變量)
                      DELETE FROM geq_file WHERE
                        geq01 = l_formula01 OR geq01 = l_formula02 OR
                        geq01 = l_formula03
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","geq_file",l_formula01,l_formula02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                         ROLLBACK WORK
                         CANCEL DELETE
                       ELSE
                         LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N  
                      END IF
                      #公式單身檔(表達式)
                      DELETE FROM ger_file WHERE
                        ger01 = l_formula01 OR ger01 = l_formula02 OR
                        ger01 = l_formula03
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","ger_file",l_formula01,l_formula02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                         ROLLBACK WORK
                         CANCEL DELETE
                       ELSE
                         LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N 
                      END IF
                   END IF
                END IF
                LET g_modify_flag = 'Y' #MOD-530319
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
           #CALL i500_tree_update()
         COMMIT WORK
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_brb[l_ac].* = g_brb_t.*
               CLOSE i500_bcl
               ROLLBACK WORK
             # EXIT INPUT      #FUN-B20101
               EXIT DIALOG     #FUN-B20101
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_brb[l_ac].brb02,-263,1)
                LET g_brb[l_ac].* = g_brb_t.*
            ELSE
               --CALL i500_tree_loop(g_bra.bra01,g_brb[l_ac].brb03,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
               --IF l_loop = "Y" THEN
                  --CALL cl_err(g_brb[l_ac].brb03,"agl1000",1)
                  --LET g_abd[l_ac].* = g_abd_t.*
               --ELSE
                CALL i500_b_move_back() 
                UPDATE brb_file SET * = b_brb.*
                 WHERE brb01 = g_bra.bra01
                   AND brb29 = g_bra.bra06 
                   AND brb011= g_bra.bra011
                 # AND brb012= g_bra.bra012
                 # AND brb013= g_bra.bra013
                   AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                   AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                   AND brb02 = g_brb_t.brb02
                   AND brb03 = g_brb_t.brb03
                   AND brb04 = g_brb_t.brb04
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","brb_file",g_bra.bra01,g_brb_t.brb02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    LET g_brb[l_ac].* = g_brb_t.*
                    
                ELSE
                    #No.FUN-A60008--begin
            	      IF g_bra.bra10 =2 AND g_sma.sma101='Y'  THEN 
            	         CALL i500_b_move_back()
            	         CALL i500_updbmb(b_brb.*,g_brb_t.brb03,g_brb_t.brb06,'u')
            	      END IF
            	      #No.FUN-A60008--end                     	 
                    UPDATE bra_file SET bradate = g_today
                                    WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06
                                   #  AND bra011=g_bra.bra011 AND bra012=g_bra.bra012
                                   #  AND bra013=g_bra.bra013
                                      AND bra011=g_bra.bra011          #FUN-B20101
                    #--->update 上一項次失效日
                    CALL i500_update('u')
#                    IF g_sma.sma845='Y' AND  #低階碼可否部份重計
#                       g_brb_t.brb03 <> g_brb[l_ac].brb03
#                       THEN
#                       CALL s_uima146(g_brb[l_ac].brb03)
#                       CALL s_uima146(g_brb_t.brb03)
#                       MESSAGE ""
#                       IF g_success='N' THEN
#                           #不可輸入此元件料號,因為產品結構偵錯發現有誤!
#                          CALL cl_err(g_brb[l_ac].brb03,'abm-602',1)  
#                          LET g_brb[l_ac].* = g_brb_t.*
#                          DISPLAY g_brb[l_ac].* TO s_brb[l_sl].*
#                          ROLLBACK WORK
#                          NEXT FIELD brb02
#                       END IF
#                    END IF
                    #--->新增料件時系統參數(sma18 低階碼是重新計算)
                    IF l_uflag = 'N' THEN
                       UPDATE sma_file SET sma18 = 'Y'
                               WHERE sma00 = '0'
                       IF SQLCA.SQLERRD[3] = 0 THEN
                         CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  #No.TQC-660046
                       END IF
                       LET l_uflag = 'Y'
                    END IF
                    LET g_modify_flag = 'Y' #MOD-530319
                    MESSAGE 'UPDATE O.K'
                    IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF                                                                                                          
                    LET l_mdm_tag = 1                   
                    LET g_wsw03 = g_bra.bra01 CLIPPED ,'|', g_brb[l_ac].brb02 CLIPPED     
#                        CASE aws_mdmdata('brb_file','update',g_wsw03,base.TypeInfo.create(b_brb),'CreateBOMData') 
#                        WHEN 0  #無與 MDM 整合
#                             MESSAGE 'UPDATE O.K'
#                        WHEN 1  #呼叫 MDM 成功
#                             MESSAGE 'UPDATE O.K, UPDATE MDM O.K'
#                        WHEN 2  #呼叫 MDM 失敗
#                             ROLLBACK WORK
#                             CONTINUE INPUT
#                    END CASE
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
          # LET l_ac = ARR_CURR()                      #FUN-B20101
            LET l_ac = DIALOG.getCurrentRow("s_brb")   #FUN-B20101
            LET l_ac_t = l_ac     
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_brb[l_ac].* = g_brb_t.*
               END IF
               CLOSE i500_bcl
              ROLLBACK WORK
            #  EXIT INPUT   #FUN-B20101
               EXIT DIALOG  #FUN-B20101
            END IF
            IF cl_null(g_brb[l_ac].brb02) OR 
               cl_null(g_brb[l_ac].brb03) THEN
               CALL g_brb.deleteElement(l_ac)
            END IF
            CLOSE i500_bcl
            COMMIT WORK
 
       ON ACTION edit_formula
        CASE WHEN INFIELD (brb03)
          #如果brb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_brb[l_ac].brb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bra.bra01,g_brb[l_ac].brb03,1) RETURNING l_result
             IF cl_null(g_brb[l_ac].brb03) THEN
                LET g_brb[l_ac].brb03 = l_result
                #如果公式內容不為空則將品名規格都設置為"<依公式生成>"
                IF NOT cl_null(l_result) THEN
                  LET g_brb[l_ac].ima02_b = g_tipstr
                  LET g_brb[l_ac].ima021_b = g_tipstr
                ELSE
                  #否則將品名和規格清空
                  LET g_brb[l_ac].ima02_b = ''
                  LET g_brb[l_ac].ima021_b = ''
                END IF
             ELSE
                IF l_result != g_brb[l_ac].brb03 THEN
                   LET g_brb[l_ac].brb03 = l_result
                   #如果公式內容不為空則將品名規格都設置為"<依公式生成>"
                   IF NOT cl_null(l_result) THEN
                     LET g_brb[l_ac].ima02_b = g_tipstr
                     LET g_brb[l_ac].ima021_b = g_tipstr
                   ELSE
                     #否則將品名和規格清空
                     LET g_brb[l_ac].ima02_b = ''
                     LET g_brb[l_ac].ima021_b = ''
                   END IF
                END IF
             END IF
          END IF
 
        WHEN INFIELD (brb06)
          #如果brb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_brb[l_ac].brb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bra.bra01,g_brb[l_ac].brb03,2) RETURNING l_result
             IF cl_null(g_brb[l_ac].brb03) THEN
                LET g_brb[l_ac].brb03 = l_result
             ELSE
                IF l_result != g_brb[l_ac].brb03 THEN
                   LET g_brb[l_ac].brb03 = l_result
                END IF
             END IF
          END IF
 
        WHEN INFIELD (brb08)
          #如果brb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_brb[l_ac].brb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bra.bra01,g_brb[l_ac].brb03,3) RETURNING l_result
             IF cl_null(g_brb[l_ac].brb03) THEN
                LET g_brb[l_ac].brb03 = l_result
             ELSE
                IF l_result != g_brb[l_ac].brb03 THEN
                   LET g_brb[l_ac].brb03 = l_result
                END IF
             END IF
          END IF
        OTHERWISE
          CALL cl_err('','abm-998',1)
          EXIT CASE
      END CASE
 
        ON ACTION create_item_master #建立料件非明細資料
             IF g_sma.sma09 = 'Y' THEN
                IF s_industry('slk') THEN LET l_cmd = "aimi100_slk '",g_brb[l_ac].brb03,"'" END IF  
                IF s_industry('icd') THEN LET l_cmd = "aimi100_icd '",g_brb[l_ac].brb03,"'" END IF  
                IF s_industry('std') THEN LET l_cmd = "aimi100 '",g_brb[l_ac].brb03,"'" END IF  
                IF cl_null(l_cmd) THEN LET l_cmd = "aimi100 '",g_brb[l_ac].brb03,"'" END IF
                CALL cl_cmdrun(l_cmd)
                NEXT FIELD brb03
             ELSE
                CALL cl_err(' ','mfg2617',0)
                NEXT FIELD brb03
             END IF

#        ON ACTION create_unit_data
#           CALL cl_cmdrun('aooi101 ')  #建立單位資料
# 
#        ON ACTION create_unit_transfer_data     #建立單位換算資料
#           CALL cl_cmdrun("aooi102 ")
# 
#        ON ACTION view_unit_transfer             #料件單位換算資料
#           CALL cl_cmdrun("aooi103 ")

     ON ACTION CONTROLP
           CASE WHEN INFIELD(brb03) #料件主檔
                IF g_brb[l_ac].brb30 = '3' THEN
                   NEXT FIELD brb03
                ELSE
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   CASE g_brb[l_ac].brb30
               #        WHEN '1'
               #              LET g_qryparam.form = "q_ima01_2"   
               #        WHEN '4'
               #              LET g_qryparam.form = "q_ima01_1"   
               #        OTHERWISE
               #              LET g_qryparam.form = "q_ima01"   
               #   END CASE
               #   LET g_qryparam.default1 = g_brb[l_ac].brb03
               #      CALL cl_create_qry() RETURNING g_brb[l_ac].brb03
                  CASE g_brb[l_ac].brb30
                       WHEN '1'
                            CALL q_sel_ima(FALSE, "q_ima01_2", "", g_brb[l_ac].brb03, "", "", "", "" ,"",'' )  RETURNING g_brb[l_ac].brb03 
                       WHEN '4'          
                            CALL q_sel_ima(FALSE, "q_ima01_1", "", g_brb[l_ac].brb03, "", "", "", "" ,"",'' )  RETURNING g_brb[l_ac].brb03        
                       OTHERWISE
                            CALL q_sel_ima(FALSE, "q_ima01", "", g_brb[l_ac].brb03, "", "", "", "" ,"",'' )  RETURNING g_brb[l_ac].brb03
                  END CASE
#FUN-AA0059 --End--
                  DISPLAY g_brb[l_ac].brb03 TO brb03
                  NEXT FIELD brb03
                END IF 
              WHEN INFIELD(brb09) #作業主檔
                   CALL q_ecd(FALSE,TRUE,g_brb[l_ac].brb09) RETURNING g_brb[l_ac].brb09
                   DISPLAY g_brb[l_ac].brb09 TO brb09
                   NEXT FIELD brb09
               WHEN INFIELD(brb10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_brb[l_ac].brb10
                  CALL cl_create_qry() RETURNING g_brb[l_ac].brb10
                  DISPLAY g_brb[l_ac].brb10 TO brb10
                  NEXT FIELD brb10
               OTHERWISE EXIT CASE
           END  CASE
  
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(brb02) AND l_ac > 1 THEN
               LET g_brb[l_ac].* = g_brb[l_ac-1].*
               LET g_brb[l_ac].brb04 = g_today
               LET g_brb[l_ac].brb02 = NULL
               LET g_brb[l_ac].brb05 = NULL  
               NEXT FIELD brb02
           END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        #TQC-C30136--mark--str--
        #ON ACTION CONTROLG
        #    CALL cl_cmdask()
        #TQC-C30136--mark--end--
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
  
        AFTER INPUT
  
          IF g_modify_flag='Y' AND
             g_sma.sma846='Y'   #產品結構有異動時是否自動執行偵錯檢查
             THEN
             LET g_status=0
             LET g_level=0
              LET g_success = 'Y'                 
             #CALL get_main_bom(g_bra.bra01,'c',1)   #No.FUN-B80100--mark--
             CALL get_mai_bom(g_bra.bra01,'c',1)     #No.FUN-B80100---修改get_main_bom為get_mai_bom---
              IF g_success = 'N'                
                THEN
                 CALL cl_err('','abm-002',1)       
             ELSE
                MESSAGE "Verify Ok!"
             END IF
          END IF
 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#    #     CONTINUE INPUT    #FUN-B20101  
#          CONTINUE  DIALOG  #FUN-B20101
# 
#      ON ACTION about      
#         CALL cl_about()     
# 
#      ON ACTION help        #MOD-4C0121
#         CALL cl_show_help()
#      ON ACTION controls                   
#         CALL cl_set_head_visible("","AUTO") 
 
    END INPUT
  #FUN-B20101--add--begin

    #FUN-D30033--add---begin---
     BEFORE DIALOG
        CASE g_flag_b
           WHEN '2' NEXT FIELD bra012
           WHEN '1' NEXT FIELD brb02
        END CASE
    #FUN-D30033--add---end---

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

     ON ACTION about
        CALL cl_about()

     ON ACTION help
        CALL cl_show_help()

     ON ACTION controlg
        CALL cl_cmdask()

     ON ACTION accept
        ACCEPT DIALOG

     ON ACTION cancel
       #FUN-D30033--add---begin---
       IF p_cmd ='a' THEN
          IF g_flag_b = '2' AND g_rec_b2 != 0 THEN
             LET g_action_choice = "detail"
             CALL g_bra1.deleteElement(l_ac2)
          END IF
          IF g_flag_b = '1' AND g_rec_b != 0 THEN
             LET g_action_choice = "detail"
             CALL g_brb.deleteElement(l_ac)
          END IF
       END IF
       #FUN-D30033--add---end---
        EXIT DIALOG
     END DIALOG
  #FUN-B20101--add--begin
#   CALL FGL_DIALOG_SETFIELDORDER(TRUE)  #恢復原來的狀態
   UPDATE bra_file SET bramodu = g_user,bradate = g_today
     WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06
     # AND bra011=g_bra.bra011 AND bra012=g_bra.bra012 
     # AND bra013=g_bra.bra013
       AND bra011=g_bra.bra011   #FUN-B20101 
    CLOSE i500_bc2              #FUN-B20101
    CLOSE i500_bcl
    COMMIT WORK
#FUN-B20101--modity
#   CALL i500_delall(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013)    #FUN-B20101
#   CALL i500_b_fill(g_wc2)    #FUN-B20101
    LET  g_wc = NULL             #FUN-B30033
    LET  g_wc2 = NULL             #FUN-B30033
    CALL i500_show()           #FUN-B20101
    IF l_flag = 'Y' THEN  LET l_flag = 'N' CONTINUE WHILE END IF
    EXIT WHILE
  END WHILE

    SELECT brb03  FROM brb_file WHERE brb01= g_bra.bra01 AND brb011= g_bra.bra011 AND brb29=g_bra.bra06
    IF SQLCA.SQLCODE = 100 THEN 
      #CALL i500_delall(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013) #FUN-B30033 jan 
       CALL i500_delall() #FUN-B30033 jan
    END IF

#FUN-B20101--modity
    CALL i500_bp_refresh()        # MOD-B30502  #FUN-B30033 jan
    CALL i500_list_cs(g_wc,g_wc2) #FUN-B30033 jan add
    CALL i500_list_fill()         # MOD-B30502  #FUN-B30033 jan
    #從Tree進來，且單身資料有異動時
    IF g_tree_b = "Y" AND g_tree_reload = "Y" THEN 
       CALL i500_tree_update() #Tree 資料有異動 
       LET g_tree_reload = "N"
    END IF

END FUNCTION


FUNCTION i500_delall()  #FUN-B30033 jan 
#DEFINE p_bra012  LIKE bra_file.bra012  #FUN-B30033 jan
#DEFINE p_bra013  LIKE bra_file.bra013  #FUN-B30033 jan
    #TQC-B40144--begin
    #SELECT COUNT(*) INTO g_cnt FROM brb_file
    #    WHERE brb01=g_bra.bra01
    #      AND brb29=g_bra.bra06 
    #      AND brb011=g_bra.bra011 
    #   #  AND brb012=g_bra.bra012
    #   #  AND brb013=g_bra.bra013
    #   #  AND brb012=p_bra012  #FUN-B20101  #FUN-B30033 jan mark
    #   #  AND brb013=p_bra013  #FUN-B20101  #FUN-B30033 jan mark
    
    SELECT COUNT(*) INTO g_cnt FROM bra_file
        WHERE bra01=g_bra.bra01
          AND bra06=g_bra.bra06 
          AND bra011=g_bra.bra011        
    #TQC-B40144--end   
    IF g_cnt = 0 THEN    # 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM bra_file WHERE bra01 = g_bra.bra01
                              AND bra06 = g_bra.bra06  
                              AND bra011= g_bra.bra011 
                            # AND bra012= g_bra.bra012
                            # AND bra013= g_bra.bra013
    END IF
END FUNCTION

 
FUNCTION i500_brb03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   
    l_ima110        LIKE ima_file.ima110,
    l_ima140        LIKE ima_file.ima140,
    l_ima1401       LIKE ima_file.ima1401,  
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima08,ima37,ima25,ima63,ima70,ima86,ima105,ima107,
           ima110,ima140,ima1401,imaacti 
        INTO g_brb[l_ac].ima02_b,g_brb[l_ac].ima021_b,
             g_ima08_b,g_ima37_b,g_ima25_b,g_ima63_b,
             g_ima70_b,g_ima86_b,g_brb27,g_ima107_b,l_ima110,l_ima140,l_ima1401,l_imaacti
        FROM ima_file
        WHERE ima01 = g_brb[l_ac].brb03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_brb[l_ac].ima02_b = NULL
                                   LET g_brb[l_ac].ima021_b = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima70_b IS NULL OR g_ima70_b = ' ' THEN
       LET g_ima70_b = 'N'
    END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
 
    IF l_ima140  ='Y' AND l_ima1401 <= g_vdate THEN 
       LET g_errno = 'aim-809'
       RETURN
    END IF
 
    IF g_brb27 IS NULL OR g_brb27 = ' ' THEN LET g_brb27 = 'N' END IF
    IF cl_null(l_ima110) THEN LET l_ima110='1' END IF
    IF p_cmd = 'a' THEN
       LET g_brb[l_ac].brb19 = l_ima110
#       DISPLAY g_brb[l_ac].brb19 TO s_brb[l_sl].brb19
       DISPLAY BY NAME g_brb[l_ac].brb19
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY g_brb[l_ac].ima02_b TO s_brb[l_sl].ima02_b
        DISPLAY g_brb[l_ac].ima021_b TO s_brb[l_sl].ima021_b
        LET g_brb[l_ac].ima08_b = g_ima08_b
        DISPLAY g_brb[l_ac].ima08_b TO s_brb[l_sl].ima08_b
    END IF
END FUNCTION
 
FUNCTION  i500_bdate(p_cmd)
  DEFINE   l_brb04_a,l_brb04_i LIKE brb_file.brb04,
           l_brb05_a,l_brb05_i LIKE brb_file.brb05,
           p_cmd     LIKE type_file.chr1,  
           l_n       LIKE type_file.num10  
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM brb_file
                             WHERE brb01 = g_bra.bra01         #主件
                               AND brb29 = g_bra.bra06       
                               AND brb011=g_bra.bra011
                              #AND brb012=g_bra.bra012
                              #AND brb013=g_bra.bra013
                               AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                               AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                               AND brb02 = g_brb[l_ac].brb02  #項次
                               AND brb04 = g_brb[l_ac].brb04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    IF p_cmd = 'u' THEN
       SELECT count(*) INTO l_n FROM brb_file
                      WHERE brb01 = g_bra.bra01         #主件
                        AND brb011=g_bra.bra011
                      # AND brb012=g_bra.bra012
                      # AND brb013=g_bra.bra013 
                        AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                        AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                        AND brb29 = g_bra.bra06       
                        AND brb02 = g_brb[l_ac].brb02   #項次
       IF l_n = 1 THEN RETURN END IF
    END IF
    SELECT MAX(brb04),MAX(brb05) INTO l_brb04_a,l_brb05_a
                       FROM brb_file
                      WHERE brb01 = g_bra.bra01         #主件
                        AND brb011=g_bra.bra011
                      # AND brb012=g_bra.bra012
                      # AND brb013=g_bra.bra013
                        AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                        AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                        AND brb29 = g_bra.bra06        
                        AND brb02 = g_brb[l_ac].brb02   #項次
                        AND brb04 < g_brb[l_ac].brb04   #生效日
    IF l_brb04_a IS NOT NULL AND l_brb05_a IS NOT NULL
    THEN IF (g_brb[l_ac].brb04 > l_brb04_a )
            AND (g_brb[l_ac].brb04 < l_brb05_a)
         THEN LET g_errno = 'mfg2737'
              RETURN
         END IF
    END IF
    IF g_brb[l_ac].brb04 <  l_brb04_a THEN
        LET g_errno = 'mfg2737'
    END IF
    IF l_brb04_a IS NULL AND l_brb05_a IS NULL THEN
       RETURN
    END IF
 
    SELECT MIN(brb04),MIN(brb05) INTO l_brb04_i,l_brb05_i
                       FROM brb_file
                      WHERE brb01 = g_bra.bra01         #主件
                        AND brb011=g_bra.bra011
                      # AND brb012=g_bra.bra012
                      # AND brb013=g_bra.bra013
                        AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                        AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                       AND  brb29 = g_bra.bra06       
                       AND  brb02 = g_brb[l_ac].brb02   #項次
                       AND  brb04 > g_brb[l_ac].brb04   #生效日
    IF l_brb04_i IS NULL AND l_brb05_i IS NULL THEN RETURN END IF
    IF l_brb04_a IS NULL AND l_brb05_a IS NULL THEN
       IF g_brb[l_ac].brb04 < l_brb04_i THEN
          LET g_errno = 'mfg2737'
       END IF
    END IF
    IF g_brb[l_ac].brb04 > l_brb04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION
 
FUNCTION  i500_edate(p_cmd)
  DEFINE   l_brb04_i   LIKE brb_file.brb04,
           l_brb04_a   LIKE brb_file.brb04,
           p_cmd       LIKE type_file.chr1,   
           l_n         LIKE type_file.num5  
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM brb_file
                      WHERE brb01 = g_bra.bra01         #主件
                        AND brb011=g_bra.bra011
                     #  AND brb012=g_bra.bra012
                     #  AND brb013=g_bra.bra013
                        AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                        AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                        AND brb29 = g_bra.bra06       
                        AND brb02 = g_brb[l_ac].brb02   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(brb04) INTO l_brb04_i
                       FROM brb_file
                      WHERE brb01 = g_bra.bra01         #主件
                        AND brb011=g_bra.bra011
                      # AND brb012=g_bra.bra012
                      # AND brb013=g_bra.bra013
                        AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                        AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                        AND brb29 = g_bra.bra06        
                       AND  brb02 = g_brb[l_ac].brb02   #項次
                       AND  brb04 > g_brb[l_ac].brb04   #生效日
   SELECT MAX(brb04) INTO l_brb04_a
                       FROM brb_file
                      WHERE brb01 = g_bra.bra01         #主件
                        AND brb011=g_bra.bra011
                      # AND brb012=g_bra.bra012
                      # AND brb013=g_bra.bra013
                        AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                        AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                       AND  brb29 = g_bra.bra06      
                       AND  brb02 = g_brb[l_ac].brb02   #項次
                       AND  brb04 > g_brb[l_ac].brb04   #生效日
   IF l_brb04_i IS NULL THEN RETURN END IF
   IF g_brb[l_ac].brb05 > l_brb04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION

FUNCTION  i500_brb10()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti
 
LET g_errno = ' '
 
     SELECT gfeacti INTO l_gfeacti FROM gfe_file
       WHERE gfe01 = g_brb[l_ac].brb10
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#=====>此FUNCTION 目的在update 上一筆的失效日
FUNCTION i500_update(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,    
         l_brb02   LIKE brb_file.brb02,
         l_brb03   LIKE brb_file.brb03,
         l_brb04   LIKE brb_file.brb04
 
    IF p_cmd ='u' THEN
       #--->更新BOM說明檔(bmc_file)的index key
       UPDATE bmc_file SET bmc02  = g_brb[l_ac].brb02,
                           bmc021 = g_brb[l_ac].brb03,
                           bmc03  = g_brb[l_ac].brb04
                       WHERE bmc01 = g_bra.bra01
                         AND bmc06 = g_bra.bra06         
                         AND bmc02 = g_brb_t.brb02
                         AND bmc021= g_brb_t.brb03
                         AND bmc03 = g_brb_t.brb04
    END IF
    DECLARE i500_update SCROLL CURSOR  FOR
            SELECT brb02,brb03,brb04 FROM brb_file
                   WHERE brb01 = g_bra.bra01
                     AND brb011=g_bra.bra011
                   # AND brb012=g_bra.bra012
                   # AND brb013=g_bra.bra013
                     AND brb012=g_bra1[l_ac2].bra012  #FUN-B20101
                        AND brb013=g_bra1[l_ac2].bra013  #FUN-B20101
                     AND brb29 = g_bra.bra06     
                     AND brb02 = g_brb[l_ac].brb02
                     AND (brb04 < g_brb[l_ac].brb04)
                   ORDER BY brb04
    OPEN i500_update
    FETCH LAST i500_update INTO l_brb02,l_brb03,l_brb04
    IF SQLCA.sqlcode = 0
       THEN UPDATE brb_file SET brb05 = g_brb[l_ac].brb04
                          WHERE brb01 = g_bra.bra01
                            AND brb011=g_bra.bra011
                         #  AND brb012=g_bra.bra012          #FUN-B20101
                         #  AND brb013=g_bra.bra013          #FUN-B20101
                            AND brb29 = g_bra.bra06        
                            AND brb02 = l_brb02
                            AND brb03 = l_brb03
                            AND brb04 = l_brb04
#           MESSAGE 'update 上一筆失效日 ok'
           CALL cl_err('','abm-810','0')  
    END IF
    CLOSE i500_update
END FUNCTION
 
#FUNCTION i500_loc(p_cmd)
#  DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(01),
#         l_qpa     LIKE brb_file.brb06,
#         l_tot     LIKE brb_file.brb06,
#         l_ins_bmt RECORD LIKE bmt_file.*,
#         l_n       LIKE type_file.num5,     #No.FUN-680096 SMALLINT,
#         l_modify  LIKE type_file.chr1      #No.FUN-680096 VARCHAR(01)
# 
# 
#    IF cl_null(g_brb[l_ac].brb02) OR
#       cl_null(g_brb[l_ac].brb03) OR
#       cl_null(g_brb[l_ac].brb04) THEN
#        RETURN
#    END IF
#    LET l_qpa = g_brb[l_ac].brb06 / g_brb[l_ac].brb07
#
#    LET l_qpa = g_brb[l_ac].brb06 / g_brb[l_ac].brb07
#    SELECT SUM(bmt07)
#      INTO l_tot
#      FROM bmt_file
#     WHERE bmt01 =g_bra.bra01
#       AND bmt08 =g_bra.bra06 #FUN-550014 add
#       AND bmt02 =g_brb[l_ac].brb02
#       AND bmt03 =g_brb[l_ac].brb03
#       AND bmt04 =g_brb[l_ac].brb04
#    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
#    SELECT COUNT(*) INTO g_cnt FROM bmt_file
#     WHERE bmt01 = g_bra.bra01
#       AND bmt08 = g_bra.bra06 #FUN-550014 add
#       AND bmt02 = g_brb[l_ac].brb02
#       AND bmt03 = g_brb[l_ac].brb03
#       AND bmt04 = g_brb[l_ac].brb04
#    IF p_cmd = 'u' THEN
#        IF g_cnt > 0  THEN
#            CALL i200(g_bra.bra01,g_brb[l_ac].brb02,
#                      g_brb[l_ac].brb03,g_brb[l_ac].brb04,'u',l_qpa,g_bra.bra06) #FUN-550014 add bra06
#        ELSE
#            CALL i200(g_bra.bra01,g_brb[l_ac].brb02,
#                      g_brb[l_ac].brb03,g_brb[l_ac].brb04,'a',l_qpa,g_bra.bra06) #FUN-550014 add bra06
#        END IF
#    END IF
# 
#    CALL i500_up_brb13(l_ac) RETURNING g_brb[l_ac].brb13
#    DISPLAY g_brb[l_ac].brb13 TO s_brb[l_ac].brb13 #FUN-550014 影響后續程式沒有跑ON ROW CHANGE,而沒有UPDATE brb13
#    UPDATE brb_file SET brb13 = g_brb[l_ac].brb13
#     WHERE brb01 = g_bra.bra01
#       AND brb29 = g_bra.bra06
#       AND brb02 = g_brb_t.brb02
#       AND brb03 = g_brb_t.brb03
#       AND brb04 = g_brb_t.brb04
#    IF SQLCA.sqlcode THEN
#       CALL cl_err3("upd","brb_file",g_bra.bra01,g_brb_t.brb02,SQLCA.sqlcode,"","",1)
#    END IF
#END FUNCTION
 
FUNCTION i500_b_askkey()
DEFINE
    l_wc2       LIKE type_file.chr1000   
 
    CLEAR ima02_b,ima021_b,ima08_b
    CONSTRUCT l_wc2 ON brb02,brb30,brb03,brb16,brb14,brb04,brb05,   # 螢幕上取單身條件
                       brb06,brb07,brb10,brb08,brb081,brb082,brb19,brb24,
                       brb13,brb31   
                       
         FROM s_brb[1].brb02,s_brb[1].brb30,s_brb[1].brb03,s_brb[1].brb16,
              s_brb[1].brb14,s_brb[1].brb04,s_brb[1].brb05,
              s_brb[1].brb06,s_brb[1].brb07,s_brb[1].brb10,s_brb[1].brb08,
              s_brb[1].brb081,s_brb[1].brb082,s_brb[1].brb19,s_brb[1].brb24,
              s_brb[1].brb13,s_brb[1].brb31
              
  
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 #  CALL i500_b_fill(l_wc2)   #FUN-B20101
    CALL   i500_b_fill(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013)     #FUN-B20101
    CALL i500_bp_refresh()
END FUNCTION
#FUN-B20101--add--begin
FUNCTION i500_b_fill_1(p_wc) 
DEFINE
   p_wc        LIKE type_file.chr1000
   IF cl_null(p_wc) THEN
      LET p_wc = " 1=1"
   END IF
  
   LET g_sql =
       "SELECT bra012,ecu014,bra013,ecb06,ecb17",
       " FROM bra_file,ecu_file,ecb_file",
       " WHERE bra01 = '",g_bra.bra01,"' ",
       "   AND bra011 = '",g_bra.bra011,"' ",
       "   AND ecu01=bra01 AND ecu02=bra011 AND ecu012=bra012 ",
       "   AND ecb01=bra01 AND ecb02=bra011 AND ecb012=bra012 AND ecb03=bra013 ",
       "   AND ",p_wc CLIPPED,
       " ORDER BY bra012,bra013"
   PREPARE i500_pb3 FROM g_sql
   DECLARE bra_curs CURSOR FOR i500_pb3
   CALL g_bra1.clear()
   LET g_rec_b2 = 0
    LET g_cnt2 = 1
   FOREACH bra_curs INTO g_bra1[g_cnt2].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt2 = g_cnt2 + 1
      IF g_cnt2 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF

    END FOREACH
   CALL g_bra1.deleteElement(g_cnt2)
    LET g_rec_b2= g_cnt2 - 1
    LET g_cnt2 = 0 
END FUNCTION
FUNCTION i500_bra_init()
  LET g_bra2.bra01 = g_bra.bra01
  LET g_bra2.bra011=g_bra.bra011
  LET g_bra2.bra012=g_bra1[l_ac2].bra012
  LET g_bra2.bra013=g_bra1[l_ac2].bra013
  LET g_bra2.bra014=g_bra.bra014
  LET g_bra2.bra02=''
  LET g_bra2.bra03=''
  LET g_bra2.bra04=g_bra.bra04
  LET g_bra2.bra05=g_bra.bra05
  LET g_bra2.bra06=g_bra.bra06
  LET g_bra2.bra07=''
  LET g_bra2.bra08=g_bra.bra08
  LET g_bra2.bra09=''
  LET g_bra2.bra10=g_bra.bra10
 #11/03/28 FUN-B30033 By jan modify----(s)
 #LET g_bra2.braacti='Y'
 #LET g_bra2.bradate=g_today
 #LET g_bra2.bragrup=g_grup
 #LET g_bra2.bramodu=g_user
 #LET g_bra2.braorig=g_grup
 #LET g_bra2.braoriu=g_user
 #LET g_bra2.brauser=g_user
  LET g_bra2.braacti=g_bra.braacti
  LET g_bra2.bradate=g_bra.bradate
  LET g_bra2.bragrup=g_bra.bragrup
  LET g_bra2.bramodu=g_bra.bramodu
  LET g_bra2.braorig=g_bra.braorig
  LET g_bra2.braoriu=g_bra.braoriu
  LET g_bra2.brauser=g_bra.brauser
 #11/03/28 FUN-B30033 By jan modify----(e)
   
END FUNCTION
#FUN-B20101--add--end 
#FUNCTION i500_b_fill(p_wc2)              #BODY FILL UP   #FUN-B20101
FUNCTION i500_b_fill(p_bra012,p_bra013)                   #FUN-B20101
DEFINE
    p_wc2      LIKE type_file.chr1000,    
    p_bra012   LIKE bra_file.bra012,                      #FUN-B20101
    p_bra013   LIKE bra_file.bra013                       #FUN-B20101
   #IF cl_null(g_wc2) THEN LET  g_wc2=' 1=1' END IF       #TQC-B60249
   #TQC-B60249 -----------------------Begin-----------------------
    IF NOT cl_null(g_vdate) THEN
       IF cl_null(g_wc2) OR (g_wc2=' 1=1') THEN
          LET g_wc2 = ' 1=1' 
          LET  g_wc2 = g_wc2  clipped,
                      " AND (brb04 <='", g_vdate,"'"," OR brb04 IS NULL )",
                      " AND (brb05 >  '",g_vdate,"'"," OR brb05 IS NULL )"
       END IF
    END IF
   #TQC-B60249 -----------------------End-------------------------
    LET g_sql =
        "SELECT brb02,brb30,brb03,ima02,ima021,ima08,brb09,brb16,brb14,brb04,brb05,brb06,brb07,",
        "       brb10,brb08,brb081,brb082,brb19,brb24,brb13,brb31  ", 
        " FROM brb_file,  ima_file",
        " WHERE brb01 ='",g_bra.bra01,"' ",
        "   AND brb29 ='",g_bra.bra06,"' ",
        "   AND brb011 ='",g_bra.bra011,"' ",
      # "   AND brb012 ='",g_bra.bra012,"' ",  #FUN-B20101
      # "   AND brb013 ='",g_bra.bra013,"' ",  #FUN-B20101
        "   AND brb012 ='",p_bra012,"' ",      #FUN-B20101
        "   AND brb013 ='",p_bra013,"' ",      #FUN-B20101
        "   AND brb_file.brb03 = ima_file.ima01 ",
        "   AND brb06 != 0 ",          #組成用量為零就不顯示了
        "   AND ",g_wc2 CLIPPED
    CASE g_sma.sma65
      WHEN '1'  LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
      WHEN '2'  LET g_sql = g_sql CLIPPED, " ORDER BY 2,1,3"
      WHEN '3'  LET g_sql = g_sql CLIPPED, " ORDER BY 6,1,3"
      OTHERWISE LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
    END CASE
 
    PREPARE i500_pb FROM g_sql
    DECLARE brb_curs                       #SCROLL CURSOR
        CURSOR FOR i500_pb
 
    CALL g_brb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH brb_curs INTO g_brb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      IF g_brb[g_cnt].brb30 = '3' THEN
         LET g_brb[g_cnt].ima02_b  = g_tipstr
         LET g_brb[g_cnt].ima021_b = g_tipstr
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_brb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i500_bp(p_ud)
   DEFINE   p_ud     LIKE type_file.chr1    
   DEFINE   l_count  LIKE type_file.num5    
   DEFINE   l_t      LIKE type_file.num10   
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer

 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   SELECT count(*)
      INTO l_count
      FROM brb_file
    WHERE brb01 = g_bra.bra01
      AND brb011=g_bra.bra011
  #FUN-B20101--modify
  #   AND brb012=g_bra.bra012
  #   AND brb013=g_bra.bra013    
  #FUN-B20101--modify
       AND brb30='3'
 
    IF l_count = 0 THEN
#       CALL cl_set_act_visible("preview_bom", FALSE)
       CALL cl_set_act_visible("edit_formula",FALSE)  
    ELSE
#       CALL cl_set_act_visible("preview_bom", TRUE)
       CALL cl_set_act_visible("edit_formula",FALSE)  
    END IF
    IF NOT s_industry('slk') THEN
        CALL cl_set_act_visible("fix",FALSE)
    END IF

      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)
    #FUN-B20101--add--begin
         DISPLAY ARRAY g_bra1 TO s_bra.*   
         BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_flag_b = '2'   #FUN-D30033 add

         BEFORE ROW
         LET l_ac2 = DIALOG.getCurrentRow("s_bra")
        IF l_ac2 <> 0 THEN
         # CALL i500_b_fill(g_wc2) #FUN-B20101
           CALL i500_b_fill(g_bra1[l_ac2].bra012,g_bra1[l_ac2].bra013)     #FUN-B20101 
           CALL i500_bp_refresh()                  #TQC-B80108
        END IF
      
      ON ACTION accept
         LET g_action_choice = "detail"
         EXIT DIALOG
   END DISPLAY
    #FUN-B20101--add--end      
         DISPLAY ARRAY g_brb TO s_brb.*
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               LET g_flag_b = '1'   #FUN-D30033 add

            BEFORE ROW
             # LET l_ac = ARR_CURR()  #FUN-B20101
               LET l_ac = DIALOG.getCurrentRow("s_brb")   #FUN-B20101
           #   CALL cl_show_fld_cont()

            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

            --&include "qry_string.4gl"
            ON ACTION accept
               LET g_action_choice="detail"
            #  LET l_ac = ARR_CURR()    #FUN-B20101
               LET l_ac = DIALOG.getCurrentRow("s_brb")   #FUN-B20101
               EXIT DIALOG
         END DISPLAY

          DISPLAY ARRAY g_bra_l TO s_bra_l.* 
             BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
            #  LET l_ac = ARR_CURR()   #FUN-B20101
             # LET l_ac =DIALOG.getCurrentRow("s_brb")   #FUN-B20101
               LET l_ac =g_curs_index     #TQC-B60234
               CALL fgl_set_arr_curr(l_ac) #TQC-B60234
               CALL cl_show_fld_cont()
               CALL i500_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,NULL) #FUN-B30033 jan add
               CONTINUE DIALOG 

            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

         END DISPLAY
         
         BEFORE DIALOG
            #判斷是否要focus到tree的正確row
            IF g_tree_focus_idx > 0 THEN
               CALL Dialog.nextField("tree.name")                   #利用NEXT FIELD達到focus另一個table
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)   # 指定tree要focus的row
            END IF
            
#         ON ACTION mat_qry
#            LET l_t = ARR_CURR()
#            IF l_t > 0 THEN  #No.MOD-8A0125 add 
#               CALL i500c(g_brb[l_t].brb03) #FUN-950065    #No:TQC-990023 取消mark   
#            END IF           #No.MOD-8A0125 add
            
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION first
            CALL i500_fetch('F',0)     
            CALL i500_tree_idxbykey()   
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
            END IF
         #   ACCEPT DIALOG
            ACCEPT DIALOG    #TQC-B60234
         #FUN-AC0076 add --------------begin---------------
         #ON ACTION 分量耗損
         ON ACTION haosun
            LET g_action_choice="haosun"
            EXIT DIALOG
         #FUN-AC0076 add ---------------end----------------
         
         ON ACTION previous
            CALL i500_fetch('P',0)     
            CALL i500_tree_idxbykey()   
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
            #    ACCEPT DIALOG
            ACCEPT DIALOG    #TQC-B60234

         ON ACTION jump
            CALL i500_fetch('/',0)     
            CALL i500_tree_idxbykey()  
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
             #   ACCEPT DIALOG
            ACCEPT DIALOG    #TQC-B60234

         ON ACTION next
            CALL i500_fetch('N',0)     
            CALL i500_tree_idxbykey()   
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
              #  ACCEPT DIALOG
            ACCEPT DIALOG    #TQC-B60234

         ON ACTION last
            CALL i500_fetch('L',0)     
            CALL i500_tree_idxbykey()   
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
           #   ACCEPT DIALOG
            ACCEPT DIALOG    #TQC-B60234

         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG

         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
            
         ON ACTION invalid
            LET g_action_choice="invalid"
            CALL i500_pic() 
            EXIT DIALOG
          #ON ACTION 審核 
         ON ACTION confirm
            LET g_action_choice = "confirm"
            EXIT DIALOG
         #ON ACTION 取消審核
         ON ACTION unconfirm
            LET g_action_choice = "unconfirm"
            EXIT DIALOG
         #@ON ACTION 發放
            ON ACTION bom_release        
            LET g_action_choice="bom_release"
            EXIT DIALOG
         #ON ACTION 取消發放
         ON ACTION unrelease
            LET g_action_choice = "unrelease"
            EXIT DIALOG
        #@ON ACTION 明細單身
         ON ACTION contents
            LET g_action_choice="contents"
            EXIT DIALOG
#TQC-B10069 ----------------------Begin--------------------
         ON ACTION carry
            LET g_action_choice = "carry"
            EXIT DIALOG
         ON ACTION qry_carry_history
            LET g_action_choice = "qry_carry_history"
            EXIT DIALOG
#TQC-B10069 ----------------------End----------------------
         ON action updbom
            LET g_action_choice="updbom"  
            EXIT dialog 
         ON ACTION list_pg
            LET g_bp_flag = 'list'
           EXIT DIALOG
         
         ON ACTION reproduce
            LET g_action_choice="reproduce"
            EXIT DIALOG
            
         ON ACTION output
             LET g_action_choice="output"
             EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         #相關文件
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG

         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
        ON ACTION preview_bom
           LET g_action_choice = 'preview_bom'
           LET g_bp_flag ='list' #TQC-B30173s
           EXIT DIALOG 
        ON ACTION edit_formula
           LET g_action_choice = 'edit_formula'
           EXIT DIALOG

         ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

#FUNCTION i500_bp(p_ud)
#   DEFINE   p_ud     LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
#   DEFINE   l_count  LIKE type_file.num5    #No.FUN-680096 SMALLINT  #No.FUN-610022
#   DEFINE   l_t      LIKE type_file.num10   #No.FUN-680096 INTEGER  #FUN-610095
#
#    ###FUN-9A50010 START ###
#   DEFINE l_wc               STRING
#   DEFINE l_tree_arr_curr    LIKE type_file.num5
#   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
#   DEFINE l_i                LIKE type_file.num5
#   DEFINE l_tok              base.StringTokenizer
#   ###FUN-9A50010 END ###
# 
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN
#      RETURN
#   END IF
#   LET g_action_choice = " "
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   SELECT count(*)
#      INTO l_count
#      FROM brb_file
#    WHERE brb01 = g_bra.bra01
#       AND brb30='3'
# 
#    IF l_count = 0 THEN
##       CALL cl_set_act_visible("preview_bom", FALSE)
#       CALL cl_set_act_visible("edit_formula",FALSE)  
#    ELSE
##       CALL cl_set_act_visible("preview_bom", TRUE)
#       CALL cl_set_act_visible("edit_formula",FALSE)  
#    END IF
#   DISPLAY ARRAY g_brb TO s_brb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#   BEFORE DISPLAY
#      CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#    BEFORE ROW
#       LET l_ac = ARR_CURR()
#       LET l_sl = SCR_LINE()                   #NO.FUN-810014
#
#    ON ACTION mat_qry
#       LET l_t = ARR_CURR()
#       IF l_t > 0 THEN  
#          CALL i500c(g_brb[l_t].brb03) #FUN-950065    #No:TQC-990023 modify 
#       END IF          
#       CONTINUE DISPLAY
#
#
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#
#      ON ACTION first
#         CALL i500_fetch('F',0)
#         CALL cl_navigator_setting(g_curs_index, g_row_count)  
#           IF g_rec_b != 0 THEN
#              CALL fgl_set_arr_curr(1) 
#           END IF
#           ACCEPT DISPLAY                 
#
#      ON ACTION previous
#         CALL i500_fetch('P',0)
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   
#           IF g_rec_b != 0 THEN
#              CALL fgl_set_arr_curr(1) 
#           END IF
#           ACCEPT DISPLAY           
#
#      ON ACTION jump
#         CALL i500_fetch('/',0)
#         CALL cl_navigator_setting(g_curs_index, g_row_count)  
#           IF g_rec_b != 0 THEN
#              CALL fgl_set_arr_curr(1)
#           END IF
#         ACCEPT DISPLAY                 
#
#      ON ACTION next
#         CALL i500_fetch('N',0)
#         CALL cl_navigator_setting(g_curs_index, g_row_count)  
#           IF g_rec_b != 0 THEN
#              CALL fgl_set_arr_curr(1)  
#           END IF
#           ACCEPT DISPLAY              
#           
#      ON ACTION last
#         CALL i500_fetch('L',0)
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#              CALL fgl_set_arr_curr(1)  
#           END IF
#          ACCEPT DISPLAY                  
#
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         CALL i500_pic() #MOD-840435
#         EXIT DISPLAY
#     #ON ACTION 糵 
#      ON ACTION confirm
#         LET g_action_choice = "confirm"
#         EXIT DISPLAY
#     #ON ACTION 糵
#      ON ACTION unconfirm
#         LET g_action_choice = "unconfirm"
#         EXIT DISPLAY
#    #@ON ACTION 祇
#      ON ACTION bom_release         
#         LET g_action_choice="bom_release"
#         EXIT DISPLAY
#     #ON ACTION 祇
#      ON ACTION unrelease
#         LET g_action_choice = "unrelease"
#         EXIT DISPLAY
#
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
#
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
#
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   
#         CALL i500_pic() 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#
#    #@ON ACTION 灿虫ō
#      ON ACTION contents
#         LET g_action_choice="contents"
#         EXIT DISPLAY
#
#      ON ACTION list_pg
#         LET g_bp_flag = 'list'
#         EXIT DISPLAY
#    #No.FUN-7C0010  --End
#
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET INT_FLAG=FALSE   
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#
#      ON ACTION about          #TQC-860021
#         CALL cl_about()       #TQC-860021
#
#      ON ACTION related_document
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
# 
#      ON ACTION exporttoexcel 
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      ON ACTION edit_formula
#         LET g_action_choice = 'edit_formula'
#         EXIT DISPLAY
#
#      ON ACTION controls                       #No.FUN-6B0033    
#         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
#
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#
#      #No.FUN-7C0050 add
#      &include "qry_string.4gl"
#
#   END DISPLAY
#      CALL cl_set_act_visible("accept,cancel", TRUE)
#      ###FUN-9A50010 END ###
# 
#END FUNCTION
 
FUNCTION i500_bp1(p_ud)
   DEFINE   p_ud     LIKE type_file.chr1   
   DEFINE   l_count  LIKE type_file.num5    
   DEFINE   l_t      LIKE type_file.num10   
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   DEFINE l_act_accept       LIKE type_file.chr1  #TQC-C30136 add
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   #判斷是否需要隱藏Ring Menu中的“BOM預覽”和“編輯自定義公式”兩個按鈕
   #被迫做這一切，只因為上面加的那個cl_load_act_list 
   SELECT count(*)
     INTO l_count
     FROM brb_file
    WHERE brb01 = g_bra.bra01
      AND brb011=g_bra.bra011
   #FUN-B20101--modify
   #  AND brb012=g_bra.bra012  #FUN-B20101
   #  AND brb013=g_bra.bra013  #FUN-B20101
   #FUN-B20101--modify
      AND brb30='3'
 
   IF l_count = 0 THEN
#      CALL cl_set_act_visible("preview_bom", FALSE)
      CALL cl_set_act_visible("edit_formula",FALSE) 
   ELSE
#      CALL cl_set_act_visible("preview_bom", TRUE)
      CALL cl_set_act_visible("edit_formula",FALSE) 
   END IF
    CALL cl_set_act_visible("accept,cancel", FALSE)
      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               LET l_act_accept = TRUE #TQC-C30136 add
               #重算g_curs_index，按上下筆按鈕才會正確
               #因為double click tree node後,focus tree的節點會改變
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
               END IF
               
             #  以最上層的id當作單頭的g_curs_index
               IF g_tree_focus_idx > 0  THEN
               CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
               LET g_curs_index = l_curs_index
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               END IF

            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row 

            #TQC-C30136--mark--str--
            ##double click tree node
            #ON ACTION accept
            #   LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
            #   #有子節點就focus在此，沒有子節點就focus在它的父節點
            #   IF g_tree[l_tree_arr_curr].has_children THEN
            #      LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
            #   ELSE
            #      CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
            #      IF l_i > 1 THEN
            #         CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
            #      END IF
            #      CALL i500_tree_idxbypath()   #依tree path指定focus節點
            #   END IF
            #   LET g_tree_b = "Y"             #tree是否進入單身 Y/N
            #    CALL i500_show_pic(l_tree_arr_curr)
            #TQC-C30136--mark--end--
         END DISPLAY

   DISPLAY ARRAY g_bra_l TO s_bra_l.* ATTRIBUTE(COUNT=g_rec_b1)
            BEFORE DISPLAY
               LET l_act_accept = FALSE #TQC-C30136 add
               CALL cl_navigator_setting( g_curs_index, g_row_count )
            BEFORE ROW
             # LET l_ac = ARR_CURR()  #FUN-B20101
              #LET l_ac =DIALOG.getCurrentRow("s_brb")    #FUN-B30033 jan mark
              #LET l_ac =DIALOG.getCurrentRow("s_bra_l")  #FUN-B30033 jan add 
               LET l_ac =g_curs_index     #TQC-B60234
               CALL fgl_set_arr_curr(l_ac) #TQC-B60234
               CALL cl_show_fld_cont()
               CALL i500_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,NULL) #FUN-B30033 jan add
               CONTINUE DIALOG 

            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG
    END DISPLAY
   
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
 
      ON ACTION first
         CALL i500_fetch('F',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN 
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         EXIT DIALOG
 
      ON ACTION previous
         CALL i500_fetch('P',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN 
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	       EXIT DIALOG
 
      ON ACTION jump
         CALL i500_fetch('/',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN 
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	       EXIT DIALOG
 
      ON ACTION next
         CALL i500_fetch('N',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	       EXIT DIALOG
 
      ON ACTION last
         CALL i500_fetch('L',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	       EXIT DIALOG
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         CALL cl_set_field_pic(g_confirm,"","","","",g_bra.braacti)   
         EXIT DIALOG
         
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DIALOG
 
      ON ACTION unconfirm
         LET g_action_choice = "unconfirm"
         EXIT DIALOG
      
      #FUN-AC0076 add --------------begin---------------
      #ON ACTION 分量耗損
      ON ACTION haosun
         LET g_action_choice="haosun"
         EXIT DIALOG
      #FUN-AC0076 add ---------------end----------------s
      
      ON ACTION unrelease
         LET g_action_choice = "unrelease"
         EXIT DIALOG
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
         CALL i500_pic() 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION bom_release       
         LET g_action_choice="bom_release"
         EXIT DIALOG
         
      ON action updbom
         LET g_action_choice="updbom"  
         EXIT dialog     
              
      #@ON ACTION 明細單身
       ON ACTION contents
          LET g_action_choice="contents"
          EXIT DIALOG   
#TQC-B10069 ----------------------Begin--------------------
      ON ACTION carry
         LET g_action_choice = "carry"
         EXIT DIALOG
      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DIALOG
#TQC-B10069 ----------------------End----------------------

      ON ACTION main
         --LET g_bp_flag = 'main'
         LET g_bp_flag = 'main' #TQC-B60234
         --LET l_ac1 = ARR_CURR()
         --LET g_jump = l_ac1
         --LET mi_no_ask = TRUE
         --IF g_rec_b1 >0 THEN
         --CALL i500_fetch('/',0)
         --END IF
         CALL i500_bp("G")
         --CALL cl_set_comp_visible("page5", FALSE)
         --CALL cl_set_comp_visible("info", FALSE)
         --CALL ui.interface.refresh()
         --CALL cl_set_comp_visible("page5", TRUE)
         --CALL cl_set_comp_visible("info", TRUE)
         EXIT DIALOG
 
      ON ACTION accept
         #TQC-C30136--add--str--
            IF NOT cl_null(l_act_accept) AND l_act_accept THEN
            #double click tree node
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree[l_tree_arr_curr].has_children THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
                  END IF
                  CALL i500_tree_idxbypath()   #依tree path指定focus節點
               END IF
               LET g_tree_b = "Y"             #tree是否進入單身 Y/N
                CALL i500_show_pic(l_tree_arr_curr)
            ELSE
         #TQC-C30136-add--end--
               --LET l_ac = ARR_CURR()
               --CALL cl_show_fld_cont()
               --CALL i500_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,NULL)  #jan add
               --CONTINUE DIALOG 
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET mi_no_ask = TRUE
               LET g_bp_flag = NULL
               CALL i500_fetch('/',0)
               CALL cl_set_comp_visible("info", FALSE)
               CALL cl_set_comp_visible("info", TRUE)
               CALL cl_set_comp_visible("page5", FALSE)   
               CALL ui.interface.refresh()             
               CALL cl_set_comp_visible("page5", TRUE)
               CONTINUE DIALOG   
               --EXIT DIALOG
            END IF  #TQC-C30136 add
 
      ON ACTION cancel
         LET INT_FLAG=FALSE   
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
  
      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO") 
  
      &include "qry_string.4gl"
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i500c(p_brb03)                                   
   DEFINE  p_brb03   LIKE brb_file.brb03
   IF p_brb03 IS NULL THEN RETURN END IF
   LET g_cmd = "abmq500 ","'",p_brb03 CLIPPED,"'"  # 物料編號
   CALL cl_cmdrun(g_cmd)
 
END FUNCTION
 
FUNCTION i500_copy()
   DEFINE new_bra06,old_bra06 LIKE bra_file.bra06 
   DEFINE new_no,old_no LIKE bra_file.bra01,
          old_bra011,new_bra011 LIKE bra_file.bra011,
          old_bra012,new_bra012 LIKE bra_file.bra012,
          old_bra013,new_bra013 LIKE bra_file.bra013,
          new_bra014            LIKE bra_file.bra014,
         l_brb  RECORD LIKE brb_file.*,
         ef_date       LIKE type_file.dat,      
         ans_1         LIKE type_file.chr1,   
         ans_2         LIKE type_file.dat,
         l_dir         LIKE type_file.chr1,     
         l_sql         STRING                   
   DEFINE l_n          LIKE type_file.num5  
   DEFINE l_n1         LIKE type_file.num5    
   DEFINE l_n2         LIKE type_file.num5
   DEFINE l_n3         LIKE type_file.num5
   DEFINE l_n4         LIKE type_file.num5    #MOD-B30505
   DEFINE l_icm  RECORD LIKE icm_file.*        
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE old_ecu03    LIKE ecu_file.ecu03
   DEFINE old_ecu014   LIKE ecu_file.ecu014
   DEFINE new_ecu03    LIKE ecu_file.ecu03
   DEFINE new_ecu014   LIKE ecu_file.ecu014   
   DEFINE l_ecb06      LIKE ecb_file.ecb06 
   DEFINE l_a          LIKE type_file.num5 
   
   IF s_shut(0) THEN RETURN END IF
 
   LET p_row = 10 LET p_col = 24
   OPEN WINDOW i500_c_w AT p_row,p_col WITH FORM "abm/42f/abmi500_c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("abmi500_c")
 
    CALL cl_set_comp_visible("old_bra06,new_bra06",g_sma.sma118='Y')
 
 
   LET old_no   = g_bra.bra01 LET new_no = NULL
   LET old_bra06= g_bra.bra06 
   LET old_bra011=g_bra.bra011
#  LET old_bra012=g_bra.bra012  #FUN-B20101
#  LET old_bra013=g_bra.bra013  #FUN-B20101
   IF cl_null(old_bra06) THEN LET old_bra06 = ' ' END IF   
   LET new_bra06 = ' '
   LET ans_1  = '1'        
   LET ef_date= NULL
   SELECT DISTINCT ecu03 INTO old_ecu03 FROM ecu_file WHERE ecu01=old_no AND ecu02=old_bra011
   DISPLAY old_ecu03 TO old_ecu03
   SELECT ecu014 INTO old_ecu014 FROM ecu_file WHERE ecu01=old_no AND ecu02=old_bra011
     AND ecu012=old_bra012
     DISPLAY old_ecu014 TO old_ecu014   
#   LET new_bra014='N' 
   CALL cl_set_head_visible("","YES")            
#  DISPLAY BY NAME old_no,old_bra011,old_bra012,old_bra013,old_bra06   #MOD-B30505
   DISPLAY BY NAME old_no,old_bra011,old_bra06                         #MOD-B30505
#   DISPLAY old_no,old_bra011 TO old_no,old_bra011
#  INPUT BY NAME new_no,new_bra011,new_bra012,new_bra013,ans_2,
   INPUT BY NAME new_no,new_bra011,ans_2,                   #MOD-B30505
                 new_bra06,ans_1,ef_date 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i500_set_entry()
         CALL i500_set_no_entry()
         CALL i500_set_required(ans_1)
         CALL i500_set_no_required(ans_1)
         LET g_before_input_done = TRUE
        
         
#      AFTER FIELD old_no
#        IF g_sma.sma118 != 'Y' THEN 
#            IF NOT cl_null(new_no) THEN
#               CALL s_field_chk(new_no,'2',g_plant,'bra01') RETURNING g_flag2
#               IF g_flag2 = '0' THEN
#                  CALL cl_err(new_no,'aoo-043',1)
#                  NEXT FIELD new_no
#               END IF
#            END IF
#            IF NOT cl_null(old_no) THEN
#                SELECT count(*) INTO g_cnt FROM bra_file WHERE bra01 = old_no
#                                                           AND bra06 = old_bra06 
#                IF g_cnt=0 THEN CALL cl_err('bra_file',100,0) NEXT FIELD old_no END IF
#            END IF
#        END IF
#      AFTER FIELD old_bra06
#        IF cl_null(old_bra06) THEN
#            LET old_bra06 = ' '
#        END IF
#        IF NOT cl_null(old_no) THEN
#            SELECT count(*) INTO g_cnt FROM bra_file WHERE bra01 = old_no
#                                                       AND bra06 = old_bra06 
#            IF g_cnt=0 THEN CALL cl_err('bra_file',100,0) NEXT FIELD old_no END IF
#        END IF
      AFTER FIELD new_no
        IF g_sma.sma118 != 'Y' THEN #FUN-550014 add if 判斷
            IF NOT cl_null(new_no) THEN
                SELECT count(*) INTO g_cnt FROM bra_file WHERE bra01 = new_no
                                                           AND bra06 = new_bra06 
                                                           AND bra011= new_bra011
                                                       #   AND bra012= new_bra012
                                                       #   AND bra013= new_bra013
                IF g_cnt>0 THEN CALL cl_err('bra_file','abm-212',0) NEXT FIELD new_no END IF
                SELECT count(*) INTO g_cnt FROM ima_file WHERE ima01 = new_no
                IF g_cnt=0 THEN CALL cl_err('ima_file',100,0) NEXT FIELD new_no END IF
                LET g_errno = ''
                CALL i500_new_no(new_no) 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(new_no,g_errno,0)
                   NEXT FIELD new_no
                END IF
            END IF
        END IF
      AFTER FIELD new_bra06
        IF cl_null(new_bra06) THEN
            LET new_bra06 = ' '
        END IF
        IF new_bra06 IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM bra_file WHERE bra01 = new_no
                                                       AND bra06 = new_bra06 
                                                       AND bra011= new_bra011
                                                     # AND bra012= new_bra012
                                                     # AND bra013= new_bra013
            IF g_cnt>0 THEN CALL cl_err('bra_file','abm-212',0) NEXT FIELD new_bra06 END IF
        END IF

      AFTER FIELD new_bra011
        #IF cl_null(new_bra011) THEN
        #    NEXT FIELD new_bra011
        #END IF
        IF NOT cl_null(new_bra011) THEN
            SELECT count(*) INTO g_cnt FROM bra_file WHERE bra01 = new_no
                                                       AND bra06 = new_bra06 
                                                       AND bra011= new_bra011
                                                     # AND bra012= new_bra012
                                                     # AND bra013= new_bra013
            IF g_cnt>0 THEN CALL cl_err('bra_file','abm-212',0) NEXT FIELD new_bra011 END IF
            SELECT COUNT(*) INTO l_n FROM ecu_file WHERE ecu01=new_no AND ecu02=new_bra011 AND ecuacti='Y' AND ecu10='Y' 
            IF l_n=0 THEN   
               CALL cl_err('','mfg4030',1)
               NEXT FIELD new_bra011
            END IF 
            SELECT DISTINCT ecu03 INTO new_ecu03 FROM ecu_file WHERE ecu01=new_no AND ecu02=new_bra011
            DISPLAY new_ecu03 TO new_ecu03 
#        ELSE 
#        	 SELECT COUNT(*) INTO l_n3 FROM bra_file WHERE bra01=new_no AND bra011=new_bra011 AND bra014='Y'
#        	 IF l_n3='Y' THEN 
#        	    LET new_bra014='Y'
#        	    DISPLAY BY NAME new_bra014
#           END IF 
        END IF
#MOD-B30505--mark--begin
#
#      AFTER FIELD new_bra012
#        IF new_bra012 IS NOT NULL THEN
#        #IF NOT cl_null(new_bra011) THEN
#           IF NOT cl_null(new_bra011) AND NOT cl_null(new_no) THEN
#            SELECT count(*) INTO g_cnt FROM bra_file WHERE bra01 = new_no
#                                                       AND bra06 = new_bra06 
#                                                       AND bra011= new_bra011
#                                                       AND bra012= new_bra012
#                                                       AND bra013= new_bra013
#            IF g_cnt>0 THEN CALL cl_err('bra_file','abm-212',0) NEXT FIELD new_bra012 END IF
#            SELECT COUNT(*) INTO l_n1 FROM ecu_file 
#             WHERE ecu01=new_no AND ecu02=new_bra011
#               AND ecu012=new_bra012 AND ecu10='Y' AND ecuacti='Y'
#            IF l_n1=0 THEN   
#               CALL cl_err('','abm-214',1)
#               NEXT FIELD new_bra012
#            END IF 
#            SELECT ecu014 INTO new_ecu014 FROM ecu_file WHERE ecu01=new_no AND ecu02=new_bra011
#              AND ecu012=new_bra012
#            DISPLAY new_ecu014 TO new_ecu014    
#           END IF            
#        END IF
#        IF cl_null(new_bra012) THEN
#            LET new_bra012 = ' '
#        END IF
#        
#      AFTER FIELD new_bra013
#        #IF cl_null(new_bra013) THEN
#        #    NEXT FIELD new_bra013
#        #END IF
#        IF NOT cl_null(new_bra013) THEN
#            SELECT count(*) INTO g_cnt FROM bra_file WHERE bra01 = new_no
#                                                       AND bra06 = new_bra06 
#                                                       AND bra011= new_bra011
#                                                       AND bra012= new_bra012
#                                                       AND bra013= new_bra013
#            IF g_cnt>0 THEN CALL cl_err('bra_file','abm-212',0) NEXT FIELD new_bra013 END IF
#             SELECT COUNT(*) INTO l_n2  FROM ecb_file 
#              WHERE ecb01=new_no AND ecb02=new_bra011
#                AND ecb012=new_bra012 AND ecb03=new_bra013 AND ecbacti='Y'
#            IF l_n2=0 THEN   
#               CALL cl_err('','abm-215',1)
#               NEXT FIELD new_bra013
#            END IF 
#        END IF
#MOD-B30505--mark--begin                               
      ON CHANGE ans_1
        IF ans_1 != '3' THEN
            CALL i500_set_no_entry()
            CALL i500_set_no_required(ans_1)
            LET ef_date = NULL
        ELSE
            CALL i500_set_entry()
            CALL i500_set_required(ans_1)
        END IF
      AFTER FIELD ans_1
        IF NOT cl_null(ans_1) THEN
            IF ans_1 NOT MATCHES "[123]" THEN NEXT FIELD ans_1 END IF
        END IF
# 
#      AFTER FIELD ans_3
#        IF NOT cl_null(ans_3) THEN
#            IF ans_3 NOT MATCHES "[YN]" THEN NEXT FIELD ans_3 END IF
#        END IF
# 
#      AFTER FIELD ans_31
#        IF NOT cl_null(ans_31) THEN
#            IF ans_31 NOT MATCHES "[YN]" THEN NEXT FIELD ans_31 END IF
#        END IF
# 
#      AFTER FIELD ans_4
#        IF NOT cl_null(ans_4) THEN
#            IF ans_4 NOT MATCHES "[YN]" THEN NEXT FIELD ans_4 END IF
#        END IF
# 
#      AFTER FIELD ans_5
#        IF NOT cl_null(ans_5) THEN
#            IF ans_5 NOT MATCHES "[YN]" THEN NEXT FIELD ans_5 END IF
#        END IF
      AFTER FIELD ef_date
        IF cl_null(ef_date) THEN
            NEXT FIELD ef_date
        END IF
      #No.TQC-A80112--begin
      AFTER INPUT 
        IF INT_FLAG THEN 
           LET new_no=NULL 
           LET new_bra011=NULL 
#          LET new_bra012=NULL       #MOD-B30505
#          LET new_bra013=NULL       #MOD-B30505
           LET ans_2=NULL
           LET new_bra06=NULL
           LET ans_1=NULL
           LET ef_date=NULL           
          EXIT INPUT   
        END IF      
        SELECT COUNT(*) INTO l_a FROM bra_file 
#        WHERE bra01=new_no AND bra011=new_bra011 AND bra012=new_bra012 
#          AND bra013=new_bra013
         WHERE bra01=new_no AND bra011=new_bra011        #MOD-B30505 
        IF l_a>0 THEN 
           CALL cl_err('','abm-230',1)
           NEXT FIELD new_bra013
        END IF 
        
      #No.TQC-A80112--end
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(new_no)
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form = "q_ima"
            #   CALL cl_create_qry() RETURNING new_no
               CALL q_sel_ima(FALSE, "q_ima", "", "", "", "", "", "" ,"",'' )  RETURNING new_no 
#FUN-AA0059 --End--
               DISPLAY new_no
               NEXT FIELD new_no
            WHEN INFIELD(new_bra011) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecu02_1"
                 LET g_qryparam.arg1 = new_no
                 LET g_qryparam.default1=new_bra011
                 LET g_qryparam.default2=new_bra012
                 CALL cl_create_qry() RETURNING new_bra011,new_bra012
                 DISPLAY BY NAME new_bra011,new_bra012
                 SELECT ecu03,ecu014 INTO new_ecu03,new_ecu014 FROM ecu_file 
                  WHERE ecu01=new_no AND ecu02=new_bra011
                    AND ecu012=new_bra012        
                 DISPLAY new_ecu03,new_ecu014 TO new_ecu03,new_ecu014         
                 NEXT FIELD new_bra011
#MOD-B30505--mark--begin
#            WHEN INFIELD(new_bra012) 
#                 CALL cl_init_qry_var()
#                 #LET g_qryparam.form = "q_ecu012_1"
#                 #LET g_qryparam.arg1 = new_no
#                 #LET g_qryparam.arg2 = new_bra011
#                 LET g_qryparam.form = "q_ecu02_1"
#                 LET g_qryparam.arg1 = new_no
#                 LET g_qryparam.default1=new_bra011
#                 LET g_qryparam.default2=new_bra012
#                 CALL cl_create_qry() RETURNING new_bra011,new_bra012
#                 DISPLAY BY NAME new_bra011,new_bra012
#                 SELECT ecu03,ecu014 INTO new_ecu03,new_ecu014 FROM ecu_file 
#                  WHERE ecu01=new_no AND ecu02=new_bra011
#                    AND ecu012=new_bra012        
#                 DISPLAY new_ecu03,new_ecu014 TO new_ecu03,new_ecu014                   
#                 NEXT FIELD new_bra012
#            WHEN INFIELD(new_bra013) 
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ecb03_1"
#                 LET g_qryparam.arg1 = new_no
#                 LET g_qryparam.arg2 = new_bra011
#                 LET g_qryparam.arg3 = new_bra012
#                 CALL cl_create_qry() RETURNING new_bra013
#                 DISPLAY BY NAME new_bra013
#                 NEXT FIELD new_bra013         
#MOD-B30505--mark-end                
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()  
 
      ON ACTION help         
         CALL cl_show_help()  
   END INPUT
   CLOSE WINDOW i500_c_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   MESSAGE ' COPY.... '
IF NOT cl_sure(0,0) THEN RETURN END IF 

 #MOD-A30131 add---start---
 #將Temptable資料的準備移到BEGIN WORK前,
 #以免DROP TABLE與INTO TEMP的語法破壞TRANSACTION的完整性,造成ROLLBACK失敗

#   #說明資料是否復制ans_3
#   IF ans_3 = 'Y' THEN
#      DROP TABLE w
#      LET l_sql = " SELECT bmc_file.* FROM bmc_file,brb_file ",
#                  " WHERE brb01 = bmc01 ",
#                  " AND   brb29 = bmc06 ",  #FUN-550014 add
#                  " AND brb02 = bmc02   ",
#                  " AND brb03 = bmc021  ",
#                  " AND brb04 = bmc03   ",
#                  " AND brb01=  '",old_no,"'",
#                  " AND brb29=  '",old_bra06,"'" #FUN-550014 add
#      IF ans_2 IS NOT NULL THEN
#         LET l_sql=l_sql CLIPPED,
#                  " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
#                  " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
#      END IF
#
#      LET l_sql = l_sql clipped," INTO TEMP w "
#      PREPARE i500_pbmc FROM l_sql
#      EXECUTE i500_pbmc
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("sel","bmc_file,brb_file",old_no,old_bra06,SQLCA.sqlcode,"","i500_pbmc",1)  #No.TQC-660046
#         LET g_success = 'N'
#         ROLLBACK WORK
#         RETURN
#      END IF
#   END IF
# 
#   #插件位置是否復制ans_31
#   IF ans_31 = 'Y' THEN
#      DROP TABLE w2
#      LET l_sql = " SELECT bmt_file.* FROM bmt_file,brb_file ",
#                  " WHERE brb01 = bmt01 ",    #主件
#                  " AND brb29 = bmt08   ",    #FUN-550014 add
#                  " AND brb02 = bmt02   ",    #項次
#                  " AND brb03 = bmt03   ",    #元件
#                  " AND brb04 = bmt04   ",    #生效日
#                  " AND brb01=  '",old_no,"'",
#                  " AND brb29=  '",old_bra06,"'" #FUN-550014 add
#      IF ans_2 IS NOT NULL THEN
#         LET l_sql=l_sql CLIPPED,
#                  " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
#                  " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
#      END IF
#      LET l_sql = l_sql clipped," INTO TEMP w2 "
#      PREPARE i500_pbmt FROM l_sql
#      EXECUTE i500_pbmt
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("sel","bmt_file,brb_file",old_no,old_bra06,SQLCA.sqlcode,"","i500_pbmt",1)  #No.TQC-660046
#         LET g_success = 'N'
#         ROLLBACK WORK
#         RETURN
#      END IF
#   END IF
#
#   #元件廠牌資料是否復制ans_4
#   IF ans_4 = 'Y' THEN
#      DROP TABLE z
#      LET l_sql = " SELECT UNIQUE bml_file.* FROM bml_file,brb_file ",
#                  " WHERE brb01 = bml02 ",
#                  "   AND brb03 = bml01 ",
#                  "   AND brb01= '",old_no,"'"
#      IF ans_2 IS NOT NULL THEN
#         LET l_sql=l_sql CLIPPED,
#                  " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
#                  " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
#      END IF
#
#      LET l_sql = l_sql clipped," INTO TEMP z "
#      PREPARE i500_pbml FROM l_sql
#      EXECUTE i500_pbml
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("sel","bml_file,brb_file",old_no,"",SQLCA.sqlcode,"","i500_pbmt",1)  #No.TQC-660046
#         LET g_success = 'N'
#         ROLLBACK WORK
#         RETURN
#      END IF
#   END IF

#   #取替代件是否復制ans_5
#   IF ans_5 = 'Y' THEN
#      DROP TABLE d
#      LET l_sql = " SELECT bmd_file.* FROM bmd_file,brb_file ",
#                  " WHERE brb01 = bmd08 ",
#                  "   AND brb03 = bmd01 ",
#                  "   AND brb01= '",old_no,"'",
#                  "   AND brb29= '",old_bra06,"'",        #No:MOD-980049 add
#                  "   AND bmdacti = 'Y'"                                           #CHI-910021
#      IF ans_2 IS NOT NULL THEN
#         LET l_sql=l_sql CLIPPED,
#                  " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
#                  " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
#      END IF
#      LET l_sql = l_sql clipped," INTO TEMP d "
#      PREPARE i500_pbmd FROM l_sql
#      EXECUTE i500_pbmd
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('i500_pbmd',SQLCA.sqlcode,0)
#         ROLLBACK WORK #MOD-650016 add
#         RETURN
#      END IF
#   END IF
#
#   DROP TABLE y
#   SELECT * FROM bra_file
#    WHERE bra01=old_no
#      AND bra06=old_bra06 #FUN-550014 add
#     INTO TEMP y
#   #MOD-A30131 ---end---
#
#   BEGIN WORK
#   LET g_success='Y'
#   IF cl_null(old_bra06) THEN LET old_bra06 = ' ' END IF #FUN-550014 add
#   IF cl_null(new_bra06) THEN LET new_bra06 = ' ' END IF #FUN-550014 add
# 
##-------------------- COPY BODY (bmc_file) ------------------------------
#   #說明資料是否復制ans_3
#   IF ans_3 = 'Y' THEN
#     #MOD-A30131 mark---start---
#     # DROP TABLE w
#     # LET l_sql = " SELECT bmc_file.* FROM bmc_file,brb_file ",
#     #             " WHERE brb01 = bmc01 ",
#     #             " AND   brb29 = bmc06 ",  #FUN-550014 add
#     #             " AND brb02 = bmc02   ",
#     #             " AND brb03 = bmc021  ",
#     #             " AND brb04 = bmc03   ",
#     #             " AND brb01=  '",old_no,"'",
#     #             " AND brb29=  '",old_bra06,"'" #FUN-550014 add
#     # IF ans_2 IS NOT NULL THEN
#     #    LET l_sql=l_sql CLIPPED,
#     #             " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
#     #             " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
#     # END IF
#     #
#     # LET l_sql = l_sql clipped," INTO TEMP w "
#     # PREPARE i500_pbmc FROM l_sql
#     # EXECUTE i500_pbmc
#     # IF SQLCA.sqlcode THEN
#     #    CALL cl_err3("sel","bmc_file,brb_file",old_no,old_bra06,SQLCA.sqlcode,"","i500_pbmc",1)  #No.TQC-660046
#     #    LET g_success = 'N'
#     #    ROLLBACK WORK
#     #    RETURN
#     # END IF
#     #MOD-A30131 mark---end---
#      CASE
#         WHEN ans_1 ='2'
#            UPDATE w SET bmc03 = g_today
#         WHEN ans_1 ='3'
#            UPDATE w SET bmc03 = ef_date
#      END CASE
#      UPDATE w SET bmc01=new_no,
#                   bmc06=new_bra06 #FUN-550014 add
#      INSERT INTO bmc_file SELECT * FROM w
#      IF STATUS OR SQLCA.SQLCODE THEN
#         CALL cl_err3("ins","bmc_file",new_no,new_bra06,SQLCA.sqlcode,"","ins bmc",1)  #No.TQC-660046
#         LET g_success = 'N'
#         ROLLBACK WORK
#         RETURN
#      END IF
#      LET g_cnt=SQLCA.SQLERRD[3]
#      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
#   END IF
##-------------------- COPY BODY (bmt_file) ------------------------------
#   #插件位置是否復制ans_31
#   IF ans_31 = 'Y' THEN
#     #MOD-A30131 mark---start---
#     # DROP TABLE w2
#     # LET l_sql = " SELECT bmt_file.* FROM bmt_file,brb_file ",
#     #             " WHERE brb01 = bmt01 ",    #主件
#     #             " AND brb29 = bmt08   ",    #FUN-550014 add
#     #             " AND brb02 = bmt02   ",    #項次
#     #             " AND brb03 = bmt03   ",    #元件
#     #             " AND brb04 = bmt04   ",    #生效日
#     #             " AND brb01=  '",old_no,"'",
#     #             " AND brb29=  '",old_bra06,"'" #FUN-550014 add
#     # IF ans_2 IS NOT NULL THEN
#     #    LET l_sql=l_sql CLIPPED,
#     #             " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
#     #             " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
#     # END IF
#     # LET l_sql = l_sql clipped," INTO TEMP w2 "
#     # PREPARE i500_pbmt FROM l_sql
#     # EXECUTE i500_pbmt
#     # IF SQLCA.sqlcode THEN
#     #    CALL cl_err3("sel","bmt_file,brb_file",old_no,old_bra06,SQLCA.sqlcode,"","i500_pbmt",1)  #No.TQC-660046
#     #    LET g_success = 'N'
#     #    ROLLBACK WORK
#     #    RETURN
#     # END IF
#     #MOD-A30131 mark---end---
#      CASE
#         WHEN ans_1 ='2'
#            UPDATE w2 SET bmt04 = g_today
#         WHEN ans_1 ='3'
#            UPDATE w2 SET bmt04 = ef_date
#      END CASE
#      UPDATE w2 SET bmt01=new_no,
#                    bmt08=new_bra06 #FUN-550014 add
#      INSERT INTO bmt_file SELECT * FROM w2
#      IF STATUS OR SQLCA.SQLCODE THEN
#         CALL cl_err3("ins","bmt_file",new_no,new_bra06,SQLCA.sqlcode,"","ins bmt",1)  #No.TQC-660046
#         LET g_success = 'N'
#         ROLLBACK WORK
#         RETURN
#      END IF
#      LET g_cnt=SQLCA.SQLERRD[3]
#      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
#   END IF
##-------------------- COPY BODY (bml_file) ------------------------------
#   #元件廠牌資料是否復制ans_4
#   IF ans_4 = 'Y' THEN
#     #MOD-A30131 mark---start---
#     # DROP TABLE z
#     # LET l_sql = " SELECT UNIQUE bml_file.* FROM bml_file,brb_file ",
#     #             " WHERE brb01 = bml02 ",
#     #             "   AND brb03 = bml01 ",
#     #             "   AND brb01= '",old_no,"'"
#     # IF ans_2 IS NOT NULL THEN
#     #    LET l_sql=l_sql CLIPPED,
#     #             " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
#     #             " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
#     # END IF
#     #
#     # LET l_sql = l_sql clipped," INTO TEMP z "
#     # PREPARE i500_pbml FROM l_sql
#     # EXECUTE i500_pbml
#     # IF SQLCA.sqlcode THEN
#     #    CALL cl_err3("sel","bml_file,brb_file",old_no,"",SQLCA.sqlcode,"","i500_pbmt",1)  #No.TQC-660046
#     #    LET g_success = 'N'
#     #    ROLLBACK WORK
#     #    RETURN
#     # END IF
#     #MOD-A30131 mark---end---
# 
#      UPDATE z SET bml02=new_no
#      INSERT INTO bml_file SELECT * FROM z
#      IF STATUS OR SQLCA.SQLCODE THEN
#         CALL cl_err3("ins","bml_file",new_no,"",SQLCA.sqlcode,"","ins bml",1)  #No.TQC-660046
#         LET g_success = 'N'
#         ROLLBACK WORK
#         RETURN
#      END IF
#      LET g_cnt=SQLCA.SQLERRD[3]
#      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
#   END IF
##------------------ COPY (bmd_file) NO:0587 add in 99/10/01 By Kammy--
#   #取替代件是否復制ans_5
#   IF ans_5 = 'Y' THEN
#     #MOD-A30131 mark---start---
#     # DROP TABLE d
#     # LET l_sql = " SELECT bmd_file.* FROM bmd_file,brb_file ",
#     #             " WHERE brb01 = bmd08 ",
#     #             "   AND brb03 = bmd01 ",
#     #             "   AND brb01= '",old_no,"'",
#     #             "   AND brb29= '",old_bra06,"'",        #No:MOD-980049 add
#     #             "   AND bmdacti = 'Y'"                                           #CHI-910021
#     # IF ans_2 IS NOT NULL THEN
#     #    LET l_sql=l_sql CLIPPED,
#     #             " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
#     #             " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
#     # END IF
#     # LET l_sql = l_sql clipped," INTO TEMP d "
#     # PREPARE i500_pbmd FROM l_sql
#     # EXECUTE i500_pbmd
#     # IF SQLCA.sqlcode THEN
#     #    CALL cl_err('i500_pbmd',SQLCA.sqlcode,0)
#     #    ROLLBACK WORK #MOD-650016 add
#     #    RETURN
#     # END IF
#     #MOD-A30131 mark---end---
 
#    IF old_no = new_no AND old_bra06 != new_bra06 THEN  #TQC-610025
#    ELSE                                               #TQC-610025
#      UPDATE d SET bmd08=new_no
#      DECLARE i500_cbmd CURSOR FOR SELECT * FROM d
#      FOREACH i500_cbmd INTO l_bmd.*
#          LET l_bmd.bmdoriu = g_user      #No.FUN-980030 10/01/04
#          LET l_bmd.bmdorig = g_grup      #No.FUN-980030 10/01/04
#          INSERT INTO bmd_file VALUES(l_bmd.*)
#          IF STATUS OR SQLCA.SQLCODE THEN
#              IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
#              ELSE
#                 CALL cl_err('ins bmd: ',SQLCA.SQLCODE,1)
#                 LET g_success = 'N'
#                 ROLLBACK WORK
#                 RETURN
#              END IF             #No:MOD-980229 add
#          END IF
#          LET g_cnt=SQLCA.SQLERRD[3]
#          MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
#      END FOREACH            #No:MOD-980229 add
#   END IF
#   END IF                                             #TQC-610025
#-------------------- COPY HEAD (bra_file) ------------------------------
  #MOD-A30131 mark---start---
  # DROP TABLE y
  # SELECT * FROM bra_file
  #  WHERE bra01=old_no
  #    AND bra06=old_bra06 #FUN-550014 add
  #   INTO TEMP y
  #MOD-A30131 mark---end---
   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=new_no AND bra011=new_bra011 AND bra014='Y' 
   IF l_n>0 THEN 
      LET new_bra014='Y' 
   ELSE 
      LET new_bra014='N' 
   END IF 
   DROP TABLE y
   SELECT * FROM bra_file
    WHERE bra01=old_no
      AND bra06=old_bra06 
      AND bra011=old_bra011
#     AND bra012=old_bra012    #MOD-B30505--mark-
#     AND bra013=old_bra013    #MOD-B30505--mark-
     INTO TEMP y

   BEGIN WORK
   LET g_success='Y'
   IF cl_null(old_bra06) THEN LET old_bra06 = ' ' END IF 
   IF cl_null(new_bra06) THEN LET new_bra06 = ' ' END IF
#MOD-B30505--add--begin   
   LET l_sql = " SELECT bra012,bra013 FROM bra_file WHERE bra01='",old_no,"'",
               "  AND bra06='",old_bra06,"' AND bra011='",old_bra011,"' "
   PREPARE i500_pbra FROM l_sql
   DECLARE i500_cbra CURSOR FOR i500_pbra
   FOREACH i500_cbra INTO new_bra012,new_bra013
       SELECT COUNT(*) INTO l_n4  FROM ecb_file 
              WHERE ecb01=old_no AND ecb02=old_bra011
              AND ecb012=new_bra012 AND ecb03=new_bra013 AND ecbacti='Y'
            IF l_n4=0 THEN   
               CONTINUE  FOREACH
            END IF     
#MOD-B30505--add--end   
   UPDATE y
       SET bra01=new_no,     #新的鍵值
           bra06=new_bra06,  #FUN-550014 add
           bra011=new_bra011,
           bra012=new_bra012,
           bra013=new_bra013,
           bra014=new_bra014,
           bra05=NULL,       #發放日
           brauser=g_user,   #資料所有者
           bragrup=g_grup,   #資料所有者所屬群
           bramodu=NULL,     #資料修改日期
           bradate=g_today,  #資料建立日期
           bra08  =g_plant,  #No.FUN-7C0010
           bra09  =0,        #No.FUN-7C0010
           bra10 = '0',      #開立狀態     #NO.FUN-810014
           braacti='Y'       #有效資料
    WHERE bra01=old_no AND bra06=old_bra06 AND bra011=old_bra011 AND bra012=new_bra012 AND bra013=new_bra013  #MOD-B30505
   INSERT INTO bra_file SELECT * FROM y
     WHERE bra01=new_no AND bra06=new_bra06 AND bra011=new_bra011 AND bra012=new_bra012 AND bra013=new_bra013  #MOD-B30505
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('ins bra: ',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF

   LET l_sql = " SELECT * FROM brb_file WHERE brb01='",old_no,"'",
               "  AND brb29='",old_bra06,"' AND brb011='",old_bra011,"' ",
               " AND brb012='",new_bra012,"' AND brb013='",new_bra013,"' "
      IF ans_2 IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED,
                  " AND (brb04 <='",ans_2,"' OR brb04 IS NULL)",
                  " AND (brb05 > '",ans_2,"' OR brb05 IS NULL)"
      END IF
   PREPARE i500_pbrb FROM l_sql
   DECLARE i500_cbrb CURSOR FOR i500_pbrb
   FOREACH i500_cbrb INTO l_brb.*
      IF SQLCA.SQLCODE THEN CALL cl_err('sel brb:',SQLCA.SQLCODE,0)
         EXIT FOREACH
      END IF
         
      LET l_brb.brb01 = new_no
      LET l_brb.brb29 = new_bra06 
      LET l_brb.brb011=new_bra011
      LET l_brb.brb012=new_bra012
      LET l_brb.brb013=new_bra013
      LET l_brb.brb24=null
      SELECT ecb06 INTO l_ecb06 FROM ecb_file 
        WHERE ecb01=l_brb.brb01 AND ecb02=l_brb.brb011
       AND ecb012=l_brb.brb012 AND ecb03=l_brb.brb013  
      LET l_brb.brb09=l_ecb06
      IF ans_1 = '2' THEN LET l_brb.brb04 = g_today END IF
      IF ans_1 = '3' THEN LET l_brb.brb04 = ef_date END IF
      #若有效日期未指定, 且生效日不使用原生效日時, 必須將失效日清null
      #否則可能產生 生效日 > 失效日之情況
      IF cl_null(ans_2) AND ans_1 <> '1' THEN
         LET l_brb.brb05=null
      END IF
      IF cl_null(l_brb.brb28) THEN LET l_brb.brb28 = 0 END IF

       LET l_brb.brb33 = '0'
      INSERT INTO brb_file VALUES(l_brb.*)
      IF SQLCA.SQLCODE <> 0 THEN
         CALL cl_err3("ins","brb_file",l_brb.brb01,l_brb.brb02,"mfg-001","","",1)  
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF s_industry('icd')  THEN
         SELECT COUNT(*) INTO l_n FROM icm_file      
          WHERE icm01 = l_brb.brb03 AND icm02 = l_brb.brb01 
         IF l_n = 0 THEN 
            INITIALIZE l_icm.* TO NULL
            LET l_icm.icm01 = l_brb.brb03 
            LET l_icm.icm02 = l_brb.brb01
            LET l_icm.icmacti = 'Y' 
            LET l_icm.icmdate = g_today
            LET l_icm.icmgrup = g_grup
            LET l_icm.icmmodu = ''
            LET l_icm.icmuser = g_user
            LET l_icm.icmoriu = g_user    
            LET l_icm.icmorig = g_grup   
            INSERT INTO icm_file VALUES (l_icm.*)
           IF SQLCA.sqlcode THEN 
            CALL cl_err3("ins","icm_file",l_brb.brb01,l_brb.brb03,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
           END IF
         END IF                                          
      END IF                                  
      LET g_wsw03 = l_brb.brb01 CLIPPED ,"|",l_brb.brb02 CLIPPED
#      CASE aws_mdmdata('brb_file','insert',g_wsw03,base.TypeInfo.create(l_brb),'CreateBOMData') #FUN-890113    
#         WHEN 0  #無與 MDM 整合
#           MESSAGE 'INSERT O.K'
#         WHEN 1  #呼叫 MDM 成功
#           MESSAGE 'INSERT O.K, INSERT MDM O.K'
#         WHEN 2  #呼叫 MDM 失敗
#           ROLLBACK WORK    
#      END CASE
   END FOREACH
  END FOREACH   #MOD-B30505   
##-------------------- 復制固定屬性  (bmv_file) ------------------------------
#  IF s_industry('slk') THEN
#   LET l_sql = " SELECT * FROM bmv_file WHERE bmv01='",old_no,"'",
#                                       "  AND bmv03='",old_bra06,"'" 
#   PREPARE i500_pbmv FROM l_sql
#   DECLARE i500_cbmv CURSOR FOR i500_pbmv
#   FOREACH i500_cbmv INTO l_bmv.*
#      IF SQLCA.SQLCODE THEN CALL cl_err('sel bmv:',SQLCA.SQLCODE,0)
#         EXIT FOREACH
#      END IF
#      LET l_bmv.bmv01 = new_no
#      LET l_bmv.bmv03 = new_bra06
#      INSERT INTO bmv_file VALUES(l_bmv.*)
#      IF SQLCA.SQLCODE <> 0 THEN
#         CALL cl_err3("ins","bmv_file",l_bmv.bmv01,l_bmv.bmv02,"mfg-001","","",1) 
#         LET g_success = 'N'
#         EXIT FOREACH
#      END IF
#   END FOREACH
#  END IF
#END IF
 
  
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','abm-019',0)
#      LET g_wc="bra01='",new_no,"' AND bra011='",new_bra011,"' AND bra012='",new_bra012,"' AND bra013='",new_bra013,"'"
#      CALL i500_q(0)
      #FUN-C30027---begin
      LET g_wc = " 1=1 "
      LET g_bra.bra01 = new_no  
      LET g_bra.bra06 = new_bra06  
      LET g_bra.bra011 = new_bra011  
      CALL i500_show()  
      #FUN-C30027---end
   ELSE
      ROLLBACK WORK
      CALL cl_err('','abm-020',0)
   END IF
#   CASE aws_mdmdata('bra_file','insert',g_bra.bra01,base.TypeInfo.create(g_bra),'CreateBOMData') #FUN-890113    
#      WHEN 0  #無與 MDM 整合
#           MESSAGE 'INSERT O.K'
#      WHEN 1  #呼叫 MDM 成功
#           MESSAGE 'INSERT O.K, INSERT MDM O.K'
#      WHEN 2  #呼叫 MDM 失敗
#           ROLLBACK WORK
#   END CASE
     
END FUNCTION
 
#FUNCTION i500_up_brb13(p_ac)
# DEFINE l_bmt06   LIKE bmt_file.bmt06,
#        l_brb13   LIKE brb_file.brb13,
#        l_i       LIKE type_file.num5,     #No.FUN-680096 SMALLINT,
#        i,j       LIKE type_file.num5,     #No.MOD-6B0077 add
#        p_ac      LIKE type_file.num5      #No.FUN-680096 SMALLINT
# 
#    LET l_brb13=' '
#    LET l_i = 0
#    DECLARE up_brb13_cs CURSOR FOR
#     SELECT bmt06 FROM bmt_file
#      WHERE bmt01=g_bra.bra01
#        AND bmt02=g_brb[p_ac].brb02
#        AND bmt03=g_brb[p_ac].brb03
#        AND bmt04=g_brb[p_ac].brb04
#        AND bmt08=g_bra.bra06 #FUN-550014 add
# 
#    FOREACH up_brb13_cs INTO l_bmt06
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#        EXIT FOREACH
#     END IF
#     IF l_i = 0 THEN
#        LET l_brb13=l_bmt06
#     ELSE
#        IF (Length(l_brb13) + Length(l_bmt06)) > 8 THEN
#           LET j = 10 - Length(l_brb13)
#           FOR i=1 TO j
#               LET l_brb13 = l_brb13 CLIPPED , '.'
#           END FOR
#           EXIT FOREACH
#        ELSE
#           LET l_brb13= l_brb13 CLIPPED , ',', l_bmt06
#        END IF
#     END IF
#     LET l_i = l_i + 1
#    END FOREACH
#    RETURN l_brb13
#END FUNCTION
 
FUNCTION i500_set_entry()
    CALL cl_set_comp_entry("ef_date,old_bra06,new_bra06",TRUE)  
END FUNCTION
 
FUNCTION i500_set_no_entry()
    CALL cl_set_comp_entry("ef_date",FALSE)
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("old_bra06,new_bra06",FALSE)
    END IF
END FUNCTION
 
 
FUNCTION i500_set_required(p_ans_1)
  DEFINE    p_ans_1       LIKE type_file.chr1     
    IF p_ans_1 = '3' THEN
        CALL cl_set_comp_required("ef_date",TRUE)
    END IF
END FUNCTION
 
FUNCTION i500_set_no_required(p_ans_1)
  DEFINE   p_ans_1        LIKE type_file.chr1    
    CALL cl_set_comp_required("ef_date",FALSE)
END FUNCTION
  
FUNCTION i500_i_set_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1   
    CALL cl_set_comp_entry("bra06,bra10",TRUE) 
END FUNCTION

FUNCTION i500_i_set_no_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1     
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("bra06",FALSE)
    END IF
    IF p_cmd ='a' OR p_cmd = 'u' THEN 
        CALL cl_set_comp_entry("bra10",FALSE)
    END IF                        
END FUNCTION

FUNCTION i500_b_set_entry()
    CALL cl_set_comp_entry("brb30",TRUE)
END FUNCTION

FUNCTION i500_b_set_no_entry()
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("brb30",FALSE)
    END IF
END FUNCTION
  
FUNCTION i500_b_move_to()
   LET g_brb[l_ac].brb02 = b_brb.brb02
   LET g_brb[l_ac].brb30 = b_brb.brb30
   LET g_brb[l_ac].brb03 = b_brb.brb03
   LET g_brb[l_ac].brb09 = b_brb.brb09
   LET g_brb[l_ac].brb16 = b_brb.brb16
   LET g_brb[l_ac].brb14 = b_brb.brb14
   LET g_brb[l_ac].brb04 = b_brb.brb04
   LET g_brb[l_ac].brb05 = b_brb.brb05
   LET g_brb[l_ac].brb06 = b_brb.brb06
   LET g_brb[l_ac].brb07 = b_brb.brb07
   LET g_brb[l_ac].brb10 = b_brb.brb10
   LET g_brb[l_ac].brb08 = b_brb.brb08
   LET g_brb[l_ac].brb19 = b_brb.brb19
   LET g_brb[l_ac].brb24 = b_brb.brb24
   LET g_brb[l_ac].brb13 = b_brb.brb13
   LET g_brb[l_ac].brb31 = b_brb.brb31 
   LET g_brb[l_ac].brb081 = b_brb.brb081
   LET g_brb[l_ac].brb082 = b_brb.brb082 
#   LET g_brb[l_ac].brb01  = b_brb.brb01
#   LET g_brb[l_ac].brb011 = b_brb.brb011
#   LET g_brb[l_ac].brb012 = b_brb.brb012
#   LET g_brb[l_ac].brb013 = b_brb.brb013
   LET g_brb10_fac = b_brb.brb10_fac                                            
   LET g_brb10_fac2 = b_brb.brb10_fac2                                          
   LET g_brb11 = b_brb.brb11                                                    
   LET g_brb15 = b_brb.brb15                                                    
   LET g_brb17 = b_brb.brb17                                                    
   LET g_brb18 = b_brb.brb18                                                    
   LET g_brb23 = b_brb.brb23                                                    
   LET g_brb27 = b_brb.brb27                                                    
   LET g_brb28 = b_brb.brb28                                                    
END FUNCTION
 
FUNCTION i500_b_move_back()

   LET b_brb.brb01      = g_bra.bra01    
   LET b_brb.brb011     = g_bra.bra011      
  #LET b_brb.brb012     = g_bra.bra012  
  #LET b_brb.brb013     = g_bra.bra013
   LET b_brb.brb012     =g_bra1[l_ac2].bra012  #FUN-B20101
   LET b_brb.brb013     = g_bra1[l_ac2].bra013 #FUN-B20101  
   LET b_brb.brb29      = g_bra.bra06      
   LET b_brb.brb02      = g_brb[l_ac].brb02
   LET b_brb.brb03      = g_brb[l_ac].brb03
   LET b_brb.brb04      = g_brb[l_ac].brb04
   LET b_brb.brb05      = g_brb[l_ac].brb05
   LET b_brb.brb06      = g_brb[l_ac].brb06
   LET b_brb.brb07      = g_brb[l_ac].brb07
   LET b_brb.brb08      = g_brb[l_ac].brb08
   LET b_brb.brb09      = g_brb[l_ac].brb09
   LET b_brb.brb10      = g_brb[l_ac].brb10
   LET b_brb.brb10_fac  = g_brb10_fac      
   LET b_brb.brb10_fac2 = g_brb10_fac2     
   LET b_brb.brb11      = g_brb11          
   LET b_brb.brb13      = g_brb[l_ac].brb13
   LET b_brb.brb14      = g_brb[l_ac].brb14
   LET b_brb.brb15      = g_brb15          
   LET b_brb.brb16      = g_brb[l_ac].brb16
   LET b_brb.brb17      = g_brb17          
   LET b_brb.brb18      = g_brb18          
   LET b_brb.brb19      = g_brb[l_ac].brb19
   LET b_brb.brb20      = ''               
   LET b_brb.brb21      = ''               
   LET b_brb.brb22      = ''               
   LET b_brb.brb23      = g_brb23          
   LET b_brb.brb24      = ''               
   LET b_brb.brb25      = ''               
   LET b_brb.brb26      = ''               
   LET b_brb.brb27      = g_brb27          
   LET b_brb.brb28      = g_brb28          
   LET b_brb.brb30      = g_brb[l_ac].brb30
   LET b_brb.brb31      = g_brb[l_ac].brb31  
   LET b_brb.brbmodu    = g_user           
   LET b_brb.brbdate    = g_today          
   LET b_brb.brbcomm    = 'abmi500'  
   LET b_brb.brb081     = g_brb[l_ac].brb081
   LET b_brb.brb082     = g_brb[l_ac].brb082      

   IF cl_null(b_brb.brb02)  THEN
      LET b_brb.brb02=' '
   END IF
END FUNCTION
 
FUNCTION i500_new_no(p_no)
   DEFINE p_no         LIKE ima_file.ima01 
   DEFINE l_ima01      LIKE ima_file.ima01 
   DEFINE l_ima08      LIKE ima_file.ima08 
   DEFINE l_imaacti    LIKE ima_file.imaacti   
   DEFINE l_ima1010    LIKE ima_file.ima1010  
 
   LET l_ima01 = p_no
 
   SELECT imaacti,ima1010,ima08 INTO l_imaacti,l_ima1010,l_ima08 FROM ima_file
    WHERE ima01 = l_ima01
    CASE WHEN SQLCA.SQLCODE = 100        LET g_errno = 'mfg2602'
         WHEN l_imaacti='N'              LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'
         WHEN l_ima08='Z'                LET g_errno = 'mfg2752'
         OTHERWISE                       LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i500_confirm()
   DEFINE l_cnt   LIKE type_file.num5  
 
   IF s_shut(0) THEN RETURN END IF
   
   IF cl_null(g_bra.bra01) THEN
      CALL cl_err('','-400',0) 
      RETURN
   END IF
   IF g_bra.bra10='1' THEN CALL cl_err('','9023',1) RETURN END IF     #CHI-C30107 add
   IF g_bra.bra10='2' THEN CALL cl_err('','abm-123',1) RETURN END IF  #CHI-C30107 add
   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 add
  #SELECT * INTO g_bra.* FROM bra_file   #FUN-B20101
   SELECT DISTINCT bra01,bra04,bra05,bra06,bra08,bra10,bra011,bra014  #MOD-B30502
    INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014
    FROM bra_file   #FUN-B20101
    WHERE bra01=g_bra.bra01
      AND bra06=g_bra.bra06
      AND bra011=g_bra.bra011 
    # AND bra012=g_bra.bra012 #FUN-B20101 
    # AND bra013=g_bra.bra013 #FUN-B20101
      
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'u') THEN
       CALL cl_err(g_bra.bra08,'aoo-045',1)
       RETURN
    END IF
 
   IF g_bra.bra10='1' THEN CALL cl_err('','9023',1) RETURN END IF
   IF g_bra.bra10='2' THEN CALL cl_err('','abm-123',1) RETURN END IF
 
   #---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM brb_file
    WHERE brb01=g_bra.bra01
      AND brb29=g_bra.bra06
      AND brb011=g_bra.bra011 
   #FUN-B20101--modify
   #  AND brb012=g_bra.bra012
   #  AND brb013=g_bra.bra013
   #FUN-B20101--modify
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      RETURN
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   BEGIN WORK
#FUN-B20101--mark--begin
#  OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013
#    OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011            #FUN-B20101
#   IF STATUS THEN
#      CALL cl_err("OPEN i500_cl:", STATUS, 1)
#      CLOSE i500_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
# # FETCH i500_cl INTO g_bra.*               # 鎖住將被更改或取消的資料
#  FETCH i500_cl INTO  g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014  #FUN-B20101 
#  IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)          #資料被他人LOCK
#      CLOSE i500_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
   IF g_bra.bra10 = '0' THEN
      LET g_bra.bra10 = '1'
      LET g_confirm = 'Y'
      DISPLAY BY NAME g_bra.bra10  #MOD-B30502
   END IF
 
  #CALL i500_show()  #MOD-B30502
#FUN-B20101--mark--end 
   IF INT_FLAG THEN                   #使用者不玩了
      LET g_bra.bra10 ='0' 
      LET INT_FLAG = 0
      DISPLAY By Name g_bra.bra10
      CALL cl_err('',9001,0)
#     CLOSE i500_cl             #FUN-B20101--mark
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE bra_file
      SET bra10 = g_bra.bra10
    WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06
   #FUN-B20101--modity
   #  AND bra011=g_bra.bra011 AND bra012=g_bra.bra012 
   #  AND bra013=g_bra.bra013
      AND bra011=g_bra.bra011
   #FUN-B20101--modity
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)
      CALL i500_show()
      ROLLBACK WORK
      RETURN
   END IF
#  CLOSE i500_cl         #FUN-B20101--mark
   COMMIT WORK
END FUNCTION
 
FUNCTION i500_unconfirm()
 
   IF cl_null(g_bra.bra01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
 
 # SELECT * INTO g_bra.* FROM bra_file     #FUN-B20101
   SELECT DISTINCT bra01,bra04,bra05,bra06,bra08,bra10,bra011,bra014  #MOD-B30502
    INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014
    FROM bra_file     #FUN-B20101
    WHERE bra01=g_bra.bra01
      AND bra06=g_bra.bra06
      AND bra011=g_bra.bra011 
  #   AND bra012=g_bra.bra012     #FUN-B20101
  #   AND bra013=g_bra.bra013     #FUN-B20101
       
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'u') THEN
       CALL cl_err(g_bra.bra08,'aoo-045',1)
       RETURN
    END IF
   IF g_bra.bra10='0' THEN CALL cl_err('','9002',1)    RETURN END IF
   IF g_bra.bra10='2' THEN CALL cl_err('','aec-003',1) RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
#FUN-B20101--mark--begin   
#  OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013 #FUN-B20101
#   OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011                           #FUN-B20101
#   IF STATUS THEN
#      CALL cl_err("OPEN i500_cl:", STATUS, 1)
#      CLOSE i500_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   # FETCH i500_cl INTO g_bra.*               # 鎖住將被更改或取消的資料 #FUN-B20101
#   FETCH i500_cl INTO  g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)          #資料被他人LOCK
#      CLOSE i500_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   
   IF g_bra.bra10 = '1' THEN
      LET g_bra.bra10 = '0'
      LET g_confirm='N'
      DISPLAY BY NAME g_bra.bra10  #MOD-B30502
   END IF
 
  #CALL i500_show()   #MOD-B30502
#FUN-B20101--mark--end 
   UPDATE bra_file
      SET bra10 = g_bra.bra10
    WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06
     #FUN-B20101--modity
     #AND bra011=g_bra.bra011 AND bra012=g_bra.bra012 
     #AND bra013=g_bra.bra013
      AND bra011=g_bra.bra011
     #FUN-B20101--modity
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)
      CALL i500_show()
      ROLLBACK WORK
      RETURN
   END IF
#  CLOSE i500_cl       #FUN-B20101--mark
   COMMIT WORK
END FUNCTION

FUNCTION i500_unrelease()
   DEFINE l_brb01  LIKE brb_file.brb01 
   DEFINE l_brb02  LIKE brb_file.brb02 
   DEFINE l_brb03  LIKE brb_file.brb03 
   DEFINE l_brb04  LIKE brb_file.brb04
   DEFINE l_cnt    LIKE type_file.num5 
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_n1     LIKE type_file.num5
   DEFINE l_t      LIKE type_file.num5
   DEFINE l_i      LIKE type_file.num5
   DEFINE l_bra    RECORD LIKE bra_file.*
   DEFINE l_bma    RECORD LIKE bma_file.*
   DEFINE l_bmb    RECORD LIKE bmb_file.*
   DEFINE l_brb    RECORD LIKE brb_file.*
   DEFINE l_ecb06  LIKE ecb_file.ecb06,
          l_sql    STRING,
          l_bra012 LIKE bra_file.bra012, 
          l_bra013 LIKE bra_file.bra013,
          l_bra06  LIKE bra_file.bra06 
          
   IF cl_null(g_bra.bra01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
 
  #SELECT * INTO g_bra.* FROM bra_file     #FUN-B20101
   SELECT DISTINCT bra01,bra04,bra05,bra06,bra08,bra10,bra011,bra014  #FUN-B20101
    INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014
    FROM bra_file     #FUN-B20101
    WHERE bra01=g_bra.bra01
      AND bra06=g_bra.bra06
      AND bra011=g_bra.bra011 
  #   AND bra012=g_bra.bra012   #FUN-B20101  
  #   AND bra013=g_bra.bra013   #FUN-B20101 
        
   # 存在工單則不可發放還原                                                                                   
    LET l_cnt=0                                                                                                                     
    SELECT COUNT(*) INTO l_cnt                                                                                                      
      FROM sfb_file                                                                                                                 
     WHERE sfb05 = g_bra.bra01 AND sfb06 =g_bra.bra011   #FUN-B30033 add sfb06                                                                                                  
    IF l_cnt >0 AND l_cnt IS NOT NULL THEN                                                                                          
       CALL cl_err("",'abm-840', 1)                                                                                                 
       RETURN                                                                                                                       
    END IF                                                                                                                          
 
    IF NOT s_dc_ud_flag('2',g_bra.bra08,g_plant,'u') THEN
       CALL cl_err(g_bra.bra08,'aoo-045',1)
       RETURN
    END IF
 
   IF g_bra.bra10='0' THEN CALL cl_err('','aap-717',1) RETURN END IF
   IF g_bra.bra10='1' THEN CALL cl_err('','amr-001',1) RETURN END IF
   IF cl_null(g_bra.bra05) THEN CALL cl_err('','amr-001',1)  RETURN END IF 
   IF NOT cl_confirm('axm_600') THEN RETURN END IF
 
   BEGIN WORK   
   LET g_success='Y'
#FUN-B20101--mark--begin 
#  OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011,g_bra.bra012,g_bra.bra013  #FUN-B20101  
#   OPEN i500_cl USING g_bra.bra01,g_bra.bra06,g_bra.bra011                            #FUN-B20101
#   IF STATUS THEN
#      CALL cl_err("OPEN i500_cl:", STATUS, 1)
#      CLOSE i500_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#  # FETCH i500_cl INTO g_bra.*               # 鎖住將被更改或取消的資料  #FUN-B20101
#   FETCH i500_cl INTO g_bra.bra01,g_bra.bra04,g_bra.bra05,g_bra.bra06,g_bra.bra08,g_bra.bra10,g_bra.bra011,g_bra.bra014
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)          #資料被他人LOCK
#      CLOSE i500_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#FUN-B20101--mark--end
#   DECLARE i500_unrele CURSOR FOR SELECT bra012,bra013,bra06 FROM bra_file 
#    WHERE bra01=g_bra.bra01 AND bra011=g_bra.bra011 AND bra10='2' 
#   FOREACH i500_unrele INTO l_bra012,bra013,bra06
#       IF l_bra012!=g_bra.bra012 OR l_bra
#   END FOREACH  
#######
#   IF l_n>0 THEN 
#      FOR l_t=1 TO g_rec_b 
#          UPDATE bmb_file SET bmb06=bmb06-g_brb[l_t].brb06
#                        WHERE bmb01=g_bra.bra01
#                          AND bmb29=g_bra.bra06
#                          AND bmb03=g_brb[l_t].brb03
#      END FOR
#   ELSE 
#      FOR l_i= 1 TO g_rec_b 
#          DELETE FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb29=g_bra.bra06
#             AND bmb03=g_brb[l_i].brb03 AND bmb09=g_ecb06
#          END FOR 
#          SELECT COUNT(*) INTO l_n1 FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb29=g_bra.bra06
#          IF l_n1=0 THEN 
#             DELETE FROM bma_file WHERE bma01=g_bra.bra01 AND bma06=g_bra.bra06
#          END IF
#   END IF 
   
   LET g_bra.bra10 = '1'
   LET g_bra.bra05 = ' '
  #CALL i500_show()  #FUN-B20101
   DISPLAY BY NAME g_bra.bra10,g_bra.bra05  #FUN-B20101
   UPDATE bra_file
      SET bra10 = g_bra.bra10,
          bra05 = ''
    WHERE bra01=g_bra.bra01 AND bra06=g_bra.bra06 
    # AND bra011=g_bra.bra011 AND bra012=g_bra.bra012  #FUN-B20101
    # AND bra013=g_bra.bra013                          #FUN-B20101
      AND bra011=g_bra.bra011                          #FUN-B20101
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_bra.bra01,SQLCA.sqlcode,0)
      CALL i500_show()
      LET g_success='N'
      RETURN
   ELSE 
      IF g_bra.bra014 = 'Y' THEN #FUN-B10018  add
         DELETE FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb29=g_bra.bra06          	     
         DELETE FROM bma_file WHERE bma01=g_bra.bra01 AND bma06=g_bra.bra06   	
         SELECT COUNT(*) INTO l_n FROM bra_file  
          WHERE bra01=g_bra.bra01 AND bra011=g_bra.bra011 AND bra10='2' 
         #  AND (bra012 !=g_bra.bra012 OR bra013 !=g_bra.bra013 OR bra06 !=g_bra.bra06)    #FUN-B20101
            AND (bra06 !=g_bra.bra06)    #FUN-B20101
                  
         IF l_n>0 THEN 
            DECLARE i710_insbra CURSOR FOR SELECT * FROM bra_file WHERE bra01=g_bra.bra01 
            AND bra011=g_bra.bra011 AND bra014='Y' AND bra10='2'
      #      AND (bra012 !=g_bra.bra012 OR bra013 !=g_bra.bra013 OR bra06 !=g_bra.bra06)
              AND (bra06 !=g_bra.bra06)    #FUN-B20101

            FOREACH i710_insbra INTO l_bra.*
          #    EXIT FOREACH                   #FUN-B10018 mark 
          # END FOREACH                       #FUN-B10018 mark
               LET l_bma.bma01=l_bra.bra01
               LET l_bma.bma06=l_bra.bra06
               LET l_bma.bma05=l_bra.bra05
               LET l_bma.bma02=l_bra.bra02
               LET l_bma.bma03=l_bra.bra03
               LET l_bma.bma04=l_bra.bra04
               LET l_bma.bma06=l_bra.bra06
               LET l_bma.bma07=l_bra.bra07
               LET l_bma.bma08=l_bra.bra08
               LET l_bma.bma09=l_bra.bra09
               LET l_bma.bma10='2'
               LET l_bma.bmaacti=l_bra.braacti
               LET l_bma.bmagrup=l_bra.bragrup
               LET l_bma.bmamodu=l_bra.bramodu
               LET l_bma.bmadate=l_bra.bradate
               LET l_bma.bmauser=l_bra.brauser
               LET l_bma.bmaorig=l_bra.braorig
               LET l_bma.bmaoriu=l_bra.braoriu   
               INSERT INTO bma_file VALUES(l_bma.*)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
                  CALL cl_err3('ins',"bra_file",g_bra.bra01,g_bra.bra06,SQLCA.sqlcode,"","",1)
                  LET g_success='N' 
               END IF          
               EXIT FOREACH          #FUN-B10018
            END FOREACH              #FUN-B10018
            DECLARE i710_insbma CURSOR FOR SELECT bra012,bra013,bra06 FROM bra_file WHERE bra01=g_bra.bra01 
            AND bra011=g_bra.bra011 AND bra014='Y' AND bra10='2'
          # AND (bra012 !=g_bra.bra012 OR bra013 !=g_bra.bra013 OR bra06 !=g_bra.bra06)    #FUN-B20101
            AND (bra06 !=g_bra.bra06)                                                      #FUN-B20101
            LET l_sql="SELECT * FROM brb_file WHERE brb01= ? AND brb011= ? AND brb012= ? AND brb013= ? AND brb29= ? "
            PREPARE i710_insbrbp FROM l_sql 
            DECLARE i710_insbrb CURSOR FOR i710_insbrbp 
            FOREACH i710_insbma INTO l_bra012,l_bra013,l_bra06
               IF cl_null(l_bra06) THEN 
                  LET l_bra06=' '
               END IF 
           #   IF l_bra012=g_bra.bra012 AND l_bra013=g_bra.bra013 AND l_bra06=g_bra.bra06 THEN #FUN-B20101
               IF l_bra06=g_bra.bra06 THEN #FUN-B20101
                  CONTINUE FOREACH 
               END IF 
               SELECT ecb06 INTO l_ecb06 FROM ecb_file 
                WHERE ecb01=g_bra.bra01 AND ecb02=g_bra.bra011
                  AND ecb012=l_bra012 AND ecb03=l_bra013               
               FOREACH i710_insbrb USING g_bra.bra01,g_bra.bra011,l_bra012,l_bra013,l_bra06 INTO l_brb.*
                  SELECT COUNT(*) INTO l_n1 FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb09=l_ecb06
                     AND bmb29=l_bra06 AND bmb02=l_brb.brb02
                  LET l_bmb.bmb03=l_brb.brb03
                  LET l_bmb.bmb06=l_brb.brb06
                  LET l_bmb.bmb01=l_brb.brb01
                  LET l_bmb.bmb02=l_brb.brb02
                  LET l_bmb.bmb04=l_brb.brb04
                  LET l_bmb.bmb05=l_brb.brb05
                  LET l_bmb.bmb07=l_brb.brb07
                  LET l_bmb.bmb08=l_brb.brb08
                  LET l_bmb.bmb081=l_brb.brb081
                  LET l_bmb.bmb082=l_brb.brb082
                  LET l_bmb.bmb09=l_ecb06
                  LET l_bmb.bmb10=l_brb.brb10
                  LET l_bmb.bmb10_fac=l_brb.brb10_fac
                  LET l_bmb.bmb10_fac2=l_brb.brb10_fac2
                  LET l_bmb.bmb11=l_brb.brb11
                  LET l_bmb.bmb13=l_brb.brb13
                  LET l_bmb.bmb14=l_brb.brb14
                  LET l_bmb.bmb15=l_brb.brb15
                  LET l_bmb.bmb16=l_brb.brb16
                  LET l_bmb.bmb17=l_brb.brb17
                  LET l_bmb.bmb18=l_brb.brb18
                  LET l_bmb.bmb19=l_brb.brb19
                  LET l_bmb.bmb20=l_brb.brb20
                  LET l_bmb.bmb21=l_brb.brb21
                  LET l_bmb.bmb22=l_brb.brb22
                  LET l_bmb.bmb23=l_brb.brb23
                  LET l_bmb.bmb24=l_brb.brb24
                  LET l_bmb.bmb25=l_brb.brb25
                  LET l_bmb.bmb26=l_brb.brb26
                  LET l_bmb.bmb27=l_brb.brb27
                  LET l_bmb.bmb28=l_brb.brb28
                  LET l_bmb.bmb29=l_brb.brb29
                  LET l_bmb.bmb30=l_brb.brb30
                  LET l_bmb.bmb31=l_brb.brb31
                  LET l_bmb.bmb33=l_brb.brb33
                  LET l_bmb.bmbmodu=l_brb.brbmodu
                  LET l_bmb.bmbdate=l_brb.brbdate
                  LET l_bmb.bmbcomm=l_brb.brbcomm
                  SELECT COUNT(*) INTO l_n1 FROM bmb_file WHERE bmb01=g_bra.bra01 
                     AND bmb03=l_brb.brb03 AND bmb29=l_bra06 AND bmb09=l_ecb06
                  SELECT MAX(bmb02) INTO l_bmb.bmb02 FROM bmb_file WHERE bmb01=g_bra.bra01 AND bmb29=l_bra06
                  IF cl_null(l_bmb.bmb02) THEN 
                     LET l_bmb.bmb02=0
                  END IF 
                  LET l_bmb.bmb02=l_bmb.bmb02+g_sma.sma19              
                  IF l_n1>0 THEN 
                     UPDATE bmb_file SET bmb06=bmb06+l_bmb.bmb06
                                   WHERE bmb01=g_bra.bra01
                                     AND bmb03=l_bmb.bmb03
                                     AND bmb29=l_bmb.bmb29
                                     AND bmb09=l_bmb.bmb09
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
                        CALL cl_err3('upd',"bmb_file",g_bra.bra01,l_bmb.bmb29,SQLCA.sqlcode,"","",1)
                        LET g_success='N' 
                        EXIT FOREACH 
                     END IF                                     
                  ELSE 
                     INSERT INTO bmb_file VALUES(l_bmb.*)
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
                        CALL cl_err3('ins',"bmb_file",g_bra.bra01,l_bmb.bmb29,SQLCA.sqlcode,"","",1)
                        LET g_success='N' 
                        EXIT FOREACH 
                     END IF                           	
                  END IF 
               END FOREACH 
               IF g_success='N' THEN 
                  EXIT FOREACH 
               END IF 
            END FOREACH 
         END IF         #FUN-B10018
      END IF    	  
   END IF

#  CLOSE i500_cl     #FUN-B20101--mark
   COMMIT WORK
 
END FUNCTION

FUNCTION i500_set_brb30()
   DEFINE lcbo_target ui.ComboBox
 
   LET lcbo_target = ui.ComboBox.forName("brb30")
   CALL lcbo_target.RemoveItem("2")
   CALL lcbo_target.RemoveItem("3")
END FUNCTION
FUNCTION i500_set_brb30_1()
   DEFINE lcbo_target ui.ComboBox
 
   LET lcbo_target = ui.ComboBox.forName("brb30")
   CALL lcbo_target.RemoveItem("4")
END FUNCTION

FUNCTION i500_pic()
   DEFINE l_conf LIKE bra_file.bra10
    
   CASE
      WHEN g_bra.braacti='N'
         LET l_conf='N'
      WHEN cl_null(g_bra.bra10) 
         IF cl_null(g_bra.bra05) THEN
            LET l_conf="N"
         ELSE
            LET l_conf="Y"
         END IF
      WHEN NOT cl_null(g_bra.bra10) 
         CASE g_bra.bra10
            WHEN "0"
               LET l_conf="N"
         OTHERWISE   
               LET l_conf="Y"
         END CASE        
   END CASE
   CALL cl_set_field_pic(l_conf,"","","","",g_bra.braacti)
 
END FUNCTION
 
FUNCTION i500_brb30(p_brb30,p_brb03)
DEFINE p_brb30    LIKE brb_file.brb30,
       p_brb03    LIKE brb_file.brb03,
       l_success  LIKE type_file.chr1,
       l_ima151   LIKE ima_file.ima151,
       r_ima151   LIKE ima_file.ima151
       
       LET l_success ='Y'
       
      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_bra.bra01
      SELECT ima151 INTO r_ima151 FROM ima_file WHERE ima01 = g_brb[l_ac].brb03
      IF l_ima151<>'Y' THEN 
            IF g_brb[l_ac].brb30<>'1' OR  (NOT cl_null(r_ima151) AND r_ima151 = 'Y'  )THEN 
              CALL cl_err('','abm-326',0)
              LET l_success = 'N' 
              RETURN l_success
            END IF     
      ELSE 
          IF NOT cl_null(r_ima151) AND r_ima151 <> 'Y'  THEN
             IF g_brb[l_ac].brb30 = '4' THEN
                CALL cl_err('','abm-000',0) 
                LET l_success ='N' 
                RETURN l_success
             END IF
          ELSE 
               IF g_brb[l_ac].brb30 = '1' THEN
                  CALL cl_err('','abm-325',0) 
                  LET l_success ='N'
                  RETURN l_success
               END IF
           END IF    
        END IF      
       
       RETURN l_success 
END FUNCTION         

#根據不同的行業動態顯示按鈕名稱
FUNCTION i500_set_act_title(ps_act_names, pi_title)
   DEFINE   ps_act_names    STRING,
            pi_title        STRING 
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING,
            lnode_root      om.DomNode,
            li_i            LIKE type_file.num5, 
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            li_j            LIKE type_file.num5, 
            lnode_item      om.DomNode,
            ls_item_name    STRING,
            ls_item_tag     STRING
 
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN
      RETURN
   END IF
 
   IF (ps_act_names IS NULL) THEN
      RETURN
   ELSE
      LET ps_act_names = ps_act_names.toLowerCase()
   END IF
 
 
   LET la_act_type[1] = "ActionDefault"
   LET la_act_type[2] = "LocalAction"
   LET la_act_type[3] = "Action"
   LET la_act_type[4] = "MenuAction"
   LET lnode_root = ui.Interface.getRootNode()
   FOR li_i = 1 TO la_act_type.getLength()
      LET lst_act_names = base.StringTokenizer.create(ps_act_names, ",")
      WHILE lst_act_names.hasMoreTokens() 
         LET ls_act_name = lst_act_names.nextToken()
         LET ls_act_name = ls_act_name.trim()
         LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])
 
         FOR li_j = 1 TO llst_items.getLength()
            LET lnode_item = llst_items.item(li_j)
            LET ls_item_name = lnode_item.getAttribute("name")
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
 
            IF (ls_item_name.equals(ls_act_name)) THEN
                CALL lnode_item.setAttribute("text",pi_title)
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION

FUNCTION i500_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3 )  #FUN-B30033 jan add
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_key3             STRING  #FUN-B30033 jan add 
   DEFINE l_child            INTEGER
   DEFINE l_bra              DYNAMIC ARRAY OF RECORD
             bra01           LIKE bra_file.bra01,
             brb03           LIKE brb_file.brb03,
             brb011          LIKE brb_file.brb011,   #FUN-B30033 jan add 
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_ima02            LIKE ima_file.ima02  #品名
   DEFINE l_brb              DYNAMIC ARRAY OF RECORD
              brb03           LIKE brb_file.brb03, 
              ima02           LIKE ima_file.ima02,
              brb06           LIKE brb_file.brb06, 
              brb07           LIKE brb_file.brb07,
              brb10           LIKE brb_file.brb10
            #  child_cnt       LIKE type_file.num5 
              END RECORD
  DEFINE  l_sql              STRING
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE i                  LIKE type_file.num5  #FUN-B30033 jan add 
  
   LET max_level = 20 #設定最大階層數為20

  #FUN-B30033 jan add(s)
   IF cl_null(p_wc) THEN 
       LET i=l_ac
       IF i = 0 THEN LET i = 1 END IF 
      LET p_wc= " bra01= '",g_bra_l[i].bra01_l,"' AND bra06= '",g_bra_l[i].bra06_l,"' AND bra011='",g_bra_l[i].bra011_l,"'" 
      LET g_wc_o = p_wc
   END IF
  #FUN-B30033 jan add(e)

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_bra.clear()
      

      #讓QBE出來的單頭都當作Tree的最上層
      IF l_ac = 0 THEN 
          LET l_ac = 1
          LET l_sql = "SELECT DISTINCT brb01,brb01 as brb03,brb011,COUNT(brb03) as child_cnt FROM brb_file,bra_file", #FUN-B30033jan add
                  " WHERE ", p_wc CLIPPED,
                  " AND brb01 = bra_file.bra01 ",
                  " AND brb29 = bra_file.bra06 ",  #FUN-B30033 jan add
                  " AND brb011 = bra_file.bra011 ",#FUN-B30033 jan add
                  " AND bra01= '",g_bra_l[l_ac].bra01_l CLIPPED,"'",
                  " AND bra011='",g_bra_l[l_ac].bra011_l CLIPPED,"'", #FUN-B30033 jan add
                  " GROUP BY brb01,brb011",  #FUN-B30033 jan add
                  " ORDER BY brb01"
      ELSE
         LET l_sql = "SELECT DISTINCT brb01,brb01 as brb03,brb011,COUNT(brb03) as child_cnt FROM brb_file,bra_file", #FUN-B30033 jan add
                  " WHERE ", p_wc CLIPPED,
                  " AND brb01 = bra_file.bra01 ",
                  " AND brb29 = bra_file.bra06 ",  #FUN-B30033 jan add
                  " AND brb011 = bra_file.bra011 ",#FUN-B30033 jan add
                  " AND bra01= '",g_bra_l[l_ac].bra01_l CLIPPED,"'",
                  " AND bra011='",g_bra_l[l_ac].bra011_l CLIPPED,"'", # FUN-B30033 jan add
                  " GROUP BY brb01,brb011",  #FUN-B30033 jan add
                  " ORDER BY brb01"
        
      END IF
         
      PREPARE i500_tree_pre1 FROM l_sql
      DECLARE i500_tree_cs1 CURSOR FOR i500_tree_pre1      

      LET l_i = 1      
      FOREACH i500_tree_cs1 INTO l_bra[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF         
         
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
         LET l_ima02 = NULL
         SELECT ima02 INTO l_ima02 FROM ima_file
            WHERE ima01 = l_bra[l_i].bra01 
         LET g_tree[g_idx].name = get_field_name("bra01"),":",l_bra[l_i].bra01,
                                 "(",get_field_name("ima02"),":",l_ima02,
                                 ")  ",get_field_name("brb011"),":",l_bra[l_i].brb011 #FUN-B30033 jan add
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_bra[l_i].brb03
         LET g_tree[g_idx].treekey1 = l_bra[l_i].bra01
         LET g_tree[g_idx].treekey2 = l_bra[l_i].brb03
        # 有子節點
         IF l_bra[l_i].child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL i500_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_bra[l_i].brb011) #FUN-B30033 jan add
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF
         LET l_i = l_i + 1
      END FOREACH
   
   ELSE
      IF p_level =1 THEN
      LET p_level = p_level + 1   #下一階層
      IF p_level > max_level THEN
         CALL cl_err_msg("","agl1001",max_level,0)
         RETURN
      END IF
 
       #LET l_sql = "SELECT UNIQUE brb03,ima02,brb06,brb07,brb10 ",                  #TQC-D40105 mark
        LET l_sql = "SELECT UNIQUE brb03,ima02,SUM(brb06),brb07,brb10 ",             #TQC-D40105 add
                    " FROM brb_file LEFT JOIN ima_file ON brb03 = ima_file.ima01 ",
                    "WHERE  brb01 = '", p_key1 CLIPPED,"'",
                    "  AND  brb011= '", p_key3 CLIPPED,"'",  #FUN-B30033 jan add
                    " GROUP BY brb03,ima02,brb07,brb10 ",                            #TQC-D40105 add
                   # " GROUP BY brb03",
                    " ORDER BY brb03"
       IF NOT cl_null(g_vdate) THEN  
       #LET l_sql = "SELECT UNIQUE brb03,ima02,brb06,brb07,brb10 ",                  #TQC-D40105 mark
        LET l_sql = "SELECT UNIQUE brb03,ima02,SUM(brb06),brb07,brb10 ",             #TQC-D40105 add
                    " FROM brb_file LEFT JOIN ima_file ON brb03 = ima_file.ima01 ",
                    "WHERE  brb01 = '", p_key1 CLIPPED,"'",
                    "  AND  brb011= '", p_key3 CLIPPED,"'",  #FUN-B30033 jan add
                    "  AND (brb04 <='", g_vdate,"'"," OR brb04 IS NULL )",
                    "  AND (brb05 >  '",g_vdate,"'"," OR brb05 IS NULL )",
                    " GROUP BY brb03,ima02,brb07,brb10 ",                            #TQC-D40105 add
                    " ORDER BY brb03"

       END IF    
      PREPARE i500_tree_pre2 FROM l_sql
      DECLARE i500_tree_cs2 CURSOR FOR i500_tree_pre2

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_brb.clear()
      FOREACH i500_tree_cs2 INTO l_brb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_brb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
            --SELECT ima02 INTO l_ima02 FROM ima_file
            --WHERE ima01 = l_brb[l_i].brb01 AND imaacti='Y'
            LET g_tree[g_idx].name = get_field_name("brb03"),":",l_brb[l_i].brb03,
                                     "(",get_field_name("ima02"),":",l_brb[l_i].ima02,
                                     "):",get_field_name("brb06"),":",l_brb[l_i].brb06,
                                     "/",get_field_name("brb07"),":",l_brb[l_i].brb07,
                                     " ",get_field_name("brb10"),":",l_brb[l_i].brb10
                                     
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_brb[l_i].brb03
            LET g_tree[g_idx].treekey1 = l_bra[l_i].bra01
            LET g_tree[g_idx].treekey2 = l_brb[l_i].brb03
            #有子節點
            SELECT COUNT(brb03) INTO l_child FROM brb_file WHERE brb01 = l_brb[l_i].brb03
            IF l_child > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL i500_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
          END FOR
      END IF
     
      END IF
   END IF
END FUNCTION

FUNCTION  i500_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2 )
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_child            INTEGER
   DEFINE l_brb              DYNAMIC ARRAY OF RECORD
              brb03           LIKE brb_file.brb03, 
              ima02           LIKE ima_file.ima02,
              brb06           LIKE brb_file.brb06, 
              brb07           LIKE brb_file.brb07,
              brb10           LIKE brb_file.brb10
            #  child_cnt       LIKE type_file.num5 
              END RECORD
  DEFINE  l_sql              STRING
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
  
   LET p_level =3
  #LET l_sql = "SELECT UNIQUE brb03,ima02,brb06,brb07,brb10 ",               #TQC-D40105 mark
   LET l_sql = "SELECT UNIQUE brb03,ima02,SUM(brb06),brb07,brb10 ",          #TQC-D40105 add
                " FROM brb_file LEFT OUTER JOIN ima_file ON brb03 = ima_file.ima01 ",
                "WHERE  brb01 = '", p_key2 CLIPPED,"'",
                " GROUP BY brb03,ima02,brb07,brb10 ",                        #TQC-D40105 add
                # " GROUP BY brb03",
                " ORDER BY brb03"
   IF NOT cl_null(g_vdate) THEN  #FUN-A50010
     #LET l_sql = "SELECT UNIQUE brb03,ima02,brb06,brb07,brb10 ",            #TQC-D40105 mark
      LET l_sql = "SELECT UNIQUE brb03,ima02,SUM(brb06),brb07,brb10 ",       #TQC-D40105 add
                   " FROM brb_file LEFT OUTER JOIN ima_file ON brb03 = ima_file.ima01 ",
                   "WHERE  brb01 = '", p_key2 CLIPPED,"'",
                   "  AND (brb04 <='", g_vdate,"'"," OR brb04 IS NULL )",
                   "  AND (brb05 >  '",g_vdate,"'"," OR brb05 IS NULL )",
                   " GROUP BY brb03,ima02,brb07,brb10 ",                     #TQC-D40105 add
                   " ORDER BY brb03"

   END IF

    PREPARE i500_tree_pre3 FROM l_sql
    DECLARE i500_tree_cs3 CURSOR FOR i500_tree_pre3

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
   LET l_cnt = 1
   CALL l_brb.clear()
   FOREACH i500_tree_cs3 INTO l_brb[l_cnt].*
     IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
     END IF
         LET l_cnt = l_cnt + 1
   END FOREACH
     CALL l_brb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
     LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
            --SELECT ima02 INTO l_ima02 FROM ima_file
            --WHERE ima01 = l_brb[l_i].brb01 AND imaacti='Y'
            LET g_tree[g_idx].name = get_field_name("brb03"),l_brb[l_i].brb03,
                                    "(",get_field_name("ima02"),":",l_brb[l_i].ima02,
                                    "):",get_field_name("brb06"),":",l_brb[l_i].brb06,
                                    "/",get_field_name("brb07"),":",l_brb[l_i].brb07,
                                    "  ",get_field_name("brb10"),":",l_brb[l_i].brb10
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_brb[l_i].brb03
            --LET g_tree[g_idx].treekey1 = l_bra[l_i].bra01
            LET g_tree[g_idx].treekey2 = l_brb[l_i].brb03
         END FOR
      END IF

END FUNCTION

FUNCTION i500_tree_idxbypath()
   DEFINE l_i       LIKE type_file.num5
   
   LET g_tree_focus_idx = 1
   FOR l_i = 1 TO g_tree.getlength()
      IF g_tree[l_i].path = g_tree_focus_path THEN
            LET g_tree_focus_idx = l_i
            EXIT FOR
      END IF
   END FOR
END FUNCTION

#FUN-BB0085-add-str----
FUNCTION i500_brb081_check()

   IF NOT cl_null(g_brb[l_ac].brb10) AND NOT cl_null(g_brb[l_ac].brb081) THEN 
      IF cl_null(g_brb10_t) OR g_brb10_t != g_brb[l_ac].brb10
         OR cl_null(g_brb_t.brb081) OR g_brb_t.brb081 != g_brb[l_ac].brb081 THEN 
         LET g_brb[l_ac].brb081 = s_digqty(g_brb[l_ac].brb081,g_brb[l_ac].brb10)
         DISPLAY BY NAME g_brb[l_ac].brb081
      END IF
   END IF

   IF NOT cl_null(g_brb[l_ac].brb081) THEN
       IF g_brb[l_ac].brb081 < 0 THEN
          CALL cl_err(g_brb[l_ac].brb081,'aec-020',0)
          LET g_brb[l_ac].brb081 = g_brb_o.brb081
          RETURN FALSE
       END IF
       LET g_brb_o.brb081 = g_brb[l_ac].brb081
   END IF
   IF cl_null(g_brb[l_ac].brb081) THEN
       LET g_brb[l_ac].brb081 = 0
   END IF
   DISPLAY BY NAME g_brb[l_ac].brb081
   RETURN TRUE
END FUNCTION
#FUN-BB0085-add-end----

##################################################
# Descriptions...: 展開節點
##################################################
FUNCTION i500_tree_open(p_idx)
   DEFINE p_idx        LIKE type_file.num10  #index
   DEFINE l_pid        STRING                #父節id
   DEFINE l_openpidx   LIKE type_file.num10  #展開父index
   DEFINE l_arrlen     LIKE type_file.num5   #array length
   DEFINE l_i          LIKE type_file.num5

   LET l_openpidx = 0
   LET l_arrlen = g_tree.getLength()

   IF p_idx > 0 THEN
      IF g_tree[p_idx].has_children THEN
         LET g_tree[p_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
      END IF
      LET l_pid = g_tree[p_idx].pid
      IF p_idx > 1 THEN
         #找父節點的index
         FOR l_i=p_idx TO 1 STEP -1
            IF g_tree[l_i].id = l_pid THEN
               LET l_openpidx = l_i
               EXIT FOR
            END IF
         END FOR
         #展開父節點
         IF (l_openpidx > 0) AND (NOT cl_null(g_tree[p_idx].path)) THEN
            CALL i500_tree_open(l_openpidx)
         END IF
      END IF
   END IF
END FUNCTION

##################################################
# Descriptions...: 檢查是否為無窮迴圈
##################################################
FUNCTION i500_tree_loop(p_key1,p_addkey2,p_flag)
   DEFINE p_key1             STRING
   DEFINE p_addkey2          STRING               #要增加的節點key2
   DEFINE p_flag             LIKE type_file.chr1  #是否已跑遞迴
   DEFINE l_brb              DYNAMIC ARRAY OF RECORD
              brb03           LIKE brb_file.brb03, 
              ima02           LIKE ima_file.ima02,
              brb06           LIKE brb_file.brb06, 
              brb07           LIKE brb_file.brb07,
              brb10           LIKE brb_file.brb10
            #  child_cnt       LIKE type_file.num5 
              END RECORD
   DEFINE l_child            INTEGER
   DEFINE l_ima02            LIKE ima_file.ima02  #部門名稱
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_loop             LIKE type_file.chr1  #是否為無窮迴圈Y/N

   IF cl_null(p_flag) THEN   #第一次進遞迴
      LET g_idx = 1
      LET g_path_add[g_idx] = p_addkey2
   END IF
   LET p_flag = "Y"
   IF cl_null(l_loop) THEN
      LET l_loop = "N"
   END IF

   IF NOT cl_null(p_addkey2) THEN
      LET g_sql = "SELECT UNIQUE brb03,ima02,brb06,brb07,brb10 ",
                    " FROM brb_file LEFT OUTER JOIN ima_file ON brb03 = ima_file.ima01 ",
                    "WHERE  brb01 = '", p_key1 CLIPPED,"'",
                   # " GROUP BY brb03",
                    " ORDER BY brb03"
      PREPARE i500_tree_pre4 FROM g_sql
      DECLARE i500_tree_cs4 CURSOR FOR i500_tree_pre4

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_brb.clear()
      FOREACH i500_tree_cs4 INTO l_brb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_brb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_path_add[g_idx] = l_brb[l_i].brb03
            IF g_path_add[g_idx] = p_key1 THEN
               LET l_loop = "Y"
               RETURN l_loop
            END IF
            #有子節點
            SELECT COUNT(brb03) INTO l_child FROM brb_file WHERE brb01 = l_brb[l_i].brb03
            IF l_child > 0 THEN
               CALL i500_tree_loop(p_key1,l_brb[l_i].brb03,p_flag) RETURNING l_loop
            END IF
          END FOR
      END IF
   END IF
   RETURN l_loop
END FUNCTION

##################################################
# Descriptions...: 異動Tree資料
##################################################
FUNCTION i500_tree_update()
   #Tree重查並展開focus節點
   CALL i500_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,NULL) #Tree填充 #FUN-B30033 jan add
   CALL i500_tree_idxbypath()                        #依tree path指定focus節點
   CALL i500_tree_open(g_tree_focus_idx)             #展開節點
   #復原cursor，上下筆的按鈕才可以使用
   IF g_tree[g_tree_focus_idx].level = 1 THEN
      LET g_tree_b = "N"
   #更新focus節點的單頭和單身
   ELSE
      LET g_tree_b = "Y"
   END IF
   CALL i500_q(g_tree_focus_idx) 
END FUNCTION

##################################################
# Descriptions...: 依key指定focus節點
##################################################
FUNCTION i500_tree_idxbykey()   #No.FUN-A30120 add by tommas  fetch單頭後，利用g_abd01來搜尋該資料目前位於g_tree的哪個索引中。
   DEFINE l_idx   INTEGER
   LET g_tree_focus_idx = 1
   FOR l_idx = 1 TO g_tree.getLength()
      IF ( g_tree[l_idx].level == 1 ) AND ( g_tree[l_idx].treekey2 == g_bra.bra01 ) CLIPPED THEN  # 尋找節點
         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx
      END IF
   END FOR
END FUNCTION

##################################################
# Descriptions...: 顯示圖片
##################################################
FUNCTION i500_show_pic(p_idx)
    DEFINE p_idx  LIKE type_file.num5
    DEFINE l_wc   STRING  
    DEFINE p_ima04 LIKE ima_file.ima04


    LET g_doc.column1 = "ima01"
    LET g_doc.value1 = g_tree[p_idx].treekey2
    CALL cl_get_fld_doc("ima04")
                 

END FUNCTION
##################################################
# Descriptions...: 顯示字段名稱
##################################################
FUNCTION get_field_name(p_field_code)
   DEFINE p_field_code STRING
   DEFINE l_sql        STRING,
          l_gaq03      LIKE gaq_file.gaq03

   LET l_sql = "SELECT gaq03 FROM gaq_file",
               " WHERE gaq01='",p_field_code,"' AND gaq02='",g_lang,"'"
   DECLARE gaq_curs SCROLL CURSOR FROM l_sql
   OPEN gaq_curs
   FETCH FIRST gaq_curs INTO l_gaq03
   CLOSE gaq_curs

   RETURN l_gaq03 CLIPPED
END FUNCTION
#No.FUN-A50089      
 
