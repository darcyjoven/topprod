/*
================================================================================
檔案代號:azwa_file
檔案名稱:登入人员可取得资料的工厂清单记录表
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azwa_file
(
azwa01      varchar2(10) NOT NULL,   /*人员编号                               */
azwa02      varchar2(10) NOT NULL,   /*所属工厂                               */
azwa03      varchar2(10) NOT NULL    /*有权限的工厂                           */
);

create unique index azwa_01 on azwa_file (azwa01,azwa02,azwa03);
grant select on azwa_file to tiptopgp;
grant update on azwa_file to tiptopgp;
grant delete on azwa_file to tiptopgp;
grant insert on azwa_file to tiptopgp;
grant index on azwa_file to public;
grant select on azwa_file to ods;
