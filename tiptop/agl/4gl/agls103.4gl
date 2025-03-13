# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: agls103.4gl
# Descriptions...: 總帳會計系統參數(五)設定作業–傳票輸入
# Date & Author..: 92/02/17 By MAY
# Modify.........: 92/10/30 By Roger 
# Modify.........: 96/06/17 By Melody 
# Modify.........: 新增aaz64、拿掉aaz86、加入 before field aaz74 之判斷
# Modify.........: No:MOD-4C0096 04/12/15 By Nicola 在FUNCTION s103_aaz31(p_code)中的 CASE WHEN SQLCA.SQLERRD[3]=0 LET g_errno='agl-001'應改為判斷STATUS=100
# Modify.........: No:FUN-580064 05/08/12 By Dido 新增合併財報參數項目-兌換損益科目(aaz86)及換算調整數科目(aaz87)維護
# Modify.........: NO.FUN-570097 05/08/26 By ice 大陸版aaz33不控管agl-213
# Modify.........: No:FUN-580088 05/08/26 By Carrier 修改大陸版時aaz31/aaz32/aaz33的title
# Modify.........: No.FUN-580096 05/08/26 By Carrier aza26='2'時隱藏aaz82 
# Modify.........: No.FUN-5C0015 05/12/07 BY GILL 增加aaz88欄位(科目使用異動碼數)
# Modify.........: No.FUN-650079 06/06/15 By rainy 維護科目使用異動碼數>01時新增訊息 : 輸入值應界於 0-1
# Modify.........: No:FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No:FUN-670032 06/07/11 By kim GP3.5 利潤中心
# Modify.........: No:FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No:FUN-670032 06/07/11 By kim 利潤中心會計科目 在程式一開始的時候,應該先判斷如果aza90沒打勾的話,不強制輸入
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No:FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No:FUN-730070 07/04/02 By Carrier 會計科目加帳套-財務
# Modify.........: No:FUN-740032 07/04/13 By Carrier 帳套和aza81時,也可以pass
# Modify.........: No:FUN-770086 06/07/25 By kim 合併報表新增功能
# Modify.........: No:TQC-790077 07/09/12 By Carrier aaz65/aaz68 做有效性控管 & 動態開窗調整
# Modify.........: No:FUN-830139 08/04/10 By bnlent 異動碼改為只能輸入0-8(9/10改為專案使用) 
# Modify.........: No:TQC-860012 08/11/12 By jan 增加"科目設置規則"欄位 
# Modify.........: No:FUN-890071 08/11/26 By Sarah aaz104欄位設為No Use
# Modify.........: No:FUN-890072 08/12/30 By jamie 增加azz109 azz110
# Modify.........: No:FUN-910001 09/05/19 By lutingting由11區追單, "合并報表"頁簽增加aaz641(合并報表帳別)欄位 
# Modify.........: No:FUN-920021 09/05/19 By lutingting由11區追單, "合并報表"移至agls101新增報表
# Modify.........: No.FUN-A50058 10/05/19 By wujie 增加a119叁数 
# Modify.........: No.FUN-A50092 10/06/02 By wujie 增加a115叁数 
# Modify.........: No.TQC-A80119 10/08/20 By xiaofeizhu aaz65,aaz68開窗調整
# Modify.........: No:FUN-9B0017 10/08/23 By chenmoyan 部門別信息合併財報中揭露,用異動碼功能來表達營運部門(如:產業別,區域別)
# Modify.........: No:FUN-A30048 10/09/01 By chenmoyan 異動碼5-8碼為空,其對應管制也應為空
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50105 11/05/20 By zhangweib azz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No.TQC-B60068 11/06/15 By lixiang  增加單別碼數的控管
# Modify.........: No.FUN-B70002 11/06/29 By zhangweib 在一般設置頁簽加入aaz126和aaz127
# Modify.........: No.FUN-B50039 11/07/07 By xianghui 增加自訂欄位
# Modify.........: No.FUN-B80098 11/08/11 By yinhy 增加aaz116憑證錄入時自動彈窗參數
# Modify.........: No.FUN-BC0027 11/12/08 By lilingyu aaz31~aaz33改為no user
# Modify.........: No.MOD-C10163 12/01/18 By Polly 增加 DISPLAY BY NAME aaz126/aaz127
# Modify.........: No.TQC-C40138 12/04/17 By lujh run 程式，報錯提示“-391 無法將null插入'欄-名稱'”
# Modify.........: No.FUN-CB0119 13/01/08 By wangrr 9主機追單到30

DATABASE ds

GLOBALS "../../config/top.global"
    DEFINE
        g_aaz_t         RECORD LIKE aaz_file.*,  # 預留參數檔
        g_aaz_o         RECORD LIKE aaz_file.*,  # 預留參數檔
        l_aaa           RECORD LIKE aaa_file.*   # 預留參數檔
DEFINE g_forupd_sql STRING                       #SELECT ... FOR UPDATE SQL    
DEFINE g_msg      LIKE type_file.chr1000         #No.FUN-580088       #No.FUN-680098 char(300)  

MAIN
   OPTIONS 
      INPUT NO WRAP
   DEFER INTERRUPT 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   OPEN WINDOW s103_w WITH FORM "agl/42f/agls103"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
   CALL cl_ui_init()

#FUN-BC0027 --begin--
#   IF g_aza.aza26 = '2' THEN                                                    
#      CALL cl_getmsg('agl-350',g_lang) RETURNING g_msg                          
#      CALL cl_set_comp_att_text("aaz31",g_msg CLIPPED)                          
#      CALL cl_getmsg('agl-351',g_lang) RETURNING g_msg                          
#      CALL cl_set_comp_att_text("aaz32",g_msg CLIPPED)                          
#      CALL cl_getmsg('agl-352',g_lang) RETURNING g_msg                          
#      CALL cl_set_comp_att_text("aaz33",g_msg CLIPPED)                          
#   END IF                                                                       
#   #No.FUN-580088  --end 
#FUN-BC0027 --end--

  CALL cl_set_comp_visible("aaz31,aaz32,aaz33",FALSE)   #FUN-BC0027

   #No.FUN-580096  --begin                                                      
   CALL cl_set_comp_visible("aaz82",g_aza.aza26<>'2')                           
   IF cl_null(g_aaz.aaz82) THEN LET g_aaz.aaz82='N' END IF                      
   #No.FUN-580096  --end 
   CALL cl_set_comp_required("aaz91,aaz92",g_aaz.aaz90='Y') #CHI-690065
#FUN-9B0017   ---START
   CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231,aaz124,ahe02_4,aaz1241",FALSE)
   CASE
#     WHEN g_aaz.aaz88 <=4                                                                                                              #FUN-B50105  Mark
#        CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231,aaz124,ahe02_4,aaz1241",FALSE)  #FUN-B500105 Mark
      WHEN g_aaz.aaz125 <=5      #FUN-B50105 aaz88  -->  aaz125
         CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211",TRUE)                
      WHEN g_aaz.aaz125 <=6      #FUN-B50105 aaz88  -->  aaz125
         CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221",TRUE)
      WHEN g_aaz.aaz125 <=7      #FUN-B50105 aaz88  -->  aaz125
         CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231",TRUE)
      OTHERWISE
         CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231,aaz124,ahe02_4,aaz1241",TRUE)
  END CASE
#FUN-9B0017   ---END
   CALL s103_show()

      LET g_action_choice=""
   CALL s103_menu()

   CLOSE WINDOW s103_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN    

FUNCTION s103_show()
#FUN-9B0017   ---start
DEFINE l_ahe02_1 LIKE ahe_file.ahe02
DEFINE l_ahe02_2 LIKE ahe_file.ahe02
DEFINE l_ahe02_3 LIKE ahe_file.ahe02
DEFINE l_ahe02_4 LIKE ahe_file.ahe02
#FUN-9B0017   ---end

   SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00 = '0'

#FUN-9B0017 --Begin
   IF cl_null(g_aaz.aaz121)  THEN LET g_aaz.aaz121=' '  END IF
   IF cl_null(g_aaz.aaz1211) THEN LET g_aaz.aaz1211=' ' END IF
   IF cl_null(g_aaz.aaz122)  THEN LET g_aaz.aaz122=' '  END IF
   IF cl_null(g_aaz.aaz1221) THEN LET g_aaz.aaz1221=' ' END IF
   IF cl_null(g_aaz.aaz123)  THEN LET g_aaz.aaz123=' '  END IF
   IF cl_null(g_aaz.aaz1231) THEN LET g_aaz.aaz1231=' ' END IF
   IF cl_null(g_aaz.aaz124)  THEN LET g_aaz.aaz124=' '  END IF
   IF cl_null(g_aaz.aaz1241) THEN LET g_aaz.aaz1241=' ' END IF
   IF cl_null(g_aaz.aaz116)  THEN LET g_aaz.aaz116 = 'N' END IF    #TQC-C40138   add
   IF cl_null(g_aaz.aaz132)  THEN LET g_aaz.aaz132 = 'N' END IF    #FUN-CB0119   add
#FUN-9B0017 --End
   IF SQLCA.sqlcode THEN
      INSERT INTO aaz_file(aaz00,aaz64,aaz69,aaz70,aaz71,aaz78,aaz80,aaz81,
#                          aaz51,aaz83,aaz85,aaz84,aaz31,aaz32,aaz33,aaz61,   #FUN-BC0027
                           aaz51,aaz83,aaz85,aaz84,aaz61,                     #FUN-BC0027
                           aaz62,aaz63,aaz65,aaz68,aaz77,aaz82,aaz72,       #FUN-920021 mark   #FUN-580064
                           aaz87,aaz88,aaz119,aaz115,aaz116,aaz132,aaz90,aaz91,aaz92,aaz107,aaz108   #FUN-920021 mark   #No.FUN-5C0015 #FUN-670032  FUN-A50058 add aaz119  FUN-A50092 add aaz115 #FUN-B80098 add aaz116 #FUN-CB0119 add--aaz132
                          #aaz62,aaz63,aaz65,aaz68,aaz77,aaz82,aaz72,aaz86, #FUN-920021 mark # FUN-580064                           
                          #aaz87,aaz88,aaz90,aaz91,aaz92,                   #FUN-920021 mark #No.FUN-5C0015 #FUN-670032
                          #aaz100,aaz101,aaz102,aaz103,aaz104,aaz107,aaz108 #FUN-770086 #TQC-860012   #FUN-890071 mark
                          #aaz100,aaz101,aaz102,aaz103,aaz107,aaz108,aaz109,aaz110,aaz641 #FUN-920021 mark   #FUN-890072 add aaz109 aaz110  #FUN-770086 #TQC-860012          #FUN-890071  #FUN-910001 add azz641 
                          ,aaz121,aaz1211,aaz122,aaz1221,aaz123,aaz1231,aaz124,aaz1241      #FUN-9B0017
                          ,aaz125       #FUN-B50105 Add
                          ,aaz126,aaz127    #FUN-B70002   Add
                           )
           VALUES ('0', g_aaz.aaz64,g_aaz.aaz69,g_aaz.aaz70,g_aaz.aaz71,
                   g_aaz.aaz78,g_aaz.aaz80,g_aaz.aaz81,g_aaz.aaz51,g_aaz.aaz83,
                   g_aaz.aaz85,g_aaz.aaz84,
#                  g_aaz.aaz31,g_aaz.aaz32,g_aaz.aaz33,                 #FUN-BC0027
                   g_aaz.aaz61,g_aaz.aaz62,g_aaz.aaz63,g_aaz.aaz65,g_aaz.aaz68,
                   g_aaz.aaz77,g_aaz.aaz82,g_aaz.aaz72,                           #FUN-920021 mark g_aaz.aaz86,g_aaz.aaz87,# FUN-580064 
                   g_aaz.aaz88,g_aaz.aaz119,g_aaz.aaz115,g_aaz.aaz116,g_aaz.aaz90,g_aaz.aaz91,g_aaz.aaz92,g_aaz.aaz107,g_aaz.aaz108               #FUN-920021 mod  #FUN-5C0015 #FUN-670032       FUN-A50058 add aaz119 FUN-A50092 add aaz115 #FUN-B80098 add aaz116
                  ,g_aaz.aaz121,' ',g_aaz.aaz122,' ',g_aaz.aaz123,' ',g_aaz.aaz124,' '                                   #FUN-9B0017 add
                  ,g_aaz.aaz125         #FUN-B50105 Add
                  ,g_aaz.aaz126,g_aaz.aaz127   #FUN-B70002   Add
                  )
                  #g_aaz.aaz88,g_aaz.aaz90,g_aaz.aaz91,g_aaz.aaz92,               #FUN-920021 mark #FUN-5C0015 #FUN-670032 
                  #g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,g_aaz.aaz104,g_aaz.aaz107,g_aaz.aaz108)               #FUN-770086  #TQC-860012   #FUN-890071 mark
                  #g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,g_aaz.aaz107,g_aaz.aaz108,g_aaz.aaz109,g_aaz.aaz110,g_aaz.aaz641)  #FUN-920021 mark

