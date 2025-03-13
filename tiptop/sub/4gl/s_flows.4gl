# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_flowauno.4gl
# Descriptions...: 产生/维护现金变动码资料
# Date & Author..: 11/07/05 By wujie #TQC-B70021
# Usage..........: (p_source,p_bookno,p_no,p_date,p_conf,p_npptype,p_carry)  
# Modify.........: No.TQC-B80059 11/08/04 By wujie 排除借贷都有现金科目切金额相抵的情况
# Modify.........: No.FUN-B90062 11/09/09 By wujie 追加tic09  
# Modify.........: No.TQC-BB0152 11/11/17 By wujie 判断itc03要用本币
# Modify.........: No.MOD-BB0243 11/11/24 By Polly FOREACH s_fsgl_flows_cur1針加NOT p_carry 判斷
# Modify.........: No.MOD-BC0006 11/12/01 By Dido npq00 與 aag00 不能串連;金額超出現金科目金額時應判斷是否已存在
# Modify.........: No.FUN-BC0110 11/12/29 By SunLM  審核時候,判斷是否啟用現金流量表控制,以及生成現金變動碼tic時候,
# Modify.........:                                  考慮到aglt110單身紅沖情況,以及取位問題修改(TQC-BB0246)
# Modify.........: No.MOD-BC0285 12/01/08 By Polly 判斷 agl-445 抓取 l_sum1/l_sum2 改 SUM(abb07)
# Modify.........: No.TQC-C10105 12/01/30 By SunLM 添加錯誤提示 "agl-448"
# Modify.........: No.MOD-C30674 12/03/14 By zhangweib 還原MOD-BB0243所做的修改
# Modify.........: No.MOD-C50162 12/05/22 By wujie  借贷方的现金科目金额需要抵扣
# Modify.........: No.TQC-C50214 12/05/25 By wujie  l_sum3,l_sum4若为null应赋予0
# Modify.........: No.TQC-C60077 12/06/08 By lujh 現金變動碼來源=2:總賬系統，且現金變動碼輸入控制是“1:必須輸入”
#                                                 點擊【設置現金變動碼】按鈕後進入s_flows界面，若刪除單身的現金變動碼資料後點擊【確定】提交資料
#                                                 系統未控卡提示現金變動碼必輸，提交資料ok
# Modify.........: No.TQC-C60090 12/06/11 By lujh 現金變動碼來源=2:總賬系統，且現金變動碼輸入控制是“2：提示空白，但可繼續審核”
#                                                 點擊【設置現金變動碼】按鈕後進入s_flows界面，若刪除單身資料，點確定提交資料ok後，點擊【審核】審核憑證資料，
#                                                 有提示“agl-445 缺少對應的現金變動碼資料，請維護！”，提示後，仍然無法審核，未更新審核碼。
# Modify.........: No.TQC-C60098 12/06/11 By lujh 現金變動碼來源=2:總賬系統，且現金變動碼輸入控制是“3：可以空白，審核時沒有提示” 
#                                                 點擊【設置現金變動碼】按鈕後進入s_flows界面，若刪除單身資料，點確定提交資料ok後，點擊【審核】審核憑證資料，
#                                                 提示“agl-445 缺少對應的現金變動碼資料，請維護！”，參數是可以空白，審核時不提示，未依據參數設置管控。
#                                                 現金變動碼來源=2:總賬系統，且現金變動碼輸入控制是“1:必須輸入”
#                                                 點擊【設置現金變動碼】按鈕後進入s_flows界面，若刪除單身資料，點退出，審核時要管控
# Modify.........: No.TQC-C60103 12/06/12 By lujh 現金變動碼來源=3:分錄底稿，且現金變動碼輸入控制是“1:必須輸入” 
#                                                 點擊【設置現金變動碼】按鈕後進入s_flows界面，若刪除單身的現金變動碼資料後點擊【確定】提交資料，
#                                                 系統未控卡提示現金變動碼必輸，提交資料ok
# Modify.........: No.MOD-D80106 13/08/16 By fengmy 相同現金變動碼的金額加總時，現金變動碼在g_tic中的位置不一定相邻
# Modify.........: No.FUN-D80115 13/08/29 By yangtt 票据參數里加個重評价默認現金异動碼(nmz73)，gnmp600產生分錄的時候，帶出默認值
# Modify.........: No.CHI-DA0033 13/10/28 By yinhy 現金變動碼來源=3:分錄底稿時，增加紅沖情況 
# Modify.........: No.MOD-06419  17/05/23 by dengsy  现金变动码包含有两种汇率的时候，原币计算需要分情况讨论
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_flows(p_source,p_bookno,p_no,p_date,p_conf,p_npptype,p_carry)
   DEFINE p_bookno  LIKE aza_file.aza81   #帐套
   DEFINE p_source  LIKE type_file.chr1   #资料来源 1 票据资金系统
                                          #         2 总帐系统
                                          #         3 分录底稿 
   DEFINE p_no      LIKE npp_file.npp01   #单号
   DEFINE p_date    LIKE npp_file.npp02   #日期
   DEFINE p_conf    LIKE aba_file.aba19   #审核否   
   DEFINE p_npptype LIKE npp_file.npptype #类型 abb传null 
   DEFINE p_carry   LIKE type_file.num5   #；来源是否为抛转
   DEFINE l_tic00   LIKE tic_file.tic00   #帳套
   DEFINE l_tic01   LIKE tic_file.tic01   #年度
   DEFINE l_tic02   LIKE tic_file.tic02   #期別
   DEFINE l_tic03   LIKE tic_file.tic03   #借貸別
   DEFINE g_tic     DYNAMIC ARRAY OF RECORD          
                    tic04     LIKE tic_file.tic04,  #單據編號
                    tic05     LIKE tic_file.tic05,  #項次
                    tic06     LIKE tic_file.tic06,  #現金變動碼
                    nml02     LIKE nml_file.nml02,  #名称 #add by dengsy170212
                    tic08     LIKE tic_file.tic08,  #關係人
                    tic07f    LIKE tic_file.tic07f, #原幣金額
                    tic07     LIKE tic_file.tic07   #本幣金額     
                    END RECORD,
          g_tic_t   RECORD          
                    tic04     LIKE tic_file.tic04,  #單據編號
                    tic05     LIKE tic_file.tic05,  #項次
                    tic06     LIKE tic_file.tic06,  #現金變動碼
                    nml02     LIKE nml_file.nml02,  #名称 #add by dengsy170212
                    tic08     LIKE tic_file.tic08,  #關係人
                    tic07f    LIKE tic_file.tic07f, #原幣金額
                    tic07     LIKE tic_file.tic07   #本幣金額     
                    END RECORD
   DEFINE g_tic_flows DYNAMIC ARRAY OF RECORD
                    npq02     LIKE npq_file.npq02,  #項次
                    npq25     LIKE npq_file.npq25,  #匯率
                    aag371    LIKE aag_file.aag371,  
                    npq37     LIKE npq_file.npq37,  #關係人
                    npq07f    LIKE npq_file.npq07f, #原幣金額 
                    npq07     LIKE npq_file.npq07   #本幣金額
                    END RECORD                 
   DEFINE l_n,t,i,j           LIKE type_file.num5
   DEFINE g_success           LIKE type_file.chr1  
   DEFINE l_rec_b             LIKE type_file.num5 
   DEFINE l_allow_insert      LIKE type_file.num5
   DEFINE l_allow_delete      LIKE type_file.num5 
   DEFINE p_cmd               LIKE type_file.chr1 
   DEFINE l_sum1,l_sum2       LIKE abb_file.abb07
   DEFINE l_sum3,l_sum4       LIKE abb_file.abb07f 
   DEFINE l_sql               STRING 
   DEFINE l_sql1              STRING 
   DEFINE l_sql2              STRING
   DEFINE l_npq06             LIKE npq_file.npq06
   DEFINE l_npq02             LIKE npq_file.npq02
   DEFINE l_tic05             LIKE tic_file.tic05
   DEFINE l_npq03             LIKE npq_file.npq03
   DEFINE l_npq25             LIKE npq_file.npq25 
   DEFINE l_aag371            LIKE aag_file.aag371
   DEFINE l_bookno1           LIKE aza_file.aza81   
   DEFINE l_bookno2           LIKE aza_file.aza82   
   DEFINE l_flag1             LIKE type_file.chr1 
   DEFINE l_sql3              STRING               #FUN-BC0110 ADD
   DEFINE l_tic07             LIKE tic_file.tic07  #FUN-BC0110 ADD
   DEFINE l_tic07f            LIKE tic_file.tic07f #FUN-BC0110 ADD
   DEFINE l_ct                LIKE type_file.num5  #FUN-BC0110 ADD
   DEFINE l_npq24             LIKE npq_file.npq24  #FUN-BC0110 ADD  #TQC-BB0246
