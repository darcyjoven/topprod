# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: aqct411.4gl
# Descriptions...: FQC 品質記錄維護作業(Run Card)
# Date & Author..: 99/05/11 By Melody
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify ........: No.MOD-480059 04/08/26 By Nicola 如果是合格應該就不能做特材了
# Modify ........: No.MOD-490371 04/09/22 By Melody controlp ...display修改
# Modify.........: No.MOD-4A0248 04/10/19 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0038 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-520016 05/02/16 By Melody 合格量不可大於送驗量
# Modify.........: NO.FUN-550063 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-550012 05/05/23 By pengu FQC單號改放工單完工入庫單身
# Modify.........: NO.FUN-560002 05/06/06 By jackie 單據編號修改
# Modify.........: NO.FUN-560195 05/07/04 By Carol  6/19會議:sfu03改用sfv17
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: NO.TQC-630218 06/03/30 BY yiting 己QC量少了RUN CARD條件
# Modify.........: No.MOD-640337 06/04/10 By pengu 製程序號,應可放大鏡查詢.
# Modify.........: No.FUN-650146 06/06/14 By Sarah t411_qcf22()計算un_post_qty的WHERE條件句修改,將AND qcf14='N'拿掉
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680010 06/09/07 By Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-680104 06/09/19 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/13 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.CHI-6C0045 07/01/05 By rainy 送驗量=0時不可確認
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-740116 07/06/07 By pengu 取到調整樣本後,再回對樣本字號時,毋需考慮級數
#                                                  當送驗量(qcf22)為 1 時, defqty() 應 return 1 毋需再比對 105E表
# Modify.........: No.CHI-740037 07/06/07 By pengu 單身判定結果為合格時應將缺點數乘上CR/MA/MI權數
# Modify.........: No.TQC-750209 07/06/07 By pengu 修正zl單CHI-740037的寫法
# Modify.........: No.TQC-750064 07/06/11 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.MOD-780149 07/08/21 By pengu 若判合格則單頭的合格量應與送驗量一致
# Modify.........: No.MOD-7C0061 07/12/10 By Pengu 在b_fill()中不應該在去呼叫s_newaql()
# Modify.........: No.MOD-7C0145 07/12/25 By Pengu 若單頭送驗量包含小數時會造成單身檢驗量為0
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820049 08/02/14 By Pengu 檢驗方式為C=0時其推算抽驗量應考慮級數
# Modify.........: No.TQC-820019 08/02/25 By Carol 調整CALL cl_set_comp_visible()傳入的action名稱
# Modify.........: No.FUN-840068 08/04/23 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-850258 08/05/27 By claire 人工輸入時不檢核送驗量(qcf22)
# Modify.........: No.MOD-840698 08/07/13 By Pengu AFTER FIELD qcf01 判斷有誤，若是修改狀態時原單號會被自動改變
# Modify.........: No.MOD-880243 08/08/29 By claire 調整FUN-680010寫法
# Modify.........: No.MOD-890223 08/09/23 By claire s_newaql加傳入pmh21,pmh22
# Modify.........: No.MOD-8A0131 08/10/15 By claire 資料重新查詢時,不應重取qcf17,qcf21
# Modify.........: No.MOD-8A0159 08/10/17 By liuxqa 進入單身,如缺點數大于零時,此時應彈出畫面輸入缺點明細
# Modify.........: No.MOD-8B0097 08/11/10 By Sarah qcf05欄位改為不開窗,新增時default值為1
# Modify.........: No.FUN-910079 09/02/20 By ve007 增加品管類型的邏輯
# Modify.........: No.FUN-940113 09/04/29 By lilingyu刪除時將shb22的單號一起刪除 
# Modify.........: No.FUN-980007 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0024 09/11/06 By Pengu 單身不允許新增
# Modify.........: No:MOD-970283 09/11/25 By sabrina 判重工後，系統又會將合格量預設帶成送驗量應預設帶0
# Modify.........: No:FUN-9C0071 10/01/12 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-A30031 10/04/14 By Summer 合格資料不能修改送驗量
# Modify.........: No:FUN-A60092 10/07/08 By lilingyu 平行工藝
# Modify.........: No.FUN-A80063 10/08/18 By wujie   品质管理功能改善修改
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No:FUN-A30045 10/11/15 By lixh1    增加"取消特采"ACTION
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
# Modify.........: No.FUN-BB0085 11/12/13 By xianghui 增加熟練欄位小數取位
# Modify.........: No:CHI-BC0018 11/12/15 By ck2yuan ima101、qcf17兩個欄位帶出後面說明欄位
# Modify.........: No:FUN-BC0104 12/01/05 By lixh1 增加'QC料件維護’ACTION
# Modify.........: No.FUN-C20068 12/02/10 By xianghui 對FUN-BB0085的調整
# Modify.........: No.TQC-C20504 12/02/27 By xianghui 確認時要檢查QC料件維護的數量要等於QC單的送驗量
# Modify.........: No.TQC-C30139 12/03/09 By xianghui qck09='N'時給出相應的提示信息
# Modify.........: No.MOD-C30557 12/03/12 By xianghui 確認時添加QC料件判定維護合格量的回寫
# Modify.........: No.MOD-C30560 12/03/14 By xianghui 雜收單的單身QC單號有值就不可再次打雜收單單頭單號的QC單的檢驗，且原單身QC單不可以取消確認 
# Modify.........: No.MOD-C30634 12/03/16 By fengrui 取消不良數量小於等於檢驗量的控管
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No.TQC-C90043 12/10/10 By chenjing 修改單身檢驗量帶不值問題
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-C30163 12/12/26 By pauline RunCard 開窗增加顯示待驗量欄位
# Modify.........: No:FUN-D20025 13/02/20 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-C80072 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_qcf           RECORD LIKE qcf_file.*,
    g_qcf_t         RECORD LIKE qcf_file.*,
    g_qcf_o         RECORD LIKE qcf_file.*,
    g_qcf22         LIKE qcf_file.qcf22,        #No.FUN-680104 DEC(12,0) #bugno:7196
    g_qcf01_t       LIKE qcf_file.qcf01,
    g_qcg           DYNAMIC ARRAY OF RECORD
        qcg03       LIKE qcg_file.qcg03,
        qcg04       LIKE qcg_file.qcg04,
        azf03_1     LIKE azf_file.azf03,
        qcg05       LIKE qcg_file.qcg05,
        qcg06       LIKE qcg_file.qcg06,
        qcg09       LIKE qcg_file.qcg09,
        qcg10       LIKE qcg_file.qcg10,
#No.FUN-A80063 --begin
        qcg14       LIKE qcg_file.qcg14,
        qcg15       LIKE qcg_file.qcg15,
#No.FUN-A80063 --end
        qcg11       LIKE qcg_file.qcg11,
        qcg07       LIKE qcg_file.qcg07,
        qcg08       LIKE qcg_file.qcg08,
        qcg08_desc  LIKE ze_file.ze03    #No.TQC-610007
       ,qcgud01 LIKE qcg_file.qcgud01,
        qcgud02 LIKE qcg_file.qcgud02,
        qcgud03 LIKE qcg_file.qcgud03,           
        qcgud04 LIKE qcg_file.qcgud04,
        qcgud05 LIKE qcg_file.qcgud05,
        qcgud06 LIKE qcg_file.qcgud06,
        qcgud07 LIKE qcg_file.qcgud07,
        qcgud08 LIKE qcg_file.qcgud08,
        qcgud09 LIKE qcg_file.qcgud09,
        qcgud10 LIKE qcg_file.qcgud10,
        qcgud11 LIKE qcg_file.qcgud11,
        qcgud12 LIKE qcg_file.qcgud12,
        qcgud13 LIKE qcg_file.qcgud13,
        qcgud14 LIKE qcg_file.qcgud14,
        qcgud15 LIKE qcg_file.qcgud15
 
                    END RECORD,
    g_qcg_t         RECORD
        qcg03       LIKE qcg_file.qcg03,
        qcg04       LIKE qcg_file.qcg04,
        azf03_1     LIKE azf_file.azf03,
        qcg05       LIKE qcg_file.qcg05,
        qcg06       LIKE qcg_file.qcg06,
        qcg09       LIKE qcg_file.qcg09,
        qcg10       LIKE qcg_file.qcg10,
#No.FUN-A80063 --begin
        qcg14       LIKE qcg_file.qcg14,
        qcg15       LIKE qcg_file.qcg15,
#No.FUN-A80063 --end
        qcg11       LIKE qcg_file.qcg11,
        qcg07       LIKE qcg_file.qcg07,
        qcg08       LIKE qcg_file.qcg08,
        qcg08_desc  LIKE ze_file.ze03    #No.TQC-610007
       ,qcgud01 LIKE qcg_file.qcgud01,
        qcgud02 LIKE qcg_file.qcgud02,
        qcgud03 LIKE qcg_file.qcgud03,           
        qcgud04 LIKE qcg_file.qcgud04,
        qcgud05 LIKE qcg_file.qcgud05,
        qcgud06 LIKE qcg_file.qcgud06,
        qcgud07 LIKE qcg_file.qcgud07,
        qcgud08 LIKE qcg_file.qcgud08,
        qcgud09 LIKE qcg_file.qcgud09,
        qcgud10 LIKE qcg_file.qcgud10,
        qcgud11 LIKE qcg_file.qcgud11,
        qcgud12 LIKE qcg_file.qcgud12,
        qcgud13 LIKE qcg_file.qcgud13,
        qcgud14 LIKE qcg_file.qcgud14,
        qcgud15 LIKE qcg_file.qcgud15
 
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680104 SMALLINT
    g_void          LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
    l_cmd           LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(300)
    l_wc            LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(300)
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680104 SMALLINT
 
DEFINE
    g_t1            LIKE oay_file.oayslip,          #No.FUN-550063  #No.FUN-680104 VARCHAR(05)
    m_gen02         LIKE gen_file.gen02,
    m_ima109        LIKE ima_file.ima109,       #No.FUN-680104 VARCHAR(4)
    qcf21_desc      LIKE ze_file.ze03,   #No.TQC-610007
    ima101_desc     LIKE gae_file.gae04,         #CHI-BC0018
    qcf17_desc      LIKE gae_file.gae04,         #CHI-BC0018
    des1,des2       LIKE ze_file.ze03,   #No.TQC-610007
    ma_num1,ma_num2,mi_num1,mi_num2 LIKE type_file.num10,        #No.FUN-680104 INTEGER
    g_max_qcf22     LIKE qcf_file.qcf22,        #No.FUN-680104 DEC(12,0)
    un_post_qty     LIKE qcf_file.qcf22,        #No.FUN-680104 DEC(15,5)
    post_qty        LIKE qcf_file.qcf22,        #No.FUN-680104 DEC(15,5)
    g_sfb39         LIKE sfb_file.sfb39
 
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done  LIKE type_file.num5    #No.FUN-680104 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680104 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680104 SMALLINT
 
DEFINE g_argv1	LIKE qcf_file.qcf01        #No.FUN-680104 VARCHAR(16) #No.FUN-4A0081
DEFINE g_argv2  STRING              #No.FUN-4A0081
DEFINE g_ima101        LIKE ima_file.ima101  #No.FUN-A80063
 
 
MAIN
DEFINE
    p_row,p_col   LIKE type_file.num5    #No.FUN-680104 SMALLINT
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP
   END IF 
 
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
   LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
   LET g_forupd_sql = "SELECT * FROM qcf_file WHERE qcf01 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t411_cl CURSOR FROM g_forupd_sql
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
      LET p_row = 2 LET p_col = 15
      OPEN WINDOW t411_w AT p_row,p_col   #顯示畫面
           WITH FORM "aqc/42f/aqct411"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      
      CALL cl_ui_init()
 
   END IF

   #FUN-BC0104--(S)-----
    IF g_qcz.qcz14='Y' THEN
      CALL cl_set_act_visible("qc_item_maintain",TRUE)
    ELSE 
      CALL cl_set_act_visible("qc_item_maintain",FALSE)
    END IF
    #FUN-BC0104--(E)-----
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t411_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t411_a()
            END IF
 
         WHEN "SPC_upd"                    #SPC-更新QC資料
            CALL t411_q()
            CALL t411_spc_upd()            
            EXIT PROGRAM
 
         OTHERWISE 
               CALL t411_q()
      END CASE
   END IF
 
   IF fgl_getenv('SPC') = "1" THEN
      CALL cl_err(g_prog ,'aws-093',0)
      EXIT PROGRAM 
   END IF 
 
   CALL t411_menu()
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",TRUE)
      CALL cl_set_comp_visible("qcfspc",TRUE)       #TQC-820019-modify
   END IF
   CLOSE WINDOW t411_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
END MAIN
 
#QBE 查詢資料
FUNCTION t411_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_qcg.clear()
 
 
  IF cl_null(g_argv1) THEN   #FUN-4A0081
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        qcf00,qcf01,qcf03,qcf05,qcf02,qcf021,qcf04,qcfspc,qcf041,qcf19,qcf20,qcf22,  #FUN-680010
        qcf091,qcf09,qcf13,qcf12,         #No.TQC-750064 del qcf06
        qcfuser,qcfgrup,qcfmodu,qcfdate,qcfacti,qcf14,qcf15
       ,qcfud01,qcfud02,qcfud03,qcfud04,qcfud05,
        qcfud06,qcfud07,qcfud08,qcfud09,qcfud10,
        qcfud11,qcfud12,qcfud13,qcfud14,qcfud15
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcf01) #單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_qcf3"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO qcf01
                   NEXT FIELD qcf01
              WHEN INFIELD(qcf021)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form = "q_ima"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY g_qryparam.multiret TO qcf021
                   NEXT FIELD qcf021
              WHEN INFIELD(qcf03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_shm"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO qcf03
                   NEXT FIELD qcf03
              WHEN INFIELD(qcf13) #員工編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO qcf13
                   NEXT FIELD qcf13
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
 
 
 
    CONSTRUCT g_wc2 ON qcg03,qcg04,qcg05,qcg10,qcg14,qcg15,qcg11,qcg07,qcg08 #螢幕上取單身條件       #No.FUN-A80063
                      ,qcgud01,qcgud02,qcgud03,qcgud04,qcgud05
                      ,qcgud06,qcgud07,qcgud08,qcgud09,qcgud10
                      ,qcgud11,qcgud12,qcgud13,qcgud14,qcgud15
                  FROM s_qcg[1].qcg03,s_qcg[1].qcg04,s_qcg[1].qcg05,
                       s_qcg[1].qcg10,s_qcg[1].qcg14,s_qcg[1].qcg15,s_qcg[1].qcg11,                  #No.FUN-A80063
                       s_qcg[1].qcg07,s_qcg[1].qcg08
                      ,s_qcg[1].qcgud01,s_qcg[1].qcgud02,s_qcg[1].qcgud03
                      ,s_qcg[1].qcgud04,s_qcg[1].qcgud05,s_qcg[1].qcgud06
                      ,s_qcg[1].qcgud07,s_qcg[1].qcgud08,s_qcg[1].qcgud09
                      ,s_qcg[1].qcgud10,s_qcg[1].qcgud11,s_qcg[1].qcgud12
                      ,s_qcg[1].qcgud13,s_qcg[1].qcgud14,s_qcg[1].qcgud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
 
  ELSE
      LET g_wc =" qcf01 = '",g_argv1,"'"    #No.FUN-4A0081
      LET g_wc2=" 1=1"
  END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
    IF g_wc2 = " 1=1" THEN     # 若單身未輸入條件
       LET g_sql = "SELECT  qcf01 FROM qcf_file ",
                   " WHERE qcf18='2' AND ", g_wc CLIPPED,
                   " ORDER BY qcf01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  qcf01 ",
                   "  FROM qcf_file, qcg_file ",
                   " WHERE qcf01 = qcg01 AND qcf18='2' ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY qcf01"
    END IF
 
    PREPARE t411_prepare FROM g_sql
    DECLARE t411_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t411_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM qcf_file",
                  " WHERE qcf18='2' AND ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT qcf01) ",
                  "  FROM qcf_file,qcg_file WHERE ",
                  "  qcg01=qcf01 AND qcf18='2' AND ",
                     g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t411_precount FROM g_sql
    DECLARE t411_count CURSOR FOR t411_precount
END FUNCTION
 
FUNCTION t411_menu()
   DEFINE l_qck09    LIKE qck_file.qck09    #FUN-BC0104

   WHILE TRUE
      CALL t411_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t411_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t411_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t411_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t411_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t411_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            CALL t411_out()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "detail_flaw_reason"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_qcf.qcf01) THEN
                  LET g_msg="aqct111 '",g_qcf.qcf01,"' 0 0 2 "
                  CALL cl_cmdrun(g_msg)
               END IF
            END IF
         WHEN "qry_detail_measure"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_qcf.qcf01) THEN
                  LET g_msg="aqcq112 '",g_qcf.qcf01,"' 0 0 2 "
                  CALL cl_cmdrun(g_msg)
               END IF
            END IF
         WHEN "detail_memo"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_qcf.qcf01) THEN
                  LET g_msg="aqct112 '",g_qcf.qcf01,"' 0 0 2 "
                  CALL cl_cmdrun(g_msg)
               END IF
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t411_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t411_y_upd()       #CALL 原確認的 update 段
               END IF
 
               IF g_qcf.qcf14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcf.qcf14,"","","",g_void,g_qcf.qcfacti)
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t411_z()
               IF g_qcf.qcf14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcf.qcf14,"","","",g_void,g_qcf.qcfacti)
            END IF
         WHEN "special_purchase"
            IF cl_chk_act_auth() THEN
               CALL t411_3()
            END IF
#FUN-A30045 ------------Begin-----------
         WHEN  "cancel_special_purchase"
            IF cl_chk_act_auth() THEN
               CALL t411_4()
            END IF         
