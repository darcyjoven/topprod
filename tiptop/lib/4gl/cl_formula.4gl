# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Library name...: cl_formula 
# Descriptions...: 自定義公式解析處理模塊
# Function List..:
# ──────────────────────────────────────
#    NAME                  Description
# ──────────────────────────────────────
#  cl_fml_trans_desc       按公式內容轉換生成公式的說明
#  cl_fml_get_content      根據公式名稱返回公式內容
#  cl_fml_extract_param    根據公式內容解析出指定類型的元素
#  cl_fml_fill_param_list  按公式內容填充對應的參數數組全局變量
#  cl_fml_check_circle     檢查當前公式是否存在循環調用的狀況
#  cl_fml_get_param_info   根據元素的名稱返回元素的詳細信息
#  cl_fml_rep_parameter    根據全局數組中的變量值來替換公式中的對應內容
#  cl_fml_show_input       當調用公式時傳入參數個數少于公式所需參數時彈出對話框要求用戶輸入
#  cl_fml_get_param_value  本函數確保參數數組中的每一個值都得到了填充
#  cl_fml_rep_expression   用結果替換公式文本中的每一個表達式
#  cl_fml_run_shell        執行傳入的shell腳本并返回結果
#  cl_fml_run_sql          執行傳入的sql語句并返回結果，可以是一個一般計算式，函數會進行自動轉換
#  cl_fml_rep_sign         用結果替換傳入公式文本中的所有SHELL標記和SQL標記
#  cl_fml_get_next_word    從傳入的文本中找到最近的傳入保留字的位置
#  cl_fml_test_condition   測試一個IF條件式并以1（通過）或0（不通過）來表示結果
#  cl_fml_run_if           執行一個IF條件式并返回結果，如果存在嵌套，則只計算最外層
#  cl_fml_clear_comment    清除文本中包含在{}之間的注釋信息
#  cl_fml_rep_logic        循環執行并用結果替換傳入文本中的所有IF邏輯式
#  cl_fml_example          生成一個多行的用于顯示的公式範例字符串
#
#  cl_fml_run_content      執行公式，傳入公式內容和參數列表，返回公式的值
#  cl_fml_run              執行公式，傳入公式名和參數列表，返回公式的值
# ──────────────────────────────────────
# Date & Author..: 05/07/20 Created By Lifeng
# Modify.........: No.FUN-610022 06/01/16 By jackie 修改cl_fml_show_input部分
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-660059 06/06/13 By Rayven imandx_file改imx_file有些欄位修改有誤，重新修正
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.TQC-740021 07/04/05 By chenl  SQL執行錯誤修正。
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.MOD-890287 08/09/30 By alexstar 變數型態定義錯誤，原型態會導致資料被截斷
# Modify.........: No.MOD-8C0242 08/12/24 By chenyu 最后回傳的值要把兩端的回車符去掉
# Modify.........: No.FUN-B50108 11/05/18 By Kevin 維護function的資訊(p_findfunc)
# Modify.........: No.FUN-C60018 12//6/11 By madey 解決點選"測試公式"時無法輸入數值及且點選"確認"後出現An array variable has been referenced outside of its specified dimensions
# Modify.........: No.CHI-D10055 13/01/30 By zack bug修正，cl_fml_fill_param_list函数有递归调用，但函数一进来却把全局变量清空，导致后续显示值不完整
# Modify.........: No.TQC-D80005 13/08/06 By SunLM 对于字符串和计算式返回值的解析
# Modify.........: No.fengmy130927 13/09/29 By fengmy SQL非语法错误，报错不卡死
# Modify.........: No.MOD-DA0066 13/10/12 By SunLM cl_fml_rep_sign函数中,繼續循環搜索下一個<SQL和SHELL循环中,起始位置应该是1，而不是l_end+1
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0045
 
GLOBALS
DEFINE
  g_fml_param DYNAMIC ARRAY OF RECORD  
              name     STRING,
              desc     STRING,
              value    STRING
  END RECORD
DEFINE 
  g_i                  LIKE type_file.num5 #CHI-D10055 
END GLOBALS


 
#No.FUN-610022 --start--
DEFINE
   g_value ARRAY[20] OF RECORD
            fname     LIKE type_file.chr5,  #No.FUN-690005 VARCHAR(5),    #欄位名稱，從'att01'~'att10'  
            imx000    LIKE imx_file.imx000, #No.FUN-690005 VARCHAR(8),    #該欄位在imx_file中對應的欄位名稱
            visible   LIKE type_file.chr1,  #No.FUN-690005 VARCHAR(1),    #是否可見，'Y'或'N'       
            nvalue    STRING,
            value     STRING  #存放當前當前組值           
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
#No.FUN-610022 --end--   
 
# Descriptions...: 用于按照公式內容生成公式的說明信息，傳入的參數為公式內容
#                  返回值為生成后的說明信息以及操作結果，如果操作過程中出現錯誤則
#                  返回空串和FALSE
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_trans_desc(p_str)
DEFINE
  p_str                          LIKE gep_file.gep05,
  
  l_tmp                          STRING,
  lc_sub,lc_desc                 LIKE type_file.chr1000, #No.FUn-690005 VARCHAR(200),
  l_start,l_end                  LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  l_str_buf                      base.StringBuffer
 
  WHENEVER ERROR CALL cl_err_msg_log
  
  #接收公式內容
  LET l_tmp = p_str
  LET l_str_buf = base.StringBuffer.create()
  CALL l_str_buf.append(l_tmp) 
 
  #首先查找并替換所有的屬性標識（以#...#為標志）
  LET l_start = l_str_buf.getIndexOf('#',1)
  IF l_start > 0 THEN
     LET l_end = l_str_buf.getIndexOf('#',l_start+1)
  END IF
  WHILE ( l_end > 0 )
    #這里需要注意了，因為屬性名稱本身是不帶#的，這一點和常量
    #以及表達式不同，所以在取子串的時候要去掉前后的#
    LET lc_sub = l_str_buf.SubString(l_start+1,l_end-1)
 
    #如果是諸如“##”這樣的空串則報錯
    IF LENGTH(lc_sub CLIPPED) = 0 THEN
       CALL cl_err("","lib-302",1) #兩個'#"之間必須包含有效的屬性名稱
       RETURN '',FALSE
    END IF 
    
    LET lc_desc = ''
    SELECT agc02 INTO lc_desc FROM agc_file WHERE agc01 = lc_sub 
    IF NOT lc_desc CLIPPED IS NULL THEN
       CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),
                              lc_desc CLIPPED,0)
    ELSE
      CALL cl_err(lc_sub,"lib-243",1)  #未知的屬性名稱
      RETURN '',FALSE
    END IF
 
    LET l_start = l_str_buf.getIndexOf('#',l_end+1)
    LET l_end = l_str_buf.getIndexOf('#',l_start+1)
  END WHILE
  IF (( l_start > 0 )AND( l_end = 0 )) THEN
     CALL cl_err("","lib-242",1)   #“#”必須成對出現
     RETURN '',FALSE
  END IF
 
  #再查找并替換所有的常量或變量
  LET l_start = l_str_buf.getIndexOf("$",1)
  IF l_start > 0 THEN
     LET l_end = l_str_buf.getIndexOf("$",l_start+1)
  END IF
  WHILE ( l_end > 0 )
    LET lc_sub = l_str_buf.SubString(l_start,l_end)
    
    #如果是諸如“$$”這樣的空串則報錯
    IF LENGTH(lc_sub CLIPPED) = 0 THEN
       CALL cl_err("","lib-244",1)    #兩個'$"之間必須包含有效的變量/常量名稱
       RETURN '',FALSE
    END IF 
 
    LET lc_desc = ''    
    SELECT ges02 INTO lc_desc FROM ges_file WHERE ges01 = lc_sub 
    IF NOT lc_desc CLIPPED IS NULL THEN
       CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),
                              lc_desc CLIPPED,0)
    ELSE
      CALL cl_err(lc_sub,"lib-246",1)  #未知的變量/常量名稱
      RETURN '',FALSE
    END IF
 
    
    LET l_start = l_str_buf.getIndexOf('$',l_end+1)
    LET l_end = l_str_buf.getIndexOf('$',l_start+1)
  END WHILE
  IF (( l_start > 0 )AND( l_end = 0 )) THEN
     CALL cl_err("","lib-245",1)    #“$”必須成對出現
     RETURN '',FALSE
  END IF  
 
  #再替換所有的表達式
  LET l_start = l_str_buf.getIndexOf('&',1)
  IF l_start > 0 THEN
     LET l_end = l_str_buf.getIndexOf('&',l_start+1)
  END IF
  WHILE ( l_end > 0 )
    LET lc_sub = l_str_buf.SubString(l_start,l_end)
    
    #如果是諸如“&&”這樣的空串則報錯
    IF LENGTH(lc_sub CLIPPED) = 0 THEN
       CALL cl_err("","lib-247",1)    #兩個'&"之間必須包含有效的表達式名稱
       RETURN '',FALSE
    END IF 
 
    LET lc_desc = ''   
    SELECT gep02 INTO lc_desc FROM gep_file WHERE gep01 = lc_sub 
    IF NOT lc_desc CLIPPED IS NULL THEN
       CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),
                              lc_desc CLIPPED,0)
    ELSE
      CALL cl_err(lc_sub,"lib-249",1)   #未知的表達式名稱
      RETURN '',FALSE
    END IF
    
    LET l_start = l_str_buf.getIndexOf('&',l_end+1)
    LET l_end = l_str_buf.getIndexOf('&',l_start+1)
  END WHILE
  IF (( l_start > 0 )AND( l_end = 0 )) THEN
     CALL cl_err("","lib-248",1)   #“&”必須成對出現
     RETURN '',FALSE
  END IF
  
  RETURN l_str_buf.toString(),TRUE
END FUNCTION
 
# Descriptions...: 該函數根據公式名稱返回公式內容
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_get_content(p_formula_name)
DEFINE
  p_formula_name    LIKE gep_file.gep01,
  l_content         LIKE gep_file.gep05
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  SELECT gep05 INTO l_content FROM gep_file
    WHERE gep01 = p_formula_name
 
  RETURN l_content CLIPPED