#No.MOD-C50162 --begin
   DEFINE l_sum5              LIKE abb_file.abb07
   DEFINE l_sum6              LIKE abb_file.abb07f 
   DEFINE l_sum7              LIKE abb_file.abb07
   DEFINE l_sum8              LIKE abb_file.abb07f 
#No.MOD-C50162 --end 
   DEFINE l_k                 LIKE type_file.num5  #MOD-D80106
   DEFINE l_flag              LIKE type_file.chr1  #MOD-D80106
   DEFINE l_npq07             LIKE npq_file.npq07   #CHI-DA0033
   DEFINE l_npq07f            LIKE npq_file.npq07f  #CHI-DA0033
   DEFINE l_tic04             LIKE tic_file.tic04 #add by liyjf170302
#TQC-B70021   
   IF g_success ='N' THEN RETURN END IF 
   SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file 
   IF g_prog<>'aglt110' THEN  #add by dengsy170221 
   IF  cl_null(p_source) OR p_source <> g_nmz.nmz70 THEN RETURN END IF 
   END IF #add by dengsy170221 
   CALL g_tic.clear()
   CALL g_tic_flows.clear() 
   IF NOT p_carry THEN  
      OPEN WINDOW s_flows AT 10,20 WITH FORM "sub/42f/s_flows"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
 
     CALL cl_ui_locale("s_flows") 
     IF p_source ='1' THEN
        CALL cl_set_comp_entry("tic04,tic05",FALSE) 
     END IF 
   END IF 
   WHENEVER ERROR CONTINUE 
   #str------- add by dengsy170221
   IF g_prog='aglt110' THEN 

   LET l_tic00 = p_bookno  
      LET l_tic01 = YEAR(p_date)             #年度
      LET l_tic02 = MONTH(p_date)            #期別  
        LET l_tic03 = '' 

          LET i=1
           LET l_rec_b=0
           DECLARE s_fsgl_c1 CURSOR FOR
            SELECT DISTINCT tic04,tic05,tic06,nml02,tic08,round(tic07f,2),round(tic07,2) FROM tic_file
            LEFT OUTER JOIN nml_file ON nml01=tic06   
                WHERE tic00 = l_tic00
                    --AND tic01 = l_tic01
                    --AND tic02 = l_tic02
                    AND tic04 in (SELECT npp01  FROM npp_file WHERE nppglno = p_no)
                    ORDER BY tic04
         
   CALL g_tic.clear()

   LET i=1
    LET l_rec_b=0
   FOREACH s_fsgl_c1 INTO g_tic[i].*
      IF STATUS THEN
         CALL cl_err('foreach tic',STATUS,0)
         EXIT FOREACH
      END IF
      
      LET i = i + 1
   END FOREACH

   CALL g_tic.deleteElement(i)
   LET l_rec_b = i - 1
   
      DISPLAY ARRAY g_tic TO s_tic.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)

       BEFORE DISPLAY 
          IF l_rec_b>0 THEN 
         
          END IF 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            EXIT DISPLAY
      END DISPLAY
      CLOSE WINDOW s_flows     
      RETURN


   END IF 
   #end------- add by dengsy170221
   
   IF p_source MATCHES '[23]' THEN 
      IF p_source ='3' THEN  
         CALL s_get_bookno(YEAR(p_date)) RETURNING l_flag1,l_bookno1,l_bookno2   #帳套   
         IF p_npptype = 0 THEN
            LET p_bookno = l_bookno1
         ELSE
            LET p_bookno = l_bookno2
         END IF 
      END IF 
      LET l_tic00 = p_bookno  
      LET l_tic01 = YEAR(p_date)             #年度
      LET l_tic02 = MONTH(p_date)            #期別  
      LET l_tic03 = '' 
      SELECT DISTINCT tic03 INTO l_tic03 FROM tic_file
       WHERE tic00 = l_tic00
         AND tic01 = l_tic01
         AND tic02 = l_tic02
         AND tic04 = p_no   
      IF cl_null(l_tic03) THEN   
         LET l_sum1 = ''
         LET l_sum2 = ''
         IF p_source = '2' THEN 
#           SELECT SUM(abb07f) INTO l_sum1 FROM abb_file,aag_file
            SELECT SUM(abb07),SUM(abb07f) INTO l_sum1,l_sum3 FROM abb_file,aag_file    #No.TQC-BB0152   #No.MOD-C50162 add l_sum3
             WHERE abb03 = aag01
               AND abb00 = p_bookno            
               AND abb01 = p_no            
               AND aag00 = abb00            
               AND abb06 = '1'
               AND aag19 = 1
#           SELECT SUM(abb07f) INTO l_sum2 FROM abb_file,aag_file
            SELECT SUM(abb07),SUM(abb07f) INTO l_sum2,l_sum4 FROM abb_file,aag_file    #No.TQC-BB0152   #No.MOD-C50162 add l_sum4
             WHERE abb03 = aag01
               AND abb00 = p_bookno            
               AND abb01 = p_no            
               AND aag00 = abb00            
               AND abb06 = '2'
               AND aag19 = 1
      
         ELSE  
#           SELECT SUM(npq07f) INTO l_sum1 FROM npq_file,aag_file
            SELECT SUM(npq07),SUM(npq07f) INTO l_sum1,l_sum3 FROM npq_file,aag_file    #No.TQC-BB0152    #No.MOD-C50162 add l_sum3    
             WHERE npq03 = aag01 
               AND npq01 = p_no            
               AND npqtype = p_npptype 
               AND aag00 = l_tic00
               AND aag19 = '1'
               AND npq06 = '1'
            
#           SELECT SUM(npq07f) INTO l_sum2 FROM npq_file,aag_file
            SELECT SUM(npq07),SUM(npq07f) INTO l_sum2,l_sum4 FROM npq_file,aag_file    #No.TQC-BB0152    #No.MOD-C50162 add l_sum4
             WHERE npq03 = aag01 
               AND npq01 = p_no            
               AND npqtype = p_npptype 
               AND aag00 = l_tic00  
               AND aag19 = '1'
               AND npq06 = '2' 
         END IF 
         IF cl_null(l_sum1) THEN
            LET l_sum1 = 0
         END IF  
      
         IF cl_null(l_sum2) THEN
            LET l_sum2 = 0
         END IF 
      
         IF l_sum1 > l_sum2 THEN
            LET l_tic03 = '2'
         ELSE
            LET l_tic03 = '1'
         END IF
#FUN-BC0110 ADD  BEGIN
         IF l_sum1 = 0  THEN 
             LET l_tic03 = '1'
         END IF 
         IF l_sum2 = 0  THEN 
             LET l_tic03 = '2'
         END IF 
#FUN-BC0110 END
#No.MOD-C50162 --begin
#需要把少的那方的现金科目总金额在多的一方扣除
#No.TQC-C50214 --begin
         IF cl_null(l_sum3) THEN
            LET l_sum3 = 0
         END IF  
         IF cl_null(l_sum4) THEN
            LET l_sum4 = 0
         END IF  
#No.TQC-C50214 --end   
         LET l_sum5 = 0 
         LET l_sum6 = 0 
         LET l_sum7 = 0
         LET l_sum8 = 0
         IF l_tic03 ='1' THEN
         	  LET l_sum5 = l_sum1
         	  LET l_sum6 = l_sum3
         ELSE
            LET l_sum5 = l_sum2
            LET l_sum6 = l_sum4
         END IF
         LET l_sum7 = l_sum5 
         LET l_sum8 = l_sum6 
#No.MOD-C50162 --end
         IF p_conf NOT MATCHES '[YyXx]' THEN                #MOD-BB0243 mark    #No.MOD-C30674   Unmark
        #IF p_conf NOT MATCHES '[YyXx]' OR p_carry THEN     #MOD-BB0243 add     #No.MOD-C30674   Mark
            IF p_source ='2' THEN 
               LET l_sql1 = "SELECT abb02,abb25,aag371,abb37,abb07f,abb07 ",
                            "  FROM abb_file,aag_file ",
                            " WHERE abb03 = aag01 AND aag19 = '1' ",
                            "   AND abb00 = aag00 ",            #MOD-BB0243
                            "   AND abb01 = '",p_no,"'",
                            "   AND aag00 = '",l_tic00,"'",
                            "   AND abb06 <> '",l_tic03,"'",
                            " ORDER BY abb07 DESC"            
               LET l_sql2 = "SELECT abb01,abb02,aag41,'','',abb07f,abb07,abb24 FROM abb_file,aag_file ",#add abb24 TQC-BB0246  #add '' by dengsy170214
                           " WHERE abb03 = aag01 AND aag19 <> '1' ",
                           "   AND abb00 = aag00 ",            #MOD-BB0243
                           "   AND abb01 = '",p_no,"'",
                           "   AND aag00 = '",l_tic00,"'",
                           "   AND abb06 = '",l_tic03,"'",
                           " ORDER BY abb07 DESC " 
