# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimt700.4gl
# Descriptions...: 工廠間調撥維護作業(兩階段)
# Date & Author..: 83/07/01 By Apple
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-480115 04/08/30 By Nicola 無法上、下筆
# Modify.........: No.MOD-4A0248 04/10/29 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-540059 05/06/19 By wujie  單據編號格式放大
# Modify.........: No.FUN-570249 05/07/25 By Carrier 多單位內容修改
# Modify.........: No.MOD-590118 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.TQC-5C0031 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-5C0077 05/12/28 By yoyo 新增字段imn29后修正INSERT寫法
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: NO.MOD-610116 06/01/24 By FUNCTION t700_imn06中 SELECT img19,img36 INTO imn091,imn092中
                              #              應該修改為SELECT img19,img36 INTO imn201,imn202
# Modify.........: No.TQC-620060 06/02/16 By pengu ms290加強判斷未存在使用營運中心的錯誤訊息
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: No.TQC-620154 06/03/16 By 單身材料倉庫/儲位(^P)查詢查無該材料實際庫存資料
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650115 06/05/24 By wujie 料件多屬性相關修改
# Modify.........: No.TQC-660068 06/06/14 By Claire 流程訊息通知傳參數
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-670093 06/07/26 By kim GP3.5 利潤中心
# Modify.........: No.TQC-680013 06/08/08 By pengu 修正INSERT INTO的寫法
# Modify.........: No.FUN-650187 06/09/04 By Sarah 增加欄位imm08(在途倉)
# Modify.........: No.FUN-680010 06/09/06 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-690026 06/09/14 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-680046 06/10/11 By jamie 1.FUNCTION t700()_q 一開始應清空g_imm.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740129 07/04/19 By sherry  調撥方式選擇“1”時，不能直接選擇自行錄入。
# Modify.........: No.FUN-770057 07/07/17 By rainy 將畫面改為多行式輸入
# Modify.........: No.TQC-790008 07/09/03 By judy "預撥數量"不可小于或等于零
# Modify.........: NO.TQC-790093 07/09/14 BY yiting Primary Key的-268訊息 程式修改 
# Modify.........: NO.TQC-790022 07/10/11 BY lumxa未根據其員工編號帶出相應的部門編號
# Modify.........: NO.TQC-7A0049 07/10/15 BY rainy 撥出倉別開窗要抓 撥出廠別的倉庫
# Modify.........: No.MOD-7A0039 07/10/16 By Pengu u()當沒有g_imm.imm01時的錯誤訊息應該是-400
# Modify.........: No.TQC-7A0108 07/10/29 By Judy 查詢撥入倉庫依庫存等級外觀
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-8C0026 08/08/12 By claire 刪除時會發生單身無法刪除錯誤
# Modify.........: No.TQC-8C0026 08/12/16 By claire 刪除時,單身仍留有資料未重新顯示
# Modify.........: No.TQC-920089 09/02/27 By destiny 修改時會報-254的錯
# Modify.........: No.TQC-940045 09/04/13 By destiny 灰掉復制按鈕
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.TQC-970074 09/07/09 By lilingyu 無效資料不可刪除
# Modify.........: No.FUN-980081 09/08/19 By destiny 修改傳到s_madd_img里的參數
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/08 By douzh gp5.2集團架構,sub相關傳參修改
# Modify.........: No.FUN-980059 09/09/10 By arman gp5.2集團架構,sub相關傳參修改
# Modify.........: No.FUN-980093 09/09/23 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.TQC-A10060 10/01/08 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位 
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/08 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.TQC-B20171 11/02/24 By destiny 新增时未显示orig,oriu 两字段 
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70074 11/07/20 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:MOD-B80136 11/08/12 By Vampire after field imn06的IF判斷式改成 p_cmd='a' or or (p_cmd='u' and (g_imn_o.imn06 IS NULL OR g_imn_o.imn06 = ' ' OR (g_imn[l_ac].imn06 != g_imn_o.imn06 ))
# Modify.........: No:TQC-BA0013 11/10/08 By houlia 查詢時開啟immoriu,immorig
# Modify.........: No:FUN-BB0084 11/12/02 By lixh1 增加數量欄位小數取位
# Modify.........: No:CHI-BB0015 11/12/16 By ck2yuan 新增列印功能
# Modify.........: No:MOD-B80212 12/01/16 By Vampire 當實撥數量已大於0時，代表已經有做調撥動作了，所以在單身刪除時要先判斷imn11是否=0
# Modify.........: No:MOD-B80348 12/01/16 By Vampire q_azr 改為 q_azp
# Modify.........: No:FUN-C20002 12/02/07 By fanbj 券產品倉庫調整
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:CHI-C50010 12/06/01 By ck2yuan 調撥時,有效日期應拿原本調撥前的有效日期
# Modify.........: No:TQC-C50034 12/06/04 By chenjing 修改單頭錄入完畢進入單身點放棄再錄入相同的調撥單號報錯
# Modify.........: No:MOD-BC0029 12/06/15 By ck2yuan 查詢如果查不到資料，單身會帶出上次查詢的資料
#                                                    imm08開窗查詢倉庫查不到
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C80107 12/09/18 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No:TQC-C90109 12/10/12 By Elise 撥出與撥入營運中心同法人時，應使用artt256
# Modify.........: No.MOD-CA0009 12/10/12 By Elise 倉庫有效日期不應控卡
# Modify.........: No:FUN-C90049 12/10/18 By Lori 預設成本倉與非成本倉改從s_get_defstore取得
# Modify.........: No.FUN-D20060 13/02/22 By yangtt 設限倉庫/儲位控卡
# Modify.........: No.FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No.CHI-D10014 13/04/03 By bart 增加批序號
# Modify.........: No:FUN-D40030 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_imm           RECORD LIKE imm_file.*,      #調撥單單頭
    g_imm_t         RECORD LIKE imm_file.*,
    g_imm_o         RECORD LIKE imm_file.*,
    g_imm01_t       LIKE imm_file.imm01,
    g_imn02_t       LIKE imn_file.imn02,
     g_imn041          LIKE imn_file.imn041,

     g_imn041_o        LIKE imn_file.imn041,
     g_imn041_t        LIKE imn_file.imn041,
     g_imn151          LIKE imn_file.imn151,
     g_imn151_o        LIKE imn_file.imn151,
     g_imn151_t        LIKE imn_file.imn151,
     g_imn   DYNAMIC ARRAY OF RECORD
              imn02   LIKE imn_file.imn02,
              imn03   LIKE imn_file.imn03,
              ima02   LIKE ima_file.ima02,
              imn29   LIKE imn_file.imn29,
              imn27   LIKE imn_file.imn27,
              ima08   LIKE ima_file.ima08,
              ima05   LIKE ima_file.ima05,
              imn04   LIKE imn_file.imn04,
              imn05   LIKE imn_file.imn05,
              imn06   LIKE imn_file.imn06,
              imn09   LIKE imn_file.imn09,
              imn9301 LIKE imn_file.imn9301,
              gem02b  LIKE gem_file.gem02,
              imn10   LIKE imn_file.imn10,
              imn33   LIKE imn_file.imn33,
              imn34   LIKE imn_file.imn34,
              imn35   LIKE imn_file.imn35,
              imn30   LIKE imn_file.imn30,
              imn31   LIKE imn_file.imn31,
              imn32   LIKE imn_file.imn32,
              imn11   LIKE imn_file.imn11,
              imn15   LIKE imn_file.imn15,
              imn16   LIKE imn_file.imn16,
              imn17   LIKE imn_file.imn17,
              imn20   LIKE imn_file.imn20,
              imn9302 LIKE imn_file.imn9302,
              gem02c  LIKE gem_file.gem02,
              imn43   LIKE imn_file.imn43,
              imn44   LIKE imn_file.imn44,
              imn45   LIKE imn_file.imn45,
              imn40   LIKE imn_file.imn40,
              imn41   LIKE imn_file.imn41,
              imn42   LIKE imn_file.imn32,
              imn23   LIKE imn_file.imn23
             END RECORD,
    g_imn_t  RECORD 
              imn02   LIKE imn_file.imn02,
              imn03   LIKE imn_file.imn03,
              ima02   LIKE ima_file.ima02,
              imn29   LIKE imn_file.imn29,
              imn27   LIKE imn_file.imn27,
              ima08   LIKE ima_file.ima08,
              ima05   LIKE ima_file.ima05,
              imn04   LIKE imn_file.imn04,
              imn05   LIKE imn_file.imn05,
              imn06   LIKE imn_file.imn06,
              imn09   LIKE imn_file.imn09,
              imn9301 LIKE imn_file.imn9301,
              gem02b  LIKE gem_file.gem02,
              imn10   LIKE imn_file.imn10,
              imn33   LIKE imn_file.imn33,
              imn34   LIKE imn_file.imn34,
              imn35   LIKE imn_file.imn35,
              imn30   LIKE imn_file.imn30,
              imn31   LIKE imn_file.imn31,
              imn32   LIKE imn_file.imn32,
              imn11   LIKE imn_file.imn11,
              imn15   LIKE imn_file.imn15,
              imn16   LIKE imn_file.imn16,
              imn17   LIKE imn_file.imn17,
              imn20   LIKE imn_file.imn20,
              imn9302 LIKE imn_file.imn9302,
              gem02c  LIKE gem_file.gem02,
              imn43   LIKE imn_file.imn43,
              imn44   LIKE imn_file.imn44,
              imn45   LIKE imn_file.imn45,
              imn40   LIKE imn_file.imn40,
              imn41   LIKE imn_file.imn41,
              imn42   LIKE imn_file.imn32,
              imn23   LIKE imn_file.imn23
            END RECORD,
    g_imn_o  RECORD 
              imn02   LIKE imn_file.imn02,
              imn03   LIKE imn_file.imn03,
              ima02   LIKE ima_file.ima02,
              imn29   LIKE imn_file.imn29,
              imn27   LIKE imn_file.imn27,
              ima08   LIKE ima_file.ima08,
              ima05   LIKE ima_file.ima05,
              imn04   LIKE imn_file.imn04,
              imn05   LIKE imn_file.imn05,
              imn06   LIKE imn_file.imn06,
              imn09   LIKE imn_file.imn09,
              imn9301 LIKE imn_file.imn9301,
              gem02b  LIKE gem_file.gem02,
              imn10   LIKE imn_file.imn10,
              imn33   LIKE imn_file.imn33,
              imn34   LIKE imn_file.imn34,
              imn35   LIKE imn_file.imn35,
              imn30   LIKE imn_file.imn30,
              imn31   LIKE imn_file.imn31,
              imn32   LIKE imn_file.imn32,
              imn11   LIKE imn_file.imn11,
              imn15   LIKE imn_file.imn15,
              imn16   LIKE imn_file.imn16,
              imn17   LIKE imn_file.imn17,
              imn20   LIKE imn_file.imn20,
              imn9302 LIKE imn_file.imn9302,
              gem02c  LIKE gem_file.gem02,
              imn43   LIKE imn_file.imn43,
              imn44   LIKE imn_file.imn44,
              imn45   LIKE imn_file.imn45,
              imn40   LIKE imn_file.imn40,
              imn41   LIKE imn_file.imn41,
              imn42   LIKE imn_file.imn32,
              imn23   LIKE imn_file.imn23
            END RECORD,
    g_imn07         LIKE imn_file.imn07,
    g_imn08         LIKE imn_file.imn08,
    g_imn091        LIKE imn_file.imn091,
    g_imn092        LIKE imn_file.imn092,
    g_imn12         LIKE imn_file.imn12,
    g_imn13         LIKE imn_file.imn13,
    g_imn14         LIKE imn_file.imn14,
    g_imn18         LIKE imn_file.imn18,
    g_imn19         LIKE imn_file.imn19,
    g_imn201        LIKE imn_file.imn201,
    g_imn202        LIKE imn_file.imn202,
    g_imn21         LIKE imn_file.imn21,
    g_imn22         LIKE imn_file.imn22,
    g_imn24         LIKE imn_file.imn24,
    g_imn25         LIKE imn_file.imn25,
    g_imn26         LIKE imn_file.imn26,
    g_imn28         LIKE imn_file.imn28,
    g_imn51         LIKE imn_file.imn51,
    g_imn52         LIKE imn_file.imn52,
    g_qty           LIKE imn_file.imn10,
    g_buf           LIKE gem_file.gem02,        #No.FUN-690026 VARCHAR(20)
    g_wc,g_sql          string,                 #No.FUN-580092 HCN
    g_wc2               STRING,                 #FUN-770057
    g_rec_b         LIKE type_file.num5,        #單身筆數            #FUN-770057
    g_b_cnt             LIKE type_file.num5,    #單身合乎條件筆數  #No.FUN-690026 SMALLINT
    g_b_cn3             LIKE type_file.num5,    #單身合乎條件筆數  #No.FUN-690026 SMALLINT
    g_statu             LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_t1                LIKE smy_file.smyslip,  #No.FUN-550029 #No.FUN-690026 VARCHAR(05)
    g_sheet             LIKE smy_file.smyslip,  #單別    (沿用)  #No.FUN-550029 #No.FUN-690026 VARCHAR(5)
    g_chgplant          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_ydate             LIKE type_file.dat,     #單據日期(沿用)  #No.FUN-690026 DATE
    g_azp01             LIKE azp_file.azp01,
    g_azp03             LIKE azp_file.azp03,
    h_qty               LIKE ima_file.ima271,
    g_smy62             LIKE smy_file.smy62         #No.TQC-650115
 
DEFINE g_ima906         LIKE ima_file.ima906,
       g_ima907         LIKE ima_file.ima907,
       g_img09_s        LIKE img_file.img09,
       g_img09_t        LIKE img_file.img09,
       g_sw             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_factor         LIKE img_file.img21,
       g_tot            LIKE img_file.img10,
       g_flag           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_argv1         LIKE imm_file.imm01      # 單號  #TQC-630052 #No.FUN-690026 VARCHAR(16)
DEFINE g_argv2         STRING                   # 指定執行的功能   #TQC-630052
DEFINE g_forupd_sql    STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE l_ac            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask        LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
DEFINE l_plant_new     LIKE azp_file.azp01        #FUN-980093 add
DEFINE l_flag01        LIKE type_file.chr1    #FUN-C80107 add
#CHI-D10014---begin
DEFINE g_ima918        LIKE ima_file.ima918   
DEFINE g_ima921        LIKE ima_file.ima921   
DEFINE l_r             LIKE type_file.chr1    
DEFINE g_rvbs   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  rvbs02  LIKE rvbs_file.rvbs02,
                  rvbs021 LIKE rvbs_file.rvbs021,
                  ima02a  LIKE ima_file.ima02,
                  ima021a LIKE ima_file.ima021,
                  rvbs022 LIKE rvbs_file.rvbs022,
                  rvbs04  LIKE rvbs_file.rvbs04,
                  rvbs03  LIKE rvbs_file.rvbs03,
                  rvbs05  LIKE rvbs_file.rvbs05,
                  rvbs06  LIKE rvbs_file.rvbs06,
                  rvbs07  LIKE rvbs_file.rvbs07,
                  rvbs08  LIKE rvbs_file.rvbs08
                END RECORD,
       g_rvbs_t RECORD
                  rvbs02  LIKE rvbs_file.rvbs02,
                  rvbs021 LIKE rvbs_file.rvbs021,
                  ima02a  LIKE ima_file.ima02,
                  ima021a LIKE ima_file.ima021,
                  rvbs022 LIKE rvbs_file.rvbs022,
                  rvbs04  LIKE rvbs_file.rvbs04,
                  rvbs03  LIKE rvbs_file.rvbs03,
                  rvbs05  LIKE rvbs_file.rvbs05,
                  rvbs06  LIKE rvbs_file.rvbs06,
                  rvbs07  LIKE rvbs_file.rvbs07,
                  rvbs08  LIKE rvbs_file.rvbs08
                END RECORD
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數
       l_ac1              LIKE type_file.num5
#CHI-D10014---end

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1=ARG_VAL(1)           #TQC-630052
    LET g_argv2=ARG_VAL(2)           #TQC-630052
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
 
    INITIALIZE g_imm.* TO NULL
    INITIALIZE g_imm_t.* TO NULL
    INITIALIZE g_imm_o.* TO NULL
    LET g_ydate  = NULL
 
    LET g_forupd_sql = "SELECT * FROM imm_file WHERE imm01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t700_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW t700_w WITH FORM "aim/42f/aimt700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL t700_mu_ui()
 
    WHILE  TRUE
       LET g_action_choice=''
    
       # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是單號(imm01)
       # 執行I時，g_argv1是單號(imm01)
       IF NOT cl_null(g_argv1) THEN
          CASE g_argv2
             WHEN "query"
                LET g_action_choice = "query"
                IF cl_chk_act_auth() THEN
                   CALL t700_q()
                END IF
             WHEN "insert"
                LET g_action_choice = "insert"
                IF cl_chk_act_auth() THEN
                   CALL t700_a()
                END IF
             OTHERWISE 
                   CALL t700_q()
          END CASE
       END IF
 
       CALL t700_menu()
       IF g_action_choice='exit' THEN EXIT WHILE END IF
    END WHILE
    CLOSE WINDOW t700_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
 
 
FUNCTION t700_cs()
    CLEAR FORM
    CALL g_imn.clear()   #MOD-BC0029 add
   IF cl_null(g_argv1) THEN  #TQC-630052
      INITIALIZE g_imm.* TO NULL   #FUN-640213 add 
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          imm01, imm02, imm09, imm14, imm08, immspc,imm07,  #FUN-670093   #FUN-650187 add imm08 #FUN-680010 add immspc
        # immuser,immgrup,immmodu,immdate,immacti     #TQC-BA0013 mark
          immuser,immgrup,immmodu,immdate,immacti,immoriu,immorig      #TQC-BA0013 add immoriu,immorig
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(imm01) #查詢單據性質
                CALL cl_init_qry_var()
                LET g_qryparam.state    = "c"
                LET g_qryparam.form     = "q_imm107"
                LET g_qryparam.arg1 = g_plant
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imm01
                NEXT FIELD imm01
              WHEN INFIELD(imm09) #申請人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_gen"
                 LET g_qryparam.default1 = g_imm.imm09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imm09
                 CALL t700_imm09('d')
                 NEXT FIELD imm09
              WHEN INFIELD(imm08) #查詢在途倉
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  ="q_imd"
                   LET g_qryparam.state ="c"
                   LET g_qryparam.arg1  ="W"
                   LET g_qryparam.arg2 = g_plant   #MOD-BC0029 add
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imm08
                   NEXT FIELD imm08
              WHEN INFIELD(imm14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imm.imm14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imm14
                 NEXT FIELD imm14
              OTHERWISE
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
 
 
        END CONSTRUCT
 
      IF INT_FLAG THEN RETURN END IF
 
   ELSE
      LET g_wc =" imm01 = '",g_argv1,"'"  
   END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
 
    CONSTRUCT g_wc2 ON imn02,  imn03,imn29,  imn04,imn05,               # 螢幕上取單身條件
                       imn06,  imn09,imn9301,imn10,imn33,
                       imn34,  imn35,imn30,  imn31,imn32,
                       imn11,  imn15,imn16,  imn17,imn20,
                       imn9302,imn43,imn44,  imn45,imn40,
                       imn41,  imn42,imn23
           FROM s_imn[1].imn02,  s_imn[1].imn03,s_imn[1].imn29,  s_imn[1].imn04,s_imn[1].imn05,  
                s_imn[1].imn06,  s_imn[1].imn09,s_imn[1].imn9301,s_imn[1].imn10,s_imn[1].imn33,
                s_imn[1].imn34,  s_imn[1].imn35,s_imn[1].imn30,  s_imn[1].imn31,s_imn[1].imn32,
                s_imn[1].imn11,  s_imn[1].imn15,s_imn[1].imn16,  s_imn[1].imn17,s_imn[1].imn20,
                s_imn[1].imn9302,s_imn[1].imn43,s_imn[1].imn44,  s_imn[1].imn45,s_imn[1].imn40,
                s_imn[1].imn41,  s_imn[1].imn42,s_imn[1].imn23
       BEFORE CONSTRUCT
            CALL cl_qbe_init()
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(imn03)
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form     = "q_ima"
              #  LET g_qryparam.state = "c"
              #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO imn03
             WHEN INFIELD(imn04)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imd"
                LET g_qryparam.state    = "c"
                LET g_qryparam.arg1     = 'SW'        #倉庫類別 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn04
                NEXT FIELD imn04
             WHEN INFIELD(imn15)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_m_imd"
                LET g_qryparam.state    = "c"
                LET g_qryparam.plant    = g_imn151    #No.FUN-980025 add  
                LET g_qryparam.arg2     = 'SW'        #倉庫類別 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn15
                NEXT FIELD imn15
               
             WHEN INFIELD(imn9301)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn9301
              WHEN INFIELD(imn9302)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn9302
              WHEN INFIELD(imn33) #單位
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn33
              WHEN INFIELD(imn30) #單位
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn30
              WHEN INFIELD(imn43) #單位
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn43
              WHEN INFIELD(imn40) #單位
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn40
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
 
    LET g_sql="SELECT UNIQUE imm_file.imm01 FROM imm_file,imn_file",
              " WHERE imm01=imn01 AND ",
              "       imm10='4' AND ",
              "       imn041 ='",g_plant,"' AND ",g_wc CLIPPED,
              "       AND ",g_wc2 CLIPPED,   #FUN-770057
              " ORDER BY imm01"
    PREPARE t700_prepare FROM g_sql               # RUNTIME 編譯
    DECLARE t700_cs                               # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t700_prepare
 
    LET g_sql="SELECT COUNT(UNIQUE imm01) FROM imm_file,imn_file ",
              " WHERE imm01=imn01 AND ",
              "       imm10='4' AND ",
              "       imn041 ='",g_plant,"' AND ",g_wc CLIPPED,
              "       AND ", g_wc2 CLIPPED    #FUN-770057
    PREPARE t700_precount FROM g_sql
    DECLARE t700_count CURSOR FOR t700_precount
END FUNCTION
 
FUNCTION t700_menu()
   WHILE TRUE
     CALL t700_bp("G")
     CASE g_action_choice
       WHEN "insert"
         IF cl_chk_act_auth() THEN
              CALL t700_a()
         END IF
       WHEN "query"
           LET g_b_cnt=0
           LET g_b_cn3=0
           IF cl_chk_act_auth() THEN
                CALL t700_q()
           END IF
       WHEN  "delete"
           IF cl_chk_act_auth() THEN
                CALL t700_r()
           END IF
       WHEN "modify"
           IF cl_chk_act_auth() THEN
                CALL t700_u()
           END IF
       WHEN "invalid"
          IF cl_chk_act_auth() THEN
               CALL t700_x()
               CALL cl_set_field_pic("","","","","",g_imm.immacti)
          END IF
       WHEN  "detail"
          IF cl_chk_act_auth() THEN
              CALL t700_b()
          END IF
 
       WHEN "help"
           CALL cl_show_help()
 
       WHEN "exit"
          EXIT WHILE
 
       WHEN "controlg"   
          CALL cl_cmdask()

       WHEN "output"                       #CHI-BB0015 add列印
          #IF cl_chk_act_auth() THEN        #CHI-BB0015 add
             CALL t700_out()               #CHI-BB0015 add
          #END IF                           #CHI-BB0015 add 

    #@ON ACTION 拋轉至SPC
       WHEN "trans_spc"                     
         IF cl_chk_act_auth() THEN
            CALL t700_spc()
         END IF
 
       WHEN "related_document"       #相關文件
         IF cl_chk_act_auth() THEN
             IF g_imm.imm01 IS NOT NULL THEN
                LET g_doc.column1 = "imm01"
                LET g_doc.value1 = g_imm.imm01
                CALL cl_doc()
             END IF
         END IF
       #CHI-D10014---begin
       WHEN "qry_lot"
          LET l_ac = ARR_CURR()
          SELECT ima918,ima921 INTO g_ima918,g_ima921
            FROM ima_file
           WHERE ima01 = g_imn[l_ac].imn03
             AND imaacti = "Y"
          IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
             LET g_success = 'Y'
             BEGIN WORK
             CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,
                           g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                           g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                           g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                           g_imn[l_ac].imn10,'','QRY',-1)
                    RETURNING l_r,g_qty
             IF g_success = "Y" THEN
                COMMIT WORK
             ELSE
                ROLLBACK WORK
             END IF
          END IF
        #CHI-D10014---end 
    END CASE
  END WHILE
END FUNCTION
 
 
FUNCTION t700_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          LIKE type_file.chr1000       #No.FUN-680102CHAR(200)
    LET g_sql =
        "SELECT imn02,imn03,ima02,imn29,imn27,ima08,ima05,imn04,imn05,imn06,imn09, ",
        "       imn9301,a.gem02,imn10,imn33,imn34,imn35,imn30,imn31,imn32,",
        "       imn11,imn15,imn16,imn17,imn20,imn9302,b.gem02,imn43,imn44,",
        "       imn45,imn40,imn41,imn42,imn23 ",
        " FROM imn_file,OUTER ima_file,OUTER gem_file a,OUTER gem_file b",
        " WHERE imn01 ='",g_imm.imm01,"'",  #單頭
        "  AND imn_file.imn03=ima_file.ima01 ",
        "  AND imn_file.imn9301=a.gem01 ", 
        "  AND imn_file.imn9302=b.gem01 "     
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY imn02 " 
    DISPLAY g_sql
 
    PREPARE imn_pb FROM g_sql
    DECLARE imn_curs                       #SCROLL CURSOR
        CURSOR FOR imn_pb
 
    CALL g_imn.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH imn_curs INTO g_imn[g_cnt].*   #單身 ARRAY 填充
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
 
    CALL g_imn.deleteElement(g_cnt)
 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    #CHI-D10014---begin
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_imm.imm01,"'"
    PREPARE sel_rvbs_pre FROM g_sql
    DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre

    CALL g_rvbs.clear()

    LET g_cnt = 1
    FOREACH rvbs_curs INTO g_rvbs[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvbs.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt - 1
    #CHI-D10014---end
END FUNCTION
 
 
FUNCTION t700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)   #CHI-D10014
      #DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #CHI-D10014
      DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b)  #CHI-D10014
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()       
      #CHI-D10014---begin 
         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY

      DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
            
         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY
      #CHI-D10014---end
      ON ACTION insert
         LET g_action_choice="insert"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
      ON ACTION delete
         LET g_action_choice="delete"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
      ON ACTION modify
         LET g_action_choice="modify"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
 
      ON ACTION first 
         CALL t700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         #ACCEPT DISPLAY  #CHI-D10014 
         ACCEPT DIALOG  #CHI-D10014             
                              
      ON ACTION previous
         CALL t700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         #ACCEPT DISPLAY  #CHI-D10014 
         ACCEPT DIALOG  #CHI-D10014               
                              
      ON ACTION jump 
         CALL t700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         #ACCEPT DISPLAY  #CHI-D10014 
         ACCEPT DIALOG  #CHI-D10014             
                              
      ON ACTION next
         CALL t700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         #ACCEPT DISPLAY  #CHI-D10014 
         ACCEPT DIALOG  #CHI-D10014                 
                              
      ON ACTION last 
         CALL t700_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         #ACCEPT DISPLAY  #CHI-D10014 
         ACCEPT DIALOG  #CHI-D10014                
      ON ACTION invalid
         LET g_action_choice="invalid"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014

      ON ACTION output                       #CHI-BB0015
         LET g_action_choice="output"        #CHI-BB0015
         #EXIT DISPLAY                        #CHI-BB0015 #CHI-D10014
         EXIT DIALOG    #CHI-D10014
         
      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()              
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY  #CHI-D10014
         CONTINUE DIALOG  #CHI-D10014
 
      ON ACTION about         
         CALL cl_about()      
 
  