#FUN-890072 add aaz109 aaz110 #FUN-770086#TQC-860012                #FUN-890071  #FUN-910001 add azz641 
   ELSE
      UPDATE aaz_file SET aaz64 = g_aaz.aaz64,
                          aaz69 = g_aaz.aaz69,
                          aaz70 = g_aaz.aaz70,
                          aaz71 = g_aaz.aaz71,
                          aaz78 = g_aaz.aaz78,
                          aaz80 = g_aaz.aaz80,
                          aaz81 = g_aaz.aaz81,
                          aaz51 = g_aaz.aaz51,
                          aaz83 = g_aaz.aaz83,
                          aaz84 = g_aaz.aaz84,
#FUN-BC0027 --begin--
#                         aaz31 = g_aaz.aaz31,
#                         aaz32 = g_aaz.aaz32,
#                         aaz33 = g_aaz.aaz33,
#FUN-BC0027 --end--
                          aaz61 = g_aaz.aaz61,
                          aaz62 = g_aaz.aaz62,
                          aaz63 = g_aaz.aaz63,
                          aaz65 = g_aaz.aaz65,
                          aaz68 = g_aaz.aaz68,
                          aaz77 = g_aaz.aaz77,
                          aaz82 = g_aaz.aaz82,
                          aaz72 = g_aaz.aaz72, 
                          #aaz86 = g_aaz.aaz86, #FUN-920021 mark #FUN-580064
                          #aaz87 = g_aaz.aaz87, #FUN-920021 mark #FUN-580064
                          aaz88 = g_aaz.aaz88,  #FUN-5C0015
                          aaz125 = g_aaz.aaz125,  #FUN-B50105
                          aaz119= g_aaz.aaz119, #No.FUN-A50058
                          aaz115= g_aaz.aaz115, #No.FUN-A50092
                          aaz116= g_aaz.aaz116, #No.FUN-B80098
                          aaz132= g_aaz.aaz132, #FUN-CB0119
                          aaz90 = g_aaz.aaz90,  #FUN-670032
                          aaz91 = g_aaz.aaz91,  #FUN-670032
                          aaz92 = g_aaz.aaz92,  #FUN-670032
                          #aaz100= g_aaz.aaz100, #FUN-920021 mark #FUN-770086
                          #aaz101= g_aaz.aaz101, #FUN-920021 mark #FUN-770086
                          #aaz102= g_aaz.aaz102, #FUN-920021 mark #FUN-770086
                          #aaz103= g_aaz.aaz103, #FUN-920021 mark #FUN-770086
                          ##aaz104= g_aaz.aaz104,#FUN-920021 mark #FUN-770086   #FUN-890071 mark
                          aaz107= g_aaz.aaz107,   #TQC-860012
                          aaz126 = g_aaz.aaz126,  #FUN-B70002   Add
                          aaz127 = g_aaz.aaz127,  #FUN-B70002   Add
                          aaz108= g_aaz.aaz108 #TQC-860012
                         ,aaz121= g_aaz.aaz121, #FUN-9B0017
                          aaz1211=g_aaz.aaz1211,#FUN-9B0017
                          aaz122= g_aaz.aaz122, #FUN-9B0017
                          aaz1221=g_aaz.aaz1221,#FUN-9B0017
                          aaz123= g_aaz.aaz123, #FUN-9B0017
                          aaz1231=g_aaz.aaz1231,#FUN-9B0017
                          aaz124= g_aaz.aaz124, #FUN-9B0017
                          aaz1241=g_aaz.aaz1241 #FUN-9B0017
                          #aaz109= g_aaz.aaz109, #FUN-890072 add
                          #aaz110= g_aaz.aaz110, #FUN-920021 mark   #FUN-890072 add
                          #,aaz641= g_aaz.aaz641 #FUN-920021 mark  #FUN-910001 add 
       WHERE aaz00 = '0'
   END IF

   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF

   DISPLAY BY NAME g_aaz.aaz64,g_aaz.aaz69,g_aaz.aaz71,g_aaz.aaz81,g_aaz.aaz78,
                   g_aaz.aaz80,g_aaz.aaz51,g_aaz.aaz83,g_aaz.aaz85,g_aaz.aaz84,
#                  g_aaz.aaz31,g_aaz.aaz32,g_aaz.aaz33,           #FUN-BC0027
                   g_aaz.aaz61,g_aaz.aaz62,
                   g_aaz.aaz63,g_aaz.aaz65,g_aaz.aaz68,g_aaz.aaz77,g_aaz.aaz82,
                   g_aaz.aaz72,       #FUN-920021 mark g_aaz.aaz86,g_aaz.aaz87, # FUN-580064 
                   g_aaz.aaz88,       # FUN-5C0015
                   g_aaz.aaz125,      #FUN-B50105 Add
                   g_aaz.aaz119,      #No.FUN-A50058
                   g_aaz.aaz115,      #No.FUN-A50092
                   g_aaz.aaz116,      #No.FUN-B80098
                   g_aaz.aaz132,      #FUN-CB0119
                   g_aaz.aaz90,g_aaz.aaz91,g_aaz.aaz92, #FUN-920021 mod #FUN-670032 
                  #g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,g_aaz.aaz104, #FUN-770086   #FUN-890071 mark
                  #g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,#FUN-920021 mark  #FUN-770086                #FUN-890071
                   g_aaz.aaz107,g_aaz.aaz108,
                  #,g_aaz.aaz109,g_aaz.aaz110  #FUN-890072 add #TQC-860012        #FUN-920021 mark
                  #,g_aaz.aaz641   #FUN-910001 add                                #FUN-920021 mark
                   g_aaz.aaz121,g_aaz.aaz1211,g_aaz.aaz122,g_aaz.aaz1221,         #FUN-9B0017
                   g_aaz.aaz123,g_aaz.aaz1231,g_aaz.aaz124,g_aaz.aaz1241,         #FUN-9B0017
                  #FUN-B50039-add-str--
                   g_aaz.aazud01,g_aaz.aazud02,g_aaz.aazud03,g_aaz.aazud04,g_aaz.aazud05,
                   g_aaz.aazud06,g_aaz.aazud07,g_aaz.aazud08,g_aaz.aazud09,g_aaz.aazud10,
                   g_aaz.aazud11,g_aaz.aazud12,g_aaz.aazud13,g_aaz.aazud14,g_aaz.aazud15,
                  #FUN-B50039-add-end--
                   g_aaz.aaz126,g_aaz.aaz127                                          #MOD-C10163 add                  

   #FUN-9B0017   ---start
    CALL s103_ahe02(g_aaz.aaz121) RETURNING l_ahe02_1
    CALL s103_ahe02(g_aaz.aaz122) RETURNING l_ahe02_2
    CALL s103_ahe02(g_aaz.aaz123) RETURNING l_ahe02_3
    CALL s103_ahe02(g_aaz.aaz124) RETURNING l_ahe02_4
    DISPLAY l_ahe02_1 TO ahe02_1
    DISPLAY l_ahe02_2 TO ahe02_2
    DISPLAY l_ahe02_3 TO ahe02_3
    DISPLAY l_ahe02_4 TO ahe02_4
   #FUN-9B0017   ---end
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION s103_menu()

   MENU ""
   ON ACTION modify 
      LET g_action_choice = "modify"
      IF cl_chk_act_auth() THEN
         CALL s103_u()
      END IF
   ON ACTION help
      CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#          EXIT MENU

   ON ACTION exit
           LET g_action_choice = "exit"
      EXIT MENU

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU

   END MENU

END FUNCTION

FUNCTION s103_u()

   CALL cl_opmsg('u')
   MESSAGE ""

   LET g_forupd_sql = "SELECT * FROM aaz_file WHERE aaz00 = '0' FOR UPDATE"    
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE aaz_curl CURSOR FROM g_forupd_sql

   BEGIN WORK
   OPEN aaz_curl 
   IF STATUS THEN
      CALL cl_err('OPEN aaz_curl',STATUS,1)
      RETURN
   END IF         

   FETCH aaz_curl INTO g_aaz.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF

   LET g_aaz_t.* = g_aaz.*
   LET g_aaz_o.* = g_aaz.*

   DISPLAY BY NAME g_aaz.aaz64,g_aaz.aaz69,g_aaz.aaz71,g_aaz.aaz81,g_aaz.aaz78,
                   g_aaz.aaz80,g_aaz.aaz51,g_aaz.aaz83,g_aaz.aaz85,g_aaz.aaz84,
