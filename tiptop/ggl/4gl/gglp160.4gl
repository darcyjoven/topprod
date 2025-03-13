# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglp160.4gl
# Descriptions...: 國家標准會計核算軟件數據接口
# Date & Author..: 06/01/16 BY Tracy
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-710056 07/02/01 By Carrier 匯出規則改變
# Modify.........: No.FUN-730070 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-790089 07/09/18 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.FUN-810045 08/03/03 By rainy 項目管理:專案table gja_file改為pja_file
# Modify.........: No.MOD-830091 08/03/12 By Smapmin 相關產出檔案未轉成簡體中文
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
# Modify.........: No:MOD-C20097 12/02/09 By Carrier 修改 科目类别 & 转码内容
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表

IMPORT os    #FUN-A30038 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                #gglp160.per獲得的參數
           v         LIKE type_file.chr20,       #NO.FUN-690009   VARCHAR(20)    #版本
           p         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #單位性質
           w         LIKE type_file.chr20,       #NO.FUN-690009   VARCHAR(20)    #行業
           year      LIKE tah_file.tah02,        #NO.FUN-690009   VARCHAR(4)     #會計年度
           mon       LIKE tah_file.tah03,        #NO.FUN-690009   VARCHAR(2)     #期別
           level1    LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #會計科目一級長度
           level2    LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #會計科目二級長度
           level3    LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #會計科目三級長度
           level4    LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #會計科目四級長度
           level5    LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #會計科目五級長度
           level6    LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #會計科目六級長度
           a         LIKE type_file.chr20,       #NO.FUN-690009   VARCHAR(20)    #單位組織機構代碼
           b         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #格式說明文件
           c         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #電子帳簿數據文件
           d         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #會計科目數據文件
           e         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #記賬憑証數據文件
           f         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #科目余額及發生額數據文件
           g         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #企業資產負債表
           h         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #企業利潤表
           i         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #企業現金流量表
           j         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #企業應交增值稅明細表
           k         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #企業資產減值准備明細表
           l         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #企業股東權益增減變動表
           m         LIKE type_file.chr1,        #NO.FUN-690009   VARCHAR(1)     #企業利潤分配表
           gg        LIKE mai_file.mai01,        #NO.FUN-690009   VARCHAR(6)     #報表結構編號
           hh        LIKE mai_file.mai01,        #NO.FUN-690009   VARCHAR(6)     #報表結構編號
           jj        LIKE mai_file.mai01,        #NO.FUN-690009   VARCHAR(6)     #報表結構編號
           kk        LIKE mai_file.mai01,        #NO.FUN-690009   VARCHAR(6)     #報表結構編號
           ll        LIKE mai_file.mai01,        #NO.FUN-690009   VARCHAR(6)     #報表結構編號
           mm        LIKE mai_file.mai01,        #NO.FUN-690009   VARCHAR(6)     #報表結構編號
           bookno    LIKE aaa_file.aaa01,        #No.FUN-730070
           path      LIKE type_file.chr50        #NO.FUN-690009   VARCHAR(30)    #保存路徑  #No.FUN-710056
           END RECORD
DEFINE  g_i          LIKE type_file.num5,        #NO.FUN-690009   SMALLINT            #count/index for any purpose
        g_msg        LIKE type_file.chr1000,     #NO.FUN-690009   VARCHAR(80)
        g_azi02      LIKE azi_file.azi02,        #幣種名稱
        g_sql        LIKE type_file.chr1000,     #NO.FUN-690009   VARCHAR(1000)
        g_aaa03      LIKE aaa_file.aaa03,        #本位幣
        g_bookno     LIKE aaa_file.aaa01         #缺省帳套編號
DEFINE  g_aaa        RECORD LIKE aaa_file.*      #FUN-BC0027 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   CALL p160_tm()

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p160_tm()
   DEFINE p_row,p_col LIKE type_file.num5,         #NO.FUN-690009   SMALLINT
          l_sw        LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01)         #重要欄位是否空白
          l_chr       LIKE type_file.chr1,         #NO.FUN-690009   VARCHAR(01)
          l_n         LIKE type_file.num5,         #NO.FUN-690009   SMALLINT
          l_cmd       LIKE type_file.chr1000       #NO.FUN-690009   VARCHAR(400)
   DEFINE li_result   LIKE type_file.num5          #No.FUN-6C0068
 
   LET p_row = 3 LET p_col = 10
   OPEN WINDOW acc_w AT p_row,p_col WITH FORM "ggl/42f/gglp160"
        ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   LET g_bookno = ' '
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file
   END IF
 
   INITIALIZE tm.* TO NULL                       #Default condition
 
   SELECT aaa03,aaa04,aaa05
     INTO g_aaa03,tm.year,tm.mon                 #本位幣,現行會計年度,期別
     FROM aaa_file
#   WHERE aaa01 = g_bookno     #No.FUN-730070
    WHERE aaa01 = g_aza.aza81  #No.FUN-730070
 
   SELECT azi02 INTO g_azi02                     #本位幣名稱
     FROM azi_file WHERE azi01 = g_aaa03
 
   #No.MOD-C20097  --Begin
   #LET tm.v = 'GP3.0'
   LET tm.v = 'GP5.3'
   #No.MOD-C20097  --End  
   LET tm.p = '1'
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   LET tm.d = 'Y'
   LET tm.e = 'Y'
   LET tm.f = 'Y'
   LET tm.g = 'N'
   LET tm.h = 'N'
   LET tm.i = 'N'
   LET tm.j = 'N'
   LET tm.k = 'N'
   LET tm.l = 'N'
   LET tm.m = 'N'
   LET tm.bookno = g_aza.aza81  #No.FUN-730070
 
   LET tm.path   = 'C:\/tiptop'
   LET tm.level1 = '4'
   LET tm.level2 = '2'
   LET tm.level3 = '2'
   LET tm.level4 = '2'
   LET tm.level5 = '2'
   LET tm.level6 = '2'
 
   WHILE TRUE
      LET l_sw = 1                               #重要欄位空白
      INPUT BY NAME tm.v,tm.p,tm.w,tm.a,tm.year,tm.mon,tm.bookno,   #No.FUN-730070
                    tm.level1,tm.level2,tm.level3,tm.level4,tm.level5,tm.level6,
                    tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.gg,tm.h,tm.hh,
                    tm.i,tm.j,tm.jj,tm.k,tm.kk,tm.l,tm.ll,tm.m,tm.mm,
                    tm.path  #No.FUN-730070
                    WITHOUT DEFAULTS HELP 1
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()
 
        ON ACTION browse
           LET tm.path = cl_browse_dir()
           DISPLAY tm.path TO FORMONLY.path
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(gg)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.where = " mai03 = '2' "  #add by ice 06/04/03
                  LET g_qryparam.default1 = tm.gg
                  CALL cl_create_qry() RETURNING tm.gg
                  DISPLAY BY NAME tm.gg
                  NEXT FIELD gg
             WHEN INFIELD(hh)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.where = " mai03 != '2' " #add by ice 06/04/03
                  LET g_qryparam.default1 = tm.gg
                  CALL cl_create_qry() RETURNING tm.hh
                  DISPLAY BY NAME tm.hh
                  NEXT FIELD hh
             WHEN INFIELD(jj)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.where = " mai03 != '2' " #add by ice 06/04/03
                  LET g_qryparam.default1 = tm.gg
                  CALL cl_create_qry() RETURNING tm.jj
                  DISPLAY BY NAME tm.jj
                  NEXT FIELD jj
             WHEN INFIELD(kk)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.where = " mai03 != '2' " #add by ice 06/04/03
                  LET g_qryparam.default1 = tm.gg
                  CALL cl_create_qry() RETURNING tm.kk
                  DISPLAY BY NAME tm.kk
                  NEXT FIELD kk
             WHEN INFIELD(ll)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.where = " mai03 != '2' " #add by ice 06/04/03
                  LET g_qryparam.default1 = tm.gg
                  CALL cl_create_qry() RETURNING tm.ll
                  DISPLAY BY NAME tm.ll
                  NEXT FIELD ll
             WHEN INFIELD(mm)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.where = " mai03 != '2' " #add by ice 06/04/03
                  LET g_qryparam.default1 = tm.gg
                  CALL cl_create_qry() RETURNING tm.mm
                  DISPLAY BY NAME tm.mm
                  NEXT FIELD mm
             #No.FUN-730070  --Begin
             WHEN INFIELD(bookno) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.bookno
                  CALL cl_create_qry() RETURNING tm.bookno
                  DISPLAY BY NAME tm.bookno
                  CALL p160_bookno('d',tm.bookno)
             #No.FUN-730070  --End  
           END CASE
 
        AFTER FIELD gg
           IF NOT cl_null(tm.gg) THEN
            #FUN-6C0068--begin
              CALL s_chkmai(tm.gg,'RGL') RETURNING li_result
              IF NOT li_result THEN
                CALL cl_err(tm.gg,g_errno,1)
                NEXT FIELD gg
              END IF
            #FUN-6C0068--end
 
              SELECT COUNT(*) INTO l_n FROM mai_file
               WHERE mai01 = tm.gg
                 AND maiacti = 'Y'
                 AND mai03 = '2'    #add by ice 06/04/03
                 AND mai00 = tm.bookno  #No.FUN-730070
              IF l_n = 0 THEN
                 CALL cl_err(tm.gg,100,0)
                 NEXT FIELD gg
              END IF
           END IF
 
        AFTER FIELD hh
           IF NOT cl_null(tm.hh) THEN
            #FUN-6C0068--begin
              CALL s_chkmai(tm.hh,'RGL') RETURNING li_result
              IF NOT li_result THEN
                CALL cl_err(tm.hh,g_errno,1)
                NEXT FIELD hh
              END IF
            #FUN-6C0068--end
              SELECT COUNT(*) INTO l_n FROM mai_file
               WHERE mai01 = tm.hh
                 AND maiacti = 'Y'
                 AND mai03 != '2'   #add by ice 06/04/03
                 AND mai00 = tm.bookno  #No.FUN-730070
              IF l_n = 0 THEN
                 CALL cl_err(tm.hh,100,0)
                 NEXT FIELD hh
              END IF
           END IF
 
        AFTER FIELD jj
           IF NOT cl_null(tm.jj) THEN
            #FUN-6C0068--begin
              CALL s_chkmai(tm.jj,'RGL') RETURNING li_result
              IF NOT li_result THEN
                CALL cl_err(tm.jj,g_errno,1)
                NEXT FIELD jj
              END IF
            #FUN-6C0068--end
              SELECT COUNT(*) INTO l_n FROM mai_file
               WHERE mai01 = tm.jj
                 AND maiacti = 'Y'
                 AND mai03 != '2'   #add by ice 06/04/03
                 AND mai00 = tm.bookno  #No.FUN-730070
              IF l_n = 0 THEN
                 CALL cl_err(tm.jj,100,0)
                 NEXT FIELD jj
              END IF
           END IF
 
        AFTER FIELD kk
           IF NOT cl_null(tm.kk) THEN
            #FUN-6C0068--begin
              CALL s_chkmai(tm.kk,'RGL') RETURNING li_result
              IF NOT li_result THEN
                CALL cl_err(tm.kk,g_errno,1)
                NEXT FIELD kk
              END IF
            #FUN-6C0068--end
              SELECT COUNT(*) INTO l_n FROM mai_file
               WHERE mai01 = tm.kk
                 AND maiacti = 'Y'
                 AND mai03 != '2'   #add by ice 06/04/03
                 AND mai00 = tm.bookno  #No.FUN-730070
              IF l_n = 0 THEN
                 CALL cl_err(tm.kk,100,0)
                 NEXT FIELD kk
              END IF
           END IF
 
        AFTER FIELD ll
           IF NOT cl_null(tm.ll) THEN
            #FUN-6C0068--begin
              CALL s_chkmai(tm.ll,'RGL') RETURNING li_result
              IF NOT li_result THEN
                CALL cl_err(tm.ll,g_errno,1)
                NEXT FIELD ll
              END IF
            #FUN-6C0068--end
              SELECT COUNT(*) INTO l_n FROM mai_file
               WHERE mai01 = tm.ll
                 AND maiacti = 'Y'
                 AND mai03 != '2'   #add by ice 06/04/03
                 AND mai00 = tm.bookno  #No.FUN-730070
              IF l_n = 0 THEN
                 CALL cl_err(tm.ll,100,0)
                 NEXT FIELD ll
              END IF
           END IF
 
        AFTER FIELD mm
           IF NOT cl_null(tm.mm) THEN
            #FUN-6C0068--begin
              CALL s_chkmai(tm.mm,'RGL') RETURNING li_result
              IF NOT li_result THEN
                CALL cl_err(tm.mm,g_errno,1)
                NEXT FIELD mm
              END IF
            #FUN-6C0068--end
              SELECT COUNT(*) INTO l_n FROM mai_file
               WHERE mai01 = tm.mm
                 AND maiacti = 'Y'
                 AND mai03 != '2'   #add by ice 06/04/03
                 AND mai00 = tm.bookno  #No.FUN-730070
              IF l_n = 0 THEN
                 CALL cl_err(tm.mm,100,0)
                 NEXT FIELD mm
              END IF
           END IF
 
        #No.FUN-730070  --Begin
        AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
               CALL p160_bookno('a',tm.bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.bookno,g_errno,0)
                  LET tm.bookno = g_aza.aza81
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
               END IF
            END IF
        #No.FUN-730070  --End  
 
        AFTER INPUT
           IF tm.g = 'Y' AND cl_null(tm.gg) THEN  NEXT FIELD gg  END IF
           IF tm.h = 'Y' AND cl_null(tm.hh) THEN  NEXT FIELD hh  END IF
           IF tm.j = 'Y' AND cl_null(tm.jj) THEN  NEXT FIELD jj  END IF
           IF tm.k = 'Y' AND cl_null(tm.kk) THEN  NEXT FIELD kk  END IF
           IF tm.l = 'Y' AND cl_null(tm.ll) THEN  NEXT FIELD ll  END IF
           IF tm.m = 'Y' AND cl_null(tm.mm) THEN  NEXT FIELD mm  END IF
           IF INT_FLAG THEN EXIT INPUT END IF
 