#@    ON ACTION 相關文件  
       ON ACTION related_document  
         LET g_action_choice="related_document"
         #EXIT DISPLAY  #CHI-D10014
         EXIT DIALOG    #CHI-D10014
 
      #AFTER DISPLAY       #CHI-D10014
      #   CONTINUE DISPLAY #CHI-D10014
      AFTER DIALOG  #CHI-D10014
         CONTINUE DIALOG  #CHI-D10014
   #END DISPLAY  #CHI-D10014
   &include "qry_string.4gl"
   END DIALOG  #CHI-D10014
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t700_cur(p_plant)  #FUN-980093 add
 DEFINE  l_sql   STRING
 DEFINE  p_plant  LIKE azp_file.azp01  #FUN-980093 add
 DEFINE  l_legal  LIKE azw_file.azw02  #CHI-D10014
 
   LET g_plant_new = p_plant
   LET l_plant_new = g_plant_new
   CALL s_getdbs()    
   CALL s_gettrandbs()
   LET l_dbs_tra = g_dbs_tra
 
  #LET l_sql = "INSERT INTO ",l_dbs_tra CLIPPED,"imm_file",  #FUN-980093 add   #FUN-A50102
   LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant_new,'imm_file'),  #FUN-A50102
               " (imm01,imm02,imm03,imm04,imm05,imm06,imm07,",
               "  imm08,imm09,imm10,imm11,imm12,imm13,imm14,",
               "  immacti,immconf,immdate,immdays,immgrup,immmodu,",
               "  immprit,immuser,immplant,immlegal,immoriu,immorig)",#TQC-A10060 add immoriu,immorig  #FUN-980004 add immplant,immlegal
               " VALUES( ?,?,?,?,?,?,?,?,?,?,", #NO:7149-2
               "         ?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"  #TQC-A10060 add ?,? #FUN-670093 #No.TQC-680013 add "?" #FUN-980004 add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
   PREPARE imm_cur FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('imm_cur',SQLCA.sqlcode,0)
   END IF
 
  #LET l_sql = "INSERT INTO ",l_dbs_tra CLIPPED,"imn_file",  #FUN-980093 add   #FUN-A50102
   LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant_new,'imn_file'), #FUN-A50102
               " (imn01,imn02,imn03,imn041,imn04, imn05,imn06,",
               "  imn07,imn08,imn09,imn091,imn092,imn10,imn11,",
               "  imn12,imn15 ,imn151,imn16,imn17,",
               "  imn18,imn19,imn20,imn201,imn202,imn21,imn22,",
               "  imn23,imn24,imn27, imn28,imn29,",
               "  imn30,imn31,imn32,imn33, imn34, imn35,imn40,",
               "  imn41,imn42,imn43,imn44, imn45, imn51,imn52,",
               "  imn9301,imn9302,imnplant,imnlegal)", #FUN-980004 add imnplant,imnlegal
               " VALUES( ?,?,?,?,?,?,?,?,?,?,",
               "         ?,?,?,?,?,?,?,?,?,?,",
               "         ?,?,?,?,?,?,?,?,?,?,",
               "         ?,?,?,?,?,?,?,?,?,?,",  #No.FUN-570249
               "         ?,?,?,?,?,?,?, ?,?)"     #No.FUN-570249 #No.FUN-5C0077 #FUN-670093 #FUN-980004 add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
   PREPARE imn_cur FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('imn_cur',SQLCA.sqlcode,0)
   END IF
   #CHI-D10014---begin
   CALL s_getlegal(g_imn151) RETURNING l_legal
   LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant_new,'rvbs_file'), 
               " (rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
               "  rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,rvbsplant,rvbslegal) ",
               " SELECT rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
               "        rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,'",l_plant_new,"','",l_legal,"'",
               "   FROM rvbs_file ",
               "  WHERE rvbs00 = 'aimt700' ",
               "    AND rvbs01 = ? ",
               "    AND rvbs02 = ? ",
               "    AND rvbs021 = ? "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  
   PREPARE rvbs_cur FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('rvbs_cur',SQLCA.sqlcode,0)
   END IF

   LET l_sql = " DELETE FROM ",cl_get_target_table(l_plant_new,'rvbs_file'), 
               "  WHERE rvbs00 = 'aimt700' ",
               "    AND rvbs01 = ? ",
               "    AND rvbs02 = ? ",
               "    AND rvbs021 = ? "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  
   PREPARE rvbs_del FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('rvbs_del',SQLCA.sqlcode,0)
   END IF
   #CHI-D10014---end