#                  g_aaz.aaz31,g_aaz.aaz32,g_aaz.aaz33,          #FUN-BC0027
                   g_aaz.aaz61,g_aaz.aaz62,
                   g_aaz.aaz63,g_aaz.aaz65,g_aaz.aaz68,g_aaz.aaz77,g_aaz.aaz82,
                   g_aaz.aaz72,                          #FUN-920021 mark g_aaz.aaz86,g_aaz.aaz87,  # FUN-580064
                   g_aaz.aaz88,# FUN-5C0015
                   g_aaz.aaz125, #FUN-B50105  Add
                   g_aaz.aaz119,  #No.FUN-A50058
                   g_aaz.aaz115,  #No.FUN-A50092
                   g_aaz.aaz116,  #No.FUN-B80098
                   g_aaz.aaz132,  #FUN-CB0119
                   g_aaz.aaz90,g_aaz.aaz91,g_aaz.aaz92, #FUN-670032
                  #g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,g_aaz.aaz104, #FUN-770086   #FUN-890071 mark
                  # g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103, #FUN-920021 mark #FUN-770086                #FUN-890071
                   g_aaz.aaz107,g_aaz.aaz108  #TQC-860012
                  # g_aaz.aaz109,g_aaz.aaz110  #FUN-920021 mark  #FUN-890072 add
                  # ,g_aaz.aaz641  #FUN-920021 mark  #FUN-910001 add
                  ,g_aaz.aaz121,g_aaz.aaz1211,g_aaz.aaz122,g_aaz.aaz1221 #FUN-9B0017
                  ,g_aaz.aaz123,g_aaz.aaz1231,g_aaz.aaz124,g_aaz.aaz1241 #FUN-9B0017
                  ,g_aaz.aaz126,g_aaz.aaz127,  #FUN-B70002   Add
                  #FUN-B50039-add-str--
                  g_aaz.aazud01,g_aaz.aazud02,g_aaz.aazud03,g_aaz.aazud04,g_aaz.aazud05,
                  g_aaz.aazud06,g_aaz.aazud07,g_aaz.aazud08,g_aaz.aazud09,g_aaz.aazud10,
                  g_aaz.aazud11,g_aaz.aazud12,g_aaz.aazud13,g_aaz.aazud14,g_aaz.aazud15
                  #FUN-B50039-add-end--

   WHILE TRUE
      CALL s103_i()

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_aaz.* = g_aaz_t.*
         CALL s103_show()
         EXIT WHILE
      END IF

#FUN-9B0017 --Begin
      IF cl_null(g_aaz.aaz121)  THEN LET g_aaz.aaz121=' '  END IF
      IF cl_null(g_aaz.aaz1211) THEN LET g_aaz.aaz1211=' ' END IF
      IF cl_null(g_aaz.aaz122)  THEN LET g_aaz.aaz122=' '  END IF
      IF cl_null(g_aaz.aaz1221) THEN LET g_aaz.aaz1221=' ' END IF
      IF cl_null(g_aaz.aaz123)  THEN LET g_aaz.aaz123=' '  END IF
      IF cl_null(g_aaz.aaz1231) THEN LET g_aaz.aaz1231=' ' END IF
      IF cl_null(g_aaz.aaz124)  THEN LET g_aaz.aaz124=' '  END IF
      IF cl_null(g_aaz.aaz1241) THEN LET g_aaz.aaz1241=' ' END IF
      IF cl_null(g_aaz.aaz116)  THEN LET g_aaz.aaz116 = 'N' END IF    #TQC-C40138   add
#FUN-9B0017 --End
      UPDATE aaz_file SET aaz64 = g_aaz.aaz64,
                          aaz69 = g_aaz.aaz69,
                          aaz71 = g_aaz.aaz71,
                          aaz78 = g_aaz.aaz78,
                          aaz80 = g_aaz.aaz80,
                          aaz81 = g_aaz.aaz81,
                          aaz51 = g_aaz.aaz51,
                          aaz83 = g_aaz.aaz83,
                          aaz85 = g_aaz.aaz85,
                          aaz84 = g_aaz.aaz84,
#FUN-BC0027 --begin--
#                         aaz31 = g_aaz.aaz31,
#                         aaz32 = g_aaz.aaz32,
#                         aaz33 = g_aaz.aaz33,
#FUN-BC0027 --end--
                          aaz61 = g_aaz.aaz61,
                          aaz62 = g_aaz.aaz62,
                          aaz63 = g_aaz.aaz63,
                          aaz65 = g_aaz.aaz65,
                          aaz68 = g_aaz.aaz68,
                          aaz77 = g_aaz.aaz77,
                          aaz82 = g_aaz.aaz82,
                          aaz72 = g_aaz.aaz72, 
                          #aaz86 = g_aaz.aaz86, #FUN-580064  #FUN-920021 mark
                          #aaz87 = g_aaz.aaz87, #FUN-580064  #FUN-920021 mark
                          aaz88 = g_aaz.aaz88, #FUN-5C0015
                          aaz125 = g_aaz.aaz125, #FUN-B50105  Add
                          aaz126 = g_aaz.aaz126, #FUN-B50143  Add
                          aaz127 = g_aaz.aaz127, #FUN-B50143  Add
                          aaz119= g_aaz.aaz119,  #No.FUN-A50058
                          aaz115= g_aaz.aaz115,  #No.FUN-A50092
                          aaz116= g_aaz.aaz116,  #No.FUN-B80098
                          aaz132= g_aaz.aaz132,  #FUN-CB0119
                          aaz90 = g_aaz.aaz90, #FUN-670032
                          aaz91 = g_aaz.aaz91, #FUN-670032
                          aaz92 = g_aaz.aaz92,  #FUN-670032
                          #aaz100= g_aaz.aaz100, #FUN-770086 #FUN-920021 mark
                          #aaz101= g_aaz.aaz101, #FUN-770086 #FUN-920021 mark
                          #aaz102= g_aaz.aaz102, #FUN-770086 #FUN-920021 mark
                          #aaz103= g_aaz.aaz103, #FUN-770086 #FUN-920021 mark
                          ##aaz104= g_aaz.aaz104, #FUN-770086   #FUN-890071 mark  #FUN-920021 mark
                          aaz107= g_aaz.aaz107, #TQC-860012
                          aaz108= g_aaz.aaz108 #TQC-860012
                          #aaz109= g_aaz.aaz109, #FUN-890072 add  #FUN-920021 mark
                          #aaz110= g_aaz.aaz110  #FUN-890072 add  #FUN-920021 mark
                          #,aaz641= g_aaz.aaz641    #FUN-920021 mark   #FUN-910001 add  #FUN-920021 mark
                         ,aaz121= g_aaz.aaz121, #FUN-9B0017
                          aaz1211=g_aaz.aaz1211,#FUN-9B0017
                          aaz122= g_aaz.aaz122, #FUN-9B0017
                          aaz1221=g_aaz.aaz1221,#FUN-9B0017
                          aaz123= g_aaz.aaz123, #FUN-9B0017
                          aaz1231=g_aaz.aaz1231,#FUN-9B0017
                          aaz124= g_aaz.aaz124, #FUN-9B0017
                          aaz1241=g_aaz.aaz1241,#FUN-9B0017
                          #FUN-B50039-add-str--
                          aazud01=g_aaz.aazud01,
                          aazud02=g_aaz.aazud02,
                          aazud03=g_aaz.aazud03,
                          aazud04=g_aaz.aazud04,
                          aazud05=g_aaz.aazud05,
                          aazud06=g_aaz.aazud06,
                          aazud07=g_aaz.aazud07,
                          aazud08=g_aaz.aazud08,
                          aazud09=g_aaz.aazud09,
                          aazud10=g_aaz.aazud10,
                          aazud11=g_aaz.aazud11,
                          aazud12=g_aaz.aazud12,
                          aazud13=g_aaz.aazud13,
                          aazud14=g_aaz.aazud14,
                          aazud15=g_aaz.aazud15
                          #FUN-B50039-add-end--
           
       WHERE aaz00='0'

      IF SQLCA.sqlcode THEN
#        CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","aaz_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660123
         CONTINUE WHILE
      END IF

      CLOSE aaz_curl
      COMMIT WORK
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION s103_i()
   DEFINE l_aza LIKE type_file.chr1,         #No.FUN-680098  char(1)
          l_cmd LIKE type_file.chr50         #No.FUN-680098  char(50)
   DEFINE li_chk_bookno  LIKE type_file.num5     #No.FUN-670005     #No.FUN-680098   smallint
   DEFINE l_abc LIKE type_file.chr7          #TQC-A80119 Add
#FUN-9B0017   ---start
   DEFINE l_ahe02_1 LIKE ahe_file.ahe02
   DEFINE l_ahe02_2 LIKE ahe_file.ahe02
   DEFINE l_ahe02_3 LIKE ahe_file.ahe02
   DEFINE l_ahe02_4 LIKE ahe_file.ahe02
   DEFINE l_flag    LIKE type_file.chr1
#FUN-9B0017   ---end
   DEFINE l_aaz     STRING,                   #No.TQC-B60068
          l_n       LIKE type_file.num5,      #No.TQC-B60068
          l_i       LIKE type_file.num5       #No.TQC-B60068
   DEFINE l_aaz126  LIKE aaz_file.aaz126      #FUN-B70002   Add
   DEFINE l_aaz127  LIKE aaz_file.aaz127      #FUN-B70002   Add

#FUN-A30048 --Begin
IF cl_null(g_aaz.aaz121) THEN LET g_aaz.aaz1211='' END IF
IF cl_null(g_aaz.aaz122) THEN LET g_aaz.aaz1221='' END IF
IF cl_null(g_aaz.aaz123) THEN LET g_aaz.aaz1231='' END IF
IF cl_null(g_aaz.aaz124) THEN LET g_aaz.aaz1241='' END IF
#FUN-A30048 --End
   
   INPUT BY NAME g_aaz.aaz64,g_aaz.aaz69,g_aaz.aaz72,g_aaz.aaz77,g_aaz.aaz85,
                 g_aaz.aaz84,g_aaz.aaz71,g_aaz.aaz81,g_aaz.aaz78,g_aaz.aaz82,
                 g_aaz.aaz80,g_aaz.aaz51,g_aaz.aaz83,
                #g_aaz.aaz88,#No.FUN-5C0015 #FUN-9B0017 mark
                 g_aaz.aaz119,    #No.FUN-A50058
                 g_aaz.aaz115,    #No.FUN-A50092
                 g_aaz.aaz116,    #No.FUN-B80098
                 g_aaz.aaz132,    #FUN-CB0119
