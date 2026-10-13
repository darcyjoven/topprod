/*
================================================================================
檔案代號:hraa_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hraa_file
(
hraa01      varchar2(10) NOT NULL,   /*公司编码                               */
hraa02      varchar2(50),            /*公司简介                               */
hraa03      varchar2(50),            /*英文名称                               */
hraa04      number(15,2),            /*所有权份额                             */
hraa05      varchar2(20),            /*所属行业ID                             */
hraa06      varchar2(4000),          /*公司简介                               */
hraa07      varchar2(1),             /*是否控股                               */
hraa08      varchar2(255),           /*公司标示                               */
hraa09      varchar2(255),           /*报表标示                               */
hraa10      varchar2(10),            /*上级公司                               */
hraa11      varchar2(3),             /*排序标志                               */
hraa12      varchar2(100),           /*公司名称                               */
hraa13      varchar2(10),            /*分配原因                               */
hraa14      varchar2(10),            /*所有者                                 */
hraa15      varchar2(1),             /*组织架构类型                           */
hraa16      varchar2(1),             /*是否是虚拟公司                         */
hraa17      varchar2(100),           /*撤销原因                               */
hraa18      varchar2(10),            /*国家或地区代码                         */
hraa19      number(15,2),            /*雇主提缴比例                           */
hraa20      varchar2(20),            /*统一编号                               */
hraa21      varchar2(20),            /*劳工保险证号                           */
hraa22      varchar2(20),            /*房屋税藉编号                           */
hraa23      varchar2(20),            /*劳工保险业别代号                       */
hraa24      varchar2(20),            /*营利事业税藉编号                       */
hraa25      varchar2(20),            /*健保投保单位代号                       */
hraa26      varchar2(20),            /*保险证号检查码                         */
hraa27      varchar2(20),            /*负责人                                 */
hraa28      varchar2(10),            /*显示层级                               */
hraa29      varchar2(10),            /*公司低阶吗                             */
hraa30      varchar2(10),            /*公司阶层吗                             */
hraa31      varchar2(20),            /*公司负责人                             */
hraa32      varchar2(20),            /*公司负责人职位                         */
hraa33      varchar2(20),            /*ERP数据库代码                          */
hraaud01    varchar2(255),           /*是否有效                               */
hraaud02    varchar2(40),            /*自定栏位-文字                          */
hraaud03    varchar2(40),            /*自定栏位-文字                          */
hraaud04    varchar2(40),            /*自定栏位-文字                          */
hraaud05    varchar2(40),            /*自定栏位-文字                          */
hraaud06    varchar2(40),            /*自定栏位-文字                          */
hraaud07    number(15,3),            /*自定栏位-数值                          */
hraaud08    number(15,3),            /*自定栏位-数值                          */
hraaud09    number(15,3),            /*自定栏位-数值                          */
hraaud10    number(10),              /*自定栏位-整数                          */
hraaud11    number(10),              /*自定栏位-整数                          */
hraaud12    number(10),              /*自定栏位-整数                          */
hraaud13    date,                    /*自定栏位-日期                          */
hraaud14    date,                    /*自定栏位-日期                          */
hraaud15    date,                    /*自定栏位-日期                          */
hraaacti    varchar2(1),             /*是否有效                               */
hraauser    varchar2(10),            /*资料所有者                             */
hraagrup    varchar2(10),            /*资料所有群                             */
hraamodu    varchar2(10),            /*资料更改者                             */
hraadate    date,                    /*最近修改日                             */
hraaorig    varchar2(10),            /*资料简历部门                           */
hraaoriu    varchar2(10)             /*资料建立者                             */
);

alter table hraa_file add  constraint tpc_hraa_pk primary key  (hraa01) enable validate;
grant select on hraa_file to tiptopgp;
grant update on hraa_file to tiptopgp;
grant delete on hraa_file to tiptopgp;
grant insert on hraa_file to tiptopgp;
grant index on hraa_file to public;
grant select on hraa_file to ods;