END FUNCTION
 
# Descriptions...: 該函數從公式內容中拆解出所有使用到的變量（當前公式）
#                  返回的字符串是以”|“分隔的各個變量名稱，同名的變量
#                  不會出現多次，拆解的標識是一個由“|”分隔的字符串，比如
#                  “#|$|&"， 該函數不做語法檢查，假設公式語法正確
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_extract_param(p_content,p_sign)
DEFINE
  p_content         STRING,
  p_sign            STRING,
  l_origin          STRING,
  l_start,l_end     LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  l_str_buf         base.StringBuffer,
  l_check_buf       base.StringBuffer,
  l_str_tok         base.StringTokenizer,
  l_sign,l_sub      STRING
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET l_check_buf = base.StringBuffer.Create()
  LET l_str_buf = base.StringBuffer.Create()
  CALL l_str_buf.append(p_content)
 
  LET l_str_tok = base.StringTokenizer.create(p_sign,'|')
  WHILE l_str_tok.hasMoreTokens()
    #依次分離每次的標識
    LET l_sign = l_str_tok.nextToken()
    LET l_sign = l_sign.trim()
    #如果標識不為空則進行拆解
    IF NOT l_sign IS NULL THEN
       #按標識拆解
       LET l_start = l_str_buf.getIndexOf(l_sign,1)
       IF l_start > 0 THEN
          LET l_end = l_str_buf.getIndexOf(l_sign,l_start+1)
       END IF
       WHILE ((l_start > 0)AND( l_end > 0 ))
         LET l_sub = l_str_buf.SubString(l_start,l_end)
         LET l_sub = l_sub.trim()
         
         #只有在已拆解出的列表中沒有的參數才添加進去
         IF l_check_buf.getIndexOf(l_sub,1) = 0 THEN
            LET l_origin = l_origin.trim(),l_sub,'|'
       
            CALL l_check_buf.clear()
            CALL l_check_buf.append(l_origin)
         END IF
          
          LET l_start = l_str_buf.getIndexOf(l_sign,l_end+1)
         LET l_end = l_str_buf.getIndexOf(l_sign,l_start+1)
       END WHILE
    END IF 
  END WHILE 
  
  RETURN l_origin.trim()
END FUNCTION
 
# Descriptions...: 該函數填充一個全局變量g_fml_param，里面包含有計算傳入公式
#                  所需要的所有的變量即其詳細信息，該函數會遞歸調用直到檢索
#                  到其中包含的所有表達式即其包含的變量信息為止，但同名參數只
#                  會出現一次
#                  該函數調用上面的cl_fml_extract_param函數來執行文本解析，因為
#                  屬性信息是不放在參數列表中的，所以需要特別進行處理
#                  傳入參數為公式的名稱
#                  如果操作成功則返回TRUE，否則返回FALSE
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_fill_param_list(p_content)
DEFINE
  p_content                          STRING,
                                     
  l_i,l_j,l_found                    LIKE type_file.num5,    #No.FUN-690005  SMALLINT,                   
  l_content,l_tok,l_tmp_content      STRING,
  l_param_list,l_express_list        STRING,
  l_str_tok                          base.StringTokenizer
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  #初始化參數列表
  #CALL g_fml_param.clear() #mark CHI-D10055  
  #LET l_i = 1 #mark CHI-D10055
   
  LET l_content = p_content
  IF l_content IS NULL THEN RETURN FALSE END IF
  
  #首先填充當前公式中用到的參數信息
  LET l_param_list = cl_fml_extract_param(l_content,'#|$')
  
  #如果當前公式中包含參數信息(可能是屬性或常變量)
  IF l_param_list.getLength() > 0 THEN
     LET l_str_tok = base.StringTokenizer.create(l_param_list,'|')
     WHILE l_str_tok.hasMoreTokens()
       LET l_tok = l_str_tok.nextToken()
       LET l_tok = l_tok.trim()
       IF l_tok.getLength() > 0 THEN
          CALL cl_fml_get_param_info(l_tok) 
               #RETURNING g_fml_param[l_i].desc,g_fml_param[l_i].value #mark CHI-D10055
               RETURNING g_fml_param[g_i].desc,g_fml_param[g_i].value #CHI-D10055  
          #如果取得了數據才將本次的
          #IF NOT g_fml_param[l_i].desc.trim() IS NULL THEN #mark CHI-D10055
          IF NOT g_fml_param[g_i].desc.trim() IS NULL THEN  #CHI-D10055
             #在把當前的參數信息加入到數組中之前必須確認數組中沒有同名的參數信息
             LET l_found = FALSE
             FOR l_j = 1 TO g_fml_param.getLength() 
                 IF g_fml_param[l_j].name = l_tok THEN
                    LET l_found = TRUE
                 END IF
             END FOR
             #當沒有找到的時候才可以插入當前的參數信息
             IF NOT l_found THEN
                #給name變量賦值
                #LET g_fml_param[l_i].name = l_tok #mark CHI-D10055
                LET g_fml_param[g_i].name = l_tok #CHI-D10055
                #增加循環下標
                #LET l_i = l_i + 1 #mark CHI-D10055
                LET g_i = g_i + 1  #CHI-D10055
             END IF 
          ELSE
             #如果是$開頭的則報該變量或常量未定義（不存在于ges_file中） 	
             IF l_tok.getCharAt(1) = '$' THEN	
                CALL cl_err(l_tok,'lib-246',1)  
             ELSE #否則報該屬性未定義（不存在于agc_file中）
             	CALL cl_err(l_tok,'lib-243',1)
             END IF
             RETURN FALSE
          END IF
       END IF
     END WHILE
  END IF
  
  #再檢查當前公式中用到的表達式信息
  LET l_express_list = cl_fml_extract_param(l_content,'&')
                   
  #如果當前公式中包含表達式信息
  IF l_express_list.getLength() > 0 THEN
     LET l_str_tok = base.StringTokenizer.create(l_express_list,'|')
     WHILE l_str_tok.hasMoreTokens()
       LET l_tok = l_str_tok.nextToken()
       LET l_tok = l_tok.trim()
       IF l_tok.getLength() > 0 THEN
          #嵌套調用當前函數解析其中包含的每一個表達式中的函數
          LET l_tmp_content = cl_fml_get_content(l_tok)
          IF NOT cl_fml_fill_param_list(l_tmp_content) THEN
             RETURN FALSE
          END IF
       END IF
     END WHILE
  END IF
 
  RETURN TRUE  
END FUNCTION
 
# Descriptions...: 該函數檢查是否存在公式定義中是否存在循環調用的情況
#                  系統中不允許公式嵌套調用，該函數除了檢查公式當前的文本以外，還
#                  會檢查該公式調用到的所有表達式及其子表達式，如果其中調用有當前
#                  公式都算循環調用返回TRUE，否則返回FALSE
#                  傳入的參數p_content是要檢查的當前表達式的內容，p_base是要比較的基准
#                  表達式名稱
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_check_circle(p_name,p_content,p_base)
DEFINE
  p_name,p_content STRING,
  p_base           STRING,
 
  l_content        STRING, 
  l_express_list   STRING,
  l_tok,l_conten   STRING,
  l_str_tok        base.StringTokenizer
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  #使用p_name參數主要是因為有循環調用的情況
  #得到公式的內容(如果調用時傳入了內容則直接使用，否則按照名稱帶出內容)
  IF p_content.getLength() > 0 THEN
     LET l_content = p_content
  ELSE
     LET l_content = cl_fml_get_content(p_name) 
  END IF
 
  IF l_content IS NULL THEN RETURN FALSE END IF 
  #檢查當前公式中用到的表達式信息
  LET l_express_list = cl_fml_extract_param(l_content,'&')
                   
  #如果當前公式中包含表達式信息
  IF l_express_list.getLength() > 0 THEN
     LET l_str_tok = base.StringTokenizer.create(l_express_list,'|')
     WHILE l_str_tok.hasMoreTokens()
       LET l_tok = l_str_tok.nextToken()
       LET l_tok = l_tok.trim()
       IF l_tok.getLength() > 0 THEN
          #先檢查該表達式和傳入表達式的名稱是否相同
          #如果相同則直接返回一個TRUE,在嵌套調用中，上層調用者只要檢測到
          #一個TRUE，則都返回TRUE，直至最后端
          IF l_tok = p_base THEN RETURN TRUE END IF
 
          #嵌套調用當前表達式中的每一個子表達式
          IF cl_fml_check_circle(l_tok,'',p_base) THEN
             RETURN TRUE
          END IF
       END IF
     END WHILE
  END IF  
 
  #整個表達式搜尋完畢沒有發現異常則返回一個FALSE
  RETURN FALSE
END FUNCTION
 
# Descriptions...: 該函數根據變量名稱返回變量的詳細信息,它根據變量的命名特征
#                  來判斷應該從哪個表中取得信息，比如以#開頭從agc_file中取得等等，
#                  如果沒有任何一個標識，則默認為從agc_file中取（即當做屬性）
#                  返回值包括屬性的名稱，類型，可能有的默認值（兩種類型），
#                  對于表達式，該函數返回的名稱有效
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_get_param_info(p_param)
DEFINE
 #p_param                       LIKE gep_file.gep09,   #No.FUN-690005 VARCHAR(20), #MOD-890287 mark
  p_param                       LIKE gep_file.gep01,   #MOD-890287
  lc_desc,l_value               LIKE gep_file.gep02,   #No.FUN-690005 VARCHAR(100),
  l_ges06                       LIKE ges_file.ges06,
  l_ges07                       LIKE ges_file.ges07,
  l_ges04                       LIKE ges_file.ges04
 
  WHENEVER ERROR CALL cl_err_msg_log
  
  #如果是以$開頭表示變量或常量，從ges_file中取得
  IF p_param[1,1] = '$' THEN
     SELECT ges02,ges06,ges07,ges04 INTO 
            lc_desc,l_ges06,l_ges07,l_ges04
     FROM ges_file WHERE ges01 = p_param 
     #如果該參數是字符型則返回字符型的默認值，否則返回數值型的默認值
     IF l_ges06 = '2' THEN
        LET l_value = l_ges07
     ELSE 
     	LET l_value = l_ges04
     END IF
  ELSE
     #如果是以&開頭表示表達式，從gep_file中取得
     IF p_param[1,1] = '&' THEN
        SELECT gep02 INTO lc_desc FROM gep_file WHERE gep01 = p_param 
        LET l_value = ''
     ELSE
     	#否則理解為屬性，從agc_file中取
     	#首先要去除可能有的前面和后面的#，因為在agc_file里是沒有這些東東的
     	IF p_param[1,1] = '#' THEN
     	   LET p_param = p_param[2,LENGTH(p_param)-1]
     	END IF 
     	
	SELECT agc02 INTO lc_desc FROM agc_file WHERE agc01 = p_param 
	LET l_value = ''
     END IF	
  END IF
  
  RETURN lc_desc CLIPPED,l_value CLIPPED
