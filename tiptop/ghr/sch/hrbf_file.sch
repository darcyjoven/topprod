/*
================================================================================
檔案代號:hrbf_file
檔案名稱:合同签订管理
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbf_file
(
hrbf01      varchar2(20) NOT NULL,   /*合同编号                               */
hrbf02      varchar2(20),            /*员工工号                               */
hrbf03      varchar2(20),            /*签订类型                               */
hrbf04      varchar2(20),            /*合同类型编码                           */
hrbf05      varchar2(1),             /*是否无固定期限合同                     */
hrbf06      varchar2(50),            /*合同名称                               */
hrbf07      varchar2(20),            /*是否应届毕业生                         */
hrbf08      date,                    /*合同生效日                             */
hrbf09      date,                    /*合同终止日                             */
hrbf10      date,                    /*签订日期                               */
hrbf11      varchar2(20),            /*签约用工单位                           */
hrbf12      varchar2(255),           /*备注                                   */
hrbfacti    varchar2(1),             /*资料有效码                             */
hrbfuser    varchar2(10),            /*资料所有者                             */
hrbfgrup    varchar2(10),            /*资料所有群                             */
hrbfmodu    varchar2(10),            /*资料更改者                             */
hrbfdate    date,                    /*最近修改日                             */
hrbforiu    varchar2(10),            /*资料建立者                             */
hrbforig    varchar2(10),            /*资料建立部门                           */
hrbfud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbfud02    varchar2(40),            /*自订栏位-文字                          */
hrbfud03    varchar2(40),            /*自订栏位-文字                          */
hrbfud04    varchar2(40),            /*自订栏位-文字                          */
hrbfud05    varchar2(40),            /*自订栏位-文字                          */
hrbfud06    varchar2(40),            /*自订栏位-文字                          */
hrbfud07    number(15,3),            /*自订栏位-数值                          */
hrbfud08    number(15,3),            /*自订栏位-数值                          */
hrbfud09    number(15,3),            /*自订栏位-数值                          */
hrbfud10    number(10),              /*自订栏位-整数                          */
hrbfud11    number(10),              /*自订栏位-整数                          */
hrbfud12    number(10),              /*自订栏位-整数                          */
hrbfud13    date,                    /*自订栏位-日期                          */
hrbfud14    date,                    /*自订栏位-日期                          */
hrbfud15    date                     /*自订栏位-日期                          */
);

alter table hrbf_file add  constraint tpc_hrbf_pk primary key  (hrbf01) enable validate;
grant select on hrbf_file to tiptopgp;
grant update on hrbf_file to tiptopgp;
grant delete on hrbf_file to tiptopgp;
grant insert on hrbf_file to tiptopgp;
grant index on hrbf_file to public;
grant select on hrbf_file to ods;
