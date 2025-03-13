# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saxmt360.4gl
# Descriptions...: 報價單資料維護作業
# Date & Author..: 00/02/29 By Gina
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No:9496 04/04/28 Melody s_oqu[l_ac]應改為s_oqu[l_sl]
# Modify.........: No.MOD-4800367 04/08/23 Wiky 在CONTOLP中加DISPLAY 才會跑ON ROW CHANG
# Modify.........: No.MOD-480553 04/09/20 Melody 用客戶編號將慣用交易條件自動default...其他如幣別....一併處理
# Modify.........: No.MOD-4A0079 04/10/07 By Mandy 1.確認後要可以看到備註資料,但不可更改
# Modify.........: No.MOD-4A0079 04/10/07 By Mandy 2.列印要能印未確認的資料
# Modify.........: No.MOD-4A0096 04/10/07 By ching PROMPT不用再OPEN WINDOW
# Modify.........: No.MOD-4A0252 04/10/21 By Smapmin 報價單號開窗
# Modify.........: No.FUN-4B0038 04/11/16 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4C0041 04/12/13 By Echo  查看"簽核狀況"的button
# Modify.........: NO.MOD-530341 05/03/25 By Mandy 生產地開窗時會篩選出有效的生產地編號, 但直接輸入時未檢查生產地編號是否有效.
# Modify.........: No.MOD-530870 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify         : No.FUN-550022 05/05/11 by Echo 複製功能，無判斷單別是否簽核，狀態碼修改為combobox。
#                                                 將確認與簽核流程拆開獨立。
# Modify.........: No.FUN-560193 05/06/29 By kim 單身 '單位' 右邊增秀'計價單位'
# Modify.........: No.MOD-570106 05/08/16 By kim 輸入客戶編號後所帶出的欄位,在存檔前再檢查一次正確性
# Modify.........: No.FUN-580028 05/09/07 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-580113 05/08/24 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.FUN-590039 05/09/09 By Mandy 若該單別設定成自動確認,則報價單輸入完存檔後要能自動確認
# Modify.........: No.FUN-590038 05/09/09 By Nicola 客戶編號可不輸入
# Modify.........: No.FUN-5B0145 05/11/30 By Echo 新增運輸方式說明
# Modify.........: No.FUN-610043 06/01/12 By Sarah 報價單之取價,應如訂單一樣有5種輸入方式
# Modify.........: No.FUN-610041 06/02/22 By Sarah 1.單身不能限制一定要輸入包裝數量、包裝單位、生產地
#                                                  2.包裝單位(oqu10)要有放大鏡帶單位資料
#                                                  3.單身新增包裝方式(oqu14)，若有選擇可以自動帶出材積、淨重、毛重
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: No.MOD-640112 06/04/09 By Mandy 單身新增號後,單位(oqu05)應自動帶出
# Modify.........: No.MOD-640459 06/04/12 By Mandy 若勾選分量計價，單身單價應該不能輸入，並應要有警號訊息。
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-640248 06/05/26 By Echo 自動執行確認功能
# Modify.........: No.FUN-650160 06/06/22 By kim 報價單的資料是由估價單得來
# Modify.........: No.FUN-660167 06/06/27 By wujie cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-650197 06/07/17 By Joe 單身增加生產地名稱欄位
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.MOD-690093 06/09/18 By Rayven 選擇分量計價，單身維護2筆以上資料，按數量報價資料按鈕，維護退出后單身第一筆資料會清掉。
# Modify.........: No.FUN-690022 06/09/29 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0051 06/10/20 By Sarah 新增時系統自動帶出輸入人員之工號於業務人員及部門代號
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0117 06/11/21 By day 欄位加控管 
# Modify.........: No.MOD-720055 07/02/07 By claire axm-365若估價單號空白則不自動產生單身
# Modify.........: No.MOD-710180 07/02/07 By claire obg07,obg08,obg22取值來自於occ21,occ20,occ22
# Modify.........: No.FUN-720014 07/03/02 By rainy 地址擴充為5欄255
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730079 07/03/21 By pengu 『運輸方式』的說明 會顯示 『交易條件』的說明
# Modify.........: No.FUN-730018 07/03/26 By kim 行業別架構
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770031 07/07/05 By claire 判斷MISC料號只取四碼判斷
# Modify.........: No.MOD-780280 07/08/30 By claire 複製後放棄資料卻寫入了
# Modify.........: No.TQC-790009 07/09/01 By claire 複製後應回到原來那筆資料
# Modify.........: No.MOD-790159 07/09/29 By claire 清除舊值
# Modify.........: No.TQC-7A0056 07/10/17 By lumxa 當報價單是由估價單轉來時，報價單幣種應該默認帶估計單的幣種，目前是按照客戶的慣用幣種重新抓取了一遍幣種。
#                     另外，當報價單幣種與估計單幣種不一致時，報價單單價應該按照匯率進行換算。 
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840042 08/04/10 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-840214 08/04/20 By claire 需加上產品淨重才是毛重
# Modify.........: No.MOD-840269 08/04/21 By Mandy 不再自動開"其它資料"視窗,要改其它資料,按Action"其它資料"即可
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-840692 08/04/30 By claire 複製時,取單號要傳入當日日期,才不會有跨期別取錯單號
# Modify.........: No.MOD-850138 08/05/13 By Smapmin 先依客戶編號預設業務人員,再者才抓g_user
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.MOD-890162 08/09/18 By Smapmin 修改key值後,單身與其他資料並未同步更新key值
# Modify.........: No.FUN-890011 08/10/14 By xiaofeizhu 在開窗選取客戶編號時，也可選擇"潛客資料(ofd_file)
# Modify.........: No.TQC-930107 09/03/13 By chenyu 1.在axmt3602中，單價可以輸入負數
#                                                   2.在axmt3602中，截至數量大于起始數量，會報錯，然后NEXT FIELD起始數量，此時點確定沒報錯，保存成功
#                                                   3.資料有效碼沒有顯示
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990186 09/09/29 By Smapmin 點選右手邊其他資料ACTION時,判斷oqt_file是否有資料,若無資料則由axmi360預設帶過來
# Modify.........: No:MOD-9B0113 09/11/17 By sherry 處理客戶編號的問題
# Modify.........: No:FUN-9C0073 10/01/07 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30103 10/03/16 By Smapmin 修改變數型態
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXM
# Modify.........: No:CHI-A60033 10/07/06 By Summer 複製時打完單號,要進入update狀態,update完後要恢復到原來的那一筆
# Modify.........: No:MOD-A60147 10/07/07 By Smapmin 按列印時跳出請輸入品名規格額外說明類別
#                                                    若按放棄，雖然可以跑出報表
#                                                    但再按一次列印會沒有反應
# Modify.........: No:FUN-A80056 10/08/14 By destiny 报价单依订单方式呈现
# Modify.........: No:FUN-AA0059 10/10/25 By chenying 料號開窗控管
# Modify.........: No:FUN-AB0082 10/12/07 By shiwuying s_fetch_price_new修改
# Modify.........: No:MOD-AC0088 10/12/24 By Summer 目的地應存放中文說明
# Modify.........: No:TQC-B20144 11/02/22 By zhangll 修改新增欄位顯示錯誤
# Modify.........: No:MOD-B30194 11/03/12 By wangxin 欄位為空時，清空欄位說明       
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B40202 11/04/25 By lilingyu EF簽核相關BUG修改
# Modify.........: No:MOD-B60217 11/06/24 By JoHung 客戶編號異動 判斷新舊值加上判斷舊值為NULL
# Modify.........: No:CHI-B60080 11/06/27 By JoHung 料件編號時判斷將客戶品號轉成本公司品號
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No:TQC-B80187 11/08/26 By lixia 查詢欄位
# Modify.........: No:TQC-B90152 11/09/22 By destiny 毛重不能小于净重
# Modify.........: No:MOD-BA0084 11/10/11 By Summer 修改FUN-A80056取價方式判斷條件 
# Modify.........: No:FUN-BB0085 11/11/21 By xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20028 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-BC0071 12/02/08 By huangtao 增加取價參數
# Modify.........: No:MOD-B90197 12/02/15 By bart (1)在AFTER FIELD oqu05檢核單位是否與該料的庫存單位(ima25)有轉換率
# Modify.........: No:TQC-C20183 12/02/16 By fengrui 數量欄位小數取位處理
# Modify.........: No.FUN-C40089 12/05/02 By bart 判斷銷售價格條件(axmi060)的oah08,若oah08為Y則單價欄位可輸入0;若oah08為N則單價欄位不可輸入0
# Modify.........: No.FUN-C50074 12/05/18 By bart 更改錯誤訊息代碼
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/07/04 By nanbing CR改串GR
# Modify.........: No:TQC-C60211 12/07/18 By zhuhao 審核時部門資料檢查
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-CA0039 12/10/15 By dongsz 取價時抓取報價單相關資料
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:CHI-CC0034 13/01/17 By Summer 修正毛重淨重計算
# Modify.........: No:FUN-D20025 13/02/21 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:TQC-D10032 13/03/05 By jt_chen AFTER FIELD oqu14(包裝方式)計算的毛重需加上淨重
# Modify.........: No:MOD-D20001 13/03/12 By jt_chen 數量報價資料 檢核 起始數量 和 截止數量 必須連續
# Modify.........: No:CHI-B60094 13/03/22 By Elise s_cusqry加傳參數
# Modify.........: No:MOD-D30252 13/03/25 By Vampire 依照單據幣別取位
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50103 13/05/16 By SunLM 1.修正分量計價畫面退出后異常情況2.如果分量計價那麼不能根據估價單號帶出單身單價和數量
#                                                  3.更改幣別,提示更改單身單價金額信息4.修正單身淨重毛重問題
# Modify.........: No:MOD-D50112 13/05/16 By SunLM 更新業務人員姓名

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt360.global"
 
DEFINE g_oqu05_t   LIKE oqu_file.oqu05  #FUN-BB0085
DEFINE g_oqu10_t   LIKE oqu_file.oqu10  #FUN-BB0085
DEFINE g_oah08     LIKE oah_file.oah08  #FUN-C40089

FUNCTION t360(p_argv1,p_argv2)
   DEFINE   p_argv1   LIKE oqt_file.oqt01    #No.FUN-630010
   DEFINE   p_argv2   STRING     #No.FUN-630010
 
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
 
    LET g_argv1 = p_argv1                  #No.FUN-630010
    LET g_argv2 = p_argv2                  #No.FUN-630010
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM oqt_file WHERE oqt01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t360_cl CURSOR FROM g_forupd_sql
 
    #start FUN-580113
    IF fgl_getenv('EASYFLOW') = "1" THEN
       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
    END IF
    #end FUN-580113
 
      LET g_action_choice = ''
 
      #建立簽核模式時的 toolbar icon
      CALL aws_efapp_toolbar()
 
      IF NOT cl_null(g_argv1) THEN
         CASE g_argv2
            WHEN "query"
               LET g_action_choice = "query"
               IF cl_chk_act_auth() THEN
                  CALL t360_q()
               END IF
            WHEN "insert"
               LET g_action_choice = "insert"
               IF cl_chk_act_auth() THEN
                  CALL t360_a()
               END IF
            WHEN "efconfirm"
               CALL t360_q()
               CALL t360_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t360_y_upd()       #CALL 原確認的 update 段
               END IF
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
               EXIT PROGRAM
               OTHERWISE
               CALL t360_q()
         END CASE
      END IF
 
      #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
      CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, 
                                void,undo_void, confirm, undo_confirm, easyflow_approval, other_data,   #FUN-D20025 add undo_void
                                qty_quot, expense_data, addr__change
                               ,memo             #TQC-B40202  
                                ")
           RETURNING g_laststage
 
      CALL t360_menu()
 
END FUNCTION
 
FUNCTION t360_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_t             LIKE    type_file.num5    #NO.FUN-A80056
    CLEAR FORM                       #清除畫面
    CALL g_oqu.clear()
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " oqt01 = '",g_argv1,"'"
       LET g_wc2 = " 1=1"
    ELSE
       WHILE TRUE
          CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
          INITIALIZE g_oqt.* TO NULL      #No.FUN-750051
          CONSTRUCT BY NAME g_wc ON      # 螢幕上取單頭條件
            oqt01,oqt02,oqt23,oqt04,oqt041,oqt03, #FUN-650160 add oqt23
            oqt07,oqt06,
            #oqt09,oqt10,oqt11,oqt08,oqt12,  #NO.FUN-A80056
            oqt09,oqt24,gec04,gec07,oqt10,oqt25,oqt11,oqt26,oqt27,oqt12,  #NO.FUN-A80056
            oqt22,oqtconf,oqt21,
            oqtuser,oqtgrup,oqtmodu,oqtdate,oqtacti,   #No.TQC-930107 add acti
            oqtoriu,oqtorig,  #TQC-B80187
            oqtud01,oqtud02,oqtud03,oqtud04,oqtud05,
            oqtud06,oqtud07,oqtud08,oqtud09,oqtud10,
            oqtud11,oqtud12,oqtud13,oqtud14,oqtud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
            ON ACTION controlp
              CASE
                  WHEN INFIELD(oqt01) #查詢單別  #MOD-4A0252報價單號開窗
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_oqt"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt01
                      NEXT FIELD oqt01
                 WHEN INFIELD(oqt23) #估價單號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_oqa"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt23
                      NEXT FIELD oqt23
                 WHEN INFIELD(oqt04) #查詢客戶資料
                      CALL q_occ08(TRUE,TRUE)                                 #FUN-890011 Add
                      RETURNING g_qryparam.multiret                           #FUN-890011 Add                                                           
                      DISPLAY g_qryparam.multiret TO oqt04                    #FUN-890011 Add                      
                 WHEN INFIELD(oqt06)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_gem"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt06
                      NEXT FIELD oqt06                       
                 WHEN INFIELD(oqt07)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_gen"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt07
                      NEXT FIELD oqt07                      
                 WHEN INFIELD(oqt09)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_azi"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt09
                      NEXT FIELD oqt09
#NO.FUN-A80056--begin
                 WHEN INFIELD(oqt24)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_oqt24"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt24
                      NEXT FIELD oqt24       
#NO.FUN-A80056--end                               
                 WHEN INFIELD(oqt10)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_oah"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt10
                      NEXT FIELD oqt10
#NO.FUN-A80056--begin
                 WHEN INFIELD(oqt25)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_oqt25"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt25
                      NEXT FIELD oqt25       
#NO.FUN-A80056--end                                 
                 WHEN INFIELD(oqt11)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_ged"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt11
#NO.FUN-A80056--begin
                 WHEN INFIELD(oqt26)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_oqt26"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt26
                      NEXT FIELD oqt26       
                 WHEN INFIELD(oqt27)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_oqt27"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqt27
                      NEXT FIELD oqt27                                
#NO.FUN-A80056--end                                 
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
 
          EXIT WHILE
       END WHILE
 
       # 螢幕上取單身條件
       CONSTRUCT g_wc2 ON oqu02,oqu03,oqu04,oqu031,oqu032,oqu09,oqu10,
                          oqu14,            #FUN-610041
                          oqu08,oqu05,oqu06,oqu07,oqu11,oqu12,oqu13,
                          oquud01,oquud02,oquud03,oquud04,oquud05,
                          oquud06,oquud07,oquud08,oquud09,oquud10,
                          oquud11,oquud12,oquud13,oquud14,oquud15
 
                     FROM s_oqu[1].oqu02, s_oqu[1].oqu03,s_oqu[1].oqu04,
                          s_oqu[1].oqu031,s_oqu[1].oqu032,s_oqu[1].oqu09,
                          s_oqu[1].oqu10,
                          s_oqu[1].oqu14,   #FUN-610041
                          s_oqu[1].oqu08, s_oqu[1].oqu05,
                          s_oqu[1].oqu06, s_oqu[1].oqu07,s_oqu[1].oqu11,
                          s_oqu[1].oqu12, s_oqu[1].oqu13,
                          s_oqu[1].oquud01,s_oqu[1].oquud02,s_oqu[1].oquud03,
                          s_oqu[1].oquud04,s_oqu[1].oquud05,
                          s_oqu[1].oquud06,s_oqu[1].oquud07,s_oqu[1].oquud08,
                          s_oqu[1].oquud09,s_oqu[1].oquud10,
                          s_oqu[1].oquud11,s_oqu[1].oquud12,s_oqu[1].oquud13,
                          s_oqu[1].oquud14,s_oqu[1].oquud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
           ON ACTION controlp
              CASE
                 WHEN INFIELD(oqu03)
#FUN-AA0059---------mod------------str-----------------
                 
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state = "c"
#                      LET g_qryparam.form ="q_ima"
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                      DISPLAY g_qryparam.multiret TO oqu03
                      NEXT FIELD oqu03
                 WHEN INFIELD(oqu04)