END FUNCTION
 
 
FUNCTION t700_a()
  DEFINE l_msg  LIKE ze_file.ze03,         #No.FUN-690026 VARCHAR(60)
         l_chr  LIKE type_file.chr1        #No.FUN-690026 VARCHAR(1)
  DEFINE li_result  LIKE type_file.num5    #No.FUN-550029  #No.FUN-690026 SMALLINT
  DEFINE l_imn RECORD LIKE imn_file.*,   #FUN-770057
         l_sql STRING
  DEFINE l_legal  LIKE azw_file.azw02  #FUN-980004 add
  DEFINE l_imni  RECORD LIKE imni_file.*  #FUN-B70074
 
    MESSAGE ""
    CLEAR FORM                                     # 清螢墓欄位內容
    INITIALIZE g_imm.* LIKE imm_file.*
    CALL g_imn.clear()
    LET g_rec_b = 0
    IF g_ydate IS NULL THEN
        LET g_imm.imm01 = NULL
        LET g_imm.imm02 = g_today
    ELSE                                           #使用上筆資料值
        LET g_imm.imm01[1,g_doc_len] = g_sheet     #No.FUN-550029
        LET g_imm.imm02 = g_ydate                  #收貨日期
    END IF
    LET g_imm.imm01[g_no_sp,g_no_ep] = ''          #No.FUN-550029
    LET g_imm.imm10 = '4'
    LET g_imn041  = g_plant                    #撥出工廠別 #FUN-770057
    CALL t700_plantnam('d','1',g_imn041)       ##FUN-770057
    LET g_imm01_t = NULL
    LET g_imm_t.* = g_imm.*
    LET g_imm_o.* = g_imm.*
    CALL cl_opmsg('a')
    WHILE TRUE
       LET g_imm.immacti = 'Y'                 #有效的資料
       LET g_imm.immuser = g_user
       LET g_imm.immoriu = g_user #FUN-980030
       LET g_imm.immorig = g_grup #FUN-980030
       LET g_data_plant = g_plant #FUN-980030
       LET g_imm.immgrup = g_grup              #使用者所屬群
       LET g_imm.immdate = g_today
       LET g_imm.imm14 = g_grup  #FUN-670093
       LET g_imm.immspc = '0' #FUN-680010
       LET g_imm.imm04  = 'N' #FUN-680010
       LET g_imm.imm03  = 'N' #FUN-680010
       LET g_imm.immplant = g_plant #FUN-980004 add
       LET g_imm.immlegal = g_legal #FUN-980004 add
       LET g_imm.immoriu = g_user   #TQC-A10060  add
      #LET g_imm.immorig = g_user   #TQC-A10060  add  #TQC-B20171
       LET g_imm.immorig = g_grup   #TQC-A10060  add  #TQC-B20171
       CALL t700_i("a")                     # 各欄位輸入
       IF INT_FLAG THEN                        # 若按了DEL鍵
          INITIALIZE g_imm.* TO NULL
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
       END IF
       IF g_imm.imm01 IS NULL THEN              # KEY 不可空白
          CONTINUE WHILE
       END IF
 
       BEGIN WORK #No:7857
       CALL s_auto_assign_no("aim",g_imm.imm01,g_imm.imm02,"4","imm_file","imm01",
                  "","","")
             RETURNING li_result,g_imm.imm01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_imm.imm01
        #FUN-A60034--add---str---
        #FUN-A70104--mod---str---
        LET g_imm.immmksg = 'N'          #是否簽核
        LET g_imm.imm15 = '0'            #簽核狀況
        LET g_imm.imm16 = g_user         #申請人
        #FUN-A70104--mod---end---
        #FUN-A60034--add---end---
        INSERT INTO imm_file VALUES(g_imm.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
        #   ROLLBACK WORK #No:7857       #FUN-B80070---回滾放在報錯後---
           CALL cl_err3("ins","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           ROLLBACK WORK               #FUN-B80070--add--
           CONTINUE WHILE
        ELSE
           #寫到撥入工廠
             CALL t700_cur(g_imn151) #FUN-980093 add
             CALL s_getlegal(g_imn151) RETURNING l_legal #FUN-980004 add
             EXECUTE imm_cur USING
                g_imm.imm01,g_imm.imm02,g_imm.imm03,g_imm.imm04,g_imm.imm05,
                g_imm.imm06,g_imm.imm07,g_imm.imm08,g_imm.imm09,g_imm.imm10,
                g_imm.imm11,g_imm.imm12,g_imm.imm13,g_imm.imm14,
                g_imm.immacti,g_imm.immconf,g_imm.immdate,g_imm.immdays,
                g_imm.immgrup,g_imm.immmodu,g_imm.immprit,g_imm.immuser,g_imn151,l_legal,g_user,g_grup #TQC-A10060  add g_user,g_grup  #FUN-980004 add g_imn151,l_legal
                IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093
        	   LET g_success = 'N'
		   CALL cl_err('imm_cur:ckp#1',SQLCA.sqlcode,0)
		   ROLLBACK WORK #No:7857
	           EXIT WHILE
		END IF
		COMMIT WORK #No:7857
		CALL cl_flow_notify(g_imm.imm01,'I')
		LET g_imm_t.* = g_imm.*              # 保存上筆資料
		SELECT imm01 INTO g_imm.imm01 FROM imm_file
		WHERE imm01 = g_imm.imm01
		CALL cl_getmsg('mfg9390',g_lang) RETURNING l_msg
		WHILE l_chr IS NULL OR l_chr NOT MATCHES'[123]'
		LET INT_FLAG = 0  ######add for prompt bug
		PROMPT l_msg CLIPPED FOR CHAR l_chr
 
		IF INT_FLAG THEN
		LET INT_FLAG = 0
		LET l_chr = '1'
		EXIT WHILE
		END IF
		END WHILE
 
		IF l_chr='2' OR l_chr='3' THEN
		IF l_chr='2' THEN  ##工單方式
		CALL t7001(g_imm.imm01,g_imm.imm02,'1',g_imn041,g_imn151)             #FUN-770057
		ELSE               ##BOM 方式
		CALL t7001(g_imm.imm01,g_imm.imm02,'2',g_imn041,g_imn151)              #FUN-770057
		END IF
#將單身資料寫入撥入廠
		LET l_sql = "SELECT * FROM imn_file " ,
		" WHERE imn01 ='",g_imm.imm01 CLIPPED,"'"
		PREPARE imn_uadd_pre  FROM l_sql
		IF SQLCA.sqlcode THEN
		CALL cl_err('imn_uadd_pre',SQLCA.sqlcode,1)
		END IF
		DECLARE imn_uadd_cur  CURSOR FOR imn_uadd_pre  
		FOREACH imn_uadd_cur INTO l_imn.*   
		IF SQLCA.sqlcode THEN
	       	CALL cl_err('imm_uadd_cur',SQLCA.sqlcode,1)
		EXIT FOREACH
	END IF
{ckp#2}        #---->產生調撥單單身資料(撥入廠)
        CALL s_getlegal(g_imn151) RETURNING l_legal #FUN-980004 add
	EXECUTE imn_cur USING 
	l_imn.imn01, l_imn.imn02, l_imn.imn03, l_imn.imn041, 
	l_imn.imn04, l_imn.imn05, l_imn.imn06, l_imn.imn07,
	l_imn.imn08, l_imn.imn09, l_imn.imn091,l_imn.imn092,
	l_imn.imn10, l_imn.imn11, l_imn.imn12, 
	l_imn.imn15, l_imn.imn151,l_imn.imn16,
	l_imn.imn17, l_imn.imn18, l_imn.imn19, l_imn.imn20,
	l_imn.imn201,l_imn.imn202,l_imn.imn21, l_imn.imn22,
	l_imn.imn23, l_imn.imn24, 
	l_imn.imn27, l_imn.imn28, l_imn.imn29, l_imn.imn30,
	l_imn.imn31, l_imn.imn32, l_imn.imn33, l_imn.imn34,
	l_imn.imn35, l_imn.imn40, l_imn.imn41, l_imn.imn42,
	l_imn.imn43, l_imn.imn44, l_imn.imn45, l_imn.imn51,
	l_imn.imn52, l_imn.imn9301,l_imn.imn9302,g_imn151,l_legal #FUN-980004 add g_imn151,l_legal
	IF SQLCA.sqlcode THEN
	LET g_success = 'N'
	CALL cl_err('imn_cur:ckp#2',SQLCA.sqlcode,0)
	EXIT FOREACH
        #FUN-B70074-add-str--
        ELSE
           IF NOT s_industry('std') THEN
              INITIALIZE l_imni.* TO NULL
              LET l_imni.imni01 = l_imn.imn01
              LET l_imni.imni02 = l_imn.imn02
              IF NOT s_ins_imni(l_imni.*,l_plant_new) THEN
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
        #FUN-B70074-add-end--
	END IF
	END FOREACH
 
###將資料重讀出
	SELECT imm01 INTO g_imm.imm01
	FROM imm_file WHERE imm01=g_imm.imm01
 
	CALL t700_b_fill("1=1")   #FUN-770057
	END IF
	END IF
	LET g_ydate = g_imm.imm02
LET g_sheet = s_get_doc_no(g_imm.imm01)
	LET g_b_cnt = 0                    #No.FUN-680064
CALL t700_b()
	EXIT WHILE
	END WHILE
	END FUNCTION
 
FUNCTION t700_i(p_cmd)
	DEFINE
	p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(20)
	l_msg           LIKE type_file.chr1000, #No.TQC-620060 add  #No.FUN-690026 VARCHAR(500)
	l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
l_flag          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
	DEFINE
	li_result       LIKE type_file.num5               #No.FUN-550029  #No.FUN-690026 SMALLINT
        DEFINE l_azw05a LIKE azw_file.azw05  #TQC-C90109 add
        DEFINE l_azw05b LIKE azw_file.azw05  #TQC-C90109 add
 
	INPUT 
	g_imm.imm01,g_imm.imm02,g_imm.imm09,g_imm.imm14,g_imm.imm08,   #FUN-650187 add g_imm.imm08
	g_imn041,
	g_imm.imm07,g_imn151,
	g_imm.immspc,  
	g_imm.immuser,g_imm.immgrup,
	g_imm.immmodu,g_imm.immdate,g_imm.immacti
	WITHOUT DEFAULTS
	FROM
	imm01,imm02,imm09,imm14,imm08,imn041,
	imm07,imn151,immspc,immuser,immgrup,
	immmodu,immdate,immacti

	BEFORE INPUT
	CALL cl_set_docno_format("imm01")
        DISPLAY BY NAME g_imm.immoriu,g_imm.immorig  #TQC-B20171 
 
	BEFORE FIELD imm01
	IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
	NEXT FIELD imm02
	END IF
 
	AFTER FIELD imm01
#調撥單號的處理:
#在輸入單別後, 至單據性質檔中讀取該單別資料;
#若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
#若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
	DISPLAY BY NAME g_imm.imm01
	IF g_imm.imm01 IS NOT NULL THEN
	IF g_imm01_t IS NULL OR g_imm.imm01 != g_imm01_t THEN
	CALL s_check_no("aim",g_imm.imm01,g_imm01_t,"4","imm_file","imm01","")         #No.FUN-540059
	RETURNING li_result,g_imm.imm01
	DISPLAY BY NAME g_imm.imm01
	IF (NOT li_result) THEN
	LET g_imm.imm01=g_imm01_t
	NEXT FIELD imm01
	END IF
 
	END IF
	END IF
	IF g_imm.imm01 != g_imm01_t OR g_imm01_t IS NULL THEN
	SELECT count(*) INTO l_n FROM imm_file
	WHERE imm01 = g_imm.imm01
	IF l_n > 0 THEN   #單據編號重複
CALL cl_err(g_imm.imm01,-239,0)
	LET g_imm.imm01 = g_imm01_t
	DISPLAY BY NAME g_imm.imm01
	NEXT FIELD imm01
	END IF
	END IF
 
	AFTER FIELD imm02     #調撥日期
	IF g_imm.imm02 IS NULL OR g_imm.imm02 = ' ' THEN
	LET g_imm.imm02 = g_today
	DISPLAY BY NAME g_imm.imm02
	NEXT FIELD imm02
	END IF

	IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN
	CALL cl_err('','mfg9999',0) NEXT FIELD imm02
	END IF
 
	AFTER FIELD imm09   #申請人員
	IF g_imm.imm09 IS NOT NULL THEN
	IF g_imm_o.imm09 IS NULL OR g_imm_t.imm09 IS NULL OR
(g_imm.imm09 != g_imm_o.imm09 )
	THEN CALL t700_imm09('a')
	IF NOT cl_null(g_errno) THEN
CALL cl_err(g_imm.imm09,g_errno,0)
	LET g_imm.imm09 = g_imm_o.imm09
	DISPLAY BY NAME g_imm.imm09
	NEXT FIELD imm09
	END IF
	END IF
	LET g_imm_o.imm09 = g_imm.imm09
	END IF
 
	AFTER FIELD imm08   #在途倉
	IF NOT cl_null(g_imm.imm08) THEN
CALL t700_imm08(g_imm.imm08)
	IF NOT cl_null(g_errno) THEN
	CALL cl_err('sel imd:',g_errno,1) 
	NEXT FIELD imm08
	END IF
	END IF
 
	AFTER FIELD imn151  #撥入工廠別
	IF g_imn151 IS NOT NULL OR g_imn151 != ' '  THEN            #FUN-770057
            IF NOT s_chk_plant(g_imn151) THEN
               NEXT FIELD imn151
            END IF
	IF g_imn151 = g_imn041 THEN             #FUN-770057
	LET g_imn151 = g_imn151_o          #FUN-770057
	DISPLAY g_imn151 TO imn151         #FUN-770057
	CALL cl_err(g_imn151,'mfg3454',0)       #FUN-770057
	NEXT FIELD imn151
	END IF

        #TQC-C90109---S---
         LET l_azw05a = ' '  LET l_azw05b = ' '
         SELECT azw05 INTO l_azw05a
           FROM azw_file
          WHERE azw01 = g_imn041
         SELECT azw05 INTO l_azw05b
           FROM azw_file
          WHERE azw01 = g_imn151
         IF l_azw05a = l_azw05b THEN
            CALL cl_err('','aim1162',1)
            NEXT FIELD imn151
         END IF
        #TQC-C90109---E---

	CALL t700_plantnam('a','2',g_imn151)       #FUN-770057
	IF NOT cl_null(g_errno) THEN
	CALL cl_err(g_imn151,g_errno,0)          #FUN-770057
	LET g_imn151 = g_imn151_o                #FUN-770057
	DISPLAY g_imn151 TO imn151               #FUN-770057
	NEXT FIELD imn151
	END IF
#檢查工廠並將新的資料庫放在g_dbs_new
	IF NOT s_chknplt(g_imn151,'AIM','AIM') OR
	NOT s_chknplt(g_imn151,'MFG','MFG')  THEN       #FUN-770057
	LET l_msg = cl_getmsg('aom-303',g_lang)
	LET l_msg = l_msg CLIPPED,g_imn151           #FUN-770057
	LET l_msg = l_msg CLIPPED,cl_getmsg('aom-304',g_lang)
	LET l_msg = l_msg CLIPPED,'AIM or MFG'
CALL cl_err(l_msg,g_errno,0)
	NEXT FIELD imn151
	END IF
	IF g_imn151_t IS NOT NULL AND
	g_imn151_t != g_imn151           #FUN-770057
	THEN LET g_chgplant = 'Y'
	END IF
	END IF
	SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_imn151  #FUN-770057 g_imn.imn151->g_imn151
	LET l_direct ='D'
 
	AFTER FIELD imm14
	IF NOT cl_null(g_imm.imm14) THEN
	SELECT gem02 INTO g_buf FROM gem_file
	WHERE gem01=g_imm.imm14
	AND gemacti='Y'
	IF STATUS THEN
	CALL cl_err3("sel","gem_file",g_imm.imm14,"",SQLCA.sqlcode,"",
			"select gem",1)
	NEXT FIELD imm14
	END IF
	DISPLAY g_buf TO gem02
	END IF
 
	ON ACTION controlp
	CASE
	WHEN INFIELD(imm01) #查詢單據性質
	LET g_t1=s_get_doc_no(g_imm.imm01)    #No.FUN-550029
CALL cl_init_qry_var()
	LET g_chr='4'                         #No.FUN-540059
	LET g_qryparam.state = "c"
	LET g_qryparam.state = 'c' #FUN-980030
	LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
	CALL q_smy(FALSE,FALSE,g_t1,'AIM',g_chr)  #TQC-670008
	RETURNING g_t1
	LET g_imm.imm01=g_t1                  #No.FUN-550029
	DISPLAY BY NAME g_imm.imm01
	NEXT FIELD imm01
 
	WHEN INFIELD(imm09) #申請人員
CALL cl_init_qry_var()
	LET g_qryparam.form     = "q_gen"
	LET g_qryparam.default1 = g_imm.imm09
	CALL cl_create_qry() RETURNING g_imm.imm09
	DISPLAY BY NAME g_imm.imm09
	CALL t700_imm09('d')
	NEXT FIELD imm09
	WHEN INFIELD(imm08) #查詢在途倉
CALL cl_init_qry_var()
	LET g_qryparam.form     ="q_imd"
	LET g_qryparam.default1 = g_imm.imm08
	LET g_qryparam.arg1     = "W"
        LET g_qryparam.arg2     = g_plant   #MOD-BC0029 add
	CALL cl_create_qry() RETURNING g_imm.imm08
	DISPLAY BY NAME g_imm.imm08
	NEXT FIELD imm08
	WHEN INFIELD(imn151) #工廠別
CALL cl_init_qry_var()
	#LET g_qryparam.form     = "q_azr"          #MOD-B80348 mark
	LET g_qryparam.form     = "q_azp"           #MOD-B80348 add
	LET g_qryparam.default1 = g_imn151          #FUN-770057 g_imn.imn151 -> g_imn151  
	CALL cl_create_qry() RETURNING g_imn151     #FUN-770057 g_imn.imn151 -> g_imn151
	DISPLAY g_imn151 TO imn151                  #FUN-770057 g_imn.imn151 -> g_imn151
	NEXT FIELD imn151
	WHEN INFIELD(imm14)
CALL cl_init_qry_var()
	LET g_qryparam.form ="q_gem"
	LET g_qryparam.default1 = g_imm.imm14
	CALL cl_create_qry() RETURNING g_imm.imm14
	DISPLAY BY NAME g_imm.imm14
	NEXT FIELD imm14
	OTHERWISE EXIT CASE
	END CASE
 
	ON ACTION mntn_doc_pty
	LET l_cmd="asmi300 'aim' "
CALL cl_cmdrun(l_cmd CLIPPED)
 
	ON ACTION CONTROLR
CALL cl_show_req_fields()
 
	ON ACTION CONTROLG
CALL cl_cmdask()
 
	ON ACTION CONTROLF                        # 欄位說明
	CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
	CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
	AFTER INPUT
	IF INT_FLAG THEN EXIT INPUT  END IF
	LET l_flag='N'
	IF g_imm.imm01 IS NULL OR g_imm.imm01 = ' ' THEN
	LET l_flag='Y'
	DISPLAY BY NAME g_imm.imm01
	END IF
	IF g_imn151 IS NULL OR g_imn151 = ' '            #FUN-770057
	THEN LET l_flag = 'Y'
	DISPLAY g_imn151   TO  imn151  #FUN-770057
	END IF
	IF g_imn041 IS NULL OR g_imn041 = ' '            #FUN-770057
	THEN LET l_flag = 'Y'
	DISPLAY g_imn041 TO imn041
	END IF
	IF l_flag='Y' THEN
	CALL cl_err('','9033',0)
	NEXT FIELD imm01
	END IF
	ON IDLE g_idle_seconds
CALL cl_on_idle()
	CONTINUE INPUT
 
	ON ACTION about         #MOD-4C0121
	CALL cl_about()      #MOD-4C0121
 
	ON ACTION help          #MOD-4C0121
	CALL cl_show_help()  #MOD-4C0121
 
 
	END INPUT
	END FUNCTION
 
 
 
FUNCTION t700_imm09(p_cmd)  #申請人員
        DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_gen02   LIKE gen_file.gen02,
	l_gen03   LIKE gen_file.gen03,
	l_gem02   LIKE gem_file.gem02,
	l_genacti LIKE gen_file.genacti
 
	LET g_errno = ' '
	SELECT gen02,gen03,genacti
	INTO l_gen02,l_gen03,l_genacti
	FROM gen_file WHERE gen01 = g_imm.imm09
	CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
	LET l_gen02 = NULL
	WHEN l_genacti='N' LET g_errno = '9028'
	OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
	SELECT gem02 INTO l_gem02
	FROM gem_file WHERE gem01=l_gen03
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
	DISPLAY l_gen02 TO FORMONLY.gen02
        LET g_imm.imm14 = l_gen03          #TQC-790022
        DISPLAY l_gen03 TO imm14           #TQC-790022
        DISPLAY l_gem02 TO FORMONLY.gem02  #TQC-790022
	END IF
	END FUNCTION
 
 
	FUNCTION t700_imm08(p_imm08)  #在途倉
	DEFINE p_imm08   LIKE imm_file.imm08,
	l_imd10   LIKE imd_file.imd10,
	l_imdacti LIKE imd_file.imdacti
 
	LET g_errno = ''
	LET l_imd10 = ''
	SELECT imdacti,imd10 INTO l_imdacti,l_imd10
	FROM imd_file WHERE imd01=p_imm08
	IF SQLCA.sqlcode=0 AND l_imd10 <> 'W' AND l_imdacti='Y' THEN
	LET g_errno='asf-724'
	RETURN
	END IF
	CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1100'
	LET l_imdacti = ''
	WHEN l_imdacti='N'        LET g_errno = '9028'
	OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
	END FUNCTION
 
FUNCTION t700_q()
	LET g_row_count = 0
	LET g_curs_index = 0
CALL cl_navigator_setting(g_curs_index,g_row_count)
	INITIALIZE g_imm.* TO NULL             #No.FUN-680046
	CALL cl_opmsg('q')
	MESSAGE ""
	DISPLAY '   ' TO FORMONLY.cnt
	CALL t700_cs()                          # 宣告 SCROLL CURSOR
	IF INT_FLAG THEN
	LET INT_FLAG = 0
	CLEAR FORM
	RETURN
	END IF
	OPEN t700_count
	FETCH t700_count INTO g_row_count
	DISPLAY g_row_count TO FORMONLY.cnt
OPEN t700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
	IF SQLCA.sqlcode THEN
CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
	INITIALIZE g_imm.* TO NULL
	ELSE
	CALL t700_fetch('F')                # 讀出TEMP第一筆並顯示
	END IF
	END FUNCTION
 
FUNCTION t700_fetch(p_flag)
	DEFINE
p_flag          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
	CASE p_flag
	WHEN 'N' FETCH NEXT     t700_cs INTO g_imm.imm01
	WHEN 'P' FETCH PREVIOUS t700_cs INTO g_imm.imm01
	WHEN 'F' FETCH FIRST    t700_cs INTO g_imm.imm01
	WHEN 'L' FETCH LAST     t700_cs INTO g_imm.imm01
	WHEN '/'
	IF (NOT g_no_ask) THEN
	CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
	LET INT_FLAG = 0  ######add for prompt bug
	PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
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
	FETCH ABSOLUTE g_jump t700_cs INTO g_imm.imm01
	LET g_no_ask = FALSE
	END CASE
 
	IF SQLCA.sqlcode THEN
CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
	INITIALIZE g_imm.* TO NULL  #TQC-6B0105
	RETURN
	ELSE
	CASE p_flag
	WHEN 'F' LET g_curs_index = 1
	WHEN 'P' LET g_curs_index = g_curs_index - 1
	WHEN 'N' LET g_curs_index = g_curs_index + 1
	WHEN 'L' LET g_curs_index = g_row_count
	WHEN '/' LET g_curs_index = g_jump          --改g_jump
	END CASE
	CALL cl_navigator_setting(g_curs_index, g_row_count)    #No.MOD-480115
	END IF
 
	SELECT * INTO g_imm.* FROM imm_file          # 重讀DB,因TEMP有不被更新特性
	WHERE imm01 = g_imm.imm01
	IF SQLCA.sqlcode THEN
	CALL cl_err3("sel","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
	ELSE
	LET g_data_owner = g_imm.immuser #FUN-4C0053
	LET g_data_group = g_imm.immgrup #FUN-4C0053
	LET g_data_plant = g_imm.immplant #FUN-980030
       #CALL t700_show()                      # 重新顯示   #MOD-BC0029 mark
	END IF
        CALL t700_show()   #MOD-BC0029
END FUNCTION
FUNCTION t700_show()
 
	LET g_imm_t.* = g_imm.*
	DISPLAY BY NAME
	g_imm.imm01,  g_imm.imm02,  g_imm.imm09, g_imm.imm14, g_imm.imm08,   #FUN-650187 add g_imm.imm08
	g_imm.imm07, #FUN-670093
	g_imm.immspc,  #FUN-680010
	g_imm.immuser,g_imm.immgrup,
	g_imm.immmodu,g_imm.immdate,g_imm.immacti
	CALL cl_set_field_pic("","","","","",g_imm.immacti)
 
	CALL t700_imm09('d')
 
CALL t700_b_fill(g_wc2)  
	SELECT DISTINCT imn041,imn151 INTO g_imn041,g_imn151
	FROM imn_file WHERE imn01 = g_imm.imm01
	LET g_imn041_t = g_imn041
	LET g_imn041_o = g_imn041
	LET g_imn151_t = g_imn151
	LET g_imn151_o = g_imn151
	DISPLAY g_imn041 TO imn041
	DISPLAY g_imn151 TO imn151
	CALL t700_plantnam('d','1',g_imn041)
	CALL t700_plantnam('d','2',g_imn151)
 
CALL cl_show_fld_cont()   #FUN-550037(smin)
	END FUNCTION
 
FUNCTION t700_u()
	DEFINE l_n          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	l_sql,l_wc   STRING,
	l_azp03      LIKE azp_file.azp03,
	l_dbs        LIKE imn_file.imn151,
	l_t1         LIKE smy_file.smyslip   #No.FUN-550029 #No.FUN-690026 VARCHAR(5)
	DEFINE l_imn RECORD LIKE imn_file.*   #FUN-770057
        DEFINE l_legal  LIKE azw_file.azw02  #FUN-980004 add
        DEFINE l_imni  RECORD LIKE imni_file.*  #FUN-B70074
 
	IF g_imm.imm01 IS NULL THEN
	CALL cl_err('',-400,0)        #No.MOD-7A0039 modify
	RETURN
	END IF
	SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
	IF g_imm.immacti ='N' THEN    #檢查資料是否為無效
	CALL cl_err3("sel","imm_file",g_imm.imm01,"","mgf1000","","",1)  #No.FUN-660156
	RETURN
	END IF
	SELECT COUNT(*) INTO l_n FROM imn_file
	WHERE imn01=g_imm.imm01 AND imn12 IN ('Y','y')
#---->已經過撥出確認動作,不可修改
	IF l_n IS NOT NULL AND l_n > 0  THEN
	CALL cl_err('','mfg6070',0)
	RETURN
	END IF
	LET l_t1=s_get_doc_no(g_imm.imm01)                     #No.FUN-550029
	SELECT * INTO g_smy.* FROM smy_file  WHERE smyslip=l_t1
	MESSAGE ""
	CALL cl_opmsg('u')
	LET g_imm01_t = g_imm.imm01
	LET g_success = 'Y'
	BEGIN WORK
 
	OPEN t700_curl USING g_imm.imm01
	IF STATUS THEN
	CALL cl_err("OPEN t700_curl:", STATUS, 1)
	CLOSE t700_curl
	ROLLBACK WORK
	RETURN
	END IF
	FETCH t700_curl INTO g_imm.*               # 對DB鎖定
	IF SQLCA.sqlcode THEN
CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
	CLOSE t700_curl ROLLBACK WORK RETURN
	END IF
	LET g_imm_t.*=g_imm.*
	LET g_imm_o.*=g_imm.*
	LET g_imm.immmodu = g_user         #修改者
	LET g_imm.immdate = g_today        #修改日期
	LET g_chgplant ='N'
	CALL t700_show()                          # 顯示最新資料
	WHILE TRUE
	CALL t700_i("u")                      # 欄位更改
	IF INT_FLAG THEN
	LET INT_FLAG = 0
	LET g_imm.* = g_imm_t.*
CALL t700_show()
	CALL cl_err('',9001,0)
	EXIT WHILE
	END IF
#---宣告一個抓舊的撥入工廠別的 cursor modi in 99/10/12 NO:0699
	LET l_sql = ''  LET l_wc = ''
	LET l_wc = " SELECT unique(imn151) FROM imn_file",
	" WHERE imn01 ='",g_imm.imm01,"'"
	PREPARE imm_dbs_pre FROM l_wc
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_chg_dbs',SQLCA.sqlcode,1)
	END IF
	DECLARE imm_chg_dbs CURSOR FOR imm_dbs_pre
 
	OPEN imm_chg_dbs
	FETCH imm_chg_dbs INTO l_dbs
	IF g_imm.imm01 != g_imm01_t AND g_chgplant ='N' THEN
           {&}         #IF g_imn.imn04 IS NULL THEN LET g_imn.imn04 = ' ' END IF
           UPDATE imn_file SET imn01=g_imm.imm01
           WHERE imn01=g_imm01_t
           IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","imn_file",g_imm01_t,"",SQLCA.sqlcode,"",
                		"",1)  #No.FUN-660156
               LET  g_success ='N'
               CONTINUE WHILE
           ELSE
               SELECT azp03 INTO l_azp03  FROM azp_file
                WHERE azp01 = l_dbs
               LET g_dbs_new = s_dbstring(l_azp03 CLIPPED)
                
                LET g_plant_new = l_dbs
                LET l_plant_new = g_plant_new
                CALL s_getdbs()    
                CALL s_gettrandbs()
                LET l_dbs_tra = g_dbs_tra
    
              #LET l_sql = "UPDATE ",l_dbs_tra CLIPPED,"imn_file",  #FUN-980093 add  #FUN-A50102
               LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'imn_file'),    #FUN-A50102
                           " SET imn01 = '",g_imm.imm01,"'",
                           " WHERE imn01 = ?"
       	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
                           PREPARE imm_chg FROM l_sql
                           IF SQLCA.sqlcode THEN
                           CALL cl_err('imm_chg',SQLCA.sqlcode,1)
                           END IF
    
               #---->更新調撥單資料(撥入廠)
                   EXECUTE imm_chg USING g_imm01_t
                   IF SQLCA.sqlcode THEN
                       LET g_success = 'N'
                       CALL cl_err('imm_chg:ckp',SQLCA.sqlcode,1)
                       EXIT WHILE
                       END IF
                       END IF
                   ELSE
                       UPDATE imn_file SET imn01=g_imm.imm01,
                       imn151=g_imn151
                       WHERE imn01=g_imm01_t
                       IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","imn_file",g_imm01_t,"",SQLCA.sqlcode,"",
                               	    "",1)  #No.FUN-660156
                           LET  g_success ='N'
                           CONTINUE WHILE
                       ELSE
#------------------------------------------------#
#       處理舊工廠別的調撥單將其刪除             #
#------------------------------------------------#
 
#抓取舊工廠別(未修改前)的database NO:0699
    SELECT azp03 INTO l_azp03  FROM azp_file
    WHERE azp01 = l_dbs
    IF NOT cl_null(l_azp03) THEN
    LET g_dbs = s_dbstring(l_azp03 CLIPPED)
    END IF
 
    LET g_plant_new = l_dbs
    LET l_plant_new = g_plant_new
    CALL s_getdbs()    
    CALL s_gettrandbs()
    LET l_dbs_tra = g_dbs_tra
 
#---->刪除舊工廠別的調撥單號單頭
   #LET l_sql = "DELETE FROM ",l_dbs_tra CLIPPED,"imm_file", #FUN-980093 add  #FUN-A50102
    LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant_new,'imm_file'),   #FUN-A50102
    " WHERE imm01 = '",g_imm01_t,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
    PREPARE imm_ur_h FROM l_sql
    IF SQLCA.sqlcode THEN
    CALL cl_err('imm_r_h',SQLCA.sqlcode,1)
    END IF
    EXECUTE imm_ur_h
    IF SQLCA.sqlcode THEN
    LET g_success = 'N'
    CALL cl_err('imm_r_h:ckp#',SQLCA.sqlcode,1)
    END IF
 
#---->刪除舊工廠別的調撥單號單身
   #LET l_sql = "DELETE FROM ",l_dbs_tra CLIPPED,"imn_file", #FUN-980093 add   #FUN-A50102
    LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant_new,'imn_file'),    #FUN-A50102
    " WHERE imn01 = '",g_imm01_t,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
    PREPARE imm_ur_b FROM l_sql
    IF SQLCA.sqlcode THEN
    CALL cl_err('imm_r_b',SQLCA.sqlcode,1)
    END IF
    EXECUTE imm_ur_b
    IF SQLCA.sqlcode THEN
    LET g_success = 'N'
    CALL cl_err('imm_r_b:ckp#',SQLCA.sqlcode,1)
    #FUN-B70074-add-str--
    ELSE
       IF NOT s_industry('std') THEN 
          IF NOT s_del_imni(g_imm01_t,'',l_plant_new) THEN
             LET g_success = 'N'
          END IF
       END IF
    #FUN-B70074-add-end--
    END IF
    END IF
 
#------------------------------------------------#
#      處理新工廠別的調撥單將新增此調撥單資料    #
#------------------------------------------------#
    LET l_sql = "SELECT * FROM imn_file " ,
    " WHERE imn01 ='",g_imm01_t,"'"
    PREPARE imm_uadd_pre  FROM l_sql
    IF SQLCA.sqlcode THEN
    CALL cl_err('imm_uadd_pre',SQLCA.sqlcode,1)
    END IF
    DECLARE imm_uadd_cur  CURSOR FOR imm_uadd_pre  #No.5736
 