#FUN-A30045 ------------End-------------

#FUN-BC0104 -----------------Begin-----------------
         WHEN "qc_item_maintain"
            IF cl_chk_act_auth() THEN
                  LET l_qck09=''  
                  SELECT DISTINCT qck09 INTO l_qck09 FROM ima_file,qck_file
                   WHERE qck01 = ima109
                     AND ima01 = g_qcf.qcf021
                IF g_qcz.qcz14 = 'Y' AND l_qck09 = 'Y' THEN                 
                  LET l_cmd = "aqci107 '",g_qcf.qcf01,"'"," 0 0"," '5'"
                  CALL cl_cmdrun_wait(l_cmd)
                 #CALL t411_qc_item_show()                #MOD-C30557
               ELSE                                       #TQC-C30139
                  CALL cl_err(m_ima109,'aqc-537',0)       #TQC-C30139
               END IF
            END IF
#FUN-BC0104 -----------------End-------------------

         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t411_x()   #FUN-D20025
               CALL t411_x(1)  #FUN-D20025  
               IF g_qcf.qcf14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcf.qcf14,"","","",g_void,g_qcf.qcfacti)
            END IF
         #FUN-D20025--add--str---
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
              #CALL t411_x()   #FUN-D20025
               CALL t411_x(2)  #FUN-D20025
               IF g_qcf.qcf14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcf.qcf14,"","","",g_void,g_qcf.qcfacti)
            END IF
         #FUN-D20025--add--end---
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcg),'','')
            END IF
         WHEN "trans_spc"         #FUN-680010
            IF cl_chk_act_auth() THEN
               CALL t411_spc()
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_qcf.qcf01 IS NOT NULL THEN
                 LET g_doc.column1 = "qcf01"
                 LET g_doc.value1 = g_qcf.qcf01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t411_a()
   DEFINE li_result   LIKE type_file.num5    #No.FUN-550063  #No.FUN-680104 SMALLINT
   DEFINE l_err       LIKE ze_file.ze01           #FUN-680010
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_qcg.clear()
    INITIALIZE g_qcf.* LIKE qcf_file.*             #DEFAULT 設定
    LET g_qcf01_t = NULL
    #預設值及將數值類變數清成零
    LET g_qcf_t.* = g_qcf.*
    LET g_qcf_o.* = g_qcf.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET m_gen02=' '
        LET m_ima109=' '
        LET qcf21_desc=' '
        LET ima101_desc = ' '     #CHI-BC0018
        LET qcf17_desc = ' '      #CHI-BC0018
        LET des1=' '
        LET des2=' '
        LET ma_num1=0
        LET ma_num2=0
        LET mi_num1=0
        LET mi_num2=0
        LET g_qcf.qcf22=0
        LET g_qcf.qcf00='1'
        LET g_qcf.qcfuser=g_user
        LET g_qcf.qcforiu = g_user #FUN-980030
        LET g_qcf.qcforig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_qcf.qcfgrup=g_grup
        LET g_qcf.qcfdate=g_today
        LET g_qcf.qcfacti='Y'              #資料有效
        LET g_qcf.qcf041=TIME              #資料有效
        LET g_qcf.qcf04=TODAY              #資料有效
        LET g_qcf.qcf05=1                  #MOD-8B0097 add
        LET g_qcf.qcfspc = '0'             #FUN-680010
        LET g_qcf.qcf14='N'
        LET g_qcf.qcf15=''
        LET g_qcf.qcf091=0
        LET g_qcf.qcf13=g_user
        LET g_qcf.qcf18='2'                #FUN-680010   搬到上面
 
           CALL t411_i("a")                   #輸入單頭
           IF INT_FLAG THEN                   #使用者不玩了
              INITIALIZE g_qcf.* TO NULL
              LET INT_FLAG = 0
              CALL cl_err('',9001,0)
              EXIT WHILE
           END IF
           IF g_qcf.qcf01 IS NULL THEN                # KEY 不可空白
               CONTINUE WHILE
           END IF
           BEGIN WORK #No:7857
          
           CALL s_auto_assign_no("asf",g_qcf.qcf01,g_qcf.qcf04,"B","qcf_file","qcf01","","","")     #No.FUN-560002
                RETURNING li_result,g_qcf.qcf01
           IF (NOT li_result) THEN
              CONTINUE WHILE
           END IF
           DISPLAY BY NAME g_qcf.qcf01
 
        LET g_qcf.qcfplant = g_plant #FUN-980007
        LET g_qcf.qcflegal = g_legal   #FUN-980007
 
        INSERT INTO qcf_file VALUES (g_qcf.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
           CALL cl_err3("ins","qcf_file",g_qcf.qcf01,"",SQLCA.sqlcode,"","",1)  #FUN-B80066
           ROLLBACK WORK #No:7857
           #CALL cl_err3("ins","qcf_file",g_qcf.qcf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115 #No.FUN-B80066
           CONTINUE WHILE
        ELSE
           COMMIT WORK #No:7857
           CALL cl_flow_notify(g_qcf.qcf01,'I')
        END IF
 
        SELECT qcf01 INTO g_qcf.qcf01 FROM qcf_file WHERE qcf01=g_qcf.qcf01
        LET g_qcf01_t = g_qcf.qcf01        #保留舊值
        LET g_qcf_t.* = g_qcf.*
 
        CALL g_qcg.clear()
        LET g_rec_b = 0
 
        CALL t411_g_b()
        CALL t411_b()                   #輸入單身
        IF NOT cl_null(g_qcf.qcf01) THEN   #CHI-C30002 add
           CALL t411_ii('a')
        END IF                             #CHI-C30002 add
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION t411_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_qcf.qcf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_qcf.* FROM qcf_file WHERE qcf01=g_qcf.qcf01
 
    IF g_qcf.qcfacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_qcf.qcf01,9027,0)
       RETURN
    END IF
    IF g_qcf.qcf14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_qcf.qcf14='Y' THEN RETURN END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_qcf01_t = g_qcf.qcf01
    LET g_qcf_o.* = g_qcf.*
 
    BEGIN WORK
 
    OPEN t411_cl USING g_qcf.qcf01
    IF STATUS THEN
       CALL cl_err("OPEN t411_cl:", STATUS, 1)
       CLOSE t411_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t411_cl INTO g_qcf.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t411_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t411_show()
 
    WHILE TRUE
        LET g_qcf01_t = g_qcf.qcf01
        LET g_qcf.qcfmodu=g_user
        LET g_qcf.qcfdate=g_today
 
        CALL t411_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_qcf.*=g_qcf_t.*
            CALL t411_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
        IF g_qcf.qcf01 != g_qcf01_t THEN
           UPDATE qcg_file SET qcg01=g_qcf.qcf01 WHERE qcg01 = g_qcf01_t
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","qcg_file",g_qcf01_t,"",SQLCA.sqlcode,"","qcg",1)  #No.FUN-660115
              CONTINUE WHILE 
           END IF
        END IF
 
        UPDATE qcf_file SET qcf_file.* = g_qcf.*
         WHERE qcf01 = g_qcf.qcf01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","qcf_file",g_qcf01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
           CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
 
    CALL t411_ii('u')
 
    # CALL aws_spccli()
    #功能: 通知 SPC 端刪除此張單據
    # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),update(修改),delete(刪除)
    # 回傳值  : 0 傳送失敗; 1 傳送成功
    IF g_qcf.qcfspc = '1' THEN
       IF NOT aws_spccli(g_prog,base.TypeInfo.create(g_qcf),'update') THEN
          LET g_qcf.* = g_qcf_t.*
          CLOSE t411_cl
          ROLLBACK WORK
          RETURN
       END IF
    END IF
 
    CLOSE t411_cl
 
    COMMIT WORK
    CALL cl_flow_notify(g_qcf.qcf01,'U')
END FUNCTION
 
 
#處理INPUT
FUNCTION t411_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改  #No.FUN-680104 VARCHAR(1)
    m_pmc03         LIKE pmc_file.pmc03,
    m_ima02         LIKE ima_file.ima02,
    m_ima109        LIKE ima_file.ima109,
    m_azf03         LIKE azf_file.azf03,
    m_pmh05         LIKE pmh_file.pmh05,
    m_pmh05_desc    LIKE ze_file.ze03,   #No.TQC-610007
    l_sgm53         LIKE sgm_file.sgm53,
    l_rvb08         LIKE rvb_file.rvb08,
    l_sfv09         LIKE sfv_file.sfv09,
    l_qcf22         LIKE qcf_file.qcf22,        #No.FUN-680104 DEC(12,0)
    l_acc_qty       LIKE qcf_file.qcf22         #No.FUN-680104 DEC(15,3)
 DEFINE l_msg       LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
 DEFINE l_str1      LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
 DEFINE l_str2      LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
 DEFINE li_result   LIKE type_file.num5     #No.FUN-550063  #No.FUN-680104 SMALLINT
 DEFINE l_err       LIKE ze_file.ze01     #FUN-680010
#FUN-A60092 --begin--
 DEFINE l_ecu012    LIKE ecu_file.ecu012
 DEFINE l_sgm03     LIKE sgm_file.sgm03
#FUN-A60092 --end--
 DEFINE l_ima55     LIKE ima_file.ima55       #FUN-BB0085
 
    DISPLAY BY NAME
       g_qcf.qcf00,g_qcf.qcf01,g_qcf.qcf03,g_qcf.qcf05,g_qcf.qcf02,g_qcf.qcf021,
       g_qcf.qcf04,g_qcf.qcfspc,g_qcf.qcf041,g_qcf.qcf21,g_qcf.qcf17,   #FUN-680010
       g_qcf.qcf19,g_qcf.qcf20,
       g_qcf.qcf22,g_qcf.qcf091,g_qcf.qcf09,g_qcf.qcf13,    #No.TQC-750064 del qcf06
       g_qcf.qcf12,g_qcf.qcf14,g_qcf.qcf15,
       g_qcf.qcfuser,g_qcf.qcfgrup,g_qcf.qcfmodu,g_qcf.qcfdate,g_qcf.qcfacti
      ,g_qcf.qcfud01,g_qcf.qcfud02,g_qcf.qcfud03,g_qcf.qcfud04,
       g_qcf.qcfud05,g_qcf.qcfud06,g_qcf.qcfud07,g_qcf.qcfud08,
       g_qcf.qcfud09,g_qcf.qcfud10,g_qcf.qcfud11,g_qcf.qcfud12,
       g_qcf.qcfud13,g_qcf.qcfud14,g_qcf.qcfud15 
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT BY NAME g_qcf.qcforiu,g_qcf.qcforig,
       g_qcf.qcf00,g_qcf.qcf01,g_qcf.qcf03,g_qcf.qcf05,g_qcf.qcf02,g_qcf.qcf021,
       g_qcf.qcf04,g_qcf.qcfspc,g_qcf.qcf041,g_qcf.qcf21,g_qcf.qcf17, #FUN-680010
       g_qcf.qcf19,g_qcf.qcf20,
       g_qcf.qcf22,             #No.TQC-750064 del qcf06
       g_qcf.qcfuser,g_qcf.qcfgrup,g_qcf.qcfmodu,g_qcf.qcfdate,g_qcf.qcfacti
      ,g_qcf.qcfud01,g_qcf.qcfud02,g_qcf.qcfud03,g_qcf.qcfud04,
       g_qcf.qcfud05,g_qcf.qcfud06,g_qcf.qcfud07,g_qcf.qcfud08,
       g_qcf.qcfud09,g_qcf.qcfud10,g_qcf.qcfud11,g_qcf.qcfud12,
       g_qcf.qcfud13,g_qcf.qcfud14,g_qcf.qcfud15 
 
       WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t411_set_entry(p_cmd)
            CALL t411_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("qcf01")
 
        BEFORE FIELD qcf00
            CALL t411_set_entry(p_cmd)
 
        AFTER FIELD qcf00
            IF NOT cl_null(g_qcf.qcf00) THEN
               IF g_qcf.qcf00 NOT MATCHES '[12]' THEN
                  NEXT FIELD qcf00
               END IF
               CALL t411_set_no_entry(p_cmd)
            END IF
 
        AFTER FIELD qcf01              #FQC編號
            IF NOT cl_null(g_qcf.qcf01) AND (g_qcf.qcf01!=g_qcf_t.qcf01 OR cl_null(g_qcf_t.qcf01)) THEN
              #LET g_t1=s_get_doc_no(g_qcf.qcf01)  #FUN-B50026 mark
              #CALL s_check_no("asf",g_t1,"","B","qcf_file","qcf01","")     #No.FUN-560002
               CALL s_check_no("asf",g_qcf.qcf01,g_qcf_t.qcf01,"B","qcf_file","qcf01","")     #No.FUN-560002 #FUN-B50026 mod
                 RETURNING li_result,g_qcf.qcf01
               IF (NOT li_result) THEN
                  NEXT FIELD qcf01
               END IF
               
               LET g_qcf_o.qcf01=g_qcf.qcf01
 
            END IF
 
        AFTER FIELD qcf03
            IF NOT cl_null(g_qcf.qcf03) THEN
               CALL t411_qcf03() RETURNING l_err
               IF NOT cl_null(l_err) THEN
                  CALL cl_err(g_qcf.qcf03,l_err,1)
                  NEXT FIELD qcf03                 
               END IF
             #TQC-C90043
               IF NOT t411_qcf22_check() THEN
                  NEXT FIELD qcf03
               END IF
            #TQC-C90043
            END IF
 
        AFTER FIELD qcf021
            IF NOT cl_null(g_qcf.qcf021) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_qcf.qcf021,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_qcf.qcf021= g_qcf_t.qcf021
                  NEXT FIELD qcf021
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               CALL t411_qcf021() RETURNING l_err
               IF NOT cl_null(l_err) THEN
                  CALL cl_err(g_qcf.qcf021,l_err,1)
                  NEXT FIELD qcf021                 
               END IF
               #FUN-BB0085-add-str--
               IF cl_null(g_qcf_t.qcf021) OR g_qcf_t.qcf021 != g_qcf.qcf021 THEN 
                  SELECT ima55 INTO l_ima55 FROM ima_file
                   WHERE ima01 = g_qcf.qcf021
                 IF g_qcf.qcf09<>'1' OR cl_null(g_qcf.qcf09) THEN      #FUN-C20068
                    LET g_qcf.qcf22 = s_digqty(g_qcf.qcf22,l_ima55)    #FUN-C20068
                    DISPLAY BY NAME g_qcf.qcf22                        #FUN-C20068
                 ELSE
                    IF NOT t411_qcf22_check() THEN    
                       NEXT FIELD qcf22               
                    END IF                           
                 END IF
               END IF 
               #FUN-BB0085-add-end--
            END IF
        AFTER FIELD qcf22
            #FUN-BB0085-add-str--
            IF NOT t411_qcf22_check() THEN 
               NEXT FIELD qcf22
            END IF
            #FUN-BB0085-add-end--
#FUN-BB0085----------------------mark--------------------str---------------------
#            IF NOT cl_null(g_qcf.qcf22) THEN
#               IF g_qcf.qcf22 < 0 THEN CALL cl_err('','aqc-016',0)
#                  NEXT FIELD qcf22
#               END IF
#               IF g_qcf.qcf22 = 0 THEN
#                  CALL cl_err('','aqc-028',0)
#                  NEXT FIELD qcf22
#               END IF
#            IF g_qcf.qcf00 <> '2' THEN #MOD-850258 add 
#               LET g_max_qcf22=0
#               LET l_acc_qty =0
#               LET l_qcf22 =0
#               
#               CALL t411_max_sgm03(g_qcf.qcf02) RETURNING l_ecu012,l_sgm03    #FUN-A60092 
#               SELECT (sgm311+sgm315+sgm316+sgm317)
#                 INTO g_max_qcf22
#                 FROM sgm_file
#                WHERE sgm01=g_qcf.qcf03
##FUN-A60092 --begin--                
##                 AND sgm03=(SELECT MAX(sgm03)   #終站程序
##                              FROM sgm_file
##                             WHERE sgm01=g_qcf.qcf03)
#                  AND sgm012 = l_ecu012
#                  AND sgm03  = l_sgm03
##FUN-A60092 --end--                  
#               CALL t411_qcf22() RETURNING l_qcf22
#               LET l_acc_qty = g_max_qcf22-l_qcf22
#               IF g_qcf.qcf22 > l_acc_qty THEN
#                  LET l_qcf22 = l_qcf22+g_qcf.qcf22
#                  CALL cl_getmsg('aqc-427',g_lang) RETURNING l_str1
#                  CALL cl_getmsg('aqc-428',g_lang) RETURNING l_str2
#                  LET l_msg = l_str2 CLIPPED,l_qcf22 USING "######.###",
#                              " > ",l_str1 CLIPPED,g_max_qcf22 USING "######.###"
#                   CALL cl_msgany(0,0,l_msg)
#                  NEXT FIELD qcf22
#               END IF
#               IF g_qcf.qcf22>g_max_qcf22 THEN
#                  CALL cl_err(g_max_qcf22,'asf-673',0)
#                  NEXT FIELD qcf22
#               END IF
#            END IF #MOD-850258 add 
#               LET g_qcf22=g_qcf.qcf22               #bugno:7196
#            END IF
#FUN-BB0085----------------------mark--------------------end--------------------- 
        AFTER FIELD qcfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcf01) #單號
                   LET g_t1 = s_get_doc_no(g_qcf.qcf01)       #No.FUN-550063
                   CALL q_smy(FALSE,FALSE,g_t1,'ASF','B') RETURNING g_t1 #TQC-670008
                   LET g_qcf.qcf01 = g_t1       #No.FUN-550063
                   DISPLAY BY NAME g_qcf.qcf01
                   NEXT FIELD qcf01
              WHEN INFIELD(qcf021)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_qcf.qcf021