#FUN-AA0059---------mod------------str-----------------                 
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state = "c"
#                      LET g_qryparam.form ="q_ima"
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                      DISPLAY g_qryparam.multiret TO oqu04
                      NEXT FIELD oqu04
                 WHEN INFIELD(oqu05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_gfe"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqu05
                      NEXT FIELD oqu05
                 WHEN INFIELD(oqu08)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_oqw"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqu08
                      NEXT FIELD oqu08
                 WHEN INFIELD(oqu10)   #包裝單位
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_gfe"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqu10
                      NEXT FIELD oqu10
                 WHEN INFIELD(oqu14)   #包裝方式
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_obe"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oqu14
                      NEXT FIELD oqu14
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
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
       END CONSTRUCT
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF   #FUN-580113
 
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oqtuser', 'oqtgrup')
    #NO.FUN-A80056--begin
    #IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
    #   LET g_sql = "SELECT  oqt01 FROM oqt_file,gec_file",           #NO.FUN-A80056 add gec_file 
    #               " WHERE gec01=oqt24 AND gec02='2' AND ", g_wc CLIPPED,  #NO.FUN-A80056 add gec_file 
    #               " ORDER BY 1"
    # ELSE					# 若單身有輸入條件
    #   LET g_sql = "SELECT UNIQUE oqt_file. oqt01 ",
    #               #"  FROM oqt_file, oqu_file",                 #NO.FUN-A80056
    #               "  FROM oqt_file gec_file, oqu_file",   #NO.FUN-A80056
    #               " WHERE oqt01 = oqu01",
    #               " AND oqt24=gec01 AND gec02='2' ",  #NO.FUN-A80056
    #               "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
    #               " ORDER BY 1"
    #END IF    
    LET l_t=g_wc.getIndexOf('gec04',1)
    IF l_t=0 THEN 
       LET l_t=g_wc.getIndexOf('gec07',1)
    END IF     
    IF l_t>0 THEN 
       IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
          LET g_sql = "SELECT  oqt01 FROM oqt_file,gec_file",          
                      " WHERE gec01=oqt24 AND gec011='2' AND ", g_wc CLIPPED,  
                      " ORDER BY 1"
        ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE oqt_file.oqt01 ",          
                      "  FROM oqt_file,gec_file,oqu_file",   
                      " WHERE oqt01 = oqu01",
                      " AND oqt24=gec01 AND gec011='2' ", 
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      " ORDER BY 1"
       END IF
    ELSE 
       IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
          LET g_sql = "SELECT oqt01 FROM oqt_file",          
                      " WHERE ", g_wc CLIPPED,  
                      " ORDER BY 1"
        ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE oqt_file.oqt01 ",          
                      "  FROM oqt_file, oqu_file",   
                      " WHERE oqt01 = oqu01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      " ORDER BY 1"
       END IF    	   
    END IF  
    #NO.FUN-A80056--end
    PREPARE t360_prepare FROM g_sql
    DECLARE t360_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t360_prepare
 
    #NO.FUN-A80056--begin
    #IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
    #    #LET g_sql="SELECT COUNT(*) FROM oqt_file WHERE ",g_wc CLIPPED
    #    LET g_sql = "SELECT COUNT(*) FROM oqt_file,gec_file WHERE gec01=oqt24 AND gec02='2' AND ", g_wc CLIPPED  #NO.FUN-A80056 add gec_file 
    #ELSE
    #    #LET g_sql="SELECT COUNT(DISTINCT oqt01) FROM oqt_file,oqu_file WHERE ",  #NO.FUN-A80056
    #    LET g_sql="SELECT COUNT(DISTINCT oqt01) FROM oqt_file,gec_file,oqu_file WHERE ",  #NO.FUN-A80056
    #              " oqt24=gec01 AND gec02='2' AND ",                                             #NO.FUN-A80056 
    #              "oqu01=oqt01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    #END IF
    IF l_t>0 THEN 
       IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
           LET g_sql = "SELECT COUNT(*) FROM oqt_file,gec_file WHERE gec01=oqt24 AND gec011='2' AND ", g_wc CLIPPED 
       ELSE
           LET g_sql="SELECT COUNT(DISTINCT oqt01) FROM oqt_file,gec_file,oqu_file WHERE ", 
                     " oqt24=gec01 AND gec011='2' AND ",                                            
                     "oqu01=oqt01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
       END IF    
    ELSE 
       IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
           LET g_sql="SELECT COUNT(*) FROM oqt_file WHERE ",g_wc CLIPPED
       ELSE
           LET g_sql="SELECT COUNT(DISTINCT oqt01) FROM oqt_file,oqu_file WHERE ",  #NO.FUN-A80056                                            
                     "oqu01=oqt01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
       END IF       	 
    END IF 
    #NO.FUN-A80056--end
    PREPARE t360_precount FROM g_sql
    DECLARE t360_count CURSOR FOR t360_precount
END FUNCTION
 
FUNCTION t360_menu()
   DEFINE l_creator    LIKE type_file.chr1     # No.FUN-680137 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1     # No.FUN-680137 VARCHAR(1)     # 是否有指定加簽人員      #FUN-580113
 
   LET l_flowuser = "N"   #FUN-580113
 
   WHILE TRUE
      CALL t360_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t360_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t360_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t360_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t360_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t360_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t360_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t360_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "other_data"
            IF cl_chk_act_auth() THEN
               CALL t360_1('')
            END IF
         WHEN "qty_quot"
            IF cl_chk_act_auth() THEN
               CALL t360_2('','y')
               CALL t360_b_fill(g_wc2)  #No.MOD-690093
            END IF
         WHEN "expense_data"
            IF cl_chk_act_auth() THEN
               CALL t360_5()
            END IF
         WHEN "query_customer"
            CALL s_cusqry(g_oqt.oqt04,'')  #CHI-B60094 add ''
         WHEN "addr__change"
            IF cl_chk_act_auth() THEN
               CALL t360_s('s')
            END IF
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t360_m()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t360_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t360_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t360_z()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t360_x()    #FUN-D20025
               CALL t360_x(1)   #FUN-D20025
            END IF
         #FUN-D20025--add--str--
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
              #CALL t360_x()    #FUN-D20025
               CALL t360_x(2)   #FUN-D20025
            END IF
         #FUN-D20025--add--str--
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oqu),'','')
            END IF
         #@WHEN "簽核狀況"
          WHEN "approval_status"               # MOD-4C0041
            IF cl_chk_act_auth() THEN  #DISPLAY ONLY
               IF aws_condition2() THEN                #FUN-550022
                    CALL aws_efstat2()                 #MOD-560007
               END IF
            END IF
 
         WHEN "easyflow_approval"     #FUN-550022
            IF cl_chk_act_auth() THEN
              #FUN-C20028 add str---
               SELECT * INTO g_oqt.* FROM oqt_file
                WHERE oqt01 = g_oqt.oqt01
               CALL t360_show()
               CALL t360_b_fill(' 1=1')
              #FUN-C20028 add end---
               CALL t360_ef()
               CALL t360_show()  #FUN-C20028 add
            END IF
 
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                 CALL t360_y_upd()      #CALL 原確認的 update 段
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                 IF cl_confirm('aws-081') THEN
                    IF aws_efapp_getnextforminfo() THEN
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                       IF NOT cl_null(g_argv1) THEN
                          CALL t360_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,
                                   locale, void,undo_void, confirm, undo_confirm, easyflow_approval, other_data,  #FUN-D20025 add undo_void
                                   qty_quot, expense_data, addr__change
                                  ,memo             #TQC-B40202  
                                   ")
                               RETURNING g_laststage
                       ELSE
                          EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "不准"
         WHEN "deny"
             IF ( l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_oqt.oqt21 = 'R'
                      DISPLAY BY NAME g_oqt.oqt21
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                         LET l_flowuser = 'N'
                         LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                         IF NOT cl_null(g_argv1) THEN
                            CALL t360_q()
                            #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                            CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, 
                               query,locale, void, undo_void,confirm, undo_confirm, easyflow_approval, #FUN-D20025 add undo_void 
                               other_data, qty_quot, expense_data, addr__change
                              ,memo             #TQC-B40202  
                               ")
                                 RETURNING g_laststage
                         ELSE
                            EXIT WHILE
                         END IF
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF
 
         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_oqt.oqt01 IS NOT NULL THEN
                 LET g_doc.column1 = "oqt01"
                 LET g_doc.value1 = g_oqt.oqt01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t360_copy()
 #DEFINE b_oqt               RECORD LIKE oqt_file.*, #CHI-A60033 mark
  DEFINE l_newno             LIKE oqt_file.oqt01,    #CHI-A60033 add
         l_oldno             LIKE oqt_file.oqt01,    #CHI-A60033 add
         l_newdate           LIKE oqt_file.oqt02,    #CHI-A60033 add
         li_result           LIKE type_file.num5                  #No.FUN-550070        #No.FUN-680137 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF #CHI-A60033 add
   #IF cl_null(g_oqt.oqt01) THEN RETURN END IF #CHI-A60033 mark
    IF g_oqt.oqt01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF #CHI-A60033
   #CHI-A60033 mark --start-- 
   #LET b_oqt.* = g_oqt.*            #Backup
   # LET g_oqt01_t = g_oqt.oqt01
   # LET b_oqt.oqt01 = null
   #CHI-A60033 mark --end-
   #CHI-A60033 add --start--
    LET l_newno   = NULL
    LET l_newdate = NULL
   #CHI-A60033 add --end--
 
   # BEGIN WORK #CHI-A60033 mark
    LET g_before_input_done = FALSE   #FUN-580028
    CALL t360_set_entry('a')          #FUN-580028
    LET g_before_input_done = TRUE    #FUN-580028
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   #INPUT BY NAME b_oqt.oqt01 WITHOUT DEFAULTS #CHI-A60033 mark
    INPUT l_newno,l_newdate FROM oqt01,oqt02   #CHI-A60033
       BEFORE INPUT
           CALL cl_set_docno_format("oqt01")          #No.FUN-550070
 
       AFTER FIELD oqt01
           IF NOT cl_null(g_oqt.oqt01) THEN
#             CALL s_check_no(g_sys,b_oqt.oqt01,"","10","oqt_file","oqt01","")
             #CHI-A60033 mod --start--
             # CALL s_check_no("axm",b_oqt.oqt01,"","10","oqt_file","oqt01","")   #No.FUN-A40041
             #   RETURNING li_result,b_oqt.oqt01
             #DISPLAY BY NAME b_oqt.oqt01 
              CALL s_check_no("axm",l_newno,"","10","oqt_file","oqt01","")
                RETURNING li_result,l_newno
              DISPLAY l_newno to oqt01
             #CHI-A60033 mod --end--
              IF (NOT li_result) THEN
                  NEXT FIELD oqt01
              END IF
           END IF #CHI-A60033 add
 
       #CHI-A60033 add --start--
       AFTER FIELD oqt02
             IF cl_null(l_newdate) THEN NEXT FIELD oqt02 END IF
             BEGIN WORK 
       #CHI-A60033 add --end--
 
#             CALL s_auto_assign_no(g_sys,b_oqt.oqt01,g_today,"10","oqt_file","oqt01","","","")      #MOD-840692
             #CHI-A60033 mod --start--
             #CALL s_auto_assign_no("axm",b_oqt.oqt01,g_today,"10","oqt_file","oqt01","","","")      #MOD-840692   #No.FUN-A40041
             #  RETURNING li_result,b_oqt.oqt01
              CALL s_auto_assign_no("axm",l_newno,l_newdate,"10","oqt_file","oqt01","","","")
                RETURNING li_result,l_newno
             #CHI-A60033 mod --end--
              IF (NOT li_result) THEN
                  NEXT FIELD oqt01
              END IF
             #DISPLAY BY NAME b_oqt.oqt01   #CHI-A60033 mark
              DISPLAY l_newno to oqt01  #CHI-A60033
              #LET l_oayslip=s_get_doc_no(b_oqt.oqt01) #CHI-A60033 mark
               LET l_oayslip=s_get_doc_no(l_newno)     #CHI-A60033
               SELECT oayapr INTO l_oayapr FROM oay_file
                 WHERE oayslip = l_oayslip
       #CHI-A60033 mark --start--
       #       SELECT COUNT(*) INTO l_n FROM oqt_file
       #        WHERE oqt01 = b_oqt.oqt01
       #       IF l_n > 0 THEN        #重複
       #          CALL cl_err('',-239,0)
       #          NEXT FIELD oqt01
       #       END IF
       #   END IF
       #CHI-A60033 mark --end--
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(oqt01) #查詢單別
#CHI-A60033 mark--start--
#                   LET l_oayslip=s_get_doc_no(g_oqt.oqt01)   #No.FUN-550070
#                   CALL q_oay(FALSE,TRUE,l_oayslip,'10','AXM') RETURNING l_oayslip    #TQC-670008
#                   LET b_oqt.oqt01 = l_oayslip               #No.FUN-550070
#                   DISPLAY BY NAME b_oqt.oqt01
#                   NEXT FIELD oqt01
#CHI-A60033 mark --end--
                  #CHI-A60033 add --start--
                   LET l_oayslip=s_get_doc_no(l_newno)
                   CALL q_oay(FALSE,TRUE,l_oayslip,'10','AXM') RETURNING l_oayslip
                   LET l_newno = l_oayslip
                   DISPLAY l_newno TO oqt01
                   NEXT FIELD oqt01
                  #CHI-A60033 add --end--
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
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       ROLLBACK WORK
       DISPLAY BY NAME g_oqt.oqt01  #CHI-A60033 add
       #LET g_oqt.oqt01 = g_oqt01_t  #TQC-790009 #CHI-A60033 mark
       #CALL t360_show()             #TQC-790009 #CHI-A60033 mark
       RETURN
    END IF
 
  #CHI-A60033 mark --start--
  # IF NOT cl_sure(0,0) THEN
  #    ROLLBACK WORK
  #    LET g_oqt.oqt01 = g_oqt01_t  #TQC-790009
  #    CALL t360_show()             #TQC-790009
  #    RETURN
  # END IF
  #CHI-A60033 mark --end--
 
  #CHI-A60033 mod --start--
    DROP TABLE y
    SELECT * FROM oqt_file         #單頭複製
        WHERE oqt01=g_oqt.oqt01
        INTO TEMP y
 
    DROP TABLE x
    SELECT * FROM oqu_file         #單身複製
        WHERE oqu01=g_oqt.oqt01
        INTO TEMP x

    DROP TABLE z
    SELECT * FROM oqx_file         #報價單費用檔複製
        WHERE oqx01=g_oqt.oqt01
        INTO TEMP z

    DROP TABLE w
    SELECT * FROM oqv_file         #報價單費用檔複製
        WHERE oqv01=g_oqt.oqt01
        INTO TEMP w

    #CHI-A60033 add --start--
    BEGIN WORK 
    LET g_success='Y'
    #CHI-A60033 add --end--

    UPDATE y
        SET oqt01=l_newno,    #新的鍵值  #CHI-A60033 mod b_oqt.oqt01->l_newno
            oqt02=l_newdate,             #CHI-A60033 mod g_todat->l_newdate
            oqtuser=g_user,   #資料所有者
            oqtgrup=g_grup,   #資料所有者所屬群
            oqtmodu=NULL,     #資料修改日期
            oqtdate=g_today,  #資料建立日期
            oqtacti='Y',      #有效資料
            oqtconf='N',       #有效資料
            oqt22=l_oayapr,    #是否簽核    #FUN-550022
            oqt21='0'          #狀態為開立  #FUN-550022
 
    INSERT INTO oqt_file
        SELECT * FROM y
    #CHI-A60033 add --start--
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","oqt_file","","",SQLCA.sqlcode,"","",1)
        LET g_success='N' 
        ROLLBACK WORK 
        RETURN
    ELSE
       COMMIT WORK 
    END IF
    #CHI-A60033 add --end--
 
#CHI-A60033 mark --start--
#    IF SQLCA.sqlcode THEN
#        CALL cl_err3("sel","oqu_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660167
#        RETURN
#    END IF
#CHI-A60033 mark --end--
 
#CHI-A60033 mark --start--
#    IF SQLCA.sqlcode THEN
#        CALL cl_err3("sel","oqx_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660167
#        RETURN
#    END IF
#CHI-A60033 mark --end--
 
    IF g_success='Y' THEN #CHI-A60033 add
       UPDATE z  SET oqx01=l_newno #CHI-A60033 mod b_oqt.oqt01->l_newno
 
       INSERT INTO oqx_file
           SELECT * FROM z
       IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","oqx_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-660167
           #RETURN #CHI-A60033 mark
           LET g_success='N' #CHI-A60033 add
       END IF
    END IF  #CHI-A60033 add
 
#CHI-A60033 mark --start--
#    IF SQLCA.sqlcode THEN
#        CALL cl_err3("sel","oqv_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660167
#        RETURN
#    END IF
#CHI-A60033 mark --end--
 
    IF g_success='Y' THEN #CHI-A60033 add
       UPDATE w  SET oqv01=l_newno #CHI-A60033 mod b_oqt.oqt01->l_newno
 
       INSERT INTO oqv_file
           SELECT * FROM w
       IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","oqv_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-660167
           #RETURN #CHI-A60033 mark
           LET g_success='N'#CHI-A60033 add
       END IF
    END IF #CHI-A60033 add
 
    IF g_success='Y' THEN #CHI-A60033 add
       UPDATE x  SET oqu01=l_newno #CHI-A60033 mod b_oqt.oqt01->l_newno
 
       INSERT INTO oqu_file
           SELECT * FROM x
       IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","oqu_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-660167
           #RETURN #CHI-A60033 mark
           LET g_success='N' #CHI-A60033 add
       #CHI-A60033 add --start--
       ELSE
           LET g_cnt=SQLCA.SQLERRD[3]
           MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
       #CHI-A60033 add --end-- 
       END IF
    END IF  #CHI-A60033 add
  #CHI-A60033 mod --end--
 
   #CHI-A60033 add --start
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET l_oldno = g_oqt.oqt01
      SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01 = l_newno
      SELECT oqt01 INTO g_oqt.oqt01 FROM oqt_file WHERE oqt01 = l_newno
      CALL t360_u()
      CALL t360_b()
   ELSE
       ROLLBACK WORK
   END IF

   #SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01 = l_oldno          #FUN-C80046
   #SELECT oqt01 INTO g_oqt.oqt01 FROM oqt_file WHERE oqt01 = l_oldno  #FUN-C80046
   #CHI-A60033 add --end--
 
   # LET g_oqt.oqt01 = g_oqt01_t #CHI-A60033 mark
    CALL t360_show()
 
END FUNCTION
 
FUNCTION t360_a()
DEFINE li_result LIKE type_file.num5     #No.FUN-550070        #No.FUN-680137 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_oqu.clear()
    INITIALIZE g_oqt.* TO NULL
    LET g_oqt01_t = NULL
    LET g_oqt_o.* = g_oqt.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_oqt.oqtuser=g_user
        LET g_oqt.oqtoriu = g_user #FUN-980030
        LET g_oqt.oqtorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_oqt.oqtgrup=g_grup
        LET g_oqt.oqtdate=g_today
        LET g_oqt.oqtacti='Y'
        LET g_oqt.oqtconf='N'
        LET g_oqt.oqt12='N'
        LET g_oqt.oqt21='0'
        LET g_oqt.oqt02=g_today
        LET g_oqt.oqtplant = g_plant 
        LET g_oqt.oqtlegal = g_legal  
        CALL t360_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_oqt.oqt01 IS NULL THEN   #No.FUN-590038
           CONTINUE WHILE
        END IF
 
        BEGIN WORK   #No:7829
#       CALL s_auto_assign_no(g_sys,g_oqt.oqt01,g_oqt.oqt02,"10","oqt_file","oqt01","","","")
        CALL s_auto_assign_no("axm",g_oqt.oqt01,g_oqt.oqt02,"10","oqt_file","oqt01","","","")  #No.FUN-A40041
          RETURNING li_result,g_oqt.oqt01
        IF (NOT li_result) THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_oqt.oqt01
        INSERT INTO oqt_file VALUES (g_oqt.*)
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL cl_err3("ins","oqt_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660167
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_oqt.oqt01,'I')
 
        SELECT oqt01 INTO g_oqt.oqt01 FROM oqt_file WHERE oqt01 = g_oqt.oqt01
        LET g_oqt01_t = g_oqt.oqt01        #保留舊值
        LET g_oqt_t.* = g_oqt.*
 
        CALL g_oqu.clear()
        LET g_rec_b = 0
 
        CALL t360_b()                   #輸入單身
        IF g_oay.oayconf='Y' AND g_oay.oayapr <> 'Y'     #確認  #FUN-640248
        THEN
            LET g_action_choice = "insert"      #FUN-640248
 
                CALL t360_y_chk()          #CALL 原確認的 check 段
                IF g_success = "Y" THEN
                   CALL t360_y_upd()       #CALL 原確認的 update 段
                END IF
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t360_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01 = g_oqt.oqt01
    IF g_oqt.oqt01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_oqt.oqtconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_oqt.oqtconf = 'X' THEN CALL cl_err(g_oqt.oqt01,'9024',0) RETURN END IF
    IF g_oqt.oqt21 matches '[Ss]' THEN          #FUN-550022
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_oqt01_t = g_oqt.oqt01
    LET g_oqt_o.* = g_oqt.*
 
    BEGIN WORK
 
    OPEN t360_cl USING g_oqt.oqt01
    IF STATUS THEN
       CALL cl_err("OPEN t360_cl:", STATUS, 1)
       CLOSE t360_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t360_cl INTO g_oqt.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t360_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t360_show()
 
    WHILE TRUE
        LET g_oqt.oqtmodu=g_user
        LET g_oqt.oqtdate=g_today
        CALL t360_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_oqt.*=g_oqt_t.*
            CALL t360_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_oqt.oqt21 = '0'        #FUN-550022
        UPDATE oqt_file SET * = g_oqt.* WHERE oqt01 = g_oqt.oqt01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","oqt_file",g_oqt_t.oqt01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660167
            CONTINUE WHILE
        END IF
        IF g_oqt.oqt01 != g_oqt_t.oqt01 THEN
           UPDATE oqu_file SET oqu01 = g_oqt.oqt01 WHERE oqu01 = g_oqt_t.oqt01
           IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","oqu_file",g_oqt_t.oqt01,"",SQLCA.sqlcode,"","",1)  
               CONTINUE WHILE
           END IF
           UPDATE oqx_file SET oqx01 = g_oqt.oqt01 WHERE oqx01 = g_oqt_t.oqt01
           IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","oqx_file",g_oqt_t.oqt01,"",SQLCA.sqlcode,"","",1)  
               CONTINUE WHILE
           END IF
           UPDATE oqv_file SET oqv01 = g_oqt.oqt01 WHERE oqv01 = g_oqt_t.oqt01
           IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","oqv_file",g_oqt_t.oqt01,"",SQLCA.sqlcode,"","",1)  
               CONTINUE WHILE
           END IF
        END IF
        EXIT WHILE
    END WHILE
    DISPLAY BY NAME g_oqt.oqt21
    IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
    COMMIT WORK
    CALL cl_flow_notify(g_oqt.oqt01,'U')
 
 
    CLOSE t360_cl
 
END FUNCTION
 
#處理INPUT
FUNCTION t360_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
         l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
         l_n1            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
         l_oqt           RECORD LIKE oqt_file.*,
         l_occ           RECORD LIKE occ_file.*,
         li_result       LIKE type_file.num5                #No.FUN-550070        #No.FUN-680137 SMALLINT
  DEFINE l_cnt           LIKE type_file.num5                #MOD-640459        #No.FUN-680137 SMALLINT
  DEFINE l_oqa05         LIKE oqa_file.oqa05,  #FUN-650160
         l_oqa06         LIKE oqa_file.oqa06,  #FUN-650160
         l_oqa07         LIKE oqa_file.oqa07,  #FUN-650160
         l_oqa08         LIKE oqa_file.oqa08   #FUN-650160
  DEFINE l_cnt1          LIKE type_file.num5     #FUN-890011
  DEFINE g_ofd           RECORD LIKE ofd_file.*  #FUN-890011         
  DEFINE l_gen02         LIKE gen_file.gen02  #TQC-9B0113 add
  DEFINE l_oac02         LIKE oac_file.oac02   #NO.FUN-A80056
  DEFINE l_oac02_1       LIKE oac_file.oac02   #NO.FUN-A80056
  DEFINE l_oag02         LIKE oag_file.oag02   #NO.FUN-A80056
  DEFINE l_oeb37         LIKE oeb_file.oeb37   #MOD-D30252 add
  
    DISPLAY BY NAME g_oqt.oqt01,g_oqt.oqt02 ,g_oqt.oqt23,g_oqt.oqt04 , #FUN-650160
                    g_oqt.oqt041,g_oqt.oqt03, g_oqt.oqt07 ,g_oqt.oqt06,
                    g_oqt.oqt09 ,g_oqt.oqt10, g_oqt.oqt11,
                    g_oqt.oqt08 ,g_oqt.oqt12 ,g_oqt.oqt22 ,
                    g_oqt.oqtconf,g_oqt.oqt21
                   ,g_oqt.oqtuser,g_oqt.oqtgrup,g_oqt.oqtmodu,g_oqt.oqtdate,g_oqt.oqtacti  #FUN-580113  #No.TQC-930107 conf-->acti
 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_oqt.oqtoriu,g_oqt.oqtorig,g_oqt.oqt01,g_oqt.oqt02 ,g_oqt.oqt23,g_oqt.oqt04 ,g_oqt.oqt041, #FUN-650160
                  g_oqt.oqt03, g_oqt.oqt07 ,g_oqt.oqt06,
                  #g_oqt.oqt09 ,g_oqt.oqt10, g_oqt.oqt11,g_oqt.oqt08 ,  #NO.FUN-A80056
                  g_oqt.oqt09,g_oqt.oqt24,g_oqt.oqt10,g_oqt.oqt25,g_oqt.oqt11,g_oqt.oqt26,g_oqt.oqt27,  #NO.FUN-A80056
                  g_oqt.oqt12 ,g_oqt.oqt22 ,
                  g_oqt.oqtconf,g_oqt.oqt21,
                  g_oqt.oqtud01,g_oqt.oqtud02,g_oqt.oqtud03,g_oqt.oqtud04,
                  g_oqt.oqtud05,g_oqt.oqtud06,g_oqt.oqtud07,g_oqt.oqtud08,
                  g_oqt.oqtud09,g_oqt.oqtud10,g_oqt.oqtud11,g_oqt.oqtud12,
                  g_oqt.oqtud13,g_oqt.oqtud14,g_oqt.oqtud15,
                  g_oqt.oqtuser,g_oqt.oqtgrup,g_oqt.oqtdate,g_oqt.oqtacti #Add No:TQC-B20144
          WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t360_set_entry(p_cmd)
           CALL t360_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("oqt01")    #No.FUN-550070
 
        AFTER FIELD oqt01
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_oqt.oqt01 != g_oqt01_t) THEN
           IF NOT cl_null(g_oqt.oqt01) THEN
#             CALL s_check_no(g_sys,g_oqt.oqt01,g_oqt_t.oqt01,"10","oqt_file","oqt01","")
             #CALL s_check_no("axm",g_oqt.oqt01,g_oqt_t.oqt01,"10","oqt_file","oqt01","")   #No.FUN-A40041
              CALL s_check_no("axm",g_oqt.oqt01,g_oqt01_t,"10","oqt_file","oqt01","")   #No.FUN-A40041  #FUN-B50026 mod
                 RETURNING li_result,g_oqt.oqt01
              DISPLAY BY NAME g_oqt.oqt01
              IF (NOT li_result) THEN
          	    NEXT FIELD oqt01
              END IF
              LET g_t1 = s_get_doc_no(g_oqt.oqt01)         #No.FUN-550070
              SELECT oayapr INTO g_oay.oayapr FROM oay_file
              WHERE oayslip = g_t1
              IF cl_null(g_oqt_t.oqt01) OR (g_oqt.oqt01 != g_oqt_t.oqt01) THEN
                 LET g_oqt.oqt22 = g_oay.oayapr
                 DISPLAY g_oqt.oqt22 TO oqt22
              END IF
           END IF
           END IF
        AFTER FIELD oqt23
           IF NOT cl_null(g_oqt.oqt23) THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM oqa_file
                                        WHERE oqa01=g_oqt.oqt23
                                          AND oqaconf='Y'
                                          AND oqaacti='Y'
              IF l_cnt=0 THEN
                 CALL cl_err('chk oqt23',100,1)
                 LET g_oqt.oqt23=g_oqt_t.oqt23
                 DISPLAY BY NAME g_oqt.oqt23
                 NEXT FIELD oqt23
              END IF
              LET l_cnt=0
              IF cl_null(g_oqt.oqt04) OR g_oqt.oqt23 != g_oqt_t.oqt23 THEN  #MOD-D50112
                 SELECT oqa05,oqa06,oqa07,oqa08 INTO 
                       l_oqa05,l_oqa06,l_oqa07,l_oqa08 FROM oqa_file
                                              WHERE oqa01=g_oqt.oqt23
                 IF cl_null(g_oqt.oqt04) OR g_oqt.oqt04 != l_oqa06 THEN #客戶編號 MOD-D50112
                    LET g_oqt.oqt04=l_oqa06
                    DISPLAY BY NAME g_oqt.oqt04
                    #MOD-9B0113---Begin
                    CALL t360_oqt23(p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_oqt.oqt04,g_errno,0)
                       NEXT FIELD oqt04
                    END IF
                    #MOD-9B0113---End     
                 END IF
 
                 IF cl_null(g_oqt.oqt06) OR g_oqt.oqt06 != l_oqa05  THEN #部門 #MOD-D50112
                    LET g_oqt.oqt06=l_oqa05
                    DISPLAY BY NAME g_oqt.oqt06
                    CALL t360_oqt06()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_oqt.oqt06,g_errno,0)
                       NEXT FIELD oqt06
                    END IF
                 END IF
 
                 IF cl_null(g_oqt.oqt07) OR g_oqt.oqt07!=l_oqa07 THEN #業務員MOD-D50112
                    LET g_oqt.oqt07=l_oqa07
                    DISPLAY BY NAME g_oqt.oqt07
                    CALL t360_oqt07(p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_oqt.oqt07,g_errno,0)
                       NEXT FIELD oqt07
                    END IF
                 END IF
 
                 IF cl_null(g_oqt.oqt09) OR g_oqt.oqt09!=l_oqa08  THEN #幣別 #MOD-D50112
                    LET g_oqt.oqt09=l_oqa08
                    CALL t360_oqt09()
                    DISPLAY BY NAME g_oqt.oqt09
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_oqt.oqt09,g_errno,0)
                       NEXT FIELD oqt09
                    END IF
                 END IF
                 NEXT FIELD oqt04
              END IF
           END IF
        
        AFTER FIELD oqt04
           IF NOT cl_null(g_oqt.oqt04) THEN
              SELECT COUNT(*) INTO l_n FROM occ_file
               WHERE occ01 = g_oqt.oqt04
              SELECT COUNT(*) INTO l_cnt1 FROM ofd_file                         #FUN-890011 Add
               WHERE ofd01 = g_oqt.oqt04                                        #FUN-890011 Add
              IF l_n = 0 AND l_cnt1 = 0 AND g_oqt.oqt04[1,4] !='MISC' THEN      #FUN-890011 Add               
                 NEXT FIELD oqt04 END IF
              IF l_n <> 0 THEN                                                  #FUN-890011 Add                 
              IF g_oqt.oqt04[1,4] != 'MISC' THEN