#                g_aaz.aaz31,g_aaz.aaz32,g_aaz.aaz33,  #FUN-BC0027
                 g_aaz.aaz65,g_aaz.aaz68,g_aaz.aaz126,g_aaz.aaz127,g_aaz.aaz107,g_aaz.aaz108,g_aaz.aaz61,g_aaz.aaz62,#TQC-860012   #FUN-B70002   Add aaz126 aaz127
                 g_aaz.aaz63,       #FUN-920021 mark  g_aaz.aaz641,g_aaz.aaz86,g_aaz.aaz87, #FUN-580064   #FUN-910001 add aaz641 
                #g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,g_aaz.aaz104, #FUN-770086   #FUN-890071 mark
                #g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,                            #FUN-890072 mark #FUN-770086                #FUN-890071
                # g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz109,g_aaz.aaz110,g_aaz.aaz102,g_aaz.aaz103, #FUN-920021 MARK #FUN-890072 mod  #FUN-770086                #FUN-890071
                 g_aaz.aaz90,g_aaz.aaz91,g_aaz.aaz92    #FUN-670032 
                ,g_aaz.aaz88,#FUN-9B0017
                 g_aaz.aaz125,  #FUN-B50105  Add
                 g_aaz.aaz121,g_aaz.aaz1211,g_aaz.aaz122,g_aaz.aaz1221,#FUN-9B0017
                 g_aaz.aaz123,g_aaz.aaz1231,g_aaz.aaz124,g_aaz.aaz1241,#FUN-9B0017
                 #FUN-B50039-add-str--
                 g_aaz.aazud01,g_aaz.aazud02,g_aaz.aazud03,g_aaz.aazud04,g_aaz.aazud05,
                 g_aaz.aazud06,g_aaz.aazud07,g_aaz.aazud08,g_aaz.aazud09,g_aaz.aazud10,
                 g_aaz.aazud11,g_aaz.aazud12,g_aaz.aazud13,g_aaz.aazud14,g_aaz.aazud15 
                 #FUN-B50039-add-end--
      WITHOUT DEFAULTS 

     #TQC-860012--BEGIN--
      BEFORE INPUT
       CALL cl_set_comp_entry("aaz108",TRUE)
       CALL cl_set_doctype_format("aaz65")      #No.TQC-B60068
       CALL cl_set_doctype_format("aaz68")      #No.TQC-B60068

     #TQC-860012--END--
      AFTER FIELD aaz64
         IF NOT cl_null(g_aaz.aaz64) THEN
            #No.FUN-670005--begin
             CALL s_check_bookno(g_aaz.aaz64,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD aaz64 
             END IF 
            #No.FUN-670005--end  
            SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_aaz.aaz64
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aaz.aaz64,'agl-043',0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",g_aaz.aaz64,"","agl-043","","",0)   #No.FUN-660123
               NEXT FIELD aaz64
            END IF
            #No.FUN-730070  --Begin
            IF g_aaz.aaz64 <> g_aza.aza81 THEN
               CALL cl_err(g_aaz.aaz64,"axc-531",1)
#              NEXT FIELD aaz64  #No.FUN-740032
            END IF
            #No.FUN-730070  --End  
         END IF 
      
      AFTER FIELD aaz69
         IF NOT cl_null(g_aaz.aaz69) THEN 
            IF g_aaz.aaz69 NOT MATCHES '[YyNn]' THEN
               LET g_aaz.aaz69=g_aaz_o.aaz69
               DISPLAY BY NAME g_aaz.aaz69
               NEXT FIELD aaz69
            END IF
            LET g_aaz_o.aaz69=g_aaz.aaz69
         END IF
      
      AFTER FIELD aaz71
         IF NOT cl_null(g_aaz.aaz71) THEN 
            IF g_aaz.aaz71 NOT MATCHES '[12]' THEN
               LET g_aaz.aaz71=g_aaz_o.aaz71
               DISPLAY BY NAME g_aaz.aaz71
               NEXT FIELD aaz71
            END IF
            LET g_aaz_o.aaz71=g_aaz.aaz71
         END IF
      
      AFTER FIELD aaz81
         IF NOT cl_null(g_aaz.aaz81) THEN
            IF g_aaz.aaz81 NOT MATCHES '[YyNn]' THEN
               LET g_aaz.aaz81=g_aaz_o.aaz81
               DISPLAY BY NAME g_aaz.aaz81
               NEXT FIELD aaz81
            END IF
            LET g_aaz_o.aaz81=g_aaz.aaz81
         END IF
      
      AFTER FIELD aaz78
         IF NOT cl_null(g_aaz.aaz78) THEN
            IF g_aaz.aaz78 NOT MATCHES '[YyNn]' THEN
               LET g_aaz.aaz78=g_aaz_o.aaz78
               DISPLAY BY NAME g_aaz.aaz78
               NEXT FIELD aaz78
            END IF
            LET g_aaz_o.aaz78=g_aaz.aaz78
         END IF
      
      AFTER FIELD aaz80
         IF NOT cl_null(g_aaz.aaz80) THEN 
            IF g_aaz.aaz80 NOT MATCHES '[YyNn]' THEN
               LET g_aaz.aaz80=g_aaz_o.aaz80
               DISPLAY BY NAME g_aaz.aaz80
               NEXT FIELD aaz80
            END IF
            LET g_aaz_o.aaz80=g_aaz.aaz80
         END IF
      
      AFTER FIELD aaz51
         IF NOT cl_null(g_aaz.aaz51) THEN 
            IF g_aaz.aaz51 NOT MATCHES '[YyNn]' THEN
               LET g_aaz.aaz51=g_aaz_o.aaz51
               DISPLAY BY NAME g_aaz.aaz51
               NEXT FIELD aaz51
            END IF
            LET g_aaz_o.aaz51=g_aaz.aaz51
         END IF
      
      AFTER FIELD aaz83
         IF NOT cl_null(g_aaz.aaz83) THEN
            IF g_aaz.aaz83 NOT MATCHES '[YyNn]' THEN
               LET g_aaz.aaz83=g_aaz_o.aaz83
               DISPLAY BY NAME g_aaz.aaz83
               NEXT FIELD aaz83
            END IF
            LET g_aaz_o.aaz83=g_aaz.aaz83
         END IF
       
      #FUN-5C0015 --begin
      AFTER FIELD aaz88
         IF NOT cl_null(g_aaz.aaz88) THEN
            IF g_aaz.aaz88 > 4 OR g_aaz.aaz88 < 0 THEN    #No.FUN-830139 10 -> 8   #FUN-B50105   8 --> 4
               LET g_aaz.aaz88 = g_aaz_o.aaz88
               #數值必須介於0 - 8 之間!                   #No.FUN-830139 10 -> 8
               #CALL cl_err('','agl-019',1) #No.FUN-650079 remark
               #CALL cl_err('','agl-067',1)  #No.FUN-650079  #FUN-B50105  Mark
               CALL cl_err('','agl-332',1)  #No.FUN-B50105
               NEXT FIELD aaz88
            END IF
            LET g_aaz_o.aaz88 = g_aaz.aaz88
#FUN-B50105   ---start  Mark
##FUN-9B0017   ---START
#           CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231,aaz124,ahe02_4,aaz1241",FALSE)
#           CASE
#              WHEN g_aaz.aaz88 <=4
#                 CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231,aaz124,ahe02_4,aaz1241",FALSE)
#              WHEN g_aaz.aaz88 <=5
#                 CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211",TRUE)                
#              WHEN g_aaz.aaz88 <=6
#                 CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221",TRUE)
#              WHEN g_aaz.aaz88 <=7
#                 CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231",TRUE)
#              OTHERWISE
#                 CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231,aaz124,ahe02_4,aaz1241",TRUE)
#          END CASE
##FUN-9B0017   ---END
#FUN-B50105   ---end    Mark
         END IF
      #FUN-5C0015 --end
#FUN-B50105   ---start   Add
      AFTER FIELD aaz125
         IF NOT cl_null(g_aaz.aaz125) THEN
            IF g_aaz.aaz125 > 8 OR g_aaz.aaz125 < 5 THEN
               LET g_aaz.aaz125 = g_aaz_o.aaz125
               CALL cl_err('','agl-333',1)
               NEXT FIELD aaz125
            END IF
            LET g_aaz_o.aaz125 = g_aaz.aaz125
            CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231,aaz124,ahe02_4,aaz1241",FALSE)
            CASE
               WHEN g_aaz.aaz125 <=5
                  CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211",TRUE)
               WHEN g_aaz.aaz125 <=6
                  CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221",TRUE)
               WHEN g_aaz.aaz125 <=7
                  CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231",TRUE)
               OTHERWISE
                  CALL cl_set_comp_visible("aaz121,ahe02_1,aaz1211,aaz122,ahe02_2,aaz1221,aaz123,ahe02_3,aaz1231,aaz124,ahe02_4,aaz1241",TRUE)
           END CASE
         END IF
#FUN-B50105   ---end     Add
#No.FUN-A50058 --begin                                                          
      AFTER FIELD aaz119                                                        
         IF NOT cl_null(g_aaz.aaz119) THEN                                      
            IF g_aaz.aaz119 NOT MATCHES '[YyNn]' THEN                           
               LET g_aaz.aaz119=g_aaz_o.aaz119                                  
               DISPLAY BY NAME g_aaz.aaz119                                     
               NEXT FIELD aaz119                                                
            END IF                                                              
            LET g_aaz_o.aaz119=g_aaz.aaz119                                     
         END IF                                                                 
#No.FUN-A50058 --end
#No.FUN-A50092 --begin                                                          
      AFTER FIELD aaz115                                                        
         IF NOT cl_null(g_aaz.aaz115) THEN                                      
            IF g_aaz.aaz115 NOT MATCHES '[YyNn]' THEN                           
               LET g_aaz.aaz115=g_aaz_o.aaz115                                  
               DISPLAY BY NAME g_aaz.aaz115                                     
               NEXT FIELD aaz115                                                
            END IF                                                              
            LET g_aaz_o.aaz115=g_aaz.aaz115                                     
         END IF                                                                 
#No.FUN-A50092 --end
#No.FUN-B80098  --Begin
      AFTER FIELD aaz116                                                        
         IF NOT cl_null(g_aaz.aaz116) THEN                                      
            IF g_aaz.aaz116 NOT MATCHES '[YyNn]' THEN                           
               LET g_aaz.aaz116=g_aaz_o.aaz116                                  
               DISPLAY BY NAME g_aaz.aaz116                                     
               NEXT FIELD aaz116                                                
            END IF                                                              
            LET g_aaz_o.aaz116=g_aaz.aaz116                                     
         END IF                                                                 
#No.FUN-B80098  --End
#FUN-CB0119----add---str
         AFTER FIELD aaz132                                                       
         IF NOT cl_null(g_aaz.aaz132) THEN                                      
            IF g_aaz.aaz132 NOT MATCHES '[YyNn]' THEN                           
               LET g_aaz.aaz132=g_aaz_o.aaz132                                 
               DISPLAY BY NAME g_aaz.aaz132                                     
               NEXT FIELD aaz132                                               
            END IF                                                              
            LET g_aaz_o.aaz132=g_aaz.aaz132                                    
         END IF                

#FUN-CB0119----add----end  
      AFTER FIELD aaz85
         IF NOT cl_null(g_aaz.aaz85) THEN 
            IF g_aaz.aaz85 NOT MATCHES '[YN]' THEN
               LET g_aaz.aaz85=g_aaz_o.aaz85
               DISPLAY BY NAME g_aaz.aaz85
               NEXT FIELD aaz85
            END IF
            LET g_aaz_o.aaz85=g_aaz.aaz85
         END IF
      
      AFTER FIELD aaz84
         IF NOT cl_null(g_aaz.aaz84) THEN 
            IF g_aaz.aaz84 NOT MATCHES '[12]' THEN
               LET g_aaz.aaz84=g_aaz_o.aaz84
               DISPLAY BY NAME g_aaz.aaz84
               NEXT FIELD aaz84
            END IF
            LET g_aaz_o.aaz84=g_aaz.aaz84
         END IF
#FUN-9B0017   ---start
      AFTER FIELD aaz121                                                                                                           
         IF NOT cl_null(g_aaz.aaz121) THEN                                                                                   
            CALL s103_chk_ahe(g_aaz.aaz121)                                                                                 
            IF g_errno THEN                                                                                                       
               NEXT FIELD aaz121                                                                                                   
            END IF                                                                                                                
         END IF                                                                                                                   
         LET l_ahe02_1 = NULL                                                                                           
         CALL s103_ahe02(g_aaz.aaz121)                                                                                      
              RETURNING l_ahe02_1                                                                                       
         DISPLAY l_ahe02_1 TO ahe02_1      

      AFTER FIELD aaz122                                                                                                           
         IF NOT cl_null(g_aaz.aaz122) THEN                                                                                   
            CALL s103_chk_ahe(g_aaz.aaz122)                                                                                 
            IF g_errno THEN                                                                                                       
               NEXT FIELD aaz122                                                                                                   
            END IF                                                                                                                
         END IF                                                                                                                   
         LET l_ahe02_2 = NULL                                                                                           
         CALL s103_ahe02(g_aaz.aaz122)                                                                                      
              RETURNING l_ahe02_2                                                                                       
         DISPLAY l_ahe02_2 TO ahe02_2  

      AFTER FIELD aaz123                                                                                                           
         IF NOT cl_null(g_aaz.aaz123) THEN                                                                                   
            CALL s103_chk_ahe(g_aaz.aaz123)                                                                                 
            IF g_errno THEN                                                                                                       
               NEXT FIELD aaz123                                                                                                   
            END IF                                                                                                                
         END IF                                                                                                                   
         LET l_ahe02_3 = NULL                                                                                           
         CALL s103_ahe02(g_aaz.aaz123)                                                                                      
              RETURNING l_ahe02_3                                                                                       
         DISPLAY l_ahe02_3 TO ahe02_3  
     
      AFTER FIELD aaz124                                                                                                           
         IF NOT cl_null(g_aaz.aaz124) THEN                                                                                   
            CALL s103_chk_ahe(g_aaz.aaz124)                                                                                 
            IF g_errno THEN                                                                                                       
               NEXT FIELD aaz124                                                                                                   
            END IF                                                                                                                
         END IF                                                                                                                   
         LET l_ahe02_4 = NULL                                                                                           
         CALL s103_ahe02(g_aaz.aaz124)                                                                                      
              RETURNING l_ahe02_4                                                                                       
         DISPLAY l_ahe02_4 TO ahe02_4     

      AFTER FIELD aaz1211                                                                                                          
         IF NOT cl_null(g_aaz.aaz1211) THEN                                                                                  
            IF g_aaz.aaz1211 NOT MATCHES'[123]' THEN                                                                         
               NEXT FIELD aaz1211                                                                                                  
            END IF                                                                                                                
            IF g_aaz.aaz1211 = '3' THEN                                                                                      
               CALL s103_chk_field(g_aaz.aaz121) RETURNING l_flag                                                           
               IF l_flag THEN                                                                                                     
                  CALL cl_err(g_aaz.aaz121,'agl-170',0)                                                                      
                  NEXT FIELD aaz1211                                                                                               
               END IF                                                                                                             
            END IF  
            IF NOT cl_null(g_aaz.aaz1211) THEN                                                                                         
               IF cl_null(g_aaz.aaz121) THEN                                                                                           
                 #異動碼輸入控制若有值,則異動碼類型代號也要有值!
                  CALL cl_err('','agl-029',1)                                                                                          
                  NEXT FIELD aaz121                                                                                                    
               END IF                                                                                                                  
            END IF                                                                                                                      
         END IF                               

      AFTER FIELD aaz1221                                                                                                          
         IF NOT cl_null(g_aaz.aaz1221) THEN                                                                                  
            IF g_aaz.aaz1221 NOT MATCHES'[123]' THEN                                                                         
               NEXT FIELD aaz1221                                                                                                  
            END IF                                                                                                                
            IF g_aaz.aaz1221 = '3' THEN                                                                                      
               CALL s103_chk_field(g_aaz.aaz122) RETURNING l_flag                                                           
               IF l_flag THEN                                                                                                     
                  CALL cl_err(g_aaz.aaz122,'agl-170',0)                                                                      
                  NEXT FIELD aaz1221                                                                                               
               END IF                                                                                                             
            END IF                                                                                                                
            IF NOT cl_null(g_aaz.aaz1221) THEN                                                                                         
               IF cl_null(g_aaz.aaz122) THEN                                                                                           
                 #異動碼輸入控制若有值,則異動碼類型代號也要有值!
                  CALL cl_err('','agl-029',1)                                                                                          
                  NEXT FIELD aaz122                                                                                                    
               END IF                                                                                                                  
            END IF        
         END IF                                                                                                                   
                               
      AFTER FIELD aaz1231                                                                                                          
         IF NOT cl_null(g_aaz.aaz1231) THEN                                                                                  
            IF g_aaz.aaz1231 NOT MATCHES'[123]' THEN                                                                         
               NEXT FIELD aaz1231                                                                                                  
            END IF                                                                                                                
            IF g_aaz.aaz1231 = '3' THEN                                                                                      
               CALL s103_chk_field(g_aaz.aaz123) RETURNING l_flag                                                           
               IF l_flag THEN                                                                                                     
                  CALL cl_err(g_aaz.aaz123,'agl-170',0)                                                                      
                  NEXT FIELD aaz1231                                                                                               
               END IF                                                                                                             
            END IF                 
            IF NOT cl_null(g_aaz.aaz1231) THEN                                                                                         
               IF cl_null(g_aaz.aaz123) THEN                                                                                           
                 #異動碼輸入控制若有值,則異動碼類型代號也要有值!
                  CALL cl_err('','agl-029',1)                                                                                          
                  NEXT FIELD aaz123                                                                                                    
               END IF                                                                                                                  
            END IF                                                                                                       
         END IF               

      AFTER FIELD aaz1241                                                                                                          
         IF NOT cl_null(g_aaz.aaz1241) THEN                                                                                  
            IF g_aaz.aaz1241 NOT MATCHES'[123]' THEN                                                                         
               NEXT FIELD aaz1241                                                                                                  
            END IF                                                                                                                
            IF g_aaz.aaz1241 = '3' THEN                                                                                      
               CALL s103_chk_field(g_aaz.aaz124) RETURNING l_flag                                                           
               IF l_flag THEN                                                                                                     
                  CALL cl_err(g_aaz.aaz124,'agl-170',0)                                                                      
                  NEXT FIELD aaz1241                                                                                               
               END IF                                                                                                             
            END IF   
            IF NOT cl_null(g_aaz.aaz1241) THEN                                                                                         
               IF cl_null(g_aaz.aaz124) THEN                                                                                           
                 #異動碼輸入控制若有值,則異動碼類型代號也要有值!
                  CALL cl_err('','agl-029',1)                                                                                          
                  NEXT FIELD aaz124                                                                                                    
               END IF                                                                                                                  
            END IF                                                                                                                     
         END IF                                                                                                                   
#FUN-9B0017   ---end
      
#FUN-BC0027 --begin--
#      AFTER FIELD aaz31 
#         IF NOT cl_null(g_aaz.aaz31) THEN 
#            CALL s103_aaz31(g_aaz.aaz31,g_aza.aza81)  #No.FUN-730070
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err('',g_errno,0)
#               #Add No.FUN-B10048
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_aag"
#               LET g_qryparam.construct = 'N'
#               LET g_qryparam.default1 = g_aaz.aaz31
#               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
#               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 != '2' AND aag01 LIKE '",g_aaz.aaz31 CLIPPED,"%'"
#               CALL cl_create_qry() RETURNING g_aaz.aaz31
#               DISPLAY BY NAME g_aaz.aaz31
#               #End Add No.FUN-B10048
#               NEXT FIELD aaz31
#            END IF
#            IF NOT cl_null(g_aaz.aaz32) THEN
#                IF g_aaz.aaz31 = g_aaz.aaz32 THEN
#                    LET g_errno = 'agl-183' #本期損益(損益類)/(資產類)/累計盈虧,此三個會計科目不可重覆
#                END IF
#            END IF
#            IF NOT cl_null(g_aaz.aaz33) THEN
#                IF g_aaz.aaz31 = g_aaz.aaz33 THEN
#                    LET g_errno = 'agl-183'
#                END IF
#            END IF
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err('',g_errno,0)
#               NEXT FIELD aaz31
#            END IF
#         END IF
#     
#      AFTER FIELD aaz32 
#         IF NOT cl_null(g_aaz.aaz32) THEN 
#            CALL s103_aaz31(g_aaz.aaz32,g_aza.aza81)  #No.FUN-730070
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err('',g_errno,0)
#               #Add No.FUN-B10048
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_aag"
#               LET g_qryparam.construct = 'N'
#               LET g_qryparam.default1 = g_aaz.aaz32
#               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
#               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 != '2' AND aag01 LIKE '",g_aaz.aaz32 CLIPPED,"%'"
#               CALL cl_create_qry() RETURNING g_aaz.aaz32
#               DISPLAY BY NAME g_aaz.aaz32
#               #End Add No.FUN-B10048
#               NEXT FIELD aaz32
#            END IF
#            IF NOT cl_null(g_aaz.aaz31) THEN
#                IF g_aaz.aaz32 = g_aaz.aaz31 THEN
#                    LET g_errno = 'agl-183' #本期損益(損益類)/(資產類)/累計盈虧,此三個會計科目不可重覆
#                END IF
#            END IF
#            IF NOT cl_null(g_aaz.aaz33) THEN
#                IF g_aaz.aaz32 = g_aaz.aaz33 THEN
#                    LET g_errno = 'agl-183'
#                END IF
#            END IF
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err('',g_errno,0)
#               NEXT FIELD aaz32
#            END IF
#         END IF
#     
#      AFTER FIELD aaz33 
#         IF NOT cl_null(g_aaz.aaz33) THEN 
#            CALL s103_aaz31(g_aaz.aaz33,g_aza.aza81)  #No.FUN-730070
#            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
#               CALL cl_err('',g_errno,0)
#               #Add No.FUN-B10048
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_aag"
#               LET g_qryparam.construct = 'N'
#               LET g_qryparam.default1 = g_aaz.aaz33
#               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
#               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 != '2' AND aag01 LIKE '",g_aaz.aaz33 CLIPPED,"%'"
#               CALL cl_create_qry() RETURNING g_aaz.aaz33
#               DISPLAY BY NAME g_aaz.aaz33
#               #End Add No.FUN-B10048
#               NEXT FIELD aaz33
#            END IF
#            IF NOT cl_null(g_aaz.aaz31) THEN
#                IF g_aaz.aaz33 = g_aaz.aaz31 THEN
#                    LET g_errno = 'agl-183' #本期損益(損益類)/(資產類)/累計盈虧,此三個會計科目不可重覆
#                END IF
#            END IF
#            IF NOT cl_null(g_aaz.aaz32) THEN
#                IF g_aaz.aaz33 = g_aaz.aaz32 THEN
#                    LET g_errno = 'agl-183'
#                END IF
#            END IF
#            IF g_aza.aza26 != '2' OR g_errno != 'agl-213' THEN  #No:FUN-570097
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err('',g_errno,0)
#                  NEXT FIELD aaz33
#               END IF
#            END IF        #No:FUN-570097
#         END IF
#FUN-BC0027 --END--

      AFTER FIELD aaz65
         IF NOT cl_null(g_aaz.aaz65) THEN
            #No.TQC-790077  --Begin
            CALL s103_check_slip_no(g_aaz.aaz65,'1')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aaz.aaz65,g_errno,0)
               LET g_aaz.aaz65=g_aaz_t.aaz65
               DISPLAY BY NAME g_aaz.aaz65
               NEXT FIELD aaz65
            END IF
            #No.TQC-790077  --End 
            #No.TQC-B60068--add--
            LET l_aaz=g_aaz.aaz65
            LET l_n=l_aaz.getlength()
            IF l_n=g_doc_len THEN
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(g_aaz.aaz65[l_i,l_i]) THEN
                     CALL cl_err(g_aaz.aaz65,'sub-146',0)
                     LET g_aaz.aaz65=g_aaz_o.aaz65 
                     NEXT FIELD aaz65 
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_aaz.aaz65,'sub-146',0)
               LET g_aaz.aaz65=g_aaz_o.aaz65 
               NEXT FIELD aaz65 
            END IF
            #No.TQC-B60068--end-- 
         END IF
         LET g_aaz_o.aaz65=g_aaz.aaz65
     
      AFTER FIELD aaz68
         IF NOT cl_null(g_aaz.aaz68) THEN
            #No.TQC-790077  --Begin
            CALL s103_check_slip_no(g_aaz.aaz68,'2')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aaz.aaz68,g_errno,0)
               LET g_aaz.aaz68 = g_aaz_t.aaz68
               NEXT FIELD aaz68
            END IF
            #No.TQC-790077  --End 
            #No.TQC-B60068--add--
            LET l_aaz=g_aaz.aaz68
            LET l_n=l_aaz.getlength()
            IF l_n=g_doc_len THEN
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(g_aaz.aaz68[l_i,l_i]) THEN
                     CALL cl_err(g_aaz.aaz68,'sub-146',0)
                     LET g_aaz.aaz68=g_aaz_o.aaz68
                     NEXT FIELD aaz68
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_aaz.aaz68,'sub-146',0)
               LET g_aaz.aaz68=g_aaz_o.aaz68
               NEXT FIELD aaz68
            END IF
            #No.TQC-B60068--end-- 
         END IF
         LET g_aaz_o.aaz68=g_aaz.aaz68
     