END FUNCTION
 
# Descriptions...: 該函數根據全局數組來替換公式中的所有變量和常量，
#                  如果數組中指定參數的當前值為空則不執行替換
#                  返回已經替換完的公式字符串
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_rep_parameter(p_content)
DEFINE
  p_content                      STRING,
  l_str_buf                      base.StringBuffer,
  l_i                            LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET l_str_buf = base.StringBuffer.create()
  CALL l_str_buf.append(p_content)
 
  FOR l_i = 1 TO g_fml_param.getLength()
    #用參數值替換在公式中出現的參數名稱
    CALL l_str_buf.replace(g_fml_param[l_i].name,g_fml_param[l_i].value,0)
  END FOR 
  
  RETURN l_str_buf.toString()
END FUNCTION
 
# Descriptions...: 該函數調用一個對話框來接收參數，參數的名稱和個數由
#                  p_origin給出（以“|”分隔的字符串），傳出值為用戶
#                  輸入的各個參數對應的值（也是以“|”分隔的字符串）
#                  用戶不能空缺任何一個參數的輸入，如果用戶取消了輸入
#                  則返回一個空字符串
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_show_input(p_origin)
DEFINE
  p_origin                     STRING,
  l_origin_tok                 base.StringTokenizer,
  l_result                     STRING,
  l_value_arr DYNAMIC ARRAY OF RECORD
              code             LIKE type_file.chr20,   #No.FUN-690005 VARCHAR(20),
              value            LIKE type_file.chr1000  #No.FUN-690005 VARCHAR(100)
  END RECORD,
  l_tmp_str                    STRING,
  l_i,l_j                      LIKE type_file.num5     #No.FUN-690005 SMALLINT
#No.FUN-610022 --start--
  DEFINE l_sql        LIKE type_file.chr1000  #No.FUN-690005 VARCHAR(400)
  DEFINE i,j          LIKE type_file.num10    #No.FUN-690005 INTEGER                                                                                                        
  DEFINE l_bom_str    STRING                                                                                                         
  DEFINE l_codestr    LIKE type_file.chr20    #No.FUN-690005 VARCHAR(20)                                                                                                       
  DEFINE l_ac         LIKE type_file.num5     #No.FUN-690005 SMALLINT
  DEFINE l_agd03      LIKE agd_file.agd03                                                                                            
  DEFINE l_agd02      LIKE agd_file.agd02                                                                                            
  DEFINE l_agb03      LIKE agb_file.agb03                                                                                            
  DEFINE l_ima01      LIKE ima_file.ima01                                                                                            
  DEFINE l_imaag      LIKE ima_file.imaag                                                                                            
  DEFINE l_imaag1     LIKE ima_file.imaag1  
  DEFINE l_agc01      LIKE agc_file.agc01,                                                                                           
         l_agc02      LIKE agc_file.agc02,                                                                                           
         lsb_item     base.StringBuffer,                                                                                             
         lsb_value    base.StringBuffer,                                                                                             
         l_msg        STRING,
         l_msg1       STRING,
         l_n          LIKE type_file.num5,    #No.FUN-690005 SMALLINT
         l            LIKE type_file.num5     #No.FUN-690005 SMALLINT 
#No.FUN-610022 --end--   
 
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  OPEN WINDOW cl_fml_input_w WITH FORM "lib/42f/cl_fml_input" 
  ATTRIBUTE(STYLE = "report") 
 
  CALL cl_ui_init()
  CALL cl_ui_locale("cl_fml_input")
 
  LET l_i = 0
  LET l_origin_tok = base.StringTokenizer.create(p_origin,'|')
  WHILE l_origin_tok.hasMoreTokens()
    LET l_i = l_i + 1
    LET l_value_arr[l_i].code = l_origin_tok.nextToken()
  END WHILE
 
  LET l_result = ''
#FUN-610022 --start--
     FOR i = 1 TO 10                                                                                                                
         LET l_msg = 'att',2*i-1 USING '&&'                                                                                         
         LET l_msg1 = 'att',2*i USING '&&'                                                                                          
         CALL cl_set_comp_visible(l_msg,FALSE)                                                                                      
         CALL cl_set_comp_visible(l_msg1,FALSE)                                                                                     
     END FOR 
 
     LET i=1
     CALL g_att.clear()
     FOR l = 1 TO l_i
         LET l_agc01 = l_value_arr[l].code
         LET l_agc01 = l_agc01[2,length(l_agc01)-1]
         LET l_agc02 =''
 
        SELECT agc02 INTO l_agc02
          FROM agc_file
         WHERE agc01 = l_agc01
        IF cl_null(l_agc02) THEN LET l_agc02=l_agc01 END IF
 
        SELECT count(*) INTO l_n
          FROM agd_file
         WHERE agd01 = l_agc01
 
        IF l_n >0 THEN 
          LET l_msg = 'att',2*i-1 USING '&&'
          LET l_msg1 = 'att',2*i USING '&&'
          CALL cl_set_comp_att_text(l_msg,l_agc02)
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_visible(l_msg1,FALSE)
 
          LET g_value[2*i-1].fname = l_msg                                                                              
          LET g_value[2*i-1].visible = 'Y'                                                                              
#         LET g_value[2*i-1].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
          LET g_value[2*i-1].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
          LET g_value[2*i-1].nvalue = l_agc01
          LET g_value[2*i].fname = l_msg1                                                                              
          LET g_value[2*i].visible = 'N'                                                                              
#         LET g_value[2*i].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
          LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
          LET g_value[2*i].nvalue = ''
          #填充組合框中的選項                                                                                           
          LET lsb_item  = base.StringBuffer.create()                                                                    
          LET lsb_value = base.StringBuffer.create()                                                                    
          DECLARE agd_cur CURSOR FOR                                                                                    
          SELECT agd02,agd03 FROM agd_file                                                                              
           WHERE agd01 = l_agc01                                                                              
          FOREACH agd_cur INTO l_agd02,l_agd03                                                                          
            IF STATUS THEN                                                                                              
               CALL cl_err('foreach agb',STATUS,0)                                                                      
               EXIT FOREACH                                                                                             
            END IF                                                                                                      
            #lsb_value放選項的說明 
            IF lsb_value IS NULL THEN                                                                                     
                CALL lsb_value.append(l_agd03 CLIPPED || ":" ||l_agd03 CLIPPED || ",")
            ELSE
                CALL lsb_value.append(lsb_value || "," ||l_agd02|| ":" ||l_agd03 CLIPPED || ",")
            END IF
            #lsb_item放選項的值                                                                                         
            IF lsb_item IS NULL THEN                                                                                     
                CALL lsb_item.append(l_agd02 CLIPPED || ",")
            ELSE
                CALL lsb_item.append(lsb_item || "," ||l_agd02 CLIPPED || ",")
            END IF
          END FOREACH                                                                                                   
          CALL cl_set_combo_items(l_msg,lsb_item.toString(),                                                            
                                   lsb_value.toString())        
        ELSE
          LET l_msg = 'att',2*i USING '&&'
          LET l_msg1= 'att',2*i-1 USING '&&'
          CALL cl_set_comp_att_text(l_msg ,l_agc02)
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_visible(l_msg1,FALSE)
          LET g_value[2*i].fname = l_msg                                                                              
          LET g_value[2*i].visible = 'Y'                                                                              
#         LET g_value[2*i].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
          LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
          LET g_value[2*i-1].nvalue = l_agc01
          LET g_value[2*i-1].fname = l_msg1                                                                              
          LET g_value[2*i-1].visible = 'N'                                                                              
#         LET g_value[2*i-1].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
          LET g_value[2*i-1].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
          LET g_value[2*i-1].nvalue = ''
        END IF    
 
        LET i = i + 1                                                                                                
        #這里防止下標溢出導致錯誤                                                                                        
        IF i = 11 THEN EXIT FOR END IF                                                                             
     END FOR       
 
     FOR i = i TO 10
        LET l_msg = 'att',2*i-1 USING '&&'
        LET l_msg1= 'att',2*i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
        CALL cl_set_comp_visible(l_msg1,FALSE)
        LET g_value[2*i-1].fname = l_msg                                                                              
        LET g_value[2*i-1].visible = 'N'                                                                              
#       LET g_value[2*i-1].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
        LET g_value[2*i-1].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
        LET g_value[2*i-1].nvalue = ''
        LET g_value[2*i].fname = l_msg1                                                                              
        LET g_value[2*i].visible = 'N'                                                                              