#                IF p_cmd='a' OR (g_oqt_t.oqt04 != g_oqt.oqt04 ) THEN                            #MOD-B60217 mark
                 IF p_cmd='a' OR (g_oqt_t.oqt04 != g_oqt.oqt04 ) OR cl_null(g_oqt_t.oqt04) THEN  #MOD-B60217
                    SELECT * INTO g_occ.* FROM occ_file
                     WHERE occ01 = g_oqt.oqt04
                    LET g_oqt.oqt041 = g_occ.occ18
                    LET g_oqt.oqt051 = g_occ.occ241
                    LET g_oqt.oqt052 = g_occ.occ242
                    LET g_oqt.oqt053 = g_occ.occ243
                    IF cl_null(g_oqt.oqt07) OR cl_null(g_oqt.oqt23) THEN #MOD-D50112
                       LET g_oqt.oqt07  = g_occ.occ04                  #MOD-850138
                    END IF #MOD-D50112
                    #-----MOD-AC0088---------
                    #LET g_oqt.oqt08  = g_occ.occ49
                    LET g_oqt.oqt08 = NULL
                    SELECT oac02 INTO g_oqt.oqt08 FROM oac_file
                     WHERE oac01 = g_occ.occ49
                    #-----END MOD-AC0088-----
                    #NO.FUN-A80056--begin              
                    LET g_oqt.oqt24  = g_occ.occ41                  
                    LET g_oqt.oqt25  = g_occ.occ45                  
                    LET g_oqt.oqt26  = g_occ.occ48                  
                    LET g_oqt.oqt27  = g_occ.occ49                  
                    CALL t360_oqt24('d')                            
                    SELECT oag02 INTO l_oag02 FROM oag_file 
                     WHERE oag01=g_oqt.oqt25
                    CALL t360_oac(g_oqt.oqt26) RETURNING l_oac02       
                    CALL t360_oac(g_oqt.oqt27) RETURNING l_oac02_1   
                    #NO.FUN-A80056--end  
                    IF cl_null(g_oqt.oqt23)  THEN       #No.TQC-7A0056
                       LET g_oqt.oqt09  = g_occ.occ42   #No.TQC-7A0056
                    END IF                              #No.TQC-7A0056
                     LET g_oqt.oqt10  = g_occ.occ44  #No.MOD-480553
                    LET g_oqt.oqt11  = g_occ.occ47
                 END IF
                 DISPLAY g_oqt.oqt041 TO oqt041
                 DISPLAY g_oqt.oqt051 TO oqt051
                 DISPLAY g_oqt.oqt052 TO oqt052
                 DISPLAY g_oqt.oqt053 TO oqt053
                 DISPLAY g_oqt.oqt07 TO oqt07   #MOD-850138
                 DISPLAY g_oqt.oqt08 TO oqt08
                 DISPLAY g_oqt.oqt09 TO oqt09
                 DISPLAY g_oqt.oqt10 TO oqt10
                 DISPLAY g_oqt.oqt11 TO oqt11
                 DISPLAY g_oqt.oqt24 TO oqt24   #NO.FUN-A80056
                 DISPLAY g_oqt.oqt25 TO oqt25   #NO.FUN-A80056
                 DISPLAY g_oqt.oqt26 TO oqt26   #NO.FUN-A80056
                 DISPLAY g_oqt.oqt27 TO oqt27   #NO.FUN-A80056
                 DISPLAY l_oac02 TO oac02       #NO.FUN-A80056
                 DISPLAY l_oac02_1 TO oac02_1   #NO.FUN-A80056
                 DISPLAY l_oag02 TO oag02       #NO.FUN-A80056
              END IF
              ELSE
                IF g_oqt.oqt04[1,4] != 'MISC' THEN
#                  IF p_cmd='a' OR (g_oqt_t.oqt04 != g_oqt.oqt04 ) THEN                            #MOD-B60217 mark
                   IF p_cmd='a' OR (g_oqt_t.oqt04 != g_oqt.oqt04 ) OR cl_null(g_oqt_t.oqt04) THEN  #MOD-B60217
                      SELECT * INTO g_ofd.* FROM ofd_file
                       WHERE ofd01 = g_oqt.oqt04
                      LET g_oqt.oqt041 = g_ofd.ofd17
                      LET g_oqt.oqt051 = g_ofd.ofd18
                      LET g_oqt.oqt052 = g_ofd.ofd19
                      LET g_oqt.oqt053 = g_ofd.ofd20
                      IF cl_null(g_oqt.oqt07) AND NOT cl_null(g_oqt.oqt23) THEN #MOD-9B0113 add
                         LET g_oqt.oqt07  = g_ofd.ofd23
                      END IF   #MOD-9B0113 add
                      LET g_oqt.oqt08  = ''   
                      IF cl_null(g_oqt.oqt09) AND NOT cl_null(g_oqt.oqt23) THEN #MOD-9B0113 add   
                         LET g_oqt.oqt09  = ''
                      END IF   #MOD-9B0113 add                              
                      LET g_oqt.oqt10  = ''  
                      LET g_oqt.oqt11  = ''                         
                   END IF                   	               
                   DISPLAY g_oqt.oqt041 TO oqt041
                   DISPLAY g_oqt.oqt051 TO oqt051
                   DISPLAY g_oqt.oqt052 TO oqt052
                   DISPLAY g_oqt.oqt053 TO oqt053
                   DISPLAY g_oqt.oqt07 TO oqt07   
                   DISPLAY g_oqt.oqt08 TO oqt08
                   DISPLAY g_oqt.oqt09 TO oqt09
                   DISPLAY g_oqt.oqt10 TO oqt10
                   DISPLAY g_oqt.oqt11 TO oqt11
                END IF                   
           END IF 
        END IF
    
        #MOD-B30194 add ---begin---
        ON CHANGE oqt04
           IF cl_null(g_oqt.oqt04) THEN
              LET g_oqt.oqt041 = ''
              DISPLAY g_oqt.oqt041 TO oqt041
           END IF
        #MOD-B30194 add ----end----
         
        #MOD-B30194 add ---begin---
        ON CHANGE oqt06
           IF cl_null(g_oqt.oqt06) THEN
              DISPLAY '' TO FORMONLY.gem02
           END IF
        #MOD-B30194 add ----end----
 
        AFTER FIELD oqt06
           IF NOT cl_null(g_oqt.oqt06) THEN
              CALL t360_oqt06()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_oqt.oqt06,g_errno,0)
                 NEXT FIELD oqt06
              END IF
           END IF
 
        BEFORE FIELD oqt07
           IF cl_null(g_oqt.oqt07) THEN
              IF NOT cl_null(g_oqt.oqt23) THEN
                 SELECT oqa07 INTO g_oqt.oqt07
                   FROM oqa_file
                  WHERE oqa01=g_oqt.oqt23
              END IF
              IF cl_null(g_oqt.oqt07) THEN
                 SELECT occ04 INTO g_oqt.oqt07 FROM occ_file
                   WHERE occ01=g_oqt.oqt04
              END IF  # MOD-9B0113 add
              IF cl_null(g_oqt.oqt07) THEN
                 LET g_oqt.oqt07 = g_user
              END IF
           END IF
           DISPLAY g_oqt.oqt07 TO oqt07
           IF NOT cl_null(g_oqt.oqt07) THEN
              LET l_gen02=''
              SELECT gen02 INTO l_gen02 FROM gen_file
               WHERE gen01=g_oqt.oqt07
              DISPLAY l_gen02 TO FORMONLY.gen02
           END IF
        #MOD-B30194 add ---begin---
        ON CHANGE oqt07
           IF cl_null(g_oqt.oqt07) THEN
              LET l_gen02=''
              DISPLAY l_gen02 TO FORMONLY.gen02
           END IF
        #MOD-B30194 add ----end----
 
        AFTER FIELD oqt07
           IF NOT cl_null(g_oqt.oqt07) THEN
              CALL t360_oqt07(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_oqt.oqt07,g_errno,0)
                 NEXT FIELD oqt07
              END IF
           END IF
        #NO.FUN-A80056--begin
        #BEFORE FIELD oqt08
        #   IF NOT cl_null(g_oqt.oqt04) THEN
        #      CALL t360_s(p_cmd)
        #   END IF #地址輸入
        #NO.FUN-A80056--end
        
        AFTER FIELD oqt09
           IF NOT cl_null(g_oqt.oqt09) THEN
              CALL t360_oqt09()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_oqt.oqt09,g_errno,0)
                 NEXT FIELD oqt09
              END IF
              LET g_oqt_o.oqt09 = g_oqt.oqt09 #MOD-D30252 add
           END IF
         
        #MOD-B30194 add ---begin---
        ON CHANGE oqt24
           IF cl_null(g_oqt.oqt24) THEN
              DISPLAY '' TO FORMONLY.gec04
           END IF
        #MOD-B30194 add ----end----   

#NO.FUN-A80056--begin
        AFTER FIELD oqt24
           IF NOT cl_null(g_oqt.oqt24) THEN
              CALL t360_oqt24('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_oqt.oqt24,g_errno,0)
                 NEXT FIELD oqt24
              END IF
           END IF
#NO.FUN-A80056--end           
    
        #MOD-B30194 add ---begin---
        ON CHANGE oqt10
           IF cl_null(g_oqt.oqt10) THEN
              DISPLAY '' TO FORMONLY.oah02
           END IF
        #MOD-B30194 add ----end----

        AFTER FIELD oqt10
           IF NOT cl_null(g_oqt.oqt10) THEN
              LET g_buf = NULL      #No.TQC-730079 add
              SELECT oah02 INTO g_buf FROM oah_file
               WHERE oah01=g_oqt.oqt10
              IF STATUS THEN
                 CALL cl_err('select oah',STATUS,0)
                 NEXT FIELD oqt10
              END IF
              DISPLAY g_buf TO oah02
           END IF

        #MOD-B30194 add ---begin---
        ON CHANGE oqt25
           IF cl_null(g_oqt.oqt25) THEN
              LET l_oag02=''
              DISPLAY l_oag02 TO FORMONLY.oag02
           END IF
        #MOD-B30194 add ----end----

#NO.FUN-A80056--begin
        AFTER FIELD oqt25
           IF NOT cl_null(g_oqt.oqt25) THEN
              LET g_buf = NULL     
              SELECT oag02 INTO g_buf FROM oag_file
               WHERE oag01=g_oqt.oqt25
              IF STATUS THEN
                 CALL cl_err('select oag',STATUS,0)
                 NEXT FIELD oqt25
              END IF
              DISPLAY g_buf TO oag02
           END IF
#NO.FUN-A80056--end           
   
        #MOD-B30194 add ---begin---
        ON CHANGE oqt26
           IF cl_null(g_oqt.oqt26) THEN
              LET l_oac02=''
              DISPLAY l_oac02 TO FORMONLY.oac02
           END IF
        #MOD-B30194 add ----end----

        #MOD-B30194 add ---begin---
        ON CHANGE oqt27
           IF cl_null(g_oqt.oqt27) THEN
              LET l_oac02_1=''
              DISPLAY l_oac02_1 TO FORMONLY.oac02_1
           END IF
        #MOD-B30194 add ----end----
 
        #MOD-B30194 add ---begin---
        ON CHANGE oqt11
           IF cl_null(g_oqt.oqt11) THEN
              DISPLAY '' TO FORMONLY.ged02
           END IF
        #MOD-B30194 add ----end----

        AFTER FIELD oqt11
           IF NOT cl_null(g_oqt.oqt11) THEN
              SELECT COUNT(*) INTO g_cnt FROM ged_file
               WHERE ged01=g_oqt.oqt11
              IF g_cnt =0 THEN
                 CALL cl_err('','axm-309',0) NEXT FIELD oqt11
              END IF
              LET g_buf = NULL      #No.TQC-730079 add
              SELECT ged02 INTO g_buf FROM ged_file
               WHERE ged01=g_oqt.oqt11
              IF STATUS THEN
                 CALL cl_err3("sel","ged_file",g_oqt.oqt01,"",STATUS,"","select ged",1)   #No.FUN-660167
                 NEXT FIELD oqt11
              END IF
              DISPLAY g_buf TO ged02
           END IF
#NO.FUN-A80056--begin
        AFTER FIELD oqt26
           IF NOT cl_null(g_oqt.oqt26) THEN
              CALL t360_oac(g_oqt.oqt26) RETURNING l_oac02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_oqt.oqt26,g_errno,0)
                 NEXT FIELD oqt26
              ELSE 
              	 DISPLAY l_oac02 TO oac02  
              END IF
           END IF
        AFTER FIELD oqt27
           IF NOT cl_null(g_oqt.oqt27) THEN
              CALL t360_oac(g_oqt.oqt27) RETURNING l_oac02_1
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_oqt.oqt27,g_errno,0)
                 NEXT FIELD oqt27
              ELSE 
              	 DISPLAY l_oac02_1 TO oac02_1  
              END IF
           END IF           