#FUN-B70002   ---start   Add
      AFTER FIELD aaz126
         IF NOT cl_null(g_aaz.aaz126) then
            LET l_aaz126 = g_aaz.aaz126,'   '
            LET l_aaz126 = l_aaz126[1,g_doc_len]
            CALL cl_chk_str_correct(l_aaz126,1,g_doc_len) RETURNING g_errno
            IF NOT g_errno THEN
               CALL cl_err(g_aaz.aaz126,'sub-146',0)
               NEXT FIELD aaz126
            END IF
            SELECT COUNT(*) INTO l_n FROM aac_file
             WHERE aac01 = g_aaz.aaz126
               AND aac03 = '0'
               AND aac11 = '1'
            IF l_n < 1 THEN
               CALL cl_err(g_aaz.aaz126,'sub-203',0)
               LET g_aaz.aaz126 = g_aaz_o.aaz126
               DISPLAY BY NAME g_aaz.aaz126
               NEXT FIELD aaz126
            END IF
            FOR l_i = 1 TO g_doc_len
               IF cl_null(g_aaz.aaz126[l_i,l_i]) THEN
                  CALL cl_err('','sub-146',0)
                  LET g_aaz.aaz126 = g_aaz_o.aaz126
                  NEXT FIELD aaz126
               END IF
            END FOR
         END IF

      AFTER FIELD aaz127
         IF NOT cl_null(g_aaz.aaz127) then
            LET l_aaz127 = g_aaz.aaz127,'   '
            LET l_aaz127 = l_aaz127[1,g_doc_len]
            CALL cl_chk_str_correct(l_aaz127,1,g_doc_len) RETURNING g_errno
            IF NOT g_errno THEN
               CALL cl_err(g_aaz.aaz127,'sub-146',0)
               NEXT FIELD aaz127
            END IF
            SELECT COUNT(*) INTO l_n FROM aac_file
             WHERE aac01 = g_aaz.aaz127
               AND aac03 = '0'
               AND aac11 = '1'
            IF l_n < 1 THEN
               CALL cl_err(g_aaz.aaz127,'sub-203',0)
               LET g_aaz.aaz127 = g_aaz_o.aaz127
               DISPLAY BY NAME g_aaz.aaz127
               NEXT FIELD aaz127
            END IF
            FOR l_i = 1 TO g_doc_len
               IF cl_null(g_aaz.aaz127[l_i,l_i]) THEN
                  CALL cl_err('','sub-146',0)
                  LET g_aaz.aaz127 = g_aaz_o.aaz127
                  NEXT FIELD aaz127
               END IF
            END FOR
         END IF