# FUN-BC0110   begin
               #紅沖情況,增加一个sql3，抓取与l_tic03反方向的，非现金类科目，参考l_sql2， 但是abb06与l_sql2取相反的 
               LET l_sql3 = "SELECT abb01,abb02,aag41,'','',(-1)*abb07f,(-1)*abb07,abb24 ", #add '' by dengsy170213 
                            "  FROM abb_file,aag_file ",
                            " WHERE abb03 = aag01 AND aag19 <> '1' ",
                            "   AND abb00 = aag00 ",            
                            "   AND abb01 = '",p_no,"'",
                            "   AND aag00 = '",l_tic00,"'",
                            "   AND abb06 <> '",l_tic03,"'",
                            " ORDER BY (-1)*abb07 DESC " 
#FUN-BC0110增加定義sql3 cursor
#               PREPARE s_fsgl_flows_pre3 FROM l_sql3                           #yinhy131028 mark
#               DECLARE s_fsgl_flows_cur3 CURSOR FOR s_fsgl_flows_pre3          #yinhy131028 mark
# FUN-BC0110   end             
            ELSE 
               LET l_sql1 = "SELECT npq02,npq25,aag371,npq37,npq07f,npq07 FROM npq_file,aag_file ",
                           " WHERE npq03 = aag01 AND aag19 = '1' ",
                          #"   AND npq00 = aag00 ",            #MOD-BB0243 #MOD-BC0006 mark
                           "   AND npq01 = '",p_no,"'",
                           "   AND aag00 = '",l_tic00,"'",
                           "   AND npqtype = '",p_npptype,"'",                        
                           "   AND npq06 <> '",l_tic03,"'",
                           " ORDER BY npq07 DESC"            
              #FUN-D80115---add---str---
               IF p_source ='1' AND (g_prog = 'gnmq600' OR g_prog = 'gnmq610') THEN
                  LET l_sql2 = "SELECT npq01,npq02,'','','',npq07f,npq07,npq24 ",  #add '' by dengsy170213
                               "  FROM npq_file,nmz_file ",
                               " WHERE npq01 = '",p_no,"'",
                               "   AND npq00 = '",l_tic00,"'",
                               "   AND npq06 = '",l_tic03,"'",
                               "   AND npqtype = '",p_npptype,"'",
                               " ORDER BY npq07 DESC "
               ELSE
              #FUN-D80115---add---end---
                  LET l_sql2 = "SELECT npq01,npq02,aag41,'','',npq07f,npq07,npq24 ", #add '' by dengsy170213
                               "  FROM npq_file,aag_file ",#add npq24 TQC-BB0246
                               " WHERE npq03 = aag01 AND aag19 <> '1' ",
                              #"   AND npq00 = aag00 ",            #MOD-BB0243 #MOD-BC0006 mark
                               "   AND npq01 = '",p_no,"'",
                               "   AND aag00 = '",l_tic00,"'",
                               "   AND npq06 = '",l_tic03,"'",
                               "   AND npqtype = '",p_npptype,"'",                        
                               " ORDER BY npq07 DESC " 
               END IF   #FUN-D80115 add
              #No.CHI-DA0033--Begin
              LET l_sql3 = "SELECT npq02,npq25,aag371,'',npq37,(-1)*npq07f,(-1)*npq07 FROM npq_file,aag_file ",  #add '' by dengsy170213
                           " WHERE npq03 = aag01 AND aag19 <> '1' ",
                           "   AND npq01 = '",p_no,"'",
                           "   AND aag00 = '",l_tic00,"'",
                           "   AND npqtype = '",p_npptype,"'",                        
                           "   AND npq06 <> '",l_tic03,"'",
                           " ORDER BY (-1)*npq07 DESC"
              #No.CHI-DA0033--End        
            END IF 
               PREPARE s_fsgl_flows_pre1 FROM l_sql1       
               DECLARE s_fsgl_flows_cur1 CURSOR FOR s_fsgl_flows_pre1
      
               PREPARE s_fsgl_flows_pre2 FROM l_sql2
               DECLARE s_fsgl_flows_cur2 CURSOR FOR s_fsgl_flows_pre2
               
               PREPARE s_fsgl_flows_pre3 FROM l_sql3
               DECLARE s_fsgl_flows_cur3 CURSOR FOR s_fsgl_flows_pre3   
         END IF 
         LET t = 1
         LET i = 1
         CALL g_tic.clear()
         CALL g_tic_flows.clear()
         LET l_npq06 = ''
         FOREACH s_fsgl_flows_cur1 INTO g_tic_flows[t].*
            IF STATUS THEN
               CALL cl_err('foreach npq1',STATUS,0)
               LET g_success = 'N'          
               EXIT FOREACH
            END IF 
            IF cl_null(g_tic_flows[t].npq07) THEN 
               LET g_tic_flows[t].npq07 = 0 
            END IF
#No.MOD-C50162 --begin
            IF l_sum5 > g_tic_flows[t].npq07 THEN
               LET l_sum5 = l_sum5 - g_tic_flows[t].npq07
               LET g_tic_flows[t].npq07 = 0 
            ELSE
               LET g_tic_flows[t].npq07 = g_tic_flows[t].npq07 - l_sum5
               LET l_sum5 = 0 
            END IF
            IF l_sum6 > g_tic_flows[t].npq07f THEN
               LET l_sum6 = l_sum6 - g_tic_flows[t].npq07f
               LET g_tic_flows[t].npq07f = 0 
            ELSE
               LET g_tic_flows[t].npq07f = g_tic_flows[t].npq07f - l_sum6
               LET l_sum6 = 0 
            END IF
            #str----- add by dengsy170523
            IF NOT cl_null(g_tic_flows[t].npq25) AND g_tic_flows[t].npq25 <> 1 THEN
                FOREACH s_fsgl_flows_cur2 INTO g_tic[i].*,l_npq24 #No.TQC-BB0246
                  IF STATUS THEN
                     CALL cl_err('foreach s_fsgl_flows_cur2',STATUS,2)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  SELECT nmz73 INTO g_tic[i].tic06 FROM nmz_file WHERE nmz71 = 'Y' AND nmz70 = '3'  #FUN-D80115
                  IF cl_null(g_tic[i].tic07) THEN 
                     LET g_tic[i].tic07 = 0 
                  END IF
                  IF g_tic[i].tic07f=0 OR g_tic[i].tic07<>g_tic[i].tic07f THEN
                     SELECT azi04 INTO t_azi04
                       FROM azi_file
                      WHERE azi01 = l_npq24
                
                     LET g_tic[i].tic07f = g_tic[i].tic07/g_tic_flows[t].npq25
                     LET g_tic[i].tic07f = cl_digcut(g_tic[i].tic07f,2)  #add by dengsy170406
                  END IF 
                  LET i = i + 1 
               END FOREACH
            ELSE 
               FOREACH s_fsgl_flows_cur2 INTO g_tic[i].*,l_npq24 #No.TQC-BB0246
                  IF STATUS THEN
                     CALL cl_err('foreach s_fsgl_flows_cur2',STATUS,2)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  SELECT nmz73 INTO g_tic[i].tic06 FROM nmz_file WHERE nmz71 = 'Y' AND nmz70 = '3'  #FUN-D80115
                  IF cl_null(g_tic[i].tic07) THEN 
                     LET g_tic[i].tic07 = 0 
                  END IF
                  IF g_tic[i].tic07f=0 OR g_tic[i].tic07<>g_tic[i].tic07f THEN
                  ELSE 
                     SELECT azi04 INTO t_azi04
                       FROM azi_file
                      WHERE azi01 = l_npq24
                
                     LET g_tic[i].tic07f = g_tic[i].tic07/g_tic_flows[t].npq25
                     LET g_tic[i].tic07f = cl_digcut(g_tic[i].tic07f,2)  #add by dengsy170406
                  END IF 
                  LET i = i + 1 
               END FOREACH
            END IF 
            #end----- add by dengsy170523
            #str----- mark by dengsy170523