#NO.FUN-A80056--end           
        ON CHANGE oqt12
             IF p_cmd = 'u' THEN
                 SELECT COUNT(*) INTO l_cnt
                   FROM oqu_file
                  WHERE oqu01 = g_oqt.oqt01
                 IF l_cnt >= 1 THEN
                     #已有單身資料,不可變更分量計價欄位!
                     CALL cl_err('','axm-364',1)
                     LET g_oqt.oqt12 = g_oqt_t.oqt12
                     DISPLAY BY NAME g_oqt.oqt12
                     NEXT FIELD oqt12
                 END IF
             END IF
 
        AFTER FIELD oqt12
           IF NOT cl_null(g_oqt.oqt12) THEN
              IF g_oqt.oqt12 NOT MATCHES '[YN]' THEN
                 NEXT FIELD oqt12
              END IF
           END IF
 
          AFTER FIELD oqtud01
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud02
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud03
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud04
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud05
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud06
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud07
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud08
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud09
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud10
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud11
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud12
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud13
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud14
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oqtud15
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
         AFTER INPUT
            LET g_oqt.oqtuser = s_get_data_owner("oqt_file") #FUN-C10039
            LET g_oqt.oqtgrup = s_get_data_group("oqt_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            #MOD-D50103 add begin
            IF g_oqt.oqt09 <> g_oqt_t.oqt09 THEN 
               CALL cl_err(g_oqt.oqt09,'axm-190',1)
            END IF 
            #MOD-D50103 add end   
           #MOD-D30252 add start -----
            SELECT COUNT(*) INTO g_cnt FROM oqu_file
             WHERE oqu01=g_oqt.oqt01
            IF g_cnt > 0 THEN
               LET g_success ='Y'
               FOR l_ac = 1 TO g_cnt
                  CALL s_fetch_price_new(g_oqt.oqt04,g_oqu[l_ac].oqu03,'',g_oqu[l_ac].oqu05,g_oqt.oqt02,'6',
                       g_plant,g_oqt.oqt09,g_oqt.oqt10,g_oqt.oqt25,g_oqt.oqt01,g_oqu[l_ac].oqu02,
                       g_oqu[l_ac].oqu06,'',p_cmd)
                       RETURNING g_oqu[l_ac].oqu07,l_oeb37 

                  UPDATE oqu_file SET oqu07 = g_oqu[l_ac].oqu07
                   WHERE oqu01 = g_oqt.oqt01 AND oqu02 = g_oqu[l_ac].oqu02
                  IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err3("upd","oqu_file",g_oqt.oqt01,g_oqu[l_ac].oqu02,STATUS,"","upd oqu:",1)
                     LET g_success ='N'
                     EXIT FOR
                  END IF
               END FOR
            END IF
           #MOD-D30252 add start -----
             CALL t360_oqt06()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_oqt.oqt06,g_errno,0)
                NEXT FIELD oqt06
             END IF
             CALL t360_oqt09()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_oqt.oqt09,g_errno,0)
                NEXT FIELD oqt09
             END IF
             LET g_buf = NULL      #No.TQC-730079 add
             SELECT oah02 INTO g_buf FROM oah_file
              WHERE oah01=g_oqt.oqt10
             IF STATUS THEN
                CALL cl_err3("sel","oah_file",g_oqt.oqt10,"",STATUS,"","select oah",1)     #No.FUN-660167
                NEXT FIELD oqt10
             END IF
             DISPLAY g_buf TO oah02
             SELECT COUNT(*) INTO g_cnt FROM ged_file
              WHERE ged01=g_oqt.oqt11
             IF g_cnt =0 THEN
                CALL cl_err('','axm-309',0) NEXT FIELD oqt11
             END IF
             LET g_buf = NULL      #No.TQC-730079 add
             SELECT ged02 INTO g_buf FROM ged_file
              WHERE ged01=g_oqt.oqt11
             IF STATUS THEN
                CALL cl_err3("sel","ged_file",g_oqt.oqt11,"",STATUS,"","select ged",1)     #No.FUN-660167
                NEXT FIELD oqt11
             END IF
             DISPLAY g_buf TO ged02
 
 
 
        ON ACTION mntn_cutsomer
           CALL cl_cmdrun('axmi221')
   
        ON ACTION controlp
          CASE
             WHEN INFIELD(oqt01) #查詢單別
                   LET l_oayslip=g_oqt.oqt01[1,g_doc_len]
                  CALL q_oay(FALSE,TRUE,l_oayslip,'10','AXM') RETURNING l_oayslip #NO:    #TQC-670008
                  LET g_oqt.oqt01 = l_oayslip            #No.FUN-550070
                  DISPLAY BY NAME g_oqt.oqt01
                  NEXT FIELD oqt01
             WHEN INFIELD(oqt23) #估價單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oqa"
                  CALL cl_create_qry() RETURNING g_oqt.oqt23
                  DISPLAY BY NAME g_oqt.oqt23
                  NEXT FIELD oqt23
             WHEN INFIELD(oqt04) #查詢客戶資料
                  CALL q_occ08(FALSE,TRUE)                                #FUN-890011 Add
                  RETURNING g_oqt.oqt04                                   #FUN-890011 Add                                                           
                  DISPLAY BY NAME g_oqt.oqt04                             #FUN-890011 Add                  
             WHEN INFIELD(oqt06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem"
                  LET g_qryparam.default1 = g_oqt.oqt06
                  CALL cl_create_qry() RETURNING g_oqt.oqt06
                  DISPLAY BY NAME g_oqt.oqt06
                  CALL t360_oqt06()
                  NEXT FIELD oqt06
             WHEN INFIELD(oqt07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gen"
                  LET g_qryparam.default1 = g_oqt.oqt07
                  CALL cl_create_qry() RETURNING g_oqt.oqt07
                  DISPLAY BY NAME g_oqt.oqt07
                  CALL t360_oqt07(p_cmd)
                  NEXT FIELD oqt07
             WHEN INFIELD(oqt09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = g_oqt.oqt09
                  CALL cl_create_qry() RETURNING g_oqt.oqt09
                  DISPLAY BY NAME g_oqt.oqt09
                  CALL t360_oqt09()
                  NEXT FIELD oqt09
#NO.FUN-A80056--begin
             WHEN INFIELD(oqt24)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gec9"
                  LET g_qryparam.default1 = g_oqt.oqt24
                  CALL cl_create_qry() RETURNING g_oqt.oqt24
                  DISPLAY BY NAME g_oqt.oqt24
                  NEXT FIELD oqt24
#NO.FUN-A80056--end                  
             WHEN INFIELD(oqt10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oah"
                  LET g_qryparam.default1 = g_oqt.oqt10
                  CALL cl_create_qry() RETURNING g_oqt.oqt10
                  DISPLAY BY NAME g_oqt.oqt10
                  NEXT FIELD oqt10
#NO.FUN-A80056--begin
             WHEN INFIELD(oqt25)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oag"
                  LET g_qryparam.default1 = g_oqt.oqt25
                  CALL cl_create_qry() RETURNING g_oqt.oqt25
                  DISPLAY BY NAME g_oqt.oqt25
                  NEXT FIELD oqt25
#NO.FUN-A80056--end                                
             WHEN INFIELD(oqt11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ged"
                  LET g_qryparam.default1 = g_oqt.oqt11
                  CALL cl_create_qry() RETURNING g_oqt.oqt11
                  DISPLAY BY NAME g_oqt.oqt11 NEXT FIELD oqt11
#NO.FUN-A80056--begin
             WHEN INFIELD(oqt26)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oac"
                  LET g_qryparam.default1 = g_oqt.oqt26
                  CALL cl_create_qry() RETURNING g_oqt.oqt26
                  DISPLAY BY NAME g_oqt.oqt26
                  NEXT FIELD oqt26
             WHEN INFIELD(oqt27)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oac"
                  LET g_qryparam.default1 = g_oqt.oqt27
                  CALL cl_create_qry() RETURNING g_oqt.oqt27
                  DISPLAY BY NAME g_oqt.oqt27
                  NEXT FIELD oqt27                  
#NO.FUN-A80056--end                             
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
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
#NO.FUN-A80056--begin
FUNCTION t360_oqt24(p_cmd)
DEFINE   l_gecacti   LIKE gec_file.gecacti
DEFINE   l_gec04     LIKE gec_file.gec04
DEFINE   l_gec07     LIKE gec_file.gec07
DEFINE   p_cmd       LIKE type_file.chr1 

    LET g_errno = ' '
    SELECT gecacti,gec04,gec07 INTO l_gecacti,l_gec04,l_gec07
      FROM gec_file WHERE gec01 = g_oqt.oqt24 AND gec011='2' 
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
         WHEN l_gecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN 
       DISPLAY l_gec04 TO gec04
       DISPLAY l_gec07 TO gec07
    END IF 
END FUNCTION  

FUNCTION t360_oac(p_oac01)
DEFINE   p_oac01     LIKE oac_file.oac01
DEFINE   l_oac02     LIKE oac_file.oac02 

    LET g_errno = ' '
    SELECT oac02 INTO l_oac02 FROM oac_file WHERE oac01 = p_oac01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_oac02 
END FUNCTION 

#NO.FUN-A80056--end

FUNCTION t360_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oqt01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t360_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oqt01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t360_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oqt.* TO NULL               #No.FUN-6A0020
    CALL cl_opmsg('q')
 
    CALL cl_msg("")                              #FUN-640248
 
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t360_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_oqt.* TO NULL
       RETURN
    END IF
    CALL cl_msg(" SEARCHING ! ")                              #FUN-640248
 
    OPEN t360_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_oqt.* TO NULL
    ELSE
       OPEN t360_count
       FETCH t360_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t360_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    CALL cl_msg("")                              #FUN-640248
 
END FUNCTION
 
FUNCTION t360_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t360_cs INTO g_oqt.oqt01
        WHEN 'P' FETCH PREVIOUS t360_cs INTO g_oqt.oqt01
        WHEN 'F' FETCH FIRST    t360_cs INTO g_oqt.oqt01
        WHEN 'L' FETCH LAST     t360_cs INTO g_oqt.oqt01
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump t360_cs INTO g_oqt.oqt01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)
        INITIALIZE g_oqt.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01 = g_oqt.oqt01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","oqt_file","","",STATUS,"","",1)     #No.FUN-660167
        INITIALIZE g_oqt.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_oqt.oqtuser      #FUN-4C0057 add
    LET g_data_group = g_oqt.oqtgrup      #FUN-4C0057 add
    LET g_data_plant = g_oqt.oqtplant #FUN-980030
    CALL t360_show()
END FUNCTION
 
 
FUNCTION t360_show()
DEFINE   l_oac02    LIKE oac_file.oac02   #NO.FUN-A80056
DEFINE   l_oac02_1  LIKE oac_file.oac02   #NO.FUN-A80056
DEFINE   l_oag02    LIKE oag_file.oag02   #NO.FUN-A80056

    LET g_oqt_t.* = g_oqt.*                #保存單頭舊值
    DISPLAY BY NAME g_oqt.oqtoriu,g_oqt.oqtorig, g_oqt.oqt01 ,g_oqt.oqt02 ,g_oqt.oqt23,g_oqt.oqt03 ,g_oqt.oqt04, #FUN-650160
                    g_oqt.oqt041,g_oqt.oqt06 ,g_oqt.oqt07 ,
                    #g_oqt.oqt08,  #NO.FUN-A80056                    
                    g_oqt.oqt09 ,g_oqt.oqt10 ,g_oqt.oqt11 ,g_oqt.oqt12,
                    g_oqt.oqt21 ,g_oqt.oqt22 ,             #No.6686
                    g_oqt.oqt24,g_oqt.oqt25,g_oqt.oqt26,g_oqt.oqt27,  #NO.FUN-A80056
                    g_oqt.oqtuser,g_oqt.oqtgrup,g_oqt.oqtmodu,g_oqt.oqtdate,g_oqt.oqtacti,   #TQC-930107 add acti
                    g_oqt.oqtconf,
                    g_oqt.oqtud01,g_oqt.oqtud02,g_oqt.oqtud03,g_oqt.oqtud04,
                    g_oqt.oqtud05,g_oqt.oqtud06,g_oqt.oqtud07,g_oqt.oqtud08,
                    g_oqt.oqtud09,g_oqt.oqtud10,g_oqt.oqtud11,g_oqt.oqtud12,
                    g_oqt.oqtud13,g_oqt.oqtud14,g_oqt.oqtud15
    IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
    #NO.FUN-A80056--begin
    CALL t360_oqt24('d') 
    CALL t360_oac(g_oqt.oqt26) RETURNING l_oac02 
    CALL t360_oac(g_oqt.oqt27) RETURNING l_oac02_1
    DISPLAY l_oac02 TO oac02
    DISPLAY l_oac02_1 TO oac02_1
    SELECT oag02 INTO l_oag02 FROM oag_file
     WHERE oag01=g_oqt.oqt25    
    DISPLAY l_oag02 TO oag02 
    #NO.FUN-A80056--end
    CALL t360_oqt06()
     CALL t360_oqt07('s')  #MOD-570106
    LET g_buf = NULL      #No.TQC-730079 add
    SELECT oah02 INTO g_buf FROM oah_file WHERE oah01=g_oqt.oqt10
    DISPLAY g_buf TO oah02
    LET g_buf = NULL      #No.TQC-730079 add
    SELECT ged02 INTO g_buf FROM ged_file WHERE ged01=g_oqt.oqt11
    DISPLAY g_buf TO ged02
 
    LET g_buf = NULL
    CALL t360_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t360_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1     # No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01 = g_oqt.oqt01
    IF g_oqt.oqt01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_oqt.oqtconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_oqt.oqtconf = 'X' THEN CALL cl_err(g_oqt.oqt01,'9024',0) RETURN END IF
    IF g_oqt.oqt21 matches '[Ss1]' THEN          #FUN-550022
         CALL cl_err("","mfg3557",0)
         RETURN
    END IF
 
    BEGIN WORK
 
    OPEN t360_cl USING g_oqt.oqt01
    IF STATUS THEN
       CALL cl_err("OPEN t360_cl:", STATUS, 1)
       CLOSE t360_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t360_cl INTO g_oqt.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)
       CLOSE t360_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t360_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "oqt01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_oqt.oqt01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete oqt,oqu!"
       DELETE FROM oqt_file WHERE oqt01 = g_oqt.oqt01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","oqt_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","del oqt",1)     #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM oqu_file WHERE oqu01 = g_oqt.oqt01
       IF STATUS THEN
          CALL cl_err3("del","oqu_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","del oqu",1)     #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM oqx_file WHERE oqx01 = g_oqt.oqt01
       IF STATUS THEN
          CALL cl_err3("del","oqx_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","del oqx",1)     #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM oqv_file WHERE oqv01 = g_oqt.oqt01
       IF STATUS THEN
          CALL cl_err3("del","oqv_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","del oqv",1)     #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM oao_file WHERE oao01 = g_oqt.oqt01
       IF STATUS THEN
          CALL cl_err3("del","oao_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","del oao",1)     #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       CALL g_oqu.clear()
       INITIALIZE g_oqt.* TO NULL
       OPEN t360_count
       FETCH t360_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t360_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t360_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t360_fetch('/')
       END IF
       MESSAGE ""
    END IF
 
    CLOSE t360_cl
    COMMIT WORK
    CALL cl_flow_notify(g_oqt.oqt01,'D')
 
END FUNCTION
 
FUNCTION t360_b()
DEFINE
    l_ima           RECORD LIKE ima_file.*,
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_row,l_col     LIKE type_file.num5,     # No.FUN-680137  SMALLINT    #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_check         LIKE type_file.chr1,     # No.FUN-680137  VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_misc          LIKE gsb_file.gsb05,     # No.FUN-680137  VARCHAR(4)            #
    l_obk03         LIKE obk_file.obk03,
    l_obk07         LIKE obk_file.obk07,
    l_obk08         LIKE obk_file.obk08,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5,                 #可刪除否        #No.FUN-680137 SMALLINT
    l_oqt21         LIKE oqt_file.oqt21,
    l_oeb05_fac     LIKE oeb_file.oeb05_fac   #MOD-B90197 add
DEFINE l_obe           RECORD LIKE obe_file.*,
       l_ima18         LIKE ima_file.ima18,
       l_ima25         LIKE ima_file.ima25,   #MOD-B90197 add
       l_box1          LIKE type_file.num10,    # No.FUN-680137 INTEGER
       l_box2          LIKE type_file.num20_6,  # No.FUN-680137 DEC(20,6)
       l_oqu09         LIKE oqu_file.oqu09,
       l_flag          LIKE type_file.num5,     # No.FUN-680137 SMALLINT
       l_factor        LIKE ima_file.ima31_fac   # No.FUN-680137 DECIMAL(16,8)
DEFINE l_ima31         LIKE ima_file.ima31  #MOD-640112 add
DEFINE l_oeb37         LIKE oeb_file.oeb37  #FUN-AB0082
DEFINE l_tf            LIKE type_file.chr1  #FUN-BB0085
 
    LET g_action_choice = ""
    SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01 = g_oqt.oqt01
    IF g_oqt.oqt01 IS NULL THEN RETURN END IF
    LET l_oqt21 = g_oqt.oqt21          #FUN-550022
    IF g_oqt.oqtconf='Y' THEN CALL cl_err('','axm-101',0) RETURN  END IF
    IF g_oqt.oqtconf = 'X' THEN CALL cl_err(g_oqt.oqt01,'9024',0) RETURN END IF
    IF g_oqt.oqt21 matches '[Ss]' THEN          #FUN-550022
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    CALL cl_opmsg('b')
   IF NOT cl_null(g_oqt.oqt23) THEN  #MOD-720055 add
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM oqu_file WHERE oqu01=g_oqt.oqt01
    IF l_cnt=0 THEN
       IF cl_confirm('axm-365') THEN
          CALL t360_g_b()
       END IF
    END IF
   END IF   #MOD-720055 add 
 
    LET g_forupd_sql = "SELECT * FROM oqu_file ",
                       " WHERE oqu01= ? AND oqu02= ?  FOR UPDATE"   
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t360_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_oqu WITHOUT DEFAULTS FROM s_oqu.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL t360_set_no_required(p_cmd) 
            CALL t360_set_required(p_cmd)    
            CALL t360_set_entry_b(p_cmd)     #MOD-640459 add
            CALL t360_set_no_entry_b(p_cmd)  #MOD-640459 add
            LET g_before_input_done = TRUE
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t360_cl USING g_oqt.oqt01
            IF STATUS THEN
               CALL cl_err("OPEN t360_cl:", STATUS, 1)
               CLOSE t360_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t360_cl INTO g_oqt.*  # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t360_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_oqu_t.* = g_oqu[l_ac].*         #BACKUP
               LET g_oqu05_t = g_oqu[l_ac].oqu05     #FUN-BB0085
               LET g_oqu10_t = g_oqu[l_ac].oqu10     #FUN-BB0085
               OPEN t360_bcl USING g_oqt.oqt01,g_oqu_t.oqu02
               IF STATUS THEN
                  CALL cl_err("OPEN t360_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t360_bcl INTO b_oqu.* #FUN-730018
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock oqu',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t360_b_move_to() #FUN-730018
                  END IF
                  SELECT oqw02 INTO g_oqu[l_ac].oqw02 FROM
                     oqw_file WHERE oqw01 = g_oqu[l_ac].oqu08
                  IF SQLCA.sqlcode THEN
                     LET g_oqu[l_ac].oqw02 = NULL
                  END IF
                  SELECT ima908 INTO g_oqu[l_ac].ima908 FROM
                     ima_file WHERE ima01=g_oqu[l_ac].oqu03
                  IF SQLCA.sqlcode THEN
                     LET g_oqu[l_ac].ima908=NULL
                  END IF
               END IF
               CALL t360_set_entry_b(p_cmd)
               CALL t360_set_no_entry_b(p_cmd)
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_oqu[l_ac].* TO NULL      #900423
            LET g_oqu_t.* = g_oqu[l_ac].*         #新輸入資料
            LET g_oqu05_t = NULL                  #FUN-BB0085  
            LET g_oqu10_t = NULL                  #FUN-BB0085
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oqu02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL t360_b_move_back() #FUN-730018
            INSERT INTO oqu_file VALUES (b_oqu.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","oqu_file",g_oqt.oqt01,g_oqu[l_ac].oqu02,SQLCA.sqlcode,"","ins oqu",1)   #No.FUn-660167
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               LET l_oqt21 = '0'          #FUN-550022
            END IF
 
 
        BEFORE FIELD oqu02               #default 項次
            IF cl_null(g_oqu[l_ac].oqu02) THEN
               SELECT MAX(oqu02)+1 INTO g_oqu[l_ac].oqu02 FROM oqu_file
                 WHERE oqu01 = g_oqt.oqt01
               IF cl_null(g_oqu[l_ac].oqu02) THEN
                  LET g_oqu[l_ac].oqu02 = 1
               END IF
            END IF
 
        AFTER FIELD oqu02               #default 項次
            IF NOT cl_null(g_oqu[l_ac].oqu02) THEN
               IF cl_null(g_oqu_t.oqu02) OR
                  g_oqu_t.oqu02 !=g_oqu[l_ac].oqu02 THEN
                  SELECT COUNT(*) INTO l_cnt FROM oqu_file
                   WHERE oqu01 = g_oqt.oqt01 AND oqu02=g_oqu[l_ac].oqu02
                  IF l_cnt > 0 THEN
                     CALL cl_err('sel oqu','axm-298',0)
                     NEXT FIELD oqu02
                  END IF
               END IF
            END IF
 
        BEFORE FIELD oqu03
            CALL t360_set_entry_b(p_cmd)
 
        AFTER FIELD oqu03
            IF NOT cl_null(g_oqu[l_ac].oqu03) THEN
#CHI-B60080 -- begin --
               IF g_oaz.oaz46='Y' THEN         # 將客戶品號轉為本公司品號
                  LET g_msg=NULL
                  SELECT MIN(obk01) INTO g_msg FROM obk_file
                     WHERE obk03=g_oqu[l_ac].oqu03 AND obk02=g_oqt.oqt04
                     AND obk05=g_oqt.oqt09
                  IF STATUS=0 AND g_msg IS NOT NULL THEN
                     LET g_oqu[l_ac].oqu04 = g_oqu[l_ac].oqu03
                     LET g_oqu[l_ac].oqu03 = g_msg
                  END IF
                  DISPLAY BY NAME g_oqu[l_ac].oqu03,g_oqu[l_ac].oqu04
               END IF
#CHI-B60080 -- end --
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_oqu[l_ac].oqu03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_oqu[l_ac].oqu03= g_oqu_t.oqu03
                  LET g_oqu[l_ac].oqu04 = g_oqu_t.oqu04    #CHI-B60080 add
                  NEXT FIELD oqu03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               IF cl_null(g_oqu_t.oqu03) OR
                  g_oqu[l_ac].oqu03 != g_oqu_t.oqu03 THEN
                  LET l_misc=g_oqu[l_ac].oqu03[1,4]
                  IF g_oqu[l_ac].oqu03[1,4]='MISC' THEN  #NO:6808
                      SELECT COUNT(*) INTO l_n FROM ima_file
                       WHERE ima01=l_misc
                      IF l_n=0 THEN
                         CALL cl_err('','aim-806',0)
                         NEXT FIELD oqu03
                      END IF
                  END IF
                  SELECT COUNT(*) INTO l_n FROM oqu_file
                   WHERE oqu01 = g_oqt.oqt01 AND oqu02 = g_oqu[l_ac].oqu02
                     AND oqu03 = g_oqu[l_ac].oqu03
                  IF l_n > 0 THEN         #重複
                     LET g_oqu[l_ac].oqu03 = g_oqu_t.oqu03
                     CALL cl_err('',-239,0) NEXT FIELD oqu03
                  ELSE                        #NO:6808
                     SELECT ima908 INTO g_oqu[l_ac].ima908 FROM
                        ima_file WHERE ima01=g_oqu[l_ac].oqu03
                     IF SQLCA.sqlcode THEN
                        LET g_oqu[l_ac].ima908=NULL
                     END IF
                     CALL t360_oqu03('a')
                     IF NOT cl_null(g_errno) AND g_oqu[l_ac].oqu03[1,4] != 'MISC' THEN
                        CALL cl_err('',g_errno,0)
                        NEXT FIELD oqu03
                     END IF
                  END IF
               END IF
 
               IF cl_null(g_oqu_t.oqu03) OR
                  ((g_oqu[l_ac].oqu03 != g_oqu_t.oqu03) OR
                   (g_oqt.oqt04 != g_oqt_o.oqt04)) THEN
                   LET l_obk03 = NULL
                   LET l_obk07 = NULL
                   LET l_obk08 = NULL
                  SELECT obk03,obk07,obk08 INTO l_obk03,l_obk07,l_obk08
                    FROM obk_file
                   WHERE obk01=g_oqu[l_ac].oqu03 AND obk02=g_oqt.oqt04
                     AND obk05=g_oqt.oqt09                               #CHI-B60080 add
                  LET g_oqu[l_ac].oqu04 = l_obk03
                  LET g_oqu[l_ac].oqu05 = l_obk07
                  DISPLAY g_oqu[l_ac].oqu04 TO s_oqu[l_ac].oqu04
                  DISPLAY g_oqu[l_ac].oqu05 TO s_oqu[l_ac].oqu05
                  IF g_oqt.oqt12 = 'N' THEN #MOD-640459 add if 判斷 #非分量計價時才預設單價
                      LET g_oqu[l_ac].oqu07 = l_obk08
                      DISPLAY g_oqu[l_ac].oqu07 TO s_oqu[l_ac].oqu07
                  END IF
                 IF cl_null(g_oqu[l_ac].oqu05) THEN
                     SELECT ima31 INTO l_ima31
                       FROM ima_file
                      WHERE ima01 = g_oqu[l_ac].oqu03
                     IF NOT cl_null(l_ima31) THEN
                         LET g_oqu[l_ac].oqu05 = l_ima31
                         DISPLAY BY NAME g_oqu[l_ac].oqu05
                         LET g_oqu[l_ac].oqu06 = s_digqty(g_oqu[l_ac].oqu06,g_oqu[l_ac].oqu05)   #FUN-BB0085
                     END IF
                 END IF
               END IF
              #取單價
               #NO.FUN-A80056--begin
               #IF g_oqt.oqt12 = 'N' THEN #MOD-640459 add if 判斷 #分量計價為'N'才需取單價
               #   IF g_oqu[l_ac].oqu03 != g_oqu_t.oqu03 AND g_oqu[l_ac].oqu06 != 0 THEN
               #      CALL t360_b_get_price()
               #   END IF
               #END IF
               IF cl_null(g_oqt.oqt23) THEN           
                  #MOD-BA0084 add --start--
                  IF g_oqt.oqt12 = 'N' THEN #分量計價為'N'才需取單價 
                     IF g_oqu[l_ac].oqu03 != g_oqu_t.oqu03 AND g_oqu[l_ac].oqu06 != 0 THEN 
                  #MOD-BA0084 add --end--
                        CALL s_fetch_price_new(g_oqt.oqt04,g_oqu[l_ac].oqu03,'',g_oqu[l_ac].oqu05,g_oqt.oqt02,'6',    #FUN-BC0071  #TQC-CA0039 1->6
                             g_plant,g_oqt.oqt09,g_oqt.oqt10,g_oqt.oqt25,g_oqt.oqt01,g_oqu[l_ac].oqu02,
                             g_oqu[l_ac].oqu06,'',p_cmd)
                            #RETURNING g_oqu[l_ac].oqu07         #FUN-AB0082
                             RETURNING g_oqu[l_ac].oqu07,l_oeb37 #FUN-AB0082
                  #MOD-BA0084 add --start--
                     END IF 
                  END IF 
                  #MOD-BA0084 add --end--
               END IF 
               #NO.FUN-A80056--end               
              #end FUN-610043
               CALL t360_set_no_entry_b(p_cmd)
           END IF
 
      #start FUN-610041  帶出材積、淨重、毛重
       AFTER FIELD oqu10
         #CHI-CC0034 mark --start--
         ##包裝方式檔
         #SELECT * INTO l_obe.* FROM obe_file
         # WHERE obe01=g_oqu[l_ac].oqu14
         #IF STATUS THEN
         #   LET g_oqu[l_ac].oqu11=0   #材積
         #   LET g_oqu[l_ac].oqu12=0   #淨重
         #   LET g_oqu[l_ac].oqu13=0   #毛重
         #ELSE
         #   IF cl_null(g_oqu[l_ac].oqu09) OR g_oqu[l_ac].oqu09=0 THEN   #包裝數量
         #      LET l_box1 =1
         #      LET l_oqu09=1
         #   ELSE
         #      LET l_box1=g_oqu[l_ac].oqu09/l_obe.obe24   #整數的箱數
         #      LET l_box2=g_oqu[l_ac].oqu09/l_obe.obe24   #算到小數位的箱數
         #      IF l_box2-l_box1 >0 THEN LET l_box1=l_box1+1 END IF
         #      LET l_oqu09=g_oqu[l_ac].oqu09
         #   END IF
         # 
         #   #-->材積
         #   LET g_oqu[l_ac].oqu11=l_box1*l_obe.obe26
         #
         #   #-->淨重
         #   SELECT ima18 INTO l_ima18 FROM ima_file
         #    WHERE ima01=g_oqu[l_ac].oqu03
         #   IF STATUS THEN LET l_ima18=0 END IF     #-->單位淨重
         #   LET g_oqu[l_ac].oqu12=l_oqu09*l_ima18
         #
         #   #-->毛重=箱數*(外包裝重量+(外包裝裝數*內包裝重量))
         #   LET g_oqu[l_ac].oqu13=l_box1*(l_obe.obe23+(l_obe.obe22*l_obe.obe13))
         #   LET g_oqu[l_ac].oqu13=g_oqu[l_ac].oqu13 + g_oqu[l_ac].oqu12  #MOD-840214 add
         #END IF
         #DISPLAY BY NAME g_oqu[l_ac].oqu11   #MOD-640459 add
         #DISPLAY BY NAME g_oqu[l_ac].oqu12   #MOD-640459 add
         #DISPLAY BY NAME g_oqu[l_ac].oqu13   #MOD-640459 add
         #CHI-CC0034 mark --end--
          #CHI-CC0034 add --start--
          IF NOT t360_chk_obe(l_ac) THEN
                NEXT FIELD oqu10 
          END IF
          #CHI-CC0034 add --end--
          CALL s_umfchk(g_oqu[l_ac].oqu03,g_oqu[l_ac].oqu10,g_oqu[l_ac].oqu05)
               RETURNING l_flag,l_factor
          IF l_flag = 0 AND g_oqt.oqt12 = 'N' THEN #MOD-640459 分量計價為'N' 時,才給數量
             LET g_oqu[l_ac].oqu06 = g_oqu[l_ac].oqu09 * l_factor
             LET g_oqu[l_ac].oqu06 = s_digqty(g_oqu[l_ac].oqu06,g_oqu[l_ac].oqu05)  #FUN-BB0085
             DISPLAY BY NAME g_oqu[l_ac].oqu06     #MOD-640459 add
          END IF
          #FUN-BB0085-add-str--
          IF NOT t360_oqu09_check() THEN
             LET g_oqu10_t = g_oqu[l_ac].oqu10
             NEXT FIELD oqu09
          END IF
          LET g_oqu10_t = g_oqu[l_ac].oqu10
          #FUN-BB0085-add-end--
        AFTER FIELD oqu05
           IF NOT cl_null(g_oqu[l_ac].oqu05) THEN
              SELECT COUNT(*) INTO l_n FROM gfe_file
                WHERE gfe01=g_oqu[l_ac].oqu05
              IF l_n = 0 THEN
                 CALL cl_err('','axm-139',0)
                 NEXT FIELD oqu05
              END IF
              IF g_oqt.oqt12 = 'Y' THEN
                 CALL t360_2(g_oqu[l_ac].oqu02,'n')
                 NEXT FIELD oqu11
              END IF
              #MOD-B90197 --- start ---
              SELECT ima25 INTO l_ima25 FROM ima_file
               WHERE ima01 = g_oqu[l_ac].oqu03
              CALL s_umfchk(g_oqu[l_ac].oqu03,g_oqu[l_ac].oqu05,l_ima25) RETURNING l_check,l_oeb05_fac

              IF l_check = '1' THEN
                 CALL cl_err('','abm-731',0)
                 LET l_oeb05_fac=1
                 NEXT FIELD oqu05
              END IF
              #MOD-B90197 ---  end  ---
              #FUN-BB0085-add-str--
              IF g_oqt.oqt12 = 'Y' THEN                                                  #TQC-C20183
                 LET g_oqu[l_ac].oqu06 = s_digqty(g_oqu[l_ac].oqu06,g_oqu[l_ac].oqu05)   #TQC-C20183
                 DISPLAY BY NAME g_oqu[l_ac].oqu06                                       #TQC-C20183
              ELSE                                                                       #TQC-C20183
                 CALL t360_oqu06_check(p_cmd) RETURNING l_tf,l_oeb37
                 IF NOT l_tf THEN
                    LET g_oqu05_t = g_oqu[l_ac].oqu05
                    NEXT FIELD oqu06 
                 END IF
              END IF                                                                     #TQC-C20183
              LET g_oqu05_t = g_oqu[l_ac].oqu05
              #FUN-BB0085-add-end--            
           END IF
 
        AFTER FIELD oqu06
           #FUN-BB0085-mark-str----
           #IF NOT cl_null(g_oqu[l_ac].oqu06) THEN
           #   IF g_oqu[l_ac].oqu06 < 0 THEN
           #      CALL cl_err(g_oqu[l_ac].oqu06,'afa-043',0)
           #      NEXT FIELD oqu06
           #   END IF
           ##NO.FUN-A80056--begin  
           ##IF g_oqt.oqt12 = 'N' THEN #MOD-640459 add if 判斷 #分量計價為'N'才需取單價
           ##    IF g_oqu[l_ac].oqu07 =0 OR
           ##      (g_oqu[l_ac].oqu06 != g_oqu_t.oqu06 OR cl_null(g_oqu_t.oqu06)) THEN
           ##       CALL t360_b_get_price()
           ##    END IF
           ##END IF
           #IF cl_null(g_oqt.oqt23) THEN           
           #   #MOD-BA0084 add --start--
           #   IF g_oqt.oqt12 = 'N' THEN #分量計價為'N'才需取單價 
           #      IF g_oqu[l_ac].oqu07 =0 OR                                              
           #        (g_oqu[l_ac].oqu06 != g_oqu_t.oqu06 OR cl_null(g_oqu_t.oqu06)) THEN
           #   #MOD-BA0084 add --end--
           #         CALL s_fetch_price_new(g_oqt.oqt04,g_oqu[l_ac].oqu03,g_oqu[l_ac].oqu05,g_oqt.oqt02,'1',
           #              g_plant,g_oqt.oqt09,g_oqt.oqt10,g_oqt.oqt25,g_oqt.oqt01,g_oqu[l_ac].oqu02,
           #              g_oqu[l_ac].oqu06,'',p_cmd)
           #             #RETURNING g_oqu[l_ac].oqu07         #FUN-AB0082
           #              RETURNING g_oqu[l_ac].oqu07,l_oeb37 #FUN-AB0082
           #   #MOD-BA0084 add --start--
           #      END IF 
           #   END IF 
           #   #MOD-BA0084 add --end--
           #END IF 
           ##NO.FUN-A80056--end
           #END IF   #No.TQC-6B0117
           #FUN-BB0085-mark-end----
           #FUN-BB0085-add-str--
           CALL t360_oqu06_check(p_cmd) RETURNING l_tf,l_oeb37
           IF NOT l_tf THEN NEXT FIELD oqu06 END IF
           #FUN-BB0085-add-end--

 
        AFTER FIELD oqu07
           IF NOT cl_null(g_oqu[l_ac].oqu07) THEN
              IF g_oqu[l_ac].oqu07 < 0 THEN
                 CALL cl_err(g_oqu[l_ac].oqu07,'afa-043',0) #No.TQC-6B0117
                 NEXT FIELD oqu07
              END IF
              #FUN-C40089---begin
              SELECT oah08 INTO g_oah08 FROM oah_file WHERE oah01=g_oqt.oqt10
              IF cl_null(g_oah08) THEN
                 LET g_oah08 = 'Y'
              END IF 
              IF g_oah08='N' AND g_oqu[l_ac].oqu07=0 THEN
                 CALL cl_err(g_oqu[l_ac].oqu07,'axm-627',0)  #FUN-C50074
                 NEXT FIELD oqu07
              END IF
              #FUN-C40089---end
             #MOD-D30252 add start -----
              SELECT azi03 INTO t_azi03 FROM azi_file
               WHERE azi01 = g_oqt.oqt09
                 AND aziacti = 'Y'
              CALL cl_digcut(g_oqu[l_ac].oqu07,t_azi03) RETURNING g_oqu[l_ac].oqu07 
             #MOD-D30252 add start -----
           END IF
 
        AFTER FIELD oqu09
           #FUN-BB0085-add-str--
           #IF NOT cl_null(g_oqu[l_ac].oqu09) THEN
           #   IF g_oqu[l_ac].oqu09 < 0 THEN
           #      CALL cl_err(g_oqu[l_ac].oqu09,'afa-043',0)
           #      NEXT FIELD oqu09
           #   END IF
           #END IF
           #FUN-BB0085-add-end--
           IF NOT t360_oqu09_check() THEN NEXT FIELD oqu09 END IF  #FUN-BB0085
 
        AFTER FIELD oqu11
           IF NOT cl_null(g_oqu[l_ac].oqu11) THEN
              IF g_oqu[l_ac].oqu11 < 0 THEN
                 CALL cl_err(g_oqu[l_ac].oqu11,'afa-043',0)
                 NEXT FIELD oqu11
              END IF
           END IF
 
        AFTER FIELD oqu12
           IF NOT cl_null(g_oqu[l_ac].oqu12) THEN
              IF g_oqu[l_ac].oqu12 < 0 THEN
                 CALL cl_err(g_oqu[l_ac].oqu12,'afa-043',0)
                 NEXT FIELD oqu12
              END IF
              #MOD-D50103 add beg
              IF cl_null(g_oqu[l_ac].oqu13) OR g_oqu[l_ac].oqu13 = 0 OR g_oqu[l_ac].oqu12 > g_oqu[l_ac].oqu13 THEN 
                 LET g_oqu[l_ac].oqu13 = g_oqu[l_ac].oqu12
              END IF  
              #MOD-D50103 add end
              #TQC-B90152--begin
              IF NOT cl_null(g_oqu[l_ac].oqu13) THEN
                 IF g_oqu[l_ac].oqu13<g_oqu[l_ac].oqu12 THEN 
                    CALL cl_err(g_oqu[l_ac].oqu12,'axm-712',0)
                    NEXT FIELD oqu12
                 END IF
              END IF 
              #TQC-B90152--end
           END IF
 
        AFTER FIELD oqu13
           IF NOT cl_null(g_oqu[l_ac].oqu13) THEN
              IF g_oqu[l_ac].oqu13 < 0 THEN
                 CALL cl_err(g_oqu[l_ac].oqu13,'afa-043',0)
                 NEXT FIELD oqu13
              END IF
              #TQC-B90152--begin
              IF NOT cl_null(g_oqu[l_ac].oqu12) THEN
                 IF g_oqu[l_ac].oqu13<g_oqu[l_ac].oqu12 THEN 
                    CALL cl_err(g_oqu[l_ac].oqu13,'axm-712',0)
                    NEXT FIELD oqu13
                 END IF
              END IF 
              #TQC-B90152--end
           END IF
 
        AFTER FIELD oqu08
           IF NOT cl_null(g_oqu[l_ac].oqu08) THEN
              SELECT oqw02 INTO g_oqu[l_ac].oqw02 FROM oqw_file  ##No.FUN-650197
               WHERE oqw01 = g_oqu[l_ac].oqu08
                 AND oqwacti = 'Y' #MOD-530341
              IF STATUS THEN                              ##No.FUN-650197
                 CALL cl_err('','axm-060',0)
                 NEXT FIELD oqu08
              END IF 
              DISPLAY BY NAME g_oqu[l_ac].oqw02   ##No.FUN-650197
           END IF
 
       AFTER FIELD oqu14   #包裝方式,若有選擇則需帶出材積、淨重、毛重
          IF NOT cl_null(g_oqu[l_ac].oqu14) THEN
            #CHI-CC0034 mark --start--
            ##包裝方式檔
            #SELECT * INTO l_obe.* FROM obe_file
            # WHERE obe01=g_oqu[l_ac].oqu14
            #IF SQLCA.sqlcode THEN                               #No.TQC-6B0117
            #   CALL cl_err(g_oqu[l_ac].oqu14,SQLCA.sqlcode,0)   #No.TQC-6B0117
            #   NEXT FIELD oqu14                                 #No.TQC-6B0117
            #   LET g_oqu[l_ac].oqu11=0   #材積
            #   LET g_oqu[l_ac].oqu12=0   #淨重
            #   LET g_oqu[l_ac].oqu13=0   #毛重
            #ELSE
            #   IF cl_null(g_oqu[l_ac].oqu09) OR
            #      g_oqu[l_ac].oqu09=0 THEN   #數量
            #      LET l_box1 =1
            #      LET l_oqu09=1
            #   ELSE
            #      LET l_box1=g_oqu[l_ac].oqu09/l_obe.obe24   #整數的箱數
            #      LET l_box2=g_oqu[l_ac].oqu09/l_obe.obe24   #算到小數位的箱數
            #      IF l_box2-l_box1 >0 THEN LET l_box1=l_box1+1 END IF
            #      LET l_oqu09=g_oqu[l_ac].oqu09
            #   END IF
            # 
            #   #-->材積
            #   LET g_oqu[l_ac].oqu11=l_box1*l_obe.obe26
            #
            #   #-->淨重
            #   SELECT ima18 INTO l_ima18 FROM ima_file
            #    WHERE ima01=g_oqu[l_ac].oqu03
            #   IF STATUS OR cl_null(l_ima18) THEN  #MOD-640459 mod
            #       LET l_ima18=0 
            #   END IF     #-->單位淨重
            #   LET g_oqu[l_ac].oqu12=l_oqu09*l_ima18
            #
            #   #-->毛重=箱數*(外包裝重量+(外包裝裝數*內包裝重量))
            #   LET g_oqu[l_ac].oqu13=l_box1*(l_obe.obe23+(l_obe.obe22*l_obe.obe13))
            #   LET g_oqu[l_ac].oqu13 = g_oqu[l_ac].oqu13 + g_oqu[l_ac].oqu12   #TQC-D10032 add
            #END IF
            #CHI-CC0034 mark --end--
             #CHI-CC0034 add --start--
             IF NOT t360_chk_obe(l_ac) THEN
                NEXT FIELD oqu14 
             END IF
             #CHI-CC0034 add --end--
          END IF
 
          AFTER FIELD oquud01
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud02
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud03
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud04
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud05
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud06
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud07
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud08
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud09
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud10
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud11
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud12
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud13
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud14
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD oquud15
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_oqu_t.oqu02 > 0 AND g_oqu_t.oqu02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM oqu_file
                 WHERE oqu01 = g_oqt.oqt01 AND oqu02 = g_oqu_t.oqu02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","oqu_file",g_oqt.oqt01,g_oqu_t.oqu02,SQLCA.sqlcode,"","",1)     #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
 
                #將分量計價資料檔的資料一併刪除
                IF g_oqt.oqt12='Y' THEN
                   DELETE FROM oqv_file
                    WHERE oqv01 = g_oqt.oqt01
                      AND oqv02 = g_oqu_t.oqu02
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","oqv_file",g_oqt.oqt01,g_oqu_t.oqu02,SQLCA.sqlcode,"","",1)     #No.FUN-660167
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
 
               LET l_oqt21 = '0'          #FUN-550022
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oqu[l_ac].* = g_oqu_t.*
               CLOSE t360_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CALL t360_b_move_back() #FUN-730018
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oqu[l_ac].oqu03,-263,1)
               LET g_oqu[l_ac].* = g_oqu_t.*
            ELSE
               UPDATE oqu_file SET * = b_oqu.*
                  WHERE oqu01=g_oqt.oqt01 AND oqu02=g_oqu_t.oqu02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","oqv_file",g_oqt.oqt01,g_oqu_t.oqu02,SQLCA.sqlcode,"","",1)     #No.FUN-660167
                  LET g_oqu[l_ac].* = g_oqu_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_oqt21 = '0'          #FUN-550022
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oqu[l_ac].* = g_oqu_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_oqu.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t360_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 Add
            CLOSE t360_bcl
            COMMIT WORK
 
#        ON ACTION CONTROLN  #MOD-D50103 mark
#            CALL t360_b_askkey()
#            EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oqu02) AND l_ac > 1 THEN  #BugNo:5223
               LET g_oqu[l_ac].* = g_oqu[l_ac-1].*
               LET g_oqu[l_ac].oqu02 = NULL
               NEXT FIELD oqu02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION mntn_prod_cus
                     LET g_msg="axmi150 '",g_oqu[l_ac].oqu03,"' "
                     CALL cl_cmdrun(g_msg)
 
        ON ACTION mntn_origin
                     LET g_msg="axmi365"
                     CALL cl_cmdrun(g_msg)
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(oqu03)
#FUN-AA0059---------mod------------str-----------------              
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_ima"
#                   LET g_qryparam.default1 = g_oqu[l_ac].oqu03
#                   CALL cl_create_qry() RETURNING g_oqu[l_ac].oqu03
                   CALL q_sel_ima(FALSE, "q_ima","",g_oqu[l_ac].oqu03,"","","","","",'' ) 
                       RETURNING  g_oqu[l_ac].oqu03
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY BY NAME g_oqu[l_ac].oqu03 #No.MOD-480367
                   NEXT FIELD oqu03
              WHEN INFIELD(oqu04)
#FUN-AA0059---------mod------------str-----------------              
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_ima"
#                   LET g_qryparam.default1 = g_oqu[l_ac].oqu04
#                   CALL cl_create_qry() RETURNING g_oqu[l_ac].oqu04
                    CALL q_sel_ima(FALSE, "q_ima","",g_oqu[l_ac].oqu04,"","","","","",'' ) 
                       RETURNING  g_oqu[l_ac].oqu04
#FUN-AA0059---------mod------------end-----------------                   
                    DISPLAY BY NAME g_oqu[l_ac].oqu04 #No.MOD-480367
                   NEXT FIELD oqu04
              WHEN INFIELD(oqu05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_oqu[l_ac].oqu05
                   CALL cl_create_qry() RETURNING g_oqu[l_ac].oqu05
                    DISPLAY BY NAME g_oqu[l_ac].oqu05  #No.MOD-480367
                   NEXT FIELD oqu05
              WHEN INFIELD(oqu08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oqw"
                   LET g_qryparam.default1 = g_oqu[l_ac].oqu08
                   CALL cl_create_qry() RETURNING g_oqu[l_ac].oqu08
                    DISPLAY BY NAME g_oqu[l_ac].oqu05  #No.MOD-480367
                   NEXT FIELD oqu08
              WHEN INFIELD(oqu10)   #包裝單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_oqu[l_ac].oqu10
                   CALL cl_create_qry() RETURNING g_oqu[l_ac].oqu10
                   DISPLAY BY NAME g_oqu[l_ac].oqu10
                   NEXT FIELD oqu10
              WHEN INFIELD(oqu14)   #包裝方式
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_obe"
                   LET g_qryparam.default1 = g_oqu[l_ac].oqu14
                   CALL cl_create_qry() RETURNING g_oqu[l_ac].oqu14
                   DISPLAY BY NAME g_oqu[l_ac].oqu14
                   NEXT FIELD oqu14
              OTHERWISE
                   EXIT CASE
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
    UPDATE oqt_file SET oqtmodu = g_user,oqtdate = g_today,oqt21=l_oqt21
     WHERE oqt01 = g_oqt.oqt01
    LET g_oqt.oqt21 = l_oqt21
    DISPLAY BY NAME g_oqt.oqt21
    IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
    SELECT COUNT(*) INTO g_cnt FROM oqu_file WHERE oqu01=g_oqt.oqt01
 
    CLOSE t360_bcl
    COMMIT WORK
    CALL t360_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t360_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_oqt.oqt01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM oqt_file ",
                  "  WHERE oqt01 LIKE '",l_slip,"%' ",
                  "    AND oqt01 > '",g_oqt.oqt01,"'"
      PREPARE t360_pb1 FROM l_sql 
      EXECUTE t360_pb1 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0  THEN
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
        #CALL t360_x()   #FUN-D20025
         CALL t360_x(1)  #FUN-D20025
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM oqx_file WHERE oqx01 = g_oqt.oqt01
         DELETE FROM oao_file WHERE oao01 = g_oqt.oqt01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  oqt_file WHERE oqt01 = g_oqt.oqt01
         INITIALIZE g_oqt.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t360_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF g_oqt.oqt12 = 'N' THEN
       CALL cl_set_comp_entry("oqu06,oqu07",TRUE)
    END IF
 
    IF INFIELD(oqu03) THEN
       CALL cl_set_comp_entry("oqu04,oqu031,oqu032",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t360_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF g_oqt.oqt12 = 'Y' THEN
       CALL cl_set_comp_entry("oqu06,oqu07",FALSE)
    END IF
 
    IF INFIELD(oqu03) THEN
       IF g_oqu[l_ac].oqu03[1,4] !='MISC' THEN
          CALL cl_set_comp_entry("oqu04,oqu031,oqu032",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t360_ins_oqs(p_flag)  #其他相關資料
    DEFINE  p_flag      LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
            l_n         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
            l_a         LIKE type_file.chr1,     # No.FUN-680137 VARCHAR(1)
            l_b         LIKE faj_file.faj02,        # No.FUN-680137   VARCHAR(10)
            l_oqs       RECORD LIKE oqs_file.*
 
    SELECT COUNT(*) INTO l_n FROM oqs_file WHERE oqs01=g_user
    IF p_flag='a' AND l_n > 0 THEN
       LET l_a='Y'
       LET l_b=g_user
       CALL t360_1(l_b)
    ELSE
     IF p_flag='a' THEN
       LET l_a='Y'
     ELSE
       IF NOT cl_confirm('axm-506') THEN
          RETURN
       ELSE
          LET l_a='Y'
       END IF
     END IF
 
     WHILE TRUE
        CALL cl_getmsg('axm-507',g_lang) RETURNING g_msg
        PROMPT g_msg CLIPPED FOR l_b
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        END PROMPT
        IF cl_null(l_b) THEN  EXIT WHILE END IF
        SELECT COUNT(*) INTO l_n FROM oqs_file WHERE oqs01=l_b
        IF l_n =0 THEN
           CALL cl_err('','axm-508',0) CONTINUE WHILE
        END IF
        EXIT WHILE
     END WHILE
     CALL t360_1(l_b)
    END IF
END FUNCTION
 
FUNCTION t360_oqu03(p_flag)  #料號
 
    DEFINE l_ima02     LIKE ima_file.ima02,
           l_ima021    LIKE ima_file.ima021,
           l_ima130    LIKE ima_file.ima130,
           l_imaacti   LIKE ima_file.imaacti,
           p_flag,l_a  LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima130,imaacti INTO l_ima02,l_ima021,l_ima130,
           l_imaacti FROM ima_file
     WHERE ima01=g_oqu[l_ac].oqu03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0016'
                                   LET l_ima02   = NULL
                                   LET l_ima021  = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #No.FUN-690022
         WHEN l_ima130='0'         LET g_errno = 'axm-129'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF (cl_null(g_errno) OR p_flag='d') OR (g_oqu[l_ac].oqu03[1,4]='MISC') THEN  #NO:6808
       LET g_oqu[l_ac].oqu031= l_ima02
       LET g_oqu[l_ac].oqu032= l_ima021
       DISPLAY g_oqu[l_ac].oqu031 TO oqu031 #No:9496(Genero)
       DISPLAY g_oqu[l_ac].oqu032 TO oqu032 #No:9496(Genero)
    END IF
END FUNCTION
 
FUNCTION t360_delall()
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM oqt_file WHERE oqt01 = g_oqt.oqt01
    END IF
END FUNCTION
 
FUNCTION t360_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON oqu02,oqu03,oqu031,oqu032,oqu04,oqu09,oqu10,
                       oqu14,        #FUN-610041
                       oqu08,oqu05,oqu06,oqu07,oqu11,oqu12,oqu13,
                       oquud01,oquud02,oquud03,oquud04,oquud05,
                       oquud06,oquud07,oquud08,oquud09,oquud10,
                       oquud11,oquud12,oquud13,oquud14,oquud15
            FROM s_oqu[1].oqu02 ,s_oqu[1].oqu03,s_oqu[1].oqu031,
                 s_oqu[1].oqu032,s_oqu[1].oqu04,s_oqu[1].oqu09,s_oqu[1].oqu10,
                 s_oqu[1].oqu14 ,    #FUN-610041
                 s_oqu[1].oqu08 ,s_oqu[1].oqu05,s_oqu[1].oqu06,
                 s_oqu[1].oqu07 ,s_oqu[1].oqu11,s_oqu[1].oqu12,s_oqu[1].oqu13,
                 s_oqu[1].oquud01,s_oqu[1].oquud02,s_oqu[1].oquud03,
                 s_oqu[1].oquud04,s_oqu[1].oebud05,s_oqu[1].oquud06,
                 s_oqu[1].oquud07,s_oqu[1].oquud08,s_oqu[1].oquud09,
                 s_oqu[1].oquud10,s_oqu[1].oquud11,s_oqu[1].oquud12,
                 s_oqu[1].oquud13,s_oqu[1].oquud14,s_oqu[1].oquud15
 
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t360_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t360_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql =
        "SELECT oqu02,oqu03,oqu04,oqu031,oqu032,oqu09,oqu10,oqu14,oqu08,'',oqu05,",   ##No.FUN-650197
               "ima908,oqu06,oqu07,oqu11,oqu12,oqu13,", #FUN-560193 add ima908 
               "oquud01,oquud02,oquud03,oquud04,oquud05,oquud06,oquud07,", 
               "oquud08,oquud09,oquud10,oquud11,oquud12,oquud13,oquud14,",
               "oquud15",  
        " FROM oqu_file,OUTER ima_file ",  #FUN-560193 add OUTER ima_file
        " WHERE oqu01 ='",g_oqt.oqt01,"'",  #單頭
        " AND oqu_file.oqu03=ima_file.ima01",  #FUN-560193
        " AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t360_pb FROM g_sql
    DECLARE oqu_curs                       #CURSOR
        CURSOR WITH HOLD FOR t360_pb
 
    CALL g_oqu.clear()
 
    LET g_cnt = 1
    FOREACH oqu_curs INTO g_oqu[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT oqw02 INTO g_oqu[g_cnt].oqw02 FROM
           oqw_file WHERE oqw01 = g_oqu[g_cnt].oqu08
        IF SQLCA.sqlcode THEN
           LET g_oqu[g_cnt].oqw02 = NULL
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_oqu.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t360_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_oqu TO s_oqu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t360_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t360_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t360_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t360_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t360_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
         IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
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
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
#@    ON ACTION 其他資料
      ON ACTION other_data
         LET g_action_choice="other_data"
         EXIT DISPLAY
#@    ON ACTION 數量報價資料
      ON ACTION qty_quot
         LET g_action_choice="qty_quot"
         EXIT DISPLAY
#@    ON ACTION 費用資料
      ON ACTION expense_data
         LET g_action_choice="expense_data"
         EXIT DISPLAY
#@    ON ACTION 客戶相關查詢
      ON ACTION query_customer
         LET g_action_choice="query_customer"
         EXIT DISPLAY
#@    ON ACTION 地址異動
      ON ACTION addr__change
         LET g_action_choice="addr__change"
         EXIT DISPLAY
#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
      ON ACTION easyflow_approval         #FUN-550022
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY
 
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025--add--str---
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025--add--str---
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
  #@ON ACTION 簽核狀況
    ON ACTION approval_status     #MOD-4C0041
      LET g_action_choice="approval_status"
      EXIT DISPLAY
 
    ON ACTION agree
       LET g_action_choice = 'agree'
       EXIT DISPLAY
 
    ON ACTION deny
       LET g_action_choice = 'deny'
       EXIT DISPLAY
 
    ON ACTION modify_flow
       LET g_action_choice = 'modify_flow'
       EXIT DISPLAY
 
    ON ACTION withdraw
       LET g_action_choice = 'withdraw'
       EXIT DISPLAY
 
    ON ACTION org_withdraw
       LET g_action_choice = 'org_withdraw'
       EXIT DISPLAY
 
    ON ACTION phrase
       LET g_action_choice = 'phrase'
       EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t360_out()
DEFINE l_b    LIKE imc_file.imc02,       #MOD-A30103
       l_wc   LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(200)
       l_c    LIKE type_file.chr1        # No.FUN-680137  VARCHAR(01)  #MOD-4A0079
 
  IF NOT cl_null(g_oqt.oqt01) THEN
           WHILE TRUE
                CALL cl_getmsg('axm-505',g_lang) RETURNING g_msg
                #IF INT_FLAG THEN  CLOSE WINDOW t360_f2 RETURN END IF   #MOD-A60147
            LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED FOR l_b
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                #-----MOD-A60147---------
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                END IF
                #-----END MOD-A60147-----
                EXIT WHILE
           END WHILE
      LET l_wc='oqt01="',g_oqt.oqt01 ,'"'
      CASE g_oqt.oqtconf
          WHEN 'Y' #1.確認
              LET l_c = '1'
          WHEN 'N' #2.未確認
              LET l_c = '2'
          WHEN 'X' #3.作廢
      END CASE
     #  LET g_msg="axmr360 '' '' '' 'Y' '' '' '",l_wc CLIPPED, #MOD-4A0079 #FUN-C30085 mark
      LET g_msg="axmg360 '' '' '' 'Y' '' '' '",l_wc CLIPPED,  #FUN-C30085 add  
            "' '",g_oqt.oqt12,"' '",l_b,"' '",l_c,"'"
      display 'g_msg:',g_msg
      CALL cl_cmdrun(g_msg)
  ELSE
      CALL cl_err('','apj-003',0)
  END IF
 
END FUNCTION
 
FUNCTION t360_oqt23(p_cmd)  #諦誧
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_cnt1    LIKE type_file.num5
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_ofd     RECORD LIKE ofd_file.*

    LET g_errno = " "
    IF cl_null(g_oqt.oqt04) THEN RETURN END IF
    SELECT COUNT(*) INTO l_n FROM occ_file
     WHERE occ01 = g_oqt.oqt04
    SELECT COUNT(*) INTO l_cnt1 FROM ofd_file     #FUN-890011 Add
     WHERE ofd01 = g_oqt.oqt04                    #FUN-890011 Add
    IF l_n = 0 AND l_cnt1 = 0 AND g_oqt.oqt04[1,4] !='MISC' THEN #FUN-890011 Add
       LET g_errno = 'mfg2732'
       RETURN
    END IF
    IF l_n <> 0 THEN     #occ
       IF g_oqt.oqt04[1,4] != 'MISC' THEN
#         IF p_cmd='a' OR (g_oqt_t.oqt04 != g_oqt.oqt04 ) THEN                            #MOD-B60217 mark
          IF p_cmd='a' OR (g_oqt_t.oqt04 != g_oqt.oqt04 ) OR cl_null(g_oqt_t.oqt04) THEN  #MOD-B60217
             SELECT * INTO g_occ.* FROM occ_file
              WHERE occ01 = g_oqt.oqt04
             LET g_oqt.oqt041 = g_occ.occ18
             LET g_oqt.oqt051 = g_occ.occ241
             LET g_oqt.oqt052 = g_occ.occ242
             LET g_oqt.oqt053 = g_occ.occ243
             #-----MOD-AC0088---------
             #LET g_oqt.oqt08  = g_occ.occ49
             LET g_oqt.oqt08 = NULL
             SELECT oac02 INTO g_oqt.oqt08 FROM oac_file
              WHERE oac01 = g_occ.occ49
             #-----END MOD-AC0088-----
             IF cl_null(g_oqt.oqt23)  THEN       #No:TQC-7A0056
                LET g_oqt.oqt09  = g_occ.occ42   #No:TQC-7A0056
             END IF                              #No:TQC-7A0056
              LET g_oqt.oqt10  = g_occ.occ44  #No:MOD-480553
             LET g_oqt.oqt11  = g_occ.occ47
          END IF
          DISPLAY g_oqt.oqt041 TO oqt041
          DISPLAY g_oqt.oqt051 TO oqt051
          DISPLAY g_oqt.oqt052 TO oqt052
          DISPLAY g_oqt.oqt053 TO oqt053
          DISPLAY g_oqt.oqt08 TO oqt08
          DISPLAY g_oqt.oqt09 TO oqt09
          DISPLAY g_oqt.oqt10 TO oqt10
          DISPLAY g_oqt.oqt11 TO oqt11
       END IF
    ELSE  #ofd
       IF g_oqt.oqt04[1,4] != 'MISC' THEN
#         IF p_cmd='a' OR (g_oqt_t.oqt04 != g_oqt.oqt04 ) THEN                            #MOD-B60217 mark
          IF p_cmd='a' OR (g_oqt_t.oqt04 != g_oqt.oqt04 ) OR cl_null(g_oqt_t.oqt04) THEN  #MOD-B60217
             SELECT * INTO l_ofd.* FROM ofd_file
              WHERE ofd01 = g_oqt.oqt04
             LET g_oqt.oqt041 = l_ofd.ofd17
             LET g_oqt.oqt051 = l_ofd.ofd18
             LET g_oqt.oqt052 = l_ofd.ofd19
             LET g_oqt.oqt053 = l_ofd.ofd20
             LET g_oqt.oqt08  = ''
             LET g_oqt.oqt09  = ''
             LET g_oqt.oqt10  = ''
             LET g_oqt.oqt11  = ''
          END IF
          DISPLAY g_oqt.oqt041 TO oqt041
          DISPLAY g_oqt.oqt051 TO oqt051
          DISPLAY g_oqt.oqt052 TO oqt052
          DISPLAY g_oqt.oqt053 TO oqt053
          DISPLAY g_oqt.oqt08 TO oqt08
          DISPLAY g_oqt.oqt09 TO oqt09
          DISPLAY g_oqt.oqt10 TO oqt10
          DISPLAY g_oqt.oqt11 TO oqt11
       END IF
    END IF

END FUNCTION

FUNCTION t360_oqt07(p_cmd)  #人員
   DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_gen02     LIKE gen_file.gen02,
          l_gen03     LIKE gen_file.gen03,
          l_genacti   LIKE gen_file.genacti
   DEFINE l_gem02     LIKE gem_file.gem02  #MOD-9B0113 add

  LET g_errno = ' '
  SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03 FROM gen_file
   WHERE gen01 = g_oqt.oqt07
 
          CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                         LET l_gen02 = NULL
                                         LET l_gen03 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
          END CASE
 
  IF p_cmd='s' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
     RETURN
  END IF
  DISPLAY l_gen02 TO FORMONLY.gen02
  IF p_cmd='d' OR cl_null(g_errno)  THEN
     IF cl_null(g_oqt.oqt23) THEN  #MOD-9B0113 add
        LET g_oqt.oqt06=l_gen03
     END IF  #MOD-9B0113 add
     DISPLAY l_gen02 TO FORMONLY.gen02
     DISPLAY BY NAME g_oqt.oqt06
     IF NOT cl_null(g_oqt.oqt06) THEN
        SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_oqt.oqt06
        DISPLAY l_gem02 TO FORMONLY.gem02
     END IF
  END IF
END FUNCTION
 
FUNCTION t360_oqt06()    #部門
   DEFINE l_gem02     LIKE gem_file.gem02,
          l_gemacti   LIKE gem_file.gemacti
 
          LET g_errno = ' '
          SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
                                  WHERE gem01 = g_oqt.oqt06
 
          CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                         LET l_gem02 = NULL
               WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
          END CASE
          DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION
 
FUNCTION t360_oqt09()  #幣別
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = " "
  #SELECT aziacti INTO l_aziacti FROM azi_file #MOD-D30252 mark
   SELECT azi03,aziacti INTO t_azi03,l_aziacti FROM azi_file #MOD-D30252 add
    WHERE azi01 = g_oqt.oqt09
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  #MOD-D30252 add start -----
   IF (g_oqt.oqt09 <> g_oqt_o.oqt09) THEN
       SELECT COUNT(*) INTO g_cnt FROM oqu_file
        WHERE oqu01 = g_oqt.oqt01
        IF g_cnt > 0 THEN
        #確定是你要變更的幣別嗎?
            IF NOT cl_confirm2('axm-918',g_oqt.oqt09) THEN
                LET g_oqt.oqt09=g_oqt_o.oqt09
                DISPLAY BY NAME g_oqt.oqt09
                CALL cl_err(g_oqt.oqt09,'axm-190',1)
            END IF
        END IF
   END IF
  #MOD-D30252 add start -----
END FUNCTION
 
FUNCTION t360_oqx041(p_oqx041)  #幣別
   DEFINE p_oqx041  LIKE oqx_file.oqx041
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = " "
   SELECT aziacti INTO l_aziacti FROM azi_file
    WHERE azi01 = p_oqx041
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION t360_1(p_oqs01)
  DEFINE  p_oqs01        LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
          l_a           LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          l_oqs         RECORD LIKE oqs_file.*,
          l_oqt         RECORD LIKE oqt_file.*,
          l_oqt_t       RECORD LIKE oqt_file.*,
          l_n           LIKE type_file.num5   #MOD-990186
 
    BEGIN WORK
 
    OPEN t360_cl USING g_oqt.oqt01
    IF STATUS THEN
       CALL cl_err("OPEN t360_cl:", STATUS, 1)
       CLOSE t360_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t360_cl INTO g_oqt.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t360_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    IF cl_null(g_oqt.oqt01) THEN RETURN END IF
 
    SELECT * INTO l_oqt.* FROM oqt_file WHERE oqt01 = g_oqt.oqt01
    LET l_oqt_t.* = l_oqt.*
    IF cl_null(l_oqt.oqt13)  AND
       cl_null(l_oqt.oqt141) AND
       cl_null(l_oqt.oqt142) AND 
       cl_null(l_oqt.oqt143) AND 
       cl_null(l_oqt.oqt151) AND 
       cl_null(l_oqt.oqt152) AND 
       cl_null(l_oqt.oqt161) AND 
       cl_null(l_oqt.oqt162) AND 
       cl_null(l_oqt.oqt171) AND 
       cl_null(l_oqt.oqt172) AND 
       cl_null(l_oqt.oqt173) AND 
       cl_null(l_oqt.oqt181) AND 
       cl_null(l_oqt.oqt182) AND 
       cl_null(l_oqt.oqt191) AND 
       cl_null(l_oqt.oqt192) AND  
       cl_null(l_oqt.oqt20)  THEN 
       LET p_oqs01 = g_user
    ELSE
       WHILE TRUE
          CALL cl_getmsg('axm-507',g_lang) RETURNING g_msg
          PROMPT g_msg CLIPPED FOR p_oqs01
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
       
             ON ACTION about         
                CALL cl_about()      
            
             ON ACTION help          
                CALL cl_show_help()  
            
             ON ACTION controlg      
                CALL cl_cmdask()     
          END PROMPT
          IF cl_null(p_oqs01) THEN  EXIT WHILE END IF
          SELECT COUNT(*) INTO l_n FROM oqs_file WHERE oqs01=p_oqs01
          IF l_n =0 THEN
             CALL cl_err('','axm-508',0) CONTINUE WHILE
          END IF
          EXIT WHILE
       END WHILE
    END IF 
 
    LET p_row = 1 LET p_col = 2
 
 
    OPEN WINDOW t360_f1 AT p_row,p_col WITH FORM "axm/42f/axmt3601"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt3601")
 
 
    DISPLAY BY NAME g_oqt.oqt01
    IF NOT cl_null(p_oqs01)  THEN
       SELECT * INTO l_oqs.* FROM oqs_file WHERE oqs01=p_oqs01
          LET l_oqt.oqt13 =l_oqs.oqs13
          LET l_oqt.oqt141=l_oqs.oqs141
          LET l_oqt.oqt142=l_oqs.oqs142
          LET l_oqt.oqt143=l_oqs.oqs143
          LET l_oqt.oqt151=l_oqs.oqs151
          LET l_oqt.oqt152=l_oqs.oqs152
          LET l_oqt.oqt161=l_oqs.oqs161
          LET l_oqt.oqt162=l_oqs.oqs162
          LET l_oqt.oqt171=l_oqs.oqs171
          LET l_oqt.oqt172=l_oqs.oqs172
          LET l_oqt.oqt173=l_oqs.oqs173
          LET l_oqt.oqt181=l_oqs.oqs181
          LET l_oqt.oqt182=l_oqs.oqs182
          LET l_oqt.oqt191=l_oqs.oqs191
          LET l_oqt.oqt192=l_oqs.oqs192
          LET l_oqt.oqt20 =l_oqs.oqs20
    END IF
    DISPLAY BY NAME
            l_oqt.oqt13 ,l_oqt.oqt141, l_oqt.oqt142,l_oqt.oqt143,
            l_oqt.oqt151,l_oqt.oqt152, l_oqt.oqt161,l_oqt.oqt162,
            l_oqt.oqt171,l_oqt.oqt172, l_oqt.oqt173,
            l_oqt.oqt181,l_oqt.oqt182, l_oqt.oqt191,l_oqt.oqt192,
            l_oqt.oqt20
 
    IF l_oqt.oqtconf='Y' THEN
       CALL cl_err('','axm-101',1)
       CLOSE WINDOW t360_f1
       RETURN
    END IF
    IF l_oqt.oqt21 matches '[Ss]' THEN   #FUN-550022
       CALL cl_err('','apm-030',1)
       CLOSE WINDOW t360_f1
       RETURN
    END IF
 
    INPUT BY NAME
            l_oqt.oqt13 ,l_oqt.oqt141,l_oqt.oqt142,l_oqt.oqt143,
            l_oqt.oqt151,l_oqt.oqt152,l_oqt.oqt161,l_oqt.oqt162,
            l_oqt.oqt171,l_oqt.oqt172,l_oqt.oqt173,
            l_oqt.oqt181,l_oqt.oqt182,l_oqt.oqt191,l_oqt.oqt192,
            l_oqt.oqt20
            WITHOUT DEFAULTS
            AFTER INPUT
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
       LET INT_FLAG=0
       CLOSE WINDOW t360_f1
       RETURN
    END IF
 
       UPDATE oqt_file SET oqt13 =l_oqt.oqt13 ,
                           oqt141=l_oqt.oqt141,
                           oqt142=l_oqt.oqt142,
                           oqt143=l_oqt.oqt143,
                           oqt151=l_oqt.oqt151,
                           oqt152=l_oqt.oqt152,
                           oqt161=l_oqt.oqt161,
                           oqt162=l_oqt.oqt162,
                           oqt171=l_oqt.oqt171,
                           oqt172=l_oqt.oqt172,
                           oqt173=l_oqt.oqt173,
                           oqt181=l_oqt.oqt181,
                           oqt182=l_oqt.oqt182,
                           oqt191=l_oqt.oqt191,
                           oqt192=l_oqt.oqt192,
                           oqt20=l_oqt.oqt20
       WHERE oqt01 = g_oqt.oqt01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","oqt_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","",1)   #No.FUn-660167
            ROLLBACK WORK
         ELSE
            MESSAGE 'UPDATE O.K'
            UPDATE oqt_file set oqt21 = '0' where oqt01 = g_oqt.oqt01
            LET g_oqt.oqt21 = '0'
 
            COMMIT WORK
         END IF
 
    CLOSE WINDOW t360_f1
    DISPLAY BY NAME g_oqt.oqt21
    IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
    SELECT COUNT(*) INTO l_n FROM oqs_file WHERE oqs01=g_user
    IF l_n = 0 THEN
       IF cl_confirm('axm-509') THEN
          LET l_oqs.oqs01 = g_user
          LET l_oqs.oqs13 =l_oqt.oqt13
          LET l_oqs.oqs141=l_oqt.oqt141
          LET l_oqs.oqs142=l_oqt.oqt142
          LET l_oqs.oqs143=l_oqt.oqt143
          LET l_oqs.oqs151=l_oqt.oqt151
          LET l_oqs.oqs152=l_oqt.oqt152
          LET l_oqs.oqs161=l_oqt.oqt161
          LET l_oqs.oqs162=l_oqt.oqt162
          LET l_oqs.oqs171=l_oqt.oqt171
          LET l_oqs.oqs172=l_oqt.oqt172
          LET l_oqs.oqs173=l_oqt.oqt173
          LET l_oqs.oqs181=l_oqt.oqt181
          LET l_oqs.oqs182=l_oqt.oqt182
          LET l_oqs.oqs191=l_oqt.oqt191
          LET l_oqs.oqs192=l_oqt.oqt192
          LET l_oqs.oqs20 =l_oqt.oqt20
          LET l_oqs.oqsacti='Y'
          LET l_oqs.oqsuser=g_user
          LET l_oqs.oqsgrup=g_grup
          LET l_oqs.oqsdate=g_today
          LET l_oqs.oqsmodu=''
 
          LET l_oqs.oqsplant = g_plant 
          LET l_oqs.oqslegal = g_legal  
 
          LET l_oqs.oqsoriu = g_user      #No.FUN-980030 10/01/04
          LET l_oqs.oqsorig = g_grup      #No.FUN-980030 10/01/04
          INSERT INTO oqs_file VALUES (l_oqs.*)
          IF STATUS OR SQLCA.SQLCODE THEN
             CALL cl_err3("ins","oqs_file",l_oqs.oqs01,"",SQLCA.SQLCODE,"","ins img",1)   #No.FUN-660167
             ROLLBACK WORK
             RETURN
          END IF
       END IF
    END IF
 
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t360_2(p_oqv02,p_flag)
DEFINE
    p_oqv02         LIKE oqv_file.oqv02,
    p_flag          LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
    l_oqv           DYNAMIC ARRAY OF RECORD
                    oqv03     LIKE oqv_file.oqv03,
                    oqv04     LIKE oqv_file.oqv04,
                    oqv05     LIKE oqv_file.oqv05
                    END RECORD,
    l_oqu03         LIKE oqu_file.oqu03,
    l_oqu031        LIKE oqu_file.oqu031,
    l_oqu032        LIKE oqu_file.oqu032,
    l_oqv_t         RECORD
                    oqv03     LIKE oqv_file.oqv03,
                    oqv04     LIKE oqv_file.oqv04,
                    oqv05     LIKE oqv_file.oqv05
                    END RECORD,
    l_chr           LIKE type_file.num5,        # No.FUN-680137 SMALLINT
    l_rec_b         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_ac,l_n        LIKE type_file.num5,                #        #No.FUN-680137 SMALLINT
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5,                 #可刪除否        #No.FUN-680137 SMALLINT
    l_oqt21         LIKE oqt_file.oqt21
 
    IF cl_null(g_oqt.oqt01) THEN RETURN END IF
 
    IF g_oqt.oqt12 = 'N' THEN
       CALL cl_err('','axm-050',0)
       RETURN
    END IF
 
    LET p_row = 2 LET p_col = 21
 
 
    OPEN WINDOW t360_f3 AT p_row,p_col WITH FORM "axm/42f/axmt3602"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt3602")
 
 
    DISPLAY g_oqt.oqt01 TO oqv01
    DISPLAY g_oqt.oqt09 TO oqt09
 
    IF p_flag ='y' THEN
       INPUT p_oqv02 FROM oqv02
           AFTER FIELD oqv02
                 IF NOT cl_null(p_oqv02) THEN
                    SELECT COUNT(*) INTO l_n FROM oqu_file
                     WHERE oqu01=g_oqt.oqt01 AND oqu02=p_oqv02
                    IF l_n=0 THEN
                       CALL cl_err('','axm-141',0)
                       NEXT FIELD oqv02
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
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW t360_f3
       RETURN
    END IF
 
    SELECT oqu03,oqu031,oqu032 INTO l_oqu03,l_oqu031,l_oqu032
      FROM oqu_file WHERE oqu01=g_oqt.oqt01 AND oqu02=p_oqv02
       DISPLAY p_oqv02     TO oqv02
       DISPLAY l_oqu03     TO oqu03
       DISPLAY l_oqu031    TO oqu031
       DISPLAY l_oqu032    TO oqu032
 
    #顯示單身舊值
    LET g_sql = " SELECT oqv03,oqv04,oqv05",
                " FROM oqv_file",
                " WHERE oqv01 = ? AND oqv02 = ?",
                " ORDER BY 1"
    PREPARE t360_b2 FROM g_sql
    DECLARE oqv_curs CURSOR FOR t360_b2
 
    CALL l_oqv.clear()
 
    LET g_cnt = 1
 
    FOREACH oqv_curs USING g_oqt.oqt01,p_oqv02 INTO l_oqv[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL l_oqv.deleteElement(g_cnt)
    LET l_rec_b = g_cnt-1
    IF g_oqt.oqtconf='Y' OR g_oqt.oqt21 matches '[Ss]' THEN   #FUN-550022
       DISPLAY ARRAY l_oqv TO s_oqv.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
 
          ON ACTION exit
             EXIT DISPLAY
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
 
          ON ACTION about         
             CALL cl_about()      
 
          ON ACTION help          
             CALL cl_show_help()  
 
          ON ACTION controlg      
             CALL cl_cmdask()     
 
       END DISPLAY
       CLOSE WINDOW t360_f3
       RETURN
    END IF
 
    LET g_success = 'Y'
 
    LET g_forupd_sql = "SELECT oqv03,oqv04,oqv05,'' FROM oqv_file ",
                       "  WHERE oqv01 = ? AND oqv02 = ? AND  oqv03 = ? ",
                       " AND oqv04 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t360_bc CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY l_oqv WITHOUT DEFAULTS FROM s_oqv.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF p_flag != 'n' THEN BEGIN WORK END IF
 
            OPEN t360_cl USING g_oqt.oqt01
            IF STATUS THEN
               CALL cl_err("OPEN t360_cl:", STATUS, 1)
               CLOSE t360_cl
               IF p_flag != 'n' THEN ROLLBACK WORK END IF
               RETURN
            END IF
 
            FETCH t360_cl INTO g_oqt.*  # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t360_cl
               IF p_flag != 'n' THEN ROLLBACK WORK END IF
               RETURN
            END IF
 
            IF l_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET l_oqv_t.* = l_oqv[l_ac].*  #BACKUP
 
               OPEN t360_bc USING g_oqt.oqt01,p_oqv02,l_oqv_t.oqv03,
                                  l_oqv_t.oqv04
               IF STATUS THEN
                  CALL cl_err("OPEN t360_bc:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t360_bc INTO l_oqv[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock oqu',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
            END IF
 
       BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE l_oqv[l_ac].* TO NULL      #900423
            LET l_oqv_t.* = l_oqv[l_ac].*         #新輸入資料
            NEXT FIELD oqv03
 
       AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO oqv_file(oqv01,oqv02,oqv03,oqv04,oqv05,
                                 oqvplant,oqvlegal)   #FUN-980010 add plant & legal 
                          VALUES(g_oqt.oqt01,p_oqv02,l_oqv[l_ac].oqv03,
                                 l_oqv[l_ac].oqv04,l_oqv[l_ac].oqv05,
                                 g_plant,g_legal)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","oqv_file",g_oqt.oqt01,p_oqv02,SQLCA.sqlcode,"","",1)     #No.FUN-660167
               CANCEL INSERT
            ELSE
               LET l_rec_b = l_rec_b + 1
               MESSAGE 'INSERT O.K'
               LET l_oqt21 = '0'         #FUN-550022
            END IF
 
       BEFORE FIELD oqv03               #default 起始數量
            IF cl_null(l_oqv[l_ac].oqv03) THEN
                SELECT MAX(oqv04)+1 INTO l_oqv[l_ac].oqv03
                  FROM oqv_file
                 WHERE oqv01 = g_oqt.oqt01 #報價單號
                   AND oqv02 = p_oqv02     #項次
               IF cl_null(l_oqv[l_ac].oqv03) THEN
                  LET l_oqv[l_ac].oqv03 = 1
               END IF
            END IF
 
       AFTER FIELD oqv03
            IF NOT cl_null(l_oqv[l_ac].oqv03) THEN
               IF l_oqv_t.oqv03 !=l_oqv[l_ac].oqv03 OR
                  cl_null(l_oqv_t.oqv03) THEN
                  SELECT COUNT(*) INTO g_i FROM oqv_file
                   WHERE oqv01 = g_oqt.oqt01 #報價單號
                     AND oqv02 = p_oqv02     #項次
                     AND l_oqv[l_ac].oqv03 BETWEEN oqv03 AND oqv04
                  IF g_i >=1 THEN
                    #起始數量重疊到已輸入的起迄數量
                     CALL cl_err('','axm-362',0)
                     LET l_oqv[l_ac].oqv03 = l_oqv_t.oqv03
                     NEXT FIELD oqv03
                  END IF
                 #MOD-D20001 add start -----
                  IF l_oqv[l_ac].oqv03 > 1 THEN
                     LET g_i = 0
                     SELECT COUNT(*) INTO g_i FROM oqv_file
                      WHERE oqv01 = g_oqt.oqt01 #報價單號
                        AND oqv02 = p_oqv02     #項次
                        AND oqv04 = l_oqv[l_ac].oqv03-1
                     IF g_i = 0 THEN
                        CALL cl_err('','axm1177',0)
                        LET l_oqv[l_ac].oqv03 = l_oqv_t.oqv03
                        NEXT FIELD oqv03
                     END IF
                  END IF
                 #MOD-D20001 add end   -----
                  IF NOT cl_null(l_oqv[l_ac].oqv04) THEN
                     IF l_oqv[l_ac].oqv04 <= l_oqv[l_ac].oqv03 THEN
                        CALL cl_err('','9011',1)
                        NEXT FIELD oqv03
                     END IF
                  END IF
               END IF
            END IF
 
       AFTER FIELD oqv04
            IF NOT cl_null(l_oqv[l_ac].oqv04) THEN
               IF cl_null(l_oqv_t.oqv04) OR
                 (l_oqv_t.oqv03 !=l_oqv[l_ac].oqv03
                  OR l_oqv_t.oqv04 !=l_oqv[l_ac].oqv04) THEN
                  SELECT COUNT(*) INTO l_n FROM oqv_file
                   WHERE oqv01=g_oqt.oqt01
                     AND oqv02=p_oqv02
                     AND oqv03=l_oqv[l_ac].oqv03
                     AND oqv04=l_oqv[l_ac].oqv04
                  IF l_n > 0  THEN
                     #資料重覆，請重新輸入!
                     CALL cl_err('sel-oqv','axm-298',0)
                     NEXT FIELD oqv04
                  END IF
               END IF
               IF l_oqv[l_ac].oqv04 <= l_oqv[l_ac].oqv03 THEN
                  CALL cl_err('','9011',1)
                  NEXT FIELD oqv04    #No.TQC-930107 add
               END IF
            END IF
 
       AFTER FIELD oqv05    #單價
            IF NOT cl_null(l_oqv[l_ac].oqv05) THEN
               IF l_oqv[l_ac].oqv05 < 0 THEN
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD oqv05
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF l_oqv_t.oqv03 > 0 AND l_oqv_t.oqv04 > 0 THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  IF p_flag != 'n' THEN ROLLBACK WORK END IF
                  CANCEL DELETE
               END IF
 
               DELETE FROM oqv_file
                WHERE oqv01 = g_oqt.oqt01
                  AND oqv02 = p_oqv02
                  AND oqv03 = l_oqv_t.oqv03
                  AND oqv04 = l_oqv_t.oqv04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","oqv_file",g_oqt.oqt01,l_oqv_t.oqv03,SQLCA.sqlcode,"","",1)   #No.FUN-660167
                  IF p_flag != 'n' THEN ROLLBACK WORK END IF
                  CANCEL DELETE
               ELSE
                  LET l_rec_b = l_rec_b - 1
                  LET l_oqt21 = '0'         #FUN-550022
               END IF
 
            END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_oqv[l_ac].* = l_oqv_t.*
              CLOSE t360_bc
              IF p_flag != 'n' THEN ROLLBACK WORK END IF
              EXIT INPUT
           END IF
 
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(l_oqv[l_ac].oqv03,-263,1)
              LET l_oqv[l_ac].* = l_oqv_t.*
              IF p_flag != 'n' THEN ROLLBACK WORK END IF
           ELSE
              UPDATE oqv_file SET oqv01=g_oqt.oqt01,
                                  oqv02=p_oqv02,
                                  oqv03=l_oqv[l_ac].oqv03,
                                  oqv04=l_oqv[l_ac].oqv04,
                                  oqv05=l_oqv[l_ac].oqv05
               WHERE oqv01=g_oqt.oqt01
                 AND oqv02=p_oqv02
                 AND oqv03=l_oqv_t.oqv03
                 AND oqv04=l_oqv_t.oqv04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","oqv_file",g_oqt.oqt01,l_oqv_t.oqv03,SQLCA.sqlcode,"","",1)   #No.FUN-660167
                 LET l_oqv[l_ac].* = l_oqv_t.*
                 IF p_flag != 'n' THEN ROLLBACK WORK END IF
              ELSE
                 MESSAGE 'UPDATE O.K'
                 LET l_oqt21 = '0'         #FUN-550022
                 IF p_flag != 'n' THEN COMMIT WORK END IF
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac    #FUN-D30034 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 #LET g_oqu[l_ac].* = g_oqu_t.* #MOD-D50103 mark
                 LET l_oqv[l_ac].* = l_oqv_t.* #MOD-D50103
              #FUN-D30034--add--str--
              ELSE
                 #CALL g_oqu.deleteElement(l_ac) #MOD-D50103 mark
                 CALL l_oqv.deleteElement(l_ac)  #MOD-D50103
              #FUN-D30034--add--end--
              END IF
              CLOSE t360_bc
              IF p_flag != 'n' THEN ROLLBACK WORK END IF
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30034 Add   
           CLOSE t360_bc
           IF p_flag != 'n' THEN COMMIT WORK END IF
 
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
 
    CLOSE WINDOW t360_f3
 
    UPDATE oqt_file SET oqt21=l_oqt21 WHERE oqt01 = g_oqt.oqt01
    LET g_oqt.oqt21 = l_oqt21
    DISPLAY BY NAME g_oqt.oqt21
    IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
END FUNCTION
 
FUNCTION t360_5()
DEFINE
    l_oqx           DYNAMIC ARRAY OF RECORD
             oqx03     LIKE oqx_file.oqx03,
             oqx04     LIKE oqx_file.oqx04,
             oaj02     LIKE oaj_file.oaj02,
             oqx041    LIKE oqx_file.oqx041,
             oqx05     LIKE oqx_file.oqx05,
             oqx06     LIKE oqx_file.oqx06
                    END RECORD,
    l_oqx_t         RECORD
             oqx03     LIKE oqx_file.oqx03,
             oqx04     LIKE oqx_file.oqx04,
             oaj02     LIKE oaj_file.oaj02,
             oqx041    LIKE oqx_file.oqx041,
             oqx05     LIKE oqx_file.oqx05,
             oqx06     LIKE oqx_file.oqx06
                    END RECORD,
    l_oaj02         LIKE oaj_file.oaj02,
    l_rec_b         LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert   LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete   LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    IF cl_null(g_oqt.oqt01)  THEN RETURN  END IF
 
    #顯示單身舊值
    LET g_sql = " SELECT oqx03,oqx04,oaj02,oqx041,oqx05,oqx06",
                " FROM oqx_file,oaj_file",
                " WHERE oqx01 = ? AND oqx04 = oaj01",
                " ORDER BY 1"
 
    LET p_row = 1 LET p_col = 2
 
 
    OPEN WINDOW t360_f4 AT p_row,p_col WITH FORM "axm/42f/axmt3605"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt3605")
 
 
    PREPARE t360_b3 FROM g_sql
    DECLARE oqx_curs CURSOR FOR t360_b3
 
    CALL l_oqx.clear()
 
    INITIALIZE l_oqx_t.* TO NULL
    LET g_cnt = 1
    LET l_rec_b = 1
 
    FOREACH oqx_curs USING g_oqt.oqt01  INTO l_oqx[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF cl_null(l_oqx[g_cnt].oqx03) THEN EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL l_oqx.deleteElement(g_cnt)
    LET l_rec_b = g_cnt-1
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_oqt.oqtconf='Y' THEN
       CALL cl_err('','axm-101',1)
       CLOSE WINDOW t360_f4
       RETURN
    END IF
    IF g_oqt.oqt21 matches '[Ss]' THEN   #FUN-550022
       CALL cl_err('','apm-030',1)
       CLOSE WINDOW t360_f4
       RETURN
    END IF
 
    LET g_forupd_sql="SELECT oqx03,oqx04,'',oqx041,oqx05,oqx06 FROM oqx_file ",
                     " WHERE oqx01= ? AND oqx03= ? AND oqx04= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t360_b4 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY l_oqx WITHOUT DEFAULTS FROM s_oqx.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t360_cl USING g_oqt.oqt01
            IF STATUS THEN
               CALL cl_err("OPEN t360_cl:", STATUS, 1)
               CLOSE t360_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t360_cl INTO g_oqt.*  # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t360_cl ROLLBACK WORK RETURN
            END IF
            IF l_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET l_oqx_t.* = l_oqx[l_ac].*  #BACKUP
 
                OPEN t360_b4 USING g_oqt.oqt01, l_oqx_t.oqx03, l_oqx_t.oqx04
                IF STATUS THEN
                   CALL cl_err("OPEN t360_b4:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t360_b4 INTO l_oqx[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(l_oqx_t.oqx03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                SELECT oaj02 INTO l_oqx[l_ac].oaj02 FROM oaj_file
                 WHERE oaj01 = l_oqx[l_ac].oqx04
            END IF
 
       BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE l_oqx[l_ac].* TO NULL         #900423
            LET l_oqx_t.* = l_oqx[l_ac].*            #新輸入資料
            NEXT FIELD oqx03
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO oqx_file(oqx01,oqx03,oqx04,oqx041,oqx05,oqx06,
                                oqxplant,oqxlegal)   #FUN-980010 add plant & legal
                         VALUES(g_oqt.oqt01,l_oqx[l_ac].oqx03,l_oqx[l_ac].oqx04,
                                l_oqx[l_ac].oqx041,l_oqx[l_ac].oqx05,
                                l_oqx[l_ac].oqx06,g_plant,g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","oqx_file",g_oqt.oqt01,l_oqx[l_ac].oqx03,SQLCA.sqlcode,"","",1)   #No.FUN-660167
              CANCEL INSERT
           ELSE
              LET l_rec_b = l_rec_b + 1
              MESSAGE 'INSERT O.K'
           END IF
 
       AFTER FIELD oqx04
           IF NOT cl_null(l_oqx[l_ac].oqx04) THEN
              IF( p_cmd='a' AND NOT cl_null(l_oqx[l_ac].oqx03)
                  AND NOT cl_null(l_oqx[l_ac].oqx04) ) OR
                ( p_cmd='u' AND (l_oqx_t.oqx03 !=l_oqx[l_ac].oqx03
                  OR l_oqx_t.oqx04 !=l_oqx[l_ac].oqx04 )) THEN
                  SELECT COUNT(*) INTO l_cnt FROM  oqx_file
                   WHERE oqx01 = g_oqt.oqt01
                     AND oqx03 = l_oqx[l_ac].oqx03
                     AND oqx04 = l_oqx[l_ac].oqx04
                  IF l_cnt > 0  THEN
                     CALL cl_err(l_oqx[l_ac].oqx04,'axm-298',0)
                     NEXT FIELD oqx04
                  END IF
              END IF
              CALL t360_oqx04(l_oqx[l_ac].oqx04,'a') RETURNING l_oaj02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_oqx[l_ac].oqx04,'axm-360',0)
                 NEXT FIELD oqx04
              END IF
              LET l_oqx[l_ac].oaj02 = l_oaj02
           END IF
 
        AFTER FIELD oqx05
           IF NOT cl_null(l_oqx[l_ac].oqx05) THEN 
              IF l_oqx[l_ac].oqx05<0 THEN 
                 CALL cl_err(l_oqx[l_ac].oqx05,'afa-043',0) 
                 NEXT FIELD oqx05 
              END IF
           END IF
 
       AFTER FIELD oqx041
           IF NOT cl_null(l_oqx[l_ac].oqx041) THEN
              CALL t360_oqx041(l_oqx[l_ac].oqx041)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_oqx[l_ac].oqx041,g_errno,0)
                 NEXT FIELD oqx041
              END IF
           END IF
 
       BEFORE DELETE                            #是否取消單身
          IF l_oqx_t.oqx03 > 0 AND l_oqx_t.oqx04 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
 
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
 
             DELETE FROM oqx_file
              WHERE oqx01 = g_oqt.oqt01
                AND oqx03 = l_oqx_t.oqx03
                AND oqx04 = l_oqx_t.oqx04
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","oqx_file",g_oqt.oqt01,l_oqx_t.oqx03,SQLCA.sqlcode,"","",1)   #No.FUN-660167
                ROLLBACK WORK
                CANCEL DELETE
             ELSE
                LET l_rec_b = l_rec_b - 1
             END IF
 
             COMMIT WORK
 
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET l_oqx[l_ac].* = l_oqx_t.*
             CLOSE t360_b4
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(l_oqx[l_ac].oqx03,-263,1)
             LET l_oqx[l_ac].* = l_oqx_t.*
          ELSE
             UPDATE oqx_file SET oqx01=g_oqt.oqt01,
                                 oqx03=l_oqx[l_ac].oqx03,
                                 oqx04=l_oqx[l_ac].oqx04,
                                 oqx041=l_oqx[l_ac].oqx041,
                                 oqx05=l_oqx[l_ac].oqx05,
                                 oqx06=l_oqx[l_ac].oqx06
              WHERE oqx01 = g_oqt.oqt01
                AND oqx03 = l_oqx_t.oqx03
                AND oqx04 = l_oqx_t.oqx04
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","oqx_file",g_oqt.oqt01,l_oqx[l_ac].oqx03,SQLCA.sqlcode,"","",1)   #No.FUN-660167
                LET l_oqx[l_ac].* = l_oqx_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D30034 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET l_oqx[l_ac].* = l_oqx_t.*
              #FUN-D30034--add--str--
              ELSE
                 CALL l_oqx.deleteElement(l_ac)
              #FUN-D30034--add--end--
              END IF
              CLOSE t360_b4
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30034 Add
           CLOSE t360_b4
           COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(oqx04)     #查詢費用
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oaj"
                 LET g_qryparam.default1 = l_oqx[l_ac].oqx04
                 CALL cl_create_qry() RETURNING l_oqx[l_ac].oqx04
                  DISPLAY BY NAME l_oqx[l_ac].oqx04  #No.MOD-480367
                 NEXT FIELD oqx04
              WHEN INFIELD(oqx041)     #查詢幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = l_oqx[l_ac].oqx041
                 CALL cl_create_qry() RETURNING l_oqx[l_ac].oqx041
                  DISPLAY BY NAME l_oqx[l_ac].oqx041  #No.MOD-480367
                 NEXT FIELD oqx041
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
 
    CLOSE t360_b4
    CLOSE WINDOW t360_f4
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t360_oqx04(p_oaj01,p_cmd)  #工作項目
    DEFINE p_oaj01     LIKE oaj_file.oaj01,
           l_oaj02     LIKE oaj_file.oaj02,
           p_cmd       LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT oaj02 INTO l_oaj02 FROM oaj_file
     WHERE oaj01=p_oaj01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-007'
                                   LET l_oaj02   = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_oaj02
END FUNCTION
 
FUNCTION t360_m()    #備註
   IF g_oqt.oqt01 IS NULL THEN
      RETURN
   END IF
 
   LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() OR g_oqt.oqtconf = 'Y' THEN #MOD-4A0079
      LET g_chr='d'
   ELSE
      LET g_chr='u'
   END IF
 
   CALL s_axm_memo(g_oqt.oqt01,0,g_chr)
END FUNCTION
 
FUNCTION t360_y()
DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF cl_null(g_oqt.oqt01) THEN  RETURN   END IF
   SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01=g_oqt.oqt01
   IF g_oqt.oqtconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oqt.oqtconf = 'X' THEN CALL cl_err(g_oqt.oqt01,'9024',0) RETURN END IF
   IF g_oqt.oqt22='Y'   THEN
       IF g_oqt.oqt21 != '1' THEN CALL cl_err('','aws-078',1) RETURN END IF
   END IF
   IF g_oqt.oqtacti='N' THEN CALL cl_err('','mfg0301',1) RETURN END IF
 
#無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM oqu_file
    WHERE oqu01=g_oqt.oqt01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t360_cl USING g_oqt.oqt01
   IF STATUS THEN
      CALL cl_err("OPEN t360_cl:", STATUS, 1)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t360_cl INTO g_oqt.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t360_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
 
   UPDATE oqt_file SET oqtconf='Y' WHERE oqt01=g_oqt.oqt01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
   IF g_oqt.oqt22 = 'N' AND g_oqt.oqt21 = '0' THEN
      LET g_oqt.oqt21 = '1'
      UPDATE oqt_file SET oqt21 = g_oqt.oqt21 WHERE oqt01=g_oqt.oqt01
      IF SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO g_cnt FROM oqu_file
       WHERE oqu01 = g_oqt.oqt01
      IF g_cnt = 0 AND g_oqt.oqt22 = 'Y' THEN
         CALL cl_err(' ','aws-065',0)
         LET g_success = 'N'
      END IF
      IF g_success = 'Y' THEN
         LET g_oqt.oqtconf='Y'
         COMMIT WORK
         CALL cl_flow_notify(g_oqt.oqt01,'Y')
         DISPLAY BY NAME g_oqt.oqtconf
         DISPLAY BY NAME g_oqt.oqt21
      ELSE
         LET g_oqt.oqtconf='N'
         ROLLBACK WORK
      END IF
   ELSE
      ROLLBACK WORK
   END IF
    IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
END FUNCTION
 
FUNCTION t360_y_chk()
 DEFINE l_cnt        LIKE type_file.num5          #No.FUN-680137 SMALLINT
 DEFINE l_gemacti    LIKE gem_file.gemacti        #No.TQC-C60211
 LET g_success = 'Y'
#CHI-C30107 --------------- add --------------------- begin
 IF cl_null(g_oqt.oqt01) THEN
    LET g_success = 'N'  
    RETURN
 END IF
#TQC-C60211 -- add -- begin
 IF NOT cl_null(g_oqt.oqt06) THEN
    SELECT gemacti INTO l_gemacti FROM gem_file
     WHERE gem01 = g_oqt.oqt06
    IF l_gemacti = 'N' THEN
       CALL cl_err(g_oqt.oqt06,'asf-472',0)
       LET g_success = 'N'
       RETURN
    END IF
 END IF
#TQC-C60211 -- add -- end
 IF g_oqt.oqtconf = 'Y' THEN
    CALL cl_err('',9023,0)
    LET g_success = 'N'
    RETURN
 END IF
 IF g_oqt.oqtconf = 'X' THEN
    CALL cl_err(g_oqt.oqt01,'9024',0)
    LET g_success = 'N'   
    RETURN
 END IF
 IF g_oqt.oqtacti='N' THEN
    CALL cl_err('','mfg0301',1)
    LET g_success = 'N'  
    RETURN
 END IF
 IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
    g_action_choice CLIPPED = "insert"       #FUN-640248
 THEN

    IF NOT cl_confirm('axm-108') THEN  LET g_success = 'N' RETURN END IF 
 END IF
#CHI-C30107 --------------- add --------------------- end
 IF cl_null(g_oqt.oqt01) THEN
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01=g_oqt.oqt01
 IF g_oqt.oqtconf = 'Y' THEN
    CALL cl_err('',9023,0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 IF g_oqt.oqtconf = 'X' THEN
    CALL cl_err(g_oqt.oqt01,'9024',0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 IF g_oqt.oqtacti='N' THEN
    CALL cl_err('','mfg0301',1)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
#無單身資料不可確認
 LET l_cnt=0
 SELECT COUNT(*) INTO l_cnt
   FROM oqu_file
  WHERE oqu01=g_oqt.oqt01
 IF l_cnt=0 OR l_cnt IS NULL THEN
    CALL cl_err('','mfg-009',0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF

 #FUN-C40089---begin
 SELECT oah08 INTO g_oah08 FROM oah_file WHERE oah01=g_oqt.oqt10
 IF cl_null(g_oah08) THEN
    LET g_oah08 = 'Y'
 END IF 
 IF g_oah08='N' THEN
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM oqu_file
      WHERE oqu01=g_oqt.oqt01 AND oqu07=0
    IF l_cnt > 0 THEN
       CALL cl_err('','axm-627',1)  #FUN-C50074
       LET g_success = 'N'
       RETURN
    END IF
 END IF
 #FUN-C40089---end
END FUNCTION
 
FUNCTION t360_y_upd()
 
 LET g_success = 'Y'
 IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
    g_action_choice CLIPPED = "insert"       #FUN-640248
 THEN
 
    IF g_oqt.oqt22='Y'   THEN
        IF g_oqt.oqt21 != '1' THEN
           CALL cl_err('','aws-078',1)
           LET g_success = 'N'
           RETURN
        END IF
    END IF
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 END IF
 
 BEGIN WORK
 
 OPEN t360_cl USING g_oqt.oqt01
 IF STATUS THEN
    CALL cl_err("OPEN t360_cl:", STATUS, 1)
    CLOSE t360_cl
    ROLLBACK WORK
    RETURN
 END IF
 
 FETCH t360_cl INTO g_oqt.*          # 鎖住將被更改或取消的資料
 IF SQLCA.sqlcode THEN
    CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
    CLOSE t360_cl ROLLBACK WORK RETURN
 END IF
 
 LET g_success = 'Y'
 
 UPDATE oqt_file SET oqtconf='Y' WHERE oqt01=g_oqt.oqt01
 IF SQLCA.sqlerrd[3]=0 THEN
    LET g_success='N'
 END IF
 IF g_oqt.oqt22 = 'N' AND g_oqt.oqt21 = '0' THEN
    LET g_oqt.oqt21 = '1'
    UPDATE oqt_file SET oqt21 = g_oqt.oqt21 WHERE oqt01=g_oqt.oqt01
    IF SQLCA.sqlerrd[3]=0 THEN
       LET g_success='N'
    END IF
 END IF
 
 IF g_success = 'Y' THEN
    IF g_oqt.oqt22 = 'Y' THEN #簽核模式
       CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
           WHEN 0  #呼叫 EasyFlow 簽核失敗
                LET g_oqt.oqtconf="N"
                LET g_success = "N"
                ROLLBACK WORK
                RETURN
           WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                LET g_oqt.oqtconf="N"
                ROLLBACK WORK
                RETURN
       END CASE
    END IF
 
    SELECT COUNT(*) INTO g_cnt FROM oqu_file
     WHERE oqu01 = g_oqt.oqt01
    IF g_cnt = 0 AND g_oqt.oqt22 = 'Y' THEN
       CALL cl_err(' ','aws-065',0)
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       LET g_oqt.oqt21='1'             #執行成功, 狀態值顯示為 '1' 已核准  #FUN
       UPDATE oqt_file SET oqt21 = g_oqt.oqt21 WHERE oqt01=g_oqt.oqt01
       IF SQLCA.sqlerrd[3]=0 THEN
          LET g_success='N'
       END IF
       LET g_oqt.oqtconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
       DISPLAY BY NAME g_oqt.oqtconf
       DISPLAY BY NAME g_oqt.oqt21
       COMMIT WORK
       CALL cl_flow_notify(g_oqt.oqt01,'Y')
       CALL s_pmista('oqt',g_oqt.oqt21,g_oqt.oqtconf,g_oqt.oqt22) RETURNING g_sta   #No.6686
       DISPLAY g_sta TO FORMONLY.desc2
    ELSE
       LET g_oqt.oqtconf='N'
       ROLLBACK WORK
    END IF
 ELSE
    ROLLBACK WORK
 END IF
  IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
END FUNCTION
 
FUNCTION t360_z() #取消確認
   IF cl_null(g_oqt.oqt01) THEN  RETURN   END IF
   SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01=g_oqt.oqt01
   IF g_oqt.oqtconf = 'N' THEN RETURN END IF
   IF g_oqt.oqtconf = 'X' THEN CALL cl_err(g_oqt.oqt01,'9024',0) RETURN END IF
   IF g_oqt.oqt21 = 'S' THEN
      CALL cl_err(g_oqt.oqt21,'apm-030',1)
      RETURN
   END IF
 
   # 報價單已轉入訂單資料的不能取消確認
   SELECT COUNT(*) INTO l_n FROM oea_file
       WHERE oea12    = g_oqt.oqt01
         AND oea11    = '5' #訂單來源 '5'.報價單轉入
         AND oeaconf  != 'X'
 
   IF l_n >0 THEN
       #報價單已轉入訂單資料的不能取消確認!
       CALL cl_err(g_oqt.oqt01,'axm-007',0)
       RETURN
   END IF
 
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'
 
   IF g_oqt.oqtconf ='Y' THEN
      LET g_oqt.oqtconf='N'
      LET g_oqt.oqt21='0'                #FUN-550022
   END IF
   UPDATE oqt_file SET oqtconf=g_oqt.oqtconf,oqt21=g_oqt.oqt21
    WHERE oqt01=g_oqt.oqt01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_oqt.oqt22 = 'N' AND g_oqt.oqt21 = '1' THEN
      LET g_oqt.oqt21 = '0'
      UPDATE oqt_file SET oqt21 = g_oqt.oqt21 WHERE oqt01=g_oqt.oqt01
      IF SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      LET g_oqt.oqtconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_oqt.oqtconf
      DISPLAY BY NAME g_oqt.oqt21
   ELSE
      ROLLBACK WORK
   END IF
    IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
END FUNCTION
 
FUNCTION t360_s(p_cmd) #地址輸入
    DEFINE  p_cmd      LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    BEGIN WORK
 
    IF p_cmd = 's' THEN  #BugNo:4851
 
       OPEN t360_cl USING g_oqt.oqt01
       IF STATUS THEN
          CALL cl_err("OPEN t360_cl:", STATUS, 1)
          CLOSE t360_cl
          ROLLBACK WORK
          RETURN
       END IF
 
       FETCH t360_cl INTO g_oqt.*          # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
           CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
           CLOSE t360_cl ROLLBACK WORK RETURN
       END IF
    END IF
 
    IF cl_null(g_oqt.oqt01) THEN  RETURN   END IF
    LET p_row = 5 LET p_col = 2
    OPEN WINDOW t360_s AT p_row,p_col WITH FORM "axm/42f/axmt3603"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt3603")
 
 
    DISPLAY BY NAME g_oqt.oqt051,g_oqt.oqt052,g_oqt.oqt053,g_oqt.oqt054,g_oqt.oqt055  #FUN-720014 add oqt055
    IF g_oqt.oqtconf = 'Y' THEN
       CALL cl_err('','axm-101',1)
       CLOSE WINDOW t360_s
       RETURN
    END IF
    IF g_oqt.oqt21 matches '[Ss]' THEN   #FUN-550022
       CALL cl_err('','apm-030',1)
       CLOSE WINDOW t360_s
       RETURN
    END IF
 
    INPUT BY NAME g_oqt.oqt051,g_oqt.oqt052,g_oqt.oqt053,g_oqt.oqt054,g_oqt.oqt055    #FUN-720014 add oqt055
          WITHOUT DEFAULTS
          AFTER INPUT
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
       LET INT_FLAG=0
       CLOSE WINDOW t360_s
       RETURN
    END IF
 
    CLOSE WINDOW t360_s
 
    IF p_cmd = 's' THEN
       UPDATE oqt_file SET oqt051=g_oqt.oqt051,
                           oqt052=g_oqt.oqt052,
                           oqt053=g_oqt.oqt053,
                           oqt054=g_oqt.oqt054,
                           oqt055=g_oqt.oqt055   #FUN-720014 add
        WHERE oqt01=g_oqt.oqt01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0  THEN
          CALL cl_err3("upd","oqt_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","upd_oqt_s",1)   #No.FUN-660167
           ROLLBACK WORK
       ELSE
           COMMIT WORK
       END IF
    END IF
 
END FUNCTION
 
#FUNCTION t360_x()        #FUN-D20025
FUNCTION t360_x(p_type)   #FUN-D20025
   DEFINE l_n LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_oqt.* FROM oqt_file WHERE oqt01=g_oqt.oqt01
   IF g_oqt.oqt01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_oqt.oqtconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_oqt.oqt21 matches '[Ss1]' THEN          #FUN-550022
         CALL cl_err("","mfg3557",0)
         RETURN
    END IF
 
 
   # 報價單已轉入訂單資料的不能作廢
   SELECT COUNT(*) INTO l_n FROM oea_file
       WHERE oea12    = g_oqt.oqt01
         AND oea11    = '5' #訂單來源 '5'.報價單轉入
         AND oeaconf != 'X'
 
   IF l_n >0 THEN
       #報價單已轉入訂單資料的不能作廢!
       CALL cl_err(g_oqt.oqt01,'axm-004',0)
       RETURN
   END IF
   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_oqt.oqtconf='X' THEN RETURN END IF
   ELSE
      IF g_oqt.oqtconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--
 
   BEGIN WORK
 
   OPEN t360_cl USING g_oqt.oqt01
   IF STATUS THEN
      CALL cl_err("OPEN t360_cl:", STATUS, 1)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t360_cl INTO g_oqt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)
      CLOSE t360_cl
      ROLLBACK WORK RETURN
   END IF
 
  #IF cl_void(0,0,g_oqt.oqtconf) THEN   #FUN-D20025
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN         #FUN-D20025
      LET g_chr = g_oqt.oqtconf
     #IF g_oqt.oqtconf = 'N' THEN   #FUN-D20025
      IF p_type = 1 THEN            #FUN-D20025
          LET g_oqt.oqtconf = 'X'
      ELSE
          LET g_oqt.oqtconf = 'N'
          LET g_oqt.oqt21   = '0'   #TQC-B40202 add
      END IF
 
      UPDATE oqt_file SET oqtconf=g_oqt.oqtconf,
                          oqt21=g_oqt.oqt21,     #FUN-550022
                          oqtmodu=g_user,
                          oqtdate=g_today
         WHERE oqt01 = g_oqt.oqt01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","oqt_file",g_oqt.oqt01,"",SQLCA.sqlcode,"","up oqtconf",1)   #No.FUN-660167
         LET g_oqt.oqtconf = g_chr
      END IF
 
      DISPLAY BY NAME g_oqt.oqtconf
   END IF
 
   CLOSE t360_cl
   COMMIT WORK
    IF g_oqt.oqtconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_oqt.oqt21='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")
 
   CALL cl_flow_notify(g_oqt.oqt01,'V')
 
END FUNCTION
 
FUNCTION t360_b_get_price()
  DEFINE l_oah03       LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(1)       #單價取價方式
  DEFINE l_ima131      LIKE type_file.chr20       # No.FUN-680137 VARCHAR(20)      #Product Type
  DEFINE l_occ20       LIKE occ_file.occ20	#MOD-710180 add
  DEFINE l_occ21       LIKE occ_file.occ21	#MOD-710180 add
  DEFINE l_occ22       LIKE occ_file.occ22	#MOD-710180 add
 
  SELECT oah03 INTO l_oah03 FROM oah_file WHERE oah01 = g_oqt.oqt10
  CASE WHEN l_oah03 = '0' RETURN   #人工輸入
       WHEN l_oah03 = '1'          #取產品檔內的訂價
            SELECT ima127 INTO g_oqu[l_ac].oqu07 FROM ima_file   #未稅訂價
             WHERE ima01 = g_oqu[l_ac].oqu03
       WHEN l_oah03 = '2'          #取產品價格檔訂價
            SELECT ima131 INTO l_ima131 FROM ima_file
             WHERE ima01 = g_oqu[l_ac].oqu03
                 SELECT occ20,occ21,occ22 INTO l_occ20,l_occ21,l_occ22 FROM occ_file
                  WHERE occ01=g_oea.oea03
                    AND occacti='Y'
            DECLARE t360_b_get_price_c CURSOR FOR
               SELECT obg21,
                      obg01,obg02,obg03,obg04,obg05,
                      obg06,obg22,obg07,obg08,obg09,obg10           #MOD-710180 add
                 FROM obg_file
                WHERE (obg01 = l_ima131          OR obg01 = '*')
                  AND (obg02 = g_oqu[l_ac].oqu03 OR obg02 = '*')
                  AND (obg03 = g_oqu[l_ac].oqu05               )
                  AND (obg04 = '*'                             )
                  AND (obg05 = g_oqt.oqt10       OR obg05 = '*')
                  AND (obg06 = g_oqt.oqt04       OR obg06 = '*')
                  AND (obg22 = l_occ22           OR obg22 = '*')  #MOD-710180 add
                  AND (obg07 = l_occ21           OR obg07 = '*')  #MOD-710180 add
                  AND (obg08 = l_occ20           OR obg08 = '*')  #MOD-710180 add
                  AND (obg09 = g_oqt.oqt09                     )
                  AND (obg10 = '*'                             )
                ORDER BY 2 DESC,3 DESC,4 DESC,5 DESC,6 DESC,7 DESC,
                         8 DESC,9 DESC,10 DESC,11 DESC               #MOD-710180 modify
            FOREACH t360_b_get_price_c INTO g_oqu[l_ac].oqu07
               IF STATUS THEN CALL cl_err('foreach obg',STATUS,1) END IF
               EXIT FOREACH
            END FOREACH
       WHEN l_oah03 = '3'          #取產品客戶上次訂價
          SELECT obk08 INTO g_oqu[l_ac].oqu07 FROM obk_file
           WHERE obk01 = g_oqu[l_ac].oqu03 AND obk02 = g_oqt.oqt04
             AND obk05 = g_oqt.oqt09
       WHEN l_oah03 = '4'          #依價格表取價
          CALL s_price(g_oqt.oqt02,g_oqt.oqt10,g_oqt.oqt09,' ',
                       g_oqt.oqt04,g_oqu[l_ac].oqu03,g_oqu[l_ac].oqu05,
                       g_oqu[l_ac].oqu06,l_oah03)
          RETURNING g_oqu[l_ac].oqu07
  END CASE
  DISPLAY BY NAME g_oqu[l_ac].oqu07
END FUNCTION

#FUN-BB0085-add-str--
FUNCTION t360_oqu06_check(p_cmd)
DEFINE l_oeb37 LIKE oeb_file.oeb37
DEFINE p_cmd   LIKE type_file.chr1

   IF NOT cl_null(g_oqu[l_ac].oqu05) AND NOT cl_null(g_oqu[l_ac].oqu06) THEN
      IF cl_null(g_oqu05_t) OR cl_null(g_oqu_t.oqu06) OR g_oqu05_t != g_oqu[l_ac].oqu05 OR g_oqu_t.oqu06 != g_oqu[l_ac].oqu06 THEN 
         LET g_oqu[l_ac].oqu06 = s_digqty(g_oqu[l_ac].oqu06,g_oqu[l_ac].oqu05)
         DISPLAY BY NAME g_oqu[l_ac].oqu06
      END IF
   END IF

   IF NOT cl_null(g_oqu[l_ac].oqu06) THEN
      IF g_oqu[l_ac].oqu06 < 0 THEN
         CALL cl_err(g_oqu[l_ac].oqu06,'afa-043',0)
         RETURN FALSE,NULL
      END IF
      IF cl_null(g_oqt.oqt23) THEN
         IF g_oqt.oqt12 = 'N' THEN #分量計價為'N'才需取單價
            IF g_oqu[l_ac].oqu07 =0 OR
              (g_oqu[l_ac].oqu06 != g_oqu_t.oqu06 OR cl_null(g_oqu_t.oqu06)) THEN
               CALL s_fetch_price_new(g_oqt.oqt04,g_oqu[l_ac].oqu03,'',g_oqu[l_ac].oqu05,g_oqt.oqt02,'6',       #FUN-BC0071  #TQC-CA0039 1->6
                    g_plant,g_oqt.oqt09,g_oqt.oqt10,g_oqt.oqt25,g_oqt.oqt01,g_oqu[l_ac].oqu02,
                    g_oqu[l_ac].oqu06,'',p_cmd)
                    RETURNING g_oqu[l_ac].oqu07,l_oeb37
            END IF
         END IF
      END IF
      RETURN TRUE,l_oeb37
   END IF
   RETURN TRUE,NULL
END FUNCTION

FUNCTION t360_oqu09_check()
   IF NOT cl_null(g_oqu[l_ac].oqu10) AND NOT cl_null(g_oqu[l_ac].oqu09) THEN 
      IF cl_null(g_oqu10_t) OR cl_null(g_oqu_t.oqu09) OR g_oqu10_t != g_oqu[l_ac].oqu10 OR g_oqu_t.oqu09 != g_oqu[l_ac].oqu09 THEN 
         LET g_oqu[l_ac].oqu09 = s_digqty(g_oqu[l_ac].oqu09,g_oqu[l_ac].oqu10)
         DISPLAY BY NAME g_oqu[l_ac].oqu09
      END IF
   END IF
   IF NOT cl_null(g_oqu[l_ac].oqu09) THEN
      IF g_oqu[l_ac].oqu09 < 0 THEN
         CALL cl_err(g_oqu[l_ac].oqu09,'afa-043',0)
         RETURN FALSE
      END IF
   END IF   
   RETURN TRUE
END FUNCTION
#FUN-BB0085-add-end--
 
FUNCTION t360_ef()
 
   CALL t360_y_chk()          #CALL 原確認的 check 段
   IF g_success = "N" THEN
       RETURN
   END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
   IF aws_efcli2(base.TypeInfo.create(g_oqt),base.TypeInfo.create(g_oqu),'','','','') THEN
       LET g_success = 'Y'
       LET g_oqt.oqt21 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
       DISPLAY BY NAME g_oqt.oqt21
   ELSE
       LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION t360_set_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done THEN
     IF g_oqt.oqt12 = 'N' THEN
        CALL cl_set_comp_required("oqu06,oqu07",TRUE)
     END IF
  END IF
END FUNCTION
 
FUNCTION t360_set_no_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done THEN
     CALL cl_set_comp_required("oqu06,oqu07",FALSE)
  END IF
END FUNCTION
 
FUNCTION t360_g_b()
DEFINE l_oqu RECORD LIKE oqu_file.*,
       l_oqa RECORD LIKE oqa_file.*,
       l_cnt LIKE type_file.num10,         #No.FUN-680137 INTEGER
       l_rate LIKE oqa_file.oqa09    #No.TQC-7A0056
 
   CALL s_curr3(g_oqt.oqt09,g_oqt.oqt02,g_sma.sma904) #No.TQC-7A0056
   RETURNING l_rate                                   #No.TQC-7A0056
 
   IF cl_null(g_oqt.oqt23) THEN
      RETURN
   END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM oqu_file WHERE oqu01=g_oqt.oqt01
   IF l_cnt>0 THEN
      RETURN
   END IF
   SELECT * INTO l_oqa.* FROM oqa_file WHERE oqa01=g_oqt.oqt23
   INITIALIZE l_oqu.* TO NULL
   LET l_oqu.oqu01=g_oqt.oqt01
   LET l_oqu.oqu02=1
   LET l_oqu.oqu03=l_oqa.oqa03
   LET l_oqu.oqu031=l_oqa.oqa031
   LET l_oqu.oqu032=l_oqa.oqa032
   
 
   SELECT ima31 INTO l_oqu.oqu05 FROM ima_file
                                WHERE ima01=l_oqu.oqu03
   
   IF g_oqt.oqt12 <> 'Y' THEN  #MOD-D50103 add
      LET l_oqu.oqu06=l_oqa.oqa10
      LET l_oqu.oqu06 = s_digqty(l_oqu.oqu06,l_oqu.oqu05)   #FUN-BB0085
      IF l_oqa.oqa10 IS NOT NULL AND l_oqa.oqa10!=0 THEN
         LET l_oqu.oqu07=(l_oqa.oqa17*(l_oqa.oqa09/l_rate))/l_oqa.oqa10   #No.TQC-7A0056
      ELSE
         LET l_oqu.oqu07=0
      END IF
   END IF #MOD-D50103 add
   LET l_oqu.oquplant = g_plant 
   LET l_oqu.oqulegal = g_legal  
 
   INSERT INTO oqu_file VALUES (l_oqu.*)
   CALL t360_b_fill("1=1")
END FUNCTION
 
FUNCTION t360_b_move_to()
   LET g_oqu[l_ac].oqu02  = b_oqu.oqu02 
   LET g_oqu[l_ac].oqu03  = b_oqu.oqu03 
   LET g_oqu[l_ac].oqu04  = b_oqu.oqu04 
   LET g_oqu[l_ac].oqu031 = b_oqu.oqu031
   LET g_oqu[l_ac].oqu032 = b_oqu.oqu032
   LET g_oqu[l_ac].oqu09  = b_oqu.oqu09 
   LET g_oqu[l_ac].oqu10  = b_oqu.oqu10 
   LET g_oqu[l_ac].oqu14  = b_oqu.oqu14 
   LET g_oqu[l_ac].oqu08  = b_oqu.oqu08 
   LET g_oqu[l_ac].oqu05  = b_oqu.oqu05 
   LET g_oqu[l_ac].oqu06  = b_oqu.oqu06 
   LET g_oqu[l_ac].oqu07  = b_oqu.oqu07 
   LET g_oqu[l_ac].oqu11  = b_oqu.oqu11 
   LET g_oqu[l_ac].oqu12  = b_oqu.oqu12 
   LET g_oqu[l_ac].oqu13  = b_oqu.oqu13
 
   LET g_oqu[l_ac].oquud01 = b_oqu.oquud01
   LET g_oqu[l_ac].oquud02 = b_oqu.oquud02
   LET g_oqu[l_ac].oquud03 = b_oqu.oquud03
   LET g_oqu[l_ac].oquud04 = b_oqu.oquud04
   LET g_oqu[l_ac].oquud05 = b_oqu.oquud05
   LET g_oqu[l_ac].oquud06 = b_oqu.oquud06
   LET g_oqu[l_ac].oquud07 = b_oqu.oquud07
   LET g_oqu[l_ac].oquud08 = b_oqu.oquud08
   LET g_oqu[l_ac].oquud09 = b_oqu.oquud09
   LET g_oqu[l_ac].oquud10 = b_oqu.oquud10
   LET g_oqu[l_ac].oquud11 = b_oqu.oquud11
   LET g_oqu[l_ac].oquud12 = b_oqu.oquud12
   LET g_oqu[l_ac].oquud13 = b_oqu.oquud13
   LET g_oqu[l_ac].oquud14 = b_oqu.oquud14
   LET g_oqu[l_ac].oquud15 = b_oqu.oquud15
 
END FUNCTION
 
FUNCTION t360_b_move_back()
   LET b_oqu.oqu01  = g_oqt.oqt01   
   LET b_oqu.oqu02  = g_oqu[l_ac].oqu02  
   LET b_oqu.oqu03  = g_oqu[l_ac].oqu03  
   LET b_oqu.oqu04  = g_oqu[l_ac].oqu04  
   LET b_oqu.oqu031 = g_oqu[l_ac].oqu031 
   LET b_oqu.oqu032 = g_oqu[l_ac].oqu032 
   LET b_oqu.oqu09  = g_oqu[l_ac].oqu09  
   LET b_oqu.oqu10  = g_oqu[l_ac].oqu10  
   LET b_oqu.oqu14  = g_oqu[l_ac].oqu14  
   LET b_oqu.oqu08  = g_oqu[l_ac].oqu08  
   LET b_oqu.oqu05  = g_oqu[l_ac].oqu05  
   LET b_oqu.oqu06  = g_oqu[l_ac].oqu06  
   LET b_oqu.oqu07  = g_oqu[l_ac].oqu07  
   LET b_oqu.oqu11  = g_oqu[l_ac].oqu11  
   LET b_oqu.oqu12  = g_oqu[l_ac].oqu12  
   LET b_oqu.oqu13  = g_oqu[l_ac].oqu13  
   LET b_oqu.oquud01 = g_oqu[l_ac].oquud01
   LET b_oqu.oquud02 = g_oqu[l_ac].oquud02
   LET b_oqu.oquud03 = g_oqu[l_ac].oquud03
   LET b_oqu.oquud04 = g_oqu[l_ac].oquud04
   LET b_oqu.oquud05 = g_oqu[l_ac].oquud05
   LET b_oqu.oquud06 = g_oqu[l_ac].oquud06
   LET b_oqu.oquud07 = g_oqu[l_ac].oquud07
   LET b_oqu.oquud08 = g_oqu[l_ac].oquud08
   LET b_oqu.oquud09 = g_oqu[l_ac].oquud09
   LET b_oqu.oquud10 = g_oqu[l_ac].oquud10
   LET b_oqu.oquud11 = g_oqu[l_ac].oquud11
   LET b_oqu.oquud12 = g_oqu[l_ac].oquud12
   LET b_oqu.oquud13 = g_oqu[l_ac].oquud13
   LET b_oqu.oquud14 = g_oqu[l_ac].oquud14
   LET b_oqu.oquud15 = g_oqu[l_ac].oquud15
 
   LET b_oqu.oquplant = g_plant 
   LET b_oqu.oqulegal = g_legal  
 
END FUNCTION
# No.FUN-9C0073 -------------By chenls 10/01/07 

#CHI-CC0034 add --start--
FUNCTION t360_chk_obe(p_ac)
DEFINE p_ac        LIKE type_file.num5
DEFINE l_obe       RECORD LIKE obe_file.* 
DEFINE l_ima18     LIKE ima_file.ima18 #單位淨重
DEFINE l_ima31     LIKE ima_file.ima31 #銷售單位
DEFINE l_oqu09     LIKE oqu_file.oqu09 
DEFINE l_box1      LIKE type_file.num10    #外包裝整數箱數 
DEFINE l_box1_1    LIKE type_file.num20_6  #外包裝算到小數位的箱數 
DEFINE l_box2      LIKE type_file.num10    #內包裝整數箱數 
DEFINE l_box2_2    LIKE type_file.num20_6  #內包裝算到小數位的箱數 
DEFINE l_flag      LIKE type_file.num5    
DEFINE l_factor    LIKE ima_file.ima31_fac 

   LET g_oqu[p_ac].oqu11=0   #材積
   LET g_oqu[p_ac].oqu12=0   #淨重
   LET g_oqu[p_ac].oqu13=0   #毛重

   IF NOT cl_null(g_oqu[p_ac].oqu14) THEN
      #包裝方式檔
      SELECT * INTO l_obe.* FROM obe_file
       WHERE obe01=g_oqu[p_ac].oqu14
      IF STATUS THEN
         CALL cl_err(g_oqu[p_ac].oqu14,SQLCA.sqlcode,0)
         RETURN FALSE
      ELSE
         IF cl_null(g_oqu[p_ac].oqu09) OR g_oqu[p_ac].oqu09=0 THEN   #包裝數量
            LET l_box1 =1
            LET l_oqu09=1
         ELSE
            SELECT ima18,ima31 INTO l_ima18,l_ima31 FROM ima_file
             WHERE ima01=g_oqu[p_ac].oqu03
            IF STATUS THEN LET l_ima18=0 END IF     #-->單位淨重
            CALL s_umfchk(g_oqu[p_ac].oqu03,g_oqu[p_ac].oqu10,l_ima31)
                 RETURNING l_flag,l_factor
            IF l_flag = '1' THEN
               CALL cl_err('','abm-731',0)
               RETURN FALSE 
            ELSE
              #LET l_oqu09 = g_oqu[p_ac].oqu09 * l_factor
               LET l_oqu09 = g_oqu[p_ac].oqu09 
               LET l_ima18 = l_ima18 * l_factor
            END IF
            #外包裝箱數
            LET l_box1=l_oqu09/l_obe.obe24     #整數的箱數
            LET l_box1_1=l_oqu09/l_obe.obe24   #算到小數位的箱數
            IF l_box1_1-l_box1 >0 THEN LET l_box1=l_box1+1 END IF
            #內包裝箱數
            LET l_box2=l_oqu09/l_obe.obe12     #整數的箱數
            LET l_box2_2=l_oqu09/l_obe.obe12   #算到小數位的箱數
            IF l_box2_2-l_box2 >0 THEN LET l_box2=l_box2+1 END IF
         END IF
 
         #-->材積
         LET g_oqu[p_ac].oqu11=l_box1*l_obe.obe26
 
         #-->淨重
         LET g_oqu[p_ac].oqu12=l_oqu09*l_ima18
 
         #-->毛重=外包裝箱數*外包裝重量+內包裝箱數*內包裝重量+總淨重
         LET g_oqu[p_ac].oqu13=(l_box1*l_obe.obe23)+(l_box2*l_obe.obe13)+g_oqu[p_ac].oqu12
      END IF
   END IF

   DISPLAY BY NAME g_oqu[p_ac].oqu11  
   DISPLAY BY NAME g_oqu[p_ac].oqu12  
   DISPLAY BY NAME g_oqu[p_ac].oqu13 

   RETURN TRUE 
END FUNCTION
#CHI-CC0034 add --end--
