# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt252.4gl
# Descriptions...: 配送分配單
# Date & Author..: No:FUN-870007 08/09/03 By Zhangyajun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0051 09/11/06 By lilingyu substr寫法調整
# Modify.........: No:TQC-9B0045 09/11/13 By xiaofeizhu DECODE寫法調整
# Modify.........: No:TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:FUN-960130 09/11/24 By bnlent get tra-db
# Modify.........: No:FUN-9B0157 09/12/07 By bnlent sql 錯誤
# Modify.........: No:FUN-9C0069 09/12/14 By bnlent mark or replace rucplant/ruclegal 
# Modify.........: No:FUN-9C0079 09/12/14 By bnlent 1.rucplant刪除導致的問題2.臨時表及時清空 
# Modify.........: No:FUN-9C0088 09/12/17 By bnlent Modify the style for CREATE TEMP TABLE
# Modify.........: No:FUN-9C0111 09/12/19 By mike insert rvv_temp values()改为insert rvv_temp() values() 
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:FUN-A10123 10/02/02 By bnlent 增加配送分貨單判斷參數(asms250里sma140 配送依收貨過帳)
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach add oriu/orig  
# Modify.........: No:FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:FUN-A40023 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:TQC-A40036 10/06/01 By Cockroach 賦值於ruooriu/ruoorig,adkoriu/adkorig
# Modify.........: No:FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:TQC-A70088 10/07/22 By houlia temp表增加g_plant、g_legal的賦值
# Modify.........: No:FUN-A70123 10/07/28 By bnlent 調撥單的法人並非一定當前法人,一些其他單據temp legal需要賦值
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No:FUN-A90063 10/09/27 By rainy INSERT INTO p630_tmp時，應給 plant/legal值
# Modify.........: No:FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No:FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No:FUN-AB0078 10/11/19 By houlia 倉庫營運中心權限控管審核段控管 
# Modify.........: No:FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No:TQC-AC0004 10/12/03 By Carrier 去掉 套号相关内容
# Modify.........: No:TQC-AC0230 10/12/17 By huangtao 帶不出單身資料
# Modify.........: No:FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:MOD-AC0245 10/12/24 By lilingyu 此作業在跨營運中心配送時,組出來的sql錯誤,導致沒有更新Img_file的資料
# Modify.........: No:TQC-AC0311 10/12/30 By huangrh  開啟單身
# Modify.........: No:TQC-B20004 11/02/14 By lixia 配送產生調撥單時,應只產生"未確認"的撥出調撥單
# Modify.........: No:FUN-B30028 11/03/11 By huangtao 移除簽核相關欄位
# Modify.........: No:FUN-B20060 11/04/07 By zhangll 增加oeb72赋值
# Modify.........: No:TQC-B40097 11/04/13 By lilingyu 隱藏"送貨上門"欄位ruc29
# Modify.........: No:TQC-B40098 11/04/25 By shiwuying 新增时rvm06默认为N
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:TQC-B70016 11/07/04 By guoch 隱藏rvm09欄位
# Modify.........: No:TQC-B60349 11/07/06 By guoch 還原rvm09欄位
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:CHI-B70039 11/08/10 By JoHung 金額 = 計價數量 x 單價
# Modify.........: No:MOD-B80228 11/08/22 By suncx 採購多角貿易流程代碼為模板時的BUG處理
# Modify.........: No:MOD-B80222 11/08/23 By suncx 如果已經錄入一筆需求單號為XXX的資料，則錄入時管控不能重複錄入
# Modify.........: No:FUN-BA0100 11/10/27 By suncx 新增產品信息和庫存信息頁簽，新增快速分配功能
# Modify.........: No.FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C40243 12/05/03 by fanbj arti162中的產品分類設為*時，artt252錄入出貨倉庫欄位時，
#                                                  仍會有AND rvk02=g_rvn[l_ac].ima131這樣的判斷，導致出貨倉庫欄位被卡住
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C80087 12/08/14 By yangxf 解决单身未成功产生删除单头资料后没有清空栏位BUG 
# Modify.........: No:TQC-C80089 12/08/14 By yangxf 解决点击审核按钮没有反应问题
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.......... No:FUN-C80072 12/08/28 By nanbing 增加配送自動完成否判斷
# Modify.......... No:TQC-C80180 12/08/30 By yangxf 產生派車單FUNCTION中抓取預設單別失敗后未將標誌欄位寫N,導致未取到預設單別卻未報錯以及回滾
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-CB0104 12/12/06 By baogc 異店取貨銷售歸屬為2.取貨門店時,撥入營運中心給值取貨營運中心,同理撥入倉庫
# Modify.........: No:FUN-CC0057 12/12/14 By shiwuying 异店取货逻辑调整
# Modify.........: No:FUN-CB0087 12/12/24 By qiull 庫存單據理由碼改善  xianghui ogb_file
# Modify.........: No:FUN-D30033 13/04/12 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rvm    RECORD LIKE rvm_file.*,
        g_rvm_t  RECORD LIKE rvm_file.*,
        g_rvm_o  RECORD LIKE rvm_file.*,
        g_rvn   DYNAMIC ARRAY OF RECORD 
                rvn02      LIKE rvn_file.rvn02, #項次#FUN-A40023
                rvn03      LIKE rvn_file.rvn03, #需求單號
                rvn04      LIKE rvn_file.rvn04, #需求項次
                rvn05      LIKE rvn_file.rvn05, #需求類型
                rvn06      LIKE rvn_file.rvn06, #需求機構
                rvn06_desc LIKE azp_file.azp02, #機構名稱
                rvn07      LIKE rvn_file.rvn07, #收貨機構
                rvn07_desc LIKE azp_file.azp02, #機構名稱
                rvn08      LIKE rvn_file.rvn08, #線路編號
                rvn09      LIKE rvn_file.rvn09, #商品編號
                ima02      LIKE ima_file.ima02, #商品名稱
                ima131     LIKE ima_file.ima131,#產品分類
                ruc16      LIKE ruc_file.ruc16, #分貨單位
                ruc16_desc LIKE gfe_file.gfe02, #單位名稱
                ruc18      LIKE ruc_file.ruc18, #需求量
                ruc18_01   LIKE rvn_file.rvn10, #未分貨量
                rvn10      LIKE rvn_file.rvn10, #本次分貨量
                rvn11      LIKE rvn_file.rvn11, #出貨倉庫
                rvn11_desc LIKE imd_file.imd02, #倉庫名稱
                rvn12      LIKE rvn_file.rvn12, #出貨機構
                rvn12_desc LIKE azp_file.azp02, #機構名稱
                ruc29      LIKE ruc_file.ruc29, #送貨上門
                rvn13      LIKE rvn_file.rvn13  #預設多角流程
                        END RECORD,
        g_rvn_t   RECORD 
                rvn02      LIKE rvn_file.rvn02, #項次
                rvn03      LIKE rvn_file.rvn03, #需求單號
                rvn04      LIKE rvn_file.rvn04, #需求項次
                rvn05      LIKE rvn_file.rvn05, #需求類型
                rvn06      LIKE rvn_file.rvn06, #需求機構
                rvn06_desc LIKE azp_file.azp02, #機構名稱
                rvn07      LIKE rvn_file.rvn07, #收貨機構
                rvn07_desc LIKE azp_file.azp02, #機構名稱
                rvn08      LIKE rvn_file.rvn08, #線路編號
                rvn09      LIKE rvn_file.rvn09, #商品編號
                ima02      LIKE ima_file.ima02, #商品名稱
                ima131     LIKE ima_file.ima131,#產品分類
                ruc16      LIKE ruc_file.ruc16, #分貨單位
                ruc16_desc LIKE gfe_file.gfe02, #單位名稱
                ruc18      LIKE ruc_file.ruc18, #需求量
                ruc18_01   LIKE rvn_file.rvn10, #未分貨量
                rvn10      LIKE rvn_file.rvn10, #本次分貨量
                rvn11      LIKE rvn_file.rvn11, #出貨倉庫
                rvn11_desc LIKE imd_file.imd02, #倉庫名稱
                rvn12      LIKE rvn_file.rvn12, #出貨機構
                rvn12_desc LIKE azp_file.azp02, #機構名稱
                ruc29      LIKE ruc_file.ruc29, #送貨上門
                rvn13      LIKE rvn_file.rvn13  #預設多角流程
                        END RECORD,
        g_rvn_o   RECORD 
                rvn02      LIKE rvn_file.rvn02, #項次
                rvn03      LIKE rvn_file.rvn03, #需求單號
                rvn04      LIKE rvn_file.rvn04, #需求項次
                rvn05      LIKE rvn_file.rvn05, #需求類型
                rvn06      LIKE rvn_file.rvn06, #需求機構
                rvn06_desc LIKE azp_file.azp02, #機構名稱
                rvn07      LIKE rvn_file.rvn07, #收貨機構
                rvn07_desc LIKE azp_file.azp02, #機構名稱
                rvn08      LIKE rvn_file.rvn08, #線路編號
                rvn09      LIKE rvn_file.rvn09, #商品編號
                ima02      LIKE ima_file.ima02, #商品名稱
                ima131     LIKE ima_file.ima131,#產品分類
                ruc16      LIKE ruc_file.ruc16, #分貨單位
                ruc16_desc LIKE gfe_file.gfe02, #單位名稱
                ruc18      LIKE ruc_file.ruc18, #需求量
                ruc18_01   LIKE rvn_file.rvn10, #未分貨量
                rvn10      LIKE rvn_file.rvn10, #本次分貨量
                rvn11      LIKE rvn_file.rvn11, #出貨倉庫
                rvn11_desc LIKE imd_file.imd02, #倉庫名稱
                rvn12      LIKE rvn_file.rvn12, #出貨機構
                rvn12_desc LIKE azp_file.azp02, #機構名稱
                ruc29      LIKE ruc_file.ruc29, #送貨上門
                rvn13      LIKE rvn_file.rvn13  #預設多角流程
                        END RECORD
        #No.TQC-AC0004  --Begin
        #g_rvnn  DYNAMIC ARRAY OF RECORD
        #        rvnn02      LIKE rvnn_file.rvnn02, #項次
        #        rvnn03      LIKE rvnn_file.rvnn03, #來源單號
        #        rvnn04      LIKE rvnn_file.rvnn04, #來源項次
        #        ruc07       LIKE ruc_file.ruc07,   #來源類型
        #        rvnn05      LIKE rvnn_file.rvnn05, #需求機構
        #        rvnn05_desc LIKE azp_file.azp02,   #機構名稱
        #        rvnn06      LIKE rvnn_file.rvnn06, #套號
        #        rvnn06_desc LIKE azp_file.azp02,   #名稱
        #        ima131      LIKE ima_file.ima131,  #產品分類
        #        ruc16       LIKE ruc_file.ruc16,   #分貨單位
        #        ruc16_desc  LIKE gfe_file.gfe02,   #單位名稱
        #        ruc18       LIKE ruc_file.ruc18,   #需求量
        #        ruc18_01    LIKE rvnn_file.rvnn07, #未分貨量
        #        rvnn07      LIKE rvnn_file.rvnn07 #本次分貨量
        #                END RECORD,
        #g_rvnn_t  RECORD
        #        rvnn02      LIKE rvnn_file.rvnn02, #項次
        #        rvnn03      LIKE rvnn_file.rvnn03, #來源單號
        #        rvnn04      LIKE rvnn_file.rvnn04, #來源項次
        #        ruc07       LIKE ruc_file.ruc07,   #來源類型
        #        rvnn05      LIKE rvnn_file.rvnn05, #需求機構
        #        rvnn05_desc LIKE azp_file.azp02,   #機構名稱
        #        rvnn06      LIKE rvnn_file.rvnn06, #套號
        #        rvnn06_desc LIKE azp_file.azp02,   #名稱
        #        ima131      LIKE ima_file.ima131,  #產品分類
        #        ruc16       LIKE ruc_file.ruc16,   #分貨單位
        #        ruc16_desc  LIKE gfe_file.gfe02,   #單位名稱
        #        ruc18       LIKE ruc_file.ruc18,   #需求量
        #        ruc18_01    LIKE rvnn_file.rvnn07, #未分貨量
        #        rvnn07      LIKE rvnn_file.rvnn07 #本次分貨量
        #                END RECORD,
        #g_rvnn_o  RECORD
        #        rvnn02      LIKE rvnn_file.rvnn02, #項次
        #        rvnn03      LIKE rvnn_file.rvnn03, #來源單號
        #        rvnn04      LIKE rvnn_file.rvnn04, #來源項次
        #        ruc07       LIKE ruc_file.ruc07,   #來源類型
        #        rvnn05      LIKE rvnn_file.rvnn05, #需求機構
        #        rvnn05_desc LIKE azp_file.azp02,   #機構名稱
        #        rvnn06      LIKE rvnn_file.rvnn06, #套號
        #        rvnn06_desc LIKE azp_file.azp02,   #名稱
        #        ima131      LIKE ima_file.ima131,  #產品分類
        #        ruc16       LIKE ruc_file.ruc16,   #分貨單位
        #        ruc16_desc  LIKE gfe_file.gfe02,   #單位名稱
        #        ruc18       LIKE ruc_file.ruc18,   #需求量
        #        ruc18_01    LIKE rvnn_file.rvnn07, #未分貨量
        #        rvnn07      LIKE rvnn_file.rvnn07 #本次分貨量
        #                END RECORD
        ##No.TQC-AC0004  --End  
#FUN-BA0100 add begin------------------------------
DEFINE  g_rvn1  DYNAMIC ARRAY OF RECORD
                rvn09     LIKE rvn_file.rvn09, #商品編號
                ima02_1   LIKE ima_file.ima02, #商品名稱
                ima25     LIKE ima_file.ima25, #庫存單位
                gfe02     LIKE gfe_file.gfe02, #單位名稱
                ruc18_1   LIKE ruc_file.ruc18, #需求總量
                ruc18_011 LIKE rvn_file.rvn10, #未分貨總量
                rvn10_1   LIKE rvn_file.rvn10, #分配总量
                img10     LIKE img_file.img10  #庫存總量
                END RECORD,
        g_rvn1_t RECORD
                rvn09     LIKE rvn_file.rvn09, #商品編號
                ima02_1   LIKE ima_file.ima02, #商品名稱
                ima25     LIKE ima_file.ima25, #庫存單位
                gfe02     LIKE gfe_file.gfe02, #單位名稱
                ruc18_1   LIKE ruc_file.ruc18, #需求總量
                ruc18_011 LIKE rvn_file.rvn10, #未分貨總量
                rvn10_1   LIKE rvn_file.rvn10, #分配总量
                img10     LIKE img_file.img10  #庫存總量
                END RECORD,
        g_rvn2  DYNAMIC ARRAY OF RECORD
                rvn11     LIKE rvn_file.rvn11, #倉庫編號
                imd02     LIKE imd_file.imd02, #倉庫名稱
                ruc18_2   LIKE ruc_file.ruc18, #需求總量
                img10_1   LIKE img_file.img10  #庫存總量
                END RECORD,
        g_rvn2_t RECORD
                rvn11     LIKE rvn_file.rvn11, #倉庫編號
                imd02     LIKE imd_file.imd02, #倉庫名稱
                ruc18_2   LIKE ruc_file.ruc18, #需求總量
                img10_1   LIKE img_file.img10  #庫存總量
                END RECORD
DEFINE  l_ac1    LIKE type_file.num5,
        l_ac2    LIKE type_file.num5,
        g_rec_b3 LIKE type_file.num5
DEFINE att DYNAMIC ARRAY OF RECORD
                rvn02      STRING, #項次#FUN-A40023
                rvn03      STRING, #需求單號
                rvn04      STRING, #需求項次
                rvn05      STRING, #需求類型
                rvn06      STRING, #需求機構
                rvn06_desc STRING, #機構名稱
                rvn07      STRING, #收貨機構
                rvn07_desc STRING, #機構名稱
                rvn08      STRING, #線路編號
                rvn09      STRING, #商品編號
                ima02      STRING, #商品名稱
                ima131     STRING, #產品分類
                ruc16      STRING, #分貨單位
                ruc16_desc STRING, #單位名稱
                ruc18      STRING, #需求量
                ruc18_01   STRING, #未分貨量
                rvn10      STRING, #本次分貨量
                rvn11      STRING, #出貨倉庫
                rvn11_desc STRING, #倉庫名稱
                rvn12      STRING, #出貨機構
                rvn12_desc STRING, #機構名稱
                ruc29      STRING, #送貨上門
                rvn13      STRING  #預設多角流程
           END RECORD
DEFINE  g_sta   STRING
#FUN-BA0100 add end---------------------------------
DEFINE  g_sql   STRING,
        g_sql1  STRING,
        g_sql2  STRING,
        g_wc    STRING,
        g_wc1   STRING,
        g_wc2   STRING,
        g_rec_b1 LIKE type_file.num5,
        g_rec_b2 LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr                LIKE type_file.chr1
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  mi_no_ask            LIKE type_file.num5
DEFINE  l_table  STRING
DEFINE  g_t1       LIKE oay_file.oayslip #自動編號
DEFINE  g_action_flag STRING
DEFINE  g_rvn11    LIKE rvn_file.rvn11  #出貨機構
DEFINE  g_rvn06    LIKE rvn_file.rvn06  #需求機構
DEFINE  g_total_count    LIKE type_file.num5
DEFINE  g_current_count  LIKE type_file.num5
DEFINE  g_post        LIKE type_file.chr1
DEFINE g_start        DATETIME MINUTE TO FRACTION(5)
DEFINE g_end          DATETIME MINUTE TO FRACTION(5)
DEFINE g_interval     INTERVAL SECOND TO FRACTION(5)
DEFINE g_stop         LIKE type_file.chr5
DEFINE g_first        LIKE type_file.chr1  #No.FUN-A10123
DEFINE g_rcj09        LIKE rcj_file.rcj09 #FUN-C80072 add      
DEFINE g_rcj12        LIKE rcj_file.rcj09 #FUN-CB0104 Add
DEFINE l_err RECORD
          field LIKE type_file.chr1000,
          data  LIKE type_file.chr1000,
          msg   LIKE type_file.chr50,
          errcode LIKE type_file.chr7,
          n     LIKE type_file.num5
          END RECORD
 
MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
 
    LET g_forupd_sql="SELECT * FROM rvm_file WHERE rvm01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t252_cl    CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10     
    OPEN WINDOW t252_w AT p_row,p_col WITH FORM "art/42f/artt252"  
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    
    CALL cl_set_comp_visible("rvn08,ruc29",FALSE)       #TQC-B40097 ADD ruc29
 #   CALL cl_set_comp_visible("rvm09",FALSE)    #TQC-B70016 #TQC-B60349 mark

    #抓取參數
    SELECT rcj09,rcj12 INTO g_rcj09,g_rcj12 FROM rcj_file #FUN-CB0104 Add
 
    CALl t252_createtable()
    CALL t252_menu()
 
    CALL t252_droptemptable()
    CLOSE WINDOW t252_w                   
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION t252_createtable()
    #No.FUN-9C0088...begin
   # SELECT rvn01,rvn02,rvn03,rvn04,rvn05,rvn06,azp02 rvn06_desc,rvn07,azp02 rvn07_desc,
   #        rvn08,rvn09,ima02,ima131,ruc16,gfe02,ruc18,ruc18 ruc18_01,rvn10,rvn11,
   #        imd02 rvn11_desc,rvn12,azp02 rvn12_desc,ruc29,rvn13,rvnplant,ruc07,ruc08,ruc09
   #   FROM rvn_file,azp_file,ima_file,imd_file,ruc_file,gfe_file
   #  WHERE 1 = 0
   #   INTO TEMP cs_rvn_temp
   CREATE TEMP TABLE cs_rvn_temp(
    rvn01    LIKE rvn_file.rvn01,
    rvn02    LIKE rvn_file.rvn02,
    rvn03    LIKE rvn_file.rvn03,
    rvn04    LIKE rvn_file.rvn04,
    rvn05    LIKE rvn_file.rvn05,
    rvn06    LIKE rvn_file.rvn06,
    rvn06_desc LIKE azp_file.azp02,
    rvn07    LIKE rvn_file.rvn07,
    rvn07_desc LIKE azp_file.azp02,
    rvn08    LIKE rvn_file.rvn08,
    rvn09    LIKE rvn_file.rvn09,
    ima02    LIKE ima_file.ima02,
    ima131   LIKE ima_file.ima131,
    ruc16     LIKE ruc_file.ruc16,
    gfe02    LIKE gfe_file.gfe02,
    ruc18    LIKE ruc_file.ruc18,
    ruc18_01 LIKE ruc_file.ruc18,
    rvn10    LIKE rvn_file.rvn10,
    rvn11    LIKE rvn_file.rvn11,
    rvn11_desc LIKE imd_file.imd02, 
    rvn12    LIKE rvn_file.rvn12,
    rvn12_desc LIKE azp_file.azp02,
    ruc29    LIKE ruc_file.ruc29,
    rvn13    LIKE rvn_file.rvn13,
    rvnplant LIKE rvn_file.rvnplant,
    ruc07     LIKE ruc_file.ruc07,
    ruc08     LIKE ruc_file.ruc08,
    ruc09     LIKE ruc_file.ruc09);
    CREATE INDEX cs_rvn_temp_pk ON cs_rvn_temp(ruc08,ruc09)
    #SELECT rvnn01,rvnn02,rvnn03,rvnn04,ruc07,rvnn05,gfe02 rvnn05_desc,rvnn06,ima02,
    #       ima131,ruc16,gfe02,ruc18,ruc18 ruc18_01,rvnn07,rvnnlegal,rvnnplant
    #  FROM rvnn_file,ima_file,ruc_file,gfe_file
    # WHERE 1 = 0 INTO TEMP cs_rvnn_temp
   #No.TQC-AC0004  --Begin
   #CREATE TEMP TABLE cs_rvnn_temp(
   # rvnn01    LIKE rvnn_file.rvnn01,
   # rvnn02    LIKE rvnn_file.rvnn02,
   # rvnn03    LIKE rvnn_file.rvnn03,
   # rvnn04    LIKE rvnn_file.rvnn04,
   # ruc07     LIKE ruc_file.ruc07,
   # rvnn05    LIKE rvnn_file.rvnn05,
   # rvnn05_desc LIKE gfe_file.gfe02,
   # rvnn06    LIKE rvnn_file.rvnn06,
   # ima02     LIKE ima_file.ima02,
   # ima131    LIKE ima_file.ima131,
   # ruc16     LIKE ruc_file.ruc16,
   # gfe02     LIKE gfe_file.gfe02,
   # ruc18     LIKE ruc_file.ruc18,
   # ruc18_01  LIKE ruc_file.ruc18,
   # rvnn07    LIKE rvnn_file.rvnn07,
   # rvnnlegal LIKE rvnn_file.rvnnlegal,
   # rvnnplant LIKE rvnn_file.rvnnplant);
   # #No.FUN-9C0088...end
   # CREATE UNIQUE INDEX cs_rvnn_temp_pk ON cs_rvnn_temp(rvnn03,rvnn04,rvnn05)
   #No.TQC-AC0004  --End  
    SELECT chr1000 field,chr1000 data,chr50 msg,chr7 errcode,num5 n 
      FROM type_file WHERE 1=0 INTO TEMP err_temp
END FUNCTION
 
FUNCTION t252_droptemptable()
    DROP TABLE cs_rvn_temp
    #No.TQC-AC0004  --Begin
    #DROP TABLE cs_rvnn_temp
    #No.TQC-AC0004  --Begin
    DROP TABLE err_temp
END FUNCTION
 
FUNCTION t252_bp1(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-BA0100 mark begin---------------------
#   DISPLAY ARRAY g_rvn TO s_rvn.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
#      BEFORE DISPLAY
#        CALL cl_navigator_setting(g_curs_index,g_row_count)
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()    
#      #No.TQC-AC0004  --Begin
#      #ON ACTION fixup2
#      #   LET g_action_flag = "fixup2"
#      #   EXIT DISPLAY               
#      #No.TQC-AC0004  --End  
#      ON ACTION confirm #審核
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#      ON ACTION void #作廢
#         LET g_action_choice="void"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t252_fetch('F')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY 
#      ON ACTION previous
#         IF g_curs_index>1 THEN
#          CALL t252_fetch('P')
#          CALL cl_navigator_setting(g_curs_index,g_row_count)
#          CALL fgl_set_arr_curr(1)
#         END IF
#         ACCEPT DISPLAY 
#      ON ACTION jump
#         CALL t252_fetch('/')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY 
#      ON ACTION next
#         IF g_curs_index<g_row_count THEN
#          CALL t252_fetch('N')
#          CALL cl_navigator_setting(g_curs_index,g_row_count)
#          CALL fgl_set_arr_curr(1)
#          ACCEPT DISPLAY 
#         END IF
#      ON ACTION LAST
#         CALL t252_fetch('L')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY 
#     ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#       ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY   
##      ON ACTION reproduce
##         LET g_action_choice="reproduce"
##         EXIT DISPLAY
##      ON ACTION output
##        LET g_action_choice="output"
##         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                  
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#     ON ACTION controlg
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
# 
#    ON ACTION accept
#      LET g_action_choice="detail"
#      LET l_ac = ARR_CURR()
#      EXIT DISPLAY
# 
#    ON ACTION cancel
#      LET INT_FLAG=FALSE 		
#      LET g_action_choice="exit"
#      EXIT DISPLAY
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
# 
#      ON ACTION about         
#         CALL cl_about()      
#            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#      ON ACTION controls                    
#           CALL cl_set_head_visible("","AUTO")  
#      ON ACTION related_document
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#  END DISPLAY
#FUN-BA0100 mark end----------------------
#FUN-BA0100 add begin----------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
         
      DISPLAY ARRAY g_rvn1 TO s_rvn1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            IF cl_null(g_sta) THEN
               LET l_ac1 = ARR_CURR()
            ELSE 
               LET g_sta = NULL
            END IF
            CALL fgl_set_arr_curr(l_ac1)
            IF l_ac1 > 0 THEN
               CALL t252_b1_fill(g_rvn1[l_ac1].rvn09)
               CALL t252_b2_fill(g_rvn1[l_ac1].rvn09)
            END IF
            CALL cl_show_fld_cont()
            
         AFTER DISPLAY
            CONTINUE DIALOG
      END DISPLAY 
      
      DISPLAY ARRAY g_rvn TO s_rvn.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
            
         AFTER DISPLAY
            CONTINUE DIALOG
      END DISPLAY 
      
      DISPLAY ARRAY g_rvn2 TO s_rvn2.* ATTRIBUTE(COUNT=g_rec_b3)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
            
         AFTER DISPLAY
            CONTINUE DIALOG
      END DISPLAY

      BEFORE DIALOG 
         CALL DIALOG.setArrayAttributes("s_rvn", att)
         
      ON ACTION confirm #審核
         LET g_action_choice="confirm"
         EXIT DIALOG
      ON ACTION void #作廢
         LET g_action_choice="void"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         CALL t252_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL t252_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG 
      ON ACTION jump
         CALL t252_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL t252_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DIALOG 
         END IF
      ON ACTION LAST
         CALL t252_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION invalid
         LET g_action_choice="invalid"
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
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
         
      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")  
           
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
      ON ACTION fast_allocation
         LET g_action_choice="fast_allocation"
         EXIT DIALOG
   END DIALOG
#FUN-BA0100 add end----------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
  
END FUNCTION
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_bp2(p_ud)
#DEFINE   p_ud   LIKE type_file.chr1          
# 
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = ''
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_rvnn TO s_rvnn.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
#      BEFORE DISPLAY
#        CALL cl_navigator_setting(g_curs_index,g_row_count)
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()   
#      ON ACTION fixup1 
#         LET g_action_flag="fixup1"
#         EXIT DISPLAY                
#      ON ACTION confirm #審核
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#      ON ACTION void #作廢
#         LET g_action_choice="void"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t252_fetch('F')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY 
#      ON ACTION previous
#         IF g_curs_index>1 THEN
#          CALL t252_fetch('P')
#          CALL cl_navigator_setting(g_curs_index,g_row_count)
#          CALL fgl_set_arr_curr(1)
#         END IF
#         ACCEPT DISPLAY 
#      ON ACTION jump
#         CALL t252_fetch('/')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY 
#      ON ACTION next
#         IF g_curs_index<g_row_count THEN
#          CALL t252_fetch('N')
#          CALL cl_navigator_setting(g_curs_index,g_row_count)
#          CALL fgl_set_arr_curr(1)
#          ACCEPT DISPLAY 
#         END IF
#      ON ACTION LAST
#         CALL t252_fetch('L')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY 
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY   
##      ON ACTION reproduce
##         LET g_action_choice="reproduce"
##         EXIT DISPLAY
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
##      ON ACTION output
##        LET g_action_choice="output"
##         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                  
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#     ON ACTION controlg
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
# 
#    ON ACTION accept
#      LET g_action_choice="detail"
#      LET l_ac = ARR_CURR()
#      EXIT DISPLAY
# 
#    ON ACTION cancel
#      LET INT_FLAG=FALSE 		
#      LET g_action_choice="exit"
#      EXIT DISPLAY
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
# 
#      ON ACTION about         
#         CALL cl_about()      
#            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#      ON ACTION controls                    
#           CALL cl_set_head_visible("","AUTO")  
#      ON ACTION related_document
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#  
#END FUNCTION
#No.TQC-AC0004  --End  
 
FUNCTION t252_menu()
 
   WHILE TRUE
      LET g_action_choice=''        
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "fixup1")
              #CALL t252_b1_fill(g_wc1)
              CALL t252_bp1("G")
         #No.TQC-AC0004  --Begin
         #WHEN (g_action_flag = "fixup2")
         #     CALL t252_b2_fill(g_wc2)
         #     CALL t252_bp2("G")
         #No.TQC-AC0004  --End  
      END CASE
      CASE g_action_choice
        #WHEN "CONfirm" #審核      #TQC-C80089 mark
         WHEN "confirm" #審核      #TQC-C80089 add                       
            IF cl_chk_act_auth() THEN
                  CALL t252_y()
            END IF
            
         WHEN "void" #作廢
            IF cl_chk_act_auth() THEN
                  CALL t252_v()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t252_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t252_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t252_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t252_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t252_x()
            END IF
#         WHEN "reproduce"
#            IF cl_chk_act_auth() THEN
#                  CALL t252_copy()
#            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               #No.TQC-AC0004  --Begin
               #  IF g_action_flag = "fixup2" THEN
               #     CALL t252_b2()
               #  ELSE
                     CALL t252_b1()
               #  END IF
               #No.TQC-AC0004  --End  
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t252_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvn),'','')
             END IF        
         WHEN "related_document"   
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rvm.rvm01) THEN
                  LET g_doc.column1 = "rvm01"
                  LET g_doc.value1 = g_rvm.rvm01
                  CALL cl_doc()
               END IF
            END IF   
        #FUN-BA0100 add begin-------------
         WHEN "fast_allocation"       
            IF cl_chk_act_auth() THEN
               CALL t252_allocation()
            END IF
        #FUN-BA0100 add end---------------
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t252_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CONSTRUCT BY NAME g_wc ON                               
#FUN-B30028 ----------------STA
#        rvm01,rvm02,rvm03,rvm04,rvm05,rvm06,rvm07,rvmmksg,                   
#        rvmconf,rvmcond,rvmconu,rvm900,rvmplant,rvm09,rvm08,
        rvm01,rvm02,rvm03,rvm04,rvm05,rvm06,rvm07,
        rvmconf,rvmcond,rvmconu,rvmplant,rvm09,rvm08,
#FUN-B30028 ----------------END
        rvmuser,rvmgrup,rvmmodu,rvmdate,rvmacti,rvmcrat
       ,rvmoriu,rvmorig                       #TQC-A30041 ADD
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rvm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvm01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvm01
                 NEXT FIELD rvm01
              WHEN INFIELD(rvm03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvm03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvm03
                 NEXT FIELD rvm03
              WHEN INFIELD(rvm05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvm05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvm05
                 NEXT FIELD rvm05
              WHEN INFIELD(rvmconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvmconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvmconu
                 NEXT FIELD rvmconu
              WHEN INFIELD(rvmplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvmplant
                 NEXT FIELD rvmplant
              OTHERWISE
                 EXIT CASE
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
    IF INT_FLAG THEN 
        RETURN
    END IF
    
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rvmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rvmgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND rvmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvmuser', 'rvmgrup')
    #End:FUN-980030
    LET g_wc1 = " 1=1"
    CONSTRUCT g_wc1 ON rvn02,rvn03,rvn04,rvn05,rvn06,rvn07,rvn08,rvn09,
                       rvn10,rvn11,rvn12,rvn13
                   FROM s_rvn[1].rvn02,s_rvn[1].rvn03,s_rvn[1].rvn04,s_rvn[1].rvn05,
                        s_rvn[1].rvn06,s_rvn[1].rvn07,s_rvn[1].rvn08,s_rvn[1].rvn09,
                        s_rvn[1].rvn10,s_rvn[1].rvn11,s_rvn[1].rvn12,s_rvn[1].rvn13
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rvn03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvn03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvn03
                 NEXT FIELD rvn03
              WHEN INFIELD(rvn09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvn09"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvn09
                 NEXT FIELD rvn09
              WHEN INFIELD(rvn13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvn13"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvn13
                 NEXT FIELD rvn13
              OTHERWISE
                 EXIT CASE
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
    
    IF INT_FLAG THEN 
        RETURN
    END IF
    #No.TQC-AC0004  --Begin
    #LET g_wc2 = " 1=1"
    #CONSTRUCT g_wc2 ON rvnn02,rvnn03,rvnn04,rvnn05,rvnn06,rvnn07
    #               FROM s_rvnn[1].rvnn02,s_rvnn[1].rvnn03,s_rvnn[1].rvnn04,s_rvnn[1].rvnn05,
    #                    s_rvnn[1].rvnn06,s_rvnn[1].rvnn07
    #   BEFORE CONSTRUCT
    #        CALL cl_qbe_display_condition(lc_qbe_sn)
    #        
    #    ON ACTION controlp
    #       CASE
    #          WHEN INFIELD(rvnn03)
    #             CALL cl_init_qry_var()
    #             LET g_qryparam.form = "q_rvnn03"
    #             LET g_qryparam.state = "c"
    #             CALL cl_create_qry() RETURNING g_qryparam.multiret
    #             DISPLAY g_qryparam.multiret TO rvnn03
    #             NEXT FIELD rvnn03
    #          OTHERWISE
    #             EXIT CASE
    #       END CASE
 
    #    ON IDLE g_idle_seconds
    #      CALL cl_on_idle()
    #      CONTINUE CONSTRUCT
 
    #    ON ACTION about         
    #      CALL cl_about()      
 
    #    ON ACTION help         
    #      CALL cl_show_help()
 
    #    ON ACTION controlg   
    #      CALL cl_cmdask() 
 
    #    ON ACTION qbe_save                        
    #      CALL cl_qbe_save()
    #    	
    #END CONSTRUCT
    #IF INT_FLAG THEN
    #   RETURN
    #END IF
    #No.TQC-AC0004  --End  
    LET g_wc1 = g_wc1 CLIPPED
    #No.TQC-AC0004  --Begin
    #LET g_wc2 = g_wc2 CLIPPED
    #No.TQC-AC0004  --End  
    LET g_sql = "SELECT rvm01 "
    LET g_sql1 = " FROM rvm_file"
#    LET g_sql2 = " WHERE rvm10='",g_rvm10,"' AND rvmplant IN ",g_auth," AND ",g_wc CLIPPED
    LET g_sql2 = " WHERE ",g_wc CLIPPED
    IF g_wc1 <> " 1=1" THEN     
         LET g_sql1 = g_sql1,",rvn_file "
         LET g_sql2 = g_sql2," AND rvm01 = rvn01 AND ",g_wc1 CLIPPED
    END IF
    #No.TQC-AC0004  --Begin
    #IF g_wc2 <> " 1=1"  THEN                               
    #     LET g_sql1 = g_sql1,",rvnn_file"
    #     LET g_sql2 = g_sql2," AND rvm01 = rvnn01 AND ",g_wc2 CLIPPED
    #END IF
    #No.TQC-AC0004  --End  
    LET g_sql = g_sql CLIPPED,g_sql1 CLIPPED,g_sql2 CLIPPED
    LET g_sql = g_sql," ORDER BY rvm01"
    PREPARE t252_prepare FROM g_sql
    DECLARE t252_cs SCROLL CURSOR WITH HOLD FOR t252_prepare
    LET g_sql = "SELECT COUNT(*) " 
    LET g_sql = g_sql CLIPPED,g_sql1 CLIPPED,g_sql2 CLIPPED
    PREPARE t252_precount FROM g_sql
    DECLARE t252_count CURSOR FOR t252_precount
END FUNCTION
 
FUNCTION t252_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rvn.clear()      
    #FUN-BA0100 add begin-----------------------
    CALL g_rvn1.clear()
    CALL g_rvn2.clear()
    #FUN-BA0100 add end-----------------------
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt
    
    CALL t252_cs()              
            
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rvm.* TO NULL
        CLEAR FORM
        CALL g_rvn.clear()
        #FUN-BA0100 add begin-----------------------
        CALL g_rvn1.clear()
        CALL g_rvn2.clear()
        #FUN-BA0100 add end-----------------------
        #No.TQC-AC0004  --Begin
        #CALL g_rvnn.clear()
        #No.TQC-AC0004  --End  
        RETURN
    END IF
    
    OPEN t252_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CLEAR FORM
        CALL g_rvn.clear()
        #FUN-BA0100 add begin-----------------------
        CALL g_rvn1.clear()
        CALL g_rvn2.clear()
        #FUN-BA0100 add end-----------------------
        #No.TQC-AC0004  --Begin
        #CALL g_rvnn.clear()
        #No.TQC-AC0004  --End  
    ELSE
        OPEN t252_count
        FETCH t252_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt                                 
           CALL t252_fetch('F') 
        ELSE 
           CALL cl_err('',100,0) 
           INITIALIZE g_rvm.* TO NULL
        END IF             
    END IF
END FUNCTION
 
FUNCTION t252_fetch(p_flrvm)
DEFINE p_flrvm         LIKE type_file.chr1           
    CASE p_flrvm
        WHEN 'N' FETCH NEXT     t252_cs INTO g_rvm.rvm01
        WHEN 'P' FETCH PREVIOUS t252_cs INTO g_rvm.rvm01
        WHEN 'F' FETCH FIRST    t252_cs INTO g_rvm.rvm01
        WHEN 'L' FETCH LAST     t252_cs INTO g_rvm.rvm01
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
                   LET g_jump = g_curs_index
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t252_cs INTO g_rvm.rvm01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rvm.rvm01,SQLCA.sqlcode,0)
        INITIALIZE g_rvm.* TO NULL
        RETURN
    ELSE
      CASE p_flrvm
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rvm.* FROM rvm_file    
     WHERE rvm01 = g_rvm.rvm01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rvm_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rvm.rvmuser           
        LET g_data_group=g_rvm.rvmgrup
        LET g_data_plant=g_rvm.rvmplant #TQC-A10128 ADD
        CALL t252_show()                   
    END IF
END FUNCTION
 
FUNCTION t252_rvm03(p_cmd) #配送中心        
DEFINE p_cmd LIKE type_file.chr1,   
       l_gem02 LIKE gem_file.gem02,
       l_gemacti LIKE gem_file.gemacti,
       l_obnacti LIKE obn_file.obnacti
          
   LET g_errno = ' '
   SELECT DISTINCT gem02,gemacti,obnacti
     INTO l_gem02,l_gemacti,l_obnacti
     FROM gem_file,obn_file 
    WHERE gem01 = obn06
      AND obn06 = g_rvm.rvm03
      AND obnacti = 'Y'
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-188' 
                                 LET l_gem02=NULL 
        WHEN l_gemacti='N'       LET g_errno='9028'   
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.rvm03_desc
  END IF
 
END FUNCTION
 
FUNCTION t252_rvm05(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_obn02 LIKE obn_file.obn02
DEFINE l_obnacti LIKE obn_file.obnacti
 
    LET g_errno = ''
    SELECT obn02,obnacti
      INTO l_obn02,l_obnacti
      FROM obn_file
     WHERE obn01 = g_rvm.rvm05
    CASE
      WHEN SQLCA.sqlcode=100 LET g_errno = 'art-559'
                             LET l_obn02 = NULL
      WHEN l_obnacti = 'N'   LET g_errno = '9028'
      OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_obn02 TO FORMONLY.rvm05_desc
    END IF
END FUNCTION
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_rvnn03()#來源單號+項次
#DEFINE l_obn05 LIKE obn_file.obn05
#DEFINE l_sql STRING
#DEFINE l_n LIKE type_file.num5
# 
#    LET l_sql = "SELECT DISTINCT ruc01,ruc04,ruc07",
#                "  FROM ruc_file ",
#                " WHERE ruc27 = '",g_rvm.rvm04,
#                "'  AND ruc08 = '",g_rvnn[l_ac].rvnn03,
#                "'  AND ruc09 = ",g_rvnn[l_ac].rvnn04
#    
#    PREPARE ruc_sel FROM l_sql
#    EXECUTE ruc_sel INTO g_rvnn[l_ac].rvnn05,g_rvnn[l_ac].rvnn06,
#                         g_rvnn[l_ac].ruc07
#      IF g_rvm.rvm06 = 'N' THEN
#       SELECT COUNT(*) INTO l_n
#         FROM obn_file,obo_file
#        WHERE obn01 = obo01
#          AND obn06 = g_rvm.rvm03 
#          AND obn08 = g_rvm.rvm05
#          AND obnacti = 'Y'
#          AND obo06 = g_rvnn[l_ac].rvnn05
#       IF l_n=0 THEN
#          INITIALIZE g_rvnn[l_ac].* TO NULL
#          LET g_errno = 'art-274'
#       END IF
#      END IF
#    IF cl_null(g_rvnn[l_ac].rvnn05) THEN
#       LET g_errno = 'art-244'
#    END IF
#    
#END FUNCTION
#No.TQC-AC0004  --End  
 
FUNCTION t252_ins_rvn13(p_rvn13,p_rvn12,p_rvn06)
DEFINE p_rvn13 LIKE rvn_file.rvn13  #多角貿易流程
DEFINE p_rvn12 LIKE rvn_file.rvn12  #出貨機構
DEFINE p_rvn06 LIKE rvn_file.rvn06  #需求機構
DEFINE l_poz01 LIKE poz_file.poz01
DEFINE l_poz01_max LIKE poz_file.poz01
DEFINE l_poz20 LIKE poz_file.poz20 #是否模版流程
DEFINE l_poy02_min LIKE poy_file.poy02  #多角貿易第一站
DEFINE l_poy02_max LIKE poy_file.poy02  #多角貿易最後站
DEFINE l_poy03 LIKE poy_file.poy03  #客戶編號
DEFINE l_n,l_cnt LIKE type_file.num5
DEFINE l_poy01 LIKE poy_file.poy01
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_occ01 LIKE occ_file.occ01
DEFINE l_poy04 LIKE poy_file.poy04
 
    LET g_errno=''
    SELECT poz20 INTO l_poz20
      FROM poz_file
     WHERE poz01 = p_rvn13
       AND poz00 = '2'
       AND pozacti = 'Y'
     
    IF l_poz20 = 'Y' THEN
          SELECT COUNT(*) INTO l_n
            FROM azw_file
           WHERE (azw01=p_rvn12 OR azw01=p_rvn06)
             AND azw02 IN (SELECT azw02 FROM azw_file,poy_file
                            WHERE azw01 = poy04
                              AND poy01 = p_rvn13)
          IF l_n>0 THEN
             LET p_rvn13 = ''
             LET g_errno = 'art-299'
             RETURN p_rvn13
          END IF
          SELECT COUNT(*) INTO l_cnt FROM poy_file
           WHERE poy01 = p_rvn13
          SELECT MIN(poy02) INTO l_poy02_min FROM poy_file
           WHERE poy01 = p_rvn13
          SELECT MAX(poy02) INTO l_poy02_max FROM poy_file
           WHERE poy01 = p_rvn13
 
          CASE l_cnt
             WHEN 2
            SELECT poz01 INTO l_poz01
              FROM poy_file a,poy_file b,poz_file
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = p_rvn06
               AND a.poy01 = b.poy01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND b.poy04 = p_rvn12
             WHEN 3
            SELECT poz01 INTO l_poz01
              FROM poy_file a,poy_file b,poy_file c,poz_file
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = p_rvn06
               AND a.poy01 = b.poy01
               AND b.poy01 = poz01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=b.poy01)
               AND b.poy04 = p_rvn12
               AND c.poy01 = b.poy01
               AND c.poy02 = (a.poy02+1)
               AND c.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13
                                 AND poy02 = c.poy02)
           WHEN 4
            SELECT poz01 INTO l_poz01
              FROM poy_file a,poy_file b,poy_file c,poy_file d,poz_file
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = p_rvn06
               AND a.poy01 = b.poy01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=b.poy01)
               AND b.poy04 = p_rvn12
               AND c.poy01 = b.poy01
               AND c.poy02 = a.poy02+1
               AND c.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13
                                 AND poy02 = c.poy02)
               AND c.poy01 = d.poy01
               AND d.poy02 = (c.poy02+1)
               AND d.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13 AND poy02 = d.poy02)
            WHEN 5
            SELECT poz01 INTO l_poz01
              FROM poy_file a,poy_file b,poy_file c,poy_file d,poy_file e,poz_file
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = p_rvn06
               AND a.poy01 = b.poy01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=b.poy01)
               AND b.poy04 = p_rvn12
               AND c.poy01 = b.poy01
               AND c.poy02 = (a.poy02+1)
               AND c.poy04 = (SELECT poy04 FROM poy_file
                               WHERE h.poy01 = p_rvn13 AND poy02 = c.poy02)
               AND c.poy01 = d.poy01
               AND d.poy02 = (c.poy02+1)
               AND d.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13 AND poy02 = d.poy02)
               AND e.poy01 = d.poy01
               AND e.poy02 = (d.poy02+1)
               AND e.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13 AND poy02 = e.poy02)
           WHEN 6
            SELECT poz01 INTO l_poz01
              FROM poy_file a,poy_file b,poy_file c,poy_file d,poy_file e,poy_file f,poz_file
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = p_rvn06
               AND a.poy01 = b.poy01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=b.poy01)
               AND b.poy04 = p_rvn12
               AND c.poy01 = b.poy01
               AND c.poy02 = (a.poy02+1)
               AND c.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13 AND poy02 = c.poy02)
               AND c.poy01 = d.poy01
               AND d.poy02 = (c.poy02+1)
               AND d.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13 AND poy02 = d.poy02)
               AND e.poy01 = d.poy01
               AND e.poy02 = (d.poy02+1)
               AND e.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13 AND poy02 = e.poy02)
               AND f.poy01 = e.poy01
               AND f.poy02 = (e.poy02+1)
               AND f.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = p_rvn13 AND poy02 = f.poy02)
            END CASE
            IF NOT cl_null(l_poz01) THEN
               RETURN l_poz01
            END IF
          INSERT INTO poz_temp SELECT * FROM poz_file WHERE poz01 = p_rvn13
          SELECT MAX(poz01) INTO l_poz01 FROM poz_file
           WHERE length(translate(poz01,'0123456789'||poz01,'0123456789'))=8
          IF cl_null(l_poz01) THEN
             LET l_poz01 = 0
          ELSE
             IF NOT cl_numchk(l_poz01,LENGTH(l_poz01)) THEN
                LET l_poz01 = 0
             END IF
          END IF
          LET l_poz01 = l_poz01 + 1
          LET l_poz01_max = l_poz01 USING '&&&&&&&&'
          UPDATE poz_temp SET poz01 = l_poz01_max,
                              poz20 = 'N',
                              poz21 = p_rvn13,
                              poz02 = p_rvn12||'--'||p_rvn06    #add by suncx MOD-B80228
          INSERT INTO poy_temp SELECT * FROM poy_file WHERE poy01 = p_rvn13
          UPDATE poy_temp SET poy01 = l_poz01_max
          SELECT poy04 INTO l_poy04 FROM poy_file 
           WHERE poy01=p_rvn13
             AND poy02=(SELECT MIN(poy02)+1 FROM poy_file WHERE poy01=p_rvn13)
          #CALL t252_azp(l_poy04) RETURNING l_dbs
          CALL t252_azp(p_rvn06) RETURNING l_dbs    #MOD-B80228
          #LET l_sql="SELECT occ01 FROM ",s_dbstring(l_dbs CLIPPED),"occ_file", #FUN-A50102
          #LET l_sql="SELECT occ01 FROM ",cl_get_target_table(l_poy04, 'occ_file'), #FUN-A50102
          LET l_sql="SELECT occ01 FROM ",cl_get_target_table(p_rvn06, 'occ_file'),   #MOD-B80228
                    " WHERE occ930 = ?"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
          #CALL cl_parse_qry_sql(l_sql, l_poy04) RETURNING l_sql    #FUN-A50102          
          CALL cl_parse_qry_sql(l_sql, p_rvn06) RETURNING l_sql    #MOD-B80228
          PREPARE occ_cs FROM l_sql
          EXECUTE occ_cs USING p_rvn06 INTO l_poy03
          IF SQLCA.sqlcode = 100 THEN
             CALL s_errmsg('rty05',p_rvn06,'','art-280',1)
          END IF  
          UPDATE poy_temp SET poy04 = p_rvn06,
                              poy03 = l_poy03,
                              poy05 = 'RMB',
                              poy20 = '3'
           WHERE poy04 = 'xxx'
          SELECT poy04 INTO l_poy04 FROM poy_file
           WHERE poy01=p_rvn13
             AND poy02=(SELECT MAX(poy02)-1 FROM poy_file WHERE poy01=p_rvn13)
          #CALL t252_azp(l_poy04) RETURNING l_dbs
          CALL t252_azp(p_rvn12) RETURNING l_dbs   #MOD-B80228
          #LET l_sql="SELECT pmc01 FROM ",s_dbstring(l_dbs CLIPPED),"pmc_file", #FUN-A50102
          #LET l_sql="SELECT pmc01 FROM ",cl_get_target_table(l_poy04, 'pmc_file'), #FUN-A50102
          LET l_sql="SELECT pmc01 FROM ",cl_get_target_table(p_rvn12, 'pmc_file'), #MOD-B80228
                    " WHERE pmc930 = ?"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
          #CALL cl_parse_qry_sql(l_sql, l_poy04) RETURNING l_sql    #FUN-A50102
          CALL cl_parse_qry_sql(l_sql, p_rvn12) RETURNING l_sql    #MOD-B80228
          PREPARE pmc_cs1 FROM l_sql
          EXECUTE pmc_cs1 USING p_rvn12 INTO l_poy03
          IF SQLCA.sqlcode = 100 THEN
             CALL s_errmsg('rty05',p_rvn12,'','art-312',1)
          END IF
          UPDATE poy_temp SET poy04  = p_rvn12,
                              poy03 = l_poy03,
                              poy05 = 'RMB',
                              poy20 = '3'
           WHERE poy04 = 'yyy'
          LET l_n=0     
          SELECT COUNT(azw01) INTO l_n
            FROM poy_temp,azw_file
           WHERE poy04=azw01
             AND poy01 = l_poz01_max  #No.FUN-960130
          HAVING COUNT(azw01)<>COUNT(DISTINCT azw02)
          IF l_n>0 THEN
             LET g_errno='art-598'
             RETURN ''
          END IF 
           INSERT INTO poz_file SELECT * FROM poz_temp
           IF SQLCA.sqlcode THEN
             CALL s_errmsg('poz01',p_rvn13,'INSERT INTO poz_file:',SQLCA.sqlcode,1)
           ELSE
             INSERT INTO poy_file SELECT * FROM poy_temp
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('poy01',p_rvn13,'INSERT INTO poy_file:',SQLCA.sqlcode,1)
             ELSE
                INSERT INTO pox_temp SELECT * FROM pox_file WHERE pox01 = p_rvn13
                UPDATE pox_temp SET pox01 = l_poz01_max
                INSERT INTO pox_file SELECT * FROM pox_temp
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('poy01',p_rvn13,'INSERT INTO poy_file:',SQLCA.sqlcode,1)
                END IF
             END IF                
           END IF
           DELETE FROM pox_temp  #No.FUN-9C0079
           DELETE FROM poy_temp  #No.FUN-9C0079
           DELETE FROM poz_temp  #No.FUN-9C0079
    ELSE
       SELECT COUNT(*) INTO l_n
         FROM poy_file a,poy_file b            
        WHERE a.poy01 = p_rvn13
          AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
          AND a.poy04 = p_rvn06
          AND a.poy01 = b.poy01
          AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=a.poy01) 
          AND b.poy04 = p_rvn12
       IF l_n=0 THEN
          LET g_errno = 'art-282'
          RETURN ''
       END IF
       LET l_n=0     
       SELECT COUNT(azw01) INTO l_n
         FROM azw_file,poy_file
        WHERE poy01 = p_rvn13
          AND poy04 = azw01
       HAVING COUNT(azw01)<>COUNT(DISTINCT azw02)
       IF l_n>0 THEN
          LET g_errno = 'art-598'
          RETURN ''
       END IF
    END IF
    SELECT poz01 INTO p_rvn13 FROM poz_temp
    RETURN p_rvn13
END FUNCTION 
 
FUNCTION t252_rvn13(p_rvn13,p_rvn12,p_rvn06)
DEFINE p_rvn13 LIKE rvn_file.rvn13  #多角貿易流程
DEFINE p_rvn12 LIKE rvn_file.rvn12  #出貨機構
DEFINE p_rvn06 LIKE rvn_file.rvn06  #需求機構
DEFINE l_n,l_n1,l_n2 LIKE type_file.num5
 
    LET g_errno = ''
 
    IF NOT cl_null(p_rvn13) THEN
        SELECT COUNT(DISTINCT poy04) INTO l_n1
         FROM poy_file,poz_file
        WHERE poy04 = p_rvn06
          AND poz01 = poy01
          AND poz01 = p_rvn13
          AND poz00 = '2'
          AND pozacti = 'Y'
          AND poy02 = (SELECT MIN(poy02) FROM poy_file,poz_file 
                                        WHERE poz01 = poy01
                                          AND poz01 = p_rvn13
                                          AND poz00 = '2'
                                          AND pozacti = 'Y')
       SELECT COUNT(DISTINCT poy04) INTO l_n2
         FROM poy_file,poz_file
        WHERE poy04 = p_rvn12
          AND poz01 = poy01
          AND poz01 = p_rvn13
          AND poz00 = '2'
          AND pozacti = 'Y'
          AND poy02 = (SELECT MAX(poy02) FROM poy_file,poz_file 
                                        WHERE poz01 = poy01
                                          AND poz01 = p_rvn13
                                          AND poz00 = '2'
                                          AND pozacti = 'Y')
       IF l_n1 = 0 OR l_n2 = 0 THEN
          LET g_errno = 'art-285'
          RETURN
       END IF
       LET l_n=0     
       SELECT COUNT(azw01) INTO l_n
         FROM azw_file,poy_file
        WHERE poy01 = p_rvn13
          AND poy04 = azw01
       HAVING COUNT(azw01)<>COUNT(DISTINCT azw02)
       IF l_n>0 THEN
          LET g_errno = 'art-598'
          RETURN 
       END IF
    END IF
END FUNCTION
 
FUNCTION t252_show()
DEFINE l_rvmconu_desc LIKE gen_file.gen02
DEFINE l_rvmplant_desc  LIKE azp_file.azp02
 
    LET g_rvm_t.* = g_rvm.*
    DISPLAY BY NAME g_rvm.rvm01,g_rvm.rvm02,g_rvm.rvm03,g_rvm.rvm04, g_rvm.rvmoriu,g_rvm.rvmorig,
                    g_rvm.rvm05,g_rvm.rvm06,g_rvm.rvm07,g_rvm.rvm09,g_rvm.rvmconf,
 #                   g_rvm.rvmcond,g_rvm.rvmconu,g_rvm.rvmmksg,g_rvm.rvm900,g_rvm.rvmplant,         #FUN-B30028 mark
                    g_rvm.rvmcond,g_rvm.rvmconu,g_rvm.rvmplant,                                     #FUN-B30028
                    g_rvm.rvm08,g_rvm.rvmuser,g_rvm.rvmgrup,g_rvm.rvmmodu,
                    g_rvm.rvmdate,g_rvm.rvmacti,g_rvm.rvmcrat
    CALL t252_rvm03('d')
    CALL t252_rvm05('d')
    CASE g_rvm.rvmconf
        WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
          CALL cl_set_act_visible('confirm,void',FALSE)
        WHEN "N"
          CALL cl_set_field_pic("","","","","",g_rvm.rvmacti)
          CALL cl_set_act_visible('confirm,void',TRUE)
        WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
          CALL cl_set_act_visible('confirm',FALSE)
    END CASE
    IF NOT cl_null(g_rvm.rvmconu) THEN
       SELECT gen02 INTO l_rvmconu_desc FROM gen_file 
          WHERE gen01=g_rvm.rvmconu AND genacti='Y'
       DISPLAY l_rvmconu_desc TO rvmconu_desc
    ELSE
       CLEAR rvmconu_desc
    END IF
    SELECT azp02 INTO l_rvmplant_desc
      FROM azp_file
     WHERE azp01 = g_rvm.rvmplant
    DISPLAY l_rvmplant_desc TO rvmplant_desc
    CALL cl_show_fld_cont()  
    #CALL t252_b1_fill(g_wc1) #FUN-BA0100 mark
    CALL t252_b_fill(g_wc1)   #FUN-BA0100 add
    #No.TQC-AC0004  --Begin
    #CALL t252_b2_fill(g_wc2)
    #No.TQC-AC0004  --End  
END FUNCTION
 
#FUNCTION t252_b1_fill(p_wc2)          #FUN-BA0100 mark
FUNCTION t252_b1_fill(p_rvn09)   #FUN-BA0100 add
DEFINE   p_wc2     STRING,
         p_rvn09   LIKE rvn_file.rvn09 #FUN-BA0100 add    

    #FUN-BA0100 MARK BEGIN---------------------------
    #LET g_start = CURRENT MINUTE TO FRACTION(5)
    #TRUNCATE TABLE cs_rvn_temp
    #LET g_sql = "INSERT INTO cs_rvn_temp ",
    #            "SELECT rvn01,rvn02,rvn03,rvn04,rvn05,rvn06,' ',rvn07,",
    #            "' ',rvn08,rvn09,'','','','','',",
    #            "'',rvn10,rvn11,'',rvn12,' ','',rvn13,rvnplant,'','',''",
    #            "  FROM rvn_file",
    #            " WHERE rvn01='",g_rvm.rvm01 CLIPPED,"'"
    #IF NOT cl_null(p_wc2) THEN
    #  LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    #END IF
    #EXECUTE IMMEDIATE g_sql
    #IF SQLCA.sqlcode THEN
    #   CALL cl_err('ins cs_rvn_temp',SQLCA.sqlcode,0)
    #   RETURN
    #END IF
    #LET g_sql = "UPDATE cs_rvn_temp a",
    #            "   SET (ruc07,ruc08,ruc09,ruc16,ruc18,ruc18_01,ruc29) = ",
    #            "       (SELECT ruc07,ruc08,ruc09,ruc16,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0),ruc29",
    #            "          FROM ruc_file ",
    #            "         WHERE ruc00 = '1' AND ruc01 = a.rvn06 ",
    #            #"           AND ruc02 = a.rvn03 AND ruc03 = a.rvn04 AND rucplant = a.rvn06)"#No.FUN-9C0069
    #            "           AND ruc02 = a.rvn03 AND ruc03 = a.rvn04 )" #No.FUN-9C0069
    #            
    #EXECUTE IMMEDIATE g_sql
    #LET g_sql = "UPDATE cs_rvn_temp a",
    #            "   SET (ima02,ima131) = (SELECT ima02,ima131 FROM ima_file",
    #            "                          WHERE ima01 = a.rvn09),",
    #            "       rvn11_desc = (SELECT imd02 FROM imd_file",
    #            "                 WHERE imd01 = a.rvn11 AND imd11 = 'Y'),",
    #            "       gfe02 = (SELECT gfe02 FROM gfe_file",
    #            "                 WHERE gfe01 = a.ruc16)"
    #EXECUTE IMMEDIATE  g_sql
    #LET g_sql = "UPDATE cs_rvn_temp a",
    #            "   SET rvn06_desc = (SELECT azp02 FROM azp_file WHERE azp01 = a.rvn06),",
    #            "       rvn12_desc = (SELECT azp02 FROM azp_file WHERE azp01 = a.rvn12)"
    #EXECUTE IMMEDIATE g_sql
    #
    #LET g_sql = "UPDATE cs_rvn_temp a",
    #            "   SET rvn07_desc = (SELECT azp02 FROM azp_file WHERE azp01 = a.rvn07)",
    #            " WHERE rvn07 IS NOT NULL "
    #EXECUTE IMMEDIATE g_sql
    #FUN-BA0100 MARK END---------------------------
 
    LET g_sql = "SELECT rvn02,rvn03,rvn04,rvn05,rvn06,'',rvn07,",
                "       '',rvn08,rvn09,'','',ruc16,'',COALESCE(ruc18,0),",
                "       COALESCE(ruc18,0)-COALESCE(ruc20,0),rvn10,rvn11,'',rvn12,",
                "       '',ruc29,rvn13",
                "  FROM rvn_file,ruc_file",
                " WHERE rvn01='",g_rvm.rvm01 CLIPPED,"' AND ruc00 = '1' ",
                "   AND ruc01 = rvn06 AND ruc02 = rvn03 AND ruc03 = rvn04",
                "   AND rvn09='",p_rvn09 CLIPPED,"'"

    DECLARE rvn_cs CURSOR FROM g_sql
    CALL g_rvn.clear()
    CALL att.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rvn_cs INTO g_rvn[g_cnt].*  
        SELECT ima02,ima131 INTO g_rvn[g_cnt].ima02,g_rvn[g_cnt].ima131
          FROM ima_file
         WHERE ima01 = g_rvn[g_cnt].rvn09
         
        SELECT imd02 INTO g_rvn[g_cnt].rvn11_desc FROM imd_file
         WHERE imd01 = g_rvn[g_cnt].rvn11 AND imd11 = 'Y'
         
        SELECT gfe02 INTO g_rvn[g_cnt].ruc16_desc FROM gfe_file
         WHERE gfe01 = g_rvn[g_cnt].ruc16
         
        SELECT azp02 INTO g_rvn[g_cnt].rvn06_desc FROM azp_file 
         WHERE azp01 = g_rvn[g_cnt].rvn06
         
        SELECT azp02 INTO g_rvn[g_cnt].rvn12_desc FROM azp_file 
         WHERE azp01 = g_rvn[g_cnt].rvn12
        
        SELECT azp02 INTO g_rvn[g_cnt].rvn07_desc FROM azp_file 
         WHERE azp01 = g_rvn[g_cnt].rvn07

        IF g_rvn[g_cnt].ruc18_01 < g_rvn[g_cnt].rvn10 AND g_rvm.rvmconf = 'N' THEN
           LET att[g_cnt].rvn02      = "red reverse"
           LET att[g_cnt].rvn03      = "red reverse"
           LET att[g_cnt].rvn04      = "red reverse"
           LET att[g_cnt].rvn05      = "red reverse"
           LET att[g_cnt].rvn06      = "red reverse"
           LET att[g_cnt].rvn06_desc = "red reverse"
           LET att[g_cnt].rvn07      = "red reverse"
           LET att[g_cnt].rvn07_desc = "red reverse"
           LET att[g_cnt].rvn08      = "red reverse"
           LET att[g_cnt].rvn09      = "red reverse"
           LET att[g_cnt].ima02      = "red reverse"
           LET att[g_cnt].ima131     = "red reverse"
           LET att[g_cnt].ruc16      = "red reverse"
           LET att[g_cnt].ruc16_desc = "red reverse"
           LET att[g_cnt].ruc18      = "red reverse"
           LET att[g_cnt].ruc18_01   = "red reverse"
           LET att[g_cnt].rvn10      = "red reverse"
           LET att[g_cnt].rvn11      = "red reverse"
           LET att[g_cnt].rvn11_desc = "red reverse"
           LET att[g_cnt].rvn12      = "red reverse"
           LET att[g_cnt].rvn12_desc = "red reverse"
           LET att[g_cnt].ruc29      = "red reverse"
           LET att[g_cnt].rvn13      = "red reverse"
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
    LET g_cnt = 0
    #FUN-BA0100 MARK BEGIN---------------------------
    #LET g_end = CURRENT MINUTE TO FRACTION(5)
    #LET g_interval = g_end - g_start
    #DISPLAY "INFO: b1_fill used ",g_interval," seconds."
    #FUN-BA0100 MARK END---------------------------
END FUNCTION

#FUN-BA0100 add begin-----------------------
FUNCTION t252_b_fill(p_wc2)
DEFINE   p_wc2  STRING 
DEFINE   l_n    LIKE type_file.num10
DEFINE   l_sql  STRING
DEFINE   l_rvn12 LIKE rvn_file.rvn12
DEFINE   l_rvn11 LIKE rvn_file.rvn11
DEFINE   l_img10 LIKE img_file.img10
DEFINE   l_img10_s LIKE img_file.img10

    LET g_sql = "SELECT DISTINCT rvn09,ima02,ima25,'',SUM(ruc18),SUM(ruc18)-SUM(ruc20),SUM(ruc20),0",
                "  FROM ruc_file,rvn_file LEFT JOIN ima_file ON ima01 = rvn09",
                " WHERE rvn01='",g_rvm.rvm01 CLIPPED,"'",
                "   AND ruc00 = '1' AND ruc01 = rvn06",
                "   AND ruc02 = rvn03 AND ruc03 = rvn04"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," GROUP BY rvn09,ima02,ima25"
    DECLARE rvn1_cs CURSOR FROM g_sql
    CALL g_rvn1.clear()
    CALL g_rvn2.clear()
    CALL g_rvn.clear()
    LET l_n = 1
    FOREACH rvn1_cs INTO g_rvn1[l_n].*  
        SELECT gfe02 INTO g_rvn1[l_n].gfe02
          FROM gfe_file 
         WHERE gfe01 = g_rvn1[l_n].ima25
        LET g_sql = "SELECT DISTINCT rvn12,rvn11",
                    "  FROM rvn_file ",
                    " WHERE rvn09 = '",g_rvn1[l_n].rvn09,"'",
                    "   AND rvn01='",g_rvm.rvm01 CLIPPED,"'"
        IF NOT cl_null(p_wc2) THEN
           LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
        END IF
        DECLARE rvn12_cs CURSOR FROM g_sql
        LET l_img10_s = 0
        FOREACH rvn12_cs INTO l_rvn12,l_rvn11
           LET l_sql = "SELECT SUM(img10) ",
                       "  FROM ",cl_get_target_table(l_rvn12,'img_file'),
                       " WHERE img01 = '",g_rvn1[l_n].rvn09,"'",
                       "   AND imgplant = '",l_rvn12,"' AND img02='",l_rvn11,"'"
           PREPARE sel_img10 FROM l_sql
           EXECUTE sel_img10 INTO l_img10
           IF cl_null(l_img10) THEN LET l_img10 = 0 END IF 
           LET l_img10_s = l_img10_s + l_img10
        END FOREACH
        LET g_rvn1[l_n].img10 = l_img10_s

        LET l_n = l_n + 1
        IF l_n > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvn1.deleteElement(l_n)
    IF NOT cl_null(g_rvn1[1].rvn09) THEN
       CALL t252_b1_fill(g_rvn1[1].rvn09)
       CALL t252_b2_fill(g_rvn1[1].rvn09)
    END IF
END FUNCTION

FUNCTION t252_b2_fill(p_rvn09)
DEFINE   p_rvn09   LIKE rvn_file.rvn09
DEFINE   l_n       LIKE type_file.num10
DEFINE   l_sql     STRING
DEFINE   l_rvn12   LIKE rvn_file.rvn12
DEFINE   l_img10   LIKE img_file.img10
DEFINE   l_img10_s LIKE img_file.img10

    LET g_sql = "SELECT DISTINCT rvn11,'',SUM(ruc18),0",
                "  FROM rvn_file LEFT JOIN ima_file ON ima01 = rvn09,ruc_file",
                " WHERE rvn01='",g_rvm.rvm01 CLIPPED,"'",
                "   AND ruc00 = '1' AND rvn09 = '",p_rvn09,"'",
                "   AND ruc01 = rvn06 AND ruc02 = rvn03 AND ruc03 = rvn04",
                " GROUP BY rvn11"
    DECLARE rvn2_cs CURSOR FROM g_sql
    CALL g_rvn2.clear()
    LET l_n = 1
    FOREACH rvn2_cs INTO g_rvn2[l_n].* 
        LET g_sql = "SELECT DISTINCT rvn12,rvn11",
                    "  FROM rvn_file ",
                    " WHERE rvn09 = '",p_rvn09,"'",
                    "   AND rvn01='",g_rvm.rvm01 CLIPPED,"'",
                    "   AND rvn11 = '",g_rvn2[l_n].rvn11,"'"
        DECLARE rvn12_cs1 CURSOR FROM g_sql
        LET l_img10_s = 0
        FOREACH rvn12_cs1 INTO l_rvn12
           LET l_sql = "SELECT SUM(img10) ",
                       "  FROM ",cl_get_target_table(l_rvn12,'img_file'),
                       " WHERE img01 = '",p_rvn09,"'",
                       "   AND img02 = '",g_rvn2[l_n].rvn11,"'",
                       "   AND imgplant = '",l_rvn12,"'"
           PREPARE sel_img10_1 FROM l_sql
           EXECUTE sel_img10_1 INTO l_img10
           IF cl_null(l_img10) THEN LET l_img10 = 0 END IF 
           LET l_img10_s = l_img10_s + l_img10
        END FOREACH
        LET g_rvn2[l_n].img10_1 = l_img10_s
        SELECT imd02 INTO g_rvn2[l_n].imd02 FROM imd_file
         WHERE imd01 = g_rvn2[l_n].rvn11 AND imd11 = 'Y'
        LET l_n = l_n + 1
        IF l_n > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvn2.deleteElement(l_n)
END FUNCTION
#FUN-BA0100 add end-------------------------

#No.TQC-AC0004  --Begin
#FUNCTION t252_b2_fill(p_wc2)              
#DEFINE   p_wc2       STRING      
#DEFINE   l_sql STRING  
#DEFINE   l_dbs LIKE azp_file.azp03
#DEFINE   l_rvnn05 LIKE rvnn_file.rvnn05
##DEFINE   l_pcab00 LIKE b_pcab.pcab00
# 
#    LET g_start = CURRENT MINUTE TO FRACTION(5)
#    TRUNCATE TABLE cs_rvnn_temp
#    LET l_sql = "INSERT INTO cs_rvnn_temp ",
#                "(rvnn01,rvnn02,rvnn03,rvnn04,rvnn05,rvnn06,rvnn07,rvnnlegal,rvnnplant)",
#                " SELECT rvnn_file.* FROM rvnn_file",
#                "  WHERE rvnn01='",g_rvm.rvm01 CLIPPED,"'"
#    IF NOT cl_null(p_wc2) THEN
#      LET l_sql=l_sql CLIPPED," AND ",p_wc2 CLIPPED
#    END IF
#    EXECUTE IMMEDIATE l_sql
#    LET l_sql = "UPDATE cs_rvnn_temp a",
#                "   SET ruc07 = (SELECT DISTINCT b.ruc07 FROM cs_rvn_temp b",
#                "                 WHERE b.ruc08 = a.rvnn03",
#                "                   AND b.ruc09 = a.rvnn04",
#                "                   AND b.rvn06 = a.rvnn05)"
#    EXECUTE IMMEDIATE l_sql
#    LET l_sql = "UPDATE cs_rvnn_temp a",
#                "   SET (ruc16,ruc18) = (SELECT ruc16,ruc18 FROM cs_rvn_temp b",
#                "                         WHERE b.ruc08 = a.rvnn03",
#                "                           AND b.ruc09 = a.rvnn04",
#                "                           AND b.rvn06 = a.rvnn05)",
#                " WHERE ruc07 <> '5' AND ruc07 <> '6'"
#    EXECUTE IMMEDIATE l_sql
#    DECLARE pcnm_cs_b CURSOR FOR SELECT DISTINCT rvnn05 FROM cs_rvnn_temp
#    FOREACH pcnm_cs_b INTO l_rvnn05
##      SELECT pcab00 INTO l_pcab00 FROM b_pcab
##       WHERE pcab01 = l_rvnn05
##      LET l_sql = "UPDATE cs_rvnn_temp a",
##                  "   SET (ruc16,ruc18) =  (SELECT pcno06,pcno07",
##                  "                                 FROM ",s_dbstring(l_pcab00 CLIPPED),"u_pcno",
##                  "                                WHERE pcno00 = a.rvnn05",
##                  "                                  AND pcno01 = a.rvnn03",
##                  "                                  AND pcno02 = a.rvnn04",
##                  "                                  AND pcnoconf = 'Y')",
##                 " WHERE ruc07 = '5'",
##                  "   AND rvnn05 = '",l_rvnn05,"'"
##      EXECUTE IMMEDIATE l_sql
#    END FOREACH
#    #No.FUN-9C0079 ..begin
#    #LET l_sql = "SELECT DISTINCT azp03 FROM azp_file ",
#    #            " WHERE azp01 = (SELECT DISTINCT azw07 FROM azw_file,cs_rvnn_temp ",
#    #            "                 WHERE azw01 = rvnn05)"
#    LET l_sql = " SELECT DISTINCT azw07 FROM azw_file,cs_rvnn_temp ",
#                "                 WHERE azw01 = rvnn05 "
#    DECLARE cs_rvnn_sel CURSOR FROM l_sql
#    #FOREACH cs_rvnn_sel INTO l_dbs
#    FOREACH cs_rvnn_sel INTO g_plant_new
#    CALL s_gettrandbs()
#    LET l_dbs=g_dbs_tra
#    #No.FUN-9C0079 ..end
#    LET l_sql = "UPDATE cs_rvnn_temp a",
#                #"   SET (ruc16,ruc18) = (SELECT rug04,rug05 FROM ",s_dbstring(l_dbs CLIPPED),"rug_file", #FUN-A50102
#                "   SET (ruc16,ruc18) = (SELECT rug04,rug05 FROM ",cl_get_target_table(g_plant_new, 'rug_file'), #FUN-A50102
#                "                         WHERE rug01 = a.rvnn03",
#                "                           AND rug02 = a.rvnn04)",
#                " WHERE ruc07 = '6'"
#    EXECUTE IMMEDIATE l_sql
#    END FOREACH
#    LET l_sql = "UPDATE cs_rvnn_temp a",
#                "   SET (ima02,ima131) = (SELECT ima02,ima131 FROM ima_file WHERE ima01 = a.rvnn06)"
#    EXECUTE IMMEDIATE l_sql
#    LET l_sql = "UPDATE cs_rvnn_temp a",
#                "   SET rvnn05_desc = (SELECT azp02 FROM azp_file WHERE azp01 = a.rvnn05)"
#    EXECUTE IMMEDIATE l_sql
#    LET l_sql = "UPDATE cs_rvnn_temp a",
#                "   SET gfe02 = (SELECT gfe02 FROM gfe_file WHERE gfe01 = a.ruc16)"
#    EXECUTE IMMEDIATE l_sql
#    LET l_sql = "UPDATE cs_rvnn_temp a",
#                "   SET ruc18_01 = ruc18*(SELECT AVG(ruc18_01/ruc18) FROM cs_rvn_temp ",
#                "                          WHERE ruc08 = a.rvnn03",
#                "                            AND ruc09 = a.rvnn04",
#                "                            AND rvn06 = a.rvnn05)"
#    EXECUTE IMMEDIATE l_sql
#    LET l_sql = "SELECT rvnn02,rvnn03,rvnn04,ruc07,rvnn05,rvnn05_desc,rvnn06,",
#                "ima02,ima131,ruc16,gfe02,ruc18,ruc18_01,rvnn07",
#                "  FROM cs_rvnn_temp ORDER BY rvnn02"
#    DECLARE rvnn_cs CURSOR FROM l_sql
#    CALL g_rvnn.clear()
#    LET g_cnt = 1
#    MESSAGE "Searching!"
#    FOREACH rvnn_cs INTO g_rvnn[g_cnt].*  
#        LET g_cnt = g_cnt + 1
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
#           EXIT FOREACH
#        END IF
#    END FOREACH
#    CALL g_rvnn.deleteElement(g_cnt)
#    MESSAGE ""
#    LET g_rec_b2 = g_cnt-1
#    DISPLAY g_rec_b2 TO FORMONLY.cn2
#    LET g_cnt = 0
#    LET g_end = CURRENT MINUTE TO FRACTION(5)
#    LET g_interval = g_end - g_start
#    DISPLAY "INFO: b2_fill used ",g_interval," seconds."
#END FUNCTION
#No.TQC-AC0004  --End  
 
FUNCTION t252_i_init()
DEFINE l_rvmplant_desc LIKE azp_file.azp02  #機構名稱
      LET g_rvm.rvmuser = g_user
      LET g_rvm.rvmoriu = g_user #FUN-980030
      LET g_rvm.rvmorig = g_grup #FUN-980030
      LET g_data_plant =g_plant  #TQC-A10128 ADD
      LET g_rvm.rvmgrup = g_grup
      LET g_rvm.rvmcrat = g_today
      LET g_rvm.rvmacti = 'Y'
      
      LET g_rvm.rvm02 = g_today  #單据日期
      LET g_rvm.rvm06 = 'N'      #臨時路線
      LET g_rvm.rvm07 = 'Y'      #自動派車
      LET g_rvm.rvmconf = 'N'    #審核碼
#      LET g_rvm.rvmmksg = 'Y'    #簽核               #FUN-B30028 mark
      LET g_rvm.rvmmksg = 'N'                         #FUN-B30028
      LET g_rvm.rvm900 = '0'     #開立
      LET g_rvm.rvmplant = g_plant CLIPPED #當前機構
      SELECT azp02 INTO l_rvmplant_desc 
        FROM azp_file
       WHERE azp01 = g_plant
      SELECT azw02 INTO g_rvm.rvmlegal FROM azw_file WHERE azw01 = g_plant
      DISPLAY BY NAME g_rvm.rvmuser,g_rvm.rvmgrup,g_rvm.rvmcrat,
#                      g_rvm.rvmacti,g_rvm.rvmconf,g_rvm.rvm900,            #FUN-B30028 mark
                      g_rvm.rvmacti,g_rvm.rvmconf,                          #FUN-B30028
                      g_rvm.rvmplant,g_rvm.rvmoriu,g_rvm.rvmorig            #TQC-A30041 ADD
      DISPLAY l_rvmplant_desc TO rvmplant_desc
END FUNCTION
 
FUNCTION t252_a()
DEFINE li_result LIKE type_file.num5
DEFINE l_n LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rvn.clear()
   #FUN-BA0100 add begin-----------------------
   CALL g_rvn1.clear()
   CALL g_rvn2.clear()
   #FUN-BA0100 add end-----------------------
   LET g_wc = NULL 
   #No.TQC-AC0004  --Begin
   #LET g_wc2= NULL 
   #No.TQC-AC0004  --End  
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rvm.* LIKE rvm_file.*                  
 
   LET g_rvm_t.* = g_rvm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
                          
      CALL t252_i_init()
     #LET g_rvm.rvm06='Y'   #TQC-AC0311 #TQC-B40098
      LET g_rvm.rvm06='N'   #TQC-B40098 Mod
      LET g_rvm.rvm07='N'   #TQC-AC0311
      CALL t252_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rvm.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rvm.rvm01) THEN       
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("art",g_rvm.rvm01,g_today,"3","rvm_file","rvm01","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rvm.rvm01,g_today,"I2","rvm_file","rvm01","","","") #FUN-A70130 mod
          RETURNING li_result,g_rvm.rvm01
      IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
      END IF
      DISPLAY BY NAME g_rvm.rvm01
      LET g_rvm.rvmoriu = g_user      #No.FUN-980030 10/01/04
      LET g_rvm.rvmorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO rvm_file VALUES (g_rvm.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","rvm_file",g_rvm.rvm01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rvm.* FROM rvm_file
       WHERE rvm01 = g_rvm.rvm01
 
      LET g_rvm_t.* = g_rvm.*
      CALL g_rvn.clear()
      #FUN-BA0100 add begin-----------------------
      CALL g_rvn1.clear()
      CALL g_rvn2.clear()
      #FUN-BA0100 add end-----------------------
      #No.TQC-AC0004  --Begin
      #CALL g_rvnn.clear()
      #No.TQC-AC0004  --End  
      IF g_rvm.rvm06 = 'N' THEN
         IF cl_confirm("art-221") THEN
            CALL t252_b_create()
            IF g_success = 'Y' THEN
               COMMIT WORK
            ELSE
               CALL s_showmsg()
               ROLLBACK WORK
               CALL t252_delall()
               INITIALIZE g_rvm.* TO NULL      #TQC-C80087 add
               CLEAR FORM                      #TQC-C80087 add
               RETURN
            END IF
            #CALL t252_b1_fill(" 1=1")  #FUN-BA0100
            CALL t252_b_fill(" 1=1")    #FUN-BA0100
            #No.TQC-AC0004  --Begin
            #CALL t252_b2_fill(" 1=1")
            #No.TQC-AC0004  --End  
            LET l_ac = 1
         #No.TQC-AC0004  --Begin
         #ELSE
         #   LET g_rec_b2 = 0
         #No.TQC-AC0004  --End  
         END IF
      #No.TQC-AC0004  --Begin
      #ELSE
      #   LET g_rec_b2 = 0
      #No.TQC-AC0004  --End  
      ELSE                            #TQC-AC0311
         CALL t252_b1()               #TQC-AC0311
      END IF
      #No.TQC-AC0004  --Begin
      #CALL t252_b2()
      #No.TQC-AC0004  --End  
      EXIT WHILE
   END WHILE
   CALL cl_set_act_visible('confirm,void',TRUE)
END FUNCTION
 
FUNCTION t252_b_create()
DEFINE l_sql STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_rvn13,l_rvn13_t LIKE rvn_file.rvn13
DEFINE l_wc STRING
DEFINE l_rvn06 LIKE rvn_file.rvn06
DEFINE l_rvn12 LIKE rvn_file.rvn12
#MOD-B80222 add begin------------
DEFINE l_rvn01   LIKE rvn_file.rvn01
DEFINE l_rvn02   LIKE rvn_file.rvn02
DEFINE l_rvn03   LIKE rvn_file.rvn03
DEFINE l_rvn04   LIKE rvn_file.rvn04
DEFINE l_rvn10   LIKE rvn_file.rvn10
DEFINE l_rvn10_s LIKE rvn_file.rvn10
#MOD-B80222 add end--------------
#No.TQC-AC0004  --Begin
#DEFINE l_rvnn05 LIKE rvnn_file.rvnn05
#No.TQC-AC0004  --End  
#DEFINE l_pcab00 LIKE b_pcab.pcab00
DEFINE l_azp03 LIKE azp_file.azp03
DEFINE l_n LIKE type_file.num5
 
   LET g_success = 'Y'
   DROP TABLE poz_temp
   DROP TABLE poy_temp
   DROP TABLE pox_temp
   DROP TABLE rvn_temp
   #No.TQC-AC0004  --Begin
   #DROP TABLE rvnn_temp
   #No.TQC-AC0004  --End  
   SELECT * FROM poz_file WHERE 1=0 INTO TEMP poz_temp
   SELECT * FROM poy_file WHERE 1=0 INTO TEMP poy_temp
   SELECT * FROM pox_file WHERE 1=0 INTO TEMP pox_temp
   #No.FUN-9C0088 ...begin
   #SELECT ruc08 rvnn01,ruc09 rvnn02,rvnn03,rvnn04,rvnn05,
   #       #rvnn06,rvnn07,ruclegal rvnnlegal,rucplant rvnnplant, #No.FUN-9C0069
   #       rvnn06,rvnn07,rvnnlegal,rvnnplant,  #No.FUN-9C0069
   #       ruc07,rvn07,rvn11,rvn12,ima131,ruc18
   #  FROM rvnn_file,rvn_file,ruc_file,ima_file
   # WHERE 1=0 INTO TEMP rvnn_temp
   #No.TQC-AC0004  --Begin
   #CREATE TEMP TABLE rvnn_temp(
   # rvnn01    LIKE rvnn_file.rvnn01,
   # rvnn02    LIKE rvnn_file.rvnn02,
   # rvnn03    LIKE rvnn_file.rvnn03,
   # rvnn04    LIKE rvnn_file.rvnn04,
   # rvnn05    LIKE rvnn_file.rvnn05,
   # rvnn06    LIKE rvnn_file.rvnn06,
   # rvnn07    LIKE rvnn_file.rvnn07,
   # rvnnlegal LIKE rvnn_file.rvnnlegal,
   # rvnnplant LIKE rvnn_file.rvnnplant,
   # ruc07     LIKE ruc_file.ruc07,
   # rvn07     LIKE rvn_file.rvn07,
   # rvn11     LIKE rvn_file.rvn11,
   # rvn12     LIKE rvn_file.rvn12,
   # ima131    LIKE ima_file.ima131,
   # ruc18     LIKE ruc_file.ruc18);
   ##No.FUN-9C0088 ...end
   #CREATE UNIQUE INDEX rvnn_temp_pk ON rvnn_temp(rvnn03,rvnn04,rvnn05)
   #No.TQC-AC0004  --End  
 
   DISPLAY "START TIME :",TIME
   #No.FUN-9C0088 ..begin.
   #LET l_sql = "SELECT ruc02 rvn01,ruc03 rvn02,ruc02 rvn03,ruc03 rvn04,",
   #            "ruc28 rvn05,ruc01 rvn06,ruc06 rvn07,ruc06 rvn08,",
   #            "ruc04 rvn09,ruc18 rvn10,",
   #            #"ruc06 rvn11,ruc06 rvn12,ruc06 rvn13,ruclegal rvnlegal,rucplant rvnplant,",#No.FUN-9C0069
   #            "ruc06 rvn11,ruc06 rvn12,ruc06 rvn13,rvnlegal,rvnplant,", #No.FUN-9C0069
   #            "ruc07,ruc08,ruc09,ruc18,ima131",
   #            "  FROM ruc_file,ima_file,rvn_file WHERE 1 = 0 INTO TEMP rvn_temp" #No.FUN-9C0079 rvn_file
   #PREPARE rvn_temp_cr FROM l_sql
   #EXECUTE rvn_temp_cr
   CREATE TEMP TABLE rvn_temp(
    rvn01    LIKE rvn_file.rvn01,
    rvn02    LIKE rvn_file.rvn02,
    rvn03    LIKE rvn_file.rvn03,
    rvn04    LIKE rvn_file.rvn04,
    rvn05    LIKE rvn_file.rvn05,
    rvn06    LIKE rvn_file.rvn06,
    rvn07    LIKE rvn_file.rvn07,
    rvn08    LIKE rvn_file.rvn08,
    rvn09    LIKE rvn_file.rvn09,
    rvn10    LIKE rvn_file.rvn10,
    rvn11    LIKE rvn_file.rvn11,
    rvn12    LIKE rvn_file.rvn12,
    rvn13    LIKE rvn_file.rvn13,
    rvnlegal LIKE rvn_file.rvnlegal,
    rvnplant LIKE rvn_file.rvnplant,
    ruc07     LIKE ruc_file.ruc07,
    ruc08     LIKE ruc_file.ruc08,
    ruc09     LIKE ruc_file.ruc09,
    ruc18     LIKE ruc_file.ruc18,
    ima131    LIKE ima_file.ima131);
   #No.FUN-9C0088 ..end.
   
   LET l_sql = "INSERT INTO rvn_temp ",
               "SELECT ruc02,ruc03,ruc02 rvn03,ruc03 rvn04,",
  #             "ruc28 rvn05,ruc01 rvn06,ruc06 rvn07,ruc06 rvn08,",          #TQC-AC0230  mark
               "ruc28 rvn05,ruc01 rvn06,ruc06 rvn07,'' rvn08,",              #TQC-AC0230        
               "ruc04 rvn09,(COALESCE(ruc18,0)-COALESCE(ruc20,0)) rvn10,",
               #"ruc06 rvn11,ruc06 rvn12,ruc06 rvn13,ruclegal rvnlegal,rucplant rvnplant,",
  #             "ruc06 rvn11,ruc06 rvn12,ruc06 rvn13,azw02 rvnlegal,ruc01 rvnplant,",    #TQC-AC0230  mark
               "ruc06 rvn11,ruc06 rvn12,'' rvn13,azw02 rvnlegal,ruc01 rvnplant,",        #TQC-AC0230
               "ruc07,ruc08,ruc09,ruc18,''",
               "  FROM ruc_file,azw_file ", #No.FUN-9C0069
               " WHERE ruc06 IN (SELECT obo06 FROM obo_file,obn_file",
               "                  WHERE obn06 = '",g_rvm.rvm03,"'",
               "                    AND obn01 = '",g_rvm.rvm05,"'",
               "                    AND obnacti = 'Y'",
               "                    AND obn01 = obo01)",
               "   AND ruc01 = azw01 ",     #No.FUN-9C0069
               "   AND ruc00 = '1'",
               "   AND ruc12 = '3'",
               "   AND ruc22 IS NULL",
               "   AND ruc32 IS NULL", #FUN-CC0057
               "   AND ruc26 = '",g_rvm.rvm03,"'",
               "   AND ruc27 = '",g_rvm.rvm04,"'"
#TQC-AC0230 ----------------STA
#    EXECUTE IMMEDIATE l_sql
    PREPARE rvn_tmp_ins FROM l_sql
    EXECUTE rvn_tmp_ins
    FREE rvn_tmp_ins
#TQC-AC0230 ----------------END
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL cl_err('ins pmk_temp',SQLCA.sqlcode,0)
       RETURN
    END IF 
   #送貨上門且取貨機構為空,也需插入
   LET l_sql = "INSERT INTO rvn_temp ",
               "SELECT ruc02,ruc03,ruc02 rvn03,ruc03 rvn04,",
               "ruc28 rvn05,ruc01 rvn06,ruc06 rvn07,ruc01 rvn08,",
               "ruc04 rvn09,(COALESCE(ruc18,0)-COALESCE(ruc20,0)) rvn10,",
               #"ruc01 rvn11,ruc01 rvn12,ruc01 rvn13,ruclegal rvnlegal,rucplant rvnplant,",#No.FUN-9C0069
               "ruc01 rvn11,ruc01 rvn12,ruc01 rvn13,azw02 rvnlegal,ruc01 rvnplant,", #No.FUN-9C0069
               "ruc07,ruc08,ruc09,ruc18,ruc01 ima131",
               "  FROM ruc_file,azw_file ", #No.FUN-9C0069
               " WHERE ruc06 IS NULL",
               "   AND ruc01 = azw01 ",     #No.FUN-9C0069
               "   AND ruc00 = '1'",
               "   AND ruc12 = '3'",
               "   AND ruc28 = '2'",
               "   AND ruc22 IS NULL",
               "   AND ruc32 IS NULL", #FUN-CC0057
               "   AND ruc27 = '",g_rvm.rvm04,"'",
               "   ORDER BY ruc02,ruc03"
    PREPARE rvn_tmp_ins1 FROM l_sql
    EXECUTE rvn_tmp_ins1
    FREE rvn_tmp_ins1
    CREATE INDEX rvn_temp_pk ON rvn_temp(ruc08,ruc09)
   
    BEGIN WORK
    CALL s_showmsg_init()
 
    UPDATE rvn_temp SET rvn08 = g_rvm.rvm05,rvn11='',rvn13=''
 
    #No.TQC-AC0004  --Begin
    #INSERT INTO rvnn_temp(rvnn03,rvnn04,rvnn05) SELECT DISTINCT ruc08,ruc09,rvn06 FROM rvn_temp
    #IF SQLCA.sqlcode THEN
    #   LET g_success='N'
    #   CALL s_errmsg('','','ins rvnn_temp',SQLCA.sqlcode,1)
    #END IF
    #LET l_sql = "UPDATE rvnn_temp a ",
    #               "SET (rvn07,ruc07) = (SELECT DISTINCT rvn07,ruc07",
    #            "                                 FROM rvn_temp",
    #            "                                WHERE ruc08 = a.rvnn03",
    #            "                                  AND ruc09 = a.rvnn04",
    #            "                                  AND rvn06 = a.rvnn05)"
    #EXECUTE IMMEDIATE l_sql
    #LET l_sql = "UPDATE rvnn_temp a",
    #            "   SET (rvnn06,ruc18) = (SELECT ruc04,(ruc18-ruc20) FROM ruc_file",
    #            "                         WHERE ruc08 = a.rvnn03",
    #            "                           AND ruc09 = a.rvnn04",
    #            "                           AND ruc01 = a.rvnn05)",
    #            " WHERE ruc07 <> '5' AND ruc07 <> '6'"
    #EXECUTE IMMEDIATE l_sql
    #No.TQC-AC0004  --End  
#POS要貨
    #No.TQC-AC0004  --Begin
    #DECLARE pcnm_cs_c CURSOR FOR SELECT DISTINCT rvnn05 FROM rvnn_temp
    #FOREACH pcnm_cs_c INTO l_rvnn05
#   #   SELECT pcab00 INTO l_pcab00 FROM b_pcab
#   #    WHERE pcab01 = l_rvnn05
#   #   LET l_sql = "UPDATE rvnn_temp a",
#   #               "   SET (rvnn06,ruc18) =  (SELECT pcno03,pcno07",
#   #               "                             FROM ",s_dbstring(l_pcab00 CLIPPED),"u_pcno",
#   #               "                                  WHERE pcno00 = a.rvnn05",
#   #               "                                    AND pcno01 = a.rvnn03",
#   #               "                                    AND pcno02 = a.rvnn04",
#   #               "                                    AND pcnoconf = 'Y')",
#   #               " WHERE ruc07 = '5'",
#   #               "   AND rvnn05 = '",l_rvnn05,"'"
#   #   EXECUTE IMMEDIATE l_sql
    #END FOREACH
    #No.TQC-AC0004  --End  
#壓貨拋轉
    #No.FUN-9C0069 ..begin
    #LET l_sql = "SELECT DISTINCT azp03 FROM azp_file ",
    #            " WHERE azp01 = (SELECT DISTINCT azw07 FROM azw_file,rvnn_temp ",
    #            "                 WHERE azw01 = rvnn05)"
    #No.TQC-AC0004  --Begin
    #LET l_sql = " SELECT DISTINCT azw07 FROM azw_file,rvnn_temp ",
    #            "                 WHERE azw01 = rvnn05 "
    #DECLARE rvnn_sel CURSOR FROM l_sql
    ##FOREACH rvnn_sel INTO l_dbs
    #FOREACH rvnn_sel INTO g_plant_new
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra
    ##No.FUN-9C0069 ..end
    #   LET l_sql = "UPDATE rvnn_temp a",
    #               #"   SET (rvnn06,ruc18) = (SELECT rug03,rug05 FROM ",s_dbstring(l_dbs CLIPPED),"rug_file", #FUN-A50102
    #               "   SET (rvnn06,ruc18) = (SELECT rug03,rug05 FROM ",cl_get_target_table(g_plant_new, 'rug_file'), #FUN-A50102
    #               "                          WHERE rug01 = a.rvnn03",
    #               "                            AND rug02 = a.rvnn04)",
    #               " WHERE ruc07 = '6'"
    #   EXECUTE IMMEDIATE l_sql
    #END FOREACH
    #
    #LET l_sql = "UPDATE rvnn_temp a",
    #            "   SET rvnn07 = ruc18*(SELECT AVG((ruc18-ruc20)/ruc18) FROM ruc_file",
    #            "                        WHERE ruc08 = a.rvnn03",
    #            "                          AND ruc09 = a.rvnn04",
    #            "                          AND ruc01 = a.rvnn05)"
    #EXECUTE IMMEDIATE l_sql
    #No.TQC-AC0004  --End  
#到arti162中去取出貨倉庫
    LET l_sql = "UPDATE rvn_temp a SET ima131 = (SELECT ima131 FROM ima_file",
                "                                  WHERE ima01 = a.rvn09)"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE rvn_temp a",
                "   SET rvn11 = (SELECT rvk03 FROM rvk_file",
                "                 WHERE rvk01 = '",g_rvm.rvm03,"'",
                "                   AND rvk02 = a.ima131",
                "                   AND rvk04 = a.rvn07",
                "                   AND rvkacti = 'Y')",
                " WHERE rvn11 IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE rvn_temp a",
                "   SET rvn11 = (SELECT rvk03 FROM rvk_file",
                "                 WHERE rvk01 = '",g_rvm.rvm03,"'",
                "                   AND rvk02 = a.ima131",
                "                   AND rvk04 = a.rvn06",
                "                   AND rvkacti = 'Y')",
                " WHERE rvn11 IS NULL",
                "   AND rvn07 IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE rvn_temp a",
                "   SET rvn11 = (SELECT rvk03 FROM rvk_file",
                "                 WHERE rvk01 = '",g_rvm.rvm03,"'",
                "                   AND rvk02 = a.ima131",
                "                   AND rvk04 = '*'",
                "                   AND rvkacti = 'Y')",
                " WHERE rvn11 IS NULL"
    EXECUTE IMMEDIATE l_sql
 
    LET l_sql = "UPDATE rvn_temp a",
                "   SET rvn11 = (SELECT rvk03 FROM rvk_file",
                "                 WHERE rvk01 = '",g_rvm.rvm03,"'",
                "                   AND rvk02 = '*'",
                "                   AND rvk04 = a.rvn07",
                "                   AND rvkacti = 'Y')",
                " WHERE rvn11 IS NULL"
    EXECUTE IMMEDIATE l_sql
 
    LET l_sql = "UPDATE rvn_temp a",
                "   SET rvn11 = (SELECT rvk03 FROM rvk_file",
                "                 WHERE rvk01 = '",g_rvm.rvm03,"'",
                "                   AND rvk02 = '*'",
                "                   AND rvk04 = a.rvn06",
                "                   AND rvkacti = 'Y')",
                " WHERE rvn11 IS NULL",
                "   AND rvn07 IS NULL"
    EXECUTE IMMEDIATE l_sql
 
    LET l_sql = "UPDATE rvn_temp a",
                "   SET rvn11 = (SELECT rvk03 FROM rvk_file",
                "                 WHERE rvk01 = '",g_rvm.rvm03,"'",
                "                   AND rvk02 = '*'",
                "                   AND rvk04 = '*'",
                "                   AND rvkacti = 'Y')",
                " WHERE rvn11 IS NULL"
    EXECUTE IMMEDIATE l_sql
#未取到    
    IF g_success = 'Y' THEN
       SELECT COUNT(*) INTO l_n
         FROM rvn_temp WHERE rvn11 IS NULL
       IF l_n>0 THEN
          LET g_success = 'N'
          INSERT INTO err_temp SELECT 'rvn11',ima131,'','art-245',1 FROM rvn_temp WHERE rvn11 IS NULL
          DELETE FROM rvn_temp WHERE rvn11 IS NULL
       END IF
    END IF
#倉庫對應機構
    LET l_sql = "UPDATE rvn_temp a",
                "   SET rvn12 = (SELECT imd20 FROM imd_file",
                "                 WHERE imd01 = a.rvn11",
                "                   AND imd11 = 'Y'",
                "                   AND imdacti = 'Y')"
    EXECUTE IMMEDIATE l_sql
#機構不存在    
    IF g_success='Y' THEN
       SELECT COUNT(*) INTO l_n
         FROM rvn_temp WHERE rvn12 IS NULL
       IF l_n >0 THEN
          LET g_success='N'
          INSERT INTO err_temp SELECT 'rvn11',rvn11,'','art-438',1 FROM rvn_temp WHERE rvn12 IS NULL
          DELETE FROM rvn_temp WHERE rvn12 IS NULL
       END IF
    END IF
#需求機構和出貨機構一樣
    IF g_success = 'Y' THEN
       SELECT COUNT(*) INTO l_n
         FROM rvn_temp WHERE rvn06 = rvn12
       IF l_n>0 THEN
          LET g_success='N'
          INSERT INTO err_temp SELECT 'rvn12',rvn12,'','art-338',1 FROM rvn_temp WHERE rvn06 = rvn12
          DELETE FROM rvn_temp WHERE rvn06 = rvn12
       END IF
    END IF
#需求機構與出貨機構法人一樣
    #No.FUN-960130 ..begin
    #IF g_success = 'Y' THEN
    #   SELECT COUNT(*) INTO l_n
    #     FROM rvn_temp
    #    WHERE EXISTS (SELECT 1 FROM azw_file a,azw_file b
    #                   WHERE a.azw01 = rvn12
    #                     AND b.azw01 = rvn07
    #                     AND a.azw02 = b.azw02) 
    #   IF l_n>0 THEN
    #      LET g_success='N'
    #      INSERT INTO err_temp SELECT 'rvn07,rvn12',rvn07||'|'||rvn12,'','art-597',1 
    #                             FROM rvn_temp
    #                           WHERE EXISTS (SELECT 1 FROM azw_file a,azw_file b
    #                                          WHERE a.azw01 = rvn12
    #                                            AND b.azw01 = rvn07
    #                                            AND a.azw02 = b.azw02) 
    #      DELETE FROM rvn_temp WHERE EXISTS (SELECT 1 FROM azw_file a,azw_file b
    #                                          WHERE a.azw01 = rvn12
    #                                            AND b.azw01 = rvn07
    #                                            AND a.azw02 = b.azw02)
    #   END IF
    #END IF
    #No.FUN-960130 ..end
#流程代碼
    LET l_sql = "UPDATE rvn_temp a",
                "   SET rvn13 = (SELECT rty10 FROM rty_file",
                "                  WHERE rty01 = a.rvn06",
                "                    AND rty02 = a.rvn09",
                "                    AND rtyacti = 'Y')",
                " WHERE EXISTS (SELECT 1 FROM azw_file b,azw_file c",
                "                WHERE b.azw01 = a.rvn12 ",
                "                  AND c.azw01 = a.rvn07",
                "                  AND b.azw02 <> c.azw02)"
    EXECUTE IMMEDIATE l_sql
#arti110中模版流程代不存在
    IF g_success ='Y' THEN
       SELECT COUNT(*) INTO l_n
         FROM rvn_temp 
        WHERE EXISTS (SELECT 1 FROM azw_file a,azw_file b
                       WHERE a.azw01=rvn12
                         AND b.azw01=rvn07
                         AND a.azw02<>b.azw02)
          AND rvn13 IS NULL
       IF l_n>0 THEN
          LET g_success='N'
          INSERT INTO err_temp SELECT 'rvn06,rvn09',rvn06||'|'||rvn09,'sel rty10','art-599',1 
                                 FROM rvn_temp 
                                WHERE EXISTS (SELECT 1 FROM azw_file a,azw_file b
                                               WHERE a.azw01=rvn12
                                                 AND b.azw01=rvn07
                                                 AND a.azw02<>b.azw02)
          AND  rvn13 IS NULL
       END IF
    END IF
 
    DECLARE rvn_sel2 CURSOR FOR SELECT DISTINCT rvn13,rvn06,rvn12 FROM rvn_temp WHERE rvn13 IS NOT NULL
    FOREACH rvn_sel2 INTO l_rvn13_t,l_rvn06,l_rvn12
       LET l_rvn13 = t252_ins_rvn13(l_rvn13_t,l_rvn12,l_rvn06)
       IF NOT cl_null(g_errno) THEN
          LET g_success = 'N'
          LET g_msg = l_rvn13_t,"|",l_rvn06,"|",l_rvn12
          INSERT INTO err_temp VALUES('rvn13,rvn06,rvn12',g_msg,'',g_errno,1)
       END IF        
       UPDATE rvn_temp SET rvn13 = l_rvn13
        WHERE rvn13 = l_rvn13_t AND rvn06 = l_rvn06 AND rvn12 = l_rvn12
    END FOREACH
    #No.TQC-AC0004  --Begin
    #LET l_sql = "UPDATE rvnn_temp",
    #            "   SET rvnn01 = '",g_rvm.rvm01,"',",
    #            "       rvnn02 = ROWNUM,",
    #            "       rvnnplant = '",g_rvm.rvmplant,"',",
    #            "       rvnnlegal = '",g_rvm.rvmlegal,"'"
    #EXECUTE IMMEDIATE l_sql
    #LET l_sql = "DELETE FROM rvn_temp a",
    #            " WHERE NOT EXISTS (SELECT 1 ",
    #            "                     FROM rvnn_temp b",
    #            "                    WHERE a.ruc08 = b.rvnn03",
    #            "                      AND a.ruc09 = b.rvnn04",
    #            "                      AND a.rvn06 = b.rvnn05)"
    #EXECUTE IMMEDIATE l_sql
    #No.TQC-AC0004  --End  
    LET l_sql = "UPDATE rvn_temp",
                "   SET rvn01 = '",g_rvm.rvm01,"',",
                "       rvn02 = ROWNUM,",
                "       rvn08 = '",g_rvm.rvm05,"',",                        #TQC-AC0230  add
                "       rvnplant = '",g_rvm.rvmplant,"',",
                "       rvnlegal = '",g_rvm.rvmlegal,"'" 
    EXECUTE IMMEDIATE l_sql

    #MOD-B80222 add begin------------------------------
    DECLARE rvn_sel09 CURSOR FOR SELECT DISTINCT rvn01,rvn02,rvn03,rvn04,rvn10 FROM rvn_temp
    FOREACH rvn_sel09 INTO l_rvn01,l_rvn02,l_rvn03,l_rvn04,l_rvn10
       SELECT SUM(rvn10) INTO l_rvn10_s FROM rvn_file,rvm_file
        WHERE rvn03 = l_rvn03 AND rvn04 = l_rvn04
          AND rvm01 = rvn01 AND rvmconf = 'N'
       IF cl_null(l_rvn10_s) THEN LET l_rvn10_s = 0 END IF
       LET l_rvn10 = l_rvn10 - l_rvn10_s
       IF l_rvn10 > 0 THEN
          UPDATE rvn_temp SET rvn10 = l_rvn10
           WHERE rvn01 = l_rvn01 AND rvn02 = l_rvn02
       ELSE
          DELETE FROM rvn_temp WHERE rvn01 = l_rvn01 AND rvn02 = l_rvn02
       END IF
    END FOREACH
    #MOD-B80222 add end------------------------------

    IF g_success = 'Y' THEN
       INSERT INTO rvn_file SELECT rvn01,rvn02,rvn03,rvn04,rvn05,rvn06,rvn07,
                                   rvn08,rvn09,rvn10,rvn11,rvn12,rvn13,rvnlegal,rvnplant FROM rvn_temp
       IF SQLCA.sqlcode THEN                     
          CALL s_errmsg('rvn01',g_rvm.rvm01,'insert into rvn_file:',SQLCA.sqlcode,1)  
          LET g_success = 'N'
       END IF
       #No.TQC-AC0004  --Begin
       #IF g_success = 'Y' THEN
       #   INSERT INTO rvnn_file SELECT rvnn01,rvnn02,rvnn03,rvnn04,
       #                                rvnn05,rvnn06,rvnn07,rvnnlegal,rvnnplant FROM rvnn_temp
       #   IF SQLCA.sqlcode THEN                     
       #      CALL s_errmsg('rvnn01',g_rvm.rvm01,'insert into rvnn_file:',SQLCA.sqlcode,1)   
       #      LET g_success = 'N'
       #   END IF
       #END IF
       #No.TQC-AC0004  --End  
    END IF
    IF g_success = 'N' THEN
       DECLARE err_cs CURSOR FOR SELECT * FROM err_temp
       FOREACH err_cs INTO l_err.*
         CALL s_errmsg(l_err.field,l_err.data,l_err.msg,l_err.errcode,l_err.n)
       END FOREACH
    END IF
    DISPLAY "ALL finished at:",TIME
END FUNCTION
 
FUNCTION t252_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1,                
           l_n       LIKE type_file.num5,
           li_result LIKE type_file.num5         
     
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME g_rvm.rvm01,g_rvm.rvm02,g_rvm.rvm03, g_rvm.rvmoriu,g_rvm.rvmorig,
                 g_rvm.rvm04,g_rvm.rvm05,g_rvm.rvm06,
#                 g_rvm.rvm07,g_rvm.rvmmksg,g_rvm.rvm08              #FUN-B30028  mark
                 g_rvm.rvm07,g_rvm.rvm08                             #FUN-B30028
     WITHOUT DEFAULTS
 
      BEFORE INPUT
         
          LET g_before_input_done = FALSE
          CALL t252_set_entry(p_cmd)
          CALL t252_set_no_entry(p_cmd)
          CALL cl_set_docno_format("rvm01")
         #TQC-B40098 Begin---
         #LET g_before_input_done = TRUE
         #CALL cl_set_comp_required("rvm05",FALSE)      #TQC-AC0311
         #CALL cl_set_comp_entry("rvm05",FALSE)         #TQC-AC0311
          IF g_rvm.rvm06 = 'Y' THEN
             CALL cl_set_comp_required("rvm05",FALSE)
             CALL cl_set_comp_entry("rvm05",FALSE)
          ELSE
             CALL cl_set_comp_required("rvm05",TRUE)
             CALL cl_set_comp_entry("rvm05",TRUE)
          END IF
          LET g_before_input_done = TRUE
         #TQC-B40098 End-----
	  
      AFTER FIELD rvm01  #配送分貨單號
         IF NOT cl_null(g_rvm.rvm01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rvm.rvm01 <> g_rvm_t.rvm01) THEN
#               CALL s_check_no("art",g_rvm.rvm01,g_rvm_t.rvm01,"3","rvm_file","rvm01,rvmplant","") #FUN-A70130 mark
                CALL s_check_no("art",g_rvm.rvm01,g_rvm_t.rvm01,"I2","rvm_file","rvm01,rvmplant","") #FUN-A70130 mod
                    RETURNING li_result,g_rvm.rvm01
                IF (NOT li_result) THEN                                                            
                    LET g_rvm.rvm01=g_rvm_t.rvm01                                                                 
                    NEXT FIELD rvm01                                                                                      
                END IF  
            END IF
         END IF
      
      AFTER FIELD rvm03    #配送中心
         IF NOT cl_null(g_rvm.rvm03) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                    
               g_rvm.rvm03 <> g_rvm_o.rvm03 OR cl_null(g_rvm_o.rvm03)) THEN
               CALL t252_rvm03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rvm03:',g_errno,0)
                  LET g_rvm.rvm03 = g_rvm_t.rvm03
                  DISPLAY BY NAME g_rvm.rvm03
                  NEXT FIELD rvm03
               ELSE 
                  LET g_rvm_o.rvm03 = g_rvm.rvm03
               END IF
            END IF
         ELSE
            LET g_rvm_o.rvm03=''
            CLEAR rvm03_desc
         END IF
         
      AFTER FIELD rvm05    #線路分類
         IF NOT cl_null(g_rvm.rvm05) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                    
               g_rvm.rvm05 <> g_rvm_o.rvm05 OR cl_null(g_rvm_o.rvm05)) THEN
               CALL t252_rvm05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rvm05:',g_errno,0)
                  LET g_rvm.rvm05 = g_rvm_t.rvm05
                  DISPLAY BY NAME g_rvm.rvm05
                  NEXT FIELD rvm05
               ELSE 
                  LET g_rvm_o.rvm05 = g_rvm.rvm05
               END IF
            END IF
         ELSE
            LET g_rvm_o.rvm05=''
            CLEAR rvm05_desc
         END IF
         
      ON CHANGE rvm06 #臨時線路,自動派車不能同時為Y
         IF NOT cl_null(g_rvm.rvm06) THEN
            IF g_rvm.rvm07 = 'Y' THEN
               LET g_rvm.rvm07 = 'N'
               DISPLAY BY NAME g_rvm.rvm07
            END IF
         END IF
#TQC-AC0311--add-------------begin-----------------------------
         IF g_rvm.rvm06='Y' THEN
            CALL cl_set_comp_required("rvm05",FALSE)
            CALL cl_set_comp_entry("rvm05",FALSE)
           #TQC-B40098 Begin---
            LET g_rvm.rvm05 = NULL
            DISPLAY BY NAME g_rvm.rvm05
            DISPLAY '' TO FORMONLY.rvm05_desc
           #TQC-B40098 End-----
         ELSE
            CALL cl_set_comp_required("rvm05",TRUE)
            CALL cl_set_comp_entry("rvm05",TRUE)
         END IF
#TQC-AC0311---add-------------end-----------------------------
      
      ON CHANGE rvm07
         IF NOT cl_null(g_rvm.rvm07) THEN
            IF g_rvm.rvm06 = 'Y' THEN
               LET g_rvm.rvm06 = 'N'
               LET g_rvm.rvm05 = NULL                    #TQC-AC0311
               CALL cl_set_comp_required("rvm05",TRUE)   #TQC-AC0311
               CALL cl_set_comp_entry("rvm05",TRUE)      #TQC-AC0311
               DISPLAY BY NAME g_rvm.rvm05               #TQC-AC0311
               DISPLAY '' TO FORMONLY.rvm05_desc         #TQC-AC0311
               DISPLAY BY NAME g_rvm.rvm06
            END IF
         END IF
         
      AFTER INPUT
         LET g_rvm.rvmuser = s_get_data_owner("rvm_file") #FUN-C10039
         LET g_rvm.rvmgrup = s_get_data_group("rvm_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rvm.rvm01) THEN
               NEXT FIELD rvm01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rvm01) THEN
            LET g_rvm.* = g_rvm_t.*
            CALL t252_show()
            NEXT FIELD rvm01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rvm01)#配送分貨但號
              LET g_t1=s_get_doc_no(g_rvm.rvm01)
#             CALL q_smy(FALSE,FALSE,g_t1,'art','3') RETURNING g_t1  #FUN-A70130--mark--
              CALL q_oay(FALSE,FALSE,g_t1,'I2','art') RETURNING g_t1  #FUN-A70130--end--
              LET g_rvm.rvm01=g_t1
              DISPLAY BY NAME g_rvm.rvm01
           WHEN INFIELD(rvm03)#配送中心
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_obn06"
              LET g_qryparam.default1 = g_rvm.rvm03
              LET g_qryparam.arg1 = g_plant
              CALL cl_create_qry() RETURNING g_rvm.rvm03
              CALL t252_rvm03('d')
              DISPLAY BY NAME g_rvm.rvm03
              NEXT FIELD rvm03
           WHEN INFIELD(rvm05)#線路
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_obn01"
              LET g_qryparam.default1 = g_rvm.rvm05
              CALL cl_create_qry() RETURNING g_rvm.rvm05
              DISPLAY BY NAME g_rvm.rvm05
              CALL t252_rvm05('d')
              NEXT FIELD rvm05
           OTHERWISE
              EXIT CASE
        END CASE
 
     ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                       
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION t252_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rvm01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t252_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rvm01",FALSE)
       
    END IF
 
END FUNCTION
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_get_store(p_org,p_item)
#DEFINE p_org LIKE rvn_file.rvn06
#DEFINE p_item LiKE rvnn_file.rvnn06
#DEFINE l_rvn11 LIKE rvn_file.rvn11
# 
#       LET l_rvn11 = ''
#       LET g_errno = ''
#       SELECT rvk03 INTO l_rvn11
#         FROM rvk_file,ima_file
#        WHERE rvk01 = g_rvm.rvm03
#          AND rvkacti = 'Y'
#          AND rvk02 = ima131
#          AND rvk04 = p_org
#          AND ima01 = p_item
#       IF NOT cl_null(l_rvn11) THEN
#          RETURN l_rvn11
#       ELSE
#          SELECT rvk03 INTO l_rvn11
#            FROM rvk_file,ima_file
#           WHERE rvk01 = g_rvm.rvm03
#             AND rvkacti = 'Y'
#             AND rvk02 = ima131
#             AND rvk04 = '*'
#             AND ima01 = p_item
#          IF NOT cl_null(l_rvn11) THEN
#             RETURN l_rvn11
#          ELSE            
#            SELECT rvk03 INTO l_rvn11
#              FROM rvk_file
#             WHERE rvk01 = g_rvm.rvm03
#               AND rvkacti = 'Y'
#               AND rvk02 = '*'
#               AND rvk04 = p_org
#            IF NOT cl_null(l_rvn11) THEN
#             RETURN l_rvn11
#            ELSE 
#               SELECT rvk03 INTO l_rvn11
#                 FROM rvk_file
#                WHERE rvk01 = g_rvm.rvm03
#                  AND rvkacti = 'Y'
#                  AND rvk02 = '*'
#                  AND rvk04 = '*'
#              IF SQLCA.sqlcode=0 AND NOT cl_null(l_rvn11) THEN
#                 RETURN l_rvn11
#              ELSE
#                 LET g_errno='art-245'
#                 RETURN ''
#              END IF
#            END IF
#         END IF
#       END IF
#          
#END FUNCTION
#No.TQC-AC0004  --End  
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_b_init()
#DEFINE l_rvn11 LIKE rvn_file.rvn11
#DEFINE l_n  LIKE type_file.num5
#DEFINE l_ruc18,l_ruc18_01 LIKE ruc_file.ruc18
#DEFINE l_pcno07 LIKE pml_file.pml20
#DEFINE l_rugplant LIKE rug_file.rugplant
#DEFINE l_dbs LIKE azp_file.azp03
#DEFINE l_ruc06  LIKE ruc_file.ruc06
##DEFINE l_pcab00 LIKE b_pcab.pcab00
# 
#        IF g_rvnn[l_ac].ruc07 MATCHES '[56]' THEN
#             LET g_sql = "SELECT DISTINCT ruc06,ruc07,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)",               
#                         "  FROM ruc_file ",
#                         " WHERE ruc01 = ?",
#                         "   AND ruc08 = ?",
#                         "   AND ruc09 = ?"
#             DECLARE ruc_cs1 CURSOR FROM g_sql
#             FOREACH ruc_cs1 USING g_rvnn[l_ac].rvnn05,g_rvnn[l_ac].rvnn03,g_rvnn[l_ac].rvnn04              
#                INTO l_ruc06,g_rvnn[l_ac].ruc07,l_ruc18,l_ruc18_01
#             IF g_rvnn[l_ac].ruc07 = '5' THEN
#             END IF      
#             IF g_rvnn[l_ac].ruc07='6' THEN     
#                SELECT azw07 INTO l_rugplant FROM azw_file WHERE azw01 = g_rvnn[l_ac].rvnn05
#                CALL t252_azp(l_rugplant) RETURNING l_dbs
#                #LET g_sql = "SELECT rug03,rug04,rug05 FROM ",s_dbstring(l_dbs CLIPPED),"rug_file", #FUN-A50102
#                LET g_sql = "SELECT rug03,rug04,rug05 FROM ",cl_get_target_table(l_rugplant, 'rug_file'), #FUN-A50102
#                            " WHERE rug01 = ?",
#                            "   AND rug02 = ?",
#                            "   AND rugplant = ?"
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql, l_rugplant) RETURNING g_sql  #FUN-A50102
#                PREPARE rug_cs2 FROM g_sql
#                EXECUTE rug_cs2 USING g_rvnn[l_ac].rvnn03,g_rvnn[l_ac].rvnn04,l_rugplant
#                                INTO g_rvnn[l_ac].rvnn06,g_rvnn[l_ac].ruc16,l_pcno07
#                SELECT gfe02 INTO g_rvnn[l_ac].ruc16_desc FROM gfe_file
#                 WHERE gfe01 = g_rvnn[l_ac].ruc16 AND gfeacti = 'Y'
#                CALL t252_get_store(l_ruc06,g_rvnn[l_ac].rvnn06) RETURNING l_rvn11
#             END IF     
#             LET l_ruc18_01 = l_ruc18_01/(l_ruc18/l_pcno07)
#             LET g_rvnn[l_ac].ruc18_01 = 0
#             LET g_rvnn[l_ac].ruc18_01 = g_rvnn[l_ac].ruc18_01 + l_ruc18_01
#             LET g_rvnn[l_ac].ruc18 = l_pcno07
#             END FOREACH
#       ELSE
#          IF g_rvnn[l_ac].ruc07 = '3' THEN
#             SELECT ruc06,ruc07,ruc16,gfe02,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)
#            INTO l_ruc06,g_rvnn[l_ac].ruc07,g_rvnn[l_ac].ruc16,g_rvnn[l_ac].ruc16_desc,
#                 g_rvnn[l_ac].ruc18,g_rvnn[l_ac].ruc18_01
#            FROM ruc_file LEFT JOIN gfe_file
#              ON ruc16 = gfe01 AND gfeacti = 'Y'
#           WHERE ruc01 = g_rvnn[l_ac].rvnn05
#             AND ruc08 = g_rvnn[l_ac].rvnn03
#             AND ruc09 = g_rvnn[l_ac].rvnn04
#          ELSE
#          SELECT ruc06,ruc07,ruc16,gfe02,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)
#            INTO l_ruc06,g_rvnn[l_ac].ruc07,g_rvnn[l_ac].ruc16,g_rvnn[l_ac].ruc16_desc,
#                 g_rvnn[l_ac].ruc18,g_rvnn[l_ac].ruc18_01
#            FROM ruc_file LEFT JOIN gfe_file
#              ON ruc16 = gfe01 AND gfeacti = 'Y'
#           WHERE ruc01 = g_rvnn[l_ac].rvnn05
#             AND ruc02 = g_rvnn[l_ac].rvnn03
#             AND ruc03 = g_rvnn[l_ac].rvnn04
#          END IF
#          CALL t252_get_store(l_ruc06,g_rvnn[l_ac].rvnn06) RETURNING l_rvn11 
#        END IF
#        SELECT azp02 INTO g_rvnn[l_ac].rvnn05_desc
#          FROM azp_file
#         WHERE azp01 = g_rvnn[l_ac].rvnn05       
#       SELECT ima02,ima131 INTO g_rvnn[l_ac].rvnn06_desc,g_rvnn[l_ac].ima131
#         FROM ima_file
#        WHERE ima01 = g_rvnn[l_ac].rvnn06
#END FUNCTION
#No.TQC-AC0004  --End  
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_b_ins()
#DEFINE l_rvn RECORD LIKE rvn_file.*
#DEFINE l_sql STRING
#DEFINE l_ruc18 LIKE ruc_file.ruc18
##DEFINE l_pcab00 LIKE b_pcab.pcab00
# 
#       IF g_rvnn[l_ac].ruc07 = '5' THEN
##          SELECT pcab00 INTO l_pcab00 FROM b_pcab
##           WHERE pcab01 = g_rvnn[l_ac].rvnn05
##          LET g_sql = "SELECT pcno08 FROM ",s_dbstring(l_pcab00 CLIPPED),"u_pcno ",
##                            " WHERE pcno00 = ?",
##                            "   AND pcno01 = ?",
##                            "   AND pcno02 = ?"
##          PREPARE pcnm_cs1 FROM g_sql
##          EXECUTE pcnm_cs1 USING g_rvnn[l_ac].rvnn05,g_rvnn[l_ac].rvnn03,
##                                g_rvnn[l_ac].rvnn04
##                           INTO l_rvn.rvn11
#       END IF
#       LET l_rvn.rvn08 = g_rvm.rvm05
#          LET l_sql = "SELECT ruc02,ruc03,ruc04,ruc28,ruc06,ruc18 ",
#                      "  FROM ruc_file ",
#                      " WHERE ruc01 = ?",
#                      "   AND ruc08 = ?",
#                      "   AND ruc09 = ?"
#          PREPARE ruc_pre FROM l_sql
#          DECLARE ruc_cs CURSOR FOR ruc_pre
#          SELECT COALESCE(MAX(rvn02),0)+1 INTO g_cnt FROM rvn_file
#           WHERE rvn01 = g_rvm.rvm01 AND rvnplant = g_rvm.rvmplant
#          FOREACH ruc_cs USING g_rvnn[l_ac].rvnn05,g_rvnn[l_ac].rvnn03,g_rvnn[l_ac].rvnn04
#                         INTO l_rvn.rvn03,l_rvn.rvn04,l_rvn.rvn09,l_rvn.rvn05,l_rvn.rvn07,l_ruc18
#            IF g_rvnn[l_ac].ruc07 <> '5' THEN
#               CALL t252_get_store(l_rvn.rvn07,g_rvnn[l_ac].rvnn06) RETURNING l_rvn.rvn11
#            END IF
#            SELECT imd20 INTO l_rvn.rvn12
#              FROM imd_file
#             WHERE imd01 = l_rvn.rvn11
#               AND imd11 = 'Y'
#               AND imdacti = 'Y'
#            LET l_rvn.rvn10 = g_rvnn[l_ac].rvnn07*(l_ruc18/g_rvnn[l_ac].ruc18)
#            LET l_rvn.rvn01 = g_rvm.rvm01
#            LET l_rvn.rvn02 = g_cnt
#            LET l_rvn.rvnplant = g_rvm.rvmplant
#            LET l_rvn.rvnlegal = g_rvm.rvmlegal
#            LET l_rvn.rvn06 = g_rvnn[l_ac].rvnn05
#            INSERT INTO rvn_file VALUES(l_rvn.*) 
#            LET g_cnt = g_cnt + 1                            
#           END FOREACH
# 
#END FUNCTION
#No.TQC-AC0004  --End  
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_b_upd()
#DEFINE l_rvn03 LIKE rvn_file.rvn03
#DEFINE l_rvn04 LIKE rvn_file.rvn04
#DEFINE l_rvn06 LIKE rvn_file.rvn06
#DEFINE l_ruc18 LIKE ruc_file.ruc18
#          
#    IF g_rvnn[l_ac].rvnn03<>g_rvnn_t.rvnn03 OR
#       g_rvnn[l_ac].rvnn04<>g_rvnn_t.rvnn04 THEN
#       DELETE FROM rvn_file WHERE rvn01 = g_rvm.rvm01 AND rvnplant = g_rvm.rvmplant
#                              AND rvn03 = g_rvnn[l_ac].rvnn03
#                              AND rvn04 = g_rvnn[l_ac].rvnn04
#                              AND rvn06 = g_rvnn[l_ac].rvnn05
#       CALL t252_b_ins()
#    ELSE
#       IF (g_rvnn[l_ac].rvnn07 <> g_rvnn_t.rvnn07 OR cl_null(g_rvnn_t.rvnn07)) THEN
#          IF g_rvnn[l_ac].ruc07 MATCHES '[356]' THEN
#                LET g_sql = "SELECT ruc01,ruc02,ruc03,COALESCE(ruc18,0) FROM ruc_file",
#                                " WHERE ruc01 = ? AND ruc08 = ?",
#                                "   AND ruc09 = ? AND ruc07 = ?"
#                DECLARE ruc_cs3 CURSOR FROM g_sql
#                FOREACH ruc_cs3 USING g_rvnn[l_ac].rvnn05,g_rvnn[l_ac].rvnn03,
#                                      g_rvnn[l_ac].rvnn04,g_rvnn[l_ac].ruc07
#                                 INTO l_rvn06,l_rvn03,l_rvn04,l_ruc18             
#                UPDATE rvn_file SET rvn10 = l_ruc18/g_rvnn[l_ac].ruc18*g_rvnn[l_ac].rvnn07
#                 WHERE rvn01 = g_rvm.rvm01 AND rvnplant = g_rvm.rvmplant
#                   AND rvn03 = l_rvn03
#                   AND rvn04 = l_rvn04
#                   AND rvn06 = l_rvn06
#                END FOREACH
#          ELSE
#                UPDATE rvn_file SET rvn10 = g_rvnn[l_ac].rvnn07
#                 WHERE rvn01 = g_rvm.rvm01 AND rvnplant = g_rvm.rvmplant
#                   AND rvn03 = g_rvnn[l_ac].rvnn03
#                   AND rvn04 = g_rvnn[l_ac].rvnn04
#                   AND rvn06 = g_rvnn[l_ac].rvnn05
#          END IF
#       END IF
#    END IF
#END FUNCTION
#No.TQC-AC0004  --End  
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_chk_count()
#DEFINE l_fac LIKE type_file.num5
#DEFINE l_rate DYNAMIC ARRAY OF DECIMAL(20,6)
#DEFINE l_rate_t LIKE ruc_file.ruc18
#DEFINE l_ruc18  LIKE ruc_file.ruc18
#DEFINE l_mod    LIKE ruc_file.ruc18
# 
#       IF g_rvnn[l_ac].ruc07 MATCHES '[356]' THEN
#                LET g_sql = "SELECT COALESCE(ruc18,0) FROM ruc_file",
#                                " WHERE ruc01 = ? AND ruc08 = ?",
#                                "   AND ruc09 = ? AND ruc07 = ?"
#                DECLARE chk_count_cs CURSOR FROM g_sql
#                LET g_cnt = 1
#                FOREACH chk_count_cs USING g_rvnn[l_ac].rvnn05,g_rvnn[l_ac].rvnn03,
#                                           g_rvnn[l_ac].rvnn04,g_rvnn[l_ac].ruc07
#                                      INTO l_ruc18             
#                    LET l_fac = g_rvnn[l_ac].rvnn07/l_ruc18
#                    IF l_fac>1 THEN
#                       LET l_rate[g_cnt]=g_rvnn[l_ac].ruc18/l_ruc18
#                    END IF
#                    IF g_cnt > 1 THEN
#                       IF l_rate[g_cnt]<l_rate[g_cnt-1] THEN
#                          LET l_rate_t = l_rate[g_cnt-1]
#                       ELSE
#                          LET l_rate_t = l_rate[g_cnt]
#                       END IF
#                    END IF
#                    LET g_cnt = g_cnt + 1
#                END FOREACH
#                IF g_rvnn[l_ac].rvnn07<l_rate_t THEN
#                   LET g_rvnn[l_ac].rvnn07 = l_rate_t
#                   RETURN TRUE
#                END IF                 
#                IF g_rvnn[l_ac].rvnn07>l_rate_t THEN
#                   LET l_mod = g_rvnn[l_ac].rvnn07 MOD l_rate_t
#                   IF l_mod = 0 THEN
#                      RETURN FALSE
#                   END IF
#                   LET g_rvnn[l_ac].rvnn07 = ((g_rvnn[l_ac].rvnn07 - l_mod)/l_rate_t+1)*l_rate_t
#                   RETURN TRUE
#                END IF
#                RETURN FALSE
#        END IF
#        RETURN FALSE
#END FUNCTION
#No.TQC-AC0004  --End  
 
FUNCTION t252_b1()
DEFINE l_ac_t LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1                
DEFINE l_allow_insert  LIKE type_file.num5,    #TQC-AC0311
       l_allow_delete  LIKE type_file.num5     #TQC-AC0311

 
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_rvm.rvm01) THEN
           RETURN 
        END IF
        IF g_rvm.rvm06 !='Y' THEN         #TQC-AC0311
           CALL cl_err('','art510',0)     #TQC-AC0311
           RETURN                         #TQC-AC0311
        END IF                            #TQC-AC0311
        
        SELECT * INTO g_rvm.* FROM rvm_file
         WHERE rvm01=g_rvm.rvm01
        IF g_rvm.rvmacti='N' THEN 
           CALL cl_err(g_rvm.rvm01,'mfg1000',0)
           RETURN 
        END IF
        
        IF g_rvm.rvmconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
        END IF
     
        CALL cl_opmsg('b')
        
        LET g_forupd_sql= "SELECT rvn02,rvn03,rvn04,rvn05,rvn06,'',",
                          "rvn07,'',rvn08,rvn09,'','','','','','',",
                          "rvn10,rvn11,'',rvn12,'','',rvn13",
                          "  FROM rvn_file",
                          " WHERE rvn01 = ? AND rvn02 = ?",
                          " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

        DECLARE t252_bcl1 CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")   #TQC-AC0311
        LET l_allow_delete=cl_detail_input_auth("delete")   #TQC-AC0311

        INPUT ARRAY g_rvn WITHOUT DEFAULTS FROM s_rvn.*
                ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,   #TQC-AC0311
                        APPEND ROW= l_allow_insert)                            #TQC-AC0311
#                        INSERT ROW=FALSE,DELETE ROW=FALSE,                    #TQC-AC0311
#                        APPEND ROW= FALSE)                                    #TQC-AC0311

        BEFORE INPUT
                IF g_rec_b1 !=0 THEN 
                   CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN t252_cl USING g_rvm.rvm01
                IF STATUS THEN
                        CALL cl_err("OPEN t252_cl:",STATUS,0)
                        CLOSE t252_cl
                        ROLLBACK WORK
                END IF
                
                FETCH t252_cl INTO g_rvm.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rvm.rvm01,SQLCA.sqlcode,0)
                        CLOSE t252_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b1>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rvn_t.*=g_rvn[l_ac].*
                        LET g_rvn_o.*=g_rvn[l_ac].*
                        OPEN t252_bcl1 USING g_rvm.rvm01,g_rvn_t.rvn02
                        IF STATUS THEN
                           CALL cl_err("OPEN t252_bcl1:",STATUS,0)
                           LET l_lock_sw='Y'
                        ELSE
                           FETCH t252_bcl1 INTO g_rvn[l_ac].*
                           IF SQLCA.sqlcode THEN
                              #No.TQC-AC0004  --Begin
                              #CALL cl_err(g_rvnn_t.rvnn03,SQLCA.sqlcode,0)
                              CALL cl_err(g_rvn_t.rvn02,SQLCA.sqlcode,0)
                              #No.TQC-AC0004  --End  
                              LET l_lock_sw="Y"
                           END IF
#TQC-AC0311---------------begin---------------------------------------------
#                              SELECT rvn06_desc,rvn07_desc,ima02,ima131,ruc16,
#                                     gfe02,ruc18,ruc18_01,rvn11_desc,rvn12_desc,ruc29
#                                INTO g_rvn[l_ac].rvn06_desc,g_rvn[l_ac].rvn07_desc,g_rvn[l_ac].ima02,
#                                     g_rvn[l_ac].ima131,g_rvn[l_ac].ruc16,g_rvn[l_ac].ruc16_desc,
#                                     g_rvn[l_ac].ruc18,g_rvn[l_ac].ruc18_01,g_rvn[l_ac].rvn11_desc,
#                                     g_rvn[l_ac].rvn12_desc,g_rvn[l_ac].ruc29
#                                FROM cs_rvn_temp
#                               WHERE rvn01 = g_rvm.rvm01
#                                 AND rvn02 = g_rvn_t.rvn02
#                              DISPLAY BY NAME g_rvn[l_ac].rvn06_desc,g_rvn[l_ac].rvn07_desc,g_rvn[l_ac].ima02,
#                                       g_rvn[l_ac].ima131,g_rvn[l_ac].ruc16,g_rvn[l_ac].ruc16_desc,
#                                       g_rvn[l_ac].ruc18,g_rvn[l_ac].ruc18_01,g_rvn[l_ac].rvn11_desc,
#                                       g_rvn[l_ac].rvn12_desc,g_rvn[l_ac].ruc29
#                                 #No.FUN-960130 ..begin
#                                  #SELECT COUNT(*) INTO l_n
#                                  #  FROM azp_file a,azp_file b
#                                  # WHERE a.azp01 = g_rvn[l_ac].rvn12
#                                  #   AND b.azp01 = g_rvn[l_ac].rvn07
#                                  #   AND a.azp03 = b.azp03

                                 SELECT ruc16,ruc18,ruc18-ruc20 
                                   INTO g_rvn[l_ac].ruc16,g_rvn[l_ac].ruc18,g_rvn[l_ac].ruc18_01
                                   FROM ruc_file
                                 WHERE ruc01=g_rvn[l_ac].rvn06
                                   AND ruc00='1'
                                   AND ruc02=g_rvn[l_ac].rvn03
                                   AND ruc03=g_rvn[l_ac].rvn04

                                 SELECT gfe02 INTO g_rvn[l_ac].ruc16_desc FROM gfe_file
                                   WHERE gfe01 = g_rvn[l_ac].ruc16 AND gfeacti = 'Y'
                                 SELECT azw08 INTO g_rvn[l_ac].rvn06_desc FROM azw_file
                                   WHERE azw01=g_rvn[l_ac].rvn06
                                 SELECT azw08 INTO g_rvn[l_ac].rvn07_desc FROM azw_file
                                   WHERE azw01=g_rvn[l_ac].rvn07
                                 SELECT ima02,ima131 INTO g_rvn[l_ac].ima02,g_rvn[l_ac].ima131
                                   FROM ima_file
                                   WHERE ima01=g_rvn[l_ac].rvn09
                                 SELECT imd02 INTO g_rvn[l_ac].rvn11_desc
                                   FROM imd_file
                                   WHERE imd01=g_rvn[l_ac].rvn11
                                 SELECT azw08 INTO g_rvn[l_ac].rvn12_desc FROM azw_file
                                   WHERE azw01=g_rvn[l_ac].rvn12
                                            
                                 DISPLAY BY NAME g_rvn[l_ac].*
                                 LET l_n=0
#TQC-AC0311---------------end-------------------------------------------------------
                                  SELECT COUNT(*) INTO l_n
                                    FROM azw_file a,azw_file b
                                   WHERE a.azw01 = g_rvn[l_ac].rvn12
                                     AND b.azw01 = g_rvn[l_ac].rvn07
                                     AND a.azw02 = b.azw02
                                 #No.FUN-960130 ..end
                                  IF l_n = 0 THEN
                                      CALL cl_set_comp_required("rvn13",TRUE)
                                  ELSE
                                      CALL cl_set_comp_required("rvn13",FALSE)
                                  END IF
                        END IF
                  END IF                        
         
#TQC-AC0311----------add--------------begin----------------------------------------------
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rvn[l_ac].* TO NULL
                LET g_rvn_t.*=g_rvn[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rvn02

       AFTER INSERT
                IF INT_FLAG THEN
                   CALL cl_err('',9001,0)
                   LET INT_FLAG=0
                   CANCEL INSERT
                END IF
                INSERT INTO rvn_file(rvn01,rvn02,rvn03,rvn04,rvn05,rvn06,
                                     rvn07,rvn08,rvn09,rvn10,rvn11,rvn12,
                                     rvn13,rvnplant,rvnlegal)
                              VALUES(g_rvm.rvm01,g_rvn[l_ac].rvn02,g_rvn[l_ac].rvn03,
                                     g_rvn[l_ac].rvn04,g_rvn[l_ac].rvn05,g_rvn[l_ac].rvn06,
                                     g_rvn[l_ac].rvn07,g_rvn[l_ac].rvn08,g_rvn[l_ac].rvn09,
                                     g_rvn[l_ac].rvn10,g_rvn[l_ac].rvn11,g_rvn[l_ac].rvn12,
                                     g_rvn[l_ac].rvn13,g_rvm.rvmplant,g_rvm.rvmlegal)
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rvn_file",g_rvm.rvm01,g_rvn[l_ac].rvn02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                   MESSAGE 'INSERT O.K.'
                   COMMIT WORK
                   LET g_rec_b1=g_rec_b1+1
                   DISPLAY g_rec_b1 TO FORMONLY.cn2
                END IF

      BEFORE FIELD rvn02
        IF cl_null(g_rvn[l_ac].rvn02) OR g_rvn[l_ac].rvn02 = 0 THEN
            SELECT MAX(rvn02)+1 INTO g_rvn[l_ac].rvn02 FROM rvn_file
             WHERE rvn01=g_rvm.rvm01
            IF g_rvn[l_ac].rvn02 IS NULL THEN
               LET g_rvn[l_ac].rvn02=1
            END IF
        END IF

      AFTER FIELD rvn03,rvn04 #來源單號
        IF NOT cl_null(g_rvn[l_ac].rvn03)THEN
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rvn[l_ac].rvn03 <> g_rvn_o.rvn03) 
                          OR cl_null(g_rvn_o.rvn03) THEN
               
              LET l_n=0
              IF NOT cl_null(g_rvn[l_ac].rvn04) AND NOT cl_null(g_rvn[l_ac].rvn03) THEN
                 SELECT COUNT(*) INTO l_n FROM ruc_file
                  WHERE ruc02 = g_rvn[l_ac].rvn03
                    AND ruc03 = g_rvn[l_ac].rvn04
                    AND ruc00 ='1'
                    AND ruc12 ='3'
                    AND ruc26 = g_rvm.rvm03
                    AND ruc18 - ruc20 >0
                    AND ruc27 = g_rvm.rvm04
                    AND ruc32 IS NULL   #FUN-CC0057
                 
                  IF l_n=0 THEN
                     CALL cl_err(g_rvn[l_ac].rvn03,'art-244',0)
                     LET g_rvn[l_ac].rvn03 = g_rvn_t.rvn03
                     LET g_rvn[l_ac].rvn04 = g_rvn_t.rvn04
                     DISPLAY BY NAME g_rvn[l_ac].rvn03
                     DISPLAY BY NAME g_rvn[l_ac].rvn04
                     NEXT FIELD CURRENT
                  END IF

                  SELECT ruc01,ruc04,ruc16,ruc18,ruc18-ruc20,ruc18-ruc20,ruc29,ruc28,ruc06  
                      INTO g_rvn[l_ac].rvn06,g_rvn[l_ac].rvn09,g_rvn[l_ac].ruc16,
                           g_rvn[l_ac].ruc18,g_rvn[l_ac].ruc18_01,g_rvn[l_ac].rvn10,
                           g_rvn[l_ac].ruc29,g_rvn[l_ac].rvn05,g_rvn[l_ac].rvn07
                      FROM ruc_file
                    WHERE ruc02 = g_rvn[l_ac].rvn03
                      AND ruc03 = g_rvn[l_ac].rvn04
                      AND ruc00 ='1'
                      AND ruc12 = '3'
                      AND ruc26 = g_rvm.rvm03
                      AND ruc18 - ruc20 >0
                      AND ruc27 = g_rvm.rvm04
                      AND ruc32 IS NULL   #FUN-CC0057

                  SELECT azw08 INTO g_rvn[l_ac].rvn06_desc FROM azw_file
                    WHERE azw01=g_rvn[l_ac].rvn06
                  SELECT azw08 INTO g_rvn[l_ac].rvn07_desc FROM azw_file
                    WHERE azw01=g_rvn[l_ac].rvn07
                  SELECT ima02,ima131 INTO g_rvn[l_ac].ima02,g_rvn[l_ac].ima131
                    FROM ima_file 
                    WHERE ima01=g_rvn[l_ac].rvn09                 
                  SELECT gfe02 INTO g_rvn[l_ac].ruc16_desc FROM gfe_file
                    WHERE gfe01 = g_rvn[l_ac].ruc16 AND gfeacti = 'Y'

                 #FUN-CB0104 Mark&Add Begin ---
                 #SELECT rvk03 INTO g_rvn[l_ac].rvn11 FROM rvk_file
                 #   WHERE rvk01=g_rvm.rvm03
                 #     #AND rvk04=g_rvn[l_ac].rvn06                    #TQC-C80087 MARK
                 #      AND (rvk04=g_rvn[l_ac].rvn06 OR rvk04='*')     #TQC-C80087 add
                 #     #AND rvk02=g_rvn[l_ac].ima131                                       #TQC-C40243 mark
                 #     AND (rvk02 = '*' OR (rvk02 <> '*' AND rvk02 = g_rvn[l_ac].ima131))  #TQC-C40243 add 
                 #     AND rvkacti='Y'
                 #若異店取貨銷售歸屬2.取貨門店且取貨門店不為空時,出貨營運中心根據取貨門店抓取,反之根據需求門店
                  IF g_rcj12 = '2' AND NOT cl_null(g_rvn[l_ac].rvn07) THEN
                     SELECT rvk03 INTO g_rvn[l_ac].rvn11 FROM rvk_file
                      WHERE  rvk01  = g_rvm.rvm03
                        AND (rvk04  = g_rvn[l_ac].rvn07 OR rvk04='*')
                        AND (rvk02  = '*' OR (rvk02 <> '*' AND rvk02 = g_rvn[l_ac].ima131))
                        AND  rvkacti= 'Y'
                  ELSE
                     SELECT rvk03 INTO g_rvn[l_ac].rvn11 FROM rvk_file
                      WHERE  rvk01  = g_rvm.rvm03
                        AND (rvk04  = g_rvn[l_ac].rvn06 OR rvk04='*')
                        AND (rvk02  = '*' OR (rvk02 <> '*' AND rvk02 = g_rvn[l_ac].ima131))
                        AND  rvkacti= 'Y'
                  END IF
                 #FUN-CB0104 Mark&Add End -----
      
      
      
                  SELECT imd02,imd20 INTO g_rvn[l_ac].rvn11_desc,g_rvn[l_ac].rvn12 FROM imd_file
                   WHERE imd01=g_rvn[l_ac].rvn11 AND imdacti='Y'
                  SELECT azw08 INTO g_rvn[l_ac].rvn12_desc FROM azw_file
                    WHERE azw01=g_rvn[l_ac].rvn12

                  DISPLAY BY NAME g_rvn[l_ac].*

                  LET l_n=0
                  SELECT COUNT(*) INTO l_n
                    FROM azw_file a,azw_file b
                   WHERE a.azw01 = g_rvn[l_ac].rvn12
                     AND b.azw01 = g_rvn[l_ac].rvn07
                     AND a.azw02 = b.azw02
                  IF l_n = 0 THEN
                      CALL cl_set_comp_required("rvn13",TRUE)
                  ELSE
                      CALL cl_set_comp_required("rvn13",FALSE)
                  END IF


#                  SELECT imd02 INTO g_rvn[l_ac].rvn11_desc
#                    FROM imd_file
#                    WHERE imd01=g_rvn[l_ac].rvn11
#                  SELECT azw08 INTO g_rvn[l_ac].rvn12_desc FROM azw_file
#                    WHERE azw01=g_rvn[l_ac].rvn12
#              ELSE
#                 SELECT COUNT(*) INTO l_n FROM ruc_file
#                  WHERE ruc02 = g_rvn[l_ac].rvn03
#                    AND ruc03 = g_rvn[l_ac].rvn04
#                    AND ruc12 ='3'
#                    AND ruc26 = g_rvm.rvm03
#                    AND ruc18 - ruc20 >0
#                    AND ruc27 = g_rvm.rvm04
#                 IF l_n=0 THEN
#                    CALL cl_err(g_rvn[l_ac].rvn03,'art-244',0)
#                    LET g_rvn[l_ac].rvn03 = g_rvn_t.rvn03
#                    LET g_rvn[l_ac].rvn04 = g_rvn_t.rvn04
#                    DISPLAY BY NAME g_rvn[l_ac].rvn03
#                    DISPLAY BY NAME g_rvn[l_ac].rvn04
#                    NEXT FIELD CURRENT
#                 END IF

              END IF
           END IF
        END IF

      AFTER FIELD rvn10
         IF NOT cl_null(g_rvn[l_ac].rvn10) THEN
            IF g_rvn[l_ac].rvn10 <0 OR g_rvn[l_ac].rvn10 >g_rvn[l_ac].ruc18_01 THEN
               CALL cl_err('','art511',0)
               LET g_rvn[l_ac].rvn10 = g_rvn_t.rvn10
               NEXT FIELD rvn10
            END IF
         END IF

      AFTER FIELD rvn11
         IF NOT cl_null(g_rvn[l_ac].rvn11) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM imd_file
             WHERE imd01=g_rvn[l_ac].rvn11 AND imdacti='Y'
            IF l_n=0 THEN
               CALL cl_err(g_rvn[l_ac].rvn11,'aic-034',0)
               LET g_rvn[l_ac].rvn11 = g_rvn_t.rvn11
               DISPLAY BY NAME g_rvn[l_ac].rvn11
               NEXT FIELD rvn11
            END IF
            LET l_n=0
           #FUN-CB0104 Mark&Add Begin ---
           #SELECT COUNT(*) INTO l_n FROM rvk_file
           #   WHERE rvk01=g_rvm.rvm03
           #    #AND rvk04=g_rvn[l_ac].rvn06                    #TQC-C80087 MARK
           #     AND (rvk04=g_rvn[l_ac].rvn06 OR rvk04='*')     #TQC-C80087 add
           #     #AND rvk02=g_rvn[l_ac].ima131                                        #TQC-C40243 mark
           #     AND (rvk02 = '*' OR (rvk02 <> '*' AND rvk02 = g_rvn[l_ac].ima131))   #TQC-C40243 add              
           #     AND rvk03 = g_rvn[l_ac].rvn11                                        #TQC-C40243 add 
           #     AND rvkacti='Y'
           #若異店取貨銷售歸屬2.取貨門店且取貨門店不為空時,出貨營運中心根據取貨門店抓取,反之根據需求門店
            IF g_rcj12 = '2' AND NOT cl_null(g_rvn[l_ac].rvn07) THEN
               SELECT COUNT(*) INTO l_n FROM rvk_file
                WHERE rvk01=g_rvm.rvm03
                  AND (rvk04=g_rvn[l_ac].rvn07 OR rvk04='*')
                  AND (rvk02 = '*' OR (rvk02 <> '*' AND rvk02 = g_rvn[l_ac].ima131))
                  AND rvk03 = g_rvn[l_ac].rvn11
                  AND rvkacti='Y'
            ELSE
               SELECT COUNT(*) INTO l_n FROM rvk_file
                WHERE rvk01=g_rvm.rvm03
                  AND (rvk04=g_rvn[l_ac].rvn06 OR rvk04='*')
                  AND (rvk02 = '*' OR (rvk02 <> '*' AND rvk02 = g_rvn[l_ac].ima131))
                  AND rvk03 = g_rvn[l_ac].rvn11
                  AND rvkacti='Y'
            END IF
           #FUN-CB0104 Mark&Add Begin ---

            IF l_n=0 THEN
               CALL cl_err(g_rvn[l_ac].rvn11,'art512',0)
               LET g_rvn[l_ac].rvn11 = g_rvn_t.rvn11
               DISPLAY BY NAME g_rvn[l_ac].rvn11
               NEXT FIELD rvn11    
            END IF

            #TQC-C40243--start add--------------------------
            SELECT imd02 INTO g_rvn[l_ac].rvn11_desc
              FROM imd_file
             WHERE imd01 = g_rvn[l_ac].rvn11  
            #TQC-C40243--end add----------------------------

            SELECT imd20 INTO g_rvn[l_ac].rvn12 FROM imd_file
             WHERE imd01=g_rvn[l_ac].rvn11 AND imdacti='Y'
            SELECT azw08 INTO g_rvn[l_ac].rvn12_desc FROM azw_file
              WHERE azw01=g_rvn[l_ac].rvn12

            DISPLAY BY NAME g_rvn[l_ac].rvn12
            DISPLAY BY NAME g_rvn[l_ac].rvn12_desc
 
         END IF
         LET l_n=0
         SELECT COUNT(*) INTO l_n
           FROM azw_file a,azw_file b
          WHERE a.azw01 = g_rvn[l_ac].rvn12
            AND b.azw01 = g_rvn[l_ac].rvn07
            AND a.azw02 = b.azw02
         IF l_n = 0 THEN
             CALL cl_set_comp_required("rvn13",TRUE)
         ELSE
             CALL cl_set_comp_required("rvn13",FALSE)
         END IF


       BEFORE DELETE
           IF g_rvn_t.rvn02 > 0 AND NOT cl_null(g_rvn_t.rvn02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rvn_file
                    WHERE rvn01 = g_rvm.rvm01
                      AND rvn02 = g_rvn_t.rvn02
                      AND rvnplant = g_rvm.rvmplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rvn_file",g_rvm.rvm01,g_rvn_t.rvn02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 COMMIT WORK
                 LET g_rec_b1 = g_rec_b1 - 1
                 DISPLAY g_rec_b1 TO FORMONLY.cn2
              END IF
           END IF


#TQC-AC0311--------add------------------end------------------------------------

      AFTER FIELD rvn13 #多角貿易代碼
           IF NOT cl_null(g_rvn[l_ac].rvn13) THEN 
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                   g_rvn[l_ac].rvn08 <> g_rvn_t.rvn13 OR cl_null(g_rvn_t.rvn13)) THEN
                   CALL t252_rvn13(g_rvn[l_ac].rvn13,g_rvn[l_ac].rvn12,g_rvn[l_ac].rvn06)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rvn[l_ac].rvn13,g_errno,0)
                      NEXT FIELD rvn13
                   END IF
                END IF
           END IF
           
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rvn[l_ac].* = g_rvn_t.*
              CLOSE t252_bcl1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rvn[l_ac].rvn02,-263,1)
              LET g_rvn[l_ac].* = g_rvn_t.*
           ELSE
              UPDATE rvn_file SET rvn10 = g_rvn[l_ac].rvn10,    #TQC-AC0311
                                  rvn11 = g_rvn[l_ac].rvn11,    #TQC-AC0311
                                  rvn12 = g_rvn[l_ac].rvn12,    #TQC-AC0311
                                  rvn13 = g_rvn[l_ac].rvn13,    #TQC-AC0311
                                  rvn03 = g_rvn[l_ac].rvn03,    #TQC-AC0311
                                  rvn04 = g_rvn[l_ac].rvn04,    #TQC-AC0311
                                  rvn05 = g_rvn[l_ac].rvn05,    #TQC-AC0311
                                  rvn06 = g_rvn[l_ac].rvn06,    #TQC-AC0311
                                  rvn07 = g_rvn[l_ac].rvn07,    #TQC-AC0311
                                  rvn08 = g_rvn[l_ac].rvn08,    #TQC-AC0311
                                  rvn09 = g_rvn[l_ac].rvn09     #TQC-AC0311
                 WHERE rvn01 = g_rvm.rvm01
                   AND rvn02 = g_rvn_t.rvn02
                   AND rvnplant=g_rvm.rvmplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rvn_file",g_rvm.rvm01,g_rvn_t.rvn02,SQLCA.sqlcode,"","",1) 
                 LET g_rvn[l_ac].* = g_rvn_t.*
              ELSE
                 LET g_rvm.rvmmodu = g_user
                 LET g_rvm.rvmdate = g_today
                 UPDATE rvm_file SET rvmmodu = g_rvm.rvmmodu,
                                     rvmdate = g_rvm.rvmdate
                       WHERE rvm01 = g_rvm.rvm01
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rvm_file",g_rvm.rvmmodu,g_rvm.rvmdate,SQLCA.sqlcode,"","",1)
                 END IF
                 DISPLAY BY NAME g_rvm.rvmmodu,g_rvm.rvmdate
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rvn[l_ac].* = g_rvn_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rvn.deleteElement(l_ac)
                 IF g_rec_b1 != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t252_bcl1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033 add
           CLOSE t252_bcl1
           COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rvn13)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz7" 
               LET g_qryparam.default1 = g_rvn[l_ac].rvn13
               LET g_qryparam.arg1 = g_rvn[l_ac].rvn06                             
               CALL cl_create_qry() RETURNING g_rvn[l_ac].rvn13
               CALL t252_rvn13(g_rvn[l_ac].rvn13,g_rvn[l_ac].rvn12,g_rvn[l_ac].rvn06)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rvn13
               END IF
               DISPLAY BY NAME g_rvn[l_ac].rvn13
               NEXT FIELD rvn13
#TQC-AC0311--------add--------------------begin-----------------------------------
            WHEN INFIELD(rvn03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ruc001"
               LET g_qryparam.default1 = g_rvn[l_ac].rvn03
               LET g_qryparam.arg1 = g_rvm.rvm03
               LET g_qryparam.arg2 = g_rvm.rvm04
               CALL cl_create_qry() RETURNING g_rvn[l_ac].rvn06,g_rvn[l_ac].rvn03,g_rvn[l_ac].rvn04
               DISPLAY BY NAME g_rvn[l_ac].rvn03
               DISPLAY BY NAME g_rvn[l_ac].rvn04
               DISPLAY BY NAME g_rvn[l_ac].rvn06
               NEXT FIELD rvn04
            WHEN INFIELD(rvn11)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rvk001"
               LET g_qryparam.default1 = g_rvn[l_ac].rvn11
               LET g_qryparam.arg1 = g_rvm.rvm03
               LET g_qryparam.arg2 = g_rvn[l_ac].ima131
              #FUN-CB0104 Mark&Add Begin ---
              #LET g_qryparam.arg3 = g_rvn[l_ac].rvn06
              #若異店取貨銷售歸屬2.取貨門店且取貨門店不為空時,出貨營運中心根據取貨門店抓取,反之根據需求門店
               IF g_rcj12 = '2' AND NOT cl_null(g_rvn[l_ac].rvn07) THEN
                  LET g_qryparam.arg3 = g_rvn[l_ac].rvn07
               ELSE
                  LET g_qryparam.arg3 = g_rvn[l_ac].rvn06
               END IF
              #FUN-CB0104 Mark&Add End -----
               CALL cl_create_qry() RETURNING g_rvn[l_ac].rvn11,g_rvn[l_ac].rvn12
               DISPLAY BY NAME g_rvn[l_ac].rvn11
               DISPLAY BY NAME g_rvn[l_ac].rvn12
               NEXT FIELD rvn11
#TQC-AC0311--------add----------------------end-------------------------------------------
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
  
    CLOSE t252_bcl1
    COMMIT WORK
    #    CALL t252_b1_fill(g_wc1)        #TQC-AC0311                
    #No.TQC-AC0004  --Begin
    #CALL t252_b2_fill(g_wc2)
    #No.TQC-AC0004  --End  
#   CALL t252_delall()  #carrier
END FUNCTION      
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_b2()
#DEFINE l_ac_t LIKE type_file.num5,
#       l_n     LIKE type_file.num5,
#       l_lock_sw       LIKE type_file.chr1,
#       p_cmd   LIKE type_file.chr1,
#       l_allow_insert  LIKE type_file.num5,
#       l_allow_delete  LIKE type_file.num5
#DEFINE l_rvn03 LIKE rvn_file.rvn03,
#       l_rvn04 LIKE rvn_file.rvn04
#DEFINE l_maxnum LIKE rvnn_file.rvnn07
#DEFINE l_sma133 LIKE sma_file.sma133                       
# 
#        LET g_action_choice=""
#        IF s_shut(0) THEN 
#                RETURN
#        END IF
#        
#        IF cl_null(g_rvm.rvm01) THEN
#                RETURN 
#        END IF
#        
#        SELECT * INTO g_rvm.* FROM rvm_file
#         WHERE rvm01=g_rvm.rvm01
#        IF g_rvm.rvmacti='N' THEN 
#           CALL cl_err(g_rvm.rvm01,'mfg1000',0)
#           RETURN 
#        END IF
#        
#        IF g_rvm.rvmconf <>'N' THEN
#          CALL cl_err('',9022,0)
#          RETURN
#        END IF
#     
#        SELECT sma133 INTO l_sma133 FROM sma_file
#        LET g_msg = cl_getmsg('art-422',g_lang) 
#     
#        CALL cl_opmsg('b')
#        
#        LET g_forupd_sql= "SELECT rvnn02,rvnn03,rvnn04,'',rvnn05,'',rvnn06,'','','',",
#                          "'','','',rvnn07,'',''",
#                          "  FROM rvnn_file",
#                          " WHERE rvnn01 = ? AND rvnn02 = ?",
#                          " FOR UPDATE "
#        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#
#        DECLARE t252_bcl CURSOR FROM g_forupd_sql
#        
#        LET l_allow_insert=cl_detail_input_auth("insert")
#        LET l_allow_delete=cl_detail_input_auth("delete")
#        DROP TABLE rvn_ins_temp
#        SELECT rvn_file.* FROM rvn_file WHERE 1=0 INTO TEMP rvn_ins_temp
# 
#        INPUT ARRAY g_rvnn WITHOUT DEFAULTS FROM s_rvnn.*
#                ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
#                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#                        APPEND ROW= l_allow_insert)
#        BEFORE INPUT
#                IF g_rec_b2 !=0 THEN 
#                        CALL fgl_set_arr_curr(l_ac)
#                END IF
#        BEFORE ROW
#                LET p_cmd =''
#                LET l_ac =ARR_CURR()
#                LET l_lock_sw ='N'
#                LET l_n =ARR_COUNT()
#                
#                BEGIN WORK 
#                OPEN t252_cl USING g_rvm.rvm01
#                IF STATUS THEN
#                   CALL cl_err("OPEN t252_cl:",STATUS,0)
#                   CLOSE t252_cl
#                   ROLLBACK WORK
#                END IF
#                
#                FETCH t252_cl INTO g_rvm.*
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_rvm.rvm01,SQLCA.sqlcode,0)
#                   CLOSE t252_cl
#                   ROLLBACK WORK 
#                   RETURN
#                END IF
#                IF g_rec_b2>=l_ac THEN 
#                   LET p_cmd ='u'
#                   LET g_rvnn_t.*=g_rvnn[l_ac].*
#                   LET g_rvnn_o.*=g_rvnn[l_ac].*
#                   OPEN t252_bcl USING g_rvm.rvm01,g_rvnn_t.rvnn02
#                   IF STATUS THEN
#                      CALL cl_err("OPEN t252_bcl:",STATUS,0)
#                      LET l_lock_sw='Y'
#                   ELSE
#                      FETCH t252_bcl INTO g_rvnn[l_ac].*
#                      IF SQLCA.sqlcode THEN
#                         CALL cl_err(g_rvnn_t.rvnn03,SQLCA.sqlcode,0)
#                         LET l_lock_sw="Y"
#                      END IF
#                      SELECT ruc07,rvnn05_desc,ima02,ima131,ruc16,
#                             gfe02,ruc18,ruc18_01
#                        INTO g_rvnn[l_ac].ruc07,g_rvnn[l_ac].rvnn05_desc,g_rvnn[l_ac].rvnn06_desc,
#                             g_rvnn[l_ac].ima131,g_rvnn[l_ac].ruc16,g_rvnn[l_ac].ruc16_desc,
#                             g_rvnn[l_ac].ruc18,g_rvnn[l_ac].ruc18_01
#                        FROM cs_rvnn_temp
#                       WHERE rvnn01 = g_rvm.rvm01 AND rvnnplant = g_rvm.rvmplant
#                         AND rvnn02 = g_rvnn_t.rvnn02
#                      DISPLAY BY NAME g_rvnn[l_ac].ruc07,g_rvnn[l_ac].rvnn05_desc,g_rvnn[l_ac].rvnn06_desc,
#                                      g_rvnn[l_ac].ima131,g_rvnn[l_ac].ruc16,g_rvnn[l_ac].ruc16_desc,
#                                      g_rvnn[l_ac].ruc18,g_rvnn[l_ac].ruc18_01
#                   END IF
#                END IF
#           
#       BEFORE INSERT
#                LET l_n=ARR_COUNT()
#                LET p_cmd='a'
#                INITIALIZE g_rvnn[l_ac].* TO NULL
#                LET g_rvnn_t.*=g_rvnn[l_ac].*
#                CALL cl_show_fld_cont()
#                NEXT FIELD rvnn02
#                
#       AFTER INSERT
#                IF INT_FLAG THEN
#                   CALL cl_err('',9001,0)
#                   LET INT_FLAG=0
#                   CANCEL INSERT
#                END IF
#                INSERT INTO rvnn_file(rvnn01,rvnn02,rvnn03,rvnn04,rvnn05,rvnn06,rvnn07,
#                                      rvnnplant,rvnnlegal)
#                              VALUES(g_rvm.rvm01,g_rvnn[l_ac].rvnn02,g_rvnn[l_ac].rvnn03,
#                                     g_rvnn[l_ac].rvnn04,g_rvnn[l_ac].rvnn05,g_rvnn[l_ac].rvnn06,
#                                     g_rvnn[l_ac].rvnn07,g_rvm.rvmplant,g_rvm.rvmlegal)
#                IF SQLCA.sqlcode THEN
#                CALL cl_err3("ins","rvnn_file",g_rvm.rvm01,g_rvnn[l_ac].rvnn02,SQLCA.sqlcode,"","",1)
#                        CANCEL INSERT
#                ELSE
#                    CALL t252_b_ins()
#                    IF SQLCA.sqlcode THEN
#                       CALL cl_err3("ins","rvn_file","","",SQLCA.sqlcode,"","",1) 
#                       ROLLBACK WORK
#                    END IF
#                    MESSAGE 'INSERT O.K.'
#                    COMMIT WORK
#                    LET g_rec_b2=g_rec_b2+1
#                    DISPLAY g_rec_b2 TO FORMONLY.cn2
#                END IF
#                
#      BEFORE FIELD rvnn02
#        IF cl_null(g_rvnn[l_ac].rvnn02) OR g_rvnn[l_ac].rvnn02 = 0 THEN 
#            SELECT MAX(rvnn02)+1 INTO g_rvnn[l_ac].rvnn02 FROM rvnn_file
#             WHERE rvnn01=g_rvm.rvm01
#            IF g_rvnn[l_ac].rvnn02 IS NULL THEN
#               LET g_rvnn[l_ac].rvnn02=1
#            END IF
#        END IF
#         
#      AFTER FIELD rvnn02 #項次
#        IF NOT cl_null(g_rvnn[l_ac].rvnn02) THEN 
#           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
#              g_rvnn[l_ac].rvnn02 <> g_rvnn_t.rvnn02) THEN
#              IF g_rvnn[l_ac].rvnn02<=0 THEN
#                 CALl cl_err('','aec-994',0)
#                 NEXT FIELD rvnn02
#              ELSE
#                 SELECT COUNT(*) INTO l_n FROM rvnn_file
#                  WHERE rvnn01 = g_rvm.rvm01 AND rvnn02 = g_rvnn[l_ac].rvnn02
#                 IF l_n>0 THEN
#                    CALL cl_err('',-239,0)
#                    LET g_rvnn[l_ac].rvnn02=g_rvnn_t.rvnn02
#                    NEXT FIELD rvnn02
#                 END IF
#              END IF
#            END IF
#         END IF
#         
#      AFTER FIELD rvnn03,rvnn04 #來源單號+來源項次              
#        IF NOT cl_null(g_rvnn[l_ac].rvnn03) THEN 
#           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
#              g_rvnn[l_ac].rvnn03 <> g_rvnn_o.rvnn03 OR cl_null(g_rvnn_o.rvnn03)) THEN
#              SELECT COUNT(*) INTO l_n FROM ruc_file
#               WHERE ruc08 = g_rvnn[l_ac].rvnn03
#                 AND ruc27 = g_rvm.rvm04
#              IF l_n=0 THEN
#                 CALL cl_err(g_rvnn[l_ac].rvnn03,'art-244',0)
#                 LET g_rvnn[l_ac].rvnn03 = g_rvnn_t.rvnn03
#                 DISPLAY BY NAME g_rvnn[l_ac].rvnn03
#                 NEXT FIELD rvnn03
#              ELSE
#                 LET g_rvnn_o.rvnn03 = g_rvnn[l_ac].rvnn03   
#              END IF
#           END IF
#        ELSE 
#            LET g_rvnn_o.rvnn03 = ''
#        END IF      
#        IF NOT cl_null(g_rvnn[l_ac].rvnn04) THEN 
#           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
#              g_rvnn[l_ac].rvnn04 <> g_rvnn_o.rvnn04 OR cl_null(g_rvnn_o.rvnn04)) THEN
#              SELECT COUNT(*) INTO l_n FROM ruc_file
#               WHERE ruc09 = g_rvnn[l_ac].rvnn04
#                 AND ruc27 = g_rvm.rvm04
#              IF l_n=0 THEN
#                 CALL cl_err(g_rvnn[l_ac].rvnn04,'art-362',0)
#                 LET g_rvnn[l_ac].rvnn04 = g_rvnn_t.rvnn04
#                 DISPLAY BY NAME g_rvnn[l_ac].rvnn04
#                 NEXT FIELD rvnn04
#              ELSE
#                 LET g_rvnn_o.rvnn04 = g_rvnn[l_ac].rvnn04      
#              END IF
#           END IF
#        ELSE 
#            LET g_rvnn_o.rvnn04 = ''
#        END IF      
#        IF NOT cl_null(g_rvnn[l_ac].rvnn03) AND NOT cl_null(g_rvnn[l_ac].rvnn04) THEN
#           IF p_cmd='a'OR (p_cmd='u' AND 
#              (g_rvnn[l_ac].rvnn03<>g_rvnn_t.rvnn03 OR g_rvnn[l_ac].rvnn04<>g_rvnn_t.rvnn04)) THEN
#              CALL t252_rvnn03()
#              IF cl_null(g_errno) THEN
#                 CALL t252_b_init()
#              END IF
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('',g_errno,0)
#                 NEXT FIELD CURRENT
#              END IF
#           END IF
#        END IF
#      
#      AFTER FIELD rvnn07 #本次分貨量
#         IF NOT cl_null(g_rvnn[l_ac].rvnn07) THEN 
#            IF p_cmd = 'a' OR (p_cmd = 'u' AND 
#               g_rvnn[l_ac].rvnn07 <> g_rvnn_t.rvnn07) THEN
#               IF g_rvnn[l_ac].rvnn07 < 0 THEN
#                  CALL cl_err(g_rvnn[l_ac].rvnn07,'axm-948',0)
#                  LET g_rvnn[l_ac].rvnn07 = g_rvnn_t.rvnn07
#                  NEXT FIELD rvnn07
#               ELSE
#                  LET g_rvnn_o.rvnn07 = g_rvnn[l_ac].rvnn07
#                  LET l_maxnum = g_rvnn[l_ac].ruc18 * (100+l_sma133)/100
#                  IF l_maxnum < (g_rvnn[l_ac].ruc18 -g_rvnn[l_ac].ruc18_01+g_rvnn[l_ac].rvnn07) THEN
#                     ERROR g_rvnn[l_ac].rvnn07,'+',(g_rvn[l_ac].ruc18 - g_rvnn[l_ac].ruc18_01),g_msg,l_sma133,'%)=',l_maxnum
#                     LET g_rvnn[l_ac].rvnn07 = g_rvnn_t.rvnn07
#                     NEXT FIELD rvnn07
#                  END IF
#                  IF t252_chk_count() THEN                   
#                     IF cl_confirm2('mfg0047',g_rvnn[l_ac].rvnn07) THEN
#                        DISPLAY BY NAME g_rvnn[l_ac].rvnn07
#                     ELSE
#                        LET g_rvnn[l_ac].rvnn07=g_rvnn_o.rvnn07
#                        DISPLAY BY NAME g_rvnn[l_ac].rvnn07
#                     END IF
#                  END IF
#               END IF
#            END IF
#         END IF
#         
#       BEFORE DELETE                      
#           IF g_rvnn_t.rvnn02 > 0 AND NOT cl_null(g_rvnn_t.rvnn02) THEN
#              IF NOT cl_delb(0,0) THEN
#                 CANCEL DELETE
#              END IF
#              IF l_lock_sw = "Y" THEN
#                 CALL cl_err("", -263, 1)
#                 CANCEL DELETE
#              END IF
#              DELETE FROM rvnn_file
#                    WHERE rvnn01 = g_rvm.rvm01
#                      AND rvnn02 = g_rvnn_t.rvnn02
#                      AND rvnnplant = g_rvm.rvmplant
#              IF SQLCA.sqlcode THEN   
#                 CALL cl_err3("del","rvnn_file",g_rvm.rvm01,g_rvnn_t.rvnn02,SQLCA.sqlcode,"","",1)  
#                 ROLLBACK WORK
#                 CANCEL DELETE
#              ELSE
#                 IF g_rvnn[l_ac].ruc07 MATCHES '[356]' THEN
#                    LET g_sql = "SELECT ruc02,ruc03 FROM ruc_file",
#                                " WHERE ruc01 = ? AND ruc08 = ?",
#                                "   AND ruc09 = ? AND ruc07 = ? "
#                    DECLARE ruc_cs2 CURSOR FROM g_sql
#                    FOREACH ruc_cs2 USING g_rvnn[l_ac].rvnn05,g_rvnn[l_ac].rvnn03,
#                                          g_rvnn[l_ac].rvnn04,g_rvnn[l_ac].ruc07
#                                    INTO l_rvn03,l_rvn04
#                    DELETE FROM rvn_file
#                     WHERE rvn01 = g_rvm.rvm01 AND rvnplant = g_rvm.rvmplant
#                       AND rvn03 = l_rvn03
#                       AND rvn04 = l_rvn04
#                    END FOREACH
#                 ELSE
#                    DELETE FROM rvn_file
#                     WHERE rvn01 = g_rvm.rvm01 AND rvnplant = g_rvm.rvmplant
#                       AND rvn03 = g_rvnn[l_ac].rvnn03
#                       AND rvn04 = g_rvnn[l_ac].rvnn04
#                 END IF
#                 IF SQLCA.sqlcode THEN   
#                    CALL cl_err3("del","rvn_file",g_rvm.rvm01,g_rvnn_t.rvnn02,SQLCA.sqlcode,"","",1)  
#                    ROLLBACK WORK
#                    CANCEL DELETE
#                 ELSE
#                    COMMIT WORK
#                    LET g_rec_b2 = g_rec_b2 - 1
#                    DISPLAY g_rec_b2 TO FORMONLY.cn2
#                 END IF
#               END IF
#           END IF
# 
#        ON ROW CHANGE
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              LET g_rvnn[l_ac].* = g_rvnn_t.*
#              CLOSE t252_bcl
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           IF l_lock_sw = 'Y' THEN
#              CALL cl_err(g_rvnn[l_ac].rvnn02,-263,1)
#              LET g_rvnn[l_ac].* = g_rvnn_t.*
#           ELSE
#             
#              UPDATE rvnn_file SET rvnn02 = g_rvnn[l_ac].rvnn02,
#                                   rvnn03 = g_rvnn[l_ac].rvnn03,
#                                   rvnn04 = g_rvnn[l_ac].rvnn04,
#                                   rvnn05 = g_rvnn[l_ac].rvnn05,
#                                   rvnn06 = g_rvnn[l_ac].rvnn06,
#                                   rvnn07 = g_rvnn[l_ac].rvnn07
#                 WHERE rvnn01 = g_rvm.rvm01 AND rvnnplant = g_rvm.rvmplant
#                   AND rvnn02 = g_rvnn_t.rvnn02
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("upd","rvnn_file",g_rvm.rvm01,g_rvnn_t.rvnn02,SQLCA.sqlcode,"","",1) 
#                 LET g_rvnn[l_ac].* = g_rvnn_t.*
#              ELSE
#                 CALL t252_b_upd()
#                 IF SQLCA.sqlcode THEN
#                    CALL cl_err3("ins","rvn_file","","",SQLCA.sqlcode,"","",1) 
#                    ROLLBACK WORK
#                 END IF
#                 LET g_rvm.rvmmodu = g_user
#                 LET g_rvm.rvmdate = g_today
#                 UPDATE rvm_file SET rvmmodu = g_rvm.rvmmodu,
#                                     rvmdate = g_rvm.rvmdate
#                       WHERE rvm01 = g_rvm.rvm01 AND rvmplant = g_rvm.rvmplant
#                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                     CALL cl_err3("upd","rvm_file",g_rvm.rvmmodu,g_rvm.rvmdate,SQLCA.sqlcode,"","",1)
#                 END IF
#                 DISPLAY BY NAME g_rvm.rvmmodu,g_rvm.rvmdate
#                 MESSAGE 'UPDATE O.K.'
#                 COMMIT WORK
#              END IF
#           END IF
# 
#        AFTER ROW
#           LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              IF p_cmd = 'u' THEN
#                 LET g_rvnn[l_ac].* = g_rvnn_t.*
#              END IF
#              CLOSE t252_bcl
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           CLOSE t252_bcl
#           COMMIT WORK
# 
#      ON ACTION CONTROLO                        
#           IF INFIELD(rvnn02) AND l_ac > 1 THEN
#              LET g_rvnn[l_ac].* = g_rvnn[l_ac-1].*
#              LET g_rvnn[l_ac].rvnn02 = g_rec_b2 + 1
#              NEXT FIELD rvn02
#           END IF
# 
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
# 
#        ON ACTION controlp                         
#          CASE
#            WHEN INFIELD(rvnn03)                     
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_ruc08" 
#               LET g_qryparam.default1 = g_rvnn[l_ac].rvnn03
#               LET g_qryparam.arg1 = g_rvm.rvm04
#               IF g_rvm.rvm06 = 'N' THEN
#                  LET g_qryparam.where = " obn06='",g_rvm.rvm03,"' AND ",
#                                         "obn08='",g_rvm.rvm05,"'"
#               END IF
#               CALL cl_create_qry() RETURNING g_rvnn[l_ac].rvnn03,g_rvnn[l_ac].rvnn04
#               DISPLAY BY NAME g_rvnn[l_ac].rvnn03,g_rvnn[l_ac].rvnn04
#               CALL t252_rvnn03()
#               IF cl_null(g_errno) THEN
#                  CALL t252_b_init()
#               END IF
#               IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('',g_errno,0)
#               END IF               
#               NEXT FIELD rvnn03
#            OTHERWISE EXIT CASE
#          END CASE
#     
#        ON ACTION CONTROLF
#           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
# 
#        ON ACTION about       
#           CALL cl_about()     
# 
#        ON ACTION help          
#           CALL cl_show_help()  
# 
#        ON ACTION controls                    
#           CALL cl_set_head_visible("","AUTO")  
#    END INPUT
#  
#    CLOSE t252_bcl
#    COMMIT WORK
#    CALL t252_b1_fill(g_wc1)
#    CALL t252_b2_fill(g_wc2)
#    CALL t252_delall()
#END FUNCTION                 
# 
#No.TQC-AC0004  --End  

#No.TQC-AC0004  --Begin
FUNCTION t252_delall()
 
#  SELECT COUNT(*) INTO g_cnt FROM rvnn_file
#   WHERE rvnn01 = g_rvm.rvm01
   SELECT COUNT(*) INTO g_cnt FROM rvn_file
    WHERE rvn01 = g_rvm.rvm01
 
   IF g_cnt = 0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rvm_file WHERE rvm01 = g_rvm.rvm01
#     DELETE FROM rvn_file WHERE rvn01 = g_rvm.rvm01
      CLEAR FROM
   END IF
 
END FUNCTION                 
#No.TQC-AC0004  --End  
                                
FUNCTION t252_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvm.rvm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t252_cl USING g_rvm.rvm01
   IF STATUS THEN
      CALL cl_err("OPEN t252_cl:", STATUS, 1)
      CLOSE t252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t252_cl INTO g_rvm.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvm.rvm01,SQLCA.sqlcode,0)    
       CLOSE t252_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   IF g_rvm.rvmacti ='N' THEN    
      CALL cl_err(g_rvm.rvm01,'mfg1000',0)
      RETURN
   END IF
   IF g_rvm.rvmconf <>'N' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
   CALL t252_show()
 
   WHILE TRUE
      LET g_rvm.rvmmodu = g_user
      LET g_rvm.rvmdate = g_today
 
      CALL t252_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rvm.*=g_rvm_t.*
         CALL t252_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rvm.rvm01 <> g_rvm_t.rvm01 THEN            
         UPDATE rvn_file SET rvn01 = g_rvm.rvm01
          WHERE rvn01 = g_rvm_t.rvm01
         #No.TQC-AC0004  --Begin
         #UPDATE rvnn_file SET rvnn01 = g_rvm.rvm01
         # WHERE rvnn01 = g_rvm_t.rvm01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            #CALL cl_err3("upd","rvnn_file",g_rvm_t.rvm01,"",SQLCA.sqlcode,"","rvnn",1)  
            CALL cl_err3("upd","rvn_file",g_rvm_t.rvm01,"",SQLCA.sqlcode,"","rvn",1)  
            CONTINUE WHILE
         END IF
         #No.TQC-AC0004  --End  
      END IF
 
      UPDATE rvm_file SET rvm_file.* = g_rvm.*
       WHERE rvm01 = g_rvm.rvm01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvm_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t252_cl
   COMMIT WORK
   CALL t252_show()
END FUNCTION          
                
FUNCTION t252_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvm.rvm01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t252_cl USING g_rvm.rvm01
   IF STATUS THEN
      CALL cl_err("OPEN t252_cl:", STATUS, 1)
      CLOSE t252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t252_cl INTO g_rvm.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvm.rvm01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_rvm.rvmacti='N' THEN 
      CALL cl_err(g_rvm.rvm01,'mfg1000',0)
      RETURN 
   END IF
   IF g_rvm.rvmconf <>'N' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
   
   CALL t252_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rvm01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rvm.rvm01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM rvm_file WHERE rvm01 = g_rvm.rvm01 
      DELETE FROM rvn_file WHERE rvn01 = g_rvm.rvm01 
      #No.TQC-AC0004  --Begin
      #DELETE FROM rvnn_file WHERE rvnn01 = g_rvm.rvm01
      #No.TQC-AC0004  --End  
      CLEAR FORM
      CALL g_rvn.clear()
      #FUN-BA0100 add begin-----------------------
      CALL g_rvn1.clear()
      CALL g_rvn2.clear()
      #FUN-BA0100 add end-----------------------
      #No.TQC-AC0004  --Begin
      #CALL g_rvnn.clear()
      #No.TQC-AC0004  --End  
      OPEN t252_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t252_cs
         CLOSE t252_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t252_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t252_cs
         CLOSE t252_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t252_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t252_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t252_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t252_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t252_copy()
DEFINE l_newno     LIKE rvm_file.rvm01
DEFINE l_oldno     LIKE rvm_file.rvm01
DEFINE l_cnt       LIKE type_file.num5
DEFINE li_result   LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rvm.rvm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   LET g_before_input_done = FALSE
   CALL t252_set_entry('a')
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rvm01
       BEFORE INPUT
          CALL cl_set_docno_format("rvm01")
       AFTER FIELD rvm01
          IF NOT cl_null(l_newno) THEN
#               CALL s_check_no("art",l_newno,g_rvm_t.rvm01,"P","rvm_file","rvm01","") #FUN-A70130 mark
               #CALL s_check_no("art",l_newno,g_rvm_t.rvm01,"I2","rvm_file","rvm01","") #FUN-A70130 mod
                CALL s_check_no("art",l_newno,"","I2","rvm_file","rvm01","") #FUN-A70130 mod  #FUN-B50026 mod
                    RETURNING li_result,l_newno
                IF (NOT li_result) THEN                                                            
                    NEXT FIELD rvm01                                                                                      
                END IF  
          END IF
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(rvm01)                        
                LET g_t1=s_get_doc_no(l_newno)
#               CALL q_smy(FALSE,FALSE,g_t1,'art','3') RETURNING g_t1   #FUN-A70130--mark--
                CALL q_oay(FALSE,FALSE,g_t1,'I2','art') RETURNING g_t1  #FUN-A70130--end--
                LET l_newno=g_t1
                DISPLAY l_newno TO rvm01
            OTHERWISE EXIT CASE
           END CASE
 
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
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rvm.rvm01
      ROLLBACK WORK
  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rvm_file         
    WHERE rvm01 = g_rvm.rvm01
    INTO TEMP y
#  CALL s_auto_assign_no("art",l_newno,g_today,"3","rvm_file","rvm01","","","") #FUN-A70130 mark
   CALL s_auto_assign_no("art",l_newno,g_today,"I2","rvm_file","rvm01","","","") #FUN-A70130 mod
          RETURNING li_result,l_newno
      IF (NOT li_result) THEN                                                                           
         RETURN
      END IF
   DISPLAY l_newno TO rvm01
   UPDATE y
       SET rvm01 = l_newno,  
           rvm02 = g_today,  
           rvmuser = g_user,   
           rvmgrup = g_grup,   
           rvmoriu = g_user,   #TQC-A30041 ADD
           rvmorig = g_grup,   #TQC-A30041 ADD
           rvmmodu = NULL,     
           rvmcrat = g_today,  
           rvmacti = 'Y',
           rvmconf = 'N',
           rvmconu = NULL,
           rvmcond = NULL 
 
   INSERT INTO rvm_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rvm_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rvn_file         
    WHERE rvn01 = g_rvm.rvm01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rvn01=l_newno
 
   INSERT INTO rvn_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK             #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rvn_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK              #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rvm.rvm01
   SELECT rvm_file.* INTO g_rvm.* 
     FROM rvm_file 
    WHERE rvm01 = l_newno
   CALL t252_u()
   #No.TQC-AC0004  --Begin
   #CALL t252_b2()
   #No.TQC-AC0004  --End  
   #SELECT rvm_file.* INTO g_rvm.*  #FUN-C80046
   #  FROM rvm_file                 #FUN-C80046
   # WHERE rvm01 = l_oldno          #FUN-C80046
   CALL t252_show()
 
END FUNCTION
 
FUNCTION t252_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvm.rvm01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t252_cl USING g_rvm.rvm01
   IF STATUS THEN
      CALL cl_err("OPEN t252_cl:", STATUS, 1)
      CLOSE t252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t252_cl INTO g_rvm.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvm.rvm01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_rvm.rvmconf <>'N' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
        
   LET g_success = 'Y'
 
   CALL t252_show()
 
   IF cl_exp(0,0,g_rvm.rvmacti) THEN                   
      LET g_chr=g_rvm.rvmacti
      IF g_rvm.rvmacti='Y' THEN
         LET g_rvm.rvmacti='N'
      ELSE
         LET g_rvm.rvmacti='Y'
      END IF
 
      UPDATE rvm_file SET  rvmacti = g_rvm.rvmacti,
                           rvmmodu = g_user,
                           rvmdate = g_today
       WHERE rvm01=g_rvm.rvm01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rvm_file",g_rvm.rvm01,"",SQLCA.sqlcode,"","",1)  
         LET g_rvm.rvmacti=g_chr
      END IF
   END IF
 
   CLOSE t252_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rvmacti,rvmmodu,rvmdate
     INTO g_rvm.rvmacti,g_rvm.rvmmodu,g_rvm.rvmdate 
     FROM rvm_file
    WHERE rvm01 = g_rvm.rvm01
   DISPLAY BY NAME g_rvm.rvmacti,g_rvm.rvmmodu,g_rvm.rvmdate
   CALL cl_set_field_pic("","","","","",g_rvm.rvmacti)
END FUNCTION
 
#No.TQC-AC0004  --Begin
#FUNCTION t252_bp_refresh()
# 
#  DISPLAY ARRAY g_rvnn TO s_rvnn.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
#     BEFORE DISPLAY
#        EXIT DISPLAY
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#  END DISPLAY
# 
#END FUNCTION                                                       
#No.TQC-AC0004  --End  
 
#審核前檢查
FUNCTION t252_y_chk()
DEFINE l_n LIKE type_file.num5
 
#是否已審核    
       INSERT INTO err_temp 
       SELECT 'rvn09',rvn09,'','9023',1
         FROM rvn_file,ruc_file
        WHERE rvn06 = ruc01
          AND rvn03 = ruc02
          AND rvn04 = ruc03
          AND ruc22 IS NOT NULL
          AND rvn01 = g_rvm.rvm01
          AND rvnplant = g_rvm.rvmplant
#出貨機構不存在          
       INSERT INTO err_temp
       SELECT 'rvn11',rvn11,rvn13,'art-438',1
         FROM rvn_file
        WHERE rvn12 IS NULL
          AND rvn01 = g_rvm.rvm01
          AND rvnplant = g_rvm.rvmplant
#需求機構出機構是否一致
       INSERT INTO err_temp 
       SELECT 'rvn06,rvn12',rvn06||'|'||rvn09,rvn13,'art-338',1
         FROM rvn_file
        WHERE rvn06 = rvn12
          AND rvn01 = g_rvm.rvm01
          AND rvnplant = g_rvm.rvmplant
#流程代碼不存在                    
       INSERT INTO err_temp
       SELECT 'rvn06,rvn12',rvn06||'|'||rvn12,rvn03||'|'||rvn04,'art-470',1
         FROM rvn_file
        WHERE rvn13 IS NULL
          AND rvn01 = g_rvm.rvm01
          #No.FUN-960130 ..begin
          #AND EXISTS (SELECT 1 FROM azp_file a,azp_file b
          #             WHERE a.azp01=rvn12
          #               AND b.azp01=rvn07
          #               AND a.azp03<>b.azp03)
          AND EXISTS (SELECT 1 FROM azw_file a,azw_file b
                       WHERE a.azw01=rvn12
                         AND b.azw01=rvn07
                         AND a.azw02<>b.azw02)
          #No.FUN-960130 ..end
#流程代碼不符合條件       
       INSERT INTO err_temp
       SELECT 'rvn13,rvn06,rvn12',rvn13||'|'||rvn06||'|'||rvn12,'','art-285',1
         FROM rvn_file
        WHERE NOT EXISTS (SELECT 1 FROM poy_file
                       WHERE poy04 = rvn06
                         AND poy01 = rvn13
                         AND poy02 = (SELECT MIN(poy02) FROM poy_file 
                                       WHERE poy01 = rvn13))
          AND rvn13 IS NOT NULL
          AND rvn01 = g_rvm.rvm01       #No.FUN-9C0079
          #No.FUN-960130 ..begin
          #AND EXISTS (SELECT 1 FROM azp_file a,azp_file b
          #             WHERE a.azp01=rvn12
          #               AND b.azp01=rvn07
          #               AND a.azp03<>b.azp03)                              
          AND EXISTS (SELECT 1 FROM azw_file a,azw_file b
                       WHERE a.azw01=rvn12
                         AND b.azw01=rvn07
                         AND a.azw02<>b.azw02)                              
          #No.FUN-960130 ..end
       INSERT INTO err_temp
       SELECT 'rvn13,rvn06,rvn12',rvn13||'|'||rvn06||'|'||rvn12,'','art-285',1
         FROM rvn_file 
        WHERE NOT EXISTS (SELECT 1 FROM poy_file
                       WHERE poy04 = rvn12
                         AND poy01 = rvn13
                         AND poy02 = (SELECT MAX(poy02) FROM poy_file 
                                       WHERE poy01 = rvn13))
          AND rvn13 IS NOT NULL 
          AND rvn01 = g_rvm.rvm01       #No.FUN-9C0079
          #No.FUN-960130 ..begin
          #AND EXISTS (SELECT 1 FROM azp_file a,azp_file b
          #             WHERE a.azp01=rvn12
          #               AND b.azp01=rvn07
          #               AND a.azp03<>b.azp03)
          AND EXISTS (SELECT 1 FROM azw_file a,azw_file b
                       WHERE a.azw01=rvn12
                         AND b.azw01=rvn07
                         AND a.azw02<>b.azw02)
          #No.FUN-960130 ..end
    SELECT COUNT(*) INTO l_n FROM err_temp
    IF l_n > 0 THEN
       LET g_success = 'N'
    END IF
END FUNCTION
 
FUNCTION t252_temptable()
 
   SELECT * FROM pmm_file WHERE 1=0 INTO TEMP pmm_temp
   SELECT * FROM pmn_file WHERE 1=0 INTO TEMP pmn_temp
   SELECT * FROM oea_file WHERE 1=0 INTO TEMP oea_temp
   SELECT * FROM oeb_file WHERE 1=0 INTO TEMP oeb_temp
   SELECT * FROM rvn_file WHERE 1=0 INTO TEMP rvn_temp2
   SELECT rvn_file.*,rty06 FROM rvn_file,rty_file WHERE 1=0 INTO TEMP rvn_temp3
   SELECT adl_file.* FROM adl_file WHERE 1 = 0 INTO TEMP adl_temp
   SELECT adk_file.* FROM adk_file WHERE 1 = 0 INTO TEMP adk_temp
   SELECT rva_file.* FROM rva_file WHERE 1 = 0 INTO TEMP rva_temp
   SELECT rvb_file.* FROM rvb_file WHERE 1 = 0 INTO TEMP rvb_temp
   SELECT rvu_file.* FROM rvu_file WHERE 1 = 0 INTO TEMP rvu_temp
   SELECT rvv_file.* FROM rvv_file WHERE 1 = 0 INTO TEMP rvv_temp
   SELECT oga_file.* FROM oga_file WHERE 1 = 0 INTO TEMP oga_temp
   SELECT ogb_file.* FROM ogb_file WHERE 1 = 0 INTO TEMP ogb_temp
   SELECT img_file.* FROM img_file WHERE 1 = 0 INTO TEMP img_temp
   SELECT tlf_file.* FROM tlf_file WHERE 1 = 0 INTO TEMP tlf_temp
   #No.FUN-9C0088 ...begin
   #SELECT azp01 plant1,azp01 plant2,azp01 plant3,rth01 item,rth02 unit,
   #       ima131,rtl04,rtl05,rtl06,rth04 price,rthacti rtg08
   #  FROM rth_file,ima_file,rtl_file,azp_file
   # WHERE 1=0 INTO TEMP price_temp
   CREATE TEMP TABLE price_temp(
   plant1   LIKE azp_file.azp01,
   plant2   LIKE azp_file.azp01,
   plant3   LIKE azp_file.azp01,
   item     LIKE rth_file.rth01,
   unit     LIKE rth_file.rth02,
   ima131   LIKE ima_file.ima131,
   rtl04    LIKE rtl_file.rtl04,
   rtl05    LIKE rtl_file.rtl05,
   rtl06    LIKE rtl_file.rtl06,
   price    LIKE rth_file.rth04,
   rtg08    LIKE rtg_file.rtg08);
   #No.FUN-9C0088 ...end
END FUNCTION
 
FUNCTION t252_y_droptable()
    DROP TABLE rvn_temp
    DROP TABLE rvn_temp2
    #No.TQC-AC0004  --Begin
    #DROP TABLE rvnn_temp
    #No.TQC-AC0004  --End  
    DROP TABLE pmm_temp
    DROP TABLE pmn_temp
    DROP TABLE oea_temp
    DROP TABLE oeb_temp
    DROP TABLE rvn_temp3
    DROP TABLE adl_temp
    DROP TABLE adk_temp
    DROP TABLE rva_temp
    DROP TABLE rvb_temp
    DROP TABLE rvu_temp
    DROP TABLE rvv_temp
    DROP TABLE ruo_temp
    DROP TABLE rup_temp
    DROP TABLE oga_temp
    DROP TABLE ogb_temp
    DROP TABLE img_temp
    DROP TABLE tlf_temp
    DROP TABLE price_temp
END FUNCTION
 
FUNCTION t252_init_progress()
DEFINE li_n LIKE type_file.num5
DEFINE li_total LIKE type_file.num5
DEFINE l_sql STRING
 
    LET li_total = 0
    #No.FUN-960130 ..begin
    #LET l_sql = "SELECT COUNT(*)",
    #            "  FROM (SELECT DISTINCT rvn06,rvn07,rvn12",
    #            "          FROM azp_file a,azp_file b,rvn_file",
    #            "         WHERE a.azp03 = b.azp03",
    #            "           AND a.azp01 <> b.azp01",
    #            "           AND a.azp01 = rvn07",
    #            "           AND b.azp01 = rvn12",
    #            "           AND rvn10 > 0",
    #            "           AND rvn01 = '",g_rvm.rvm01,"'",
    #            "           AND rvnplant = '",g_rvm.rvmplant,"')"
    LET l_sql = "SELECT COUNT(*)",
                "  FROM (SELECT DISTINCT rvn06,rvn07,rvn12",
                "          FROM azw_file a,azw_file b,rvn_file",
                "         WHERE a.azw02 = b.azw02",
                "           AND a.azw01 <> b.azw01",
                "           AND a.azw01 = rvn07",
                "           AND b.azw01 = rvn12",
                "           AND rvn10 > 0",
                "           AND rvn01 = '",g_rvm.rvm01,"'",
                "           AND rvnplant = '",g_rvm.rvmplant,"')"
    #No.FUN-960130 ..end
    PREPARE progress1 FROM l_sql
    EXECUTE progress1 INTO li_n
    LET li_total = li_n
    #No.FUN-960130 ..begin
    #LET l_sql = "SELECT COUNT(*)",
    #            "  FROM (SELECT DISTINCT rty01,rty06,rvn13",
    #            "          FROM azp_file a,azp_file b,rty_file,rvn_file",
    #            "         WHERE a.azp03 <> b.azp03",
    #            "           AND a.azp01 = rvn06",
    #            "           AND b.azp01 = rvn12",
    #            "           AND rty01 = rvn06",
    #            "           AND rty02 = rvn09",
    #            "           AND rvn10 > 0",
    #            "           AND rvn01 = '",g_rvm.rvm01,"'",
    #            "           AND rvnplant = '",g_rvm.rvmplant,"')"
    LET l_sql = "SELECT COUNT(*)",
                "  FROM (SELECT DISTINCT rty01,rty06,rvn13",
                "          FROM azw_file a,azw_file b,rty_file,rvn_file",
                "         WHERE a.azw02 <> b.azw02",
                "           AND a.azw01 = rvn06",
                "           AND b.azw01 = rvn12",
                "           AND rty01 = rvn06",
                "           AND rty02 = rvn09",
                "           AND rvn10 > 0",
                "           AND rvn01 = '",g_rvm.rvm01,"'",
                "           AND rvnplant = '",g_rvm.rvmplant,"')"
    #No.FUN-960130 ..end
    PREPARE progress2 FROM l_sql
    EXECUTE progress2 INTO li_n
    LET li_total = li_total + li_n
    IF g_rvm.rvm07 = 'Y' THEN
       SELECT COUNT(DISTINCT rvn08) INTO li_n
         FROM rvm_file,rvn_file
        WHERE rvm01 = rvn01
          AND rvmplant = rvnplant
          AND rvm07 = 'Y'
          AND rvm01 = g_rvm.rvm01
          AND rvmplant = g_rvm.rvmplant
       LET li_total = li_total + li_n
    END IF
    LET g_total_count = li_total
    CALL cl_progress_bar(li_total)
    LET g_current_count = 0
END FUNCTION
 
FUNCTION t252_progressing(ps_log)
DEFINE ps_log STRING
DEFINE li_percent LIKE type_file.num5
 
    LET li_percent = g_current_count * 100 / g_total_count
    DISPLAY ps_log,li_percent,g_current_count,g_total_count,li_percent
         TO proc,progbar,curr,total,p
    CALL ui.Interface.refresh()
    LET g_current_count = g_current_count + 1
END FUNCTION
 
FUNCTION t252_showmsg()
DEFINE l_n LIKE type_file.num5
    
    SELECT COUNT(*) INTO l_n FROM err_temp
    IF l_n > 0 THEN
       LET g_success = 'N'
       DECLARE err_temp_cs CURSOR FOR SELECT * FROM err_temp
       FOREACH err_temp_cs INTO l_err.*
         CALL s_errmsg(l_err.field,l_err.data,l_err.msg,l_err.errcode,l_err.n)
       END FOREACH 
       DELETE FROM err_temp
    END IF
    CALL s_showmsg()
    IF ui.Window.forName("w_progbar") IS NOT NULL THEN
       CALl cl_close_progress_bar()
    END IF
END FUNCTION
 
FUNCTION t252_y() #審核
DEFINE l_rvmconu_desc LIKE gen_file.gen02 
DEFINE g_db_type LIKE type_file.chr3
DEFINE l_rvn11   LIKE rvn_file.rvn11   #add FUN-AB0078
DEFINE l_rvn12   LIKE rvn_file.rvn12   #add FUN-AB0078
 
   IF cl_null(g_rvm.rvm01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF   
#CHI-C30107 ------------ add ------------ begin   
   IF g_rvm.rvmacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF

   IF g_rvm.rvmconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF

   IF g_rvm.rvmconf='X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN
      RETURN
    END IF
#CHI-C30107 ------------ add ------------ end
#TQC-AC0230 -----------STA
   IF g_rec_b1 = 0 THEN
      CALL cl_err('','art-486',0)
      RETURN
   END IF
#TQC-AC0230 -----------END
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t252_cl USING g_rvm.rvm01
   IF STATUS THEN
      CALL cl_err("OPEN t252_cl:", STATUS, 1)
      CLOSE t252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t252_cl INTO g_rvm.*    
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t252_cl
      ROLLBACK WORK
      RETURN
     END IF
 
   IF g_rvm.rvmacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_rvm.rvmconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
   
   IF g_rvm.rvmconf='X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
      
   CALL s_showmsg_init()
   #add FUN-AB0078
    DECLARE t252_rvn11 CURSOR FOR 
     SELECT rvn11,rvn12 FROM rvn_file 
      WHERE rvn01 = g_rvm.rvm01
   FOREACH t252_rvn11 INTO l_rvn11,l_rvn12
        IF NOT s_chk_ware1(l_rvn11,l_rvn12) THEN #检查仓库是否属于当前门店 
           LET g_success='N'
           CLOSE t252_cl
           CALL t252_showmsg()
           ROLLBACK WORK 
           RETURN
        END IF
   END FOREACH
   #end FUN-AB0078
 
   CALL t252_y_chk()
   IF g_success = 'N' THEN
      CLOSE t252_cl
      CALL t252_showmsg()
      ROLLBACK WORK
      RETURN
   END IF
   COMMIT WORK
#CHI-C30107 ------------- mark -------------- begin
#  IF NOT cl_confirm('axm-108') THEN 
#     RETURN
#  END IF 
#CHI-C30107 ------------- mark -------------- end
   CALL t252_temptable()
   #No.FUN-A10123 ..mark
   #LET g_db_type = cl_db_get_database_type()
   #IF g_db_type = 'ORA' THEN
   #   CALL t252_create_plsql()
   #END IF
   #No.FUN-A10123 ..mark
   #FUN-C80072 add sta
  #SELECT rcj09 INTO g_rcj09 FROM rcj_file               #FUN-CB0104 Mark
   IF g_rcj09 = 'Y' THEN 
      CALL p810_temp('1')
   END IF    
   #FUN-C80072 add end

   BEGIN WORK
   CALL t252_init_progress()
   
#產生機構調撥單
   CALL t252_transfer()
   IF g_totsuccess = 'N' THEN
      CLOSE t252_cl
      CALL t252_showmsg()
      ROLLBACK WORK
      #FUN-C80072 add sta
      IF g_rcj09 = 'Y' THEN 
         CALL p810_temp('2')
      END IF    
      #FUN-C80072 add end  
      RETURN
   END IF
 
#TQC-B20004--mark--str--
##訂單->出貨->采購->收貨->入庫
#   CALL t252_po_post()
#   IF g_totsuccess = 'N' THEN
#      CLOSE t252_cl
#      CALL t252_showmsg()
#      ROLLBACK WORK   
#      CALL t252_y_droptable()   
#      RETURN
#   END IF
#TQC-B20004--mark--end--
 
#派車單   
   CALL t252_dispatch()
   IF g_totsuccess = 'N' THEN
      CLOSE t252_cl
      CALL t252_showmsg()
      ROLLBACK WORK
      #FUN-C80072 add sta
      IF g_rcj09 = 'Y' THEN 
         CALL p810_temp('2')
      END IF    
      #FUN-C80072 add end  
      CALL t252_y_droptable()
      RETURN
   END IF
   
#回寫需求匯總表ruc_file
#如果是Oracle采用pl/sql提高效率
    #No.FUN-A10123...mark
    #LET g_db_type = cl_db_get_database_type()
    #IF g_db_type = 'ORA' THEN
    #   CALL t252_update_plsql()
    #END IF
    #IF g_db_type <> 'ORA' OR g_db_type IS NULL THEN
    #   CALL t252_update()
    #END IF
    #No.FUN-A10123...mark
       CALL t252_update()    #No.FUN-A10123
    IF g_totsuccess = 'N' THEN
       CLOSE t252_cl
       CALL t252_showmsg()
       CALL cl_close_progress_bar()
       ROLLBACK WORK
       #FUN-C80072 add sta
       IF g_rcj09 = 'Y' THEN 
          CALL p810_temp('2')
       END IF    
       #FUN-C80072 add end  
       CALL t252_y_droptable()
       RETURN
    END IF
        UPDATE rvm_file SET rvmconf = 'Y',
                            rvmconu = g_user,
                            rvmcond = g_today,
                            rvmmodu = g_user,
                            rvmdate = g_today,
                            rvm09 = g_rvm.rvm09,
                            rvm900 = '1'
               WHERE rvm01 = g_rvm.rvm01 AND rvmplant = g_rvm.rvmplant
            IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rvm_file",g_rvm.rvm01,"",STATUS,"","",1) 
              LET g_totsuccess = 'N'
            ELSE
             IF SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("upd","rvm_file",g_rvm.rvm01,"","9050","","",1) 
              LET g_totsuccess = 'N'          
             END IF
            END IF
   IF g_totsuccess = 'Y' THEN
      COMMIT WORK
#      CALL cl_close_progress_bar()        #TQC-AC0230 add  #TQC-AC0311 mark
      LET g_rvm.rvmconf = 'Y'
      LET g_rvm.rvmconu = g_user
      LET g_rvm.rvmcond = g_today
      LET g_rvm.rvmmodu = g_user
      LET g_rvm.rvmdate = g_today
      LET g_rvm.rvm900 = '1'
      DISPLAY BY NAME g_rvm.rvmconf,g_rvm.rvmconu,g_rvm.rvmcond,
                      g_rvm.rvmmodu,g_rvm.rvmdate,g_rvm.rvm09
#                     ,g_rvm.rvm900                                    #FUN-B30028 mark      
      SELECT gen02 INTO l_rvmconu_desc
        FROM gen_file
       WHERE gen01 = g_rvm.rvmconu
         AND genacti = 'Y'
      DISPLAY l_rvmconu_desc TO rvmconu_desc
      CALL cl_set_field_pic(g_rvm.rvmconf,"","","","","")
      CALL cl_err('','art-169',0)
      CALL cl_set_act_visible('confirm,void',FALSE)
   ELSE
      ROLLBACK WORK
   END IF
   #FUN-C80072 add sta
   IF g_rcj09 = 'Y' THEN 
      CALL p810_temp('2')
   END IF    
   #FUN-C80072 add end  
   CALL t252_y_droptable()   
END FUNCTION
 
FUNCTION t252_transfer()
DEFINE l_rvn RECORD LIKE rvn_file.*
DEFINE l_ruo RECORD LIKE ruo_file.*
DEFINE l_rup RECORD LIKE rup_file.*
DEFINE l_sql STRING
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE l_flag    LIKE type_file.num5
DEFINE l_fac     LIKE ima_file.ima31_fac
DEFINE li_result LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_no      LIKE ruo_file.ruo01   #預設單別
DEFINE l_ruo01   LIKE ruo_file.ruo01
DEFINE l_ruo901  LIKE ruo_file.ruo901 #TQC-B20004
DEFINE l_ruo904  LIKE ruo_file.ruo904 #TQC-B20004
DEFINE l_azw02   LIKE azw_file.azw02  #TQC-B20004
DEFINE l_sma142  LIKE sma_file.sma142 #TQC-B20004
DEFINE l_sma143  LIKE sma_file.sma143 #TQC-B20004
DEFINE l_ruo14   LIKE ruo_file.ruo14  #TQC-B20004
DEFINE l_imd20   LIKE imd_file.imd20  #TQC-B20004
DEFINE l_ruoplant LIKE ruo_file.ruoplant  #FUN-C80072 add     
#TQC-B20004--mark--str--
#    #No.FUN-960130 ...begin 
#    #SELECT COUNT(*) INTO l_n
#    #  FROM azp_file a,azp_file b,rvn_file
#    # WHERE a.azp03 = b.azp03
#    #   AND a.azp01 <> b.azp01
#    #   AND a.azp01 = rvn07
#    #   AND b.azp01 = rvn12
#    #   AND rvn10 > 0
#    #   AND rvn01 = g_rvm.rvm01
#    #   AND rvnplant = g_rvm.rvmplant
#    SELECT COUNT(*) INTO l_n
#      FROM azw_file a,azw_file b,rvn_file
#     WHERE a.azw02 = b.azw02
#       AND a.azw01 <> b.azw01
#       AND a.azw01 = rvn07
#       AND b.azw01 = rvn12
#       AND rvn10 > 0
#       AND rvn01 = g_rvm.rvm01
#       AND rvnplant = g_rvm.rvmplant
#    #No.FUN-960130 ... end
#    IF l_n = 0 THEN
#       RETURN
#    END IF
#    DELETE FROM rvn_temp2
#    #No.FUN-960130 ..begin
#    #INSERT INTO rvn_temp2
#    #SELECT rvn_file.* 
#    #  FROM azp_file a,azp_file b,rvn_file 
#    # WHERE a.azp03 = b.azp03
#    #   AND a.azp01 <> b.azp01
#    #   AND a.azp01 = rvn07
#    #   AND b.azp01 = rvn12
#    #   AND rvn10 > 0
#    #   AND rvn01 = g_rvm.rvm01
#    #   AND rvnplant = g_rvm.rvmplant
#    INSERT INTO rvn_temp2
#    SELECT rvn_file.* 
#      FROM azw_file a,azw_file b,rvn_file 
#     WHERE a.azw02 = b.azw02
#       AND a.azw01 <> b.azw01
#       AND a.azw01 = rvn07
#       AND b.azw01 = rvn12
#       AND rvn10 > 0
#       AND rvn01 = g_rvm.rvm01
#       AND rvnplant = g_rvm.rvmplant
#    #No.FUN-960130 ..end
#    DECLARE rvn_cs1 CURSOR FOR SELECT DISTINCT rvn06,rvn07,rvn12 FROM rvn_temp2
##    LET l_sql  = "SELECT rvn03,rvn04,rvn09,rvn10,rvn11 ",              #TQC-AC0230 mark
#     LET l_sql  = "SELECT rvn02,rvn03,rvn04,rvn09,rvn10,rvn11 ",        #TQC-AC0230
#                 "  FROM rvn_temp2",
#                 " WHERE rvn06 = ? ",
#                 "   AND rvn07 = ? ",
#                 "   AND rvn12 = ? "
#    PREPARE rvn_cs_pre2 FROM l_sql
#    DECLARE rvn_cs2 CURSOR FOR rvn_cs_pre2
#    SELECT ruo_file.* FROM ruo_file WHERE 1 = 0 INTO TEMP ruo_temp
#    SELECT rup_file.* FROM rup_file WHERE 1 = 0 INTO TEMP rup_temp
#    CALL cl_getmsg('art-560',g_lang) RETURNING g_msg
#    FOREACH rvn_cs1 INTO l_rvn.rvn06,l_rvn.rvn07,l_rvn.rvn12
#      IF STATUS THEN
#            CALL s_errmsg('','','Foreach rvn_cs1',STATUS,1)
#            LET g_success = 'N'
#            CONTINUE FOREACH
#      END IF
#      CALL t252_progressing(g_msg)
#      CALL t252_azp(l_rvn.rvn06) RETURNING l_dbs
#      IF NOT cl_null(g_errno) THEN
#           LET g_success = 'N'
#           CALL s_errmsg('rvn06',l_rvn.rvn06,'',g_errno,1)
#           EXIT FOREACH
#      END IF
##取預設單別arti099
#      #CALL t252_def_no(l_dbs,'art','F') RETURNING l_no #FUN-A50102
#      CALL t252_def_no(l_rvn.rvn06,'art','J1') RETURNING l_no #FUN-A50102    #FUN-A70130
#      IF cl_null(l_no) THEN
#         CALL s_errmsg('',l_dbs,'art F','art-330',1)
#         LET g_success = 'N'
#      END IF
##     CALL s_auto_assign_no("art",l_no,g_today,"F","ruo_file","ruo01",l_rvn.rvn06,"","") #FUN-A70130 mark
#      CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01",l_rvn.rvn06,"","") #FUN-A70130 mod
#          RETURNING li_result,l_ruo.ruo01
#      IF (NOT li_result) THEN                                                                           
#          LET g_success = 'N'
#          CALL s_errmsg('ruo01',l_no,'','sub-145',1)
#          CONTINUE FOREACH
#      END IF
#      SELECT azw02 INTO l_ruo.ruolegal FROM azw_file WHERE azw01=l_rvn.rvn07  #No.FUN-A70123
##TQC-A70088 --add
#   #  INSERT INTO ruo_temp (ruo01,ruopos,ruoplant)VALUES(l_ruo.ruo01,'N',l_rvn.rvn07)
#      #INSERT INTO ruo_temp (ruo01,ruopos,ruoplant,ruolegal)VALUES(l_ruo.ruo01,'N',l_rvn.rvn07,g_legal)         #No.FUN-A70123
#       INSERT INTO ruo_temp (ruo01,ruopos,ruoplant,ruolegal)VALUES(l_ruo.ruo01,'N',l_rvn.rvn07,l_ruo.ruolegal)  #No.FUN-A70123
##TQC-A70088 --end  add ruolegal
#      IF SQLCA.sqlcode THEN
#         LET g_success='N'
#         CALL s_errmsg('','','ins ruo_temp',SQLCA.sqlcode,1)
#      END IF
#      LET l_ruo.ruo12t = TIME
#      UPDATE ruo_temp SET ruo02 = '3',
#                          ruo03 = g_rvm.rvm01,
#                          ruo04 = l_rvn.rvn12,
#                          ruo05 = l_rvn.rvn06,
#                          ruo06 = l_rvn.rvn07,
#                          ruo07 = g_today,
#                          ruo08 = g_user,
#                          ruo10 = g_today,
#                          ruo11 = g_user,
#                          ruo12 = g_today,
#                          ruo13 = g_user,
#                          ruoconf = '2',
#                          ruouser = g_user,
#                          ruogrup = g_grup,
#                          ruocrat = g_today,
#                          ruooriu = g_user,      #TQC-A40036 ADD--
#                          ruoorig = g_grup,      #TQC-A40036 ADD--
#                          ruoacti = 'Y',
#                          ruo10t = l_ruo.ruo12t,
#                          ruo12t = l_ruo.ruo12t
#        WHERE ruo01 = l_ruo.ruo01
#
#       LET g_cnt = 1
#       FOREACH rvn_cs2 USING l_rvn.rvn06,l_rvn.rvn07,l_rvn.rvn12
#  #                      INTO l_rvn.rvn03,l_rvn.rvn04,l_rvn.rvn09,                  #TQC-AC0230 mark
#                         INTO l_rvn.rvn02,l_rvn.rvn03,l_rvn.rvn04,l_rvn.rvn09,      #TQC-AC0230
#                             l_rvn.rvn10,l_rvn.rvn11
#             
#         SELECT ima25 INTO l_rup.rup04
#           FROM ima_file
#          WHERE ima01 = l_rvn.rvn09
#         SELECT ruc11,ruc14,ruc16
#           INTO l_rup.rup05,l_rup.rup06,l_rup.rup07
#           FROM ruc_file
#          WHERE ruc01 = l_rvn.rvn06
#            AND ruc02 = l_rvn.rvn03
#            AND ruc03 = l_rvn.rvn04
#         CALL s_umfchk('',l_rup.rup04,l_rup.rup07) RETURNING l_flag,l_fac
#         SELECT rtz07 
#           INTO l_rup.rup13
#           FROM rtz_file
#          WHERE rtz01 = l_rvn.rvn06
#            
#         SELECT COUNT(*) INTO l_n FROM rup_temp
#          WHERE rup03 = l_rvn.rvn09
#            AND rup01 = l_ruo.ruo01
#            AND COALESCE(rup05,'X') = COALESCE(l_rup.rup05,'X')
#            AND COALESCE(rup06,'X') = COALESCE(l_rup.rup06,'X')
#            AND COALESCE(rup07,'X') = COALESCE(l_rup.rup07,'X')
#         IF l_n>0 THEN
#            UPDATE rup_temp SET rup12 = rup12 + l_rvn.rvn10,
#                                rup16 = rup16 + l_rvn.rvn10
#             WHERE rup01 = l_ruo.ruo01 AND rup03 = l_rvn.rvn09
#         ELSE
##TQC-A70088 --begin
#         #  INSERT INTO rup_temp (rup01,rup02,rupplant)VALUES(l_ruo.ruo01,g_cnt,l_rvn.rvn07)
#            #INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal)VALUES(l_ruo.ruo01,g_cnt,l_rvn.rvn07,g_legal)        #No.FUN-A70123
#        #    INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal)VALUES(l_ruo.ruo01,g_cnt,l_rvn.rvn07,l_ruo.ruolegal)  #No.FUN-A70123   #TQC-AC0230 mark
#            INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal,rup17)VALUES(l_ruo.ruo01,g_cnt,l_rvn.rvn07,l_ruo.ruolegal,l_rvn.rvn02)  #TQC-AC0230
##TQC-A70088 --end   add ruplegal
#            IF SQLCA.sqlcode THEN
#               LET g_success='N'
#               CALL s_errmsg('','','ins rup_temp',SQLCA.sqlcode,1)
#            END IF
#            UPDATE rup_temp SET rup03 = l_rvn.rvn09,
#                                rup04 = l_rup.rup04,
#                                rup05 = l_rup.rup05,
#                                rup06 = l_rup.rup06,
#                                rup07 = l_rup.rup07,
#                                rup08 = l_fac,
#                                rup09 = l_rvn.rvn11,
#                                rup12 = l_rvn.rvn10,
#                                rup13 = l_rup.rup13,
#                                rup16 = l_rvn.rvn10
#             WHERE rup01 = l_ruo.ruo01 AND rup02 = g_cnt
#             LET g_cnt = g_cnt + 1
#          END IF
#        END FOREACH
#        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ruo_file SELECT * FROM ruo_temp WHERE ruo01=?" #FUN-A50102
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_rvn.rvn06, 'ruo_file')," SELECT * FROM ruo_temp WHERE ruo01=?" #FUN-A50102
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
#        CALL cl_parse_qry_sql(l_sql, l_rvn.rvn06) RETURNING l_sql  #FUN-A50102
#        PREPARE ruo_ins FROM l_sql
#        EXECUTE ruo_ins USING l_ruo.ruo01
#        CALL cl_progressing(g_msg)
#     END FOREACH
#      DECLARE ruo_temp_cs CURSOR FOR SELECT ruo01 FROM ruo_temp
#      FOREACH ruo_temp_cs INTO l_ruo.ruo01
##撥入單 
#        SELECT ruo04,ruo05 INTO l_ruo.ruo04,l_ruo.ruo05 FROM ruo_temp WHERE ruo01=l_ruo.ruo01
#        CALL t252_azp(l_ruo.ruo05) RETURNING l_dbs
#        IF NOT cl_null(g_errno) THEN
#           LET g_success = 'N'
#           CALL s_errmsg('ruo04',l_ruo.ruo04,'',g_errno,1)
#           CONTINUE FOREACH
#        END IF
#        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rup_file SELECT * FROM rup_temp WHERE rup01=?"  #FUN-A50102
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo05, 'rup_file')," SELECT * FROM rup_temp WHERE rup01=?" #FUN-A50102
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
#        CALL cl_parse_qry_sql(l_sql, l_ruo.ruo05) RETURNING l_sql  #FUN-A50102
#        PREPARE rup_ins FROM l_sql
#        EXECUTE rup_ins USING l_ruo.ruo01
##庫存異動
#        DECLARE rup_cs CURSOR FOR SELECT * FROM rup_temp WHERE rup01 = l_ruo.ruo01
#        FOREACH rup_cs INTO l_rup.*
#           CALL t252_s2(l_rup.*)
#           IF g_success = 'N' THEN
#              CONTINUE FOREACH
#           END IF
#        END FOREACH
##撥出單  
#        CALL t252_azp(l_ruo.ruo04) RETURNING l_dbs
#        IF NOT cl_null(g_errno) THEN
#           LET g_success = 'N'
#           CALL s_errmsg('ruo05',l_ruo.ruo04,'',g_errno,1)
#           CONTINUE FOREACH
#        END IF
##       CALL s_auto_assign_no("art",l_no,g_today,"F","ruo_file","ruo01",l_ruo.ruo04,"","") #FUN-A70130 mark
#        CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01",l_ruo.ruo04,"","") #FUN-A70130 mod
#          RETURNING li_result,l_ruo01
#        IF (NOT li_result) THEN                                                                           
#          LET g_success = 'N'
#          CALL s_errmsg('ruo01',l_no,'','sub-145',1)
#          CONTINUE FOREACH
#        END IF        
#        SELECT azw02 INTO l_ruo.ruolegal FROM azw_file WHERE azw01=l_ruo.ruo04
#        UPDATE ruo_temp SET ruo01 = l_ruo01,
#                            ruoconf='1',  
#                            ruoplant = l_ruo.ruo04,
#                            ruolegal = l_ruo.ruolegal
#         WHERE ruo01 = l_ruo.ruo01
#        UPDATE rup_temp SET rup01 = l_ruo01,
#                            rupplant = l_ruo.ruo04,
#                            ruplegal = l_ruo.ruolegal
#         WHERE rup01 = l_ruo.ruo01
#        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ruo_file SELECT * FROM ruo_temp WHERE ruo01 = ?" #FUN-A50102
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo04, 'ruo_file')," SELECT * FROM ruo_temp WHERE ruo01=?" #FUN-A50102
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
#        CALL cl_parse_qry_sql(l_sql, l_ruo.ruo04) RETURNING l_sql  #FUN-A50102
#        PREPARE ruo_ins1 FROM l_sql
#        EXECUTE ruo_ins1 USING l_ruo01
#        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rup_file SELECT * FROM rup_temp WHERE rup01 = ?" #FUN-A50102
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo04, 'rup_file')," SELECT * FROM rup_temp WHERE rup01=?" #FUN-A50102
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
#        CALL cl_parse_qry_sql(l_sql, l_ruo.ruo04) RETURNING l_sql  #FUN-A50102
#        PREPARE rup_ins1 FROM l_sql
#        EXECUTE rup_ins1 USING l_ruo01
##庫存異動
#        DECLARE rup_cs1 CURSOR FOR SELECT * FROM rup_temp WHERE rup01 = l_ruo01
#        FOREACH rup_cs1 INTO l_rup.*
#           CALL t252_s1(l_rup.*)
#           IF g_success = 'N' THEN
#              CONTINUE FOREACH
#           END IF
#        END FOREACH
#      END FOREACH
#TQC-B20004--mark--end--
#TQC-B20004--add--str--
    SELECT COUNT(*) INTO l_n
      FROM rvn_file
     WHERE rvn10 > 0
       AND rvn01 = g_rvm.rvm01
       AND rvnplant = g_rvm.rvmplant
    IF l_n = 0 THEN
       RETURN
    END IF
    DELETE FROM rvn_temp2   
    INSERT INTO rvn_temp2
    SELECT rvn_file.* 
      FROM rvn_file 
     WHERE rvn10 > 0
       AND rvn01 = g_rvm.rvm01
       AND rvnplant = g_rvm.rvmplant
   #FUN-CB0104 Mark&Add Begin ---
   #DECLARE rvn_cs1 CURSOR FOR SELECT DISTINCT rvn06,rvn12,rvn13 FROM rvn_temp2
   #若異店取貨銷售歸屬為2.取貨營運中心則抓取rvn07收貨營運中心
    IF g_rcj12 = '2' THEN 
       LET g_sql = "SELECT DISTINCT COALESCE(rvn07,rvn06),rvn12,rvn13 FROM rvn_temp2"
    ELSE
       LET g_sql = "SELECT DISTINCT rvn06,rvn12,rvn13 FROM rvn_temp2"
    END IF
    PREPARE rvn_pre1 FROM g_sql
    DECLARE rvn_cs1 CURSOR FOR rvn_pre1
   #FUN-CB0104 Mark&Add End -----
    SELECT ruo_file.* FROM ruo_file WHERE 1 = 0 INTO TEMP ruo_temp
    SELECT rup_file.* FROM rup_file WHERE 1 = 0 INTO TEMP rup_temp
    CALL cl_getmsg('art-560',g_lang) RETURNING g_msg
    FOREACH rvn_cs1 INTO l_rvn.rvn06,l_rvn.rvn12,l_rvn.rvn13
      IF STATUS THEN
            CALL s_errmsg('','','Foreach rvn_cs1',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
      END IF
     #FUN-CB0104 Mark&Add Begin ---
     #LET l_sql  = "SELECT rvn02,rvn03,rvn04,rvn09,rvn10,rvn11 ",
     #             "  FROM rvn_temp2",
     #             " WHERE rvn06 = '",l_rvn.rvn06,"'",
     #             "   AND rvn12 = '",l_rvn.rvn12,"'"
      IF g_rcj12 = '2' THEN
         LET l_sql  = "SELECT rvn02,rvn03,rvn04,rvn09,rvn10,rvn11,rvn06,COALESCE(rvn07,rvn06) ",
                      "  FROM rvn_temp2",
                      " WHERE COALESCE(rvn07,rvn06) = '",l_rvn.rvn06,"'",
                      "   AND rvn12 = '",l_rvn.rvn12,"'"
      ELSE
         LET l_sql  = "SELECT rvn02,rvn03,rvn04,rvn09,rvn10,rvn11,rvn06,rvn07 ",
                      "  FROM rvn_temp2",
                      " WHERE rvn06 = '",l_rvn.rvn06,"'",
                      "   AND rvn12 = '",l_rvn.rvn12,"'"
      END IF
     #FUN-CB0104 Mark&Add End -----
      IF cl_null(l_rvn.rvn13) THEN
         LET l_sql = l_sql,"   AND rvn13 IS NULL "
      ELSE
         LET l_sql  = l_sql,"   AND rvn13 =  '",l_rvn.rvn13,"'"
      END IF
      PREPARE rvn_cs_pre2 FROM l_sql
      DECLARE rvn_cs2 CURSOR FOR rvn_cs_pre2
      CALL t252_progressing(g_msg)
      #取預設單別arti099
      CALL t252_def_no(l_rvn.rvn12,'art','J1') RETURNING l_no 
      IF cl_null(l_no) THEN
         CALL s_errmsg('',l_rvn.rvn12,'art F','art-330',1)
         LET g_success = 'N'
      END IF
      CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01",l_rvn.rvn12,"","") 
          RETURNING li_result,l_ruo.ruo01
      IF (NOT li_result) THEN                                                                           
          LET g_success = 'N'
          CALL s_errmsg('ruo01',l_no,'','sub-145',1)
          CONTINUE FOREACH
      END IF
      SELECT azw02 INTO l_ruo.ruolegal FROM azw_file WHERE azw01=l_rvn.rvn12 
      INSERT INTO ruo_temp (ruo01,ruopos,ruoplant,ruolegal)VALUES(l_ruo.ruo01,'N',l_rvn.rvn12,l_ruo.ruolegal) 
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins ruo_temp',SQLCA.sqlcode,1)
      END IF
      SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = l_rvn.rvn06
      LET l_ruo904 = NULL
      IF l_ruo.ruolegal = l_azw02 THEN
         LET l_ruo901 = 'N'
      ELSE
         LET l_ruo901 = 'Y'
         LET l_ruo904 = l_rvn.rvn13
      END IF

      LET l_sql = "SELECT sma142,sma143 FROM ",cl_get_target_table(l_rvn.rvn12,'sma_file')
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_rvn.rvn12) RETURNING l_sql
      PREPARE sma_pre FROM l_sql
      EXECUTE sma_pre INTO l_sma142,l_sma143
      IF l_sma142 = 'Y' THEN   #在途管理
         IF l_sma143 = '1' THEN
            LET l_imd20 = l_rvn.rvn12
         ELSE
            LET l_imd20 = l_rvn.rvn06
         END IF
         LET l_sql = "SELECT imd01 FROM ",cl_get_target_table(l_imd20,'imd_file'),
                     " WHERE imd10 = 'W' AND imd22 = 'Y' ",
                     "   AND imd20 = '",l_imd20,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_imd20) RETURNING l_sql
         PREPARE imd01_pre FROM l_sql
         EXECUTE imd01_pre INTO l_ruo14
      ELSE
         LET l_ruo14 = NULL
      END IF      

      UPDATE ruo_temp SET ruo02 = '3',
                          ruo03 = g_rvm.rvm01,
                          ruo04 = l_rvn.rvn12,
                          ruo05 = l_rvn.rvn06,
                          ruo06 = l_rvn.rvn07,
                          ruo07 = g_today,
                          ruo08 = g_user,
                          ruo14 = l_ruo14,
                          ruo15 = 'N',
                          ruo901 = l_ruo901,
                          ruo904 = l_ruo904,
                          ruoconf = '0',
                          ruouser = g_user,
                          ruogrup = g_grup,
                          ruocrat = g_today,
                          ruooriu = g_user,      
                          ruoorig = g_grup,     
                          ruoacti = 'Y'
        WHERE ruo01 = l_ruo.ruo01
       LET g_cnt = 1
       FOREACH rvn_cs2 INTO l_rvn.rvn02,l_rvn.rvn03,l_rvn.rvn04,l_rvn.rvn09, 
                           #l_rvn.rvn10,l_rvn.rvn11
                            l_rvn.rvn10,l_rvn.rvn11,l_rvn.rvn06,l_rvn.rvn07
          SELECT ima25 INTO l_rup.rup04
            FROM ima_file
           WHERE ima01 = l_rvn.rvn09
          SELECT ruc11,ruc14,ruc16
            INTO l_rup.rup05,l_rup.rup06,l_rup.rup07
            FROM ruc_file
           WHERE ruc01 = l_rvn.rvn06
             AND ruc02 = l_rvn.rvn03
             AND ruc03 = l_rvn.rvn04
          CALL s_umfchk('',l_rup.rup04,l_rup.rup07) RETURNING l_flag,l_fac
          LET l_rvn.rvn10 = s_digqty(l_rvn.rvn10,l_rup.rup07)    #FUN-910088--add--
 
          #FUN-C90049 mark beign---
          #SELECT rtz07
          #  INTO l_rup.rup13
          #  FROM rtz_file
          # WHERE rtz01 = l_rvn.rvn06
          #FUN-C90049 mark end-----
         #FUN-CB0104 Mark&Add Begin ---
         #CALL s_get_coststore(l_rvn.rvn06,l_rvn.rvn09) RETURNING l_rup.rup13    #FUN-C90049 add
          IF g_rcj12 = '2' THEN
             CALL s_get_coststore(l_rvn.rvn07,l_rvn.rvn09) RETURNING l_rup.rup13
          ELSE
             CALL s_get_coststore(l_rvn.rvn06,l_rvn.rvn09) RETURNING l_rup.rup13
          END IF
         #FUN-CB0104 Mark&Add Begin ---
 
          SELECT COUNT(*) INTO l_n FROM rup_temp
           WHERE rup03 = l_rvn.rvn09
             AND rup01 = l_ruo.ruo01
             AND COALESCE(rup05,'X') = COALESCE(l_rup.rup05,'X')
             AND COALESCE(rup06,'X') = COALESCE(l_rup.rup06,'X')
             AND COALESCE(rup07,'X') = COALESCE(l_rup.rup07,'X')
             AND rup22 = l_rvn.rvn07 #FUN-CC0057
         #IF l_n>0 THEN                               #FUN-CC0057
          IF l_n>0 AND l_rvn.rvn06 = l_rvn.rvn07 THEN #FUN-CC0057
             UPDATE rup_temp SET rup12 = rup12 + l_rvn.rvn10,
                                 rup16 = rup16 + l_rvn.rvn10
              WHERE rup01 = l_ruo.ruo01 AND rup03 = l_rvn.rvn09
                AND rup22 = l_rvn.rvn07 #FUN-CC0057
          ELSE
             INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal,rup17)
             VALUES(l_ruo.ruo01,g_cnt,l_rvn.rvn12,l_ruo.ruolegal,l_rvn.rvn02)
             IF SQLCA.sqlcode THEN
                LET g_success='N'
                CALL s_errmsg('','','ins rup_temp',SQLCA.sqlcode,1)
             END IF
             UPDATE rup_temp SET rup03 = l_rvn.rvn09,
                                 rup04 = l_rup.rup04,
                                 rup05 = l_rup.rup05,
                                 rup06 = l_rup.rup06,
                                 rup07 = l_rup.rup07,
                                 rup08 = l_fac,
                                 rup09 = l_rvn.rvn11,
                                 rup12 = l_rvn.rvn10,
                                 rup13 = l_rup.rup13,
                                 rup16 = l_rvn.rvn10,
                                 rup22 = l_rvn.rvn07, #FUN-CC0057
                                 rup18 = 'N'
              WHERE rup01 = l_ruo.ruo01 AND rup02 = g_cnt
              LET g_cnt = g_cnt + 1
           END IF
        END FOREACH
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_rvn.rvn12, 'ruo_file')," SELECT * FROM ruo_temp WHERE ruo01=?" 
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
        CALL cl_parse_qry_sql(l_sql, l_rvn.rvn12) RETURNING l_sql  
        PREPARE ruo_ins FROM l_sql
        EXECUTE ruo_ins USING l_ruo.ruo01
        CALL cl_progressing(g_msg)
     END FOREACH
      DECLARE ruo_temp_cs CURSOR FOR SELECT ruo01 FROM ruo_temp
      FOREACH ruo_temp_cs INTO l_ruo.ruo01
        SELECT ruo04,ruo05 INTO l_ruo.ruo04,l_ruo.ruo05 FROM ruo_temp WHERE ruo01=l_ruo.ruo01
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo04, 'rup_file')," SELECT * FROM rup_temp WHERE rup01=?" 
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
        CALL cl_parse_qry_sql(l_sql, l_ruo.ruo04) RETURNING l_sql  
        PREPARE rup_ins FROM l_sql
        EXECUTE rup_ins USING l_ruo.ruo01
      END FOREACH
#TQC-B20004--add--end--

      #FUN-C80072 add sta
      IF g_success = 'Y' THEN 
         IF g_rcj09 = 'Y' THEN  
            DECLARE ruo_temp_cs1 CURSOR FOR SELECT ruo01,ruoplant,ruo05 FROM ruo_temp
            FOREACH ruo_temp_cs1 INTO l_ruo.ruo01,l_ruo.ruoplant,l_ruo.ruo05
               CALL p810_out_yes(l_ruo.ruo01,l_ruo.ruoplant,'N')
               LET l_sql =  "SELECT ruo01,ruoplant FROM ",cl_get_target_table(l_ruo.ruo05,'ruo_file'),
                            " WHERE ruo011 = ? AND ruoplant = ? "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
               CALL cl_parse_qry_sql(l_sql, l_ruo.ruo05) RETURNING l_sql  
               PREPARE ruo_sel FROM l_sql
               EXECUTE ruo_sel USING l_ruo.ruo01,l_ruo.ruo05 INTO l_ruo01,l_ruoplant
               IF g_sma.sma142 = 'Y' THEN
                  CALL p810_in_yes(l_ruo01,l_ruoplant,'N')
               END IF
            END FOREACH  
         END IF 
      END IF 
      #FUN-C80072 add end  

      IF g_success = 'N' THEN
         LET g_totsuccess = 'N'
         LET g_success = 'Y'
      END IF
END FUNCTION
 
FUNCTION t252_po_post()
DEFINE l_pmm904 LIKE pmm_file.pmm904
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_rty06 LIKE rty_file.rty06
DEFINE l_poy02 LIKE poy_file.poy02
DEFINE l_poy04 LIKE poy_file.poy04
DEFINE l_sql STRING
DEFINE l_dbs_f LIKE azp_file.azp03
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_success LIKE type_file.chr1
DEFINE l_poy02_min LIKE poy_file.poy02
DEFINE l_poy02_max LIKE poy_file.poy02
DEFINE l_n LIKE type_file.num5
 
    #No.FUN-960130 ..begin
    #LET l_sql = "SELECT COUNT(*)",
    #            "  FROM (SELECT DISTINCT rty01,rty06,rvn13",
    #            "          FROM azp_file a,azp_file b,rty_file,rvn_file",
    #            "         WHERE a.azp03 <> b.azp03",
    #            "           AND a.azp01 = rvn06",
    #            "           AND b.azp01 = rvn12",
    #            "           AND rty01 = rvn06",
    #            "           AND rty02 = rvn09",
    #            "           AND rvn10 > 0",
    #            "           AND rvn01 = '",g_rvm.rvm01,"'",
    #            "           AND rvnplant = '",g_rvm.rvmplant,"')"
    LET l_sql = "SELECT COUNT(*)",
                "  FROM (SELECT DISTINCT rty01,rty06,rvn13",
                "          FROM azw_file a,azw_file b,rty_file,rvn_file",
                "         WHERE a.azw02 <> b.azw02",
                "           AND a.azw01 = rvn06",
                "           AND b.azw01 = rvn12",
                "           AND rty01 = rvn06",
                "           AND rty02 = rvn09",
                "           AND rvn10 > 0",
                "           AND rvn01 = '",g_rvm.rvm01,"'",
                "           AND rvnplant = '",g_rvm.rvmplant,"')"
    #No.FUN-960130 ..end
    PREPARE po_post_cs FROM l_sql
    EXECUTE po_post_cs INTO l_n
    IF l_n=0 THEN
        RETURN 
    END IF
    CALL cl_getmsg('art-561',g_lang) RETURNING g_msg  
    DECLARE post_cs CURSOR FOR SELECT DISTINCT rvn13,rty06 FROM rvn_file,rty_file
                         WHERE rvn01 = g_rvm.rvm01
                           AND rvnplant = g_rvm.rvmplant
                           AND rty01 = rvn06
                           AND rvn09 = rty02
    FOREACH post_cs INTO l_pmm904,l_rty06
      CALL t252_progressing(g_msg)           
      DISPLAY "-----流程代碼",l_pmm904," start    at:",TIME,"-----"
      SELECT MIN(poy02),MAX(poy02)
        INTO l_poy02_min,l_poy02_max
        FROM poy_file
       WHERE poy01 = l_pmm904
      LET l_sql = "SELECT poy02,poy04 FROM poy_file ",
                  " WHERE poy01 = '",l_pmm904,"'",
                  " ORDER BY poy02"
      DECLARE poy_cs CURSOR FROM l_sql
      FOREACH poy_cs INTO l_poy02,l_poy04
        LET g_first = 'N'    #No.FUN-A10123
        LET g_stop = l_poy02
        LET l_dbs_f = l_dbs
        IF l_poy02 = l_poy02_max THEN
           SELECT DISTINCT rvn11 INTO g_rvn11 FROM rvn_file
            WHERE rvn13 = l_pmm904
              AND rvn01 = g_rvm.rvm01
              AND rvnplant = g_rvm.rvmplant
        END IF
        IF l_poy02 = l_poy02_min THEN
           LET g_first = 'Y'   #No.FUN-A10123
           SELECT DISTINCT rvn06 INTO g_rvn06 FROM rvn_file
            WHERE rvn13 = l_pmm904
              AND rvn01 = g_rvm.rvm01
              AND rvnplant = g_rvm.rvmplant
        END IF
        CALL t252_azp(l_poy04) RETURNING l_dbs
        IF l_poy02 = l_poy02_min THEN
           #CALL t252_flowauno(l_pmm904,g_today,l_dbs) RETURNING l_success,l_pmm99 #FUN-A50102
           CALL t252_flowauno(l_pmm904,g_today,l_poy04) RETURNING l_success,l_pmm99 #FUN-A50102
           IF NOT l_success THEN
              LET g_success = 'N'
              CONTINUE FOREACH
           END IF
        END IF
        IF (l_poy02 = l_poy02_min) OR (l_poy02 = l_poy02_max) THEN
           LET g_post = TRUE
        ELSE
           LET g_post = FALSE
        END IF
        IF (l_poy02 >= l_poy02_min) AND (l_poy02 < l_poy02_max) THEN
 
           LET g_start = CURRENT MINUTE TO FRACTION(5)
           CALL t252_po(l_pmm904,l_pmm99,l_poy04,l_dbs,l_poy02,l_rty06)
           LET g_end = CURRENT MINUTE TO FRACTION(5)
           LET g_interval = g_end - g_start
           DISPLAY "第 ",g_stop," 站 ",l_poy04," 采購單 used ",g_interval," seconds."
 
           IF g_sma.sma140 <> 'Y' THEN #No.FUN-A10123 
              LET g_start = CURRENT MINUTE TO FRACTION(5)
              CALL t252_receipt(l_pmm99,l_poy04,l_dbs)
              LET g_end = CURRENT MINUTE TO FRACTION(5)
              LET g_interval = g_end - g_start
              DISPLAY "第 ",g_stop," 站 ",l_poy04," 收貨單 used ",g_interval," seconds."
              
              LET g_start = CURRENT MINUTE TO FRACTION(5)
              #CALL t252_stockin(l_dbs) #FUN-A50102
              CALL t252_stockin(l_poy04) #FUN-A50102
              LET g_end = CURRENT MINUTE TO FRACTION(5)
              LET g_interval = g_end - g_start
              DISPLAY "第 ",g_stop," 站 ",l_poy04," 入庫單 used ",g_interval," seconds."
           END IF                      #No.FUN-A10123 
 
        END IF
        IF (l_poy02 > l_poy02_min) AND (l_poy02 <= l_poy02_max) THEN
 
           LET g_start = CURRENT MINUTE TO FRACTION(5)
           #CALL t252_order(l_pmm904,l_pmm99,l_dbs_f,l_poy02)  #FUN-A50102
           CALL t252_order(l_pmm904,l_pmm99,l_poy04,l_poy02) #FUN-A50102
           LET g_end = CURRENT MINUTE TO FRACTION(5)
           LET g_interval = g_end - g_start
           DISPLAY "第 ",g_stop," 站 ",l_poy04," 訂 單 used ",g_interval," seconds."
 
           IF g_sma.sma140 <> 'Y' THEN #No.FUN-A10123 
              LET g_start = CURRENT MINUTE TO FRACTION(5)
              CALL t252_ship(l_pmm99,l_poy04,l_dbs)
              LET g_end = CURRENT MINUTE TO FRACTION(5)
              LET g_interval = g_end - g_start
              DISPLAY "第 ",g_stop," 站 ",l_poy04," 出貨單 used ",g_interval," seconds."
           END IF                      #No.FUN-A10123 
 
        END IF
      END FOREACH
      IF cl_null(g_rvm.rvm09) THEN
         LET g_rvm.rvm09 = l_pmm99
      ELSE
         LET g_rvm.rvm09 = g_rvm.rvm09,'|',l_pmm99
      END IF
      CALL cl_progressing(g_msg)
      DISPLAY "-----流程代碼 ",l_pmm904," finished at:",TIME,"-----"    
    END FOREACH
END FUNCTION
 
#產生採購單
FUNCTION t252_po(l_pmm904,l_pmm99,l_pmmplant,l_dbs,l_i,l_rty06)
DEFINE l_pmm RECORD LIKE pmm_file.*
DEFINE l_pmn RECORD LIKE pmn_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_dbs  LIKE azp_file.azp03
DEFINE l_sql  STRING
DEFINE l_price  LIKE tqn_file.tqn05
DEFINE l_success LIKE type_file.chr1
DEFINE l_no     LIKE pmm_file.pmm01
DEFINE l_pmm99  LIKE pmm_file.pmm99 
DEFINE l_pmm09  LIKE pmm_file.pmm09
DEFINE l_pmmplant LIKE pmm_file.pmmplant 
DEFINE l_pmmlegal LIKE pmm_file.pmmlegal
DEFINE l_n      LIKE type_file.num5
DEFINE l_pmm904 LIKE pmm_file.pmm904
DEFINE l_time   LIKE pmm_file.pmmcont
DEFINE l_i      LIKE type_file.num5
DEFINE l_rty06  LIKE rty_file.rty06
DEFINE l_gec07  LIKE gec_file.gec07
       
       DELETE FROM rvn_temp3
       LET l_sql = "INSERT INTO rvn_temp3 ",
                   "SELECT c.*,rty06",
                   "  FROM rvn_file c,rty_file",
                   #No.FUN-960130 ..begin
                   #" WHERE EXISTS (SELECT 1 FROM azp_file a,azp_file b",
                   #"                WHERE a.azp03 <> b.azp03",
                   #"                  AND a.azp01 = c.rvn06",
                   #"                  AND b.azp01 = c.rvn12)",
                   " WHERE EXISTS (SELECT 1 FROM azw_file a,azw_file b",
                   "                WHERE a.azw02 <> b.azw02",
                   "                  AND a.azw01 = c.rvn06",
                   "                  AND b.azw01 = c.rvn12)",
                   #No.FUN-960130 ..end
                   "   AND rvn10 > 0",
                   "   AND rvn13 = ?",
                   "   AND rvn01 = ?",
                   "   AND rvnplant = ?",
                   "   AND rty01 = rvn06 ",
                   "   AND rty02 = rvn09 ",
                   "   AND rty06 = '",l_rty06,"'"
      PREPARE ins_rvn_temp3 FROM l_sql
      EXECUTE ins_rvn_temp3 USING l_pmm904,g_rvm.rvm01,g_rvm.rvmplant
      
#商品經營方式在arti110中不存在         
      SELECT COUNT(*) INTO l_n FROM rvn_temp3
       WHERE rty06 IS NULL
      IF l_n>0 THEN
         LET g_success='N'
         INSERT INTO err_temp 
         SELECT 'rvn06,rvn09',rvn06||'|'||rvn09,'sel rty06','art-177',1 
           FROM rvn_temp3
          WHERE rty06 IS NULL
      END IF
      DELETE FROM pmm_temp
      DELETE FROM pmn_temp 
#取預設單別aooi410
      #CALL t252_def_no(l_dbs,'apm','2') RETURNING l_no #FUN-A50102
      CALL t252_def_no(l_pmmplant,'apm','2') RETURNING l_no #FUN-A50102
      IF cl_null(l_no) THEN
         CALL s_errmsg('',l_dbs,'apm 2','art-330',1)
         LET g_success = 'N'
      ELSE 
#自動編號
         CALL s_auto_assign_no("apm",l_no,g_today,"2","pmm_file","pmm01",l_pmmplant,"","")
               RETURNING li_result,l_pmm.pmm01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            CALL s_errmsg('pmmplant',l_pmmplant,'apm 2','sub-145',1)
         END IF
      END IF
      #No.FUN-A70123 ..begin
      SELECT azw02 INTO l_pmmlegal FROM azw_file WHERE azw01 = l_pmmplant  
      #LET l_sql = " INSERT INTO pmm_temp(pmm01,pmm51,pmmplant,pmm904,pmmpos)",
      #            " SELECT '",l_pmm.pmm01,"',rty06,'",l_pmmplant CLIPPED,"',rvn13,'N'",
      LET l_sql = " INSERT INTO pmm_temp(pmm01,pmm51,pmmplant,pmm904,pmmpos,pmmlegal)",
                  " SELECT '",l_pmm.pmm01,"',rty06,'",l_pmmplant CLIPPED,"',rvn13,'N','",l_pmmlegal,"' ",
                  "   FROM (SELECT DISTINCT rty06,rvn13,rvn06,'N' FROM rvn_temp3)"
      #No.FUN-A70123 ..end
      EXECUTE IMMEDIATE l_sql 
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins pmm_temp',SQLCA.sqlcode,1)
      END IF
      INSERT INTO pmn_temp(pmn01,pmn02,pmn20,pmn31,pmn42,pmn50,pmn51,
#                          pmn53,pmn55,pmn57,pmn61,pmn62,pmn04,             #TQC-9B0203 mark
                           pmn53,pmn55,pmn57,pmn58,pmn61,pmn62,pmn04,       #TQC-9B0203
                           pmn24,pmn25,pmn73,pmn75,pmn76,pmn77,pmn87,pmn89,pmnplant,pmnlegal) #FUN-9B0157  #No.FUN-A70123 #FUN-A90063
      SELECT pmm01,ROWNUM,rvn10,0,'0',rvn10,0,
#            rvn10,0,0,rvn09,1,rvn09,rvn03,             #TQC-9B0203 mark
             rvn10,0,0,0,rvn09,1,rvn09,rvn03,           #TQC-9B0203
             rvn04,' ',rvn01,rvn02,rvnplant,rvn10,'N',pmmplant,pmmlegal   #FUN-9B0157  #No.FUN-A70123  #FUN-A90063
        FROM rvn_temp3,pmm_temp
       WHERE rty06 = pmm51
         AND rvn13 = pmm904
         AND pmm904 = l_pmm904
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins pmn_temp',SQLCA.sqlcode,1)
      END IF
      #SELECT azw02 INTO l_pmmlegal FROM azw_file WHERE azw01 = l_pmmplant  #No.FUN-A70123 放前面
            UPDATE pmn_temp SET pmnplant = l_pmmplant,
                                pmnlegal = l_pmmlegal,
                                pmn73 = '4',   #取价類型
                                pmn16 = '2',   #狀況碼
                                pmn38 = 'Y',   #
                                pmn63 = "N",   
                                pmn64 = "N",  
                                pmn65 = '1',   
                                pmn90 = 0,     
                                pmn011 = 'TAP',
                                pmn33 = g_today,
                                pmn34 = g_today,
                                pmn11 = 'N',         
                                pmn041 = (SELECT ima02 FROM ima_file WHERE ima01 = pmn04)
           #No.FUN-A10123  begin
           IF g_sma.sma140 = 'Y' THEN 
              UPDATE pmn_temp SET pmn50 = 0 
           END IF
           #No.FUN-A10123  end
 
            LET l_sql = "UPDATE pmn_temp a ",
                        "   SET (pmn07,pmn08,pmn09) = (SELECT ruc13,ruc16,ruc17 ",
                        "                                FROM ruc_file",  
                        "                               WHERE ruc00 = '1'",
                        "                                 AND ruc01 = '",g_rvn06,"'",
                        "                                 AND ruc04 = a.pmn04",
                        "                                 AND ruc02 = a.pmn24",
                        "                                 AND ruc03 = a.pmn25)"
            EXECUTE IMMEDIATE l_sql
 
            UPDATE pmn_temp SET pmn86 = pmn07
#供應商取流程代碼下一站
            SELECT poy03 INTO l_pmm09 FROM poy_file WHERE poy01 = l_pmm904 AND poy02 = l_i+1
            UPDATE pmm_temp SET pmm09 = l_pmm09
            
#取稅种等資料
            LET l_sql = "UPDATE pmm_temp a ",
                        "   SET (pmm20,pmm21,pmm41) = (SELECT pmc17,pmc47,pmc49",
                        "                                      FROM pmc_file",
                        "                                     WHERE pmc01 = a.pmm09",
                        "                                       AND pmc05 = '1')"
            EXECUTE IMMEDIATE l_sql
#稅种資料不存在            
            SELECT COUNT(*) INTO l_n FROM pmm_temp WHERE pmm21 IS NULL
            IF l_n>0 THEN
               LET g_success = 'N'
               INSERT INTO err_temp 
               SELECT 'pmc01',pmm09,'sel pmc47','art-493',1 
                 FROM pmm_temp
                WHERE pmm21 IS NULL
            END IF
#取稅率
            LET l_sql = "UPDATE pmm_temp a",
                        "   SET pmm43 = (SELECT gec04 ",
                        "                  FROM gec_file",
                        "                 WHERE gec01 = a.pmm21",
                        "                   AND gec011= '1')"
            EXECUTE IMMEDIATE l_sql
#稅率不存在          
            SELECT COUNT(*) INTO l_n FROM pmm_temp WHERE pmm43 IS NULL
            IF l_n>0 THEN
               LET g_success='N' 
               INSERT INTO err_temp 
               SELECT 'gec01',pmm21,'sel gec04','alm-141',1 
                 FROM pmm_temp
                WHERE pmm43 IS NULL
            END IF 
            SELECT pmm43 INTO l_pmm.pmm43 FROM pmm_temp
#採購取價            
            DELETE FROM price_temp
            INSERT INTO price_temp(item,unit) SELECT DISTINCT pmn04,pmn07 FROM pmn_temp
            CALL t252_fetch_price(l_pmm904,l_pmmplant,'0',l_i)
#更新價格
            SELECT gec07 INTO l_gec07 FROM gec_file,pmm_temp WHERE gec01=pmm21
            IF l_gec07 IS NULL THEN LET l_gec07='N' END IF
            IF l_gec07='Y' THEN
               UPDATE pmn_temp
                  SET pmn31t = (SELECT DISTINCT price FROM price_temp WHERE item = pmn04 AND unit = pmn07) 
               UPDATE pmn_temp
                  SET pmn30 = pmn31t,
                      pmn31 = pmn31t/(1+l_pmm.pmm43/100),
                      pmn44 = pmn31
            ELSE
               UPDATE pmn_temp 
                  SET pmn31 = (SELECT DISTINCT price FROM price_temp WHERE item = pmn04 AND unit = pmn07)
               UPDATE pmn_temp
                  SET pmn30 = pmn31,                   
                      pmn31t = pmn31 *(1+l_pmm.pmm43/100),
                      pmn44 = pmn31
            END IF
            UPDATE pmn_temp
               SET pmn88 = pmn31*pmn87,
                   pmn88t = pmn31t*pmn87
#更新下游厂商
        LET l_sql = "UPDATE pmm_temp a ",
                    "   SET pmm911 = (SELECT poy03 FROM poy_file WHERE poy01 = a.pmm904 AND poy02 = 0),",
                    "       pmm912 = (SELECT poy03 FROM poy_file WHERE poy01 = a.pmm904 AND poy02 = 1),",
                    "       pmm913 = (SELECT poy03 FROM poy_file WHERE poy01 = a.pmm904 AND poy02 = 2),",
                    "       pmm914 = (SELECT poy03 FROM poy_file WHERE poy01 = a.pmm904 AND poy02 = 3),",
                    "       pmm915 = (SELECT poy03 FROM poy_file WHERE poy01 = a.pmm904 AND poy02 = 4),",
                    "       pmm916 = (SELECT poy03 FROM poy_file WHERE poy01 = a.pmm904 AND poy02 = 5)"
        EXECUTE IMMEDIATE l_sql
 
         LET l_time = TIME
         #No.FUN-A10123 ..begin
         IF g_first = 'Y' THEN 
            LET l_pmm.pmm906 = 'Y'
         ELSE
            LET l_pmm.pmm906 = 'N'
         END IF
         #No.FUN-A10123 ..end
         UPDATE pmm_temp SET pmmlegal = l_pmmlegal, #法人
                             pmm99 = l_pmm99,      #多角流程序
                             pmm02 = 'TAP',        #採購單性質
                             pmm52 = pmmplant,     #採購機構
                             pmm53 = g_rvm.rvm03,  #配送中心
                             pmm04 = g_today,      #採購日期
                             pmm31 = (SELECT azn02 FROM azn_file WHERE azn01 = g_today),#會計年度		
                             pmm03 = 0,	         #更動序號
                             pmm12 = g_user,     #採購員
                             pmm13 = g_grup,     #採購部門
                             pmm22 = 'RMB',      #幣別	
                             pmm42 = '1',        #匯率
                             pmm25 = '2',        #狀況碼
                             pmm27 = g_today,    #異動日期
                             pmm30 = 'N',        #收貨單打印否
                             pmm401= 0,          #代買總金額
                             pmm44 = '1',        #扣抵區分   
                             pmm45 = 'Y',        #可用
                             pmm46 = 0,          #預付比率
                             pmm47 = 0,          #預付金額
                             pmm48 = 0,          #已結帳金額
                             pmm901 = 'Y',       #多角貿易採購單
                             pmm902 = 'N',       #最采
                             pmm905 = 'Y',       #多角貿易拋轉 
                             pmm906 = l_pmm.pmm906, #No.FUN-A10123       
                             pmmdays = 0,        #列印次數
                             pmmprno = 0,        #列印次數
                             pmmsmax = 0,        #己簽順序
                             pmmsseq = 0,        #應簽順序
                             pmmprsw = 'Y',      #列印控制
                             pmmmksg = 'N',      #是否簽核
                             pmmacti ='Y',       #有效的資料
                             pmmuser = g_user,
                             pmmgrup = g_grup,   #使用者所屬群
                             pmmoriu = g_user,#No.FUN-A10123  
                             pmmorig = g_grup,   #使用者所屬群#No.FUN-A10123  
                             pmmcrat = g_today,            
                             pmm909 = '7',   
                             pmm18 = 'Y',        #審核碼
                             pmmconu = g_user,
                             pmmcond = g_today,
                             pmmcont = l_time
 
        LET l_sql = "UPDATE pmm_temp a ",
#                   "   SET pmm40 = (SELECT SUM(pmn31*pmn20) FROM pmn_temp),",#未稅總金額   #CHI-B70039 mark
                    "   SET pmm40 = (SELECT SUM(pmn87*pmn31) FROM pmn_temp),",              #CHI-B70039
#                   "       pmm40t = (SELECT SUM(pmn31t*pmn20) FROM pmn_temp)" #含稅總金額  #CHI-B70039 mark
                    "       pmm40t = (SELECT SUM(pmn87*pmn31t) FROM pmn_temp)"              #CHI-B70039
        EXECUTE IMMEDIATE l_sql
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'pmn_file'), #FUN-A50102
                    " SELECT * FROM pmn_temp"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102
        PREPARE pmn_ins FROM l_sql
        EXECUTE pmn_ins
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('pmn01',l_pmm.pmm01,'INSERT INTO pmn_file:',SQLCA.sqlcode,1)
        END IF
        #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"pml_file a", #FUN-A50102
         LET l_sql = "UPDATE ",cl_get_target_table(l_pmmplant, 'pml_file')," a", #FUN-A50102
                    "   SET pml21=(SELECT pmn20 FROM pmn_temp",
                    "               WHERE pmn24=a.pml01 AND pmn25=a.pml02)",
                    " WHERE EXISTS (SELECT 1 FROM pmn_temp ",
                    "                WHERE pmn24 = a.pml01 ",
                    "                  AND pmn25 = a.pml02)"
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('pmn01',l_pmm.pmm01,'UPDATE pml_file:',SQLCA.sqlcode,1)
        END IF
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED), #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'pmm_file'), #FUN-A50102
                    " SELECT * FROM pmm_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102
         PREPARE pmm_ins FROM l_sql
         EXECUTE pmm_ins
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('pmm01',l_pmm.pmm01,'INSERT INTO pmm_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
         IF g_success = 'Y' THEN
            CALL t252_po_upd(l_dbs) 
            #CALL t252_po_upd(l_rvn.rvn06) #FUN-A50102
         END IF
     IF g_success = 'N' THEN
        LET g_success ='Y'
        LET g_totsuccess = 'N'
     END IF
END FUNCTION
 
#採購審核更新字段
#FUNCTION t252_po_upd(l_dbs) #FUN-A50102
FUNCTION t252_po_upd(l_pmmplant) #FUN-A50102
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_pmmplant LIKE pmm_file.pmmplant #FUN-A50102
 
#供商最近採購日期    
    LET l_sql = "UPDATE pmc_file ",
                "   SET pmc40 = ?",
                " WHERE pmc01 = (SELECT pmm09 FROM pmm_temp)"
    PREPARE pmc_upd FROM l_sql
    EXECUTE pmc_upd USING g_today
#料件最近採購日期 
    #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
    LET l_sql = "UPDATE ",cl_get_target_table(l_pmmplant, 'ima_file')," a ", #FUN-A50102
                "   SET ima881 = ?",
                " WHERE EXISTS (SELECT 1 FROM pmn_temp",
                "                WHERE pmn04 = a.ima01)"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102
    PREPARE po_ima_upd FROM l_sql
    EXECUTE po_ima_upd USING g_today
#最近採購價格    
    CASE g_sma.sma843
     WHEN '1'
         #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
         LET l_sql = "UPDATE ",cl_get_target_table(l_pmmplant, 'ima_file')," a ", #FUN-A50102
                     "   SET ima53 = (SELECT MAX(pmn31) FROM pmn_temp",
                     "                 WHERE pmn04 = a.ima01)",
                     " WHERE EXISTS (SELECT 1 FROM pmn_temp",
                     "                WHERE pmn04 = a.ima01)"         
     WHEN '2'
        #LET l_sql = "UDDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
         LET l_sql = "UDDATE ",cl_get_target_table(l_pmmplant, 'ima_file'),#FUN-A50102
                     "   SET ima53 = (SELECT MAX(pmn31) FROM pmn_temp",
                     "                 WHERE pmn04 = a.ima01)",
                     " WHERE EXISTS (SELECT 1 FROM pmn_temp",
                     "                WHERE pmn04 = a.ima01",
                     "                  AND pmn31 < a.ima53)" 
     OTHERWISE EXIT CASE
    END CASE
    EXECUTE IMMEDIATE l_sql
#市價,最近更新日期    
    CASE g_sma.sma844
     WHEN '1'
       #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
       LET l_sql = "UPDATE ",cl_get_target_table(l_pmmplant, 'ima_file')," a ", #FUN-A50102
                   "   SET ima531 = (SELECT MAX(pmn31) FROM pmn_temp",
                   "                 WHERE pmn04 = a.ima01),",
                   "       ima532 = ?",
                   " WHERE EXISTS (SELECT 1 FROM pmn_temp",
                   "                WHERE pmn04 = a.ima01)" 
               
     WHEN '2'
        #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
        LET l_sql = "UPDATE ",cl_get_target_table(l_pmmplant, 'ima_file')," a ", #FUN-A50102
                    "   SET ima531 = (SELECT MAX(pmn31) FROM pmn_temp",
                    "                 WHERE pmn04 = a.ima01)",
                    "       ima532 = ?",
                    " WHERE EXISTS (SELECT 1 FROM pmn_temp",
                    "                WHERE pmn04 = a.ima01",
                    "                  AND pmn31 < a.ima531)" 
     OTHERWISE EXIT CASE
    END CASE
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102
    PREPARE po_ima_upd1 FROM l_sql
    EXECUTE po_ima_upd1 USING g_today
END FUNCTION
 
#訂單
#FUNCTION t252_order(l_pmm904,l_pmm99,l_dbs_f,l_i) #FUN-A50102  
FUNCTION t252_order(l_pmm904,l_pmm99,l_plant,l_i) #FUN-A50102
DEFINE l_pmm904 LIKE pmm_file.pmm904
DEFINE l_pmm99  LIKE pmm_file.pmm99
DEFINE l_dbs    LIKE azp_file.azp03
DEFINE l_dbs_f  LIKE azp_file.azp03
DEFINE l_i      LIKE poy_file.poy02
DEFINE l_oea01  LIKE oea_file.oea01
DEFINE l_oea RECORD LIKE oea_file.*
DEFINE l_oeb RECORD LIKE oeb_file.*
DEFINE l_poy RECORD LIKE poy_file.*
DEFINE l_sql STRING    
DEFINE l_pod04 LIKE pod_file.pod04
DEFINE l_pmm RECORD LIKE pmm_file.*
DEFINE li_result,l_n LIKE type_file.num5
DEFINE l_oeacont LIKE oea_file.oeacont
DEFINE l_success LIKE type_file.num5 
DEFINE l_poy04 LIKE poy_file.poy04
DEFINE l_plant LIKE poy_file.poy04
 
#一單到底apms010    
#    LET l_sql = "SELECT pod04 FROM ",s_dbstring(l_dbs_f CLIPPED),"pod_file"
#    PREPARE pod_cs FROM l_sql
#    EXECUTE pod_cs INTO l_pod04
    
    SELECT * INTO l_poy.* FROM poy_file WHERE poy01 = l_pmm904 AND poy02 = l_i
    #No.FUN-960130 ..begin
    #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_poy.poy04
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = l_poy.poy04
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra
    #FUN-A50102 ---mark---end---
    #No.FUN-960130 ..end
    SELECT poy04 INTO l_poy04 FROM poy_file WHERE poy01=l_pmm904 AND poy02=l_i-1
#取前一站採購資料    
    #LET l_sql = "SELECT pmm_file.* FROM ",s_dbstring(l_dbs_f CLIPPED),"pmm_file WHERE pmm99 = ? AND pmmplant = ?" #FUN-A50102
    LET l_sql = "SELECT pmm_file.* FROM ",cl_get_target_table(l_plant, 'pmm_file')," WHERE pmm99 = ? AND pmmplant = ?" #FUN-A50102
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102
    PREPARE or_pmm_cs FROM l_sql
    EXECUTE or_pmm_cs USING l_pmm99,l_poy04 INTO l_pmm.*
 
#一單到底不重新編號    
#    IF l_pod04 = 'Y' THEN
#       LET l_oea01 = l_pmm.pmm01
#    ELSE
       #CALL t252_def_no(l_dbs,'axm','30') RETURNING l_oea01 #FUN-A50102
       CALL t252_def_no(l_plant,'axm','30') RETURNING l_oea01 #FUN-A50102
       IF cl_null(l_oea01) THEN
          CALL s_errmsg('',l_dbs,'axm 30','art-330',1)
          LET g_success = 'N'
       ELSE 
          CALL s_auto_assign_no("AXM",l_oea01,l_pmm.pmm04,"30","oea_file","oea01",l_poy.poy04,"","")
                 RETURNING li_result,l_oea01
          IF (NOT li_result) THEN
              LET g_success = 'N'
              CALL s_errmsg('','','','sub-145',1)  
          END IF
       END IF
#    END IF
    
    DELETE FROM oea_temp
    INSERT INTO oea_temp (oea01,oea02,oea09,oea10,oea61,oea62,oea63,oea85,oea99,
                          oea903,oea904,oea911,oea912,
                          oea913,oea914,oea915,oea916,oeaplant,oealegal)  #No.FUN-A70123 
           VALUES (l_oea01,l_pmm.pmm04,0,l_pmm.pmm01,l_pmm.pmm40,0,0,'2',l_pmm.pmm99,
                   l_pmm.pmm903,l_pmm.pmm904,l_pmm.pmm911,l_pmm.pmm912,
                   l_pmm.pmm913,l_pmm.pmm914,l_pmm.pmm915,l_pmm.pmm916,' ',' ') #No.FUN-A70123
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins oea_temp',SQLCA.sqlcode,1)
    END IF 
    LET l_oeacont = TIME
    UPDATE oea_temp
       SET oea00 = '1',
           oea06 = 0,
           oea07 = 'N',
           oea08 = '2',
           oea11 = '6',
           oea14 = g_user,
           oea15 = g_grup,
           oea161 = 0,
           oea162 = 100,
           oea163 = 0,
           oea20 = 'Y',
           oea23 = 'RMB',
           oea24 = 1,
           oea49 = '1',
           oea50 = 'N',
           oea72 = g_today,
           oea901 = 'Y',
           oea902 = 'N',
           oea905 = 'Y',
           oea906 = 'N',
           oeamksg = 'N',
           oeasign = '',
           oeadays = 0,
           oeaprit = 0,
           oeasseq = 0,
           oeasmax = 0,
           oeaconf = 'Y',
           oeaprsw = 0,
           oeauser = g_user,
           oeagrup = g_grup,
           oeaoriu = g_user,#No.FUN-A10123  
           oeaorig = g_grup,#No.FUN-A10123  
           oea65 = 'N',
           oeacont = l_oeacont,
           oeaconu = g_user
           
#客戶取流程代碼前一站
    LET l_sql = "UPDATE oea_temp a",
                "   SET oea03 = (SELECT poy03 FROM poy_file",
                "                 WHERE poy01 = ?",
                "                   AND poy02 = (?-1))"
    PREPARE oea_upd1 FROM l_sql
    EXECUTE oea_upd1 USING l_pmm904,l_i
    EXECUTE IMMEDIATE "UPDATE oea_temp SET oea04 = oea03,oea17 = oea03"
    LET l_sql = "UPDATE oea_temp a",
                "   SET (oea05,oea21,oea25,oea32,oea83,oea84,oeaplant) = ",
                "       (SELECT poy12,poy08,poy10,poy32,poy04,poy04,poy04",
                "          FROM poy_file",
                "         WHERE poy01 = ?",
                "           AND poy02 = ?)"
    PREPARE oea_upd2 FROM l_sql
    EXECUTE oea_upd2 USING l_pmm904,l_i
    UPDATE oea_temp SET oealegal = (SELECT azw02 FROM azw_file 
                                     WHERE azw01 = oeaplant)
#更新客戶基本資料    
    LET l_sql = "UPDATE oea_temp a",
                "   SET (oea31,oea32,oea032,oea033) = (SELECT occ44,occ45,occ02,occ11",
                "                                        FROM occ_file",
                "                                       WHERE occ01 = a.oea03)"
    EXECUTE IMMEDIATE l_sql
#取稅種    
    LET l_sql = "UPDATE oea_temp a",
                "   SET oea21 = (SELECT occ41",
                "                  FROM occ_file",
                "                 WHERE occ01 = a.oea03)",
                " WHERE oea21 IS NULL"
    EXECUTE IMMEDIATE l_sql
#稅種為空    
    SELECT COUNT(*) INTO l_n FROM oea_temp WHERE oea21 IS NULL
    IF l_n>0 THEN
       LET g_success='N'
       INSERT INTO err_temp SELECT 'oea03',oea03,'','afa-351',1 FROM oea_temp WHERE oea21 IS NULL
    END IF
    LET l_sql = "UPDATE oea_temp a",
                "   SET (oea211,oea212,oea213) = (SELECT gec04,gec05,gec07 ",
                #"                                   FROM ",s_dbstring(l_dbs CLIPPED),"gec_file", #FUN-A50102
                "                                   FROM ",cl_get_target_table(l_poy.poy04, 'gec_file'), #FUN-A50102
                "                                  WHERE gec01 = a.oea21",
                "                                    AND gec011 = '2')"
    EXECUTE IMMEDIATE l_sql
  
    LET l_sql = "UPDATE oea_temp a",
                "   SET oea902 = 'Y'",
                " WHERE EXISTS (SELECT 1 FROM poy_file",
                "                WHERE poy01 = a.oea904",
                "                  AND poy02 = (SELECT MAX(poy02) FROM poy_file",
                "                                WHERE poy01 = a.oea904)",
                "                  AND poy02 = ?)"
    PREPARE oea_upd3 FROM l_sql
    EXECUTE oea_upd3 USING l_i
    
    DELETE FROM oeb_temp    
    LET l_sql = "INSERT INTO oeb_temp",
                "(oeb01,oeb03,oeb04,oeb05,oeb05_fac,",
                " oeb06,oeb12,oeb13,oeb14,oeb14t,oeb23,oeb24,oeb25,oeb26,",           
                " oeb44,oeb47,oeb48,",
               #" oeb916,oeb917,oeb15,oeb72,oeb910,",  #FUN-B20060 add oeb72   #CHI-C80060 mark
                " oeb916,oeb917,oeb15,oeb910,",  #CHI-C80060 add 
                " oeb911,oeb912,oeb913,oeb914,oeb915,oebplant,oeblegal,oeb37) ",  #No.FUN-A70123    #FUN-AB0061 add oeb37
                "SELECT '",l_oea01 CLIPPED,"',pmn02,pmn04,pmn07,pmn09,",
                "       pmn041,pmn20,0,0,0,0,pmn20,0,0,",                             
                "       ' ',0,'1',",
               #"       pmn86,pmn87,pmn33,pmn33,pmn80,",  #FUN-B20060 add pmn33  #CHI-C80060 mark
                "       pmn86,pmn87,pmn33,pmn80,",        #CHI-C80060 add
                "       pmn81,pmn82,pmn83,pmn84,pmn85,' ',' ',0 ",             #No.FUN-A70123       #FUN-AB0061 add 0
                "  FROM pmn_temp"
    PREPARE ins_oeb_temp FROM l_sql
    EXECUTE ins_oeb_temp
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins oeb_temp',SQLCA.sqlcode,1)
    END IF 
    SELECT * INTO l_oea.* FROM oea_temp
#更新經營方式    
    LET l_sql = "UPDATE oeb_temp a ",
                #"   SET oeb44 = (SELECT pmm51 FROM ",s_dbstring(l_dbs_f CLIPPED),"pmm_file", #FUN-A50102
                "   SET oeb44 = (SELECT pmm51 FROM ",cl_get_target_table(l_plant, 'pmm_file'), #FUN-A50102
                "                 WHERE pmm01 = '",l_pmm.pmm01,"')"
    EXECUTE IMMEDIATE l_sql
    UPDATE oeb_temp 
       SET oeb45 = 0,
           oeb47 = 0,
           oeb48 = '2',
           oeb1003 = '1',
           oeb19 = 'N',
           oeb23 = 0,
           oeb25 = 0,
           oeb26 = 0,
           oeb70 = 'N',
           oeb901 = 0,
           oeb905 = 0,
           oeb906 = 'Y',
           oebplant = l_oea.oeaplant,
           oeblegal = l_oea.oealegal
   #No.FUN-A10123  begin
   IF g_sma.sma140 = 'Y' THEN 
      UPDATE oeb_temp SET oeb24 = 0 
   END IF
   #No.FUN-A10123  end
#銷售取價           
            DELETE FROM price_temp
            INSERT INTO price_temp(item,unit) SELECT DISTINCT oeb04,oeb05 FROM oeb_temp
            CALL t252_fetch_price(l_pmm904,l_poy.poy04,'1',l_i)
            IF l_oea.oea213 = 'N' THEN
               LET l_sql = "UPDATE oeb_temp ",
                           "   SET oeb13 = (SELECT price FROM price_temp WHERE item = oeb04 AND unit = oeb05)"
               EXECUTE IMMEDIATE l_sql    
               UPDATE oeb_temp
                  SET oeb14 = oeb917*oeb13
               UPDATE oeb_temp
                  SET oeb14t = oeb14*(1+l_oea.oea211/100)
            ELSE
                #No.FUN-9B0157 ..begin
                #LET l_sql = "UPDATE oeb_temp ",
                #           "   SET oeb13 = (SELECT price FROM price_temp WHERE item = oeb04 AND unit = oeb05)* (1+",l_oea.oea211,"/100)"
                LET l_sql = "UPDATE oeb_temp ",
                           "   SET oeb13 = (SELECT price FROM price_temp WHERE item = oeb04 AND unit = oeb05)"
                EXECUTE IMMEDIATE l_sql        
                LET l_sql = "UPDATE oeb_temp ",
                           "   SET oeb13 = oeb13*(1+",l_oea.oea211,"/100)"
                EXECUTE IMMEDIATE l_sql        
                #No.FUN-9B0157 ..end
                UPDATE oeb_temp
                   SET oeb14t = oeb917*oeb13
                UPDATE oeb_temp
                   SET oeb14 = oeb14t/(1+l_oea.oea211/100)   #No.FUN-A10123  *--> /
                UPDATE oea_temp SET oea61 = (SELECT SUM(oeb14) FROM oeb_temp )   #No.FUN-A10123
            END IF
   #FUN-AB0061 -----------add start----------------
    LET l_sql = " UPDATE oeb_temp ",
                "    SET oeb37 = ( SELECT oeb13 FROM oeb_temp) "
    EXECUTE IMMEDIATE l_sql
   #FUN-AB0061 -----------add end---------------- 
    IF g_success = 'Y' THEN
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"oeb_file SELECT * FROM oeb_temp" #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_poy.poy04, 'oeb_file')," SELECT * FROM oeb_temp" #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_poy.poy04) RETURNING l_sql  #FUN-A50102
         PREPARE oeb_ins FROM l_sql
         EXECUTE oeb_ins
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg("oea01",l_oea01,"INSERT INTO oeb_file",SQLCA.sqlcode,1)
         ELSE
            #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"oea_file SELECT * FROM oea_temp" #FUN-A50102
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_poy.poy04, 'oea_file')," SELECT * FROM oea_temp" #FUN-A50102
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_poy.poy04) RETURNING l_sql  #FUN-A50102      
            PREPARE oea_ins FROM l_sql
            EXECUTE oea_ins
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg("oea01",l_oea01,"INSERT INTO oea_file",SQLCA.sqlcode,1)
            END IF
         END IF
    END IF
    IF g_success = 'N' THEN
        LET g_success ='Y'
        LET g_totsuccess = 'N'
    END IF
END FUNCTION
 
#出貨單
FUNCTION t252_ship(l_pmm99,l_plant,l_dbs)
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_plant LIKE pmm_file.pmmplant
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_oga01 LIKE oga_file.oga01
DEFINE l_oea RECORD LIKE oea_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_sql STRING
DEFINE l_n LIKE type_file.num5
DEFINE l_time LIKE oga_file.ogacont  #No.FUN-A10123
 
#取預設單別
    #CALL t252_def_no(l_dbs,'axm','50') RETURNING l_oga01 #FUN-A50102
    CALL t252_def_no(l_plant,'axm','50') RETURNING l_oga01 #FUN-A50102
    
#取訂單資料
    #LET l_sql = "SELECT oea_file.* FROM ",s_dbstring(l_dbs CLIPPED),"oea_file WHERE oea99 = ? AND oeaplant = ?" #FUN-A50102
    LET l_sql = "SELECT oea_file.* FROM ",cl_get_target_table(l_plant, 'oea_file')," WHERE oea99 = ? AND oeaplant = ?" #FUN-A50102
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102
    PREPARE oea_cs FROM l_sql
    EXECUTE oea_cs USING l_pmm99,l_plant INTO l_oea.*
 
#自動編號
    IF NOT cl_null(l_oga01) THEN
       CALL s_auto_assign_no('axm',l_oga01,g_today,"50","oga_file","oga01",l_plant,"","")
            RETURNING li_result,l_oga01
       IF (NOT li_result) THEN                                                                           
          LET g_success = 'N'
          LET g_showmsg = l_oga01,"|",l_oea.oeaplant
          CALL s_errmsg('oga01,oeaplant',g_showmsg,'','sub-145',1)
       END IF
    END IF
    DELETE FROM oga_temp
    INSERT INTO oga_temp (oga01,oga50,oga52,oga53,oga54,oga85,oga94,oga161,oga162,oga163,ogaplant,ogalegal) #No.FUN-A70123
                      VALUES(l_oga01,0,0,0,0,' ','N',0,0,0,' ',' ')  #No.FUN-A70123
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins oga_temp',SQLCA.sqlcode,1)
    END IF
       LET l_time = TIME  #No.FUN-A10123
       UPDATE oga_temp
          SET oga00 = '1',
              oga02 = g_today,
              oga021= g_today,
              oga022= g_today,
              oga03 = l_oea.oea03,
              oga032= l_oea.oea032,
              oga033= l_oea.oea033,
              oga04 = l_oea.oea04,
              oga044= l_oea.oea044,
              oga05 = l_oea.oea05,
              oga06 = l_oea.oea06,
              oga07 = l_oea.oea07,
              oga08 = l_oea.oea08,
              oga09 = '6',
              oga11 = NULL,
              oga12 = NULL,
              oga14 = l_oea.oea14,
              oga15 = l_oea.oea15,
              oga16 = l_oea.oea01,
              oga161= l_oea.oea161,
              oga162= l_oea.oea162,
              oga163= l_oea.oea163,
              oga18 = l_oea.oea17,
              oga20 = 'Y',
              oga21 = l_oea.oea21,
              oga211= l_oea.oea211,
              oga212= l_oea.oea212,
              oga213= l_oea.oea213,
              oga23 = l_oea.oea23,
              oga24 = l_oea.oea24,
              oga25 = l_oea.oea25,
              oga26 = l_oea.oea26,
              oga27 = l_oea.oea27,
              oga28 = l_oea.oea18,
              oga29 = 0,
              oga30 = 'N',
              oga31 = l_oea.oea31,
              oga32 = l_oea.oea32,
              oga33 = l_oea.oea33,
              oga34 = 0,
              oga40 = l_oea.oea19,
              oga41 = l_oea.oea41,
              oga42 = l_oea.oea42,
              oga43 = l_oea.oea43,
              oga44 = l_oea.oea44,
              oga45 = l_oea.oea45,
              oga46 = l_oea.oea46,
              oga55 = '1',
              oga57 = '1', #FUN-AC0055 add
              oga65 = l_oea.oea65,
              oga69 = g_today,
              oga99 = l_pmm99,
              oga901='N',
              oga905='Y',
              oga906='N',
              oga909='Y',
              ogaconf='Y',
              ogapost='Y',
              ogaprsw=0,
              ogauser=g_user,
              ogagrup=g_grup,
              ogaoriu=g_user,#No.FUN-A10123  
              ogaorig=g_grup,#No.FUN-A10123  
              ogacont = l_time, #No.FUN-A10123
              ogadate=NULL,
              oga83 = l_oea.oea83,
              oga84 = l_oea.oea84,
              oga85 = l_oea.oea85,
              oga86 = l_oea.oea86,
              oga87 = l_oea.oea87,
              oga88 = l_oea.oea88,
              oga89 = l_oea.oea89,
              oga90 = l_oea.oea90,
              oga91 = l_oea.oea91,
              oga92 = l_oea.oea92,
              oga93 = l_oea.oea93,
              oga94 = 'N',
              ogaconu = g_user,
              ogacond = g_today,
              ogaplant = l_oea.oeaplant,
              ogalegal = l_oea.oealegal
 
    DELETE FROM ogb_temp
    LET l_sql = "INSERT INTO ogb_temp",
                "(ogb01,ogb03,ogb04,ogb05,ogb05_fac,ogb06,ogb07,",
                " ogb08,ogb09,ogb091,ogb092,ogb11,ogb12,ogb37,ogb13,ogb14,",#FUN-AB0061 ADD ogb37
                " ogb14t,ogb15,ogb15_fac,ogb16,ogb17,ogb18,ogb19,ogb31,",
                " ogb32,ogb60,ogb63,ogb64,ogb910,ogb911,ogb912,ogb913,ogb914,", 
                " ogb915,ogb916,ogb917,ogbplant,ogb1005,ogb1008,ogb1009,ogb1010,",
                " ogb44,ogb45,ogb46,ogb47,ogblegal)",
                "SELECT '",l_oga01 CLIPPED,"',oeb03,oeb04,oeb05,oeb05_fac,oeb06,oeb07,",
                "       oeb08,oeb09,oeb091,oeb092,oeb11,oeb12,oeb37,oeb13,oeb14,",#FUN-AB0061 ADD oeb37  
                "       oeb14t,oeb05,1,oeb12,'N',oeb12,'Y',oeb01,",
                "       oeb03,0,0,0,oeb910,oeb911,oeb912,oeb913,oeb914,",
                "       oeb915,oeb916,oeb917,oebplant,'1',oeb1008,oeb1009,oeb1010,",
                "       oeb44,oeb45,oeb46,oeb47,oeblegal",
               #"  FROM ",s_dbstring(l_dbs CLIPPED),"oeb_file", #FUN-A50102
                "  FROM ",cl_get_target_table(l_plant, 'oeb_file'), #FUN-A50102
                " WHERE oeb01 = '",l_oea.oea01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102
    PREPARE ins_ogb_temp FROM l_sql
    EXECUTE ins_ogb_temp
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins ogb_temp',SQLCA.sqlcode,1)
    END IF
    #FUN-CB0087--add--str--
    LET l_sql = " UPDATE ogb_temp a ",
                "    SET ogb1001 = (SELECT ggc08 FROM ggc_file ",
                "          WHERE (ggc01 = '",l_oga01,"' OR ggc01 ='*') ",
                "            AND (ggc02 = a.ogb31 OR a.ogb31 IS NULL OR ggc02='*') ",
                "            AND (ggc04 = a.ogb04 OR a.ogb04 IS NULL OR ggc04='*') ",
                "            AND (ggc05 = a.ogb09 OR a.ogb09 IS NULL OR ggc05='*') ",
                "            AND (ggc06 = '",l_oea.oea14,"' OR ggc06='*') ",
                "            AND (ggc07 = '",l_oea.oea15,"' OR ggc07='*') AND ggc09 ='Y' AND ggcacti='Y' AND rownum = 1) "
    PREPARE upd_ogb1001 FROM l_sql
    EXECUTE upd_ogb1001
    IF SQLCA.SQLERRD[3] = 0 AND SQLCA.sqlcode THEN 
       CALL cl_err('','aim-425',1)
       LET g_success='N'
    END IF 
    #FUN-CB0087--add--end--
#如果是最后一站取出貨機構，否則取機構預設倉庫對應機構    
    IF g_post THEN
       UPDATE ogb_temp SET ogb09 = g_rvn11,
                           ogb091 = ' ',
                           ogb092 = ' '
    ELSE
       #取預設成本倉   
       LET l_sql = "UPDATE ogb_temp a ",
                  #"   SET ogb09 = (SELECT rtz07 FROM rtz_file WHERE rtz01 = a.ogbplant),",   #FUN-C90049 mark
                   "   SET ogb09 = '", s_get_coststore(l_oea.oeaplant,''),"'",                      #FUN-C90049 add
                   "       ogb091 = ' ',",
                   "       ogb092 = ' '",             
                   " WHERE ogb44 = '1'"
       EXECUTE IMMEDIATE l_sql
       #取預設非成本倉 
       LET l_sql = "UPDATE ogb_temp a ",
                  #"   SET ogb09 = (SELECT rtz08 FROM rtz_file WHERE rtz01 = a.ogbplant),",   #FUN-C90049 mark
                   "   SET ogb09 = '", s_get_noncoststore(l_oea.oeaplant,''),"'",                   #FUN-C90049 add
                   "       ogb091 = ' ',",
                   "       ogb092 = ' '",
                   " WHERE ogb44 <> '1'"
       EXECUTE IMMEDIATE l_sql
       SELECT COUNT(*) INTO l_n FROM ogb_temp WHERE ogb09 IS NULL
       IF l_n>0 THEN
          LET g_success='N'
          INSERT INTO err_temp 
          SELECT 'ogbplant',ogbplant,'sel rtz07/rtz08','art-524',1
            FROM ogb_temp
           WHERE ogb09 IS NULL
       END IF
    END IF
#FUN-AB0061 -----------add start----------------                             
    LET l_sql = " UPDATE ogb_temp ",                                            
                "    SET ogb37 = ( SELECT ogb13 FROM ogb_temp) "                
    EXECUTE IMMEDIATE l_sql                                                     
#FUN-AB0061 -----------add end----------------  
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 -----------add start-------------
#    LET l_sql = " UPDATE ogb_temp ",
#               "    SET ogb50 = '1' WHERE ogb50 IS NULL "
#    EXECUTE IMMEDIATE l_sql
##FUN-AB0096 ----------add end---------------   
#FUN-AC0055 mark ----------------------end------------------------
##FUN-C50097 ----------add start--------------
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb50 = '0' WHERE ogb50 IS NULL "
    EXECUTE IMMEDIATE l_sql
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb51 = '0' WHERE ogb51 IS NULL "
    EXECUTE IMMEDIATE l_sql
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb52 = '0' WHERE ogb52 IS NULL "
    EXECUTE IMMEDIATE l_sql  
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb53 = '0' WHERE ogb53 IS NULL "
    EXECUTE IMMEDIATE l_sql
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb54 = '0' WHERE ogb54 IS NULL "
    EXECUTE IMMEDIATE l_sql
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb55 = '0' WHERE ogb55 IS NULL "
    EXECUTE IMMEDIATE l_sql           
##FUN-C50097 ----------add end---------------
    IF g_success = 'Y' THEN
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ogb_file SELECT * FROM ogb_temp" #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'ogb_file')," SELECT * FROM ogb_temp" #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102
         PREPARE ogb_ins FROM l_sql
         EXECUTE ogb_ins
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg("oga01",l_oga01,"INSERT INTO ogb_file",SQLCA.sqlcode,1)
         ELSE
            #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"oga_file SELECT * FROM oga_temp" #FUN-A50102
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'oga_file')," SELECT * FROM oga_temp" #FUN-A50102
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102
            PREPARE oga_ins FROM l_sql
            EXECUTE oga_ins
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg("oga01",l_oga01,"INSERT INTO oga_file",SQLCA.sqlcode,1)
            ELSE       
               #CALL t252_ship_log(l_oga01,l_pmm99,l_dbs) #FUN-A50102
               CALL t252_ship_log(l_oga01,l_pmm99,l_plant) #FUN-A50102
               IF g_success = 'Y' THEN
                  #CALL t252_upd_ima1(l_dbs) #FUN-A50102
                  CALL t252_upd_ima1(l_plant) #FUN-A50102
               END IF
            END IF
         END IF
    END IF
    IF g_success = 'N' THEN
        LET g_success ='Y'
        LET g_totsuccess = 'N'
    END IF
END FUNCTION
 
#img_file,tlf_file
#FUNCTION t252_ship_log(l_oga01,l_pmm99,l_dbs) #FUN-A50102
FUNCTION t252_ship_log(l_oga01,l_pmm99,l_plant) #FUN-A50102
DEFINE l_oga01 LIKE oga_file.oga01
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_tlf08 LIKE tlf_file.tlf08
DEFINE l_n LIKE type_file.num5
DEFINE l_ogb04 LIKE ogb_file.ogb04
DEFINE l_ogb09 LIKE ogb_file.ogb09
DEFINE l_ogb091 LIKE ogb_file.ogb091
DEFINE l_ogb092 LIKE ogb_file.ogb092
DEFINE l_ogb05 LIKE ogb_file.ogb05
DEFINE l_img09 LIKE img_file.img09
DEFINE l_ima01 LIKE ima_file.ima01               #TQC-9B0045 Add
DEFINE l_ima71 LIKE ima_file.ima71               #TQC-9B0045 Add
DEFINE l_plant LIKE pmm_file.pmmplant #FUN-A50102
 
#最后一站更新img_file，中間站不更新
    IF g_post THEN
      #料件庫存資料不存在則新增一筆
      DELETE FROM img_temp
      #No.FUN-A70123 ..begin
      #LET l_sql = "INSERT INTO img_temp(img01,img02,img03,img04,img10,img21) ",
      #            "SELECT DISTINCT ogb04,ogb09,ogb091,ogb092,0,1 FROM ogb_temp a",
      LET l_sql = "INSERT INTO img_temp(img01,img02,img03,img04,img10,img21,imgplant,imglegal) ",
                  "SELECT DISTINCT ogb04,ogb09,ogb091,ogb092,0,1,ogbplant,ogblegal FROM ogb_temp a",
      #No.FUN-A70123 ..end
                  #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                  "                    WHERE img01 = a.ogb04",
                  "                      AND img02 = a.ogb09",
                  "                      AND img03 = a.ogb091",
                  "                      AND img04 = a.ogb092)"
      EXECUTE IMMEDIATE l_sql
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins img_temp',SQLCA.sqlcode,1)
      END IF
      SELECT COUNT(img01) INTO l_n FROM img_temp
      IF l_n > 0 THEN
         LET l_sql = "UPDATE img_temp a",
                     "   SET img05 = '",l_oga01,"',",
                     "       img06 = (SELECT MIN(ogb03) FROM ogb_temp WHERE ogb04 = a.img01 AND ogb09 = a.img02),",
                     "       img13 = NULL,",
                     "       img17 = '",g_today,"',",
                     "       img20 = 1,",
                     "       img30 = 0,",
                     "       img31 = 0,",
                     "       img32 = 0,",
                     "       img33 = 0,",
                     "       img34 = 0,",
                     "       img37 = '",g_today,"'"
         EXECUTE IMMEDIATE l_sql
         LET l_sql = "UPDATE img_temp a ",
                     "       SET imgplant = (SELECT DISTINCT ogbplant FROM ogb_temp),",
                     "           imglegal = (SELECT DISTINCT ogblegal FROM ogb_temp)"
         EXECUTE IMMEDIATE l_sql
        #TQC-9B0045-Mark-Begin
#       LET l_sql = "UPDATE img_temp a",
#                   "   SET (img09,img18) = (SELECT ima25,DECODE(ima71,0,?,ima71 + ?)",
#                   "                          FROM ",s_dbstring(l_dbs CLIPPED),"ima_file",
#                   "                         WHERE ima01 = a.img01)"
#       PREPARE sh_img_upd1 FROM l_sql
#       EXECUTE sh_img_upd1 USING g_lastdat,g_today
        #TQC-9B0045-Mark-End
        #TQC-9B0045-Add-Begin
        LET l_sql = "UPDATE img_temp a",
                    "   SET img09 = (SELECT ima25",
                    #"                 FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
                    "                 FROM ",cl_get_target_table(l_plant, 'ima_file'), #FUN-A50102
                    "                WHERE ima01 = a.img01)"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
        PREPARE sh_img_upd1 FROM l_sql
        EXECUTE sh_img_upd1
        #LET l_sql = "   SELECT ima01,ima71 INTO l_ima71 ", #No.FUN-9B0157
        LET l_sql = "   SELECT ima01,ima71 ",               #No.FUN-9B0157
                    #"     FROM img_temp a ,",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
                    "     FROM img_temp a ,",cl_get_target_table(l_plant, 'ima_file'), #FUN-A50102
                    "    WHERE ima01 = a.img01"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
        PREPARE sh_ima71 FROM l_sql
        DECLARE ima_cs CURSOR FOR sh_ima71                                                                              
        FOREACH ima_cs INTO l_ima01,l_ima71
         IF l_ima71 = 0 THEN 
           LET l_sql = "UPDATE img_temp a",
                       "   SET img18 = '",g_lastdat,"'",
                       " WHERE a.img01 = '",l_ima01,"'"
           PREPARE sh_img_upd1_1 FROM l_sql
           EXECUTE sh_img_upd1_1
         ELSE
           LET l_sql = "UPDATE img_temp a",
                       "   SET img18 = '",l_ima71+g_today,"'",
                       " WHERE a.img01 = '",l_ima01,"'"
           PREPARE sh_img_upd1_2 FROM l_sql
           EXECUTE sh_img_upd1_2
         END IF
        END FOREACH
        #TQC-9B0045-Add-End
        LET l_sql = "UPDATE img_temp a",
                    "   SET (img22,img23,img24,img25,img26) = (SELECT ime04,ime05,ime06,ime07,ime09",
                    #"                                            FROM ",s_dbstring(l_dbs CLIPPED),"ime_file", #FUN-A50102
                    "                                            FROM ",cl_get_target_table(l_plant, 'ime_file'), #FUN-A50102
                    "                                           WHERE ime01 = a.img02",
                    "                                             AND ime02 = a.img03 AND imeacti = 'Y')",   #FUN-D40103
                    " WHERE img22 IS NULL"
        EXECUTE IMMEDIATE l_sql
        LET l_sql = "UPDATE img_temp a",
                    "   SET (img22,img23,img24,img25,img26) = (SELECT imd10,imd11,imd12,imd13,imd08",
                    #"                                            FROM ",s_dbstring(l_dbs CLIPPED),"imd_file", #FUN-A50102
                    "                                            FROM ",cl_get_target_table(l_plant, 'imd_file'), #FUN-A50102
                    "                                           WHERE imd01 = a.img02)",
                    " WHERE img22 IS NULL"
        EXECUTE IMMEDIATE l_sql
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                    "SELECT * FROM img_temp"
        EXECUTE IMMEDIATE l_sql
      END IF
#判斷料件單位和庫存單位是否有轉換率
      LET l_sql = "SELECT COUNT(*) FROM ogb_temp a",
                  " WHERE NOT EXISTS (SELECT 1 FROM smd_file ",
                  "                    WHERE smd01 = a.ogb04",
                  "                      AND smd02 = a.ogb05",
                  #"                      AND smd03 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  "                      AND smd03 = (SELECT img09 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                  "                                    WHERE img01 = a.ogb04",
                  "                                      AND img02 = a.ogb09",
                  "                                      AND img03 = a.ogb091",
                  "                                      AND img04 = a.ogb092))"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
      PREPARE sh_img_chk1 FROM l_sql
      EXECUTE sh_img_chk1 INTO l_n
      IF l_n > 0 THEN
         LET l_sql = "SELECT COUNT(*) FROM ogb_temp a",
                     " WHERE NOT EXISTS (SELECT 1 FROM smd_file ",
                     "                    WHERE smd01 = a.ogb04",
                     "                      AND smd03 = a.ogb05",
                     #"                      AND smd02 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                     "                      AND smd02 = (SELECT img09 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                     "                                    WHERE img01 = a.ogb04",
                     "                                      AND img02 = a.ogb09",
                     "                                      AND img03 = a.ogb091",
                     "                                      AND img04 = a.ogb092))"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
         PREPARE sh_img_chk2 FROM l_sql
         EXECUTE sh_img_chk2 INTO l_n
         IF l_n > 0 THEN
            LET l_sql = "SELECT COUNT(*) FROM ogb_temp ",
                        #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                        " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                        "                    WHERE img01 = ogb04",
                        "                      AND img02 = ogb09",
                        "                      AND img03 = ogb091",
                        "                      AND img04 = ogb092",
                        "                      AND img09 = ogb05)"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
            PREPARE sh_img_chk3 FROM l_sql
            EXECUTE sh_img_chk3 INTO l_n
            IF l_n > 0 THEN
               LET l_sql = "SELECT COUNT(*) FROM ogb_temp a",
                           " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                           "                    WHERE smc01 = a.ogb05",
                           #"                      AND smc02 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                           "                      AND smc02 = (SELECT img09 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                           "                                    WHERE img01 = a.ogb04",
                           "                                      AND img02 = a.ogb09",
                           "                                      AND img03 = a.ogb091",
                           "                                      AND img04 = a.ogb092))"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102            
               PREPARE sh_img_chk4 FROM l_sql
               EXECUTE sh_img_chk4 INTO l_n
               IF l_n > 0 THEN
                  LET l_sql = "SELECT COUNT(*) FROM ogb_temp a",
                              " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                              "                    WHERE smc02 = a.ogb05",
                              #"                      AND smc01 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                              "                      AND smc01 = (SELECT img09 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                              "                                    WHERE img01 = a.ogb04",
                              "                                      AND img02 = a.ogb09",
                              "                                      AND img03 = a.ogb091",
                              "                                      AND img04 = a.ogb092))"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
                  PREPARE sh_img_chk5 FROM l_sql
                  EXECUTE sh_img_chk5 INTO l_n
                  IF l_n > 0 THEN
                     LET g_success = 'N'
                     LET l_sql = "SELECT ogb04,ogb09,ogb091,ogb092,ogb05 FROM ogb_temp a",
                                 " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                                 "                    WHERE smc02 = a.ogb05",
                                 "                      AND smc01 = (SELECT img09 ",
                                 #"                                     FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                                 "                                     FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                                 "                                    WHERE img01 = a.ogb04",
                                 "                                      AND img02 = a.ogb09",
                                 "                                      AND img03 = a.ogb091",
                                 "                                      AND img04 = a.ogb092))"
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
                     CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
                     DECLARE sh_img_chk_cs CURSOR FROM l_sql
                     FOREACH sh_img_chk_cs INTO l_ogb04,l_ogb09,l_ogb091,l_ogb092,l_ogb05
                        LET l_sql = "SELECT img09 ",
                                    #"  FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                                    "  FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                                    " WHERE img01 = ?",
                                    "   AND img02 = ?",
                                    "   AND img03 = ?",
                                    "   AND img04 = ?"
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
                        CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
                        PREPARE sh_img09_cs FROM l_sql
                        EXECUTE sh_img09_cs USING l_ogb04,l_ogb09,l_ogb091,l_ogb092 INTO l_img09
                        LET g_showmsg = l_ogb04,"|",l_ogb05,"|",l_img09
                        CALL s_errmsg('ogb04,ogb05,img09',g_showmsg,'','mfg3075',1)
                     END FOREACH
                  END IF
               END IF
            END IF
          END IF
      END IF
#更新庫存量，最近异動日期      
      #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"img_file a", #FUN-A50102
      LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'img_file')," a", #FUN-A50102
                  "   SET img10 = img10 - (SELECT ogb12 FROM ogb_temp",
                  "                         WHERE ogb04 = a.img01",
                  "                           AND ogb09 = a.img02",
                  "                           AND ogb091 = a.img03",
                  "                           AND ogb092 = a.img04),",
                  "       img16 = ?,",
                  "       img17 = ?",
                  " WHERE EXISTS (SELECT 1 FROM ogb_temp",
                  "                WHERE ogb04 = a.img01",
                  "                  AND ogb09 = a.img02",
                  "                  AND ogb091 = a.img03",
                  "                  AND ogb092 = a.img04)"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
       CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
       PREPARE upd_img FROM l_sql
       EXECUTE upd_img USING g_today,g_today
     END IF
     
#tlf_file     
     DELETE FROM tlf_temp
     LET l_sql = "INSERT INTO tlf_temp ",
                 "(tlf01,tlf020,tlf021,tlf022,tlf023,tlf024,",
                 " tlf025,tlf026,tlf027,tlf030,tlf036,",
                 " tlf037,tlf10,tlf11,tlf12,tlf62,tlf63,tlf902,",
                 " tlf903,tlf904,tlf905,tlf906,tlfplant,tlflegal) ",
                 "SELECT ogb04,ogbplant,ogb09,ogb091,ogb092,ogb12,",
                 "       ogb910,ogb31,ogb32,ogbplant,ogb01,",
                 "       ogb03,ogb12,ogb15,ogb15_fac,ogb01,ogb03,ogb09,",
                 "       ogb091,ogb092,ogb01,ogb03,ogbplant,ogblegal",
                 "  FROM ogb_temp"
    PREPARE ins_tlf_temp FROM l_sql
    EXECUTE ins_tlf_temp
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins tlf_temp',SQLCA.sqlcode,1)
    END IF
    LET l_tlf08 = TIME
#TQC-9B0045-Mark-Begin
#   UPDATE tlf_temp
#      SET tlf02 = 50,
#          tlf03 = 724,
#          tlf06 = g_today,
#          tlf07 = g_today,
#          tlf08 = l_tlf08,
#          tlf09 = g_user,
#          tlf13 = 'axmt620',
#          tlf907 = -1,
#          tlf99 = l_pmm99,
#         #tlf61 = substr(tlf905,1,g_doc_len)  #FUN-9B0051
#          tlf61 = tlf905[1,g_doc_len]  #FUN-9B0051
#TQC-9B0045-Mark-End
#TQC-9B0045-Add-Begin
    LET l_sql = "  UPDATE tlf_temp ",
                "     SET tlf02 = 50,tlf03 = 724,",
                "         tlf06 = '",g_today,"',",
                "         tlf07 = '",g_today,"',",
                "         tlf08 = '",l_tlf08,"',",
                "         tlf09 = '",g_user,"',",
                "         tlf13 = 'axmt620',",
                "         tlf907 = -1,",
                "         tlf99 = '",l_pmm99,"',",
                "         tlf61 = tlf905[1,",g_doc_len,"]" 
      PREPARE tlf_upd_1 FROM l_sql
      EXECUTE tlf_upd_1
#TQC-9B0045-Add-End
    LET l_sql = "UPDATE tlf_temp a",
                "   SET (tlf024,tlf025) = (SELECT img10,img09",
                #"                            FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                "                            FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                "                           WHERE img01 = a.tlf01",
                "                             AND img02 = a.tlf031",
                "                             AND img03 = a.tlf032",
                "                             AND img04 = a.tlf033)"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE tlf_temp a",
#                "   SET tlf18 = (SELECT ima261 + ima262 ", #FUN-A20044
#                "                  FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A20044
#                "                 WHERE ima01 = a.tlf01)"#FUN-A20044
                "    SET tlf18 = (SELECT SUM(img10*img21)",
                #"                    FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                "                    FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                "                   WHERE img01 = a.tlf01 AND imgplant = a.tlfplant AND (img23 = 'Y' OR",
                "                     img23 = 'N'))"  #FUN-A20044
    EXECUTE IMMEDIATE l_sql
    #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tlf_file", #FUN-A50102
    LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'tlf_file'), #FUN-A50102
                " SELECT * FROM tlf_temp"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
    PREPARE ins_tlf FROM l_sql
    EXECUTE ins_tlf
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       LET g_showmsg = l_oga01,'|',l_pmm99
       CALL s_errmsg('oga01,oga99',g_showmsg,'ins tlf_file ',SQLCA.sqlcode,1)
    END IF
END FUNCTION
 
#收貨單
FUNCTION t252_receipt(l_pmm99,l_pmmplant,l_dbs) 
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_pmmplant LIKE pmm_file.pmmplant
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_pmm RECORD LIKE pmm_file.*
DEFINE l_rva01 LIKE rva_file.rva01
DEFINE l_rvb05 LIKE rvb_file.rvb05
DEFINE l_rvb36 LIKE rvb_file.rvb36
DEFINE l_rvb37 LIKE rvb_file.rvb37
DEFINE l_rvb38 LIKE rvb_file.rvb38
DEFINE l_rvb86 LIKE rvb_file.rvb86
DEFINE l_img09 LIKE img_file.img09
DEFINE li_result LIKE type_file.num5
DEFINE l_n   LIKE type_file.num5 
DEFINE l_ima01 LIKE ima_file.ima01                #TQC-9B0045 Add
DEFINE l_ima71 LIKE ima_file.ima71                #TQC-9B0045 Add
DEFINE l_time  LIKE rva_file.rvacont              #No.FUN-A10123
 
#取預設單別     
     #CALL t252_def_no(l_dbs,'apm','3') RETURNING l_rva01 #FUN-A50102
     CALL t252_def_no(l_pmmplant,'apm','3') RETURNING l_rva01 #FUN-A50102
 
#取採購單資料  
     #LET l_sql = "SELECT pmm_file.* FROM ",s_dbstring(l_dbs CLIPPED),"pmm_file WHERE pmm99 = ? AND pmmplant = ?" #FUN-A50102
     LET l_sql = "SELECT pmm_file.* FROM ",cl_get_target_table(l_pmmplant, 'pmm_file')," WHERE pmm99 = ? AND pmmplant = ?" #FUN-A50102
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
     CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
     PREPARE receipt_pmm_cs FROM l_sql
     EXECUTE receipt_pmm_cs USING l_pmm99,l_pmmplant INTO l_pmm.*
 
#自動編號  
     IF NOT cl_null(l_rva01) THEN
        CALL s_auto_assign_no("apm",l_rva01,g_today,"3","rva_file","rva01",l_pmmplant,"","")
             RETURNING li_result,l_rva01
        IF (NOT li_result) THEN                                                                           
           LET g_success = 'N'
           CALL s_errmsg('rva01',l_rva01,'','sub-145',1)
        END IF
     END IF
     DELETE FROM rva_temp
     #No.FUN-A70123 ..begin
     #INSERT INTO rva_temp(rva01,rva29,rva32,rvamksg) VALUES(l_rva01,' ',' ',' ') #No.FUN-9C0088
     INSERT INTO rva_temp(rva01,rva29,rva32,rvamksg,rvaplant,rvalegal) VALUES(l_rva01,' ',' ',' ',l_pmm.pmmplant,l_pmm.pmmlegal) 
     #No.FUN-A70123 ..end
     IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins rva_temp',SQLCA.sqlcode,1)
     END IF
        LET l_time = TIME #No.FUN-A10123
        UPDATE rva_temp
           SET rva02 = l_pmm.pmm01,
               rva99 = l_pmm.pmm99,
               rva04 = 'N',
               rva00 = '1',    #No.FUN-9B0157
               rva05 = l_pmm.pmm09,
               rva06 = g_today,
               rva10 = 'TAP',
               rvaprsw = 'N',
               rvaprno = 0,
               rva28 = NULL,
               rva29 = l_pmm.pmm51,
               rva30 = l_pmm.pmm52,
               rva31 = l_pmm.pmm53,
               rvaacti = 'Y',   #No.FUN-A10123
               rvauser = l_pmm.pmmuser,
               rvagrup = l_pmm.pmmgrup,
               rvaoriu = g_user,#No.FUN-A10123  
               rvaorig = g_grup,#No.FUN-A10123  
               rvacont = l_time,#No.FUN-A10123  
               rvacrat = l_pmm.pmmcrat,
               rvaconf = 'Y',
               rvacond = l_pmm.pmmcond,
               rvaconu = l_pmm.pmmconu,
               rvaplant = l_pmm.pmmplant,
               rvalegal = l_pmm.pmmlegal
         WHERE rva01 = l_rva01
     DELETE FROM rvb_temp      
     LET l_sql = "INSERT INTO rvb_temp ",
                 "(rvb01,rvb02,rvb03,rvb04,rvb05,rvb06,rvb07,rvb08,",
                 " rvb09,rvb10,rvb10t,rvb11,rvb12,rvb13,rvb14,rvb15,",
                 " rvb16,rvb17,rvb18,rvb19,rvb20,rvb21,rvb27,rvb28,",
                 " rvb29,rvb30,rvb31,rvb35,rvb36,rvb37,rvb38,rvb39,",
                 " rvb40,rvb41,rvb42,rvb43,rvb44,rvb45,rvb80,rvb81,",
                 " rvb82,rvb83,rvb84,rvb85,rvb86,rvb87,rvb88,rvb88t,rvb89,rvb90,rvbplant,rvblegal) ",#No.FUN-9B0157
                 "SELECT '",l_rva01 CLIPPED,"',pmn02,pmn02,pmn01,pmn04,0,pmn20,pmn20,",
                 "       0,pmn31,pmn31t,0,pmn33,'','',0,",
                 "       0,'','30','1','','',0,0,",
                 "       0,pmn20,pmn20,'N','',' ',' ','N',",
                 "       '','',pmn73,pmn74,pmn75,pmn76,pmn80,pmn81,",
                 "       pmn82,pmn83,pmn84,pmn85,pmn86,pmn87,pmn88,pmn88t,'N',pmn07,pmnplant,pmnlegal",#No.FUN-9B0157
                 #"  FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
                 "  FROM ",cl_get_target_table(l_pmmplant, 'pmn_file'), #FUN-A50102
                 " WHERE pmn01 = '",l_pmm.pmm01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
      PREPARE ins_rvb_temp FROM l_sql
      EXECUTE ins_rvb_temp      
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins rvb_temp',SQLCA.sqlcode,1)
      END IF
#取機構預設倉庫      
      IF l_pmm.pmm51 = '1' THEN
         UPDATE rvb_temp
           #SET rvb36 = (SELECT rtz07 FROM rtz_file WHERE rtz01 = l_pmm.pmmplant)    #FUN-C90049 mark
            SET rvb36 = s_get_coststore(l_pmm.pmmplant,'')                           #FUN-C90049 add
      ELSE
         UPDATE rvb_temp
           #SET rvb36 = (SELECT rtz08 FROM rtz_file WHERE rtz01 = l_pmm.pmmplant)    #FUN-C90049 mark
            SET rvb36 = s_get_noncoststore(l_pmm.pmmplant,'')                        #FUN-C90049 add
      END IF
      SELECT COUNT(*) INTO l_n FROM rvb_temp WHERE rvb36 IS NULL
      IF l_n > 0 THEN
         CALL s_errmsg('rvaplant',l_pmm.pmmplant,'aooi901a','art-524',1)
         LET g_success = 'N'
      END IF
      
#如果img資料不存在則新增一筆      
      DELETE FROM img_temp
      #No.FUN-A70123 ..begin
      #LET l_sql = "INSERT INTO img_temp(img01,img02,img03,img04,img10,img21) ",
      #            "SELECT DISTINCT rvb05,rvb36,rvb37,rvb38,0,1 FROM rvb_temp a",
      LET l_sql = "INSERT INTO img_temp(img01,img02,img03,img04,img10,img21,imgplant,imglegal) ",
                  "SELECT DISTINCT rvb05,rvb36,rvb37,rvb38,0,1,rvbplant,rvblegal FROM rvb_temp a",
      #No.FUN-A70123 ..end
                  #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                  "                    WHERE img01 = a.rvb05",
                  "                      AND img02 = a.rvb36",
                  "                      AND img03 = a.rvb37",
                  "                      AND img04 = a.rvb38)"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
      PREPARE ins_img_temp FROM l_sql
      EXECUTE ins_img_temp
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins img_temp',SQLCA.sqlcode,1)
      END IF
      SELECT COUNT(img01) INTO l_n FROM img_temp
      IF l_n > 0 THEN
         LET l_sql = "UPDATE img_temp a",
                     "   SET img05 = '",l_rva01,"',",
                     "       img06 = (SELECT MIN(rvb02) FROM rvb_temp WHERE rvb05 = a.img01 AND rvb36 = a.img02),",
                     "       img13 = NULL,",
                     "       img17 = '",g_today,"',",
                     "       img20 = 1,",
                     "       img30 = 0,",
                     "       img31 = 0,",
                     "       img32 = 0,",
                     "       img33 = 0,",
                     "       img34 = 0,",
                     "       img37 = '",g_today,"',",
                     "       imgplant = '",l_pmm.pmmplant,"',",
                     "       imglegal = '",l_pmm.pmmlegal,"'"
        EXECUTE IMMEDIATE l_sql
        #TQC-9B0045-Mark-Begin
#       LET l_sql = "UPDATE img_temp a",
#                   "   SET (img09,img18) = (SELECT ima25,DECODE(ima71,0,?,ima71 + ?)",
#                   "                          FROM ",s_dbstring(l_dbs CLIPPED),"ima_file",
#                   "                         WHERE ima01 = a.img01)"
#       PREPARE img_upd1 FROM l_sql
#       EXECUTE img_upd1 USING g_lastdat,g_today
        #TQC-9B0045-Mark-End
        #TQC-9B0045-Add-Begin
        LET l_sql = "UPDATE img_temp a",
                    "   SET img09 = (SELECT ima25",
                    #"                 FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
                    "                 FROM ",cl_get_target_table(l_pmmplant, 'ima_file'), #FUN-A50102
                    "                WHERE ima01 = a.img01)"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
        PREPARE img_upd1 FROM l_sql
        EXECUTE img_upd1
        #LET l_sql = "   SELECT ima01,ima71 INTO l_ima71 ", #No.FUN-9B0157
        LET l_sql = "   SELECT ima01,ima71 ",   #No.FUN-9B0157
                    #"     FROM img_temp a ,",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
                    "     FROM img_temp a ,",cl_get_target_table(l_pmmplant, 'ima_file'), #FUN-A50102
                    "    WHERE ima01 = a.img01"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102            
        PREPARE sh_ima71_1 FROM l_sql
        DECLARE ima_cs_1 CURSOR FOR sh_ima71_1
        FOREACH ima_cs_1 INTO l_ima01,l_ima71
         IF l_ima71 = 0 THEN
           LET l_sql = "UPDATE img_temp a",
                       "   SET img18 = '",g_lastdat,"'",
                       " WHERE a.img01 = '",l_ima01,"'"
           PREPARE img_upd1_1 FROM l_sql
           EXECUTE img_upd1_1
         ELSE
           LET l_sql = "UPDATE img_temp a",
                       "   SET img18 = '",l_ima71+g_today,"'",
                       " WHERE a.img01 = '",l_ima01,"'"
           PREPARE img_upd1_2 FROM l_sql
           EXECUTE img_upd1_2
         END IF
        END FOREACH
        #TQC-9B0045-Add-End
        LET l_sql = "UPDATE img_temp a",
                    "   SET (img22,img23,img24,img25,img26) = (SELECT ime04,ime05,ime06,ime07,ime09",
                    #"                                            FROM ",s_dbstring(l_dbs CLIPPED),"ime_file", #FUN-A50102
                    "                                            FROM ",cl_get_target_table(l_pmmplant, 'ime_file'), #FUN-A50102
                    "                                           WHERE ime01 = a.img02",
                    "                                             AND ime02 = a.img03 AND imeacti = 'Y')",  #FUN-D40103
                    " WHERE img22 IS NULL"
        EXECUTE IMMEDIATE l_sql
        LET l_sql = "UPDATE img_temp a",
                    "   SET (img22,img23,img24,img25,img26) = (SELECT imd10,imd11,imd12,imd13,imd08",
                    #"                                            FROM ",s_dbstring(l_dbs CLIPPED),"imd_file", #FUN-A50102
                    "                                            FROM ",cl_get_target_table(l_pmmplant, 'imd_file'), #FUN-A50102
                    "                                           WHERE imd01 = a.img02)",
                    " WHERE img22 IS NULL"
        EXECUTE IMMEDIATE l_sql
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                    " SELECT * FROM img_temp"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
        PREPARE ins_img FROM l_sql
        EXECUTE ins_img
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('','','ins img_file',SQLCA.sqlcode,1)
        END IF
      END IF
#判斷是否有換算率
      LET l_sql = "SELECT COUNT(*) FROM rvb_temp a",
                  " WHERE NOT EXISTS (SELECT 1 FROM smd_file ",
                  "                    WHERE smd01 = a.rvb05",
                  "                      AND smd02 = a.rvb86",
                  #"                      AND smd03 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  "                      AND smd03 = (SELECT img09 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                  "                                    WHERE img01 = a.rvb05",
                  "                                      AND img02 = a.rvb36",
                  "                                      AND img03 = a.rvb37",
                  "                                      AND img04 = a.rvb38))"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
      PREPARE img_chk1 FROM l_sql
      EXECUTE img_chk1 INTO l_n
      IF l_n > 0 THEN
         LET l_sql = "SELECT COUNT(*) FROM rvb_temp a",
                     " WHERE NOT EXISTS (SELECT 1 FROM smd_file ",
                     "                    WHERE smd01 = a.rvb05",
                     "                      AND smd03 = a.rvb86",
                     #"                      AND smd02 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                     "                      AND smd02 = (SELECT img09 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                     "                                    WHERE img01 = a.rvb05",
                     "                                      AND img02 = a.rvb36",
                     "                                      AND img03 = a.rvb37",
                     "                                      AND img04 = a.rvb38))"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102            
         PREPARE img_chk2 FROM l_sql
         EXECUTE img_chk2 INTO l_n
         IF l_n > 0 THEN
            LET l_sql = "SELECT COUNT(*) FROM rvb_temp ",
                        #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                        " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                        "                    WHERE img01 = rvb05",
                        "                      AND img02 = rvb36",
                        "                      AND img03 = rvb37",
                        "                      AND img04 = rvb38",
                        "                      AND img09 = rvb86)"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102            
            PREPARE img_chk3 FROM l_sql
            EXECUTE img_chk3 INTO l_n
            IF l_n > 0 THEN 
               LET l_sql = "SELECT COUNT(*) FROM rvb_temp a",
                           " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                           "                    WHERE smc01 = a.rvb86",
                           #"                      AND smc02 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                           "                      AND smc02 = (SELECT img09 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                           "                                    WHERE img01 = a.rvb05",
                           "                                      AND img02 = a.rvb36",
                           "                                      AND img03 = a.rvb37",
                           "                                      AND img04 = a.rvb38))"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
               CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102            
               PREPARE img_chk4 FROM l_sql
               EXECUTE img_chk4 INTO l_n
               IF l_n > 0 THEN
                  LET l_sql = "SELECT COUNT(*) FROM rvb_temp a",
                              " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                              "                    WHERE smc02 = a.rvb86",
                              #"                      AND smc01 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                              "                      AND smc01 = (SELECT img09 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                              "                                    WHERE img01 = a.rvb05",
                              "                                      AND img02 = a.rvb36",
                              "                                      AND img03 = a.rvb37",
                              "                                      AND img04 = a.rvb38))"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102            
                  PREPARE img_chk5 FROM l_sql
                  EXECUTE img_chk5 INTO l_n
                  IF l_n > 0 THEN
                     LET l_sql = "SELECT rvb05,rvb36,rvb37,rvb38,rvb86 FROM rvb_temp a",
                                 " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                                 "                    WHERE smc02 = a.rvb86",
                                 "                      AND smc01 = (SELECT img09 ",
                                 #"                                     FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                                 "                                     FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                                 "                                    WHERE img01 = a.rvb05",
                                 "                                      AND img02 = a.rvb36",
                                 "                                      AND img03 = a.rvb37",
                                 "                                      AND img04 = a.rvb38))"
                     DECLARE img_chk_cs CURSOR FROM l_sql
                     LET g_success = 'N'
                     FOREACH img_chk_cs INTO l_rvb05,l_rvb36,l_rvb37,l_rvb38,l_rvb86
                        LET l_sql = "SELECT img09 ",
                                    #"  FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                                    "  FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                                    " WHERE img01 = ?",
                                    "   AND img02 = ?",
                                    "   AND img03 = ?",
                                    "   AND img04 = ?"
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
                        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102            
                        PREPARE img09_cs FROM l_sql
                        EXECUTE img09_cs USING l_rvb05,l_rvb36,l_rvb37,l_rvb38 INTO l_img09
                        LET g_showmsg = l_pmmplant,"|",l_rvb05,"|",l_rvb86,"|",l_img09
                        CALL s_errmsg('rvbplant,rvb05,rvb86,img09',g_showmsg,'','mfg3075',1)
                     END FOREACH
                  END IF
               END IF
            END IF
          END IF
      END IF
      IF g_success = 'Y' THEN
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rvb_file SELECT * FROM rvb_temp" #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'rvb_file')," SELECT * FROM rvb_temp" #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
         PREPARE rvb_ins FROM l_sql
         EXECUTE rvb_ins
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg("rvb01",l_rva01,"INSERT INTO rvb_file",SQLCA.sqlcode,1)
         ELSE
            #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rva_file SELECT * FROM rva_temp" #FUN-A50102
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'rvb_file')," SELECT * FROM rva_temp" #FUN-A50102
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
            PREPARE rva_ins FROM l_sql
            EXECUTE rva_ins
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg("rvb01",l_rva01,"INSERT INTO rva_file",SQLCA.sqlcode,1)
            ELSE    
               #CALL t252_receipt_log(l_rva01,l_dbs) #FUN-A50102
               CALL t252_receipt_log(l_rva01,l_pmmplant) #FUN-A50102
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN
         LET g_success ='Y'
         LET g_totsuccess = 'N'
      END IF
END FUNCTION
 
#入庫更新料件資料
#FUNCTION t252_upd_ima(l_dbs) #FUN-A50102
FUNCTION t252_upd_ima(l_plant) #FUN-A50102
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_plant LIKE poy_file.poy04    #FUN-A50102
########FUNA-A20044----BEGIN 
#更新MPS/MRP可用庫存量
#     LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
 #                "   SET ima26 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
  #               "                 WHERE img01= a.ima01 AND img24='Y')",
   #              " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
    #             "                WHERE rvv31 = a.ima01)"
#     EXECUTE IMMEDIATE l_sql
#更新不可用庫存量     
#     LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
 #                "   SET ima261 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
  #               "                 WHERE img01= a.ima01 AND img23='N')",
   #              " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
    #             "                WHERE rvv31 = a.ima01)"
    # EXECUTE IMMEDIATE l_sql
#更新庫存可用量     
#      LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
 #                "   SET ima262 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
  ##               "                 WHERE img01= a.ima01 AND img23='Y')",
     #            " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
    #             "                WHERE rvv31 = a.ima01)"
  #   EXECUTE IMMEDIATE l_sql
#更新最近异動日，最近入庫日     
     #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
     LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'ima_file')," a ", #FUN-A50102
                 "   SET ima29 = '",g_today,"',",
                 "       ima73 = '",g_today,"'",
                 " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
                 "                WHERE rvv31 = a.ima01)"
    EXECUTE IMMEDIATE l_sql
#更新首次入庫日
    #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
    LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'ima_file')," a ", #FUN-A50102
                "   SET ima1013 = '",g_today,"'",
                " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
                "                WHERE rvv31 = a.ima01)",
                "   AND ima1013 IS NULL"
    EXECUTE IMMEDIATE l_sql
#######FUN-A20044-----END
END FUNCTION
 
#出貨更新料件資料
#FUNCTION t252_upd_ima1(l_dbs) #FUN-A50102
FUNCTION t252_upd_ima1(l_plant) #FUN-A50102
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_plant LIKE pmm_file.pmmplant #FUN-A50102

#######FUN-A20044-----BEGIN 
#更新MPS/MRP可用存量
#     LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
#                 "   SET ima26 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
 #                "                 WHERE img01= a.ima01 AND img24='Y')",
  #               " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
   #              "                WHERE ogb04 = a.ima01)"
    # EXECUTE IMMEDIATE l_sql
#更新不可用存量
#     LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
 #                "   SET ima261 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
  #               "                 WHERE img01= a.ima01 AND img23='N')",
   #              " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
    #             "                WHERE ogb04 = a.ima01)"
#     EXECUTE IMMEDIATE l_sql
#更新存可用量
#      LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
 #                "   SET ima262 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
  #               "                 WHERE img01= a.ima01 AND img23='Y')",
   #              " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
    #             "                WHERE ogb04 = a.ima01)"
 #    EXECUTE IMMEDIATE l_sql
#更新最近异動日，最近出貨日
     #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
     LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'ima_file')," a ", #FUN-A50102
                 "   SET ima29 = '",g_today,"',",
                 "       ima74 = '",g_today,"'",
                 " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
                 "                WHERE ogb04 = a.ima01)"
    EXECUTE IMMEDIATE l_sql
#更新首次出貨日
    #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
    LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'ima_file')," a ", #FUN-A50102
                "   SET ima1012 = '",g_today,"'",
                " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
                "                WHERE ogb04 = a.ima01)",
                "   AND ima1012 IS NULL"
    EXECUTE IMMEDIATE l_sql
########FUN-A20044----END
END FUNCTION
 
#入庫單
#FUNCTION t252_stockin(l_dbs)  #FUN-A50102
FUNCTION t252_stockin(l_plant)  #FUN-A50102
DEFINE l_rvu01 LIKE rvu_file.rvu01
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_rva RECORD LIKE rva_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_sql STRING
DEFINE l_n     LIKE type_file.num5
DEFINE l_rvucont LIKE rvu_file.rvucont
DEFINE l_rvu03   LIKE rvu_file.rvu03
DEFINE l_rvu04   LIKE rvu_file.rvu04
DEFINE l_plant LIKE poy_file.poy04    #FUN-A50102
#取預設單別
   #CALL t252_def_no(l_dbs,'apm','7') RETURNING l_rvu01 #FUN-A50102
   CALL t252_def_no(l_plant,'apm','7') RETURNING l_rvu01 #FUN-A50102
 
#取收貨資料
   SELECT * INTO l_rva.* FROM rva_temp
   IF NOT cl_null(l_rvu01) THEN
      CALL s_auto_assign_no("apm",l_rvu01,g_today,"7","rvu_file","rvu01",l_rva.rvaplant,"","")
           RETURNING li_result,l_rvu01
      IF (NOT li_result) THEN                                                                           
         LET g_success = 'N'
         CALL s_errmsg('rvu01',l_rvu01,'','sub-145',1)
      END IF
   END IF
   DELETE FROM rvu_temp
   LET l_rvu03 = l_rva.rva06
   LET l_rvu04 = l_rva.rva05
   #No.FUN-A70123 ..begin
   #INSERT INTO rvu_temp(rvu01,rvu21,rvu900,rvumksg,rvupos)
   #   VALUES(l_rvu01,' ','1','N','N')
  #TQC-B60065 Begin---
  #INSERT INTO rvu_temp(rvu01,rvu21,rvu900,rvumksg,rvupos,rvuplant,rvulegal)
  #   VALUES(l_rvu01,' ','1','N','N',' ',' ')
   INSERT INTO rvu_temp(rvu01,rvu21,rvu900,rvumksg,rvupos,rvuplant,rvulegal,rvu27)
      VALUES(l_rvu01,' ','1','N','N',' ',' ','1')
  #TQC-B60065 End-----
   #No.FUN-A70123 ..end
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('','','ins rvu_temp',SQLCA.sqlcode,1)
   END IF
   LET l_rvucont = TIME
   UPDATE rvu_temp 
      SET rvu00 = '1',
          rvu99 = l_rva.rva99,
          rvu01 = l_rvu01,
          rvu02 = l_rva.rva01,
          rvu03 = l_rva.rva06,
          rvu04 = l_rva.rva05,
          rvu05 = (SELECT pmc03 FROM pmc_file WHERE pmc01=l_rva.rva05),
          rvu06 = g_grup,
          rvu07 = g_user,
          rvu08 = l_rva.rva10,
          rvu20 = 'Y',
          rvu21 = l_rva.rva29,
          rvu22 = l_rva.rva30,
          rvu23 = l_rva.rva31,
          rvuconf = 'Y',
          rvuacti = 'Y',   #No.FUN-A10123
          rvucond = l_rva.rvacond,
          rvuconu = l_rva.rvaconu,
          rvucont = l_rvucont,
          rvuuser = l_rva.rvauser,
          rvugrup = l_rva.rvagrup,
          rvuoriu = g_user,#No.FUN-A10123  
          rvuorig = g_grup,#No.FUN-A10123  
          rvucrat = l_rva.rvacrat,
          rvuplant = l_rva.rvaplant,
          rvulegal = l_rva.rvalegal
   
   DELETE FROM rvv_temp
     #LET l_sql = "INSERT INTO rvv_temp ", FUN-9C0111 mark
      LET l_sql = "INSERT INTO rvv_temp(rvv01,rvv02,rvv03,rvv04,rvv05,  ",                  #FUN-9C0111
                  "                     rvv06,rvv09,rvv17,rvv18,rvv23,rvv24,rvv25, ",       #FUN-9C0111
                  "                     rvv26,rvv31,rvv031,rvv32,rvv33,rvv34,rvv35,  ",     #FUN-9C0111
                  "                     rvv35_fac,rvv36,rvv37,rvv38,rvv39,rvv40,rvv41,rvv42,rvv43, ", #FUN-9C0111
                  "                     rvv80,rvv81,rvv82,rvv83,rvv84,rvv85,   ",    #FUN-9C0111
                  "                     rvv86,rvv87,rvv39t,rvv38t,rvv930,rvv88,  ",  #FUN-9C0111
                  "                     rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,", #FUN-9C0111
                  "                     rvv89,rvvplant,rvvlegal,rvv10,rvv11,rvv12,rvv13) ", #FUN-9C0111 
                  "SELECT '",l_rvu01 CLIPPED,"',rvb02,'1',rvb01,rvb02,",
                  "       '",l_rvu04 CLIPPED,"','",l_rvu03,"',rvb31,rvb34,0,' ',rvb35,",
                  "       ' ',rvb05,'',rvb36,rvb37,rvb38,rvb86,",                        
                  "       '',rvb04,rvb03,rvb10,rvb88,'N',rvb25,'','', ",
                  "       rvb80,rvb81,rvb82,rvb83,rvb84,rvb85,",
                  "       rvb86,rvb87,rvb88t,rvb10t,rvb930,0,",
                  "       '','','','','','','','','','','','','','','',",
                  "       'N',rvbplant,rvblegal,rvb42,rvb43,rvb44,rvb45",
                  "  FROM rvb_temp"
      PREPARE ins_rvv_temp FROM l_sql
      EXECUTE ins_rvv_temp
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins rvv_temp',SQLCA.sqlcode,1)
      END IF
      LET l_sql = "UPDATE rvv_temp a",
                  #"   SET (rvv031,rvv35_fac) = (SELECT pmn041,pmn09 FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
                  "   SET (rvv031,rvv35_fac) = (SELECT pmn041,pmn09 FROM ",cl_get_target_table(l_plant, 'pmn_file'), #FUN-A50102
                  "                              WHERE pmn01 = a.rvv36",
                  "                                AND pmn02 = a.rvv37)"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102
      PREPARE rvv_temp_upd FROM l_sql
      EXECUTE rvv_temp_upd
      #FUN-CB0087---qiull---add---str---
      LET l_sql = " UPDATE rvv_temp a ",
                  "    SET rvv26 = (SELECT ggc08 FROM ggc_file ",
                  "          WHERE (ggc01 = '",l_rvu01,"' OR ggc01 ='*') ",
                  "            AND (ggc02 = a.rvv04 OR a.rvv04 IS NULL OR ggc02='*') ",
                  "            AND (ggc04 = a.rvv31 OR a.rvv31 IS NULL OR ggc04='*') ",
                  "            AND (ggc05 = a.rvv32 OR a.rvv32 IS NULL OR ggc05='*') ",
                  "            AND (ggc06 = '",g_user,"' OR ggc06='*') ",
                  "            AND (ggc07 = '",g_grup,"' OR ggc07='*') AND ggc09='Y' AND ggcacti='Y AND rownum =1) "
      PREPARE upd_rvv26 FROM l_sql
      EXECUTE upd_rvv26
      IF SQLCA.SQLERRD[3] = 0 AND SQLCA.sqlcode THEN
         CALL cl_err('','aim-425',1)
         LET g_success='N'
      END IF
      #FUN-CB0087---qiull---add---end---
      IF g_success = 'Y' THEN
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rvu_file SELECT * FROM rvu_temp" #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'rvu_file')," SELECT * FROM rvu_temp" #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102
         PREPARE rvu_ins FROM l_sql
         EXECUTE rvu_ins
         IF SQLCA.sqlcode THEN
            CALL s_errmsg("rvu01",l_rvu01,'insert into rvu_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE
            #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rvv_file SELECT * FROM rvv_temp" #FUN-A50102
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'rvv_file')," SELECT * FROM rvv_temp" #FUN-A50102
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102
            PREPARE rvv_ins FROM l_sql
            EXECUTE rvv_ins
            IF SQLCA.sqlcode THEN
               CALL s_errmsg("rvv01",l_rvu01,'insert into rvv_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
            ELSE
               #CALL t252_stockin_log(l_rvu01,l_rva.rva99,l_dbs) #FUN-A50102
               CALL t252_stockin_log(l_rvu01,l_rva.rva99,l_plant) #FUN-A50102
               IF g_success = 'Y' THEN
                  #CALL t252_upd_ima(l_dbs) #FUN-A50102
                  CALL t252_upd_ima(l_plant) #FUN-A50102
               END IF
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN
         LET g_success ='Y'
         LET g_totsuccess = 'N'
      END IF
END FUNCTION
 
#收貨單日志
#FUNCTION t252_receipt_log(l_rva01,l_dbs) #FUN-A50102
FUNCTION t252_receipt_log(l_rva01,l_pmmplant) #FUN-A50102
DEFINE l_rva01 LIKE rva_file.rva01
DEFINE l_rva05 LIKE rva_file.rva05
DEFINE l_rva06 LIKE rva_file.rva06
DEFINE l_rva99 LIKE rva_file.rva99
DEFINE l_tlf08 LIKE tlf_file.tlf08
DEFINE l_sql STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_pmmplant LIKE pmm_file.pmmplant #FUN-A50102
   
   DELETE FROM tlf_temp
   INSERT INTO tlf_temp
             (tlf01,tlf020,tlf026,tlf027,tlf030,tlf031,tlf032,tlf033,
              tlf036,tlf037,tlf10,tlf62,tlf63,tlf64,tlfplant,tlflegal)
   SELECT rvb05,rvbplant,rvb04,rvb03,rvbplant,rvb36,rvb37,rvb38,
          rvb01,rvb02,rvb07,rvb04,rvb03,rvb25,rvbplant,rvblegal
     FROM rvb_temp
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('','','ins tlf_temp',SQLCA.sqlcode,1)
   END IF
   LET l_tlf08 = TIME
   SELECT rva05,rva06,rva99 
     INTO l_rva05,l_rva06,l_rva99
     FROM rva_temp WHERE rva01 = l_rva01
#TQC-9B0045-Mark-Begin
#  UPDATE tlf_temp
#     SET tlf02 = 10,
#         tlf03  = 20,
#         tlf13  = 'apmt1101',
#         tlf06  = l_rva06,
#         tlf07  = g_today,
#         tlf08  = l_tlf08,
#         tlf09  = g_user,
#         tlf19  = l_rva05,
#         tlf902 = tlf031,
#         tlf903 = tlf032,
#         tlf904 = tlf033,
#         tlf905 = tlf036,
#         tlf906 = tlf037,
#         tlf907 = 0,
#         tlf99  = l_rva99,
#        #tlf61  = substr(tlf036,1,g_doc_len)  #FUN-9B0051
#         tlf61  = tlf036[1,g_doc_len]  #FUN-9B0051
#TQC-9B0045-Mark-End
#TQC-9B0045-Add-Begin
   LET l_sql = " UPDATE tlf_temp ",
               "    SET tlf02 = 10,",
               "        tlf03  = 20,",
               "        tlf13  = 'apmt1101',",
               "        tlf06  = '",l_rva06,"',",
               "        tlf07  = '",g_today,"',",
               "        tlf08  = '",l_tlf08,"',",
               "        tlf09  = '",g_user,"',",
               "        tlf19  = '",l_rva05,"',",
               "        tlf902 = tlf031,",
               "        tlf903 = tlf032,",
               "        tlf904 = tlf033,",
               "        tlf905 = tlf036,",
               "        tlf906 = tlf037,",
               "        tlf907 = 0,",
               "        tlf99  = '",l_rva99,"',",
               "        tlf61  = tlf036[1,'",g_doc_len,"'] "
    PREPARE tlf_upd_2 FROM l_sql
    EXECUTE tlf_upd_2
#TQC-9B0045-Add-End

      LET l_sql = "UPDATE tlf_temp a",
                  "   SET (tlf11,tlf12) = (SELECT pmn07,pmn09",
                  #"                          FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
                  "                          FROM ",cl_get_target_table(l_pmmplant, 'pmn_file'), #FUN-A50102
                  "                         WHERE pmn01 = a.tlf026 ",
                  "                           AND pmn02 = a.tlf027),",
#                  "        tlf18 = (SELECT ima261 + ima262 ", #FUN-A20044
#                  "                   FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A20044
#                  "                  WHERE ima01 = a.tlf01)" #FUN-A20044
                  "     tlf18 = (SELECT SUM(img10*img21)",
                  #"                     FROM ",s_dbstring(l_dbs CLIPPED), "img_file", #FUN-A50102
                  "                     FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                  "                   WHERE img01 = a.tlf01 AND imgplant = a.tlfplant AND (img23 = 'Y' OR",
                  "                     img23 = 'N'))"  #FUN-A20044
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102
      PREPARE re_tlf_upd FROM l_sql
      EXECUTE re_tlf_upd
      #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tlf_file", #FUN-A50102
      LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'tlf_file'), #FUN-A50102
                  " SELECT * FROM tlf_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102
      PREPARE re_ins_tlf FROM l_sql
      EXECUTE re_ins_tlf
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('rva01',l_rva01,'ins tlf_file',SQLCA.sqlcode,1)
      END IF
END FUNCTION
 
#入庫單日志
#FUNCTION t252_stockin_log(l_rvu01,l_pmm99,l_dbs) #FUN-A50102
FUNCTION t252_stockin_log(l_rvu01,l_pmm99,l_plant) #FUN-A50102
DEFINE l_rvu01 LIKE rvu_file.rvu01
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_dbs  LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_tlf08 LIKE tlf_file.tlf08
DEFINE l_plant LIKE poy_file.poy04 #FUN-A50102
 
#中間站庫存不异動
     IF g_post THEN     
        #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"img_file a", #FUN-A50102
#MOD-AC0245 --begin--
#        LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'img_file')," a", #FUN-A50102
#                    "   SET img10 = img10 + (SELECT rvv17 FROM rvv_temp",
#                    "                         WHERE rvv31 = a.img01",
#                    "                           AND rvv32 = a.img02",
#                    "                           AND rvv33 = a.img03",
#                    "                           AND rvv34 = a.img04),",
#                    "       img15 = ?,",
#                    "       img17 = ?",
#                    " WHERE EXISTS (SELECT 1 FROM rvv_temp",
#                    "                WHERE rvv31 = a.img01",
#                    "                  AND rvv32 = a.img02",
#                    "                  AND rvv33 = a.img03",
#                    "                  AND rvv34 = a.img04)"
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'img_file')," img_file", 
                    "   SET img10 = img10 + (SELECT rvv17 FROM rvv_temp",
                    "                         WHERE rvv31 = img_file.img01",
                    "                           AND rvv32 = img_file.img02",
                    "                           AND rvv33 = img_file.img03",
                    "                           AND rvv34 = img_file.img04),",
                    "       img15 = ?,",
                    "       img17 = ?",
                    " WHERE EXISTS (SELECT 1 FROM rvv_temp",
                    "                WHERE rvv31 = img_file.img01",
                    "                  AND rvv32 = img_file.img02",
                    "                  AND rvv33 = img_file.img03",
                    "                  AND rvv34 = img_file.img04)"
#MOD-AC0245 --end--
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
       CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102             
       PREPARE st_upd_img FROM l_sql
       EXECUTE st_upd_img USING g_today,g_today
     END IF
     DELETE FROM tlf_temp
     INSERT INTO tlf_temp(tlf01,tlf020,tlf026,tlf027,tlf030,tlf031,tlf032,
                          tlf033,tlf034,tlf035,tlf036,tlf037,
                          tlf06,tlf10,tlf11,tlf12,tlf14,tlf19,
                          tlf20,tlf62,tlf63,tlf64,tlfplant,tlflegal)
     SELECT rvv31,rvvplant,rvv04,rvv05,rvvplant,rvv32,rvv33,
            rvv34,rvv17,rvv35,rvv01,rvv02,
            rvv09,rvv17,rvv35,rvv35_fac,rvv26,rvv06,
            rvv34,rvv36,rvv37,rvv41,rvvplant,rvvlegal
       FROM rvv_temp
     IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins tlf_temp',SQLCA.sqlcode,1)
     END IF
     LET l_tlf08 = TIME
     UPDATE tlf_temp
        SET tlf02  = 20,                #來源狀況
            tlf03=50,                   
            tlf06=g_today,
            tlf07=g_today,              #異動資料產生日期
            tlf08=l_tlf08,              #異動資料產生時:分:秒
            tlf09=g_user,               #產生人
            tlf13='apmt150',            #異動命令代號
           #tlf61=substr(tlf905,1,3),  #FUN-9B0051
            tlf61=tlf905[1,3],  #FUN-9B0051
            tlf902 = tlf031,
            tlf903 = tlf032,
            tlf904 = tlf033,
            tlf905 = tlf036,
            tlf906 = tlf037,
            tlf907 = 1,
            tlf99 = l_pmm99 
    LET l_sql = "UPDATE tlf_temp a",
                "   SET (tlf034,tlf035) = (SELECT img10,img09",
                #"                            FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                "                            FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                "                           WHERE img01 = a.tlf01",
                "                             AND img02 = a.tlf031",
                "                             AND img03 = a.tlf032",
                "                             AND img04 = a.tlf033)"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102
    PREPARE st_tlf_upd3 FROM l_sql
    EXECUTE st_tlf_upd3
    LET l_sql = "UPDATE tlf_temp a",
#                "   SET tlf18 = (SELECT ima261 + ima262 ", #FUN-A20044
#                "                  FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A20044
#                "                 WHERE ima01 = a.tlf01)"#FUN-A20044
                "    SET tlf18 = (SELECT SUM(img10*img21)", #FUN-A20044 
                #"                    FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
                "                    FROM ",cl_get_target_table(l_plant, 'ima_file'), #FUN-A50102
                "                   WHERE img01 = a.tlf01 AND imgplant = a.tlfplant  AND (img23 = 'Y' OR",
                "                     img23 = 'N'))"  #FUN-A20044
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102          
      PREPARE st_tlf_upd4 FROM l_sql
      EXECUTE st_tlf_upd4
      #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tlf_file", #FUN-A50102
      LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'tlf_file'), #FUN-A50102
                  " SELECT * FROM tlf_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102            
      PREPARE st_ins_tlf FROM l_sql
      EXECUTE st_ins_tlf
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('rvu01',l_rvu01,'ins tlf_file',SQLCA.sqlcode,1)
      END IF
END FUNCTION
 
#派車單
FUNCTION t252_dispatch()
DEFINE l_rvn RECORD LIKE rvn_file.*
DEFINE l_adk RECORD LIKE adk_file.*
DEFINE l_adl RECORD LIKE adl_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_no LIKE adk_file.adk01
 
    IF g_rvm.rvm07 <> 'Y' THEN
       RETURN
    END IF
    IF g_totsuccess = 'N' THEN
       RETURN
    END IF 
    DELETE FROM rvn_temp2
    INSERT INTO rvn_temp2
    SELECT rvn_file.* 
      FROM rvm_file,rvn_file 
     WHERE rvm01 = rvn01
       AND rvmplant = rvnplant
       AND rvm07 = 'Y'
       AND rvm01 = g_rvm.rvm01
       AND rvmplant = g_rvm.rvmplant
    DECLARE rvn_cs3 CURSOR FOR SELECT DISTINCT rvn08 FROM rvn_temp2
    DECLARE rvn_cs4 CURSOR FROM "SELECT rvn02,rvn03,rvn04,rvn06,rvn10 FROM rvn_temp2 WHERE rvn08 = ?"
 
#取預設單別arti099
  #FUN-C90050 mark begin---
  #  SELECT rye03 INTO l_no
  #    FROM rye_file
  ##   WHERE rye01 = 'axm'
  ##     AND rye02 = '19'   
  #    WHERE rye01 = 'atm'                             #FUN-A70130
  #      AND rye02 = 'U8'                              #FUN-A70130
  #      AND ryeacti = 'Y'
  #FUN-C90050 mark end-----

    CALL s_get_defslip('atm','U8',g_plant,'N') RETURNING l_no    #FUN-C90050 add

    IF cl_null(l_no) THEN
       CALL s_errmsg('','','axm 19','art-330',1)
       LET g_success = 'N'
       LET g_totsuccess = 'N'                         #TQC-C80180 add 
       RETURN
    END IF
    CALL cl_getmsg('art-562',g_lang) RETURNING g_msg
    FOREACH rvn_cs3 INTO l_rvn.rvn08
       IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rvn_cs3:',STATUS,1)
         CONTINUE FOREACH
      END IF
      CALL t252_progressing(g_msg) 
#     CALL s_auto_assign_no("axm",l_no,g_today,"19","adk_file","adk01","","","") #FUN-A70130 mark
#     CALL s_auto_assign_no("art",l_no,g_today,"U8","adk_file","adk01","","","") #FUN-A70130 mod   #TQC-C80180 mark
      CALL s_auto_assign_no("atm",l_no,g_today,"U8","adk_file","adk01","","","") #TQC-C80180 add
           RETURNING li_result,l_adk.adk01
      IF (NOT li_result) THEN                                                                           
          LET g_success = 'N'
          CALL s_errmsg('adk01',l_no,'','sub-145',1)
          CONTINUE FOREACH
      END IF
      INSERT INTO adk_temp(adk01,adk02,adk13,adk14,adk15,adk17,adkplant,adklegal,
                           adkconf,adkmksg,adkuser,adkgrup,adkdate,adkacti,adkoriu,adkorig)    #TQC-A40036 ADD--
                   VALUES(l_adk.adk01,g_today,g_user,g_grup,g_rvm.rvm05,'0',g_rvm.rvmplant,g_rvm.rvmlegal,
                          'N','N',g_user,g_grup,g_today,'Y',g_user,g_grup)                     #TQC-A40036 ADD-- 
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins adk_temp',SQLCA.sqlcode,1)
      END IF
      LET g_cnt = 1
    
    FOREACH rvn_cs4 USING l_rvn.rvn08
                     INTO l_rvn.rvn02,l_rvn.rvn03,l_rvn.rvn04,
                          l_rvn.rvn06,l_rvn.rvn10
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rvn_cs4:',STATUS,1)
         CONTINUE FOREACH
      END IF     
      
#TQC-A70088 --begin
   #  INSERT INTO adl_temp (adl01,adl02)VALUES(l_adk.adk01,g_cnt)        
      INSERT INTO adl_temp (adl01,adl02,adlplant,adllegal)VALUES(l_adk.adk01,g_cnt,g_plant,g_legal)        
#TQC-A70088 --end  add   addplant  addlegal
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins adl_temp',SQLCA.sqlcode,1)
      END IF
         SELECT ruc16
           INTO l_adl.adl20
           FROM ruc_file
          WHERE ruc01 = l_rvn.rvn06
            AND ruc02 = l_rvn.rvn03
            AND ruc03 = l_rvn.rvn04
         UPDATE adl_temp SET adl11 = '3',
                             adl03 = g_rvm.rvm01,
                             adl04 = l_rvn.rvn02,
                             adl20 = l_adl.adl20,
                             adl05 = l_rvn.rvn10,  
                             adl07 = NULL,        
                             adl08 = NULL,
                             adl09 = NULL,
                             adl10 = NULL,
                             adlplant = g_rvm.rvmplant,                      
                             adllegal = g_rvm.rvmlegal    
          WHERE adl01 = l_adk.adk01 AND adl02 = g_cnt
          LET g_cnt = g_cnt + 1
     END FOREACH
     INSERT INTO adl_file SELECT * FROM adl_temp WHERE adl01 = l_adk.adk01
     IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('adl01',l_adk.adk01,'INSERT INTO adl_file:',SQLCA.sqlcode,1)
     ELSE
        INSERT INTO adk_file SELECT * FROM adk_temp WHERE adk01 = l_adk.adk01
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('adk01',l_adk.adk01,'INSERT INTO adk_file:',SQLCA.sqlcode,1)
        END IF
     END IF
     CALL cl_progressing(g_msg)
     END FOREACH
     IF g_success = 'N' THEN
        LET g_totsuccess = 'N'
        LET g_success = 'Y'
     END IF   
END FUNCTION
 
FUNCTION t252_v() #作廢
DEFINE l_rvmconu_desc LIKE gen_file.gen02
 
   IF cl_null(g_rvm.rvm01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t252_cl USING g_rvm.rvm01
   IF STATUS THEN
      CALL cl_err("OPEN t252_cl:", STATUS, 1)
      CLOSE t252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t252_cl INTO g_rvm.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t252_cl
      ROLLBACK WORK
      RETURN
   END IF
     
   IF g_rvm.rvmacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF   
   IF g_rvm.rvmconf ='X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   IF g_rvm.rvmconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
   IF NOT cl_confirm('lib-016') THEN 
        RETURN
   END IF
            UPDATE rvm_file SET rvmconf = 'X',
                                rvmconu = g_user,
                                rvmcond = g_today,
                                rvmmodu = g_user,
                                rvmdate = g_today,
                                rvm900 = '9'
               WHERE rvm01 = g_rvm.rvm01 AND rvmplant = g_rvm.rvmplant
            IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rvm_file",g_rvm.rvm01,"",STATUS,"","",1) 
              LET g_success = 'N'
            ELSE
              IF SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","rvm_file",g_rvm.rvm01,"","9050","","",1) 
                 LET g_success = 'N'
              END IF
            END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rvm.rvmconf = 'X'
      LET g_rvm.rvmconu = g_user
      LET g_rvm.rvmcond = g_today
      LET g_rvm.rvmmodu = g_user
      LET g_rvm.rvmdate = g_today
      DISPLAY BY NAME g_rvm.rvmconf,g_rvm.rvmconu,g_rvm.rvmcond,
                      g_rvm.rvmuser,g_rvm.rvmdate
      SELECT gen02 INTO l_rvmconu_desc
        FROM gen_file
       WHERE gen01 = g_rvm.rvmconu
         AND genacti = 'Y'
      DISPLAY l_rvmconu_desc TO rvmconu_desc
      CALL cl_set_field_pic("","","","",g_rvm.rvmconf,"")
   ELSE
      ROLLBACK WORK
   END IF
   
END FUNCTION           
 
FUNCTION t252_update() #更新需求匯總表
DEFINE l_rvn RECORD LIKE rvn_file.*
DEFINE l_ruc22 LIKE ruc_file.ruc22
DEFINE l_ruc20 LIKE ruc_file.ruc20
DEFINE l_ruc18 LIKE ruc_file.ruc18
DEFINE l_sql   STRING
    
    LET g_start = CURRENT MINUTE TO FRACTION(5)
    LET l_sql="SELECT rvn03,rvn04,rvn05,rvn06,rvn09,rvn10",
              "  FROM rvn_file",
              " WHERE rvn01 = '",g_rvm.rvm01,
              "'  AND rvnplant = '",g_rvm.rvmplant,"'"
    DECLARE rvn_sel4 CURSOR FROM l_sql
    FOREACH rvn_sel4 INTO l_rvn.rvn03,l_rvn.rvn04,l_rvn.rvn05,
                          l_rvn.rvn06,l_rvn.rvn09,l_rvn.rvn10
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rvn_sel4:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT ruc18,ruc20 INTO l_ruc18,l_ruc20
        FROM ruc_file
       WHERE ruc00 = '1'
         AND ruc01 = l_rvn.rvn06
         AND ruc02 = l_rvn.rvn03
         AND ruc03 = l_rvn.rvn04
         #AND rucplant = l_rvn.rvn06  #No.FUN-9C0069
      LET l_ruc22=''
      IF l_ruc18 = (l_rvn.rvn10+l_ruc20) THEN
            LET l_ruc22 = '6'
      END IF
      IF l_ruc18 < (l_rvn.rvn10+l_ruc20) THEN
            LET l_ruc22 = '7'
      END IF
      UPDATE ruc_file SET ruc20 = COALESCE(ruc20,0) + l_rvn.rvn10,
                          ruc22 = l_ruc22
       WHERE ruc00 = '1'
         AND ruc01 = l_rvn.rvn06
         AND ruc02 = l_rvn.rvn03
         AND ruc03 = l_rvn.rvn04
         AND ruc04 = l_rvn.rvn09
         #AND rucplant = l_rvn.rvn06  #No.FUN-9C0069
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL s_errmsg('','','UPDATE ruc_file:',SQLCA.sqlcode,1)
       END IF
     END FOREACH
     LET g_end = CURRENT MINUTE TO FRACTION(5)
     LET g_interval = g_end - g_start
     DISPLAY "UPDATE ruc_file used ",g_interval," seconds "
END FUNCTION
 
FUNCTION t252_create_plsql()
DEFINE l_sql STRING
    LET l_sql =  "create or replace procedure upd_ruc"
                  ||"(v_rvm01 in rvm_file.rvm01%type,v_rvmplant in rvm_file.rvmplant%type)"
                  ||" is "
                  ||" type tab_rvn03 is table of rvn_file.rvn03%type index by binary_integer; "
                  ||" type tab_rvn04 is table of rvn_file.rvn04%type index by binary_integer; "
                  ||" type tab_rvn06 is table of rvn_file.rvn06%type index by binary_integer; "
                  ||" type tab_rvn10 is table of rvn_file.rvn10%type index by binary_integer; "
                  ||" type tab_ruc18 is table of ruc_file.ruc18%type index by binary_integer; "
                  ||" type tab_ruc20 is table of ruc_file.ruc20%type index by binary_integer; "
                  ||" type tab_ruc22 is table of ruc_file.ruc22%type index by binary_integer; "
                  ||" v_rvn03 tab_rvn03; "
                  ||" v_rvn04 tab_rvn04; "
                  ||" v_rvn06 tab_rvn06; "
                  ||" v_rvn10 tab_rvn10; "
                  ||" v_ruc20 tab_ruc20; "
                  ||" v_ruc22 tab_ruc22; "
                  ||" v_ruc18 tab_ruc18; "
                  ||" begin "
                  ||"  select rvn03,rvn04,rvn06,rvn10 bulk collect "
                  ||"    into v_rvn03,v_rvn04,v_rvn06,v_rvn10 "
                  ||"    from rvn_file "
                  ||"   where rvn01 = v_rvm01 "
                  ||"     and rvnplant = v_rvmplant; "
                  ||" for i in 1..v_rvn03.count loop "
                  ||"    select ruc18,ruc20 into v_ruc18(i),v_ruc20(i) "
                  ||"      from ruc_file "
                  ||"     where ruc00 = '1' "
                  ||"       and ruc01 = v_rvn06(i) "
                  ||"       and ruc02 = v_rvn03(i) "
                  ||"       and ruc03 = v_rvn04(i); "
                  #||"       and rucplant = v_rvn06(i); "#No.FUN-9C0069
                  ||"    if v_ruc18(i) = (v_rvn10(i)+v_ruc20(i)) then "
                  ||"       v_ruc22(i) := '6'; "
                  ||"    end if; "
                  ||"    if v_ruc18(i)< (v_rvn10(i)+v_ruc20(i)) then "
                  ||"       v_ruc22(i) := '7'; "
                  ||"    end if; "
                  ||"    v_ruc20(i):=(v_rvn10(i)+v_ruc20(i)); "
                  ||" end loop; "
                  ||" forall i in 1..v_rvn03.count "
                  ||" update ruc_file set (ruc20,ruc22) =(select v_ruc20(i),v_ruc22(i) from dual) "
                  ||"  where ruc00 = '1' "
                  ||"    and ruc01 = v_rvn06(i) "
                  ||"    and ruc02 = v_rvn03(i) "
                  ||"    and ruc03 = v_rvn04(i); "
                  #||"    and rucplant = v_rvn06(i); "  #No.FUN-9C0069
                  ||" end; "
     EXECUTE IMMEDIATE l_sql
 
END FUNCTION
 
#update ruc_file using pl/sql
FUNCTION t252_update_plsql()
DEFINE l_sql STRING
 
     LET g_start = CURRENT MINUTE TO FRACTION(5)
     PREPARE ruc_upd FROM "begin upd_ruc(?,?); end;"
     EXECUTE ruc_upd USING g_rvm.rvm01 IN,g_rvm.rvmplant IN
     LET g_end = CURRENT MINUTE TO FRACTION(5)
     LET g_interval = g_end - g_start
     DISPLAY "UPDATE ruc_file using PL/SQL used ",g_interval," seconds "
END FUNCTION
 
#撥入異動庫存copy and modify from artt256
FUNCTION t252_s2(l_rup)
DEFINE l_rup RECORD LIKE rup_file.*
DEFINE l_qty     LIKE rup_file.rup16
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE p_dbs     LIKE type_file.chr21
DEFINE l_n       LIKE type_file.num5
DEFINE l_img RECORD LIKE img_file.*
 
       CALL t252_azp(l_rup.rupplant) RETURNING l_dbs
       IF NOT cl_null(g_errno) THEN
          LET g_success = 'N'
          CALL s_errmsg('rupplant',l_rup.rupplant,'',g_errno,1)
       END IF
       #LET g_sql = " SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
       LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                   "  WHERE img01= ? ",
                   "    AND img02= ? ",
                   "    AND img03= ' ' ",
                   "    AND img04= ' ' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, l_rup.rupplant) RETURNING g_sql  #FUN-A50102            
       PREPARE s2_img_cs FROM g_sql
       EXECUTE s2_img_cs INTO l_n USING l_rup.rup03,l_rup.rup13
       IF l_n = 0 THEN
          CALL s_madd_img(l_rup.rup03,l_rup.rup13,'','',l_rup.rup01,
                          l_rup.rup02,g_today,l_rup.rupplant)
       END IF
          #LET g_sql = " SELECT * FROM ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
          LET g_sql = " SELECT * FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                      "  WHERE img01= ? ",
                      "    AND img02= ? ",
                      "    AND img03= ' ' ",
                      "    AND img04= ' ' ",
                      " FOR UPDATE "
          LET g_sql=cl_forupd_sql(g_sql)

          DECLARE img_lock_bu1 CURSOR FROM g_sql
          OPEN img_lock_bu1 USING l_rup.rup03,l_rup.rup13
          IF STATUS THEN
             LET g_success = 'N'
             CALL s_errmsg('','',"OPEN img_lock_bu1:", STATUS, 1)
             CLOSE img_lock_bu1
          END IF
          FETCH img_lock_bu1 INTO l_img.*
          IF STATUS THEN
             LET g_success = 'N'
             CALL s_errmsg('','','img_lock_bu fail',STATUS,1)
          END IF
          LET l_qty = l_rup.rup16*l_rup.rup08
          CALL s_mupimg(+1,l_rup.rup03,l_rup.rup13,'','',l_qty,g_today,l_rup.rupplant,'',l_rup.rup01,l_rup.rup02)
       IF g_success = 'Y' THEN
          CALL t252_in_log(l_rup.*,l_dbs)
          
       END IF
END FUNCTION
 
FUNCTION t252_in_log(l_rup,l_dbs) 
DEFINE l_rup       RECORD LIKE rup_file.*
DEFINE l_dbs       LIKE azp_file.azp03
DEFINE l_img09     LIKE img_file.img09,                                                                        
       l_img10     LIKE img_file.img10,                                                                        
       l_img26     LIKE img_file.img26
            
    LET g_sql = "SELECT img09,img10,img26 ",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
                "  FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                " WHERE img01 = '",l_rup.rup03,
                "'  AND img02 = '",l_rup.rup13,
                "'  AND img03 = ' ' AND img04 = ' '"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, l_rup.rupplant) RETURNING g_sql  #FUN-A50102            
    PREPARE img_sel2 FROM g_sql
    EXECUTE img_sel2 INTO l_img09,l_img10,l_img26
    IF SQLCA.sqlcode THEN
       CALL s_errmsg("rup03",l_rup.rup03,"sel img_file",SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
    INITIALIZE g_tlf.* TO NULL
    LET g_tlf.tlf01 = l_rup.rup03
    LET g_tlf.tlf020 = g_plant
    LET g_tlf.tlf02 = 57
    LET g_tlf.tlf021 = l_rup.rup09
    LET g_tlf.tlf022 = l_rup.rup10
    LET g_tlf.tlf023 = l_rup.rup11
    LET g_tlf.tlf024 = l_img10
    LET g_tlf.tlf025 = l_rup.rup04
    LET g_tlf.tlf026 = l_rup.rup01
    LET g_tlf.tlf027 = l_rup.rup02
    LET g_tlf.tlf03 = 50
    LET g_tlf.tlf031 = l_rup.rup13
    LET g_tlf.tlf032 = l_rup.rup14
    LET g_tlf.tlf033 = l_rup.rup15
    LET g_tlf.tlf035 = l_rup.rup04
    LET g_tlf.tlf036 = l_rup.rup01 
    LET g_tlf.tlf037 = l_rup.rup02
    LET g_tlf.tlf04 = ' '                                                                                   
    LET g_tlf.tlf05 = ' '
    LET g_tlf.tlf06 = g_today
    LET g_tlf.tlf07=g_today
    LET g_tlf.tlf08=TIME
    LET g_tlf.tlf09=g_user
    LET g_tlf.tlf10=l_rup.rup16
    LET g_tlf.tlf11=l_rup.rup04
    LET g_tlf.tlf12=l_rup.rup08
    LET g_tlf.tlf13='artt256'
    LET g_tlf.tlf15=l_img26
    LET g_tlf.tlf60=l_rup.rup08
    LET g_tlf.tlfplant = l_rup.rupplant
    LET g_tlf.tlflegal = l_rup.ruplegal
    LET g_tlf.tlf902 = l_rup.rup13
    LET g_tlf.tlf903 = ' '
    LET g_tlf.tlf904 = ' '
    LET g_tlf.tlf905 = l_rup.rup01
    LET g_tlf.tlf906 = l_rup.rup02
    LET g_tlf.tlf907 = 1
    CALL s_tlf2(1,0,l_rup.rupplant)
END FUNCTION
 
#撥出異動庫存
FUNCTION t252_s1(l_rup)
DEFINE   l_rup     RECORD LIKE rup_file.*
DEFINE   l_qty     LIKE rup_file.rup12
DEFINE   l_dbs     LIKE azp_file.azp03
DEFINE   p_dbs     LIKE type_file.chr21
DEFINE   l_n       LIKE type_file.num5
DEFINE   l_img RECORD LIKE img_file.*
 
    CALL t252_azp(l_rup.rupplant) RETURNING l_dbs
    IF NOT cl_null(g_errno) THEN
       LET g_success = 'N'
       CALL s_errmsg('rupplant',l_rup.rupplant,'',g_errno,1)
    END IF
    #LET g_sql = " SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
    LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                  "  WHERE img01= ? ",
                  "    AND img02= ? ",
                  "    AND img03= ' ' ",
                  "    AND img04= ' ' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, l_rup.rupplant) RETURNING g_sql  #FUN-A50102                
    PREPARE s1_img_cs FROM g_sql
    EXECUTE s1_img_cs INTO l_n USING l_rup.rup03,l_rup.rup09
    IF l_n = 0 THEN
        CALL s_madd_img(l_rup.rup03,l_rup.rup09,' ',' ',l_rup.rup01,
                          l_rup.rup02,g_today,l_rup.rupplant)
    END IF
        #LET g_sql = " SELECT * FROM ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
        LET g_sql = " SELECT * FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                    "  WHERE img01= ? ",
                    "    AND img02= ? ",
                    "    AND img03= ' ' ",
                    "    AND img04= ' ' ",
                    " FOR UPDATE "
         LET g_sql=cl_forupd_sql(g_sql)

        DECLARE img_lock_bu CURSOR FROM g_sql
        OPEN img_lock_bu USING l_rup.rup03,l_rup.rup09
        IF STATUS THEN
           LET g_success = 'N'
           CALL s_errmsg('img01',l_rup.rup03,"SELECT img_file:",'art-502', 1)
           CLOSE img_lock_bu
        END IF
        FETCH img_lock_bu INTO l_img.*
        IF STATUS THEN
           LET g_success = 'N'
           CALL s_errmsg('','','img_lock_bu fail',STATUS,1)
        END IF
        LET l_qty = l_rup.rup12*l_rup.rup08
        CALL s_mupimg(-1,l_rup.rup03,l_rup.rup09,'','',l_qty,g_today,l_rup.rupplant,'',l_rup.rup01,l_rup.rup02)
      IF g_success = 'Y' THEN
#--------產生異動記錄 
         CALL t252_out_log(l_rup.*,l_dbs)
      END IF
END FUNCTION
 
FUNCTION t252_out_log(l_rup,l_dbs)
DEFINE l_rup       RECORD LIKE rup_file.*
DEFINE l_dbs       LIKE azp_file.azp03
DEFINE l_img09     LIKE img_file.img09,       #庫存單位                                                                           
       l_img10     LIKE img_file.img10,       #庫存數量                                                                           
       l_img26     LIKE img_file.img26
 
    LET g_sql = "SELECT img09,img10,img26",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                "  FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                " WHERE img01 = '",l_rup.rup03,
                "'  AND img02 = '",l_rup.rup09,
                "'  AND img03 = ' ' AND img04 = ' '"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, l_rup.rupplant) RETURNING g_sql  #FUN-A50102            
    PREPARE img_sel1 FROM g_sql
    EXECUTE img_sel1 INTO l_img09,l_img10,l_img26
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('rup03',l_rup.rup03,"sel img_file",SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
    INITIALIZE g_tlf.* TO NULL
 
    LET g_tlf.tlf01 = l_rup.rup03      #異動料件編號
    LET g_tlf.tlf020 = g_plant         #機構別
    LET g_tlf.tlf02 = 50               #來源狀況
    LET g_tlf.tlf021 = l_rup.rup09     #倉庫(來源）
    LET g_tlf.tlf022 = l_rup.rup10     #儲位(來源）
    LET g_tlf.tlf023 = l_rup.rup11     #批號(來源）
    LET g_tlf.tlf024 = l_img10         #異動後庫存數量
    LET g_tlf.tlf025 = l_rup.rup04     #庫存單位
    LET g_tlf.tlf026 = l_rup.rup01     #單據號碼
    LET g_tlf.tlf027 = l_rup.rup02     #單據項次
    LET g_tlf.tlf03 = 66               #資料目的
    LET g_tlf.tlf031 = l_rup.rup13     #倉庫(目的)
    LET g_tlf.tlf032 = l_rup.rup14     #儲位(目的)
    LET g_tlf.tlf033 = l_rup.rup15     #批號(目的)
    LET g_tlf.tlf035 = l_rup.rup04     #庫存單位
    LET g_tlf.tlf036 = l_rup.rup01     #參考號碼
    LET g_tlf.tlf037 = l_rup.rup02     #單據項次
    LET g_tlf.tlf04 = ' '                #工作站                                                                                    
    LET g_tlf.tlf05 = ' '                #作業序號
    LET g_tlf.tlf06 = g_today            #日期
    LET g_tlf.tlf07=g_today              #異動資料產生日期
    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user               #產生人
    LET g_tlf.tlf10=l_rup.rup12          #收料數量
    LET g_tlf.tlf11=l_rup.rup04          #收料單位 
    LET g_tlf.tlf12=l_rup.rup08          #收料/庫存轉換率
    LET g_tlf.tlf13='artt256'            #異動命令代號
    LET g_tlf.tlf15=l_img26              #倉儲會計科目
    LET g_tlf.tlf60=l_rup.rup08          #異動單據單位對庫存單位之換算率
    LET g_tlf.tlfplant = l_rup.rupplant
    LET g_tlf.tlflegal = l_rup.ruplegal
    LET g_tlf.tlf902 = l_rup.rup09
    LET g_tlf.tlf903 = ' '
    LET g_tlf.tlf904 = ' '
    LET g_tlf.tlf905 = l_rup.rup01
    LET g_tlf.tlf906 = l_rup.rup02
    LET g_tlf.tlf907 = -1
    CALL s_tlf2(1,0,l_rup.rupplant)
END FUNCTION
 
FUNCTION t252_azp(l_azp01)
   DEFINE l_azp01  LIKE azp_file.azp01,
          l_azp03  LIKE azp_file.azp03
 
    LET g_errno=' '
    #No.FUN-960130 ..begin
    #SELECT azp03 INTO l_azp03 FROM azp_file 
    # WHERE azp01=l_azp01
    LET g_plant_new = l_azp01
    CALL s_gettrandbs()
    LET l_azp03=g_dbs_tra
    #No.FUN-960130 ..end
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_azp03 CLIPPED
END FUNCTION
 
#FUNCTION t252_def_no(l_dbs,l_rye01,l_rye02) #FUN-A50102
FUNCTION t252_def_no(l_plant,l_rye01,l_rye02) #FUN-A50102
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_rye01 LIKE rye_file.rye01
DEFINE l_rye02 LIKE rye_file.rye02
DEFINE l_sql STRING
DEFINE l_no LIKE rva_file.rva01
DEFINE l_plant LIKE pmm_file.pmmplant  #FUN-A50102
 
   #LET l_sql = "SELECT rye03 FROM ",s_dbstring(l_dbs CLIPPED),"rye_file",     #FUN-A50102
   #FUN-C90050 mark begin---
   #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(l_plant, 'rye_file'),  #FUN-A50102
   #            " WHERE rye01 = ? AND rye02 = ? AND ryeacti='Y'"  
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
   #CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql    #FUN-A50102            
   #PREPARE rye_trans FROM l_sql
   #EXECUTE rye_trans USING l_rye01,l_rye02 INTO l_no
   #FUN-C90050 mark endiiiii

   CALL s_get_defslip(l_rye01,l_rye02,l_plant,'N') RETURNING l_no    #FUN-C90050 add

   IF cl_null(l_no) THEN
      CALL s_errmsg('rye03',l_no,'rye_file','art-330',1)
      LET g_success = 'N'
      RETURN ''
   END IF
   RETURN l_no
END FUNCTION
 
#生成流程序號
#FUNCTION t252_flowauno(p_flow,p_date,p_dbs) #FUN-A50102
FUNCTION t252_flowauno(p_flow,p_date,l_plant) #FUN-A50102
   DEFINE p_date          LIKE type_file.dat, #單據日期
          p_flow          LIKE type_file.chr8,#流程代碼
          p_dbs           LIKE type_file.chr21,            
          l_i             LIKE type_file.num5,          
          l_sql           LIKE type_file.chr1000,       
          g_flowauno_mxno LIKE pmm_file.pmm99,
          g_forupd_sql    STRING,  
          l_slip99        LIKE bnb_file.bnb06,  #多角序號 
          l_buf           LIKE type_file.chr1000,  
          l_date          LIKE aab_file.aab02,            
          g_message       STRING
DEFINE g_poz RECORD LIKE poz_file.*
DEFINE   l_plant LIKE poy_file.poy04 #FUN-A50102
 
   CALL cl_getmsg('mfg8889',g_lang) RETURNING g_message
   MESSAGE g_message

   LET g_forupd_sql = "SELECT * FROM poz_file WHERE poz01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE pozauno_cl CURSOR FROM g_forupd_sql
   OPEN pozauno_cl USING p_flow     
   IF SQLCA.sqlcode = "-243" THEN
      CALL s_errmsg('poz01',p_flow,'poz01:read poz:',SQLCA.sqlcode,1)
      CLOSE pozauno_cl 
      RETURN FALSE,''
   END IF
   FETCH pozauno_cl INTO g_poz.*      
   IF SQLCA.sqlcode = "-243" THEN
      CALL s_errmsg('poz01',p_flow,'poz01:read poz:',SQLCA.sqlcode,1)
      CLOSE pozauno_cl 
      RETURN FALSE,''
   END IF
   IF g_poz.poz11 = '1' THEN    #依流水
      LET l_sql = " SELECT COALESCE(MAX(pmm99),'",p_flow CLIPPED,"-00000000')",
                  #"   FROM ",s_dbstring(p_dbs CLIPPED),"pmm_file ", #FUN-A50102
                  "   FROM ",cl_get_target_table(l_plant, 'pmm_file'), #FUN-A50102
                 #"  WHERE substr(pmm99,1,8) = '",p_flow,"'"   #FUN-9B0051
                  "  WHERE pmm99[1,8] = '",p_flow,"'"   #FUN-9B0051
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102            
      PREPARE pmm99_pre1 FROM l_sql
      EXECUTE pmm99_pre1 INTO g_flowauno_mxno
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pmm904',p_flow,'max(pmm99)',SQLCA.sqlcode,1)
         CLOSE pozauno_cl 
         RETURN FALSE,''
      END IF
      LET l_slip99 = g_flowauno_mxno[1,9],(g_flowauno_mxno[10,17]+1) USING '&&&&&&&&'
   ELSE                         #依年度期別
      LET l_date = YEAR(p_date) USING '&&&&',MONTH(p_date) USING '&&'
      LET l_buf = p_flow,'-',l_date[3,6]
      LET l_sql = " SELECT COALESCE(MAX(pmm99),'",l_buf CLIPPED,"0000')",
                  #"   FROM ",s_dbstring(p_dbs CLIPPED),"pmm_file ", #FUN-A50102
                  "   FROM ",cl_get_target_table(l_plant, 'pmm_file'), #FUN-A50102
                 #"  WHERE substr(pmm99,1,13) = '",l_buf,"'"  #FUN-9B0051
                  "  WHERE pmm99[1,13] = '",l_buf,"'"  #FUN-9B0051
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102
      PREPARE pmm99_pre2 FROM l_sql
      EXECUTE pmm99_pre2 INTO g_flowauno_mxno
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pmm904',p_flow,'max(pmm99)',SQLCA.sqlcode,1)
         CLOSE pozauno_cl 
         RETURN FALSE,''
      END IF
      LET l_slip99 = g_flowauno_mxno[1,13],(g_flowauno_mxno[14,17]+1) USING '&&&&'
   END IF   
   CLOSE pozauno_cl 
   RETURN TRUE,l_slip99
END FUNCTION
 
FUNCTION t252_fetch_price(p_no,p_org,p_type,p_num)
DEFINE p_no    LIKE poz_file.poz01
DEFINE p_org   LIKE tsk_file.tskplant
DEFINE p_type  LIKE type_file.chr1
DEFINE l_cust  LIKE tsk_file.tskplant
DEFINE p_num   LIKE type_file.num5
DEFINE l_success LIKE type_file.chr1
DEFINE l_price LIKE tqn_file.tqn05
DEFINE l_pox03 LIKE pox_file.pox03
DEFINE l_pox05 LIKE pox_file.pox05
DEFINE l_pox06 LIKE pox_file.pox06
DEFINE l_sql   STRING
DEFINE l_pmc930 LIKE pmc_file.pmc930
DEFINE l_poy03 LIKE poy_file.poy03
DEFINE l_plant LIKE pmc_file.pmc930
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_max   LIKE poy_file.poy02
DEFINE l_min   LIKE poy_file.poy02
DEFINE l_cnt   LIKE type_file.num5
 
       CALL s_pox(p_no,p_num,g_today) RETURNING l_pox03,l_pox05,l_pox06,l_cnt
       IF l_cnt = 0 THEN
          LET g_success = 'N'
          LET l_price = 0
          CALL s_errmsg('pox01',p_no,'','art-484',1) 
       END IF
       SELECT MIN(poy02),MAX(poy02) 
         INTO l_min,l_max FROM poy_file
        WHERE poy01 = p_no 
          CASE l_pox03
            WHEN '1' SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = l_min
            WHEN '2' IF p_num = l_min THEN
                        SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = l_min
                     ELSE
                       SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = (p_num-1) 
                     END IF
                     
            WHEN '3' SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = l_max
            WHEN '4' IF p_num = l_max THEN
                        SELECT poy04 INTO l_cust
                          FROM poy_file
                         WHERE poy01 = l_no
                          AND poy02 = l_max
                     ELSE
                        SELECT poy04 INTO l_cust
                          FROM poy_file
                         WHERE poy01 = l_no
                           AND poy02 = (p_num + 1)
                     END IF
          END CASE
       IF p_type='0' THEN
          IF p_num = l_max THEN
             SELECT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
             AND poy02 = l_max
          ELSE
             SELECT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
                AND poy02 = p_num + 1 
          END IF
       ELSE
          IF p_num = l_min THEN
             SELECT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
             AND poy02 = l_min
          ELSE
             SELECT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
                AND poy02 = p_num -1
          END IF
       END IF
       #No.FUN-960130 ..begin
       #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_poy03
       LET g_plant_new = l_poy03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       #No.FUN-960130 ..end
       IF cl_null(l_dbs) THEN
          LET g_success = 'N'
          CALL s_errmsg('azp01',l_poy03,'','art-002',1)
       END IF
       #LET l_sql = "SELECT pmc930 FROM ",s_dbstring(l_dbs CLIPPED),"pmc_file", #FUN-A50102
       LET l_sql = "SELECT pmc930 FROM ",cl_get_target_table(l_poy03, 'pmc_file'), #FUN-A50102
                   " WHERE pmc01 = ? AND pmcacti = 'Y' AND pmc05 = '1'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
       CALL cl_parse_qry_sql(l_sql, l_poy03) RETURNING l_sql    #FUN-A50102            
       PREPARE pmc_sel FROM l_sql
       EXECUTE pmc_sel USING l_poy03 INTO l_plant
       IF cl_null(l_plant) THEN
          LET g_success = 'N'
          CALL s_errmsg('pmc930',l_poy03,'','art-479',1)
       END IF
       
       #No.FUN-960130 ..begin
       #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_cust
       LET g_plant_new = l_cust
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       #No.FUN-960130 ..end
       IF cl_null(l_dbs) THEN
          LET g_success = 'N'
          CALL s_errmsg('azp01',l_cust,'','art-002',1)
       END IF
       #LET l_sql = "SELECT pmc930 FROM ",s_dbstring(l_dbs CLIPPED),"pmc_file", #FUN-A50102
       LET l_sql = "SELECT pmc930 FROM ",cl_get_target_table(l_cust, 'pmc_file'), #FUN-A50102
                   " WHERE pmc01 = ? AND pmcacti = 'Y' AND pmc05 = '1'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
       CALL cl_parse_qry_sql(l_sql, l_cust) RETURNING l_sql     #FUN-A50102            
       PREPARE pmc_sel1 FROM l_sql
       EXECUTE pmc_sel1 USING l_cust INTO l_pmc930
       IF cl_null(l_pmc930) THEN
          LET g_success = 'N'
          CALL s_errmsg('pmc930',l_cust,'','art-479',1)
       END IF
       IF p_type='0' THEN
          UPDATE price_temp SET plant1 = l_plant,
                                plant2 = p_org,
                                plant3 = l_pmc930
       ELSE
          UPDATE price_temp SET plant1 = p_org,
                                plant2 = l_plant,
                                plant3 = l_pmc930
       END IF
       CALL t252_trade_price()  
END FUNCTION
 
FUNCTION t252_trade_price()
DEFINE l_sql STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_rtz05 LIKE rtz_file.rtz05
DEFINE l_n LIKE type_file.num5
 
    LET l_sql = "UPDATE price_temp a ",
                "   SET ima131 = (SELECT ima131 FROM ima_file",
                "                  WHERE ima01 = a.item",
                "                    AND imaacti = 'Y')"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET (rtl04,rtl05,rtl06) = (SELECT rtl04,rtl05,rtl06",
                "                                FROM rtl_file",
                "                               WHERE rtl01 = a.plant1",
                "                                 AND rtl03 = a.plant2",
                "                                 AND rtl07 = a.ima131",
                "                                 AND rtlacti = 'Y')",
                " WHERE rtl04 IS NULL",
                "   AND rtl06 IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET (rtl04,rtl05,rtl06) = (SELECT rtl04,rtl05,rtl06",
                "                                FROM rtl_file",
                "                               WHERE rtl01 = a.plant1",
                "                                 AND rtl03 = '*'",
                "                                 AND rtl07 = a.ima131",
                "                                 AND rtlacti = 'Y')",
                " WHERE rtl04 IS NULL",
                "   AND rtl06 IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET (rtl04,rtl05,rtl06) = (SELECT rtl04,rtl05,rtl06",
                "                                FROM rtl_file",
                "                               WHERE rtl01 = a.plant1",
                "                                 AND rtl03 = a.plant2",
                "                                 AND rtl07 = '*'",
                "                                 AND rtlacti = 'Y')",
                " WHERE rtl04 IS NULL",
                "   AND rtl06 IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET (rtl04,rtl05,rtl06) = (SELECT rtl04,rtl05,rtl06",
                "                                FROM rtl_file",
                "                               WHERE rtl01 = a.plant1",
                "                                 AND rtl03 = '*'",
                "                                 AND rtl07 = '*'",
                "                                 AND rtlacti = 'Y')",
                " WHERE rtl04 IS NULL",
                "   AND rtl06 IS NULL"
    EXECUTE IMMEDIATE l_sql
    INSERT INTO err_temp SELECT 'rtl01',plant1,'arti150','sub-207',1
                           FROM price_temp
                          WHERE rtl04 IS NULL
                             OR rtl06 IS NULL
    #No.FUN-9C0069 ..begin
    #SELECT DISTINCT azp03 INTO l_dbs 
    #  FROM price_temp,azp_file
    # WHERE azp01 = plant3
    SELECT DISTINCT plant3 
      INTO g_plant_new FROM price_temp
    CALL s_gettrandbs()
    LET l_dbs=g_dbs_tra
    #No.FUN-9C0069 ..end
    IF cl_null(l_dbs) THEN
       INSERT INTO err_temp VALUES('azp01',(SELECT DISTINCT plant3 FROM price_temp),'azp_file','art-330',1)
    END IF
    #LET l_sql = "SELECT DISTINCT rtz05 FROM ",s_dbstring(l_dbs),"rtz_file", #FUN-A50102
    LET l_sql = "SELECT DISTINCT rtz05 FROM ",cl_get_target_table(g_plant_new, 'rtz_file'), #FUN-A50102
               " WHERE rtz01=(SELECT DISTINCT plant3 FROM price_temp)"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql     #FUN-A50102           
    PREPARE rtz05_sel FROM l_sql
    EXECUTE rtz05_sel INTO l_rtz05
    LET l_sql = "UPDATE price_temp ",
                "   SET rtg08 = (SELECT rtg08 FROM rtg_file",
                "                 WHERE rtg01 = '",l_rtz05,"'",
                "                   AND rtg03 = item",
                "                   AND rtg04 = unit",
                "                   AND rtg09 = 'Y')"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp ",
                "   SET price = (SELECT rth04 FROM rth_file",
                "                 WHERE rthacti = 'Y'",
                "                   AND rth02 = unit",
                "                   AND rthplant = plant3",
                "                   AND rth01 = item)",
                " WHERE rtl04 = '2'",
                "   AND rtg08 = 'Y'",
                "   AND price IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp ",
                "   SET price = (SELECT rtg05 FROM rtg_file",
                "                 WHERE rtg01 = '",l_rtz05,"'",
                "                   AND rtg03 = item",
                "                   AND rtg04 = unit",
                "                   AND rtg09 = 'Y')",
                " WHERE rtl04 = '2'",
                "   AND price IS NULL"
    EXECUTE IMMEDIATE l_sql 
    LET l_sql = "INSERT INTO err_temp ",
                "SELECT 'rtl05',rtl05,'','art-331',1 FROM price_temp a",
                #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"tqm_file,", #FUN-A50102
                #                                   s_dbstring(l_dbs CLIPPED),"tqn_file",   #FUN-A50102
                " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(g_plant_new, 'tqm_file'),",", #FUN-A50102
                                                    cl_get_target_table(g_plant_new, 'tqn_file'),   #FUN-A50102
                "                    WHERE tqm01 = tqn01",
                "                      AND tqn01 = a.rtl05 ",
                "                      AND tqn03 = a.item ",
                "                      AND tqm04 = '1'",
                "                      AND tqm06 = '4'",
                "                      AND tqn06 <= '",g_today,"' ",
                "                      AND (tqn07 IS NULL OR tqn07 >='",g_today,"'))",
                "   AND rtl04 = '3'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "DELETE FROM price_temp a",
                #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"tqm_file,", #FUN-A50102
                #                                    s_dbstring(l_dbs CLIPPED),"tqn_file",   #FUN-A50102
                " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(g_plant_new, 'tqm_file'),",", #FUN-A50102
                                                    cl_get_target_table(g_plant_new, 'tqn_file'),   #FUN-A50102
                "                    WHERE tqm01 = tqn01",
                "                      AND tqn01 = a.rtl05 ",
                "                      AND tqn03 = a.item ",
                "                      AND tqm04 = '1'",
                "                      AND tqm06 = '4'",
                "                      AND tqn06 <= '",g_today,"' ",
                "                      AND (tqn07 IS NULL OR tqn07 >='",g_today,"'))",
                "   AND rtl04 = '3'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT tqn05 ",
                #"                  FROM ",s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                "                  FROM ",cl_get_target_table(g_plant_new, 'tqn_file'), #FUN-A50102
                "                 WHERE tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item ",
                "                   AND tqn04 = a.unit) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"               
    EXECUTE IMMEDIATE l_sql
    #CALL t252_umfchk(l_dbs) #FUN-A50102
    CALL t252_umfchk(g_plant_new) #FUN-A50102
    UPDATE price_temp SET price = price*rtl06/100
     WHERE rtl04='2'
    SELECT COUNT(*) INTO l_n FROM price_temp WHERE price IS NULL
    IF l_n>0 THEN
       LET g_success='N'
       INSERT INTO err_temp SELECT 'rth01,rth02,rthplant',item||'|'||unit||'|'||plant3,'','art-340',1
                              FROM price_temp
                             WHERE rtl04 = '2'
                               AND price IS NULL
       INSERT INTO err_temp SELECT 'tqm01,tqn03,tqn04',rtl05||'|'||item||'|'||unit,'atmi227','art-340',1
                              FROM price_temp
                             WHERE rtl04 = '3'
                               AND price IS NULL
    END IF
END FUNCTION
 
#FUNCTION t252_umfchk(l_dbs) #FUN-A50102
FUNCTION t252_umfchk(l_plant) #FUN-A50102
DEFINE l_sql STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_plant LIKE pmm_file.pmmplant #FUN-A50102
 
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*rth04) FROM smd_file,rth_file ",
                "                 WHERE smd01 = a.item",
                "                   AND smd02 = a.unit",
                "                   AND smd03 = rth02",
                "                   AND smd01 = rth01)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'",
                "   AND rtg08 = 'Y'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*rth04) FROM smd_file,rth_file ",
                "                 WHERE smd01 = a.item",
                "                   AND smd03 = a.unit",
                "                   AND smd02 = rth02",
                "                   AND smd01 = rth01)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'",
                "   AND rtg08 = 'Y'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*rtg05) FROM smd_file,rtg_file ",
                "                 WHERE smd01 = a.item",
                "                   AND smd02 = a.unit",
                "                   AND smd03 = rtg04",
                "                   AND smd01 = rtg03)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*rtg05) FROM smd_file,rtg_file ",
                "                 WHERE smd01 = a.item",
                "                   AND smd03 = a.unit",
                "                   AND smd02 = rtg04",
                "                   AND smd01 = rtg03)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*rth04) FROM smc_file,rth_file",
                "                 WHERE smc01 = a.unit",
                "                   AND smc02 = rth02",
                "                   AND smcacti = 'Y'",
                "                   AND rth01 = a.item)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'",
                "   AND rtg08 = 'Y'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*rth04) FROM smc_file,rth_file",
                "                 WHERE smc02 = a.unit",
                "                   AND smc01 = rth02",
                "                   AND smcacti = 'Y'",
                "                   AND rth01 = a.item)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'",
                "   AND rtg08 = 'Y'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*rtg05) FROM smc_file,rtg_file",
                "                 WHERE smc01 = a.unit",
                "                   AND smc02 = rtg04",
                "                   AND smcacti = 'Y'",
                "                   AND rtg03 = a.item)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*rtg05) FROM smc_file,rtg_file",
                "                 WHERE smc02 = a.unit",
                "                   AND smc01 = rtg04",
                "                   AND smcacti = 'Y'",
                "                   AND rtg03 = a.item)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*tqn05)",
                #"                  FROM smd_file,",s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                "                  FROM smd_file,",cl_get_target_table(l_plant, 'tqn_file'), #FUN-A50102
                "                 WHERE smd01 = tqn03",
                "                   AND smd02 = a.unit",
                "                   AND smd03 = tqn04",
                "                   AND tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"               
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*tqn05)",
                #"                  FROM smd_file,",s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                "                  FROM smd_file,",cl_get_target_table(l_plant, 'tqn_file'), #FUN-A50102
                "                 WHERE smd01 = tqn03",
                "                   AND smd03 = a.unit",
                "                   AND smd02 = tqn04",
                "                   AND tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"               
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*tqn05)",
                #"                  FROM smc_file,",s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                "                  FROM smc_file,",cl_get_target_table(l_plant, 'tqn_file'), #FUN-A50102
                "                 WHERE smc01 = a.unit",
                "                   AND smc02 = tqn04",
                "                   AND tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"               
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*tqn05)",
                #"                  FROM smc_file,",s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                "                  FROM smc_file,",cl_get_target_table(l_plant, 'tqn_file'), #FUN-A50102
                "                 WHERE smc02 = a.unit",
                "                   AND smc01 = tqn04",
                "                   AND tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"               
    EXECUTE IMMEDIATE l_sql
    INSERT INTO err_temp SELECT 'rvn09,ruc16',item||'|'||unit,'','mfg3075',1
                           FROM price_temp
                          WHERE price IS NULL
 
END FUNCTION

#FUN-BA0100 add begin-------------
FUNCTION t252_allocation()
DEFINE tm RECORD 
          type  LIKE type_file.chr1,
          rvn09 STRING, 
          rvn06 STRING
      END RECORD
DEFINE buf base.StringBuffer
DEFINE l_rvn06_s STRING
DEFINE l_rvn09   LIKE rvn_file.rvn09
DEFINE l_rvn09_s STRING
DEFINE l_ruc18_1 LIKE ruc_file.ruc18
DEFINE l_img10   LIKE img_file.img10
DEFINE l_rvn01   LIKE rvn_file.rvn01
DEFINE l_rvn02   LIKE rvn_file.rvn02
DEFINE l_rvn11   LIKE rvn_file.rvn11
DEFINE l_rvn12   LIKE rvn_file.rvn12

    IF cl_null(g_rvm.rvm01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    IF g_rvm.rvmacti ='N' THEN    
       CALL cl_err(g_rvm.rvm01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rvm.rvmconf <>'N' THEN
       CALL cl_err('',9022,0)
       RETURN
    END IF

    OPEN WINDOW t252_w2 WITH FORM "art/42f/artt252_w"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
    CALL cl_ui_locale("artt252_w")

    INPUT BY NAME tm.type,tm.rvn09,tm.rvn06
       BEFORE INPUT
          LET tm.type = '1'
          CALL cl_set_comp_entry("rvn06",(tm.type='3'))
          
       ON CHANGE type
          CALL cl_set_comp_entry("rvn06",(tm.type='3'))
          
       ON ACTION controlp                         
          CASE
            WHEN INFIELD(rvn09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvn09"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = "rvn01='",g_rvm.rvm01,"'"
                 CALL cl_create_qry() RETURNING tm.rvn09
                 DISPLAY tm.rvn09 TO rvn09
                 NEXT FIELD rvn09
              WHEN INFIELD(rvn06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvn06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING tm.rvn06
                 DISPLAY tm.rvn06 TO rvn06
                 NEXT FIELD rvn06
          END CASE           
    END INPUT 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW t252_w2
       RETURN
    END IF

    LET buf = base.StringBuffer.create()
    IF NOT cl_null(tm.rvn09) THEN 
       CALL buf.clear()
       CALL buf.append(tm.rvn09)
       CALL buf.replace("|", "\',\'", 0)
       CALL buf.insertAt(1, "(\'")
       CALL buf.append("\')")
       LET l_rvn09_s = buf.toString()
    END IF
    IF NOT cl_null(tm.rvn06) THEN 
       CALL buf.clear()
       CALL buf.append(tm.rvn06)
       CALL buf.replace("|", "\',\'", 0)
       CALL buf.insertAt(1, "(\'")
       CALL buf.append("\')")
       LET l_rvn06_s = buf.toString()
    END IF
    BEGIN WORK
    LET g_sta = "fen"
    LET g_success = "Y"
    #按需求分貨
    IF tm.type='1' THEN 
       LET g_sql = "UPDATE rvn_file a",
                   "   SET rvn10 = (SELECT COALESCE(ruc18,0)-COALESCE(ruc20,0)",
                   "                  FROM ruc_file ",
                   "                 WHERE ruc00 = '1' AND ruc01 = a.rvn06 ",
                   "                   AND ruc02 = a.rvn03 AND ruc03 = a.rvn04 )",
                   " WHERE rvn01 = '",g_rvm.rvm01,"'"
       IF NOT cl_null(tm.rvn09) THEN 
          LET g_sql = g_sql CLIPPED," AND rvn09 IN ",l_rvn09_s," "
       END IF
       IF NOT cl_null(g_wc1) THEN
         LET g_sql=g_sql CLIPPED," AND ",g_wc1 CLIPPED
       END IF
       EXECUTE IMMEDIATE g_sql
       IF SQLCA.sqlcode THEN 
          CALL cl_err('',SQLCA.sqlcode,0)
          LET g_success = "N"
       END IF
    END IF

    CALL s_showmsg_init()
    #指定門店和平均分貨
    IF tm.type='3' OR tm.type='2' THEN
       LET g_sql = "SELECT DISTINCT rvn09,rvn11,rvn12,SUM(ruc18)-SUM(ruc20)",
                   "  FROM ruc_file,rvn_file",
                   " WHERE rvn01='",g_rvm.rvm01 CLIPPED,"'",
                   "   AND ruc00 = '1' AND ruc01 = rvn06",
                   "   AND ruc02 = rvn03 AND ruc03 = rvn04"
       #有輸入產品編號時，則加上產品編號條件
       IF NOT cl_null(tm.rvn09) THEN 
          LET g_sql = g_sql CLIPPED," AND rvn09 IN ",l_rvn09_s," "
       END IF
       #指定門店且輸入門店時加上門店sql條件
       IF NOT cl_null(tm.rvn06) AND tm.type='3' THEN  
          LET g_sql = g_sql CLIPPED," AND rvn06 IN ",l_rvn06_s," "
       END IF
       IF NOT cl_null(g_wc1) THEN
          LET g_sql=g_sql CLIPPED," AND ",g_wc1 CLIPPED
       END IF
       LET g_sql=g_sql CLIPPED," GROUP BY rvn09,rvn11,rvn12"
       DECLARE rvn09_cs2 CURSOR FROM g_sql

       FOREACH rvn09_cs2 INTO l_rvn09,l_rvn11,l_rvn12,l_ruc18_1
          LET g_sql = "SELECT SUM(img10) ",
                      "  FROM ",cl_get_target_table(l_rvn12,'img_file'),
                      " WHERE img01 = '",l_rvn09,"'",
                      "   AND imgplant = '",l_rvn12,"' AND img02='",l_rvn11,"'"
          PREPARE sel_img10_pre FROM g_sql
          EXECUTE sel_img10_pre INTO l_img10
          IF SQLCA.sqlcode THEN 
             LET g_success = "N"
             CALL s_errmsg('rvn01_cs',g_rvm.rvm01,'SELECT SUM(img10):',SQLCA.sqlcode,1)
             CONTINUE FOREACH
          END IF
          #平均分貨時，進行分貨
          IF tm.type='2' THEN 
             IF l_img10 > 0 THEN
                CALL t252_allocation_arg(l_rvn09,l_rvn11,l_rvn12,l_img10,NULL,'N')
             ELSE
                LET g_msg = g_rvm.rvm01,"|",l_rvn09,"|",l_rvn11  
                CALL s_errmsg('rvm01|rvn09|rvn11',g_msg,'','art1020',1)
                CONTINUE FOREACH
             END IF 
          END IF 
          #指定門店分貨時，進行分貨
          IF tm.type='3' THEN 
             IF l_img10 >= l_ruc18_1 THEN
                LET g_sql = "UPDATE rvn_file a",
                            "   SET rvn10 = (SELECT COALESCE(ruc18,0)-COALESCE(ruc20,0)",
                            "                  FROM ruc_file ",
                            "                 WHERE ruc00 = '1' AND ruc01 = a.rvn06 ",
                            "                   AND ruc02 = a.rvn03 AND ruc03 = a.rvn04 )",
                            " WHERE rvn01 = '",g_rvm.rvm01,"' AND rvn09 = '",l_rvn09,"'",
                            "   AND rvn11 = '",l_rvn11,"' AND rvn12 = '",l_rvn12,"'"
                IF NOT cl_null(tm.rvn06) AND tm.type='3' THEN  
                   LET g_sql = g_sql CLIPPED," AND rvn06 IN ",l_rvn06_s," "
                END IF
                IF NOT cl_null(g_wc1) THEN
                   LET g_sql=g_sql CLIPPED," AND ",g_wc1 CLIPPED
                END IF
                EXECUTE IMMEDIATE g_sql
                IF SQLCA.sqlcode THEN 
                   CALL cl_err('',SQLCA.sqlcode,0)
                   LET g_success = "N"
                ELSE
                   LET l_img10=l_img10-l_ruc18_1
                END IF
                IF l_img10 >= 0 THEN 
                   CALL t252_allocation_arg(l_rvn09,l_rvn11,l_rvn12,l_img10,l_rvn06_s,'N')
                END IF
             ELSE
                LET g_msg = cl_getmsg("art1054",g_lang)
                CALL cl_replace_str(g_msg,"item",l_rvn09) RETURNING g_msg
                CALL cl_replace_str(g_msg,"plant",l_rvn12) RETURNING g_msg
                CALL cl_replace_str(g_msg,"cang",l_rvn11) RETURNING g_msg
                IF cl_prompt(0,0,g_msg) THEN
                   IF l_img10 > 0 THEN
                      CALL t252_allocation_arg(l_rvn09,l_rvn11,l_rvn12,l_img10,l_rvn06_s,'Y')
                      #料件對應庫存不足時，其他非指定門店數量更新為0
                      IF NOT cl_null(l_rvn06_s) THEN
                         LET g_sql = "UPDATE rvn_file SET rvn10 = 0 ",
                                     " WHERE rvn01='",g_rvm.rvm01,"' AND rvn09='",l_rvn09,"'",
                                     "   AND rvn11='",l_rvn11,"' AND rvn12 = '",l_rvn12,"'",
                                     "   AND rvn06 NOT IN ",l_rvn06_s," "
                         PREPARE upd_other_pr FROM g_sql
                         EXECUTE upd_other_pr 
                         IF SQLCA.sqlcode THEN 
                            LET g_success = "N"
                            CALL s_errmsg('upd_other_pr',g_rvm.rvm01,'update rvn_file:',SQLCA.sqlcode,1)
                         END IF
                      END IF 
                   ELSE
                      LET g_msg = g_rvm.rvm01,"|",l_rvn09,"|",l_rvn11  
                      CALL s_errmsg('rvm01|rvn09|rvn11',g_msg,'','art1020',1)
                      CONTINUE FOREACH
                   END IF 
                END IF  
             END IF  
          END IF
       END FOREACH 
    END IF
    CALL s_showmsg()
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
       
    CLOSE WINDOW t252_w2 
END FUNCTION 

FUNCTION t252_allocation_arg(p_rvn09,p_rvn11,p_rvn12,p_img10,p_rvn06_s,p_go)
DEFINE p_rvn09   LIKE rvn_file.rvn09
DEFINE p_rvn11   LIKE rvn_file.rvn11
DEFINE p_rvn12   LIKE rvn_file.rvn12
DEFINE p_img10   LIKE img_file.img10
DEFINE p_rvn06_s STRING                #指定門店分配時所指定的門店
DEFINE p_go      LIKE type_file.chr1   #指定門店分配時p_go='Y'則庫存不足
DEFINE l_rvn01   LIKE rvn_file.rvn01
DEFINE l_rvn02   LIKE rvn_file.rvn02
DEFINE l_img10_s LIKE img_file.img10   #平均分貨時，多餘量
DEFINE l_img10_a LIKE img_file.img10   #平均分貨時，平均量
DEFINE l_n       LIKE type_file.num5
DEFINE l_sql     STRING

   LET l_sql = "SELECT COUNT(*)",
               "  FROM ruc_file,rvn_file",
               " WHERE rvn01='",g_rvm.rvm01 CLIPPED,"'",
               "   AND ruc00 = '1' AND ruc01 = rvn06",
               "   AND ruc02 = rvn03 AND ruc03 = rvn04",
               "   AND rvn11 = ? AND rvn12 = ? AND rvn09 = ?"
   IF NOT cl_null(p_rvn06_s) THEN  
      IF p_go = 'N' THEN
         LET l_sql = l_sql CLIPPED," AND rvn06 NOT IN ",p_rvn06_s," "
      ELSE 
         LET l_sql = l_sql CLIPPED," AND rvn06 IN ",p_rvn06_s," "
      END IF 
   END IF
   PREPARE count_pr FROM l_sql
   EXECUTE count_pr USING p_rvn11,p_rvn12,p_rvn09 INTO l_n
   IF SQLCA.sqlcode THEN 
      LET g_success = "N"
      CALL s_errmsg('count_pr',g_rvm.rvm01,'count_pr:',SQLCA.sqlcode,1)
   END IF
   LET l_img10_s = p_img10 MOD l_n
   LET l_img10_a = (p_img10 - l_img10_s) / l_n
   LET g_sql = "SELECT rvn01,rvn02 FROM rvn_file",
               " WHERE rvn01='",g_rvm.rvm01,"' AND rvn09='",p_rvn09,"'",
               "   AND rvn11='",p_rvn11,"' AND rvn12 = '",p_rvn12,"'"
   IF NOT cl_null(p_rvn06_s) THEN  
      IF p_go = 'N' THEN
         LET g_sql = g_sql CLIPPED," AND rvn06 NOT IN ",p_rvn06_s," "
      ELSE 
         LET g_sql = g_sql CLIPPED," AND rvn06 IN ",p_rvn06_s," "
      END IF 
   END IF

   DECLARE rvn01_cs CURSOR FROM g_sql
   IF SQLCA.sqlcode THEN 
      LET g_success = "N"
      CALL s_errmsg('rvn01_cs',g_rvm.rvm01,'SELECT rvn01,rvn02 FROM rvn_file:',SQLCA.sqlcode,1)
   END IF
   FOREACH rvn01_cs INTO l_rvn01,l_rvn02  
      UPDATE rvn_file SET rvn10 = l_img10_a
       WHERE rvn01 = l_rvn01 AND rvn02 = l_rvn02
      IF SQLCA.sqlcode THEN 
         LET g_success = "N"
         CALL s_errmsg('rvn01_cs',g_rvm.rvm01,'update rvn_file:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   END FOREACH
   UPDATE rvn_file SET rvn10 = rvn10 + l_img10_s
    WHERE rvn01 = l_rvn01 AND rvn02 = l_rvn02
   IF SQLCA.sqlcode THEN 
      LET g_success = "N"
      CALL s_errmsg('rvn01_cs',g_rvm.rvm01,'update rvn_file:',SQLCA.sqlcode,1)
   END IF

END FUNCTION
#FUN-BA0100 add end---------------
#FUN-870007