#No.MOD-C50162 --end 
            --IF t = 1 THEN
               --LET i = 1
               --FOREACH s_fsgl_flows_cur2 INTO g_tic[i].*,l_npq24 #No.TQC-BB0246
                  --IF STATUS THEN
                     --CALL cl_err('foreach s_fsgl_flows_cur2',STATUS,2)
                     --LET g_success = 'N'
                     --EXIT FOREACH
                  --END IF
                  --SELECT nmz73 INTO g_tic[i].tic06 FROM nmz_file WHERE nmz71 = 'Y' AND nmz70 = '3'  #FUN-D80115
                  --IF cl_null(g_tic[i].tic07) THEN 
                     --LET g_tic[i].tic07 = 0 
                  --END IF
                  --IF NOT cl_null(g_tic_flows[t].npq25) AND g_tic_flows[t].npq25 > 0 THEN
                  #No.TQC-BB0246 add-----begin
                     --SELECT azi04 INTO t_azi04
                       --FROM azi_file
                      --WHERE azi01 = l_npq24
                  #No.TQC-BB0246 add-----end
                     --LET g_tic[i].tic07f = g_tic[i].tic07/g_tic_flows[t].npq25
                     #LET g_tic[i].tic07f = cl_digcut(g_tic[i].tic07f,g_azi04)   
                     #LET g_tic[i].tic07f = cl_digcut(g_tic[i].tic07f,t_azi04) #No.TQC-BB0246 modify: g_azi->t_azi #mark by dengsy170406
                     --LET g_tic[i].tic07f = cl_digcut(g_tic[i].tic07f,2)  #add by dengsy170406
                  --END IF 
                  --LET i = i + 1 
               --END FOREACH
            --END IF
            #end------ mark by dengsy170523
            
            FOR j = 1 TO i - 1 
                IF g_tic_flows[t].npq07 = 0 OR g_tic[j].tic07 = 0 THEN
                   CONTINUE FOR
                END IF
                #str------- add by dengsy170221
                IF cl_null(g_tic[j].tic06) THEN
                    IF g_prog='aapt330' THEN 
                      SELECT apf14 INTO g_tic[j].tic06 FROM apf_file
                       WHERE apf01=p_no 
                   END IF
                END IF
                
                #end------- add by dengsy170221
                IF NOT cl_null(g_tic_flows[t].aag371) THEN
                   LET g_tic[j].tic08 = g_tic_flows[t].npq37
                END IF
                IF cl_null(g_tic[j].tic06) THEN             
                   LET g_tic[j].tic06 = ' '
                END IF
                IF cl_null(g_tic[j].tic08) THEN             
                   LET g_tic[j].tic08 = ' '
                END IF
                
                IF g_tic[j].tic07 > g_tic_flows[t].npq07 THEN 
                  #-MOD-BC0006-add-
                   IF j > 1 THEN 
                  #MOD-D80106--begin
                      LET l_flag = 'N'
                      FOR l_k =1 TO j-1
                         IF l_npq02 = g_tic_flows[t].npq02 AND g_tic[j].tic06 = g_tic[l_k].tic06
                            AND g_tic[j].tic08 = g_tic[l_k].tic08 THEN
                            LET l_flag='Y'
                         END IF
                      END FOR
                      IF l_flag = 'Y' THEN
                  #MOD-D80106--end
                     #IF l_npq02 = g_tic_flows[t].npq02 AND g_tic[j].tic06 = g_tic[j-1].tic06   #MOD-D80106 mark
                     #   AND g_tic[j].tic08 = g_tic[j-1].tic08 THEN                             #MOD-D80106 mark
                         UPDATE tic_file SET tic07 = tic07 + g_tic_flows[t].npq07,
                                             tic07f = tic07f + g_tic_flows[t].npq07f 
                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
                            AND tic02 = l_tic02  AND tic04 = p_no                         
                            AND tic05 = g_tic_flows[t].npq02
                            AND tic06 = g_tic[j].tic06
                            AND tic08 = g_tic[j].tic08 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","tic_file","",p_no,SQLCA.sqlcode,"","upd tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF    
                      ELSE
                         
                         INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)    #No.FUN-B90062 add tic09 
                          VALUES (l_tic00,l_tic01,l_tic02,l_tic03,p_no,g_tic_flows[t].npq02,
                                  g_tic[j].tic06,g_tic_flows[t].npq07,g_tic_flows[t].npq07f,g_tic[j].tic08,p_source) #No.FUN-B90062 add tic09
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("ins","tic_file","",p_no,SQLCA.sqlcode,"","ins tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF 
                      END IF     
                   ELSE 
                  #-MOD-BC0006-end-
                     
                      INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)   #No.FUN-B90062 add tic09 
                       VALUES (l_tic00,l_tic01,l_tic02,l_tic03,p_no,g_tic_flows[t].npq02,
                               g_tic[j].tic06,g_tic_flows[t].npq07,g_tic_flows[t].npq07f,g_tic[j].tic08,p_source) #No.FUN-B90062 add tic09
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("ins","tic_file","",p_no,SQLCA.sqlcode,"","ins tic",1)
                         LET g_success = 'N'
                         EXIT FOREACH
                      END IF                
                   END IF               #MOD-BC0006 
                   LET g_tic[j].tic07 = g_tic[j].tic07 - g_tic_flows[t].npq07 
                   LET g_tic[j].tic07f = g_tic[j].tic07f - g_tic_flows[t].npq07f
                   EXIT FOR    
                ELSE
                   IF j > 1 THEN 
                  #MOD-D80106--begin
                      LET l_flag = 'N'
                      FOR l_k =1 TO j-1
                         IF l_npq02 = g_tic_flows[t].npq02 AND g_tic[j].tic06 = g_tic[l_k].tic06
                            AND g_tic[j].tic08 = g_tic[l_k].tic08 THEN
                            LET l_flag='Y'
                         END IF
                      END FOR
                      IF l_flag = 'Y' THEN
                  #MOD-D80106--end
                     #IF l_npq02 = g_tic_flows[t].npq02 AND g_tic[j].tic06 = g_tic[j-1].tic06  #MOD-D80106 mark
                     #   AND g_tic[j].tic08 = g_tic[j-1].tic08 THEN                            #MOD-D80106 mark
                         UPDATE tic_file SET tic07 = tic07 + g_tic[j].tic07,tic07f = tic07f + g_tic[j].tic07f
                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
                            AND tic02 = l_tic02  AND tic04 = p_no                         
                            AND tic05 = g_tic_flows[t].npq02
                            AND tic06 = g_tic[j].tic06
                            AND tic08 = g_tic[j].tic08 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","tic_file","",p_no,SQLCA.sqlcode,"","upd tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF    
                      ELSE
                         
                         INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)   #No.FUN-B90062 add tic09  
                         VALUES (l_tic00,l_tic01,l_tic02,l_tic03,p_no,g_tic_flows[t].npq02,
                                 g_tic[j].tic06,g_tic[j].tic07,g_tic[j].tic07f,g_tic[j].tic08,p_source) #No.FUN-B90062 add tic09 

                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("ins","tic_file","",p_no,SQLCA.sqlcode,"","ins tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF 
                      END IF     
                   ELSE 
                      
                      INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)   #No.FUN-B90062 add tic09                       
                      VALUES (l_tic00,l_tic01,l_tic02,l_tic03,p_no,g_tic_flows[t].npq02,
                              g_tic[j].tic06,g_tic[j].tic07,g_tic[j].tic07f,g_tic[j].tic08,p_source) #No.FUN-B90062 add tic09  #mark by dengsy170221

                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("ins","tic_file","",p_no,SQLCA.sqlcode,"","ins tic",1)
                         LET g_success = 'N'
                         EXIT FOREACH
                      END IF 
                   END IF          
                   LET g_tic_flows[t].npq07 = g_tic_flows[t].npq07 - g_tic[j].tic07 
                   LET g_tic_flows[t].npq07f = g_tic_flows[t].npq07f - g_tic[j].tic07f
                   LET g_tic[j].tic07 = 0
                   LET g_tic[j].tic07f = 0
                   LET l_npq02 = g_tic_flows[t].npq02                
                END IF   
            END FOR
            LET t = t + 1
         END FOREACH 
#FUN-BC0110 BEGIN ADD
#先判断总体的tic资料里，借贷是否相等，若不相等，参考上一个for的做法将sql3的数组去冲sql1的金额，
#直到借贷相等为止
     #IF p_source =   '2' THEN                              #CHI-DA0033 mark
     IF p_source =   '2' OR p_source =   '3' THEN           #CHI-DA0033
         LET t = 1
         LET i = 1
         CALL g_tic.clear()
         CALL g_tic_flows.clear()
         LET l_npq06 = ''
         FOREACH s_fsgl_flows_cur1 INTO g_tic_flows[t].*
            IF STATUS THEN
               CALL cl_err('foreach npq1',STATUS,0)
               LET g_success = 'N'          
               EXIT FOREACH
            END IF 
