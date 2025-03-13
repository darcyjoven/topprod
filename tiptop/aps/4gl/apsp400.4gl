# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# Pattern name...: apsp400.4gl
# Descriptions...: MDS沖銷作業
# Date & Author..: 2008/04/07 By Mandy #FUN-840008
# Modify.........: 2008/06/23 by duke#FUN-860060
# Modify.........: 2008/07/04 By Mandy #TQC-870006 .使用時距方式1:依時距代號隱藏--暫時不用
# Modify.........: 2008/07/04 By Mandy #FUN-870104 沖銷功能改善(1)add 前期資料放入第1期做控管
#                                                              (2)add 需求量納入方式,增加4:有訂單取訂單;沒訂單取預測
#                                                              (3)add 預測料號納入否
# Modify.........: 2008/08/12 By Mandy #FUN-880044 增加參數,可選擇預測資料抓計劃日期(opc03)小於或大於執行日(vld12)且最靠近者
# Modify.........: 2008/08/22 By Mandy #TQC-880041 允許預測料號做沖銷時,預測料號ima133設成和ima01一樣,預測資料未被抓入,做沖銷
# Modify.........: 2008/09/15 By Mandy #FUN-890055 MDS沖銷功能加強
# Modify.........: 2008/09/30 By Mandy #TQC-890061 MDS沖銷BUG-(1)計畫基準日欄位沒有經過enter,則此欄位則無作用
# Modify.........: 2008/09/30 By Mandy #TQC-890061 MDS沖銷BUG-(2)以預測為主時,獨立性需求及零期資料也應一併納進來,只要在資料日期範圍內的獨立性需求都要納入,跟需求納入方式沒有關係
# Modify.........: 2008/09/30 By Mandy #TQC-890061 MDS沖銷BUG-(3)獨立需求及零期資料在沖銷狀況請顯示3.直接納入
# Modify.........: 2008/10/02 By Mandy #FUN-8A0011 限定版本功能
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:FUN-940001 09/04/03 BY DUKE 需求納入方式加入訂單期數之選項
# Modify.........: No:FUN-940064 09/04/17 By Duke 調整嚴守交期
# Modify.........: No:CHI-940034 09/05/12 By Duke 因vld17固定為1,故可mark掉部份程式段
# Modify.........: No:TQC-990139 09/09/25 By Mandy l_vld12b,l_vld12e 日期抓錯
# Modify.........: No:FUN-9C0010 09/12/07 By Mandy 程式筆誤,應抓oeb16才對
# Modify.........: NO:FUN-A30080 10/03/24 BY Lilan 獨立需求納入資料時rpc131為NULL的資料不會被納入
# Modify.........: No.FUN-A60068 10/06/24 By Mandy 
#                                                 (1)沖銷時,預測與訂單沖銷時,直接與訂單量做沖銷 (不以淨需求沖銷[訂單量-出貨量])
#                                                 (2)需求量納入方式改為需求納入方式,僅在兩者取其大時,有沖銷關係
#                                                 (3)訂單資料僅考慮未結案條件
#Modify.........: No.FUN-A80049 10/08/16 By Mandy
#                                                 1.改用「計劃基準日」來判斷預測訂單的計畫日期
#                                                              (1)輸入日期可不需要介於資料日期範圍內
#                                                              (2)計劃基準日後面的實際計劃基準日欄位需做隱藏
#                                                              (3)計劃基準日名稱調整為「預測計劃基準日」
#                                                              (4)計劃基準日與預測計劃日期比對時，邏輯改成先撈取 計劃日期(opc03) <=預測計劃基準日 最接近者
#                                                                                        但無資料時，則自動改抓  計劃日期(opc03) > 預測計劃基準日 最接近者
#                                                 2.改用「資料日期範圍的起始日」用來判斷時距的第一期 
#                                                             EX: 資料日期範圍為 2010/07/01~2010/07/31
#                                                                 07/01的歸屬時距日為06/28(一)，但訂單資料撈取範圍是從6/28~07/31
#                                                                 07/01的歸屬時距日為06/28(一)，但預測的資料撈取範圍是從07/01~07/31
#                                                 3.當需求納入方式選擇: 1:依時距代號時,要從資料起始日開始做時距切割
#                                                 4.前期資料: 資料起始日之前的未結案且未交量>'0'的訂單也要納進需求訂單檔
#                                                 5.當期訂單資料日期範圍從資料起始日的歸屬時距日~資料結束日
#                                                   當期預測資料日期範圍從資料起始日            ~資料結束日
#Modify.........: No.FUN-A80075 10/08/20 By Mandy 將欄位base_date 隱藏
#Modify.........: No.FUN-AB0090(1) 10/11/26 By Mandy 取預測資料規則調整同amsp500:
#                                                 原本方式:(1)先抓l_max_opc03 => MAX(計劃日期) <= 預測計劃基準日
#                                                          (2)再  抓出opc_file==>SELECT opc01,opc02,MAX(opc03),opc04 where 計劃日期=l_max_opc03
#                                                 改成    :省略步驟(1),
#                                                          (2)直接抓出opc_file==>SELECT opc01,opc02,MAX(opc03),opc04 where 計劃日期<=預測計劃基準日(vld18) 的資料
#Modify.........: No.FUN-AB0090(2) 10/12/01 By Mandy 加入優先序功能
#Modify.........: No.TQC-AC0226 因FUN-AB0090的調整,導致vmu25的值不正確
#Modify.......... No.TQC-AC0270 (1)當優先序內有選擇"交期"時,無法產生vmu_file
#                               (2)當優先序內選擇"4:需求形式",需求形式為"F:預測",則排序顛倒=>應是"F:預測的在前","R:訂單:"的在後才對
#Modify.........: No.FUN-B10070 取預測資料規則:
#                               一律是先抓         『計劃日期(opc03) ＜＝ 預測計劃基準日(vld18)』最靠近者,
#                               但無資料時,自動改抓『計劃日期(opc03) ＞   預測計劃基準日(vld18)』最靠近者
#Modify.........: No.FUN-B50022 11/05/10 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
#Modify.........: NO.FUN-B60063 11/07/31 By Mandy MDS效率優化
#Modify.........: No.FUN-B70026 11/08/25 By Abby  FORECASE 會用到的序號放大到六碼
#Modify.........: No.FUN-BA0036 11/11/29 By Mandy 合約訂單以淨需求沖銷,一般訂單以訂單量沖銷,
#                                                 但是當銷售訂單納入否vld07='N'時(僅勾選合約訂單時,合約訂單以合約訂單量沖銷)
#Modify.........: No.FUN-BB0085 11/12/22 By xianghui 增加數量欄位小數取位
#Modify.........: No.TQC-C40213 12/04/23 By SunLM 如果走出貨簽收,已經簽收的要扣掉
#Modify.........: No.MOD-C80107 12/08/15 By SunLM vlz70增加開窗
#Modify.........: No.FUN-D10051 13/01/11 By Mandy vloplant,vlolegal未塞值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_vlz70          LIKE vlz_file.vlz70    #FUN-8A0011 add
DEFINE g_msp01          RECORD LIKE vld_file.* #FUN-890055 add
DEFINE g_base_date      LIKE type_file.dat     #FUN-890055 add
DEFINE g_base_buk_date  LIKE type_file.dat     #FUN-890055 add
DEFINE g_vld_t          RECORD LIKE vld_file.* #FUN-890055 add
DEFINE g_vld            RECORD LIKE vld_file.* #FUN-840008
DEFINE g_vlo            RECORD LIKE vlo_file.* #FUN-AB0090 add
DEFINE g_vle            RECORD LIKE vle_file.*
DEFINE g_vlf            RECORD LIKE vlf_file.*
DEFINE g_vmu            RECORD LIKE vmu_file.*
DEFINE g_rpg01          LIKE rpg_file.rpg01     # Bucket code
DEFINE g_sql            STRING  
DEFINE g_sql_limited    STRING  #FUN-8A0011
DEFINE g_count          LIKE type_file.num5     
DEFINE g_cnt            LIKE type_file.num5     
DEFINE i,j,k            LIKE type_file.num10   
DEFINE g_argv1          LIKE mps_file.mps_v    
DEFINE g_err_cnt        LIKE type_file.num10   
DEFINE g_before_input_done   STRING
DEFINE g_i              LIKE type_file.num5   #count/index for any purpose
DEFINE g_msg            LIKE type_file.chr1000 
DEFINE past_date        LIKE type_file.dat      
DEFINE bdate,edate      LIKE type_file.dat      
DEFINE g_pri            LIKE vmu_file.vmu10  #優先順序
DEFINE g_seq            LIKE type_file.num10  #FORECASE 會用到的序號
DEFINE l_vld12b         LIKE vld_file.vld12   #FUN-940001 ADD   時距起始日
DEFINE l_vld12e         LIKE vld_file.vld12   #FUN-940001 ADD   時距截止日

#==>MDS 沖銷資料來源/結果暫存檔用的變數----------str----
DEFINE g_tmp      RECORD                                                  #訂單/合約                #獨立需求       #預測
                         tmp01   LIKE  vle_file.vle03, #料號              #oeb04                    #rpc01          #opd01
                         tmp02   LIKE  vle_file.vle04, #歸屬時距日        #                         #               #
                         tmp03   LIKE  vle_file.vle08, #需求日期          #oeb15,oeb16              #rpc12          #opd06
                        #tmp04   LIKE  vle_file.vle09, #淨需求            #oeb12-oeb24+oeb25-oeb26  #rpc13-rpc131   #opd08,opd09 #FUN-A60068 mark
                         tmp04   LIKE  vle_file.vle09, #訂單量            #oeb12                    #rpc13          #opd08,opd09 #FUN-A60068 add
                         tmp041  LIKE  vle_file.vle09, #數量(vmu24)       #oeb12                    #rpc13          #opd08,opd09
                         tmp042  LIKE  vle_file.vle09, #已出貨量(vmu13)   #oeb24-oeb25+oeb26        #rpc131         #0    
                         tmp05   LIKE  vle_file.vle11, #單據編號          #oeb01                    #rpc02          #FORECAST
                         tmp06   LIKE  vle_file.vle12, #項次              #oeb03                    #rpc03          #opd05
                         tmp07   LIKE  vle_file.vle13, #單據開立日期      #oea02                    #rpc21          #opd03
                         tmp08   LIKE  vle_file.vle14, #客戶編號          #oea03                    #NULL           #opd02
                         tmp09   LIKE  vle_file.vle15, #業務員            #oea14                    #NULL           #opd04
                         tmp10   LIKE  vle_file.vle16, #需求來源型式      #0/1                      #2              #3    #(0:一般訂單 1:合約訂單 2:獨立需求 3:預測)
                         tmp11   LIKE  vle_file.vle06, #時距內最大納入量
                         tmp12   LIKE  vle_file.vle06, #沖銷結果(>0 :表餘量 <0 不足)
                         tmp13   LIKE  vle_file.vle10, #單位
                         tmp14   LIKE  vle_file.vle14, #餘量否
                         tmp15   LIKE  vle_file.vle12, #序號
                         tmp16   LIKE  vle_file.vle03, #預測料號 #FUN-870104 add
                         tmp17   LIKE  vle_file.vle16  #需求型式('R'=>tmp10 in ('0','1','2'); 'F'=>tmp10 in ('3') #TQC-AC0226
                      END RECORD
#==>MDS 沖銷資料來源/結果暫存檔用的變數----------end----
DEFINE g_req_tmp     RECORD                                               #訂單/合約                #獨立需求       #預測
                         tmp01   LIKE  vle_file.vle03, #料號              #oeb04                    #rpc01          #opd01
                         tmp02   LIKE  vle_file.vle04, #歸屬時距日        #                         #               #
                         tmp03   LIKE  vle_file.vle08, #需求日期          #oeb15,oeb16              #rpc12          #opd06
                        #tmp04   LIKE  vle_file.vle09, #淨需求            #oeb12-oeb24+oeb25-oeb26  #rpc13-rpc131   #opd08,opd09 #FUN-A60068 mark
                         tmp04   LIKE  vle_file.vle09, #訂單量            #oeb12                    #rpc13          #opd08,opd09 #FUN-A60068 add
                         tmp041  LIKE  vle_file.vle09, #數量(vmu24)       #oeb12                    #rpc13          #opd08,opd09
                         tmp042  LIKE  vle_file.vle09, #已出貨量(vmu13)   #oeb24-oeb25+oeb26        #rpc131         #0    
                         tmp05   LIKE  vle_file.vle11, #單據編號          #oeb01                    #rpc02          #FORECAST
                         tmp06   LIKE  vle_file.vle12, #項次              #oeb03                    #rpc03          #opd05
                         tmp07   LIKE  vle_file.vle13, #單據開立日期      #oea02                    #rpc21          #opd03
                         tmp08   LIKE  vle_file.vle14, #客戶編號          #oea03                    #NULL           #opd02
                         tmp09   LIKE  vle_file.vle15, #業務員            #oea14                    #NULL           #opd04
                         tmp10   LIKE  vle_file.vle16, #需求來源型式      #0/1                      #2              #3    #(0:一般訂單 1:合約訂單 2:獨立需求 3:預測)
                         tmp11   LIKE  vle_file.vle06, #時距內最大納入量
                         tmp12   LIKE  vle_file.vle06, #沖銷結果(>0 :表餘量 <0 不足)
                         tmp13   LIKE  vle_file.vle10, #單位
                         tmp14   LIKE  vle_file.vle14, #餘量否
                         tmp15   LIKE  vle_file.vle12, #序號
                         tmp16   LIKE  vle_file.vle03, #預測料號 #FUN-870104 add
                         tmp17   LIKE  vle_file.vle16  #需求型式('R'=>tmp10 in ('0','1','2'); 'F'=>tmp10 in ('3') #TQC-AC0226
                      END RECORD
DEFINE g_for_tmp  RECORD                                                  #訂單/合約                #獨立需求       #預測
                         tmp01   LIKE  vle_file.vle03, #料號              #oeb04                    #rpc01          #opd01
                         tmp02   LIKE  vle_file.vle04, #歸屬時距日        #                         #               #
                         tmp03   LIKE  vle_file.vle08, #需求日期          #oeb15,oeb16              #rpc12          #opd06
                        #tmp04   LIKE  vle_file.vle09, #淨需求            #oeb12-oeb24+oeb25-oeb26  #rpc13-rpc131   #opd08,opd09 #FUN-A60068 mark
                         tmp04   LIKE  vle_file.vle09, #訂單量            #oeb12                    #rpc13          #opd08,opd09 #FUN-A60068 add
                         tmp041  LIKE  vle_file.vle09, #數量(vmu24)       #oeb12                    #rpc13          #opd08,opd09
                         tmp042  LIKE  vle_file.vle09, #已出貨量(vmu13)   #oeb24-oeb25+oeb26        #rpc131         #0    
                         tmp05   LIKE  vle_file.vle11, #單據編號          #oeb01                    #rpc02          #FORECAST
                         tmp06   LIKE  vle_file.vle12, #項次              #oeb03                    #rpc03          #opd05
                         tmp07   LIKE  vle_file.vle13, #單據開立日期      #oea02                    #rpc21          #opd03
                         tmp08   LIKE  vle_file.vle14, #客戶編號          #oea03                    #NULL           #opd02
                         tmp09   LIKE  vle_file.vle15, #業務員            #oea14                    #NULL           #opd04
                         tmp10   LIKE  vle_file.vle16, #需求來源型式      #0/1                      #2              #3    #(0:一般訂單 1:合約訂單 2:獨立需求 3:預測)
                         tmp11   LIKE  vle_file.vle06, #時距內最大納入量
                         tmp12   LIKE  vle_file.vle06, #沖銷結果(>0 :表餘量 <0 不足)
                         tmp13   LIKE  vle_file.vle10, #單位
                         tmp14   LIKE  vle_file.vle14, #餘量否
                         tmp15   LIKE  vle_file.vle12, #序號
                         tmp16   LIKE  vle_file.vle03, #預測料號 #FUN-870104 add
                         tmp17   LIKE  vle_file.vle16  #需求型式('R'=>tmp10 in ('0','1','2'); 'F'=>tmp10 in ('3') #TQC-AC0226
                      END RECORD
#FUN-AB0090---add----str--
DEFINE g_order1        STRING                                                   
DEFINE g_order2        STRING                                                   
DEFINE g_order3        STRING                                                   
#FUN-AB0090---add----end--
DEFINE g_vlz            RECORD LIKE vlz_file.* #FUN-9C0125 add #FUN-B50022 add
DEFINE g_max_sum      LIKE   vle_file.vle06 #FUN-B60063 add

MAIN
   DEFINE   p_row,p_col LIKE type_file.num5     

   #FUN-B50022---mod---str---
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   #FUN-B50022---mod---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 2 LET p_col = 23
   OPEN WINDOW p400_w AT p_row,p_col
        WITH FORM "aps/42f/apsp400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL p400_def_form()    #FUN-9C0125 add #FUN-B50022 add
  #CALL cl_set_comp_visible("vld14",FALSE) #TQC-870006          #FUN-890055 mark
   CALL cl_set_comp_visible("group1_2,vld15,vld16,vld17",FALSE) #FUN-890055 add
   CALL cl_set_comp_visible("base_date",FALSE)                  #FUN-A80075 add #實際計劃基準日欄位需做隱藏
   CALL cl_set_comp_entry("vld19",FALSE)  #FUN-940001  ADD
   LET  g_vld.vld19 = NULL  #FUN-940001 ADD
   LET bdate   =NULL
   LET edate   =NULL

   WHILE TRUE
      CALL p400_ask() #輸入執行apsp400條件
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
      CALL cl_wait()
      #FUN-890055---add----str---
      DISPLAY g_base_date TO FORMONLY.base_date
      IF g_base_date > g_vld.vld03 THEN
          LET g_base_buk_date = g_base_date
      ELSE
          LET g_base_buk_date = g_vld.vld03
      END IF
      #FUN-890055---add----end---
      CALL p400() 
      ERROR ''
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      CALL cl_end(0,0)
      EXIT WHILE
   END WHILE
   CLOSE WINDOW p400_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
#------------------------------------------------------------------------------------------------------
#測試範例:
#CCCCCC前期資料(oeb15 or oeb16)C
#                               AAAAAAAAAAAAAAAAAAAAAA訂單(oeb15 or oeb16)AAAAAAAAAAAAAA
#                                                      BBBBBBBBBBBBBB預測(opd06)BBBBBBBB
#-------------------------------*----------------------*-------------------------------*---------------
#                               *                      *                               *
#                            g_base_date             vld03                           vld04
#                             06/28                  07/01                           07/31
#                               *=>7/1的歸屬時距日
#
#資料日期範圍      :07/01~07/31
#07/01的歸屬時距日 :06/28(使用時距為3:週)
#前期未結案訂單    :指 06/28 之前的資料(不含6/28)
#訂單資料撈取範圍  :06/28~07/31
#預測資料撈取範圍  :07/01~07/31
#當需求納入方式選擇: 1:依時距代號時,切割時距的起始日為:07/01
#------------------------------------------------------------------------------------------------------

FUNCTION p400()
   CALL p400_ins_vld()          # INSERT MDS沖銷條件記錄檔(vld_file)
   CALL p400_ins_vlo()          # INSERT MDS沖銷排序條件記錄檔(vlo_file) #FUN-AB0090 add
   CALL p400_cre_tmp()          # 建立本程式所有會用到的TEMP TABLE 
  #CALL p400_c_buk_tmp()        # 產生時距檔                       #FUN-890055 mark
   CALL p400_del()              # 將原資料(vmu_file/vle_file/vlf_file)清除
   CALL p400_c_mds_tmp()        # 產生MDS沖銷來源資料暫存檔
   CALL p400_c_mds_result_tmp() # 產生MDS沖銷結果暫存檔
   CALL p400_add_0_period()     # Prog. Version..: '5.30.06-13.03.12(0期)資料納入MDS沖銷結果暫存檔    #FUN-890055 add
   CALL p400_add_rpc()          # 將獨立性需求的資料納入MDS沖銷結果暫存檔 #FUN-890055 add
   CALL p400_ins_mds()          # 產生APS需求訂單檔(vmu_file)/MDS沖銷關聯檔(vle_file)
  #CALL p400_ins_vlf()          # 產生MDS沖銷關聯檔(vlf_file) #FUN-B60063 mark
END FUNCTION