#--抓取新工廠別(修改後)的Database NO:0699
    SELECT azp03 INTO l_azp03  FROM azp_file
    WHERE azp01 = g_imn151
    IF NOT cl_null(l_azp03) THEN
    LET g_dbs_new = s_dbstring(l_azp03 CLIPPED)
    LET l_plant_new = g_imn151   #FUN-A50102
	END IF
{ckp#1}      #---->產生調撥單單頭資料(撥入廠)
        CALL t700_cur(g_imn151)                      #NO.TQC-920089 #FUN-980093 add
        CALL s_getlegal(g_imn151) RETURNING l_legal #FUN-980004 add
	EXECUTE imm_cur USING 
	g_imm.imm01,g_imm.imm02,g_imm.imm03,g_imm.imm04,g_imm.imm05,
	g_imm.imm06,g_imm.imm07,g_imm.imm08,g_imm.imm09,g_imm.imm10,
	g_imm.imm11,g_imm.imm12,g_imm.imm13,g_imm.imm14,
	g_imm.immacti,g_imm.immconf,g_imm.immdate,g_imm.immdays,
	g_imm.immgrup,g_imm.immmodu,g_imm.immprit,g_imm.immuser,g_imn151,l_legal,g_user,g_grup #TQC-A10060   #FUN-980004 add g_imn151,l_legal
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #NO.TQC-790093
	   LET g_success = 'N'
	   CALL cl_err('imm_cur:ckp#1',SQLCA.sqlcode,0)
	END IF
	FOREACH imm_uadd_cur INTO l_imn.*   #FUN-770057
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_uadd_cur',SQLCA.sqlcode,1)
	EXIT FOREACH
	END IF
{ckp#2}        #---->產生調撥單單身資料(撥入廠)
	EXECUTE imn_cur USING 
	l_imn.imn01, l_imn.imn02, l_imn.imn03, l_imn.imn041, 
	l_imn.imn04, l_imn.imn05, l_imn.imn06, l_imn.imn07,
	l_imn.imn08, l_imn.imn09, l_imn.imn091,l_imn.imn092,
	l_imn.imn10, l_imn.imn11, l_imn.imn12, 
	l_imn.imn15, l_imn.imn151,l_imn.imn16,
	l_imn.imn17, l_imn.imn18, l_imn.imn19, l_imn.imn20,
	l_imn.imn201,l_imn.imn202,l_imn.imn21, l_imn.imn22,
	l_imn.imn23, l_imn.imn24, 
	l_imn.imn27, l_imn.imn28, l_imn.imn29, l_imn.imn30,
	l_imn.imn31, l_imn.imn32, l_imn.imn33, l_imn.imn34,
	l_imn.imn35, l_imn.imn40, l_imn.imn41, l_imn.imn42,
	l_imn.imn43, l_imn.imn44, l_imn.imn45, l_imn.imn51,
	l_imn.imn52, l_imn.imn9301,l_imn.imn9302
	IF SQLCA.sqlcode THEN
	LET g_success = 'N'
	CALL cl_err('imn_cur:ckp#2',SQLCA.sqlcode,0)
	EXIT FOREACH
        #FUN-B70074-add-str--
        ELSE
           IF NOT s_industry('std') THEN
              INITIALIZE l_imni.* TO NULL
              LET l_imni.imni01 = l_imn.imn01
              LET l_imni.imni02 = l_imn.imn02
              IF NOT s_ins_imni(l_imni.*,l_plant_new) THEN
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
        #FUN-B70074-add-end--
	END IF
	END FOREACH
	END IF
 
 
 
	UPDATE imm_file SET imm_file.* = g_imm.*    # 更新DB
	WHERE imm01 = g_imm01_t               # COLAUTH?
	IF SQLCA.sqlcode THEN
	CALL cl_err3("upd","imm_file",g_imm_t.imm01,"",SQLCA.sqlcode,"",
			"",1)  #No.FUN-660156
	CONTINUE WHILE
	ELSE
	FOREACH imm_chg_dbs INTO l_dbs
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_dbs#ckp',SQLCA.sqlcode,1)
	EXIT FOREACH
	END IF
	SELECT azp03 INTO l_azp03  FROM azp_file
	WHERE azp01 = l_dbs
	IF NOT cl_null(l_azp03) THEN
	LET g_dbs_new = s_dbstring(l_azp03 CLIPPED)
	END IF
 
         LET g_plant_new = l_dbs
         LET l_plant_new = g_plant_new
         CALL s_getdbs()    
         CALL s_gettrandbs()
         LET l_dbs_tra = g_dbs_tra
 
       #LET l_sql = "UPDATE ",l_dbs_tra CLIPPED,"imm_file ",  #FUN-980093 add  #FUN-A50102
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'imm_file'),     #FUN-A50102
	" SET ",
	"imm01  = ?, imm02  = ?, imm03  = ?, imm04  = ?, ",
	"immdays= ?, immprit= ?, ",
	"imm05  = ?, imm06  = ?, ",
	"imm07  = ?, imm08  = ?, imm09  = ?, imm10  = ?,",
	"imm11  = ?, imm12  = ?, imm13  = ?,",
	"immacti= ?, immuser= ?, immgrup= ?, immmodu= ?,",
	"immdate= ?,",
	"immconf= ?,",  #FUN-670093
	"imm14  = ? ",  #FUN-670093
	" WHERE imm01='",g_imm.imm01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
	PREPARE imm_chg_cur FROM l_sql
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_u_cur',SQLCA.sqlcode,1)
	END IF
 
#---->更新調撥單資料(撥入廠)
	EXECUTE imm_chg_cur USING 
	g_imm.imm01,g_imm.imm02,g_imm.imm03,g_imm.imm04,
	g_imm.immdays,g_imm.immprit,
	g_imm.imm05,g_imm.imm06,
	g_imm.imm07,g_imm.imm08,g_imm.imm09,g_imm.imm10,
	g_imm.imm11,g_imm.imm12,g_imm.imm13,
	g_imm.immacti,g_imm.immuser,g_imm.immgrup,g_imm.immmodu,
	g_imm.immdate,
	g_imm.immconf,
	g_imm.imm14 
	IF SQLCA.sqlcode THEN
	LET g_success = 'N'
	CALL cl_err('imm_chg_cur:ckp#',SQLCA.sqlcode,1)
	EXIT WHILE
	END IF
	END FOREACH
	END IF
	EXIT WHILE
	END WHILE
	CLOSE t700_curl
	IF g_success = 'Y'
	THEN CALL cl_cmmsg(4)  COMMIT WORK
	CALL cl_flow_notify(g_imm.imm01,'U')
	ELSE CALL cl_rbmsg(4)  ROLLBACK WORK
	END IF
	MESSAGE " "
	END FUNCTION
 
 
 
FUNCTION t700_x()
	DEFINE
l_chr        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_n          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	l_sql,l_wc   STRING,
	l_azp03      LIKE azp_file.azp03,
	l_dbs        LIKE imn_file.imn151
 
	IF g_imm.imm01 IS NULL THEN
	CALL cl_err('',-400,0)     #No.MOD-7A0039 modify
	RETURN
	END IF
#---->已經過撥出確認動作,不可修改
	SELECT COUNT(*) INTO l_n
	FROM imn_file
	WHERE imn01=g_imm.imm01 AND imn12 IN ('Y','y')
	IF l_n IS NOT NULL AND l_n > 0  THEN
	CALL cl_err('','mfg6072',0)
	RETURN
	END IF
	LET g_success ='Y'
	BEGIN WORK
 
	OPEN t700_curl USING g_imm.imm01
	IF STATUS THEN
	CALL cl_err("OPEN t700_curl:", STATUS, 1)
	CLOSE t700_curl
	ROLLBACK WORK
	RETURN
	END IF
	FETCH t700_curl INTO g_imm.*               # 對DB鎖定
	IF SQLCA.sqlcode THEN
CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
	CLOSE t700_curl ROLLBACK WORK RETURN
	END IF
CALL t700_show()
	IF cl_exp(0,0,g_imm.immacti) THEN
	LET g_chr = g_imm.immacti
	IF g_imm.immacti = 'Y' THEN
	LET g_imm.immacti = 'N'
	ELSE
	LET g_imm.immacti = 'Y'
	END IF
	UPDATE imm_file
	SET immacti = g_imm.immacti,
	immmodu = g_user,
	immdate = g_today
	WHERE imm01 = g_imm.imm01
	IF SQLCA.SQLERRD[3] = 0 THEN
	CALL cl_err3("upd","imm_file",g_imm_t.imm01,"",SQLCA.sqlcode,"",
			"",1)  #No.FUN-660156
	LET g_imm.immacti = g_chr
	ELSE
	LET l_sql = ' '  LET l_wc = ' '
	LET l_wc = " SELECT unique(imn151) FROM imn_file",
	" WHERE imn01 ='",g_imm.imm01,"'"
	PREPARE imm_x_dbs_pre FROM l_wc
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_x_dbs_pre',SQLCA.sqlcode,1)
	END IF
	DECLARE imm_x_dbs_cur  CURSOR FOR imm_x_dbs_pre  #No.5736
 
	FOREACH imm_x_dbs_cur INTO l_dbs
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_x_dbs#ckp',SQLCA.sqlcode,1)
	EXIT FOREACH
	END IF
	SELECT azp03 INTO l_azp03  FROM azp_file
	WHERE azp01 = l_dbs
	IF NOT cl_null(l_azp03) THEN
	LET g_dbs_new = s_dbstring(l_azp03 CLIPPED)
	END IF 
 
         LET g_plant_new = l_dbs
         LET l_plant_new = g_plant_new
         CALL s_getdbs()
         CALL s_gettrandbs()
         LET l_dbs_tra = g_dbs_tra
 
       #LET l_sql = "UPDATE ",l_dbs_tra CLIPPED,"imm_file",  #FUN-980093 add  #FUN-A50102
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'imm_file'),    #FUN-A50102
	" SET immacti= ?, immuser= ?, immdate= ? ",
	" WHERE imm01='",g_imm.imm01,"'" clipped
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
	PREPARE imm_x_cur FROM l_sql
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_x_cur',SQLCA.sqlcode,1)
	END IF
 
#---->更新調撥單資料(撥入廠)
	EXECUTE imm_x_cur USING g_imm.immacti,g_user, g_today
	IF SQLCA.sqlcode THEN
	LET g_success = 'N'
	CALL cl_err('imm_x_cur:ckp#',SQLCA.sqlcode,1)
	EXIT FOREACH
	END IF
	END FOREACH
	END IF
	DISPLAY BY NAME g_imm.immacti
	END IF
	CLOSE t700_curl
	IF g_success = 'Y'
	THEN CALL cl_cmmsg(4)  COMMIT WORK
	CALL cl_flow_notify(g_imm.imm01,'V')
	ELSE CALL cl_rbmsg(4)  ROLLBACK WORK
	END IF
	END FUNCTION
 
	FUNCTION t700_r()
DEFINE l_chr        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_sql,l_wc   STRING,
	l_azp03      LIKE azp_file.azp03,
	l_dbs        LIKE imn_file.imn151,
	l_count      LIKE type_file.num10    #No.FUN-690026 INTEGER
 
	IF s_shut(0) THEN RETURN END IF
	IF g_imm.imm01 IS NULL THEN
	CALL cl_err('',-400,0)
	RETURN
	END IF
 
        IF g_imm.immacti = 'N' THEN
           CALL cl_err('','abm-033',0)
           RETURN
        END IF 
	SELECT COUNT(*) INTO l_count
	FROM imn_file WHERE imn01 = g_imm.imm01
	AND imn12 IN ('Y','y')
	IF l_count > 0  THEN    #已經過撥出確認動作,不可修改
	CALL cl_err('','mfg6072',0)
	RETURN
	END IF
	LET g_success ='Y'
	BEGIN WORK
 
	OPEN t700_curl USING g_imm.imm01
	IF STATUS THEN
	CALL cl_err("OPEN t700_curl:", STATUS, 1)
	CLOSE t700_curl
	ROLLBACK WORK
	RETURN
	END IF
	FETCH t700_curl INTO g_imm.*               # 對DB鎖定
	IF SQLCA.sqlcode THEN
CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
	CLOSE t700_curl ROLLBACK WORK RETURN
	END IF
CALL t700_show()
	IF cl_delh(15,16) THEN
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "imm01"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = g_imm.imm01      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
	LET l_sql = ' '  LET l_wc = ' '
	LET l_wc = " SELECT unique(imn151) FROM imn_file",
	" WHERE imn01 ='",g_imm.imm01,"'"
	PREPARE imm_r_dbs_pre FROM l_wc
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_r_dbs_pre',SQLCA.sqlcode,1)
	LET g_success ='N'
	END IF
	DECLARE imm_r_dbs_cur CURSOR FOR imm_r_dbs_pre
 
	FOREACH imm_r_dbs_cur INTO l_dbs
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_r_dbs#ckp',SQLCA.sqlcode,1)
	EXIT FOREACH
	END IF
	SELECT azp03 INTO l_azp03  FROM azp_file
	WHERE azp01 = l_dbs
	IF NOT cl_null(l_azp03) THEN
	LET g_dbs_new = s_dbstring(l_azp03 CLIPPED)
	END IF
         LET g_plant_new = l_dbs
         LET l_plant_new = g_plant_new
         CALL s_gettrandbs()
         LET l_dbs_tra = g_dbs_tra
 
#---->調撥單頭刪除
       #LET l_sql = "DELETE FROM ",l_dbs_tra CLIPPED,"imm_file",  #FUN-980093 add
        LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant_new,'imm_file'),   #FUN-A50102
	" WHERE imm01 = '",g_imm.imm01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
	PREPARE imm_r_h FROM l_sql
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_r_h',SQLCA.sqlcode,1)
	END IF
	EXECUTE imm_r_h
	IF SQLCA.sqlcode THEN
	LET g_success = 'N'
	CALL cl_err('imm_r_h:ckp#',SQLCA.sqlcode,1)
	EXIT FOREACH
	END IF
 
#---->調撥單身刪除
       #LET l_sql = "DELETE FROM ",l_dbs_tra CLIPPED,"imn_file",  #FUN-980093 add   #FUN-A50102
        LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant_new,'imn_file'),     #FUN-A50102
	" WHERE imn01 = '",g_imm.imm01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
	PREPARE imm_r_b FROM l_sql
	IF SQLCA.sqlcode THEN
	CALL cl_err('imm_r_b',SQLCA.sqlcode,1)
	END IF
	EXECUTE imm_r_b
	IF SQLCA.sqlcode THEN
	LET g_success = 'N'
	CALL cl_err('imm_r_b:ckp#',SQLCA.sqlcode,1)
	EXIT FOREACH
        #FUN-B70074-add-str--
        ELSE
           IF NOT s_industry('std') THEN
              IF NOT s_del_imni(g_imm.imm01,'',l_plant_new) THEN
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
        #FUN-B70074-add-end--
	END IF
	END FOREACH
 
	DELETE FROM imm_file WHERE imm01 = g_imm.imm01
	IF SQLCA.SQLERRD[3]=0
	THEN # CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)  #No.FUN-660156
	CALL cl_err3("del","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
			"",1)  #No.FUN-660156
	LET g_success ='N'
	END IF
 
	DELETE FROM imn_file WHERE imn01 = g_imm.imm01
	IF SQLCA.SQLERRD[3]=0 THEN # CALL cl_err(g_imn.imn01,SQLCA.sqlcode,0) #No.FUN-660156
	CALL cl_err3("del","imn_file",g_imm.imm01,"",SQLCA.sqlcode,"",
			"",1)  #No.FUN-660156
	LET g_success ='N'
        #FUN-B70074-add-str--
        ELSE
           #CHI-D10014---begin
           CALL t700_cur(g_imn151)
           FOR g_i = 1 TO g_rec_b
              EXECUTE rvbs_del USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
              IF NOT s_del_rvbs('1',g_imm.imm01,g_imn[g_i].imn02,0)  THEN       
                 ROLLBACK WORK
                 RETURN
              END IF
           END FOR
           #CHI-D10014---end
           IF NOT s_industry('std') THEN
              IF NOT s_del_imni(g_imm.imm01,'','') THEN
                 LET g_success = 'N'
              END IF
           END IF
        #FUN-B70074-add-end--
	END IF
 
	IF g_success = 'Y'
	THEN CALL cl_cmmsg(4)  COMMIT WORK
	CALL cl_flow_notify(g_imm.imm01,'D')
	ELSE CALL cl_rbmsg(4)  ROLLBACK WORK
	END IF
	CLEAR FORM
        CALL g_imn.clear()
        OPEN t700_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t700_cs
           CLOSE t700_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH t700_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t700_cs
           CLOSE t700_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t700_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t700_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE      #No.FUN-6A0067
           CALL t700_fetch('/')
        END IF
	END IF
	CLOSE t700_curl
	END FUNCTION
 
FUNCTION t700_b()
	DEFINE
	l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT  
	l_n             LIKE type_file.num5,         #檢查重複用     
	l_lock_sw       LIKE type_file.chr1,         #單身鎖住否   
	p_cmd           LIKE type_file.chr1,         #處理狀態      
	l_allow_insert  LIKE type_file.chr1,         
	l_allow_delete  LIKE type_file.chr1         
	DEFINE
	l_ime09         LIKE ime_file.ime09,
	l_ima906        LIKE ima_file.ima906,      #No.TQC-620154 add
	t_imf05         LIKE imf_file.imf05,
        l_legal         LIKE azw_file.azw02,    #FUN-980004 add
	l_azp03         LIKE azp_file.azp03,
	sn1,sn2         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	l_flag          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(20)
l_str           LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(80)
	l_sql           STRING,
	l_code          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	l_imaag         LIKE ima_file.imaag,  #No.TQC-650115
	l_imaag1        LIKE ima_file.imaag   #No.TQC-650115
  DEFINE l_imni  RECORD LIKE imni_file.*  #FUN-B70074
  DEFINE l_date         LIKE type_file.dat      #CHI-C50010 add 
  DEFINE l_tf      LIKE type_file.chr1    #FUN-BB0084
   #FUN-C20002--start add------------------------
   DEFINE   l_ima154     LIKE ima_file.ima154
   DEFINE   l_rcj03      LIKE rcj_file.rcj03
   DEFINE   l_rtz07      LIKE rtz_file.rtz07
   DEFINE   l_rtz08      LIKE rtz_file.rtz08
   #FUN-C20002--end add--------------------------    

	LET g_action_choice = ""
	IF s_shut(0) THEN RETURN END IF
	IF g_imm.imm01 IS NULL THEN
	RETURN
	END IF
 
	LET l_allow_insert = cl_detail_input_auth('insert')
	LET l_allow_delete = cl_detail_input_auth('delete')
 
	SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
	IF g_imm.immacti ='N' THEN    #檢查資料是否為無效
	CALL cl_err(g_imm.imm01,'aom-000',0)
	RETURN
	END IF
 
        CALL t700_cur(g_imn151) #FUN-980093 add
 
	CALL cl_opmsg('b')
 
	LET g_forupd_sql = 
	"SELECT imn02,imn03,'',imn29,imn27,'','',imn04,imn05,imn06,imn09, ",
	"       imn9301,'',imn10,imn33,imn34,imn35,imn30,imn31,imn32,",
	"       imn11,imn15,imn16,imn17,imn20,imn9302,'',imn43,imn44,",
	"       imn45,imn40,imn41,imn42,imn23 ",
	"  FROM imn_file ",
	" WHERE imn01=? AND imn02=? FOR UPDATE"
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

	DECLARE t700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
	INPUT ARRAY g_imn WITHOUT DEFAULTS FROM s_imn.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
		INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
	BEFORE ROW
	LET p_cmd = ''
    LET l_ac = ARR_CURR()
	LET l_lock_sw = 'N'            #DEFAULT
 
	BEGIN WORK
	OPEN t700_curl USING g_imm.imm01
	IF STATUS THEN
	   CALL cl_err("OPEN t700_curl:", STATUS, 1)
	   CLOSE t700_curl
	   ROLLBACK WORK
	   RETURN
	END IF
	FETCH t700_curl INTO g_imm.*            # 鎖住將被更改或取消的資料
	IF SQLCA.sqlcode THEN
       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
	   CLOSE t700_curl 
	   ROLLBACK WORK 
	   RETURN
	END IF
	IF g_rec_b >= l_ac THEN
	   LET p_cmd='u'
	   LET g_imn_t.* = g_imn[l_ac].*  #BACKUP
#FUN-BB0084 -------------Begin----------------
           LET g_imn_o.imn30 = g_imn[l_ac].imn30
           LET g_imn_o.imn33 = g_imn[l_ac].imn33
           LET g_imn_o.imn40 = g_imn[l_ac].imn40
           LET g_imn_o.imn43 = g_imn[l_ac].imn43 
#FUN-BB0084 -------------End------------------       
	   OPEN t700_bcl USING g_imm.imm01,g_imn_t.imn02
	   IF STATUS THEN
	      CALL cl_err("OPEN t700_bcl:", STATUS, 1)
	      LET l_lock_sw = "Y"
	   ELSE
          FETCH t700_bcl INTO g_imn[l_ac].* 
	      IF SQLCA.sqlcode THEN
             CALL cl_err(g_imn_t.imn02,SQLCA.sqlcode,1)
	         LET l_lock_sw = "Y"
	      END IF
	      CALL t700_imn03('a')
	      LET g_imn[l_ac].gem02b = s_costcenter_desc(g_imn[l_ac].imn9301) 
              LET g_imn[l_ac].gem02c = s_costcenter_desc(g_imn[l_ac].imn9302) 
	      DISPLAY BY NAME g_imn[l_ac].ima02,g_imn08,g_imn[l_ac].imn05,
	                      g_imn[l_ac].gem02b,g_imn[l_ac].gem02c 
       END IF
       CALL cl_show_fld_cont()     
	END IF
	IF cl_null(g_azp03) THEN
	   SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_imn151
	END IF
 
	BEFORE INSERT
	DISPLAY "BEFORE INSERT"
	LET p_cmd='a'
    LET l_n = ARR_COUNT()
	INITIALIZE g_imn[l_ac].* TO NULL     
	LET g_imn[l_ac].imn29 ='N'                
	LET g_imn[l_ac].imn10 =0          	#預計調撥數量
	LET g_imn[l_ac].imn11 =0           	#實際調撥數量
	LET g_imn12 ='N'            #確認碼
	LET g_imn18 =' '            
	LET g_imn19 =' '            
	LET g_imn21 =1         		#轉換率
	LET g_imn[l_ac].imn23 =0         		#實際撥入數量
	LET g_imn24 ='N'            #撥出確認碼
	LET g_imn25 =' '            #
	LET g_imn28 =' '            #
	LET g_imn[l_ac].imn27 ='N'            #結案否
	LET g_imn[l_ac].imn32 =0
	LET g_imn[l_ac].imn42 =0
	LET g_imn[l_ac].imn35 =0
	LET g_imn[l_ac].imn45 =0
	LET g_imn51 =1
	LET g_imn52 =1
        LET g_imn[l_ac].imn9301=s_costcenter(g_imm.imm14) 
	LET g_imn[l_ac].imn9302=g_imn[l_ac].imn9301
	LET g_imn_t.* = g_imn[l_ac].*         #新輸入資料
#FUN-BB0084 -------------Begin----------------
        LET g_imn_o.imn30 = NULL 
        LET g_imn_o.imn33 = NULL 
        LET g_imn_o.imn40 = NULL
        LET g_imn_o.imn43 = NULL
#FUN-BB0084 -------------End------------------     
    CALL cl_show_fld_cont()     
	NEXT FIELD imn02
 
	AFTER INSERT
	DISPLAY "AFTER INSERT"
	IF INT_FLAG THEN
	CALL cl_err('',9001,0)
	LET INT_FLAG = 0
	LET g_imn[l_ac].* = g_imn_t.*
	CANCEL INSERT
	END IF
	IF cl_null(g_imn[l_ac].imn03) AND cl_null(g_imn[l_ac].imn04) AND cl_null(g_imn[l_ac].imn05) THEN
	LET g_imn[l_ac].* = g_imn_t.*
	EXIT INPUT
	END IF
	IF g_imn[l_ac].imn04 IS NULL THEN LET g_imn[l_ac].imn04 = ' ' END IF
	IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 = ' ' END IF
	IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 = ' ' END IF
CALL t700_du_data_to_correct()
 
 
INSERT INTO imn_file(imn01,imn02,imn03,imn041,imn04,imn05,
		imn06,imn07,imn08,imn09,imn091,imn092,
		imn10,imn11,imn12,imn151,
		imn15,imn16,imn17,imn20,imn201,imn202,
		imn21,imn22,imn23,imn24,imn27,
		imn29,imn30,imn31,imn32,imn33,imn34,imn35,
		imn40,imn41,imn42,imn43,imn44,imn45,
		imn51,imn52,imn9301,imn9302,imnplant,imnlegal)  #FUN-980004 add imnplant,imnlegal                
VALUES(g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03,
		g_imn041,g_imn[l_ac].imn04,g_imn[l_ac].imn05,
		g_imn[l_ac].imn06,g_imn07,g_imn08,
		g_imn[l_ac].imn09,g_imn091,g_imn092,
		g_imn[l_ac].imn10,g_imn[l_ac].imn11,
		g_imn12,g_imn151,
		g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17,
		g_imn[l_ac].imn20,g_imn201,g_imn202,
		g_imn21,g_imn22,g_imn[l_ac].imn23,g_imn24,
		g_imn[l_ac].imn27,g_imn[l_ac].imn29,g_imn[l_ac].imn30,
		g_imn[l_ac].imn31,g_imn[l_ac].imn32,g_imn[l_ac].imn33,
		g_imn[l_ac].imn34,g_imn[l_ac].imn35,g_imn[l_ac].imn40,
		g_imn[l_ac].imn41,g_imn[l_ac].imn42,g_imn[l_ac].imn43,
		g_imn[l_ac].imn44,g_imn[l_ac].imn45,g_imn51,
		g_imn52,g_imn[l_ac].imn9301,g_imn[l_ac].imn9302,g_plant,g_legal #FUN-980004 add g_plant,g_legal
      )
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","imn_file",g_imn[l_ac].imn02,"",SQLCA.sqlcode,"","",1)  
       CANCEL INSERT
       #CHI-D10014---begin
       SELECT ima918,ima921 INTO g_ima918,g_ima921
         FROM ima_file
        WHERE ima01 = g_imn[l_ac].imn03
          AND imaacti = "Y"

       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN
             CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn[l_ac].imn02,SQLCA.sqlcode,"","",1)
             ROLLBACK WORK   
             CANCEL INSERT   
          END IF
          EXECUTE rvbs_del USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
       END IF
       #CHI-D10014---end
	ELSE
           #FUN-B70074-add-str--
           IF NOT s_industry('std') THEN
              INITIALIZE l_imni.* TO NULL
              LET l_imni.imni01 = g_imm.imm01
              LET l_imni.imni02 = g_imn[l_ac].imn02
              IF NOT s_ins_imni(l_imni.*,g_plant) THEN
                 CANCEL INSERT
              END IF
           END IF
           #FUN-B70074-add-end--
     
