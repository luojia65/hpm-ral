#![no_std]
#![no_main]

extern crate hpm_bootheader;
extern crate panic_halt;

use hpm_ral as ral;
use riscv_rt::entry;

use hpm6750evkmini as bsp;

use bsp::gpio::Gpio;

#[entry]
fn main() -> ! {
    let sysctl = unsafe { ral::sysctl::SYSCTL::instance() };
    let gpio = unsafe { Gpio::new(ral::gpio::GPIO0::instance(), ral::ioc::IOC0::instance()) };

    bsp::board_init(&sysctl);
    let led_pin = gpio.pd15.into_push_pull_output();

    loop {
        led_pin.toggle();
        for _ in 0..50000 {}
    }
}