#FUN-B70002   ---end     Add

      AFTER FIELD aaz77
         IF NOT cl_null(g_aaz.aaz77) THEN 
            IF g_aaz.aaz77 NOT MATCHES '[YyNn]' THEN
               LET g_aaz.aaz77=g_aaz_o.aaz77
               DISPLAY BY NAME g_aaz.aaz77
               NEXT FIELD aaz77
            END IF 
         END IF
         LET g_aaz_o.aaz77=g_aaz.aaz77
     
      AFTER FIELD aaz82
         IF NOT cl_null(g_aaz.aaz82) THEN 
            IF g_aaz.aaz82 NOT MATCHES '[YyNn]' THEN
               LET g_aaz.aaz82=g_aaz_o.aaz82
               DISPLAY BY NAME g_aaz.aaz82
               NEXT FIELD aaz82
            END IF
         END IF
         LET g_aaz_o.aaz82=g_aaz.aaz82
     
      AFTER FIELD aaz72
         IF NOT cl_null(g_aaz.aaz72) THEN 
            IF g_aaz.aaz72 NOT MATCHES '[12]' THEN
               LET g_aaz.aaz72=g_aaz_o.aaz72
               DISPLAY BY NAME g_aaz.aaz72
               NEXT FIELD aaz72
            END IF
         END IF
         LET g_aaz_o.aaz72=g_aaz.aaz72
    
    #FUN-920021---mark--str--- 
    ##str FUN-910001 add                                                                                                            
    # AFTER FIELD aaz641                                                                                                            
    #    IF NOT cl_null(g_aaz.aaz641) THEN                                                                                          
    #       CALL s_check_bookno(g_aaz.aaz641,g_user,g_plant)                                                                        
    #            RETURNING li_chk_bookno                                                                                            
    #       IF (NOT li_chk_bookno) THEN                                                                                             
    #             NEXT FIELD aaz641                                                                                                  
    #       END IF                                                                                                                  
    #       SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_aaz.aaz641                                                          
    #       IF SQLCA.sqlcode THEN                                                                                                   
    #          CALL cl_err3("sel","aaa_file",g_aaz.aaz641,"","agl-043","","",0)   #No.FUN-660123                                    
    #          NEXT FIELD aaz641                                                                                                    
    #       END IF                                                                                                                  
    #    END IF                                                                                                                     
    ##end FUN-910001 add 

## FUN-580064
    #  AFTER FIELD aaz86
    #     IF NOT cl_null(g_aaz.aaz86) THEN 
    #        CALL s103_aaz31(g_aaz.aaz86,g_aza.aza81)  #No.FUN-7300070
    #        IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
    #           CALL cl_err('',g_errno,0)
    #           NEXT FIELD aaz86
    #        END IF
    #     END IF

    #  AFTER FIELD aaz87
    #     IF NOT cl_null(g_aaz.aaz87) THEN 
    #        CALL s103_aaz31(g_aaz.aaz87,g_aza.aza81)  #No.FUN-7300070
    #        IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
    #           CALL cl_err('',g_errno,0)
    #           NEXT FIELD aaz87
    #        END IF
    #     END IF
## FUN-580064 End

    #  #FUN-770086...............begin
    #  AFTER FIELD aaz100
    #     IF NOT cl_null(g_aaz.aaz100) THEN 
    #        CALL s103_aaz31(g_aaz.aaz100,g_aza.aza81)
    #        IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
    #           CALL cl_err('',g_errno,0)
    #           NEXT FIELD aaz100
    #        END IF
    #     END IF
    #  
    #  AFTER FIELD aaz101
    #     IF NOT cl_null(g_aaz.aaz101) THEN 
    #        CALL s103_aaz31(g_aaz.aaz101,g_aza.aza81)
    #        IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
    #           CALL cl_err('',g_errno,0)
    #           NEXT FIELD aaz101
    #        END IF
    #     END IF

    #  AFTER FIELD aaz102
    #     IF NOT cl_null(g_aaz.aaz102) THEN 
    #        CALL s103_aaz31(g_aaz.aaz102,g_aza.aza81)
    #        IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
    #           CALL cl_err('',g_errno,0)
    #           NEXT FIELD aaz102
    #        END IF
    #     END IF

    #  AFTER FIELD aaz103
    #     IF NOT cl_null(g_aaz.aaz103) THEN 
    #        CALL s103_aaz31(g_aaz.aaz103,g_aza.aza81)
    #        IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
    #           CALL cl_err('',g_errno,0)
    #           NEXT FIELD aaz103
    #        END IF
    #     END IF
    #FUN-920021---mark--end--- 

     #str FUN-890071 mark
     #AFTER FIELD aaz104
     #   IF NOT cl_null(g_aaz.aaz104) THEN 
     #      CALL s103_aaz31(g_aaz.aaz104,g_aza.aza81)
     #      IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
     #         CALL cl_err('',g_errno,0)
     #         NEXT FIELD aaz104
     #      END IF
     #   END IF
     #end FUN-890071 mark
      #FUN-770086...............end

      #TQC-860012--BEGIN--
      BEFORE FIELD aaz107
           CALL cl_set_comp_entry("aaz108",TRUE)

      AFTER FIELD aaz107
        IF NOT cl_null(g_aaz.aaz108) THEN
           IF cl_null(g_aaz.aaz107) THEN
              CALL cl_err('','agl-136',0)
              NEXT FIElD aaz108
           END IF
        END IF
        IF NOT cl_null(g_aaz.aaz107) THEN
           IF g_aaz.aaz107 = 0 THEN 
               CALL cl_err('','-32406',0)
               NEXT FIELD aaz107
           END IF
        END IF
      
      BEFORE FIELD aaz108
        IF cl_null(g_aaz.aaz107) THEN
           CALL cl_err('','agl-136',0)
           CALL cl_set_comp_entry("aaz108",FALSE)
        END IF
        IF cl_null(g_aaz.aaz107) AND NOT cl_null(g_aaz.aaz108) THEN
           CALL cl_set_comp_entry("aaz108",TRUE)
        END IF

      AFTER FIELD aaz108
        CALL cl_set_comp_entry("aaz108",TRUE)
        IF NOT cl_null(g_aaz.aaz107) THEN
           IF cl_null(g_aaz.aaz108) THEN
              CALL cl_err('','agl-136',0)
              NEXT FIELD aaz107
           END IF
        ELSE
           IF NOT cl_null(g_aaz.aaz108) THEN
              CALL cl_err('','agl-136',0)
              NEXT FIELD aaz108
           END IF
        END IF
        IF NOT cl_null(g_aaz.aaz108) THEN
            IF g_aaz.aaz108 = 0 THEN
               CALL cl_err('','-32406',0)
               NEXT FIELD aaz108
            END IF
        END IF
      #TQC-860012--END--      
      