#---->產生調撥單單身資料(撥入廠)
       CALL s_getlegal(g_imn151) RETURNING l_legal #FUN-980004 add
	   EXECUTE imn_cur USING
	g_imm.imm01,        g_imn[l_ac].imn02, g_imn[l_ac].imn03, 
	g_imn041,           g_imn[l_ac].imn04, g_imn[l_ac].imn05,
	g_imn[l_ac].imn06,  g_imn07,           g_imn08, 
	g_imn[l_ac].imn09,  g_imn091,          g_imn092,
	g_imn[l_ac].imn10,  g_imn[l_ac].imn11, g_imn12,
	g_imn[l_ac].imn15,  g_imn151,          g_imn[l_ac].imn16,
	g_imn[l_ac].imn17,  g_imn18,           g_imn19, 
	g_imn[l_ac].imn20,  g_imn201,          g_imn202,
	g_imn21,            g_imn22,           g_imn[l_ac].imn23, 
	g_imn24,            g_imn[l_ac].imn27, g_imn28,
	g_imn[l_ac].imn29,  g_imn[l_ac].imn30, g_imn[l_ac].imn31, 
	g_imn[l_ac].imn32,  g_imn[l_ac].imn33, g_imn[l_ac].imn34,
	g_imn[l_ac].imn35,  g_imn[l_ac].imn40, g_imn[l_ac].imn41, 
	g_imn[l_ac].imn42,  g_imn[l_ac].imn43, g_imn[l_ac].imn44, 
	g_imn[l_ac].imn45,  g_imn51,           g_imn52, 
	g_imn[l_ac].imn9301,g_imn[l_ac].imn9302,g_imn151,l_legal
	IF SQLCA.sqlcode THEN
	   CALL cl_err('imn_cur:ckp#2',SQLCA.sqlcode,0)
	   CANCEL INSERT
        #FUN-B70074-add-str--
    ELSE
           IF NOT s_industry('std') THEN
              INITIALIZE l_imni.* TO NULL
              LET l_imni.imni01 = g_imm.imm01
              LET l_imni.imni02 = g_imn[l_ac].imn02
              IF NOT s_ins_imni(l_imni.*,l_plant_new) THEN
                 CANCEL INSERT
              END IF
           END IF
        #FUN-B70074-add-end--
	END IF
	MESSAGE 'INSERT O.K'
	LET g_rec_b=g_rec_b+1
	DISPLAY g_rec_b TO FORMONLY.cn2  
	END IF
 
 
	BEFORE DELETE                            #是否取消單身
        #MOD-B80212 --- modify --- start ---
        IF g_imn[l_ac].imn11 > 0 THEN
           CALL cl_err('','aim1012',1)
           CANCEL DELETE
        END IF
        #MOD-B80212 --- modify ---  end  ---
	IF g_imn_t.imn02 > 0 AND
	g_imn_t.imn02 IS NOT NULL THEN
	IF NOT cl_delb(0,0) THEN
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "imm01"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = g_imm.imm01      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
	CANCEL DELETE
	END IF
	IF l_lock_sw = "Y" THEN 
	CALL cl_err("", -263, 1) 
	CANCEL DELETE 
	END IF 
	DELETE FROM imn_file
	WHERE imn01 = g_imm.imm01 AND
	imn02 = g_imn_t.imn02
	IF SQLCA.sqlcode THEN
	CALL cl_err3("del","imn_file",g_imn_t.imn02,"",SQLCA.sqlcode,"","",1)  
	ROLLBACK WORK
	CANCEL DELETE
	ELSE
        #FUN-B70074-add-str--
           IF NOT s_industry('std') THEN
              IF NOT s_del_imni(g_imm.imm01,g_imn_t.imn02,'') THEN
                 ROLLBACK WORK      
                 CANCEL DELETE
              END IF
           END IF
        #FUN-B70074-add-end--
           #CHI-D10014---begin
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_imn[l_ac].imn03
                AND imaacti = "Y"

             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045
                   CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                EXECUTE rvbs_del USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
             END IF
           #CHI-D10014---end
         LET g_plant_new = g_imn151
         LET l_plant_new = g_plant_new
         CALL s_gettrandbs()
         LET l_dbs_tra = g_dbs_tra
        #LET l_sql = "DELETE FROM ",l_dbs_tra CLIPPED,"imn_file",  #FUN-980093 add  #FUN-A50102
        LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant_new,'imn_file'),     #FUN-A50102
	                " WHERE imn01 = ? AND imn02 =? " CLIPPED
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
	PREPARE imn_r_cur FROM l_sql
	IF SQLCA.sqlcode THEN
	CALL cl_err('imn_u_cur',SQLCA.sqlcode,0)
	END IF
#---->刪除調撥單單頭資料(撥入廠)
	EXECUTE imn_r_cur  USING g_imm.imm01,g_imn_t.imn02
	IF SQLCA.sqlcode THEN
	CALL cl_err('imn_r_cur:ckp#4',SQLCA.sqlcode,0)
	ROLLBACK WORK
	CANCEL DELETE
        #FUN-B70074-add-str--
        ELSE
           IF NOT s_industry('std') THEN
              IF NOT s_del_imni(g_imm.imm01,g_imn_t.imn02,l_plant_new) THEN
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
           END IF
        #FUN-B70074-add-end--
	END IF
	END IF
	LET g_rec_b=g_rec_b-1
	DISPLAY g_rec_b TO FORMONLY.cn2  
	MESSAGE "Delete Ok"
	CLOSE t700_bcl
	COMMIT WORK
	END IF
 
	ON ROW CHANGE
	DISPLAY "ON ROW CHANGE"
	IF INT_FLAG THEN                 #新增程式段
	CALL cl_err('',9001,0)
	LET INT_FLAG = 0
	LET g_imn[l_ac].* = g_imn_t.*
	CLOSE t700_bcl
	ROLLBACK WORK
	EXIT INPUT
	END IF
 
	IF l_lock_sw = 'Y' THEN
         CALL cl_err(g_imn[l_ac].imn02,-263,1)
	LET g_imn[l_ac].* = g_imn_t.*
	ELSE
	IF g_imn[l_ac].imn04 IS NULL THEN LET g_imn[l_ac].imn04 = ' ' END IF
	IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 = ' ' END IF
	IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 = ' ' END IF
CALL t700_du_data_to_correct()
 
	UPDATE imn_file SET  
	imn02=g_imn[l_ac].imn02,
	imn03=g_imn[l_ac].imn03,
	imn04=g_imn[l_ac].imn04,
	imn05=g_imn[l_ac].imn05,
	imn06=g_imn[l_ac].imn06,
	imn07=g_imn07,
	imn08=g_imn08,
	imn09=g_imn[l_ac].imn09,
	imn091=g_imn091,
	imn092=g_imn092,
	imn10=g_imn[l_ac].imn10,
	imn11=g_imn[l_ac].imn11, 
	imn12=g_imn12,
	imn13=g_imn13,
	imn14=g_imn14,
	imn151=g_imn151,
	imn15=g_imn[l_ac].imn15,
	imn16=g_imn[l_ac].imn16,
	imn17=g_imn[l_ac].imn17,
	imn20=g_imn[l_ac].imn20,
	imn201=g_imn201,
	imn202=g_imn202,
	imn21 =g_imn21 ,
	imn22 =g_imn22 ,
	imn23 =g_imn[l_ac].imn23 ,
	imn24 =g_imn24 ,
	imn26 =g_imn26 ,
	imn27 =g_imn[l_ac].imn27 ,
	imn29 =g_imn[l_ac].imn29 ,
	imn30 =g_imn[l_ac].imn30 ,
	imn31 =g_imn[l_ac].imn31 ,
	imn32 =g_imn[l_ac].imn32 ,
	imn33 =g_imn[l_ac].imn33 ,
	imn34 =g_imn[l_ac].imn34 ,
	imn35 =g_imn[l_ac].imn35 ,
	imn40 =g_imn[l_ac].imn40 ,
	imn41 =g_imn[l_ac].imn41 ,
	imn42 =g_imn[l_ac].imn42 ,
	imn43 =g_imn[l_ac].imn43 ,
	imn44 =g_imn[l_ac].imn44 ,
	imn45 =g_imn[l_ac].imn45 ,
	imn51 =g_imn51 ,
	imn52 =g_imn52 ,
	imn9301=g_imn[l_ac].imn9301,
	imn9302=g_imn[l_ac].imn9302               
	WHERE imn01=g_imm.imm01 
	AND imn02=g_imn_t.imn02
	IF SQLCA.sqlcode THEN
	CALL cl_err3("upd","imn_file",g_imn[l_ac].imn02,"",SQLCA.sqlcode,"","",1)  
	LET g_imn[l_ac].* = g_imn_t.*
	CLOSE t700_bcl
	ROLLBACK WORK
	ELSE
         LET g_plant_new = g_imn151
         LET l_plant_new = g_plant_new
         CALL s_gettrandbs()
         LET l_dbs_tra = g_dbs_tra
       #LET l_sql = "UPDATE ",l_dbs_tra CLIPPED,"imn_file",  #FUN-980093 add  #FUN-A50102
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'imn_file'),    #FUN-A50102
	" SET imn01= ?, imn02= ?, imn03= ?,",
	"imn041= ?, imn04 = ?, imn05 = ?, ",
	"imn06 = ?, imn07 = ?, imn08 = ?, ",
	"imn09 = ?, imn091= ?, imn092= ?, ",
	"imn10 = ?, imn11 = ?, imn12 = ?, ",
	"imn13 = ?, imn14 = ?, imn151= ?, ",
	"imn15 = ?, imn16 = ?, imn17 = ?, ",
	"imn18 = ?, imn19 = ?, imn20 = ?, ",
	"imn201= ?, imn202= ?, imn21 = ?, ",
	"imn22 = ?, imn23 = ?, imn24 = ?, ",
	"imn25 = ?, imn26 = ?, imn27 = ?,  ",
	"imn28 = ?, imn30 = ?, imn31 = ?, ",
	"imn32 = ?, imn33 = ?, imn34 = ?, ",
	"imn35 = ?, imn40 = ?, imn41 = ?, ",
	"imn42 = ?, imn43 = ?, imn44 = ?, ",
	"imn45 = ?, imn51 = ?, imn52 = ?, ",
	"imn29 = ?,", 
	"imn9301 = ? , imn9302 = ? ",  
	" WHERE imn01='",g_imm.imm01,"' AND ",
	"       imn02= ",g_imn_t.imn02 CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
	PREPARE imn_u_cur FROM l_sql
	IF SQLCA.sqlcode THEN
	CALL cl_err('imn_u_cur',SQLCA.sqlcode,0)
	END IF
#---->更新調撥單單頭資料(撥入廠)
	EXECUTE imn_u_cur USING
	g_imm.imm01, g_imn[l_ac].imn02, g_imn[l_ac].imn03, 
	g_imn041,g_imn[l_ac].imn04, g_imn[l_ac].imn05, 
	g_imn[l_ac].imn06, g_imn07, g_imn08,
	g_imn[l_ac].imn09, g_imn091,g_imn092,
	g_imn[l_ac].imn10, g_imn[l_ac].imn11, g_imn12, 
	g_imn13, g_imn14, g_imn151,
	g_imn[l_ac].imn15, g_imn[l_ac].imn16, g_imn[l_ac].imn17,
	g_imn18, g_imn19, g_imn[l_ac].imn20,
	g_imn201,g_imn202,g_imn21,
	g_imn22, g_imn[l_ac].imn23, g_imn24,
	g_imn25, g_imn26, g_imn[l_ac].imn27,
	g_imn28, g_imn[l_ac].imn30, g_imn[l_ac].imn31,
	g_imn[l_ac].imn32, g_imn[l_ac].imn33, g_imn[l_ac].imn34,
	g_imn[l_ac].imn35, g_imn[l_ac].imn40, g_imn[l_ac].imn41,
	g_imn[l_ac].imn42, g_imn[l_ac].imn43, g_imn[l_ac].imn44,
	g_imn[l_ac].imn45, g_imn51, g_imn52,
	g_imn[l_ac].imn29,
	g_imn[l_ac].imn9301,g_imn[l_ac].imn9302
	IF SQLCA.sqlcode THEN
	CALL cl_err('imn_u_cur:ckp#3',SQLCA.sqlcode,0)
	CLOSE t700_bcl
	ROLLBACK WORK
	ELSE
	MESSAGE 'UPDATE O.K'
	CLOSE t700_bcl
	COMMIT WORK
	END IF
	END IF
	END IF
 
	AFTER ROW
	   DISPLAY "AFTER  ROW"
           LET l_ac = ARR_CURR()
	  #LET l_ac_t = l_ac    #FUN-D40030 Mark
 
	   IF INT_FLAG THEN                 
	      CALL cl_err('',9001,0)
	      LET INT_FLAG = 0
          #CHI-D10014---begin
          IF p_cmd='a' AND l_ac <= g_imn.getLength() THEN   
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_imn[l_ac].imn03
                AND imaacti = "Y"
             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN 
                   CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,SQLCA.sqlcode,"","",1)
                END IF
                EXECUTE rvbs_del USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
             END IF
          END IF
          #CHI-D10014---end
	      IF p_cmd = 'u' THEN
	         LET g_imn[l_ac].* = g_imn_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_imn.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
	      END IF
 
	      CLOSE t700_bcl
	      ROLLBACK WORK
	      EXIT INPUT
	   END IF
           LET l_ac_t = l_ac    #FUN-D40030 Add
	   CLOSE t700_bcl
	   COMMIT WORK
 
	BEFORE FIELD imn02
	IF (g_imn[l_ac].imn02 IS NULL OR g_imn[l_ac].imn02 = 0 OR
			g_imn_t.imn02 != g_imn[l_ac].imn02)
	THEN SELECT max(imn02)+1 INTO g_imn[l_ac].imn02
	FROM imn_file
	WHERE imn01 = g_imm.imm01
	IF g_imn[l_ac].imn02 IS NULL OR g_imn[l_ac].imn02 = ' ' THEN
	LET g_imn[l_ac].imn02 = 1
	END IF
	DISPLAY BY NAME g_imn[l_ac].imn02
	END IF
 
	AFTER FIELD imn02     #項次
	IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
	(p_cmd = "u" AND (g_imm.imm01 != g_imm01_t OR
			  g_imn[l_ac].imn02 != g_imn_t.imn02)) THEN
	SELECT count(*) INTO l_n FROM imn_file
	WHERE imn01 = g_imm.imm01
	AND imn02 = g_imn[l_ac].imn02
	IF l_n > 0 THEN                  # Duplicated
	LET g_msg=g_imm.imm01 CLIPPED,'+',g_imn[l_ac].imn02
CALL cl_err(g_msg,-239,0)
	LET g_imn[l_ac].imn02 = g_imn02_t
	DISPLAY BY NAME g_imn[l_ac].imn02
	NEXT FIELD imn02
	END IF
	END IF
 
	BEFORE FIELD imn03
	IF g_sma.sma60 = 'Y' THEN
	CALL s_inp5(11,42,g_imn[l_ac].imn03) RETURNING g_imn[l_ac].imn03
	DISPLAY BY NAME g_imn[l_ac].imn03
	IF INT_FLAG THEN LET INT_FLAG = 0 END IF
	END IF
	CALL t700_set_entry_b()
        CALL t700_set_no_required()
 
	AFTER FIELD imn03             #料件編號
        LET l_tf = NULL               #FUN-BB0084
	IF g_imn[l_ac].imn03 IS NULL OR g_imn[l_ac].imn03 = ' ' THEN
        	NEXT FIELD imn03
	ELSE
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_imn[l_ac].imn03,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD imn03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
	     SELECT imaag,imaag1 INTO l_imaag,l_imaag1 FROM ima_file                                                                            
	     WHERE ima01 =g_imn[l_ac].imn03                                                                                          
	     IF NOT CL_null(l_imaag) AND l_imaag <> '@CHILD' THEN 
	        CALL cl_err(g_imn[l_ac].imn03,'aim1004',0)                                                                      
	        NEXT FIELD imn03                                                                                                
	     END IF
	     IF g_sma.sma120 ='Y' AND g_sma.sma907 ='Y' THEN                                                                   
	        LET g_t1 =g_imm.imm01[1,g_doc_len]                                                                             
	        SELECT smy62 INTO g_smy62 FROM smy_file                                                                        
                WHERE smyslip =g_t1  
	        IF NOT cl_null(g_smy62) THEN
	           IF g_smy62 <> l_imaag1 THEN
	              CALL cl_err('','atm-525',0)
                      NEXT FIELD imn03
	           END IF
	           IF cl_null(l_imaag1) THEN
	              CALL cl_err('','atm-525',0)
	              NEXT FIELD imn03
	           END IF
	        END IF
	     END IF
             IF g_imn_o.imn03 IS NULL OR
                (g_imn_o.imn03 != g_imn[l_ac].imn03) THEN
                 CALL t700_imn03('a')
               IF NOT cl_null(g_errno)  THEN
                   CALL cl_err(g_imn[l_ac].imn03,g_errno,0)
                   LET g_imn[l_ac].imn03 = g_imn_o.imn03
                   DISPLAY BY NAME g_imn[l_ac].imn03
 
                   NEXT FIELD imn03
               END IF
               IF g_sma.sma115 = 'Y' THEN
                   CALL s_chk_va_setting(g_imn[l_ac].imn03)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD imn03
                   END IF
                   IF g_ima906 = '3' THEN
                      LET g_imn[l_ac].imn33=g_ima907
                      LET g_imn[l_ac].imn43=g_ima907
                      DISPLAY BY NAME g_imn[l_ac].imn33
                      DISPLAY BY NAME g_imn[l_ac].imn43
                   #FUN-BB0084 ---------------Begin---------------
                      IF NOT cl_null(g_imn[l_ac].imn45) THEN
                         LET g_imn[l_ac].imn45 = s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)
                      END IF
                      CALL t700_imn35_chk(p_cmd) RETURNING l_tf 
                   #FUN-BB0084 ---------------End-----------------
                   END IF
               END IF
              END IF
         END IF
	LET g_imn_o.imn03=g_imn[l_ac].imn03
	CALL t700_set_no_entry_b()
        CALL t700_set_required()
#FUN-BB0084 -------------------Begin-------------------
        IF NOT cl_null(l_tf) AND NOT l_tf THEN
           NEXT FIELD imn35
        END IF 
#FUN-BB0084 -------------------End---------------------
 
	BEFORE FIELD imn04
	IF g_sma.sma12 ='N' THEN
	IF g_sma.sma115='Y' THEN
	IF g_ima906 = '1' THEN
	NEXT FIELD imn30
	ELSE
	NEXT FIELD imn33
	END IF
	ELSE
	NEXT FIELD imn10
	END IF
	END IF
 
	AFTER FIELD imn04  #倉庫
	IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn04 = ' ' THEN
	NEXT FIELD imn04
	END IF
        #FUN-D20060----add---str--
        IF NOT cl_null(g_imn[l_ac].imn04) THEN
           IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                           g_imn[l_ac].imn04, g_imn[l_ac].imn05) THEN
              NEXT FIELD imn04
           END IF
        END IF
        #FUN-D20060----add---end--
        #FUN-C20002--start add------------------------
        IF NOT cl_null(g_imn[l_ac].imn04) THEN
           IF g_azw.azw04 = '2' THEN
              SELECT ima154 INTO l_ima154
                FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
              IF l_ima154 = 'Y' AND g_imn[l_ac].imn03[1,4] <> 'MISC' THEN
                 SELECT rcj03 INTO l_rcj03
                   FROM rcj_file
                  WHERE rcj00 = '0'

                 #FUN-C90049 mark begin---
                 #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                 #  FROM rtz_file
                 # WHERE rtz01 = g_plant
                 #FUN-C90049 mark end-----

                 CALL s_get_defstore(g_plant,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08     #FUN-C90049 add            

                  IF l_rcj03 = '1' THEN
                     IF g_imn[l_ac].imn04 <> l_rtz07 THEN
                        CALL cl_err('','aim1142',0)
                        LET g_imn[l_ac].imn04 = g_imn_t.imn04
                        NEXT FIELD imn04
                     END IF
                  ELSE
                     IF g_imn[l_ac].imn04 <> l_rtz08 THEN
                        CALL cl_err('','aim1143',0)
                        LET g_imn[l_ac].imn04 = g_imn_t.imn04
                        NEXT FIELD imn04
                     END IF
                  END IF
              END IF
           END IF
        END IF 
        #FUN-C20002--end add--------------------------  
#---->依系統參數的設定,檢查倉庫的使用
	IF NOT s_stkchk(g_imn[l_ac].imn04,'A') THEN
	CALL cl_err(g_imn[l_ac].imn04,'mfg6076',0)
	LET g_imn[l_ac].imn04 = g_imn_o.imn04
	DISPLAY BY NAME g_imn[l_ac].imn04
	NEXT FIELD imn04
	END IF
#---->檢查倉庫是否為可用倉
	CALL s_swyn(g_imn[l_ac].imn04) RETURNING sn1,sn2
	IF sn1=1 THEN
	CALL cl_err(g_imn[l_ac].imn04,'mfg6080',1)
	END IF
	IF sn2=2 THEN
	CALL cl_err(g_imn[l_ac].imn04,'mfg6085',1)
	END IF
	LET sn1=0     LET sn2=0
	LET g_imn_o.imn04 = g_imn[l_ac].imn04
 
	AFTER FIELD imn05  #儲位
	IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 = ' ' END IF
#------------------------------------ 檢查料號預設倉儲及單別預設倉儲
        IF g_imn[l_ac].imn04 IS NOT NULL THEN  #FUN-D20060 add
           IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                          g_imn[l_ac].imn04, g_imn[l_ac].imn05) THEN
              NEXT FIELD imn04
           END IF
        END IF   #FUN-D20060 add
	IF g_imn[l_ac].imn05 IS NOT NULL THEN
#---->檢查儲位是否為可用
	CALL  s_lwyn(g_imn[l_ac].imn04,g_imn[l_ac].imn05) RETURNING sn1,sn2
	IF sn1=1 THEN
	CALL cl_err(g_imn[l_ac].imn05,'mfg6081',1)
	END IF
	IF sn2=2 THEN
	CALL cl_err(g_imn[l_ac].imn05,'mfg6086',0)
	END IF
	LET sn1 = 0  LET sn2 = 0
	END IF
 
	BEFORE FIELD imn06  #批號
	IF g_sma.sma12 = 'N' THEN
	NEXT FIELD imn03
	END IF
 
	AFTER FIELD imn06  #批號
	IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 = ' ' END IF
#---->檢查是否存在[庫存資料明細檔]中
        #MOD-B80136 --- modify --- start ---
	#IF g_imn_o.imn06 IS NULL OR g_imn_o.imn06 = ' '
	#OR (g_imn[l_ac].imn06 != g_imn_o.imn06 ) THEN
        IF p_cmd='a' OR (p_cmd='u' AND (g_imn_o.imn06 IS NULL OR g_imn_o.imn06 = ' ')
        OR (g_imn[l_ac].imn06 != g_imn_o.imn06 )) THEN
        #MOD-B80136 --- modify ---  end  ---
	CALL t700_imn06('a')
	IF NOT cl_null(g_errno) THEN