#       LET g_value[2*i].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                  
        LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
        LET g_value[2*i].nvalue = ''
     END FOR
 
     CALL g_att.appendElement() #FUN-C60018
     INPUT ARRAY g_att WITHOUT DEFAULTS FROM s_arr.*                                                                                 
         ATTRIBUTE(COUNT=1,APPEND ROW=FALSE,INSERT ROW=FALSE,DELETE ROW=FALSE,                                                                   
                   UNBUFFERED)
 
     BEFORE ROW
         LET l_ac = ARR_CURR()
 
    AFTER FIELD att01                                                                                                           
       IF NOT cl_null(g_att[l_ac].att01) THEN                                                                                      
          LET g_value[1].value = g_att[l_ac].att01 END IF 
 
    AFTER FIELD att02                                                                                                           
       IF NOT cl_null(g_att[l_ac].att02) THEN                                                                                      
          LET g_value[2].value = g_att[l_ac].att02 END IF 
 
    AFTER FIELD att03                                                                                                           
       IF NOT cl_null(g_att[l_ac].att03) THEN                                                                                      
          LET g_value[3].value = g_att[l_ac].att03 END IF 
 
    AFTER FIELD att04                                                                                                           
       IF NOT cl_null(g_att[l_ac].att04) THEN                                                                                      
          LET g_value[4].value = g_att[l_ac].att04 END IF 
 
    AFTER FIELD att05                                                                                                           
       IF NOT cl_null(g_att[l_ac].att05) THEN                                                                                      
          LET g_value[5].value = g_att[l_ac].att05 END IF 
 
    AFTER FIELD att06                                                                                                           
       IF NOT cl_null(g_att[l_ac].att06) THEN                                                                                      
          LET g_value[6].value = g_att[l_ac].att06 END IF 
 
    AFTER FIELD att07                                                                                                           
       IF NOT cl_null(g_att[l_ac].att07) THEN                                                                                      
          LET g_value[7].value = g_att[l_ac].att07 END IF 
 
    AFTER FIELD att08                                                                                                           
       IF NOT cl_null(g_att[l_ac].att08) THEN                                                                                      
          LET g_value[8].value = g_att[l_ac].att08 END IF 
 
    AFTER FIELD att09                                                                                                          
       IF NOT cl_null(g_att[l_ac].att09) THEN                                                                                      
          LET g_value[9].value = g_att[l_ac].att09 END IF 
 
    AFTER FIELD att10                                                                                                          
       IF NOT cl_null(g_att[l_ac].att10) THEN                                                                                      
          LET g_value[10].value = g_att[l_ac].att10 END IF 
 
    AFTER FIELD att11                                                                                                          
       IF NOT cl_null(g_att[l_ac].att11) THEN                                                                                      
          LET g_value[11].value = g_att[l_ac].att11 END IF 
 
    AFTER FIELD att12                                                                                                          
       IF NOT cl_null(g_att[l_ac].att12) THEN                                                                                      
          LET g_value[12].value = g_att[l_ac].att12 END IF 
 
    AFTER FIELD att13                                                                                                          
       IF NOT cl_null(g_att[l_ac].att13) THEN                                                                                      
          LET g_value[13].value = g_att[l_ac].att13 END IF 
 
    AFTER FIELD att14                                                                                                          
       IF NOT cl_null(g_att[l_ac].att14) THEN                                                                                      
          LET g_value[14].value = g_att[l_ac].att14 END IF 
 
    AFTER FIELD att15                                                                                                          
       IF NOT cl_null(g_att[l_ac].att15) THEN                                                                                      
          LET g_value[15].value = g_att[l_ac].att15 END IF 
 
    AFTER FIELD att16                                                                                                          
       IF NOT cl_null(g_att[l_ac].att16) THEN                                                                                      
          LET g_value[16].value = g_att[l_ac].att16 END IF 
 
    AFTER FIELD att17                                                                                                          
       IF NOT cl_null(g_att[l_ac].att17) THEN                                                                                      
          LET g_value[17].value = g_att[l_ac].att17 END IF 
 
    AFTER FIELD att18                                                                                                          
       IF NOT cl_null(g_att[l_ac].att18) THEN                                                                                      
          LET g_value[18].value = g_att[l_ac].att18 END IF 
 
    AFTER FIELD att19                                                                                                          
       IF NOT cl_null(g_att[l_ac].att19) THEN                                                                                      
          LET g_value[19].value = g_att[l_ac].att19 END IF 
 
    AFTER FIELD att20                                                                                                          
       IF NOT cl_null(g_att[l_ac].att20) THEN                                                                                      
          LET g_value[20].value = g_att[l_ac].att20 END IF 
 
    AFTER INPUT
       IF INT_FLAG THEN
          EXIT INPUT
       END IF
       IF (cl_null(g_att[l_ac].att01) AND g_value[1].visible= 'Y') OR
          (cl_null(g_att[l_ac].att02) AND g_value[2].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att03) AND g_value[3].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att04) AND g_value[4].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att05) AND g_value[5].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att06) AND g_value[6].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att07) AND g_value[7].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att08) AND g_value[8].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att09) AND g_value[9].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att10) AND g_value[10].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att11) AND g_value[11].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att12) AND g_value[12].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att13) AND g_value[13].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att14) AND g_value[14].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att15) AND g_value[15].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att16) AND g_value[16].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att17) AND g_value[17].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att18) AND g_value[18].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att19) AND g_value[19].visible= 'Y') OR 
          (cl_null(g_att[l_ac].att20) AND g_value[20].visible= 'Y') 
       THEN
          CALL cl_err('','abm-997',0)
          IF g_value[1].visible = 'Y' THEN
              NEXT FIELD att01
          ELSE
              NEXT FIELD att02
          END IF
       END IF
 
        #No.TQC-860016 --start--
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
        #No.TQC-860016 ---end---
 
     END INPUT
 
     IF INT_FLAG THEN                                                                                                                  
        LET INT_FLAG = 0                                                                                                               
     ELSE
        LET i = 1                                                                                                                    
        FOR i = 1 TO 20                                                                                                              
            IF g_value[i].visible = 'Y' THEN  
               LET l_bom_str = g_value[i].value
               LET l_bom_str = l_bom_str.trim()                                                                                           
               LET l_result  = l_result,l_bom_str,'|'
            END IF
        END FOR                          
     END IF                                                                                                                            
{
  INPUT ARRAY l_value_arr WITHOUT DEFAULTS FROM s_arr.*
    ATTRIBUTE(APPEND ROW=FALSE,INSERT ROW=FALSE,DELETE ROW=FALSE,
              UNBUFFERED)
  IF INT_FLAG THEN
     LET INT_FLAG = 0
  ELSE
     FOR l_j = 1 TO l_i 
         LET l_tmp_str = l_value_arr[l_j].value
         LET l_tmp_str = l_tmp_str.trim()
         LET l_result = l_result,l_tmp_str,'|'
     END FOR
  END IF
}
#No.FUN-610022 --end--
  CLOSE WINDOW cl_fml_input_w
 
  RETURN l_result
END FUNCTION
 
# Descriptions...: 該函數用于完成所有公式所需參數的填充，傳入的列表
#                  p_input是一個“參數名|參數值|參數名|參數值“格式的字符串，
#                  如果檢查后發現傳入參數不能滿足動態參數數組的需要，則會
#                  調用上面的cl_fml_show_input()來顯示一個對話框提示用戶輸入
#                  空缺的參數，如果操作成功則返回TRUE，否則（比如用戶選擇取消）
#                  則返回FALSE
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_get_param_value(p_input)
DEFINE
  p_str                          STRING,
  p_input                        STRING,
  
  l_tmp,l_sub,l_result           STRING,
  l_str_buf                      base.StringBuffer, 
  l_origin,l_value               STRING,  #傳給對話框的參數名稱列表  
 
  l_tmp_code,l_tmp_value         STRING,
  l_str_tok                      base.StringTokenizer,
  l_code_tok,l_value_tok         base.StringTokenizer,
  l_start,l_end                  LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_success                      LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_i                            LIKE type_file.num5      #No.FUN-690005 SMALLINT
 
  WHENEVER ERROR CALL cl_err_msg_log
  
  #先按照傳入的參數來填充數組
  LET l_str_tok = base.StringTokenizer.create(p_input,'|')
  WHILE l_str_tok.hasMoreTokens()
    #切出一組參數名和參數值
    LET l_origin = l_str_tok.nextToken()
    LET l_value = l_str_tok.nextToken()
    
    #參數名和參數值必須成對出現
    IF l_value = '' THEN
       CALL cl_err('','lib-254',1)   #“$”必須成對出現
       RETURN FALSE
    END IF
    #定位并填充指定的參數
    FOR l_i = 1 TO g_fml_param.getLength()
        IF g_fml_param[l_i].name = l_origin THEN
           LET g_fml_param[l_i].value = l_value
        END IF   
    END FOR
  END WHILE
  #正常情況下到此處為止數組中的每一個參數都應該有了value
    
  LET l_origin = ''
  #檢查替換之后數組中是否還有值為空的參數，如果有則表示
  #因為前面傳入的參數不夠導致有一部分屬性、變量或常量
  #沒有被替換掉，需要彈出對話框來提示用戶手工輸入
  FOR l_i = 1 TO g_fml_param.getLength() 
      IF g_fml_param[l_i].value IS NULL THEN
         LET l_origin = l_origin,g_fml_param[l_i].name,'|'
      END IF
  END FOR
  
  #如果有剩余遺漏的參數
  IF l_origin.getLength() > 0 THEN
     #顯示接收參數輸入的對話框并接收返回值
     LET l_value = cl_fml_show_input(l_origin)
     #如果用戶選擇了取消則退出本函數
     IF l_value.getLength() = 0 THEN
        RETURN FALSE
     ELSE
        #否則按照用戶輸入的參數值對剩余的參數進行替換
        LET l_code_tok = base.StringTokenizer.create(l_origin,'|')
        LET l_value_tok = base.StringTokenizer.create(l_value,'|')
        WHILE l_code_tok.hasMoreTokens()
           LET l_tmp_code = l_code_tok.nextToken()
           LET l_tmp_value = l_value_tok.nextToken()
 
           FOR l_i = 1 TO g_fml_param.getLength() 
               IF (( g_fml_param[l_i].name = l_tmp_code )AND
                  ( g_fml_param[l_i].value IS NULL )) THEN
                  LET g_fml_param[l_i].value = l_tmp_value
                  EXIT FOR
               END IF 
           END FOR
        END WHILE
     END IF
  END IF
 
  #到此為止可以保証整個參數數組中都完成了填充
  RETURN TRUE
END FUNCTION 
 