#No.MOD-C50162 --begin
           #CHI-DA0033  --Begin
           IF g_tic_flows[t].npq07 < 0 THEN 
              LET l_npq07 = g_tic_flows[t].npq07 * -1
              LET l_npq07f = g_tic_flows[t].npq07f * -1
           END IF
           #CHI-DA0033  --Begin
           #IF l_sum7 > g_tic_flows[t].npq07 THEN   #CHI-DA0033
           IF l_sum7 > l_npq07 THEN                 #CHI-DA0033
              LET l_sum7 = l_sum7 - g_tic_flows[t].npq07
              LET g_tic_flows[t].npq07 = 0 
           ELSE
              LET g_tic_flows[t].npq07 = g_tic_flows[t].npq07 - l_sum7
              LET l_sum7 = 0 
           END IF
           #IF l_sum8 > g_tic_flows[t].npq07f THEN    #CHI-DA0033
           IF l_sum8 > l_npq07f THEN                  #CHI-DA0033
              LET l_sum8 = l_sum8 - g_tic_flows[t].npq07f
              LET g_tic_flows[t].npq07f = 0 
           ELSE
              LET g_tic_flows[t].npq07f = g_tic_flows[t].npq07f - l_sum8
              LET l_sum8 = 0 
           END IF
#No.MOD-C50162 --end 
            IF cl_null(g_tic_flows[t].npq07) THEN 
               LET g_tic_flows[t].npq07 = 0 
            END IF
             # flows tic - sum(tic07)
            #判斷現金類科目相同項次tic07是否已被沖完
            SELECT SUM(tic07) ,SUM(tic07f)  INTO l_tic07 ,l_tic07f FROM tic_file
             WHERE tic00 = l_tic00
                    AND  tic01=  l_tic01
                    AND tic02 =  l_tic02
                    AND tic03 =  l_tic03
                    AND tic04 =  p_no
                    AND tic05 =  g_tic_flows[t].npq02    
            IF l_tic07 IS NULL 
            	  THEN LET l_tic07 = 0 
            END IF
            IF l_tic07f IS NULL 
            	  THEN LET l_tic07f = 0 
            END IF            
            #如果沖完continue foreach
            IF l_tic07 =   g_tic_flows[t].npq07 THEN 
                CONTINUE FOREACH 
            ELSE 
            #如果沒有沖完,則算出剩餘的現金量
               LET g_tic_flows[t].npq07  = g_tic_flows[t].npq07  - l_tic07 
               LET g_tic_flows[t].npq07f  = g_tic_flows[t].npq07f  - l_tic07f
            END IF                
            IF t = 1 THEN
               LET i = 1
               FOREACH s_fsgl_flows_cur3 INTO g_tic[i].*,l_npq24 
                  IF STATUS THEN
                     CALL cl_err('foreach s_fsgl_flows_cur3',STATUS,2)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  IF cl_null(g_tic[i].tic07) THEN 
                     LET g_tic[i].tic07 = 0 
                  END IF          
                  IF NOT cl_null(g_tic_flows[t].npq25) AND g_tic_flows[t].npq25 > 0 THEN
              #No.TQC-BB0246 add-----begin
                     SELECT azi04 INTO t_azi04
                       FROM azi_file
                      WHERE azi01 = l_npq24
              #No.TQC-BB0246 add-----end
                     LET g_tic[i].tic07f = g_tic[i].tic07/g_tic_flows[t].npq25
                     LET g_tic[i].tic07f = cl_digcut(g_tic[i].tic07f,t_azi04) #No.TQC-BB0246 modify: g_azi->t_azi  
                  END IF 
                  LET i = i + 1 
               END FOREACH       
            END IF
            
            FOR j = 1 TO i - 1 
                IF g_tic_flows[t].npq07 = 0 OR g_tic[j].tic07 = 0 THEN
                   CONTINUE FOR
                END IF
                IF NOT cl_null(g_tic_flows[t].aag371) THEN
                   LET g_tic[j].tic08 = g_tic_flows[t].npq37
                END IF
                IF cl_null(g_tic[j].tic06) THEN             
                   LET g_tic[j].tic06 = ' '
                END IF
                IF cl_null(g_tic[j].tic08) THEN             
                   LET g_tic[j].tic08 = ' '
                END IF
                
                IF g_tic[j].tic07 > g_tic_flows[t].npq07 THEN 
                  #-MOD-BC0006-add-
                   IF j > 1 THEN 
                  #MOD-D80106--begin
                      LET l_flag = 'N'
                      FOR l_k =1 TO j-1
                         IF l_npq02 = g_tic_flows[t].npq02 AND g_tic[j].tic06 = g_tic[l_k].tic06
                            AND g_tic[j].tic08 = g_tic[l_k].tic08 THEN
                            LET l_flag='Y'
                         END IF
                      END FOR
                      IF l_flag = 'Y' THEN
                  #MOD-D80106--end
                     #IF l_npq02 = g_tic_flows[t].npq02 AND g_tic[j].tic06 = g_tic[j-1].tic06 #MOD-D80106 mark
                     #   AND g_tic[j].tic08 = g_tic[j-1].tic08 THEN                           #MOD-D80106 mark
                         UPDATE tic_file SET tic07 = tic07 + g_tic_flows[t].npq07,
                                             tic07f = tic07f + g_tic_flows[t].npq07f 
                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
                            AND tic02 = l_tic02  AND tic04 = p_no                         
                            AND tic05 = g_tic_flows[t].npq02
                            AND tic06 = g_tic[j].tic06
                            AND tic08 = g_tic[j].tic08 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","tic_file","",p_no,SQLCA.sqlcode,"","upd tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF    
                      ELSE
                         INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)    #No.FUN-B90062 add tic09 
                          VALUES (l_tic00,l_tic01,l_tic02,l_tic03,p_no,g_tic_flows[t].npq02,
                                  g_tic[j].tic06,g_tic_flows[t].npq07,g_tic_flows[t].npq07f,g_tic[j].tic08,p_source) #No.FUN-B90062 add tic09 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("ins","tic_file","",p_no,SQLCA.sqlcode,"","ins tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF 
                      END IF     
                   ELSE 
                    	#紅沖時候,如果項次,現金變動碼,關係人一致則更新,不一致則插入
                        SELECT COUNT(*) INTO l_ct FROM tic_file
                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
                            AND tic02 = l_tic02  AND tic04 = p_no                         
                            AND tic05 = g_tic_flows[t].npq02
                            AND tic06 = g_tic[j].tic06
                            AND tic08 = g_tic[j].tic08                         	
                       IF l_ct >0   THEN
                         UPDATE tic_file SET tic07 = tic07 + g_tic_flows[t].npq07,
                                             tic07f = tic07f + g_tic_flows[t].npq07f 
                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
                            AND tic02 = l_tic02  AND tic04 = p_no                         
                            AND tic05 = g_tic_flows[t].npq02
                            AND tic06 = g_tic[j].tic06
                            AND tic08 = g_tic[j].tic08 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","tic_file","",p_no,SQLCA.sqlcode,"","upd tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF 
                  #-MOD-BC0006-end-
                       ELSE 
                       	INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)    #No.FUN-B90062 add tic09 
                            VALUES (l_tic00,l_tic01,l_tic02,l_tic03,p_no,g_tic_flows[t].npq02,
                               g_tic[j].tic06,g_tic_flows[t].npq07,g_tic_flows[t].npq07f,g_tic[j].tic08,p_source) #No.FUN-B90062 add tic09 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("ins","tic_file","",p_no,SQLCA.sqlcode,"","ins tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF                
                       END IF               #MOD-BC0006 
                   END IF 
                   LET g_tic[j].tic07 = g_tic[j].tic07 - g_tic_flows[t].npq07 
                   LET g_tic[j].tic07f = g_tic[j].tic07f - g_tic_flows[t].npq07f
                   EXIT FOR    
                ELSE
                   IF j > 1 THEN 
                  #MOD-D80106--begin
                      LET l_flag = 'N'
                      FOR l_k =1 TO j-1
                         IF l_npq02 = g_tic_flows[t].npq02 AND g_tic[j].tic06 = g_tic[l_k].tic06
                            AND g_tic[j].tic08 = g_tic[l_k].tic08 THEN
                            LET l_flag='Y'
                         END IF
                      END FOR
                      IF l_flag = 'Y' THEN
                  #MOD-D80106--end
                     #IF l_npq02 = g_tic_flows[t].npq02 AND g_tic[j].tic06 = g_tic[j-1].tic06 #MOD-D80106 mark
                     #   AND g_tic[j].tic08 = g_tic[j-1].tic08 THEN                           #MOD-D80106 mark
                         UPDATE tic_file SET tic07 = tic07 + g_tic[j].tic07,tic07f = tic07f + g_tic[j].tic07f
                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
                            AND tic02 = l_tic02  AND tic04 = p_no                         
                            AND tic05 = g_tic_flows[t].npq02
                            AND tic06 = g_tic[j].tic06
                            AND tic08 = g_tic[j].tic08 
                         IF SQLCA.sqlcode OR sqlca.sqlerrd[3] = 0 THEN
                            CALL cl_err3("upd","tic_file","",p_no,SQLCA.sqlcode,"","upd tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF    
                      ELSE
                         INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)    #No.FUN-B90062   
                         VALUES (l_tic00,l_tic01,l_tic02,l_tic03,p_no,g_tic_flows[t].npq02,
                                 g_tic[j].tic06,g_tic[j].tic07,g_tic[j].tic07f,g_tic[j].tic08,p_source)              #No.FUN-B90062 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("ins","tic_file","",p_no,SQLCA.sqlcode,"","ins tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF 
                      END IF     
                   ELSE 
