# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Program name...: cs_fifo.4gl
# Descriptions...: 库存先进先出提示
# Date & Author..:darcy:2023/04/03

database ds    #FUN-850069  FUN-7C0053
 
globals "../../../tiptop/config/top.global"
globals "../../../tiptop/config/darcy.global"



# 提示是否还有更早的库存
# 调用前自己调用s_showmsg_init，与s_showmsg
# 有效日期查询
function cs_fifo(p_img) 
    define p_img dynamic array of fifo_img
    define l_sql string
    define l_img18  like img_file.img18
    define l_cnt,l_i,l_j,l_k    like type_file.num5
    define l_img dynamic array of record
        fifo_imgcheck    like type_file.chr1,
        fifo_img01       like img_file.img01,
        fifo_ima02       like ima_file.ima02,
        fifo_ima021      like ima_file.ima021,
        fifo_img02       like img_file.img02,
        fifo_img03       like img_file.img03,
        fifo_img04       like img_file.img04,
        fifo_img09       like img_file.img09,
        fifo_img10       like img_file.img10,
        fifo_img18       like img_file.img18
        end record
    define l_img_excel dynamic array of record
        fifo_imgcheck    like type_file.chr1,
        fifo_img01       like img_file.img01,
        fifo_ima02       like ima_file.ima02,
        fifo_ima021      like ima_file.ima021,
        fifo_img02       like img_file.img02,
        fifo_img03       like img_file.img03,
        fifo_img04       like img_file.img04,
        fifo_img09       like img_file.img09,
        fifo_img10       like img_file.img10,
        fifo_img18       like img_file.img18
        end record

    #1. 
    if p_img.getlength() = 0 then
        call cl_err("无资料需要处理","!",0)
        return
    end if

    if g_bgjob = 'Y' then
        return
    end if

    let l_sql = "SELECT 'Y',img01, ima02, ima021, img02, img03, img04, img09,img10, img18
                  FROM img_file, ima_file
                  WHERE img01 = ?
                  AND ima01 = img01
                  AND NOT (img02 = ? AND img03 = ? AND img04 = ?)
                        AND img10 > 0 AND img18 < ? "
    prepare fifo_p from l_sql
    declare fifo_c cursor for fifo_p
    
    let l_i = 1
    for l_cnt = 1 to p_img.getlength()
        #2. 找到有效日期
        if cl_null(p_img[l_cnt].img18) then
            select img18 into p_img[l_cnt].img18 from img_file
             where img01 = p_img[l_cnt].img01 and img02 = p_img[l_cnt].img02
               and img03= p_img[l_cnt].img03 and img04 = p_img[l_cnt].img04
            if cl_null(p_img[l_cnt].img18) or status then
                exit for
            end if
        end if

        foreach fifo_c using p_img[l_cnt].img01,p_img[l_cnt].img02,p_img[l_cnt].img03,p_img[l_cnt].img04,p_img[l_cnt].img18
           into l_img[l_i].*

            if status then
                call cl_err("fifo_c",status,1)
                return
            end if
            let l_i = l_i + 1

        end foreach

    end for

    call l_img.deleteElement(l_i)
    let l_i = l_i - 1

    if l_img.getlength() = 0 then
        return
    end if

    open window fifo_w with form 'csub/42f/cs_fifo'
    CALL cl_ui_locale("cs_fifo")

    display l_i to fifo_cnt 
    display '以下有更早的料件可以选择，请确认。' to fifo_title

    input array l_img without defaults from s_fifo_img.*
            attributes ( unbuffered,APPEND ROW=false,DELETE ROW=false,INSERT ROW=false)
        
        on action selectall
            for l_j = 1 to l_img.getlength()
                let l_img[l_j].fifo_imgcheck = 'Y'
            end for
        on action unselect
            for l_j = 1 to l_img.getlength()
                let l_img[l_j].fifo_imgcheck = iif(l_img[l_j].fifo_imgcheck = 'Y','N','Y')
            end for
        on action fifo_out
            let l_k = 1
            call l_img_excel.clear()
            for l_j = 1 to l_img.getlength()
                if l_img[l_j].fifo_imgcheck = 'Y' then
                    let l_img_excel[l_k].* = l_img[l_k].*
                    let l_k = l_k + 1
                end if
            end for
            call cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_img_excel),'','')

    end input

    close window fifo_w
end function