CALL cl_err(g_imn[l_ac].imn06,g_errno,0)
	DISPLAY BY NAME g_imn[l_ac].imn06
	NEXT FIELD imn04
	END IF
	SELECT img09 INTO g_img09_s FROM img_file
	WHERE img01=g_imn[l_ac].imn03
	AND img02=g_imn[l_ac].imn04
	AND img03=g_imn[l_ac].imn05
	AND img04=g_imn[l_ac].imn06
	IF SQLCA.sqlcode THEN
	CALL cl_err3("sel","img_file",g_imn[l_ac].imn04,"",SQLCA.sqlcode,"","",1)
	NEXT FIELD imn04
	END IF
	IF g_sma.sma115 = 'Y' THEN
	IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
	g_imn_t.imn04 IS NULL OR g_imn[l_ac].imn04 <> g_imn_t.imn04 OR
	g_imn_t.imn05 IS NULL OR g_imn[l_ac].imn05 <> g_imn_t.imn05 OR
	g_imn_t.imn06 IS NULL OR g_imn[l_ac].imn06 <> g_imn_t.imn06 THEN
	CALL t700_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn04,
			g_imn[l_ac].imn05,g_imn[l_ac].imn06,'')
	RETURNING g_imn[l_ac].imn33,g_imn[l_ac].imn34,g_imn[l_ac].imn35,
	g_imn[l_ac].imn30,g_imn[l_ac].imn31,g_imn[l_ac].imn32
	DISPLAY BY NAME g_imn[l_ac].imn33
	DISPLAY BY NAME g_imn[l_ac].imn34
	DISPLAY BY NAME g_imn[l_ac].imn35
	DISPLAY BY NAME g_imn[l_ac].imn30
	DISPLAY BY NAME g_imn[l_ac].imn31
	DISPLAY BY NAME g_imn[l_ac].imn32
	END IF
	END IF
	END IF
	LET g_imn_o.imn06 = g_imn[l_ac].imn06
 
	AFTER FIELD imn10  #預撥數量
           IF g_imn[l_ac].imn10 <= 0 THEN
              CALL cl_err('','aim-988',0)
              NEXT FIELD imn10
           END IF
#FUN-BB0084 ------------------Begin-----------------
           IF NOT cl_null(g_imn[l_ac].imn10) AND NOT cl_null(g_imn[l_ac].imn09) THEN
              IF cl_null(g_imn_o.imn10) OR g_imn_o.imn10! = g_imn[l_ac].imn10 THEN
                 LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)
                 DISPLAY BY NAME g_imn[l_ac].imn10
              END IF
           END IF
#FUN-BB0084 ------------------End-------------------
#庫存量不足時顯示警告訊息
           IF g_imn[l_ac].imn10 > g_qty THEN
              CALL cl_getmsg('mfg6075',g_lang) RETURNING l_str
              IF NOT cl_prompt(0,0,l_str) THEN
                 NEXT FIELD imn10
              END IF
           END IF
           #CHI-D10014---begin
           SELECT ima918,ima921 INTO g_ima918,g_ima921
             FROM ima_file
            WHERE ima01 = g_imn[l_ac].imn03
              AND imaacti = "Y"
           IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
              (cl_null(g_imn_t.imn10) OR (g_imn[l_ac].imn10<>g_imn_t.imn10 )) THEN
                 CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,
                               g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                               g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                               g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                               g_imn[l_ac].imn10,'','MOD',-1) 
                     RETURNING l_r,g_qty
                 IF l_r = "Y" THEN
                    LET g_imn[l_ac].imn10 = g_qty
                 END IF
                 DISPLAY BY NAME g_imn[l_ac].imn10
                 EXECUTE rvbs_del USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
                 EXECUTE rvbs_cur USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
           END IF
           #CHI-D10014---end
           LET g_imn22 = g_imn[l_ac].imn10 * g_imn21
           LET g_imn22 = s_digqty(g_imn22,g_imn[l_ac].imn20)  #FUN-BB0084
           LET g_imn_o.imn10 = g_imn[l_ac].imn10
 
	BEFORE FIELD imn33
           CALL t700_set_no_required()
 
	AFTER FIELD imn33  #第二單位
	IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
	IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
	   g_imn[l_ac].imn06 IS NULL THEN
	   NEXT FIELD imn04
	END IF
	IF NOT cl_null(g_imn[l_ac].imn33) THEN
	   SELECT gfe02 INTO g_buf FROM gfe_file
	    WHERE gfe01=g_imn[l_ac].imn33
	      AND gfeacti='Y'
	IF STATUS THEN
	CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn33,"",SQLCA.sqlcode,"",
			"gfe",1)  #No.FUN-660156
	NEXT FIELD imn33
	END IF
	CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
			g_img09_s,g_imn[l_ac].imn33,g_ima906)
	RETURNING g_errno,g_factor
	IF NOT cl_null(g_errno) THEN
       CALL cl_err(g_imn[l_ac].imn33,g_errno,0)
	NEXT FIELD imn33
	END IF
	IF cl_null(g_imn_t.imn33) OR g_imn_t.imn33 <> g_imn[l_ac].imn33 THEN
       	LET g_imn[l_ac].imn34 = g_factor
	END IF
	CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
			g_imn[l_ac].imn05,g_imn[l_ac].imn06,
			g_imn[l_ac].imn33) RETURNING g_flag
	IF g_flag = 1 THEN
	CALL cl_err('sel imgg:',STATUS,0)
	NEXT FIELD imn33
	END IF
	END IF
        CALL t700_set_required()
	LET g_imn_t.imn33=g_imn[l_ac].imn33
    #FUN-BB0084 ------------Begin---------------
        IF NOT t700_imn35_chk(p_cmd) THEN
           LET g_imn_o.imn33 = g_imn[l_ac].imn33
           NEXT FIELD imn35
        END IF 
        LET g_imn_o.imn33 = g_imn[l_ac].imn33
    #FUN-BB0084 ------------End-----------------
 
	BEFORE FIELD imn35
	IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
	IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
	g_imn[l_ac].imn06 IS NULL THEN
	NEXT FIELD imn04
	END IF
	IF NOT cl_null(g_imn[l_ac].imn33) AND g_ima906 = '3' THEN
	CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
			g_img09_s,g_imn[l_ac].imn33,g_ima906)
	RETURNING g_errno,g_factor
	IF NOT cl_null(g_errno) THEN
           CALL cl_err(g_imn[l_ac].imn33,g_errno,0)
	NEXT FIELD imn33
	END IF
	IF cl_null(g_imn_t.imn33) OR g_imn_t.imn33 <> g_imn[l_ac].imn33 THEN
	LET g_imn[l_ac].imn34 = g_factor
	END IF
	CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
			g_imn[l_ac].imn05,g_imn[l_ac].imn06,
			g_imn[l_ac].imn33) RETURNING g_flag
	IF g_flag = 1 THEN
	CALL cl_err('sel img:',STATUS,0)
	NEXT FIELD imn04
	END IF
	END IF
 
	AFTER FIELD imn35  #第二數量
#FUN-BB0084 -------------Begin----------------
        IF NOT t700_imn35_chk(p_cmd) THEN
           NEXT FIELD imn35
        END IF
#FUN-BB0084 -------------End------------------
#FUN-BB0084 -------------Begin----------------
#	IF NOT cl_null(g_imn[l_ac].imn35) THEN
#	IF g_imn[l_ac].imn35 < 0 THEN
#	CALL cl_err('','aim-391',0)  #
#	NEXT FIELD imn35
#	END IF
#       IF p_cmd = 'a' THEN
#           IF g_ima906='3' THEN
#              LET g_tot=g_imn[l_ac].imn35*g_imn[l_ac].imn34
#              IF cl_null(g_imn[l_ac].imn32) OR g_imn[l_ac].imn32=0 THEN #CHI-960022
#                 LET g_imn[l_ac].imn32=g_tot*g_imn[l_ac].imn31
#                 DISPLAY BY NAME g_imn[l_ac].imn32                      #CHI-960022
#              END IF                                                    #CHI-960022
#           END IF
#        END IF
#        END IF
#FUN-BB0084 -------------End------------------
 
	BEFORE FIELD imn30
           CALL t700_set_no_required()
 
	AFTER FIELD imn30  #第一單位
	   IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
	   IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
          g_imn[l_ac].imn06 IS NULL THEN
	      NEXT FIELD imn04
	   END IF
	   IF NOT cl_null(g_imn[l_ac].imn30) THEN
	      SELECT gfe02 INTO g_buf FROM gfe_file
	       WHERE gfe01=g_imn[l_ac].imn30
	         AND gfeacti='Y'
	      IF STATUS THEN
	         CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn30,"",SQLCA.sqlcode,"","gfe:",1)  
	         NEXT FIELD imn30
	      END IF
          CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
               g_imn[l_ac].imn09,g_imn[l_ac].imn30,'1')
              RETURNING g_errno,g_factor
	      IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_imn[l_ac].imn30,g_errno,0)
	          NEXT FIELD imn30
          END IF
	      IF cl_null(g_imn_t.imn30) OR g_imn_t.imn30 <> g_imn[l_ac].imn30 THEN
	         LET g_imn[l_ac].imn31 = g_factor
	      END IF
	      IF g_ima906 = '2' THEN
	         CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
			                 g_imn[l_ac].imn05,g_imn[l_ac].imn06,
			                 g_imn[l_ac].imn30) RETURNING g_flag
	         IF g_flag = 1 THEN
	            CALL cl_err('sel img:',STATUS,0)
	            NEXT FIELD imn30
	         END IF
	      END IF
	   END IF
       CALL t700_set_required()
	   LET g_imn_t.imn30=g_imn[l_ac].imn30
#FUN-BB0084 -----------Begin----------
       IF NOT t700_imn32_chk() THEN
          LET g_imn_o.imn30 = g_imn[l_ac].imn30
          NEXT FIELD imn32
       END IF    
       LET g_imn_o.imn30 = g_imn[l_ac].imn30
#FUN-BB0084 -----------End------------
 
	AFTER FIELD imn32  #第一數量
#FUN-BB0084 -----------Begin----------
       IF NOT t700_imn32_chk() THEN
          NEXT FIELD imn32
       END IF    
#FUN-BB0084 -----------End------------           
#FUN-BB0084 -----------Begin----------
#	IF NOT cl_null(g_imn[l_ac].imn32) THEN
#	IF g_imn[l_ac].imn32 < 0 THEN
#	CALL cl_err('','aim-391',0)  #
#	NEXT FIELD imn32
#	END IF
#	END IF
#FUN-BB0084 -----------End------------    
    #CHI-D10014---begin
       SELECT ima918,ima921 INTO g_ima918,g_ima921
         FROM ima_file
        WHERE ima01 = g_imn[l_ac].imn03
          AND imaacti = "Y"

       IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
          (p_cmd = 'a' OR g_imn[l_ac].imn35<>g_imn_t.imn35 OR g_imn[l_ac].imn32 <> g_imn_t.imn32 ) THEN
             CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,
                           g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                           g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                           g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                           g_imn[l_ac].imn10,'','MOD',-1) 
                 RETURNING l_r,g_qty
             IF l_r = "Y" THEN
                LET g_imn[l_ac].imn10 = g_qty
             END IF
             #LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
             #DISPLAY BY NAME g_imn[l_ac].imn22
             EXECUTE rvbs_del USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
             EXECUTE rvbs_cur USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
       END IF
    #CHI-D10014---end
    
	BEFORE FIELD imn15
	IF t700_qty_issue() THEN
           NEXT FIELD imn35
	END IF
        CALL t700_set_origin_field()
        DISPLAY BY NAME g_imn[l_ac].imn09   #FUN-BB0084
        DISPLAY BY NAME g_imn[l_ac].imn10   #FUN-BB0084
	IF g_sma.sma12 ='N' THEN
	   NEXT FIELD imn03
	END IF
 
#No.FUN-570249  --end
 
 
	AFTER FIELD imn15  #倉庫
	IF NOT cl_null(g_imn[l_ac].imn15) THEN
           #FUN-D20060----add---str--
           IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                           g_imn[l_ac].imn15, g_imn[l_ac].imn16) THEN
              NEXT FIELD imn15
           END IF
           #FUN-D20060----add---end--
           #FUN-C20002--start add------------------------
           IF g_azw.azw04 = '2' THEN
              SELECT ima154 INTO l_ima154
                FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
              IF l_ima154 = 'Y' AND g_imn[l_ac].imn03[1,4] <> 'MISC' THEN
                 SELECT rcj03 INTO l_rcj03
                   FROM rcj_file
                  WHERE rcj00 = '0'

                 #FUN-C90049 mark begin---
                 #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                 #  FROM rtz_file
                 # WHERE rtz01 = g_imn151
                 #FUN-C90049 mark end-----

                 CALL s_get_defstore(g_imn151,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add

                  IF l_rcj03 = '1' THEN
                     IF g_imn[l_ac].imn15 <> l_rtz07 THEN
                        CALL cl_err('','aim1142',0)
                        LET g_imn[l_ac].imn15 = g_imn_t.imn15
                        NEXT FIELD imn15
                     END IF
                  ELSE
                     IF g_imn[l_ac].imn15 <> l_rtz08 THEN
                        CALL cl_err('','aim1143',0)
                        LET g_imn[l_ac].imn15 = g_imn_t.imn15
                        NEXT FIELD imn15
                     END IF
                  END IF
              END IF
           END IF
           #FUN-C20002--end add--------------------------  
#------>check-1
IF NOT s_imfchk12(g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn151)   #No.FUN-980059
	THEN CALL cl_err(g_imn[l_ac].imn15,'mfg9036',0)
	NEXT FIELD imn15
	END IF
#------>check-2
	CALL  s_stkchk2(g_imn151,g_imn[l_ac].imn15,'A') RETURNING l_code   #FUN-980020
	IF NOT l_code THEN
CALL cl_err(g_imn[l_ac].imn15,l_code,1)
	NEXT FIELD imn15
	END IF
	CALL  s_swyn1(g_imn[l_ac].imn15,g_imn151) RETURNING sn1,sn2 #FUN-980093 add
	IF sn1=1 THEN
	CALL cl_err(g_imn[l_ac].imn15,'mfg6080',1)
	NEXT FIELD imn15
	ELSE IF sn2=2 THEN
	CALL cl_err(g_imn[l_ac].imn15,'mfg6085',0)
	NEXT FIELD imn15
	END IF
	END IF
	END IF
 
	AFTER FIELD imn16  #儲位
#控管是否為全型空白
	IF g_imn[l_ac].imn16 ='　' THEN #全型空白
	LET g_imn[l_ac].imn16 =' '
	END IF
        #FUN-D20060----add---str--
        IF NOT cl_null(g_imn[l_ac].imn15) THEN
           IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                           g_imn[l_ac].imn15, g_imn[l_ac].imn16) THEN
              NEXT FIELD imn15
           END IF
        END IF
        #FUN-D20060----add---end--
 
#------>chk-1
       #IF NOT s_imfchk11(g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_azp03) THEN   #No.FUN-980059
	IF NOT s_imfchk11(g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn151) THEN  #No.FUN-980059
	CALL cl_err(g_imn[l_ac].imn16,'mfg6095',0)
	NEXT FIELD imn16
	END IF
#------>chk-2
CALL s_hqty1(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
		#g_imn[l_ac].imn16,g_azp03) #FUN-980093 mark
		g_imn[l_ac].imn16,g_imn151) #FUN-980093 add
	RETURNING g_cnt,h_qty,t_imf05
CALL  s_lwyn1(g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn151) #FUN-980093 add
	RETURNING sn1,sn2
	IF sn1=1 THEN
	CALL cl_err(g_imn[l_ac].imn16,'mfg6081',0)
	NEXT FIELD imn16
	ELSE IF sn2=2 THEN
	CALL cl_err(g_imn[l_ac].imn16,'mfg6086',0)
	NEXT FIELD imn16
	END IF
	END IF
	LET sn1=0 LET sn2=0
	IF g_imn[l_ac].imn16 IS NULL THEN LET g_imn[l_ac].imn16=' ' END IF
 
	AFTER FIELD imn17
# 控管是否為全型空白
           IF cl_null(g_imn[l_ac].imn15) AND cl_null(g_imn[l_ac].imn16) AND cl_null(g_imn[l_ac].imn17) THEN  #FUN-770057 add 倉儲批空白的不寫入
              NEXT FIELD imn15
           END IF   #FUN-770057
	IF g_imn[l_ac].imn17 ='　' THEN #全型空白
	LET g_imn[l_ac].imn17 =' '
	END IF
	IF g_imn[l_ac].imn17 IS NULL THEN
	LET g_imn[l_ac].imn17 = ' '
	END IF
         LET g_plant_new = g_imn151
         LET l_plant_new = g_plant_new
         CALL s_gettrandbs()
         LET l_dbs_tra = g_dbs_tra
       #LET l_sql="SELECT img09 FROM ",l_dbs_tra,"img_file",   #TQC-950003 ADD  #FUN-980093 add  #FUN-A50102
        LET l_sql="SELECT img09 FROM ",cl_get_target_table(l_plant_new,'img_file'),   #FUN-A50102
	" WHERE img01='",g_imn[l_ac].imn03 CLIPPED,"' AND",
	" img02='",g_imn[l_ac].imn15 CLIPPED,"' AND",
	" img03='",g_imn[l_ac].imn16 ,"' AND",
	" img04='",g_imn[l_ac].imn17 ,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-A50102
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
	PREPARE t700_prex_pre FROM l_sql
	DECLARE t700_prex CURSOR FOR t700_prex_pre
	OPEN t700_prex
	FETCH t700_prex INTO g_imn[l_ac].imn20
{+}     IF SQLCA.sqlcode THEN
	  IF NOT cl_confirm('mfg1401') THEN NEXT FIELD imn15 END IF
         #CHI-C50010 str add-----
          SELECT img18 INTO l_date FROM img_file
           WHERE img01 = g_imn[l_ac].imn03
             AND img02 = g_imn[l_ac].imn04
             AND img03 = g_imn[l_ac].imn05
             AND img04 = g_imn[l_ac].imn06
          CALL s_mdate_record(l_date,'Y')
         #CHI-C50010 end add-----
          CALL s_madd_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn[l_ac].imn16,
		g_imn[l_ac].imn17,g_imm.imm01,g_imn[l_ac].imn02,
		g_imm.imm02,g_imn151)                                        #No.FUN-980081  
          IF g_errno='N' THEN NEXT FIELD imn17 END IF
          #LET l_sql="SELECT img09 FROM ",l_dbs_tra,"img_file",    #TQC-950003 ADD  #FUN-980093 add  #FUN-A50102
           LET l_sql="SELECT img09 FROM ",cl_get_target_table(l_plant_new,'img_file'),   #FUN-A50102
                " WHERE img01='",g_imn[l_ac].imn03 CLIPPED,"' AND",
                " img02='",g_imn[l_ac].imn15 CLIPPED,"' AND",
                " img03='",g_imn[l_ac].imn16 CLIPPED,"' AND",
                " img04='",g_imn[l_ac].imn17 CLIPPED,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
                PREPARE t700_prex_apre FROM l_sql
                DECLARE t700_aprex CURSOR FOR t700_prex_apre
                OPEN t700_aprex
                FETCH t700_aprex INTO g_imn[l_ac].imn20
                IF SQLCA.sqlcode THEN
                CALL cl_err('sel img09',SQLCA.sqlcode,0)
                NEXT FIELD imn15
          END IF
        END IF
	DISPLAY BY NAME g_imn[l_ac].imn09
       #MOD-CA0009---mark---S
       #IF NOT s_actimg1(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
       #	g_imn[l_ac].imn16,g_imn[l_ac].imn17,g_imn151) #FUN-980093 add
       #THEN CALL cl_err('inactive','mfg6117',0)
       #     NEXT FIELD imn15
       #END IF
       #MOD-CA0009---mark---E
	DISPLAY BY NAME g_imn[l_ac].imn20
        LET l_azp03 = t700_catstr(g_azp03)
	IF g_sma.sma115 ='N' THEN
          IF g_imn[l_ac].imn09 != g_imn[l_ac].imn20 THEN
             CALL s_umfchk1(g_imn[l_ac].imn03,g_imn[l_ac].imn09,
                            g_imn[l_ac].imn20,g_imn151)  #No.FUN-980059
             RETURNING g_cnt,g_imn21
             IF g_cnt = 1 THEN
                CALL cl_err('','mfg3075',1)
                NEXT FIELD imn17
             END IF
          ELSE
            LET g_imn21=1
          END IF
          LET g_imn22=g_imn[l_ac].imn10*g_imn21
          LET g_imn22=s_digqty(g_imn22,g_imn[l_ac].imn20)   #FUN-BB0084
        ELSE
          IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
             g_imn_t.imn15 IS NULL OR g_imn[l_ac].imn15 <> g_imn_t.imn15 OR
             g_imn_t.imn16 IS NULL OR g_imn[l_ac].imn16 <> g_imn_t.imn16 OR
             g_imn_t.imn17 IS NULL OR g_imn[l_ac].imn17 <> g_imn_t.imn17 THEN
             CALL t700_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn15,
	                          g_imn[l_ac].imn16,g_imn[l_ac].imn17,g_imn151) #FUN-980093 add
             RETURNING g_imn[l_ac].imn43,g_imn[l_ac].imn44,g_imn[l_ac].imn45,
	               g_imn[l_ac].imn40,g_imn[l_ac].imn41,g_imn[l_ac].imn42
	     DISPLAY BY NAME g_imn[l_ac].imn43
	     DISPLAY BY NAME g_imn[l_ac].imn44
	     DISPLAY BY NAME g_imn[l_ac].imn45
	     DISPLAY BY NAME g_imn[l_ac].imn40
	     DISPLAY BY NAME g_imn[l_ac].imn41
	     DISPLAY BY NAME g_imn[l_ac].imn42
	  END IF
	END IF
	LET g_img09_t=g_imn[l_ac].imn20
 
	BEFORE FIELD imn43
        CALL t700_set_no_required()
 
	AFTER FIELD imn43  #第二單位
	IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
	IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
	g_imn[l_ac].imn17 IS NULL THEN
	NEXT FIELD imn15
	END IF
	IF NOT cl_null(g_imn[l_ac].imn43) THEN
          CALL t700_unit(g_imn[l_ac].imn43,g_imn151) #FUN-980093 add
	IF NOT cl_null(g_errno) THEN
	CALL cl_err('gfe:',STATUS,0)
	LET g_imn[l_ac].imn43=g_imn_t.imn43
	DISPLAY BY NAME g_imn[l_ac].imn43
	NEXT FIELD imn40
	END IF
	CALL s_du_umfchk1(g_imn[l_ac].imn03,'','','',
			g_img09_t,g_imn[l_ac].imn43,g_ima906,g_imn151)  #No.FUN-980059
	RETURNING g_errno,g_factor
	IF NOT cl_null(g_errno) THEN
CALL cl_err(g_imn[l_ac].imn43,g_errno,0)
	NEXT FIELD imn43
	END IF
	IF cl_null(g_imn_t.imn43) OR g_imn_t.imn43 <> g_imn[l_ac].imn43 THEN
	LET g_imn[l_ac].imn44 = g_factor
	DISPLAY BY NAME g_imn[l_ac].imn44
	END IF
CALL s_umfchk1(g_imn[l_ac].imn03,g_imn[l_ac].imn33,g_imn[l_ac].imn43,g_imn151)  #No.FUN-980059
	RETURNING g_flag,g_factor
	IF g_flag = 1 THEN
	LET g_msg=g_imn[l_ac].imn03,' ',g_imn[l_ac].imn33,' ',g_imn[l_ac].imn43
	CALL cl_err(g_msg CLIPPED,'mfg3075',1)
	NEXT FIELD imn43
	ELSE
	LET g_imn52=g_factor
	END IF
	CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
			g_imn[l_ac].imn16,g_imn[l_ac].imn17,
			g_imn[l_ac].imn43,g_imn151) RETURNING g_flag #FUN-980093 add
	IF g_flag = 1 THEN
	IF g_sma.sma892[3,3] = 'Y' THEN
	IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn43 END IF
	END IF
CALL s_madd_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
		g_imn[l_ac].imn16,g_imn[l_ac].imn17,
		g_imn[l_ac].imn43,g_imn[l_ac].imn44,
		g_imm.imm01,g_imn[l_ac].imn02,0,g_imn151) #FUN-980093 add