#FUN-BC0110 ADD BEGIN
                    	#紅沖時候,如果項次,現金變動碼,關係人一致則更新,不一致則插入
                        SELECT COUNT(*) INTO l_ct FROM tic_file
                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
                            AND tic02 = l_tic02  AND tic04 = p_no                         
                            AND tic05 = g_tic_flows[t].npq02
                            AND tic06 = g_tic[j].tic06
                            AND tic08 = g_tic[j].tic08                         	
                      IF l_ct >0   THEN
                         UPDATE tic_file SET tic07 = tic07 + g_tic_flows[t].npq07,
                                             tic07f = tic07f + g_tic_flows[t].npq07f 
                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
                            AND tic02 = l_tic02  AND tic04 = p_no                         
                            AND tic05 = g_tic_flows[t].npq02
                            AND tic06 = g_tic[j].tic06
                            AND tic08 = g_tic[j].tic08 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","tic_file","",p_no,SQLCA.sqlcode,"","upd tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF
                      ELSE       
#FUN-BC0110 ADD END                      
                         INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)        #No.FUN-B90062  
                         VALUES (l_tic00,l_tic01,l_tic02,l_tic03,p_no,g_tic_flows[t].npq02,
                              g_tic[j].tic06,g_tic[j].tic07,g_tic[j].tic07f,g_tic[j].tic08,p_source)                  #No.FUN-B90062  
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("ins","tic_file","",p_no,SQLCA.sqlcode,"","ins tic",1)
                            LET g_success = 'N'
                            EXIT FOREACH
                         END IF 
                      END IF #FUN-BC0110 ADD
                   END IF          
                   LET g_tic_flows[t].npq07 = g_tic_flows[t].npq07 - g_tic[j].tic07 
                   LET g_tic_flows[t].npq07f = g_tic_flows[t].npq07f - g_tic[j].tic07f
                   LET g_tic[j].tic07 = 0
                   LET g_tic[j].tic07f = 0
                   LET l_npq02 = g_tic_flows[t].npq02                
                END IF   
            END FOR
            LET t = t + 1
         END FOREACH 
     END IF    
 
 #FUN-BC0110 END ADD

         IF g_success = 'N' THEN
            RETURN
         END IF   
      END IF
      IF p_carry THEN RETURN END IF 
      
      DISPLAY l_tic00,l_tic01,l_tic02,l_tic03 TO tic00,tic01,tic02,tic03
      END IF 
   
   DECLARE s_fsgl_flows_c CURSOR FOR
    #SELECT tic04,tic05,tic06,tic08,tic07f,tic07  #mark by dengsy170212
      #FROM tic_file  #mark by dengsy170212 
    SELECT tic04,tic05,tic06,nml02,tic08,tic07f,tic07  #add by dengsy170212
      FROM tic_file LEFT OUTER JOIN nml_file ON nml01=tic06   #add by dengsy170212
     WHERE tic00 = l_tic00
       AND tic01 = l_tic01
       AND tic02 = l_tic02
       AND tic04 = p_no 
     ORDER BY tic04

   CALL g_tic.clear()

   LET i=1
   LET l_rec_b=0
   FOREACH s_fsgl_flows_c INTO g_tic[i].*
      IF STATUS THEN
         CALL cl_err('foreach tic',STATUS,0)
         EXIT FOREACH
      END IF
      
      LET i = i + 1
   END FOREACH
   CALL g_tic.deleteElement(i)
   LET l_rec_b = i - 1
 
   IF (l_n < 1 AND l_rec_b = 0) OR p_conf matches '[YyXx]' THEN  #mark by dengsy170221
      DISPLAY ARRAY g_tic TO s_tic.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            EXIT DISPLAY
      END DISPLAY
      CLOSE WINDOW s_flows     
      RETURN
   END IF
   
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET i = 1
   
   INPUT ARRAY g_tic WITHOUT DEFAULTS FROM s_tic.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
             INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,APPEND ROW = l_allow_insert)

      BEFORE INPUT
          IF l_rec_b != 0 THEN
             CALL fgl_set_arr_curr(i)
          END IF
#FUN-BC0110 BEGIN
          SELECT nmz70,nmz71,nmz72 INTO g_nmz.nmz70,g_nmz.nmz71,g_nmz.nmz72 FROM nmz_file
          IF g_nmz.nmz71 = 'Y' AND g_nmz.nmz70 ='2' AND g_nmz.nmz72 ='1' THEN 
             CALL cl_set_comp_required("tic06",TRUE)
          END IF
          IF g_nmz.nmz71 = 'Y' AND g_nmz.nmz70 ='2' AND g_nmz.nmz72 MATCHES '[23]' THEN
          	 CALL cl_set_comp_required("tic06",FALSE)
          END IF
#FUN-BC0110 END
      BEFORE ROW
         LET i = ARR_CURR()
         IF l_rec_b >= i THEN
            LET p_cmd='u'
            LET g_tic_t.* = g_tic[i].*                                                                                             
            BEGIN WORK                                                                                                               
            CALL cl_show_fld_cont()
         END IF 

      BEFORE INSERT 
         LET p_cmd='a'
         INITIALIZE g_tic[i].*  TO NULL 
         LET g_tic_t.* = g_tic[i].*
         LET g_tic[i].tic04 = p_no 
         CALL cl_show_fld_cont()
         NEXT FIELD tic05   

      AFTER FIELD tic05
         IF NOT cl_null(g_tic[i].tic05) THEN
            IF p_cmd='a' OR (p_cmd='u' AND g_tic[i].tic05<>g_tic_t.tic05) THEN
               LET l_n = 0
               IF p_source = '2' THEN 
                  SELECT COUNT(*) INTO l_n  FROM abb_file,aag_file
                   WHERE abb03 = aag01
                     AND abb00 = l_tic00                    
                     AND abb01 = p_no                     
                     AND aag00 = abb00                     
                     AND abb02 = g_tic[i].tic05
                     AND aag19 = '1'
               ELSE 
                  SELECT COUNT(*) INTO l_n  FROM npq_file,aag_file
                   WHERE npq03 = aag01 
                     AND npq01 = p_no                  
                     AND npqtype = p_npptype 
                     AND aag19 = '1'
                     AND npq02 = g_tic[i].tic05
                     AND aag00 = abb00              
               END IF 
                IF l_n < 1 THEN                  
                  CALL cl_err(g_tic[i].tic05,'aec-040',0)
                  LET g_tic[i].tic05 = g_tic_t.tic05
                  DISPLAY BY NAME g_tic[i].tic05
                  NEXT FIELD tic05 
               END IF
            END IF
            IF p_cmd='a' AND cl_null(g_tic_t.tic07) THEN
               SELECT SUM(tic07f) INTO l_sum1 FROM tic_file
                WHERE tic00 = l_tic00
                  AND tic01 = l_tic01
                  AND tic02 = l_tic02
                  AND tic04 = p_no                  
                  AND tic05 = g_tic[i].tic05
               IF cl_null(l_sum1) THEN
                  LET l_sum1 = 0
               END IF
               
               IF p_source ='2' THEN 
                  SELECT abb07f,abb25 INTO l_sum2,l_npq25  FROM abb_file
                   WHERE abb00 = p_bookno                   
                     AND abb01 = p_no1                     
                     AND abb02 = g_tic[i].tic05

               ELSE 
                  SELECT npq07f,npq25 INTO l_sum2,l_npq25 FROM npq_file
                   WHERE npq01 = p_no                  
                     AND npq02 = g_tic[i].tic05
                     AND npqtype = p_npptype
               END IF  
               IF cl_null(l_sum2) THEN
                  LET l_sum2 = 0
               END IF
                         
               IF l_sum2 >= l_sum1 THEN
                  LET g_tic[i].tic07f = l_sum2 - l_sum1
                  IF cl_null(l_npq25) THEN
                     LET g_tic[i].tic07 = g_tic[i].tic07f
                  ELSE
                     LET g_tic[i].tic07 = g_tic[i].tic07f * l_npq25
                  END IF
               ELSE
                  LET g_tic[i].tic07 = 0
                  LET g_tic[i].tic07f = 0
               END IF
            END IF 
            IF cl_null(l_npq25) THEN         
               IF p_source ='2' THEN 
                  SELECT abb25 INTO l_npq25  FROM abb_file
                   WHERE abb00 = p_bookno                   
                     AND abb01 = p_no                     
                     AND abb02 = g_tic[i].tic05

               ELSE 
                  SELECT npq25 INTO l_npq25 FROM npq_file
                   WHERE npq01 = p_no                  
                     AND npq02 = g_tic[i].tic05
                     AND npqtype = p_npptype
               END IF  
             END IF 
         END IF        

      AFTER FIELD tic06