# Descriptions...: 本函數解析傳入公式中包含的所有表達式并用其結果來替換其位置
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_rep_expression(p_str)
DEFINE 
  p_str                STRING,
  
  l_str_buf            base.StringBuffer,
  l_start,l_end        LIKE type_file.num5,     #No.FUN-690005 SMALLINT,   #公式起止標記&的位置
  l_startex,l_endex    LIKE type_file.num5,     #No.FUN-690005 SMALLINT,   #公式所帶參數起止標記()的位置
  l_sub,l_origin       STRING     #公式名稱
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET p_str = p_str.trim()
  #如果傳入的參數為一個空串，則返回一個空串并不報錯
  IF p_str.getLength() = 0 THEN
     RETURN '',TRUE
  END IF
 
  LET l_str_buf = base.StringBuffer.create()
  CALL l_str_buf.append(p_str)
 
  LET l_start = l_str_buf.getIndexOf('&',1)
  IF l_start > 0 THEN
     LET l_end = l_str_buf.getIndexOf('&',l_start+1)
  END IF
  WHILE ( l_end > 0 )
    LET l_sub = l_str_buf.SubString(l_start,l_end)
    LET l_sub = l_sub.trim()
 
    LET l_origin = l_origin.trim(),l_sub,'|'
    
    LET l_start = l_str_buf.getIndexOf('&',l_end+1)
    LET l_end = l_str_buf.getIndexOf('&',l_start+1)
  END WHILE
 
END FUNCTION 
 
# Descriptions...: 本函數調用shell進行計算并返回一個結果
#                  IF條件塊的執行和標准shell標識塊的執行都要調用它，
#                  該shell腳本中將計算結果返回到$FML_RESULT環境變量中
#                  以供Runtime系統接收
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_run_shell(p_content)
DEFINE
  p_content       STRING,
  l_channel       base.Channel,
  l_result        LIKE type_file.num5     #No.FUN-690005 SMALLINT
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET p_content = p_content.trim()
  #如果傳入的參數為一個空串，則返回一個空串并不報錯
  IF p_content.getLength() = 0 THEN
     RETURN '',TRUE
  END IF
 
  #直接執行該語句并檢查返回狀態
  LET l_channel = base.Channel.create()
  RUN p_content
  CALL l_channel.openPipe('echo $?','r')
  WHILE l_channel.read(l_result)
  END WHILE
  CALL l_channel.close()
  #腳本的返回結果存在FML_RESULT環境變量中
  IF l_result = 0 THEN
     RETURN FGL_GETENV('FML_RESULT'),TRUE
  ELSE
     CALL cl_err('','lib-263',1)    #Shell腳本執行錯誤
     RETURN '',FALSE
  END IF
END FUNCTION
 
# Descriptions...: 本函數計算一個SQL標識并返回一個結果
#                  基本計算式的執行和標准SQL標識塊的執行都要調用它，該函數接收
#                  的傳入參數可能有兩種，一種是諸如SELECT A FROM B之類的純SQL語句，
#                  另一類是諸如a*b(c-d)之類的一般計算式，對于第一種情況，我們可以
#                  直接RUN并返回結果，對于第二種，我們必須在前后增加SELECT和FROM使
#                  其成為合法的SQL語句，一般是構成SELECT xxx FROM sma_file，因為sma_file
#                  永遠只有一條記錄
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_run_sql(p_content)
DEFINE
  p_content        STRING,
  l_sql            STRING,
  l_result         LIKE type_file.chr1000  #No.FUN-690005 VARCHAR(1000)
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  #首先判斷當前傳入的參數是什么類型（是否帶SELECT）
  LET l_sql = p_content.trim()
 
  #如果傳入的為空字符串則直接返回一個空串，而且不報錯
  IF l_sql.getLength() = 0 THEN
     RETURN '',TRUE
  END IF
#TQC-D80005 add begin------------------ 
#  IF l_sql.getIndexOf('SELECT ',1) <> 1 THEN
#    #LET l_sql = 'SELECT "',l_sql,'" FROM sma_file '   #No.TQC-740021  #No.MOD-8C0242 mark
#    #LET l_sql = "SELECT ",l_sql,"  FROM sma_file "   #No.TQC-740021   #No.MOD-8C0242 add
#    LET l_sql = "SELECT '",l_sql,"'  FROM sma_file " 
#  END IF
  IF (l_sql.getIndexOf('+',1) <> 0 OR l_sql.getIndexOf('-',1) <> 0 OR 
      l_sql.getIndexOf('*',1) <> 0 OR l_sql.getIndexOf('/',1) <> 0) AND 
     l_sql.getIndexOf('SELECT ',1) <> 1  THEN
     LET l_sql = "SELECT ",l_sql,"  FROM sma_file " 
  ELSE 
     IF l_sql.getIndexOf('SELECT ',1) <> 1 THEN
        LET l_sql = "SELECT '",l_sql,"'  FROM sma_file " 
     END IF 
  END IF   
   #LET l_sql = "SELECT ",l_sql,"  FROM sma_file "     
#TQC-D80005 add end------------------ 
  
  #執行并得到計算結果
  DECLARE cur_fml CURSOR FROM l_sql
  OPEN cur_fml
  IF SQLCA.sqlcode THEN
     CALL cl_err('','lib-262',1)   #一般計算式語法錯誤
     RETURN '',FALSE
  ELSE  	 
     #得到計算結果
     FETCH cur_fml INTO l_result
     IF SQLCA.sqlcode THEN  
        #fengmy130927 begin      
        IF g_bgerr THEN
           CALL s_errmsg('',p_content.trim(),'',SQLCA.sqlcode,1)
        ELSE
           CALL cl_err(p_content.trim(),'General SQL ERROR :',1)
        END IF
        LET g_success = 'N'           
       #CLOSE cur_fml
       #CALL cl_err(p_content.trim(),'General SQL ERROR :',1)
       #RETURN '',FALSE
        RETURN '',TRUE        
       #ELSE  
          #CLOSE cur_fml	 
          #RETURN '',TRUE
       #END IF   
        #fengmy130927 end
     ELSE     
     #返回正常結果	
    #CLOSE cur_fml	#fengmy130927 mark
     RETURN l_result,TRUE
     END IF
  END IF
END FUNCTION
 
# Descriptions...: 該函數用于替換文本中出現的所有標記，包括<SQL=.../SQL>標記
#                  和<SHELL=.../SHELL>標記,返回替換以后的結果和可能有的錯誤
#                  提示信息(比如寫了<SQL=沒有寫結束/SQL>等
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_rep_sign(p_content)
DEFINE
  p_content                      STRING,
  
  l_start,l_end                  LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_str_buf                      base.StringBuffer,
  l_result,l_sub                 STRING,
  l_status                       LIKE type_file.num5      #No.FUN-690005 SMALLINT
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET p_content = p_content.trim()
  #如果傳入的參數為一個空串，則返回一個空串并不報錯
  IF p_content.getLength() = 0 THEN
     RETURN '',TRUE
  END IF
 
  LET l_str_buf = base.StringBuffer.create()
  CALL l_str_buf.append(p_content) 
 
  #首先查找并替換所有的SQL標識（以<SQL=.../SQL>為標志）
  LET l_start = l_str_buf.getIndexOf('<SQL=',1)
  IF l_start > 0 THEN
     LET l_end = l_str_buf.getIndexOf('/SQL>',l_start+5)
  END IF
  WHILE ( l_end > 0 )
    #這里需要注意了，因為屬性名稱本身是不帶#的，這一點和常量
    #以及表達式不同，所以在取子串的時候要去掉前后的#
    LET l_sub = l_str_buf.SubString(l_start+5,l_end-1)
 
    #如果是諸如“<SQL=/SQL>”這樣的空串則報錯
    IF LENGTH(l_sub CLIPPED) = 0 THEN
       CALL cl_err("","lib-264",1)   #在<SQL=和/SQL>之間未包含任何有效的SQL腳本信息
       RETURN '',FALSE
    END IF 
    #fengmy130927 add  
    BEGIN WORK
    CALL s_showmsg_init()  
    LET g_success='Y'
    #fengmy130927 end 
    #調用cl_fml_run_sql來解析該SQL語句
    CALL cl_fml_run_sql(l_sub) RETURNING l_result,l_status  #No.TQC-740021
    #fengmy130927 add 
    CALL s_showmsg()
    IF g_success='Y' THEN 
       COMMIT WORK        
    ELSE                  
       ROLLBACK WORK      
    END IF	              
    CLOSE cur_fml 
    #fengmy130927 end   
    IF NOT l_status  THEN 
      RETURN '',FALSE
    END IF
    
    
    #用結果來替換原來的子句(如果同一段腳本里多次出現了相同的SQL子句則
    #會一次全部替換掉)
    LET l_sub = l_str_buf.subString(l_start,l_end+4)  #No.TQC-740021
    CALL l_str_buf.replace(l_sub,l_result,0)
    #繼續循環搜索下一個<SQL=.../SQL>子句
    #LET l_start = l_str_buf.getIndexOf('<SQL=',l_end+1)  ##MOD-DA0066 mark
    LET l_start = l_str_buf.getIndexOf('<SQL=',1)  ##MOD-DA0066 add
    LET l_end = l_str_buf.getIndexOf('/SQL>',l_start+5)
  END WHILE
  IF (( l_start > 0 )AND( l_end = 0 )) THEN
     CALL cl_err("","lib-265",1)  #<SQL=和/SQL>必須成對出現
     RETURN '',FALSE
  END IF
 
  #再查找并替換所有的SHELL標識（以<SHELL=.../SHELL>為標志）
  LET l_start = l_str_buf.getIndexOf('<SHELL=',1)
  IF l_start > 0 THEN
     LET l_end = l_str_buf.getIndexOf('/SHELL>',l_start+7)
  END IF
  WHILE ( l_end > 0 )
    #這里需要注意了，因為屬性名稱本身是不帶#的，這一點和常量
    #以及表達式不同，所以在取子串的時候要去掉前后的#
    LET l_sub = l_str_buf.SubString(l_start+7,l_end-1)
 
    #如果是諸如“<SHELL=/SHELL>”這樣的空串則報錯
    IF LENGTH(l_sub CLIPPED) = 0 THEN
       CALL cl_err("","lib-266",1)   #在<SHELL=和/SHELL>之間未包含任何有效的SHELL腳本信息
       RETURN '',FALSE
    END IF 
 
    #調用cl_fml_run_shell來解析該SHELL腳本
    CALL cl_fml_run_shell(l_sub) RETURNING l_result,l_status
    IF NOT l_status THEN 
      RETURN '',FALSE
    END IF
    
    #用結果來替換原來的子句(如果同一段腳本里多次出現了相同的SHELL子句則
    #會一次全部替換掉)
    LET l_sub = l_str_buf.subString(l_start,l_end)
    CALL l_str_buf.replace(l_sub,l_result,0)
    
    #繼續循環搜索下一個<SHELL=.../SHELL>子句
    #LET l_start = l_str_buf.getIndexOf('<SHELL=',l_end+1) #MOD-DA0066 mark
    LET l_start = l_str_buf.getIndexOf('<SHELL=',1)  #MOD-DA0066 add
    LET l_end = l_str_buf.getIndexOf('/SHELL>',l_start+7)
  END WHILE
  IF (( l_start > 0 )AND( l_end = 0 )) THEN
     CALL cl_err("","lib-267",1)   #<SHELL=和/SHELL>必須成對出現
     RETURN '',FALSE
  END IF
 
  #返回正常情況下的返回值
  RETURN l_str_buf.toString(),TRUE 
