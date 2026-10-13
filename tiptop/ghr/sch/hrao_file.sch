/*
================================================================================
檔案代號:hrao_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrao_file
(
hrao00      varchar2(10) NOT NULL,   /*所属公司编号                           */
hrao01      varchar2(20) NOT NULL,   /*部门编号                               */
                                     /*                                       */
hrao02      varchar2(40) NOT NULL,   /*部门名称                               */
hrao03      varchar2(40),            /*部门简称                               */
hrao04      date,                    /*成立日期                               */
hrao05      varchar2(1),             /*直属部门否                             */
hrao06      varchar2(20),            /*上级部门                               */
hrao07      varchar2(1),             /*是助手级否                             */
hrao08      varchar2(1),             /*在组织架构图                           */
hrao09      varchar2(20),            /*部门阶层序号                           */
hrao10      varchar2(20),            /*一级部门                               */
hrao11      varchar2(20),            /*ERP营运中心                            */
hrao12      varchar2(20),            /*ERP部门编号                            */
hrao13      varchar2(255),           /*部门简介                               */
hraoud01    varchar2(255),           /*自定义                                 */
hraoud02    varchar2(40),            /*自定义文字                             */
hraoud03    varchar2(40),            /*自定义文字                             */
hraoud04    varchar2(40),            /*自定义文字                             */
hraoud05    varchar2(40),            /*自定义文字                             */
hraoud06    varchar2(40),            /*自定义文字                             */
hraoud07    number(15,3),            /*自定义数值                             */
hraoud08    number(15,3),            /*自定义数值                             */
hraoud09    number(15,3),            /*自定义数值                             */
hraoud10    number(10),              /*自定义整数                             */
hraoud11    number(10),              /*自定义整数                             */
hraoud12    number(10),              /*自定义整数                             */
hraoud13    date,                    /*自定义日期                             */
hraoud14    date,                    /*自定义日期                             */
hraoud15    date,                    /*自定义日期                             */
hraoacti    varchar2(1),             /*资料有效码                             */
hraouser    varchar2(10),            /*资料所有者                             */
hraogrup    varchar2(10),            /*资料所有群                             */
hraomodu    varchar2(10),            /*资料更改者                             */
hraodate    date,                    /*最近修改日                             */
hraooriu    varchar2(10),            /*资料建立者                             */
hraoorig    varchar2(10)             /*资料建立部门                           */
);

alter table hrao_file add  constraint tpc_hrao_pk primary key  (hrao01) enable validate;
grant select on hrao_file to tiptopgp;
grant update on hrao_file to tiptopgp;
grant delete on hrao_file to tiptopgp;
grant insert on hrao_file to tiptopgp;
grant index on hrao_file to public;
grant select on hrao_file to ods;
