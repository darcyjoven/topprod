/*
================================================================================
檔案代號:hrdm_file
檔案名稱:员工薪资类别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdm_file
(
hrdm01      varchar2(20) NOT NULL,   /*流水码                                 */
hrdm02      varchar2(20),            /*员工ID                                 */
hrdm03      varchar2(20),            /*薪资类别                               */
hrdm04      varchar2(50),            /*生效薪资月                             */
hrdm05      varchar2(50),            /*失效薪资月                             */
hrdm06      varchar2(20),            /*设置人ID                               */
hrdm07      date,                    /*设置日期                               */
hrdm08      number(5),               /*发薪次数                               */
hrdm09      varchar2(50),            /*撤销薪资月                             */
hrdm10      varchar2(20),            /*新单据流水码                           */
hrdm11      varchar2(255),           /*备注                                   */
hrdm12      varchar2(1),             /*标志                                   */
hrdmacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdmuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdmgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdmmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdmdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdmoriu    varchar2(10),            /*资料建立者                             */
hrdmorig    varchar2(10),            /*资料建立部门                           */
hrdmud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdmud02    varchar2(40),            /*自订栏位-文字                          */
hrdmud03    varchar2(40),            /*自订栏位-文字                          */
hrdmud04    varchar2(40),            /*自订栏位-文字                          */
hrdmud05    varchar2(40),            /*自订栏位-文字                          */
hrdmud06    varchar2(40),            /*自订栏位-文字                          */
hrdmud07    number(15,3),            /*自订栏位-数值                          */
hrdmud08    number(15,3),            /*自订栏位-数值                          */
hrdmud09    number(15,3),            /*自订栏位-数值                          */
hrdmud10    number(10),              /*自订栏位-整数                          */
hrdmud11    number(10),              /*自订栏位-整数                          */
hrdmud12    number(10),              /*自订栏位-整数                          */
hrdmud13    date,                    /*自订栏位-日期                          */
hrdmud14    date,                    /*自订栏位-日期                          */
hrdmud15    date,                    /*自订栏位-日期                          */
hrdm13      varchar2(1)              /*是否无限期                             */
);

alter table hrdm_file add  constraint tpc_hrdm_pk primary key  (hrdm01) enable validate;
grant select on hrdm_file to tiptopgp;
grant update on hrdm_file to tiptopgp;
grant delete on hrdm_file to tiptopgp;
grant insert on hrdm_file to tiptopgp;
grant index on hrdm_file to public;
grant select on hrdm_file to ods;