#                  CALL cl_create_qry() RETURNING g_qcf.qcf021
                   CALL q_sel_ima(FALSE, "q_ima","",g_qcf.qcf021,"","","","","",'' ) 
                     RETURNING  g_qcf.qcf021  
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_qcf.qcf021
                   NEXT FIELD qcf021
              WHEN INFIELD(qcf03)
                  #FUN-C30163 mark START
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_shm"
                  #LET g_qryparam.default1 = g_qcf.qcf03
                  #CALL cl_create_qry() RETURNING g_qcf.qcf03
                  #FUN-C30163 mark END
                  #FUN-C30163 add START
                   CALL q_sel_shm01(FALSE,TRUE,g_qcf.qcf03,g_qcf.qcf01)
                      RETURNING g_qcf.qcf03
                  #FUN-C30163 add END
                   DISPLAY BY NAME g_qcf.qcf03
                   NEXT FIELD qcf03
              WHEN INFIELD(qcf13) #員工編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_qcf.qcf13
                   CALL cl_create_qry() RETURNING g_qcf.qcf13
                   DISPLAY BY NAME g_qcf.qcf13
                   NEXT FIELD qcf13
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
 
#Query 查詢
FUNCTION t411_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_qcf.* TO NULL              #No.FUN-6A0160
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_qcg.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t411_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t411_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_qcf.* TO NULL
    ELSE
       OPEN t411_count
       FETCH t411_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t411_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t411_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t411_cs INTO g_qcf.qcf01
        WHEN 'P' FETCH PREVIOUS t411_cs INTO g_qcf.qcf01
        WHEN 'F' FETCH FIRST    t411_cs INTO g_qcf.qcf01
        WHEN 'L' FETCH LAST     t411_cs INTO g_qcf.qcf01
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
            FETCH ABSOLUTE g_jump t411_cs INTO g_qcf.qcf01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)
        INITIALIZE g_qcf.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_qcf.* FROM qcf_file WHERE qcf01 = g_qcf.qcf01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","qcf_file",g_qcf.qcf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
        INITIALIZE g_qcf.* TO NULL
    ELSE
        LET g_data_owner = g_qcf.qcfuser     #FUN-4C0038
        LET g_data_group = g_qcf.qcfgrup     #FUN-4C0038
        LET g_data_plant = g_qcf.qcfplant #FUN-980030
        CALL t411_show()
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t411_show()
   DEFINE m_ima02         LIKE ima_file.ima02,       #No.FUN-680104 VARCHAR(30)
          m_ima021        LIKE ima_file.ima021,
          m_azf03         LIKE azf_file.azf03,       #No.FUN-680104 VARCHAR(30)
          m_qcf091        LIKE qcf_file.qcf091,      #No.FUN-680104 DEC(12,3)
          l_qcf22         LIKE qcf_file.qcf22
 
    LET g_qcf_t.* = g_qcf.*                #保存單頭舊值
    DISPLAY BY NAME g_qcf.qcforiu,g_qcf.qcforig,                              # 顯示單頭值
       g_qcf.qcf00,g_qcf.qcf01,g_qcf.qcf03,g_qcf.qcf05,g_qcf.qcf02,g_qcf.qcf021,
       g_qcf.qcf04,g_qcf.qcfspc,g_qcf.qcf041,g_qcf.qcf21,g_qcf.qcf17, #FUN-680010
       g_qcf.qcf19,g_qcf.qcf20,
       g_qcf.qcf22,g_qcf.qcf091,g_qcf.qcf09,g_qcf.qcf13,    #No.TQC-750064 del qcf06
       g_qcf.qcf12,g_qcf.qcf14,g_qcf.qcf15,
       g_qcf.qcfuser,g_qcf.qcfgrup,g_qcf.qcfmodu,g_qcf.qcfdate,g_qcf.qcfacti
      ,g_qcf.qcfud01,g_qcf.qcfud02,g_qcf.qcfud03,g_qcf.qcfud04,
       g_qcf.qcfud05,g_qcf.qcfud06,g_qcf.qcfud07,g_qcf.qcfud08,
       g_qcf.qcfud09,g_qcf.qcfud10,g_qcf.qcfud11,g_qcf.qcfud12,
       g_qcf.qcfud13,g_qcf.qcfud14,g_qcf.qcfud15
 
    SELECT ima02,ima109,ima101 INTO m_ima02,m_ima109,g_ima101 FROM ima_file    #No.FUN-A80063
       WHERE ima01=g_qcf.qcf021
    IF STATUS=100 THEN LET m_ima02 = ' ' LET m_ima109=' ' END IF
    DISPLAY m_ima02 TO FORMONLY.ima02
    DISPLAY m_ima109 TO FORMONLY.ima109
    DISPLAY g_ima101 TO ima101   #No.FUN-A80063
 
    SELECT azf03 INTO m_azf03 FROM azf_file
       WHERE azf01=m_ima109 AND azf02='8'
    IF STATUS THEN LET m_azf03=' ' END IF
    DISPLAY m_azf03 TO FORMONLY.azf03
 
    CASE g_qcf.qcf09
         WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
         WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING des1
         WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING des1 #BugNo:5046
    END CASE
    DISPLAY des1 TO FORMONLY.des1
 
    CASE g_qcf.qcf21
         WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcf21_desc
         WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcf21_desc
         WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcf21_desc
    END CASE
    DISPLAY qcf21_desc TO FORMONLY.qcf21_desc

   #----------CHI-BC0018 str add-----------------
   CASE g_ima101
      WHEN '1'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_1' AND gae03=g_lang

      WHEN '2'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_2' AND gae03=g_lang

      WHEN '3'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_3' AND gae03=g_lang

      WHEN '4'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_4' AND gae03=g_lang

      OTHERWISE
         LET ima101_desc=' '
   END CASE
   DISPLAY ima101_desc TO FORMONLY.ima101_desc
   
    CASE g_qcf.qcf17
      WHEN '1'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
      WHEN '7'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcf17_desc= ' '
    END CASE
   DISPLAY qcf17_desc TO FORMONLY.qcf17_desc
   #----------CHI-BC0018 end add-----------------
 
    SELECT gen02 INTO m_gen02 FROM gen_file WHERE gen01=g_qcf.qcf13
    DISPLAY m_gen02 TO FORMONLY.gen02
 
    CALL t411_shm('q')   #MOD-8A0131 add 'q'
    IF g_qcf.qcf14 = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_qcf.qcf14,"","","",g_void,g_qcf.qcfacti)
    CALL t411_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整 筆 (所有合乎單頭的資料)
FUNCTION t411_r()
   DEFINE l_cnt        LIKE type_file.num5   #FUN-940113
   DEFINE l_cnt1   LIKE type_file.num10        #FUN-BC0104
 
   IF s_shut(0) THEN RETURN END IF
   IF g_qcf.qcf01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_qcf.* FROM qcf_file WHERE qcf01=g_qcf.qcf01
   IF g_qcf.qcfacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_qcf.qcf01,9027,0)
      RETURN
   END IF
   IF g_qcf.qcf14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_qcf.qcf14='Y' THEN RETURN END IF

#FUN-BC0104 --------------Begin--------------
   SELECT count(*) INTO l_cnt1 FROM qco_file
    WHERE qco01 = g_qcf.qcf01
      AND qco02 = 0
      AND qco05 = 0
   IF cl_null(l_cnt1) THEN
      LET l_cnt1 = 0
   END IF
   IF l_cnt1 > 0 THEN
      IF NOT cl_confirm('aqc-056') THEN
         RETURN
      END IF
   END IF
#FUN-BC0104 --------------End----------------
 
    BEGIN WORK
 
    OPEN t411_cl USING g_qcf.qcf01
    IF STATUS THEN
       CALL cl_err("OPEN t411_cl:", STATUS, 1)
       CLOSE t411_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t411_cl INTO g_qcf.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t411_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t411_show()
 
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "qcf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_qcf.qcf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM qcf_file WHERE qcf01 = g_qcf.qcf01
       DELETE FROM qcg_file WHERE qcg01 = g_qcf.qcf01
       DELETE FROM qcu_file WHERE qcu01 = g_qcf.qcf01
    #FUN-BC0104 -------------Begin---------------
       DELETE FROM qco_file WHERE qco01 = g_qcf.qcf01
                              AND qco02 = 0
                              AND qco05 = 0  
    #FUN-BC0104 -------------End-----------------
       # 對應之測量值資料一併刪除
       DELETE FROM qcgg_file WHERE qcgg01 = g_qcf.qcf01
       DELETE FROM qcv_file WHERE qcv01 = g_qcf.qcf01  #FUN-680010
 
      SELECT COUNT(*) INTO l_cnt FROM shb_file                                                                                      
       WHERE shb22 = g_qcf.qcf01                                                                                            
         AND shbconf = 'Y'     #FUN-A70095
       IF SQLCA.sqlcode THEN LET l_cnt = 0  END IF                                                                                   
       IF l_cnt>0 THEN                                                                                                               
         UPDATE shb_file SET shb22 = NULL                                                                                           
          WHERE shb22 = g_qcf.qcf01                                                                                                 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                                                                
            CALL cl_err('upd shb22',SQLCA.sqlcode,1)                                                                                
            ROLLBACK WORK                                                                                                           
            RETURN                                                                                                                  
         END IF                                                                                                                     
      END IF                                                                                                                        
        
       IF g_aza.aza64 NOT matches '[ Nn]' THEN 
          # CALL aws_spccli()
          #功能: 通知 SPC 端刪除此張單據
          # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),delete(刪除)
          # 回傳值  : 0 傳送失敗; 1 傳送成功
          IF g_qcf.qcfspc = '1' THEN
             IF NOT aws_spccli(g_prog,base.TypeInfo.create(g_qcf),'delete') THEN
                CLOSE t411_cl
                ROLLBACK WORK
                RETURN
             END IF
          END IF
       END IF
 
       INITIALIZE g_qcf.* TO NULL
       CLEAR FORM
       CALL g_qcg.clear()
    END IF
 
    CLOSE t411_cl
    COMMIT WORK
    CALL cl_flow_notify(g_qcf.qcf01,'D')
 
END FUNCTION
 
#單身
FUNCTION t411_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680104 SMALLINT
    l_n,l_cnt,l_num,l_numcr,l_numma,l_nummi LIKE type_file.num5,         #No.FUN-680104 SMALLINT #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680104 VARCHAR(1)
    l_qcd07         LIKE qcd_file.qcd07,
   #將l_qct07改宣告為整數形態，因為當缺點數乘上權數後
   #是以無條件捨去，取整數來作比較
    l_qcg07         LIKE qcg_file.qcg07,   #No.CHI-740037 add
    l_chkqty        LIKE type_file.num5,
    l_qcd05         LIKE qcd_file.qcd05,
    l_qcd061        LIKE qcd_file.qcd061,
    l_qcd062        LIKE qcd_file.qcd062,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
    DEFINE l_sql    STRING     #No.FUN-910079
    DEFINE l_length         LIKE type_file.num10               #No:MOD-9B0024 add
#No.FUN-A80130 --begin
DEFINE l_avg           LIKE qcgg_file.qcgg04
DEFINE l_qcgg04        LIKE qcgg_file.qcgg04
DEFINE l_sum           LIKE qcgg_file.qcgg04
DEFINE l_stddev        LIKE qcgg_file.qcgg04
DEFINE l_k_max         LIKE qcgg_file.qcgg04
DEFINE l_k_min         LIKE qcgg_file.qcgg04
DEFINE l_f             LIKE qcgg_file.qcgg04
DEFINE l_qcd           RECORD LIKE qcd_file.*
DEFINE l_qcd03         LIKE qcd_file.qcd03
DEFINE l_qcd04         LIKE qcd_file.qcd04
#No.FUN-A80130 --end 
DEFINE l_count         LIKE type_file.num5     #FUN-BC0104

    
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_qcf.qcf01 IS NULL THEN
        RETURN
    END IF
 
    SELECT * INTO g_qcf.* FROM qcf_file WHERE qcf01=g_qcf.qcf01
    IF g_qcf.qcfacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_qcf.qcf01,'aom-000',0)
       RETURN
    END IF
    IF g_qcf.qcf14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_qcf.qcf14='Y' THEN RETURN END IF

#FUN-BC0104 ----------------Begin-----------------
   SELECT COUNT(*) INTO l_count FROM qco_file
    WHERE qco01 = g_qcf.qcf01
      AND qco02 = 0
      AND qco05 = 0
   IF cl_null(l_count) THEN LET l_count = 0 END IF
   IF l_count > 0 THEN
      CALL cl_err(g_qcf.qcf01,'aqc-402',0)
      RETURN
   END IF
#FUN-BC0104 ----------------End-------------------
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT qcg03,qcg04,'',qcg05,qcg06,qcg09,qcg10,qcg14,qcg15,qcg11,qcg07,qcg08,'' ",          #No.FUN-A80063
        "      ,qcgud01,qcgud02,qcgud03,qcgud04,qcgud05,",
        "       qcgud06,qcgud07,qcgud08,qcgud09,qcgud10,",
        "       qcgud11,qcgud12,qcgud13,qcgud14,qcgud15",
 
        " FROM qcg_file ",
        " WHERE qcg01= ? AND qcg03= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t411_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
     LET l_allow_insert = FALSE
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qcg WITHOUT DEFAULTS FROM s_qcg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t411_cl USING g_qcf.qcf01
            IF STATUS THEN
               CALL cl_err("OPEN t411_cl:", STATUS, 1)
               CLOSE t411_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t411_cl INTO g_qcf.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t411_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_qcg_t.* = g_qcg[l_ac].*  #BACKUP
 
                OPEN t411_bcl USING g_qcf.qcf01, g_qcg_t.qcg03
                IF STATUS THEN
                   CALL cl_err("OPEN t411_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t411_bcl INTO g_qcg[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_qcg_t.qcg03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT azf03 INTO g_qcg[l_ac].azf03_1 FROM azf_file
                         WHERE azf01=g_qcg[l_ac].qcg04 AND azf02='6'
 
                      CASE g_qcg[l_ac].qcg08
                           WHEN '1' CALL cl_getmsg('aqc-004',g_lang)
                                         RETURNING g_qcg[l_ac].qcg08_desc
                           WHEN '2' CALL cl_getmsg('aqc-033',g_lang)
                                         RETURNING g_qcg[l_ac].qcg08_desc
                      END CASE
                   END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            BEGIN WORK
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qcg[l_ac].* TO NULL      #900423
            LET g_qcg_t.* = g_qcg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qcg03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_qcg[l_ac].qcg07=0 THEN
               DELETE FROM qcu_file
                  WHERE qcu01=g_qcf.qcf01
                    AND qcu03=g_qcg[l_ac].qcg03
            END IF
 
             INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, #No.MOD-470041
                                  qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,
                                  qcgud01,qcgud02,qcgud03,
                                  qcgud04,qcgud05,qcgud06,
                                  qcgud07,qcgud08,qcgud09,
                                  qcgud10,qcgud11,qcgud12,
                                  qcgud13,qcgud14,qcgud15,
                                  qcgplant,qcglegal)  #FUN-980007
                 VALUES(g_qcf.qcf01,g_qcg[l_ac].qcg03,g_qcg[l_ac].qcg04,
                        g_qcg[l_ac].qcg05,g_qcg[l_ac].qcg06,g_qcg[l_ac].qcg07,
                        g_qcg[l_ac].qcg08,g_qcg[l_ac].qcg09,g_qcg[l_ac].qcg10,
                        g_qcg[l_ac].qcg11,l_qcd05,0,0,
                        g_qcg[l_ac].qcgud01, g_qcg[l_ac].qcgud02,
                        g_qcg[l_ac].qcgud03, g_qcg[l_ac].qcgud04,
                        g_qcg[l_ac].qcgud05, g_qcg[l_ac].qcgud06,
                        g_qcg[l_ac].qcgud07, g_qcg[l_ac].qcgud08,
                        g_qcg[l_ac].qcgud09, g_qcg[l_ac].qcgud10,
                        g_qcg[l_ac].qcgud11, g_qcg[l_ac].qcgud12,
                        g_qcg[l_ac].qcgud13, g_qcg[l_ac].qcgud14,
                        g_qcg[l_ac].qcgud15,
                        g_plant,g_legal)               #FUN-980007
 
 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","qcg_file",g_qcf.qcf01,g_qcg[l_ac].qcg03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        BEFORE FIELD qcg03                        #default 序號
            IF g_qcg[l_ac].qcg03 IS NULL OR
               g_qcg[l_ac].qcg03 = 0 THEN
                SELECT max(qcg03)+1 INTO g_qcg[l_ac].qcg03 FROM qcg_file
                 WHERE qcg01 = g_qcf.qcf01
                IF g_qcg[l_ac].qcg03 IS NULL THEN
                    LET g_qcg[l_ac].qcg03 = 1
                END IF
            END IF
 
        AFTER FIELD qcg11
            IF g_qcg[l_ac].qcg11<=0 THEN NEXT FIELD qcg11 END IF
            IF g_qcg[l_ac].qcg11 IS NULL THEN LET g_qcg[l_ac].qcg11=0 END IF
         LET l_sql = " SELECT qcd05,qcd061,qcd062,qcd07",
                     " FROM qcd_file",
                     "  WHERE qcd01 = ? AND qcd02 = ? ",
                     " AND qcd08 in ('2','9')"
         PREPARE qcd_sel1 FROM l_sql  
         EXECUTE qcd_sel1 USING g_qcf.qcf021,g_qcg[l_ac].qcg04
          INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07             
 
            IF STATUS=100 THEN
            LET l_sql = " SELECT qck07 FROM qck_file,ima_file", 
                        "  WHERE ima01=? AND qck01=ima109",
                        "  AND qck02= ?",
                        " AND qck08 in ('2','9')"
            PREPARE qck_sel1 FROM l_sql  
            EXECUTE qck_sel1 USING g_qcf.qcf021,g_qcg[l_ac].qcg04
              INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                        
               IF STATUS=100 THEN
                  LET l_qcd07='N'
               END IF
            END IF
 
            IF g_qcg[l_ac].qcg11>0 AND l_qcd07='Y'AND g_qcz.qcz01='Y' THEN
               CALL t411_more_b1(g_qcg[l_ac].qcg11,l_qcd05,l_qcd061,l_qcd062,
                                 g_qcg[l_ac].qcg03,g_qcg[l_ac].qcg04)
               #----- 測量值總數量是否符合應檢驗數
               SELECT COUNT(*) INTO g_cnt FROM qcgg_file
                  WHERE qcgg01 = g_qcf.qcf01
                    AND qcgg03 = g_qcg[l_ac].qcg03
               IF g_cnt != g_qcg[l_ac].qcg11 THEN
                  LET g_msg=g_cnt,': ',g_qcg[l_ac].qcg11
                  CALL cl_err(g_msg,'aqc-038',0)
                  NEXT FIELD qcg11
               END IF
            END IF
 
            IF g_qcg[l_ac].qcg07 IS NULL THEN LET g_qcg[l_ac].qcg07 = 0 END IF
 
        AFTER FIELD qcg07
            #MOD-C30634--mark--str--
            #IF g_qcg[l_ac].qcg07 > g_qcg[l_ac].qcg11 THEN
            #    #不良數量應<=檢驗量
            #    CALL cl_err(g_qcg[l_ac].qcg07,'aqc-112',0)
            #    LET g_qcg[l_ac].qcg07 = g_qcg_t.qcg07
            #    DISPLAY BY NAME g_qcg[l_ac].qcg07
            #    NEXT FIELD qcg07
            #END IF
            #MOD-C30634--mark--end--
            IF g_qcg[l_ac].qcg07 > 0 THEN
               CALL t411_more_b()
            END IF