# 检查有效期是否小于15天
function cs_fifo_validity(p_img)
    define p_img dynamic array of fifo_img
    define l_sql string
    define l_img18  like img_file.img18
    define l_cnt,l_i,l_j,l_k    like type_file.num5
    define l_img dynamic array of record
        fifo_imgcheck    like type_file.chr1,
        fifo_img01       like img_file.img01,
        fifo_ima02       like ima_file.ima02,
        fifo_ima021      like ima_file.ima021,
        fifo_img02       like img_file.img02,
        fifo_img03       like img_file.img03,
        fifo_img04       like img_file.img04,
        fifo_img09       like img_file.img09,
        fifo_img10       like img_file.img10,
        fifo_img18       like img_file.img18
        end record
    define l_img_excel dynamic array of record
        fifo_imgcheck    like type_file.chr1,
        fifo_img01       like img_file.img01,
        fifo_ima02       like ima_file.ima02,
        fifo_ima021      like ima_file.ima021,
        fifo_img02       like img_file.img02,
        fifo_img03       like img_file.img03,
        fifo_img04       like img_file.img04,
        fifo_img09       like img_file.img09,
        fifo_img10       like img_file.img10,
        fifo_img18       like img_file.img18
        end record
    define l_success    varchar(1)
    
    #1. 无资料和背景执行不需要检查
    if p_img.getlength() = 0 then
        call cl_err("无资料需要处理","!",0)
        return true
    end if

    if g_bgjob = 'Y' then
        return true
    end if

    let l_sql = "SELECT 'Y',img01, ima02, ima021, img02, img03, img04, img09,img10, img18
                  FROM img_file, ima_file
                  WHERE img01 = ?
                  AND ima01 = img01
                  AND img02 = ? AND img03 = ? AND img04 = ?"
    prepare fifo_p2 from l_sql
    declare fifo_c2 cursor for fifo_p2

    let l_sql = "select img18 from img_file where img01 = ? and img02=? and img03 =? and img04 =? "
    prepare fifo_p3 from l_sql 

    let l_i = 1

    for l_cnt = 1 to p_img.getlength()
        let l_img18 = ''
        execute fifo_p3 using p_img[l_cnt].img01,p_img[l_cnt].img02,p_img[l_cnt].img03,p_img[l_cnt].img04
           into l_img18
        if sqlca.sqlcode then 
            let l_img[l_i].fifo_imgcheck = 'Y'
            let l_img[l_i].fifo_img01   = p_img[l_cnt].img01

            select ima02,ima021 into l_img[l_i].fifo_ima02 ,l_img[l_i].fifo_ima021 from ima_file
             where ima01 = p_img[l_cnt].img01

            let l_img[l_i].fifo_img02   = p_img[l_cnt].img02
            let l_img[l_i].fifo_img03   = p_img[l_cnt].img03
            let l_img[l_i].fifo_img04   = p_img[l_cnt].img04
            let l_img[l_i].fifo_img09   = ''
            let l_img[l_i].fifo_img10   = ''
            let l_img[l_i].fifo_img18   = ''
            let l_i = l_i + 1
        end if
        # 剩余有效期天数小于14天提醒
        if l_img18 - g_today <=14 then
            execute fifo_p2 using p_img[l_cnt].img01,p_img[l_cnt].img02,p_img[l_cnt].img03,p_img[l_cnt].img04
               into l_img[l_i].*
            let l_i = l_i + 1
        end if
    end for

    call l_img.deleteElement(l_i)
    let l_i = l_i - 1

    # 如果没有资料就略过
    if l_img.getlength() = 0 then
        return true
    end if

    open window fifo_w with form 'csub/42f/cs_fifo'
    CALL cl_ui_locale("cs_fifo")

    display l_i to fifo_cnt 
    display '以下剩余有效天数小于等于15天，请确认。' to fifo_title

    input array l_img without defaults from s_fifo_img.*
            attributes ( unbuffered,APPEND ROW=false,DELETE ROW=false,INSERT ROW=false)
        
        on action selectall
            for l_j = 1 to l_img.getlength()
                let l_img[l_j].fifo_imgcheck = 'Y'
            end for
        on action unselect
            for l_j = 1 to l_img.getlength()
                let l_img[l_j].fifo_imgcheck = iif(l_img[l_j].fifo_imgcheck = 'Y','N','Y')
            end for
        on action fifo_out
            let l_k = 1
            call l_img_excel.clear()
            for l_j = 1 to l_img.getlength()
                if l_img[l_j].fifo_imgcheck = 'Y' then
                    let l_img_excel[l_k].* = l_img[l_k].*
                    let l_k = l_k + 1
                end if
            end for
            call cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_img_excel),'','')
        on action accept
            let l_success = true
            exit input
        on action cancel
            let l_success = false
            exit input
    end input

    close window fifo_w

    if int_flag then
        let int_flag = false
    end if
    return l_success
    