END FUNCTION
 
# Descriptions...: 該函數對傳進來的一個表達式進行判斷，傳入表達式通常是IF ... THEN
#                  中間的那個條件字符串，該函數會將這個條件表達式組進一個SQL語句并
#                  由它進行判斷（具體的實現就是拼成一個"SELECT COUNT(*) FROM sma_file
#                  WHERE 表達式"的語句，如果表達式語法正確且結果為正確，則返回1，如果
#                  語法正確但結果不正確（比如傳入1>2）則返回0，如果表達式的語法都錯誤
#                  則返回-1，因為是使用SQL進行判斷，所以條件的類型可以支持到SQL語法支持
#                  的所有類型，包括條件之間的and和or
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_test_condition(p_condition)
DEFINE
  p_condition            STRING,
  l_condition            STRING,
  l_result               LIKE type_file.num5     #No.FUN-690005 SMALLINT
  
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET l_condition = p_condition.trim()
  
  IF l_condition.getLength() = 0 THEN 
     CALL cl_err('','lib-268',1)  #IF子句中的條件不能為空
     RETURN -1
  END IF
  #合成判斷語句
  LET l_condition = 'SELECT COUNT(*) FROM sma_file WHERE (',l_condition,')'
  #執行并得到計算結果
  DECLARE cur_fml_ex CURSOR FROM l_condition
  OPEN cur_fml_ex
  IF SQLCA.sqlcode THEN
     CALL cl_err('','lib-269',1)  #IF子句條件語法錯誤
     RETURN -1
  ELSE
     #得到計算結果
     FETCH cur_fml_ex INTO l_result
     IF SQLCA.sqlcode THEN
        CLOSE cur_fml_ex
        CALL cl_err(p_condition.trim(),'Genero SQL Error :',1)
        RETURN -1
     ELSE
     #返回正常結果	
     CLOSE cur_fml_ex	
     RETURN l_result
     END IF
  END IF  
END FUNCTION
 
# Descriptions...: 該函數用于從p_content傳入的字符串中尋找舉例p_start指定的開始
#                  位置最近的一個要定位字符p_word,如果找到則返回一個大于0的數值
#                  表示其位置，如果沒有找到則返回0
#                  為什么不直接用getIndexOf的原因是因為如果需要找的字符出現在另一個
#                  字符中間的時候（比如ENDIF中就包含有IF）容易引起邏輯混亂，本
#                  函數通過比較在找到字符串的前后緊鄰的字符（是否為空格、\t、\n或
#                  括號)來判斷是否獨立字符串，并且在定位過程中忽略字母的大小寫
 
#                  特別注意□本函數只適用于保留字（如IF，ELSE）等的定位！！！
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_get_next_word(p_buf,p_word,p_start)
DEFINE
  p_buf           base.StringBuffer,
  p_word          STRING,
  p_start         LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  l_content,l_prev,l_next                STRING,
  l_start,l_prev_right,l_next_right      LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  l_str_buf                       base.stringBuffer
 
  #如果傳入文本或要定位詞匯中的任何一個為空則返回0
  LET l_content = p_buf.toString()
  IF (( l_content.getLength() = 0 )OR( p_word.getLength() = 0 )) THEN
     RETURN 0
  END IF
  #如果用戶沒有給出符合要求的起始字符則自動校正
  IF p_start <= 0 THEN LET p_start = 1 END IF
 
  #接收傳入文本并忽略其大小寫
  LET l_str_buf = base.stringBuffer.create()
  CALL l_str_buf.append(l_content)
  CALL l_str_buf.toUpperCase()
  LET p_word = p_word.toUpperCase()
 
  #開始循環搜索
  LET l_start = p_start
  WHILE TRUE
    #定位符合p_word的子串位置
    LET l_start = l_str_buf.getIndexOf(p_word,l_start)
 
    #如果沒有定義到則直接退出
    IF l_start = 0 THEN
       EXIT WHILE
    END IF
 
    #如果定義到的子串為該文本的起始
    IF l_start = 1 THEN
       LET l_prev_right = TRUE #該子串從前面看是合乎要求的
    ELSE
       #否則需要提取出該子串的前驅字符
       LET l_prev = l_str_buf.getCharAt(l_start - 1)
       #如果前驅字符是'\t','\n'或空格中的一個則算符合要求
       IF l_prev = '\t' OR l_prev = ' ' OR l_prev = '\n' OR
          l_prev = '('  OR l_prev = ')' OR l_prev = '['  OR
          l_prev = ']'  THEN
          LET l_prev_right = TRUE
       ELSE 
          LET l_prev_right = FALSE #否則不符合要求
       END IF
    END IF
 
    #如果前驅符合要求才進行下面的搜索
    IF l_prev_right THEN
       #如果該子串的結尾也就是整個文本的結尾，則算符合要求
       IF ( l_start + p_word.getLength() - 1 = l_content.getLength()) THEN
          LET l_next_right = TRUE
       ELSE 
          #否則需要提取出該子串的后繼字符
          LET l_next = l_str_buf.getCharAt(l_start + p_word.getLength())
          #如果后繼字符是'\t','\n'或空格中的一個則算符合要求
          IF l_next = '\t' OR l_next = ' ' OR l_next = '\n' OR 
             l_next = '('  OR l_next = ')' OR l_next = '['  OR
             l_next = ']'  THEN
             LET l_next_right = TRUE
          ELSE
             LET l_next_right = FALSE  #否則不符合要求
          END IF
       END IF
    END IF
 
    #如果前驅和后繼都符合要求則算找到了該詞
    IF l_prev_right = TRUE AND l_next_right = TRUE THEN
       EXIT WHILE
    ELSE
       #否則后移起始位置并繼續搜索
       LET l_start = l_start + p_word.getLength()
    END IF
 
  END WHILE
 
  #返回搜索結果
  RETURN l_start
END FUNCTION
 