RETURNING g_flag
IF g_flag = 1 THEN
NEXT FIELD imn43
END IF
END IF
        LET g_imn[l_ac].imn45=g_imn[l_ac].imn35*g_imn52
        LET g_imn[l_ac].imn45=s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)   #FUN-BB0084
        DISPLAY BY NAME g_imn[l_ac].imn45 #g_imm.immoriu,g_imm.immorig,
	END IF
        CALL t700_set_required()
	LET g_imn_t.imn43=g_imn[l_ac].imn43
 
	BEFORE FIELD imn40
	IF g_ima906 = '3' THEN
	IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
	IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
	g_imn[l_ac].imn17 IS NULL THEN
	NEXT FIELD imn15
	END IF
	IF NOT cl_null(g_imn[l_ac].imn43) AND g_ima906 = '3' THEN
	CALL s_du_umfchk1(g_imn[l_ac].imn03,'','','',
			g_img09_t,g_imn[l_ac].imn43,g_ima906,g_imn151)  #No.FUN-980059
	RETURNING g_errno,g_factor
	IF NOT cl_null(g_errno) THEN
CALL cl_err(g_imn[l_ac].imn43,g_errno,0)
	NEXT FIELD imn43
	END IF
	IF cl_null(g_imn_t.imn43) OR g_imn_t.imn43 <> g_imn[l_ac].imn43 THEN
	LET g_imn[l_ac].imn44 = g_factor
	DISPLAY BY NAME g_imn[l_ac].imn44
	END IF
	LET g_factor =1
CALL s_umfchk1(g_imn[l_ac].imn03,g_imn[l_ac].imn33,g_imn[l_ac].imn43,g_imn151)  #No.FUN-980059
	RETURNING g_flag,g_factor
	LET g_imn52=g_factor
	CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
			g_imn[l_ac].imn16,g_imn[l_ac].imn17,
			g_imn[l_ac].imn43,g_imn151) RETURNING g_flag #FUN-980093 add
	IF g_flag = 1 THEN
	IF g_sma.sma892[3,3] = 'Y' THEN
	IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn15 END IF
	END IF
CALL s_madd_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
		g_imn[l_ac].imn16,g_imn[l_ac].imn17,
		g_imn[l_ac].imn43,g_imn[l_ac].imn44,
		g_imm.imm01,g_imn[l_ac].imn02,0,g_imn151) #FUN-980093 add
RETURNING g_flag
IF g_flag = 1 THEN
NEXT FIELD imn15
END IF
END IF
    LET g_imn[l_ac].imn45=g_imn[l_ac].imn35*g_imn52
    LET g_imn[l_ac].imn45=s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)   #FUN-BB0084
    DISPLAY BY NAME g_imn[l_ac].imn45
END IF
	END IF
CALL t700_set_no_required()
 
	AFTER FIELD imn40  #第一單位
	IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
	IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
	g_imn[l_ac].imn17 IS NULL THEN
	NEXT FIELD imn15
	END IF
	IF NOT cl_null(g_imn[l_ac].imn40) THEN
CALL t700_unit(g_imn[l_ac].imn40,g_imn151) #FUN-980093 add
	IF NOT cl_null(g_errno) THEN
	CALL cl_err('gfe:',STATUS,0)
	LET g_imn[l_ac].imn40=g_imn_t.imn40
	DISPLAY BY NAME g_imn[l_ac].imn40
	NEXT FIELD imn40
	END IF
	CALL s_du_umfchk1(g_imn[l_ac].imn03,'','','',
                        g_imn[l_ac].imn20,g_imn[l_ac].imn40,'1',g_imn151) #No.CHI-960052
	RETURNING g_errno,g_factor
	IF NOT cl_null(g_errno) THEN
CALL cl_err(g_imn[l_ac].imn40,g_errno,0)
	NEXT FIELD imn40
	END IF
	IF cl_null(g_imn_t.imn40) OR g_imn_t.imn40 <> g_imn[l_ac].imn40 THEN
	LET g_imn[l_ac].imn41 = g_factor
	DISPLAY BY NAME g_imn[l_ac].imn41
	END IF
CALL s_umfchk1(g_imn[l_ac].imn03,g_imn[l_ac].imn30,g_imn[l_ac].imn40,g_imn151)  #No.FUN-980059
	RETURNING g_flag,g_factor
	IF g_flag = 1 THEN
	LET g_msg=g_imn[l_ac].imn03,' ',g_imn[l_ac].imn30,' ',g_imn[l_ac].imn40
	CALL cl_err(g_msg CLIPPED,'mfg3075',1)
	NEXT FIELD imn40
	ELSE
	LET g_imn51=g_factor
	END IF
	IF g_ima906 = '2' THEN
	CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
			g_imn[l_ac].imn16,g_imn[l_ac].imn17,
			g_imn[l_ac].imn40,g_imn151) RETURNING g_flag #FUN-980093 add
	IF g_flag = 1 THEN
	IF g_sma.sma892[3,3] = 'Y' THEN
	IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn40 END IF
	END IF
CALL s_madd_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
		g_imn[l_ac].imn16,g_imn[l_ac].imn17,
		g_imn[l_ac].imn40,g_imn[l_ac].imn41,
		g_imm.imm01,g_imn[l_ac].imn02,0,g_imn151)  #FUN-980093 add
RETURNING g_flag
IF g_flag = 1 THEN
NEXT FIELD imn40
END IF
END IF
END IF
        LET g_imn[l_ac].imn42=g_imn[l_ac].imn32*g_imn51
        LET g_imn[l_ac].imn42=s_digqty(g_imn[l_ac].imn42,g_imn[l_ac].imn40) #FUN-BB0084 
        DISPLAY BY NAME g_imn[l_ac].imn42
	END IF
	CALL t700_set_required()
        CALL t700_set_origin_field()
        DISPLAY BY NAME g_imn[l_ac].imn09    #FUN-BB0084
        DISPLAY BY NAME g_imn[l_ac].imn10    #FUN-BB0084
	LET g_imn_t.imn40=g_imn[l_ac].imn40
 
	AFTER FIELD imn9301 
	IF NOT s_costcenter_chk(g_imn[l_ac].imn9301) THEN
	LET g_imn[l_ac].imn9301=g_imn_t.imn9301
LET g_imn[l_ac].gem02b =s_costcenter_desc(g_imn[l_ac].imn9301) 
	DISPLAY BY NAME g_imn[l_ac].imn9301
	DISPLAY BY NAME g_imn[l_ac].gem02b
	NEXT FIELD imn9301
	ELSE
LET g_imn[l_ac].gem02b =s_costcenter_desc(g_imn[l_ac].imn9301) 
	DISPLAY BY NAME g_imn[l_ac].gem02b
	END IF
	AFTER FIELD imn9302 
	IF NOT s_costcenter_chk(g_imn[l_ac].imn9302) THEN
	LET g_imn[l_ac].imn9302=g_imn_t.imn9302
LET g_imn[l_ac].gem02c =s_costcenter_desc(g_imn[l_ac].imn9302) 
	DISPLAY BY NAME g_imn[l_ac].imn9302
	DISPLAY BY NAME g_imn[l_ac].gem02c
	NEXT FIELD imn9302
	ELSE
LET g_imn[l_ac].gem02c =s_costcenter_desc(g_imn[l_ac].imn9302) 
	DISPLAY BY NAME g_imn[l_ac].gem02c
	END IF
	AFTER INPUT
	IF INT_FLAG THEN EXIT INPUT  END IF
	LET l_flag='N'
	IF g_imn[l_ac].imn03 IS NULL OR g_imn[l_ac].imn03 = ' ' THEN  #料件編號
	LET l_flag='Y'
	DISPLAY BY NAME g_imn[l_ac].imn03
	END IF
	IF g_imn[l_ac].imn10 IS NULL OR g_imn[l_ac].imn10 <= 0 THEN  #預撥數量
	LET l_flag='Y'
	DISPLAY BY NAME g_imn[l_ac].imn10
	END IF
	IF g_imn151 IS NULL OR g_imn151 = ' '
	THEN LET l_flag = 'Y'
	DISPLAY BY NAME g_imn151
	END IF
	IF l_flag='Y' THEN
	CALL cl_err('','9033',0)
	NEXT FIELD imn03
	END IF
 
 
	ON ACTION controlp
	CASE
	WHEN INFIELD(imn03) #查詢料件編號
     #   CALL cl_init_qry_var()        #FUN-AA0059
	LET g_t1 =g_imm.imm01[1,g_doc_len]
	SELECT smy62 INTO g_smy62 FROM smy_file
	WHERE smyslip =g_t1
	IF g_sma.sma120 ='Y' AND g_sma.sma907 ='Y' AND NOT cl_null(g_smy62) THEN
#FUN-AA0059 --Begin--
#	LET g_qryparam.form     = "q_ima19"
#	LET g_qryparam.arg1= g_smy62
#	LET g_qryparam.default1 = g_imn[l_ac].imn03
#	ELSE
#	LET g_qryparam.form     = "q_ima"
#	LET g_qryparam.default1 = g_imn[l_ac].imn03
#	END IF
#	CALL cl_create_qry() RETURNING g_imn[l_ac].imn03
           CALL q_sel_ima(FALSE, "q_ima19", "", g_imn[l_ac].imn03, g_smy62, "", "", "" ,"",'' )  RETURNING g_imn[l_ac].imn03
        ELSE  
           CALL q_sel_ima(FALSE, "q_ima", "", g_imn[l_ac].imn03, "", "", "", "" ,"",'' )  RETURNING g_imn[l_ac].imn03
        END IF
#FUN-AA0059 --End--
	DISPLAY BY NAME g_imn[l_ac].imn03
	CALL t700_imn03('d')
	NEXT FIELD imn03
	WHEN INFIELD(imn04) #倉庫
	LET l_ima906 = NULL
	SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_imn[l_ac].imn03
	IF STATUS THEN
	LET l_ima906 = NULL
	END IF
	IF l_ima906 = '2' OR l_ima906 = '3' THEN 
CALL cl_init_qry_var()
	LET g_qryparam.form     = "q_imgg"
	LET g_qryparam.default1 = g_imn[l_ac].imn04
	LET g_qryparam.default2 = g_imn[l_ac].imn05
	LET g_qryparam.default3 = g_imn[l_ac].imn06
	LET g_qryparam.arg1     = g_imn[l_ac].imn03
	CALL cl_create_qry() RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06
	ELSE
CALL cl_init_qry_var()
	LET g_qryparam.form     = "q_img5"
	LET g_qryparam.default1 = g_imn[l_ac].imn04
	LET g_qryparam.default2 = g_imn[l_ac].imn05
	LET g_qryparam.default3 = g_imn[l_ac].imn06
	LET g_qryparam.arg1     = g_imn[l_ac].imn03
	CALL cl_create_qry() RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06
	END IF
	DISPLAY BY NAME g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06
	NEXT FIELD imn04
 
	WHEN INFIELD(imn15) #
CALL cl_init_qry_var()
	LET g_qryparam.state = "c"
	LET g_qryparam.state = 'c' #FUN-980030
	LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
	CALL q_img5(FALSE,TRUE,g_imn[l_ac].imn03,  ##NO.FUN-660085
			g_imn[l_ac].imn15,
			g_imn[l_ac].imn16,
			g_imn[l_ac].imn17,'A',g_imn151) #FUN-980093 add
	RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17
	DISPLAY BY NAME g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17
	NEXT FIELD imn15
	WHEN INFIELD(imn33) #單位
CALL cl_init_qry_var()
	LET g_qryparam.form ="q_gfe"
	LET g_qryparam.default1 = g_imn[l_ac].imn33
	CALL cl_create_qry() RETURNING g_imn[l_ac].imn33
	NEXT FIELD imn33
	WHEN INFIELD(imn30) #單位
CALL cl_init_qry_var()
	LET g_qryparam.form ="q_gfe"
	LET g_qryparam.default1 = g_imn[l_ac].imn30
	CALL cl_create_qry() RETURNING g_imn[l_ac].imn30
	NEXT FIELD imn30
	WHEN INFIELD(imn43) #單位
CALL cl_init_qry_var()
	LET g_qryparam.form ="q_gfe"
	LET g_qryparam.default1 = g_imn[l_ac].imn43
	CALL cl_create_qry() RETURNING g_imn[l_ac].imn43
	NEXT FIELD imn43
	WHEN INFIELD(imn40) #單位
CALL cl_init_qry_var()
	LET g_qryparam.form ="q_gfe"
	LET g_qryparam.default1 = g_imn[l_ac].imn40
	CALL cl_create_qry() RETURNING g_imn[l_ac].imn40
	NEXT FIELD imn40
	WHEN INFIELD(imn9301)
CALL cl_init_qry_var()
	LET g_qryparam.form ="q_gem4"
	CALL cl_create_qry() RETURNING g_imn[l_ac].imn9301
	DISPLAY BY NAME g_imn[l_ac].imn9301
	NEXT FIELD imn9301
	WHEN INFIELD(imn9302)
       CALL cl_init_qry_var()
	   LET g_qryparam.form ="q_gem4"
	   CALL cl_create_qry() RETURNING g_imn[l_ac].imn9302
	   DISPLAY BY NAME g_imn[l_ac].imn9302
	   NEXT FIELD imn9302
    END CASE
 
	ON ACTION mntn_stock
	   LET l_cmd = 'aimi200 x'
       CALL cl_cmdrun(l_cmd)
 
	ON ACTION mntn_loc
	   LET l_cmd = "aimi201 '",g_imn[l_ac].imn15,"'" 
       CALL cl_cmdrun(l_cmd)
 
	ON ACTION qry_inv1
        CALL q_img6(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn04,g_imn[l_ac].imn05,'A') 
	RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06,
        g_imn091,g_imn092 
 
	DISPLAY BY NAME g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06
 
	ON ACTION qry_inv2
        CALL q_img5(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17,'A',g_imn151)  #TQC-7A0108 #FUN-980093 add
	RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17 
	DISPLAY BY NAME g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17
 
	ON ACTION qry_imf #預設倉庫/ 儲位
       CALL cl_init_qry_var()
	LET g_qryparam.form = 'q_imf'
	LET g_qryparam.arg1 = g_imn[l_ac].imn03
	LET g_qryparam.default1 = g_imn[l_ac].imn04
	LET g_qryparam.default1 = g_imn[l_ac].imn05
	CALL cl_create_qry() RETURNING g_imn[l_ac].imn03,g_imn[l_ac].imn05
	DISPLAY BY NAME g_imn[l_ac].imn03,g_imn[l_ac].imn05
	NEXT FIELD imn04
 
	ON ACTION CONTROLO                        #沿用所有欄位
	IF INFIELD(imn02) AND l_ac > 1 THEN
	LET g_imn[l_ac].* = g_imn[l_ac-1].*
	SELECT max(imn02)+1
	INTO g_imn[l_ac].imn02
	FROM imn_file
	WHERE imn01 = g_imm.imm01
	NEXT FIELD imn02
	END IF
    #CHI-D10014---begin
    ON ACTION modi_lot
       SELECT ima918,ima921 INTO g_ima918,g_ima921
         FROM ima_file
        WHERE ima01 = g_imn[l_ac].imn03
          AND imaacti = "Y"
       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,
                        g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                        g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                        g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                        g_imn[l_ac].imn10,'','MOD',-1)
                 RETURNING l_r,g_qty
           
          IF l_r = "Y" THEN
             LET g_imn[l_ac].imn10 = g_qty
          END IF
          DISPLAY BY NAME g_imn[l_ac].imn10
          EXECUTE rvbs_del USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
          EXECUTE rvbs_cur USING g_imm.imm01,g_imn[l_ac].imn02,g_imn[l_ac].imn03
       END IF
    #CHI-D10014---end
	ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
	ON ACTION CONTROLG
       CALL cl_cmdask()
 
	ON ACTION CONTROLF
	   CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
	   CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
	ON IDLE g_idle_seconds
       CALL cl_on_idle()
	CONTINUE INPUT
 
	ON ACTION about         
       CALL cl_about()      
 
	ON ACTION HELP          
       CALL cl_show_help()  
	END INPUT
 
	LET g_imm.immmodu = g_user
	LET g_imm.immdate = g_today
	UPDATE imm_file SET immmodu = g_imm.immmodu,immdate = g_imm.immdate
	WHERE imm01 = g_imm.imm01
	DISPLAY BY NAME g_imm.immmodu,g_imm.immdate
    CALL t700_b_fill("1=1")  #CHI-D10014
 
	CLOSE t700_bcl
	CLOSE t700_curl
	COMMIT WORK
        CALL t700_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t700_delHeader()
#TQC-C50034--add--start--
   DEFINE l_sql    STRING
   CALL s_getdbs()
   CALL s_gettrandbs()
   LET l_sql = "DELETE FROM  ",cl_get_target_table(l_plant_new,'imm_file'),
               " WHERE imm01 =  '" ,g_imm.imm01 CLIPPED,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
   PREPARE  imm_del FROM l_sql
#TQC-C50034--add--end--
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         EXECUTE imm_del       #TQC-C50034--add--
         DELETE FROM imm_file WHERE imm01 = g_imm.imm01
         INITIALIZE g_imm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#FUN-BB0084 -------------Begin---------------
FUNCTION t700_imn32_chk()
   IF NOT cl_null(g_imn[l_ac].imn32) THEN
	  IF g_imn[l_ac].imn32 < 0 THEN
	     CALL cl_err('','aim-391',0)  
	     RETURN FALSE
      END IF
   END IF
   IF NOT cl_null(g_imn[l_ac].imn32) AND NOT cl_null(g_imn[l_ac].imn32) THEN
      IF g_imn_o.imn32! = g_imn[l_ac].imn32 OR g_imn_o.imn30! = g_imn[l_ac].imn30
         OR cl_null(g_imn_o.imn32) OR cl_null(g_imn_o.imn30) THEN
         LET g_imn[l_ac].imn32 = s_digqty(g_imn[l_ac].imn32,g_imn[l_ac].imn30)
         DISPLAY BY NAME g_imn[l_ac].imn32 
      END IF   
   END IF    
   RETURN TRUE 
END FUNCTION    

FUNCTION t700_imn35_chk(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1    
   IF NOT cl_null(g_imn[l_ac].imn35) THEN
      IF g_imn[l_ac].imn35 < 0 THEN
          CALL cl_err('','aim-391',0)  
          RETURN FALSE 
      END IF
      IF NOT cl_null(g_imn[l_ac].imn33) THEN
         IF cl_null(g_imn_o.imn33) OR cl_null(g_imn_o.imn35) OR
            g_imn_o.imn35! = g_imn[l_ac].imn35 OR g_imn_o.imn33! = g_imn[l_ac].imn33 THEN
            LET g_imn[l_ac].imn35 = s_digqty(g_imn[l_ac].imn35,g_imn[l_ac].imn33)
            DISPLAY BY NAME g_imn[l_ac].imn35
         END IF 
      END IF 
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
             LET g_tot=g_imn[l_ac].imn35*g_imn[l_ac].imn34
             IF cl_null(g_imn[l_ac].imn32) OR g_imn[l_ac].imn32=0 THEN 
                LET g_imn[l_ac].imn32=g_tot*g_imn[l_ac].imn31
                LET g_imn[l_ac].imn32=s_digqty(g_imn[l_ac].imn32,g_imn[l_ac].imn30)
                DISPLAY BY NAME g_imn[l_ac].imn32                      
             END IF                                                    
         END IF
      END IF
   END IF
   RETURN TRUE 
END FUNCTION 
#FUN-BB0084 -------------End-----------------
    
FUNCTION t700_delall()
	DEFINE  l_cnt  LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
	SELECT COUNT(*) INTO l_cnt FROM imn_file
	WHERE imn01 = g_imm.imm01
	IF l_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
	CALL cl_getmsg('9044',g_lang) RETURNING g_msg
	ERROR g_msg CLIPPED
	DELETE FROM imm_file WHERE imm01 = g_imm.imm01
	END IF
	END FUNCTION
 
 
	FUNCTION t700_imn03(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_ima02   LIKE ima_file.ima02,
	l_ima05   LIKE ima_file.ima05,
	l_ima08   LIKE ima_file.ima08,
	l_ima25   LIKE ima_file.ima25,
	l_ima39   LIKE ima_file.ima39,
	l_imaacti LIKE ima_file.imaacti
 
	LET g_errno = ' '
	LET l_ima02=' '
	LET l_ima05=' '
	LET l_ima08=' '
	SELECT ima02,ima05,ima08,ima25,ima39,imaacti
	INTO l_ima02,l_ima05,l_ima08,l_ima25,l_ima39,l_imaacti
	FROM ima_file WHERE ima01 = g_imn[l_ac].imn03   #FUN-770057 g_imn.imn03->g_imn[l_ac].imn03
	CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
	LET l_ima02 = NULL
	WHEN l_imaacti='N' LET g_errno = '9028'
	WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
	OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
	IF g_sma.sma12 = 'N' THEN
	LET g_imn[l_ac].imn09 = l_ima25
   #FUN-BB0084 ---------------Begin-----------------      
        IF NOT cl_null(g_imn[l_ac].imn10) THEN
           LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09) 
           DISPLAY BY NAME g_imn[l_ac].imn10    
        END IF
   #FUN-BB0084 ---------------End-------------------
	LET g_imn07 = l_ima39
	DISPLAY BY NAME g_imn[l_ac].imn09
	END IF
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
	LET g_imn[l_ac].ima02 = l_ima02
	LET g_imn[l_ac].ima05 = l_ima05
	LET g_imn[l_ac].ima08 = l_ima08
	END IF
	END FUNCTION
 
	FUNCTION t700_imn06(p_cmd)   #存放批號
DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_img10 LIKE img_file.img10,
	l_img22 LIKE img_file.img22
 
	LET g_errno = ' '
	IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05=' ' END IF
	IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06=' ' END IF
	SELECT img09,img10,img19,
	img26,img22,img35,img36
	INTO g_imn[l_ac].imn09,l_img10,g_imn201,
	g_imn07,l_img22,g_imn08,g_imn202
	FROM img_file
	WHERE img01 = g_imn[l_ac].imn03 AND img02=g_imn[l_ac].imn04
	AND img03 = g_imn[l_ac].imn05 AND img04=g_imn[l_ac].imn06
 
	CASE WHEN SQLCA.SQLCODE = 100   
          #FUN-C80107 modify begin---------------------------------------121107
          #LET g_errno = 'mfg9033'
          #LET l_img10 = 0  LET l_img22 = NULL
          LET l_flag01 = NULL
          #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING l_flag01   #FUN-D30024---mark
          CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING l_flag01   #FUN-D30024---add  #TQC-D40078 g_plant
          IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
             LET g_errno = 'mfg9033'
             LET l_img10 = 0  LET l_img22 = NULL
          ELSE
             IF g_sma.sma892[3,3] = 'Y' THEN
                IF NOT cl_confirm('mfg1401') THEN
                   LET g_errno = 'mfg9033'
                   LET l_img10 = 0  LET l_img22 = NULL
                ELSE
                   CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                            g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                            g_imm.imm01      ,g_imn[l_ac].imn02,
                            g_imm.imm02)
                   IF g_errno='N' THEN
                      LET g_errno = 'mfg9033'
                      LET l_img10 = 0  LET l_img22 = NULL
                   ELSE
                      SELECT img09,img10,img19,img26,img22,img35,img36
                            INTO g_imn[l_ac].imn09,l_img10,g_imn201,
                             g_imn07,l_img22,g_imn08,g_imn202
                            FROM img_file
                       WHERE img01 = g_imn[l_ac].imn03 AND img02=g_imn[l_ac].imn04
                         AND img03 = g_imn[l_ac].imn05 AND img04=g_imn[l_ac].imn06
                   END IF
                END IF
             ELSE
                LET g_errno = 'mfg9033'
                LET l_img10 = 0  LET l_img22 = NULL
             END IF
          END IF
          #FUN-C80107 modify end-----------------------------------------121107
	OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
	LET g_qty=l_img10
	DISPLAY BY NAME g_imn[l_ac].imn09
    #FUN-BB0084 --------------Begin-------------
        IF NOT cl_null(g_imn[l_ac].imn10) THEN
           LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)
           DISPLAY BY NAME g_imn[l_ac].imn10
        END IF 
    #FUN-BB0084 --------------End---------------
	END IF
	END FUNCTION
 
	FUNCTION t700_plantnam(p_cmd,p_code,p_plant)
	DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