#        IF NOT cl_null(g_tic[i].tic06) AND p_source = '3' THEN
         IF NOT cl_null(g_tic[i].tic06) THEN   #No.MOD-C50162 
            IF p_cmd='a' OR (p_cmd='u' AND g_tic[i].tic06<>g_tic_t.tic06) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n  FROM nml_file
                WHERE nmlacti = 'Y'
                  AND nml01 = g_tic[i].tic06
               IF l_n < 1 THEN
                  CALL cl_err(g_tic[i].tic06,'anm-140',0)
                  LET g_tic[i].tic06 = g_tic_t.tic06
                  DISPLAY BY NAME g_tic[i].tic06
                  NEXT FIELD tic06
               END IF
            END IF
         ELSE
            IF p_cmd='u' AND g_tic[i].tic06 = ' ' AND g_nmz.nmz72 = '1' THEN  #FUN-BC0110 add  AND g_nmz.nmz72 = '1'
               CALL cl_err(g_tic[i].tic06,'aim-927',0)
               NEXT FIELD tic06
            END IF
         END IF

      AFTER FIELD tic07
         IF NOT cl_null(g_tic[i].tic07) AND NOT cl_null(g_tic[i].tic05) THEN  
            LET l_sum1 = 0
            LET l_sum2 = 0
            SELECT SUM(tic07) INTO l_sum1 FROM tic_file
             WHERE tic00 = l_tic00
               AND tic01 = l_tic01
               AND tic02 = l_tic02
               AND tic04 = p_no               
               AND tic05 = g_tic[i].tic05
            IF cl_null(l_sum1) THEN
               LET l_sum1 = 0
            END IF
            IF cl_null(g_tic_t.tic07) THEN
               LET g_tic_t.tic07 = 0
            END IF         
            LET l_sum1 = l_sum1 + g_tic[i].tic07 - g_tic_t.tic07
            IF p_source ='2' THEN 
               SELECT abb07 INTO l_sum2 FROM abb_file
                WHERE abb00 = p_bookno                  
                  AND abb01 = p_no                  
                  AND abb02 = g_tic[i].tic05
            ELSE 
               SELECT npq07 INTO l_sum2 FROM npq_file
                WHERE npq01 = p_no               
                  AND npq02 = g_tic[i].tic05
                  AND npqtype = p_npptype
            END IF 
            IF l_sum2 < l_sum1 THEN
               CALL cl_err(l_tic05,'anm-607',0)
               NEXT FIELD tic07
            END IF  
         END IF 
         
      AFTER FIELD tic07f
        IF NOT cl_null(g_tic[i].tic07f) THEN           
           IF NOT cl_null(g_tic[i].tic05) THEN
              LET l_sum1 = 0
              LET l_sum2 = 0
              SELECT SUM(tic07f) INTO l_sum1 FROM tic_file
               WHERE tic00 = l_tic00
                 AND tic01 = l_tic01
                 AND tic02 = l_tic02
                 AND tic04 = p_no                 
                 AND tic05 = g_tic[i].tic05
              IF cl_null(l_sum1) THEN
                 LET l_sum1 = 0
              END IF
              IF cl_null(g_tic_t.tic07f) THEN
                 LET g_tic_t.tic07f = 0
              END IF
              LET l_sum1 = l_sum1 + g_tic[i].tic07f - g_tic_t.tic07f
              IF p_source ='2' THEN 
                 SELECT abb07f INTO l_sum2 FROM abb_file
                  WHERE abb00 = p_bookno                  
                    AND abb01 = p_no                  
                    AND abb02 = g_tic[i].tic05
              ELSE 
                 SELECT npq07f INTO l_sum2 FROM npq_file
                  WHERE npq01 = p_no               
                    AND npq02 = g_tic[i].tic05
                    AND npqtype = p_npptype
              END IF 
              IF l_sum2 < l_sum1 THEN
                 CALL cl_err(l_tic05,'anm-606',0)
                 NEXT FIELD tic07f
              END IF
           END IF
           IF NOT cl_null(l_npq25) AND (g_tic[i].tic07f <> g_tic_t.tic07f OR g_tic_t.tic07f IS NULL )THEN   
              LET g_tic[i].tic07 = g_tic[i].tic07f * l_npq25
              LET g_tic[i].tic07 = cl_digcut(g_tic[i].tic07,g_azi04)   
              DISPLAY BY NAME g_tic[i].tic07
           END IF  
        END IF

      BEFORE FIELD tic08
         LET l_npq03 = ''
         IF p_source ='2' THEN  
            SELECT abb03,aag371 INTO l_npq03,l_aag371 
              FROM abb_file,aag_file
             WHERE abb03 = aag01
               AND abb00 = p_bookno               
               AND abb01 = p_no               
               AND aag00 = abb00               
               AND abb02 = g_tic[i].tic05
               AND aag19 = 1
         ELSE 
            SELECT npq03,aag371 INTO l_npq03,l_aag371
              FROM npq_file,aag_file
             WHERE npq01 = g_tic[i].tic04
               AND npq02 = g_tic[i].tic05
               AND npqtype = p_npptype 
               AND npq03 = aag01
               AND aag00 = p_bookno 
               AND aag19 = 1
         END IF 
      AFTER FIELD tic08
         IF NOT cl_null(l_npq03) THEN            
            CALL s_chk_aee(l_npq03,'99',g_tic[i].tic08,p_bookno)  
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('sel aee:',g_errno,1)
               NEXT FIELD tic08
            END IF
         ELSE
            IF l_aag371 MATCHES '[234]' THEN
               CALL cl_err('','mfg0037',0)
               NEXT FIELD tic08
            END IF
         END IF    

      BEFORE DELETE
         IF NOT cl_null(g_tic_t.tic04) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF   
            IF cl_null(g_tic[i].tic08) THEN
               LET g_tic[i].tic08 = ' '
            END IF
            DELETE FROM tic_file 
             WHERE tic00 = l_tic00
               AND tic01 = l_tic01
               AND tic02 = l_tic02
               AND tic04 = g_tic_t.tic04
               AND tic05 = g_tic_t.tic05
               AND tic06 = g_tic_t.tic06
               AND tic08 = g_tic_t.tic08                                                                    
            IF SQLCA.sqlcode THEN                                                             
               CALL cl_err3("del","tic_file",'',"",SQLCA.sqlcode ,"","",1)                                                       
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            COMMIT WORK 
            LET l_rec_b = l_rec_b - 1  
         END IF                                                                                                                
    
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tic[i].* = g_tic_t.*
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF cl_null(g_tic[i].tic08) THEN
            LET g_tic[i].tic08 = ' '
         END IF
#FUN-BC0110 BEGIN
         IF cl_null(g_tic[i].tic06) THEN
            LET g_tic[i].tic06 = ' '
         END IF         
