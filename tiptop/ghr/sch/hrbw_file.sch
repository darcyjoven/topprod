/*
================================================================================
檔案代號:hrbw_file
檔案名稱:员工卡片管理档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbw_file
(
hrbw01      varchar2(50) NOT NULL,   /* 员工ID                                */
hrbw02      varchar2(50) NOT NULL,   /* 卡号                                  */
hrbw03      date NOT NULL,           /* 发卡日期                              */
hrbw04      varchar2(50),            /* 发卡人                                */
hrbw05      date,                    /* 生效日期                              */
hrbw06      date,                    /* 失效日期                              */
hrbw07      varchar2(255),           /* 备注                                  */
hrbwacti    varchar2(1),             /* 资料有效否                            */
hrbwud01    varchar2(255),           /* 自订栏位-Textedit                     */
hrbwud02    varchar2(40),            /* 自订栏位-文字                         */
hrbwud03    varchar2(40),            /* 自订栏位-文字                         */
hrbwud04    varchar2(40),            /* 自订栏位-文字                         */
hrbwud05    varchar2(40),            /* 自订栏位-文字                         */
hrbwud06    varchar2(40),            /* 自订栏位-文字                         */
hrbwud07    number(15,3),            /* 自订栏位-数值                         */
hrbwud08    number(15,3),            /* 自订栏位-数值                         */
hrbwud09    number(15,3),            /* 自订栏位-数值                         */
hrbwud10    number(10),              /* 自订栏位-整数                         */
hrbwud11    number(10),              /* 自订栏位-整数                         */
hrbwud12    number(10),              /* 自订栏位-整数                         */
hrbwud13    date,                    /* 自订栏位-日期                         */
hrbwud14    date,                    /* 自订栏位-日期                         */
hrbwud15    date,                    /* 自订栏位-日期                         */
hrbwuser    varchar2(10),            /* 资料所有者                            */
hrbwgrup    varchar2(10),            /* 资料所有群                            */
hrbwmodu    varchar2(10),            /* 资料更改者                            */
hrbwdate    date,                    /* 最近修改日                            */
hrbworig    varchar2(10),            /* 资料建立部门                          */
hrbworiu    varchar2(10)             /* 资料建立者                            */
);

create        index tic_hrbw_02 on hrbw_file (hrbw01,hrbw02,hrbw05,hrbw06,hrbw03,hrbw04,hrbw07);
alter table hrbw_file add  constraint tpc_hrbw_pk primary key  (hrbw01,hrbw02,hrbw03) enable validate;
grant select on hrbw_file to tiptopgp;
grant update on hrbw_file to tiptopgp;
grant delete on hrbw_file to tiptopgp;
grant insert on hrbw_file to tiptopgp;
grant index on hrbw_file to public;
grant select on hrbw_file to ods;
