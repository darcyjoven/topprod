/*
================================================================================
檔案代號:azmm_file
檔案名稱:账套会计期间参数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table azmm_file
(
azmm00      varchar2(5) NOT NULL,    /*帐套                                   */
azmm01      number(5) NOT NULL,      /*年度                                   */
azmm02      varchar2(1),             /*会计期间分类方式                       */
                                     /*1-12,2-13                              */
azmm011     date,                    /*第 1期起始日期                         */
azmm012     date,                    /*第 1期截止日期                         */
azmm013     number(5),               /*季别                                   */
azmm021     date,                    /*第 2期起始日期                         */
azmm022     date,                    /*第 2期截止日期                         */
azmm023     number(5),               /*季别                                   */
azmm031     date,                    /*第 3期起始日期                         */
azmm032     date,                    /*第 3期截止日期                         */
azmm033     number(5),               /*季别                                   */
azmm041     date,                    /*第 4期起始日期                         */
azmm042     date,                    /*第 4期截止日期                         */
azmm043     number(5),               /*季别                                   */
azmm051     date,                    /*第 5期起始日期                         */
azmm052     date,                    /*第 5期截止日期                         */
azmm053     number(5),               /*季别                                   */
azmm061     date,                    /*第 6期起始日期                         */
azmm062     date,                    /*第 6期截止日期                         */
azmm063     number(5),               /*季别                                   */
azmm071     date,                    /*第 7期起始日期                         */
azmm072     date,                    /*第 7期截止日期                         */
azmm073     number(5),               /*季别                                   */
azmm081     date,                    /*第 8期起始日期                         */
azmm082     date,                    /*第 8期截止日期                         */
azmm083     number(5),               /*季别                                   */
azmm091     date,                    /*第 9期起始日期                         */
azmm092     date,                    /*第 9期截止日期                         */
azmm093     number(5),               /*季别                                   */
azmm101     date,                    /*第10期起始日期                         */
azmm102     date,                    /*第10期截止日期                         */
azmm103     number(5),               /*季别                                   */
azmm111     date,                    /*第11期起始日期                         */
azmm112     date,                    /*第11期截止日期                         */
azmm113     number(5),               /*季别                                   */
azmm121     date,                    /*第12期起始日期                         */
azmm122     date,                    /*第12期截止日期                         */
azmm123     number(5),               /*季别                                   */
azmm131     date,                    /*第13期起始日期                         */
azmm132     date,                    /*第13期截止日期                         */
azmm133     number(5)                /*季别                                   */
);

alter table azmm_file add  constraint azmm_pk primary key  (azmm00,azmm01) enable validate;
grant select on azmm_file to tiptopgp;
grant update on azmm_file to tiptopgp;
grant delete on azmm_file to tiptopgp;
grant insert on azmm_file to tiptopgp;
grant index on azmm_file to public;
grant select on azmm_file to ods;
