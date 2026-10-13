/*
================================================================================
檔案代號:hrbg_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbg_file
(
hrbg01      number(5) NOT NULL,      /*项次                                   */
hrbg02      varchar2(50) NOT NULL,   /*人员ID                                 */
hrbg03      number(4),               /*年度                                   */
hrbg04      date,                    /*受伤日期                               */
hrbg05      date,                    /*医疗终结日期                           */
hrbg06      varchar2(10),            /*伤残鉴定等级                           */
hrbg07      number(15,2),            /*补偿金额                               */
hrbg08      varchar2(20),            /*生活自理障碍等级                       */
hrbg09      varchar2(50),            /*鉴定部位                               */
hrbg10      varchar2(50),            /*安装康复器具                           */
hrbg11      number(15,2),            /*伤残就业补助金                         */
hrbg12      varchar2(255),           /*工伤原因                               */
hrbg13      varchar2(255),           /*善后处理                               */
hrbg14      varchar2(255),           /*备注                                   */
hrbguser    varchar2(10),            /*资料所有者                             */
hrbggrup    varchar2(10),            /*资料所有群                             */
hrbgmodu    varchar2(10),            /*资料更改者                             */
hrbgdate    date,                    /*最近修改日                             */
hrbgorig    varchar2(10),            /*资料建立部门                           */
hrbgoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrbg_file add  constraint tpc_hrbg_pk primary key  (hrbg01) enable validate;
grant select on hrbg_file to tiptopgp;
grant update on hrbg_file to tiptopgp;
grant delete on hrbg_file to tiptopgp;
grant insert on hrbg_file to tiptopgp;
grant index on hrbg_file to public;
grant select on hrbg_file to ods;