#FUN-B50039-add-str--
      AFTER FIELD aazud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD aazud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
#FUN-B50039-add-end--



      #FUN-670032...............begin
      ON CHANGE aaz90
         IF NOT cl_null(g_aaz.aaz90) THEN
            CASE g_aaz.aaz90
               WHEN 'Y'
                  CALL cl_set_comp_entry("aaz91,aaz92",TRUE)
                  CALL cl_set_comp_required("aaz91,aaz92",TRUE)
               WHEN 'N'
                  CALL cl_set_comp_entry("aaz91,aaz92",FALSE)
                  CALL cl_set_comp_required("aaz91,aaz92",FALSE)
                  LET g_aaz.aaz91 = NULL
                  LET g_aaz.aaz92 = NULL
                  DISPLAY BY NAME g_aaz.aaz91,g_aaz.aaz92
            END CASE
         END IF

      AFTER FIELD aaz91
         IF NOT cl_null(g_aaz.aaz91) THEN
            CALL s103_abb03(g_aaz.aaz91,g_aza.aza81)  #No.FUN-730070
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,'0')  #Mod No.FUN-B10048 1->0
               #Add No.FUN-B10048
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_aaz.aaz91
               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 = '2'",
                                      " AND aag38='Y' AND aag01 LIKE '",g_aaz.aaz91 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_aaz.aaz91
               DISPLAY BY NAME g_aaz.aaz91
               #End Add No.FUN-B10048
               NEXT FIELD aaz91
            END IF
         END IF

      AFTER FIELD aaz92
         IF NOT cl_null(g_aaz.aaz92) THEN
            CALL s103_abb03(g_aaz.aaz92,g_aza.aza81)  #No.FUN-730070
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,'0')  #Mod No.FUN-B10048 1->0
               #Add No.FUN-B10048
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_aaz.aaz92
               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 = '2'",
                                      " AND aag38='Y' AND aag01 LIKE '",g_aaz.aaz92 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_aaz.aaz92
               DISPLAY BY NAME g_aaz.aaz92
               #End Add No.FUN-B10048
               NEXT FIELD aaz92
            END IF
         END IF

      #FUN-670031...............end
     #FUN-920021---str--mark
     ##FUN-890072---add---str---
     # AFTER FIELD aaz109
     #    IF NOT cl_null(g_aaz.aaz109) THEN 
     #       CALL s103_aaz31(g_aaz.aaz109,g_aza.aza81)
     #       IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
     #          CALL cl_err('',g_errno,0)
     #          NEXT FIELD aaz109
     #       END IF
     #    END IF
      
     # AFTER FIELD aaz110
     #    IF NOT cl_null(g_aaz.aaz110) THEN 
     #       CALL s103_aaz31(g_aaz.aaz110,g_aza.aza81)
     #       IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
     #          CALL cl_err('',g_errno,0)
     #          NEXT FIELD aaz110
     #       END IF
     #    END IF
     ##FUN-890072---add---end---
     #No.FUN-920021--str--end
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          

      ON ACTION mntn_acc_code
          CALL cl_cmdrun('agli102' CLIPPED) 

      ON ACTION mntn_doc_type
          CALL cl_cmdrun('agli108 ' CLIPPED) 
     
      ON ACTION controlp                                                          
         CASE                                                                     
            WHEN INFIELD(aaz64)                                                   
               CALL cl_init_qry_var()                                             
               LET g_qryparam.form ="q_aaa"                                       
               LET g_qryparam.default1 = g_aaz.aaz64                              
               CALL cl_create_qry() RETURNING g_aaz.aaz64                         
               DISPLAY BY NAME g_aaz.aaz64
               NEXT FIELD aaz64                                      
#FUN-BC0027 --begin--
#            WHEN INFIELD(aaz31)                                                   
#               CALL cl_init_qry_var()                                             
#               LET g_qryparam.form ="q_aag"                                       
#               LET g_qryparam.default1 = g_aaz.aaz31                              
#               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
#               CALL cl_create_qry() RETURNING g_aaz.aaz31                         
##               CALL FGL_DIALOG_SETBUFFER( g_aaz.aaz31 )
#               DISPLAY BY NAME g_aaz.aaz31                                        
#               NEXT FIELD aaz31                                                   
#            WHEN INFIELD(aaz32)                                                   
#               CALL cl_init_qry_var()                                             
#               LET g_qryparam.form ="q_aag"                                       
#               LET g_qryparam.default1 = g_aaz.aaz32                              
#               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
#               CALL cl_create_qry() RETURNING g_aaz.aaz32                         
##               CALL FGL_DIALOG_SETBUFFER( g_aaz.aaz32 )
#               DISPLAY BY NAME g_aaz.aaz32                                        
#               NEXT FIELD aaz32                                                   
#            WHEN INFIELD(aaz33)                                                   
#               CALL cl_init_qry_var()                                             
#               LET g_qryparam.form ="q_aag"                                       
#               LET g_qryparam.default1 = g_aaz.aaz33                              
#               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
#               CALL cl_create_qry() RETURNING g_aaz.aaz33                         
##               CALL FGL_DIALOG_SETBUFFER( g_aaz.aaz33 )
#               DISPLAY BY NAME g_aaz.aaz33                                        
#               NEXT FIELD aaz33               
#FUN-BC0027 --end--
            WHEN INFIELD(aaz65) 
              #CALL q_aac(FALSE,TRUE,g_aaz.aaz65,'','','',g_sys)  #TQC-670008 remark
              LET l_abc = "0','7"                                                 #TQC-A80119 Add
#              CALL q_aac(FALSE,TRUE,g_aaz.aaz65,'','','','AGL') #TQC-670008      #TQC-A80119 Mark
               CALL q_aac(FALSE,TRUE,g_aaz.aaz65,l_abc,'','','AGL')               #TQC-A80119 Add
                        RETURNING g_aaz.aaz65
               DISPLAY BY NAME g_aaz.aaz65                                        
               NEXT FIELD aaz65               
            WHEN INFIELD(aaz68) 
              #CALL q_aac(FALSE,TRUE,g_aaz.aaz68,'','','',g_sys) #TQC-670008 remark
              LET l_abc = "0','4"                                                 #TQC-A80119 Add
#              CALL q_aac(FALSE,TRUE,g_aaz.aaz68,'','','','AGL') #TQC-670008      #TQC-A80119 Mark
               CALL q_aac(FALSE,TRUE,g_aaz.aaz68,l_abc,'','','AGL')               #TQC-A80119 Add               
                        RETURNING g_aaz.aaz68
               DISPLAY BY NAME g_aaz.aaz68                                        
               NEXT FIELD aaz68               
          #FUN-920021---mark--str--
          ###str FUN-910001 add                                                                                                      
          #  WHEN INFIELD(aaz64)   #合并報表帳別                                                                                     
          #     CALL cl_init_qry_var()                                                                                               
          #     LET g_qryparam.form ="q_aaa"                                                                                         
          #     LET g_qryparam.default1 = g_aaz.aaz641                                                                               
          #     CALL cl_create_qry() RETURNING g_aaz.aaz641                                                                          
          #     DISPLAY BY NAME g_aaz.aaz641                                                                                         
          #     NEXT FIELD aaz641                                                                                                    
          ##end FUN-910001 add 

          ## FUN-580064
          #  WHEN INFIELD(aaz86)                                                   
          #     CALL cl_init_qry_var()                                             
          #     LET g_qryparam.form ="q_aag"                                       
          #     LET g_qryparam.default1 = g_aaz.aaz86                              
          #     LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
          #     CALL cl_create_qry() RETURNING g_aaz.aaz86                         
          #     DISPLAY BY NAME g_aaz.aaz86                                        
          #     NEXT FIELD aaz86                                                   
          #  WHEN INFIELD(aaz87)                                                   
          #     CALL cl_init_qry_var()                                             
          #     LET g_qryparam.form ="q_aag"                                       
          #     LET g_qryparam.default1 = g_aaz.aaz87                              
          #     LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
          #     CALL cl_create_qry() RETURNING g_aaz.aaz87                         
          #     DISPLAY BY NAME g_aaz.aaz87                                        
          #     NEXT FIELD aaz87   
          ## FUN-580064 End
          #  #FUN-770086................begin
          #  WHEN INFIELD(aaz100)                                                   
          #     CALL cl_init_qry_var()                                             
          #     LET g_qryparam.form ="q_aag"                                       
          #     LET g_qryparam.default1 = g_aaz.aaz100                              
          #     LET g_qryparam.arg1 = g_aza.aza81
          #     CALL cl_create_qry() RETURNING g_aaz.aaz100                         
          #     DISPLAY BY NAME g_aaz.aaz100                                        
          #     NEXT FIELD aaz100                                                   
          #  WHEN INFIELD(aaz101)                                                   
          #     CALL cl_init_qry_var()                                             
          #     LET g_qryparam.form ="q_aag"                                       
          #     LET g_qryparam.default1 = g_aaz.aaz101                              
          #     LET g_qryparam.arg1 = g_aza.aza81
          #     CALL cl_create_qry() RETURNING g_aaz.aaz101                         
          #     DISPLAY BY NAME g_aaz.aaz101                                        
          #     NEXT FIELD aaz101                                                   
          #  WHEN INFIELD(aaz102)                                                   
          #     CALL cl_init_qry_var()                                             
          #     LET g_qryparam.form ="q_aag"                                       
          #     LET g_qryparam.default1 = g_aaz.aaz102                              
          #     LET g_qryparam.arg1 = g_aza.aza81
          #     CALL cl_create_qry() RETURNING g_aaz.aaz102                         
          #     DISPLAY BY NAME g_aaz.aaz102                                        
          #     NEXT FIELD aaz102                                                   
          #  WHEN INFIELD(aaz103)                                                   
          #     CALL cl_init_qry_var()                                             
          #     LET g_qryparam.form ="q_aag"                                       
          #     LET g_qryparam.default1 = g_aaz.aaz103                              
          #     LET g_qryparam.arg1 = g_aza.aza81
          #     CALL cl_create_qry() RETURNING g_aaz.aaz103                         
          #     DISPLAY BY NAME g_aaz.aaz103                                        
          #     NEXT FIELD aaz103          
           #FUN-920021---mark---end---                                          
           #str FUN-890071 mark
           #WHEN INFIELD(aaz104)                                                   
           #   CALL cl_init_qry_var()                                             
           #   LET g_qryparam.form ="q_aag"                                       
           #   LET g_qryparam.default1 = g_aaz.aaz104                              
           #   LET g_qryparam.arg1 = g_aza.aza81
           #   CALL cl_create_qry() RETURNING g_aaz.aaz104                         
           #   DISPLAY BY NAME g_aaz.aaz104                                        
           #   NEXT FIELD aaz104                                                   
           #end FUN-890071 mark
            #FUN-770086................end
            #FUN-670032...............begin
            WHEN INFIELD(aaz91)      #查詢科目代號不為統制帳戶'1'
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_aaz.aaz91
               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 = '2'",
                                      " AND aag38='Y'"
               CALL cl_create_qry() RETURNING g_aaz.aaz91
               DISPLAY BY NAME g_aaz.aaz91
               NEXT FIELD aaz91            
            WHEN INFIELD(aaz92)      #查詢科目代號不為統制帳戶'1'
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_aaz.aaz92
               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 = '2'",
                                      " AND aag38='Y'"
               CALL cl_create_qry() RETURNING g_aaz.aaz92
               DISPLAY BY NAME g_aaz.aaz92
               NEXT FIELD aaz92
            #FUN-670032...............end
            #FUN-890072---add---str---
            WHEN INFIELD(aaz109)                                                   
               CALL cl_init_qry_var()                                             
               LET g_qryparam.form ="q_aag"                                       
               LET g_qryparam.default1 = g_aaz.aaz109                              
               LET g_qryparam.arg1 = g_aza.aza81
               CALL cl_create_qry() RETURNING g_aaz.aaz109                         
               DISPLAY BY NAME g_aaz.aaz109                                        
               NEXT FIELD aaz109                                                   
            WHEN INFIELD(aaz110)                                                   
               CALL cl_init_qry_var()                                             
               LET g_qryparam.form ="q_aag"                                       
               LET g_qryparam.default1 = g_aaz.aaz110                              
               LET g_qryparam.arg1 = g_aza.aza81
               CALL cl_create_qry() RETURNING g_aaz.aaz110                         
               DISPLAY BY NAME g_aaz.aaz110                                        
               NEXT FIELD aaz110                                                   
            #FUN-890072---add---end---