#--NO.MOD-860078 start---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
#--NO.MOD-860078 end------- 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW acc_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL p160_out()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW acc_w
END FUNCTION
 
#No.FUN-730070  --Begin
FUNCTION p160_bookno(p_cmd,p_bookno)
  DEFINE p_cmd      LIKE type_file.chr1,  
         p_bookno   LIKE aaa_file.aaa01, 
         l_aaaacti  LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-730070  --End  
 
FUNCTION p160_out()
   DEFINE l_name    LIKE zaa_file.zaa08,       #NO.FUN-690009   VARCHAR(60)
          l_name1   LIKE zaa_file.zaa08,       #NO.FUN-690009   VARCHAR(60)
          l_name2   LIKE zaa_file.zaa08,       #NO.FUN-690009   VARCHAR(60)      #add by ice
          l_name3   LIKE zaa_file.zaa08,       #NO.FUN-690009   VARCHAR(60)      #add by ice
          ls_cmd    STRING,                      #add by ice
          sr1       RECORD                       #KJKM.TXT
                    aag01   LIKE aag_file.aag01, #科目編號
                    aag02   LIKE aag_file.aag13, #科目名稱   #No.FUN-710056
                    level   LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01)   #科目層級
                    sign    LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01)   #輔助核算標志
                    desc    LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(60)   #輔助核算項
                    kind    LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(50)   #科目類型
                    unit    LIKE aag_file.aag12,         #NO.FUN-690009   VARCHAR(10)   #計量單位
                    msg     LIKE aag_file.aag10          #NO.FUN-690009   VARCHAR(10)   #余額方向
                    END RECORD,
          l_sql     LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(1000)
          l_sql2    LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(1000)
          l_sql3    LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(1000)
          l_sql4    LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(1000)
          l_sql5    LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(1000)
          l_sql6    LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(1000)
          l_aag06   LIKE aag_file.aag06,         #正常余額型態(1.借余/2.貸余)
          l_aag07   LIKE aag_file.aag07,         #No.FUN-710056
          l_len     LIKE type_file.num5,         #NO.FUN-690009    SMALLINT      #科目編號長度
          sr2       RECORD                       #BMXX.TXT
                    gem01   LIKE gem_file.gem01, #部門編號
                    gem02   LIKE gem_file.gem02  #部門簡稱
                    END RECORD,
          sr3       RECORD                       #WLDW.TXT
                    occ01  LIKE occ_file.occ01,  #NO.FUN-690009    VARCHAR(30)       #單位編號
                    occ18  LIKE occ_file.occ18,  #NO.FUN-690009    VARCHAR(80)       #單位名稱
                    sort   LIKE type_file.chr20, #NO.FUN-690009    VARCHAR(20)       #類別
                    geo02  LIKE geo_file.geo02,  #NO.FUN-690009    VARCHAR(40)       #地區
                    occ261 LIKE occ_file.occ261, #NO.FUN-690009    VARCHAR(20)       #電話
                    occ231 LIKE occ_file.occ231, #NO.FUN-690009    VARCHAR(255)      #地址
                    occ61  LIKE occ_file.occ61   #NO.FUN-690009    VARCHAR(10)       #信用等級
                    END RECORD,
          sr4       RECORD                       #XMXX.TXT
                  #FUN-810045 begin
                    #gja01   LIKE gja_file.gja01, #項目編號
                    #gja02   LIKE gja_file.gja02  #項目名稱
                    pja01   LIKE pja_file.pja01, #項目編號
                    pja02   LIKE pja_file.pja02  #項目名稱
                  #FUN-810045 end
                    END RECORD,
          sr5       RECORD                       #RYXX.TXT
                    gen01   LIKE gen_file.gen01, #員工編號
                    gen02   LIKE gen_file.gen02  #員工姓名
                    END RECORD,
          l_aag01   LIKE aag_file.aag01,
          sr6,sr7   RECORD                       #KMYE.TXT
                    tah01   LIKE tah_file.tah01, #科目編號
                    azi02   LIKE azi_file.azi02, #幣種名稱
                    ted02   LIKE ted_file.ted02, #異動碼VALUE
                    qcye    LIKE tah_file.tah04, #期初余額
                    qcsl    LIKE tah_file.tah06, #期初數量  #No.FUN-710056
                    qcwbye  LIKE tah_file.tah09, #期初外幣余額
                    tah04   LIKE tah_file.tah04, #借方發生額
                    tah06   LIKE tah_file.tah06, #借方發生數量
                    tah09   LIKE tah_file.tah09, #借方外幣發生額
                    tah05   LIKE tah_file.tah05, #貸方發生額
                    tah07   LIKE tah_file.tah07, #貸方發生數量
                    tah10   LIKE tah_file.tah10, #貸方外幣發生額
                    qmye    LIKE tah_file.tah04, #期末余額
                    qmsl    LIKE tah_file.tah06, #期末數量   #No.FUN-710056
                    qmwbye  LIKE tah_file.tah09, #期末外幣余額
                    tah03   LIKE tah_file.tah03  # Prog. Version..: '5.30.06-13.03.12(02)      #期別
                    END RECORD,
          l_tah08   LIKE tah_file.tah08,         #幣別
          l_tah01   LIKE tah_file.tah01,         #No.FUN-710056
          l_n       LIKE type_file.num5,         #NO.FUN-690009    SMALLINT
          sr8       RECORD                       #JZPZ.TXT
                    aba02   LIKE aba_file.aba02, #憑証日期
                    aac02   LIKE aac_file.aac02, #單別名稱(憑証種類）
                    aba11   LIKE aba_file.aba11, #總號  #No.FUN-710056
                    abb02   LIKE abb_file.abb02, #項次
                    abb04   LIKE abb_file.abb04, #摘要
                    abb03   LIKE abb_file.abb03, #科目編號
                    abb07a  LIKE abb_file.abb07, #借方金額
                    abb07b  LIKE abb_file.abb07, #貸方金額
                    azi02   LIKE azi_file.azi02, #幣種說明
                    abb07fa LIKE abb_file.abb07f,#借方外幣金額
                    abb07fb LIKE abb_file.abb07f,#貸方外幣金額
                    abb25   LIKE abb_file.abb25, #匯率
                    abb41   LIKE abb_file.abb41, #數量
                    abb42   LIKE abb_file.abb42, #單價
                    desc    LIKE zaa_file.zaa08, #NO.FUN-690009   VARCHAR(255)           #核算項1234
                    aba31   LIKE aba_file.aba31, #結算方式
                    aba32   LIKE aba_file.aba32, #票據類型
                    aba33   LIKE aba_file.aba33, #票據號
                    aba34   LIKE aba_file.aba34, #票據日期
                    aba21   LIKE aba_file.aba21, #附件張數
                    abauser LIKE aba_file.abauser,    #錄入人員
                    aba37   LIKE aba_file.aba37,      #審核人員
                    aba38   LIKE aba_file.aba38,      #記賬人員
                    aba36   LIKE aba_file.aba36,      #出納人員
                    abapost LIKE aba_file.abapost,    #過賬碼
                    abaacti LIKE aba_file.abaacti     #資料有效碼
                    END RECORD,
          l_abb06   LIKE abb_file.abb06,         #借貸別
          l_abb07   LIKE abb_file.abb07,         #本幣金額
          l_abb07f  LIKE abb_file.abb07f,        #原幣金額
          l_abb24   LIKE abb_file.abb24,         #幣種
          l_abb11   LIKE abb_file.abb11,         #核算項-1
          l_abb12   LIKE abb_file.abb12,         #核算項-2
          l_abb13   LIKE abb_file.abb13,         #核算項-3
          l_abb14   LIKE abb_file.abb14,         #核算項-4
          l_aba01   LIKE aba_file.aba01,         #No.FUN-710056
          l_t1      LIKE aac_file.aac01          #憑証單別
 
   CALL cl_outnam('gglp160') RETURNING l_name
 
   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = tm.bookno   #FUN-BC0027
   
   #[1]匯出格式說明文件GSSM.TXT
   IF tm.b = 'Y' THEN
      LET l_name1 = 'GSSM.TXT'
      START REPORT gssm_rep TO l_name1
      OUTPUT TO REPORT gssm_rep()
      FINISH REPORT gssm_rep
      CALL p160_save(l_name1)
   END IF
 
   #[2]匯出電子賬簿DZZB.TXT
   IF tm.c = 'Y' THEN
      LET l_name1 = 'DZZB.TXT'
      START REPORT dzzb_rep TO l_name1
      OUTPUT TO REPORT dzzb_rep()
      FINISH REPORT dzzb_rep
      CALL p160_save(l_name1)
   END IF
 
   #[3]匯出會計科目KJKM.TXT
 
   IF tm.d = 'Y' THEN
      LET l_name1 = 'KJKM.TXT'
      #aag01科目編號,aag02科目名稱,aag06余額型態
      #匯出aag13(額外名稱)
      #No.FUN-710056  --Begin
      LET l_sql = "SELECT aag01, aag13, 0,0,'','',aag12,'',aag06",
                  "  FROM aag_file ",
                  " WHERE aagacti = 'Y' ",
                  "   AND aag00 = '",tm.bookno,"'",  #No.FUN-730070
                  " ORDER BY aag01 "
      #No.FUN-710056  --End
      PREPARE aag_p1 FROM l_sql
      IF STATUS <> 0 THEN
         CALL cl_err('prepare aag:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE aag_curs1 CURSOR FOR aag_p1
 
      START REPORT kjkm_rep TO l_name1
      FOREACH aag_curs1 INTO sr1.*,l_aag06  #No.FUN-710056
         IF STATUS THEN
            CALL cl_err('foreach aag:',STATUS,1)
            EXIT FOREACH
         END IF
         #No.FUN-710056  --Begin
         #虛科目不要出來
         IF sr1.aag01 = '3131-IS' OR sr1.aag01 ='3135-IS' OR sr1.aag01 = '3135' THEN
            CONTINUE FOREACH
         END IF
#         IF sr1.aag01 = g_aaz.aaz31 OR sr1.aag01 = g_aaz.aaz32 THEN   #FUN-BC0027 
          IF sr1.aag01 = g_aaa.aaa14 OR sr1.aag01 = g_aaa.aaa15 THEN   #FUN-BC0027 
            CONTINUE FOREACH
         END IF
         #No.FUN-710056  --End
 
         LET l_len = LENGTH(sr1.aag01)
         IF l_len-tm.level1<=0 THEN
            LET sr1.level = 1
         ELSE
            IF l_len-tm.level1-tm.level2<=0 THEN
               LET sr1.level = 2
            ELSE
               IF l_len-tm.level1-tm.level2-tm.level3<=0 THEN
                  LET sr1.level = 3
               ELSE
                  IF l_len-tm.level1-tm.level2-tm.level3-tm.level4<=0 THEN
                     LET sr1.level = 4
                  ELSE
                     IF l_len-tm.level1-tm.level2-tm.level3-tm.level4-tm.level5<=0 THEN
                        LET sr1.level = 5
                     ELSE
                        LET sr1.level = 6
                     END IF
                  END IF
               END IF
            END IF
         END IF
 
         CASE sr1.aag01[1,1]
            #No.MOD-C20097  --Begin
            WHEN '1'  LET sr1.kind = g_x[176]    #資產類
            WHEN '2'  LET sr1.kind = g_x[177]    #負債類
            WHEN '3'  LET sr1.kind = g_x[184]    #共同类
            WHEN '4'  LET sr1.kind = g_x[178]    #所有者權益類
            WHEN '5'  LET sr1.kind = g_x[179]    #成本費用類
            WHEN '6'  LET sr1.kind = g_x[180]    #損益類
            #No.MOD-C20097  --End  
         END CASE
 
         IF l_aag06 = '1' THEN                   #1借 2貸
            LET sr1.msg = g_x[172]
         ELSE
            LET sr1.msg = g_x[173]
         END IF
         OUTPUT TO REPORT kjkm_rep(sr1.*)
      END FOREACH
 
      FINISH REPORT kjkm_rep
      CALL p160_save(l_name1)
   END IF
 
   #[4]匯出部門信息BMXX.TXT
   LET l_name1 = 'BMXX.TXT'
   LET l_sql1 = "SELECT gem01, gem02 FROM gem_file ",
                " WHERE gemacti = 'Y'",
                " ORDER BY gem01 "               #gem01部門編號,gem02部門名稱
 
   PREPARE gem_p1 FROM l_sql1
   IF STATUS <> 0 THEN
      CALL cl_err('prepare gem:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE gem_curs1 CURSOR FOR gem_p1
   START REPORT bmxx_rep TO l_name1
   FOREACH gem_curs1 INTO sr2.*
      IF STATUS THEN
         CALL cl_err('foreach gem:',STATUS,1)
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT bmxx_rep(sr2.*)
   END FOREACH
 
   FINISH REPORT bmxx_rep
   CALL p160_save(l_name1)
 
   #[5]匯出單位信息WLDW.TXT
   LET l_name1 = 'WLDW.TXT'
#FUN-690009 -----------------------------begin------------------------------------
#   DROP TABLE p160_temp
#   CREATE TEMP TABLE p160_temp(
#          occ01  VARCHAR(30),                       #單位編號
#          occ18  VARCHAR(80),                       #單位名稱
#          sort   VARCHAR(20),                       #類別
#          geo02  VARCHAR(40),                       #地區
#          occ261 VARCHAR(20),                       #電話
#          occ231 VARCHAR(255),                      #地址
#          occ61  VARCHAR(10) )                      #信用等級
#FUN-690009-------------------------------END-------------------------------------
#FUN-690009 -----------------------------begin------------------------------------
   DROP TABLE p160_temp
   CREATE TEMP TABLE p160_temp(
          occ01  LIKE occ_file.occ01,
          occ18  LIKE occ_file.occ18,
          sort   LIKE type_file.chr20,
          geo02  LIKE geo_file.geo02,
          occ261 LIKE occ_file.occ261,
          occ231 LIKE occ_file.occ231,
          occ61  LIKE occ_file.occ61)
#FUN-690009-------------------------------END-------------------------------------
   CREATE UNIQUE INDEX p160_temp_01 ON p160_temp(occ01);  #No.FUN-710056
 
   DECLARE occ_curs CURSOR FOR
   SELECT occ01,occ18,'',occ22,occ261,occ231,occ61
     FROM occ_file
   FOREACH occ_curs INTO sr3.*
      IF STATUS THEN
         CALL cl_err('foreach occ_curs:',STATUS,1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(sr3.geo02) THEN
         SELECT geo02 INTO sr3.geo02 FROM geo_file WHERE geo01 = sr3.geo02
      END IF
      INSERT INTO p160_temp VALUES (sr3.occ01,sr3.occ18,sr3.sort,sr3.geo02,
                                    sr3.occ261,sr3.occ231,sr3.occ61)
      IF STATUS THEN
#        CALL cl_err('ins p160_temp:',STATUS,1)                                                                                    #No.FUN-660124
         CALL cl_err3("ins","p160_temp","","",STATUS,"","",1)   #No.FUN-660124
         EXIT FOREACH
      END IF
   END FOREACH
 
   LET g_msg = g_x[175]                          #客戶
   UPDATE p160_temp SET sort = g_msg
   IF STATUS <> 0 THEN
#     CALL cl_err('upd p160_temp occ:',STATUS,1)      #No.FUN-660124
      CALL cl_err3("upd","p160_temp","","",STATUS,"","",1)   #No.FUN-660124
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE pmc_curs CURSOR FOR
      SELECT pmc01,pmc081,'',pmc908,pmc10,pmc091,pmc18
        FROM pmc_file
   START REPORT wldw_rep TO l_name1
   FOREACH pmc_curs INTO sr3.*
      IF STATUS THEN
         CALL cl_err('foreach p160_temp:',STATUS,1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(sr3.geo02) THEN
         SELECT geo02 INTO sr3.geo02 FROM geo_file WHERE geo01 = sr3.geo02
      END IF
      INSERT INTO p160_temp VALUES (sr3.occ01,sr3.occ18,sr3.sort,sr3.geo02,
                                    sr3.occ261,sr3.occ231,sr3.occ61)
      IF STATUS THEN
        #No.FUN-710056  --Begin      
        #IF STATUS = -239 THEN                        #TQC-790089 mark
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN      #TQC-790089 mod
            CONTINUE FOREACH
         ELSE
#           CALL cl_err('ins p160_temp:',STATUS,1)                                                                                        #No.FUN-660124
            CALL cl_err3("ins","p160_temp","","",STATUS,"","",1)   #No.FUN-660124
            EXIT FOREACH
         END IF
         #No.FUN-710056  --Begin
      END IF
   END FOREACH
 
   LET g_msg = g_x[174]                          #供應商
   UPDATE p160_temp SET sort = g_msg WHERE sort is null
   IF STATUS <> 0 THEN
#     CALL cl_err('upd p160_temp pmc:',STATUS,1)        #No.FUN-660124
      CALL cl_err3("upd","p160_temp","","",STATUS,"","",1)   #No.FUN-660124
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE occ_curs1 CURSOR FOR
      SELECT * FROM p160_temp ORDER BY occ01
   FOREACH occ_curs1 INTO sr3.*
      IF STATUS THEN
         CALL cl_err('foreach p160_temp:',STATUS,1)
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT wldw_rep(sr3.*)
   END FOREACH
 
   FINISH REPORT wldw_rep
   CALL p160_save(l_name1)
 
   #[6]匯出項目信息XMXX.TXT
   LET l_name1 = 'XMXX.TXT'
  #FUN-810045 begin
   #LET l_sql3 = "SELECT gja01, gja02 FROM gja_file ",
   #             " WHERE gjaacti = 'Y'",
   #             " ORDER BY gja01 "               #gja01項目編號,gja02項目名稱
   LET l_sql3 = "SELECT pja01, pja02 FROM pja_file ",
                " WHERE pjaacti = 'Y'",
                " ORDER BY pja01 "               #pja01項目編號,pja02項目名稱
  #FUN-810045 end
 
   PREPARE pja_p1 FROM l_sql3  #FUN-810045 gja->pja
   IF STATUS <> 0 THEN
      CALL cl_err('prepare pja:',STATUS,1) #FUN-810045 gja->pja
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE pja_curs1 CURSOR FOR pja_p1   #FUN-810045 gja->pja
   START REPORT xmxx_rep TO l_name1
 
   FOREACH pja_curs1 INTO sr4.*    #FUN-810045 gja->pja
      IF STATUS THEN
         CALL cl_err('foreach pja:',STATUS,1)   #FUN-810045 gja->pja
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT xmxx_rep(sr4.*)
   END FOREACH
 
   FINISH REPORT xmxx_rep
   CALL p160_save(l_name1)
 
   #[7]匯出人員信息RYXX.TXT
   LET l_name1 = 'RYXX.TXT'
   LET l_sql4 = "SELECT gen01, gen02 FROM gen_file ",
                " WHERE genacti = 'Y'",
                " ORDER BY gen01 "               #gen01人員編號,gen02人員姓名
 
   PREPARE gen_p1 FROM l_sql4
   IF STATUS <> 0 THEN
      CALL cl_err('prepare gen:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE gen_curs1 CURSOR FOR gen_p1
   START REPORT ryxx_rep TO l_name1
   FOREACH gen_curs1 INTO sr5.*
      IF STATUS THEN
         CALL cl_err('foreach gen:',STATUS,1)
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT ryxx_rep(sr5.*)
 
   END FOREACH
 
   FINISH REPORT ryxx_rep
   CALL p160_save(l_name1)
 
   #[8]科目余額及發生額KMYE.TXT
   IF tm.f = 'Y' THEN
      LET l_name1 = 'KMYE.TXT'
 
      DROP TABLE p160_temp2
#FUN-690009------------------------------begin------------------------------
#      CREATE TEMP TABLE p160_temp2(
#             tah01   VARCHAR(30),                   #科目編號
#             azi02   VARCHAR(20),                   #幣種名稱
#             ted02   VARCHAR(30),                   #異動碼VALUE
#             qcye    DEC(20,6),                  #期初余額
#             qcsl    INTEGER,                    #期初數量
#             qcwbye  DEC(20,6),                  #期初外幣余額
#             tah04   DEC(20,6),                  #借方發生額
#             tah06   INTEGER,                    #借方發生數量
#             tah09   DEC(20,6),                  #借方外幣發生額
#             tah05   DEC(20,6),                  #貸方發生額
#             tah07   INTEGER,                    #貸方發生數量
#             tah10   DEC(20,6),                  #貸方外幣發生額
#             qmye    DEC(20,6),                  #期末余額
#             qmsl    INTEGER,                    #期末數量
#             qmwbye  DEC(20,6),                  #期末外幣余額
# Prog. Version..: '5.30.06-13.03.12(02) )                  #期別
#FUN-690009-------------------------------END-------------------------------
#FUN-690009------------------------------begin------------------------------
      #No.FUN-710056  --Begin
      CREATE TEMP TABLE p160_temp2(
             tah01   LIKE aag_file.aag01,
             azi01   LIKE azi_file.azi01,
             azi02   LIKE azi_file.azi02,
             ted02   LIKE ted_file.ted02,
             qcye    LIKE tah_file.tah04,
             qcsl    LIKE tah_file.tah06,
             qcwbye  LIKE tah_file.tah04,
             tah04   LIKE tah_file.tah04,
             tah06   LIKE tah_file.tah06,
             tah09   LIKE tah_file.tah09,
             tah05   LIKE tah_file.tah05,
             tah07   LIKE tah_file.tah07,
             tah10   LIKE tah_file.tah10,
             qmye    LIKE tah_file.tah04,
             qmsl    LIKE tah_file.tah06,
             qmwbye  LIKE tah_file.tah04,
             tah03   LIKE tah_file.tah03)
#FUN-690009-------------------------------END-------------------------------
      IF g_aaz.aaz83 = 'Y' THEN
         LET l_sql5 = "SELECT UNIQUE aag01,aag06,aag07,tah08 ",
                      "  FROM aag_file LEFT OUTER JOIN tah_file ON aag_file.aag00=tah_file.tah00 AND aag_file.aag01=tah_file.tah01",
                      "   WHERE aag00='",tm.bookno,"'"  #No.FUN-730070
      ELSE
         LET l_sql5 = "SELECT UNIQUE aag01,aag06,aag07,'' ",
                      "  FROM aag_file",
                      " WHERE aag00='",tm.bookno,"'"  #No.FUN-730070
      END IF
      PREPARE aag1_p1 FROM l_sql5
      IF STATUS <> 0 THEN
         CALL cl_err('prepare aag:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE aag1_curs1 CURSOR FOR aag1_p1
      FOREACH aag1_curs1 INTO l_aag01,l_aag06,l_aag07,l_tah08
         IF STATUS THEN
            CALL cl_err('foreach aag:',STATUS,1)
            EXIT FOREACH
         END IF
         #虛科目不要出來
         IF l_aag01 = '3131-IS' OR l_aag01 ='3135-IS' OR l_aag01 = '3135' THEN
            CONTINUE FOREACH
         END IF
#        IF l_aag01 = g_aaz.aaz31 OR l_aag01 = g_aaz.aaz32 THEN  #FUN-BC0027
         IF l_aag01 = g_aaa.aaa14 OR l_aag01 = g_aaa.aaa15 THEN  #FUN-BC0027
            CONTINUE FOREACH
         END IF
         INITIALIZE sr6.* TO NULL
         LET sr6.tah01 = l_aag01
         LET sr6.tah03 = tm.mon
         IF NOT cl_null(l_tah08) THEN
            SELECT azi02 INTO sr6.azi02 FROM azi_file WHERE azi01 = l_tah08
         ELSE
            SELECT azi02 INTO sr6.azi02 FROM azi_file WHERE azi01 = g_aaa03
         END IF
 
         IF g_aaz.aaz83 = 'Y' THEN
            #qcye
            SELECT SUM(tah04-tah05),SUM(tah06+tah07),SUM(tah09-tah10)
              INTO sr6.qcye,sr6.qcsl,sr6.qcwbye
              FROM tah_file
             WHERE tah00 = tm.bookno             #賬套  #No.FUN-730070
               AND tah01 = sr6.tah01             #科目編號
               AND tah02 = tm.year               #年度
               AND tah03 < tm.mon                #期別
               AND tah08 = l_tah08               #幣別
            #dqyd
            SELECT SUM(tah04),SUM(tah06),SUM(tah09),
                   SUM(tah05),SUM(tah07),SUM(tah10)
              INTO sr6.tah04,sr6.tah06,sr6.tah09,
                   sr6.tah05,sr6.tah07,sr6.tah10
              FROM tah_file
             WHERE tah00 = tm.bookno             #賬套  #No.FUN-730070
               AND tah01 = sr6.tah01             #科目編號
               AND tah02 = tm.year               #年度
               AND tah03 = tm.mon                #期別
               AND tah08 = l_tah08               #幣別
         ELSE
            #qcye
            SELECT SUM(aah04-aah05),SUM(aah06+aah07),0
              INTO sr6.qcye,sr6.qcsl,sr6.qcwbye
              FROM aah_file
             WHERE aah00 = tm.bookno             #賬套  #No.FUN-730070
               AND aah01 = sr6.tah01             #科目編號
               AND aah02 = tm.year               #年度
               AND aah03 < tm.mon                #期別
            #dqyd
            SELECT SUM(aah04),SUM(aah06),0,
                   SUM(aah05),SUM(aah07),0
              INTO sr6.tah04,sr6.tah06,sr6.tah09,
                   sr6.tah05,sr6.tah07,sr6.tah10
              FROM aah_file
             WHERE aah00 = tm.bookno             #賬套  #No.FUN-730070
               AND aah01 = sr6.tah01             #科目編號
               AND aah02 = tm.year               #年度
               AND aah03 = tm.mon                #期別
         END IF
         #qcye
         IF cl_null(sr6.qcye)   THEN LET sr6.qcye = 0   END IF
         IF cl_null(sr6.qcsl)   THEN LET sr6.qcsl = 0   END IF
         IF cl_null(sr6.qcwbye) THEN LET sr6.qcwbye = 0 END IF
         IF l_aag06 = '2' THEN
            LET sr6.qcye   = sr6.qcye   * -1
            LET sr6.qcwbye = sr6.qcwbye * -1
         END IF
         #dqyd
         IF cl_null(sr6.tah04) THEN LET sr6.tah04 = 0 END IF
         IF cl_null(sr6.tah06) THEN LET sr6.tah06 = 0 END IF
         IF cl_null(sr6.tah09) THEN LET sr6.tah09 = 0 END IF
         IF cl_null(sr6.tah05) THEN LET sr6.tah05 = 0 END IF
         IF cl_null(sr6.tah07) THEN LET sr6.tah07 = 0 END IF
         IF cl_null(sr6.tah10) THEN LET sr6.tah10 = 0 END IF
         #qmye
         IF l_aag06 = '2' THEN
            LET sr6.qmye   = sr6.qcye  -sr6.tah04+sr6.tah05
            LET sr6.qmsl   = sr6.qcsl  +sr6.tah06+sr6.tah07
            LET sr6.qmwbye = sr6.qcwbye-sr6.tah09+sr6.tah10
         ELSE
            LET sr6.qmye   = sr6.qcye  +sr6.tah04-sr6.tah05
            LET sr6.qmsl   = sr6.qcsl  +sr6.tah06+sr6.tah07
            LET sr6.qmwbye = sr6.qcwbye+sr6.tah09-sr6.tah10
         END IF
         IF cl_null(sr6.qmye)   THEN LET sr6.qmye = 0   END IF
         IF cl_null(sr6.qmsl)   THEN LET sr6.qmsl = 0   END IF
         IF cl_null(sr6.qmwbye) THEN LET sr6.qmwbye = 0 END IF
 
         IF l_tah08 = g_aaa03 THEN
            LET sr6.qcwbye = 0
            LET sr6.tah09  = 0
            LET sr6.tah10  = 0
            LET sr6.qmwbye = 0
         END IF
         INSERT INTO p160_temp2 VALUES (sr6.tah01,l_tah08,sr6.azi02,'',sr6.qcye,
                                        sr6.qcsl,sr6.qcwbye,sr6.tah04,sr6.tah06,
                                        sr6.tah09,sr6.tah05,sr6.tah07,sr6.tah10,
                                        sr6.qmye,sr6.qmsl,sr6.qmwbye,sr6.tah03)
      END FOREACH
 
      #一個科目僅能有一種幣種異動,若出現兩者或兩者以上,則全部用"記帳本位幣"反映
      DECLARE kmye_curs CURSOR FOR
       SELECT UNIQUE tah01
         FROM p160_temp2
        ORDER BY tah01
      START REPORT kmye_rep TO l_name1
      FOREACH kmye_curs INTO l_tah01
         IF STATUS THEN
            CALL cl_err('foreach p160_temp2:',STATUS,1)
            EXIT FOREACH
         END IF
         INITIALIZE sr6.* TO NULL
         SELECT COUNT(*) INTO l_n FROM p160_temp2
          WHERE tah01=l_tah01
         IF l_n = 1 THEN
            SELECT tah01,azi02,ted02,qcye,qcsl,qcwbye,
                   tah04,tah06,tah09,tah05,tah07,tah10,
                   qmye,qmsl,qmwbye,tah03
             INTO sr6.*
             FROM p160_temp2
            WHERE tah01=l_tah01
         ELSE
            LET sr6.tah01=l_tah01
            SELECT azi02 INTO sr6.azi02 FROM azi_file WHERE azi01 = g_aaa03
            LET sr6.tah03=tm.mon
            SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01=l_tah01
                                       AND aag00 = tm.bookno  #No.FUN-730070
 
            #qcye
            SELECT SUM(aah04-aah05),SUM(aah06+aah07),0
              INTO sr6.qcye,sr6.qcsl,sr6.qcwbye
              FROM aah_file
             WHERE aah00 = tm.bookno             #賬套  #No.FUN-730070
               AND aah01 = sr6.tah01             #科目編號
               AND aah02 = tm.year               #年度
               AND aah03 < tm.mon                #期別
            IF cl_null(sr6.qcye)   THEN LET sr6.qcye = 0   END IF
            IF cl_null(sr6.qcsl)   THEN LET sr6.qcsl = 0   END IF
            IF cl_null(sr6.qcwbye) THEN LET sr6.qcwbye = 0 END IF
            IF l_aag06 = '2' THEN
               LET sr6.qcye   = sr6.qcye   * -1
               LET sr6.qcwbye = sr6.qcwbye * -1
            END IF
            #dqyd
            SELECT SUM(aah04),SUM(aah06),0,
                   SUM(aah05),SUM(aah07),0
              INTO sr6.tah04,sr6.tah06,sr6.tah09,
                   sr6.tah05,sr6.tah07,sr6.tah10
              FROM aah_file
             WHERE aah00 = tm.bookno             #賬套  #No.FUN-730070
               AND aah01 = l_tah01               #科目編號
               AND aah02 = tm.year               #年度
               AND aah03 = tm.mon                #期別
            IF cl_null(sr6.tah04) THEN LET sr6.tah04 = 0 END IF
            IF cl_null(sr6.tah06) THEN LET sr6.tah06 = 0 END IF
            IF cl_null(sr6.tah09) THEN LET sr6.tah09 = 0 END IF
            IF cl_null(sr6.tah05) THEN LET sr6.tah05 = 0 END IF
            IF cl_null(sr6.tah07) THEN LET sr6.tah07 = 0 END IF
            IF cl_null(sr6.tah10) THEN LET sr6.tah10 = 0 END IF
            #qmye
            IF l_aag06 = '2' THEN
               LET sr6.qmye   = sr6.qcye  -sr6.tah04+sr6.tah05
               LET sr6.qmsl   = sr6.qcsl  +sr6.tah06+sr6.tah07
               LET sr6.qmwbye = sr6.qcwbye-sr6.tah09+sr6.tah10
            ELSE
               LET sr6.qmye   = sr6.qcye  +sr6.tah04-sr6.tah05
               LET sr6.qmsl   = sr6.qcsl  +sr6.tah06+sr6.tah07
               LET sr6.qmwbye = sr6.qcwbye+sr6.tah09-sr6.tah10
            END IF
            IF cl_null(sr6.qmye)   THEN LET sr6.qmye = 0   END IF
            IF cl_null(sr6.qmsl)   THEN LET sr6.qmsl = 0   END IF
            IF cl_null(sr6.qmwbye) THEN LET sr6.qmwbye = 0 END IF
 
            LET sr6.qcwbye = 0
            LET sr6.tah09  = 0
            LET sr6.tah10  = 0 #carrier
            LET sr6.qmwbye = 0
         END IF
         OUTPUT TO REPORT kmye_rep(sr6.*)
      END FOREACH
      #No.FUN-710056  --Begin
 
      FINISH REPORT kmye_rep
      CALL p160_save(l_name1)
   END IF
 
   #[9]匯出記賬憑証JZPZ.TXT
   IF tm.e = 'Y' THEN
      #No.FUN-710056  --Begin
      DROP TABLE p160_jzpz2;
      CREATE TEMP TABLE p160_jzpz2(
                       aba02   LIKE aba_file.aba02, #憑証日期
                       aac02   LIKE aac_file.aac02, #單別名稱(憑証種類）
                       aba11   LIKE aba_file.aba11, #總號  #No.FUN-710056
                       abb02   LIKE abb_file.abb02, #項次
                       abb04   LIKE abb_file.abb04, #摘要
                       abb03   LIKE abb_file.abb03, #科目編號
                       abb07a  LIKE abb_file.abb07, #借方金額
                       abb07b  LIKE abb_file.abb07, #貸方金額
                       azi02   LIKE azi_file.azi02, #幣種說明
                       abb07fa LIKE abb_file.abb07f,#借方外幣金額
                       abb07fb LIKE abb_file.abb07f,#貸方外幣金額
                       abb25   LIKE abb_file.abb25, #匯率
                       abb41   LIKE abb_file.abb41, #數量
                       abb42   LIKE abb_file.abb42, #單價
                       desc1   LIKE zaa_file.zaa08, #核算項1234
                       aba31   LIKE aba_file.aba31, #結算方式
                       aba32   LIKE aba_file.aba32, #票據類型
                       aba33   LIKE aba_file.aba33, #票據號
                       aba34   LIKE aba_file.aba34, #票據日期
                       aba21   LIKE aba_file.aba21, #附件張數
                       abauser LIKE aba_file.abauser,    #錄入人員
                       aba37   LIKE aba_file.aba37,      #審核人員
                       aba38   LIKE aba_file.aba38,      #記賬人員
                       aba36   LIKE aba_file.aba36,      #出納人員
                       abapost LIKE aba_file.abapost,    #過賬碼
                       abaacti LIKE aba_file.abaacti);   #資料有效碼
 
      LET l_name1 = 'JZPZ.TXT'
      LET l_sql6 = "SELECT aba02,'',aba11,abb02,abb04,abb03,'','','','','',",  #No.FUN-710056
                   "       abb25,abb41,abb42,'',aba31,aba32,aba33,aba34,aba21,",
                   "       abauser,aba37,aba38,aba36,abapost,abaacti,abb06,",
                   "       abb07,abb07f,abb24,abb11,abb12,abb13,abb14,aba01 ",
                   "  FROM aba_file,abb_file ",
                   " WHERE aba01 = abb01 AND aba00 = '",tm.bookno,"'", #No.FUN-730070
                   "   AND aba03 = ",tm.year,
                   "   AND aba04 = ",tm.mon,
                   "   AND abapost = 'Y'",
                   "   AND aba01 NOT LIKE '",g_aaz.aaz65,"%'",
                   " ORDER BY aba02,aba01,abb02 "
 
      PREPARE aba_p1 FROM l_sql6
      IF STATUS <> 0 THEN
         CALL cl_err('prepare aba:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE aba_curs1 CURSOR FOR aba_p1
 
      FOREACH aba_curs1 INTO sr8.*,l_abb06,l_abb07,l_abb07f,l_abb24,l_abb11,
                             l_abb12,l_abb13,l_abb14,l_aba01
         IF STATUS THEN
            CALL cl_err('foreach aba:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET l_t1 = s_get_doc_no(l_aba01)
         SELECT aac02 INTO sr8.aac02 FROM aac_file WHERE aac01 = l_t1
 
         IF STATUS <> 0 THEN
#           CALL cl_err('sel aac:',STATUS,0)                                                                                        #No.FUN-660124
            CALL cl_err3("sel","aac_file",l_t1,"",STATUS,"","sel aac:",0)   #No.FUN-660124
         END IF
 
         LET sr8.abb07b = 0
         LET sr8.abb07fb= 0
         LET sr8.abb07a = 0
         LET sr8.abb07fa= 0
 
         IF l_abb06 = '1' THEN
            LET sr8.abb07a = l_abb07
            IF l_abb24 <> g_aaa03 THEN
               LET sr8.abb07fa= l_abb07f
            END IF
         END IF
         IF l_abb06 = '2' THEN
            LET sr8.abb07b = l_abb07
            IF l_abb24 <> g_aaa03 THEN
               LET sr8.abb07fb= l_abb07f
            END IF
         END IF
 
         IF NOT cl_null(l_abb24) THEN
            SELECT azi02 INTO sr8.azi02 FROM azi_file WHERE azi01 = l_abb24
         END IF
 
         IF cl_null(sr8.aba21) THEN
            LET sr8.aba21 = '0'
         END IF
 
         IF sr8.abapost = 'Y' THEN
            LET sr8.abapost = '1'
         ELSE
            LET sr8.abapost = '0'
         END IF
 
         IF sr8.abaacti = 'Y' THEN
            LET sr8.abaacti = '0'
         ELSE
            LET sr8.abaacti = '1'
         END IF
 
         INSERT INTO p160_jzpz2 VALUES(sr8.*)
 
      END FOREACH
      START REPORT jzpz_rep TO l_name1
      DECLARE jzpz_curs CURSOR FOR
         SELECT * FROM p160_jzpz2
         ORDER BY aba02,aba11,abb02
      FOREACH jzpz_curs INTO sr8.*
         IF STATUS THEN
            CALL cl_err('foreach p160_temp2:',STATUS,1)
            EXIT FOREACH
         END IF
         SELECT COUNT(UNIQUE tah08) INTO l_n FROM tah_file
          WHERE tah01=sr8.abb03
            AND tah00=tm.bookno  #No.FUN-730070
         IF l_n > 1 THEN
            SELECT azi02 INTO sr8.azi02 FROM azi_file WHERE azi01=g_aaa03
            LET sr8.abb07fa=0
            LET sr8.abb07fb=0
            LET sr8.abb25=1
         END IF
         OUTPUT TO REPORT jzpz_rep(sr8.*)
      END FOREACH
      #No.FUN-710056  --End
      FINISH REPORT jzpz_rep
      CALL p160_save(l_name1)
   END IF
 
   #add by ice 06/04/03
   IF tm.g = 'Y' THEN  #企業資產負債表
      LET l_name1 = 'Q_ZCFZB.TXT'
      LET g_msg = "gglr116 '1' '",tm.gg,"' ",tm.year," ",tm.mon," ",tm.mon," '",l_name1,"' '",tm.bookno,"'"  #No.FUN-710056   #No.FUN-730070
      CALL cl_cmdrun(g_msg)
      CALL p160_save(l_name1)
   END IF
   IF tm.h = 'Y' THEN  #利潤表
      LET l_name1 = 'Q_LRB.TXT'
      LET g_msg = "gglr116 '2' '",tm.hh,"' ",tm.year," ",tm.mon," ",tm.mon," '",l_name1,"' '",tm.bookno,"'"  #No.FUN-710056  #No.FUN-730070
      CALL cl_cmdrun(g_msg)
      CALL p160_save(l_name1)
   END IF
   IF tm.i = 'Y' THEN  #現金流量表
      LET l_name2 = 'Q_XJLLB_1.TXT'     #直接法
      #No.FUN-710056  --Begin
      #LET g_msg = "gnmr940 '' '' '' '' '' '' '' '",tm.year,"' '",tm.mon,"' '",l_name2,"' "
      LET g_msg = "gnmr940 '' '' '' '' '' '' '' '",l_name2,"' ",tm.year," ",tm.year," ",tm.mon," ",tm.mon," '",tm.bookno,"'"  #No.FUN-730070
      CALL cl_cmdrun_wait(g_msg)
      LET l_name3 = 'Q_XJLLB_2.TXT'     #間接法
     #LET g_msg = "aglr940 '' '' '' '' '' '' '' ",tm.year," ",tm.mon," '",l_name3,"' '",tm.bookno,"'"  #No.FUN-710056  #No.FUN-730070  #FUN-C30085
      LET g_msg = "aglg940 '' '' '' '' '' '' '' ",tm.year," ",tm.mon," '",l_name3,"' '",tm.bookno,"'"  #No.FUN-710056  #No.FUN-730070  #FUN-C30085 
      CALL cl_cmdrun_wait(g_msg)
      #No.FUN-710056  --End
      LET l_name1 = fgl_getenv("TEMPDIR")
      LET l_name2 = l_name1,"/",l_name2
      LET l_name3 = l_name1,"/",l_name3
      LET l_name1 = l_name1,'/Q_XJLLB.TXT'
      #No.FUN-710056  --Begin
      LET ls_cmd='sed "/^ *$/d" ',l_name2 CLIPPED,">",l_name1 CLIPPED
      RUN ls_cmd
      LET ls_cmd="mv ",l_name1 CLIPPED," ",l_name2 CLIPPED
      RUN ls_cmd
      LET ls_cmd='sed "/^ *$/d" ',l_name3 CLIPPED,">",l_name1 CLIPPED
      RUN ls_cmd
      LET ls_cmd="mv ",l_name1 CLIPPED," ",l_name3 CLIPPED
      RUN ls_cmd
      #No.FUN-710056  --End
      LET ls_cmd= "cat ",l_name2 CLIPPED,
                     " ",l_name3 CLIPPED,
                   " > ",l_name1 CLIPPED
      RUN ls_cmd
      LET l_name1 = 'Q_XJLLB.TXT'
      CALL p160_save(l_name1)
   END IF
   IF tm.j = 'Y' THEN  #應交增值稅明細表
      LET l_name1 = 'Q_YJZZSMXB.TXT'
      LET g_msg = "gglr116 '4' '",tm.jj,"' ",tm.year," ",tm.mon," ",tm.mon," '",l_name1,"' '",tm.bookno,"'"  #No.FUN-710056  #No.FUN-730070
      CALL cl_cmdrun(g_msg)
      CALL p160_save(l_name1)
   END IF
   IF tm.k = 'Y' THEN  #資產減值准備明細表
      LET l_name1 = 'Q_ZCJZZBMXB.TXT'
      LET g_msg = "gglr116 '5' '",tm.kk,"' ",tm.year," ",tm.mon," ",tm.mon," '",l_name1,"' '",tm.bookno,"'"  #No.FUN-710056  #No.FUN-730070
      CALL cl_cmdrun(g_msg)
      CALL p160_save(l_name1)
   END IF
   IF tm.l = 'Y' THEN  #股東權益增減變動表
      LET l_name1 = 'Q_GDQYZJBDB.TXT'
      LET g_msg = "gglr116 '6' '",tm.ll,"' ",tm.year," ",tm.mon," ",tm.mon," '",l_name1,"' '",tm.bookno,"'"  #No.FUN-710056  #No.FUN-730070
      CALL cl_cmdrun(g_msg)
      CALL p160_save(l_name1)
   END IF
   IF tm.m = 'Y' THEN  #利潤分配表
      LET l_name1 = 'Q_LRFPB.TXT'
      LET g_msg = "gglr116 '7' '",tm.mm,"' ",tm.year," ",tm.mon," ",tm.mon," '",l_name1,"' '",tm.bookno,"'"  #No.FUN-710056  #No.FUN-730070
      CALL cl_cmdrun(g_msg)
      CALL p160_save(l_name1)
   END IF
   #end add
 
END FUNCTION
 
FUNCTION p160_save(l_name1)                     #將匯出資料從主機復制到客戶端
   DEFINE l_name1  LIKE type_file.chr20,        #NO.FUN-690009   VARCHAR(60)
          l_dir1   LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(300)
          l_dir2   LIKE type_file.chr1000,      #NO.FUN-690009   VARCHAR(300)
          l_n      LIKE type_file.num5          #NO.FUN-690009   SMALLINT
 
   LET l_dir1 = FGL_GETENV("TEMPDIR") CLIPPED,'\/',l_name1
   #No.MOD-C20097  --Begin
   LET g_sql = "sed 's: ::g' ",l_dir1,"|sed '/^ *$/d'>tmp1.tmp"
   RUN g_sql
   LET g_sql = "mv tmp1.tmp ",l_dir1  
   RUN g_sql
   #No.MOD-C20097  --End  
 
   LET l_n = LENGTH(tm.path)
   IF l_n>0 THEN
      IF tm.path[l_n,l_n] = '/' THEN
         LET tm.path[l_n,l_n] = ' '
      END IF
   END IF
 
   LET l_dir2 = tm.path CLIPPED,'\/',l_name1
 
   IF NOT cl_download_file(l_dir1 CLIPPED,l_dir2 CLIPPED) THEN
      CALL cl_err(l_name1,'ggl-003',1)
      RETURN
   END IF
END FUNCTION
 
FUNCTION p160_gen02(p_gen01)                     #根據人員編號取人員名稱
 
  DEFINE  p_gen01   LIKE gen_file.gen01,
          l_gen02   LIKE gen_file.gen02
 
  SELECT gen02 INTO l_gen02 FROM gen_file
   WHERE gen01 = p_gen01
  RETURN l_gen02
 
END FUNCTION
 
REPORT gssm_rep()                                #格式說明文件
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   FORMAT
   #PAGE HEADER
   ON EVERY ROW
   PRINT g_x[1]   PRINT g_x[2]   PRINT g_x[3]   PRINT g_x[4]   PRINT g_x[5]
   PRINT g_x[6]   PRINT g_x[7]   PRINT g_x[8]   PRINT g_x[9]   PRINT g_x[10]
   PRINT g_x[11]  PRINT g_x[12]  PRINT g_x[13]
   PRINT
   PRINT g_x[14]  PRINT g_x[15]  PRINT g_x[16]  PRINT g_x[17]  PRINT g_x[18]
   PRINT g_x[19]  PRINT g_x[20]  PRINT g_x[21]  PRINT g_x[22]  PRINT g_x[23]
   PRINT
   PRINT g_x[24]  PRINT g_x[25]  PRINT g_x[26]  PRINT g_x[27]  PRINT g_x[28]
   PRINT
   PRINT g_x[29]  PRINT g_x[30]  PRINT g_x[31]  PRINT g_x[32]
   PRINT
   PRINT g_x[33]  PRINT g_x[34]  PRINT g_x[35]  PRINT g_x[36]  PRINT g_x[37]
   PRINT g_x[38]  PRINT g_x[39]  PRINT g_x[40]  PRINT g_x[41]
   PRINT
   PRINT g_x[42]  PRINT g_x[43]  PRINT g_x[44]  PRINT g_x[45]
   PRINT
   PRINT g_x[46]  PRINT g_x[47]  PRINT g_x[48]  PRINT g_x[49]
   PRINT
   PRINT g_x[50]  PRINT g_x[51]  PRINT g_x[52]  PRINT g_x[53]  PRINT g_x[54]
   PRINT g_x[55]  PRINT g_x[56]  PRINT g_x[57]  PRINT g_x[58]  PRINT g_x[59]
   PRINT g_x[60]  PRINT g_x[61]  PRINT g_x[62]  PRINT g_x[63]  PRINT g_x[64]
   PRINT g_x[65]  PRINT g_x[66]  PRINT g_x[67]
   PRINT
   PRINT g_x[68]  PRINT g_x[69]  PRINT g_x[70]  PRINT g_x[71]  PRINT g_x[72]
   PRINT g_x[73]  PRINT g_x[74]  PRINT g_x[75]  PRINT g_x[76]  PRINT g_x[77]
   PRINT g_x[78]  PRINT g_x[79]  PRINT g_x[80]  PRINT g_x[81]  PRINT g_x[82]
   PRINT g_x[83]  PRINT g_x[84]  PRINT g_x[85]  PRINT g_x[86]  PRINT g_x[87]
   PRINT g_x[88]  PRINT g_x[89]  PRINT g_x[90]  PRINT g_x[91]  PRINT g_x[92]
   PRINT g_x[93]  PRINT g_x[94]  PRINT g_x[95]
   PRINT
   PRINT g_x[96]  PRINT g_x[97]  PRINT g_x[98]  PRINT g_x[99]  PRINT g_x[100]
   PRINT g_x[101] PRINT g_x[102] PRINT g_x[103] PRINT g_x[104] PRINT g_x[105]
   PRINT
   PRINT g_x[106] PRINT g_x[107] PRINT g_x[108] PRINT g_x[109] PRINT g_x[110]
   PRINT g_x[111] PRINT g_x[112] PRINT g_x[113] PRINT g_x[114] PRINT g_x[115]
   PRINT
   PRINT g_x[116] PRINT g_x[117] PRINT g_x[118] PRINT g_x[119] PRINT g_x[120]
   PRINT g_x[121] PRINT g_x[122] PRINT g_x[123] PRINT g_x[124]
   PRINT
   PRINT g_x[125] PRINT g_x[126] PRINT g_x[127] PRINT g_x[128] PRINT g_x[129]
   PRINT g_x[130] PRINT g_x[131] PRINT g_x[132] PRINT g_x[133] PRINT g_x[134]
   PRINT
   PRINT g_x[135] PRINT g_x[136] PRINT g_x[137] PRINT g_x[138] PRINT g_x[139]
   PRINT g_x[140] PRINT g_x[141] PRINT g_x[142] PRINT g_x[143] PRINT g_x[144]
   PRINT g_x[145]
   PRINT
   PRINT g_x[146] PRINT g_x[147] PRINT g_x[148] PRINT g_x[149] PRINT g_x[150]
   PRINT g_x[151] PRINT g_x[152] PRINT g_x[153] PRINT g_x[154] PRINT g_x[155]
   PRINT
   PRINT g_x[156] PRINT g_x[157] PRINT g_x[158] PRINT g_x[159] PRINT g_x[160]
   PRINT g_x[161] PRINT g_x[162] PRINT g_x[163] PRINT g_x[164] PRINT g_x[165]
   PRINT
END REPORT
 
REPORT dzzb_rep()                                #電子賬簿
   DEFINE l_aaf03  LIKE aaf_file.aaf03,          #帳套名稱
          l_zo02   LIKE zo_file.zo02,            #公司對內全名
          l_aag01  LIKE aag_file.aag01,          #科目編號
          l_maxlen LIKE type_file.num5,          #NO.FUN-690009   SMALLINT      #科目編號最大長度
          l_form   LIKE type_file.chr20          #NO.FUN-690009   VARCHAR(20)      #科目結構
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   FORMAT
   PAGE HEADER
 
   SELECT aaf03 INTO l_aaf03 FROM aaf_file
    WHERE aaf01 = tm.bookno AND aaf02=g_lang  #No.FUN-730070
 
   SELECT zo02 INTO l_zo02 FROM zo_file
    WHERE zo01 = g_lang
 
   SELECT aaa03 INTO g_aaa03 FROM aaa_file
    WHERE aaa01 = tm.bookno  #No.FUN-730070
 
   SELECT azi02 INTO g_azi02                     #本位幣名稱
     FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#      CALL cl_err('sel azi02','',1)    #No.FUN-660124
       CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi02",1)   #No.FUN-660124
    END IF
   IF tm.p = '1' THEN                            #1企業單位 2事業單位
      LET g_msg = g_x[170]
   ELSE
      LET g_msg = g_x[171]
   END IF
 
   LET l_maxlen = 0
   DECLARE aag_curs CURSOR FOR
   SELECT aag01 FROM aag_file
    WHERE aag00 = tm.bookno  #No.FUN-730070
   FOREACH aag_curs INTO l_aag01
      IF STATUS THEN
         CALL cl_err('foreach aag_curs:',STATUS,1)
         EXIT FOREACH
      END IF
      IF LENGTH(l_aag01) > l_maxlen THEN
         LET l_maxlen = LENGTH(l_aag01)
      END IF
   END FOREACH
 
   LET l_form = tm.level1
   IF l_maxlen-tm.level1>0 THEN
      LET l_form = l_form,g_x[169],tm.level2
      IF l_maxlen-tm.level1-tm.level2>0 THEN
         LET l_form = l_form,g_x[169],tm.level3
         IF l_maxlen-tm.level1-tm.level2-tm.level3>0 THEN
            LET l_form = l_form,g_x[169],tm.level4
            IF l_maxlen-tm.level1-tm.level2-tm.level3-tm.level4>0 THEN
               LET l_form = l_form,g_x[169],tm.level5
               IF l_maxlen-tm.level1-tm.level2-tm.level3-tm.level4-tm.level5>0 THEN
                  LET l_form = l_form,g_x[169],tm.level6
               END IF
            END IF
         END IF
      END IF
   END IF
 
   PRINT g_x[166],tm.bookno CLIPPED,  #No.FUN-730070
         g_x[167],l_aaf03  CLIPPED,
         g_x[167],l_zo02   CLIPPED,
         g_x[167],tm.a     CLIPPED,
         g_x[167],g_msg    CLIPPED,
         g_x[167],tm.w     CLIPPED,
         g_x[167],g_x[168] CLIPPED,
         g_x[167],tm.v     CLIPPED,
         g_x[167],tm.year  CLIPPED,
         g_x[167],g_azi02  CLIPPED,
         g_x[167],l_form   CLIPPED,
         g_x[166]
END REPORT
 
REPORT kjkm_rep(sr)                              #會計科目
   DEFINE sr      RECORD
                  aag01   LIKE aag_file.aag01,   #科目編號
                  aag02   LIKE aag_file.aag13,   #科目名稱  #No.FUN-710056
                  level   LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01)         #科目層級
                  sign    LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01)         #輔助核算標志
                  desc    LIKE abb_file.abb12,   #NO.FUN-690009   VARCHAR(60)         #輔助核算項
                  kind    LIKE type_file.chr1000,#NO.FUN-690009   VARCHAR(50)         #科目類型
                  unit    LIKE aag_file.aag12,   #NO.FUN-690009   VARCHAR(10)         #計量單位
                  msg     LIKE aag_file.aag10    #NO.FUN-690009   VARCHAR(10)         #余額方向
                  END RECORD
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.aag01
   FORMAT
   PAGE HEADER
 
   ON EVERY ROW
      PRINT g_x[166],sr.aag01  CLIPPED,
            g_x[167],sr.aag02  CLIPPED,
            g_x[181],sr.level  CLIPPED,
            g_x[182],sr.sign   CLIPPED,
            g_x[167],sr.desc   CLIPPED,
            g_x[167],sr.kind   CLIPPED,
            g_x[167],sr.unit   CLIPPED,
            g_x[167],sr.msg    CLIPPED,
            g_x[166]
END REPORT
 
REPORT bmxx_rep(sr)                              #部門信息
   DEFINE sr      RECORD
                  gem01   LIKE  gem_file.gem01,  #部門編號
                  gem02   LIKE  gem_file.gem02   #部門簡稱
                  END RECORD
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.gem01
   FORMAT
   PAGE HEADER
 
   ON EVERY ROW
      PRINT g_x[166],sr.gem01  CLIPPED,
            g_x[167],sr.gem02  CLIPPED,
            g_x[166]
END REPORT
 
REPORT xmxx_rep(sr)                              #項目信息
   DEFINE sr      RECORD
            #FUN-810045 begin
                #  gja01   LIKE  gja_file.gja01,  #項目編號
                #  gja02   LIKE  gja_file.gja02   #項目名稱
                  pja01   LIKE  pja_file.pja01,  #項目編號
                  pja02   LIKE  pja_file.pja02   #項目名稱
            #FUN-810045 end
                  END RECORD
 
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.pja01   #FUN-810045 gja->pja
   FORMAT
   PAGE HEADER
   ON EVERY ROW
      PRINT g_x[166],sr.pja01  CLIPPED,  #FUN-810045 gja->pja
            g_x[167],sr.pja02  CLIPPED,  #FUN-810045 gja->pja
            g_x[166]
END REPORT
 
REPORT ryxx_rep(sr)                              #人員信息
   DEFINE sr      RECORD
                  gen01   LIKE  gen_file.gen01,  #人員編號
                  gen02   LIKE  gen_file.gen02   #人員姓名
                  END RECORD
 
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.gen01
   FORMAT
   PAGE HEADER
   ON EVERY ROW
      PRINT g_x[166],sr.gen01  CLIPPED,
            g_x[167],sr.gen02  CLIPPED,
            g_x[166]
END REPORT
 
REPORT wldw_rep(sr)                              #部門信息
   DEFINE sr      RECORD
                  occ01  LIKE occ_file.occ01,    #NO.FUN-690009   VARCHAR(30)        #單位編號
                  occ18  LIKE occ_file.occ18,    #NO.FUN-690009   VARCHAR(80)        #單位名稱
                  sort   LIKE type_file.chr20,   #NO.FUN-690009   VARCHAR(20)        #類別
                  geo02  LIKE geo_file.geo02,    #NO.FUN-690009   VARCHAR(40)        #地區
                  occ261 LIKE occ_file.occ261,   #NO.FUN-690009   VARCHAR(20)        #電話  #No.FUN-710056
                  occ231 LIKE occ_file.occ231,   #NO.FUN-690009   VARCHAR(255)       #地址
                  occ61  LIKE occ_file.occ61     #NO.FUN-690009   VARCHAR(10)        #信用等級
                  END RECORD
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.occ01
   FORMAT
   PAGE HEADER
   ON EVERY ROW
      PRINT g_x[166],sr.occ01  CLIPPED,
            g_x[167],sr.occ18  CLIPPED,
            g_x[167],sr.sort   CLIPPED,
            g_x[167],sr.geo02  CLIPPED,
            g_x[167],sr.occ261 CLIPPED,
            g_x[167],sr.occ231 CLIPPED,
            g_x[167],sr.occ61  CLIPPED,
            g_x[166] CLIPPED
END REPORT
 
REPORT kmye_rep(sr)                              #科目余額信息
   DEFINE sr      RECORD
                  tah01   LIKE tah_file.tah01,   #科目編號
                  azi02   LIKE azi_file.azi02,   #幣種名稱
                  ted02   LIKE ted_file.ted02,   #異動碼VALUE
                  qcye    LIKE tah_file.tah04,   #期初余額
                  qcsl    LIKE tah_file.tah06,   #期初數量     #No.FUN-710056
                  qcwbye  LIKE tah_file.tah09,   #期初外幣余額
                  tah04   LIKE tah_file.tah04,   #借方發生額
                  tah06   LIKE tah_file.tah06,   #借方發生數量
                  tah09   LIKE tah_file.tah09,   #借方外幣發生額
                  tah05   LIKE tah_file.tah05,   #貸方發生額
                  tah07   LIKE tah_file.tah07,   #貸方發生數量
                  tah10   LIKE tah_file.tah10,   #貸方外幣發生額
                  qmye    LIKE tah_file.tah04,   #期末余額
                  qmsl    LIKE tah_file.tah06,   #期末數量     #No.FUN-710056
                  qmwbye  LIKE tah_file.tah09,   #期末外幣余額
                  tah03   LIKE tah_file.tah03    # Prog. Version..: '5.30.06-13.03.12(02)        #期別
                  END RECORD
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.tah01
   FORMAT
   PAGE HEADER
   ON EVERY ROW
      PRINT g_x[166],sr.tah01 CLIPPED,
            g_x[167],sr.azi02 CLIPPED,
            g_x[167],sr.ted02 CLIPPED,
            g_x[181],cl_numfor(sr.qcye,20,2)   USING "-----------------&.&&",
            g_x[183],cl_numfor(sr.qcsl,20,2)   USING "-----------------&.&&",
            g_x[183],cl_numfor(sr.qcwbye,20,2) USING "-----------------&.&&",
            g_x[183],cl_numfor(sr.tah04,18,2)  USING "---------------&.&&",
            g_x[183],cl_numfor(sr.tah06,18,2)  USING "---------------&.&&",
            g_x[183],cl_numfor(sr.tah09,18,2)  USING "---------------&.&&",
            g_x[183],cl_numfor(sr.tah05,18,2)  USING "---------------&.&&",
            g_x[183],cl_numfor(sr.tah07,18,2)  USING "---------------&.&&",
            g_x[183],cl_numfor(sr.tah10,18,2)  USING "---------------&.&&",
            g_x[183],cl_numfor(sr.qmye,20,2)   USING "-----------------&.&&",
            g_x[183],cl_numfor(sr.qmsl,20,2)   USING "-----------------&.&&",
            g_x[183],cl_numfor(sr.qmwbye,20,2) USING "-----------------&.&&",
            g_x[182],sr.tah03 USING "&<",
            g_x[166]
END REPORT
 
REPORT jzpz_rep(sr)                              #記賬憑証
   DEFINE sr      RECORD
                  aba02   LIKE aba_file.aba02,   #憑証日期
                  aac02   LIKE aac_file.aac02,   #單別名稱(憑証種類）
                  aba11   LIKE aba_file.aba11,   #總號  #No.FUN-710056
                  abb02   LIKE abb_file.abb02,   #項次
                  abb04   LIKE abb_file.abb04,   #摘要
                  abb03   LIKE abb_file.abb03,   #科目編號
                  abb07a  LIKE abb_file.abb07,   #借方金額
                  abb07b  LIKE abb_file.abb07,   #貸方金額
                  azi02   LIKE azi_file.azi02,   #幣種說明
                  abb07fa LIKE abb_file.abb07f,  #借方外幣金額
                  abb07fb LIKE abb_file.abb07f,  #貸方外幣金額
                  abb25   LIKE abb_file.abb25,   #匯率
                  abb41   LIKE abb_file.abb41,   #數量
                  abb42   LIKE abb_file.abb42,   #單價
                  desc    LIKE zaa_file.zaa08,   #NO.FUN-690009    VARCHAR(255)      #核算項1234 #No.FUN-710056
                  aba31   LIKE aba_file.aba31,   #結算方式
                  aba32   LIKE aba_file.aba32,   #票據類型
                  aba33   LIKE aba_file.aba33,   #票據號
                  aba34   LIKE aba_file.aba34,   #票據日期
                  aba21   LIKE aba_file.aba21,   #附件張數
                  abauser LIKE aba_file.abauser, #錄入人員
                  aba37   LIKE aba_file.aba37,   #審核人員
                  aba38   LIKE aba_file.aba38,   #記賬人員
                  aba36   LIKE aba_file.aba36,   #出納人員
                  abapost LIKE aba_file.abapost, #過賬碼
                  abaacti LIKE aba_file.abaacti  #資料有效碼
                  END RECORD,
          l_abausera      LIKE gen_file.gen02,   #錄入人員姓名
          l_aba37a        LIKE gen_file.gen02,   #審核人員姓名
          l_aba38a        LIKE gen_file.gen02,   #記賬人員姓名
          l_aba36a        LIKE gen_file.gen02    #出納人員姓名
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.aba11,sr.aba02,sr.abb02  #No.FUN-710056
   FORMAT
   PAGE HEADER
 
   ON EVERY ROW
 
      CALL p160_gen02(sr.abauser) RETURNING l_abausera
      CALL p160_gen02(sr.aba37)   RETURNING l_aba37a
      CALL p160_gen02(sr.aba38)   RETURNING l_aba38a
      CALL p160_gen02(sr.aba36)   RETURNING l_aba36a
 
      PRINT g_x[166],sr.aba02   USING 'YYYYMMDD',
            g_x[167],sr.aac02   CLIPPED,
            g_x[167],sr.aba11   CLIPPED,  #No.FUN-710056
            g_x[181],sr.abb02   USING '<<<<<',
            g_x[182],sr.abb04   CLIPPED,
            g_x[167],sr.abb03   CLIPPED,
            g_x[181],cl_numfor(sr.abb07a,18,2)  USING "<<<<<<<<<<<<<<<&.&&",
            g_x[183],cl_numfor(sr.abb07b,18,2)  USING "<<<<<<<<<<<<<<<&.&&",
            g_x[182],sr.azi02   CLIPPED,
            g_x[181],cl_numfor(sr.abb07fa,18,2) USING "<<<<<<<<<<<<<<<&.&&",
            g_x[183],cl_numfor(sr.abb07fb,18,2) USING "<<<<<<<<<<<<<<<&.&&",
            g_x[183],cl_numfor(sr.abb25,13,6)   USING "<<<<<<&.&&&&&&",
            g_x[183],cl_numfor(sr.abb41,15,4)   USING "<<<<<<<<<<&.&&&&",
            g_x[183],cl_numfor(sr.abb42,18,4)   USING "<<<<<<<<<<<<<&.&&&&",
            g_x[182],sr.desc    CLIPPED,
            g_x[167],sr.aba31   CLIPPED,
            g_x[167],sr.aba32   CLIPPED,
            g_x[167],sr.aba33   CLIPPED;
      IF cl_null(sr.aba34) THEN
         PRINT g_x[167];
      ELSE
         PRINT g_x[167],sr.aba34   USING 'YYYYMMDD';
      END IF
      PRINT g_x[181],sr.aba21   CLIPPED,
            g_x[182],l_abausera CLIPPED,
            g_x[167],l_aba37a   CLIPPED,
            g_x[167],l_aba38a   CLIPPED,
            g_x[167],l_aba36a   CLIPPED,
            g_x[167],sr.abapost CLIPPED,
            g_x[167],sr.abaacti CLIPPED,
            g_x[166]
END REPORT
