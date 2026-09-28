# DATABASE ds
 
GLOBALS "../../config/top.global"

function cs_ima02(imz01)
    define imz01    like imz_file.imz01

    define ima021   like ima_file.ima021

    define l_tc_cmb dynamic array of record
        tc_cmb03    like tc_cmb_file.tc_cmb03,
        tc_cmb05    like tc_cmb_file.tc_cmb05,
        tc_cmb06    like tc_cmb_file.tc_cmb06,
        tc_cmb07    like tc_cmb_file.tc_cmb07,
        tc_cma10    like tc_cma_file.tc_cma10
        end record
    define l_tc_cmb_t dynamic array of record
        tc_cmb03    like tc_cmb_file.tc_cmb03,
        tc_cmb05    like tc_cmb_file.tc_cmb05,
        tc_cmb06    like tc_cmb_file.tc_cmb06,
        tc_cmb07    like tc_cmb_file.tc_cmb07,
        tc_cma10    like tc_cma_file.tc_cma10
        end record
    define cnt,index    like type_file.num5
    define  tok base.StringTokenizer

    define l_ac,l_n,count     like type_file.num5

    define l_item array[36] of varchar(100)
    define l_demo varchar(100)
    define l_ima021  varchar(2000)

    open window cs_ima02 with form "csub/42f/cs_ima02"
      attribute (style = g_win_style clipped)

    # 资料查询

    declare cs_ima02 cursor for 
        select tc_cmb03,tc_cmb05,tc_cmb06,tc_cmb07,tc_cma_file.tc_cma10 from tc_cmb_file,tc_cma_file
         where tc_cmb01 = imz01 and tc_cmb01=tc_cma01 and tc_cma03 ='Y'
         order by tc_cmb03
    let cnt = 1
    foreach cs_ima02 into l_tc_cmb[cnt].*
        if sqlca.sqlcode then
            call cl_err("cs_ima02",sqlca.sqlcode,1)
            exit foreach
        end if
        
        let l_tc_cmb_t[cnt].* = l_tc_cmb[cnt].*
         
        let l_tc_cmb[cnt].tc_cmb06 = ""
        let cnt = cnt + 1
    end foreach
    call l_tc_cmb.deleteElement(cnt)
    let count = cnt - 1

    ## 
    #input l_item1,l_item2,l_item3,l_item4,l_item5,l_item6,l_item7,l_item8,l_item9,l_item10,l_item11,l_item12,l_item13,l_item14,l_item15,l_item16,l_item17,l_item18,l_item19,l_item20,l_item21,l_item22,l_item23,l_item24,l_item25,l_item26,l_item27,l_item28,l_item29,l_item30,l_item31,l_item32,l_item33,l_item34,l_item35,l_item36
    # from ComboBox37,ComboBox38,ComboBox39,ComboBox40,ComboBox41,ComboBox42,ComboBox43,ComboBox44,ComboBox45,ComboBox46,ComboBox47,ComboBox48,ComboBox49,ComboBox50,ComboBox51,ComboBox52,ComboBox53,ComboBox54,ComboBox55,ComboBox56,ComboBox57,ComboBox58,ComboBox59,ComboBox60,ComboBox61,ComboBox62,ComboBox63,ComboBox64,ComboBox65,ComboBox66,ComboBox67,ComboBox68,ComboBox69,ComboBox70,ComboBox71,ComboBox72
    #    attribute (without defaults)
    begin work
    call cs_ima02_set_visiable(l_tc_cmb_t)
    # call cs_ima02_set_text()
    call cl_ui_init()
    INPUT l_item[1],l_item[2],l_item[3],l_item[4],l_item[5],l_item[6],l_item[7],l_item[8],l_item[9],l_item[10],l_item[11],l_item[12],l_item[13],l_item[14],l_item[15],l_item[16],l_item[17],l_item[18],l_item[19],l_item[20],l_item[21],l_item[22],l_item[23],l_item[24],l_item[25],l_item[26],l_item[27],l_item[28],l_item[29],l_item[30],l_item[31],l_item[32],l_item[33],l_item[34],l_item[35],l_item[36]
     FROM ComboBox37,ComboBox38,ComboBox39,ComboBox40,ComboBox41,ComboBox42,ComboBox43,ComboBox44,ComboBox45,ComboBox46,ComboBox47,ComboBox48,ComboBox49,ComboBox50,ComboBox51,ComboBox52,ComboBox53,ComboBox54,ComboBox55,ComboBox56,ComboBox57,ComboBox58,ComboBox59,ComboBox60,ComboBox61,ComboBox62,ComboBox63,ComboBox64,ComboBox65,ComboBox66,ComboBox67,ComboBox68,ComboBox69,ComboBox70,ComboBox71,ComboBox72
    # input by name l_item.*
        before input
            message ""
        after input
            let l_ima021 = cs_ima02_set_text(l_item,l_tc_cmb_t)
    end input

    rollback work

    close window cs_ima02
    return ima021
end function

function cs_ima02_set_visiable(p_tc_cmb)

    define count,index like type_file.num5
    define item varchar(100)
    define p_tc_cmb dynamic array of record
        tc_cmb03    like tc_cmb_file.tc_cmb03,
        tc_cmb05    like tc_cmb_file.tc_cmb05,
        tc_cmb06    like tc_cmb_file.tc_cmb06,
        tc_cmb07    like tc_cmb_file.tc_cmb07,
        tc_cma10    like tc_cma_file.tc_cma10
        end record

    let count = p_tc_cmb.getLength()

    if count > 36 then
        call cl_err("不支持超过36笔","!",1)
        return
    end if
    # 设置显示几个
    for index = 1 to count
        let item = "ComboBox"||index+36
        call cl_set_comp_visible(item,true)
        call cl_set_comp_required(item,true)
        # 设置说明
        let item = "combobox"||index+36
        update gae_file set gae04 = p_tc_cmb[index].tc_cmb05
         where gae01 = 'cs_ima02' and gae03 = 2 and gae02 = item
        # 设置下拉框的值
        call cl_set_combo_items(item,p_tc_cmb[index].tc_cmb06,p_tc_cmb[index].tc_cmb06)
    end for
    for index = count +1 to 36 
        call cl_set_comp_visible("ComboBox"||index+36,false)
    end for


end function

function cs_ima02_set_text(p_item,p_tc_cmb)
    define p_item array[36] of varchar(100)
    define p_tc_cmb dynamic array of record
        tc_cmb03    like tc_cmb_file.tc_cmb03,
        tc_cmb05    like tc_cmb_file.tc_cmb05,
        tc_cmb06    like tc_cmb_file.tc_cmb06,
        tc_cmb07    like tc_cmb_file.tc_cmb07,
        tc_cma10    like tc_cma_file.tc_cma10
        end record
    
    define index integer
    define text,temp  varchar(2000)

    let text = ""
    for index = 1 to p_tc_cmb.getLength()
        let temp = cl_replace_str(p_tc_cmb[index].tc_cmb07,"$2",p_tc_cmb[index].tc_cma10)
        let temp = cl_replace_str(temp,"$1",p_item[index])
        let text = text,temp
    end for

    return text

end function