#No.FUN-A80063 --begin
         #---- 項目判定
         SELECT *
           INTO l_qcd.* FROM qcd_file
          WHERE qcd01 = g_qcf.qcf021
            AND qcd02 = g_qcg[l_ac].qcg04
            AND qcd08 IN ('2','9')             #No.FUN-910079
         IF STATUS = 100 THEN
             SELECT qck_file.* INTO l_qcd.* FROM qck_file,ima_file 
              WHERE ima01=g_qcf.qcf021 AND qck01=ima109 AND qck02=g_qcg[l_ac].qcg04
                AND qck08 IN ('2','9')             #No.FUN-910079
            IF STATUS = 100 THEN
               LET l_qcd07 = 'N'
            END IF
         END IF 
         IF l_qcd.qcd05 ='4' THEN 
            SELECT SUM(qcgg04) INTO l_qcgg04
              FROM qcgg_file
             WHERE qcgg01 = g_qcf.qcf01
               AND qcgg02 = g_qcf.qcf02
               AND qcgg021= g_qcf.qcf05
               AND qcgg03 = g_qcg[l_ac].qcg03
            IF cl_null(l_qcgg04) THEN 
               LET l_qcgg04 = 0
            END IF  
            LET l_avg = l_qcgg04 / g_qcg[l_ac].qcg11
            
            LET l_sum = 0 
            DECLARE qcgg_sel CURSOR FOR 
              SELECT qcgg04 FROM qcgg_file
               WHERE qcgg01 = g_qcf.qcf01
                 AND qcgg02 = g_qcf.qcf02
                 AND qcgg021= g_qcf.qcf05
                 AND qcgg03 = g_qcg[l_ac].qcg03
            FOREACH qcgg_sel INTO l_qcgg04
              LET l_sum = l_sum + ((l_qcgg04 - l_avg)*(l_qcgg04 - l_avg))
            END FOREACH 
            LET l_stddev = s_power(l_sum/(g_qcg[l_ac].qcg11 -1),2)
            LET l_k_max  = (l_qcd.qcd062 - l_avg)/l_stddev
            LET l_k_min  = (l_avg - l_qcd.qcd061)/l_stddev
            LET l_f      = l_stddev/(l_qcd.qcd062 - l_qcd.qcd061)
            IF cl_null(l_qcd.qcd061) OR cl_null(l_qcd.qcd061) THEN 
               IF cl_null(l_qcd.qcd061) THEN 
                  IF l_k_max >= g_qcg[l_ac].qcg14 THEN 
                     LET g_qcg[l_ac].qcg08 ='1'
                  ELSE
                  	 LET g_qcg[l_ac].qcg08 ='2'
                  END IF  
               ELSE 
                  IF l_k_min >= g_qcg[l_ac].qcg14 THEN 
                     LET g_qcg[l_ac].qcg08 ='1'
                  ELSE
                  	 LET g_qcg[l_ac].qcg08 ='2'
                  END IF 
               END IF 
            ELSE 
            	 IF l_k_min >= g_qcg[l_ac].qcg14 AND l_k_max >= g_qcg[l_ac].qcg14 AND l_f >= g_qcg[l_ac].qcg15 THEN 
                  LET g_qcg[l_ac].qcg08 ='1'
               ELSE 
               	  LET g_qcg[l_ac].qcg08 ='2'
               END IF 
            END IF 
         ELSE 
#No.FUN-A80063 --end 
           #在判定合格或驗退時，應先將缺點數乘上CR/MA/MI權數
             CASE g_qcg[l_ac].qcg05
                 WHEN "1"
                       LET l_chkqty = g_qcg[l_ac].qcg07*g_qcz.qcz02/g_qcz.qcz021  #No.TQC-750209 modify
                 WHEN "2"
                       LET l_chkqty = g_qcg[l_ac].qcg07*g_qcz.qcz03/g_qcz.qcz031  #No.TQC-750209 modify 
                 WHEN "3"
                       LET l_chkqty = g_qcg[l_ac].qcg07*g_qcz.qcz04/g_qcz.qcz041  #No.TQC-750209 modify 
                 OTHERWISE
                       LET l_chkqty = g_qcg[l_ac].qcg07                           #No.TQC-750209 modify
             END CASE
            IF l_chkqty>=g_qcg[l_ac].qcg10 THEN          #No.TQC-750209 modify
               LET g_qcg[l_ac].qcg08='2'
            ELSE
               LET g_qcg[l_ac].qcg08='1'
            END IF
         END IF            #No.FUN-A80063
            CASE g_qcg[l_ac].qcg08
                 WHEN '1' CALL cl_getmsg('aqc-004',g_lang)
                               RETURNING g_qcg[l_ac].qcg08_desc
                 WHEN '2' CALL cl_getmsg('aqc-033',g_lang)
                               RETURNING g_qcg[l_ac].qcg08_desc
            END CASE
            DISPLAY BY NAME g_qcg[l_ac].qcg08_desc
            DISPLAY BY NAME g_qcg[l_ac].qcg08
 
        AFTER FIELD qcgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_qcg_t.qcg03 > 0 AND
               g_qcg_t.qcg03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM qcg_file
                 WHERE qcg01 = g_qcf.qcf01
                   AND qcg03 = g_qcg_t.qcg03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","qcg_file",g_qcf.qcf01,g_qcg_t.qcg03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                    DELETE FROM qcu_file
                    WHERE qcu01 = g_qcf.qcf01
                      AND qcu03 = g_qcg_t.qcg03
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qcg[l_ac].* = g_qcg_t.*
               CLOSE t411_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_qcg[l_ac].qcg03,-263,1)
               LET g_qcg[l_ac].* = g_qcg_t.*
            ELSE
 
               IF g_qcg[l_ac].qcg07=0 THEN
                  DELETE FROM qcu_file
                   WHERE qcu01=g_qcf.qcf01
                     AND qcu03=g_qcg[l_ac].qcg03
               END IF
 
               UPDATE qcg_file SET qcg03=g_qcg[l_ac].qcg03,
                                   qcg04=g_qcg[l_ac].qcg04,
                                   qcg05=g_qcg[l_ac].qcg05,
                                   qcg06=g_qcg[l_ac].qcg06,
                                   qcg07=g_qcg[l_ac].qcg07,
                                   qcg08=g_qcg[l_ac].qcg08,
                                   qcg09=g_qcg[l_ac].qcg09,
                                   qcg10=g_qcg[l_ac].qcg10,
                                   qcg11=g_qcg[l_ac].qcg11,
                                   qcg12=l_qcd05
                                  ,qcgud01 = g_qcg[l_ac].qcgud01,
                                   qcgud02 = g_qcg[l_ac].qcgud02,
                                   qcgud03 = g_qcg[l_ac].qcgud03,
                                   qcgud04 = g_qcg[l_ac].qcgud04,
                                   qcgud05 = g_qcg[l_ac].qcgud05,
                                   qcgud06 = g_qcg[l_ac].qcgud06,
                                   qcgud07 = g_qcg[l_ac].qcgud07,
                                   qcgud08 = g_qcg[l_ac].qcgud08,
                                   qcgud09 = g_qcg[l_ac].qcgud09,
                                   qcgud10 = g_qcg[l_ac].qcgud10,
                                   qcgud11 = g_qcg[l_ac].qcgud11,
                                   qcgud12 = g_qcg[l_ac].qcgud12,
                                   qcgud13 = g_qcg[l_ac].qcgud13,
                                   qcgud14 = g_qcg[l_ac].qcgud14,
                                   qcgud15 = g_qcg[l_ac].qcgud15
 
                WHERE qcg01=g_qcf.qcf01 AND
                      qcg03=g_qcg_t.qcg03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","qcg_file",g_qcf.qcf01,g_qcg_t.qcg03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                  LET g_qcg[l_ac].* = g_qcg_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qcg[l_ac].* = g_qcg_t.*
               END IF
               CLOSE t411_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t411_bcl
            COMMIT WORK
            LET l_length = g_qcg.getlength()
            IF l_ac = l_length THEN 
                EXIT INPUT
            END IF
 
        ON ACTION detail_flaw_reason
            IF g_qcg[l_ac].qcg07 > 0 THEN
               CALL t411_more_b()
            END IF
 
        ON ACTION detail_memo
                     CALL t411_b_memo()
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
    LET g_qcf.qcfmodu = g_user
    LET g_qcf.qcfdate = g_today
    UPDATE qcf_file SET qcfmodu = g_qcf.qcfmodu,qcfdate = g_qcf.qcfdate
     WHERE qcf01 = g_qcf.qcf01
    DISPLAY BY NAME g_qcf.qcfmodu,g_qcf.qcfdate
 
    CLOSE t411_bcl
    COMMIT WORK
 
    #------------------------------------------------- 單身不良總合判定
    LET l_cnt=0 LET l_numcr=0 LET l_numma=0 LET l_nummi=0
 
    SELECT COUNT(*) INTO l_cnt FROM qcg_file
     WHERE qcg01=g_qcf.qcf01
       AND qcg08='2'
    IF l_cnt>0 THEN LET g_qcf.qcf09='2' ELSE LET g_qcf.qcf09='1' END IF
 
    #--------- CR 不良數
    SELECT SUM(qcg07) INTO l_numcr FROM qcg_file
     WHERE qcg01=g_qcf.qcf01 AND qcg05='1'
    IF l_numcr IS NULL THEN LET l_numcr=0 END IF
 
    #--------- MA 不良數
    SELECT SUM(qcg07) INTO l_numma FROM qcg_file
     WHERE qcg01=g_qcf.qcf01 AND qcg05='2'
    IF l_numma IS NULL THEN LET l_numma=0 END IF
 
    #--------- MI 不良數
    SELECT SUM(qcg07) INTO l_nummi FROM qcg_file
     WHERE qcg01=g_qcf.qcf01 AND qcg05='3'
    IF l_nummi IS NULL THEN LET l_nummi=0 END IF
 
   IF g_qcf.qcf09 = '1' THEN #合格
      LET g_qcf.qcf091=g_qcf.qcf22
   ELSE
      LET g_qcf.qcf091=0    #'2':重工=>合格量default為0 (即預設全退) 
   END IF
    CASE g_qcf.qcf09
         WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
         WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING des1
    END CASE
 
    DISPLAY des1 TO FORMONLY.des1
    DISPLAY BY NAME g_qcf.qcf091,g_qcf.qcf09,g_qcf.qcf13
    UPDATE qcf_file SET qcf091=g_qcf.qcf091,qcf09=g_qcf.qcf09
     WHERE qcf01=g_qcf.qcf01 AND qcf02=g_qcf.qcf02
       AND qcf05=g_qcf.qcf05
    CALL t411_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t411_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_qcf.qcf01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM qcf_file ",
                  "  WHERE qcf01 LIKE '",l_slip,"%' ",
                  "    AND qcf01 > '",g_qcf.qcf01,"'"
      PREPARE t411_pb1 FROM l_sql 
      EXECUTE t411_pb1 INTO l_cnt
      
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
        #CALL t411_x()    #FUN-D20025
         CALL t411_x(1)   #FUN-D20025
         IF g_qcf.qcf14 = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_qcf.qcf14,"","","",g_void,g_qcf.qcfacti)
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM qco_file WHERE qco01 = g_qcf.qcf01
                                AND qco02 = 0
                                AND qco05 = 0
         DELETE FROM qcgg_file WHERE qcgg01 = g_qcf.qcf01
         DELETE FROM qcv_file WHERE qcv01 = g_qcf.qcf01   
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM qcf_file WHERE qcf01=g_qcf.qcf01
         INITIALIZE g_qcf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t411_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON qcg03,qcg04,qcg05,qcg06,qcg09,qcg10,qcg14,qcg15,qcg11,qcg07,qcg08     #No.FUN-A80063
                      ,qcgud01,qcgud02,qcgud03,qcgud04,qcgud05
                      ,qcgud06,qcgud07,qcgud08,qcgud09,qcgud10
                      ,qcgud11,qcgud12,qcgud13,qcgud14,qcgud15
            FROM s_qcg[1].qcg03,s_qcg[1].qcg04,s_qcg[1].qcg05,
                 s_qcg[1].qcg06,s_qcg[1].qcg09,s_qcg[1].qcg10,s_qcg[1].qcg14,s_qcg[1].qcg15, #No.FUN-A80063
                 s_qcg[1].qcg11,s_qcg[1].qcg07,s_qcg[1].qcg08
                ,s_qcg[1].qcgud01,s_qcg[1].qcgud02,s_qcg[1].qcgud03
                ,s_qcg[1].qcgud04,s_qcg[1].qcgud05,s_qcg[1].qcgud06
                ,s_qcg[1].qcgud07,s_qcg[1].qcgud08,s_qcg[1].qcgud09
                ,s_qcg[1].qcgud10,s_qcg[1].qcgud11,s_qcg[1].qcgud12
                ,s_qcg[1].qcgud13,s_qcg[1].qcgud14,s_qcg[1].qcgud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
 
    CALL t411_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t411_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    l_qcg12         LIKE qcg_file.qcg12,
    p_wc2           LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(200)
 
    IF p_wc2 IS NULL THEN LET p_wc2=" 1=1 " END IF
    LET g_sql =
        "SELECT qcg03,qcg04,azf03,qcg05,qcg06,qcg09,qcg10,qcg14,qcg15,qcg11,",           #No.FUN-A80063
        "       qcg07,qcg08,' ',",  #qcg12 ",
        "       qcgud01,qcgud02,qcgud03,qcgud04,qcgud05,",
        "       qcgud06,qcgud07,qcgud08,qcgud09,qcgud10,",
        "       qcgud11,qcgud12,qcgud13,qcgud14,qcgud15,",
        "       qcg12 ",
        " FROM qcg_file, OUTER azf_file ",
        " WHERE qcg01 ='",g_qcf.qcf01,"'",
       "   AND qcg_file.qcg04 = azf_file.azf01 AND azf_file.azf02='6' ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE t411_pb FROM g_sql
    DECLARE qcg_curs                       #SCROLL CURSOR
        CURSOR FOR t411_pb
 
    CALL g_qcg.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH qcg_curs INTO g_qcg[g_cnt].*,l_qcg12   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        CASE g_qcg[g_cnt].qcg08
             WHEN '1' CALL cl_getmsg('aqc-004',g_lang)
                           RETURNING g_qcg[g_cnt].qcg08_desc
             WHEN '2' CALL cl_getmsg('aqc-033',g_lang)
                           RETURNING g_qcg[g_cnt].qcg08_desc
        END CASE
 
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_qcg.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t411_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",FALSE)
      CALL cl_set_comp_visible("qcmspc",FALSE)
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcg TO s_qcg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t411_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t411_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t411_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t411_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t411_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
         IF g_qcf.qcf14 = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_qcf.qcf14,"","","",g_void,g_qcf.qcfacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 單身不良原因
      ON ACTION detail_flaw_reason
         LET g_action_choice="detail_flaw_reason"
         EXIT DISPLAY
#@    ON ACTION 單身測量值查詢
      ON ACTION qry_detail_measure
         LET g_action_choice="qry_detail_measure"
         EXIT DISPLAY
#@    ON ACTION 單身備註
      ON ACTION detail_memo
         LET g_action_choice="detail_memo"
         EXIT DISPLAY
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 特採
      ON ACTION special_purchase
         LET g_action_choice="special_purchase"
         EXIT DISPLAY

#FUN-A30045 --------------------Begin----------------
      ON ACTION cancel_special_purchase
         LET g_action_choice="cancel_special_purchase"
         EXIT DISPLAY                  
#FUN-A30045 --------------------End------------------

#FUN-BC0104 ---------------Begin---------------
      ON ACTION qc_item_maintain
         LET g_action_choice="qc_item_maintain"
         EXIT DISPLAY