FUNCTION p400_ask()
  DEFINE l_period  LIKE  type_file.num5   #TQC-990139 add
  DEFINE l_cnt LIKE type_file.num5     
  DEFINE l_dd  LIKE type_file.num5     #FUN-890055 add

  LET g_vld.vld03 = g_today
  LET g_vld.vld04 = g_today
  LET g_vld.vld05 = '1'
  LET g_vld.vld06 = '3'
  LET g_vld.vld07 = 'Y'
  LET g_vld.vld08 = 'Y'
  LET g_vld.vld09 = 'Y'
  LET g_vld.vld10 = '3'  
  LET g_vld.vld11 = '2'
  LET g_vld.vld17 = '1' #FUN-880044 add
  LET g_vld.vld12 = g_today
  #FUN-870104 add--str--
  LET g_vld.vld15 = 'Y' #FUN-890055 mod
  LET g_vld.vld16 = 'Y' #FUN-890055 mod
  LET g_vld.vld18 = NULL#TQC-890061 add
  INITIALIZE g_vld_t.* TO NULL #FUN-890055 add
  #FUN-870104 add--end--
  LET g_vlz70 = NULL                #FUN-8A0011 add
  #FUN-AB0090---add----str---
  LET g_vlo.vlo03 = '1'  
  LET g_vlo.vlo04 = '2'  
  LET g_vlo.vlo05 = '3'  
  LET g_vlo.vlo06 = ''  
  #FUN-AB0090---add----end---
  LET g_vlz.vlz70 = NULL #FUN-B50022 add
 #DISPLAY g_vlz70 TO FORMONLY.vlz70 #FUN-8A0011 add #FUN-B50022

  DISPLAY BY NAME g_vld.vld01,g_vld.vld02,g_vlz.vlz70, #FUN-B50022 add vlz70
                  g_vld.vld03,
                  g_vld.vld04,g_vld.vld05,g_vld.vld06,g_vld.vld14,g_vld.vld18, #FUN-890055 add vld18
                  g_vld.vld10,g_vld.vld11,g_vld.vld17,g_vld.vld12,             #FUN-880044 add vld17
                  g_vld.vld07,g_vld.vld08,g_vld.vld09,
                  g_vld.vld15,g_vld.vld16 #FUN-870104 add
  DISPLAY BY NAME g_vlo.vlo03,g_vlo.vlo04,g_vlo.vlo05,g_vlo.vlo06 #FUN-AB0090 add
                  

  INPUT BY NAME g_vld.vld01,g_vld.vld02,g_vlz.vlz70, #FUN-B50022 add vlz70
                g_vld.vld03,
                g_vld.vld04,g_vld.vld05,g_vld.vld06,g_vld.vld14,g_vld.vld18,   #FUN-890055 add vld18
                g_vld.vld10,
                g_vld.vld19,   #FUN-940001  ADD
                g_vld.vld11,g_vld.vld17,                           #FUN-880044 add vld17
                g_vld.vld07,g_vld.vld08,g_vld.vld09,
                g_vld.vld15,g_vld.vld16,#FUN-870104 add
                g_vlo.vlo03,g_vlo.vlo04,g_vlo.vlo05,g_vlo.vlo06    #FUN-AB0090 add vlo03,vlo04,vlo05,vlo06
                WITHOUT DEFAULTS
     BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL p400_set_entry()
          CALL p400_set_no_entry()
          CALL p400_set_no_required()
          CALL p400_set_required()
          LET g_before_input_done = TRUE
      #FUN-B50022---add---str---
      AFTER FIELD vlz70
         IF NOT cl_null(g_vlz.vlz70) THEN
             CALL p400_vlz70()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_vlz.vlz70,g_errno,1)
                LET g_vlz.vlz70 = NULL
                DISPLAY BY NAME g_vlz.vlz70
                NEXT FIELD vlz70
             END IF
         END IF
      #FUN-B50022---add---end---
     AFTER FIELD vld01
         IF NOT cl_null(g_vld.vld01) THEN
             IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN #FUN-9C0125 add if判斷 #FUN-B50022 add
                 SELECT count(*) INTO l_cnt 
                   FROM vlz_file
                  WHERE vlz01 = g_vld.vld01
                 IF l_cnt <=0 THEN
                     CALL cl_err('','aic-004',1)
                     NEXT FIELD vld01
                 END IF
             END IF #FUN-B50022 add
         END IF
     AFTER FIELD vld02
         IF NOT cl_null(g_vld.vld01) AND NOT cl_null(g_vld.vld02) THEN
             IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN #FUN-9C0125 add if判斷 #FUN-B50022 add
                 SELECT count(*) INTO l_cnt 
                   FROM vlz_file
                  WHERE vlz01 = g_vld.vld01
                    AND vlz02 = g_vld.vld02
                 IF l_cnt <=0 THEN
                     CALL cl_err('','aic-004',1)
                     NEXT FIELD vld02
                 END IF
             END IF #FUN-B50022 add
             #FUN-8A0011--add----str---
             SELECT vlz70 INTO g_vlz70
               FROM vlz_file
              WHERE vlz01 = g_vld.vld01
                AND vlz02 = g_vld.vld02
             LET g_vlz.vlz70 = g_vlz70 #FUN-B50022 add
            #DISPLAY g_vlz70 TO FORMONLY.vlz70                  #FUN-B50022 mark
             DISPLAY BY NAME g_vlz.vlz70       #FUN-9C0125 add  #FUN-B50022 add
             #FUN-8A0011--add----end---
            
             SELECT * INTO g_vld.*
               FROM vld_file
              WHERE vld01 = g_vld.vld01
                AND vld02 = g_vld.vld02
            #IF cl_null(g_vld.vld15) THEN LET g_vld.vld15 = 'N' END IF #FUN-870104 add #FUN-890055 mark
            #IF cl_null(g_vld.vld16) THEN LET g_vld.vld16 = 'N' END IF #FUN-870104 add #FUN-890055 mark
             LET g_vld.vld15 = 'Y'  #FUN-890055 add
             LET g_vld.vld16 = 'Y'  #FUN-890055 add
             LET g_vld.vld17 = '1'  #FUN-890055 add
             DISPLAY BY NAME g_vld.vld03,
                             g_vld.vld04,g_vld.vld05,g_vld.vld06,g_vld.vld14,g_vld.vld18,#FUN-890055 add vld18
                             g_vld.vld10,
                             g_vld.vld19,  #FUN-940001 ADD  
                             g_vld.vld11,g_vld.vld17,      #FUN-880044 add vld17
                             g_vld.vld07,g_vld.vld08,g_vld.vld09,g_vld.vld15,g_vld.vld16 #FUN-870104 mod
             #FUN-AB0090--add----str---
             INITIALIZE g_vlo.* TO NULL 
             SELECT * INTO g_vlo.*
               FROM vlo_file
              WHERE vlo01 = g_vld.vld01
                AND vlo02 = g_vld.vld02
             IF cl_null(g_vlo.vlo03) THEN
                 LET g_vlo.vlo03 = '1'  
                 LET g_vlo.vlo04 = '2'  
                 LET g_vlo.vlo05 = '3'  
                 LET g_vlo.vlo06 = ''  
             END IF
             DISPLAY BY NAME g_vlo.vlo03,g_vlo.vlo04,g_vlo.vlo05,g_vlo.vlo06
             #FUN-AB0090--add----end---
            
         END IF

     BEFORE FIELD vld06
        CALL p400_set_entry()
        CALL p400_set_no_required()
     #FUN-890055---add----str---
     AFTER FIELD vld03
        IF NOT cl_null(g_vld.vld03) THEN
            IF NOT cl_null(g_vld.vld04) THEN
                IF g_vld.vld04 < g_vld.vld03 THEN
                    #起始日期不可大於截止日期, 請重新輸入!!!
                    CALL cl_err('','mfg6164',1)
                    LET g_vld.vld03 = NULL
                    LET g_vld.vld04 = NULL
                    DISPLAY BY NAME g_vld.vld03,g_vld.vld04
                    NEXT FIELD vld03
                END IF
            END IF
            IF NOT cl_null(g_vld.vld06) AND NOT cl_null(g_vld.vld04) THEN
               IF cl_null(g_vld_t.vld03) OR g_vld.vld03 <> g_vld_t.vld03 THEN
                   IF g_vld.vld06 = '1' THEN
                       IF NOT cl_null(g_vld.vld14) THEN
                           CALL p400_c_buk_tmp()       # 產生時距檔
                       END IF
                   ELSE
                       CALL p400_c_buk_tmp()       # 產生時距檔
                   END IF
               END IF
            END IF
        END IF
        LET g_vld_t.vld03 = g_vld.vld03 
     #FUN-890055---add----end---
     AFTER FIELD vld04
        IF NOT cl_null(g_vld.vld04) THEN
            IF NOT cl_null(g_vld.vld03) THEN
                IF g_vld.vld04 < g_vld.vld03 THEN
                    #截止日期不可小於起始日期，請重新輸入
                    CALL cl_err('','agl-031',1)
                    LET g_vld.vld04 = NULL
                    DISPLAY BY NAME g_vld.vld04
                    NEXT FIELD vld03
                END IF
            END IF
            #FUN-890055---add---str---
            IF NOT cl_null(g_vld.vld06) AND NOT cl_null(g_vld.vld03) THEN
               IF cl_null(g_vld_t.vld04) OR g_vld.vld04 <> g_vld_t.vld04 THEN
                   IF g_vld.vld06 = '1' THEN
                       IF NOT cl_null(g_vld.vld14) THEN
                           CALL p400_c_buk_tmp()       # 產生時距檔
                       END IF
                   ELSE
                       CALL p400_c_buk_tmp()       # 產生時距檔
                   END IF
               END IF
            END IF
            #FUN-890055---add---end---
        END IF
        LET g_vld_t.vld04 = g_vld.vld04 #FUN-890055 add
     AFTER FIELD vld06
        CALL p400_set_no_entry()
        CALL p400_set_required()
        #FUN-890055---add---str---
        IF NOT cl_null(g_vld.vld06) AND NOT cl_null(g_vld.vld03) AND NOT cl_null(g_vld.vld04) THEN
           IF cl_null(g_vld_t.vld06) OR g_vld.vld06 <> g_vld_t.vld06 THEN
               IF g_vld.vld06 = '1' THEN
                   IF NOT cl_null(g_vld.vld14) THEN
                       CALL p400_c_buk_tmp()       # 產生時距檔
                   END IF
               ELSE
                   CALL p400_c_buk_tmp()       # 產生時距檔
               END IF
           END IF
        END IF
        LET g_vld_t.vld06 = g_vld.vld06
        #FUN-890055---add---end---
     AFTER FIELD vld14
        IF NOT cl_null(g_vld.vld14) THEN
           SELECT * FROM rpg_file 
            WHERE rpg01 = g_vld.vld14
              AND rpgacti = 'Y'
           IF STATUS THEN
              CALL cl_err('sel rpg1',STATUS,1) 
              NEXT FIELD vld14
           END IF
           IF NOT cl_null(g_vld.vld06) AND NOT cl_null(g_vld.vld03) AND NOT cl_null(g_vld.vld04) THEN
              IF cl_null(g_vld_t.vld14) OR g_vld.vld14 <> g_vld_t.vld14 THEN
                  CALL p400_c_buk_tmp()       # 產生時距檔
              END IF
           END IF
        END IF
        LET g_vld_t.vld14 = g_vld.vld14

     #FUN-940001 ADD   --STR--
     AFTER FIELD vld10
        IF g_vld.vld10 = 5 THEN
           LET  g_vld.vld19 = 1
           DISPLAY BY NAME g_vld.vld19
           CALL cl_set_comp_entry("vld19",TRUE)  
           CALL cl_set_comp_required("vld19",TRUE)
        ELSE
           LET g_vld.vld19 = NULL 
           DISPLAY BY NAME g_vld.vld19
           CALL cl_set_comp_entry("vld19",FALSE)
           CALL cl_set_comp_required("vld19",FALSE) 
        END IF

     AFTER FIELD vld19
        IF NOT cl_null(g_vld.vld19) THEN
           IF g_vld.vld19 < 0 THEN #TQC-990139 mod
              CALL cl_err('','aec-992',1) #此欄位不可為負數
              NEXT FIELD vld19
           END IF
        END IF
     #FUN-940001  ADD    --END--

     #FUN-890055---add----str----
     BEFORE FIELD vld18
        IF cl_null(g_vld.vld18) THEN
           #LET g_vld.vld18 = g_vld.vld03 #FUN-A80049 mark
            LET g_vld.vld18 = g_today     #FUN-A80049 add 改預設當天
            DISPLAY BY NAME g_vld.vld18
        END IF
     AFTER FIELD vld18
       #FUN-A80049 mark---str---
       #(1)預測計劃基準日不需要介於資料日期範圍內
       #(2)g_base_date改用資料日期的起始日
       #IF NOT cl_null(g_vld.vld18) THEN
       #    IF NOT cl_null(g_vld.vld03) THEN
       #        IF g_vld.vld18 < g_vld.vld03 THEN
       #            #計劃基準日需在資料日期範圍內!
       #            CALL cl_err('','aps-026',1)
       #            LET g_vld.vld18 = NULL
       #            DISPLAY BY NAME g_vld.vld18
       #            NEXT FIELD vld18
       #        END IF
       #    END IF
       #    IF NOT cl_null(g_vld.vld04) THEN
       #        IF g_vld.vld18 > g_vld.vld04 THEN
       #            #計劃基準日需在資料日期範圍內!
       #            CALL cl_err('','aps-026',1)
       #            LET g_vld.vld18 = NULL
       #            DISPLAY BY NAME g_vld.vld18
       #            NEXT FIELD vld18
       #        END IF
       #    END IF
       #    SELECT plan_date INTO g_base_date
       #      FROM buk_tmp
       #     WHERE real_date = g_vld.vld18
       #    DISPLAY g_base_date TO FORMONLY.base_date
       #END IF
       #FUN-A80049 mark---end---
     #FUN-890055---add----end----
     #FUN-AB0090---add----str----
     BEFORE FIELD vlo03
        CALL p400_set_entry()
        CALL p400_set_no_required()
     BEFORE FIELD vlo04
        CALL p400_set_entry()
        CALL p400_set_no_required()
     BEFORE FIELD vlo05
        CALL p400_set_entry()
        CALL p400_set_no_required()
     ON CHANGE vlo03
        CALL p400_set_no_entry()
        CALL p400_set_required()
     ON CHANGE vlo04
        CALL p400_set_no_entry()
        CALL p400_set_required()
     ON CHANGE vlo05
        CALL p400_set_no_entry()
        CALL p400_set_required()
     AFTER FIEld vlo03
        CALL p400_set_no_entry()
        CALL p400_set_required()
     AFTER FIEld vlo04
        CALL p400_set_no_entry()
        CALL p400_set_required()
     AFTER FIEld vlo05
        CALL p400_set_no_entry()
        CALL p400_set_required()
     #FUN-AB0090---add----end----
     AFTER INPUT 
        IF g_vld.vld07 = 'N' AND g_vld.vld08 = 'N' AND g_vld.vld09 = 'N' THEN
            LET g_vld.vld07 = 'Y'
            LET g_vld.vld08 = 'Y'
            LET g_vld.vld09 = 'Y'
            DISPLAY BY NAME g_vld.vld07,g_vld.vld08,g_vld.vld09
            #至少要選擇一種訂單來源
            CALL cl_err('','aps-400',1)
            NEXT FIELD vld07
        END IF
        #TQC-890061---add---str---
       #IF NOT cl_null(g_vld.vld18) THEN  #FUN-A80049 mark
        IF NOT cl_null(g_vld.vld03) THEN  #FUN-A80049 add
           #FUN-A80049 mark---str---
           #預測計劃基準日不需要介於資料日期範圍內
           #IF NOT cl_null(g_vld.vld03) THEN
           #    IF g_vld.vld18 < g_vld.vld03 THEN
           #        #計劃基準日需在資料日期範圍內!
           #        CALL cl_err('','aps-026',1)
           #        LET g_vld.vld18 = NULL
           #        DISPLAY BY NAME g_vld.vld18
           #        NEXT FIELD vld18
           #    END IF
           #END IF
           #IF NOT cl_null(g_vld.vld04) THEN
           #    IF g_vld.vld18 > g_vld.vld04 THEN
           #        #計劃基準日需在資料日期範圍內!
           #        CALL cl_err('','aps-026',1)
           #        LET g_vld.vld18 = NULL
           #        DISPLAY BY NAME g_vld.vld18
           #        NEXT FIELD vld18
           #    END IF
           #END IF
           #FUN-A80049 mark---end---
            #TQC-990139----mod---str---
            #(1)先產生時距檔
            CALL p400_c_buk_tmp()       # 產生時距檔
            #(2)抓g_base_date
            SELECT plan_date INTO g_base_date
              FROM buk_tmp
            #WHERE real_date = g_vld.vld18 #FUN-A80049 mark
             WHERE real_date = g_vld.vld03 #FUN-A80049 add
            DISPLAY g_base_date TO FORMONLY.base_date
            #(3)抓l_vld12b,l_vld12e
            IF g_vld.vld10 = '5' THEN
                #前取訂單的日期範圍:l_vld12b至(l_vld12e-1)
                LET l_vld12b = g_base_date
                DECLARE sel_buk_cur SCROLL CURSOR FOR
                 SELECT UNIQUE plan_date 
                   FROM buk_tmp 
                  WHERE plan_date >= g_base_date
                  ORDER BY  plan_date 

                SELECT COUNT(UNIQUE plan_date) INTO l_cnt
                  FROM buk_tmp 
                 WHERE plan_date >= g_base_date

                LET l_period = g_vld.vld19 + 1
                IF l_period > l_cnt THEN
                    LET l_period = l_cnt
                END IF
                
                OPEN sel_buk_cur
                FETCH ABSOLUTE l_period sel_buk_cur INTO l_vld12e
               
            END IF
            #TQC-990139----mod---end---
        END IF
        #TQC-890061---add---end---
        #FUN-8A0011---add---str---
        IF cl_null(g_vlz70) THEN #FUN-B50022 add if 判斷
            SELECT vlz70 INTO g_vlz70
              FROM vlz_file
             WHERE vlz01 = g_vld.vld01
               AND vlz02 = g_vld.vld02
            LET g_vlz.vlz70 = g_vlz70 #FUN-B50022 add
           #DISPLAY g_vlz70 TO FORMONLY.vlz70 #FUN-B50022 mark
            DISPLAY BY NAME g_vlz.vlz70       #FUN-B50022 add
        END IF
        #FUN-8A0011---add---end---
     ON ACTION controlp
        CASE
           WHEN INFIELD(vld01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_vlz01"
              LET g_qryparam.default1 = g_vld.vld01
              CALL cl_create_qry() RETURNING g_vld.vld01,g_vld.vld02
              DISPLAY BY NAME g_vld.vld01,g_vld.vld02
              #TQC-890061---add----str---
              SELECT * INTO g_vld.*
                FROM vld_file
               WHERE vld01 = g_vld.vld01
                 AND vld02 = g_vld.vld02
              LET g_vld.vld15 = 'Y'  
              LET g_vld.vld16 = 'Y'  
              LET g_vld.vld17 = '1'  
              DISPLAY BY NAME g_vld.vld03,
                              g_vld.vld04,g_vld.vld05,g_vld.vld06,g_vld.vld14,g_vld.vld18, 
                              g_vld.vld10,g_vld.vld11,g_vld.vld17,     
                              g_vld.vld07,g_vld.vld08,g_vld.vld09,g_vld.vld15,g_vld.vld16 
              #TQC-890061---add----str---
              #FUN-AB0090--add----str---
              INITIALIZE g_vlo.* TO NULL 
              SELECT * INTO g_vlo.*
                FROM vlo_file
               WHERE vlo01 = g_vld.vld01
                 AND vlo02 = g_vld.vld02
              IF cl_null(g_vlo.vlo03) THEN
                  LET g_vlo.vlo03 = '1'  
                  LET g_vlo.vlo04 = '2'  
                  LET g_vlo.vlo05 = '3'  
                  LET g_vlo.vlo06 = ''  
              END IF
              DISPLAY BY NAME g_vlo.vlo03,g_vlo.vlo04,g_vlo.vlo05,g_vlo.vlo06
              #FUN-AB0090--add----end---
              NEXT FIELD vld01
           WHEN INFIELD(vld14)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rpg"
              LET g_qryparam.default1 = g_vld.vld14
              CALL cl_create_qry() RETURNING g_vld.vld14
              DISPLAY BY NAME g_vld.vld14
              NEXT FIELD vld14
#MOD-C80107 add beg----
           WHEN INFIELD(vlz70)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_msp01"
              CALL cl_create_qry() RETURNING g_vlz.vlz70
              DISPLAY BY NAME g_vlz.vlz70
              NEXT FIELD vlz70            
#MOD-C80107 add end----
           OTHERWISE
              EXIT CASE
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
 
     ON ACTION locale       
        CALL cl_dynamic_locale()
        CALL p400_def_form()   #FUN-9C0125 add #FUN-B50022 add
 
     ON ACTION qbe_select
        CALL cl_qbe_select()

     ON ACTION qbe_save
        CALL cl_qbe_save()

  END INPUT
  IF INT_FLAG THEN RETURN END IF
END FUNCTION

FUNCTION p400_set_entry()
    CALL cl_set_comp_entry("vld14",TRUE)
    CALL cl_set_comp_entry("vlo06",TRUE) #FUN-AB0090 add
END FUNCTION

FUNCTION p400_set_no_entry()
      IF g_vld.vld06 <> '1' THEN #依時距代號
         LET g_vld.vld14 = NULL
         DISPLAY BY NAME g_vld.vld14
         CALL cl_set_comp_entry("vld14",FALSE)
      END IF
      #FUN-AB0090---add---str---
      IF NOT (g_vlo.vlo03 = '4' OR g_vlo.vlo04 = '4' OR g_vlo.vlo05 = '4') THEN
         LET g_vlo.vlo06 = ''
         DISPLAY BY NAME g_vlo.vlo06
         CALL cl_set_comp_entry("vlo06",FALSE)
      END IF
      #FUN-AB0090---add---end---

END FUNCTION

FUNCTION p400_set_no_required()
    CALL cl_set_comp_required("vld14",FALSE)        
    CALL cl_set_comp_required("vlo06",FALSE)    #FUN-AB0090 add
END FUNCTION

FUNCTION p400_set_required()
    IF g_vld.vld06 = '1' THEN #依時距代號
        CALL cl_set_comp_required("vld14",TRUE)        
    END IF
    #FUN-AB0090---add---str---
    IF (g_vlo.vlo03 = '4' OR g_vlo.vlo04 = '4' OR g_vlo.vlo05 = '4') THEN
        CALL cl_set_comp_required("vlo06",TRUE)        
    END IF
    #FUN-AB0090---add---end---
END FUNCTION

FUNCTION p400_ins_vld()
   DEFINE l_cnt LIKE type_file.num5     

   SELECT COUNT(*) INTO l_cnt 
     FROM vld_file
    WHERE vld01 = g_vld.vld01
      AND vld02 = g_vld.vld02
   IF l_cnt >=1 THEN
       DELETE FROM vld_file 
        WHERE vld01 = g_vld.vld01
          AND vld02 = g_vld.vld02
       IF STATUS THEN 
           CALL cl_err('Del vld_file',STATUS,1) 
       END IF
   END IF
   LET g_vld.vld12 = g_today
   LET g_vld.vld13 = TIME
   #FUN-870104---mod---str---
   #FUN-880044 add vld17
   #FUN-890055 add vld18
   INSERT INTO vld_file(vld01,vld02,vld03,vld04,vld05,
                        vld06,vld07,vld08,vld09,vld10,
                        vld11,vld12,vld13,vld14,vld15,
                        vld16,vld17,vld18,
                        vldplant,vldlegal, #FUN-B50022 add
                        vld19   #FUN-940001  ADD
                       ) VALUES
                       (g_vld.vld01,g_vld.vld02,g_vld.vld03,g_vld.vld04,g_vld.vld05,
                        g_vld.vld06,g_vld.vld07,g_vld.vld08,g_vld.vld09,g_vld.vld10,
                        g_vld.vld11,g_vld.vld12,g_vld.vld13,g_vld.vld14,g_vld.vld15,
                        g_vld.vld16,g_vld.vld17,g_vld.vld18,
                        g_plant,g_legal,   #FUN-B50022 add
                        g_vld.vld19    #FUN-940001 ADD
                       )
   #FUN-870104---mod---end---
   IF STATUS THEN 
       CALL cl_err('Ins vld_file',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
       EXIT PROGRAM 
   END IF
END FUNCTION

#FUN-AB0090---add---str--
FUNCTION p400_ins_vlo()
   DEFINE l_cnt LIKE type_file.num5     

   SELECT COUNT(*) INTO l_cnt 
     FROM vlo_file
    WHERE vlo01 = g_vld.vld01
      AND vlo02 = g_vld.vld02
   IF l_cnt >=1 THEN
       DELETE FROM vlo_file 
        WHERE vlo01 = g_vld.vld01
          AND vlo02 = g_vld.vld02
       IF STATUS THEN 
           CALL cl_err('Del vlo_file',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
           EXIT PROGRAM 
       END IF
   END IF
   LET g_vlo.vlo01 = g_vld.vld01
   LET g_vlo.vlo02 = g_vld.vld02
   IF NOT (g_vlo.vlo03 = '4' OR g_vlo.vlo04 = '4' OR g_vlo.vlo05 = '4') THEN
       LET g_vlo.vlo06 = ' '
   END IF
   INSERT INTO vlo_file(vlo01,vlo02,vlo03,vlo04,vlo05,
                        vlo06,
                        vlolegal,vloplant #FUN-D10051 add
                       ) VALUES
                       (g_vlo.vlo01,g_vlo.vlo02,g_vlo.vlo03,g_vlo.vlo04,g_vlo.vlo05,
                        g_vlo.vlo06,
                        g_legal,g_plant   #FUN-D10051 add
                       )
   IF STATUS THEN 
       CALL cl_err('Ins vlo_file',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
       EXIT PROGRAM 
   END IF
END FUNCTION
#FUN-AB0090---add---end--

FUNCTION p400_c_buk_tmp()       # 產生時距檔
  DEFINE d,d2   LIKE type_file.dat      
  DEFINE l_period  LIKE  type_file.num5   #FUN-940001 ADD
  DEFINE l_date    LIKE  type_file.dat    #FUN-940001 ADD
  DEFINE l_bdate   LIKE type_file.dat     #FUN-A80049 add
  DEFINE l_edate   LIKE type_file.dat     #FUN-A80049 add
 
  #FUN-890055---add---str--
  #==>時距檔
  DROP TABLE buk_tmp
  CREATE TEMP TABLE buk_tmp(
    real_date  DATE,       
    plan_date  DATE)       #歸屬時距日期
  #FUN-890055---add---end--

  LET bdate = g_vld.vld03
  LET edate = g_vld.vld04

  IF STATUS THEN CALL cl_err('create buk_tmp:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
      EXIT PROGRAM 
  END IF
  CASE WHEN g_vld.vld06 = '1' CALL rpg_buk() RETURN       #1:依時距代號
       WHEN g_vld.vld06 = '2' LET past_date = bdate-1     #2:天
       WHEN g_vld.vld06 = '3' LET past_date = bdate-7     #3:週
       WHEN g_vld.vld06 = '4' LET past_date = bdate-10    #4:旬
       WHEN g_vld.vld06 = '5' LET past_date = bdate-30    #5:月
       OTHERWISE           LET past_date = bdate-1
  END CASE
  CALL p400_buk_date(past_date) RETURNING past_date

  LET l_period = 0   #FUN-940001 ADD
  FOR j = bdate TO edate
     LET d=j
     CALL p400_buk_date(d) RETURNING d2
     INSERT INTO buk_tmp VALUES(d,d2)
    #TQC-990139--mark---str----
    ##FUN-940001 ADD  --STR--
    # IF j=bdate  THEN
    #    LET   l_vld12b = d2
    #    LET   l_vld12e = d2
    #    LET   l_date = d2
    # END IF
    # IF g_vld.vld10 = 5 THEN
    #     IF l_period = g_vld.vld19   THEN                 
    #        LET l_vld12e = d2
    #     END IF  
    #     IF l_date <> d2 THEN
    #        LET l_period = l_period + 1  
    #        LET l_date = d2 
    #     END IF
    # END IF
    ##FUN-940001  ADD  --END--
    #TQC-990139--mark---end----

     IF STATUS THEN 
         CALL cl_err('ins buk_tmp:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
         EXIT PROGRAM 
     END IF
  END FOR
  #FUN-A80049---add----str---
  #補齊6/28,6/29,6/30 進buk_tmp
  #因為訂單資料抓6/28~7/31的資料
  SELECT plan_date INTO l_bdate
    FROM buk_tmp
   WHERE real_date = g_vld.vld03
  LET l_edate = g_vld.vld03 - 1
  
  FOR j = l_bdate TO l_edate
     LET d=j
     CALL p400_buk_date(d) RETURNING d2
     INSERT INTO buk_tmp VALUES(d,d2)

     IF STATUS THEN 
         CALL cl_err('ins buk_tmp:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
         EXIT PROGRAM 
     END IF
  END FOR
  #FUN-A80049---add----end---
END FUNCTION

FUNCTION p400_buk_date(d)
  DEFINE d,d2   LIKE type_file.dat      
  DEFINE x      LIKE type_file.chr8    

  CASE WHEN g_vld.vld06 = '3' LET i=weekday(d) IF i=0 THEN LET i=7 END IF
                           LET d2=d-i+1
       WHEN g_vld.vld06 = '4' LET x = d USING 'yyyymmdd'
                           CASE WHEN x[7,8]<='10' LET x[7,8]='01'
                                WHEN x[7,8]<='20' LET x[7,8]='11'
                                OTHERWISE         LET x[7,8]='21'
                           END CASE
                           LET d2= MDY(x[5,6],x[7,8],x[1,4])
       WHEN g_vld.vld06 = '5' LET x = d USING 'yyyymmdd'
                           LET x[7,8]='01'
                           LET d2= MDY(x[5,6],x[7,8],x[1,4])
       OTHERWISE           LET d2=d
  END CASE
 #INSERT INTO msk_file(msk_v,msk_d) VALUES(ver_no, d2)
  RETURN d2
END FUNCTION

FUNCTION rpg_buk()
  DEFINE l_bucket ARRAY[36] OF LIKE type_file.num5     
  DEFINE l_rpg    RECORD LIKE rpg_file.*
  DEFINE dd1,dd2  LIKE type_file.dat      

  SELECT * INTO l_rpg.* 
    FROM rpg_file 
   WHERE rpg01 = g_vld.vld14 
  IF STATUS THEN CALL cl_err('sel rpg2:',STATUS,1) 
      RETURN 
  END IF
 
  LET l_bucket[01]=l_rpg.rpg101 LET l_bucket[02]=l_rpg.rpg102
  LET l_bucket[03]=l_rpg.rpg103 LET l_bucket[04]=l_rpg.rpg104
  LET l_bucket[05]=l_rpg.rpg105 LET l_bucket[06]=l_rpg.rpg106
  LET l_bucket[07]=l_rpg.rpg107 LET l_bucket[08]=l_rpg.rpg108
  LET l_bucket[09]=l_rpg.rpg109 LET l_bucket[10]=l_rpg.rpg110
  LET l_bucket[11]=l_rpg.rpg111 LET l_bucket[12]=l_rpg.rpg112
  LET l_bucket[13]=l_rpg.rpg113 LET l_bucket[14]=l_rpg.rpg114
  LET l_bucket[15]=l_rpg.rpg115 LET l_bucket[16]=l_rpg.rpg116
  LET l_bucket[17]=l_rpg.rpg117 LET l_bucket[18]=l_rpg.rpg118
  LET l_bucket[19]=l_rpg.rpg119 LET l_bucket[20]=l_rpg.rpg120
  LET l_bucket[21]=l_rpg.rpg121 LET l_bucket[22]=l_rpg.rpg122
  LET l_bucket[23]=l_rpg.rpg123 LET l_bucket[24]=l_rpg.rpg124
  LET l_bucket[25]=l_rpg.rpg125 LET l_bucket[26]=l_rpg.rpg126
  LET l_bucket[27]=l_rpg.rpg127 LET l_bucket[28]=l_rpg.rpg128
  LET l_bucket[29]=l_rpg.rpg129 LET l_bucket[30]=l_rpg.rpg130
  LET l_bucket[31]=l_rpg.rpg131 LET l_bucket[32]=l_rpg.rpg132
  LET l_bucket[33]=l_rpg.rpg133 LET l_bucket[34]=l_rpg.rpg134
  LET l_bucket[35]=l_rpg.rpg135 LET l_bucket[36]=l_rpg.rpg136
  LET past_date=bdate-l_rpg.rpg101
  LET dd1=bdate 
  LET dd2=bdate
  FOR i = 1 TO 36
   FOR j=1 TO l_bucket[i]
     INSERT INTO buk_tmp VALUES (dd1,dd2)
     LET dd1=dd1+1
   END FOR
   LET dd2=dd2+l_bucket[i]
  END FOR
END FUNCTION

FUNCTION p400_c_mds_tmp()       # 產生MDS沖銷來源資料暫存檔
  DEFINE #l_sql          LIKE type_file.chr1000 
         l_sql          STRING       #NO.FUN-910082   
  DEFINE l_oea          RECORD LIKE oea_file.*
  DEFINE l_oeb          RECORD LIKE oea_file.*
  DEFINE l_opc01        LIKE opc_file.opc01
  DEFINE l_opc02        LIKE opc_file.opc02
  DEFINE l_opc03        LIKE opc_file.opc03
  DEFINE l_opc04        LIKE opc_file.opc04
  DEFINE l_ima133       LIKE ima_file.ima133 #FUN-870104 add
  DEFINE l_max_opc03    LIKE opc_file.opc03  #FUN-870104 add #計劃日期(opc03) <=或>=執行日期(vld12)且最接近者
  DEFINE l_opc03_1      LIKE opc_file.opc03  #FUN-880044 add
  DEFINE l_opc03_2      LIKE opc_file.opc03  #FUN-880044 add
  DEFINE l_condition    STRING               #FUN-B10070 add
  DEFINE l_ogb12        LIKE ogb_file.ogb12  #TQC-C40213 add
  #FUN-8A0011---add----str---
  IF NOT cl_null(g_vlz70) THEN 
      CALL s_get_sql_msp04(g_vlz70,'oeb01') RETURNING g_sql_limited 
  ELSE
      LET g_sql_limited = ' 1=1 '
  END IF
  #FUN-8A0011---add----end---
  #===>一般訂單/合約訂單
  IF g_vld.vld07= 'Y' OR g_vld.vld08 = 'Y' THEN
      LET g_sql="SELECT oeb04,'',"
      IF g_vld.vld05 = '1' THEN
          #日期選擇=>1:約定交貨日oeb15
          LET g_sql = g_sql CLIPPED, " oeb15 "
      ELSE
          #日期選擇=>2:排定交貨日oeb16
          LET g_sql = g_sql CLIPPED, " oeb16 "
      END IF
     #LET g_sql = g_sql CLIPPED, ",(oeb12-oeb24+oeb25-oeb26),oeb12,(oeb24-oeb25+oeb26),oeb01,oeb03,oea02,oea03,oea14,oea00 ", #FUN-A60068 mark
     #FUN-BA0036--mark--str----
     #LET g_sql = g_sql CLIPPED, ", oeb12                   ,oeb12,(oeb24-oeb25+oeb26),oeb01,oeb03,oea02,oea03,oea14,oea00 ", #FUN-A60068 add
     #FUN-BA0036--mark--end----
     #FUN-BA0036--add---str----
      IF g_vld.vld07 = 'N' THEN
          #銷售訂單納入否vld07='N'時(僅勾選合約訂單時,合約訂單以合約訂單量沖銷)
          #tmp04抓=>oeb12, tmp042抓=>0
          LET g_sql = g_sql CLIPPED, ", oeb12,oeb12,0 "
      ELSE
          #當0:合約時,tmp04抓=>淨需求:(oeb12-oeb24+oeb25-oeb26) ,tmp042抓=>(oeb24-oeb25+oeb26)
          #當1:訂單時,tmp04抓=>訂單量:(oeb12)                   ,tmp042抓=>(oeb24-oeb25+oeb26)
          LET g_sql = g_sql CLIPPED, ",CASE WHEN oea00 = '0' THEN (oeb12-oeb24+oeb25-oeb26) ELSE oeb12 END ",
                                     ",oeb12",
                                     ",(oeb24-oeb25+oeb26) "
      END IF
      LET g_sql = g_sql CLIPPED,",oeb01,oeb03,oea02,oea03,oea14,oea00 ",
     #FUN-BA0036--add---end----
                                 "  FROM oea_file,oeb_file",
                                 " WHERE oea01 = oeb01 ",
                                #"   AND oeb12 > (oeb24-oeb25+oeb26) ", #FUN-A60068 mark
                                 "   AND oeb70 = 'N' ",
                                 "   AND oeaconf = 'Y' ",
                                 "   AND ",g_sql_limited CLIPPED #FUN-8A0003 add
      IF g_vld.vld05 = '1' THEN
          #日期選擇=>1:約定交貨日oeb15
         #FUN-890055---mod---str---
         #FUN-870104---mod---str---
         #IF g_vld.vld15 = 'N' THEN #前期資料納入否
             #LET g_sql = g_sql CLIPPED, " AND oeb15 >= '",g_base_buk_date,"'", #FUN-A80049 mark
              LET g_sql = g_sql CLIPPED, " AND oeb15 >= '",g_base_date,"'",     #FUN-A80049 add
                                         " AND oeb15 <= '",g_vld.vld04,"'"
         #ELSE
         #    LET g_sql = g_sql CLIPPED, " AND oeb15 <= '",g_vld.vld04,"'"
         #END IF
         #FUN-870104---mod---end---
         #FUN-890055---mod---end---
      ELSE
          #日期選擇=>2:排定交貨日oeb16
         #FUN-890055---mod---str---
         #FUN-870104---mod---str---
         #IF g_vld.vld15 = 'N' THEN #前期資料納入否
             #LET g_sql = g_sql CLIPPED, " AND oeb15 >= '",g_base_buk_date,"'", #FUN-9C0010 mark
             #LET g_sql = g_sql CLIPPED, " AND oeb16 >= '",g_base_buk_date,"'", #FUN-9C0010 add #FUN-A80049 mark
              LET g_sql = g_sql CLIPPED, " AND oeb16 >= '",g_base_date    ,"'", #FUN-9C0010 add #FUN-A80049 add
                                         " AND oeb16 <= '",g_vld.vld04,"'"
         #ELSE
         #    LET g_sql = g_sql CLIPPED, " AND oeb16 <= '",g_vld.vld04,"'"
         #END IF
         #FUN-870104---mod---end---
         #FUN-890055---mod---end---
      END IF
      LET g_sql = g_sql CLIPPED, " AND oea00 IN ("
      IF g_vld.vld07 = 'Y' THEN
          LET g_sql = g_sql CLIPPED, "'1'"
      END IF
      IF g_vld.vld08 = 'Y' THEN
          IF g_vld.vld07 = 'Y' THEN LET g_sql = g_sql CLIPPED,"," END IF
          LET g_sql = g_sql CLIPPED, "'0'"
      END IF
      LET g_sql = g_sql CLIPPED,")"
      PREPARE p400_mds_p1 FROM g_sql
      DECLARE p400_mds_c1 CURSOR FOR p400_mds_p1
      INITIALIZE g_tmp.* TO NULL
      FOREACH p400_mds_c1 INTO g_tmp.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach p400_mds_c1:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
        #FUN-890055 mod----str---
        #FUN-870104 mod----str---
        #IF g_tmp.tmp03 < g_vld.vld03 THEN #前期資料
        #    SELECT MIN(plan_date) INTO g_tmp.tmp02
        #      FROM buk_tmp
        #ELSE
             SELECT plan_date INTO g_tmp.tmp02
               FROM buk_tmp
              WHERE real_date = g_tmp.tmp03
        #END IF
        #FUN-870104 mod----end---
        #FUN-890055 mod----end---

         #FUN-870104 add----str---
         #預測料號
         IF g_vld.vld16 = 'Y' THEN
             SELECT ima133 INTO l_ima133
               FROM ima_file
              WHERE ima01 = g_tmp.tmp01
             IF NOT cl_null(l_ima133) THEN
                 LET g_tmp.tmp16 = l_ima133
             ELSE
                 LET g_tmp.tmp16 = g_tmp.tmp01
             END IF
         ELSE
             LET g_tmp.tmp16 = g_tmp.tmp01
         END IF
         #FUN-870104 add----end---
# add begin TQC-C40213
       #如果走出貨簽收,已經簽收的要扣掉 
         SELECT SUM(ogb12) INTO l_ogb12 FROM ogb_file,oga_file
          WHERE oga65='Y'
            AND oga01=ogb01
            AND oga09='2'
            AND ogapost='Y'
            AND ogb31=g_tmp.tmp05
            AND ogb32=g_tmp.tmp06
         IF cl_null(l_ogb12) THEN LET l_ogb12=0 END IF
         LET g_tmp.tmp042=g_tmp.tmp042+l_ogb12

# add end TQC-C40213
         INSERT INTO mds_tmp VALUES(g_tmp.*)
         IF STATUS THEN 
             CALL cl_err('ins mds_tmp',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
             EXIT PROGRAM 
         END IF
      END FOREACH
  END IF
 #FUN-890055---mark---str--
 ##===>獨立需求(amri506)
 #IF g_vld.vld09 = 'Y' THEN
 #    LET g_sql="SELECT rpc01,'',rpc12,rpc13-rpc131,rpc13,rpc131,rpc02,rpc03,rpc21,'','','2' ",
 #              "  FROM rpc_file",
 #              " WHERE rpc13 > rpc131 ",
 #              "   AND rpc18 = 'Y' ", #確認碼
 #              "   AND rpc19 = 'N' "  #結案碼
 #    #FUN-870104---mod---str---
 #    IF g_vld.vld15 = 'N' THEN #前期資料納入否
 #        LET g_sql = g_sql CLIPPED, "   AND rpc12 >= '",g_vld.vld03,"'",
 #                                   "   AND rpc12 <= '",g_vld.vld04,"'"
 #    ELSE
 #        LET g_sql = g_sql CLIPPED, "   AND rpc12 <= '",g_vld.vld04,"'"
 #    END IF
 #    #FUN-870104---mod---end---
 #    PREPARE p400_mds_p2 FROM g_sql
 #    DECLARE p400_mds_c2 CURSOR FOR p400_mds_p2
 #    FOREACH p400_mds_c2 INTO g_tmp.*
 #       IF SQLCA.sqlcode THEN
 #          CALL cl_err('foreach p400_mds_c2:',SQLCA.sqlcode,1)
 #          EXIT FOREACH
 #       END IF
 #       #FUN-870104 mod----str---
 #       IF g_tmp.tmp03 < g_vld.vld03 THEN #前期資料
 #           SELECT MIN(plan_date) INTO g_tmp.tmp02
 #             FROM buk_tmp
 #       ELSE
 #           SELECT plan_date INTO g_tmp.tmp02
 #             FROM buk_tmp
 #            WHERE real_date = g_tmp.tmp03
 #       END IF
 #       #FUN-870104 mod----end---

 #       #FUN-870104 add----str---
 #       #預測料號
 #       IF g_vld.vld16 = 'Y' THEN
 #           SELECT ima133 INTO l_ima133
 #             FROM ima_file
 #            WHERE ima01 = g_tmp.tmp01
 #           IF NOT cl_null(l_ima133) THEN
 #               LET g_tmp.tmp16 = l_ima133
 #           ELSE
 #               LET g_tmp.tmp16 = g_tmp.tmp01
 #           END IF
 #       ELSE
 #           LET g_tmp.tmp16 = g_tmp.tmp01
 #       END IF
 #       #FUN-870104 add----end---

 #       INSERT INTO mds_tmp VALUES(g_tmp.*)
 #       IF STATUS THEN CALL cl_err('ins mds_tmp',STATUS,1) EXIT PROGRAM END IF
 #    END FOREACH
 #END IF
 #FUN-890055---mark---end--
  #FUN-880044 mod--str--
  #===>預測(axmi171)
  #FUN-870104--add---str---
  #FUN-880044--mod---str---
  #-->抓計劃日期>=執行基準日    且最靠近者  #FUN-A80049 mark
  #-->抓計劃日期>=預測計劃基準日且最靠近者  #FUN-A80049 add 改為此邏輯
  LET g_sql = "SELECT UNIQUE MIN(opc03)",
              "  FROM opc_file ",
             #" WHERE opc03 >= '",g_vld.vld12,"'",       #計劃日期<=執行日期        #FUN-A80049 mark
              " WHERE opc03 >= '",g_vld.vld18,"'",       #計劃日期<=預測計劃基準日  #FUN-A80049 add
              "   AND opc11 = 'Y' " #業務確認
  IF g_vld.vld11 = '1' THEN
      #生管確認
      LET g_sql = g_sql CLIPPED, " AND opc12 = 'Y' "
  END IF
  PREPARE p400_opc03_p1 FROM g_sql
  DECLARE p400_opc03_c1 CURSOR FOR p400_opc03_p1
  OPEN p400_opc03_c1
  FETCH p400_opc03_c1 INTO l_opc03_1

  #-->抓計劃日期<=執行基準日    且最靠近者  #FUN-A80049 mark
  #-->抓計劃日期<=預測計劃基準日且最靠近者  #FUN-A80049 add 改為此邏輯
  LET g_sql = "SELECT UNIQUE MAX(opc03)",
              "  FROM opc_file ",
             #" WHERE opc03 <= '",g_vld.vld12,"'",       #計劃日期<=執行日期       #FUN-A80049 mark
              " WHERE opc03 <= '",g_vld.vld18,"'",       #計劃日期<=預測計劃基準日 #FUN-A80049 add
              "   AND opc11 = 'Y' " #業務確認
  IF g_vld.vld11 = '1' THEN
      #生管確認
      LET g_sql = g_sql CLIPPED, " AND opc12 = 'Y' "
  END IF
  PREPARE p400_opc03_p2 FROM g_sql
  DECLARE p400_opc03_c2 CURSOR FOR p400_opc03_p2
  OPEN p400_opc03_c2
  FETCH p400_opc03_c2 INTO l_opc03_2
  #CHI-940034 MOD --STR--------------------------------
  #IF g_vld.vld17 = '1' THEN    
  #    IF NOT cl_null(l_opc03_1) THEN
  #        LET l_max_opc03 = l_opc03_1
  #    ELSE
  #        LET l_max_opc03 = l_opc03_2
  #    END IF
  #ELSE
  #    LET l_max_opc03 = l_opc03_2
  #END IF
    #FUN-A80049--mod---str---
    #邏輯改成先撈取         "計劃日期(opc03) <=預測計劃基準日 最接近者",
    #但無資料時，則自動改抓 "計劃日期(opc03) > 預測計劃基準日 最接近者"
    #EX:
    #-----------*---------------*------------------*-------------------------
    #          06/28           07/15              07/19
    #          計劃日期        預測計劃基日       計劃日期
    #以此範例,應抓06/28計劃日期所預測的(axmi171)資料
    #IF NOT cl_null(l_opc03_1) THEN
    #    LET l_max_opc03 = l_opc03_1
    #ELSE
    #    LET l_max_opc03 = l_opc03_2
    #END IF
     IF NOT cl_null(l_opc03_2) THEN
         LET l_max_opc03 = l_opc03_2
     ELSE
         LET l_max_opc03 = l_opc03_1
     END IF
    #FUN-A80049--mod---end---
  #CHI-940034 MOD --END--------------------------------

  #FUN-880044--mod---end---
  #FUN-870104--add---end---
 #FUN-B10070---mark---str--- 
 ##FUN-870104----mod---str---
 #LET g_sql = "SELECT opc01,opc02,MAX(opc03),opc04 ", 
 #            "  FROM opc_file,ima_file ",
 #           #" WHERE opc03 <= '",g_vld.vld12,"'",      #計劃日期<=執行日期                         #FUN-870104 mod
 #           #" WHERE opc03  = '",l_max_opc03,"'",      #計劃日期<=或>=執行日期且最接近的           #FUN-870104 mod #FUN-AB0090(1) mark
 #            " WHERE opc03 <= '",g_vld.vld18,"'",      #計劃日期<=預測計劃基準日                                   #FUN-AB0090(1) add 
 #            "   AND opc11  = 'Y' ", #業務確認  
 #            "   AND opc01  = ima01 ",
 #            "   AND imaacti = 'Y' "
 #IF g_vld.vld11 = '1' THEN
 #    #生管確認
 #    LET g_sql = g_sql CLIPPED, " AND opc12 = 'Y' "
 #END IF
 #IF g_vld.vld16 = 'Y' THEN
 #    #預測資料,只抓真正屬於預測料號的資料,不抓實際料號
 #    LET g_sql = g_sql CLIPPED, " AND (ima01 = ima133 OR ima133 IS NULL) " #TQC-880041 mod
 #END IF
 ##FUN-870104----mod---end---
 #LET g_sql = g_sql CLIPPED," GROUP BY opc01,opc02,opc04 "
 #FUN-B10070---mark---end--- 

 #FUN-B10070---add----str--- 
  LET l_condition = "  FROM opc_file,ima_file ",
                    " WHERE opc11  = 'Y' ", #業務確認  
                    "   AND opc01  = ima01 ",
                    "   AND imaacti = 'Y' "
  IF g_vld.vld11 = '1' THEN
      #生管確認
      LET l_condition = l_condition CLIPPED, " AND opc12 = 'Y' "
  END IF
  IF g_vld.vld16 = 'Y' THEN
      #預測資料,只抓真正屬於預測料號的資料,不抓實際料號
      LET l_condition = l_condition CLIPPED, " AND (ima01 = ima133 OR ima133 IS NULL) " 
  END IF
  LET g_sql = "SELECT UNIQUE opc01,opc02,opc04 ",l_condition CLIPPED
  LET g_sql = g_sql CLIPPED," ORDER BY opc01,opc02,opc04 "
  #FUN-870104----add---end---
  PREPARE p400_opc_p FROM g_sql
  DECLARE p400_opc_c CURSOR FOR p400_opc_p
  #FUN-870104----add---str---
  LET g_sql = "SELECT MAX(opc03) ",l_condition CLIPPED,
              " AND opc03 <= '",g_vld.vld18,"'",      #計劃日期<=預測計劃基準日  
              " AND opc01 = ? ",
              " AND opc02 = ? ",
              " AND opc04 = ? "
  PREPARE p400_opc_max_p FROM g_sql

  LET g_sql = "SELECT MIN(opc03) ",l_condition CLIPPED,
              " AND opc03 > '",g_vld.vld18,"'",      #計劃日期 > 預測計劃基準日  
              " AND opc01 = ? ",
              " AND opc02 = ? ",
              " AND opc04 = ? "
  PREPARE p400_opc_min_p FROM g_sql
  #FUN-870104----add---end---
  

  #==>再抓axmi171單身
  LET g_sql="SELECT opd01,'',opd06,"
  IF g_vld.vld11 = '2' THEN
      #業務確認
      LET g_sql = g_sql CLIPPED, " opd08,opd08,0 "
  ELSE
      #生管確認
      LET g_sql = g_sql CLIPPED, " opd09,opd09,0 "
  END IF
  LET g_sql = g_sql CLIPPED,",'FORECAST',opd05,opd03,opd02,opd04,'3'",
                            "  FROM opd_file",
                            " WHERE opd01 = ? ",
                            "   AND opd02 = ? ",
                            "   AND opd03 = ? ",
                            "   AND opd04 = ? ",
                           #"   AND opd06 >= '",g_vld.vld03,"'",  #FUN-890055 mark
                           #"   AND opd06 >= '",g_base_buk_date,"'",  #FUN-890055 mod #FUN-A80049 mark
                            "   AND opd06 >= '",g_vld.vld03    ,"'",  #FUN-890055 mod #FUN-A80049 add
                            "   AND opd06 <= '",g_vld.vld04,"'"
  #FUN-870104---add---str--
  #預測數量大於0的才納入計算
  IF g_vld.vld11 = '2' THEN
      #業務確認
      LET g_sql = g_sql CLIPPED, " AND opd08 > 0 "
  ELSE
      #生管確認
      LET g_sql = g_sql CLIPPED, " AND opd09 > 0 "
  END IF
  #FUN-870104---add---end--
  PREPARE p400_mds_p3 FROM g_sql
  DECLARE p400_mds_c3 CURSOR FOR p400_mds_p3
  
 #FOREACH p400_opc_c INTO l_opc01,l_opc02,l_opc03,l_opc04 #FUN-B10070 mark
  FOREACH p400_opc_c INTO l_opc01,l_opc02,l_opc04 #FUN-B10070 add
      IF SQLCA.sqlcode THEN CALL cl_err('p100_opc_c',STATUS,1) RETURN END IF
      #FUN-B10070 ----add-----str---
      LET l_opc03 = NULL
      EXECUTE p400_opc_max_p USING l_opc01,l_opc02,l_opc04 INTO l_opc03
      IF cl_null(l_opc03) THEN
          LET l_opc03 = NULL
          EXECUTE p400_opc_min_p USING l_opc01,l_opc02,l_opc04 INTO l_opc03
          IF cl_null(l_opc03) THEN
              CONTINUE FOREACH
          END IF
      END IF
      #FUN-B10070 ----add-----end---
      FOREACH p400_mds_c3 
         USING l_opc01,l_opc02,l_opc03,l_opc04
         INTO g_tmp.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach p400_mds_c3:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT plan_date INTO g_tmp.tmp02
           FROM buk_tmp
          WHERE real_date = g_tmp.tmp03
         #FUN-A80049--mod--end--
         #FUN-870104 add----str---
         #預測料號
         IF g_vld.vld16 = 'Y' THEN
             SELECT ima133 INTO l_ima133
               FROM ima_file
              WHERE ima01 = g_tmp.tmp01
             IF NOT cl_null(l_ima133) THEN
                 LET g_tmp.tmp16 = l_ima133
             ELSE
                 LET g_tmp.tmp16 = g_tmp.tmp01
             END IF
         ELSE
             LET g_tmp.tmp16 = g_tmp.tmp01
         END IF
         #FUN-870104 add----end---
         INSERT INTO mds_tmp VALUES(g_tmp.*)
         IF STATUS THEN 
             CALL cl_err('ins mds_tmp',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
             EXIT PROGRAM 
         END IF
      END FOREACH
  END FOREACH


END FUNCTION

FUNCTION p400_c_mds_result_tmp() # 產生MDS沖銷結果暫存檔
 #DEFINE l_tmp15        LIKE   type_file.num10 #FUN-B60063 add
  DEFINE l_mds_type     LIKE   type_file.chr1 #FUN-A60068 add 誰的資料先納入MDS=>'1':訂單 '2':預測
  DEFINE l_req_sum      LIKE   vle_file.vle06
  DEFINE l_for_sum      LIKE   vle_file.vle06
  DEFINE l_max_sum      LIKE   vle_file.vle06
  DEFINE l_result_qty   LIKE   vle_file.vle06
  DEFINE l_mds_qty      LIKE   vle_file.vle06
  #FUN-870104---mod---str--
  #tmp01全面換成tmp16
  DEFINE l_mds_all_tmp  RECORD                                          
                           tmp16   LIKE  vle_file.vle03, #料號         #FUN-870104 mod
                           tmp02   LIKE  vle_file.vle04  #歸屬時距日    
                        END RECORD

  LET g_sql="SELECT UNIQUE tmp16,tmp02 ", #FUN-870104 mod
            "  FROM mds_tmp",
            "  ORDER BY tmp16,tmp02 "     #FUN-870104 mod
  PREPARE p400_mds_all_p1 FROM g_sql
  DECLARE p400_mds_all_c1 CURSOR FOR p400_mds_all_p1
  #==>需求
  LET g_sql="SELECT * ",
            "  FROM mds_tmp",
            " WHERE tmp16 = ? ",  #FUN-870104 mod
            "   AND tmp02 = ? ",
           #"   AND tmp10 IN ('0','1','2') ", #FUN-B60063 mark
            "   AND tmp10 IN ('0','1') ",     #FUN-B60063 add
            "  ORDER BY tmp03 "
  PREPARE p400_mds_req_p1 FROM g_sql
  DECLARE p400_mds_req_c1 CURSOR FOR p400_mds_req_p1

  #==>預測
  LET g_sql="SELECT * ",
            "  FROM mds_tmp",
            " WHERE tmp16 = ? ",  #FUN-870104 mod
            "   AND tmp02 = ? ",
            "   AND tmp10 IN ('3') ",
            "  ORDER BY tmp03 DESC"
  PREPARE p400_mds_for_p1 FROM g_sql
  DECLARE p400_mds_for_c1 CURSOR FOR p400_mds_for_p1

  FOREACH p400_mds_all_c1 INTO l_mds_all_tmp.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach p400_mds_all_c1:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     #==>需求
     SELECT SUM(tmp04) 
       INTO l_req_sum
       FROM mds_tmp
      WHERE tmp16 = l_mds_all_tmp.tmp16 #料號  #FUN-870104 mod
        AND tmp02 = l_mds_all_tmp.tmp02 #歸屬時距日
       #AND tmp10 IN ('0','1','2')      #需求 #FUN-B60063 mark
        AND tmp10 IN ('0','1')          #需求 #FUN-B60063 add
     #==>預測
     SELECT SUM(tmp04) 
       INTO l_for_sum
       FROM mds_tmp
      WHERE tmp16 = l_mds_all_tmp.tmp16 #料號  #FUN-870104 mod
        AND tmp02 = l_mds_all_tmp.tmp02 #歸屬時距日
        AND tmp10 IN ('3')              #預測
     IF cl_null(l_req_sum) THEN LET l_req_sum = 0 END IF
     IF cl_null(l_for_sum) THEN LET l_for_sum = 0 END IF
     IF g_vld.vld10 = '1' THEN #需求量納入方式 1:以訂單為主
         LET l_max_sum = l_req_sum
         LET l_mds_type = '1' #FUN-A60068 add
     END IF
     IF g_vld.vld10 = '2' THEN #需求量納入方式 2:以預測為主
         LET l_max_sum = l_for_sum   
         LET l_mds_type = '2' #FUN-A60068 add
     END IF
     IF g_vld.vld10 = '3' THEN #需求量納入方式 3:兩者取其大
         IF l_req_sum >= l_for_sum THEN
             LET l_max_sum = l_req_sum   
             LET l_mds_type = '1' #FUN-A60068 add
         ELSE
             LET l_max_sum = l_for_sum   
             LET l_mds_type = '1' #FUN-A60068 add
         END IF
     END IF
     #FUN-870104---add---str---
     IF g_vld.vld10 = '4' THEN #需求量納入方式 4:有訂單取訂單;沒訂單取預測
        IF l_req_sum <> 0 THEN
            LET l_max_sum = l_req_sum   
            LET l_mds_type = '1' #FUN-A60068 add
        ELSE
            LET l_max_sum = l_for_sum   
            LET l_mds_type = '2' #FUN-A60068 add
        END IF
     END IF
     #FUN-870104---add---end---

     #FUN-940001  ADD   --STR--
      IF g_vld.vld10 = '5' THEN
         IF l_mds_all_tmp.tmp02 >= l_vld12b AND
            l_mds_all_tmp.tmp02 < l_vld12e THEN
            LET l_max_sum = l_req_sum       #依訂單
            LET l_mds_type = '1' #FUN-A60068 add
         ELSE
            LET l_max_sum = l_for_sum
            LET l_mds_type = '2' #FUN-A60068 add
         END IF
      END IF
     #FUN-940001  ADD    --END--

     LET l_mds_qty = l_max_sum - l_req_sum
     LET l_result_qty = l_max_sum
     LET g_max_sum = l_max_sum #FUN-B60063 add
     #==>需求
    #IF l_result_qty > 0 THEN #需求量需大於0                       #FUN-A60068 mark
     IF l_result_qty > 0 AND l_mds_type = '1' THEN #需求量需大於0  #FUN-A60068 add
         FOREACH p400_mds_req_c1 USING l_mds_all_tmp.tmp16,l_mds_all_tmp.tmp02 INTO g_tmp.*  #FUN-870104 mod
             IF l_result_qty < g_tmp.tmp04 THEN
                 LET g_tmp.tmp04  = l_result_qty
                 LET g_tmp.tmp041 = l_result_qty
                 LET g_tmp.tmp042 = 0
             END IF
             LET g_tmp.tmp11 = l_max_sum
             LET g_tmp.tmp12 = l_mds_qty
             LET g_tmp.tmp14 = 'N' #餘量否
             IF g_tmp.tmp04 <= 0 THEN 
                 CONTINUE FOREACH
             END IF
            #FUN-B60063----mod----str---
            ##FUN-AB0090---add----str---
            #IF g_tmp.tmp10 = '3' THEN #預測           
            #   #LET g_tmp.tmp10 = 'F'                 #需求來源 #TQC-AC0226 mark
            #    LET g_tmp.tmp17 = 'F'                 #需求來源 #TQC-AC0226 add
            #ELSE
            #   #LET g_tmp.tmp10 = 'R'                 #需求來源 #TQC-AC0226 mark
            #    LET g_tmp.tmp17 = 'R'                 #需求來源 #TQC-AC0226 add
            #END IF
            ##FUN-AB0090---add----end---
             LET g_tmp.tmp17 = 'R'
            #FUN-B60063----mod----end---
             INSERT INTO mds_result_tmp VALUES(g_tmp.*)
             IF STATUS THEN 
                 CALL cl_err('ins mds_result_tmp:',STATUS,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
                 EXIT PROGRAM 
             END IF
             IF l_result_qty <= g_tmp.tmp04 THEN
                 LET l_result_qty = l_result_qty - g_tmp.tmp04
                 EXIT FOREACH
             ELSE
                 LET l_result_qty = l_result_qty - g_tmp.tmp04
             END IF
         END FOREACH
     END IF

     #==>預測
     IF l_result_qty > 0 THEN #代表有餘量
         FOREACH p400_mds_for_c1 USING l_mds_all_tmp.tmp16,l_mds_all_tmp.tmp02 INTO g_tmp.*  #FUN-870104 mod
             IF l_result_qty < g_tmp.tmp04 THEN
                 LET g_tmp.tmp04  = l_result_qty
                 LET g_tmp.tmp041 = l_result_qty
                 LET g_tmp.tmp042 = 0
             END IF
             LET g_tmp.tmp11 = l_max_sum
             LET g_tmp.tmp12 = l_mds_qty
             LET g_tmp.tmp14 = 'Y' #餘量否
            #FUN-B60063----mod----str---
            ##FUN-AB0090---add----str---
            #IF g_tmp.tmp10 = '3' THEN #預測           
            #   #LET g_tmp.tmp10 = 'F'                 #需求來源 #TQC-AC0226 mark
            #    LET g_tmp.tmp17 = 'F'                 #需求來源 #TQC-AC0226 add
            #ELSE
            #   #LET g_tmp.tmp10 = 'R'                 #需求來源 #TQC-AC0226 mark
            #    LET g_tmp.tmp17 = 'R'                 #需求來源 #TQC-AC0226 add
            #END IF
            ##FUN-AB0090---add----end---
             LET g_tmp.tmp17 = 'F'
            #FUN-B60063----mod----end---
             INSERT INTO mds_result_tmp VALUES(g_tmp.*)
             IF STATUS THEN 
                 CALL cl_err('ins mds_result_tmp:',STATUS,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
                 EXIT PROGRAM 
             END IF
             IF l_result_qty <= g_tmp.tmp04 THEN
                 LET l_result_qty = l_result_qty - g_tmp.tmp04
                 EXIT FOREACH
             ELSE
                 LET l_result_qty = l_result_qty - g_tmp.tmp04
             END IF
         END FOREACH
     END IF
     CALL p400_ins_vlf_new(l_mds_all_tmp.tmp16,l_mds_all_tmp.tmp02) #FUN-B60063 add
  END FOREACH
  #FUN-870104---mod---end--
      
END FUNCTION

FUNCTION p400_del()
   DELETE FROM vmu_file 
    WHERE vmu01 = g_vld.vld01
      AND vmu02 = g_vld.vld02
   IF STATUS THEN 
       CALL cl_err('del vmu_file',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
       EXIT PROGRAM 
   END IF
   DELETE FROM vle_file 
    WHERE vle01 = g_vld.vld01
      AND vle02 = g_vld.vld02
   IF STATUS THEN 
       CALL cl_err('del vle_file',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
       EXIT PROGRAM 
   END IF
   DELETE FROM vlf_file 
    WHERE vlf01 = g_vld.vld01
      AND vlf02 = g_vld.vld02
   IF STATUS THEN 
       CALL cl_err('del vlf_file',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
       EXIT PROGRAM 
   END IF
END FUNCTION

FUNCTION p400_ins_mds()          # 產生APS需求訂單檔(vmu_file)/MDS沖銷關聯檔(vle_file)
  DEFINE l_all_item       LIKE  vle_file.vle03  #料號          
  DEFINE l_vlp02_1        LIKE  vlp_file.vlp02  #FUN-AB0090 add
  DEFINE l_vlp02_2        LIKE  vlp_file.vlp02  #FUN-AB0090 add
  DEFINE l_vlp02_3        LIKE  vlp_file.vlp02  #FUN-AB0090 add

 #FUN-870104 mark--str--
 #沒有用到的CURSOR mark掉
 #LET g_sql="SELECT UNIQUE tmp01 ",
 #          "  FROM mds_tmp",
 #          "  ORDER BY tmp01 "
 #PREPARE p400_mds_all_p2 FROM g_sql
 #DECLARE p400_mds_all_c2 CURSOR FOR p400_mds_all_p2
 #FUN-870104 mark--end--
 #FUN-AB0090--mark---str--
 #LET g_sql="SELECT * ",
 #          "  FROM mds_result_tmp",
 #          "  ORDER BY tmp03 " #需求日期
 #FUN-AB0090--mark---end--
 #FUN-AB0090--add----str--
  CALL p400_get_order()
 #FUN-B50022--mod---str---
 #LET g_sql="SELECT mds_result_tmp.* ,item_tmp.vlp02_1,customer_tmp.vlp02_2,sales_tmp.vlp02_3 ",
 #          "  FROM mds_result_tmp,",
 #          " (SELECT vlp03 vlp03_1,vlp02 vlp02_1 FROM vlp_file WHERE vlp01 = '1' ) item_tmp, ",
 #          " (SELECT vlp03 vlp03_2,vlp02 vlp02_2 FROM vlp_file WHERE vlp01 = '2' ) customer_tmp, ",
 #          " (SELECT vlp03 vlp03_3,vlp02 vlp02_3 FROM vlp_file WHERE vlp01 = '3' ) sales_tmp ",
 #          " WHERE mds_result_tmp.tmp01 =     item_tmp.vlp03_1 (+) ",
 #          "   AND mds_result_tmp.tmp08 = customer_tmp.vlp03_2 (+) ",
 #          "   AND mds_result_tmp.tmp09 =    sales_tmp.vlp03_3 (+) ",
 #          "  ORDER BY ",g_order1 CLIPPED,",",
 #                        g_order2 CLIPPED,",",
 #                        g_order3 CLIPPED,",",
 #          "mds_result_tmp.tmp03 " #需求日期
  LET g_sql="SELECT mds_result_tmp.* ,item_tmp.vlp02_1,customer_tmp.vlp02_2,sales_tmp.vlp02_3 ",
            "  FROM mds_result_tmp ",
            "  LEFT OUTER JOIN (SELECT vlp03 vlp03_1,vlp02 vlp02_1 FROM vlp_file WHERE vlp01 = '1' ) item_tmp     ON mds_result_tmp.tmp01 = item_tmp.vlp03_1 ",
            "  LEFT OUTER JOIN (SELECT vlp03 vlp03_2,vlp02 vlp02_2 FROM vlp_file WHERE vlp01 = '2' ) customer_tmp ON mds_result_tmp.tmp08 = customer_tmp.vlp03_2 ",
            "  LEFT OUTER JOIN (SELECT vlp03 vlp03_3,vlp02 vlp02_3 FROM vlp_file WHERE vlp01 = '3' ) sales_tmp    ON mds_result_tmp.tmp09 = sales_tmp.vlp03_3 ",
            "  ORDER BY ",g_order1 CLIPPED,",",
                          g_order2 CLIPPED,",",
                          g_order3 CLIPPED,",",
            "mds_result_tmp.tmp03 " #需求日期
 #FUN-B50022--mod---end---
 #FUN-AB0090--add----end--
  PREPARE p400_ins_vmu_p1 FROM g_sql
  DECLARE p400_ins_vmu_c1 CURSOR FOR p400_ins_vmu_p1

  LET g_seq  = 0
  LET g_pri = 10
  INITIALIZE g_tmp.* TO NULL
  FOREACH p400_ins_vmu_c1 INTO g_tmp.*,l_vlp02_1,l_vlp02_2,l_vlp02_3
      CALL p400_ins_vmu()
     #CALL p400_ins_vle() #FUN-B60063 mark
      LET g_pri = g_pri + 10
  END FOREACH
END FUNCTION

FUNCTION p400_ins_vmu()
  DEFINE l_chr4       LIKE type_file.chr4
  DEFINE l_oea10      LIKE oea_file.oea10
  DEFINE l_oeb24      LIKE oeb_file.oeb24
  DEFINE l_oeb05      LIKE oeb_file.oeb05
  DEFINE l_oeb05_fac  LIKE oeb_file.oeb05_fac
  DEFINE l_oeb11      LIKE oeb_file.oeb11
  DEFINE l_occ34      LIKE occ_file.occ34
  DEFINE l_ima31      LIKE ima_file.ima31
  DEFINE l_ima31_fac  LIKE ima_file.ima31_fac


  INITIALIZE g_vmu.* TO NULL
  LET g_vmu.vmu01 = g_vld.vld01             #APS版本
  LET g_vmu.vmu02 = g_vld.vld02             #儲存版本
 #TQC-AC0226--mod---str--
 #FUN-AB0090--mod---str--
 #IF g_tmp.tmp10 = '3' THEN #預測           #需求訂單編號
 #IF g_tmp.tmp10 = 'F' THEN #預測           #需求訂單編號
 #FUN-AB0090--mod---end--
  IF g_tmp.tmp10 = '3' THEN #預測           #需求訂單編號
 #TQC-AC0226--mod---end--
      LET g_seq = g_seq + 1
     #LET g_vmu.vmu03 = 'FORECAST-',g_seq USING '&&&&'   #FUN-B70026 mark 
      LET g_vmu.vmu03 = 'FORECAST-',g_seq USING '&&&&&&' #FUN-B70026 add   
      LET g_vmu.vmu08 = 'F'                 #需求來源
      #FUN-B60063--add----str---
      UPDATE vlf_file
         SET vlf26 = g_vmu.vmu03
        WHERE vlf01 = g_vld.vld01
          AND vlf02 = g_vld.vld02
          AND vlf03 = g_tmp.tmp01 #料號       opd01 vmu23 
          AND vlf21 = g_tmp.tmp08 #客戶編號   opd02 vmu06  
          AND vlf22 = g_tmp.tmp07 #計劃日期   opd03 vmu18 
          AND vlf23 = g_tmp.tmp09 #業務員     opd04 vmu16 
          AND vlf24 = g_tmp.tmp06 #序號       opd05 vmu26 
          AND vlf29 = '1'         #預測餘量
      #FUN-B60063--add----end---
  ELSE
      LET l_chr4  = g_tmp.tmp06 USING '&&&&'
      LET g_vmu.vmu03 = g_tmp.tmp05 CLIPPED,'-',l_chr4
      LET g_vmu.vmu08 = 'R'                 #需求來源
  END IF
  LET g_vmu.vmu04 = g_tmp.tmp03  #交期
  LET g_vmu.vmu05 = 0                     #可否耗用 #FUN-860060
  LET g_vmu.vmu06 = g_tmp.tmp08  #客戶編號
  LET g_vmu.vmu07 = 1                       #是否能排程
  LET g_vmu.vmu09 = NULL                    #產品族群編號
  LET g_vmu.vmu10 = g_pri                   #訂單優先順序
  LET g_vmu.vmu11 = g_tmp.tmp05  #單據編號
  LET g_vmu.vmu13 = g_tmp.tmp042 #已出貨量
  IF cl_null(g_vmu.vmu13) THEN
      LET g_vmu.vmu13 = 0        #已出貨量
  END IF
  IF g_tmp.tmp10 MATCHES '[01]' THEN
      SELECT   oea10,  oeb24,  oeb05,  oeb05_fac,  oeb11
        INTO l_oea10,l_oeb24,l_oeb05,l_oeb05_fac,l_oeb11
        FROM oea_file,oeb_file
       WHERE oea01 = oeb01
         AND oea00 = g_tmp.tmp10
         AND oeb01 = g_tmp.tmp05
         AND oeb03 = g_tmp.tmp06
      LET g_vmu.vmu12 = l_oea10         #客戶單號
      LET g_vmu.vmu14 = l_oeb05         #單位
      LET g_vmu.vmu17 = l_oeb05_fac     #銷售單位/庫存單位換算率
      LET g_vmu.vmu21 = l_oeb11         #客戶品號
  ELSE
      LET g_vmu.vmu12 = NULL            #客戶單號
      SELECT   ima31,  ima31_fac
        INTO l_ima31,l_ima31_fac
        FROM ima_file
       WHERE ima01 = g_tmp.tmp01
      LET g_vmu.vmu14 = l_ima31         #單位
      LET g_vmu.vmu17 = l_ima31_fac     #銷售單位/庫存單位換算率
      LET g_vmu.vmu21 = NULL            #客戶品號
  END IF
  LET g_tmp.tmp13 = g_vmu.vmu14         #單位
  IF g_tmp.tmp10 MATCHES '[013]' THEN
      SELECT occ34 INTO l_occ34
        FROM occ_file
       WHERE occ01 = g_vmu.vmu06
      LET g_vmu.vmu15 = l_occ34             #客戶群組編號
  ELSE
      LET g_vmu.vmu15 = NULL                #客戶群組編號
  END IF
  LET g_vmu.vmu16 = g_tmp.tmp09  #業務員
  LET g_vmu.vmu18 = g_tmp.tmp07  #單據開立日期/計劃日期
  LET g_vmu.vmu19 = NULL                    #分配法則
  LET g_vmu.vmu20 = NULL                    #運輸天數
  LET g_vmu.vmu22 = 0                       #是否嚴守交期( 0:否  1:是 )  
  LET g_vmu.vmu23 = g_tmp.tmp01  #料號
  LET g_vmu.vmu24 = g_tmp.tmp041 #數量
  LET g_vmu.vmu24 = s_digqty(g_vmu.vmu24,g_vmu.vmu14)   #FUN-BB0085
  LET g_vmu.vmu13 = s_digqty(g_vmu.vmu13,g_vmu.vmu14)   #FUN-BB0085
  LET g_vmu.vmu25 = g_tmp.tmp10  #需求來源類別

 #FUN-940064 ADD  --STR--
  IF g_vmu.vmu25='1' THEN
     SELECT * FROM oeb_file 
      WHERE oeb01 = g_tmp.tmp05
        AND oeb03 = g_tmp.tmp06 
        AND oeb19 = 'Y'
        AND oeb905 > 0   
     IF NOT STATUS THEN
        LET g_vmu.vmu22 = 1
     END IF
  END IF 
 #FUN-940064 ADD  --END--
 
 LET g_vmu.vmu26 = g_tmp.tmp06  #(訂單oeb02/合約oeb02/獨立需求單rpc03/預測opd05)的項次

  LET g_vmu.vmulegal = g_legal
  LET g_vmu.vmuplant = g_plant
  
  INSERT INTO vmu_file VALUES(g_vmu.*)
  IF STATUS THEN 
      CALL cl_err('ins vmu_file:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
      EXIT PROGRAM 
  END IF
END FUNCTION

FUNCTION p400_ins_vle()
  INITIALIZE g_vle.* TO NULL
  LET g_vle.vle01 = g_vld.vld01
  LET g_vle.vle02 = g_vld.vld02
  LET g_vle.vle03 = g_tmp.tmp01
  LET g_vle.vle04 = g_tmp.tmp02
  LET g_vle.vle05 = g_vld.vld10
  LET g_vle.vle06 = g_tmp.tmp11
  LET g_vle.vle07 = g_tmp.tmp12
  LET g_vle.vle08 = g_tmp.tmp03
  LET g_vle.vle09 = g_tmp.tmp04
  LET g_vle.vle10 = g_tmp.tmp13
  LET g_vle.vle11 = g_tmp.tmp05
  LET g_vle.vle12 = g_tmp.tmp06
  LET g_vle.vle13 = g_tmp.tmp07
  LET g_vle.vle14 = g_tmp.tmp08
  LET g_vle.vle15 = g_tmp.tmp09
  LET g_vle.vle16 = g_tmp.tmp10
 #LET g_vle.vle17 = g_tmp.tmp14
 #LET g_vle.vle18 = g_vmu.vmu03
 #LET g_vle.vle19 = g_vmu.vmu10
  LET g_vle.vleplant = g_plant #FUN-B50022 add
  LET g_vle.vlelegal = g_legal #FUN-B50022 add
  INSERT INTO vle_file VALUES(g_vle.*)
  IF STATUS THEN 
      CALL cl_err('ins vle_file:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
      EXIT PROGRAM 
  END IF
END FUNCTION

FUNCTION p400_cre_tmp()          # 建立本程式所有會用到的TEMP TABLE
 
  #==>MDS 沖銷資料來源暫存檔
  DROP TABLE mds_tmp
  CREATE TEMP TABLE mds_tmp(
                           tmp01   LIKE  vle_file.vle03, #料號          
                           tmp02   LIKE  vle_file.vle04, #歸屬時距日    
                           tmp03   LIKE  vle_file.vle08, #需求日期      
                           tmp04   LIKE  vle_file.vle09, #數量          
                           tmp041  LIKE  vle_file.vle09, #數量          
                           tmp042  LIKE  vle_file.vle09, #數量          
                           tmp05   LIKE  vle_file.vle11, #單據編號      
                           tmp06   LIKE  vle_file.vle12, #項次          
                           tmp07   LIKE  vle_file.vle13, #單據開立日期  
                           tmp08   LIKE  vle_file.vle14, #客戶編號      
                           tmp09   LIKE  vle_file.vle15, #業務員        
                           tmp10   LIKE  vle_file.vle16, #需求來源型式  #(0:一般訂單 1:合約訂單 2:獨立需求 3:預測)
                           tmp11   LIKE  vle_file.vle06, #時距內最大納入量
                           tmp12   LIKE  vle_file.vle06, #沖銷結果(>0 :表餘量 <0 不足)
                           tmp13   LIKE  vle_file.vle10, #單位
                           tmp14   LIKE  vle_file.vle14, #餘量否
                           tmp15   LIKE  vle_file.vle12, #序號
                           tmp16   LIKE  vle_file.vle03, #預測料號 #FUN-870104 add
                           tmp17   LIKE  vle_file.vle16 )#需求型式('R'=>tmp10 in ('0','1','2'); 'F'=>tmp10 in ('3') #TQC-AC0226 add
  CREATE INDEX mds_tmp_idx ON mds_tmp (tmp16,tmp02)  #FUN-B60063 add
  #==>MDS 沖銷結果暫存檔
  DROP TABLE mds_result_tmp
  CREATE TEMP TABLE mds_result_tmp(
                           tmp01   LIKE  vle_file.vle03, #料號          
                           tmp02   LIKE  vle_file.vle04, #歸屬時距日    
                           tmp03   LIKE  vle_file.vle08, #需求日期      
                           tmp04   LIKE  vle_file.vle09, #數量          
                           tmp041  LIKE  vle_file.vle09, #數量          
                           tmp042  LIKE  vle_file.vle09, #數量          
                           tmp05   LIKE  vle_file.vle11, #單據編號      
                           tmp06   LIKE  vle_file.vle12, #項次          
                           tmp07   LIKE  vle_file.vle13, #單據開立日期  
                           tmp08   LIKE  vle_file.vle14, #客戶編號      
                           tmp09   LIKE  vle_file.vle15, #業務員        
                           tmp10   LIKE  vle_file.vle16, #需求來源型式  #(0:一般訂單 1:合約訂單 2:獨立需求 3:預測)
                           tmp11   LIKE  vle_file.vle06, #時距內最大納入量
                           tmp12   LIKE  vle_file.vle06, #沖銷結果(>0 :表餘量 <0 不足)
                           tmp13   LIKE  vle_file.vle10, #單位
                           tmp14   LIKE  vle_file.vle14, #餘量否
                           tmp15   LIKE  vle_file.vle12, #序號
                           tmp16   LIKE  vle_file.vle03, #預測料號 #FUN-870104 add
                           tmp17   LIKE  vle_file.vle16 )#需求型式('R'=>tmp10 in ('0','1','2'); 'F'=>tmp10 in ('3') #TQC-AC0226 add
 #FUN-B60063--mark---str---
 ##==>需求暫存檔
 #DROP TABLE req_tmp
 #CREATE TEMP TABLE req_tmp(
 #                         tmp01   LIKE  vle_file.vle03, #料號          
 #                         tmp02   LIKE  vle_file.vle04, #歸屬時距日    
 #                         tmp03   LIKE  vle_file.vle08, #需求日期      
 #                         tmp04   LIKE  vle_file.vle09, #數量          
 #                         tmp041  LIKE  vle_file.vle09, #數量          
 #                         tmp042  LIKE  vle_file.vle09, #數量          
 #                         tmp05   LIKE  vle_file.vle11, #單據編號      
 #                         tmp06   LIKE  vle_file.vle12, #項次          
 #                         tmp07   LIKE  vle_file.vle13, #單據開立日期  
 #                         tmp08   LIKE  vle_file.vle14, #客戶編號      
 #                         tmp09   LIKE  vle_file.vle15, #業務員        
 #                         tmp10   LIKE  vle_file.vle16, #需求來源型式  #(0:一般訂單 1:合約訂單 2:獨立需求 3:預測)
 #                         tmp11   LIKE  vle_file.vle06, #時距內最大納入量
 #                         tmp12   LIKE  vle_file.vle06, #沖銷結果(>0 :表餘量 <0 不足)
 #                         tmp13   LIKE  vle_file.vle10, #單位
 #                         tmp14   LIKE  vle_file.vle14, #餘量否
 #                         tmp15   LIKE  vle_file.vle12, #序號
 #                         tmp16   LIKE  vle_file.vle03, #預測料號 #FUN-870104 add
 #                         tmp17   LIKE  vle_file.vle16 )#需求型式('R'=>tmp10 in ('0','1','2'); 'F'=>tmp10 in ('3') #TQC-AC0226 add
 ##==>預測暫存檔
 #DROP TABLE for_tmp
 #CREATE TEMP TABLE for_tmp(
 #                         tmp01   LIKE  vle_file.vle03, #料號          
 #                         tmp02   LIKE  vle_file.vle04, #歸屬時距日    
 #                         tmp03   LIKE  vle_file.vle08, #需求日期      
 #                         tmp04   LIKE  vle_file.vle09, #數量          
 #                         tmp041  LIKE  vle_file.vle09, #數量          
 #                         tmp042  LIKE  vle_file.vle09, #數量          
 #                         tmp05   LIKE  vle_file.vle11, #單據編號      
 #                         tmp06   LIKE  vle_file.vle12, #項次          
 #                         tmp07   LIKE  vle_file.vle13, #單據開立日期  
 #                         tmp08   LIKE  vle_file.vle14, #客戶編號      
 #                         tmp09   LIKE  vle_file.vle15, #業務員        
 #                         tmp10   LIKE  vle_file.vle16, #需求來源型式  #(0:一般訂單 1:合約訂單 2:獨立需求 3:預測)
 #                         tmp11   LIKE  vle_file.vle06, #時距內最大納入量
 #                         tmp12   LIKE  vle_file.vle06, #沖銷結果(>0 :表餘量 <0 不足)
 #                         tmp13   LIKE  vle_file.vle10, #單位
 #                         tmp14   LIKE  vle_file.vle14, #餘量否
 #                         tmp15   LIKE  vle_file.vle12, #序號
 #                         tmp16   LIKE  vle_file.vle03, #預測料號 #FUN-870104 add
 #                         tmp17   LIKE  vle_file.vle16 )#需求型式('R'=>tmp10 in ('0','1','2'); 'F'=>tmp10 in ('3') #TQC-AC0226 add
 #FUN-B60063--mark---end---
END FUNCTION

#FUN-B60063--mark--str---
#FUNCTION p400_ins_vlf() #產生MDS沖銷關聯檔
#  DEFINE l_tmp15        LIKE   type_file.num10   
#  DEFINE l_vlf16        LIKE   vlf_file.vlf16
#  DEFINE l_vlf26        LIKE   vlf_file.vlf26
#  DEFINE l_req_end      LIKE   type_file.chr1
#  DEFINE l_for_end      LIKE   type_file.chr1
#  DEFINE l_i            LIKE   type_file.num10   
#  DEFINE l_j            LIKE   type_file.num10   
#  DEFINE l_req          LIKE   type_file.num10   
#  DEFINE l_for          LIKE   type_file.num10   
#  DEFINE l_req_sum      LIKE   vle_file.vle06
#  DEFINE l_for_sum      LIKE   vle_file.vle06
#  DEFINE l_max_sum      LIKE   vle_file.vle06
#  DEFINE l_max_sum_co   LIKE   vle_file.vle06
#  DEFINE l_result_qty   LIKE   vle_file.vle06
#  DEFINE l_mds_qty      LIKE   vle_file.vle06
#  DEFINE l_req_cmp      LIKE   vle_file.vle06
#  DEFINE l_for_cmp      LIKE   vle_file.vle06
#  #FUN-870104---mod---str---
#  #tmp01 全面換成tmp16
#  DEFINE l_mds_all_tmp  RECORD                                          
#                           tmp16   LIKE  vle_file.vle03, #料號          #FUN-870104 mod
#                           tmp02   LIKE  vle_file.vle04  #歸屬時距日    
#                        END RECORD
#
#  LET g_sql="SELECT UNIQUE tmp16,tmp02 ",  #FUN-870104 mod
#            "  FROM mds_tmp",
#            "  ORDER BY tmp16,tmp02 "      #FUN-870104 mod
#  PREPARE p400_mds_all_p3 FROM g_sql
#  DECLARE p400_mds_all_c3 CURSOR FOR p400_mds_all_p3
#  #==>需求
#  LET g_sql="SELECT * ",
#            "  FROM mds_tmp",
#            " WHERE tmp16 = ? ",  #FUN-870104 mod
#            "   AND tmp02 = ? ",
#            "   AND tmp10 IN ('0','1','2') ",
#            "  ORDER BY tmp03 "
#  PREPARE p400_ins_req_p1 FROM g_sql
#  DECLARE p400_ins_req_c1 CURSOR FOR p400_ins_req_p1
#
#  #==>預測
#  LET g_sql="SELECT * ",
#            "  FROM mds_tmp",
#            " WHERE tmp16 = ? ",  #FUN-870104 mod
#            "   AND tmp02 = ? ",
#            "   AND tmp10 IN ('3') ",
#            "  ORDER BY tmp03,tmp041,tmp08 " #FUN-870104 mod
#  PREPARE p400_ins_for_p1 FROM g_sql
#  DECLARE p400_ins_for_c1 CURSOR FOR p400_ins_for_p1
#
#  FOREACH p400_mds_all_c3 INTO l_mds_all_tmp.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach p400_mds_all_c1:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     #==>需求
#     SELECT SUM(tmp04) 
#       INTO l_req_sum
#       FROM mds_tmp
#      WHERE tmp16 = l_mds_all_tmp.tmp16 #料號  #FUN-870104 mod
#        AND tmp02 = l_mds_all_tmp.tmp02 #歸屬時距日
#        AND tmp10 IN ('0','1','2')      #需求
#     #==>預測
#     SELECT SUM(tmp04) 
#       INTO l_for_sum
#       FROM mds_tmp
#      WHERE tmp16 = l_mds_all_tmp.tmp16 #料號  #FUN-870104 mod
#        AND tmp02 = l_mds_all_tmp.tmp02 #歸屬時距日
#        AND tmp10 IN ('3')              #預測
#     IF cl_null(l_req_sum) THEN LET l_req_sum = 0 END IF
#     IF cl_null(l_for_sum) THEN LET l_for_sum = 0 END IF
#     IF g_vld.vld10 = '1' THEN #需求量納入方式 1:以訂單為主
#         LET l_max_sum = l_req_sum
#     END IF
#     IF g_vld.vld10 = '2' THEN #需求量納入方式 2:以預測為主
#         LET l_max_sum = l_for_sum   
#     END IF
#     IF g_vld.vld10 = '3' THEN #需求量納入方式 3:兩者取其大
#         IF l_req_sum >= l_for_sum THEN
#             LET l_max_sum = l_req_sum   
#         ELSE
#             LET l_max_sum = l_for_sum   
#         END IF
#     END IF
#     #FUN-870104---add----str--
#     IF g_vld.vld10 = '4' THEN #需求量納入方式 4:有訂單取訂單;沒訂單取預測
#         IF l_req_sum <> 0 THEN
#             LET l_max_sum = l_req_sum   
#         ELSE
#             LET l_max_sum = l_for_sum   
#         END IF
#     END IF
#     #FUN-870104---add----str--
#
#     #FUN-940001  ADD   --STR--
#      IF g_vld.vld10 = '5' THEN
#         IF l_mds_all_tmp.tmp02 >= l_vld12b AND
#            l_mds_all_tmp.tmp02 < l_vld12e THEN
#            LET l_max_sum = l_req_sum       #依訂單
#         ELSE
#            LET l_max_sum = l_for_sum
#         END IF
#      END IF
#     #FUN-940001  ADD    --END--
#
#
#
#     LET l_max_sum_co = l_max_sum
#     #==>需求
#     LET l_tmp15  = 0
#     FOREACH p400_ins_req_c1 USING l_mds_all_tmp.tmp16,l_mds_all_tmp.tmp02 INTO g_req_tmp.* #FUN-870104 mod
#         LET l_tmp15 = l_tmp15 + 1
#         INSERT INTO req_tmp VALUES(g_req_tmp.tmp01,g_req_tmp.tmp02,g_req_tmp.tmp03,g_req_tmp.tmp04,g_req_tmp.tmp041,g_req_tmp.tmp042,g_req_tmp.tmp05,
#                                    g_req_tmp.tmp06,g_req_tmp.tmp07,g_req_tmp.tmp08,g_req_tmp.tmp09,g_req_tmp.tmp10,
#                                    g_req_tmp.tmp11,g_req_tmp.tmp12,g_req_tmp.tmp13,g_req_tmp.tmp14,l_tmp15,l_mds_all_tmp.tmp16,g_req_tmp.tmp17)  #FUN-870104 mod #TQC-AC0226 add tmp17
#         IF STATUS THEN 
#             CALL cl_err('ins req_tmp:',STATUS,1)
#             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
#             EXIT PROGRAM 
#         END IF
#     END FOREACH
#     #==>預測
#     LET l_tmp15 = 0 
#     FOREACH p400_ins_for_c1 USING l_mds_all_tmp.tmp16,l_mds_all_tmp.tmp02 INTO g_for_tmp.*  #FUN-870104 mod
#         LET l_tmp15 = l_tmp15 + 1
#         INSERT INTO for_tmp VALUES(g_for_tmp.tmp01,g_for_tmp.tmp02,g_for_tmp.tmp03,g_for_tmp.tmp04,g_for_tmp.tmp041,g_for_tmp.tmp042,g_for_tmp.tmp05,
#                                    g_for_tmp.tmp06,g_for_tmp.tmp07,g_for_tmp.tmp08,g_for_tmp.tmp09,g_for_tmp.tmp10,
#                                    g_for_tmp.tmp11,g_for_tmp.tmp12,g_for_tmp.tmp13,g_for_tmp.tmp14,l_tmp15,l_mds_all_tmp.tmp16,g_req_tmp.tmp17)  #FUN-870104 mod #TQC-AC0226 add tmp17
#         IF STATUS THEN 
#             CALL cl_err('ins for_tmp:',STATUS,1) 
#             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
#             EXIT PROGRAM 
#         END IF
#     END FOREACH
#     LET l_req = 1
#     LET l_for = 1
#     LET l_req_end = 'N'
#     LET l_for_end = 'N'
#     #==>需求
#     SELECT * INTO g_req_tmp.*
#       FROM req_tmp
#      WHERE tmp16 = l_mds_all_tmp.tmp16  #FUN-870104 mod
#        AND tmp02 = l_mds_all_tmp.tmp02
#        AND tmp15 = l_req
#     IF STATUS THEN LET l_req_end = 'Y' END IF
#     #==>預測
#     SELECT * INTO g_for_tmp.*
#       FROM for_tmp
#      WHERE tmp16 = l_mds_all_tmp.tmp16  #FUN-870104 mod
#        AND tmp02 = l_mds_all_tmp.tmp02
#        AND tmp15 = l_for
#     IF STATUS THEN LET l_for_end = 'Y' END IF
#     IF cl_null(g_req_tmp.tmp04) THEN LET g_req_tmp.tmp04 = 0 END IF
#     IF cl_null(g_for_tmp.tmp04) THEN LET g_for_tmp.tmp04 = 0 END IF
#     LET l_req_cmp = g_req_tmp.tmp04
#     LET l_for_cmp = g_for_tmp.tmp04
#     FOR l_i = 1 TO g_max_rec
#         INITIALIZE g_vlf.* TO NULL
#         IF l_req_end = 'N' AND l_for_end = 'N' THEN
#             LET g_cnt = l_req_cmp - l_for_cmp
#             CASE 
#                  WHEN g_cnt < 0 #需求小
#                           LET g_vlf.vlf18 = l_req_cmp 
#                           LET g_vlf.vlf28 = l_req_cmp
#                           LET l_max_sum_co = l_max_sum_co - l_req_cmp  
#                  WHEN g_cnt > 0 #預測小
#                           LET g_vlf.vlf18 = l_for_cmp
#                           LET g_vlf.vlf28 = l_for_cmp
#                           LET l_max_sum_co = l_max_sum_co - l_for_cmp  
#                  WHEN g_cnt = 0 #需求=預測
#                           LET g_vlf.vlf18 = l_req_cmp 
#                           LET g_vlf.vlf28 = l_req_cmp
#                           LET l_max_sum_co = l_max_sum_co - l_req_cmp  
#             END CASE
#         ELSE
#             IF l_req_end = 'Y' THEN
#                 LET g_vlf.vlf18 = l_for_cmp
#                 LET g_vlf.vlf28 = l_for_cmp
#                 LET l_max_sum_co = l_max_sum_co - l_for_cmp  
#             ELSE
#                 LET g_vlf.vlf18 = l_req_cmp 
#                 LET g_vlf.vlf28 = l_req_cmp
#                 LET l_max_sum_co = l_max_sum_co - l_req_cmp  
#             END IF
#         END IF
#         LET g_vlf.vlf01 = g_vld.vld01            #APS版本                                          */
#         LET g_vlf.vlf02 = g_vld.vld02            #儲存版本                                         */
#         IF l_req_end = 'N' THEN
#             LET g_vlf.vlf03 = g_req_tmp.tmp16        #料號                                             */ #FUN-870104 mod
#             LET g_vlf.vlf04 = g_req_tmp.tmp02        #歸屬時距                                         */
#         ELSE
#             LET g_vlf.vlf03 = g_for_tmp.tmp16        #料號                                             */ #FUN-870104 mod
#             LET g_vlf.vlf04 = g_for_tmp.tmp02        #歸屬時距                                         */
#         END IF
#         LET g_vlf.vlf05 = l_i                    #序號                                             */
#         LET g_vlf.vlf06 = g_vld.vld10            #需求量納入方式                                   */
#         #TQC-890061---mod-----str----
#         IF g_vlf.vlf04 = '99/01/01' THEN
#             LET g_vlf.vlf06 = '0'                #需求量納入方式 ==>'0':零期資料
#             LET l_max_sum = l_req_sum
#         END IF
#         IF g_vlf.vlf04 = '99/12/31' THEN
#             LET g_vlf.vlf06 = '9'                #需求量納入方式 ==>'9':獨立需求
#             LET l_max_sum = l_req_sum
#         END IF
#         #TQC-890061---mod-----end----
#         LET g_vlf.vlf07 = l_max_sum              #時距內總需求量                                   */
#         LET g_vlf.vlf08 = NULL                   #NO USE                                           */
#         LET g_vlf.vlf09 = NULL                   #NO USE                                           */
#         #*****************************************需求**********************************************/
#         IF l_req_end = 'N' THEN
#             LET g_vlf.vlf10 = g_req_tmp.tmp05        #需求--訂單編號 oeb01/rpc02                       */
#             LET g_vlf.vlf11 = g_req_tmp.tmp06        #需求--項次     oeb03/rpc03                       */
#             LET g_vlf.vlf12 = g_req_tmp.tmp07        #需求--單據日期 oea02/rpc21                       */
#             LET g_vlf.vlf13 = g_req_tmp.tmp10        #需求--來源型式 0:一般訂單 1:合約訂單 2:獨立需求  */
#             LET g_vlf.vlf14 = NULL                   #NO USE                                           */
#             LET g_vlf.vlf15 = g_req_tmp.tmp01        #FUN-870104--mod #實際料號
#             LET l_vlf16 = NULL
#             CASE g_vlf.vlf13
#                  WHEN '0'
#                          SELECT vmu03 INTO l_vlf16 
#                            FROM vmu_file
#                           WHERE vmu01 = g_vld.vld01
#                             AND vmu02 = g_vld.vld02
#                             AND vmu11 = g_vlf.vlf10
#                             AND vmu26 = g_vlf.vlf11
#                  WHEN '1'
#                          SELECT vmu03 INTO l_vlf16 
#                            FROM vmu_file
#                           WHERE vmu01 = g_vld.vld01
#                             AND vmu02 = g_vld.vld02
#                             AND vmu11 = g_vlf.vlf10
#                             AND vmu26 = g_vlf.vlf11
#                  WHEN '2'
#                          SELECT vmu03 INTO l_vlf16 
#                            FROM vmu_file
#                           WHERE vmu01 = g_vld.vld01
#                             AND vmu02 = g_vld.vld02
#                             AND vmu11 = g_vlf.vlf10
#                             AND vmu26 = g_vlf.vlf11
#                             AND vmu18 = g_vlf.vlf12
#             END CASE
#             LET g_vlf.vlf16 = l_vlf16                #需求單號vmu03
#             LET g_vlf.vlf17 = g_req_tmp.tmp03        #需求--需求日期 #oeb15/oeb16          #rpc12      */
#            #LET g_vlf.vlf18 =                        #需求--沖銷量                                     */
#             #TQC-890061---mod---str---
#             IF g_vlf.vlf06 MATCHES '[09]' THEN       #需求量納入方式 ==>'0':零期資料 '9':獨立需求
#                 LET g_vlf.vlf19 = '3'                #需求--沖銷狀況 3:直接納入                        */
#             ELSE
#                 IF l_for_end = 'N' THEN
#                     LET g_vlf.vlf19 = '0'                #需求--沖銷狀況 0:完全沖銷                        */
#                 ELSE
#                     IF l_max_sum_co >= 0 THEN
#                         LET g_vlf.vlf19 = '1'            #1:需求多
#                     ELSE
#                         LET g_vlf.vlf19 = '2'            #2:未沖
#                     END IF
#                 END IF
#             END IF
#             #TQC-890061---mod---end---
#         ELSE
#             LET g_vlf.vlf10 = NULL                   #需求--訂單編號 oeb01/rpc02                       */
#             LET g_vlf.vlf11 = NULL                   #需求--項次     oeb03/rpc03                       */
#             LET g_vlf.vlf12 = NULL                   #需求--單據日期 oea02/rpc21                       */
#             LET g_vlf.vlf13 = NULL                   #需求--來源型式 0:一般訂單 1:合約訂單 2:獨立需求  */
#             LET g_vlf.vlf14 = NULL                   #NO USE                                           */
#             LET g_vlf.vlf15 = NULL                   #實際料號#FUN-870104 mod
#             LET g_vlf.vlf16 = NULL                   #NO USE                                           */
#             LET g_vlf.vlf17 = NULL                   #需求--需求日期 #oeb15/oeb16          #rpc12      */
#             LET g_vlf.vlf18 = NULL                   #需求--沖銷量                                     */
#             LET g_vlf.vlf19 = NULL                   #需求--沖銷狀況                                   */
#         END IF
#         #***************=                        #預測**********************************************/
#         IF l_for_end = 'N' THEN
#             LET g_vlf.vlf20 = 'FORECAST'             #預測--FORECAST                                   */
#             LET g_vlf.vlf21 = g_for_tmp.tmp08        #預測--客戶編號   opd02                           */
#             LET g_vlf.vlf22 = g_for_tmp.tmp07        #預測--計劃日期   opd03                           */
#             LET g_vlf.vlf23 = g_for_tmp.tmp09        #預測--業務員     opd04                           */
#             LET g_vlf.vlf24 = g_for_tmp.tmp06        #預測--序號       opd05                           */
#             LET g_vlf.vlf25 = g_for_tmp.tmp01        #FUN-870104 mod #實際料號
#             LET l_vlf26 = NULL
#             SELECT vmu03 INTO l_vlf26
#               FROM vmu_file
#              WHERE vmu01 = g_vld.vld01
#                AND vmu02 = g_vld.vld02
#                AND vmu23 = g_vlf.vlf03 #料號       opd01
#                AND vmu06 = g_vlf.vlf21 #客戶編號   opd02 
#                AND vmu18 = g_vlf.vlf22 #計劃日期   opd03
#                AND vmu16 = g_vlf.vlf23 #業務員     opd04
#                AND vmu26 = g_vlf.vlf24 #序號       opd05
#             IF l_vlf26[1,8] = 'FORECAST' THEN
#                 LET g_vlf.vlf26 = l_vlf26                #vmu03                                            */
#             ELSE
#                 LET g_vlf.vlf26 = NULL
#             END IF
#             LET g_vlf.vlf27 = g_for_tmp.tmp03        #預測--計劃起始日 opd06                           */
#            #LET g_vlf.vlf28 =                        #預測--沖銷量                                     */
#             LET g_vlf.vlf29 = '0'                    #預測--沖銷狀況                                   */
#             IF l_req_end = 'N' THEN
#                 LET g_vlf.vlf29 = '0'                #需求--沖銷狀況 0:完全沖銷                        */
#                 LET g_vlf.vlf26 = NULL               #FUN-870104 add
#             ELSE
#                 IF l_max_sum_co >= 0 THEN
#                     LET g_vlf.vlf29 = '1'            #1:需求多
#                 ELSE
#                     LET g_vlf.vlf29 = '2'            #2:未沖
#                 END IF
#             END IF
#         ELSE
#             LET g_vlf.vlf20 = NULL                   #預測--FORECAST                                   */
#             LET g_vlf.vlf21 = NULL                   #預測--客戶編號   opd02                           */
#             LET g_vlf.vlf22 = NULL                   #預測--計劃日期   opd03                           */
#             LET g_vlf.vlf23 = NULL                   #預測--業務員     opd04                           */
#             LET g_vlf.vlf24 = NULL                   #預測--序號       opd05                           */
#             LET g_vlf.vlf25 = NULL                   #實際料號 #FUN-870104 mod
#             LET g_vlf.vlf26 = NULL                   #NO USE                                           */
#             LET g_vlf.vlf27 = NULL                   #預測--計劃起始日 opd06                           */
#             LET g_vlf.vlf28 = NULL                   #預測--沖銷量                                     */
#             LET g_vlf.vlf29 = NULL                   #預測--沖銷狀況                                   */
#         END IF
#         LET g_vlf.vlfplant = g_plant #FUN-B50022 add
#         LEt g_vlf.vlflegal = g_legal #FUN-B50022 add
#         INSERT INTO vlf_file VALUES(g_vlf.*)
#         IF STATUS THEN 
#             CALL cl_err('ins vlf_file',STATUS,1) 
#             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
#             EXIT PROGRAM 
#         END IF
#            
#         IF l_req_end = 'N' AND l_for_end = 'N' THEN
#             CASE 
#                  WHEN g_cnt < 0 
#                           #預測大
#                           LET l_for_cmp = l_for_cmp - l_req_cmp
#             
#                           #需求小
#                           #==>需求重抓
#                           INITIALIZE g_req_tmp TO NULL
#                           LET l_req = l_req + 1
#                           SELECT * INTO g_req_tmp.*
#                             FROM req_tmp
#                            WHERE tmp16 = l_mds_all_tmp.tmp16 #FUN-870104 mod
#                              AND tmp02 = l_mds_all_tmp.tmp02
#                              AND tmp15 = l_req
#                           IF STATUS = 100 THEN LET l_req_end = 'Y' END IF
#                           LET l_req_cmp = g_req_tmp.tmp04
#                           IF cl_null(l_req_cmp) THEN LET l_req_cmp = 0 END IF
#                  WHEN g_cnt > 0
#                           #需求大
#                           LET l_req_cmp = l_req_cmp - l_for_cmp
#             
#                           #預測小
#                           #==>預測重抓
#                           INITIALIZE g_for_tmp TO NULL
#                           LET l_for = l_for + 1
#                           SELECT * INTO g_for_tmp.*
#                             FROM for_tmp
#                            WHERE tmp16 = l_mds_all_tmp.tmp16 #FUN-870104 mod
#                              AND tmp02 = l_mds_all_tmp.tmp02
#                              AND tmp15 = l_for
#                           IF STATUS = 100 THEN LET l_for_end = 'Y' END IF
#                           LET l_for_cmp = g_for_tmp.tmp04
#                           IF cl_null(l_for_cmp) THEN LET l_for_cmp = 0 END IF
#                  WHEN g_cnt = 0 
#                           #需求=預測
#                           #==>需求重抓
#                           INITIALIZE g_req_tmp TO NULL
#                           LET l_req = l_req + 1
#                           SELECT * INTO g_req_tmp.*
#                             FROM req_tmp
#                            WHERE tmp16 = l_mds_all_tmp.tmp16 #FUN-870104 mod
#                              AND tmp02 = l_mds_all_tmp.tmp02
#                              AND tmp15 = l_req
#                           IF STATUS = 100 THEN LET l_req_end = 'Y' END IF
#                           LET l_req_cmp = g_req_tmp.tmp04
#                           IF cl_null(l_req_cmp) THEN LET l_req_cmp = 0 END IF
#                           #==>預測重抓
#                           INITIALIZE g_for_tmp TO NULL
#                           LET l_for = l_for + 1
#                           SELECT * INTO g_for_tmp.*
#                             FROM for_tmp
#                            WHERE tmp16 = l_mds_all_tmp.tmp16 #FUN-870104 mod
#                              AND tmp02 = l_mds_all_tmp.tmp02
#                              AND tmp15 = l_for
#                           IF STATUS = 100 THEN LET l_for_end = 'Y' END IF
#                           LET l_for_cmp = g_for_tmp.tmp04
#                           IF cl_null(l_for_cmp) THEN LET l_for_cmp = 0 END IF
#             END CASE
#         ELSE
#             IF l_for_end = 'N' THEN
#                 #==>預測重抓
#                 INITIALIZE g_for_tmp TO NULL
#                 LET l_for = l_for + 1
#                 SELECT * INTO g_for_tmp.*
#                   FROM for_tmp
#                  WHERE tmp16 = l_mds_all_tmp.tmp16 #FUN-870104 mod
#                    AND tmp02 = l_mds_all_tmp.tmp02
#                    AND tmp15 = l_for
#                 IF STATUS = 100 THEN LET l_for_end = 'Y' END IF
#                 LET l_for_cmp = g_for_tmp.tmp04
#                 IF cl_null(l_for_cmp) THEN LET l_for_cmp = 0 END IF
#             ELSE
#                 #==>需求重抓
#                 INITIALIZE g_req_tmp TO NULL
#                 LET l_req = l_req + 1
#                 SELECT * INTO g_req_tmp.*
#                   FROM req_tmp
#                  WHERE tmp16 = l_mds_all_tmp.tmp16 #FUN-870104 mod
#                    AND tmp02 = l_mds_all_tmp.tmp02
#                    AND tmp15 = l_req
#                 IF STATUS = 100 THEN LET l_req_end = 'Y' END IF
#                 LET l_req_cmp = g_req_tmp.tmp04
#                 IF cl_null(l_req_cmp) THEN LET l_req_cmp = 0 END IF
#             END IF
#         END IF
#         IF l_req_end = 'Y' AND l_for_end = 'Y' THEN 
#             EXIT FOR
#         END IF
#     END FOR
#
#  END FOREACH
#      
#END FUNCTION
#FUN-B60063--mark--end---

#FUN-890055---add----str--
FUNCTION p400_add_rpc()          # 將獨立性需求的資料納入MDS沖銷結果暫存檔 
  DEFINE l_tmp16_t      LIKE vle_file.vle03  #FUN-B60063 add
  DEFINE l_chr4         LIKE type_file.chr4  #FUN-B60063 add
  DEFINE l_i            LIKE type_file.num10 #FUN-B60063 add
  DEFINE #l_sql          LIKE type_file.chr1000
         l_sql        STRING       #NO.FUN-910082    
  DEFINE l_oea          RECORD LIKE oea_file.*
  DEFINE l_oeb          RECORD LIKE oea_file.*
  DEFINE l_opc01        LIKE opc_file.opc01
  DEFINE l_opc02        LIKE opc_file.opc02
  DEFINE l_opc03        LIKE opc_file.opc03
  DEFINE l_opc04        LIKE opc_file.opc04
  DEFINE l_ima133       LIKE ima_file.ima133 #FUN-870104 add
  DEFINE l_max_opc03    LIKE opc_file.opc03  #FUN-870104 add #計劃日期(opc03) <=或>=執行日期(vld12)且最接近者
  DEFINE l_opc03_1      LIKE opc_file.opc03  #FUN-880044 add
  DEFINE l_opc03_2      LIKE opc_file.opc03  #FUN-880044 add
 #DEFINE l_tmp10_bak    LIKE vle_file.vle16  #FUN-AB0090 add #TQC-AC0226 mark

  #FUN-8A0011---add----str---
  IF NOT cl_null(g_vlz70) THEN 
      CALL s_get_sql_msp04(g_vlz70,'rpc02') RETURNING g_sql_limited 
  ELSE
      LET g_sql_limited = ' 1=1 '
  END IF
  #FUN-8A0011---add----end---
 ##===>獨立需求(amri506)
  IF g_vld.vld09 = 'Y' THEN
     #LET g_sql="SELECT rpc01,'',rpc12,rpc13-rpc131,rpc13,rpc131,rpc02,rpc03,rpc21,'','','2' ", #FUN-A60068 mark
      LET g_sql="SELECT rpc01,'',rpc12,rpc13       ,rpc13,rpc131,rpc02,rpc03,rpc21,'','','2' ", #FUN-A60068 add
                ",'','','','','' ",                                           #FUN-B60063 add
                ",CASE WHEN ima133 IS NULL THEN rpc01 ELSE ima133 END tmp16 ",#FUN-B60063 add
               #"  FROM rpc_file",                                            #FUN-B60063 mark
               #"  FROM rpc_file,ima_file ",                                  #FUN-B60063 add
                "  FROM rpc_file LEFT OUTER JOIN ima_file ON rpc01=ima01 ",   #FUN-B60063 add
               #" WHERE rpc13 > rpc131 ",                  #FUN-A30080 mark
                " WHERE NVL(rpc13,0) > NVL(rpc131,0) ",    #避免欄位為NULL值導致資料被排除 #FUN-A30080 add
                "   AND rpc18 = 'Y' ",  #確認碼
                "   AND rpc19 = 'N' ",  #結案碼
                "   AND rpc12 >= '",g_vld.vld03,"'",
                "   AND rpc12 <= '",g_vld.vld04,"'",
                "   AND ",g_sql_limited CLIPPED #FUN-8A0003 add
      LET g_sql = g_sql CLIPPED,"ORDER BY tmp16,rpc12 " #FUN-B60063 add
      PREPARE p400_mds_p2 FROM g_sql
      DECLARE p400_mds_c2 CURSOR FOR p400_mds_p2
      LET l_i = 0 #FUN-B60063 add
      FOREACH p400_mds_c2 INTO g_tmp.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach p400_mds_c2:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         SELECT plan_date INTO g_tmp.tmp02
           FROM buk_tmp
          WHERE real_date = g_tmp.tmp03

        #FUN-B60063--mark---str---
        ##FUN-870104 add----str---
        ##預測料號
        #IF g_vld.vld16 = 'Y' THEN
        #    SELECT ima133 INTO l_ima133
        #      FROM ima_file
        #     WHERE ima01 = g_tmp.tmp01
        #    IF NOT cl_null(l_ima133) THEN
        #        LET g_tmp.tmp16 = l_ima133
        #    ELSE
        #        LET g_tmp.tmp16 = g_tmp.tmp01
        #    END IF
        #ELSE
        #    LET g_tmp.tmp16 = g_tmp.tmp01
        #END IF
        #FUN-B60063--mark---end---
        ##FUN-870104 add----end---
        ##TQC-AC0226---mark---str---
        ##FUN-AB0090---mod----str---
        #LET l_tmp10_bak = g_tmp.tmp10
        #IF g_tmp.tmp10 = '3' THEN #預測           
        #    LET g_tmp.tmp10 = 'F'                 #需求來源
        #ELSE
        #    LET g_tmp.tmp10 = 'R'                 #需求來源
        #END IF
        ##FUN-AB0090---mod----end---
        ##TQC-AC0226---mark---end---

       ###TQC-AC0226---add----str---
       #FUN-B60063-----mod----str---
       # IF g_tmp.tmp10 = '3' THEN #預測           
       #     LET g_tmp.tmp17 = 'F'                 #需求來源
       # ELSE
       #     LET g_tmp.tmp17 = 'R'                 #需求來源
       # END IF
         LET g_tmp.tmp17 = 'R'                 #需求來源
       #FUN-B60063-----mod----end---
        ##TQC-AC0226---add----end---
         INSERT INTO mds_result_tmp VALUES(g_tmp.*)
         IF STATUS THEN 
             CALL cl_err('ins mdsresult_tmp_from_rpc',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
             EXIT PROGRAM 
         END IF
        #LET g_tmp.tmp02 = '99/12/31'  #FUN-B60063 mark
        #LET g_tmp.tmp10 = l_tmp10_bak #FUN-AB0090 add #TQC-AC0226 mark
        #FUN-B60063---mark---str---
        #INSERT INTO mds_tmp VALUES(g_tmp.*)
        #IF STATUS THEN 
        #    CALL cl_err('ins mds_tmp_from_rpc',STATUS,1) 
        #    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
        #    EXIT PROGRAM 
        #END IF
        #FUN-B60063---mark---end---
        #FUN-B60063---add----str--- 
         LET g_vlf.vlf01 = g_vld.vld01                    #APS版本  
         LET g_vlf.vlf02 = g_vld.vld02                    #儲存版本
         LET g_vlf.vlf03 = g_tmp.tmp16                    #料號 
         LET g_vlf.vlf04 = g_tmp.tmp02                    #歸屬時距
         IF cl_null(l_tmp16_t) OR (l_tmp16_t <> g_tmp.tmp16) THEN
             SELECT MAX(vlf05) 
               INTO l_i
               FROM vlf_file
              WHERE vlf01 = g_vlf.vlf01
                AND vlf02 = g_vlf.vlf02
                AND vlf03 = g_vlf.vlf03
                AND vlf04 = g_vlf.vlf04
             IF cl_null(l_i) THEN
                 LET l_i = 0
             END IF
         END IF
         LET l_i = l_i + 1
         LET g_vlf.vlf05 = l_i                            #序號  
         LET g_vlf.vlf06 = '9'                            #需求量納入方式 ==>'9':獨立需求
         LET g_vlf.vlf07 = 0                              #時距內總需求量 
         LET g_vlf.vlf08 = NULL                           #NO USE
         LET g_vlf.vlf09 = NULL                           #NO USE
         #*************************************************需求**********************************************/
         LET g_vlf.vlf10 = g_tmp.tmp05                    #參考單號 rpc02
         LET g_vlf.vlf11 = g_tmp.tmp06                    #項次     rpc03
         LET g_vlf.vlf12 = g_tmp.tmp07                    #單據日期 rpc21
         LET g_vlf.vlf13 = g_tmp.tmp10                    #來源型式 2:獨立需求
         LET g_vlf.vlf14 = NULL                           #NO USE                                           */
         LET g_vlf.vlf15 = g_tmp.tmp01                    #實際料號
         LET l_chr4  = g_tmp.tmp06 USING '&&&&'
         LET g_vlf.vlf16 = g_tmp.tmp05 CLIPPED,'-',l_chr4 #需求單號
         LET g_vlf.vlf17 = g_tmp.tmp03                    #需求日期 rpc12
         LET g_vlf.vlf18 = g_tmp.tmp04                    #沖銷量
         LET g_vlf.vlf19 = '3'                            #沖銷狀況 3:直接納入                        */
         LET g_vlf.vlfplant = g_plant #FUN-B50022 add
         LEt g_vlf.vlflegal = g_legal #FUN-B50022 add
         INSERT INTO vlf_file VALUES(g_vlf.*)
         IF STATUS THEN 
             CALL cl_err('ins vlf_file@p400_add_rpc()',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B60063 add
             EXIT PROGRAM 
         END IF
         LET l_tmp16_t = g_tmp.tmp16
         INITIALIZE g_tmp.* TO NULL
         INITIALIZE g_vlf.* TO NULL
        #FUN-B60063---add----end--- 
      END FOREACH
  END IF
END FUNCTION

FUNCTION p400_add_0_period()     # 將前期(0期)資料納入MDS沖銷結果暫存檔    
  DEFINE l_tmp16_t      LIKE vle_file.vle03  #FUN-B60063 add
  DEFINE l_chr4         LIKE type_file.chr4  #FUN-B60063 add
  DEFINE l_i            LIKE type_file.num10 #FUN-B60063 add
  DEFINE #l_sql          LIKE type_file.chr1000 
         l_sql        STRING       #NO.FUN-910082   
  DEFINE l_oea          RECORD LIKE oea_file.*
  DEFINE l_oeb          RECORD LIKE oea_file.*
  DEFINE l_opc01        LIKE opc_file.opc01
  DEFINE l_opc02        LIKE opc_file.opc02
  DEFINE l_opc03        LIKE opc_file.opc03
  DEFINE l_opc04        LIKE opc_file.opc04
  DEFINE l_ima133       LIKE ima_file.ima133 #FUN-870104 add
  DEFINE l_max_opc03    LIKE opc_file.opc03  #FUN-870104 add #計劃日期(opc03) <=或>=執行日期(vld12)且最接近者
  DEFINE l_opc03_1      LIKE opc_file.opc03  #FUN-880044 add
  DEFINE l_opc03_2      LIKE opc_file.opc03  #FUN-880044 add
 #DEFINE l_tmp10_bak    LIKE vle_file.vle16  #FUN-AB0090 add #TQC-AC0226 mark

  #FUN-8A0011---add----str---
  IF NOT cl_null(g_vlz70) THEN 
      CALL s_get_sql_msp04(g_vlz70,'oeb01') RETURNING g_sql_limited 
  ELSE
      LET g_sql_limited = ' 1=1 '
  END IF
  #FUN-8A0011---add----end---

  #===>一般訂單/合約訂單
  IF g_vld.vld07= 'Y' OR g_vld.vld08 = 'Y' THEN
      LET g_sql="SELECT oeb04,'',"
      IF g_vld.vld05 = '1' THEN
          #日期選擇=>1:約定交貨日oeb15
          LET g_sql = g_sql CLIPPED, " oeb15 "
      ELSE
          #日期選擇=>2:排定交貨日oeb16
          LET g_sql = g_sql CLIPPED, " oeb16 "
      END IF
     #LET g_sql = g_sql CLIPPED, ",(oeb12-oeb24+oeb25-oeb26),oeb12,(oeb24-oeb25+oeb26),oeb01,oeb03,oea02,oea03,oea14,oea00 ", #FUN-A60068 mark
      LET g_sql = g_sql CLIPPED, ", oeb12                   ,oeb12,(oeb24-oeb25+oeb26),oeb01,oeb03,oea02,oea03,oea14,oea00 ", #FUN-A60068 add
                                 ",'','','','','' ",                                           #FUN-B60063 add
                                 ",CASE WHEN ima133 IS NULL THEN oeb04 ELSE ima133 END tmp16 ",#FUN-B60063 add
                                #"  FROM oea_file,oeb_file",                                   #FUN-B60063 mark
                                #"  FROM oea_file,oeb_file,ima_file",                          #FUN-B60063 add
                                 "  FROM oea_file,oeb_file LEFT OUTER JOIN ima_file ON oeb04=ima01 ",   #FUN-B60063 add
                                 " WHERE oea01 = oeb01 ",
                                 "   AND oeb12 > (oeb24-oeb25+oeb26) ", #FUN-A60068 mark #FUN-A80049 unmark
                                 "   AND oeb70 = 'N' ",
                                 "   AND oeaconf = 'Y' ",
                                 "   AND ",g_sql_limited CLIPPED #FUN-8A0003 add
      IF g_vld.vld05 = '1' THEN
          #日期選擇=>1:約定交貨日oeb15
         #FUN-A80049---mod---str---
         #LET g_sql = g_sql CLIPPED, " AND oeb15 >= '",g_vld.vld03,"'",
         #                           " AND oeb15 <  '",g_base_buk_date,"'"
          LET g_sql = g_sql CLIPPED, " AND oeb15 <  '",g_base_date,"'"
         #FUN-A80049---mod---end---
      ELSE
          #日期選擇=>2:排定交貨日oeb16
         #FUN-A80049---mod---str---
         #LET g_sql = g_sql CLIPPED, " AND oeb15 >= '",g_vld.vld03,"'",
         #                           " AND oeb16 <  '",g_base_buk_date,"'"
          LET g_sql = g_sql CLIPPED, " AND oeb16 <  '",g_base_date,"'"
         #FUN-A80049---mod---end---
      END IF
      LET g_sql = g_sql CLIPPED, " AND oea00 IN ("
      IF g_vld.vld07 = 'Y' THEN
          LET g_sql = g_sql CLIPPED, "'1'"
      END IF
      IF g_vld.vld08 = 'Y' THEN
          IF g_vld.vld07 = 'Y' THEN LET g_sql = g_sql CLIPPED,"," END IF
          LET g_sql = g_sql CLIPPED, "'0'"
      END IF
      LET g_sql = g_sql CLIPPED,")"
      LET g_sql = g_sql CLIPPED," ORDER BY tmp16,oea02 " #FUN-B60063 add
      PREPARE p400_mds_p4 FROM g_sql
      DECLARE p400_mds_c4 CURSOR FOR p400_mds_p4
      INITIALIZE g_tmp.* TO NULL
      INITIALIZE g_vlf.* TO NULL #FUN-B60063 add
      LET l_tmp16_t = NULL       #FUN-B60063 add
      FOREACH p400_mds_c4 INTO g_tmp.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach p400_mds_c4:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT plan_date INTO g_tmp.tmp02
           FROM buk_tmp
          WHERE real_date = g_tmp.tmp03

        #FUN-B60063--mark---str---
        ##FUN-870104 add----str---
        ##預測料號
        #IF g_vld.vld16 = 'Y' THEN
        #    SELECT ima133 INTO l_ima133
        #      FROM ima_file
        #     WHERE ima01 = g_tmp.tmp01
        #    IF NOT cl_null(l_ima133) THEN
        #        LET g_tmp.tmp16 = l_ima133
        #    ELSE
        #        LET g_tmp.tmp16 = g_tmp.tmp01
        #    END IF
        #ELSE
        #    LET g_tmp.tmp16 = g_tmp.tmp01
        #END IF
        ##FUN-870104 add----end---
        #FUN-B60063--mark---end---

         LET g_tmp.tmp02 = '99/01/01' #FUN-A80049 add
        ##TQC-AC0226---mark---str---
        ##FUN-AB0090---mod----str---
        #LET l_tmp10_bak = g_tmp.tmp10
        #IF g_tmp.tmp10 = '3' THEN #預測           
        #    LET g_tmp.tmp10 = 'F'                 #需求來源
        #ELSE
        #    LET g_tmp.tmp10 = 'R'                 #需求來源
        #END IF
        ##FUN-AB0090---mod----end---
        ##TQC-AC0226---mark---end---

        ##TQC-AC0226---add----str---
        #FUN-B60063----mod----str---
        #IF g_tmp.tmp10 = '3' THEN #預測           
        #    LET g_tmp.tmp17 = 'F'                 #需求來源
        #ELSE
        #    LET g_tmp.tmp17 = 'R'                 #需求來源
        #END IF
         LET g_tmp.tmp17 = 'R'                 #需求來源
        #FUN-B60063----mod----end---
        ##TQC-AC0226---add----end---
         INSERT INTO mds_result_tmp VALUES(g_tmp.*)
         IF STATUS THEN 
             CALL cl_err('ins mdsresult_tmp_from_0_period',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
             EXIT PROGRAM 
         END IF

        #LET g_tmp.tmp02 = '99/01/01'  #FUN-B60063 mark
        #LET g_tmp.tmp10 = l_tmp10_bak #FUN-AB0090 add #TQC-AC0226 mark
        #FUN-B60063---mark--str---
        #INSERT INTO mds_tmp VALUES(g_tmp.*)
        #IF STATUS THEN 
        #    CALL cl_err('ins mds_tmp_from_0_period',STATUS,1) 
        #    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
        #    EXIT PROGRAM 
        #END IF
        #FUN-B60063---mark--end---
        #FUN-B60063---add---str---
         LET g_vlf.vlf01 = g_vld.vld01                    #APS版本  
         LET g_vlf.vlf02 = g_vld.vld02                    #儲存版本
         LET g_vlf.vlf03 = g_tmp.tmp16                    #料號 
         LET g_vlf.vlf04 = g_tmp.tmp02                    #歸屬時距
         IF cl_null(l_tmp16_t) OR (l_tmp16_t <> g_tmp.tmp16) THEN
             LET l_i = 0
         END IF
         LET l_i = l_i + 1
         LET g_vlf.vlf05 = l_i                            #序號  
         LET g_vlf.vlf06 = '0'                            #需求量納入方式 ==>'0':零期資料
         LET g_vlf.vlf07 = 0                              #時距內總需求量 
         LET g_vlf.vlf08 = NULL                           #NO USE
         LET g_vlf.vlf09 = NULL                           #NO USE
         #*************************************************需求**********************************************/
         LET g_vlf.vlf10 = g_tmp.tmp05                    #訂單編號 oeb01
         LET g_vlf.vlf11 = g_tmp.tmp06                    #項次     oeb03
         LET g_vlf.vlf12 = g_tmp.tmp07                    #單據日期 oea02
         LET g_vlf.vlf13 = g_tmp.tmp10                    #來源型式 0:一般訂單 1:合約訂單
         LET g_vlf.vlf14 = NULL                           #NO USE                                           */
         LET g_vlf.vlf15 = g_tmp.tmp01                    #實際料號
         LET l_chr4  = g_tmp.tmp06 USING '&&&&'
         LET g_vlf.vlf16 = g_tmp.tmp05 CLIPPED,'-',l_chr4 #需求單號
         LET g_vlf.vlf17 = g_tmp.tmp03                    #需求日期 #oeb15/oeb16
         LET g_vlf.vlf18 = g_tmp.tmp04                    #沖銷量
         LET g_vlf.vlf19 = '3'                            #沖銷狀況 3:直接納入                        */
         LET g_vlf.vlfplant = g_plant #FUN-B50022 add
         LEt g_vlf.vlflegal = g_legal #FUN-B50022 add
         INSERT INTO vlf_file VALUES(g_vlf.*)
         IF STATUS THEN 
             CALL cl_err('ins vlf_file@p400_add_0_period()',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B60063 add
             EXIT PROGRAM 
         END IF
         LET l_tmp16_t = g_tmp.tmp16
         INITIALIZE g_tmp.* TO NULL
         INITIALIZE g_vlf.* TO NULL
        #FUN-B60063---add---end---
      END FOREACH
  END IF
END FUNCTION
#FUN-890055---add----end--

##FUN-8A0011---add----str--
#FUNCTION s_get_sql_msp04(l_msp01,l_feldname) #單別
#DEFINE l_msp01         LIKE msp_file.msp01
#DEFINE l_feldname      LIKE type_file.chr20
#DEFINE l_chr20         LIKE type_file.chr20
#DEFINE l_msp           RECORD LIKE msp_file.*
#DEFINE l_n             LIKE type_file.num5         
#DEFINE l_i             LIKE type_file.num5     
#DEFINE g_sw            LIKE type_file.chr1     
#DEFINE l_digits        LIKE type_file.chr1     
#DEFINE l_sql           LIKE type_file.chr1000  
#
#  LET l_n = 1
#  LET l_sql = NULL
#  DECLARE sel_msp_cur CURSOR FOR
#   SELECT * FROM msp_file 
#    WHERE msp01 = l_msp01
#      AND msp04 IS NOT NULL
#  FOREACH sel_msp_cur INTO l_msp.*
#    IF STATUS THEN CALL cl_err('for msp:',STATUS,0) EXIT FOREACH END IF
#
#      #==>單據
#      IF l_n=1 THEN
#          CASE g_aza.aza41
#               WHEN '1' #單別位數,3碼
#                    LET l_digits = '3'
#               WHEN '2' #單別位數,4碼
#                    LET l_digits = '4'
#               WHEN '3' #單別位數,5碼
#                    LET l_digits = '5'
#              OTHERWISE
#                    LET l_digits = '3'
#          END CASE
#          IF l_msp.msp10 = 0 THEN
#              LET l_chr20 = " IN "
#          ELSE
#              LET l_chr20 = " NOT IN "
#          END IF
#          LET l_sql = l_sql CLIPPED,"(SUBSTR(",l_feldname CLIPPED,",1,",l_digits,")",l_chr20,"('",l_msp.msp04 CLIPPED,"'"
#      ELSE
#          LET l_sql = l_sql CLIPPED,",'",l_msp.msp04 CLIPPED,"'"
#      END IF
#      LET l_n = l_n + 1
#
#  END FOREACH
#
#  IF NOT cl_null(l_sql)  THEN 
#      LET l_sql  = l_sql  CLIPPED," ))"  
#  ELSE
#      LET l_sql  = " 1=1 "
#  END IF
#  RETURN l_sql
#
#END FUNCTION
##FUN-8A0011---add----end--
#FUN-AB0090----add----str--
FUNCTION p400_get_order()
   CASE 
        WHEN g_vlo.vlo03 = '1' #料號
              LET g_order1 = 'item_tmp.vlp02_1'
        WHEN g_vlo.vlo03 = '2' #客戶
              LET g_order1 = 'customer_tmp.vlp02_2'
        WHEN g_vlo.vlo03 = '3' #業務員
              LET g_order1 = 'sales_tmp.vlp02_3'
        WHEN g_vlo.vlo03 = '4' AND g_vlo.vlo06='F' #需求形式
             #LET g_order1 = 'mds_result_tmp.tmp10 DESC' #TQC-AC0226 mark
              LET g_order1 = 'mds_result_tmp.tmp17     ' #TQC-AC0226 add  #TQC-AC0270 mod
        WHEN g_vlo.vlo03 = '4' AND g_vlo.vlo06='R' #需求形式
             #LET g_order1 = 'mds_result_tmp.tmp10 '     #TQC-AC0226 mark
              LET g_order1 = 'mds_result_tmp.tmp17 DESC' #TQC-AC0226 add  #TQC-AC0270 mod
        WHEN g_vlo.vlo03 = '5' #交期
             #LET g_order1 = 'vmu04'                           #TQC-AC0270 mark
              LET g_order1 = 'mds_result_tmp.tmp03 ' #需求日期 #TQC-AC0270 add
   END CASE

   CASE 
        WHEN g_vlo.vlo04 = '1' #料號
              LET g_order2 = 'item_tmp.vlp02_1'
        WHEN g_vlo.vlo04 = '2' #客戶
              LET g_order2 = 'customer_tmp.vlp02_2'
        WHEN g_vlo.vlo04 = '3' #業務員
              LET g_order2 = 'sales_tmp.vlp02_3'
        WHEN g_vlo.vlo04 = '4' AND g_vlo.vlo06='F' #需求形式
             #LET g_order2 = 'mds_result_tmp.tmp10 DESC' #TQC-AC0226 mark
              LET g_order2 = 'mds_result_tmp.tmp17     ' #TQC-AC0226 add  #TQC-AC0270 mod
        WHEN g_vlo.vlo04 = '4' AND g_vlo.vlo06='R' #需求形式
             #LET g_order2 = 'mds_result_tmp.tmp10 '     #TQC-AC0226 mark
              LET g_order2 = 'mds_result_tmp.tmp17 DESC' #TQC-AC0226 add  #TQC-AC0270 mod
        WHEN g_vlo.vlo04 = '5' #交期
             #LET g_order2 = 'vmu04'                           #TQC-AC0270 mark
              LET g_order2 = 'mds_result_tmp.tmp03 ' #需求日期 #TQC-AC0270 add
   END CASE

   CASE 
        WHEN g_vlo.vlo05 = '1' #料號
              LET g_order3 = 'item_tmp.vlp02_1'
        WHEN g_vlo.vlo05 = '2' #客戶
              LET g_order3 = 'customer_tmp.vlp02_2'
        WHEN g_vlo.vlo05 = '3' #業務員
              LET g_order3 = 'sales_tmp.vlp02_3'
        WHEN g_vlo.vlo05 = '4' AND g_vlo.vlo06='F' #需求形式
             #LET g_order3 = 'mds_result_tmp.tmp10 DESC' #TQC-AC0226 mark
              LET g_order3 = 'mds_result_tmp.tmp17     ' #TQC-AC0226 add  #TQC-AC0270 mod
        WHEN g_vlo.vlo05 = '4' AND g_vlo.vlo06='R' #需求形式
             #LET g_order3 = 'mds_result_tmp.tmp10 '     #TQC-AC0226 mark
              LET g_order3 = 'mds_result_tmp.tmp17 DESC' #TQC-AC0226 add  #TQC-AC0270 mod
        WHEN g_vlo.vlo05 = '5' #交期
             #LET g_order3 = 'vmu04'                           #TQC-AC0270 mark
              LET g_order3 = 'mds_result_tmp.tmp03 ' #需求日期 #TQC-AC0270 add
   END CASE
END FUNCTION
#FUN-AB0090----add----end--

#FUN-B50022--add---str---
FUNCTION p400_def_form()
   IF cl_null(g_sma.sma901) OR g_sma.sma901 = 'N' THEN
      CALL cl_set_comp_visible("vld01",FALSE)          #APS版本
      LET g_vld.vld01 = 'TP'                           
      CALL cl_getmsg('aps-450',g_lang) RETURNING g_msg #MDS版本
      CALL cl_set_comp_att_text("vld02",g_msg CLIPPED)
      CALL cl_set_comp_entry("vlz70",TRUE)
   ELSE
      CALL cl_set_comp_entry("vlz70",FALSE)
   END IF
END FUNCTION

FUNCTION p400_ins_vlz()
   DEFINE l_cnt LIKE type_file.num5     
 
   SELECT COUNT(*) INTO l_cnt 
     FROM vlz_file
    WHERE vlz01 = g_vld.vld01
      AND vlz02 = g_vld.vld02
   IF l_cnt >=1 THEN
       DELETE FROM vlz_file 
        WHERE vlz01 = g_vld.vld01
          AND vlz02 = g_vld.vld02
       IF STATUS THEN 
           CALL cl_err('Del vld_file',STATUS,1) 
       END IF
   END IF
   LET g_vlz.vlz01  = 'TP'
   LET g_vlz.vlz02  = g_vld.vld02
   LET g_vlz.vlz04  = NULL
   LET g_vlz.vlz05  = 0
   LET g_vlz.vlz06  = NULL
   LET g_vlz.vlz07  = NULL
   LET g_vlz.vlz08  = NULL
   LET g_vlz.vlz09  = 0
   LET g_vlz.vlz10  = 0
   LET g_vlz.vlz11  = 0
   LET g_vlz.vlz12  = 1  
   LET g_vlz.vlz13  = 2
   LET g_vlz.vlz14  = 2
   LET g_vlz.vlz15  = 2
   LET g_vlz.vlz16  = 0
   LET g_vlz.vlz17  = 1  
   LET g_vlz.vlz18  = 1
   LET g_vlz.vlz19  = 0
   LET g_vlz.vlz20  = 1
   LET g_vlz.vlz21  = 1
   LET g_vlz.vlz22  = 1
   LET g_vlz.vlz23  = 1
   LET g_vlz.vlz24  = 1
   LET g_vlz.vlz25  = 1
   LET g_vlz.vlz26  = 0
   LET g_vlz.vlz27  = 1
   LET g_vlz.vlz28  = 1
   LET g_vlz.vlz29  = 0
   LET g_vlz.vlz30  = 0
   LET g_vlz.vlz31  = 1
   LET g_vlz.vlz32  = 24
   LET g_vlz.vlz33  = 31
   LET g_vlz.vlz34  = 0
   LET g_vlz.vlz35  = 0
   LET g_vlz.vlz36  = 0
   LET g_vlz.vlz37  = 0
   LET g_vlz.vlz38  = 365
   LET g_vlz.vlz39  = 0
   LET g_vlz.vlz40  = 0
   LET g_vlz.vlz41  = 0
   LET g_vlz.vlz42  = 0
   LET g_vlz.vlz44  = 0
   LET g_vlz.vlz45  = 3
   LET g_vlz.vlz46  = 3
   LET g_vlz.vlz47  = 3
   LET g_vlz.vlz48  = 3
   LET g_vlz.vlz49  = 0
   LET g_vlz.vlz50  = 1
   LET g_vlz.vlz51  = 1
   LET g_vlz.vlz52  = 12
   LET g_vlz.vlz53  = 0
   LET g_vlz.vlz54  = 0
   LET g_vlz.vlz55  = 0 
   LET g_vlz.vlz56  = 0
   LET g_vlz.vlz56b = '00:00:00'  
   LET g_vlz.vlz57  = 7200
   LET g_vlz.vlz57b = '02:00:00'  
   LET g_vlz.vlz58  = '1'
   LET g_vlz.vlz59  = '1'
   LET g_vlz.vlz60  = 0
   LET g_vlz.vlz62  = 'VTOP'
   LET g_vlz.vlz63  = 'VTEQ'
   LET g_vlz.vlz66  = 'mcp'
   LET g_vlz.vlz67  = 2
   LET g_vlz.vlz68  = 'VTR1'
   LET g_vlz.vlz69  = 1
   LET g_vlz.vlz71  = '0,1'  
   LET g_vlz.vlz72  = 'VENDER'  
   LET g_vlz.vlz73  = 'APS_MO-'  
   LET g_vlz.vlz74  = 'APS_PO-'  
   LET g_vlz.vlz75  = 0          
   LET g_vlz.vlz76  = 0         
   INSERT INTO vlz_file VALUES(g_vlz.*)     
   IF STATUS THEN 
       CALL cl_err('Ins vld_file',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
   END IF
END FUNCTION

FUNCTION p400_vlz70()
DEFINE l_cnt                 LIKE type_file.num10         
 
   LET g_errno=''
   SELECT count(*)
     INTO l_cnt
     FROM msp_file
    WHERE msp01 = g_vlz.vlz70
    IF l_cnt <= 0 THEN
        #無此版本代號, 請重新輸入!
        LET g_errno='adm-002'
    ELSE 
        LET g_errno=SQLCA.sqlcode USING '------'
    END IF
END FUNCTION
#FUN-B50022--add---end---

#FUN-B60063---add---str--
FUNCTION p400_ins_vlf_new(p_tmp16,p_tmp02) #產生MDS沖銷關聯檔
  DEFINE l_chr4         LIKE   type_file.chr4 #FUN-B60063-- add
  DEFINE p_tmp16        LIKE   vle_file.vle03 #料
  DEFINE p_tmp02        LIKE   vle_file.vle04 #時距日
  DEFINE l_tmp15        LIKE   type_file.num10   
  DEFINE l_vlf16        LIKE   vlf_file.vlf16
  DEFINE l_vlf26        LIKE   vlf_file.vlf26
  DEFINE l_req_end      LIKE   type_file.chr1
  DEFINE l_for_end      LIKE   type_file.chr1
  DEFINE l_i            LIKE   type_file.num10   
  DEFINE l_j            LIKE   type_file.num10   
  DEFINE l_req          LIKE   type_file.num10   
  DEFINE l_for          LIKE   type_file.num10   
  DEFINE l_req_sum      LIKE   vle_file.vle06
  DEFINE l_for_sum      LIKE   vle_file.vle06
  DEFINE l_max_sum      LIKE   vle_file.vle06
  DEFINE l_max_sum_co   LIKE   vle_file.vle06
  DEFINE l_result_qty   LIKE   vle_file.vle06
  DEFINE l_mds_qty      LIKE   vle_file.vle06
  DEFINE l_req_cmp      LIKE   vle_file.vle06
  DEFINE l_for_cmp      LIKE   vle_file.vle06

  #FUN-B60063---add----str---
  #==>需求
  LET g_sql="SELECT * ",
            "  FROM mds_tmp",
            " WHERE tmp16 = '",p_tmp16,"'",
            "   AND tmp02 = '",p_tmp02,"'",
            "   AND tmp10 IN ('0','1') ", 
            "  ORDER BY tmp03 "
  PREPARE p400_mds_req_p2 FROM g_sql
  DECLARE p400_mds_req_c2 SCROLL CURSOR WITH HOLD FOR p400_mds_req_p2
  OPEN p400_mds_req_c2

  #==>預測
  LET g_sql="SELECT * ",
            "  FROM mds_tmp",
            " WHERE tmp16 = '",p_tmp16,"'",
            "   AND tmp02 = '",p_tmp02,"'",
            "   AND tmp10 IN ('3') ",
            "  ORDER BY tmp03,tmp041,tmp08 " 
  PREPARE p400_mds_for_p2 FROM g_sql
  DECLARE p400_mds_for_c2 SCROLL CURSOR WITH HOLD FOR p400_mds_for_p2
  OPEN p400_mds_for_c2
  #FUN-B60063---add----end---

     LET l_max_sum_co = g_max_sum

     LET l_req = 1
     LET l_for = 1
     LET l_req_end = 'N'
     LET l_for_end = 'N'
    #FUN-B60063--mod---str--
     #==>需求
    #SELECT * INTO g_req_tmp.*
    #  FROM req_tmp
    # WHERE tmp16 = p_tmp16  
    #   AND tmp02 = p_tmp02
    #   AND tmp15 = l_req
     FETCH ABSOLUTE l_req p400_mds_req_c2 INTO g_req_tmp.*
    #FUN-B60063--mod---end--
     IF STATUS THEN LET l_req_end = 'Y' END IF

    #FUN-B60063--mod---str--
     #==>預測
    #SELECT * INTO g_for_tmp.*
    #  FROM for_tmp
    # WHERE tmp16 = p_tmp16  
    #   AND tmp02 = p_tmp02
    #   AND tmp15 = l_for
     FETCH ABSOLUTE l_for p400_mds_for_c2 INTO g_for_tmp.*
    #FUN-B60063--mod---end--
     IF STATUS THEN LET l_for_end = 'Y' END IF

     IF cl_null(g_req_tmp.tmp04) THEN LET g_req_tmp.tmp04 = 0 END IF
     IF cl_null(g_for_tmp.tmp04) THEN LET g_for_tmp.tmp04 = 0 END IF
     LET l_req_cmp = g_req_tmp.tmp04
     LET l_for_cmp = g_for_tmp.tmp04
     FOR l_i = 1 TO g_max_rec
         INITIALIZE g_vlf.* TO NULL
         IF l_req_end = 'N' AND l_for_end = 'N' THEN
             LET g_cnt = l_req_cmp - l_for_cmp
             CASE 
                  WHEN g_cnt < 0 #需求小
                           LET g_vlf.vlf18 = l_req_cmp 
                           LET g_vlf.vlf28 = l_req_cmp
                           LET l_max_sum_co = l_max_sum_co - l_req_cmp  
                  WHEN g_cnt > 0 #預測小
                           LET g_vlf.vlf18 = l_for_cmp
                           LET g_vlf.vlf28 = l_for_cmp
                           LET l_max_sum_co = l_max_sum_co - l_for_cmp  
                  WHEN g_cnt = 0 #需求=預測
                           LET g_vlf.vlf18 = l_req_cmp 
                           LET g_vlf.vlf28 = l_req_cmp
                           LET l_max_sum_co = l_max_sum_co - l_req_cmp  
             END CASE
         ELSE
             IF l_req_end = 'Y' THEN
                 LET g_vlf.vlf18 = l_for_cmp
                 LET g_vlf.vlf28 = l_for_cmp
                 LET l_max_sum_co = l_max_sum_co - l_for_cmp  
             ELSE
                 LET g_vlf.vlf18 = l_req_cmp 
                 LET g_vlf.vlf28 = l_req_cmp
                 LET l_max_sum_co = l_max_sum_co - l_req_cmp  
             END IF
         END IF
         LET g_vlf.vlf01 = g_vld.vld01            #APS版本                                          */
         LET g_vlf.vlf02 = g_vld.vld02            #儲存版本                                         */
         IF l_req_end = 'N' THEN
             LET g_vlf.vlf03 = g_req_tmp.tmp16        #料號                                             */ #FUN-870104 mod
             LET g_vlf.vlf04 = g_req_tmp.tmp02        #歸屬時距                                         */
         ELSE
             LET g_vlf.vlf03 = g_for_tmp.tmp16        #料號                                             */ #FUN-870104 mod
             LET g_vlf.vlf04 = g_for_tmp.tmp02        #歸屬時距                                         */
         END IF
         LET g_vlf.vlf05 = l_i                    #序號                                             */
         LET g_vlf.vlf06 = g_vld.vld10            #需求量納入方式                                   */
         #TQC-890061---mod-----str----
         IF g_vlf.vlf04 = '99/01/01' THEN
             LET g_vlf.vlf06 = '0'                #需求量納入方式 ==>'0':零期資料
             LET l_max_sum = l_req_sum
         END IF
         IF g_vlf.vlf04 = '99/12/31' THEN
             LET g_vlf.vlf06 = '9'                #需求量納入方式 ==>'9':獨立需求
             LET l_max_sum = l_req_sum
         END IF
         #TQC-890061---mod-----end----
        #LET g_vlf.vlf07 = l_max_sum              #時距內總需求量                                   */ #FUN-B60063 mark
         LET g_vlf.vlf07 = g_max_sum              #時距內總需求量                                   */ #FUN-B60063 add
         LET g_vlf.vlf08 = NULL                   #NO USE                                           */
         LET g_vlf.vlf09 = NULL                   #NO USE                                           */
         #*****************************************需求**********************************************/
         IF l_req_end = 'N' THEN
             LET g_vlf.vlf10 = g_req_tmp.tmp05        #需求--訂單編號 oeb01/rpc02                       */
             LET g_vlf.vlf11 = g_req_tmp.tmp06        #需求--項次     oeb03/rpc03                       */
             LET g_vlf.vlf12 = g_req_tmp.tmp07        #需求--單據日期 oea02/rpc21                       */
             LET g_vlf.vlf13 = g_req_tmp.tmp10        #需求--來源型式 0:一般訂單 1:合約訂單 2:獨立需求  */
             LET g_vlf.vlf14 = NULL                   #NO USE                                           */
             LET g_vlf.vlf15 = g_req_tmp.tmp01        #FUN-870104--mod #實際料號
             LET l_vlf16 = NULL
            #FUN-B60063---mark---str---
            #CASE g_vlf.vlf13
            #     WHEN '0'
            #             SELECT vmu03 INTO l_vlf16 
            #               FROM vmu_file
            #              WHERE vmu01 = g_vld.vld01
            #                AND vmu02 = g_vld.vld02
            #                AND vmu11 = g_vlf.vlf10
            #                AND vmu26 = g_vlf.vlf11
            #     WHEN '1'
            #             SELECT vmu03 INTO l_vlf16 
            #               FROM vmu_file
            #              WHERE vmu01 = g_vld.vld01
            #                AND vmu02 = g_vld.vld02
            #                AND vmu11 = g_vlf.vlf10
            #                AND vmu26 = g_vlf.vlf11
            #     WHEN '2'
            #             SELECT vmu03 INTO l_vlf16 
            #               FROM vmu_file
            #              WHERE vmu01 = g_vld.vld01
            #                AND vmu02 = g_vld.vld02
            #                AND vmu11 = g_vlf.vlf10
            #                AND vmu26 = g_vlf.vlf11
            #                AND vmu18 = g_vlf.vlf12
            #END CASE
            #LET g_vlf.vlf16 = l_vlf16                #需求單號vmu03
            #FUN-B60063---mark---end---
            #FUN-B60063---add----str---
             LET l_chr4  = g_req_tmp.tmp06 USING '&&&&'
             LET g_vlf.vlf16 = g_req_tmp.tmp05 CLIPPED,'-',l_chr4
            #FUN-B60063---add----end---
             LET g_vlf.vlf17 = g_req_tmp.tmp03        #需求--需求日期 #oeb15/oeb16          #rpc12      */
            #LET g_vlf.vlf18 =                        #需求--沖銷量                                     */
             #TQC-890061---mod---str---
             IF g_vlf.vlf06 MATCHES '[09]' THEN       #需求量納入方式 ==>'0':零期資料 '9':獨立需求
                 LET g_vlf.vlf19 = '3'                #需求--沖銷狀況 3:直接納入                        */
             ELSE
                 IF l_for_end = 'N' THEN
                     LET g_vlf.vlf19 = '0'                #需求--沖銷狀況 0:完全沖銷                        */
                 ELSE
                     IF l_max_sum_co >= 0 THEN
                         LET g_vlf.vlf19 = '1'            #1:需求多
                     ELSE
                         LET g_vlf.vlf19 = '2'            #2:未沖
                     END IF
                 END IF
             END IF
             #TQC-890061---mod---end---
         ELSE
             LET g_vlf.vlf10 = NULL                   #需求--訂單編號 oeb01/rpc02                       */
             LET g_vlf.vlf11 = NULL                   #需求--項次     oeb03/rpc03                       */
             LET g_vlf.vlf12 = NULL                   #需求--單據日期 oea02/rpc21                       */
             LET g_vlf.vlf13 = NULL                   #需求--來源型式 0:一般訂單 1:合約訂單 2:獨立需求  */
             LET g_vlf.vlf14 = NULL                   #NO USE                                           */
             LET g_vlf.vlf15 = NULL                   #實際料號#FUN-870104 mod
             LET g_vlf.vlf16 = NULL                   #NO USE                                           */
             LET g_vlf.vlf17 = NULL                   #需求--需求日期 #oeb15/oeb16          #rpc12      */
             LET g_vlf.vlf18 = NULL                   #需求--沖銷量                                     */
             LET g_vlf.vlf19 = NULL                   #需求--沖銷狀況                                   */
         END IF
         #***************=                        #預測**********************************************/
         IF l_for_end = 'N' THEN
             LET g_vlf.vlf20 = 'FORECAST'             #預測--FORECAST                                   */
             LET g_vlf.vlf21 = g_for_tmp.tmp08        #預測--客戶編號   opd02                           */
             LET g_vlf.vlf22 = g_for_tmp.tmp07        #預測--計劃日期   opd03                           */
             LET g_vlf.vlf23 = g_for_tmp.tmp09        #預測--業務員     opd04                           */
             LET g_vlf.vlf24 = g_for_tmp.tmp06        #預測--序號       opd05                           */
             LET g_vlf.vlf25 = g_for_tmp.tmp01        #FUN-870104 mod #實際料號
             LET l_vlf26 = NULL
            #FUN-B60063---mark--str---
            #SELECT vmu03 INTO l_vlf26
            #  FROM vmu_file
            # WHERE vmu01 = g_vld.vld01
            #   AND vmu02 = g_vld.vld02
            #   AND vmu23 = g_vlf.vlf03 #料號       opd01
            #   AND vmu06 = g_vlf.vlf21 #客戶編號   opd02 
            #   AND vmu18 = g_vlf.vlf22 #計劃日期   opd03
            #   AND vmu16 = g_vlf.vlf23 #業務員     opd04
            #   AND vmu26 = g_vlf.vlf24 #序號       opd05
            #IF l_vlf26[1,8] = 'FORECAST' THEN
            #    LET g_vlf.vlf26 = l_vlf26                #vmu03                                            */
            #ELSE
            #    LET g_vlf.vlf26 = NULL
            #END IF
            #FUN-B60063---mark--end---
             LET g_vlf.vlf27 = g_for_tmp.tmp03        #預測--計劃起始日 opd06                           */
            #LET g_vlf.vlf28 =                        #預測--沖銷量                                     */
             LET g_vlf.vlf29 = '0'                    #預測--沖銷狀況                                   */
             IF l_req_end = 'N' THEN
                 LET g_vlf.vlf29 = '0'                #需求--沖銷狀況 0:完全沖銷                        */
                 LET g_vlf.vlf26 = NULL               #FUN-870104 add
             ELSE
                 IF l_max_sum_co >= 0 THEN
                     LET g_vlf.vlf29 = '1'            #1:需求多
                 ELSE
                     LET g_vlf.vlf29 = '2'            #2:未沖
                 END IF
             END IF
         ELSE
             LET g_vlf.vlf20 = NULL                   #預測--FORECAST                                   */
             LET g_vlf.vlf21 = NULL                   #預測--客戶編號   opd02                           */
             LET g_vlf.vlf22 = NULL                   #預測--計劃日期   opd03                           */
             LET g_vlf.vlf23 = NULL                   #預測--業務員     opd04                           */
             LET g_vlf.vlf24 = NULL                   #預測--序號       opd05                           */
             LET g_vlf.vlf25 = NULL                   #實際料號 #FUN-870104 mod
             LET g_vlf.vlf26 = NULL                   #NO USE                                           */
             LET g_vlf.vlf27 = NULL                   #預測--計劃起始日 opd06                           */
             LET g_vlf.vlf28 = NULL                   #預測--沖銷量                                     */
             LET g_vlf.vlf29 = NULL                   #預測--沖銷狀況                                   */
         END IF
         LET g_vlf.vlfplant = g_plant #FUN-B50022 add
         LEt g_vlf.vlflegal = g_legal #FUN-B50022 add
         INSERT INTO vlf_file VALUES(g_vlf.*)
         IF STATUS THEN 
             CALL cl_err('ins vlf_file@p400_ins_vlf_new()',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B60063 add
             EXIT PROGRAM 
         END IF #FUN-B60063 mod
            
         IF l_req_end = 'N' AND l_for_end = 'N' THEN
             CASE 
                  WHEN g_cnt < 0 
                           #預測大
                           LET l_for_cmp = l_for_cmp - l_req_cmp
             
                           #需求小
                           #==>需求重抓
                           INITIALIZE g_req_tmp TO NULL
                           LET l_req = l_req + 1
                          #FUN-B60063--mod---str---
                          #SELECT * INTO g_req_tmp.*
                          #  FROM req_tmp
                          # WHERE tmp16 = p_tmp16 #FUN-870104 mod
                          #   AND tmp02 = p_tmp02
                          #   AND tmp15 = l_req
                           FETCH ABSOLUTE l_req p400_mds_req_c2 INTO g_req_tmp.*
                          #FUN-B60063--mod---end---
                           IF STATUS = 100 THEN LET l_req_end = 'Y' END IF
                           LET l_req_cmp = g_req_tmp.tmp04
                           IF cl_null(l_req_cmp) THEN LET l_req_cmp = 0 END IF
                  WHEN g_cnt > 0
                           #需求大
                           LET l_req_cmp = l_req_cmp - l_for_cmp
             
                           #預測小
                           #==>預測重抓
                           INITIALIZE g_for_tmp TO NULL
                           LET l_for = l_for + 1
                          #FUN-B60063---mod---str---
                          #SELECT * INTO g_for_tmp.*
                          #  FROM for_tmp
                          # WHERE tmp16 = p_tmp16 #FUN-870104 mod
                          #   AND tmp02 = p_tmp02
                          #   AND tmp15 = l_for
                           FETCH ABSOLUTE l_for p400_mds_for_c2 INTO g_for_tmp.*
                          #FUN-B60063---mod---end---
                           IF STATUS = 100 THEN LET l_for_end = 'Y' END IF
                           LET l_for_cmp = g_for_tmp.tmp04
                           IF cl_null(l_for_cmp) THEN LET l_for_cmp = 0 END IF
                  WHEN g_cnt = 0 
                           #需求=預測
                           #==>需求重抓
                           INITIALIZE g_req_tmp TO NULL
                           LET l_req = l_req + 1
                          #FUN-B60063--mod---str---
                          #SELECT * INTO g_req_tmp.*
                          #  FROM req_tmp
                          # WHERE tmp16 = p_tmp16 #FUN-870104 mod
                          #   AND tmp02 = p_tmp02
                          #   AND tmp15 = l_req
                           FETCH ABSOLUTE l_req p400_mds_req_c2 INTO g_req_tmp.*
                          #FUN-B60063--mod---end---
                           IF STATUS = 100 THEN LET l_req_end = 'Y' END IF
                           LET l_req_cmp = g_req_tmp.tmp04
                           IF cl_null(l_req_cmp) THEN LET l_req_cmp = 0 END IF
                           #==>預測重抓
                           INITIALIZE g_for_tmp TO NULL
                           LET l_for = l_for + 1
                   
                          #FUN-B60063--mod---str---
                          #SELECT * INTO g_for_tmp.*
                          #  FROM for_tmp
                          # WHERE tmp16 = p_tmp16 #FUN-870104 mod
                          #   AND tmp02 = p_tmp02
                          #   AND tmp15 = l_for
                           FETCH ABSOLUTE l_for p400_mds_for_c2 INTO g_for_tmp.*
                          #FUN-B60063--mod---end---
                           IF STATUS = 100 THEN LET l_for_end = 'Y' END IF
                           LET l_for_cmp = g_for_tmp.tmp04
                           IF cl_null(l_for_cmp) THEN LET l_for_cmp = 0 END IF
             END CASE
         ELSE
             IF l_for_end = 'N' THEN
                 #==>預測重抓
                 INITIALIZE g_for_tmp TO NULL
                 LET l_for = l_for + 1
                #FUN-B60063--mod---str---
                #SELECT * INTO g_for_tmp.*
                #  FROM for_tmp
                # WHERE tmp16 = p_tmp16 #FUN-870104 mod
                #   AND tmp02 = p_tmp02
                #   AND tmp15 = l_for
                 FETCH ABSOLUTE l_for p400_mds_for_c2 INTO g_for_tmp.*
                #FUN-B60063--mod---end---
                 IF STATUS = 100 THEN LET l_for_end = 'Y' END IF
                 LET l_for_cmp = g_for_tmp.tmp04
                 IF cl_null(l_for_cmp) THEN LET l_for_cmp = 0 END IF
             ELSE
                 #==>需求重抓
                 INITIALIZE g_req_tmp TO NULL
                 LET l_req = l_req + 1
                #FUN-B60063---mod---str---
                #SELECT * INTO g_req_tmp.*
                #  FROM req_tmp
                # WHERE tmp16 = p_tmp16 #FUN-870104 mod
                #   AND tmp02 = p_tmp02
                #   AND tmp15 = l_req
                 FETCH ABSOLUTE l_req p400_mds_req_c2 INTO g_req_tmp.*
                #FUN-B60063---mod---end---
                 IF STATUS = 100 THEN LET l_req_end = 'Y' END IF
                 LET l_req_cmp = g_req_tmp.tmp04
                 IF cl_null(l_req_cmp) THEN LET l_req_cmp = 0 END IF
             END IF
         END IF
         IF l_req_end = 'Y' AND l_for_end = 'Y' THEN 
             EXIT FOR
         END IF
     END FOR
     CLOSE p400_mds_req_c2 #FUN-B60063 add
     CLOSE p400_mds_for_c2 #FUN-B60063 add

END FUNCTION
#FUN-B60063---add---end--