#FUN-BC0110 END
         UPDATE tic_file SET tic06 = g_tic[i].tic06,
                             tic07 = g_tic[i].tic07,
                             tic07f = g_tic[i].tic07f,    
                             tic08 = g_tic[i].tic08      
          WHERE tic00 = l_tic00
            AND tic01 = l_tic01
            AND tic02 = l_tic02
            AND tic04 = g_tic_t.tic04
            AND tic05 = g_tic_t.tic05
            AND tic06 = g_tic_t.tic06
            AND tic08 = g_tic_t.tic08
         IF SQLCA.sqlcode THEN
            CALL cl_err("upd tic_file",SQLCA.sqlcode,1)
            LET g_tic[i].* = g_tic_t.*
            ROLLBACK WORK
         ELSE
            COMMIT WORK  
         END IF
         
      AFTER INSERT                                                                                                                   
         IF INT_FLAG THEN                                                                                                            
            CALL cl_err('',9001,0)                                                                                                   
            LET INT_FLAG = 0                                                                                                       
            CANCEL INSERT                                                                                                            
          END IF 
          IF cl_null(g_tic[i].tic08) THEN
             LET g_tic[i].tic08 = ' '
          END IF
          INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)   #No.FUN-B90062 add tic09  
          VALUES(l_tic00,l_tic01,l_tic02,l_tic03,g_tic[i].tic04,g_tic[i].tic05,
                 g_tic[i].tic06,g_tic[i].tic07,g_tic[i].tic07f,g_tic[i].tic08,p_source)              #No.FUN-B90062 add tic09  
          IF SQLCA.sqlcode THEN                                                                                                      
             CALL cl_err3("ins","tic_file",g_tic[i].tic05,"",SQLCA.sqlcode,"","",1)                                                  
             CANCEL INSERT                                                                                                         
          ELSE
             LET l_rec_b = l_rec_b + 1 
          END IF   

      AFTER ROW
         LET i = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tic[i].* = g_tic_t.*
            ROLLBACK WORK
            EXIT INPUT
         END IF         
         COMMIT WORK 
          
      AFTER INPUT
         #TQC-C60077--add--str--
         IF g_nmz.nmz71 = 'Y' THEN
            #IF g_nmz.nmz70 = '2' AND g_nmz.nmz72 = '1' THEN    #TQC-C60103--mark
            IF (g_nmz.nmz70 = '2' AND g_nmz.nmz72 = '1') OR (g_nmz.nmz70 = '3' AND g_nmz.nmz72 = '1') THEN     #TQC-C60103  add
               SELECT COUNT(*) INTO l_n FROM tic_file
                WHERE tic00 = l_tic00
                  AND tic01 = l_tic01
                  AND tic02 = l_tic02
                  AND tic03 = l_tic03
                  AND tic04 = g_tic_t.tic04
               IF l_n = 0 THEN
                  CALL cl_err('','axr-278',1)
                  NEXT FIELD tic06
               END IF
            END IF
         END IF
         #TQC-C60077--add--end--

         FOR j = 1 TO l_rec_b
            #IF cl_null(g_tic[j].tic06) OR g_tic[j].tic06 = ' ' THEN
            IF (cl_null(g_tic[j].tic06) OR g_tic[j].tic06 = ' ') AND g_nmz.nmz72 = '1' THEN  #FUN-BC0110 add   AND g_nmz.nmz72 = '1'
               LET i = j
               CALL cl_err(g_tic[j].tic06,'aim-927',0)
               CALL fgl_set_arr_curr(i) 
               NEXT FIELD tic06
            END IF   
         END FOR
         COMMIT WORK

      ON ACTION controlp
         CASE 
            WHEN INFIELD(tic06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nml"
               CALL cl_create_qry() RETURNING g_tic[i].tic06
               DISPLAY BY NAME g_tic[i].tic06
               NEXT FIELD tic06
            WHEN INFIELD(tic08)    #關係人
               CALL s_ahe_qry(l_npq03,'99','i',g_tic[i].tic08,p_bookno)
               RETURNING g_tic[i].tic08
               DISPLAY g_tic[i].tic08 TO tic08
               NEXT FIELD tic08   
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

   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      CLOSE WINDOW s_flows      
      RETURN
   END IF
   
   CLOSE WINDOW s_flows   
   RETURN 
END FUNCTION
FUNCTION s_chktic(p_bookno,p_no) 
DEFINE p_bookno   LIKE aba_file.aba00
DEFINE p_no       LIKE aba_file.aba01 
DEFINE l_n        LIKE type_file.num5 
#No.TQC-B80059 --begin
DEFINE l_sum1     LIKE abb_file.abb07f 
DEFINE l_sum2     LIKE abb_file.abb07f 
#No.TQC-B80059 --end

#   SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file   #FUN-BC0110  MARK
#   IF g_nmz.nmz70 <> '2' THEN RETURN TRUE END IF #FUN-BC0110  MARK
#FUN-BC0110 BEGIN
   SELECT nmz70,nmz71,nmz72 INTO g_nmz.nmz70,g_nmz.nmz71,g_nmz.nmz72 FROM nmz_file 
   IF g_nmz.nmz71 = 'N'  THEN RETURN TRUE END IF #不啟用現金流量錶功能FUN-BC0110 add
   IF g_nmz.nmz71 = 'Y' AND g_nmz.nmz70 <> '2' THEN RETURN TRUE END IF 
#FUN-BC0110 END

   LET l_n =0 
   SELECT COUNT(*) INTO l_n FROM abb_file,aag_file 
    WHERE abb01 = p_no 
      AND abb00 = p_bookno 
      AND abb03 = aag01 
      AND aag00 = abb00
      AND aag19 = '1'  

   IF l_n >0 AND g_nmz.nmz70 = '2' THEN   
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM tic_file WHERE tic04 = p_no AND tic00 = p_bookno AND (tic06 IS NULL OR tic06 = ' ') 
      IF l_n > 0 THEN 
#         CALL cl_err('','agl-444','0')   #FUN-BC0110  MARK
#         RETURN FALSE                    #FUN-BC0110  MARK
# FUN-BC0110  BEGIN
         IF g_nmz.nmz72 = '1' OR g_nmz.nmz72 = '2' THEN 
               #CALL cl_err('','agl-444','0')  #現金變動碼為空 #TQC-C10105 mark
               #TQC-C10105 add begin
               IF g_nmz.nmz72 = '1' THEN 
                  CALL cl_err('','agl-444','0') 
               END IF  
               IF g_nmz.nmz72 = '2' THEN 
                  CALL cl_err('','agl-448','0') 
               END IF
               #TQC-C10105 add end
               IF g_nmz.nmz72 = '1' THEN 
                     RETURN FALSE 
                  ELSE 
                     RETURN TRUE 
                END IF 
         END IF       
# FUN-BC0110  END
      END IF
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM tic_file WHERE tic04 = p_no AND tic00 = p_bookno       
#No.TQC-B80059 --begin
     #SELECT SUM(abb07f) INTO l_sum1 FROM abb_file,aag_file    #MOD-BC0285 mark
      SELECT SUM(abb07) INTO l_sum1 FROM abb_file,aag_file     #MOD-BC0285 add
       WHERE abb03 = aag01
         AND abb00 = p_bookno            
         AND abb01 = p_no            
         AND aag00 = abb00            
         AND abb06 = '1'
         AND aag19 = 1
     #SELECT SUM(abb07f) INTO l_sum2 FROM abb_file,aag_file     #MOD-BC0285 mark
      SELECT SUM(abb07) INTO l_sum2 FROM abb_file,aag_file      #MOD-BC0285 add
       WHERE abb03 = aag01
         AND abb00 = p_bookno            
         AND abb01 = p_no            
         AND aag00 = abb00            
         AND abb06 = '2'
         AND aag19 = 1
      IF cl_null(l_sum1) THEN LET l_sum1 =0 END IF
      IF cl_null(l_sum2) THEN LET l_sum2 =0 END IF
      IF l_n = 0 AND (l_sum1 - l_sum2) <> 0 THEN 
#No.TQC-B80059 --end
         #CALL cl_err('','agl-445','0')    #TQC-C60090  mark
         #RETURN FALSE                     #TQC-C60090  mark

         #TQC-C60098--add--str--
         IF g_nmz.nmz70 ='2' AND g_nmz.nmz72 = '1' THEN 
            CALL cl_err('','agl-445','0')
            RETURN FALSE 
         END IF 
         #TQC-C60098--add--end--         

         #TQC-C60090--add--str--
         IF g_nmz.nmz70 ='2' AND g_nmz.nmz72 = '2' THEN 
            CALL cl_err('','agl-448','0')
         END IF 
         #TQC-C60090--add--end--
      END IF
   END IF  
   RETURN TRUE 
END FUNCTION 