end function


# 提示是否还有更早的库存
# 调用前自己调用s_showmsg_init，与s_showmsg
function cs_fifo_check(p_img) 
    define p_img dynamic array of fifo_img
    define l_sql string
    define l_img18  like img_file.img18
    define l_cnt,l_i,l_j,l_k    like type_file.num5
    define l_img dynamic array of record
        fifo_imgcheck    like type_file.chr1,
        fifo_img01       like img_file.img01,
        fifo_ima02       like ima_file.ima02,
        fifo_ima021      like ima_file.ima021,
        fifo_img02       like img_file.img02,
        fifo_img03       like img_file.img03,
        fifo_img04       like img_file.img04,
        fifo_img09       like img_file.img09,
        fifo_img10       like img_file.img10,
        fifo_img18       like img_file.img18
        end record
    define l_img_excel dynamic array of record
        fifo_imgcheck    like type_file.chr1,
        fifo_img01       like img_file.img01,
        fifo_ima02       like ima_file.ima02,
        fifo_ima021      like ima_file.ima021,
        fifo_img02       like img_file.img02,
        fifo_img03       like img_file.img03,
        fifo_img04       like img_file.img04,
        fifo_img09       like img_file.img09,
        fifo_img10       like img_file.img10,
        fifo_img18       like img_file.img18
        end record
    define l_img04      char(20)

    #1. 
    if p_img.getlength() = 0 then
        call cl_err("无资料需要处理","!",1)
    end if

    if g_bgjob = 'Y' then
        return
    end if

    let l_sql = "SELECT 'Y',img01, ima02, ima021, img02, img03, img04, img09,img10, img18
                  FROM img_file, ima_file
                  WHERE img01 = ?
                  AND ima01 = img01
                  AND NOT (img02 = ? AND img03 = ? AND img04 = ?)
                        AND img10 > 0 AND substr(img04,1,8) < ? "
    prepare fifo_p4 from l_sql
    declare fifo_c3 cursor for fifo_p4
    
    let l_i = 1
    for l_cnt = 1 to p_img.getlength()
        #2. 找到批号前八位
        let l_img04 = p_img[l_cnt].img04
        let l_img04 = l_img04[1,8]
        if p_img[l_cnt].img02 <> 'S001' and p_img[l_cnt].img02 <> 'S010' then
            continue for
        end if
         
        foreach fifo_c3 using p_img[l_cnt].img01,p_img[l_cnt].img02,p_img[l_cnt].img03,p_img[l_cnt].img04,l_img04
           into l_img[l_i].*

            if status then
                call cl_err("fifo_c3",status,1)
                return
            end if
            let l_i = l_i + 1

        end foreach

    end for

    call l_img.deleteElement(l_i)
    let l_i = l_i - 1

    if l_img.getlength() = 0 then
        return
    end if

    open window fifo_w3 with form 'csub/42f/cs_fifo'
    CALL cl_ui_locale("cs_fifo")

    display l_i to fifo_cnt 
    display '以下有更早的料件可以选择，请确认。' to fifo_title

    input array l_img without defaults from s_fifo_img.*
            attributes ( unbuffered,APPEND ROW=false,DELETE ROW=false,INSERT ROW=false)
        
        on action selectall
            for l_j = 1 to l_img.getlength()
                let l_img[l_j].fifo_imgcheck = 'Y'
            end for
        on action unselect
            for l_j = 1 to l_img.getlength()
                let l_img[l_j].fifo_imgcheck = iif(l_img[l_j].fifo_imgcheck = 'Y','N','Y')
            end for
        on action fifo_out
            let l_k = 1
            call l_img_excel.clear()
            for l_j = 1 to l_img.getlength()
                if l_img[l_j].fifo_imgcheck = 'Y' then
                    let l_img_excel[l_k].* = l_img[l_k].*
                    let l_k = l_k + 1
                end if
            end for
            call cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_img_excel),'','')

    end input

    close window fifo_w3
end function