p_code  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	p_plant LIKE imn_file.imn151,
	l_azp02 LIKE azp_file.azp02,
	l_azp03 LIKE azp_file.azp03
 
	LET g_errno = ' '
	SELECT azp02,azp03 INTO l_azp02,l_azp03  FROM azp_file
	WHERE azp01 = p_plant
 
	CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'
	LET l_azp02 = NULL
	OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
 
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
	IF p_code = '1' THEN
	DISPLAY l_azp02 TO FORMONLY.azp02_1
	ELSE
	DISPLAY l_azp02 TO FORMONLY.azp02_2
	LET g_dbs_new = s_dbstring(l_azp03 CLIPPED)
        LET l_plant_new = p_plant  #FUN-A50102
	END IF
	END IF
	END FUNCTION
 
 
FUNCTION t700_b_clear()
    CLEAR imn02, imn27, imn03,imn29, ima02,   #No.FUN-5C0077
          imn04, imn05, imn06,
          imn07, imn09, imn10, imn11,imn23
END FUNCTION
 
FUNCTION t700_catstr(p_dbs)
DEFINE p_dbs  LIKE azp_file.azp03
 
  FOR g_i=20 TO 1 STEP -1
      IF p_dbs[g_i,g_i]='.'
         THEN RETURN p_dbs
      END IF
  END FOR
  LET p_dbs=p_dbs CLIPPED,'.'
  RETURN p_dbs
END FUNCTION
 
FUNCTION t700_mu_ui()
    CALL cl_set_comp_visible("imn31,imn34,imn41,imn44",FALSE)
    CALL cl_set_comp_att_text("imn31,imn34,imn41,imn44",' ')
    CALL cl_set_comp_visible("imn33,imn35,imn43,imn45",g_sma.sma115='Y')
    CALL cl_set_comp_visible("imn30,imn32,imn40,imn42",g_sma.sma115='Y')
    CALL cl_set_comp_visible("imn09,imn10,imn20",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-331',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-332',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn35",g_msg CLIPPED)
       CALL cl_getmsg('asm-333',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-334',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn32",g_msg CLIPPED)
       CALL cl_getmsg('asm-335',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn43",g_msg CLIPPED)
       CALL cl_getmsg('asm-336',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn45",g_msg CLIPPED)
       CALL cl_getmsg('asm-337',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn40",g_msg CLIPPED)
       CALL cl_getmsg('asm-338',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn42",g_msg CLIPPED)
       CALL cl_getmsg('asm-347',g_lang) RETURNING g_msg
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-339',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-340',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn35",g_msg CLIPPED)
       CALL cl_getmsg('asm-341',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-342',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn32",g_msg CLIPPED)
       CALL cl_getmsg('asm-343',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn43",g_msg CLIPPED)
       CALL cl_getmsg('asm-344',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn45",g_msg CLIPPED)
       CALL cl_getmsg('asm-345',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn40",g_msg CLIPPED)
       CALL cl_getmsg('asm-346',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn42",g_msg CLIPPED)
    END IF
    IF g_sma.sma115='N' THEN
       CALL cl_set_comp_att_text("imn33,imn35,imn43,imn45",' ')
       CALL cl_set_comp_att_text("imn30,imn32,imn40,imn42",' ')
    ELSE
       CALL cl_set_comp_att_text("imn09,imn10,imn20",' ')
    END IF
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("imm14",TRUE)
    END IF
    CALL cl_set_comp_visible("imn9301,gem02b,imn9302,gem02c",g_aaz.aaz90='Y')  #FUN-670093
 
    IF g_aza.aza64 matches '[ Nn]' THEN
       CALL cl_set_comp_visible("immspc",FALSE)
       CALL cl_set_act_visible("trans_spc",FALSE)
    END IF 
 
END FUNCTION
 
FUNCTION t700_unit(p_unit,p_plant) #FUN-980093 add
  DEFINE p_unit    LIKE gfe_file.gfe01,
         p_azp03   LIKE azp_file.azp03,
         l_gfeacti LIKE gfe_file.gfeacti,
         l_sql     STRING
  DEFINE p_plant   LIKE azp_file.azp01 #FUN-980093 add
 
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
    LET g_errno = ' '
   #LET l_sql=" SELECT gfe02,gfeacti FROM ",g_dbs_new,"gfe_file",   #TQC-950003 ADD     #FUN-980093 add #FUN-A50102
    LET l_sql=" SELECT gfe02,gfeacti FROM ",cl_get_target_table(l_plant_new,'gfe_file'),  #FUN-A50102
              "  WHERE gfe01='",p_unit,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-A50102
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE s_gfe_pre FROM l_sql
    DECLARE s_gfe_cur  CURSOR FOR s_gfe_pre
    OPEN s_gfe_cur
    FETCH s_gfe_cur INTO g_buf,l_gfeacti
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                                  LET g_buf   = NULL
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t700_set_entry_b()
 
    CALL cl_set_comp_entry("imn33,imn35,imn43",TRUE)
 
END FUNCTION
 
FUNCTION t700_set_no_entry_b()
 
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("imn33,imn35,imn43,imn45",FALSE)
    END IF
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_entry("imn33,imn43",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t700_set_required()
 
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("imn33,imn35,imn30,imn32,imn43,,imn45,imn40,imn42",TRUE)
  END IF
  #單位不空,轉換率,數量必KEY,KEY了來源,目的必KEY
  IF NOT cl_null(g_imn[l_ac].imn33) THEN ##FUN-770057 add l_ac
     CALL cl_set_comp_required("imn35,imn43,imn45",TRUE)
  END IF
  IF NOT cl_null(g_imn[l_ac].imn30) THEN   ##FUN-770057 add l_ac
     CALL cl_set_comp_required("imn32,imn40,imn42",TRUE)
  END IF
  IF NOT cl_null(g_imn[l_ac].imn43) THEN   #FUN-770057 add l_ac
     CALL cl_set_comp_required("imn45,imn33,imn35",TRUE)
  END IF
  IF NOT cl_null(g_imn[l_ac].imn40) THEN   #FUN-770057 add l_ac
     CALL cl_set_comp_required("imn42,imn30,imn32",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t700_set_no_required()
 
  CALL cl_set_comp_required("imn33,imn34,imn35,imn30,imn31,imn32,imn43,imn44,imn45,imn40,imn41,imn42",FALSE)
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t700_du_default(p_cmd,p_item,p_ware,p_loc,p_lot,p_plant) #FUN-980093 add
  DEFINE    p_item   LIKE img_file.img01,     #料號
            p_ware   LIKE img_file.img02,     #倉庫
            p_loc    LIKE img_file.img03,     #儲
            p_lot    LIKE img_file.img04,     #批
            p_azp03  LIKE azp_file.azp03,
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_sql    STRING,
            p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
  DEFINE    p_plant  LIKE azp_file.azp01      #FUN-980093 add
 
    #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
 
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = p_item
    IF NOT cl_null(p_azp03) THEN
      #LET l_sql=" SELECT ima25,ima906,ima907 FROM ",g_dbs_new,"ima_file", #TQC-950003 ADD   #FUN-980093 add  #FUN-A50102
       LET l_sql=" SELECT ima25,ima906,ima907 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                 "  WHERE ima01 = '",p_item,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-A50102
       CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
       PREPARE s_prex1 FROM l_sql
       DECLARE s_curx1 CURSOR FOR s_prex1
       OPEN s_curx1
       FETCH s_curx1 INTO l_ima25,l_ima906,l_ima907
    END IF
 
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = p_item
       AND img02 = p_ware
       AND img03 = p_loc
       AND img04 = p_lot
    IF NOT cl_null(p_azp03) THEN
      #LET l_sql=" SELECT img09 FROM ",l_dbs_tra,"img_file",  #TQC-950003 ADD   #FUN-980093 add  #FUN-A50102
       LET l_sql=" SELECT img09 FROM ",cl_get_target_table(l_plant_new,'img_file'),  #FUN-A50102
                 "  WHERE img01 = '",p_item,"'",
                 "    AND img02 = '",p_ware,"'",
                 "    AND img03 = '",p_loc ,"'",
                 "    AND img04 = '",p_lot ,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
       CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
       PREPARE s_prex2 FROM l_sql
       DECLARE s_curx2 CURSOR FOR s_prex2
       OPEN s_curx2
       FETCH s_curx2 INTO l_img09
    END IF
    IF cl_null(l_img09) THEN LET l_img09 = l_ima25 END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       IF NOT cl_null(p_plant) THEN #FUN-980093 add
          CALL s_du_umfchk1(p_item,'','','',l_img09,l_ima907,l_ima906,p_plant)  #No.FUN-980059 #FUN-980093 add
               RETURNING g_errno,l_factor
       ELSE
          CALL s_du_umfchk(p_item,'','','',l_img09,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
       END IF
       LET l_fac2 = l_factor
       LET l_qty2 = 0
    END IF
    LET l_unit1 = l_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    RETURN l_unit2,l_fac2,l_qty2,l_unit1,l_fac1,l_qty1
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t700_set_origin_field()
  DEFINE    p_flag      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_ima906    LIKE ima_file.ima906,
            l_ima907    LIKE ima_file.ima907,
            l_tot       LIKE img_file.img10,
            l_img09_s   LIKE img_file.img09,
            l_img09_t   LIKE img_file.img09,
            l_azp03     LIKE azp_file.azp03,
            l_sql       STRING,
            l_fac1      LIKE img_file.img21,
            l_fac2      LIKE img_file.img21,
            l_fac3      LIKE img_file.img21,
            l_fac4      LIKE img_file.img21,
            l_qty1      LIKE img_file.img10,
            l_qty2      LIKE img_file.img10,
            l_qty3      LIKE img_file.img10,
            l_qty4      LIKE img_file.img10
 
   IF g_sma.sma115='N' THEN RETURN END IF
   LET l_qty1=g_imn[l_ac].imn35
   LET l_qty2=g_imn[l_ac].imn32
   LET l_qty3=g_imn[l_ac].imn45
   LET l_qty4=g_imn[l_ac].imn42
   LET l_fac1=g_imn[l_ac].imn34
   LET l_fac2=g_imn[l_ac].imn31
   LET l_fac3=g_imn[l_ac].imn44
   LET l_fac4=g_imn[l_ac].imn41
 
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
   IF cl_null(l_qty3) THEN LET l_qty3=0 END IF
   IF cl_null(l_qty4) THEN LET l_qty4=0 END IF
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_fac3) THEN LET l_fac3=1 END IF
   IF cl_null(l_fac4) THEN LET l_fac4=1 END IF
 
    #source
    SELECT img09 INTO l_img09_s FROM img_file
     WHERE img01 = g_imn[l_ac].imn03
       AND img02 = g_imn[l_ac].imn04
       AND img03 = g_imn[l_ac].imn05
       AND img04 = g_imn[l_ac].imn06
 
     LET g_plant_new = g_imn151
     CALL s_getdbs()
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
   #LET l_sql=" SELECT img09 FROM ",l_dbs_tra,"img_file",  #TQC-950003 ADD  #FUN-980093 add  #FUN-A50102
    LET l_sql=" SELECT img09 FROM ",cl_get_target_table(l_plant_new,'img_file'),   #FUN-A50102
              "  WHERE img01 = '",g_imn[l_ac].imn03,"'",
              "    AND img02 = '",g_imn[l_ac].imn15,"'",
              "    AND img03 = '",g_imn[l_ac].imn16,"'",
              "    AND img04 = '",g_imn[l_ac].imn17,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
    PREPARE s_prex3 FROM l_sql
    DECLARE s_curx3 CURSOR FOR s_prex3
    OPEN s_curx3
    FETCH s_curx3 INTO l_img09_t
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_imn[l_ac].imn09=l_img09_s
                   LET g_imn[l_ac].imn10=l_qty2*l_fac2
                   LET g_imn[l_ac].imn20=l_img09_t
                   LET g_imn22=l_qty4*l_fac4
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
                   LET g_imn[l_ac].imn09=l_img09_s
                   LET g_imn[l_ac].imn10=l_tot
                   LET l_tot=l_qty3*l_fac3+l_qty4*l_fac4
                   LET g_imn[l_ac].imn20=l_img09_t
                   LET g_imn22=l_tot
          WHEN '3' LET g_imn[l_ac].imn09=l_img09_s
                   LET g_imn[l_ac].imn10=l_qty2*l_fac2
                   LET g_imn[l_ac].imn20=l_img09_t
                   LET g_imn22=l_qty4*l_fac4
                   IF l_qty1 <> 0 THEN
                      LET g_imn[l_ac].imn34=l_qty2/l_qty1
                   ELSE
                      LET g_imn[l_ac].imn34=0
                   END IF
                   IF l_qty3 <> 0 THEN
                      LET g_imn[l_ac].imn44=l_qty4/l_qty3
                   ELSE
                      LET g_imn[l_ac].imn44=0
                   END IF
       END CASE
       LET g_imn[l_ac].imn10=s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)   #FUN-BB0084
       LET g_imn22=s_digqty(g_imn22,g_imn[l_ac].imn20)     #FUN-BB0084
    END IF
 
    LET l_azp03 = s_madd_img_catstr(g_azp03)
    IF g_imn[l_ac].imn09 <> g_imn[l_ac].imn20 THEN
       CALL s_umfchk1(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20,g_imn151) #No.FUN-980059
            RETURNING g_cnt,g_imn21
    ELSE
       LET g_imn21 = 1
    END IF
END FUNCTION
 
#以img09單位來計算雙單位所確定的數量
FUNCTION t700_tot_by_img09(p_item,p_fac2,p_qty2,p_fac1,p_qty1)
  DEFINE p_item    LIKE ima_file.ima01
  DEFINE p_fac2    LIKE img_file.img21
  DEFINE p_qty2    LIKE img_file.img10
  DEFINE p_fac1    LIKE img_file.img21
  DEFINE p_qty1    LIKE img_file.img10
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima907  LIKE ima_file.ima907
  DEFINE l_tot     LIKE img_file.img10
 
    SELECT ima906,ima907 INTO l_ima906,l_ima907
      FROM ima_file WHERE ima01 = p_item
 
    IF cl_null(p_fac2) THEN LET p_fac2 = 1 END IF
    IF cl_null(p_qty2) THEN LET p_qty2 = 0 END IF
    IF cl_null(p_fac1) THEN LET p_fac1 = 1 END IF
    IF cl_null(p_qty1) THEN LET p_qty1 = 0 END IF
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=p_qty1*p_fac1
          WHEN '2' LET l_tot=p_qty1*p_fac1+p_qty2*p_fac2
          WHEN '3' LET l_tot=p_qty1*p_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=p_qty1*p_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    RETURN l_tot
 
END FUNCTION
 
#計算庫存總量是否滿足所輸入數量
FUNCTION t700_check_inventory_qty()
  DEFINE l_img10    LIKE img_file.img10
  DEFINE l_tot      LIKE img_file.img10
  DEFINE l_flag     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET l_flag = '1'
    SELECT img10 INTO l_img10 FROM img_file
     WHERE img01 = g_imn[l_ac].imn03 #FUN-770057 add l_ac 
       AND img02 = g_imn[l_ac].imn04 #FUN-770057 add l_ac 
       AND img03 = g_imn[l_ac].imn05 #FUN-770057 add l_ac 
       AND img04 = g_imn[l_ac].imn06 #FUN-770057 add l_ac 
 
    CALL t700_tot_by_img09(g_imn[l_ac].imn03,g_imn[l_ac].imn34,g_imn[l_ac].imn35,
                           g_imn[l_ac].imn31,g_imn[l_ac].imn32)
         RETURNING l_tot
    IF l_img10 < l_tot THEN
       LET l_flag = '0'
    END IF
    RETURN l_flag
END FUNCTION
 
#檢查發料/報廢動作是否可以進行下去
FUNCTION t700_qty_issue()
DEFINE l_flag   LIKE type_file.chr1   #FUN-C80107
 
    CALL t700_check_inventory_qty()  RETURNING g_flag
    IF g_flag = '0' THEN
      #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN   #FUN-C80107 mark
       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING l_flag   #FUN-C80107 add g_imn[l_ac].imn04) RETURNING l_flag01   #FUN-D30024--mark
       CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING l_flag     #FUN-D30024---add  #TQC-D40078 g_plant
       IF l_flag = 'N' OR l_flag IS NULL THEN   #FUN-C80107 add
          CALL cl_err(g_imn[l_ac].imn03,'mfg1303',1)  #FUN-770057 add l_ac
          RETURN 1
       ELSE
          IF NOT cl_confirm('mfg3469') THEN
             RETURN 1
          END IF
      END IF
    END IF
 
    RETURN 0
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t700_du_data_to_correct()
  #FUN-770057 將此function 全部 g_imn.* 改成 g_imn[l_ac].*
 
   IF cl_null(g_imn[l_ac].imn33) THEN
      LET g_imn[l_ac].imn34 = NULL
      LET g_imn[l_ac].imn35 = NULL
   END IF
 
   IF cl_null(g_imn[l_ac].imn30) THEN
      LET g_imn[l_ac].imn31 = NULL
      LET g_imn[l_ac].imn32 = NULL
   END IF
 
   IF cl_null(g_imn[l_ac].imn43) THEN
      LET g_imn[l_ac].imn44 = NULL
      LET g_imn[l_ac].imn45 = NULL
   END IF
 
   IF cl_null(g_imn[l_ac].imn40) THEN
      LET g_imn[l_ac].imn41 = NULL
      LET g_imn[l_ac].imn42 = NULL
   END IF
 
   DISPLAY BY NAME g_imn[l_ac].imn33
   DISPLAY BY NAME g_imn[l_ac].imn34
   DISPLAY BY NAME g_imn[l_ac].imn35
   DISPLAY BY NAME g_imn[l_ac].imn30
   DISPLAY BY NAME g_imn[l_ac].imn31
   DISPLAY BY NAME g_imn[l_ac].imn32
   DISPLAY BY NAME g_imn[l_ac].imn43
   DISPLAY BY NAME g_imn[l_ac].imn44
   DISPLAY BY NAME g_imn[l_ac].imn45
   DISPLAY BY NAME g_imn[l_ac].imn40
   DISPLAY BY NAME g_imn[l_ac].imn41
   DISPLAY BY NAME g_imn[l_ac].imn42
END FUNCTION
 
FUNCTION t700_spc()
DEFINE l_gaz03        LIKE gaz_file.gaz03
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_imn02        LIKE imn_file.imn02    ## 項次
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qc_prog      LIKE zz_file.zz01      #No.FUN-690026 VARCHAR(10)
DEFINE l_i            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_cmd          STRING
DEFINE l_sql          STRING
DEFINE l_err          STRING
 
   LET g_success = 'Y'
 
   #檢查資料是否可拋轉至 SPC
   IF g_imm.imm04 matches '[Yy]' THEN    #判斷是否撥出確認
      CALL cl_err('imm04','aim-393',0)
      LET g_success='N'
      RETURN
   END IF
 
   IF g_imm.imm03 matches '[Yy]' THEN    #判斷是否撥入確認
      CALL cl_err('imm03','aim-100',0)
      LET g_success='N'
      RETURN
   END IF
 
   #CALL aws_spccli_check('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_check(g_imm.imm01,g_imm.immspc,'','')
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   LET l_qc_prog = "aqct700"               #設定QC單的程式代號
 
   #若在 QC 單已有此單號相關資料，則取消拋轉至 SPC
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imm.imm01  
   IF l_cnt > 0 THEN
      CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
      CALL cl_err_msg(g_imm.imm01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
      LET g_success='N'
      RETURN
   END IF
  
   #需要 QC 檢驗的筆數
   SELECT COUNT(*) INTO l_qc_cnt FROM imn_file 
    WHERE imn01 = g_imm.imm01 AND imn29 = 'Y' 
   IF l_qc_cnt = 0 THEN 
      CALL cl_err(g_imm.imm01,l_err,0) 
      LET g_success='N'
      RETURN
   END IF
 
   #需檢驗的資料，自動新增資料至 QC 單 ,功能參數為「SPC」
   LET l_sql  = "SELECT imn02 FROM imn_file 
                  WHERE imn01 = '",g_imm.imm01,"' AND imn29='Y'"
   PREPARE t700_imn_p FROM l_sql
   DECLARE t700_imn_c CURSOR WITH HOLD FOR t700_imn_p
   FOREACH t700_imn_c INTO l_imn02
       display l_cmd
       LET l_cmd = l_qc_prog CLIPPED," '",g_imm.imm01,"' '",l_imn02,"' '1' 'SPC' 'D'"
       CALL aws_spccli_qc(l_qc_prog,l_cmd)
   END FOREACH 
 
   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imm.imm01
   IF l_cnt <> l_qc_cnt THEN
      CALL t700_qcs_del()
      LET g_success='N'
      RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_imm.imm01,"'"
   PREPARE t700_qc_p FROM l_sql
   DECLARE t700_qc_c CURSOR WITH HOLD FOR t700_qc_p
   LET l_cnt = 1
   FOREACH t700_qc_c INTO l_qcs[l_cnt].*
       LET l_cnt = l_cnt + 1 
   END FOREACH
   CALL l_qcs.deleteElement(l_cnt)
 
   # CALL aws_spccli() 
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert") THEN
      LET g_imm.immspc = '1'
   ELSE
      LET g_imm.immspc = '2'
      CALL t700_qcs_del()
   END IF
 
   UPDATE imm_file set immspc = g_imm.immspc WHERE imm01 = g_imm.imm01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","imm_file",g_imm.imm01,"",STATUS,"","upd immspc",1)
      IF g_imm.immspc = '1' THEN
          CALL t700_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_imm.immspc
  
END FUNCTION 
 
FUNCTION t700_qcs_del()
 
      DELETE FROM qcs_file WHERE qcs01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcs_file err!",0)
      END IF
 
      DELETE FROM qct_file WHERE qct01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qct_file err!",0)
      END IF
 
      DELETE FROM qctt_file WHERE qctt01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcstt_file err!",0)
      END IF
 
      DELETE FROM qcu_file WHERE qcu01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcu_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcu_file err!",0)
      END IF
 
      DELETE FROM qcv_file WHERE qcv01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcv_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcv_file err!",0)
      END IF
 
END FUNCTION 
#------------CHI-BB0015 add------------------------
FUNCTION t700_out()
    IF g_imm.imm01 IS NULL THEN RETURN END IF
    LET g_msg = 'imm01="',g_imm.imm01,'" '
  # LET g_msg = "aimr512 '",g_today,"' '",g_user,"' '",g_lang,"' ",   #FUN-C30085 mark
    LET g_msg = "aimg512 '",g_today,"' '",g_user,"' '",g_lang,"' ",   #FUN-C30085 add
                " 'Y' ' ' '1' ",
                " '",g_msg,"' '4' "
    CALL cl_cmdrun(g_msg)

END FUNCTION
#------------CHI-BB0015 add------------------------
#No.FUN-9C0072 精簡程式碼