#FUN-BC0104 ---------------End-----------------
        
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20025--add--str--
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20025--add--end--
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0160  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
#@    ON ACTION 拋轉至SPC     #FUN-680010
      ON ACTION trans_spc
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t411_shm(p_cmd)                                #MOD-8A0131 add p_cmd
   DEFINE m_shm01       LIKE shm_file.shm01,
          p_cmd         LIKE type_file.chr1,            #MOD-8A0131 add   
          m_shm05       LIKE shm_file.shm05,
          m_sfb07       LIKE sfb_file.sfb07,
          m_sfb82       LIKE sfb_file.sfb82,
          m_sfb22       LIKE sfb_file.sfb22,
          m_gem02       LIKE gem_file.gem02,
          m_oea04       LIKE oea_file.oea04,
          m_occ02       LIKE occ_file.occ02,
          m_sfb05       LIKE sfb_file.sfb05,
          m_azf03       LIKE azf_file.azf03,       #No.FUN-680104 VARCHAR(30)
          m_ima109      LIKE ima_file.ima109,
          m_ima02       LIKE ima_file.ima02,
          m_ima021      LIKE ima_file.ima021
 
   IF NOT cl_null(g_qcf.qcf03) THEN
      IF p_cmd='q' THEN
         LET g_qcf_o.qcf21 = g_qcf.qcf21
         LET g_qcf_o.qcf17 = g_qcf.qcf17
      END IF 
      SELECT shm01,shm05,ima02,ima021,
             ima100,ima102,ima109,ima05,shm012,ima101   #Ni.FUN-A80063  
        INTO m_shm01,m_shm05,m_ima02,m_ima021,
             g_qcf.qcf21,g_qcf.qcf17,m_ima109,m_sfb07,g_qcf.qcf02,g_ima101   #No.FUN-A80063  
       FROM shm_file,ima_file WHERE shm01 = g_qcf.qcf03 AND shm05 = ima01
       LET g_qcf.qcf021 = m_shm05
 
      IF p_cmd='q' THEN
         LET g_qcf.qcf21 = g_qcf_o.qcf21
         LET g_qcf.qcf17 = g_qcf_o.qcf17
      END IF 
 
      SELECT sfb82,sfb22,sfb05,sfb39
        INTO m_sfb82,m_sfb22,m_sfb05,g_sfb39
       FROM sfb_file WHERE sfb01 = g_qcf.qcf02
 
       SELECT azf03 INTO m_azf03 FROM azf_file
        WHERE azf01=m_ima109 AND azf02='8'
       IF STATUS THEN LET m_azf03=' ' END IF
       DISPLAY m_azf03 TO FORMONLY.azf03    #---- 類別說明
 
       SELECT gem02 INTO m_gem02 FROM gem_file #部門名稱
        WHERE gem01 = m_sfb82
          AND gemacti='Y'   #NO:6950
          IF STATUS = 100 THEN
            SELECT pmc03 INTO m_gem02 FROM  pmc_file WHERE pmc01 = m_sfb82
          END IF
       SELECT oea04 INTO m_oea04 FROM oea_file      #客戶編號
        WHERE oea01 = m_sfb22
       SELECT occ02 INTO m_occ02 FROM occ_file      #客戶名稱
        WHERE occ01 = m_oea04
       DISPLAY m_sfb07 TO FORMONLY.sfb07    #版本
       DISPLAY m_sfb82 TO FORMONLY.sfb82    #製造部門
       DISPLAY m_sfb05 TO qcf021            #料件編號
       DISPLAY m_ima02 TO FORMONLY.ima02    #料件名稱
       DISPLAY m_gem02 TO FORMONLY.gem02    #製造名稱
       DISPLAY m_sfb22 TO FORMONLY.sfb22    #訂單編號
       DISPLAY m_oea04 TO FORMONLY.occ01    #客戶編號
       DISPLAY m_occ02 TO FORMONLY.occ02    #客戶名稱
       DISPLAY m_ima109 TO FORMONLY.ima109
       DISPLAY g_ima101 TO ima101        #No.FUN-A80063
 
       CASE g_qcf.qcf21
            WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcf21_desc
            WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcf21_desc
            WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcf21_desc
       END CASE
       DISPLAY BY NAME g_qcf.qcf02,g_qcf.qcf21,g_qcf.qcf17
       DISPLAY qcf21_desc TO FORMONLY.qcf21_desc
   #----------CHI-BC0018 str add-----------------
   CASE g_ima101
      WHEN '1'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_1' AND gae03=g_lang

      WHEN '2'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_2' AND gae03=g_lang

      WHEN '3'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_3' AND gae03=g_lang

      WHEN '4'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_4' AND gae03=g_lang

      OTHERWISE
         LET ima101_desc=' '
   END CASE
   DISPLAY ima101_desc TO FORMONLY.ima101_desc
   
    CASE g_qcf.qcf17
      WHEN '1'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
      WHEN '7'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcf17_desc= ' '
    END CASE
   DISPLAY qcf17_desc TO FORMONLY.qcf17_desc
   #----------CHI-BC0018 end add-----------------

   ELSE
       DISPLAY ' ' TO FORMONLY.sfb07    #版本
       DISPLAY ' ' TO FORMONLY.sfb82    #製造部門
       DISPLAY ' ' TO FORMONLY.gem02    #製造名稱
       DISPLAY ' ' TO FORMONLY.sfb22    #訂單編號
       DISPLAY ' ' TO FORMONLY.occ01    #客戶編號
       DISPLAY ' ' TO FORMONLY.occ02    #客戶名稱
   END IF
 
END FUNCTION
 
FUNCTION t411_defqty(l_def,l_rate,l_level,l_type)       #No.FUN-A80063 add l_level l_type
    DEFINE l_def       LIKE type_file.num5,         #No.FUN-680104 SMALLINT #00-12-29   1:單頭入 2.單身入
           l_rate      LIKE qcd_file.qcd04,
           l_qcb04     LIKE qcb_file.qcb04
    DEFINE l_pmh09     LIKE pmh_file.pmh09,
           l_pmh15     LIKE pmh_file.pmh15,
           l_pmh16     LIKE pmh_file.pmh16,
           l_qca03     LIKE qca_file.qca03,
           l_qca04     LIKE qca_file.qca04,
           l_qca05     LIKE qca_file.qca05,
           l_qca06     LIKE qca_file.qca06
   DEFINE l_qty     LIKE type_file.num10          #No.MOD-7C0145 add
#No.FUN-A80063 --begin
   DEFINE l_level   LIKE qcd_file.qcd03
   DEFINE l_type    LIKE qcd_file.qcd05
   DEFINE l_qdg04   LIKE qdg_file.qdg04
   DEFINE l_qcd03   LIKE qcd_file.qcd03
   DEFINE l_qdf02   LIKE qdf_file.qdf02
#No.FUN-A80063 --end

 
   #對送驗量做四捨五入
    LET l_qty = g_qcf22
    LET g_qcf22 = l_qty
 
    SELECT ima100,ima101,ima102 INTO l_pmh09,l_pmh15,l_pmh16 FROM ima_file
     WHERE ima01=g_qcf.qcf021
    IF STATUS THEN
       IF STATUS THEN
          LET l_pmh09='' LET l_pmh15='' LET l_pmh16='' RETURN 0
       END IF
    END IF
 
    IF l_pmh09 IS NULL OR l_pmh09=' ' THEN RETURN 0 END IF
    IF l_pmh15 IS NULL OR l_pmh15=' ' THEN RETURN 0 END IF
    IF l_pmh16 IS NULL OR l_pmh16=' ' THEN RETURN 0 END IF
 
    IF l_pmh15='1' THEN
       IF l_def = '1' THEN
          SELECT qca03,qca04,qca05,qca06
            INTO l_qca03,l_qca04,l_qca05,l_qca06
            FROM qca_file
           WHERE g_qcf22 BETWEEN qca01 AND qca02        #bugno:7196
             AND qca07=g_qcf.qcf17
          IF STATUS THEN RETURN 0 END IF
       ELSE
          SELECT qcb04 INTO l_qcb04 FROM qcb_file,qca_file
           WHERE (g_qcf22 BETWEEN qca01 AND qca02)       #bugno:7196
             AND qcb02 = l_rate
             AND qca03 = qcb03
             AND qca07 = g_qcf.qcf17
             AND qcb01 = g_qcf.qcf21
          IF NOT cl_null(l_qcb04) THEN
             SELECT UNIQUE qca03,qca04,qca05,qca06    #No.FUN-740116 add unique
               INTO l_qca03,l_qca04,l_qca05,l_qca06
               FROM qca_file
              WHERE qca03 = l_qcb04
             IF STATUS THEN
                LET l_qca03 = 0  LET l_qca04 = 0
                LET l_qca05 = 0  LET l_qca06 = 0
             END IF
           END IF
       END IF
    END IF
    IF l_pmh15='2' THEN
       IF l_def = '1' THEN
          SELECT qch03,qch04,qch05,qch06
            INTO l_qca03,l_qca04,l_qca05,l_qca06
            FROM qch_file
           WHERE g_qcf22 BETWEEN qch01 AND qch02       #bugno:7196
             AND qch07=g_qcf.qcf17
          IF STATUS THEN RETURN 0 END IF
       ELSE
          SELECT qcb04 INTO l_qcb04 FROM qcb_file,qch_file
           WHERE (g_qcf22 BETWEEN qch01 AND qch02)       #bugno:7196
             AND qcb02 = l_rate
             AND qch03 = qcb03
             AND qch07 = g_qcf.qcf17
             AND qcb01 = g_qcf.qcf21
          IF NOT cl_null(l_qcb04) THEN
             SELECT UNIQUE qch03,qch04,qch05,qch06      #No.FUN-740116 add unique
               INTO l_qca03,l_qca04,l_qca05,l_qca06
               FROM qch_file
              WHERE qch03 = l_qcb04
             IF STATUS THEN
                LET l_qca03 = 0  LET l_qca04 = 0
                LET l_qca05 = 0  LET l_qca06 = 0
             END IF
           END IF
       END IF
    END IF
 
   IF g_qcf22 = 1 THEN
      LET l_qca04 = 1
      LET l_qca05 = 1
      LET l_qca06 = 1
   END IF
 

#No.FUN-A80063 --begin 
#   CASE l_pmh09
#      WHEN 'N'
#         RETURN l_qca04
#      WHEN 'T'
#         RETURN l_qca05
#      WHEN 'R'
#         RETURN l_qca06
#      OTHERWISE
#         RETURN 0
#   END CASE

  IF l_type ='1' OR l_type ='2' THEN 
      CASE l_pmh09
         WHEN 'N'
            RETURN l_qca04
         WHEN 'T'
            RETURN l_qca05
         WHEN 'R'
            RETURN l_qca06
         OTHERWISE
            RETURN 0
      END CASE
  END IF 
  IF l_type ='3' OR l_type ='4' THEN 
      CASE l_pmh09
         WHEN 'N'
            LET l_qcd03 = l_level
         WHEN 'T'
            LET l_qcd03 = l_level+1
            IF l_qcd03 = 8 THEN 
               LET l_qcd03 ='T'
            END IF 
         WHEN 'R'
            LET l_qcd03 = l_level-1
            IF l_qcd03 = 0 THEN 
               LET l_qcd03 ='R'
            END IF 
         OTHERWISE
            RETURN 0
      END CASE  
      SELECT qdf02 INTO l_qdf02
        FROM qdf_file
       WHERE (g_qcf.qcf22 BETWEEN qdf03 AND qdf04) 
         AND qdf01 = l_qcd03
      SELECT qdg04 INTO l_qdg04
        FROM qdg_file
       WHERE qdg01 = g_ima101
         AND qdg02 = l_qcd03
         AND qdg03 = l_qdf02
      IF SQLCA.sqlcode THEN 
         LET l_qdg04 = 0
      END IF    
      RETURN l_qdg04
   END IF 
#No.FUN-A80063 --end 
 
END FUNCTION

#FUN-A60092 --begin--
FUNCTION t411_max_sgm03(p_sfb01)
 DEFINE p_sfb01     LIKE sfb_file.sfb01
 DEFINE l_sfb93     LIKE sfb_file.sfb93
 DEFINE l_sfb05     LIKE sfb_file.sfb05
 DEFINE l_sfb06     LIKE sfb_file.sfb06
 DEFINE l_ecu012    LIKE ecu_file.ecu012
 DEFINE l_sgm03     LIKE sgm_file.sgm03

 SELECT sfb93,sfb06,sfb05 INTO l_sfb93,l_sfb06,l_sfb05 
   FROM sfb_file 
  WHERE sfb01 = p_sfb01
                
  IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
       SELECT ecu012 INTO l_ecu012 FROM ecu_file
        WHERE ecu01 = l_sfb05
          AND ecu02 = l_sfb06
          AND (ecu015 IS NULL OR ecu015=' ')
  END IF
  
  IF l_ecu012 IS NULL THEN LET l_ecu012 = ' ' END IF
  
  SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file
  WHERE sgm01 = g_qcf.qcf03
    AND sgm012= l_ecu012
  
  RETURN l_ecu012,l_sgm03      
END FUNCTION 
#FUN-A60092 --end--
 
FUNCTION t411_y()
   DEFINE l_msg      LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_str1     LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_str2     LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_acc_qty  LIKE qcf_file.qcf22         #No.FUN-680104 DEC(15,3)
   DEFINE l_qcf22    LIKE qcf_file.qcf22         #No.FUN-680104 DEC(15,3)
   DEFINE l_ecu012   LIKE ecu_file.ecu012        #FUN-A60092 
   DEFINE l_sgm03    LIKE sgm_file.sgm03         #FUN-A60092 
   
   SELECT * INTO g_qcf.* FROM qcf_file
    WHERE qcf01=g_qcf.qcf01 AND qcf02=g_qcf.qcf02
 
   IF g_qcf.qcf14 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_qcf.qcf14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
   LET g_max_qcf22=0
   LET l_acc_qty =0
   LET l_qcf22 =0
   
  CALL t411_max_sgm03(g_qcf.qcf02) RETURNING l_ecu012,l_sgm03   #FUN-A60092 
  SELECT (sgm311+sgm315+sgm316+sgm317)
    INTO g_max_qcf22
    FROM sgm_file
   WHERE sgm01=g_qcf.qcf03               