# Descriptions...: 該函數用于計算一個IF表達式并返回結果，傳入的參數必須為
#                  一個以IF開頭ENDIF結尾的完整表達式，而且不支持ELSEIF結構
#                  但支持IF嵌套,函數返回兩個值，一個是存放結果字符串的值，另
#                  一個是表示操作是否成功，從功能上來看，該函數相當于把可能的
#                  多層的IF結構的最外層解析掉，循環調用即可實現替換所有的IF結構
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_run_if(p_content)
DEFINE
  p_content               STRING,
  l_str_buf,l_cond_buf    base.stringBuffer,
  l_start,l_then          LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_result                LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_if,l_else,l_end       LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_result1,l_result2     STRING,
  l_tmp_str,l_condition   STRING,
  l_level                 LIKE type_file.num5      #No.FUN-690005 SMALLINT
  
  WHENEVER ERROR CALL cl_err_msg_log
  
  LET l_str_buf = base.stringBuffer.create()
  LET l_tmp_str = p_content.trim()
  CALL l_str_buf.append(l_tmp_str)
  
  #分析□目前支持的IF [條件] THEN [結果1] ELSE [結果2] ENDIF
  #我們解析的時候需要同時注意處理好條件、結果1和結果2之中可能包含的嵌套
  
  #排除條件段中可能有的嵌套并得到對應的條件語句
  #判斷方法□設定當前級別為1，凡遇到一個IF，則加1遇到一個ENDIF則減1，當級別重新
  #減為1的時候判斷最近的地方有沒有ELSE，如果有則這個就是本級的ELSE，否則重復上面
  #的操作直至找到為止
 
  #初始化起始位置     
  LET l_start = 3  #忽略開頭的IF 
  #初始化當前級別為1
  LET l_level = 1   
  WHILE TRUE
    #首先看看有沒有下一個IF，以及它的位置在哪里
    LET l_if = cl_fml_get_next_word(l_str_buf,'IF',l_start)
    LET l_then = cl_fml_get_next_word(l_str_buf,'THEN',l_start)
    LET l_end = cl_fml_get_next_word(l_str_buf,'ENDIF',l_start)
 
    IF l_then = 0 THEN
       CALL cl_err('','lib-270',0)      #找不到對應的THEN
       RETURN '',FALSE
    END IF
    #下面可以保証l_then是大于0的了
   
    #以下要結合當前的嵌套層次來進行判別，如果當前沒有嵌套(l_level = 1)，則
    #比較下一個IF和THEN的相對位置，如果當前是在嵌套中(l_level > 1)，則不關心
    #THEN，只需要找下一個ENDIF并跳出嵌套即可
    IF l_level = 1 THEN       
       #判斷此時在THEN前面是否有IF
       IF ( l_if > 0 )AND( l_if < l_then ) THEN
          #如果發現了有IF則將嵌套級別加1并把搜索起始符向后移2位
          LET l_level = l_level + 1
          LET l_start = l_if + 2  
             
          #中止本次的while循環
          CONTINUE WHILE
       END IF
              
       #如果程序能運行到這里，說明找到最外層對應的THEN了，可以使用它得到[條件]段
       LET l_condition = l_str_buf.subString(3,l_then - 1)
       LET l_condition = l_condition.trim()
       EXIT WHILE
 
       #上面是當l_level=1，即不在嵌套IF子句中的情況
    ELSE
       #下面是當處于IF嵌套子句中的情況l_level > 1
       IF l_level > 1 THEN
          IF l_end = 0 THEN
             CALL cl_err('','lib-240',1)    #缺少與IF相對應的ENDIF
             RETURN '',FALSE
          END IF
          #直接跳到最近的一個ENDIF之后，即跳出當前的嵌套IF子句
          LET l_start = l_end + 5  
          #將嵌套層數遞減
          LET l_level = l_level - 1
       ELSE
       	  #l_level < 1的情況是不可能出現的
          RETURN '',FALSE
       END IF
    END IF
    #繼續循環吧
  END WHILE       
 
  #判斷方法□設定當前級別為1，凡遇到一個IF，則加1遇到一個ENDIF則減1，當級別重新
  #減為1的時候判斷最近的地方有沒有ELSE，如果有則這個就是本級的ELSE，否則重復上面
  #的操作直至找到為止
 
  #初始化起始位置     
  LET l_start = l_then + 4 
  #初始化當前級別為1
  LET l_level = 1   
  WHILE TRUE
    #首先看看有沒有下一個IF，以及它的位置在哪里
    LET l_if = cl_fml_get_next_word(l_str_buf,'IF',l_start)
    LET l_else = cl_fml_get_next_word(l_str_buf,'ELSE',l_start)
    LET l_end = cl_fml_get_next_word(l_str_buf,'ENDIF',l_start)
 
    #以下要結合當前的嵌套層次來進行判別，如果當前沒有嵌套(l_level = 1)，則
    #比較下一個IF和ELSE的相對位置，如果當前是在嵌套中(l_level > 1)，則不關心
    #ELSE，只需要找下一個ENDIF并跳出嵌套即可
    IF l_level = 1 THEN
       #如果中途出現找不到ELSE的情況，則說明所有ELSE都是包含在嵌套子句中的，
       #本級IF句子實際上是沒有ELSE的,這時剩下的內容除去尾部的那個ENDIF之外
       #全部是[結果1]，[結果2]為空即可
       IF l_else = 0 THEN
          LET l_result1 = l_str_buf.subString(l_then + 4,l_str_buf.getLength()-4)
          LET l_result1 = l_result1.trim()
          LET l_result2 = ''
          #就可以退出循環了
          EXIT WHILE
       END IF
       
       #下面可以保証l_else是大于0的了
       
       #判斷此時在ELSE前面是否有IF
       IF ( l_if > 0 )AND( l_if < l_else ) THEN
          #如果IF是最靠前的（即比最臨近的ENDIF位置要近）才算數
          IF (( l_end = 0 )OR  #有IF沒ENDIF
             (( l_end > 0 )AND( l_end > l_if ))) #有IF有ELSE且IF比較近 
          THEN       
             #如果發現了有IF則將嵌套級別加1并把搜索起始符向后移2位
             LET l_level = l_level + 1
             LET l_start = l_if + 2  
             
             #中止本次的while循環
             CONTINUE WHILE
          END IF
       END IF
              
       #如果程序能運行到這里，說明找到最外層的ELSE了，可以使用它作為result1和
       #result2的分界點
       #將THEN后面ELSE前面的部分作為[結果1]
       LET l_result1 = l_str_buf.subString(l_then + 4, l_else - 1 )
       #將ELSE后面最后一個ENDIF前面的部分作為[結果2]
       LET l_result2 = l_str_buf.subString(l_else + 4, l_str_buf.getLength()-5)
       LET l_result1 = l_result1.trim()
       LET l_result2 = l_result2.trim()
       #就可以退出循環了
       EXIT WHILE
 
       #上面是當l_level=1，即不在嵌套IF子句中的情況
    ELSE
       #下面是當處于IF嵌套子句中的情況l_level > 1
       IF l_level > 1 THEN
          #直接跳到最近的一個ENDIF之后，即跳出當前的嵌套IF子句
          LET l_start = l_end + 5  
          #將嵌套層數遞減
          LET l_level = l_level - 1
       ELSE
       	  #l_level < 1的情況是不可能出現的
          RETURN '',FALSE
       END IF
    END IF
    #繼續循環吧
  END WHILE       
 
  #清除條件段中可能存在的IF嵌套
  CALL cl_fml_rep_logic(l_condition) RETURNING l_condition,l_result
  IF l_result = FALSE THEN
     CALL cl_err('','lib-269',1)    #IF子句條件語法錯誤
     RETURN '',FALSE
  END IF
  
  #現在可以保証分離完成了，可以調用cl_fml_test_condition判斷函數來決定返回哪個值
  CALL cl_fml_test_condition(l_condition) RETURNING l_result
 
  #如果返回一個正數（按道理只可能為1，但謹慎起見寫成>0)
  #表示condition成立，返回result1
  IF l_result > 0 THEN
     RETURN l_result1,TRUE
  ELSE
     #如果測試結果為0表示condition不成立,返回result2
     IF l_result = 0 THEN
        RETURN l_result2,TRUE
     ELSE
     	#如果測試結果為負數，表示出現錯誤，返回一個錯誤結果
        RETURN '',FALSE
     END IF
  END IF 
  
END FUNCTION
 
# Descriptions...: 該函數循環解析傳入文本中出現的所有邏輯式，并用結果替換其位置，
#                  嵌套調用上面的cl_fml_run_if()函數來從外到里解析每一層的邏輯式，
#                  真正的分析處理工作是在cl_fml_run_if()函數里完成的，本函數的功能
#                  只是循環地找到文本中的每一個最外層IF子句并傳給它，如果該函數執行
#                  成功則返回已經不包含任何IF結構的一個完成型字符串，否則返回相應的
#                  錯誤提示（兩個返回值，一個是結果字符串，一個是狀態碼）
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_rep_logic(p_content)
DEFINE
  p_content               STRING,
 
  l_sub,l_sub_if          STRING,
  l_str_buf               base.stringBuffer,
  l_start,l_first_start   LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_end,l_last_end        LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_level,l_if            LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_res_str,l_tmp_str     STRING,
  l_result                LIKE type_file.num5      #No.FUN-690005 SMALLINT
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET p_content = p_content.trim()
  #如果傳入的參數為一個空串，則返回一個空串并不報錯
  IF p_content.getLength() = 0 THEN
     RETURN '',TRUE
  END IF
 
  LET l_str_buf = base.stringBuffer.create()
  LET l_tmp_str = p_content.trim()
  CALL l_str_buf.append(l_tmp_str)  
 
  LET l_start = 1 
  WHILE l_start > 0
    #在句子中定位第一個出現的IF的位置(代表著IF句子的起始位置)
    LET l_start = cl_fml_get_next_word(l_str_buf,'IF',1)
  
    #如果文本中沒有發現任何IF邏輯句的開頭標志則直接退出
    IF l_start = 0 THEN EXIT WHILE END IF
 
    #記錄下本輪搜索的最外層IF起始位置
    LET l_first_start = l_start
    #初始化起始搜索位置，從'IF'后開始搜索
    LET l_start = l_start + 2 
    #初始化嵌套級別，其后如果進入嵌套則遞增，退出嵌套則遞減
    LET l_level = 1  
    
    #循環搜索
    WHILE TRUE
      #看看接下來最先遇到誰，如果遇到的是ELSE或ENDIF則表示
      #當前的IF語句沒有嵌套，如果先遇到的仍然是IF則說明有嵌套
      LET l_if = cl_fml_get_next_word(l_str_buf,'IF',l_start)
      LET l_end = cl_fml_get_next_word(l_str_buf,'ENDIF',l_start)
      
      #如果沒有找到對應的ENDIF則表示出現了錯誤
      IF l_end = 0 THEN
         CALL cl_err('','lib-240',1)    #缺少與IF對應的ENDIF
         RETURN '',FALSE
      END IF
      
      #如果有嵌套(必須是遇到了IF且IF在ENDIF的前面)
      IF l_if > 0 AND l_if < l_end THEN
         #進入嵌套IF
         LET l_level = l_level + 1
         LET l_start = l_if + 2 
      ELSE
         #否則要看當前的嵌套等級是多少，如果嵌套等級為1則直接退出循環，
         #因為已經找到了最外層IF對應的END IF
         IF l_level = 1 THEN 
            LET l_last_end = l_end
            EXIT WHILE
         ELSE
            #否則理解為出退出當前嵌套層次
            LET l_level = l_level - 1
            LET l_start = l_end + 5  #從ENDIF開始繼續搜索
         END IF
      END IF
      
    END WHILE
    #現在l_first_start和l_last_end之間包的字符串就是整個IF句子（應該是字符串
    #中的第一個IF句子，在整個文本中可能可以會出現多個IF句子，比如下面這個例子□
    #( IF A > 3 THEN 5 ELSE 3 ENDIF ) * 3 + ( IF $B$ < 2 THEN $C + 5 ELSE 6 ENDIF )
    #本函數會做循環依次消滅每一個IF句子
    #LET l_sub_if = l_str_buf.subString(l_first_start,l_last_end+5) #得到這個IF句子
    LET l_sub_if = l_str_buf.subString(l_first_start,l_last_end+4) #得到這個IF句子
    #消滅它
    CALL cl_fml_run_if(l_sub_if) RETURNING l_res_str,l_result
    IF l_result = FALSE THEN
       RETURN '',FALSE
    ELSE
       CALL l_str_buf.replace(l_sub_if,l_res_str,0)
    END IF
    
    #繼續循環直到消滅每一個IF句子
    LET l_start = cl_fml_get_next_word(l_str_buf,'IF',1)
  END WHILE
    
  #如果整個串里都不包含IF了，則把整個字符串當做結果返回
  RETURN l_str_buf.toString(),TRUE
 
END FUNCTION
 
