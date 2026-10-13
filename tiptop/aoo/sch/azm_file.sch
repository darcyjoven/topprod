/*
================================================================================
檔案代號:azm_file
檔案名稱:会计期间参数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table azm_file
(
azm01       number(5) NOT NULL,      /*年度                                   */
azm02       varchar2(1),             /*会计期间分类方式                       */
                                     /*會計期間分類方式                       */
azm011      date,                    /*第 1期起始日期                         */
azm012      date,                    /*第 1期截止日期                         */
azm013      number(5),               /*季别                                   */
                                     /*季別                                   */
azm021      date,                    /*第 2期起始日期                         */
azm022      date,                    /*第 2期截止日期                         */
azm023      number(5),               /*季别                                   */
                                     /*季別                                   */
azm031      date,                    /*第 3期起始日期                         */
azm032      date,                    /*第 3期截止日期                         */
azm033      number(5),               /*季别                                   */
                                     /*季別                                   */
azm041      date,                    /*第 4期起始日期                         */
azm042      date,                    /*第 4期截止日期                         */
azm043      number(5),               /*季别                                   */
                                     /*季別                                   */
azm051      date,                    /*第 5期起始日期                         */
azm052      date,                    /*第 5期截止日期                         */
azm053      number(5),               /*季别                                   */
                                     /*季別                                   */
azm061      date,                    /*第 6期起始日期                         */
azm062      date,                    /*第 6期截止日期                         */
azm063      number(5),               /*季别                                   */
                                     /*季別                                   */
azm071      date,                    /*第 7期起始日期                         */
azm072      date,                    /*第 7期截止日期                         */
azm073      number(5),               /*季别                                   */
                                     /*季別                                   */
azm081      date,                    /*第 8期起始日期                         */
azm082      date,                    /*第 8期截止日期                         */
azm083      number(5),               /*季别                                   */
                                     /*季別                                   */
azm091      date,                    /*第 9期起始日期                         */
azm092      date,                    /*第 9期截止日期                         */
azm093      number(5),               /*季别                                   */
                                     /*季別                                   */
azm101      date,                    /*第10期起始日期                         */
azm102      date,                    /*第10期截止日期                         */
azm103      number(5),               /*季别                                   */
                                     /*季別                                   */
azm111      date,                    /*第11期起始日期                         */
azm112      date,                    /*第11期截止日期                         */
azm113      number(5),               /*季别                                   */
                                     /*季別                                   */
azm121      date,                    /*第12期起始日期                         */
azm122      date,                    /*第12期截止日期                         */
azm123      number(5),               /*季别                                   */
                                     /*季別                                   */
azm131      date,                    /*第13期起始日期                         */
azm132      date,                    /*第13期截止日期                         */
azm133      number(5),               /*季别                                   */
                                     /*季別                                   */
azmud01     varchar2(255),           /*自订字段                               */
azmud02     varchar2(40),            /*自订字段                               */
azmud03     varchar2(40),            /*自订字段                               */
azmud04     varchar2(40),            /*自订字段                               */
azmud05     varchar2(40),            /*自订字段                               */
azmud06     varchar2(255),           /*自订字段                               */
azmud07     number(15,3),            /*自订字段                               */
azmud08     number(15,3),            /*自订字段                               */
azmud09     number(15,3),            /*自订字段                               */
azmud10     number(10),              /*自订字段                               */
azmud11     number(10),              /*自订字段                               */
azmud12     number(10),              /*自订字段                               */
azmud13     date,                    /*自订字段                               */
azmud14     date,                    /*自订字段                               */
azmud15     date                     /*自订字段                               */
);

alter table azm_file add  constraint azm_pk primary key  (azm01) enable validate;
grant select on azm_file to tiptopgp;
grant update on azm_file to tiptopgp;
grant delete on azm_file to tiptopgp;
grant insert on azm_file to tiptopgp;
grant index on azm_file to public;
grant select on azm_file to ods;