#    AND sgm03=(SELECT MAX(sgm03)   #終站程序  #FUN-A60092 
#                 FROM sgm_file                #FUN-A60092 
#                WHERE sgm01=g_qcf.qcf03)      #FUN-A60092 
     AND sgm012 = l_ecu012                     #FUN-A60092 
     AND sgm03  = l_sgm03                      #FUN-A60092   

   CALL t411_qcf22() RETURNING l_qcf22
   LET l_acc_qty = g_max_qcf22-l_qcf22
   IF g_qcf.qcf091 > l_acc_qty THEN
      LET l_qcf22 = l_qcf22+g_qcf.qcf091
      CALL cl_getmsg('aqc-427',g_lang) RETURNING l_str1
      CALL cl_getmsg('aqc-428',g_lang) RETURNING l_str2
      LET l_msg = l_str2 CLIPPED,l_qcf22 USING "######.###",
                  " > ",l_str1 CLIPPED,g_max_qcf22 USING "######.###"
       CALL cl_msgany(0,0,l_msg)
       RETURN
   END IF
 
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t411_cl USING g_qcf.qcf01
   IF STATUS THEN
      CALL cl_err("OPEN t411_cl:", STATUS, 1)
      CLOSE t411_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t411_cl INTO g_qcf.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t411_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   LET g_success = 'Y'
 
   UPDATE qcf_file SET qcf14='Y',
                       qcf15=g_today
    WHERE qcf01=g_qcf.qcf01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_qcf.qcf14='Y'
      LET g_qcf.qcf15=g_today
      COMMIT WORK
      CALL cl_flow_notify(g_qcf.qcf01,'Y')
      DISPLAY BY NAME g_qcf.qcf14,g_qcf.qcf15
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t411_z()
DEFINE l_cnt    LIKE type_file.num5    #MOD-C30560
   SELECT * INTO g_qcf.* FROM qcf_file
    WHERE qcf01=g_qcf.qcf01 AND qcf02=g_qcf.qcf02
   IF g_qcf.qcf14 = 'N' THEN RETURN END IF
   IF g_qcf.qcf14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_qcf.qcf09 = '3' THEN CALL cl_err(g_qcf.qcf01,'aqc-410',0) RETURN END IF #BugNo:5046
 
   SELECT COUNT(*) INTO g_cnt FROM sfv_file
    WHERE sfv17=g_qcf.qcf01
      AND sfv01 IN ( SELECT sfu01 FROM sfu_file
                     WHERE sfu00='1'
                       AND sfupost='Y')
   IF g_cnt>0 THEN CALL cl_err('','aqc-013',0) RETURN END IF
 
   #MOD-C30560----add----str----
   IF g_qcf.qcf00 MATCHES '[2]' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM inb_file
       WHERE inb44 = g_qcf.qcf01
         AND inb45 = 0
         AND inb48 = 0
      IF l_cnt > 0 THEN
         CALL cl_err(g_qcf.qcf01,'aqc-542',0)
         RETURN
      END IF
   END IF
   #MOD-C30560----add----end----

   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t411_cl USING g_qcf.qcf01
   IF STATUS THEN
      CALL cl_err("OPEN t411_cl:", STATUS, 1)
      CLOSE t411_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t411_cl INTO g_qcf.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t411_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   UPDATE qcf_file SET qcf14='N',
                       #qcf15=''      #CHI-C80072
                       qcf15=g_today  #CHI-C80072
      WHERE qcf01=g_qcf.qcf01 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_qcf.qcf14='N'
      #LET g_qcf.qcf15=''     #CHI-C80072
      LET g_qcf.qcf15=g_today #CHI-C80072
      COMMIT WORK
      DISPLAY BY NAME g_qcf.qcf14,g_qcf.qcf15
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
#FUNCTION t411_x()        #FUN-D20025
FUNCTION t411_x(p_type)   #FUN-D20025
   DEFINE l_qcfspc        LIKE qcf_file.qcfspc     #FUN-680010
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
 
   IF s_shut(0) THEN RETURN END IF
 
   SELECT * INTO g_qcf.* FROM qcf_file WHERE qcf01 = g_qcf.qcf01
   IF cl_null(g_qcf.qcf01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_qcf.qcf14 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_qcf.qcf14='X' THEN RETURN END IF
   ELSE
      IF g_qcf.qcf14<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t411_cl USING g_qcf.qcf01
   IF STATUS THEN
      CALL cl_err("OPEN t411_cl:", STATUS, 1)
      CLOSE t411_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t411_cl INTO g_qcf.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t411_cl ROLLBACK WORK RETURN
   END IF
 
  #IF cl_void(0,0,g_qcf.qcf14)   THEN
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN         #FUN-D20025
      LET g_chr=g_qcf.qcf14
 
     #IF g_qcf.qcf14 ='N' THEN  #FUN-D20025
      IF p_type = 1 THEN        #FUN-D20025
          LET g_qcf.qcf14='X'
      ELSE
          LET g_qcf.qcf14='N'
      END IF
 
      LET l_qcfspc = '0'            #FUN-680010
 
      UPDATE qcf_file SET qcf14  =g_qcf.qcf14,
                          qcfspc = l_qcfspc,       #FUN-680010
                          qcf15  =g_today,
                          qcfmodu=g_user,
                          qcfdate=g_today
       WHERE qcf01  =g_qcf.qcf01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","qcf_file",g_qcf.qcf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
          LET g_qcf.qcf14=g_chr
      END IF
 
      IF g_aza.aza64 NOT matches '[ Nn]' THEN 
         # CALL aws_spccli()
         #功能: 通知 SPC 端刪除此張單據
         # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),delete(刪除)
         # 回傳值  : 0 傳送失敗; 1 傳送成功
         IF g_qcf.qcfspc = '1' THEN
            IF NOT aws_spccli(g_prog,base.TypeInfo.create(g_qcf),'delete')
            THEN
                 CLOSE t411_cl
                 ROLLBACK WORK
                 RETURN
            END IF
         END IF
      END IF
 
      SELECT qcf14,qcf15,qcfspc INTO g_qcf.qcf14,g_qcf.qcf15,g_qcf.qcfspc #FUN-680010
        FROM qcf_file
       WHERE qcf01 = g_qcf.qcf01
      DISPLAY BY NAME g_qcf.qcf14,g_qcf.qcf15,g_qcf.qcfspc   #FUN-680010
      IF g_qcf.qcf00='1' THEN CALL s_updsfb11(g_qcf.qcf02) END IF #No:8644
 
   END IF
 
   CLOSE t411_cl
   COMMIT WORK
   CALL cl_flow_notify(g_qcf.qcf01,'V')
 
END FUNCTION
 
FUNCTION t411_g_b()
    DEFINE l_cnt    LIKE type_file.num5        #No.FUN-680104 SMALLINT
    DEFINE l_yn     LIKE type_file.num5        #No.FUN-680104 SMALLINT
    DEFINE l_qcd    RECORD LIKE qcd_file.*
    DEFINE l_qcg11  LIKE qcg_file.qcg11
    DEFINE seq      LIKE type_file.num5        #No.FUN-680104 SMALLINT
    DEFINE l_ac_num,l_re_num LIKE type_file.num5         #No.FUN-680104 SMALLINT
    DEFINE l_sql    STRING     #No.FUN-910079
#No.FUN-A80063 --begin
    DEFINE l_qdf02   LIKE qdf_file.qdf02
    DEFINE l_qcg14   LIKE qcg_file.qcg14
    DEFINE l_qcg15   LIKE qcg_file.qcg15
#No.FUN-A80063 --end 
 
    LET seq=1
 
    SELECT COUNT(*) INTO l_cnt FROM qcg_file
     WHERE qcg01=g_qcf.qcf01
 
    IF l_cnt=0 THEN
       #bug.3761 02/01/15 QC單身產生時先抓該料件檢驗項目,
       #                  抓不到再抓該料所屬材料類別之檢驗項目
       LET l_sql = " SELECT COUNT(*)  FROM qcd_file WHERE qcd01=? AND qcd08 in ('2','9')"
       PREPARE qcd_sel2 FROM l_sql
       EXECUTE qcd_sel2 USING g_qcf.qcf021 INTO l_yn               
       IF l_yn>0 THEN  #--- 料件檢驗項目
       LET l_sql =" SELECT * FROM qcd_file WHERE qcd01=?  AND qcd08 in ('2','9') ORDER BY qcd02 "
       PREPARE qcd_cur1 FROM l_sql
       DECLARE qcd_cur CURSOR FOR qcd_cur1
         
           FOREACH qcd_cur USING g_qcf.qcf021 INTO l_qcd.* 
#No.FUN-A80063 --begin
#             IF l_qcd.qcd05='1' THEN
#                 #-------- Ac,Re 數量賦予
#                 CALL s_newaql(g_qcf.qcf021,' ',l_qcd.qcd04,g_qcf.qcf22,' ','1')  #MOD-890223 add ' ','1'
#                      RETURNING l_ac_num,l_re_num
#                 CALL t411_defqty(2,l_qcd.qcd04)
#                      RETURNING l_qcg11
#              ELSE
#                 LET l_ac_num=0 LET l_re_num=1
#                 SELECT qcj05 INTO l_qcg11
#                   FROM qcj_file
#                  WHERE (g_qcf.qcf22 BETWEEN qcj01 AND qcj02)
#                    AND qcj03=l_qcd.qcd04
#                    AND qcj04 = g_qcf.qcf17   #No.MOD-820049 add
#                 IF STATUS THEN LET l_qcg11=0 END IF
#                 IF g_qcf22 = 1 THEN
#                    LET l_qcg11 = 1
#                 END IF
#              END IF

              CASE l_qcd.qcd05
               WHEN '1'   #一般
                 CALL s_newaql(g_qcf.qcf021,' ',l_qcd.qcd04,g_qcf.qcf22,' ','1')  #MOD-890223 add ' ','1'
                      RETURNING l_ac_num,l_re_num
                 CALL t411_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05)
                      RETURNING l_qcg11
                 LET l_qcg14 =''
                 LET l_qcg15 =''
               WHEN '2'   #特殊
                 LET l_ac_num=0 LET l_re_num=1
                 SELECT qcj05 INTO l_qcg11
                   FROM qcj_file
                  WHERE (g_qcf.qcf22 BETWEEN qcj01 AND qcj02)
                    AND qcj03 = l_qcd.qcd04
                    AND qcj04 = g_qcf.qcf17   #No.MOD-820049 add
                 IF STATUS THEN
                    LET l_qcg11 = 0
                 END IF
                 IF g_qcf22 = 1 THEN
                    LET l_qcg11 = 1
                 END IF
                 LET l_qcg14 =''
                 LET l_qcg15 =''
               WHEN '3'   #1916 计数
                 LET l_ac_num =0
                 LET l_re_num =1
                 CALL t411_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qcg11
                 LET l_qcg14 =''
                 LET l_qcg15 =''
              
               WHEN '4'   #1916 计量
                 LET l_ac_num =''
                 LET l_re_num =''
                 CALL t411_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qcg11
                 SELECT qdf02 INTO l_qdf02
                   FROM qdf_file
                  WHERE (g_qcf.qcf22 BETWEEN qdf03 AND qdf04)
                    AND qdf01 = l_qcd.qcd03
                 SELECT qdg05,qdg06 INTO l_qcg14,l_qcg15
                   FROM qdg_file
                  WHERE qdg01 = g_ima101
                    AND qdg02 = l_qcd.qcd03
                    AND qdg03 = l_qdf02
                 IF SQLCA.sqlcode THEN 
                    LET l_qcg14 =0
                    LET l_qcg15 =0
                 END IF
              END CASE 
#No.FUN-A80063 --end  
              IF l_qcg11 > g_qcf.qcf22 THEN LET l_qcg11=g_qcf.qcf22 END IF
              IF cl_null(l_qcg11) THEN LET l_qcg11=0 END IF
 
               INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, #No.MOD-470041
                                     qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,qcg14,qcg15,         #No.FUN-A80063
                                     qcgplant,qcglegal)  #FUN-980007
                   VALUES(g_qcf.qcf01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                          0,'1',l_ac_num,l_re_num,l_qcg11,l_qcd.qcd05,
                          l_qcd.qcd061,l_qcd.qcd062,l_qcg14,l_qcg15,                                  #No.FUN-A80063
                          g_plant,g_legal)               #FUN-980007
              LET seq=seq+1
          END FOREACH
       ELSE            #--- 材料類別檢驗項目
          LET l_sql  =" SELECT qck_file.* FROM qck_file,ima_file ",
                      " WHERE qck01=ima109 AND ima01=?",
                      " AND qck08 in ('2','9') ORDER BY qck02" 
          PREPARE qck_cur1 FROM l_sql
          DECLARE qck_cur CURSOR FOR qck_cur1                                   	
           FOREACH qck_cur USING g_qcf.qcf021 INTO l_qcd.* 
#              IF l_qcd.qcd05='1' THEN
#                 #-------- Ac,Re 數量賦予
#                 CALL s_newaql(g_qcf.qcf021,' ',l_qcd.qcd04,g_qcf.qcf22,' ','1')  #MOD-890223 add ' ','1'
#                      RETURNING l_ac_num,l_re_num
#                 CALL t411_defqty(2,l_qcd.qcd04)
#                      RETURNING l_qcg11
#              ELSE
#                 LET l_ac_num=0 LET l_re_num=1
#                 SELECT qcj05 INTO l_qcg11
#                   FROM qcj_file
#                  WHERE (g_qcf.qcf22 BETWEEN qcj01 AND qcj02)
#                    AND qcj03=l_qcd.qcd04
#                    AND qcj04 = g_qcf.qcf17   #No.MOD-820049 add
#                 IF STATUS THEN LET l_qcg11=0 END IF
#                 IF g_qcf22 = 1 THEN
#                    LET l_qcg11 = 1
#                 END IF
#              END IF


              CASE l_qcd.qcd05
               WHEN '1'   #一般
                 CALL s_newaql(g_qcf.qcf021,' ',l_qcd.qcd04,g_qcf.qcf22,' ','1')  #MOD-890223 add ' ','1'
                      RETURNING l_ac_num,l_re_num
                 CALL t411_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05)
                      RETURNING l_qcg11
                 LET l_qcg14 =''
                 LET l_qcg15 =''
               WHEN '2'   #特殊
                 LET l_ac_num=0 LET l_re_num=1
                 SELECT qcj05 INTO l_qcg11
                   FROM qcj_file
                  WHERE (g_qcf.qcf22 BETWEEN qcj01 AND qcj02)
                    AND qcj03 = l_qcd.qcd04
                    AND qcj04 = g_qcf.qcf17   #No.MOD-820049 add
                 IF STATUS THEN
                    LET l_qcg11 = 0
                 END IF
                 IF g_qcf22 = 1 THEN
                    LET l_qcg11 = 1
                 END IF
                 LET l_qcg14 =''
                 LET l_qcg15 =''
               WHEN '3'   #1916 计数
                 LET l_ac_num =0
                 LET l_re_num =1
                 CALL t411_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qcg11
                 LET l_qcg14 =''
                 LET l_qcg15 =''
              
               WHEN '4'   #1916 计量
                 LET l_ac_num =''
                 LET l_re_num =''
                 CALL t411_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qcg11
                 SELECT qdf02 INTO l_qdf02
                   FROM qdf_file
                  WHERE (g_qcf.qcf22 BETWEEN qdf03 AND qdf04)
                    AND qdf01 = l_qcd.qcd03
                 SELECT qdg05,qdg06 INTO l_qcg14,l_qcg15
                   FROM qdg_file
                  WHERE qdg01 = g_ima101
                    AND qdg02 = l_qcd.qcd03
                    AND qdg03 = l_qdf02
                 IF SQLCA.sqlcode THEN 
                    LET l_qcg14 =0
                    LET l_qcg15 =0
                 END IF
              END CASE 
#No.FUN-A80063 --end  

              IF l_qcg11 > g_qcf.qcf22 THEN LET l_qcg11=g_qcf.qcf22 END IF
              IF cl_null(l_qcg11) THEN LET l_qcg11=0 END IF
               INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, #No.MOD-470041
                                     qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,qcg14,qcg15,              #No.FUN-A80063
                                     qcgplant,qcglegal)  #FUN-980007
                   VALUES(g_qcf.qcf01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                          0,'1',l_ac_num,l_re_num,l_qcg11,l_qcd.qcd05,
                          l_qcd.qcd061,l_qcd.qcd062,l_qcg14,l_qcg15,                                       #No.FUN-A80063
                          g_plant,g_legal)               #FUN-980007
 
              LET seq=seq+1
          END FOREACH
       END  IF
       CALL t411_show()
    END IF
 
END FUNCTION
 
FUNCTION t411_ii(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
    DEFINE l_ima55     LIKE ima_file.ima55    #FUN-BB0085
 
    DISPLAY BY NAME g_qcf.qcf091,g_qcf.qcf09,g_qcf.qcf13,g_qcf.qcf12
 
    INPUT BY NAME g_qcf.qcf091,g_qcf.qcf13,g_qcf.qcf12 #BugNo:5046
        WITHOUT DEFAULTS
 
        AFTER FIELD qcf091
            #FUN-BB0085-add-str--
            IF NOT cl_null(g_qcf.qcf091) THEN 
               IF g_qcf_t.qcf091 != g_qcf.qcf091 OR cl_null(g_qcf_t.qcf091) THEN 
                  SELECT ima55 INTO l_ima55 FROM ima_file
                   WHERE ima01 = g_qcf.qcf021
                  LET g_qcf.qcf091 = s_digqty(g_qcf.qcf091,l_ima55) 
                  DISPLAY BY NAME g_qcf.qcf091
               END IF 
            END IF
            #FUN-BB0085-add-end--
            IF NOT cl_null(g_qcf.qcf091) THEN
               IF g_qcf.qcf091 > g_qcf.qcf22 OR g_qcf.qcf091<0 THEN
                   CALL cl_err('err qcf091','aqc-425',0)   #MOD-520016
                  NEXT FIELD qcf091
               END IF
            END IF
 
        AFTER FIELD qcf13
            IF NOT cl_null(g_qcf.qcf13) THEN
               SELECT gen02 INTO m_gen02 FROM gen_file WHERE gen01=g_qcf.qcf13
               IF STATUS THEN
                  CALL cl_err3("sel","gen_file",g_qcf.qcf13,"","aoo-017","","",1)  #No.FUN-660115
                  NEXT FIELD qcf13
               END IF
               DISPLAY m_gen02 TO FORMONLY.gen02
            END IF
 
        AFTER INPUT
               IF g_qcf.qcf091 > g_qcf.qcf22 OR g_qcf.qcf091<0 THEN
                  CALL cl_err('err qcf091','aqc-425',0)
                  NEXT FIELD qcf091
               END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcf13) #員工編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_qcf.qcf13
                   CALL cl_create_qry() RETURNING g_qcf.qcf13
                   DISPLAY BY NAME g_qcf.qcf13
                   NEXT FIELD qcf13
           END CASE
 
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
 
    UPDATE qcf_file SET qcf091=g_qcf.qcf091,
                        qcf09=g_qcf.qcf09,
                        qcf13=g_qcf.qcf13,
                        qcf12=g_qcf.qcf12
     WHERE qcf01=g_qcf.qcf01
 
END FUNCTION
 