# Descriptions...: 該函數清除傳入文本中的注釋信息（包含在一對{}中），返回清除完成后的
#                  文本和操作的狀態碼，如果文本中存在只有"{"而沒有對應的"}"或反過來的
#                  情況則返回FALSE，否則返回TRUE
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_clear_comment(p_content)
DEFINE
  p_content               STRING,
  l_start,l_end           LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  l_str_buf               base.stringBuffer
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  #如果傳入文本為空則直接返回一個空
  IF p_content.getLength() = 0 THEN
     RETURN '',TRUE
  END IF 
 
  LET l_str_buf = base.stringBuffer.create()
  CALL l_str_buf.append(p_content)
 
  LET l_start = 1
  WHILE TRUE
    #在文本中定位{
    LET l_start = l_str_buf.getIndexOf('{',l_start)
   
    #如果沒有發現{
    IF l_start = 0 THEN
       #看看有沒有多余的}
       LET l_end = l_str_buf.getIndexOf('}',l_start)
       #如果發現多余的}則報錯
       IF l_end > 0 THEN
          CALL cl_err('','lib-291',1)  #在公式中出現了多余的}字符
          RETURN '',FALSE
       ELSE
       	  #否則說明整個文本中已經不包含任何{和}字符，可以返回了
       	  RETURN l_str_buf.toString(),TRUE
       END IF
    ELSE
      #如果發現了{
      LET l_end = l_str_buf.getIndexOf('}',l_start)
      #如果發現了對應的}則將其中包含的內容除去
      IF l_end > 0 THEN
         CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),'',0)      
      ELSE
      	 #否則報一個錯
      	 CALL cl_err('','lib-292',1)  #在公式中出現了多余的{字符
      	 RETURN '',FALSE
      END IF
    END IF
  END WHILE
  #實際上程序是永遠不可能走到這里的
END FUNCTION
 
# Descriptions...: 顯示范例字符串
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_example()
DEFINE
  l_str       STRING,
  l_ze03      LIKE ze_file.ze03
  
  #注釋及數學運算
  LET l_str = '--------------------------------------------------------------------------------\n'
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'aoo-158' AND ze02 = g_lang
  LET l_str = l_str,l_ze03 CLIPPED,"\n",
              '--------------------------------------------------------------------------------\n'
  LET l_str = l_str,"{This is a comment}\n",
              "2+3*(2-5)/2\n\n",
              '--------------------------------------------------------------------------------\n'
  
  #邏輯判斷
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'aoo-159' AND ze02 = g_lang
  LET l_str = l_str,l_ze03 CLIPPED,'\n',
              '--------------------------------------------------------------------------------\n'
  LET l_str = l_str,"IF (( $VAR$ > 200 )AND( $NAM$ IN ('20','30','40'))) THEN\n",
                    "   IF $VAR$ BETWEEN $MIN$ AND $MAX$ THEN\n",
                    "      'It is in range'\n",
                    "   ELSE\n",
                    "      'It is out of range'\n",
                    "   ENDIF\n",
                    "ELSE\n",
                    "   'Cannot compare the value'\n",
                    "ENDIF\n\n",
                    "--------------------------------------------------------------------------------\n"
           
  #內置表達式         
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'aoo-160' AND ze02 = g_lang
  LET l_str = l_str,l_ze03 CLIPPED,'\n',
              '--------------------------------------------------------------------------------\n'
  LET l_str = l_str,"2*(3+&AVG&)-12\n\n",                    	
                    "--------------------------------------------------------------------------------\n"
                    
  #內置SQL語句和SHELL語句         
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'aoo-161' AND ze02 = g_lang
  LET l_str = l_str,l_ze03 CLIPPED,'\n',
              '--------------------------------------------------------------------------------\n'
  LET l_str = l_str,"IF <SQL=SELECT COUNT(*) FROM IMA_FILE WHERE IMA01 LIKE '01%'/SQL> > 0 THEN\n",
                    "   <SHELL=mv filename1 filename2/SHELL>\n",
                    "ELSE\n",
                    "   <SQL=SELECT MAX(IMA01) FROM IMA_FILE/SQL>\n",
                    "ENDIF\n\n",
                    "--------------------------------------------------------------------------------\n"
                    
  #內置函數調用
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'aoo-162' AND ze02 = g_lang
  LET l_str = l_str,l_ze03 CLIPPED,'\n',
              '--------------------------------------------------------------------------------\n'
  LET l_str = l_str,"IF ( IF ABS($VAR$)>10 THEN $VAR$ ELSE $VAR$+10 ENDIF ) > 0 THEN\n",
                    "   SIN($TES$)\n",
                    "ELSE\n",
                    "   COS($VAR$)\n",
                    "ENDIF\n\n"
 
  RETURN l_str                    
END FUNCTION
 
#---------------------------------------------------------------
#  這里是核心函數
#---------------------------------------------------------------
# Descriptions...: 該函數解析一個公式并返回計算結果，傳入參數為“參數名|參數值|參數名|參數值”格式
#                  的字符串。返回值為公式計算的結果和返回狀態，如果解析中途出現錯誤則
#                  返回空字符串和錯誤的狀態碼(FALSE)
#                  傳入參數p_call_type表示是外部調用還是內部調用，其中我們在別的程式中調用均屬于
#                  外部調用，內部調用是特指函數中嵌套調用自身時使用的標識，兩者之間的區別為外部調用
#                  需要初始化以下參數數組，而內部調用不需要，直接借用已經在最外層調用時初始化并填充
#                  好的全局數組就行了，p_call_type = -3885表示內部調用，其他數值均為外部調用
# Input Parameter:
# Return Code....:
 
FUNCTION cl_fml_run_content(p_content,p_param_list,p_call_type)
DEFINE
  p_content                           STRING,
  p_param_list                        STRING,
  p_call_type                         LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  
  l_express_list,l_tmp_content        STRING,
  l_content,l_exp,l_result            STRING,
  l_status                            LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
  l_exp_tok                           base.StringTokenizer,
  l_exp_buf                           base.StringBuffer,
  l_grm_buf                           base.StringBuffer
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  #得到公式內容(首先清除可能有的注釋內容)
  CALL cl_fml_clear_comment(p_content) RETURNING l_content,l_status
  
  #以下根據p_param_list參數是否為空來判斷本次調用是屬于頂層調用還是屬于
  #嵌套調用，如果是頂層調用則需要先初始化一下參數數組并填充其中的內容，如果
  #是嵌套調用則不需要這些操作了，因為在開始時已經初始化過，只需要使用公共
  #數組就可以了
  #如果該公式本來就不使用參數，那么也無所謂下面要做的對公共數組的操作
  IF p_call_type <> -3885 THEN
     #根據公式名稱得到計算公式所需的所有參數并填充公共數組
     CALL g_fml_param.clear() #CHI-D10055
     LET g_i = 1 #CHI-D10055 
     IF NOT cl_fml_fill_param_list(p_content) THEN RETURN '',FALSE END IF
  
     #根據傳入的參數列表填充公共數組
     IF NOT cl_fml_get_param_value(p_param_list) THEN RETURN '',FALSE END IF
  END IF
  
  #根據公共數組中的內容來替換公式中的所有屬性，常量和變量
  LET l_content = cl_fml_rep_parameter(l_content)
  
  #替換公式中出現的表達式
  LET l_express_list = cl_fml_extract_param(l_content,'&')
  #如果公式中包含表達式信息則嵌套調用自身來解析每一個表達式
  IF l_express_list.getLength() > 0 THEN
     #這個StringBuffer對象是用于用計算結果來替換公式名稱的
     LET l_exp_buf = base.StringBuffer.create()
     CALL l_exp_buf.append(l_content)
     #開始拆解每一個表達式
     LET l_exp_tok = base.StringTokenizer.create(l_express_list,'|')
     WHILE l_exp_tok.hasMoreTokens()
       LET l_exp = l_exp_tok.nextToken()
       IF NOT l_exp IS NULL THEN
          #調用自身來計算這個表達式并接收返回值
          LET l_tmp_content = cl_fml_get_content(l_exp)
          CALL cl_fml_run_content(l_tmp_content,'',-3885) RETURNING l_result,l_status
          #只要嵌套調用過程中的任何一個步驟出現錯誤，則立即會退出整個過程
          IF NOT l_status THEN
             RETURN '',l_status
          ELSE
             #如果調用過程正常結束，則用表達式的計算結果來替換原來在公式中的為止
             CALL l_exp_buf.replace(l_exp,l_result,0)
          END IF
          #這樣就消滅了一個子表達式，繼續循環直到消滅了所有的子表達式為止
       END IF
     END WHILE
     LET l_content = l_exp_buf.toString()
  END IF
 
  #到這里為止公式里只剩下各種標記、邏輯式和一般計算式了
 
  #計算公式里可能有的<SQL= ... /SQL>標記和<SHELL= ... /SHELL>標記
  CALL cl_fml_rep_sign(l_content) RETURNING l_content,l_status
  IF NOT l_status THEN
     RETURN '',l_status
  END IF
 
  #到這里為止公式里只剩下單純的邏輯式和一般計算式了
  
  #接下來解析所有的邏輯式
  CALL cl_fml_rep_logic(l_content) RETURNING l_content,l_status
  IF NOT l_status THEN
     RETURN '',l_status
  END IF
 
  #No.MOD-8C0242 add --begin
  LET l_content = cl_replace_str(l_content,'\n',' ')
  #No.MOD-8C0242 add --end
  
  #接下來應該只剩一個最后的一般計算式了，解析它即得到整個公式的結果
  CALL cl_fml_run_sql(l_content) RETURNING l_content,l_status         #mark By Beryl 130718此句造成sql解析失败
 
  #返回最后的計算結果和狀態
  RETURN l_content.trim(),l_status
  
END FUNCTION
 
# Descriptions...: 執行公式       #FUN-B50108
# Input Parameter: 傳入公式名和參數列表
# Return Code....: 返回公式的值
 
 
FUNCTION cl_fml_run(p_formula_name,p_param_list)
DEFINE
  p_formula_name	   	      LIKE gep_file.gep01,
  p_param_list                        STRING,
 
  l_res,l_content                     STRING,
  l_status                            LIKE type_file.num5     #No.FUN-690005 SMALLINT
 
  #根據公式名稱得到公式的內容
  LET l_content = cl_fml_get_content(p_formula_name)
  #如果沒有找到對應的公式則直接將公式的名稱當做公式的解析結果返回
  IF l_content.getLength() = 0 THEN
     RETURN p_formula_name,TRUE
  END IF
 
  #調用cl_fml_run_content來計算公式并返回結果
  CALL cl_fml_run_content(l_content , p_param_list,1) RETURNING l_res,l_status
  RETURN l_res,l_status
END FUNCTION