#FUN-9B0017   --start
            WHEN INFIELD(aaz121) #異動代碼5
               CALL cl_init_qry_var()                                                                                           
               LET g_qryparam.form = "q_ahe"                                                                                    
               LET g_qryparam.default1 = g_aaz.aaz121                                                                      
               CALL cl_create_qry() RETURNING g_aaz.aaz121                                                                 
               DISPLAY BY NAME g_aaz.aaz121                                                                                
               NEXT FIELD aaz121                                                                                                 
            WHEN INFIELD(aaz122)  #異動代碼6
               CALL cl_init_qry_var()                                                                                           
               LET g_qryparam.form = "q_ahe"                                                                                    
               LET g_qryparam.default1 = g_aaz.aaz122                                                                      
               CALL cl_create_qry() RETURNING g_aaz.aaz122                                                                 
               DISPLAY BY NAME g_aaz.aaz122                                                                                
               NEXT FIELD aaz122                                                                                                 
            WHEN INFIELD(aaz123)   #異動代碼7
               CALL cl_init_qry_var()                                                                                           
               LET g_qryparam.form = "q_ahe"                                                                                    
               LET g_qryparam.default1 = g_aaz.aaz123                                                                      
               CALL cl_create_qry() RETURNING g_aaz.aaz123                                                                 
               DISPLAY BY NAME g_aaz.aaz123                                                                                
               NEXT FIELD aaz123                                                                                                 
            WHEN INFIELD(aaz124)   #異動代碼8
               CALL cl_init_qry_var()                                                                                           
               LET g_qryparam.form = "q_ahe"  
               LET g_qryparam.default1 = g_aaz.aaz124                                                                      
               CALL cl_create_qry() RETURNING g_aaz.aaz124                                                                 
               DISPLAY BY NAME g_aaz.aaz124                                                                                
               NEXT FIELD aaz124 
#FUN-9B0017   ---end           
#FUN-B70002   ---start   Add
            WHEN INFIELD(aaz126)   #異動代碼8
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aha1"
               LET g_qryparam.default1 = g_aaz.aaz126
               LET g_qryparam.where = "aac03 = '0' AND aac11 = '1'"
               CALL cl_create_qry() RETURNING g_aaz.aaz126
               DISPLAY BY NAME g_aaz.aaz126
               NEXT FIELD aaz126
            WHEN INFIELD(aaz127)   #異動代碼8
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aha1"
               LET g_qryparam.default1 = g_aaz.aaz127
               LET g_qryparam.where = "aac03 = '0' AND aac11 = '1'"
               CALL cl_create_qry() RETURNING g_aaz.aaz127
               DISPLAY BY NAME g_aaz.aaz127
               NEXT FIELD aaz127
#FUN-B70002   ---end     Add
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

END FUNCTION

#FUN-BC0027 --begin--
#FUNCTION s103_aaz31(p_code,p_bookno)      #No.FUN-730070
#   DEFINE p_code     LIKE aag_file.aag01  
#   DEFINE p_bookno   LIKE aag_file.aag00  #No.FUN-730070
#   DEFINE l_aagacti  LIKE aag_file.aagacti
#   DEFINE l_aag07    LIKE aag_file.aag07  
#   DEFINE l_aag03    LIKE aag_file.aag03  
# 
#   SELECT aag03,aag07,aagacti INTO l_aag03,l_aag07,l_aagacti
#     FROM aag_file
#    WHERE aag01=p_code      
#      AND aag00=p_bookno  #No.FUN-730070
#
#    CASE WHEN STATUS=100         LET g_errno='agl-001'   #MOD-4C0096
#        WHEN l_aagacti='N'      LET g_errno='9028'
#        WHEN l_aag07  = '1'     LET g_errno = 'agl-015' 
#        WHEN l_aag03  = '2'     LET g_errno = 'agl-213' 
#        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
#   END CASE
#END FUNCTION
#FUN-BC0027 --end--

#FUN-670032
#檢查科目名稱 same as saglt110.t110_abb03
FUNCTION s103_abb03(p_aag01,p_bookno)  #No.FUN-730070
DEFINE
    p_aag01         LIKE aag_file.aag01,
    p_bookno        LIKE aag_file.aag00,   #No.FUN-730070
    l_aagacti       LIKE aag_file.aagacti,
    l_aag07         LIKE aag_file.aag07,  
    l_aag03         LIKE aag_file.aag03,  
    l_aag38         LIKE aag_file.aag38  

    LET g_errno = ' '
    IF cl_null(p_aag01) THEN RETURN END IF
   #SELECT aag03,aag07,aag38,aagacti INTO l_aagacti
    SELECT aag03,aag07,aag38,aagacti INTO l_aag03,l_aag07,l_aag38,l_aagacti  #Mod No.FUN-B10048
        FROM aag_file WHERE aag01 = p_aag01
                        AND aag00 = p_bookno  #No.FUN-730070
    CASE WHEN SQLCA.SQLCODE=100 LET g_errno = 'agl-001'
         WHEN l_aagacti = 'N'   LET g_errno = '9028'
         WHEN l_aag07 ='1'      LET g_errno = 'agl-015'
         WHEN l_aag03 != '2'    LET g_errno = 'agl-201'
         WHEN l_aag38<>'Y'      LET g_errno = 'agl-069'
         OTHERWISE              LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION

#No.TQC-790077  --Begin
FUNCTION s103_check_slip_no(p_aac01,p_type)
  DEFINE p_aac01         LIKE aac_file.aac01
  DEFINE p_type          LIKE type_file.chr1
  DEFINE l_aacacti       LIKE aac_file.aacacti

    LET g_errno = ' '
    IF p_type = '1' THEN
       SELECT aacacti INTO l_aacacti FROM aac_file
        WHERE aac01 = p_aac01
          AND (aac11 = '0' OR aac11 = '7')
    ELSE
       SELECT aacacti INTO l_aacacti FROM aac_file
        WHERE aac01 = p_aac01
          AND (aac11 = '0' OR aac11 = '4')
    END IF

    CASE WHEN SQLCA.SQLCODE=100 LET g_errno = 'agl-035'
         WHEN l_aacacti = 'N'   LET g_errno = '9028'
         OTHERWISE              LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
#No.TQC-790077  --End  
#FUN-9B0017   ---START
FUNCTION s103_ahe02(p_ahe)                                                                                                         
  DEFINE  p_ahe     LIKE ahe_file.ahe01,                                                                                            
          l_ahe02   LIKE ahe_file.ahe02                                                                                             
                                                                                                                                    
  SELECT ahe02 INTO l_ahe02 FROM ahe_file                                                                                           
   WHERE ahe01 = p_ahe                                                                                                              
                                                                                                                                    
  RETURN l_ahe02                                                                                                                    
                                                                                                                                    
END FUNCTION     

FUNCTION s103_chk_ahe(p_ahe)                                                                                                       
  DEFINE  p_ahe     LIKE ahe_file.ahe01,                                                                                            
          l_n       LIKE type_file.num10                                                                   
                                                                                                                                    
  LET g_errno = ''                                                                                                                  
  SELECT COUNT(*) INTO l_n FROM ahe_file                                                                                            
   WHERE ahe01 = p_ahe                                                                                                              
                                                                                                                                    
  IF l_n <= 0 THEN                                                                                                                  
     #無此異動碼類型代號,請重新輸入!
     LET g_errno = 'agl-028'                                                                                                        
     CALL cl_err(p_ahe,g_errno,1)                                                                                                   
     RETURN                                                                                                                         
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION

FUNCTION s103_chk_field(p_ahe)
   DEFINE p_ahe       LIKE ahe_file.ahe01
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_ahe       RECORD LIKE ahe_file.*
   DEFINE l_length    LIKE type_file.num5
   DEFINE l_length1   LIKE type_file.num5
   DEFINE l_precision LIKE type_file.num5

   SELECT * INTO l_ahe.* FROM ahe_file
    WHERE ahe01=p_ahe AND ahe03='1'
   IF STATUS THEN
      RETURN 0
   ELSE
      #抓取欄位寬度
    # SELECT to_char(decode(data_precision,null,data_length,data_precision),'9999.99')
    #   INTO l_length
    #   FROM user_tab_columns
    #  WHERE lower(table_name) =l_ahe.ahe04
    #    AND lower(column_name)=l_ahe.ahe05
      SELECT data_precision,data_length
        INTO l_precision,l_length1
        FROM user_tab_columns
       WHERE lower(table_name) =l_ahe.ahe04
         AND lower(column_name)=l_ahe.ahe05
      IF cl_null(l_precision) THEN
         LET l_length=l_length1
      ELSE
         LET l_length=l_precision
      END IF
       
      IF l_length > 30 THEN
         RETURN 1
      ELSE
         RETURN 0
      END IF
   END IF
END FUNCTION
#FUN-9B0017   ---END