FUNCTION t411_more_b()
  DEFINE ls_tmp           STRING
  DEFINE l_qcu            DYNAMIC ARRAY OF RECORD
                          qcu04     LIKE qcu_file.qcu04,
                          qce03     LIKE qce_file.qce03,
                          qcu05     LIKE qcu_file.qcu05,
                          qcuicd01  LIKE qcu_file.qcuicd01,  #No.MOD-8A0159 add by liuxqa
                          qcuicd02  LIKE qcu_file.qcuicd02,  #No.MOD-8A0159 add by liuxqa
                          icd03     LIKE type_file.chr1000   #No.MOD-8A0159 add by liuxqa
                          END RECORD
  DEFINE l_qcu05_t        LIKE qcu_file.qcu05
  DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE l_rec_b          LIKE type_file.num5,    #No.FUN-680104 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
 
   OPEN WINDOW t411_mo AT 04,04 WITH FORM "aqc/42f/aqct1101"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aqct1101")
 
 
   DECLARE t411_mo CURSOR FOR
    SELECT qcu04,qce03,qcu05,
           qcuicd01,qcuicd02,''   #No.MOD-8A0159 add by liuxqa
     FROM qcu_file, OUTER qce_file
     WHERE qcu_file.qcu04=qce_file.qce01
       AND qcu01=g_qcf.qcf01
       AND qcu03=g_qcg[l_ac].qcg03
 
   CALL l_qcu.clear()
   LET i = 1
   LET l_rec_b = 0
   FOREACH t411_mo INTO l_qcu[i].*
      IF STATUS THEN CALL cl_err('foreach qcu',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   DISPLAY l_rec_b TO cn2
   SELECT SUM(qcu05) INTO l_qcu05_t FROM qcu_file
    WHERE qcu01=g_qcf.qcf01
      AND qcu03=g_qcg[l_ac].qcg03
   DISPLAY l_qcu05_t TO qcu05t
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_qcu WITHOUT DEFAULTS FROM s_qcu.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
     BEFORE INPUT
        CALL fgl_set_arr_curr(l_ac)
     BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()     #FUN-550037(smin)
 
     AFTER FIELD qcu04
        IF NOT cl_null(l_qcu[i].qcu04) THEN
           SELECT qce03 INTO l_qcu[i].qce03 FROM qce_file
              WHERE qce01=l_qcu[i].qcu04
           IF STATUS THEN NEXT FIELD qcu04 END IF
           DISPLAY l_qcu[i].qce03 TO s_qcu[j].qce03
        END IF
 
     AFTER FIELD qcu05
        IF l_qcu[i].qcu05<0 OR l_qcu[i].qcu05 IS NULL THEN
           LET l_qcu[i].qcu05=0
           DISPLAY l_qcu[i].qcu05 TO s_qcu[j].qcu05
        END IF
 
     AFTER ROW
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0) LET INT_FLAG = 0 EXIT INPUT
        END IF
        LET l_qcu05_t=0
        FOR k = 1 TO l_qcu.getLength()
           IF l_qcu[k].qcu05 IS NOT NULL AND l_qcu[k].qcu05 <> 0 THEN
              LET l_qcu05_t = l_qcu05_t + l_qcu[k].qcu05
           END IF
        END FOR
        DISPLAY l_qcu05_t TO qcu05t
 
     AFTER INPUT
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcu04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_qce"
                   LET g_qryparam.default1 = l_qcu[i].qcu04
                   CALL cl_create_qry() RETURNING l_qcu[i].qcu04
                    DISPLAY l_qcu[i].qcu04 TO qcu04  #No.MOD-490371
                   NEXT FIELD qcu04
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
 
   CLOSE WINDOW t411_mo
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DELETE FROM qcu_file
    WHERE qcu01=g_qcf.qcf01
      AND qcu03=g_qcg[l_ac].qcg03
 
   FOR i = 1 TO l_qcu.getLength()
       IF l_qcu[i].qcu05 IS NULL OR l_qcu[i].qcu05=0 THEN
          CONTINUE FOR
       END IF
        INSERT INTO qcu_file (qcu01,qcu02,qcu021,qcu03,qcu04,qcu05,
                              qcuicd01,qcuicd02,qcuplant,qculegal) #FUN-980007 
            VALUES(g_qcf.qcf01,0,0,g_qcg[l_ac].qcg03,l_qcu[i].qcu04,
                   l_qcu[i].qcu05,l_qcu[i].qcuicd01,l_qcu[i].qcuicd02,g_plant,g_legal) #FUN-980007   
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","qcu_file",g_qcf.qcf01,g_qcg[l_ac].qcg03,SQLCA.sqlcode,"","INS-qcu",1)  #No.FUN-660115
          LET g_success = 'N' EXIT FOR
       END IF
    END FOR
 
END FUNCTION
 
FUNCTION t411_more_b1(p_qcg11,p_qcd05,p_qcd061,p_qcd062,p_qcg03,p_qcg04)
  DEFINE ls_tmp           STRING
  DEFINE l_qcgg           DYNAMIC ARRAY OF RECORD
                          qcgg04    LIKE qcgg_file.qcgg04
                          END RECORD
  DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE l_rec_b          LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE p_qcg11          LIKE qcg_file.qcg11
  DEFINE p_qcd05          LIKE qcd_file.qcd05
  DEFINE p_qcd061         LIKE qcd_file.qcd061
  DEFINE p_qcd062         LIKE qcd_file.qcd062
  DEFINE p_qcg03          LIKE qcg_file.qcg03
  DEFINE p_qcg04          LIKE qcg_file.qcg04
  DEFINE l_azf03          LIKE azf_file.azf03,
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
   OPEN WINDOW t411_mo1 AT 04,04 WITH FORM "aqc/42f/aqct4102"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aqct4102")
 
 
   DISPLAY p_qcg03 TO FORMONLY.qcg03
   DISPLAY p_qcg04 TO FORMONLY.qcg04
   SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=p_qcg04 AND azf02='6'
   DISPLAY l_azf03 TO FORMONLY.azf03
   DISPLAY p_qcg11 TO FORMONLY.qcg11
   DISPLAY p_qcd05 TO FORMONLY.qcg12
   DISPLAY p_qcd061 TO FORMONLY.qcg131
   DISPLAY p_qcd062 TO FORMONLY.qcg132
 
   CALL l_qcgg.clear()
 
   LET i = 1 LET k=1
   DECLARE t411_mo1 CURSOR FOR
    SELECT qcgg04 FROM qcgg_file
     WHERE qcgg01=g_qcf.qcf01
       AND qcgg03=g_qcg[l_ac].qcg03
   FOREACH t411_mo1 INTO l_qcgg[k].*
      IF STATUS THEN CALL cl_err('foreach qcgg',STATUS,0) EXIT FOREACH END IF
      LET k = k + 1
      IF k > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
   LET l_rec_b=k-1
   DISPLAY l_rec_b TO cn2
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_qcgg WITHOUT DEFAULTS FROM s_qcgg.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)
 
     BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()     #FUN-550037(smin)
 
     AFTER FIELD qcgg04
        IF l_qcgg[i].qcgg04 IS NULL THEN LET l_qcgg[i].qcgg04=0 END IF
 
     AFTER ROW
        IF INT_FLAG THEN
           CALL cl_err('',9001,0) LET INT_FLAG = 0 EXIT INPUT
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
 
   CLOSE WINDOW t411_mo1
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DELETE FROM qcgg_file
    WHERE qcgg01=g_qcf.qcf01
      AND qcgg03=g_qcg[l_ac].qcg03
 
   LET g_qcg[l_ac].qcg07=0
 
   FOR i = 1 TO l_qcgg.getLength()
       IF l_qcgg[i].qcgg04 IS NULL OR l_qcgg[i].qcgg04=0 THEN
          CONTINUE FOR
       END IF
 
        INSERT INTO qcgg_file(qcgg01,qcgg03,qcgg04,qcggplant,qcgglegal) #FUN-980007 
            VALUES(g_qcf.qcf01,g_qcg[l_ac].qcg03,l_qcgg[i].qcgg04,g_plant,g_legal) #FUN-980007
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","qcgg_file",g_qcf.qcf01,g_qcg[l_ac].qcg03,SQLCA.sqlcode,"","INS-qcgg",1)  #No.FUN-660115
          LET g_success = 'N' EXIT FOR
       ELSE
          IF l_qcgg[i].qcgg04<p_qcd061 OR l_qcgg[i].qcgg04>p_qcd062 THEN
             LET g_qcg[l_ac].qcg07=g_qcg[l_ac].qcg07+1
          END IF
       END IF
 
   END FOR
 
END FUNCTION
 
FUNCTION t411_out()
   DEFINE l_cmd        LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(200)
          l_wc,l_wc2   LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(50)
          l_prtway     LIKE type_file.chr1     #No.FUN-680104 VARCHAR(01)
 
      CALL cl_wait()
      LET l_wc='qcf01="',g_qcf.qcf01,'"'
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
      #WHERE zz01 = 'aqcr455'  #FUN-C30085 mark
       WHERE zz01 = 'aqcg455'  #FUN-C30085 add
 
     #LET l_cmd = 'aqcr455',  #FUN-C30085 mark
      LET l_cmd = 'aqcg455',  #FUN-C30085 add
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                   " '",l_wc CLIPPED,"' "
      CALL cl_cmdrun(l_cmd)
 
      ERROR ' '
 
END FUNCTION
 
FUNCTION t411_b_memo()
  DEFINE ls_tmp           STRING
  DEFINE l_qcv            DYNAMIC ARRAY OF RECORD
                          qcv04     LIKE qcv_file.qcv04
                          END RECORD
  DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE i,j,k            LIKE type_file.num5,    #No.FUN-680104 SMALLINT
         l_rec_b          LIKE type_file.num5,    #No.FUN-680104 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
 
   OPEN WINDOW t411_b_memo AT 04,04 WITH FORM "aqc/42f/aqct1103"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aqct1103")
 
 
   DECLARE t411_b_memo CURSOR FOR
           SELECT qcv04 FROM qcv_file
            WHERE qcv01=g_qcf.qcf01
              AND qcv03=g_qcg[l_ac].qcg03
 
   CALL l_qcv.clear()
   LET i = 1
   LET l_rec_b = 0
 
   FOREACH t411_b_memo INTO l_qcv[i].*
      IF STATUS THEN CALL cl_err('foreach qcv',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   LET l_rec_b = i - 1
   DISPLAY l_rec_b TO cn2
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_qcv WITHOUT DEFAULTS FROM s_qcv.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)
 
     BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()     #FUN-550037(smin)
 
     AFTER ROW
        IF INT_FLAG THEN
           CALL cl_err('',9001,0) LET INT_FLAG = 0 EXIT INPUT
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
 
   CLOSE WINDOW t411_b_memo
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DELETE FROM qcv_file
    WHERE qcv01=g_qcf.qcf01
      AND qcv03=g_qcg[l_ac].qcg03
 
   FOR i = 1 TO l_qcv.getLength()
       IF cl_null(l_qcv[i].qcv04) THEN CONTINUE FOR END IF
        INSERT INTO qcv_file(qcv01,qcv02,qcv021,qcv03,qcv04,qcvplant,qcvlegal)#FUN-980007
            VALUES(g_qcf.qcf01,0,0,g_qcg[l_ac].qcg03,l_qcv[i].qcv04,g_plant,g_legal) #FUN-980007
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","qcv_file",g_qcf.qcf01,g_qcg[l_ac].qcg03,SQLCA.sqlcode,"","INS-qcv",1)  #No.FUN-660115
          LET g_success = 'N' EXIT FOR
       END IF
 
    END FOR
 
END FUNCTION
 
FUNCTION t411_3()
DEFINE l_ima55   LIKE ima_file.ima55       #FUN-BB0085
 
   SELECT * INTO g_qcf.* FROM qcf_file
    WHERE qcf01 = g_qcf.qcf01
    IF g_qcf.qcf09='1' THEN   #No.MOD-480059
      RETURN
   END IF
   IF cl_null(g_qcf.qcf01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_qcf.qcf14 != 'Y' THEN
      CALL cl_err(g_qcf.qcf01,'anm-960',0)
      RETURN
   END IF
   LET g_qcf_t.*=g_qcf.*
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t411_cl USING g_qcf.qcf01
   IF STATUS THEN
      CALL cl_err("OPEN t411_cl:", STATUS, 1)
      CLOSE t411_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t411_cl INTO g_qcf.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t411_cl ROLLBACK WORK RETURN
   END IF
 
   #show特採
   CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   DISPLAY '3',des1 TO qcf09,FORMONLY.des1
 
   INPUT BY NAME g_qcf.qcf091,g_qcf.qcf12 WITHOUT DEFAULTS
        AFTER FIELD qcf091
            #FUN-BB0085-add-str--
            IF NOT cl_null(g_qcf.qcf091) THEN 
               IF cl_null(g_qcf_t.qcf091) OR g_qcf_t.qcf091 != g_qcf.qcf091 THEN 
                  SELECT ima55 INTO l_ima55 FROM ima_file
                   WHERE ima01 = g_qcf.qcf021
                  LET g_qcf.qcf091 = s_digqty(g_qcf.qcf091,l_ima55)   
                  DISPLAY BY NAME g_qcf.qcf091
               END IF                       
            END IF 
            #FUN-BB0085-add-end--
            IF g_qcf.qcf091 > g_qcf.qcf22 OR g_qcf.qcf091<0 THEN
               CALL cl_err('err qcf091','aqc-002',0)
               NEXT FIELD qcf091
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
       LET g_qcf.*=g_qcf_t.*
       CALL t411_show()
       CALL cl_err('','9001',0)
       RETURN
   END IF
 
   UPDATE qcf_file
      SET qcf09  ='3', #特採
          qcf091 =g_qcf.qcf091,
          qcf12  =g_qcf.qcf12,
          qcf15  =g_today,
          qcfmodu=g_user,
          qcfdate=g_today
    WHERE qcf01  =g_qcf.qcf01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","qcf_file",g_qcf.qcf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       LET g_success = 'N'
   END IF
 
   IF g_success = 'Y' THEN
       COMMIT WORK
   ELSE
       ROLLBACK WORK
   END IF
   CLOSE t411_cl
 
   SELECT * INTO g_qcf.* FROM qcf_file
    WHERE qcf01 = g_qcf.qcf01
 
   CALL t411_show()
 
END FUNCTION

#FUN-A30045 ---------------------Begin------------------------------------------
FUNCTION t411_4()
   DEFINE l_n      LIKE  type_file.num5

   SELECT * INTO g_qcf.* FROM qcf_file
    WHERE qcf01 = g_qcf.qcf01
    
   IF g_qcf.qcf09 <> '3' THEN
      CALL cl_err(g_qcf.qcf09,'aqct1003',0)
      RETURN
   END IF  
   IF cl_null(g_qcf.qcf01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_qcf.qcf14 != 'Y' THEN
      CALL cl_err(g_qcf.qcf01,'anm-960',0)
      RETURN
   END IF 
   SELECT COUNT(*) INTO l_n FROM sfv_file
       WHERE sfv17 = g_qcf.qcf01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      
   END IF 
   IF l_n <> 0 THEN 
      CALL cl_err(g_qcf.qcf01,'aqc1004',0)
      RETURN
   END IF
   
   IF NOT cl_confirm('aqc1002') THEN
      RETURN
   END IF 
 
   LET g_qcf_t.* = g_qcf.*   
   BEGIN WORK
   LET g_success = 'Y'  

   OPEN t411_cl USING g_qcf.qcf01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      
      CLOSE t411_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t411_cl INTO g_qcf.*          
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      
      CLOSE t411_cl
      ROLLBACK WORK
      RETURN
   END IF  

   UPDATE qcf_file SET qcf09='2',
                       qcf091=0,
                       qcf38=0,
                       qcf41=0,
                       qcf15 = g_today,
                       qcfmodu = g_user,
                       qcfdate = g_today
       WHERE qcf01 = g_qcf.qcf01	
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","qcf_file",g_qcf.qcf01,g_qcf.qcf01,SQLCA.sqlcode,"","",1)  
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   CLOSE t411_cl
   
   SELECT * INTO g_qcf.* FROM qcf_file
    WHERE qcf01 = g_qcf.qcf01

   CALL t411_show()

END FUNCTION
#FUN-A30045 ---------------------End--------------------------------------------
 
FUNCTION t411_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("qcf00,qcf01,qcf02,qcf03,qcf05",TRUE)
    END IF
 
    IF INFIELD(qcf00) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("qcf02,qcf05,qcf03,qcf021",TRUE)
    END IF
 
    #No.CHI-A30031 --start--
    IF g_qcf.qcf09<>'1' OR cl_null(g_qcf.qcf09) THEN
       CALL cl_set_comp_entry("qcf22",TRUE)
    END IF
    #No.CHI-A30031 --end--

END FUNCTION
 
FUNCTION t411_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN       #No.FUN-570109
       IF g_qcf.qcf00='1' THEN
          CALL cl_set_comp_entry("qcf00,qcf01",FALSE)
       ELSE
          CALL cl_set_comp_entry("qcf00,qcf01,qcf03,qcf02,qcf05",FALSE)
       END IF
    END IF
 
    IF INFIELD(qcf00) OR ( NOT g_before_input_done ) THEN
       IF g_qcf.qcf00='2' THEN
          CALL cl_set_comp_entry("qcf03,qcf05,qcf02",FALSE)
       END IF
       IF g_qcf.qcf00='1' THEN
          CALL cl_set_comp_entry("qcf021",FALSE)
       END IF
 
    END IF
 
    #No.CHI-A30031 --start--
    IF p_cmd = 'u' AND g_qcf.qcf09='1' THEN
       CALL cl_set_comp_entry("qcf22",FALSE)
    END IF
    #No.CHI-A30031 --end--

END FUNCTION
 
FUNCTION t411_qcf22()
    DEFINE l_acc_qty   LIKE qcf_file.qcf22
    DEFINE l_sfv09     LIKE sfv_file.sfv09
 
     SELECT SUM(qcf22) INTO un_post_qty FROM qcf_file
      WHERE qcf02 = g_qcf.qcf02
        AND qcf01<>g_qcf.qcf01
        AND qcf03 = g_qcf.qcf03  #NO.TQC-630218 ADD
     IF un_post_qty IS NULL THEN LET un_post_qty=0 END IF
     SELECT SUM(qcf091) INTO post_qty FROM qcf_file
      WHERE qcf02 = g_qcf.qcf02
        AND qcf14='Y'   #確認
        AND qcf01<>g_qcf.qcf01
        AND qcf03 = g_qcf.qcf03  #NO.TQC-630218 ADD
     IF post_qty IS NULL THEN LET post_qty=0 END IF
     LET l_acc_qty= un_post_qty+post_qty
     RETURN l_acc_qty
END FUNCTION
 
FUNCTION t411_spc()
 
   LET g_success = 'Y'
 
   CALL t411_y_chk()          #CALL 原確認的 check 段
   IF g_success = "N" THEN
      RETURN
   END IF
 
   #檢查資料是否可拋轉至 SPC
   CALL aws_spccli_qc_chk(g_qcf.qcf01,g_qcf.qcfspc,g_qcf.qcf14,g_qcf.qcfacti)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   # CALL aws_spccli()
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),delete(刪除)
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(g_prog,base.TypeInfo.create(g_qcf),'insert') THEN 
      LET g_qcf.qcfspc = '1'
   ELSE
      LET g_qcf.qcfspc = '2'
   END IF
 
   DISPLAY BY NAME g_qcf.qcfspc
 
END FUNCTION
 
FUNCTION t411_qcf03()
   DEFINE l_err           LIKE ze_file.ze01
   DEFINE l_qcf22         LIKE qcf_file.qcf22        #No.FUN-680104 DEC(12,0)
   DEFINE l_acc_qty       LIKE qcf_file.qcf22        #No.FUN-680104 DEC(15,3)
   DEFINE l_ecu012        LIKE ecu_file.ecu012       #FUN-A60092 add
   DEFINE l_sgm03         LIKE sgm_file.sgm03        #FUN-A60092 add
   DEFINE l_ima55         LIKE ima_file.ima55        #FUN-BB0085
   
   SELECT * FROM shm_file
    WHERE shm01 = g_qcf.qcf03
      AND shm28 = 'N'  #未結案
   IF STATUS=100 THEN
      LET l_err = 'aqc-034'
      RETURN l_err
   END IF
   CALL t411_shm('i')   #MOD-8A0131 add 'i'
   IF STATUS = 100 THEN 
      LET l_err = 'aqc-034'
      RETURN l_err
   END IF
 
   LET g_max_qcf22=0
   
   CALL t411_max_sgm03(g_qcf.qcf02) RETURNING l_ecu012,l_sgm03  #FUN-A60092    
   SELECT (sgm311+sgm315+sgm316+sgm317)
     INTO g_max_qcf22
     FROM sgm_file
    WHERE sgm01=g_qcf.qcf03
#FUN-A60092 --begin--
#     AND sgm03=(SELECT MAX(sgm03)   #終站程序
#                  FROM sgm_file
#                 WHERE sgm01=g_qcf.qcf03)
      AND sgm012 = l_ecu012
      AND sgm03  = l_sgm03
#FUN-A60092 --end--
      
   IF cl_null(g_qcf.qcf22) OR g_qcf.qcf22=0 THEN
      LET g_qcf.qcf22=g_max_qcf22
   END IF
   CALL t411_qcf22() RETURNING l_qcf22
   LET l_acc_qty = g_max_qcf22-l_qcf22
   LET g_qcf.qcf22=l_acc_qty
   #FUN-BB0085-add-str--
   SELECT ima55 INTO l_ima55 FROM ima_file
    WHERE ima01 = g_qcf.qcf021
   LET g_qcf.qcf22 = s_digqty(g_qcf.qcf22,l_ima55)
   #FUN-BB0085-add-end--
   DISPLAY BY NAME g_qcf.qcf22
 
   RETURN l_err
 
END FUNCTION
 
FUNCTION t411_qcf021()
   DEFINE l_err     LIKE ze_file.ze01,
          m_ima02   LIKE ima_file.ima02,
          m_ima109  LIKE ima_file.ima109,
          m_azf03   LIKE azf_file.azf03
 
   LET l_err = NULL 
 
   SELECT ima02,ima109,ima100,ima101,ima102   #FUN-A80063 add ima101
     INTO m_ima02,m_ima109,g_qcf.qcf21,g_ima101,g_qcf.qcf17    #FUN-A80063 add ima101
     FROM ima_file WHERE ima01=g_qcf.qcf021
   IF STATUS=100 THEN
      LET m_ima02 = ' ' 
      LET m_ima109=' '
      LET g_qcf.qcf21=' ' 
      LET g_qcf.qcf17=' '
      LET l_err = 'mfg1201'
      LET g_ima101 = ' '   #FUN-A80063 add ima101
      RETURN l_err
   END IF
   DISPLAY m_ima02 TO FORMONLY.ima02
   DISPLAY m_ima109 TO FORMONLY.ima109
 
   SELECT azf03 INTO m_azf03 FROM azf_file
      WHERE azf01=m_ima109 AND azf02='8'
   IF STATUS THEN LET m_azf03=' ' END IF
   DISPLAY m_azf03 TO FORMONLY.azf03
 
   DISPLAY g_qcf.qcf17 TO qcf17
   CASE g_qcf.qcf21
        WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcf21_desc
        WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcf21_desc
        WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcf21_desc
   END CASE
   DISPLAY g_qcf.qcf21 TO qcf21
   DISPLAY qcf21_desc TO FORMONLY.qcf21_desc

   #----------CHI-BC0018 str add-----------------
   CASE g_ima101
      WHEN '1'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_1' AND gae03=g_lang

      WHEN '2'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_2' AND gae03=g_lang

      WHEN '3'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_3' AND gae03=g_lang

      WHEN '4'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_4' AND gae03=g_lang

      OTHERWISE
         LET ima101_desc=' '
   END CASE
   DISPLAY ima101_desc TO FORMONLY.ima101_desc
   
    CASE g_qcf.qcf17
      WHEN '1'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
      WHEN '7'
         SELECT gae04 INTO qcf17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcf17_desc= ' '
    END CASE
   DISPLAY qcf17_desc TO FORMONLY.qcf17_desc
   #----------CHI-BC0018 end add-----------------

   RETURN l_err
 
END FUNCTION
 
FUNCTION t411_spc_upd()
   BEGIN WORK
   IF NOT t411_spc_upd_process() THEN
      ROLLBACK WORK
      RETURN
   END IF
   IF g_aza.aza65 = 'Y' THEN
      CALL t411_y_chk()              #CALL 原確認的 check 段
      IF g_success = "Y" THEN
         CALL t411_y_upd()           #CALL 原確認的 update 段
      END IF
      IF g_success = "N" THEN
         ROLLBACK WORK
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION t411_y_chk()
   DEFINE l_msg      LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_str1     LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_str2     LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_acc_qty  LIKE qcf_file.qcf22         #No.FUN-680104 DEC(15,3)
   DEFINE l_qcf22    LIKE qcf_file.qcf22         #No.FUN-680104 DEC(15,3)
   DEFINE l_ecu012   LIKE ecu_file.ecu012        #FUN-A60092 
   DEFINE l_sgm03    LIKE sgm_file.sgm03         #FUN-A60092 
   DEFINE l_n        LIKE type_file.num5         #FUN-BC0104
   DEFINE l_sum      LIKE type_file.num10        #FUN-BC0104
   DEFINE l_sum1     LIKE type_file.num10        #TQC-C20504
   
   LET g_success = 'Y'
 
#CHI-C30107 ----------------- add ------------------ begin
   IF g_qcf.qcf14 = 'Y' THEN
      CALL cl_err('',9023,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_qcf.qcf14 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_qcf.qcf22 = 0 THEN
      CALL cl_err('','aqc-027',0)
      LET g_success ='N'
      RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm" THEN
     IF NOT cl_confirm('axm-108') THEN
        LET g_success='N'
        RETURN
     END IF
   END IF
#CHI-C30107 ------------ add ------------ end
   SELECT * INTO g_qcf.* FROM qcf_file
    WHERE qcf01=g_qcf.qcf01 AND qcf02=g_qcf.qcf02
 
   IF g_qcf.qcf14 = 'Y' THEN 
      CALL cl_err('',9023,0) 
      LET g_success = 'N'
      RETURN 
   END IF
 
   IF g_qcf.qcf14 = 'X' THEN 
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN 
   END IF
 
   IF g_qcf.qcf22 = 0 THEN
      CALL cl_err('','aqc-027',0)
      LET g_success ='N'
      RETURN
   END IF
 
   IF g_qcf.qcf00 = '1' THEN     #MOD-C30560
      LET g_max_qcf22=0
      LET l_acc_qty =0
      LET l_qcf22 =0
     
      CALL t411_max_sgm03(g_qcf.qcf02) RETURNING l_ecu012,l_sgm03  #FUN-A60092   
      SELECT (sgm311+sgm315+sgm316+sgm317)
        INTO g_max_qcf22
        FROM sgm_file
       WHERE sgm01=g_qcf.qcf03
       #FUN-A60092 --beign--    
       # AND sgm03=(SELECT MAX(sgm03)   #終站程序
       #              FROM sgm_file
       #             WHERE sgm01=g_qcf.qcf03)
         AND sgm012 = l_ecu012
         AND sgm03  = l_sgm03 
       #FUN-A60092 --end--
                  
      CALL t411_qcf22() RETURNING l_qcf22
      LET l_acc_qty = g_max_qcf22-l_qcf22
      IF g_qcf.qcf091 > l_acc_qty THEN
         LET l_qcf22 = l_qcf22+g_qcf.qcf091
         CALL cl_getmsg('aqc-427',g_lang) RETURNING l_str1
         CALL cl_getmsg('aqc-428',g_lang) RETURNING l_str2
         LET l_msg = l_str2 CLIPPED,l_qcf22 USING "######.###",
                     " > ",l_str1 CLIPPED,g_max_qcf22 USING "######.###"
         CALL cl_msgany(0,0,l_msg)
         LET g_success = 'N'
         RETURN
      END IF
   END IF               #MOD-C30560
#FUN-BC0104----add----str----
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = g_qcf.qcf01
   IF l_n > 0 THEN
      IF g_qcf.qcf09 = '1' THEN          #MOD-C30557
         SELECT SUM(qco11*qco19) INTO l_sum
           FROM qco_file,qcl_file
          WHERE qco01 = g_qcf.qcf01
            AND qco03 = qcl01
            AND qcl05 <> '3'
         IF l_sum != g_qcf.qcf091 THEN
            CALL cl_err(g_qcf.qcf01,'aqc-520',0)
            LET g_success = 'N'
            RETURN
         END IF
      END IF                            #MOD-C30557
      #TQC-C20504----Begin----
      SELECT SUM(qco11*qco19) INTO l_sum1
        FROM qco_file
       WHERE qco01 = g_qcf.qcf01
      IF l_sum1 != g_qcf.qcf22 THEN
         CALL cl_err(g_qcf.qcf01,'aqc-536',0)
         LET g_success ='N'
         RETURN
      END IF
      #TQC-C20504-----End-----
   END IF
#FUN-BC0104----add----end----
END FUNCTION
 
FUNCTION t411_y_upd()
   DEFINE l_msg      LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_str1     LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_str2     LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
   DEFINE l_acc_qty  LIKE qcf_file.qcf22         #No.FUN-680104 DEC(15,3)
   DEFINE l_qcf22    LIKE qcf_file.qcf22         #No.FUN-680104 DEC(15,3)
 
   #若設定與 SPC 整合, 判斷是否已拋轉
   IF g_aza.aza64 NOT matches '[ Nn]' AND 
     ((g_qcf.qcfspc IS NULL ) OR g_qcf.qcfspc NOT matches '[1]'  )
   THEN
     CALL cl_err('','aqc-117',0)
     LET g_success='N'
     RETURN
   END IF
 
#CHI-C30107 --------------- mark ----------------- begin
#  IF g_action_choice CLIPPED = "confirm" THEN 
#    IF NOT cl_confirm('axm-108') THEN
#       LET g_success='N'
#       RETURN
#    END IF
#  END IF
#CHI-C30107 --------------- mark ----------------- end
 
   IF (g_argv2 <> "SPC_ins" AND g_argv2 <> "SPC_upd") OR g_argv2 IS NULL THEN
      BEGIN WORK
   END IF
 
   OPEN t411_cl USING g_qcf.qcf01
   IF STATUS THEN
      CALL cl_err("OPEN t411_cl:", STATUS, 1)
      CLOSE t411_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t411_cl INTO g_qcf.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t411_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   LET g_success = 'Y'
 
   UPDATE qcf_file SET qcf14='Y',
                       qcf15=g_today
    WHERE qcf01=g_qcf.qcf01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
   IF g_qcf.qcf09 = '2' THEN      #MOD-C30557
      CALL t411_qc()              #MOD-C30557
   END IF                         #MOD-C30557
 
   IF g_success = 'Y' THEN
      LET g_qcf.qcf14='Y'
      LET g_qcf.qcf15=g_today
      IF (g_argv2 <> "SPC_ins" AND g_argv2 <> "SPC_upd")     
                OR g_argv2 IS NULL THEN 
         COMMIT WORK
      END IF
      CALL cl_flow_notify(g_qcf.qcf01,'Y')
      DISPLAY BY NAME g_qcf.qcf14,g_qcf.qcf15
      CALL t411_qc_item_show()                #MOD-C30557
   ELSE
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
#MOD-C30557----add----str----
FUNCTION t411_qc()
DEFINE l_sum_qco11     LIKE type_file.num10,
       l_n             LIKE type_file.num5

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = g_qcf.qcf01
   IF l_n = 0 THEN RETURN END IF

   SELECT SUM(qco11*qco19) INTO l_sum_qco11
     FROM qco_file,qcl_file
    WHERE qco01 = g_qcf.qcf01
      AND qco03 = qcl01
      AND qcl05 <> '3'
   IF cl_null(l_sum_qco11) THEN LET l_sum_qco11 = 0 END IF
   IF l_sum_qco11 = 0 THEN RETURN END IF

   UPDATE qcf_file
      SET qcf09  = '1',
          qcf091 = l_sum_qco11
    WHERE qcf01  = g_qcf.qcf01
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
   END IF

END FUNCTION
#MOD-C30557----add----end----

FUNCTION t411_spc_def()
DEFINE l_err           LIKE ze_file.ze01             
 
   LET g_qcf.qcfspc = '1'
 
   CALL t411_qcf03() RETURNING l_err
   IF NOT cl_null(l_err) THEN
      CALL cl_err(g_qcf.qcf01,l_err,1)
      RETURN 0
   END IF
 
   CALL t411_qcf021() RETURNING l_err  
   IF NOT cl_null(l_err) THEN
      CALL cl_err(g_qcf.qcf01,l_err,1)
      RETURN 0
   END IF
 
   LET g_qcf.qcf05 = '1'
 
   RETURN 1
END FUNCTION
 
FUNCTION t411_spc_upd_process()
DEFINE l_status    LIKE type_file.num5         #No.FUN-680104 SMALLINT
DEFINE l_qcf091    LIKE qcf_file.qcf091
DEFINE l_qcf22     LIKE qcf_file.qcf22
 
   # CALL aws_spcfld()
   #功能: 修改 QC 張資料
   # 傳入參數: (1) QC 程式代號, (2) TABLE 名稱,
   #           (3) 合格量欄位,  (4) 送驗量欄位
   # 回傳值  : (1)0 更改失敗; 1 更新成功
   #           (2) 合格量數量， (3)送驗量數量
   CALL aws_spcfld(g_prog,'qcf_file','qcf091','qcf22') 
     RETURNING l_status,l_qcf091,l_qcf22
   IF l_status = 0 THEN
      RETURN FALSE
   END IF
   RETURN TRUE 
END FUNCTION
#FUN-BB0085-----add-----str-------------
FUNCTION t411_qcf22_check()
DEFINE l_acc_qty       LIKE qcf_file.qcf22,
       l_qcf22         LIKE qcf_file.qcf22,
       l_ecu012        LIKE ecu_file.ecu012,
       l_sgm03         LIKE sgm_file.sgm03,
       l_str1          LIKE type_file.chr1000,
       l_str2          LIKE type_file.chr1000, 
       l_msg           LIKE type_file.chr1000,
       l_ima55         LIKE ima_file.ima55
     

   IF NOT cl_null(g_qcf.qcf22) THEN
      IF g_qcf_t.qcf22 != g_qcf.qcf22 OR cl_null(g_qcf_t.qcf22) OR cl_null(g_qcf_t.qcf021) OR g_qcf_t.qcf021 != g_qcf.qcf021 THEN
         SELECT ima55 INTO l_ima55 FROM ima_file
          WHERE ima01 = g_qcf.qcf021
         LET g_qcf.qcf22 = s_digqty(g_qcf.qcf22,l_ima55)
         DISPLAY BY NAME g_qcf.qcf22
      END IF
   END IF
   IF NOT cl_null(g_qcf.qcf22) THEN
      IF g_qcf.qcf22 < 0 THEN CALL cl_err('','aqc-016',0)
         RETURN FALSE
      END IF
      IF g_qcf.qcf22 = 0 THEN
         CALL cl_err('','aqc-028',0)
         RETURN FALSE
      END IF
   IF g_qcf.qcf00 <> '2' THEN #MOD-850258 add
      LET g_max_qcf22=0
      LET l_acc_qty =0
      LET l_qcf22 =0

      CALL t411_max_sgm03(g_qcf.qcf02) RETURNING l_ecu012,l_sgm03
      SELECT (sgm311+sgm315+sgm316+sgm317)
        INTO g_max_qcf22
        FROM sgm_file
       WHERE sgm01=g_qcf.qcf03
         AND sgm012 = l_ecu012
         AND sgm03  = l_sgm03
      CALL t411_qcf22() RETURNING l_qcf22
      LET l_acc_qty = g_max_qcf22-l_qcf22
      IF g_qcf.qcf22 > l_acc_qty THEN
         LET l_qcf22 = l_qcf22+g_qcf.qcf22
         CALL cl_getmsg('aqc-427',g_lang) RETURNING l_str1
         CALL cl_getmsg('aqc-428',g_lang) RETURNING l_str2
         LET l_msg = l_str2 CLIPPED,l_qcf22 USING "######.###",
                     " > ",l_str1 CLIPPED,g_max_qcf22 USING "######.###"
         CALL cl_msgany(0,0,l_msg)
         RETURN FALSE    
      END IF
      IF g_qcf.qcf22>g_max_qcf22 THEN
         CALL cl_err(g_max_qcf22,'asf-673',0)
         RETURN FALSE    
      END IF
   END IF
      LET g_qcf22=g_qcf.qcf22
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BB0085-----add-----end-------------
#FUN-BC0104-add-str--
FUNCTION t411_qc_item_show()
   SELECT qcf09,qcf091
     INTO g_qcf.qcf09,g_qcf.qcf091
     FROM qcf_file
    WHERE qcf01 = g_qcf.qcf01
   DISPLAY BY NAME g_qcf.qcf09,g_qcf.qcf091
   CASE g_qcf.qcf09
      WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
      WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING des1             
      WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   END CASE
   DISPLAY des1 TO FORMONLY.des1
END FUNCTION
#FUN-BC0104-add-end--
#No:FUN-9C0071--------精簡程式-----
